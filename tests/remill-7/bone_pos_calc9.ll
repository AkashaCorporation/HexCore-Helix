; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x14142fe90
; Size: 2250 bytes
; Architecture: amd64
; Generated: 2026-03-08T21:25:29.352Z
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
bb_0:
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
  store i64 5389876880, ptr %NEXT_PC, align 8
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !38
  %CSBASE = alloca i64, align 8
  store i64 0, ptr %CSBASE, align 8
  %SSBASE = alloca i64, align 8
  store i64 0, ptr %SSBASE, align 8
  %ESBASE = alloca i64, align 8
  store i64 0, ptr %ESBASE, align 8
  %DSBASE = alloca i64, align 8
  store i64 0, ptr %DSBASE, align 8
  store i64 5389876880, ptr %PC, align 8
  store i64 5389876885, ptr %NEXT_PC, align 8
  %v1 = load i64, ptr %RSP, align 8
  %v2 = add i64 %v1, 16
  %v3 = load i64, ptr %RSI, align 8
  %v4 = load ptr, ptr %MEMORY, align 8
  %v5 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4, ptr %state, i64 %v2, i64 %v3)
  store ptr %v5, ptr %MEMORY, align 8
  store i64 5389876885, ptr %PC, align 8
  store i64 5389876890, ptr %NEXT_PC, align 8
  %v6 = load i64, ptr %RSP, align 8
  %v7 = add i64 %v6, 32
  %v8 = load i64, ptr %RDI, align 8
  %v9 = load ptr, ptr %MEMORY, align 8
  %v10 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9, ptr %state, i64 %v7, i64 %v8)
  store ptr %v10, ptr %MEMORY, align 8
  store i64 5389876890, ptr %PC, align 8
  store i64 5389876895, ptr %NEXT_PC, align 8
  %v11 = load i64, ptr %RSP, align 8
  %v12 = add i64 %v11, 24
  %v13 = load i32, ptr %R8D, align 4
  %v14 = zext i32 %v13 to i64
  %v15 = load ptr, ptr %MEMORY, align 8
  %v16 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v15, ptr %state, i64 %v12, i64 %v14)
  store ptr %v16, ptr %MEMORY, align 8
  store i64 5389876895, ptr %PC, align 8
  store i64 5389876896, ptr %NEXT_PC, align 8
  %v17 = load i64, ptr %RBP, align 8
  %v18 = load ptr, ptr %MEMORY, align 8
  %v19 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v18, ptr %state, i64 %v17)
  store ptr %v19, ptr %MEMORY, align 8
  store i64 5389876896, ptr %PC, align 8
  store i64 5389876898, ptr %NEXT_PC, align 8
  %v20 = load i64, ptr %R12, align 8
  %v21 = load ptr, ptr %MEMORY, align 8
  %v22 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v21, ptr %state, i64 %v20)
  store ptr %v22, ptr %MEMORY, align 8
  store i64 5389876898, ptr %PC, align 8
  store i64 5389876900, ptr %NEXT_PC, align 8
  %v23 = load i64, ptr %R13, align 8
  %v24 = load ptr, ptr %MEMORY, align 8
  %v25 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v24, ptr %state, i64 %v23)
  store ptr %v25, ptr %MEMORY, align 8
  store i64 5389876900, ptr %PC, align 8
  store i64 5389876902, ptr %NEXT_PC, align 8
  %v26 = load i64, ptr %R14, align 8
  %v27 = load ptr, ptr %MEMORY, align 8
  %v28 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v27, ptr %state, i64 %v26)
  store ptr %v28, ptr %MEMORY, align 8
  store i64 5389876902, ptr %PC, align 8
  store i64 5389876904, ptr %NEXT_PC, align 8
  %v29 = load i64, ptr %R15, align 8
  %v30 = load ptr, ptr %MEMORY, align 8
  %v31 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v30, ptr %state, i64 %v29)
  store ptr %v31, ptr %MEMORY, align 8
  store i64 5389876904, ptr %PC, align 8
  store i64 5389876907, ptr %NEXT_PC, align 8
  %v32 = load i64, ptr %RSP, align 8
  %v33 = load ptr, ptr %MEMORY, align 8
  %v34 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v33, ptr %state, ptr %RBP, i64 %v32)
  store ptr %v34, ptr %MEMORY, align 8
  store i64 5389876907, ptr %PC, align 8
  store i64 5389876911, ptr %NEXT_PC, align 8
  %v35 = load i64, ptr %RSP, align 8
  %v36 = load ptr, ptr %MEMORY, align 8
  %v37 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v36, ptr %state, ptr %RSP, i64 %v35, i64 96)
  store ptr %v37, ptr %MEMORY, align 8
  store i64 5389876911, ptr %PC, align 8
  store i64 5389876915, ptr %NEXT_PC, align 8
  %v38 = load i64, ptr %RBP, align 8
  %v39 = add i64 %v38, 80
  %v40 = load ptr, ptr %MEMORY, align 8
  %v41 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v40, ptr %state, ptr %RSI, i64 %v39)
  store ptr %v41, ptr %MEMORY, align 8
  store i64 5389876915, ptr %PC, align 8
  store i64 5389876917, ptr %NEXT_PC, align 8
  %v42 = load i64, ptr %RDI, align 8
  %v43 = load i32, ptr %EDI, align 4
  %v44 = zext i32 %v43 to i64
  %v45 = load ptr, ptr %MEMORY, align 8
  %v46 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v45, ptr %state, ptr %RDI, i64 %v42, i64 %v44)
  store ptr %v46, ptr %MEMORY, align 8
  store i64 5389876917, ptr %PC, align 8
  store i64 5389876920, ptr %NEXT_PC, align 8
  %v47 = load i32, ptr %R9D, align 4
  %v48 = zext i32 %v47 to i64
  %v49 = load ptr, ptr %MEMORY, align 8
  %v50 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v49, ptr %state, ptr %R13, i64 %v48)
  store ptr %v50, ptr %MEMORY, align 8
  store i64 5389876920, ptr %PC, align 8
  store i64 5389876923, ptr %NEXT_PC, align 8
  %v51 = load i32, ptr %R8D, align 4
  %v52 = zext i32 %v51 to i64
  %v53 = load ptr, ptr %MEMORY, align 8
  %v54 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v53, ptr %state, ptr %R12, i64 %v52)
  store ptr %v54, ptr %MEMORY, align 8
  store i64 5389876923, ptr %PC, align 8
  store i64 5389876926, ptr %NEXT_PC, align 8
  %v55 = load i64, ptr %RDX, align 8
  %v56 = load ptr, ptr %MEMORY, align 8
  %v57 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v56, ptr %state, ptr %R15, i64 %v55)
  store ptr %v57, ptr %MEMORY, align 8
  store i64 5389876926, ptr %PC, align 8
  store i64 5389876929, ptr %NEXT_PC, align 8
  %v58 = load i64, ptr %RCX, align 8
  %v59 = load ptr, ptr %MEMORY, align 8
  %v60 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v59, ptr %state, ptr %R14, i64 %v58)
  store ptr %v60, ptr %MEMORY, align 8
  store i64 5389876929, ptr %PC, align 8
  store i64 5389876935, ptr %NEXT_PC, align 8
  %v61 = load i64, ptr %RSI, align 8
  %v62 = add i64 %v61, 256
  %v63 = load ptr, ptr %MEMORY, align 8
  %v64 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v63, ptr %state, ptr %RAX, i64 %v62)
  store ptr %v64, ptr %MEMORY, align 8
  store i64 5389876935, ptr %PC, align 8
  store i64 5389876937, ptr %NEXT_PC, align 8
  %v65 = load i32, ptr %EAX, align 4
  %v66 = zext i32 %v65 to i64
  %v67 = load i32, ptr %EAX, align 4
  %v68 = zext i32 %v67 to i64
  %v69 = load ptr, ptr %MEMORY, align 8
  %v70 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v69, ptr %state, i64 %v66, i64 %v68)
  store ptr %v70, ptr %MEMORY, align 8
  store i64 5389876937, ptr %PC, align 8
  store i64 5389876939, ptr %NEXT_PC, align 8
  %v71 = load ptr, ptr %MEMORY, align 8
  %v72 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v71, ptr %state, ptr %BRANCH_TAKEN, i64 5389876953, i64 5389876939, ptr %NEXT_PC)
  store ptr %v72, ptr %MEMORY, align 8
  br i1 true, label %bb_5389876953, label %bb_5389876939

bb_5389876939:                                    ; preds = %bb_0
  store i64 5389876939, ptr %PC, align 8
  store i64 5389876941, ptr %NEXT_PC, align 8
  %v73 = load i64, ptr %RSI, align 8
  %v74 = load i32, ptr %EDI, align 4
  %v75 = zext i32 %v74 to i64
  %v76 = load ptr, ptr %MEMORY, align 8
  %v77 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v76, ptr %state, i64 %v73, i64 %v75)
  store ptr %v77, ptr %MEMORY, align 8
  store i64 5389876941, ptr %PC, align 8
  store i64 5389876947, ptr %NEXT_PC, align 8
  %v78 = load i64, ptr %RSI, align 8
  %v79 = add i64 %v78, 256
  %v80 = load i64, ptr %RSI, align 8
  %v81 = add i64 %v80, 256
  %v82 = load ptr, ptr %MEMORY, align 8
  %v83 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v82, ptr %state, i64 %v79, i64 %v81)
  store ptr %v83, ptr %MEMORY, align 8
  store i64 5389876947, ptr %PC, align 8
  store i64 5389876953, ptr %NEXT_PC, align 8
  %v84 = load i64, ptr %RSI, align 8
  %v85 = add i64 %v84, 256
  %v86 = load ptr, ptr %MEMORY, align 8
  %v87 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v86, ptr %state, ptr %RAX, i64 %v85)
  store ptr %v87, ptr %MEMORY, align 8
  br label %bb_5389876953

bb_5389876953:                                    ; preds = %bb_5389876939, %bb_0
  %v88 = load i64, ptr %NEXT_PC, align 8
  store i64 %v88, ptr %PC, align 8
  %v89 = add i64 %v88, 3
  store i64 %v89, ptr %NEXT_PC, align 8
  %v90 = load i32, ptr %EAX, align 4
  %v91 = zext i32 %v90 to i64
  %v92 = load ptr, ptr %MEMORY, align 8
  %v93 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v92, ptr %state, i64 %v91, i64 1)
  store ptr %v93, ptr %MEMORY, align 8
  store i64 %v89, ptr %PC, align 8
  %v94 = add i64 %v89, 2
  store i64 %v94, ptr %NEXT_PC, align 8
  %v95 = add i64 %v94, 76
  %v96 = load ptr, ptr %MEMORY, align 8
  %v97 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v96, ptr %state, ptr %BRANCH_TAKEN, i64 %v95, i64 %v94, ptr %NEXT_PC)
  store ptr %v97, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877034, label %bb_5389876958

bb_5389876958:                                    ; preds = %bb_5389876953
  store i64 %v94, ptr %PC, align 8
  %v98 = add i64 %v94, 4
  store i64 %v98, ptr %NEXT_PC, align 8
  %v99 = load i64, ptr %RBP, align 8
  %v100 = sub i64 %v99, 40
  %v101 = load ptr, ptr %MEMORY, align 8
  %v102 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v101, ptr %state, ptr %RCX, i64 %v100)
  store ptr %v102, ptr %MEMORY, align 8
  store i64 %v98, ptr %PC, align 8
  %v103 = add i64 %v98, 4
  store i64 %v103, ptr %NEXT_PC, align 8
  %v104 = load i64, ptr %RBP, align 8
  %v105 = sub i64 %v104, 8
  %v106 = load i64, ptr %RDI, align 8
  %v107 = load ptr, ptr %MEMORY, align 8
  %v108 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v107, ptr %state, i64 %v105, i64 %v106)
  store ptr %v108, ptr %MEMORY, align 8
  store i64 %v103, ptr %PC, align 8
  %v109 = add i64 %v103, 5
  store i64 %v109, ptr %NEXT_PC, align 8
  %v110 = sub i64 %v109, 18801275
  %v111 = load ptr, ptr %MEMORY, align 8
  %v112 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v111, ptr %state, i64 5371075696, ptr %NEXT_PC, i64 %v109, ptr %RETURN_PC)
  store ptr %v112, ptr %MEMORY, align 8
  store i64 %v109, ptr %PC, align 8
  %v113 = add i64 %v109, 2
  store i64 %v113, ptr %NEXT_PC, align 8
  %v114 = load i64, ptr %RSI, align 8
  %v115 = load ptr, ptr %MEMORY, align 8
  %v116 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v115, ptr %state, ptr %RDX, i64 %v114)
  store ptr %v116, ptr %MEMORY, align 8
  store i64 %v113, ptr %PC, align 8
  %v117 = add i64 %v113, 4
  store i64 %v117, ptr %NEXT_PC, align 8
  %v118 = load i64, ptr %RBP, align 8
  %v119 = sub i64 %v118, 40
  %v120 = load ptr, ptr %MEMORY, align 8
  %v121 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v120, ptr %state, ptr %R8, i64 %v119)
  store ptr %v121, ptr %MEMORY, align 8
  store i64 %v117, ptr %PC, align 8
  %v122 = add i64 %v117, 3
  store i64 %v122, ptr %NEXT_PC, align 8
  %v123 = load i32, ptr %R12D, align 4
  %v124 = zext i32 %v123 to i64
  %v125 = load ptr, ptr %MEMORY, align 8
  %v126 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v125, ptr %state, ptr %R9, i64 %v124)
  store ptr %v126, ptr %MEMORY, align 8
  store i64 %v122, ptr %PC, align 8
  %v127 = add i64 %v122, 8
  store i64 %v127, ptr %NEXT_PC, align 8
  %v128 = load i64, ptr %RSP, align 8
  %v129 = add i64 %v128, 40
  %v130 = load ptr, ptr %MEMORY, align 8
  %v131 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v130, ptr %state, i64 %v129, i64 -1)
  store ptr %v131, ptr %MEMORY, align 8
  store i64 %v127, ptr %PC, align 8
  %v132 = add i64 %v127, 3
  store i64 %v132, ptr %NEXT_PC, align 8
  %v133 = load i64, ptr %R14, align 8
  %v134 = load ptr, ptr %MEMORY, align 8
  %v135 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v134, ptr %state, ptr %RCX, i64 %v133)
  store ptr %v135, ptr %MEMORY, align 8
  store i64 %v132, ptr %PC, align 8
  %v136 = add i64 %v132, 5
  store i64 %v136, ptr %NEXT_PC, align 8
  %v137 = load i64, ptr %RSP, align 8
  %v138 = add i64 %v137, 32
  %v139 = load i32, ptr %R13D, align 4
  %v140 = zext i32 %v139 to i64
  %v141 = load ptr, ptr %MEMORY, align 8
  %v142 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v141, ptr %state, i64 %v138, i64 %v140)
  store ptr %v142, ptr %MEMORY, align 8
  store i64 %v136, ptr %PC, align 8
  %v143 = add i64 %v136, 5
  store i64 %v143, ptr %NEXT_PC, align 8
  %v144 = add i64 %v143, 4935
  %v145 = load ptr, ptr %MEMORY, align 8
  %v146 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v145, ptr %state, i64 5389881936, ptr %NEXT_PC, i64 %v143, ptr %RETURN_PC)
  store ptr %v146, ptr %MEMORY, align 8
  store i64 %v143, ptr %PC, align 8
  %v147 = add i64 %v143, 4
  store i64 %v147, ptr %NEXT_PC, align 8
  %v148 = load i64, ptr %R15, align 8
  %v149 = add i64 %v148, 32
  %v150 = load ptr, ptr %MEMORY, align 8
  %v151 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v150, ptr %state, ptr %RCX, i64 %v149)
  store ptr %v151, ptr %MEMORY, align 8
  store i64 %v147, ptr %PC, align 8
  %v152 = add i64 %v147, 3
  store i64 %v152, ptr %NEXT_PC, align 8
  %v153 = load i32, ptr %EAX, align 4
  %v154 = zext i32 %v153 to i64
  %v155 = load ptr, ptr %MEMORY, align 8
  %v156 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v155, ptr %state, i64 %v154, i64 -1)
  store ptr %v156, ptr %MEMORY, align 8
  store i64 %v152, ptr %PC, align 8
  %v157 = add i64 %v152, 4
  store i64 %v157, ptr %NEXT_PC, align 8
  %v158 = load ptr, ptr %MEMORY, align 8
  %v159 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v158, ptr %state, ptr %DIL)
  store ptr %v159, ptr %MEMORY, align 8
  store i64 %v157, ptr %PC, align 8
  %v160 = add i64 %v157, 3
  store i64 %v160, ptr %NEXT_PC, align 8
  %v161 = load i64, ptr %RCX, align 8
  %v162 = load i64, ptr %RCX, align 8
  %v163 = load ptr, ptr %MEMORY, align 8
  %v164 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v163, ptr %state, i64 %v161, i64 %v162)
  store ptr %v164, ptr %MEMORY, align 8
  store i64 %v160, ptr %PC, align 8
  %v165 = add i64 %v160, 2
  store i64 %v165, ptr %NEXT_PC, align 8
  %v166 = add i64 %v165, 10
  %v167 = load ptr, ptr %MEMORY, align 8
  %v168 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v167, ptr %state, ptr %BRANCH_TAKEN, i64 %v166, i64 %v165, ptr %NEXT_PC)
  store ptr %v168, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877027, label %bb_5389877017

bb_5389877017:                                    ; preds = %bb_5389876958
  store i64 %v165, ptr %PC, align 8
  %v169 = add i64 %v165, 3
  store i64 %v169, ptr %NEXT_PC, align 8
  %v170 = load i64, ptr %RCX, align 8
  %v171 = load ptr, ptr %MEMORY, align 8
  %v172 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v171, ptr %state, ptr %R8, i64 %v170)
  store ptr %v172, ptr %MEMORY, align 8
  store i64 %v169, ptr %PC, align 8
  %v173 = add i64 %v169, 3
  store i64 %v173, ptr %NEXT_PC, align 8
  %v174 = load i64, ptr %R15, align 8
  %v175 = load ptr, ptr %MEMORY, align 8
  %v176 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v175, ptr %state, ptr %RDX, i64 %v174)
  store ptr %v176, ptr %MEMORY, align 8
  store i64 %v173, ptr %PC, align 8
  %v177 = add i64 %v173, 4
  store i64 %v177, ptr %NEXT_PC, align 8
  %v178 = load i64, ptr %R8, align 8
  %v179 = add i64 %v178, 24
  %v180 = load ptr, ptr %MEMORY, align 8
  %v181 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v180, ptr %state, i64 %v179, ptr %NEXT_PC, i64 %v177, ptr %RETURN_PC)
  store ptr %v181, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877027:                                    ; preds = %bb_5389876958
  store i64 %v165, ptr %PC, align 8
  %v182 = add i64 %v165, 2
  store i64 %v182, ptr %NEXT_PC, align 8
  %v183 = load i32, ptr %EDI, align 4
  %v184 = zext i32 %v183 to i64
  %v185 = load ptr, ptr %MEMORY, align 8
  %v186 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v185, ptr %state, ptr %RAX, i64 %v184)
  store ptr %v186, ptr %MEMORY, align 8
  store i64 %v182, ptr %PC, align 8
  %v187 = add i64 %v182, 5
  store i64 %v187, ptr %NEXT_PC, align 8
  %v188 = add i64 %v187, 576
  %v189 = load ptr, ptr %MEMORY, align 8
  %v190 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v189, ptr %state, i64 %v188, ptr %NEXT_PC)
  store ptr %v190, ptr %MEMORY, align 8
  br label %bb_5389877610

bb_5389877034:                                    ; preds = %bb_5389876953
  store i64 %v94, ptr %PC, align 8
  %v191 = add i64 %v94, 2
  store i64 %v191, ptr %NEXT_PC, align 8
  %v192 = load i64, ptr %RAX, align 8
  %v193 = load ptr, ptr %MEMORY, align 8
  %v194 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v193, ptr %state, ptr %RAX, i64 %v192)
  store ptr %v194, ptr %MEMORY, align 8
  store i64 %v191, ptr %PC, align 8
  %v195 = add i64 %v191, 8
  store i64 %v195, ptr %NEXT_PC, align 8
  %v196 = load i64, ptr %RSP, align 8
  %v197 = add i64 %v196, 144
  %v198 = load i64, ptr %RBX, align 8
  %v199 = load ptr, ptr %MEMORY, align 8
  %v200 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v199, ptr %state, i64 %v197, i64 %v198)
  store ptr %v200, ptr %MEMORY, align 8
  store i64 %v195, ptr %PC, align 8
  %v201 = add i64 %v195, 3
  store i64 %v201, ptr %NEXT_PC, align 8
  %v202 = load i32, ptr %EAX, align 4
  %v203 = zext i32 %v202 to i64
  %v204 = load ptr, ptr %MEMORY, align 8
  %v205 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v204, ptr %state, ptr %RCX, i64 %v203)
  store ptr %v205, ptr %MEMORY, align 8
  store i64 %v201, ptr %PC, align 8
  %v206 = add i64 %v201, 3
  store i64 %v206, ptr %NEXT_PC, align 8
  %v207 = load i64, ptr %RSI, align 8
  %v208 = load i64, ptr %RCX, align 8
  %v209 = mul i64 %v208, 4
  %v210 = add i64 %v207, %v209
  %v211 = load ptr, ptr %MEMORY, align 8
  %v212 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v211, ptr %state, ptr %RDX, i64 %v210)
  store ptr %v212, ptr %MEMORY, align 8
  store i64 %v206, ptr %PC, align 8
  %v213 = add i64 %v206, 3
  store i64 %v213, ptr %NEXT_PC, align 8
  %v214 = load i64, ptr %R14, align 8
  %v215 = load ptr, ptr %MEMORY, align 8
  %v216 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v215, ptr %state, ptr %RCX, i64 %v214)
  store ptr %v216, ptr %MEMORY, align 8
  store i64 %v213, ptr %PC, align 8
  %v217 = add i64 %v213, 5
  store i64 %v217, ptr %NEXT_PC, align 8
  %v218 = add i64 %v217, 6478
  %v219 = load ptr, ptr %MEMORY, align 8
  %v220 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v219, ptr %state, i64 5389883536, ptr %NEXT_PC, i64 %v217, ptr %RETURN_PC)
  store ptr %v220, ptr %MEMORY, align 8
  store i64 %v217, ptr %PC, align 8
  %v221 = add i64 %v217, 3
  store i64 %v221, ptr %NEXT_PC, align 8
  %v222 = load i32, ptr %EAX, align 4
  %v223 = zext i32 %v222 to i64
  %v224 = load ptr, ptr %MEMORY, align 8
  %v225 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v224, ptr %state, ptr %RBX, i64 %v223)
  store ptr %v225, ptr %MEMORY, align 8
  store i64 %v221, ptr %PC, align 8
  %v226 = add i64 %v221, 3
  store i64 %v226, ptr %NEXT_PC, align 8
  %v227 = load i32, ptr %EBX, align 4
  %v228 = zext i32 %v227 to i64
  %v229 = load ptr, ptr %MEMORY, align 8
  %v230 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v229, ptr %state, i64 %v228, i64 -1)
  store ptr %v230, ptr %MEMORY, align 8
  store i64 %v226, ptr %PC, align 8
  %v231 = add i64 %v226, 2
  store i64 %v231, ptr %NEXT_PC, align 8
  %v232 = add i64 %v231, 121
  %v233 = load ptr, ptr %MEMORY, align 8
  %v234 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v233, ptr %state, ptr %BRANCH_TAKEN, i64 %v232, i64 %v231, ptr %NEXT_PC)
  store ptr %v234, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877187, label %bb_5389877066

bb_5389877066:                                    ; preds = %bb_5389877034
  store i64 %v231, ptr %PC, align 8
  %v235 = add i64 %v231, 2
  store i64 %v235, ptr %NEXT_PC, align 8
  %v236 = load i32, ptr %EAX, align 4
  %v237 = zext i32 %v236 to i64
  %v238 = load i32, ptr %EAX, align 4
  %v239 = zext i32 %v238 to i64
  %v240 = load ptr, ptr %MEMORY, align 8
  %v241 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v240, ptr %state, i64 %v237, i64 %v239)
  store ptr %v241, ptr %MEMORY, align 8
  store i64 %v235, ptr %PC, align 8
  %v242 = add i64 %v235, 2
  store i64 %v242, ptr %NEXT_PC, align 8
  %v243 = add i64 %v242, 60
  %v244 = load ptr, ptr %MEMORY, align 8
  %v245 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v244, ptr %state, ptr %BRANCH_TAKEN, i64 %v243, i64 %v242, ptr %NEXT_PC)
  store ptr %v245, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877130, label %bb_5389877070

bb_5389877070:                                    ; preds = %bb_5389877066
  store i64 %v242, ptr %PC, align 8
  %v246 = add i64 %v242, 4
  store i64 %v246, ptr %NEXT_PC, align 8
  %v247 = load i32, ptr %EBX, align 4
  %v248 = zext i32 %v247 to i64
  %v249 = load i64, ptr %R14, align 8
  %v250 = add i64 %v249, 40
  %v251 = load ptr, ptr %MEMORY, align 8
  %v252 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v251, ptr %state, i64 %v248, i64 %v250)
  store ptr %v252, ptr %MEMORY, align 8
  store i64 %v246, ptr %PC, align 8
  %v253 = add i64 %v246, 2
  store i64 %v253, ptr %NEXT_PC, align 8
  %v254 = add i64 %v253, 54
  %v255 = load ptr, ptr %MEMORY, align 8
  %v256 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v255, ptr %state, ptr %BRANCH_TAKEN, i64 %v254, i64 %v253, ptr %NEXT_PC)
  store ptr %v256, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877130, label %bb_5389877076

bb_5389877076:                                    ; preds = %bb_5389877070
  store i64 %v253, ptr %PC, align 8
  %v257 = add i64 %v253, 4
  store i64 %v257, ptr %NEXT_PC, align 8
  %v258 = load i64, ptr %R14, align 8
  %v259 = add i64 %v258, 32
  %v260 = load ptr, ptr %MEMORY, align 8
  %v261 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v260, ptr %state, ptr %R8, i64 %v259)
  store ptr %v261, ptr %MEMORY, align 8
  store i64 %v257, ptr %PC, align 8
  %v262 = add i64 %v257, 3
  store i64 %v262, ptr %NEXT_PC, align 8
  %v263 = load i64, ptr %RDI, align 8
  %v264 = load ptr, ptr %MEMORY, align 8
  %v265 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v264, ptr %state, ptr %RCX, i64 %v263)
  store ptr %v265, ptr %MEMORY, align 8
  store i64 %v262, ptr %PC, align 8
  %v266 = add i64 %v262, 4
  store i64 %v266, ptr %NEXT_PC, align 8
  %v267 = load i64, ptr %RBX, align 8
  %v268 = load ptr, ptr %MEMORY, align 8
  %v269 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v268, ptr %state, ptr %RDX, i64 %v267, i64 56)
  store ptr %v269, ptr %MEMORY, align 8
  store i64 %v266, ptr %PC, align 8
  %v270 = add i64 %v266, 4
  store i64 %v270, ptr %NEXT_PC, align 8
  %v271 = load i64, ptr %R8, align 8
  %v272 = load ptr, ptr %MEMORY, align 8
  %v273 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v272, ptr %state, ptr %R8, i64 %v271, i64 8)
  store ptr %v273, ptr %MEMORY, align 8
  store i64 %v270, ptr %PC, align 8
  %v274 = add i64 %v270, 4
  store i64 %v274, ptr %NEXT_PC, align 8
  %v275 = load i64, ptr %RBP, align 8
  %v276 = sub i64 %v275, 8
  %v277 = load i64, ptr %RCX, align 8
  %v278 = load ptr, ptr %MEMORY, align 8
  %v279 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v278, ptr %state, i64 %v276, i64 %v277)
  store ptr %v279, ptr %MEMORY, align 8
  store i64 %v274, ptr %PC, align 8
  %v280 = add i64 %v274, 3
  store i64 %v280, ptr %NEXT_PC, align 8
  %v281 = load i64, ptr %R8, align 8
  %v282 = load i64, ptr %RDX, align 8
  %v283 = load ptr, ptr %MEMORY, align 8
  %v284 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v283, ptr %state, ptr %R8, i64 %v281, i64 %v282)
  store ptr %v284, ptr %MEMORY, align 8
  store i64 %v280, ptr %PC, align 8
  %v285 = add i64 %v280, 4
  store i64 %v285, ptr %NEXT_PC, align 8
  %v286 = load i64, ptr %R8, align 8
  %v287 = add i64 %v286, 32
  %v288 = load ptr, ptr %MEMORY, align 8
  %v289 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v288, ptr %state, ptr %R9, i64 %v287)
  store ptr %v289, ptr %MEMORY, align 8
  store i64 %v285, ptr %PC, align 8
  %v290 = add i64 %v285, 3
  store i64 %v290, ptr %NEXT_PC, align 8
  %v291 = load i64, ptr %R9, align 8
  %v292 = load i64, ptr %R9, align 8
  %v293 = load ptr, ptr %MEMORY, align 8
  %v294 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v293, ptr %state, i64 %v291, i64 %v292)
  store ptr %v294, ptr %MEMORY, align 8
  store i64 %v290, ptr %PC, align 8
  %v295 = add i64 %v290, 2
  store i64 %v295, ptr %NEXT_PC, align 8
  %v296 = add i64 %v295, 30
  %v297 = load ptr, ptr %MEMORY, align 8
  %v298 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v297, ptr %state, ptr %BRANCH_TAKEN, i64 %v296, i64 %v295, ptr %NEXT_PC)
  store ptr %v298, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877137, label %bb_5389877107

bb_5389877107:                                    ; preds = %bb_5389877076
  store i64 %v295, ptr %PC, align 8
  %v299 = add i64 %v295, 4
  store i64 %v299, ptr %NEXT_PC, align 8
  %v300 = load i64, ptr %RBP, align 8
  %v301 = sub i64 %v300, 8
  %v302 = load i64, ptr %R9, align 8
  %v303 = load ptr, ptr %MEMORY, align 8
  %v304 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v303, ptr %state, i64 %v301, i64 %v302)
  store ptr %v304, ptr %MEMORY, align 8
  store i64 %v299, ptr %PC, align 8
  %v305 = add i64 %v299, 4
  store i64 %v305, ptr %NEXT_PC, align 8
  %v306 = load i64, ptr %RBP, align 8
  %v307 = sub i64 %v306, 40
  %v308 = load ptr, ptr %MEMORY, align 8
  %v309 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v308, ptr %state, ptr %RDX, i64 %v307)
  store ptr %v309, ptr %MEMORY, align 8
  store i64 %v305, ptr %PC, align 8
  %v310 = add i64 %v305, 3
  store i64 %v310, ptr %NEXT_PC, align 8
  %v311 = load i64, ptr %R9, align 8
  %v312 = load ptr, ptr %MEMORY, align 8
  %v313 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v312, ptr %state, ptr %RAX, i64 %v311)
  store ptr %v313, ptr %MEMORY, align 8
  store i64 %v310, ptr %PC, align 8
  %v314 = add i64 %v310, 3
  store i64 %v314, ptr %NEXT_PC, align 8
  %v315 = load i64, ptr %R9, align 8
  %v316 = load ptr, ptr %MEMORY, align 8
  %v317 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v316, ptr %state, ptr %RCX, i64 %v315)
  store ptr %v317, ptr %MEMORY, align 8
  store i64 %v314, ptr %PC, align 8
  %v318 = add i64 %v314, 3
  store i64 %v318, ptr %NEXT_PC, align 8
  %v319 = load i64, ptr %RAX, align 8
  %v320 = add i64 %v319, 8
  %v321 = load ptr, ptr %MEMORY, align 8
  %v322 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v321, ptr %state, i64 %v320, ptr %NEXT_PC, i64 %v318, ptr %RETURN_PC)
  store ptr %v322, ptr %MEMORY, align 8
  store i64 %v318, ptr %PC, align 8
  %v323 = add i64 %v318, 4
  store i64 %v323, ptr %NEXT_PC, align 8
  %v324 = load i64, ptr %RBP, align 8
  %v325 = sub i64 %v324, 8
  %v326 = load ptr, ptr %MEMORY, align 8
  %v327 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v326, ptr %state, ptr %RCX, i64 %v325)
  store ptr %v327, ptr %MEMORY, align 8
  store i64 %v323, ptr %PC, align 8
  %v328 = add i64 %v323, 2
  store i64 %v328, ptr %NEXT_PC, align 8
  %v329 = add i64 %v328, 7
  %v330 = load ptr, ptr %MEMORY, align 8
  %v331 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v330, ptr %state, i64 %v329, ptr %NEXT_PC)
  store ptr %v331, ptr %MEMORY, align 8
  br label %bb_5389877137

bb_5389877130:                                    ; preds = %bb_5389877070, %bb_5389877066
  %v332 = load i64, ptr %NEXT_PC, align 8
  store i64 %v332, ptr %PC, align 8
  %v333 = add i64 %v332, 3
  store i64 %v333, ptr %NEXT_PC, align 8
  %v334 = load i64, ptr %RDI, align 8
  %v335 = load ptr, ptr %MEMORY, align 8
  %v336 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v335, ptr %state, ptr %RCX, i64 %v334)
  store ptr %v336, ptr %MEMORY, align 8
  store i64 %v333, ptr %PC, align 8
  %v337 = add i64 %v333, 4
  store i64 %v337, ptr %NEXT_PC, align 8
  %v338 = load i64, ptr %RBP, align 8
  %v339 = sub i64 %v338, 8
  %v340 = load i64, ptr %RCX, align 8
  %v341 = load ptr, ptr %MEMORY, align 8
  %v342 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v341, ptr %state, i64 %v339, i64 %v340)
  store ptr %v342, ptr %MEMORY, align 8
  br label %bb_5389877137

bb_5389877137:                                    ; preds = %bb_5389877130, %bb_5389877107, %bb_5389877076
  %v343 = load i64, ptr %NEXT_PC, align 8
  store i64 %v343, ptr %PC, align 8
  %v344 = add i64 %v343, 7
  store i64 %v344, ptr %NEXT_PC, align 8
  %v345 = load i64, ptr %RCX, align 8
  %v346 = add i64 %v344, 27074328
  %v347 = load ptr, ptr %MEMORY, align 8
  %v348 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v347, ptr %state, i64 %v345, i64 %v346)
  store ptr %v348, ptr %MEMORY, align 8
  store i64 %v344, ptr %PC, align 8
  %v349 = add i64 %v344, 4
  store i64 %v349, ptr %NEXT_PC, align 8
  %v350 = load ptr, ptr %MEMORY, align 8
  %v351 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v350, ptr %state, ptr %R12B)
  store ptr %v351, ptr %MEMORY, align 8
  store i64 %v349, ptr %PC, align 8
  %v352 = add i64 %v349, 3
  store i64 %v352, ptr %NEXT_PC, align 8
  %v353 = load i64, ptr %RCX, align 8
  %v354 = load i64, ptr %RCX, align 8
  %v355 = load ptr, ptr %MEMORY, align 8
  %v356 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v355, ptr %state, i64 %v353, i64 %v354)
  store ptr %v356, ptr %MEMORY, align 8
  store i64 %v352, ptr %PC, align 8
  %v357 = add i64 %v352, 2
  store i64 %v357, ptr %NEXT_PC, align 8
  %v358 = add i64 %v357, 10
  %v359 = load ptr, ptr %MEMORY, align 8
  %v360 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v359, ptr %state, ptr %BRANCH_TAKEN, i64 %v358, i64 %v357, ptr %NEXT_PC)
  store ptr %v360, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877163, label %bb_5389877153

bb_5389877153:                                    ; preds = %bb_5389877137
  store i64 %v357, ptr %PC, align 8
  %v361 = add i64 %v357, 3
  store i64 %v361, ptr %NEXT_PC, align 8
  %v362 = load i64, ptr %RCX, align 8
  %v363 = load ptr, ptr %MEMORY, align 8
  %v364 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v363, ptr %state, ptr %RAX, i64 %v362)
  store ptr %v364, ptr %MEMORY, align 8
  store i64 %v361, ptr %PC, align 8
  %v365 = add i64 %v361, 4
  store i64 %v365, ptr %NEXT_PC, align 8
  %v366 = load i64, ptr %RBP, align 8
  %v367 = sub i64 %v366, 40
  %v368 = load ptr, ptr %MEMORY, align 8
  %v369 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v368, ptr %state, ptr %RDX, i64 %v367)
  store ptr %v369, ptr %MEMORY, align 8
  store i64 %v365, ptr %PC, align 8
  %v370 = add i64 %v365, 3
  store i64 %v370, ptr %NEXT_PC, align 8
  %v371 = load i64, ptr %RAX, align 8
  %v372 = add i64 %v371, 24
  %v373 = load ptr, ptr %MEMORY, align 8
  %v374 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v373, ptr %state, i64 %v372, ptr %NEXT_PC, i64 %v370, ptr %RETURN_PC)
  store ptr %v374, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877163:                                    ; preds = %bb_5389877137
  store i64 %v357, ptr %PC, align 8
  %v375 = add i64 %v357, 3
  store i64 %v375, ptr %NEXT_PC, align 8
  %v376 = load i8, ptr %R12B, align 1
  %v377 = zext i8 %v376 to i64
  %v378 = load i8, ptr %R12B, align 1
  %v379 = zext i8 %v378 to i64
  %v380 = load ptr, ptr %MEMORY, align 8
  %v381 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v380, ptr %state, i64 %v377, i64 %v379)
  store ptr %v381, ptr %MEMORY, align 8
  store i64 %v375, ptr %PC, align 8
  %v382 = add i64 %v375, 2
  store i64 %v382, ptr %NEXT_PC, align 8
  %v383 = add i64 %v382, 15
  %v384 = load ptr, ptr %MEMORY, align 8
  %v385 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v384, ptr %state, ptr %BRANCH_TAKEN, i64 %v383, i64 %v382, ptr %NEXT_PC)
  store ptr %v385, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877183, label %bb_5389877168

bb_5389877168:                                    ; preds = %bb_5389877163
  store i64 %v382, ptr %PC, align 8
  %v386 = add i64 %v382, 2
  store i64 %v386, ptr %NEXT_PC, align 8
  %v387 = load i32, ptr %EBX, align 4
  %v388 = zext i32 %v387 to i64
  %v389 = load ptr, ptr %MEMORY, align 8
  %v390 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v389, ptr %state, ptr %RDX, i64 %v388)
  store ptr %v390, ptr %MEMORY, align 8
  store i64 %v386, ptr %PC, align 8
  %v391 = add i64 %v386, 3
  store i64 %v391, ptr %NEXT_PC, align 8
  %v392 = load i64, ptr %R14, align 8
  %v393 = load ptr, ptr %MEMORY, align 8
  %v394 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v393, ptr %state, ptr %RCX, i64 %v392)
  store ptr %v394, ptr %MEMORY, align 8
  store i64 %v391, ptr %PC, align 8
  %v395 = add i64 %v391, 5
  store i64 %v395, ptr %NEXT_PC, align 8
  %v396 = add i64 %v395, 5398
  %v397 = load ptr, ptr %MEMORY, align 8
  %v398 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v397, ptr %state, i64 5389882576, ptr %NEXT_PC, i64 %v395, ptr %RETURN_PC)
  store ptr %v398, ptr %MEMORY, align 8
  store i64 %v395, ptr %PC, align 8
  %v399 = add i64 %v395, 5
  store i64 %v399, ptr %NEXT_PC, align 8
  %v400 = load ptr, ptr %MEMORY, align 8
  %v401 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v400, ptr %state, ptr %RBX, i64 4294967295)
  store ptr %v401, ptr %MEMORY, align 8
  br label %bb_5389877183

bb_5389877183:                                    ; preds = %bb_5389877168, %bb_5389877163
  %v402 = load i64, ptr %NEXT_PC, align 8
  store i64 %v402, ptr %PC, align 8
  %v403 = add i64 %v402, 4
  store i64 %v403, ptr %NEXT_PC, align 8
  %v404 = load i64, ptr %RBP, align 8
  %v405 = add i64 %v404, 64
  %v406 = load ptr, ptr %MEMORY, align 8
  %v407 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v406, ptr %state, ptr %R12, i64 %v405)
  store ptr %v407, ptr %MEMORY, align 8
  br label %bb_5389877187

bb_5389877187:                                    ; preds = %bb_5389877183, %bb_5389877034
  %v408 = load i64, ptr %NEXT_PC, align 8
  store i64 %v408, ptr %PC, align 8
  %v409 = add i64 %v408, 4
  store i64 %v409, ptr %NEXT_PC, align 8
  %v410 = load i64, ptr %RBP, align 8
  %v411 = add i64 %v410, 80
  %v412 = load i64, ptr %RDI, align 8
  %v413 = load ptr, ptr %MEMORY, align 8
  %v414 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v413, ptr %state, i64 %v411, i64 %v412)
  store ptr %v414, ptr %MEMORY, align 8
  store i64 %v409, ptr %PC, align 8
  %v415 = add i64 %v409, 3
  store i64 %v415, ptr %NEXT_PC, align 8
  %v416 = load i32, ptr %EBX, align 4
  %v417 = zext i32 %v416 to i64
  %v418 = load ptr, ptr %MEMORY, align 8
  %v419 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v418, ptr %state, i64 %v417, i64 -1)
  store ptr %v419, ptr %MEMORY, align 8
  store i64 %v415, ptr %PC, align 8
  %v420 = add i64 %v415, 2
  store i64 %v420, ptr %NEXT_PC, align 8
  %v421 = add i64 %v420, 96
  %v422 = load ptr, ptr %MEMORY, align 8
  %v423 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v422, ptr %state, ptr %BRANCH_TAKEN, i64 %v421, i64 %v420, ptr %NEXT_PC)
  store ptr %v423, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877292, label %bb_5389877196

bb_5389877196:                                    ; preds = %bb_5389877187
  store i64 %v420, ptr %PC, align 8
  %v424 = add i64 %v420, 4
  store i64 %v424, ptr %NEXT_PC, align 8
  %v425 = load i64, ptr %RBP, align 8
  %v426 = add i64 %v425, 80
  %v427 = load ptr, ptr %MEMORY, align 8
  %v428 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v427, ptr %state, ptr %RCX, i64 %v426)
  store ptr %v428, ptr %MEMORY, align 8
  store i64 %v424, ptr %PC, align 8
  %v429 = add i64 %v424, 5
  store i64 %v429, ptr %NEXT_PC, align 8
  %v430 = sub i64 %v429, 584725
  %v431 = load ptr, ptr %MEMORY, align 8
  %v432 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v431, ptr %state, i64 5389292480, ptr %NEXT_PC, i64 %v429, ptr %RETURN_PC)
  store ptr %v432, ptr %MEMORY, align 8
  store i64 %v429, ptr %PC, align 8
  %v433 = add i64 %v429, 4
  store i64 %v433, ptr %NEXT_PC, align 8
  %v434 = load i64, ptr %RBP, align 8
  %v435 = sub i64 %v434, 8
  %v436 = load i64, ptr %RDI, align 8
  %v437 = load ptr, ptr %MEMORY, align 8
  %v438 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v437, ptr %state, i64 %v435, i64 %v436)
  store ptr %v438, ptr %MEMORY, align 8
  store i64 %v433, ptr %PC, align 8
  %v439 = add i64 %v433, 4
  store i64 %v439, ptr %NEXT_PC, align 8
  %v440 = load i64, ptr %RBP, align 8
  %v441 = add i64 %v440, 80
  %v442 = load i64, ptr %RDI, align 8
  %v443 = load ptr, ptr %MEMORY, align 8
  %v444 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v443, ptr %state, i64 %v441, i64 %v442)
  store ptr %v444, ptr %MEMORY, align 8
  store i64 %v439, ptr %PC, align 8
  %v445 = add i64 %v439, 2
  store i64 %v445, ptr %NEXT_PC, align 8
  %v446 = add i64 %v445, 30
  %v447 = load ptr, ptr %MEMORY, align 8
  %v448 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v447, ptr %state, ptr %BRANCH_TAKEN, i64 %v446, i64 %v445, ptr %NEXT_PC)
  store ptr %v448, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877245, label %bb_5389877215

bb_5389877215:                                    ; preds = %bb_5389877196
  store i64 %v445, ptr %PC, align 8
  %v449 = add i64 %v445, 7
  store i64 %v449, ptr %NEXT_PC, align 8
  %v450 = add i64 %v449, 27074250
  %v451 = load ptr, ptr %MEMORY, align 8
  %v452 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v451, ptr %state, ptr %RCX, i64 %v450)
  store ptr %v452, ptr %MEMORY, align 8
  store i64 %v449, ptr %PC, align 8
  %v453 = add i64 %v449, 4
  store i64 %v453, ptr %NEXT_PC, align 8
  %v454 = load i64, ptr %RBP, align 8
  %v455 = sub i64 %v454, 8
  %v456 = load i64, ptr %RCX, align 8
  %v457 = load ptr, ptr %MEMORY, align 8
  %v458 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v457, ptr %state, i64 %v455, i64 %v456)
  store ptr %v458, ptr %MEMORY, align 8
  store i64 %v453, ptr %PC, align 8
  %v459 = add i64 %v453, 3
  store i64 %v459, ptr %NEXT_PC, align 8
  %v460 = load i64, ptr %RCX, align 8
  %v461 = load i64, ptr %RCX, align 8
  %v462 = load ptr, ptr %MEMORY, align 8
  %v463 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v462, ptr %state, i64 %v460, i64 %v461)
  store ptr %v463, ptr %MEMORY, align 8
  store i64 %v459, ptr %PC, align 8
  %v464 = add i64 %v459, 2
  store i64 %v464, ptr %NEXT_PC, align 8
  %v465 = add i64 %v464, 14
  %v466 = load ptr, ptr %MEMORY, align 8
  %v467 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v466, ptr %state, ptr %BRANCH_TAKEN, i64 %v465, i64 %v464, ptr %NEXT_PC)
  store ptr %v467, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877245, label %bb_5389877231

bb_5389877231:                                    ; preds = %bb_5389877215
  store i64 %v464, ptr %PC, align 8
  %v468 = add i64 %v464, 3
  store i64 %v468, ptr %NEXT_PC, align 8
  %v469 = load i64, ptr %RCX, align 8
  %v470 = load ptr, ptr %MEMORY, align 8
  %v471 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v470, ptr %state, ptr %RAX, i64 %v469)
  store ptr %v471, ptr %MEMORY, align 8
  store i64 %v468, ptr %PC, align 8
  %v472 = add i64 %v468, 4
  store i64 %v472, ptr %NEXT_PC, align 8
  %v473 = load i64, ptr %RBP, align 8
  %v474 = add i64 %v473, 80
  %v475 = load ptr, ptr %MEMORY, align 8
  %v476 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v475, ptr %state, ptr %R8, i64 %v474)
  store ptr %v476, ptr %MEMORY, align 8
  store i64 %v472, ptr %PC, align 8
  %v477 = add i64 %v472, 4
  store i64 %v477, ptr %NEXT_PC, align 8
  %v478 = load i64, ptr %RBP, align 8
  %v479 = sub i64 %v478, 40
  %v480 = load ptr, ptr %MEMORY, align 8
  %v481 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v480, ptr %state, ptr %RDX, i64 %v479)
  store ptr %v481, ptr %MEMORY, align 8
  store i64 %v477, ptr %PC, align 8
  %v482 = add i64 %v477, 3
  store i64 %v482, ptr %NEXT_PC, align 8
  %v483 = load i64, ptr %RAX, align 8
  %v484 = add i64 %v483, 16
  %v485 = load ptr, ptr %MEMORY, align 8
  %v486 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v485, ptr %state, i64 %v484, ptr %NEXT_PC, i64 %v482, ptr %RETURN_PC)
  store ptr %v486, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877245:                                    ; preds = %bb_5389877215, %bb_5389877196
  %v487 = load i64, ptr %NEXT_PC, align 8
  store i64 %v487, ptr %PC, align 8
  %v488 = add i64 %v487, 6
  store i64 %v488, ptr %NEXT_PC, align 8
  %v489 = load i64, ptr %RSI, align 8
  %v490 = add i64 %v489, 256
  %v491 = load ptr, ptr %MEMORY, align 8
  %v492 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v491, ptr %state, ptr %RAX, i64 %v490)
  store ptr %v492, ptr %MEMORY, align 8
  store i64 %v488, ptr %PC, align 8
  %v493 = add i64 %v488, 4
  store i64 %v493, ptr %NEXT_PC, align 8
  %v494 = load i64, ptr %RBP, align 8
  %v495 = sub i64 %v494, 40
  %v496 = load ptr, ptr %MEMORY, align 8
  %v497 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v496, ptr %state, ptr %R8, i64 %v495)
  store ptr %v497, ptr %MEMORY, align 8
  store i64 %v493, ptr %PC, align 8
  %v498 = add i64 %v493, 2
  store i64 %v498, ptr %NEXT_PC, align 8
  %v499 = load i64, ptr %RAX, align 8
  %v500 = load ptr, ptr %MEMORY, align 8
  %v501 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v500, ptr %state, ptr %RAX, i64 %v499)
  store ptr %v501, ptr %MEMORY, align 8
  store i64 %v498, ptr %PC, align 8
  %v502 = add i64 %v498, 8
  store i64 %v502, ptr %NEXT_PC, align 8
  %v503 = load i64, ptr %RSP, align 8
  %v504 = add i64 %v503, 40
  %v505 = load ptr, ptr %MEMORY, align 8
  %v506 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v505, ptr %state, i64 %v504, i64 -1)
  store ptr %v506, ptr %MEMORY, align 8
  store i64 %v502, ptr %PC, align 8
  %v507 = add i64 %v502, 3
  store i64 %v507, ptr %NEXT_PC, align 8
  %v508 = load i32, ptr %EAX, align 4
  %v509 = zext i32 %v508 to i64
  %v510 = load ptr, ptr %MEMORY, align 8
  %v511 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v510, ptr %state, ptr %RCX, i64 %v509)
  store ptr %v511, ptr %MEMORY, align 8
  store i64 %v507, ptr %PC, align 8
  %v512 = add i64 %v507, 3
  store i64 %v512, ptr %NEXT_PC, align 8
  %v513 = load i32, ptr %R12D, align 4
  %v514 = zext i32 %v513 to i64
  %v515 = load ptr, ptr %MEMORY, align 8
  %v516 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v515, ptr %state, ptr %R9, i64 %v514)
  store ptr %v516, ptr %MEMORY, align 8
  store i64 %v512, ptr %PC, align 8
  %v517 = add i64 %v512, 5
  store i64 %v517, ptr %NEXT_PC, align 8
  %v518 = load i64, ptr %RSP, align 8
  %v519 = add i64 %v518, 32
  %v520 = load i32, ptr %R13D, align 4
  %v521 = zext i32 %v520 to i64
  %v522 = load ptr, ptr %MEMORY, align 8
  %v523 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v522, ptr %state, i64 %v519, i64 %v521)
  store ptr %v523, ptr %MEMORY, align 8
  store i64 %v517, ptr %PC, align 8
  %v524 = add i64 %v517, 3
  store i64 %v524, ptr %NEXT_PC, align 8
  %v525 = load i64, ptr %RSI, align 8
  %v526 = load i64, ptr %RCX, align 8
  %v527 = mul i64 %v526, 4
  %v528 = add i64 %v525, %v527
  %v529 = load ptr, ptr %MEMORY, align 8
  %v530 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v529, ptr %state, ptr %RDX, i64 %v528)
  store ptr %v530, ptr %MEMORY, align 8
  store i64 %v524, ptr %PC, align 8
  %v531 = add i64 %v524, 3
  store i64 %v531, ptr %NEXT_PC, align 8
  %v532 = load i64, ptr %R14, align 8
  %v533 = load ptr, ptr %MEMORY, align 8
  %v534 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v533, ptr %state, ptr %RCX, i64 %v532)
  store ptr %v534, ptr %MEMORY, align 8
  store i64 %v531, ptr %PC, align 8
  %v535 = add i64 %v531, 5
  store i64 %v535, ptr %NEXT_PC, align 8
  %v536 = add i64 %v535, 4649
  %v537 = load ptr, ptr %MEMORY, align 8
  %v538 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v537, ptr %state, i64 5389881936, ptr %NEXT_PC, i64 %v535, ptr %RETURN_PC)
  store ptr %v538, ptr %MEMORY, align 8
  store i64 %v535, ptr %PC, align 8
  %v539 = add i64 %v535, 5
  store i64 %v539, ptr %NEXT_PC, align 8
  %v540 = add i64 %v539, 227
  %v541 = load ptr, ptr %MEMORY, align 8
  %v542 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v541, ptr %state, i64 %v540, ptr %NEXT_PC)
  store ptr %v542, ptr %MEMORY, align 8
  br label %bb_5389877519

bb_5389877292:                                    ; preds = %bb_5389877187
  store i64 %v420, ptr %PC, align 8
  %v543 = add i64 %v420, 2
  store i64 %v543, ptr %NEXT_PC, align 8
  %v544 = load i32, ptr %EBX, align 4
  %v545 = zext i32 %v544 to i64
  %v546 = load i32, ptr %EBX, align 4
  %v547 = zext i32 %v546 to i64
  %v548 = load ptr, ptr %MEMORY, align 8
  %v549 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v548, ptr %state, i64 %v545, i64 %v547)
  store ptr %v549, ptr %MEMORY, align 8
  store i64 %v543, ptr %PC, align 8
  %v550 = add i64 %v543, 2
  store i64 %v550, ptr %NEXT_PC, align 8
  %v551 = add i64 %v550, 60
  %v552 = load ptr, ptr %MEMORY, align 8
  %v553 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v552, ptr %state, ptr %BRANCH_TAKEN, i64 %v551, i64 %v550, ptr %NEXT_PC)
  store ptr %v553, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877356, label %bb_5389877296

bb_5389877296:                                    ; preds = %bb_5389877292
  store i64 %v550, ptr %PC, align 8
  %v554 = add i64 %v550, 4
  store i64 %v554, ptr %NEXT_PC, align 8
  %v555 = load i32, ptr %EBX, align 4
  %v556 = zext i32 %v555 to i64
  %v557 = load i64, ptr %R14, align 8
  %v558 = add i64 %v557, 40
  %v559 = load ptr, ptr %MEMORY, align 8
  %v560 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v559, ptr %state, i64 %v556, i64 %v558)
  store ptr %v560, ptr %MEMORY, align 8
  store i64 %v554, ptr %PC, align 8
  %v561 = add i64 %v554, 2
  store i64 %v561, ptr %NEXT_PC, align 8
  %v562 = add i64 %v561, 54
  %v563 = load ptr, ptr %MEMORY, align 8
  %v564 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v563, ptr %state, ptr %BRANCH_TAKEN, i64 %v562, i64 %v561, ptr %NEXT_PC)
  store ptr %v564, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877356, label %bb_5389877302

bb_5389877302:                                    ; preds = %bb_5389877296
  store i64 %v561, ptr %PC, align 8
  %v565 = add i64 %v561, 4
  store i64 %v565, ptr %NEXT_PC, align 8
  %v566 = load i64, ptr %R14, align 8
  %v567 = add i64 %v566, 32
  %v568 = load ptr, ptr %MEMORY, align 8
  %v569 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v568, ptr %state, ptr %R8, i64 %v567)
  store ptr %v569, ptr %MEMORY, align 8
  store i64 %v565, ptr %PC, align 8
  %v570 = add i64 %v565, 3
  store i64 %v570, ptr %NEXT_PC, align 8
  %v571 = load i64, ptr %RDI, align 8
  %v572 = load ptr, ptr %MEMORY, align 8
  %v573 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v572, ptr %state, ptr %R9, i64 %v571)
  store ptr %v573, ptr %MEMORY, align 8
  store i64 %v570, ptr %PC, align 8
  %v574 = add i64 %v570, 4
  store i64 %v574, ptr %NEXT_PC, align 8
  %v575 = load i64, ptr %R8, align 8
  %v576 = load ptr, ptr %MEMORY, align 8
  %v577 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v576, ptr %state, ptr %R8, i64 %v575, i64 8)
  store ptr %v577, ptr %MEMORY, align 8
  store i64 %v574, ptr %PC, align 8
  %v578 = add i64 %v574, 3
  store i64 %v578, ptr %NEXT_PC, align 8
  %v579 = load i32, ptr %EBX, align 4
  %v580 = zext i32 %v579 to i64
  %v581 = load ptr, ptr %MEMORY, align 8
  %v582 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v581, ptr %state, ptr %RAX, i64 %v580)
  store ptr %v582, ptr %MEMORY, align 8
  store i64 %v578, ptr %PC, align 8
  %v583 = add i64 %v578, 4
  store i64 %v583, ptr %NEXT_PC, align 8
  %v584 = load i64, ptr %RAX, align 8
  %v585 = load ptr, ptr %MEMORY, align 8
  %v586 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v585, ptr %state, ptr %RCX, i64 %v584, i64 56)
  store ptr %v586, ptr %MEMORY, align 8
  store i64 %v583, ptr %PC, align 8
  %v587 = add i64 %v583, 4
  store i64 %v587, ptr %NEXT_PC, align 8
  %v588 = load i64, ptr %RBP, align 8
  %v589 = sub i64 %v588, 8
  %v590 = load i64, ptr %RDI, align 8
  %v591 = load ptr, ptr %MEMORY, align 8
  %v592 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v591, ptr %state, i64 %v589, i64 %v590)
  store ptr %v592, ptr %MEMORY, align 8
  store i64 %v587, ptr %PC, align 8
  %v593 = add i64 %v587, 3
  store i64 %v593, ptr %NEXT_PC, align 8
  %v594 = load i64, ptr %R8, align 8
  %v595 = load i64, ptr %RCX, align 8
  %v596 = load ptr, ptr %MEMORY, align 8
  %v597 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v596, ptr %state, ptr %R8, i64 %v594, i64 %v595)
  store ptr %v597, ptr %MEMORY, align 8
  store i64 %v593, ptr %PC, align 8
  %v598 = add i64 %v593, 4
  store i64 %v598, ptr %NEXT_PC, align 8
  %v599 = load i64, ptr %R8, align 8
  %v600 = add i64 %v599, 32
  %v601 = load ptr, ptr %MEMORY, align 8
  %v602 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v601, ptr %state, ptr %RCX, i64 %v600)
  store ptr %v602, ptr %MEMORY, align 8
  store i64 %v598, ptr %PC, align 8
  %v603 = add i64 %v598, 3
  store i64 %v603, ptr %NEXT_PC, align 8
  %v604 = load i64, ptr %RCX, align 8
  %v605 = load i64, ptr %RCX, align 8
  %v606 = load ptr, ptr %MEMORY, align 8
  %v607 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v606, ptr %state, i64 %v604, i64 %v605)
  store ptr %v607, ptr %MEMORY, align 8
  store i64 %v603, ptr %PC, align 8
  %v608 = add i64 %v603, 2
  store i64 %v608, ptr %NEXT_PC, align 8
  %v609 = add i64 %v608, 27
  %v610 = load ptr, ptr %MEMORY, align 8
  %v611 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v610, ptr %state, ptr %BRANCH_TAKEN, i64 %v609, i64 %v608, ptr %NEXT_PC)
  store ptr %v611, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877363, label %bb_5389877336

bb_5389877336:                                    ; preds = %bb_5389877302
  store i64 %v608, ptr %PC, align 8
  %v612 = add i64 %v608, 4
  store i64 %v612, ptr %NEXT_PC, align 8
  %v613 = load i64, ptr %RBP, align 8
  %v614 = sub i64 %v613, 8
  %v615 = load i64, ptr %RCX, align 8
  %v616 = load ptr, ptr %MEMORY, align 8
  %v617 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v616, ptr %state, i64 %v614, i64 %v615)
  store ptr %v617, ptr %MEMORY, align 8
  store i64 %v612, ptr %PC, align 8
  %v618 = add i64 %v612, 4
  store i64 %v618, ptr %NEXT_PC, align 8
  %v619 = load i64, ptr %RBP, align 8
  %v620 = sub i64 %v619, 40
  %v621 = load ptr, ptr %MEMORY, align 8
  %v622 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v621, ptr %state, ptr %RDX, i64 %v620)
  store ptr %v622, ptr %MEMORY, align 8
  store i64 %v618, ptr %PC, align 8
  %v623 = add i64 %v618, 3
  store i64 %v623, ptr %NEXT_PC, align 8
  %v624 = load i64, ptr %RCX, align 8
  %v625 = load ptr, ptr %MEMORY, align 8
  %v626 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v625, ptr %state, ptr %RAX, i64 %v624)
  store ptr %v626, ptr %MEMORY, align 8
  store i64 %v623, ptr %PC, align 8
  %v627 = add i64 %v623, 3
  store i64 %v627, ptr %NEXT_PC, align 8
  %v628 = load i64, ptr %RAX, align 8
  %v629 = add i64 %v628, 8
  %v630 = load ptr, ptr %MEMORY, align 8
  %v631 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v630, ptr %state, i64 %v629, ptr %NEXT_PC, i64 %v627, ptr %RETURN_PC)
  store ptr %v631, ptr %MEMORY, align 8
  store i64 %v627, ptr %PC, align 8
  %v632 = add i64 %v627, 4
  store i64 %v632, ptr %NEXT_PC, align 8
  %v633 = load i64, ptr %RBP, align 8
  %v634 = sub i64 %v633, 8
  %v635 = load ptr, ptr %MEMORY, align 8
  %v636 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v635, ptr %state, ptr %R9, i64 %v634)
  store ptr %v636, ptr %MEMORY, align 8
  store i64 %v632, ptr %PC, align 8
  %v637 = add i64 %v632, 2
  store i64 %v637, ptr %NEXT_PC, align 8
  %v638 = add i64 %v637, 7
  %v639 = load ptr, ptr %MEMORY, align 8
  %v640 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v639, ptr %state, i64 %v638, ptr %NEXT_PC)
  store ptr %v640, ptr %MEMORY, align 8
  br label %bb_5389877363

bb_5389877356:                                    ; preds = %bb_5389877296, %bb_5389877292
  %v641 = load i64, ptr %NEXT_PC, align 8
  store i64 %v641, ptr %PC, align 8
  %v642 = add i64 %v641, 3
  store i64 %v642, ptr %NEXT_PC, align 8
  %v643 = load i64, ptr %RDI, align 8
  %v644 = load ptr, ptr %MEMORY, align 8
  %v645 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v644, ptr %state, ptr %R9, i64 %v643)
  store ptr %v645, ptr %MEMORY, align 8
  store i64 %v642, ptr %PC, align 8
  %v646 = add i64 %v642, 4
  store i64 %v646, ptr %NEXT_PC, align 8
  %v647 = load i64, ptr %RBP, align 8
  %v648 = sub i64 %v647, 8
  %v649 = load i64, ptr %RDI, align 8
  %v650 = load ptr, ptr %MEMORY, align 8
  %v651 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v650, ptr %state, i64 %v648, i64 %v649)
  store ptr %v651, ptr %MEMORY, align 8
  br label %bb_5389877363

bb_5389877363:                                    ; preds = %bb_5389877356, %bb_5389877336, %bb_5389877302
  %v652 = load i64, ptr %NEXT_PC, align 8
  store i64 %v652, ptr %PC, align 8
  %v653 = add i64 %v652, 7
  store i64 %v653, ptr %NEXT_PC, align 8
  %v654 = load i64, ptr %R9, align 8
  %v655 = add i64 %v653, 27074102
  %v656 = load ptr, ptr %MEMORY, align 8
  %v657 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v656, ptr %state, i64 %v654, i64 %v655)
  store ptr %v657, ptr %MEMORY, align 8
  store i64 %v653, ptr %PC, align 8
  %v658 = add i64 %v653, 3
  store i64 %v658, ptr %NEXT_PC, align 8
  %v659 = load i64, ptr %RDI, align 8
  %v660 = load ptr, ptr %MEMORY, align 8
  %v661 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v660, ptr %state, ptr %RCX, i64 %v659)
  store ptr %v661, ptr %MEMORY, align 8
  store i64 %v658, ptr %PC, align 8
  %v662 = add i64 %v658, 4
  store i64 %v662, ptr %NEXT_PC, align 8
  %v663 = load i64, ptr %RBP, align 8
  %v664 = sub i64 %v663, 48
  %v665 = load i64, ptr %RCX, align 8
  %v666 = load ptr, ptr %MEMORY, align 8
  %v667 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v666, ptr %state, i64 %v664, i64 %v665)
  store ptr %v667, ptr %MEMORY, align 8
  store i64 %v662, ptr %PC, align 8
  %v668 = add i64 %v662, 2
  store i64 %v668, ptr %NEXT_PC, align 8
  %v669 = add i64 %v668, 79
  %v670 = load ptr, ptr %MEMORY, align 8
  %v671 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v670, ptr %state, ptr %BRANCH_TAKEN, i64 %v669, i64 %v668, ptr %NEXT_PC)
  store ptr %v671, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877458, label %bb_5389877379

bb_5389877379:                                    ; preds = %bb_5389877363
  store i64 %v668, ptr %PC, align 8
  %v672 = add i64 %v668, 3
  store i64 %v672, ptr %NEXT_PC, align 8
  %v673 = load i64, ptr %R9, align 8
  %v674 = load i64, ptr %R9, align 8
  %v675 = load ptr, ptr %MEMORY, align 8
  %v676 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v675, ptr %state, i64 %v673, i64 %v674)
  store ptr %v676, ptr %MEMORY, align 8
  store i64 %v672, ptr %PC, align 8
  %v677 = add i64 %v672, 2
  store i64 %v677, ptr %NEXT_PC, align 8
  %v678 = add i64 %v677, 74
  %v679 = load ptr, ptr %MEMORY, align 8
  %v680 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v679, ptr %state, ptr %BRANCH_TAKEN, i64 %v678, i64 %v677, ptr %NEXT_PC)
  store ptr %v680, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877458, label %bb_5389877384

bb_5389877384:                                    ; preds = %bb_5389877379
  store i64 %v677, ptr %PC, align 8
  %v681 = add i64 %v677, 3
  store i64 %v681, ptr %NEXT_PC, align 8
  %v682 = load i64, ptr %R9, align 8
  %v683 = load ptr, ptr %MEMORY, align 8
  %v684 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v683, ptr %state, ptr %RAX, i64 %v682)
  store ptr %v684, ptr %MEMORY, align 8
  store i64 %v681, ptr %PC, align 8
  %v685 = add i64 %v681, 4
  store i64 %v685, ptr %NEXT_PC, align 8
  %v686 = load i64, ptr %RBP, align 8
  %v687 = sub i64 %v686, 40
  %v688 = load ptr, ptr %MEMORY, align 8
  %v689 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v688, ptr %state, ptr %RDX, i64 %v687)
  store ptr %v689, ptr %MEMORY, align 8
  store i64 %v685, ptr %PC, align 8
  %v690 = add i64 %v685, 3
  store i64 %v690, ptr %NEXT_PC, align 8
  %v691 = load i64, ptr %R9, align 8
  %v692 = load ptr, ptr %MEMORY, align 8
  %v693 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v692, ptr %state, ptr %RCX, i64 %v691)
  store ptr %v693, ptr %MEMORY, align 8
  store i64 %v690, ptr %PC, align 8
  %v694 = add i64 %v690, 3
  store i64 %v694, ptr %NEXT_PC, align 8
  %v695 = load i64, ptr %RAX, align 8
  %v696 = add i64 %v695, 56
  %v697 = load ptr, ptr %MEMORY, align 8
  %v698 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v697, ptr %state, i64 %v696, ptr %NEXT_PC, i64 %v694, ptr %RETURN_PC)
  store ptr %v698, ptr %MEMORY, align 8
  store i64 %v694, ptr %PC, align 8
  %v699 = add i64 %v694, 3
  store i64 %v699, ptr %NEXT_PC, align 8
  %v700 = load i64, ptr %RAX, align 8
  %v701 = load ptr, ptr %MEMORY, align 8
  %v702 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v701, ptr %state, ptr %RBX, i64 %v700)
  store ptr %v702, ptr %MEMORY, align 8
  store i64 %v699, ptr %PC, align 8
  %v703 = add i64 %v699, 3
  store i64 %v703, ptr %NEXT_PC, align 8
  %v704 = load i64, ptr %RAX, align 8
  %v705 = load ptr, ptr %MEMORY, align 8
  %v706 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v705, ptr %state, ptr %RCX, i64 %v704)
  store ptr %v706, ptr %MEMORY, align 8
  store i64 %v703, ptr %PC, align 8
  %v707 = add i64 %v703, 3
  store i64 %v707, ptr %NEXT_PC, align 8
  %v708 = load i64, ptr %RCX, align 8
  %v709 = load i64, ptr %RCX, align 8
  %v710 = load ptr, ptr %MEMORY, align 8
  %v711 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v710, ptr %state, i64 %v708, i64 %v709)
  store ptr %v711, ptr %MEMORY, align 8
  store i64 %v707, ptr %PC, align 8
  %v712 = add i64 %v707, 2
  store i64 %v712, ptr %NEXT_PC, align 8
  %v713 = add i64 %v712, 8
  %v714 = load ptr, ptr %MEMORY, align 8
  %v715 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v714, ptr %state, ptr %BRANCH_TAKEN, i64 %v713, i64 %v712, ptr %NEXT_PC)
  store ptr %v715, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877416, label %bb_5389877408

bb_5389877408:                                    ; preds = %bb_5389877384
  store i64 %v712, ptr %PC, align 8
  %v716 = add i64 %v712, 2
  store i64 %v716, ptr %NEXT_PC, align 8
  %v717 = load i64, ptr %RCX, align 8
  %v718 = load i64, ptr %RCX, align 8
  %v719 = load ptr, ptr %MEMORY, align 8
  %v720 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v719, ptr %state, i64 %v717, i64 %v718)
  store ptr %v720, ptr %MEMORY, align 8
  store i64 %v716, ptr %PC, align 8
  %v721 = add i64 %v716, 4
  store i64 %v721, ptr %NEXT_PC, align 8
  %v722 = load i64, ptr %RCX, align 8
  %v723 = add i64 %v722, 48
  %v724 = load ptr, ptr %MEMORY, align 8
  %v725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v724, ptr %state, ptr %RCX, i64 %v723)
  store ptr %v725, ptr %MEMORY, align 8
  store i64 %v721, ptr %PC, align 8
  %v726 = add i64 %v721, 2
  store i64 %v726, ptr %NEXT_PC, align 8
  %v727 = load i64, ptr %RCX, align 8
  %v728 = load i64, ptr %RCX, align 8
  %v729 = load ptr, ptr %MEMORY, align 8
  %v730 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v729, ptr %state, i64 %v727, i64 %v728)
  store ptr %v730, ptr %MEMORY, align 8
  br label %bb_5389877416

bb_5389877416:                                    ; preds = %bb_5389877408, %bb_5389877384
  %v731 = load i64, ptr %NEXT_PC, align 8
  store i64 %v731, ptr %PC, align 8
  %v732 = add i64 %v731, 4
  store i64 %v732, ptr %NEXT_PC, align 8
  %v733 = load i64, ptr %RBP, align 8
  %v734 = sub i64 %v733, 48
  %v735 = load ptr, ptr %MEMORY, align 8
  %v736 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v735, ptr %state, ptr %RCX, i64 %v734)
  store ptr %v736, ptr %MEMORY, align 8
  store i64 %v732, ptr %PC, align 8
  %v737 = add i64 %v732, 3
  store i64 %v737, ptr %NEXT_PC, align 8
  %v738 = load i64, ptr %RCX, align 8
  %v739 = load i64, ptr %RCX, align 8
  %v740 = load ptr, ptr %MEMORY, align 8
  %v741 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v740, ptr %state, i64 %v738, i64 %v739)
  store ptr %v741, ptr %MEMORY, align 8
  store i64 %v737, ptr %PC, align 8
  %v742 = add i64 %v737, 2
  store i64 %v742, ptr %NEXT_PC, align 8
  %v743 = add i64 %v742, 5
  %v744 = load ptr, ptr %MEMORY, align 8
  %v745 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v744, ptr %state, ptr %BRANCH_TAKEN, i64 %v743, i64 %v742, ptr %NEXT_PC)
  store ptr %v745, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877430, label %bb_5389877425

bb_5389877425:                                    ; preds = %bb_5389877416
  store i64 %v742, ptr %PC, align 8
  %v746 = add i64 %v742, 5
  store i64 %v746, ptr %NEXT_PC, align 8
  %v747 = sub i64 %v746, 726
  %v748 = load ptr, ptr %MEMORY, align 8
  %v749 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v748, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v746, ptr %RETURN_PC)
  store ptr %v749, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877430:                                    ; preds = %bb_5389877416
  store i64 %v742, ptr %PC, align 8
  %v750 = add i64 %v742, 3
  store i64 %v750, ptr %NEXT_PC, align 8
  %v751 = load i64, ptr %RBX, align 8
  %v752 = load ptr, ptr %MEMORY, align 8
  %v753 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v752, ptr %state, ptr %RCX, i64 %v751)
  store ptr %v753, ptr %MEMORY, align 8
  store i64 %v750, ptr %PC, align 8
  %v754 = add i64 %v750, 4
  store i64 %v754, ptr %NEXT_PC, align 8
  %v755 = load i64, ptr %RBP, align 8
  %v756 = sub i64 %v755, 48
  %v757 = load i64, ptr %RCX, align 8
  %v758 = load ptr, ptr %MEMORY, align 8
  %v759 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v758, ptr %state, i64 %v756, i64 %v757)
  store ptr %v759, ptr %MEMORY, align 8
  store i64 %v754, ptr %PC, align 8
  %v760 = add i64 %v754, 3
  store i64 %v760, ptr %NEXT_PC, align 8
  %v761 = load i64, ptr %RCX, align 8
  %v762 = load i64, ptr %RCX, align 8
  %v763 = load ptr, ptr %MEMORY, align 8
  %v764 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v763, ptr %state, i64 %v761, i64 %v762)
  store ptr %v764, ptr %MEMORY, align 8
  store i64 %v760, ptr %PC, align 8
  %v765 = add i64 %v760, 2
  store i64 %v765, ptr %NEXT_PC, align 8
  %v766 = add i64 %v765, 12
  %v767 = load ptr, ptr %MEMORY, align 8
  %v768 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v767, ptr %state, ptr %BRANCH_TAKEN, i64 %v766, i64 %v765, ptr %NEXT_PC)
  store ptr %v768, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877454, label %bb_5389877442

bb_5389877442:                                    ; preds = %bb_5389877430
  store i64 %v765, ptr %PC, align 8
  %v769 = add i64 %v765, 4
  store i64 %v769, ptr %NEXT_PC, align 8
  %v770 = load i64, ptr %RCX, align 8
  %v771 = add i64 %v770, 48
  %v772 = load ptr, ptr %MEMORY, align 8
  %v773 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v772, ptr %state, ptr %RAX, i64 %v771)
  store ptr %v773, ptr %MEMORY, align 8
  store i64 %v769, ptr %PC, align 8
  %v774 = add i64 %v769, 2
  store i64 %v774, ptr %NEXT_PC, align 8
  %v775 = load i64, ptr %RCX, align 8
  %v776 = load i64, ptr %RCX, align 8
  %v777 = load ptr, ptr %MEMORY, align 8
  %v778 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v777, ptr %state, i64 %v775, i64 %v776)
  store ptr %v778, ptr %MEMORY, align 8
  store i64 %v774, ptr %PC, align 8
  %v779 = add i64 %v774, 2
  store i64 %v779, ptr %NEXT_PC, align 8
  %v780 = load i64, ptr %RAX, align 8
  %v781 = load i64, ptr %RAX, align 8
  %v782 = load ptr, ptr %MEMORY, align 8
  %v783 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v782, ptr %state, i64 %v780, i64 %v781)
  store ptr %v783, ptr %MEMORY, align 8
  store i64 %v779, ptr %PC, align 8
  %v784 = add i64 %v779, 4
  store i64 %v784, ptr %NEXT_PC, align 8
  %v785 = load i64, ptr %RBP, align 8
  %v786 = sub i64 %v785, 48
  %v787 = load ptr, ptr %MEMORY, align 8
  %v788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v787, ptr %state, ptr %RCX, i64 %v786)
  store ptr %v788, ptr %MEMORY, align 8
  br label %bb_5389877454

bb_5389877454:                                    ; preds = %bb_5389877442, %bb_5389877430
  %v789 = load i64, ptr %NEXT_PC, align 8
  store i64 %v789, ptr %PC, align 8
  %v790 = add i64 %v789, 4
  store i64 %v790, ptr %NEXT_PC, align 8
  %v791 = load i64, ptr %RBP, align 8
  %v792 = sub i64 %v791, 8
  %v793 = load ptr, ptr %MEMORY, align 8
  %v794 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v793, ptr %state, ptr %R9, i64 %v792)
  store ptr %v794, ptr %MEMORY, align 8
  br label %bb_5389877458

bb_5389877458:                                    ; preds = %bb_5389877454, %bb_5389877379, %bb_5389877363
  %v795 = load i64, ptr %NEXT_PC, align 8
  store i64 %v795, ptr %PC, align 8
  %v796 = add i64 %v795, 4
  store i64 %v796, ptr %NEXT_PC, align 8
  %v797 = load i64, ptr %RBP, align 8
  %v798 = add i64 %v797, 80
  %v799 = load ptr, ptr %MEMORY, align 8
  %v800 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v799, ptr %state, ptr %RAX, i64 %v798)
  store ptr %v800, ptr %MEMORY, align 8
  store i64 %v796, ptr %PC, align 8
  %v801 = add i64 %v796, 3
  store i64 %v801, ptr %NEXT_PC, align 8
  %v802 = load i64, ptr %RAX, align 8
  %v803 = load i64, ptr %RAX, align 8
  %v804 = load ptr, ptr %MEMORY, align 8
  %v805 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v804, ptr %state, i64 %v802, i64 %v803)
  store ptr %v805, ptr %MEMORY, align 8
  store i64 %v801, ptr %PC, align 8
  %v806 = add i64 %v801, 2
  store i64 %v806, ptr %NEXT_PC, align 8
  %v807 = add i64 %v806, 16
  %v808 = load ptr, ptr %MEMORY, align 8
  %v809 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v808, ptr %state, ptr %BRANCH_TAKEN, i64 %v807, i64 %v806, ptr %NEXT_PC)
  store ptr %v809, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877483, label %bb_5389877467

bb_5389877467:                                    ; preds = %bb_5389877458
  store i64 %v806, ptr %PC, align 8
  %v810 = add i64 %v806, 3
  store i64 %v810, ptr %NEXT_PC, align 8
  %v811 = load i64, ptr %RAX, align 8
  %v812 = load ptr, ptr %MEMORY, align 8
  %v813 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v812, ptr %state, ptr %RCX, i64 %v811)
  store ptr %v813, ptr %MEMORY, align 8
  store i64 %v810, ptr %PC, align 8
  %v814 = add i64 %v810, 5
  store i64 %v814, ptr %NEXT_PC, align 8
  %v815 = sub i64 %v814, 771
  %v816 = load ptr, ptr %MEMORY, align 8
  %v817 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v816, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v814, ptr %RETURN_PC)
  store ptr %v817, ptr %MEMORY, align 8
  store i64 %v814, ptr %PC, align 8
  %v818 = add i64 %v814, 4
  store i64 %v818, ptr %NEXT_PC, align 8
  %v819 = load i64, ptr %RBP, align 8
  %v820 = sub i64 %v819, 48
  %v821 = load ptr, ptr %MEMORY, align 8
  %v822 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v821, ptr %state, ptr %RCX, i64 %v820)
  store ptr %v822, ptr %MEMORY, align 8
  store i64 %v818, ptr %PC, align 8
  %v823 = add i64 %v818, 4
  store i64 %v823, ptr %NEXT_PC, align 8
  %v824 = load i64, ptr %RBP, align 8
  %v825 = sub i64 %v824, 8
  %v826 = load ptr, ptr %MEMORY, align 8
  %v827 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v826, ptr %state, ptr %R9, i64 %v825)
  store ptr %v827, ptr %MEMORY, align 8
  br label %bb_5389877483

bb_5389877483:                                    ; preds = %bb_5389877467, %bb_5389877458
  %v828 = load i64, ptr %NEXT_PC, align 8
  store i64 %v828, ptr %PC, align 8
  %v829 = add i64 %v828, 4
  store i64 %v829, ptr %NEXT_PC, align 8
  %v830 = load i64, ptr %RBP, align 8
  %v831 = add i64 %v830, 80
  %v832 = load i64, ptr %RCX, align 8
  %v833 = load ptr, ptr %MEMORY, align 8
  %v834 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v833, ptr %state, i64 %v831, i64 %v832)
  store ptr %v834, ptr %MEMORY, align 8
  store i64 %v829, ptr %PC, align 8
  %v835 = add i64 %v829, 3
  store i64 %v835, ptr %NEXT_PC, align 8
  %v836 = load i64, ptr %RCX, align 8
  %v837 = load i64, ptr %RCX, align 8
  %v838 = load ptr, ptr %MEMORY, align 8
  %v839 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v838, ptr %state, i64 %v836, i64 %v837)
  store ptr %v839, ptr %MEMORY, align 8
  store i64 %v835, ptr %PC, align 8
  %v840 = add i64 %v835, 2
  store i64 %v840, ptr %NEXT_PC, align 8
  %v841 = add i64 %v840, 9
  %v842 = load ptr, ptr %MEMORY, align 8
  %v843 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v842, ptr %state, ptr %BRANCH_TAKEN, i64 %v841, i64 %v840, ptr %NEXT_PC)
  store ptr %v843, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877501, label %bb_5389877492

bb_5389877492:                                    ; preds = %bb_5389877483
  store i64 %v840, ptr %PC, align 8
  %v844 = add i64 %v840, 5
  store i64 %v844, ptr %NEXT_PC, align 8
  %v845 = sub i64 %v844, 793
  %v846 = load ptr, ptr %MEMORY, align 8
  %v847 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v846, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v844, ptr %RETURN_PC)
  store ptr %v847, ptr %MEMORY, align 8
  store i64 %v844, ptr %PC, align 8
  %v848 = add i64 %v844, 4
  store i64 %v848, ptr %NEXT_PC, align 8
  %v849 = load i64, ptr %RBP, align 8
  %v850 = sub i64 %v849, 8
  %v851 = load ptr, ptr %MEMORY, align 8
  %v852 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v851, ptr %state, ptr %R9, i64 %v850)
  store ptr %v852, ptr %MEMORY, align 8
  br label %bb_5389877501

bb_5389877501:                                    ; preds = %bb_5389877492, %bb_5389877483
  %v853 = load i64, ptr %NEXT_PC, align 8
  store i64 %v853, ptr %PC, align 8
  %v854 = add i64 %v853, 3
  store i64 %v854, ptr %NEXT_PC, align 8
  %v855 = load i64, ptr %R9, align 8
  %v856 = load i64, ptr %R9, align 8
  %v857 = load ptr, ptr %MEMORY, align 8
  %v858 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v857, ptr %state, i64 %v855, i64 %v856)
  store ptr %v858, ptr %MEMORY, align 8
  store i64 %v854, ptr %PC, align 8
  %v859 = add i64 %v854, 2
  store i64 %v859, ptr %NEXT_PC, align 8
  %v860 = add i64 %v859, 13
  %v861 = load ptr, ptr %MEMORY, align 8
  %v862 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v861, ptr %state, ptr %BRANCH_TAKEN, i64 %v860, i64 %v859, ptr %NEXT_PC)
  store ptr %v862, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877519, label %bb_5389877506

bb_5389877506:                                    ; preds = %bb_5389877501
  store i64 %v859, ptr %PC, align 8
  %v863 = add i64 %v859, 3
  store i64 %v863, ptr %NEXT_PC, align 8
  %v864 = load i64, ptr %R9, align 8
  %v865 = load ptr, ptr %MEMORY, align 8
  %v866 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v865, ptr %state, ptr %RAX, i64 %v864)
  store ptr %v866, ptr %MEMORY, align 8
  store i64 %v863, ptr %PC, align 8
  %v867 = add i64 %v863, 4
  store i64 %v867, ptr %NEXT_PC, align 8
  %v868 = load i64, ptr %RBP, align 8
  %v869 = sub i64 %v868, 40
  %v870 = load ptr, ptr %MEMORY, align 8
  %v871 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v870, ptr %state, ptr %RDX, i64 %v869)
  store ptr %v871, ptr %MEMORY, align 8
  store i64 %v867, ptr %PC, align 8
  %v872 = add i64 %v867, 3
  store i64 %v872, ptr %NEXT_PC, align 8
  %v873 = load i64, ptr %R9, align 8
  %v874 = load ptr, ptr %MEMORY, align 8
  %v875 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v874, ptr %state, ptr %RCX, i64 %v873)
  store ptr %v875, ptr %MEMORY, align 8
  store i64 %v872, ptr %PC, align 8
  %v876 = add i64 %v872, 3
  store i64 %v876, ptr %NEXT_PC, align 8
  %v877 = load i64, ptr %RAX, align 8
  %v878 = add i64 %v877, 24
  %v879 = load ptr, ptr %MEMORY, align 8
  %v880 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v879, ptr %state, i64 %v878, ptr %NEXT_PC, i64 %v876, ptr %RETURN_PC)
  store ptr %v880, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877519:                                    ; preds = %bb_5389877501, %bb_5389877245
  %v881 = load i64, ptr %NEXT_PC, align 8
  store i64 %v881, ptr %PC, align 8
  %v882 = add i64 %v881, 6
  store i64 %v882, ptr %NEXT_PC, align 8
  %v883 = load i64, ptr %RSI, align 8
  %v884 = add i64 %v883, 256
  %v885 = load i64, ptr %RSI, align 8
  %v886 = add i64 %v885, 256
  %v887 = load ptr, ptr %MEMORY, align 8
  %v888 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v887, ptr %state, i64 %v884, i64 %v886)
  store ptr %v888, ptr %MEMORY, align 8
  store i64 %v882, ptr %PC, align 8
  %v889 = add i64 %v882, 4
  store i64 %v889, ptr %NEXT_PC, align 8
  %v890 = load i64, ptr %RBP, align 8
  %v891 = sub i64 %v890, 40
  %v892 = load ptr, ptr %MEMORY, align 8
  %v893 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v892, ptr %state, ptr %RCX, i64 %v891)
  store ptr %v893, ptr %MEMORY, align 8
  store i64 %v889, ptr %PC, align 8
  %v894 = add i64 %v889, 3
  store i64 %v894, ptr %NEXT_PC, align 8
  %v895 = load i64, ptr %R15, align 8
  %v896 = load ptr, ptr %MEMORY, align 8
  %v897 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v896, ptr %state, ptr %RDX, i64 %v895)
  store ptr %v897, ptr %MEMORY, align 8
  store i64 %v894, ptr %PC, align 8
  %v898 = add i64 %v894, 4
  store i64 %v898, ptr %NEXT_PC, align 8
  %v899 = load i64, ptr %RBP, align 8
  %v900 = sub i64 %v899, 8
  %v901 = load i64, ptr %RDI, align 8
  %v902 = load ptr, ptr %MEMORY, align 8
  %v903 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v902, ptr %state, i64 %v900, i64 %v901)
  store ptr %v903, ptr %MEMORY, align 8
  store i64 %v898, ptr %PC, align 8
  %v904 = add i64 %v898, 5
  store i64 %v904, ptr %NEXT_PC, align 8
  %v905 = sub i64 %v904, 18801845
  %v906 = load ptr, ptr %MEMORY, align 8
  %v907 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v906, ptr %state, i64 5371075696, ptr %NEXT_PC, i64 %v904, ptr %RETURN_PC)
  store ptr %v907, ptr %MEMORY, align 8
  store i64 %v904, ptr %PC, align 8
  %v908 = add i64 %v904, 4
  store i64 %v908, ptr %NEXT_PC, align 8
  %v909 = load i64, ptr %RBP, align 8
  %v910 = add i64 %v909, 80
  %v911 = load ptr, ptr %MEMORY, align 8
  %v912 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v911, ptr %state, ptr %RCX, i64 %v910)
  store ptr %v912, ptr %MEMORY, align 8
  store i64 %v908, ptr %PC, align 8
  %v913 = add i64 %v908, 4
  store i64 %v913, ptr %NEXT_PC, align 8
  %v914 = load i64, ptr %RBP, align 8
  %v915 = sub i64 %v914, 40
  %v916 = load ptr, ptr %MEMORY, align 8
  %v917 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v916, ptr %state, ptr %RDX, i64 %v915)
  store ptr %v917, ptr %MEMORY, align 8
  store i64 %v913, ptr %PC, align 8
  %v918 = add i64 %v913, 3
  store i64 %v918, ptr %NEXT_PC, align 8
  %v919 = load i32, ptr %R13D, align 4
  %v920 = zext i32 %v919 to i64
  %v921 = load ptr, ptr %MEMORY, align 8
  %v922 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v921, ptr %state, ptr %R9, i64 %v920)
  store ptr %v922, ptr %MEMORY, align 8
  store i64 %v918, ptr %PC, align 8
  %v923 = add i64 %v918, 5
  store i64 %v923, ptr %NEXT_PC, align 8
  %v924 = load i64, ptr %RSP, align 8
  %v925 = add i64 %v924, 32
  %v926 = load i64, ptr %RSI, align 8
  %v927 = load ptr, ptr %MEMORY, align 8
  %v928 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v927, ptr %state, i64 %v925, i64 %v926)
  store ptr %v928, ptr %MEMORY, align 8
  store i64 %v923, ptr %PC, align 8
  %v929 = add i64 %v923, 3
  store i64 %v929, ptr %NEXT_PC, align 8
  %v930 = load i32, ptr %R12D, align 4
  %v931 = zext i32 %v930 to i64
  %v932 = load ptr, ptr %MEMORY, align 8
  %v933 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v932, ptr %state, ptr %R8, i64 %v931)
  store ptr %v933, ptr %MEMORY, align 8
  store i64 %v929, ptr %PC, align 8
  %v934 = add i64 %v929, 5
  store i64 %v934, ptr %NEXT_PC, align 8
  %v935 = sub i64 %v934, 685
  %v936 = load ptr, ptr %MEMORY, align 8
  %v937 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v936, ptr %state, i64 5389876880, ptr %NEXT_PC, i64 %v934, ptr %RETURN_PC)
  store ptr %v937, ptr %MEMORY, align 8
  store i64 %v934, ptr %PC, align 8
  %v938 = add i64 %v934, 4
  store i64 %v938, ptr %NEXT_PC, align 8
  %v939 = load i64, ptr %RBP, align 8
  %v940 = add i64 %v939, 80
  %v941 = load ptr, ptr %MEMORY, align 8
  %v942 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v941, ptr %state, ptr %RCX, i64 %v940)
  store ptr %v942, ptr %MEMORY, align 8
  store i64 %v938, ptr %PC, align 8
  %v943 = add i64 %v938, 2
  store i64 %v943, ptr %NEXT_PC, align 8
  %v944 = load i32, ptr %EAX, align 4
  %v945 = zext i32 %v944 to i64
  %v946 = load ptr, ptr %MEMORY, align 8
  %v947 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v946, ptr %state, ptr %RBX, i64 %v945)
  store ptr %v947, ptr %MEMORY, align 8
  store i64 %v943, ptr %PC, align 8
  %v948 = add i64 %v943, 3
  store i64 %v948, ptr %NEXT_PC, align 8
  %v949 = load i64, ptr %RCX, align 8
  %v950 = load i64, ptr %RCX, align 8
  %v951 = load ptr, ptr %MEMORY, align 8
  %v952 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v951, ptr %state, i64 %v949, i64 %v950)
  store ptr %v952, ptr %MEMORY, align 8
  store i64 %v948, ptr %PC, align 8
  %v953 = add i64 %v948, 2
  store i64 %v953, ptr %NEXT_PC, align 8
  %v954 = add i64 %v953, 5
  %v955 = load ptr, ptr %MEMORY, align 8
  %v956 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v955, ptr %state, ptr %BRANCH_TAKEN, i64 %v954, i64 %v953, ptr %NEXT_PC)
  store ptr %v956, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877581, label %bb_5389877576

bb_5389877576:                                    ; preds = %bb_5389877519
  store i64 %v953, ptr %PC, align 8
  %v957 = add i64 %v953, 5
  store i64 %v957, ptr %NEXT_PC, align 8
  %v958 = sub i64 %v957, 877
  %v959 = load ptr, ptr %MEMORY, align 8
  %v960 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v959, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v957, ptr %RETURN_PC)
  store ptr %v960, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877581:                                    ; preds = %bb_5389877519
  store i64 %v953, ptr %PC, align 8
  %v961 = add i64 %v953, 4
  store i64 %v961, ptr %NEXT_PC, align 8
  %v962 = load i64, ptr %R15, align 8
  %v963 = add i64 %v962, 32
  %v964 = load ptr, ptr %MEMORY, align 8
  %v965 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v964, ptr %state, ptr %RCX, i64 %v963)
  store ptr %v965, ptr %MEMORY, align 8
  store i64 %v961, ptr %PC, align 8
  %v966 = add i64 %v961, 3
  store i64 %v966, ptr %NEXT_PC, align 8
  %v967 = load i64, ptr %RCX, align 8
  %v968 = load i64, ptr %RCX, align 8
  %v969 = load ptr, ptr %MEMORY, align 8
  %v970 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v969, ptr %state, i64 %v967, i64 %v968)
  store ptr %v970, ptr %MEMORY, align 8
  store i64 %v966, ptr %PC, align 8
  %v971 = add i64 %v966, 2
  store i64 %v971, ptr %NEXT_PC, align 8
  %v972 = add i64 %v971, 10
  %v973 = load ptr, ptr %MEMORY, align 8
  %v974 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v973, ptr %state, ptr %BRANCH_TAKEN, i64 %v972, i64 %v971, ptr %NEXT_PC)
  store ptr %v974, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877600, label %bb_5389877590

bb_5389877590:                                    ; preds = %bb_5389877581
  store i64 %v971, ptr %PC, align 8
  %v975 = add i64 %v971, 3
  store i64 %v975, ptr %NEXT_PC, align 8
  %v976 = load i64, ptr %RCX, align 8
  %v977 = load ptr, ptr %MEMORY, align 8
  %v978 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v977, ptr %state, ptr %R8, i64 %v976)
  store ptr %v978, ptr %MEMORY, align 8
  store i64 %v975, ptr %PC, align 8
  %v979 = add i64 %v975, 3
  store i64 %v979, ptr %NEXT_PC, align 8
  %v980 = load i64, ptr %R15, align 8
  %v981 = load ptr, ptr %MEMORY, align 8
  %v982 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v981, ptr %state, ptr %RDX, i64 %v980)
  store ptr %v982, ptr %MEMORY, align 8
  store i64 %v979, ptr %PC, align 8
  %v983 = add i64 %v979, 4
  store i64 %v983, ptr %NEXT_PC, align 8
  %v984 = load i64, ptr %R8, align 8
  %v985 = add i64 %v984, 24
  %v986 = load ptr, ptr %MEMORY, align 8
  %v987 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v986, ptr %state, i64 %v985, ptr %NEXT_PC, i64 %v983, ptr %RETURN_PC)
  store ptr %v987, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877600:                                    ; preds = %bb_5389877581
  store i64 %v971, ptr %PC, align 8
  %v988 = add i64 %v971, 2
  store i64 %v988, ptr %NEXT_PC, align 8
  %v989 = load i32, ptr %EBX, align 4
  %v990 = zext i32 %v989 to i64
  %v991 = load ptr, ptr %MEMORY, align 8
  %v992 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v991, ptr %state, ptr %RAX, i64 %v990)
  store ptr %v992, ptr %MEMORY, align 8
  store i64 %v988, ptr %PC, align 8
  %v993 = add i64 %v988, 8
  store i64 %v993, ptr %NEXT_PC, align 8
  %v994 = load i64, ptr %RSP, align 8
  %v995 = add i64 %v994, 144
  %v996 = load ptr, ptr %MEMORY, align 8
  %v997 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v996, ptr %state, ptr %RBX, i64 %v995)
  store ptr %v997, ptr %MEMORY, align 8
  br label %bb_5389877610

bb_5389877610:                                    ; preds = %bb_5389877600, %bb_5389877027
  %v998 = load i64, ptr %NEXT_PC, align 8
  store i64 %v998, ptr %PC, align 8
  %v999 = add i64 %v998, 5
  store i64 %v999, ptr %NEXT_PC, align 8
  %v1000 = load i64, ptr %RSP, align 8
  %v1001 = add i64 %v1000, 96
  %v1002 = load ptr, ptr %MEMORY, align 8
  %v1003 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1002, ptr %state, ptr %R11, i64 %v1001)
  store ptr %v1003, ptr %MEMORY, align 8
  store i64 %v999, ptr %PC, align 8
  %v1004 = add i64 %v999, 4
  store i64 %v1004, ptr %NEXT_PC, align 8
  %v1005 = load i64, ptr %R11, align 8
  %v1006 = add i64 %v1005, 56
  %v1007 = load ptr, ptr %MEMORY, align 8
  %v1008 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1007, ptr %state, ptr %RSI, i64 %v1006)
  store ptr %v1008, ptr %MEMORY, align 8
  store i64 %v1004, ptr %PC, align 8
  %v1009 = add i64 %v1004, 4
  store i64 %v1009, ptr %NEXT_PC, align 8
  %v1010 = load i64, ptr %R11, align 8
  %v1011 = add i64 %v1010, 72
  %v1012 = load ptr, ptr %MEMORY, align 8
  %v1013 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1012, ptr %state, ptr %RDI, i64 %v1011)
  store ptr %v1013, ptr %MEMORY, align 8
  store i64 %v1009, ptr %PC, align 8
  %v1014 = add i64 %v1009, 3
  store i64 %v1014, ptr %NEXT_PC, align 8
  %v1015 = load i64, ptr %R11, align 8
  %v1016 = load ptr, ptr %MEMORY, align 8
  %v1017 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1016, ptr %state, ptr %RSP, i64 %v1015)
  store ptr %v1017, ptr %MEMORY, align 8
  store i64 %v1014, ptr %PC, align 8
  %v1018 = add i64 %v1014, 2
  store i64 %v1018, ptr %NEXT_PC, align 8
  %v1019 = load ptr, ptr %MEMORY, align 8
  %v1020 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1019, ptr %state, ptr %R15)
  store ptr %v1020, ptr %MEMORY, align 8
  store i64 %v1018, ptr %PC, align 8
  %v1021 = add i64 %v1018, 2
  store i64 %v1021, ptr %NEXT_PC, align 8
  %v1022 = load ptr, ptr %MEMORY, align 8
  %v1023 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1022, ptr %state, ptr %R14)
  store ptr %v1023, ptr %MEMORY, align 8
  store i64 %v1021, ptr %PC, align 8
  %v1024 = add i64 %v1021, 2
  store i64 %v1024, ptr %NEXT_PC, align 8
  %v1025 = load ptr, ptr %MEMORY, align 8
  %v1026 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1025, ptr %state, ptr %R13)
  store ptr %v1026, ptr %MEMORY, align 8
  store i64 %v1024, ptr %PC, align 8
  %v1027 = add i64 %v1024, 2
  store i64 %v1027, ptr %NEXT_PC, align 8
  %v1028 = load ptr, ptr %MEMORY, align 8
  %v1029 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1028, ptr %state, ptr %R12)
  store ptr %v1029, ptr %MEMORY, align 8
  store i64 %v1027, ptr %PC, align 8
  %v1030 = add i64 %v1027, 1
  store i64 %v1030, ptr %NEXT_PC, align 8
  %v1031 = load ptr, ptr %MEMORY, align 8
  %v1032 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1031, ptr %state, ptr %RBP)
  store ptr %v1032, ptr %MEMORY, align 8
  store i64 %v1030, ptr %PC, align 8
  %v1033 = add i64 %v1030, 1
  store i64 %v1033, ptr %NEXT_PC, align 8
  %v1034 = load ptr, ptr %MEMORY, align 8
  %v1035 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1034, ptr %state, ptr %NEXT_PC)
  store ptr %v1035, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877636:                                    ; No predecessors!
  %v1036 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1036, ptr %PC, align 8
  %v1037 = add i64 %v1036, 1
  store i64 %v1037, ptr %NEXT_PC, align 8
  %v1038 = load ptr, ptr %MEMORY, align 8
  %v1039 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1038, ptr %state, ptr undef)
  store ptr %v1039, ptr %MEMORY, align 8
  store i64 %v1037, ptr %PC, align 8
  %v1040 = add i64 %v1037, 1
  store i64 %v1040, ptr %NEXT_PC, align 8
  %v1041 = load ptr, ptr %MEMORY, align 8
  %v1042 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1041, ptr %state, ptr undef)
  store ptr %v1042, ptr %MEMORY, align 8
  store i64 %v1040, ptr %PC, align 8
  %v1043 = add i64 %v1040, 1
  store i64 %v1043, ptr %NEXT_PC, align 8
  %v1044 = load ptr, ptr %MEMORY, align 8
  %v1045 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1044, ptr %state, ptr undef)
  store ptr %v1045, ptr %MEMORY, align 8
  store i64 %v1043, ptr %PC, align 8
  %v1046 = add i64 %v1043, 1
  store i64 %v1046, ptr %NEXT_PC, align 8
  %v1047 = load ptr, ptr %MEMORY, align 8
  %v1048 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1047, ptr %state, ptr undef)
  store ptr %v1048, ptr %MEMORY, align 8
  store i64 %v1046, ptr %PC, align 8
  %v1049 = add i64 %v1046, 1
  store i64 %v1049, ptr %NEXT_PC, align 8
  %v1050 = load ptr, ptr %MEMORY, align 8
  %v1051 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1050, ptr %state, ptr undef)
  store ptr %v1051, ptr %MEMORY, align 8
  store i64 %v1049, ptr %PC, align 8
  %v1052 = add i64 %v1049, 1
  store i64 %v1052, ptr %NEXT_PC, align 8
  %v1053 = load ptr, ptr %MEMORY, align 8
  %v1054 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1053, ptr %state, ptr undef)
  store ptr %v1054, ptr %MEMORY, align 8
  store i64 %v1052, ptr %PC, align 8
  %v1055 = add i64 %v1052, 1
  store i64 %v1055, ptr %NEXT_PC, align 8
  %v1056 = load ptr, ptr %MEMORY, align 8
  %v1057 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1056, ptr %state, ptr undef)
  store ptr %v1057, ptr %MEMORY, align 8
  store i64 %v1055, ptr %PC, align 8
  %v1058 = add i64 %v1055, 1
  store i64 %v1058, ptr %NEXT_PC, align 8
  %v1059 = load ptr, ptr %MEMORY, align 8
  %v1060 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1059, ptr %state, ptr undef)
  store ptr %v1060, ptr %MEMORY, align 8
  store i64 %v1058, ptr %PC, align 8
  %v1061 = add i64 %v1058, 1
  store i64 %v1061, ptr %NEXT_PC, align 8
  %v1062 = load ptr, ptr %MEMORY, align 8
  %v1063 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1062, ptr %state, ptr undef)
  store ptr %v1063, ptr %MEMORY, align 8
  store i64 %v1061, ptr %PC, align 8
  %v1064 = add i64 %v1061, 1
  store i64 %v1064, ptr %NEXT_PC, align 8
  %v1065 = load ptr, ptr %MEMORY, align 8
  %v1066 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1065, ptr %state, ptr undef)
  store ptr %v1066, ptr %MEMORY, align 8
  store i64 %v1064, ptr %PC, align 8
  %v1067 = add i64 %v1064, 1
  store i64 %v1067, ptr %NEXT_PC, align 8
  %v1068 = load ptr, ptr %MEMORY, align 8
  %v1069 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1068, ptr %state, ptr undef)
  store ptr %v1069, ptr %MEMORY, align 8
  store i64 %v1067, ptr %PC, align 8
  %v1070 = add i64 %v1067, 1
  store i64 %v1070, ptr %NEXT_PC, align 8
  %v1071 = load ptr, ptr %MEMORY, align 8
  %v1072 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1071, ptr %state, ptr undef)
  store ptr %v1072, ptr %MEMORY, align 8
  store i64 %v1070, ptr %PC, align 8
  %v1073 = add i64 %v1070, 5
  store i64 %v1073, ptr %NEXT_PC, align 8
  %v1074 = load i64, ptr %RSP, align 8
  %v1075 = add i64 %v1074, 16
  %v1076 = load i64, ptr %RBX, align 8
  %v1077 = load ptr, ptr %MEMORY, align 8
  %v1078 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1077, ptr %state, i64 %v1075, i64 %v1076)
  store ptr %v1078, ptr %MEMORY, align 8
  store i64 %v1073, ptr %PC, align 8
  %v1079 = add i64 %v1073, 5
  store i64 %v1079, ptr %NEXT_PC, align 8
  %v1080 = load i64, ptr %RSP, align 8
  %v1081 = add i64 %v1080, 32
  %v1082 = load i64, ptr %RBP, align 8
  %v1083 = load ptr, ptr %MEMORY, align 8
  %v1084 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1083, ptr %state, i64 %v1081, i64 %v1082)
  store ptr %v1084, ptr %MEMORY, align 8
  store i64 %v1079, ptr %PC, align 8
  %v1085 = add i64 %v1079, 1
  store i64 %v1085, ptr %NEXT_PC, align 8
  %v1086 = load i64, ptr %RDI, align 8
  %v1087 = load ptr, ptr %MEMORY, align 8
  %v1088 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1087, ptr %state, i64 %v1086)
  store ptr %v1088, ptr %MEMORY, align 8
  store i64 %v1085, ptr %PC, align 8
  %v1089 = add i64 %v1085, 4
  store i64 %v1089, ptr %NEXT_PC, align 8
  %v1090 = load i64, ptr %RSP, align 8
  %v1091 = load ptr, ptr %MEMORY, align 8
  %v1092 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1091, ptr %state, ptr %RSP, i64 %v1090, i64 80)
  store ptr %v1092, ptr %MEMORY, align 8
  store i64 %v1089, ptr %PC, align 8
  %v1093 = add i64 %v1089, 7
  store i64 %v1093, ptr %NEXT_PC, align 8
  %v1094 = load i64, ptr %R8, align 8
  %v1095 = add i64 %v1094, 256
  %v1096 = load ptr, ptr %MEMORY, align 8
  %v1097 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1096, ptr %state, ptr %RAX, i64 %v1095)
  store ptr %v1097, ptr %MEMORY, align 8
  store i64 %v1093, ptr %PC, align 8
  %v1098 = add i64 %v1093, 3
  store i64 %v1098, ptr %NEXT_PC, align 8
  %v1099 = load i64, ptr %R8, align 8
  %v1100 = load ptr, ptr %MEMORY, align 8
  %v1101 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1100, ptr %state, ptr %RDI, i64 %v1099)
  store ptr %v1101, ptr %MEMORY, align 8
  store i64 %v1098, ptr %PC, align 8
  %v1102 = add i64 %v1098, 2
  store i64 %v1102, ptr %NEXT_PC, align 8
  %v1103 = load i32, ptr %EDX, align 4
  %v1104 = zext i32 %v1103 to i64
  %v1105 = load ptr, ptr %MEMORY, align 8
  %v1106 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1105, ptr %state, ptr %RBP, i64 %v1104)
  store ptr %v1106, ptr %MEMORY, align 8
  store i64 %v1102, ptr %PC, align 8
  %v1107 = add i64 %v1102, 3
  store i64 %v1107, ptr %NEXT_PC, align 8
  %v1108 = load i64, ptr %RCX, align 8
  %v1109 = load ptr, ptr %MEMORY, align 8
  %v1110 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1109, ptr %state, ptr %RBX, i64 %v1108)
  store ptr %v1110, ptr %MEMORY, align 8
  store i64 %v1107, ptr %PC, align 8
  %v1111 = add i64 %v1107, 2
  store i64 %v1111, ptr %NEXT_PC, align 8
  %v1112 = load i32, ptr %EAX, align 4
  %v1113 = zext i32 %v1112 to i64
  %v1114 = load i32, ptr %EAX, align 4
  %v1115 = zext i32 %v1114 to i64
  %v1116 = load ptr, ptr %MEMORY, align 8
  %v1117 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1116, ptr %state, i64 %v1113, i64 %v1115)
  store ptr %v1117, ptr %MEMORY, align 8
  store i64 %v1111, ptr %PC, align 8
  %v1118 = add i64 %v1111, 6
  store i64 %v1118, ptr %NEXT_PC, align 8
  %v1119 = add i64 %v1118, 318
  %v1120 = load ptr, ptr %MEMORY, align 8
  %v1121 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1120, ptr %state, ptr %BRANCH_TAKEN, i64 %v1119, i64 %v1118, ptr %NEXT_PC)
  store ptr %v1121, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878004, label %bb_5389877686

bb_5389877686:                                    ; preds = %bb_5389877636
  store i64 %v1118, ptr %PC, align 8
  %v1122 = add i64 %v1118, 2
  store i64 %v1122, ptr %NEXT_PC, align 8
  %v1123 = load i64, ptr %RAX, align 8
  %v1124 = load ptr, ptr %MEMORY, align 8
  %v1125 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1124, ptr %state, ptr %RAX, i64 %v1123)
  store ptr %v1125, ptr %MEMORY, align 8
  store i64 %v1122, ptr %PC, align 8
  %v1126 = add i64 %v1122, 3
  store i64 %v1126, ptr %NEXT_PC, align 8
  %v1127 = load i32, ptr %EAX, align 4
  %v1128 = zext i32 %v1127 to i64
  %v1129 = load ptr, ptr %MEMORY, align 8
  %v1130 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v1129, ptr %state, ptr %RDX, i64 %v1128)
  store ptr %v1130, ptr %MEMORY, align 8
  store i64 %v1126, ptr %PC, align 8
  %v1131 = add i64 %v1126, 4
  store i64 %v1131, ptr %NEXT_PC, align 8
  %v1132 = load i64, ptr %R8, align 8
  %v1133 = load i64, ptr %RDX, align 8
  %v1134 = mul i64 %v1133, 4
  %v1135 = add i64 %v1132, %v1134
  %v1136 = load ptr, ptr %MEMORY, align 8
  %v1137 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1136, ptr %state, ptr %RDX, i64 %v1135)
  store ptr %v1137, ptr %MEMORY, align 8
  store i64 %v1131, ptr %PC, align 8
  %v1138 = add i64 %v1131, 5
  store i64 %v1138, ptr %NEXT_PC, align 8
  %v1139 = add i64 %v1138, 5836
  %v1140 = load ptr, ptr %MEMORY, align 8
  %v1141 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1140, ptr %state, i64 5389883536, ptr %NEXT_PC, i64 %v1138, ptr %RETURN_PC)
  store ptr %v1141, ptr %MEMORY, align 8
  store i64 %v1138, ptr %PC, align 8
  %v1142 = add i64 %v1138, 3
  store i64 %v1142, ptr %NEXT_PC, align 8
  %v1143 = load i32, ptr %EAX, align 4
  %v1144 = zext i32 %v1143 to i64
  %v1145 = load ptr, ptr %MEMORY, align 8
  %v1146 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1145, ptr %state, i64 %v1144, i64 -1)
  store ptr %v1146, ptr %MEMORY, align 8
  store i64 %v1142, ptr %PC, align 8
  %v1147 = add i64 %v1142, 6
  store i64 %v1147, ptr %NEXT_PC, align 8
  %v1148 = add i64 %v1147, 295
  %v1149 = load ptr, ptr %MEMORY, align 8
  %v1150 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1149, ptr %state, ptr %BRANCH_TAKEN, i64 %v1148, i64 %v1147, ptr %NEXT_PC)
  store ptr %v1150, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878004, label %bb_5389877709

bb_5389877709:                                    ; preds = %bb_5389877686
  store i64 %v1147, ptr %PC, align 8
  %v1151 = add i64 %v1147, 7
  store i64 %v1151, ptr %NEXT_PC, align 8
  %v1152 = load i64, ptr %RDI, align 8
  %v1153 = add i64 %v1152, 256
  %v1154 = load ptr, ptr %MEMORY, align 8
  %v1155 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1154, ptr %state, i64 %v1153, i64 1)
  store ptr %v1155, ptr %MEMORY, align 8
  store i64 %v1151, ptr %PC, align 8
  %v1156 = add i64 %v1151, 2
  store i64 %v1156, ptr %NEXT_PC, align 8
  %v1157 = add i64 %v1156, 31
  %v1158 = load ptr, ptr %MEMORY, align 8
  %v1159 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1158, ptr %state, ptr %BRANCH_TAKEN, i64 %v1157, i64 %v1156, ptr %NEXT_PC)
  store ptr %v1159, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877749, label %bb_5389877718

bb_5389877718:                                    ; preds = %bb_5389877709
  store i64 %v1156, ptr %PC, align 8
  %v1160 = add i64 %v1156, 2
  store i64 %v1160, ptr %NEXT_PC, align 8
  %v1161 = load i32, ptr %EAX, align 4
  %v1162 = zext i32 %v1161 to i64
  %v1163 = load ptr, ptr %MEMORY, align 8
  %v1164 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1163, ptr %state, ptr %RDX, i64 %v1162)
  store ptr %v1164, ptr %MEMORY, align 8
  store i64 %v1160, ptr %PC, align 8
  %v1165 = add i64 %v1160, 3
  store i64 %v1165, ptr %NEXT_PC, align 8
  %v1166 = load i64, ptr %RBX, align 8
  %v1167 = load ptr, ptr %MEMORY, align 8
  %v1168 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1167, ptr %state, ptr %RCX, i64 %v1166)
  store ptr %v1168, ptr %MEMORY, align 8
  store i64 %v1165, ptr %PC, align 8
  %v1169 = add i64 %v1165, 5
  store i64 %v1169, ptr %NEXT_PC, align 8
  %v1170 = add i64 %v1169, 4848
  %v1171 = load ptr, ptr %MEMORY, align 8
  %v1172 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1171, ptr %state, i64 5389882576, ptr %NEXT_PC, i64 %v1169, ptr %RETURN_PC)
  store ptr %v1172, ptr %MEMORY, align 8
  store i64 %v1169, ptr %PC, align 8
  %v1173 = add i64 %v1169, 5
  store i64 %v1173, ptr %NEXT_PC, align 8
  %v1174 = load ptr, ptr %MEMORY, align 8
  %v1175 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1174, ptr %state, ptr %RAX, i64 1)
  store ptr %v1175, ptr %MEMORY, align 8
  store i64 %v1173, ptr %PC, align 8
  %v1176 = add i64 %v1173, 5
  store i64 %v1176, ptr %NEXT_PC, align 8
  %v1177 = load i64, ptr %RSP, align 8
  %v1178 = add i64 %v1177, 104
  %v1179 = load ptr, ptr %MEMORY, align 8
  %v1180 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1179, ptr %state, ptr %RBX, i64 %v1178)
  store ptr %v1180, ptr %MEMORY, align 8
  store i64 %v1176, ptr %PC, align 8
  %v1181 = add i64 %v1176, 5
  store i64 %v1181, ptr %NEXT_PC, align 8
  %v1182 = load i64, ptr %RSP, align 8
  %v1183 = add i64 %v1182, 120
  %v1184 = load ptr, ptr %MEMORY, align 8
  %v1185 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1184, ptr %state, ptr %RBP, i64 %v1183)
  store ptr %v1185, ptr %MEMORY, align 8
  store i64 %v1181, ptr %PC, align 8
  %v1186 = add i64 %v1181, 4
  store i64 %v1186, ptr %NEXT_PC, align 8
  %v1187 = load i64, ptr %RSP, align 8
  %v1188 = load ptr, ptr %MEMORY, align 8
  %v1189 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1188, ptr %state, ptr %RSP, i64 %v1187, i64 80)
  store ptr %v1189, ptr %MEMORY, align 8
  store i64 %v1186, ptr %PC, align 8
  %v1190 = add i64 %v1186, 1
  store i64 %v1190, ptr %NEXT_PC, align 8
  %v1191 = load ptr, ptr %MEMORY, align 8
  %v1192 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1191, ptr %state, ptr %RDI)
  store ptr %v1192, ptr %MEMORY, align 8
  store i64 %v1190, ptr %PC, align 8
  %v1193 = add i64 %v1190, 1
  store i64 %v1193, ptr %NEXT_PC, align 8
  %v1194 = load ptr, ptr %MEMORY, align 8
  %v1195 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1194, ptr %state, ptr %NEXT_PC)
  store ptr %v1195, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877749:                                    ; preds = %bb_5389877709
  store i64 %v1156, ptr %PC, align 8
  %v1196 = add i64 %v1156, 2
  store i64 %v1196, ptr %NEXT_PC, align 8
  %v1197 = load i32, ptr %EAX, align 4
  %v1198 = zext i32 %v1197 to i64
  %v1199 = load i32, ptr %EAX, align 4
  %v1200 = zext i32 %v1199 to i64
  %v1201 = load ptr, ptr %MEMORY, align 8
  %v1202 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1201, ptr %state, i64 %v1198, i64 %v1200)
  store ptr %v1202, ptr %MEMORY, align 8
  store i64 %v1196, ptr %PC, align 8
  %v1203 = add i64 %v1196, 2
  store i64 %v1203, ptr %NEXT_PC, align 8
  %v1204 = add i64 %v1203, 64
  %v1205 = load ptr, ptr %MEMORY, align 8
  %v1206 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1205, ptr %state, ptr %BRANCH_TAKEN, i64 %v1204, i64 %v1203, ptr %NEXT_PC)
  store ptr %v1206, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877817, label %bb_5389877753

bb_5389877753:                                    ; preds = %bb_5389877749
  store i64 %v1203, ptr %PC, align 8
  %v1207 = add i64 %v1203, 3
  store i64 %v1207, ptr %NEXT_PC, align 8
  %v1208 = load i32, ptr %EAX, align 4
  %v1209 = zext i32 %v1208 to i64
  %v1210 = load i64, ptr %RBX, align 8
  %v1211 = add i64 %v1210, 40
  %v1212 = load ptr, ptr %MEMORY, align 8
  %v1213 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1212, ptr %state, i64 %v1209, i64 %v1211)
  store ptr %v1213, ptr %MEMORY, align 8
  store i64 %v1207, ptr %PC, align 8
  %v1214 = add i64 %v1207, 2
  store i64 %v1214, ptr %NEXT_PC, align 8
  %v1215 = add i64 %v1214, 59
  %v1216 = load ptr, ptr %MEMORY, align 8
  %v1217 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1216, ptr %state, ptr %BRANCH_TAKEN, i64 %v1215, i64 %v1214, ptr %NEXT_PC)
  store ptr %v1217, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877817, label %bb_5389877758

bb_5389877758:                                    ; preds = %bb_5389877753
  store i64 %v1214, ptr %PC, align 8
  %v1218 = add i64 %v1214, 4
  store i64 %v1218, ptr %NEXT_PC, align 8
  %v1219 = load i64, ptr %RBX, align 8
  %v1220 = add i64 %v1219, 32
  %v1221 = load ptr, ptr %MEMORY, align 8
  %v1222 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1221, ptr %state, ptr %R8, i64 %v1220)
  store ptr %v1222, ptr %MEMORY, align 8
  store i64 %v1218, ptr %PC, align 8
  %v1223 = add i64 %v1218, 2
  store i64 %v1223, ptr %NEXT_PC, align 8
  %v1224 = load i64, ptr %RBX, align 8
  %v1225 = load i32, ptr %EBX, align 4
  %v1226 = zext i32 %v1225 to i64
  %v1227 = load ptr, ptr %MEMORY, align 8
  %v1228 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1227, ptr %state, ptr %RBX, i64 %v1224, i64 %v1226)
  store ptr %v1228, ptr %MEMORY, align 8
  store i64 %v1223, ptr %PC, align 8
  %v1229 = add i64 %v1223, 4
  store i64 %v1229, ptr %NEXT_PC, align 8
  %v1230 = load i64, ptr %R8, align 8
  %v1231 = load ptr, ptr %MEMORY, align 8
  %v1232 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1231, ptr %state, ptr %R8, i64 %v1230, i64 8)
  store ptr %v1232, ptr %MEMORY, align 8
  store i64 %v1229, ptr %PC, align 8
  %v1233 = add i64 %v1229, 2
  store i64 %v1233, ptr %NEXT_PC, align 8
  %v1234 = load ptr, ptr %MEMORY, align 8
  %v1235 = call ptr @_ZN12_GLOBAL__N_18CDQE_EAXEP6MemoryR5State(ptr %v1234, ptr %state)
  store ptr %v1235, ptr %MEMORY, align 8
  store i64 %v1233, ptr %PC, align 8
  %v1236 = add i64 %v1233, 4
  store i64 %v1236, ptr %NEXT_PC, align 8
  %v1237 = load i64, ptr %RAX, align 8
  %v1238 = load ptr, ptr %MEMORY, align 8
  %v1239 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1238, ptr %state, ptr %RCX, i64 %v1237, i64 56)
  store ptr %v1239, ptr %MEMORY, align 8
  store i64 %v1236, ptr %PC, align 8
  %v1240 = add i64 %v1236, 5
  store i64 %v1240, ptr %NEXT_PC, align 8
  %v1241 = load i64, ptr %RSP, align 8
  %v1242 = add i64 %v1241, 64
  %v1243 = load i64, ptr %RBX, align 8
  %v1244 = load ptr, ptr %MEMORY, align 8
  %v1245 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1244, ptr %state, i64 %v1242, i64 %v1243)
  store ptr %v1245, ptr %MEMORY, align 8
  store i64 %v1240, ptr %PC, align 8
  %v1246 = add i64 %v1240, 3
  store i64 %v1246, ptr %NEXT_PC, align 8
  %v1247 = load i32, ptr %EBX, align 4
  %v1248 = zext i32 %v1247 to i64
  %v1249 = load ptr, ptr %MEMORY, align 8
  %v1250 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1249, ptr %state, ptr %R9, i64 %v1248)
  store ptr %v1250, ptr %MEMORY, align 8
  store i64 %v1246, ptr %PC, align 8
  %v1251 = add i64 %v1246, 3
  store i64 %v1251, ptr %NEXT_PC, align 8
  %v1252 = load i64, ptr %R8, align 8
  %v1253 = load i64, ptr %RCX, align 8
  %v1254 = load ptr, ptr %MEMORY, align 8
  %v1255 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1254, ptr %state, ptr %R8, i64 %v1252, i64 %v1253)
  store ptr %v1255, ptr %MEMORY, align 8
  store i64 %v1251, ptr %PC, align 8
  %v1256 = add i64 %v1251, 4
  store i64 %v1256, ptr %NEXT_PC, align 8
  %v1257 = load i64, ptr %R8, align 8
  %v1258 = add i64 %v1257, 32
  %v1259 = load ptr, ptr %MEMORY, align 8
  %v1260 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1259, ptr %state, ptr %RCX, i64 %v1258)
  store ptr %v1260, ptr %MEMORY, align 8
  store i64 %v1256, ptr %PC, align 8
  %v1261 = add i64 %v1256, 3
  store i64 %v1261, ptr %NEXT_PC, align 8
  %v1262 = load i64, ptr %RCX, align 8
  %v1263 = load i64, ptr %RCX, align 8
  %v1264 = load ptr, ptr %MEMORY, align 8
  %v1265 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1264, ptr %state, i64 %v1262, i64 %v1263)
  store ptr %v1265, ptr %MEMORY, align 8
  store i64 %v1261, ptr %PC, align 8
  %v1266 = add i64 %v1261, 2
  store i64 %v1266, ptr %NEXT_PC, align 8
  %v1267 = add i64 %v1266, 33
  %v1268 = load ptr, ptr %MEMORY, align 8
  %v1269 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1268, ptr %state, ptr %BRANCH_TAKEN, i64 %v1267, i64 %v1266, ptr %NEXT_PC)
  store ptr %v1269, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877827, label %bb_5389877794

bb_5389877794:                                    ; preds = %bb_5389877758
  store i64 %v1266, ptr %PC, align 8
  %v1270 = add i64 %v1266, 5
  store i64 %v1270, ptr %NEXT_PC, align 8
  %v1271 = load i64, ptr %RSP, align 8
  %v1272 = add i64 %v1271, 64
  %v1273 = load i64, ptr %RCX, align 8
  %v1274 = load ptr, ptr %MEMORY, align 8
  %v1275 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1274, ptr %state, i64 %v1272, i64 %v1273)
  store ptr %v1275, ptr %MEMORY, align 8
  store i64 %v1270, ptr %PC, align 8
  %v1276 = add i64 %v1270, 5
  store i64 %v1276, ptr %NEXT_PC, align 8
  %v1277 = load i64, ptr %RSP, align 8
  %v1278 = add i64 %v1277, 32
  %v1279 = load ptr, ptr %MEMORY, align 8
  %v1280 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1279, ptr %state, ptr %RDX, i64 %v1278)
  store ptr %v1280, ptr %MEMORY, align 8
  store i64 %v1276, ptr %PC, align 8
  %v1281 = add i64 %v1276, 3
  store i64 %v1281, ptr %NEXT_PC, align 8
  %v1282 = load i64, ptr %RCX, align 8
  %v1283 = load ptr, ptr %MEMORY, align 8
  %v1284 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1283, ptr %state, ptr %RAX, i64 %v1282)
  store ptr %v1284, ptr %MEMORY, align 8
  store i64 %v1281, ptr %PC, align 8
  %v1285 = add i64 %v1281, 3
  store i64 %v1285, ptr %NEXT_PC, align 8
  %v1286 = load i64, ptr %RAX, align 8
  %v1287 = add i64 %v1286, 8
  %v1288 = load ptr, ptr %MEMORY, align 8
  %v1289 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1288, ptr %state, i64 %v1287, ptr %NEXT_PC, i64 %v1285, ptr %RETURN_PC)
  store ptr %v1289, ptr %MEMORY, align 8
  store i64 %v1285, ptr %PC, align 8
  %v1290 = add i64 %v1285, 5
  store i64 %v1290, ptr %NEXT_PC, align 8
  %v1291 = load i64, ptr %RSP, align 8
  %v1292 = add i64 %v1291, 64
  %v1293 = load ptr, ptr %MEMORY, align 8
  %v1294 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1293, ptr %state, ptr %R9, i64 %v1292)
  store ptr %v1294, ptr %MEMORY, align 8
  store i64 %v1290, ptr %PC, align 8
  %v1295 = add i64 %v1290, 2
  store i64 %v1295, ptr %NEXT_PC, align 8
  %v1296 = add i64 %v1295, 10
  %v1297 = load ptr, ptr %MEMORY, align 8
  %v1298 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v1297, ptr %state, i64 %v1296, ptr %NEXT_PC)
  store ptr %v1298, ptr %MEMORY, align 8
  br label %bb_5389877827

bb_5389877817:                                    ; preds = %bb_5389877753, %bb_5389877749
  %v1299 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1299, ptr %PC, align 8
  %v1300 = add i64 %v1299, 2
  store i64 %v1300, ptr %NEXT_PC, align 8
  %v1301 = load i64, ptr %RBX, align 8
  %v1302 = load i32, ptr %EBX, align 4
  %v1303 = zext i32 %v1302 to i64
  %v1304 = load ptr, ptr %MEMORY, align 8
  %v1305 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1304, ptr %state, ptr %RBX, i64 %v1301, i64 %v1303)
  store ptr %v1305, ptr %MEMORY, align 8
  store i64 %v1300, ptr %PC, align 8
  %v1306 = add i64 %v1300, 3
  store i64 %v1306, ptr %NEXT_PC, align 8
  %v1307 = load i32, ptr %EBX, align 4
  %v1308 = zext i32 %v1307 to i64
  %v1309 = load ptr, ptr %MEMORY, align 8
  %v1310 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1309, ptr %state, ptr %R9, i64 %v1308)
  store ptr %v1310, ptr %MEMORY, align 8
  store i64 %v1306, ptr %PC, align 8
  %v1311 = add i64 %v1306, 5
  store i64 %v1311, ptr %NEXT_PC, align 8
  %v1312 = load i64, ptr %RSP, align 8
  %v1313 = add i64 %v1312, 64
  %v1314 = load i64, ptr %RBX, align 8
  %v1315 = load ptr, ptr %MEMORY, align 8
  %v1316 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1315, ptr %state, i64 %v1313, i64 %v1314)
  store ptr %v1316, ptr %MEMORY, align 8
  br label %bb_5389877827

bb_5389877827:                                    ; preds = %bb_5389877817, %bb_5389877794, %bb_5389877758
  %v1317 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1317, ptr %PC, align 8
  %v1318 = add i64 %v1317, 7
  store i64 %v1318, ptr %NEXT_PC, align 8
  %v1319 = load i64, ptr %R9, align 8
  %v1320 = add i64 %v1318, 27073638
  %v1321 = load ptr, ptr %MEMORY, align 8
  %v1322 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1321, ptr %state, i64 %v1319, i64 %v1320)
  store ptr %v1322, ptr %MEMORY, align 8
  store i64 %v1318, ptr %PC, align 8
  %v1323 = add i64 %v1318, 3
  store i64 %v1323, ptr %NEXT_PC, align 8
  %v1324 = load i64, ptr %RBX, align 8
  %v1325 = load ptr, ptr %MEMORY, align 8
  %v1326 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1325, ptr %state, ptr %RCX, i64 %v1324)
  store ptr %v1326, ptr %MEMORY, align 8
  store i64 %v1323, ptr %PC, align 8
  %v1327 = add i64 %v1323, 5
  store i64 %v1327, ptr %NEXT_PC, align 8
  %v1328 = load i64, ptr %RSP, align 8
  %v1329 = add i64 %v1328, 112
  %v1330 = load i64, ptr %RBX, align 8
  %v1331 = load ptr, ptr %MEMORY, align 8
  %v1332 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1331, ptr %state, i64 %v1329, i64 %v1330)
  store ptr %v1332, ptr %MEMORY, align 8
  store i64 %v1327, ptr %PC, align 8
  %v1333 = add i64 %v1327, 2
  store i64 %v1333, ptr %NEXT_PC, align 8
  %v1334 = add i64 %v1333, 80
  %v1335 = load ptr, ptr %MEMORY, align 8
  %v1336 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1335, ptr %state, ptr %BRANCH_TAKEN, i64 %v1334, i64 %v1333, ptr %NEXT_PC)
  store ptr %v1336, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877924, label %bb_5389877844

bb_5389877844:                                    ; preds = %bb_5389877827
  store i64 %v1333, ptr %PC, align 8
  %v1337 = add i64 %v1333, 3
  store i64 %v1337, ptr %NEXT_PC, align 8
  %v1338 = load i64, ptr %R9, align 8
  %v1339 = load i64, ptr %R9, align 8
  %v1340 = load ptr, ptr %MEMORY, align 8
  %v1341 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1340, ptr %state, i64 %v1338, i64 %v1339)
  store ptr %v1341, ptr %MEMORY, align 8
  store i64 %v1337, ptr %PC, align 8
  %v1342 = add i64 %v1337, 6
  store i64 %v1342, ptr %NEXT_PC, align 8
  %v1343 = add i64 %v1342, 133
  %v1344 = load ptr, ptr %MEMORY, align 8
  %v1345 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1344, ptr %state, ptr %BRANCH_TAKEN, i64 %v1343, i64 %v1342, ptr %NEXT_PC)
  store ptr %v1345, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877853

bb_5389877853:                                    ; preds = %bb_5389877844
  store i64 %v1342, ptr %PC, align 8
  %v1346 = add i64 %v1342, 3
  store i64 %v1346, ptr %NEXT_PC, align 8
  %v1347 = load i64, ptr %R9, align 8
  %v1348 = load ptr, ptr %MEMORY, align 8
  %v1349 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1348, ptr %state, ptr %RAX, i64 %v1347)
  store ptr %v1349, ptr %MEMORY, align 8
  store i64 %v1346, ptr %PC, align 8
  %v1350 = add i64 %v1346, 5
  store i64 %v1350, ptr %NEXT_PC, align 8
  %v1351 = load i64, ptr %RSP, align 8
  %v1352 = add i64 %v1351, 32
  %v1353 = load ptr, ptr %MEMORY, align 8
  %v1354 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1353, ptr %state, ptr %RDX, i64 %v1352)
  store ptr %v1354, ptr %MEMORY, align 8
  store i64 %v1350, ptr %PC, align 8
  %v1355 = add i64 %v1350, 3
  store i64 %v1355, ptr %NEXT_PC, align 8
  %v1356 = load i64, ptr %R9, align 8
  %v1357 = load ptr, ptr %MEMORY, align 8
  %v1358 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1357, ptr %state, ptr %RCX, i64 %v1356)
  store ptr %v1358, ptr %MEMORY, align 8
  store i64 %v1355, ptr %PC, align 8
  %v1359 = add i64 %v1355, 5
  store i64 %v1359, ptr %NEXT_PC, align 8
  %v1360 = load i64, ptr %RSP, align 8
  %v1361 = add i64 %v1360, 96
  %v1362 = load i64, ptr %RSI, align 8
  %v1363 = load ptr, ptr %MEMORY, align 8
  %v1364 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1363, ptr %state, i64 %v1361, i64 %v1362)
  store ptr %v1364, ptr %MEMORY, align 8
  store i64 %v1359, ptr %PC, align 8
  %v1365 = add i64 %v1359, 3
  store i64 %v1365, ptr %NEXT_PC, align 8
  %v1366 = load i64, ptr %RAX, align 8
  %v1367 = add i64 %v1366, 56
  %v1368 = load ptr, ptr %MEMORY, align 8
  %v1369 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1368, ptr %state, i64 %v1367, ptr %NEXT_PC, i64 %v1365, ptr %RETURN_PC)
  store ptr %v1369, ptr %MEMORY, align 8
  store i64 %v1365, ptr %PC, align 8
  %v1370 = add i64 %v1365, 3
  store i64 %v1370, ptr %NEXT_PC, align 8
  %v1371 = load i64, ptr %RAX, align 8
  %v1372 = load ptr, ptr %MEMORY, align 8
  %v1373 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1372, ptr %state, ptr %RSI, i64 %v1371)
  store ptr %v1373, ptr %MEMORY, align 8
  store i64 %v1370, ptr %PC, align 8
  %v1374 = add i64 %v1370, 3
  store i64 %v1374, ptr %NEXT_PC, align 8
  %v1375 = load i64, ptr %RAX, align 8
  %v1376 = load ptr, ptr %MEMORY, align 8
  %v1377 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1376, ptr %state, ptr %RCX, i64 %v1375)
  store ptr %v1377, ptr %MEMORY, align 8
  store i64 %v1374, ptr %PC, align 8
  %v1378 = add i64 %v1374, 3
  store i64 %v1378, ptr %NEXT_PC, align 8
  %v1379 = load i64, ptr %RCX, align 8
  %v1380 = load i64, ptr %RCX, align 8
  %v1381 = load ptr, ptr %MEMORY, align 8
  %v1382 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1381, ptr %state, i64 %v1379, i64 %v1380)
  store ptr %v1382, ptr %MEMORY, align 8
  store i64 %v1378, ptr %PC, align 8
  %v1383 = add i64 %v1378, 2
  store i64 %v1383, ptr %NEXT_PC, align 8
  %v1384 = add i64 %v1383, 8
  %v1385 = load ptr, ptr %MEMORY, align 8
  %v1386 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1385, ptr %state, ptr %BRANCH_TAKEN, i64 %v1384, i64 %v1383, ptr %NEXT_PC)
  store ptr %v1386, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877891, label %bb_5389877883

bb_5389877883:                                    ; preds = %bb_5389877853
  store i64 %v1383, ptr %PC, align 8
  %v1387 = add i64 %v1383, 2
  store i64 %v1387, ptr %NEXT_PC, align 8
  %v1388 = load i64, ptr %RCX, align 8
  %v1389 = load i64, ptr %RCX, align 8
  %v1390 = load ptr, ptr %MEMORY, align 8
  %v1391 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1390, ptr %state, i64 %v1388, i64 %v1389)
  store ptr %v1391, ptr %MEMORY, align 8
  store i64 %v1387, ptr %PC, align 8
  %v1392 = add i64 %v1387, 4
  store i64 %v1392, ptr %NEXT_PC, align 8
  %v1393 = load i64, ptr %RCX, align 8
  %v1394 = add i64 %v1393, 48
  %v1395 = load ptr, ptr %MEMORY, align 8
  %v1396 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1395, ptr %state, ptr %RCX, i64 %v1394)
  store ptr %v1396, ptr %MEMORY, align 8
  store i64 %v1392, ptr %PC, align 8
  %v1397 = add i64 %v1392, 2
  store i64 %v1397, ptr %NEXT_PC, align 8
  %v1398 = load i64, ptr %RCX, align 8
  %v1399 = load i64, ptr %RCX, align 8
  %v1400 = load ptr, ptr %MEMORY, align 8
  %v1401 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1400, ptr %state, i64 %v1398, i64 %v1399)
  store ptr %v1401, ptr %MEMORY, align 8
  br label %bb_5389877891

bb_5389877891:                                    ; preds = %bb_5389877883, %bb_5389877853
  %v1402 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1402, ptr %PC, align 8
  %v1403 = add i64 %v1402, 5
  store i64 %v1403, ptr %NEXT_PC, align 8
  %v1404 = load i64, ptr %RSP, align 8
  %v1405 = add i64 %v1404, 112
  %v1406 = load ptr, ptr %MEMORY, align 8
  %v1407 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1406, ptr %state, ptr %RCX, i64 %v1405)
  store ptr %v1407, ptr %MEMORY, align 8
  store i64 %v1403, ptr %PC, align 8
  %v1408 = add i64 %v1403, 3
  store i64 %v1408, ptr %NEXT_PC, align 8
  %v1409 = load i64, ptr %RCX, align 8
  %v1410 = load i64, ptr %RCX, align 8
  %v1411 = load ptr, ptr %MEMORY, align 8
  %v1412 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1411, ptr %state, i64 %v1409, i64 %v1410)
  store ptr %v1412, ptr %MEMORY, align 8
  store i64 %v1408, ptr %PC, align 8
  %v1413 = add i64 %v1408, 2
  store i64 %v1413, ptr %NEXT_PC, align 8
  %v1414 = add i64 %v1413, 5
  %v1415 = load ptr, ptr %MEMORY, align 8
  %v1416 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1415, ptr %state, ptr %BRANCH_TAKEN, i64 %v1414, i64 %v1413, ptr %NEXT_PC)
  store ptr %v1416, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877906, label %bb_5389877901

bb_5389877901:                                    ; preds = %bb_5389877891
  store i64 %v1413, ptr %PC, align 8
  %v1417 = add i64 %v1413, 5
  store i64 %v1417, ptr %NEXT_PC, align 8
  %v1418 = sub i64 %v1417, 1202
  %v1419 = load ptr, ptr %MEMORY, align 8
  %v1420 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1419, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v1417, ptr %RETURN_PC)
  store ptr %v1420, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877906:                                    ; preds = %bb_5389877891
  store i64 %v1413, ptr %PC, align 8
  %v1421 = add i64 %v1413, 3
  store i64 %v1421, ptr %NEXT_PC, align 8
  %v1422 = load i64, ptr %RSI, align 8
  %v1423 = load ptr, ptr %MEMORY, align 8
  %v1424 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1423, ptr %state, ptr %RCX, i64 %v1422)
  store ptr %v1424, ptr %MEMORY, align 8
  store i64 %v1421, ptr %PC, align 8
  %v1425 = add i64 %v1421, 5
  store i64 %v1425, ptr %NEXT_PC, align 8
  %v1426 = load i64, ptr %RSP, align 8
  %v1427 = add i64 %v1426, 64
  %v1428 = load ptr, ptr %MEMORY, align 8
  %v1429 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1428, ptr %state, ptr %R9, i64 %v1427)
  store ptr %v1429, ptr %MEMORY, align 8
  store i64 %v1425, ptr %PC, align 8
  %v1430 = add i64 %v1425, 5
  store i64 %v1430, ptr %NEXT_PC, align 8
  %v1431 = load i64, ptr %RSP, align 8
  %v1432 = add i64 %v1431, 96
  %v1433 = load ptr, ptr %MEMORY, align 8
  %v1434 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1433, ptr %state, ptr %RSI, i64 %v1432)
  store ptr %v1434, ptr %MEMORY, align 8
  store i64 %v1430, ptr %PC, align 8
  %v1435 = add i64 %v1430, 5
  store i64 %v1435, ptr %NEXT_PC, align 8
  %v1436 = load i64, ptr %RSP, align 8
  %v1437 = add i64 %v1436, 112
  %v1438 = load i64, ptr %RCX, align 8
  %v1439 = load ptr, ptr %MEMORY, align 8
  %v1440 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1439, ptr %state, i64 %v1437, i64 %v1438)
  store ptr %v1440, ptr %MEMORY, align 8
  br label %bb_5389877924

bb_5389877924:                                    ; preds = %bb_5389877906, %bb_5389877827
  %v1441 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1441, ptr %PC, align 8
  %v1442 = add i64 %v1441, 3
  store i64 %v1442, ptr %NEXT_PC, align 8
  %v1443 = load i64, ptr %R9, align 8
  %v1444 = load i64, ptr %R9, align 8
  %v1445 = load ptr, ptr %MEMORY, align 8
  %v1446 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1445, ptr %state, i64 %v1443, i64 %v1444)
  store ptr %v1446, ptr %MEMORY, align 8
  store i64 %v1442, ptr %PC, align 8
  %v1447 = add i64 %v1442, 2
  store i64 %v1447, ptr %NEXT_PC, align 8
  %v1448 = add i64 %v1447, 19
  %v1449 = load ptr, ptr %MEMORY, align 8
  %v1450 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1449, ptr %state, ptr %BRANCH_TAKEN, i64 %v1448, i64 %v1447, ptr %NEXT_PC)
  store ptr %v1450, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877948, label %bb_5389877929

bb_5389877929:                                    ; preds = %bb_5389877924
  store i64 %v1447, ptr %PC, align 8
  %v1451 = add i64 %v1447, 3
  store i64 %v1451, ptr %NEXT_PC, align 8
  %v1452 = load i64, ptr %R9, align 8
  %v1453 = load ptr, ptr %MEMORY, align 8
  %v1454 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1453, ptr %state, ptr %RAX, i64 %v1452)
  store ptr %v1454, ptr %MEMORY, align 8
  store i64 %v1451, ptr %PC, align 8
  %v1455 = add i64 %v1451, 5
  store i64 %v1455, ptr %NEXT_PC, align 8
  %v1456 = load i64, ptr %RSP, align 8
  %v1457 = add i64 %v1456, 32
  %v1458 = load ptr, ptr %MEMORY, align 8
  %v1459 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1458, ptr %state, ptr %RDX, i64 %v1457)
  store ptr %v1459, ptr %MEMORY, align 8
  store i64 %v1455, ptr %PC, align 8
  %v1460 = add i64 %v1455, 3
  store i64 %v1460, ptr %NEXT_PC, align 8
  %v1461 = load i64, ptr %R9, align 8
  %v1462 = load ptr, ptr %MEMORY, align 8
  %v1463 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1462, ptr %state, ptr %RCX, i64 %v1461)
  store ptr %v1463, ptr %MEMORY, align 8
  store i64 %v1460, ptr %PC, align 8
  %v1464 = add i64 %v1460, 3
  store i64 %v1464, ptr %NEXT_PC, align 8
  %v1465 = load i64, ptr %RAX, align 8
  %v1466 = add i64 %v1465, 24
  %v1467 = load ptr, ptr %MEMORY, align 8
  %v1468 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1467, ptr %state, i64 %v1466, ptr %NEXT_PC, i64 %v1464, ptr %RETURN_PC)
  store ptr %v1468, ptr %MEMORY, align 8
  store i64 %v1464, ptr %PC, align 8
  %v1469 = add i64 %v1464, 5
  store i64 %v1469, ptr %NEXT_PC, align 8
  %v1470 = load i64, ptr %RSP, align 8
  %v1471 = add i64 %v1470, 112
  %v1472 = load ptr, ptr %MEMORY, align 8
  %v1473 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1472, ptr %state, ptr %RCX, i64 %v1471)
  store ptr %v1473, ptr %MEMORY, align 8
  br label %bb_5389877948

bb_5389877948:                                    ; preds = %bb_5389877929, %bb_5389877924
  %v1474 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1474, ptr %PC, align 8
  %v1475 = add i64 %v1474, 3
  store i64 %v1475, ptr %NEXT_PC, align 8
  %v1476 = load i64, ptr %RCX, align 8
  %v1477 = load i64, ptr %RCX, align 8
  %v1478 = load ptr, ptr %MEMORY, align 8
  %v1479 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1478, ptr %state, i64 %v1476, i64 %v1477)
  store ptr %v1479, ptr %MEMORY, align 8
  store i64 %v1475, ptr %PC, align 8
  %v1480 = add i64 %v1475, 2
  store i64 %v1480, ptr %NEXT_PC, align 8
  %v1481 = add i64 %v1480, 33
  %v1482 = load ptr, ptr %MEMORY, align 8
  %v1483 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1482, ptr %state, ptr %BRANCH_TAKEN, i64 %v1481, i64 %v1480, ptr %NEXT_PC)
  store ptr %v1483, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877953

bb_5389877953:                                    ; preds = %bb_5389877948
  store i64 %v1480, ptr %PC, align 8
  %v1484 = add i64 %v1480, 6
  store i64 %v1484, ptr %NEXT_PC, align 8
  %v1485 = load i64, ptr %RDI, align 8
  %v1486 = add i64 %v1485, 256
  %v1487 = load i64, ptr %RDI, align 8
  %v1488 = add i64 %v1487, 256
  %v1489 = load ptr, ptr %MEMORY, align 8
  %v1490 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1489, ptr %state, i64 %v1486, i64 %v1488)
  store ptr %v1490, ptr %MEMORY, align 8
  store i64 %v1484, ptr %PC, align 8
  %v1491 = add i64 %v1484, 3
  store i64 %v1491, ptr %NEXT_PC, align 8
  %v1492 = load i64, ptr %RDI, align 8
  %v1493 = load ptr, ptr %MEMORY, align 8
  %v1494 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1493, ptr %state, ptr %R8, i64 %v1492)
  store ptr %v1494, ptr %MEMORY, align 8
  store i64 %v1491, ptr %PC, align 8
  %v1495 = add i64 %v1491, 2
  store i64 %v1495, ptr %NEXT_PC, align 8
  %v1496 = load i32, ptr %EBP, align 4
  %v1497 = zext i32 %v1496 to i64
  %v1498 = load ptr, ptr %MEMORY, align 8
  %v1499 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1498, ptr %state, ptr %RDX, i64 %v1497)
  store ptr %v1499, ptr %MEMORY, align 8
  store i64 %v1495, ptr %PC, align 8
  %v1500 = add i64 %v1495, 5
  store i64 %v1500, ptr %NEXT_PC, align 8
  %v1501 = sub i64 %v1500, 321
  %v1502 = load ptr, ptr %MEMORY, align 8
  %v1503 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1502, ptr %state, i64 5389877648, ptr %NEXT_PC, i64 %v1500, ptr %RETURN_PC)
  store ptr %v1503, ptr %MEMORY, align 8
  store i64 %v1500, ptr %PC, align 8
  %v1504 = add i64 %v1500, 5
  store i64 %v1504, ptr %NEXT_PC, align 8
  %v1505 = load i64, ptr %RSP, align 8
  %v1506 = add i64 %v1505, 112
  %v1507 = load ptr, ptr %MEMORY, align 8
  %v1508 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1507, ptr %state, ptr %RCX, i64 %v1506)
  store ptr %v1508, ptr %MEMORY, align 8
  store i64 %v1504, ptr %PC, align 8
  %v1509 = add i64 %v1504, 2
  store i64 %v1509, ptr %NEXT_PC, align 8
  %v1510 = load i32, ptr %EAX, align 4
  %v1511 = zext i32 %v1510 to i64
  %v1512 = load ptr, ptr %MEMORY, align 8
  %v1513 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1512, ptr %state, ptr %RBX, i64 %v1511)
  store ptr %v1513, ptr %MEMORY, align 8
  store i64 %v1509, ptr %PC, align 8
  %v1514 = add i64 %v1509, 3
  store i64 %v1514, ptr %NEXT_PC, align 8
  %v1515 = load i64, ptr %RCX, align 8
  %v1516 = load i64, ptr %RCX, align 8
  %v1517 = load ptr, ptr %MEMORY, align 8
  %v1518 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1517, ptr %state, i64 %v1515, i64 %v1516)
  store ptr %v1518, ptr %MEMORY, align 8
  store i64 %v1514, ptr %PC, align 8
  %v1519 = add i64 %v1514, 2
  store i64 %v1519, ptr %NEXT_PC, align 8
  %v1520 = add i64 %v1519, 5
  %v1521 = load ptr, ptr %MEMORY, align 8
  %v1522 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1521, ptr %state, ptr %BRANCH_TAKEN, i64 %v1520, i64 %v1519, ptr %NEXT_PC)
  store ptr %v1522, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877981

bb_5389877981:                                    ; preds = %bb_5389877953
  store i64 %v1519, ptr %PC, align 8
  %v1523 = add i64 %v1519, 5
  store i64 %v1523, ptr %NEXT_PC, align 8
  %v1524 = sub i64 %v1523, 1282
  %v1525 = load ptr, ptr %MEMORY, align 8
  %v1526 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1525, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v1523, ptr %RETURN_PC)
  store ptr %v1526, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877986:                                    ; preds = %bb_5389877953, %bb_5389877948, %bb_5389877844
  %v1527 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1527, ptr %PC, align 8
  %v1528 = add i64 %v1527, 2
  store i64 %v1528, ptr %NEXT_PC, align 8
  %v1529 = load i32, ptr %EBX, align 4
  %v1530 = zext i32 %v1529 to i64
  %v1531 = load ptr, ptr %MEMORY, align 8
  %v1532 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1531, ptr %state, ptr %RAX, i64 %v1530)
  store ptr %v1532, ptr %MEMORY, align 8
  store i64 %v1528, ptr %PC, align 8
  %v1533 = add i64 %v1528, 5
  store i64 %v1533, ptr %NEXT_PC, align 8
  %v1534 = load i64, ptr %RSP, align 8
  %v1535 = add i64 %v1534, 104
  %v1536 = load ptr, ptr %MEMORY, align 8
  %v1537 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1536, ptr %state, ptr %RBX, i64 %v1535)
  store ptr %v1537, ptr %MEMORY, align 8
  store i64 %v1533, ptr %PC, align 8
  %v1538 = add i64 %v1533, 5
  store i64 %v1538, ptr %NEXT_PC, align 8
  %v1539 = load i64, ptr %RSP, align 8
  %v1540 = add i64 %v1539, 120
  %v1541 = load ptr, ptr %MEMORY, align 8
  %v1542 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1541, ptr %state, ptr %RBP, i64 %v1540)
  store ptr %v1542, ptr %MEMORY, align 8
  store i64 %v1538, ptr %PC, align 8
  %v1543 = add i64 %v1538, 4
  store i64 %v1543, ptr %NEXT_PC, align 8
  %v1544 = load i64, ptr %RSP, align 8
  %v1545 = load ptr, ptr %MEMORY, align 8
  %v1546 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1545, ptr %state, ptr %RSP, i64 %v1544, i64 80)
  store ptr %v1546, ptr %MEMORY, align 8
  store i64 %v1543, ptr %PC, align 8
  %v1547 = add i64 %v1543, 1
  store i64 %v1547, ptr %NEXT_PC, align 8
  %v1548 = load ptr, ptr %MEMORY, align 8
  %v1549 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1548, ptr %state, ptr %RDI)
  store ptr %v1549, ptr %MEMORY, align 8
  store i64 %v1547, ptr %PC, align 8
  %v1550 = add i64 %v1547, 1
  store i64 %v1550, ptr %NEXT_PC, align 8
  %v1551 = load ptr, ptr %MEMORY, align 8
  %v1552 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1551, ptr %state, ptr %NEXT_PC)
  store ptr %v1552, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878004:                                    ; preds = %bb_5389877686, %bb_5389877636
  %v1553 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1553, ptr %PC, align 8
  %v1554 = add i64 %v1553, 5
  store i64 %v1554, ptr %NEXT_PC, align 8
  %v1555 = load i64, ptr %RSP, align 8
  %v1556 = add i64 %v1555, 104
  %v1557 = load ptr, ptr %MEMORY, align 8
  %v1558 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1557, ptr %state, ptr %RBX, i64 %v1556)
  store ptr %v1558, ptr %MEMORY, align 8
  store i64 %v1554, ptr %PC, align 8
  %v1559 = add i64 %v1554, 2
  store i64 %v1559, ptr %NEXT_PC, align 8
  %v1560 = load i64, ptr %RAX, align 8
  %v1561 = load i32, ptr %EAX, align 4
  %v1562 = zext i32 %v1561 to i64
  %v1563 = load ptr, ptr %MEMORY, align 8
  %v1564 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1563, ptr %state, ptr %RAX, i64 %v1560, i64 %v1562)
  store ptr %v1564, ptr %MEMORY, align 8
  store i64 %v1559, ptr %PC, align 8
  %v1565 = add i64 %v1559, 5
  store i64 %v1565, ptr %NEXT_PC, align 8
  %v1566 = load i64, ptr %RSP, align 8
  %v1567 = add i64 %v1566, 120
  %v1568 = load ptr, ptr %MEMORY, align 8
  %v1569 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1568, ptr %state, ptr %RBP, i64 %v1567)
  store ptr %v1569, ptr %MEMORY, align 8
  store i64 %v1565, ptr %PC, align 8
  %v1570 = add i64 %v1565, 4
  store i64 %v1570, ptr %NEXT_PC, align 8
  %v1571 = load i64, ptr %RSP, align 8
  %v1572 = load ptr, ptr %MEMORY, align 8
  %v1573 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1572, ptr %state, ptr %RSP, i64 %v1571, i64 80)
  store ptr %v1573, ptr %MEMORY, align 8
  store i64 %v1570, ptr %PC, align 8
  %v1574 = add i64 %v1570, 1
  store i64 %v1574, ptr %NEXT_PC, align 8
  %v1575 = load ptr, ptr %MEMORY, align 8
  %v1576 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1575, ptr %state, ptr %RDI)
  store ptr %v1576, ptr %MEMORY, align 8
  store i64 %v1574, ptr %PC, align 8
  %v1577 = add i64 %v1574, 1
  store i64 %v1577, ptr %NEXT_PC, align 8
  %v1578 = load ptr, ptr %MEMORY, align 8
  %v1579 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1578, ptr %state, ptr %NEXT_PC)
  store ptr %v1579, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878022:                                    ; No predecessors!
  %v1580 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1580, ptr %PC, align 8
  %v1581 = add i64 %v1580, 1
  store i64 %v1581, ptr %NEXT_PC, align 8
  %v1582 = load ptr, ptr %MEMORY, align 8
  %v1583 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1582, ptr %state, ptr undef)
  store ptr %v1583, ptr %MEMORY, align 8
  store i64 %v1581, ptr %PC, align 8
  %v1584 = add i64 %v1581, 1
  store i64 %v1584, ptr %NEXT_PC, align 8
  %v1585 = load ptr, ptr %MEMORY, align 8
  %v1586 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1585, ptr %state, ptr undef)
  store ptr %v1586, ptr %MEMORY, align 8
  store i64 %v1584, ptr %PC, align 8
  %v1587 = add i64 %v1584, 1
  store i64 %v1587, ptr %NEXT_PC, align 8
  %v1588 = load ptr, ptr %MEMORY, align 8
  %v1589 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1588, ptr %state, ptr undef)
  store ptr %v1589, ptr %MEMORY, align 8
  store i64 %v1587, ptr %PC, align 8
  %v1590 = add i64 %v1587, 1
  store i64 %v1590, ptr %NEXT_PC, align 8
  %v1591 = load ptr, ptr %MEMORY, align 8
  %v1592 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1591, ptr %state, ptr undef)
  store ptr %v1592, ptr %MEMORY, align 8
  store i64 %v1590, ptr %PC, align 8
  %v1593 = add i64 %v1590, 1
  store i64 %v1593, ptr %NEXT_PC, align 8
  %v1594 = load ptr, ptr %MEMORY, align 8
  %v1595 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1594, ptr %state, ptr undef)
  store ptr %v1595, ptr %MEMORY, align 8
  store i64 %v1593, ptr %PC, align 8
  %v1596 = add i64 %v1593, 1
  store i64 %v1596, ptr %NEXT_PC, align 8
  %v1597 = load ptr, ptr %MEMORY, align 8
  %v1598 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1597, ptr %state, ptr undef)
  store ptr %v1598, ptr %MEMORY, align 8
  store i64 %v1596, ptr %PC, align 8
  %v1599 = add i64 %v1596, 1
  store i64 %v1599, ptr %NEXT_PC, align 8
  %v1600 = load ptr, ptr %MEMORY, align 8
  %v1601 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1600, ptr %state, ptr undef)
  store ptr %v1601, ptr %MEMORY, align 8
  store i64 %v1599, ptr %PC, align 8
  %v1602 = add i64 %v1599, 1
  store i64 %v1602, ptr %NEXT_PC, align 8
  %v1603 = load ptr, ptr %MEMORY, align 8
  %v1604 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1603, ptr %state, ptr undef)
  store ptr %v1604, ptr %MEMORY, align 8
  store i64 %v1602, ptr %PC, align 8
  %v1605 = add i64 %v1602, 1
  store i64 %v1605, ptr %NEXT_PC, align 8
  %v1606 = load ptr, ptr %MEMORY, align 8
  %v1607 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1606, ptr %state, ptr undef)
  store ptr %v1607, ptr %MEMORY, align 8
  store i64 %v1605, ptr %PC, align 8
  %v1608 = add i64 %v1605, 1
  store i64 %v1608, ptr %NEXT_PC, align 8
  %v1609 = load ptr, ptr %MEMORY, align 8
  %v1610 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1609, ptr %state, ptr undef)
  store ptr %v1610, ptr %MEMORY, align 8
  store i64 %v1608, ptr %PC, align 8
  %v1611 = add i64 %v1608, 5
  store i64 %v1611, ptr %NEXT_PC, align 8
  %v1612 = load i64, ptr %RSP, align 8
  %v1613 = add i64 %v1612, 8
  %v1614 = load i64, ptr %RBX, align 8
  %v1615 = load ptr, ptr %MEMORY, align 8
  %v1616 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1615, ptr %state, i64 %v1613, i64 %v1614)
  store ptr %v1616, ptr %MEMORY, align 8
  store i64 %v1611, ptr %PC, align 8
  %v1617 = add i64 %v1611, 5
  store i64 %v1617, ptr %NEXT_PC, align 8
  %v1618 = load i64, ptr %RSP, align 8
  %v1619 = add i64 %v1618, 16
  %v1620 = load i64, ptr %RSI, align 8
  %v1621 = load ptr, ptr %MEMORY, align 8
  %v1622 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1621, ptr %state, i64 %v1619, i64 %v1620)
  store ptr %v1622, ptr %MEMORY, align 8
  store i64 %v1617, ptr %PC, align 8
  %v1623 = add i64 %v1617, 1
  store i64 %v1623, ptr %NEXT_PC, align 8
  %v1624 = load i64, ptr %RDI, align 8
  %v1625 = load ptr, ptr %MEMORY, align 8
  %v1626 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1625, ptr %state, i64 %v1624)
  store ptr %v1626, ptr %MEMORY, align 8
  store i64 %v1623, ptr %PC, align 8
  %v1627 = add i64 %v1623, 4
  store i64 %v1627, ptr %NEXT_PC, align 8
  %v1628 = load i64, ptr %RSP, align 8
  %v1629 = load ptr, ptr %MEMORY, align 8
  %v1630 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1629, ptr %state, ptr %RSP, i64 %v1628, i64 32)
  store ptr %v1630, ptr %MEMORY, align 8
  store i64 %v1627, ptr %PC, align 8
  %v1631 = add i64 %v1627, 3
  store i64 %v1631, ptr %NEXT_PC, align 8
  %v1632 = load i64, ptr %RCX, align 8
  %v1633 = add i64 %v1632, 24
  %v1634 = load ptr, ptr %MEMORY, align 8
  %v1635 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1634, ptr %state, ptr %RDX, i64 %v1633)
  store ptr %v1635, ptr %MEMORY, align 8
  store i64 %v1631, ptr %PC, align 8
  %v1636 = add i64 %v1631, 2
  store i64 %v1636, ptr %NEXT_PC, align 8
  %v1637 = load i64, ptr %RSI, align 8
  %v1638 = load i32, ptr %ESI, align 4
  %v1639 = zext i32 %v1638 to i64
  %v1640 = load ptr, ptr %MEMORY, align 8
  %v1641 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1640, ptr %state, ptr %RSI, i64 %v1637, i64 %v1639)
  store ptr %v1641, ptr %MEMORY, align 8
  store i64 %v1636, ptr %PC, align 8
  %v1642 = add i64 %v1636, 3
  store i64 %v1642, ptr %NEXT_PC, align 8
  %v1643 = load i64, ptr %RCX, align 8
  %v1644 = load ptr, ptr %MEMORY, align 8
  %v1645 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1644, ptr %state, ptr %RDI, i64 %v1643)
  store ptr %v1645, ptr %MEMORY, align 8
  store i64 %v1642, ptr %PC, align 8
  %v1646 = add i64 %v1642, 2
  store i64 %v1646, ptr %NEXT_PC, align 8
  %v1647 = load i32, ptr %EDX, align 4
  %v1648 = zext i32 %v1647 to i64
  %v1649 = load i32, ptr %EDX, align 4
  %v1650 = zext i32 %v1649 to i64
  %v1651 = load ptr, ptr %MEMORY, align 8
  %v1652 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1651, ptr %state, i64 %v1648, i64 %v1650)
  store ptr %v1652, ptr %MEMORY, align 8
  store i64 %v1646, ptr %PC, align 8
  %v1653 = add i64 %v1646, 2
  store i64 %v1653, ptr %NEXT_PC, align 8
  %v1654 = add i64 %v1653, 23
  %v1655 = load ptr, ptr %MEMORY, align 8
  %v1656 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1655, ptr %state, ptr %BRANCH_TAKEN, i64 %v1654, i64 %v1653, ptr %NEXT_PC)
  store ptr %v1656, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878082, label %bb_5389878059

bb_5389878059:                                    ; preds = %bb_5389878022
  store i64 %v1653, ptr %PC, align 8
  %v1657 = add i64 %v1653, 4
  store i64 %v1657, ptr %NEXT_PC, align 8
  %v1658 = load i64, ptr %RCX, align 8
  %v1659 = add i64 %v1658, 16
  %v1660 = load ptr, ptr %MEMORY, align 8
  %v1661 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1660, ptr %state, ptr %RCX, i64 %v1659)
  store ptr %v1661, ptr %MEMORY, align 8
  store i64 %v1657, ptr %PC, align 8
  %v1662 = add i64 %v1657, 3
  store i64 %v1662, ptr %NEXT_PC, align 8
  %v1663 = load i64, ptr %RCX, align 8
  %v1664 = load i64, ptr %RCX, align 8
  %v1665 = load ptr, ptr %MEMORY, align 8
  %v1666 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1665, ptr %state, i64 %v1663, i64 %v1664)
  store ptr %v1666, ptr %MEMORY, align 8
  store i64 %v1662, ptr %PC, align 8
  %v1667 = add i64 %v1662, 2
  store i64 %v1667, ptr %NEXT_PC, align 8
  %v1668 = add i64 %v1667, 9
  %v1669 = load ptr, ptr %MEMORY, align 8
  %v1670 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1669, ptr %state, ptr %BRANCH_TAKEN, i64 %v1668, i64 %v1667, ptr %NEXT_PC)
  store ptr %v1670, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878077, label %bb_5389878068

bb_5389878068:                                    ; preds = %bb_5389878059
  store i64 %v1667, ptr %PC, align 8
  %v1671 = add i64 %v1667, 5
  store i64 %v1671, ptr %NEXT_PC, align 8
  %v1672 = sub i64 %v1671, 1157081
  %v1673 = load ptr, ptr %MEMORY, align 8
  %v1674 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1673, ptr %state, i64 5388720992, ptr %NEXT_PC, i64 %v1671, ptr %RETURN_PC)
  store ptr %v1674, ptr %MEMORY, align 8
  store i64 %v1671, ptr %PC, align 8
  %v1675 = add i64 %v1671, 4
  store i64 %v1675, ptr %NEXT_PC, align 8
  %v1676 = load i64, ptr %RDI, align 8
  %v1677 = add i64 %v1676, 16
  %v1678 = load i64, ptr %RSI, align 8
  %v1679 = load ptr, ptr %MEMORY, align 8
  %v1680 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1679, ptr %state, i64 %v1677, i64 %v1678)
  store ptr %v1680, ptr %MEMORY, align 8
  br label %bb_5389878077

bb_5389878077:                                    ; preds = %bb_5389878068, %bb_5389878059
  %v1681 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1681, ptr %PC, align 8
  %v1682 = add i64 %v1681, 3
  store i64 %v1682, ptr %NEXT_PC, align 8
  %v1683 = load i64, ptr %RDI, align 8
  %v1684 = add i64 %v1683, 28
  %v1685 = load i32, ptr %ESI, align 4
  %v1686 = zext i32 %v1685 to i64
  %v1687 = load ptr, ptr %MEMORY, align 8
  %v1688 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1687, ptr %state, i64 %v1684, i64 %v1686)
  store ptr %v1688, ptr %MEMORY, align 8
  store i64 %v1682, ptr %PC, align 8
  %v1689 = add i64 %v1682, 2
  store i64 %v1689, ptr %NEXT_PC, align 8
  %v1690 = add i64 %v1689, 20
  %v1691 = load ptr, ptr %MEMORY, align 8
  %v1692 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v1691, ptr %state, i64 %v1690, ptr %NEXT_PC)
  store ptr %v1692, ptr %MEMORY, align 8
  br label %bb_5389878102

bb_5389878082:                                    ; preds = %bb_5389878022
  store i64 %v1653, ptr %PC, align 8
  %v1693 = add i64 %v1653, 3
  store i64 %v1693, ptr %NEXT_PC, align 8
  %v1694 = load i64, ptr %RCX, align 8
  %v1695 = add i64 %v1694, 28
  %v1696 = load i32, ptr %EDX, align 4
  %v1697 = zext i32 %v1696 to i64
  %v1698 = load ptr, ptr %MEMORY, align 8
  %v1699 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1698, ptr %state, i64 %v1695, i64 %v1697)
  store ptr %v1699, ptr %MEMORY, align 8
  store i64 %v1693, ptr %PC, align 8
  %v1700 = add i64 %v1693, 2
  store i64 %v1700, ptr %NEXT_PC, align 8
  %v1701 = add i64 %v1700, 15
  %v1702 = load ptr, ptr %MEMORY, align 8
  %v1703 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1702, ptr %state, ptr %BRANCH_TAKEN, i64 %v1701, i64 %v1700, ptr %NEXT_PC)
  store ptr %v1703, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878102, label %bb_5389878087

bb_5389878087:                                    ; preds = %bb_5389878082
  store i64 %v1700, ptr %PC, align 8
  %v1704 = add i64 %v1700, 6
  store i64 %v1704, ptr %NEXT_PC, align 8
  %v1705 = load ptr, ptr %MEMORY, align 8
  %v1706 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1705, ptr %state, ptr %R8, i64 134217736)
  store ptr %v1706, ptr %MEMORY, align 8
  store i64 %v1704, ptr %PC, align 8
  %v1707 = add i64 %v1704, 4
  store i64 %v1707, ptr %NEXT_PC, align 8
  %v1708 = load i64, ptr %RCX, align 8
  %v1709 = load ptr, ptr %MEMORY, align 8
  %v1710 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1709, ptr %state, ptr %RCX, i64 %v1708, i64 16)
  store ptr %v1710, ptr %MEMORY, align 8
  store i64 %v1707, ptr %PC, align 8
  %v1711 = add i64 %v1707, 5
  store i64 %v1711, ptr %NEXT_PC, align 8
  %v1712 = sub i64 %v1711, 644470
  %v1713 = load ptr, ptr %MEMORY, align 8
  %v1714 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1713, ptr %state, i64 5389233632, ptr %NEXT_PC, i64 %v1711, ptr %RETURN_PC)
  store ptr %v1714, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878102:                                    ; preds = %bb_5389878082, %bb_5389878077
  %v1715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1715, ptr %PC, align 8
  %v1716 = add i64 %v1715, 3
  store i64 %v1716, ptr %NEXT_PC, align 8
  %v1717 = load i64, ptr %RDI, align 8
  %v1718 = add i64 %v1717, 40
  %v1719 = load ptr, ptr %MEMORY, align 8
  %v1720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1719, ptr %state, ptr %RDX, i64 %v1718)
  store ptr %v1720, ptr %MEMORY, align 8
  store i64 %v1716, ptr %PC, align 8
  %v1721 = add i64 %v1716, 2
  store i64 %v1721, ptr %NEXT_PC, align 8
  %v1722 = load i32, ptr %EDX, align 4
  %v1723 = zext i32 %v1722 to i64
  %v1724 = load i32, ptr %EDX, align 4
  %v1725 = zext i32 %v1724 to i64
  %v1726 = load ptr, ptr %MEMORY, align 8
  %v1727 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1726, ptr %state, i64 %v1723, i64 %v1725)
  store ptr %v1727, ptr %MEMORY, align 8
  store i64 %v1721, ptr %PC, align 8
  %v1728 = add i64 %v1721, 2
  store i64 %v1728, ptr %NEXT_PC, align 8
  %v1729 = add i64 %v1728, 37
  %v1730 = load ptr, ptr %MEMORY, align 8
  %v1731 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1730, ptr %state, ptr %BRANCH_TAKEN, i64 %v1729, i64 %v1728, ptr %NEXT_PC)
  store ptr %v1731, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878146, label %bb_5389878109

bb_5389878109:                                    ; preds = %bb_5389878102
  store i64 %v1728, ptr %PC, align 8
  %v1732 = add i64 %v1728, 4
  store i64 %v1732, ptr %NEXT_PC, align 8
  %v1733 = load i64, ptr %RDI, align 8
  %v1734 = add i64 %v1733, 32
  %v1735 = load ptr, ptr %MEMORY, align 8
  %v1736 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1735, ptr %state, ptr %RCX, i64 %v1734)
  store ptr %v1736, ptr %MEMORY, align 8
  store i64 %v1732, ptr %PC, align 8
  %v1737 = add i64 %v1732, 3
  store i64 %v1737, ptr %NEXT_PC, align 8
  %v1738 = load i64, ptr %RCX, align 8
  %v1739 = load i64, ptr %RCX, align 8
  %v1740 = load ptr, ptr %MEMORY, align 8
  %v1741 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1740, ptr %state, i64 %v1738, i64 %v1739)
  store ptr %v1741, ptr %MEMORY, align 8
  store i64 %v1737, ptr %PC, align 8
  %v1742 = add i64 %v1737, 2
  store i64 %v1742, ptr %NEXT_PC, align 8
  %v1743 = add i64 %v1742, 9
  %v1744 = load ptr, ptr %MEMORY, align 8
  %v1745 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1744, ptr %state, ptr %BRANCH_TAKEN, i64 %v1743, i64 %v1742, ptr %NEXT_PC)
  store ptr %v1745, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878127, label %bb_5389878118

bb_5389878118:                                    ; preds = %bb_5389878109
  store i64 %v1742, ptr %PC, align 8
  %v1746 = add i64 %v1742, 5
  store i64 %v1746, ptr %NEXT_PC, align 8
  %v1747 = sub i64 %v1746, 1157131
  %v1748 = load ptr, ptr %MEMORY, align 8
  %v1749 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1748, ptr %state, i64 5388720992, ptr %NEXT_PC, i64 %v1746, ptr %RETURN_PC)
  store ptr %v1749, ptr %MEMORY, align 8
  store i64 %v1746, ptr %PC, align 8
  %v1750 = add i64 %v1746, 4
  store i64 %v1750, ptr %NEXT_PC, align 8
  %v1751 = load i64, ptr %RDI, align 8
  %v1752 = add i64 %v1751, 32
  %v1753 = load i64, ptr %RSI, align 8
  %v1754 = load ptr, ptr %MEMORY, align 8
  %v1755 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1754, ptr %state, i64 %v1752, i64 %v1753)
  store ptr %v1755, ptr %MEMORY, align 8
  br label %bb_5389878127

bb_5389878127:                                    ; preds = %bb_5389878118, %bb_5389878109
  %v1756 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1756, ptr %PC, align 8
  %v1757 = add i64 %v1756, 3
  store i64 %v1757, ptr %NEXT_PC, align 8
  %v1758 = load i64, ptr %RDI, align 8
  %v1759 = add i64 %v1758, 44
  %v1760 = load i32, ptr %ESI, align 4
  %v1761 = zext i32 %v1760 to i64
  %v1762 = load ptr, ptr %MEMORY, align 8
  %v1763 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1762, ptr %state, i64 %v1759, i64 %v1761)
  store ptr %v1763, ptr %MEMORY, align 8
  store i64 %v1757, ptr %PC, align 8
  %v1764 = add i64 %v1757, 5
  store i64 %v1764, ptr %NEXT_PC, align 8
  %v1765 = load i64, ptr %RSP, align 8
  %v1766 = add i64 %v1765, 48
  %v1767 = load ptr, ptr %MEMORY, align 8
  %v1768 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1767, ptr %state, ptr %RBX, i64 %v1766)
  store ptr %v1768, ptr %MEMORY, align 8
  store i64 %v1764, ptr %PC, align 8
  %v1769 = add i64 %v1764, 5
  store i64 %v1769, ptr %NEXT_PC, align 8
  %v1770 = load i64, ptr %RSP, align 8
  %v1771 = add i64 %v1770, 56
  %v1772 = load ptr, ptr %MEMORY, align 8
  %v1773 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1772, ptr %state, ptr %RSI, i64 %v1771)
  store ptr %v1773, ptr %MEMORY, align 8
  store i64 %v1769, ptr %PC, align 8
  %v1774 = add i64 %v1769, 4
  store i64 %v1774, ptr %NEXT_PC, align 8
  %v1775 = load i64, ptr %RSP, align 8
  %v1776 = load ptr, ptr %MEMORY, align 8
  %v1777 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1776, ptr %state, ptr %RSP, i64 %v1775, i64 32)
  store ptr %v1777, ptr %MEMORY, align 8
  store i64 %v1774, ptr %PC, align 8
  %v1778 = add i64 %v1774, 1
  store i64 %v1778, ptr %NEXT_PC, align 8
  %v1779 = load ptr, ptr %MEMORY, align 8
  %v1780 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1779, ptr %state, ptr %RDI)
  store ptr %v1780, ptr %MEMORY, align 8
  store i64 %v1778, ptr %PC, align 8
  %v1781 = add i64 %v1778, 1
  store i64 %v1781, ptr %NEXT_PC, align 8
  %v1782 = load ptr, ptr %MEMORY, align 8
  %v1783 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1782, ptr %state, ptr %NEXT_PC)
  store ptr %v1783, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878146:                                    ; preds = %bb_5389878102
  store i64 %v1728, ptr %PC, align 8
  %v1784 = add i64 %v1728, 3
  store i64 %v1784, ptr %NEXT_PC, align 8
  %v1785 = load i64, ptr %RDI, align 8
  %v1786 = add i64 %v1785, 44
  %v1787 = load i32, ptr %EDX, align 4
  %v1788 = zext i32 %v1787 to i64
  %v1789 = load ptr, ptr %MEMORY, align 8
  %v1790 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1789, ptr %state, i64 %v1786, i64 %v1788)
  store ptr %v1790, ptr %MEMORY, align 8
  store i64 %v1784, ptr %PC, align 8
  %v1791 = add i64 %v1784, 2
  store i64 %v1791, ptr %NEXT_PC, align 8
  %v1792 = add i64 %v1791, 15
  %v1793 = load ptr, ptr %MEMORY, align 8
  %v1794 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1793, ptr %state, ptr %BRANCH_TAKEN, i64 %v1792, i64 %v1791, ptr %NEXT_PC)
  store ptr %v1794, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878166, label %bb_5389878151

bb_5389878151:                                    ; preds = %bb_5389878146
  store i64 %v1791, ptr %PC, align 8
  %v1795 = add i64 %v1791, 6
  store i64 %v1795, ptr %NEXT_PC, align 8
  %v1796 = load ptr, ptr %MEMORY, align 8
  %v1797 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1796, ptr %state, ptr %R8, i64 134217784)
  store ptr %v1797, ptr %MEMORY, align 8
  store i64 %v1795, ptr %PC, align 8
  %v1798 = add i64 %v1795, 4
  store i64 %v1798, ptr %NEXT_PC, align 8
  %v1799 = load i64, ptr %RDI, align 8
  %v1800 = add i64 %v1799, 32
  %v1801 = load ptr, ptr %MEMORY, align 8
  %v1802 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1801, ptr %state, ptr %RCX, i64 %v1800)
  store ptr %v1802, ptr %MEMORY, align 8
  store i64 %v1798, ptr %PC, align 8
  %v1803 = add i64 %v1798, 5
  store i64 %v1803, ptr %NEXT_PC, align 8
  %v1804 = sub i64 %v1803, 644534
  %v1805 = load ptr, ptr %MEMORY, align 8
  %v1806 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1805, ptr %state, i64 5389233632, ptr %NEXT_PC, i64 %v1803, ptr %RETURN_PC)
  store ptr %v1806, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878166:                                    ; preds = %bb_5389878146
  store i64 %v1791, ptr %PC, align 8
  %v1807 = add i64 %v1791, 5
  store i64 %v1807, ptr %NEXT_PC, align 8
  %v1808 = load i64, ptr %RSP, align 8
  %v1809 = add i64 %v1808, 48
  %v1810 = load ptr, ptr %MEMORY, align 8
  %v1811 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1810, ptr %state, ptr %RBX, i64 %v1809)
  store ptr %v1811, ptr %MEMORY, align 8
  store i64 %v1807, ptr %PC, align 8
  %v1812 = add i64 %v1807, 5
  store i64 %v1812, ptr %NEXT_PC, align 8
  %v1813 = load i64, ptr %RSP, align 8
  %v1814 = add i64 %v1813, 56
  %v1815 = load ptr, ptr %MEMORY, align 8
  %v1816 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1815, ptr %state, ptr %RSI, i64 %v1814)
  store ptr %v1816, ptr %MEMORY, align 8
  store i64 %v1812, ptr %PC, align 8
  %v1817 = add i64 %v1812, 4
  store i64 %v1817, ptr %NEXT_PC, align 8
  %v1818 = load i64, ptr %RSP, align 8
  %v1819 = load ptr, ptr %MEMORY, align 8
  %v1820 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1819, ptr %state, ptr %RSP, i64 %v1818, i64 32)
  store ptr %v1820, ptr %MEMORY, align 8
  store i64 %v1817, ptr %PC, align 8
  %v1821 = add i64 %v1817, 1
  store i64 %v1821, ptr %NEXT_PC, align 8
  %v1822 = load ptr, ptr %MEMORY, align 8
  %v1823 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1822, ptr %state, ptr %RDI)
  store ptr %v1823, ptr %MEMORY, align 8
  store i64 %v1821, ptr %PC, align 8
  %v1824 = add i64 %v1821, 1
  store i64 %v1824, ptr %NEXT_PC, align 8
  %v1825 = load ptr, ptr %MEMORY, align 8
  %v1826 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1825, ptr %state, ptr %NEXT_PC)
  store ptr %v1826, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878182:                                    ; No predecessors!
  %v1827 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1827, ptr %PC, align 8
  %v1828 = add i64 %v1827, 1
  store i64 %v1828, ptr %NEXT_PC, align 8
  %v1829 = load ptr, ptr %MEMORY, align 8
  %v1830 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1829, ptr %state, ptr undef)
  store ptr %v1830, ptr %MEMORY, align 8
  store i64 %v1828, ptr %PC, align 8
  %v1831 = add i64 %v1828, 1
  store i64 %v1831, ptr %NEXT_PC, align 8
  %v1832 = load ptr, ptr %MEMORY, align 8
  %v1833 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1832, ptr %state, ptr undef)
  store ptr %v1833, ptr %MEMORY, align 8
  store i64 %v1831, ptr %PC, align 8
  %v1834 = add i64 %v1831, 1
  store i64 %v1834, ptr %NEXT_PC, align 8
  %v1835 = load ptr, ptr %MEMORY, align 8
  %v1836 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1835, ptr %state, ptr undef)
  store ptr %v1836, ptr %MEMORY, align 8
  store i64 %v1834, ptr %PC, align 8
  %v1837 = add i64 %v1834, 1
  store i64 %v1837, ptr %NEXT_PC, align 8
  %v1838 = load ptr, ptr %MEMORY, align 8
  %v1839 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1838, ptr %state, ptr undef)
  store ptr %v1839, ptr %MEMORY, align 8
  store i64 %v1837, ptr %PC, align 8
  %v1840 = add i64 %v1837, 1
  store i64 %v1840, ptr %NEXT_PC, align 8
  %v1841 = load ptr, ptr %MEMORY, align 8
  %v1842 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1841, ptr %state, ptr undef)
  store ptr %v1842, ptr %MEMORY, align 8
  store i64 %v1840, ptr %PC, align 8
  %v1843 = add i64 %v1840, 1
  store i64 %v1843, ptr %NEXT_PC, align 8
  %v1844 = load ptr, ptr %MEMORY, align 8
  %v1845 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1844, ptr %state, ptr undef)
  store ptr %v1845, ptr %MEMORY, align 8
  store i64 %v1843, ptr %PC, align 8
  %v1846 = add i64 %v1843, 1
  store i64 %v1846, ptr %NEXT_PC, align 8
  %v1847 = load ptr, ptr %MEMORY, align 8
  %v1848 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1847, ptr %state, ptr undef)
  store ptr %v1848, ptr %MEMORY, align 8
  store i64 %v1846, ptr %PC, align 8
  %v1849 = add i64 %v1846, 1
  store i64 %v1849, ptr %NEXT_PC, align 8
  %v1850 = load ptr, ptr %MEMORY, align 8
  %v1851 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1850, ptr %state, ptr undef)
  store ptr %v1851, ptr %MEMORY, align 8
  store i64 %v1849, ptr %PC, align 8
  %v1852 = add i64 %v1849, 1
  store i64 %v1852, ptr %NEXT_PC, align 8
  %v1853 = load ptr, ptr %MEMORY, align 8
  %v1854 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1853, ptr %state, ptr undef)
  store ptr %v1854, ptr %MEMORY, align 8
  store i64 %v1852, ptr %PC, align 8
  %v1855 = add i64 %v1852, 1
  store i64 %v1855, ptr %NEXT_PC, align 8
  %v1856 = load ptr, ptr %MEMORY, align 8
  %v1857 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1856, ptr %state, ptr undef)
  store ptr %v1857, ptr %MEMORY, align 8
  store i64 %v1855, ptr %PC, align 8
  %v1858 = add i64 %v1855, 4
  store i64 %v1858, ptr %NEXT_PC, align 8
  %v1859 = load i64, ptr %RCX, align 8
  %v1860 = add i64 %v1859, 8
  %v1861 = load ptr, ptr %MEMORY, align 8
  %v1862 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1861, ptr %state, ptr %RAX, i64 %v1860)
  store ptr %v1862, ptr %MEMORY, align 8
  store i64 %v1858, ptr %PC, align 8
  %v1863 = add i64 %v1858, 3
  store i64 %v1863, ptr %NEXT_PC, align 8
  %v1864 = load i64, ptr %RDX, align 8
  %v1865 = load i64, ptr %RAX, align 8
  %v1866 = load ptr, ptr %MEMORY, align 8
  %v1867 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1866, ptr %state, i64 %v1864, i64 %v1865)
  store ptr %v1867, ptr %MEMORY, align 8
  store i64 %v1863, ptr %PC, align 8
  %v1868 = add i64 %v1863, 3
  store i64 %v1868, ptr %NEXT_PC, align 8
  %v1869 = load i64, ptr %RAX, align 8
  %v1870 = load i64, ptr %RAX, align 8
  %v1871 = load ptr, ptr %MEMORY, align 8
  %v1872 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1871, ptr %state, i64 %v1869, i64 %v1870)
  store ptr %v1872, ptr %MEMORY, align 8
  store i64 %v1868, ptr %PC, align 8
  %v1873 = add i64 %v1868, 2
  store i64 %v1873, ptr %NEXT_PC, align 8
  %v1874 = add i64 %v1873, 8
  %v1875 = load ptr, ptr %MEMORY, align 8
  %v1876 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1875, ptr %state, ptr %BRANCH_TAKEN, i64 %v1874, i64 %v1873, ptr %NEXT_PC)
  store ptr %v1876, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878212, label %bb_5389878204

bb_5389878204:                                    ; preds = %bb_5389878182
  store i64 %v1873, ptr %PC, align 8
  %v1877 = add i64 %v1873, 2
  store i64 %v1877, ptr %NEXT_PC, align 8
  %v1878 = load i64, ptr %RAX, align 8
  %v1879 = load i64, ptr %RAX, align 8
  %v1880 = load ptr, ptr %MEMORY, align 8
  %v1881 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1880, ptr %state, i64 %v1878, i64 %v1879)
  store ptr %v1881, ptr %MEMORY, align 8
  store i64 %v1877, ptr %PC, align 8
  %v1882 = add i64 %v1877, 4
  store i64 %v1882, ptr %NEXT_PC, align 8
  %v1883 = load i64, ptr %RAX, align 8
  %v1884 = add i64 %v1883, 48
  %v1885 = load ptr, ptr %MEMORY, align 8
  %v1886 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1885, ptr %state, ptr %RAX, i64 %v1884)
  store ptr %v1886, ptr %MEMORY, align 8
  store i64 %v1882, ptr %PC, align 8
  %v1887 = add i64 %v1882, 2
  store i64 %v1887, ptr %NEXT_PC, align 8
  %v1888 = load i64, ptr %RAX, align 8
  %v1889 = load i64, ptr %RAX, align 8
  %v1890 = load ptr, ptr %MEMORY, align 8
  %v1891 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1890, ptr %state, i64 %v1888, i64 %v1889)
  store ptr %v1891, ptr %MEMORY, align 8
  br label %bb_5389878212

bb_5389878212:                                    ; preds = %bb_5389878204, %bb_5389878182
  %v1892 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1892, ptr %PC, align 8
  %v1893 = add i64 %v1892, 3
  store i64 %v1893, ptr %NEXT_PC, align 8
  %v1894 = load i64, ptr %RDX, align 8
  %v1895 = load ptr, ptr %MEMORY, align 8
  %v1896 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1895, ptr %state, ptr %RAX, i64 %v1894)
  store ptr %v1896, ptr %MEMORY, align 8
  store i64 %v1893, ptr %PC, align 8
  %v1897 = add i64 %v1893, 1
  store i64 %v1897, ptr %NEXT_PC, align 8
  %v1898 = load ptr, ptr %MEMORY, align 8
  %v1899 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1898, ptr %state, ptr %NEXT_PC)
  store ptr %v1899, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878216:                                    ; No predecessors!
  %v1900 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1900, ptr %PC, align 8
  %v1901 = add i64 %v1900, 1
  store i64 %v1901, ptr %NEXT_PC, align 8
  %v1902 = load ptr, ptr %MEMORY, align 8
  %v1903 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1902, ptr %state, ptr undef)
  store ptr %v1903, ptr %MEMORY, align 8
  store i64 %v1901, ptr %PC, align 8
  %v1904 = add i64 %v1901, 1
  store i64 %v1904, ptr %NEXT_PC, align 8
  %v1905 = load ptr, ptr %MEMORY, align 8
  %v1906 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1905, ptr %state, ptr undef)
  store ptr %v1906, ptr %MEMORY, align 8
  store i64 %v1904, ptr %PC, align 8
  %v1907 = add i64 %v1904, 1
  store i64 %v1907, ptr %NEXT_PC, align 8
  %v1908 = load ptr, ptr %MEMORY, align 8
  %v1909 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1908, ptr %state, ptr undef)
  store ptr %v1909, ptr %MEMORY, align 8
  store i64 %v1907, ptr %PC, align 8
  %v1910 = add i64 %v1907, 1
  store i64 %v1910, ptr %NEXT_PC, align 8
  %v1911 = load ptr, ptr %MEMORY, align 8
  %v1912 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1911, ptr %state, ptr undef)
  store ptr %v1912, ptr %MEMORY, align 8
  store i64 %v1910, ptr %PC, align 8
  %v1913 = add i64 %v1910, 1
  store i64 %v1913, ptr %NEXT_PC, align 8
  %v1914 = load ptr, ptr %MEMORY, align 8
  %v1915 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1914, ptr %state, ptr undef)
  store ptr %v1915, ptr %MEMORY, align 8
  store i64 %v1913, ptr %PC, align 8
  %v1916 = add i64 %v1913, 1
  store i64 %v1916, ptr %NEXT_PC, align 8
  %v1917 = load ptr, ptr %MEMORY, align 8
  %v1918 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1917, ptr %state, ptr undef)
  store ptr %v1918, ptr %MEMORY, align 8
  store i64 %v1916, ptr %PC, align 8
  %v1919 = add i64 %v1916, 1
  store i64 %v1919, ptr %NEXT_PC, align 8
  %v1920 = load ptr, ptr %MEMORY, align 8
  %v1921 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1920, ptr %state, ptr undef)
  store ptr %v1921, ptr %MEMORY, align 8
  store i64 %v1919, ptr %PC, align 8
  %v1922 = add i64 %v1919, 1
  store i64 %v1922, ptr %NEXT_PC, align 8
  %v1923 = load ptr, ptr %MEMORY, align 8
  %v1924 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1923, ptr %state, ptr undef)
  store ptr %v1924, ptr %MEMORY, align 8
  store i64 %v1922, ptr %PC, align 8
  %v1925 = add i64 %v1922, 2
  store i64 %v1925, ptr %NEXT_PC, align 8
  %v1926 = load i64, ptr %RBX, align 8
  %v1927 = load ptr, ptr %MEMORY, align 8
  %v1928 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1927, ptr %state, i64 %v1926)
  store ptr %v1928, ptr %MEMORY, align 8
  store i64 %v1925, ptr %PC, align 8
  %v1929 = add i64 %v1925, 4
  store i64 %v1929, ptr %NEXT_PC, align 8
  %v1930 = load i64, ptr %RSP, align 8
  %v1931 = load ptr, ptr %MEMORY, align 8
  %v1932 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1931, ptr %state, ptr %RSP, i64 %v1930, i64 32)
  store ptr %v1932, ptr %MEMORY, align 8
  store i64 %v1929, ptr %PC, align 8
  %v1933 = add i64 %v1929, 3
  store i64 %v1933, ptr %NEXT_PC, align 8
  %v1934 = load i64, ptr %RCX, align 8
  %v1935 = load ptr, ptr %MEMORY, align 8
  %v1936 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1935, ptr %state, ptr %RBX, i64 %v1934)
  store ptr %v1936, ptr %MEMORY, align 8
  store i64 %v1933, ptr %PC, align 8
  %v1937 = add i64 %v1933, 4
  store i64 %v1937, ptr %NEXT_PC, align 8
  %v1938 = load i64, ptr %RCX, align 8
  %v1939 = add i64 %v1938, 8
  %v1940 = load i64, ptr %RDX, align 8
  %v1941 = load ptr, ptr %MEMORY, align 8
  %v1942 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v1941, ptr %state, i64 %v1939, i64 %v1940)
  store ptr %v1942, ptr %MEMORY, align 8
  store i64 %v1937, ptr %PC, align 8
  %v1943 = add i64 %v1937, 6
  store i64 %v1943, ptr %NEXT_PC, align 8
  %v1944 = add i64 %v1943, 281
  %v1945 = load ptr, ptr %MEMORY, align 8
  %v1946 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1945, ptr %state, ptr %BRANCH_TAKEN, i64 %v1944, i64 %v1943, ptr %NEXT_PC)
  store ptr %v1946, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878524, label %bb_5389878243

bb_5389878243:                                    ; preds = %bb_5389878216
  store i64 %v1943, ptr %PC, align 8
  %v1947 = add i64 %v1943, 5
  store i64 %v1947, ptr %NEXT_PC, align 8
  %v1948 = load i64, ptr %RSP, align 8
  %v1949 = add i64 %v1948, 48
  %v1950 = load i64, ptr %RBP, align 8
  %v1951 = load ptr, ptr %MEMORY, align 8
  %v1952 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1951, ptr %state, i64 %v1949, i64 %v1950)
  store ptr %v1952, ptr %MEMORY, align 8
  store i64 %v1947, ptr %PC, align 8
  %v1953 = add i64 %v1947, 4
  store i64 %v1953, ptr %NEXT_PC, align 8
  %v1954 = load i64, ptr %RCX, align 8
  %v1955 = add i64 %v1954, 48
  %v1956 = load ptr, ptr %MEMORY, align 8
  %v1957 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1956, ptr %state, ptr %RBP, i64 %v1955)
  store ptr %v1957, ptr %MEMORY, align 8
  store i64 %v1953, ptr %PC, align 8
  %v1958 = add i64 %v1953, 3
  store i64 %v1958, ptr %NEXT_PC, align 8
  %v1959 = load i64, ptr %RDX, align 8
  %v1960 = load i64, ptr %RDX, align 8
  %v1961 = load ptr, ptr %MEMORY, align 8
  %v1962 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1961, ptr %state, i64 %v1959, i64 %v1960)
  store ptr %v1962, ptr %MEMORY, align 8
  store i64 %v1958, ptr %PC, align 8
  %v1963 = add i64 %v1958, 2
  store i64 %v1963, ptr %NEXT_PC, align 8
  %v1964 = add i64 %v1963, 16
  %v1965 = load ptr, ptr %MEMORY, align 8
  %v1966 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1965, ptr %state, ptr %BRANCH_TAKEN, i64 %v1964, i64 %v1963, ptr %NEXT_PC)
  store ptr %v1966, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878273, label %bb_5389878257

bb_5389878257:                                    ; preds = %bb_5389878243
  store i64 %v1963, ptr %PC, align 8
  %v1967 = add i64 %v1963, 4
  store i64 %v1967, ptr %NEXT_PC, align 8
  %v1968 = load i64, ptr %RDX, align 8
  %v1969 = add i64 %v1968, 48
  %v1970 = load i64, ptr %RBP, align 8
  %v1971 = load ptr, ptr %MEMORY, align 8
  %v1972 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v1971, ptr %state, i64 %v1969, i64 %v1970)
  store ptr %v1972, ptr %MEMORY, align 8
  store i64 %v1967, ptr %PC, align 8
  %v1973 = add i64 %v1967, 2
  store i64 %v1973, ptr %NEXT_PC, align 8
  %v1974 = add i64 %v1973, 10
  %v1975 = load ptr, ptr %MEMORY, align 8
  %v1976 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1975, ptr %state, ptr %BRANCH_TAKEN, i64 %v1974, i64 %v1973, ptr %NEXT_PC)
  store ptr %v1976, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878273, label %bb_5389878263

bb_5389878263:                                    ; preds = %bb_5389878257
  store i64 %v1973, ptr %PC, align 8
  %v1977 = add i64 %v1973, 4
  store i64 %v1977, ptr %NEXT_PC, align 8
  %v1978 = load i64, ptr %RCX, align 8
  %v1979 = load i64, ptr %RBP, align 8
  %v1980 = add i64 %v1979, 8
  %v1981 = load ptr, ptr %MEMORY, align 8
  %v1982 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1981, ptr %state, i64 %v1978, i64 %v1980)
  store ptr %v1982, ptr %MEMORY, align 8
  store i64 %v1977, ptr %PC, align 8
  %v1983 = add i64 %v1977, 6
  store i64 %v1983, ptr %NEXT_PC, align 8
  %v1984 = add i64 %v1983, 246
  %v1985 = load ptr, ptr %MEMORY, align 8
  %v1986 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1985, ptr %state, ptr %BRANCH_TAKEN, i64 %v1984, i64 %v1983, ptr %NEXT_PC)
  store ptr %v1986, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878519, label %bb_5389878273

bb_5389878273:                                    ; preds = %bb_5389878263, %bb_5389878257, %bb_5389878243
  %v1987 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1987, ptr %PC, align 8
  %v1988 = add i64 %v1987, 5
  store i64 %v1988, ptr %NEXT_PC, align 8
  %v1989 = load i64, ptr %RSP, align 8
  %v1990 = add i64 %v1989, 64
  %v1991 = load i64, ptr %RDI, align 8
  %v1992 = load ptr, ptr %MEMORY, align 8
  %v1993 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1992, ptr %state, i64 %v1990, i64 %v1991)
  store ptr %v1993, ptr %MEMORY, align 8
  store i64 %v1988, ptr %PC, align 8
  %v1994 = add i64 %v1988, 5
  store i64 %v1994, ptr %NEXT_PC, align 8
  %v1995 = load i64, ptr %RSP, align 8
  %v1996 = add i64 %v1995, 72
  %v1997 = load i64, ptr %R14, align 8
  %v1998 = load ptr, ptr %MEMORY, align 8
  %v1999 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1998, ptr %state, i64 %v1996, i64 %v1997)
  store ptr %v1999, ptr %MEMORY, align 8
  store i64 %v1994, ptr %PC, align 8
  %v2000 = add i64 %v1994, 3
  store i64 %v2000, ptr %NEXT_PC, align 8
  %v2001 = load i64, ptr %R14, align 8
  %v2002 = load i32, ptr %R14D, align 4
  %v2003 = zext i32 %v2002 to i64
  %v2004 = load ptr, ptr %MEMORY, align 8
  %v2005 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2004, ptr %state, ptr %R14, i64 %v2001, i64 %v2003)
  store ptr %v2005, ptr %MEMORY, align 8
  store i64 %v2000, ptr %PC, align 8
  %v2006 = add i64 %v2000, 4
  store i64 %v2006, ptr %NEXT_PC, align 8
  %v2007 = load i64, ptr %RCX, align 8
  %v2008 = add i64 %v2007, 8
  %v2009 = load i64, ptr %RDX, align 8
  %v2010 = load ptr, ptr %MEMORY, align 8
  %v2011 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2010, ptr %state, i64 %v2008, i64 %v2009)
  store ptr %v2011, ptr %MEMORY, align 8
  store i64 %v2006, ptr %PC, align 8
  %v2012 = add i64 %v2006, 3
  store i64 %v2012, ptr %NEXT_PC, align 8
  %v2013 = load i64, ptr %RDX, align 8
  %v2014 = load i64, ptr %RDX, align 8
  %v2015 = load ptr, ptr %MEMORY, align 8
  %v2016 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2015, ptr %state, i64 %v2013, i64 %v2014)
  store ptr %v2016, ptr %MEMORY, align 8
  store i64 %v2012, ptr %PC, align 8
  %v2017 = add i64 %v2012, 2
  store i64 %v2017, ptr %NEXT_PC, align 8
  %v2018 = add i64 %v2017, 6
  %v2019 = load ptr, ptr %MEMORY, align 8
  %v2020 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2019, ptr %state, ptr %BRANCH_TAKEN, i64 %v2018, i64 %v2017, ptr %NEXT_PC)
  store ptr %v2020, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878301, label %bb_5389878295

bb_5389878295:                                    ; preds = %bb_5389878273
  store i64 %v2017, ptr %PC, align 8
  %v2021 = add i64 %v2017, 4
  store i64 %v2021, ptr %NEXT_PC, align 8
  %v2022 = load i64, ptr %RDX, align 8
  %v2023 = add i64 %v2022, 48
  %v2024 = load ptr, ptr %MEMORY, align 8
  %v2025 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2024, ptr %state, ptr %RAX, i64 %v2023)
  store ptr %v2025, ptr %MEMORY, align 8
  store i64 %v2021, ptr %PC, align 8
  %v2026 = add i64 %v2021, 2
  store i64 %v2026, ptr %NEXT_PC, align 8
  %v2027 = add i64 %v2026, 46
  %v2028 = load ptr, ptr %MEMORY, align 8
  %v2029 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2028, ptr %state, i64 %v2027, ptr %NEXT_PC)
  store ptr %v2029, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878301:                                    ; preds = %bb_5389878273
  store i64 %v2017, ptr %PC, align 8
  %v2030 = add i64 %v2017, 2
  store i64 %v2030, ptr %NEXT_PC, align 8
  %v2031 = load i64, ptr %RDX, align 8
  %v2032 = load i32, ptr %EDX, align 4
  %v2033 = zext i32 %v2032 to i64
  %v2034 = load ptr, ptr %MEMORY, align 8
  %v2035 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2034, ptr %state, ptr %RDX, i64 %v2031, i64 %v2033)
  store ptr %v2035, ptr %MEMORY, align 8
  store i64 %v2030, ptr %PC, align 8
  %v2036 = add i64 %v2030, 3
  store i64 %v2036, ptr %NEXT_PC, align 8
  %v2037 = load i64, ptr %R9, align 8
  %v2038 = load i32, ptr %R9D, align 4
  %v2039 = zext i32 %v2038 to i64
  %v2040 = load ptr, ptr %MEMORY, align 8
  %v2041 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2040, ptr %state, ptr %R9, i64 %v2037, i64 %v2039)
  store ptr %v2041, ptr %MEMORY, align 8
  store i64 %v2036, ptr %PC, align 8
  %v2042 = add i64 %v2036, 3
  store i64 %v2042, ptr %NEXT_PC, align 8
  %v2043 = load i64, ptr %R8, align 8
  %v2044 = load i32, ptr %R8D, align 4
  %v2045 = zext i32 %v2044 to i64
  %v2046 = load ptr, ptr %MEMORY, align 8
  %v2047 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2046, ptr %state, ptr %R8, i64 %v2043, i64 %v2045)
  store ptr %v2047, ptr %MEMORY, align 8
  store i64 %v2042, ptr %PC, align 8
  %v2048 = add i64 %v2042, 3
  store i64 %v2048, ptr %NEXT_PC, align 8
  %v2049 = load i64, ptr %RDX, align 8
  %v2050 = add i64 %v2049, 24
  %v2051 = load ptr, ptr %MEMORY, align 8
  %v2052 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2051, ptr %state, ptr %RCX, i64 %v2050)
  store ptr %v2052, ptr %MEMORY, align 8
  store i64 %v2048, ptr %PC, align 8
  %v2053 = add i64 %v2048, 5
  store i64 %v2053, ptr %NEXT_PC, align 8
  %v2054 = sub i64 %v2053, 1159245
  %v2055 = load ptr, ptr %MEMORY, align 8
  %v2056 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2055, ptr %state, i64 5388719072, ptr %NEXT_PC, i64 %v2053, ptr %RETURN_PC)
  store ptr %v2056, ptr %MEMORY, align 8
  store i64 %v2053, ptr %PC, align 8
  %v2057 = add i64 %v2053, 3
  store i64 %v2057, ptr %NEXT_PC, align 8
  %v2058 = load i64, ptr %RAX, align 8
  %v2059 = load i64, ptr %RAX, align 8
  %v2060 = load ptr, ptr %MEMORY, align 8
  %v2061 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2060, ptr %state, i64 %v2058, i64 %v2059)
  store ptr %v2061, ptr %MEMORY, align 8
  store i64 %v2057, ptr %PC, align 8
  %v2062 = add i64 %v2057, 2
  store i64 %v2062, ptr %NEXT_PC, align 8
  %v2063 = add i64 %v2062, 22
  %v2064 = load ptr, ptr %MEMORY, align 8
  %v2065 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2064, ptr %state, ptr %BRANCH_TAKEN, i64 %v2063, i64 %v2062, ptr %NEXT_PC)
  store ptr %v2065, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878344, label %bb_5389878322

bb_5389878322:                                    ; preds = %bb_5389878301
  store i64 %v2062, ptr %PC, align 8
  %v2066 = add i64 %v2062, 4
  store i64 %v2066, ptr %NEXT_PC, align 8
  %v2067 = load i64, ptr %RAX, align 8
  %v2068 = add i64 %v2067, 16
  %v2069 = load ptr, ptr %MEMORY, align 8
  %v2070 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2069, ptr %state, ptr %RCX, i64 %v2068)
  store ptr %v2070, ptr %MEMORY, align 8
  store i64 %v2066, ptr %PC, align 8
  %v2071 = add i64 %v2066, 3
  store i64 %v2071, ptr %NEXT_PC, align 8
  %v2072 = load i8, ptr %CL, align 1
  %v2073 = zext i8 %v2072 to i64
  %v2074 = load ptr, ptr %MEMORY, align 8
  %v2075 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2074, ptr %state, ptr %CL, i64 %v2073, i64 253)
  store ptr %v2075, ptr %MEMORY, align 8
  store i64 %v2071, ptr %PC, align 8
  %v2076 = add i64 %v2071, 4
  store i64 %v2076, ptr %NEXT_PC, align 8
  %v2077 = load i64, ptr %RAX, align 8
  %v2078 = add i64 %v2077, 8
  %v2079 = load i64, ptr %RBX, align 8
  %v2080 = load ptr, ptr %MEMORY, align 8
  %v2081 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2080, ptr %state, i64 %v2078, i64 %v2079)
  store ptr %v2081, ptr %MEMORY, align 8
  store i64 %v2076, ptr %PC, align 8
  %v2082 = add i64 %v2076, 3
  store i64 %v2082, ptr %NEXT_PC, align 8
  %v2083 = load i8, ptr %CL, align 1
  %v2084 = zext i8 %v2083 to i64
  %v2085 = load ptr, ptr %MEMORY, align 8
  %v2086 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2085, ptr %state, ptr %CL, i64 %v2084, i64 1)
  store ptr %v2086, ptr %MEMORY, align 8
  store i64 %v2082, ptr %PC, align 8
  %v2087 = add i64 %v2082, 3
  store i64 %v2087, ptr %NEXT_PC, align 8
  %v2088 = load i64, ptr %RAX, align 8
  %v2089 = load i32, ptr %R14D, align 4
  %v2090 = zext i32 %v2089 to i64
  %v2091 = load ptr, ptr %MEMORY, align 8
  %v2092 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2091, ptr %state, i64 %v2088, i64 %v2090)
  store ptr %v2092, ptr %MEMORY, align 8
  store i64 %v2087, ptr %PC, align 8
  %v2093 = add i64 %v2087, 3
  store i64 %v2093, ptr %NEXT_PC, align 8
  %v2094 = load i64, ptr %RAX, align 8
  %v2095 = add i64 %v2094, 16
  %v2096 = load i8, ptr %CL, align 1
  %v2097 = zext i8 %v2096 to i64
  %v2098 = load ptr, ptr %MEMORY, align 8
  %v2099 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2098, ptr %state, i64 %v2095, i64 %v2097)
  store ptr %v2099, ptr %MEMORY, align 8
  store i64 %v2093, ptr %PC, align 8
  %v2100 = add i64 %v2093, 2
  store i64 %v2100, ptr %NEXT_PC, align 8
  %v2101 = add i64 %v2100, 3
  %v2102 = load ptr, ptr %MEMORY, align 8
  %v2103 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2102, ptr %state, i64 %v2101, ptr %NEXT_PC)
  store ptr %v2103, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878344:                                    ; preds = %bb_5389878301
  store i64 %v2062, ptr %PC, align 8
  %v2104 = add i64 %v2062, 3
  store i64 %v2104, ptr %NEXT_PC, align 8
  %v2105 = load i64, ptr %R14, align 8
  %v2106 = load ptr, ptr %MEMORY, align 8
  %v2107 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2106, ptr %state, ptr %RAX, i64 %v2105)
  store ptr %v2107, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878347:                                    ; preds = %bb_5389878344, %bb_5389878322, %bb_5389878295
  %v2108 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2108, ptr %PC, align 8
  %v2109 = add i64 %v2108, 4
  store i64 %v2109, ptr %NEXT_PC, align 8
  %v2110 = load i64, ptr %RBX, align 8
  %v2111 = add i64 %v2110, 48
  %v2112 = load i64, ptr %RAX, align 8
  %v2113 = load ptr, ptr %MEMORY, align 8
  %v2114 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2113, ptr %state, i64 %v2111, i64 %v2112)
  store ptr %v2114, ptr %MEMORY, align 8
  store i64 %v2109, ptr %PC, align 8
  %v2115 = add i64 %v2109, 3
  store i64 %v2115, ptr %NEXT_PC, align 8
  %v2116 = load i32, ptr %R14D, align 4
  %v2117 = zext i32 %v2116 to i64
  %v2118 = load ptr, ptr %MEMORY, align 8
  %v2119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2118, ptr %state, ptr %RDI, i64 %v2117)
  store ptr %v2119, ptr %MEMORY, align 8
  store i64 %v2115, ptr %PC, align 8
  %v2120 = add i64 %v2115, 4
  store i64 %v2120, ptr %NEXT_PC, align 8
  %v2121 = load i64, ptr %RBX, align 8
  %v2122 = add i64 %v2121, 40
  %v2123 = load i32, ptr %R14D, align 4
  %v2124 = zext i32 %v2123 to i64
  %v2125 = load ptr, ptr %MEMORY, align 8
  %v2126 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2125, ptr %state, i64 %v2122, i64 %v2124)
  store ptr %v2126, ptr %MEMORY, align 8
  store i64 %v2120, ptr %PC, align 8
  %v2127 = add i64 %v2120, 2
  store i64 %v2127, ptr %NEXT_PC, align 8
  %v2128 = add i64 %v2127, 94
  %v2129 = load ptr, ptr %MEMORY, align 8
  %v2130 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2129, ptr %state, ptr %BRANCH_TAKEN, i64 %v2128, i64 %v2127, ptr %NEXT_PC)
  store ptr %v2130, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878454, label %bb_5389878360

bb_5389878360:                                    ; preds = %bb_5389878347
  store i64 %v2127, ptr %PC, align 8
  %v2131 = add i64 %v2127, 5
  store i64 %v2131, ptr %NEXT_PC, align 8
  %v2132 = load i64, ptr %RSP, align 8
  %v2133 = add i64 %v2132, 56
  %v2134 = load i64, ptr %RSI, align 8
  %v2135 = load ptr, ptr %MEMORY, align 8
  %v2136 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2135, ptr %state, i64 %v2133, i64 %v2134)
  store ptr %v2136, ptr %MEMORY, align 8
  store i64 %v2131, ptr %PC, align 8
  %v2137 = add i64 %v2131, 3
  store i64 %v2137, ptr %NEXT_PC, align 8
  %v2138 = load i64, ptr %R14, align 8
  %v2139 = load ptr, ptr %MEMORY, align 8
  %v2140 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2139, ptr %state, ptr %RSI, i64 %v2138)
  store ptr %v2140, ptr %MEMORY, align 8
  br label %bb_5389878368

bb_5389878368:                                    ; preds = %bb_5389878438, %bb_5389878360
  %v2141 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2141, ptr %PC, align 8
  %v2142 = add i64 %v2141, 4
  store i64 %v2142, ptr %NEXT_PC, align 8
  %v2143 = load i64, ptr %RBX, align 8
  %v2144 = add i64 %v2143, 32
  %v2145 = load ptr, ptr %MEMORY, align 8
  %v2146 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2145, ptr %state, ptr %RDX, i64 %v2144)
  store ptr %v2146, ptr %MEMORY, align 8
  store i64 %v2142, ptr %PC, align 8
  %v2147 = add i64 %v2142, 4
  store i64 %v2147, ptr %NEXT_PC, align 8
  %v2148 = load i64, ptr %RDX, align 8
  %v2149 = load ptr, ptr %MEMORY, align 8
  %v2150 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2149, ptr %state, ptr %RDX, i64 %v2148, i64 8)
  store ptr %v2150, ptr %MEMORY, align 8
  store i64 %v2147, ptr %PC, align 8
  %v2151 = add i64 %v2147, 3
  store i64 %v2151, ptr %NEXT_PC, align 8
  %v2152 = load i64, ptr %RDX, align 8
  %v2153 = load i64, ptr %RSI, align 8
  %v2154 = load ptr, ptr %MEMORY, align 8
  %v2155 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2154, ptr %state, ptr %RDX, i64 %v2152, i64 %v2153)
  store ptr %v2155, ptr %MEMORY, align 8
  store i64 %v2151, ptr %PC, align 8
  %v2156 = add i64 %v2151, 4
  store i64 %v2156, ptr %NEXT_PC, align 8
  %v2157 = load i64, ptr %RDX, align 8
  %v2158 = add i64 %v2157, 32
  %v2159 = load ptr, ptr %MEMORY, align 8
  %v2160 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2159, ptr %state, ptr %RCX, i64 %v2158)
  store ptr %v2160, ptr %MEMORY, align 8
  store i64 %v2156, ptr %PC, align 8
  %v2161 = add i64 %v2156, 7
  store i64 %v2161, ptr %NEXT_PC, align 8
  %v2162 = load i64, ptr %RCX, align 8
  %v2163 = add i64 %v2161, 27073082
  %v2164 = load ptr, ptr %MEMORY, align 8
  %v2165 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2164, ptr %state, i64 %v2162, i64 %v2163)
  store ptr %v2165, ptr %MEMORY, align 8
  store i64 %v2161, ptr %PC, align 8
  %v2166 = add i64 %v2161, 2
  store i64 %v2166, ptr %NEXT_PC, align 8
  %v2167 = add i64 %v2166, 46
  %v2168 = load ptr, ptr %MEMORY, align 8
  %v2169 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2168, ptr %state, ptr %BRANCH_TAKEN, i64 %v2167, i64 %v2166, ptr %NEXT_PC)
  store ptr %v2169, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878392

bb_5389878392:                                    ; preds = %bb_5389878368
  store i64 %v2166, ptr %PC, align 8
  %v2170 = add i64 %v2166, 3
  store i64 %v2170, ptr %NEXT_PC, align 8
  %v2171 = load i64, ptr %RCX, align 8
  %v2172 = load i64, ptr %RCX, align 8
  %v2173 = load ptr, ptr %MEMORY, align 8
  %v2174 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2173, ptr %state, i64 %v2171, i64 %v2172)
  store ptr %v2174, ptr %MEMORY, align 8
  store i64 %v2170, ptr %PC, align 8
  %v2175 = add i64 %v2170, 2
  store i64 %v2175, ptr %NEXT_PC, align 8
  %v2176 = add i64 %v2175, 5
  %v2177 = load ptr, ptr %MEMORY, align 8
  %v2178 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2177, ptr %state, ptr %BRANCH_TAKEN, i64 %v2176, i64 %v2175, ptr %NEXT_PC)
  store ptr %v2178, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878402, label %bb_5389878397

bb_5389878397:                                    ; preds = %bb_5389878392
  store i64 %v2175, ptr %PC, align 8
  %v2179 = add i64 %v2175, 3
  store i64 %v2179, ptr %NEXT_PC, align 8
  %v2180 = load i64, ptr %R14, align 8
  %v2181 = load ptr, ptr %MEMORY, align 8
  %v2182 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2181, ptr %state, ptr %RAX, i64 %v2180)
  store ptr %v2182, ptr %MEMORY, align 8
  store i64 %v2179, ptr %PC, align 8
  %v2183 = add i64 %v2179, 2
  store i64 %v2183, ptr %NEXT_PC, align 8
  %v2184 = add i64 %v2183, 6
  %v2185 = load ptr, ptr %MEMORY, align 8
  %v2186 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2185, ptr %state, i64 %v2184, ptr %NEXT_PC)
  store ptr %v2186, ptr %MEMORY, align 8
  br label %bb_5389878408

bb_5389878402:                                    ; preds = %bb_5389878392
  store i64 %v2175, ptr %PC, align 8
  %v2187 = add i64 %v2175, 3
  store i64 %v2187, ptr %NEXT_PC, align 8
  %v2188 = load i64, ptr %RCX, align 8
  %v2189 = load ptr, ptr %MEMORY, align 8
  %v2190 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2189, ptr %state, ptr %RAX, i64 %v2188)
  store ptr %v2190, ptr %MEMORY, align 8
  store i64 %v2187, ptr %PC, align 8
  %v2191 = add i64 %v2187, 3
  store i64 %v2191, ptr %NEXT_PC, align 8
  %v2192 = load i64, ptr %RAX, align 8
  %v2193 = add i64 %v2192, 48
  %v2194 = load ptr, ptr %MEMORY, align 8
  %v2195 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v2194, ptr %state, i64 %v2193, ptr %NEXT_PC, i64 %v2191, ptr %RETURN_PC)
  store ptr %v2195, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878408:                                    ; preds = %bb_5389878397
  store i64 %v2183, ptr %PC, align 8
  %v2196 = add i64 %v2183, 3
  store i64 %v2196, ptr %NEXT_PC, align 8
  %v2197 = load i64, ptr %RAX, align 8
  %v2198 = load ptr, ptr %MEMORY, align 8
  %v2199 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2198, ptr %state, ptr %RCX, i64 %v2197)
  store ptr %v2199, ptr %MEMORY, align 8
  store i64 %v2196, ptr %PC, align 8
  %v2200 = add i64 %v2196, 3
  store i64 %v2200, ptr %NEXT_PC, align 8
  %v2201 = load i64, ptr %RCX, align 8
  %v2202 = load i64, ptr %RCX, align 8
  %v2203 = load ptr, ptr %MEMORY, align 8
  %v2204 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2203, ptr %state, i64 %v2201, i64 %v2202)
  store ptr %v2204, ptr %MEMORY, align 8
  store i64 %v2200, ptr %PC, align 8
  %v2205 = add i64 %v2200, 2
  store i64 %v2205, ptr %NEXT_PC, align 8
  %v2206 = add i64 %v2205, 22
  %v2207 = load ptr, ptr %MEMORY, align 8
  %v2208 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2207, ptr %state, ptr %BRANCH_TAKEN, i64 %v2206, i64 %v2205, ptr %NEXT_PC)
  store ptr %v2208, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878416

bb_5389878416:                                    ; preds = %bb_5389878408
  store i64 %v2205, ptr %PC, align 8
  %v2209 = add i64 %v2205, 4
  store i64 %v2209, ptr %NEXT_PC, align 8
  %v2210 = load i64, ptr %RCX, align 8
  %v2211 = add i64 %v2210, 8
  %v2212 = load i64, ptr %RBX, align 8
  %v2213 = load ptr, ptr %MEMORY, align 8
  %v2214 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2213, ptr %state, i64 %v2211, i64 %v2212)
  store ptr %v2214, ptr %MEMORY, align 8
  store i64 %v2209, ptr %PC, align 8
  %v2215 = add i64 %v2209, 2
  store i64 %v2215, ptr %NEXT_PC, align 8
  %v2216 = add i64 %v2215, 16
  %v2217 = load ptr, ptr %MEMORY, align 8
  %v2218 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2217, ptr %state, ptr %BRANCH_TAKEN, i64 %v2216, i64 %v2215, ptr %NEXT_PC)
  store ptr %v2218, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878422

bb_5389878422:                                    ; preds = %bb_5389878416
  store i64 %v2215, ptr %PC, align 8
  %v2219 = add i64 %v2215, 3
  store i64 %v2219, ptr %NEXT_PC, align 8
  %v2220 = load i64, ptr %RBX, align 8
  %v2221 = load ptr, ptr %MEMORY, align 8
  %v2222 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2221, ptr %state, ptr %RDX, i64 %v2220)
  store ptr %v2222, ptr %MEMORY, align 8
  store i64 %v2219, ptr %PC, align 8
  %v2223 = add i64 %v2219, 4
  store i64 %v2223, ptr %NEXT_PC, align 8
  %v2224 = load i64, ptr %RCX, align 8
  %v2225 = add i64 %v2224, 48
  %v2226 = load i64, ptr %R14, align 8
  %v2227 = load ptr, ptr %MEMORY, align 8
  %v2228 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2227, ptr %state, i64 %v2225, i64 %v2226)
  store ptr %v2228, ptr %MEMORY, align 8
  store i64 %v2223, ptr %PC, align 8
  %v2229 = add i64 %v2223, 4
  store i64 %v2229, ptr %NEXT_PC, align 8
  %v2230 = load i64, ptr %RCX, align 8
  %v2231 = add i64 %v2230, 8
  %v2232 = load i64, ptr %R14, align 8
  %v2233 = load ptr, ptr %MEMORY, align 8
  %v2234 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2233, ptr %state, i64 %v2231, i64 %v2232)
  store ptr %v2234, ptr %MEMORY, align 8
  store i64 %v2229, ptr %PC, align 8
  %v2235 = add i64 %v2229, 5
  store i64 %v2235, ptr %NEXT_PC, align 8
  %v2236 = sub i64 %v2235, 214
  %v2237 = load ptr, ptr %MEMORY, align 8
  %v2238 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2237, ptr %state, i64 5389878224, ptr %NEXT_PC, i64 %v2235, ptr %RETURN_PC)
  store ptr %v2238, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878438:                                    ; preds = %bb_5389878416, %bb_5389878408, %bb_5389878368
  %v2239 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2239, ptr %PC, align 8
  %v2240 = add i64 %v2239, 2
  store i64 %v2240, ptr %NEXT_PC, align 8
  %v2241 = load i64, ptr %RDI, align 8
  %v2242 = load ptr, ptr %MEMORY, align 8
  %v2243 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2242, ptr %state, ptr %RDI, i64 %v2241)
  store ptr %v2243, ptr %MEMORY, align 8
  store i64 %v2240, ptr %PC, align 8
  %v2244 = add i64 %v2240, 4
  store i64 %v2244, ptr %NEXT_PC, align 8
  %v2245 = load i64, ptr %RSI, align 8
  %v2246 = load ptr, ptr %MEMORY, align 8
  %v2247 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2246, ptr %state, ptr %RSI, i64 %v2245, i64 56)
  store ptr %v2247, ptr %MEMORY, align 8
  store i64 %v2244, ptr %PC, align 8
  %v2248 = add i64 %v2244, 3
  store i64 %v2248, ptr %NEXT_PC, align 8
  %v2249 = load i32, ptr %EDI, align 4
  %v2250 = zext i32 %v2249 to i64
  %v2251 = load i64, ptr %RBX, align 8
  %v2252 = add i64 %v2251, 40
  %v2253 = load ptr, ptr %MEMORY, align 8
  %v2254 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2253, ptr %state, i64 %v2250, i64 %v2252)
  store ptr %v2254, ptr %MEMORY, align 8
  store i64 %v2248, ptr %PC, align 8
  %v2255 = add i64 %v2248, 2
  store i64 %v2255, ptr %NEXT_PC, align 8
  %v2256 = sub i64 %v2255, 81
  %v2257 = load ptr, ptr %MEMORY, align 8
  %v2258 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2257, ptr %state, ptr %BRANCH_TAKEN, i64 %v2256, i64 %v2255, ptr %NEXT_PC)
  store ptr %v2258, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878368, label %bb_5389878449

bb_5389878449:                                    ; preds = %bb_5389878438
  store i64 %v2255, ptr %PC, align 8
  %v2259 = add i64 %v2255, 5
  store i64 %v2259, ptr %NEXT_PC, align 8
  %v2260 = load i64, ptr %RSP, align 8
  %v2261 = add i64 %v2260, 56
  %v2262 = load ptr, ptr %MEMORY, align 8
  %v2263 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2262, ptr %state, ptr %RSI, i64 %v2261)
  store ptr %v2263, ptr %MEMORY, align 8
  br label %bb_5389878454

bb_5389878454:                                    ; preds = %bb_5389878449, %bb_5389878347
  %v2264 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2264, ptr %PC, align 8
  %v2265 = add i64 %v2264, 5
  store i64 %v2265, ptr %NEXT_PC, align 8
  %v2266 = load i64, ptr %RSP, align 8
  %v2267 = add i64 %v2266, 72
  %v2268 = load ptr, ptr %MEMORY, align 8
  %v2269 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2268, ptr %state, ptr %R14, i64 %v2267)
  store ptr %v2269, ptr %MEMORY, align 8
  store i64 %v2265, ptr %PC, align 8
  %v2270 = add i64 %v2265, 5
  store i64 %v2270, ptr %NEXT_PC, align 8
  %v2271 = load i64, ptr %RSP, align 8
  %v2272 = add i64 %v2271, 64
  %v2273 = load ptr, ptr %MEMORY, align 8
  %v2274 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2273, ptr %state, ptr %RDI, i64 %v2272)
  store ptr %v2274, ptr %MEMORY, align 8
  store i64 %v2270, ptr %PC, align 8
  %v2275 = add i64 %v2270, 3
  store i64 %v2275, ptr %NEXT_PC, align 8
  %v2276 = load i64, ptr %RBP, align 8
  %v2277 = load i64, ptr %RBP, align 8
  %v2278 = load ptr, ptr %MEMORY, align 8
  %v2279 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2278, ptr %state, i64 %v2276, i64 %v2277)
  store ptr %v2279, ptr %MEMORY, align 8
  store i64 %v2275, ptr %PC, align 8
  %v2280 = add i64 %v2275, 2
  store i64 %v2280, ptr %NEXT_PC, align 8
  %v2281 = add i64 %v2280, 42
  %v2282 = load ptr, ptr %MEMORY, align 8
  %v2283 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2282, ptr %state, ptr %BRANCH_TAKEN, i64 %v2281, i64 %v2280, ptr %NEXT_PC)
  store ptr %v2283, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878511, label %bb_5389878469

bb_5389878469:                                    ; preds = %bb_5389878454
  store i64 %v2280, ptr %PC, align 8
  %v2284 = add i64 %v2280, 4
  store i64 %v2284, ptr %NEXT_PC, align 8
  %v2285 = load i64, ptr %RBX, align 8
  %v2286 = load i64, ptr %RBP, align 8
  %v2287 = add i64 %v2286, 8
  %v2288 = load ptr, ptr %MEMORY, align 8
  %v2289 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2288, ptr %state, i64 %v2285, i64 %v2287)
  store ptr %v2289, ptr %MEMORY, align 8
  store i64 %v2284, ptr %PC, align 8
  %v2290 = add i64 %v2284, 2
  store i64 %v2290, ptr %NEXT_PC, align 8
  %v2291 = add i64 %v2290, 32
  %v2292 = load ptr, ptr %MEMORY, align 8
  %v2293 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2292, ptr %state, ptr %BRANCH_TAKEN, i64 %v2291, i64 %v2290, ptr %NEXT_PC)
  store ptr %v2293, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878507, label %bb_5389878475

bb_5389878475:                                    ; preds = %bb_5389878469
  store i64 %v2290, ptr %PC, align 8
  %v2294 = add i64 %v2290, 5
  store i64 %v2294, ptr %NEXT_PC, align 8
  %v2295 = load ptr, ptr %MEMORY, align 8
  %v2296 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2295, ptr %state, ptr %RDX, i64 24)
  store ptr %v2296, ptr %MEMORY, align 8
  store i64 %v2294, ptr %PC, align 8
  %v2297 = add i64 %v2294, 3
  store i64 %v2297, ptr %NEXT_PC, align 8
  %v2298 = load i64, ptr %RBP, align 8
  %v2299 = load ptr, ptr %MEMORY, align 8
  %v2300 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2299, ptr %state, ptr %RCX, i64 %v2298)
  store ptr %v2300, ptr %MEMORY, align 8
  store i64 %v2297, ptr %PC, align 8
  %v2301 = add i64 %v2297, 5
  store i64 %v2301, ptr %NEXT_PC, align 8
  %v2302 = sub i64 %v2301, 1165176
  %v2303 = load ptr, ptr %MEMORY, align 8
  %v2304 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2303, ptr %state, i64 5388713312, ptr %NEXT_PC, i64 %v2301, ptr %RETURN_PC)
  store ptr %v2304, ptr %MEMORY, align 8
  store i64 %v2301, ptr %PC, align 8
  %v2305 = add i64 %v2301, 4
  store i64 %v2305, ptr %NEXT_PC, align 8
  %v2306 = load i64, ptr %RBX, align 8
  %v2307 = add i64 %v2306, 48
  %v2308 = load ptr, ptr %MEMORY, align 8
  %v2309 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2308, ptr %state, ptr %RAX, i64 %v2307)
  store ptr %v2309, ptr %MEMORY, align 8
  store i64 %v2305, ptr %PC, align 8
  %v2310 = add i64 %v2305, 5
  store i64 %v2310, ptr %NEXT_PC, align 8
  %v2311 = load i64, ptr %RSP, align 8
  %v2312 = add i64 %v2311, 48
  %v2313 = load ptr, ptr %MEMORY, align 8
  %v2314 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2313, ptr %state, ptr %RBP, i64 %v2312)
  store ptr %v2314, ptr %MEMORY, align 8
  store i64 %v2310, ptr %PC, align 8
  %v2315 = add i64 %v2310, 4
  store i64 %v2315, ptr %NEXT_PC, align 8
  %v2316 = load i64, ptr %RAX, align 8
  %v2317 = add i64 %v2316, 16
  %v2318 = load i64, ptr %RAX, align 8
  %v2319 = add i64 %v2318, 16
  %v2320 = load ptr, ptr %MEMORY, align 8
  %v2321 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2320, ptr %state, i64 %v2317, i64 %v2319, i64 1)
  store ptr %v2321, ptr %MEMORY, align 8
  store i64 %v2315, ptr %PC, align 8
  %v2322 = add i64 %v2315, 4
  store i64 %v2322, ptr %NEXT_PC, align 8
  %v2323 = load i64, ptr %RSP, align 8
  %v2324 = load ptr, ptr %MEMORY, align 8
  %v2325 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2324, ptr %state, ptr %RSP, i64 %v2323, i64 32)
  store ptr %v2325, ptr %MEMORY, align 8
  store i64 %v2322, ptr %PC, align 8
  %v2326 = add i64 %v2322, 1
  store i64 %v2326, ptr %NEXT_PC, align 8
  %v2327 = load ptr, ptr %MEMORY, align 8
  %v2328 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2327, ptr %state, ptr %RBX)
  store ptr %v2328, ptr %MEMORY, align 8
  store i64 %v2326, ptr %PC, align 8
  %v2329 = add i64 %v2326, 1
  store i64 %v2329, ptr %NEXT_PC, align 8
  %v2330 = load ptr, ptr %MEMORY, align 8
  %v2331 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2330, ptr %state, ptr %NEXT_PC)
  store ptr %v2331, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878507:                                    ; preds = %bb_5389878469
  store i64 %v2290, ptr %PC, align 8
  %v2332 = add i64 %v2290, 4
  store i64 %v2332, ptr %NEXT_PC, align 8
  %v2333 = load i64, ptr %RBP, align 8
  %v2334 = add i64 %v2333, 16
  %v2335 = load i64, ptr %RBP, align 8
  %v2336 = add i64 %v2335, 16
  %v2337 = load ptr, ptr %MEMORY, align 8
  %v2338 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2337, ptr %state, i64 %v2334, i64 %v2336, i64 1)
  store ptr %v2338, ptr %MEMORY, align 8
  br label %bb_5389878511

bb_5389878511:                                    ; preds = %bb_5389878507, %bb_5389878454
  %v2339 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2339, ptr %PC, align 8
  %v2340 = add i64 %v2339, 4
  store i64 %v2340, ptr %NEXT_PC, align 8
  %v2341 = load i64, ptr %RBX, align 8
  %v2342 = add i64 %v2341, 48
  %v2343 = load ptr, ptr %MEMORY, align 8
  %v2344 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2343, ptr %state, ptr %RAX, i64 %v2342)
  store ptr %v2344, ptr %MEMORY, align 8
  store i64 %v2340, ptr %PC, align 8
  %v2345 = add i64 %v2340, 4
  store i64 %v2345, ptr %NEXT_PC, align 8
  %v2346 = load i64, ptr %RAX, align 8
  %v2347 = add i64 %v2346, 16
  %v2348 = load i64, ptr %RAX, align 8
  %v2349 = add i64 %v2348, 16
  %v2350 = load ptr, ptr %MEMORY, align 8
  %v2351 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2350, ptr %state, i64 %v2347, i64 %v2349, i64 1)
  store ptr %v2351, ptr %MEMORY, align 8
  br label %bb_5389878519

bb_5389878519:                                    ; preds = %bb_5389878511, %bb_5389878263
  %v2352 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2352, ptr %PC, align 8
  %v2353 = add i64 %v2352, 5
  store i64 %v2353, ptr %NEXT_PC, align 8
  %v2354 = load i64, ptr %RSP, align 8
  %v2355 = add i64 %v2354, 48
  %v2356 = load ptr, ptr %MEMORY, align 8
  %v2357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2356, ptr %state, ptr %RBP, i64 %v2355)
  store ptr %v2357, ptr %MEMORY, align 8
  br label %bb_5389878524

bb_5389878524:                                    ; preds = %bb_5389878519, %bb_5389878216
  %v2358 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2358, ptr %PC, align 8
  %v2359 = add i64 %v2358, 4
  store i64 %v2359, ptr %NEXT_PC, align 8
  %v2360 = load i64, ptr %RSP, align 8
  %v2361 = load ptr, ptr %MEMORY, align 8
  %v2362 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2361, ptr %state, ptr %RSP, i64 %v2360, i64 32)
  store ptr %v2362, ptr %MEMORY, align 8
  store i64 %v2359, ptr %PC, align 8
  %v2363 = add i64 %v2359, 1
  store i64 %v2363, ptr %NEXT_PC, align 8
  %v2364 = load ptr, ptr %MEMORY, align 8
  %v2365 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2364, ptr %state, ptr %RBX)
  store ptr %v2365, ptr %MEMORY, align 8
  store i64 %v2363, ptr %PC, align 8
  %v2366 = add i64 %v2363, 1
  store i64 %v2366, ptr %NEXT_PC, align 8
  %v2367 = load ptr, ptr %MEMORY, align 8
  %v2368 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2367, ptr %state, ptr %NEXT_PC)
  store ptr %v2368, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878530:                                    ; No predecessors!
  %v2369 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2369, ptr %PC, align 8
  %v2370 = add i64 %v2369, 1
  store i64 %v2370, ptr %NEXT_PC, align 8
  %v2371 = load ptr, ptr %MEMORY, align 8
  %v2372 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2371, ptr %state, ptr undef)
  store ptr %v2372, ptr %MEMORY, align 8
  store i64 %v2370, ptr %PC, align 8
  %v2373 = add i64 %v2370, 1
  store i64 %v2373, ptr %NEXT_PC, align 8
  %v2374 = load ptr, ptr %MEMORY, align 8
  %v2375 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2374, ptr %state, ptr undef)
  store ptr %v2375, ptr %MEMORY, align 8
  store i64 %v2373, ptr %PC, align 8
  %v2376 = add i64 %v2373, 1
  store i64 %v2376, ptr %NEXT_PC, align 8
  %v2377 = load ptr, ptr %MEMORY, align 8
  %v2378 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2377, ptr %state, ptr undef)
  store ptr %v2378, ptr %MEMORY, align 8
  store i64 %v2376, ptr %PC, align 8
  %v2379 = add i64 %v2376, 1
  store i64 %v2379, ptr %NEXT_PC, align 8
  %v2380 = load ptr, ptr %MEMORY, align 8
  %v2381 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2380, ptr %state, ptr undef)
  store ptr %v2381, ptr %MEMORY, align 8
  store i64 %v2379, ptr %PC, align 8
  %v2382 = add i64 %v2379, 1
  store i64 %v2382, ptr %NEXT_PC, align 8
  %v2383 = load ptr, ptr %MEMORY, align 8
  %v2384 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2383, ptr %state, ptr undef)
  store ptr %v2384, ptr %MEMORY, align 8
  store i64 %v2382, ptr %PC, align 8
  %v2385 = add i64 %v2382, 1
  store i64 %v2385, ptr %NEXT_PC, align 8
  %v2386 = load ptr, ptr %MEMORY, align 8
  %v2387 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2386, ptr %state, ptr undef)
  store ptr %v2387, ptr %MEMORY, align 8
  store i64 %v2385, ptr %PC, align 8
  %v2388 = add i64 %v2385, 1
  store i64 %v2388, ptr %NEXT_PC, align 8
  %v2389 = load ptr, ptr %MEMORY, align 8
  %v2390 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2389, ptr %state, ptr undef)
  store ptr %v2390, ptr %MEMORY, align 8
  store i64 %v2388, ptr %PC, align 8
  %v2391 = add i64 %v2388, 1
  store i64 %v2391, ptr %NEXT_PC, align 8
  %v2392 = load ptr, ptr %MEMORY, align 8
  %v2393 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2392, ptr %state, ptr undef)
  store ptr %v2393, ptr %MEMORY, align 8
  store i64 %v2391, ptr %PC, align 8
  %v2394 = add i64 %v2391, 1
  store i64 %v2394, ptr %NEXT_PC, align 8
  %v2395 = load ptr, ptr %MEMORY, align 8
  %v2396 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2395, ptr %state, ptr undef)
  store ptr %v2396, ptr %MEMORY, align 8
  store i64 %v2394, ptr %PC, align 8
  %v2397 = add i64 %v2394, 1
  store i64 %v2397, ptr %NEXT_PC, align 8
  %v2398 = load ptr, ptr %MEMORY, align 8
  %v2399 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2398, ptr %state, ptr undef)
  store ptr %v2399, ptr %MEMORY, align 8
  store i64 %v2397, ptr %PC, align 8
  %v2400 = add i64 %v2397, 1
  store i64 %v2400, ptr %NEXT_PC, align 8
  %v2401 = load ptr, ptr %MEMORY, align 8
  %v2402 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2401, ptr %state, ptr undef)
  store ptr %v2402, ptr %MEMORY, align 8
  store i64 %v2400, ptr %PC, align 8
  %v2403 = add i64 %v2400, 1
  store i64 %v2403, ptr %NEXT_PC, align 8
  %v2404 = load ptr, ptr %MEMORY, align 8
  %v2405 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2404, ptr %state, ptr undef)
  store ptr %v2405, ptr %MEMORY, align 8
  store i64 %v2403, ptr %PC, align 8
  %v2406 = add i64 %v2403, 1
  store i64 %v2406, ptr %NEXT_PC, align 8
  %v2407 = load ptr, ptr %MEMORY, align 8
  %v2408 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2407, ptr %state, ptr undef)
  store ptr %v2408, ptr %MEMORY, align 8
  store i64 %v2406, ptr %PC, align 8
  %v2409 = add i64 %v2406, 1
  store i64 %v2409, ptr %NEXT_PC, align 8
  %v2410 = load ptr, ptr %MEMORY, align 8
  %v2411 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2410, ptr %state, ptr undef)
  store ptr %v2411, ptr %MEMORY, align 8
  store i64 %v2409, ptr %PC, align 8
  %v2412 = add i64 %v2409, 5
  store i64 %v2412, ptr %NEXT_PC, align 8
  %v2413 = load i64, ptr %RSP, align 8
  %v2414 = add i64 %v2413, 24
  %v2415 = load i64, ptr %RBX, align 8
  %v2416 = load ptr, ptr %MEMORY, align 8
  %v2417 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2416, ptr %state, i64 %v2414, i64 %v2415)
  store ptr %v2417, ptr %MEMORY, align 8
  store i64 %v2412, ptr %PC, align 8
  %v2418 = add i64 %v2412, 1
  store i64 %v2418, ptr %NEXT_PC, align 8
  %v2419 = load i64, ptr %RDI, align 8
  %v2420 = load ptr, ptr %MEMORY, align 8
  %v2421 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2420, ptr %state, i64 %v2419)
  store ptr %v2421, ptr %MEMORY, align 8
  store i64 %v2418, ptr %PC, align 8
  %v2422 = add i64 %v2418, 4
  store i64 %v2422, ptr %NEXT_PC, align 8
  %v2423 = load i64, ptr %RSP, align 8
  %v2424 = load ptr, ptr %MEMORY, align 8
  %v2425 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2424, ptr %state, ptr %RSP, i64 %v2423, i64 32)
  store ptr %v2425, ptr %MEMORY, align 8
  store i64 %v2422, ptr %PC, align 8
  %v2426 = add i64 %v2422, 3
  store i64 %v2426, ptr %NEXT_PC, align 8
  %v2427 = load i64, ptr %RDX, align 8
  %v2428 = load ptr, ptr %MEMORY, align 8
  %v2429 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2428, ptr %state, ptr %RAX, i64 %v2427)
  store ptr %v2429, ptr %MEMORY, align 8
  store i64 %v2426, ptr %PC, align 8
  %v2430 = add i64 %v2426, 3
  store i64 %v2430, ptr %NEXT_PC, align 8
  %v2431 = load i64, ptr %RDX, align 8
  %v2432 = load ptr, ptr %MEMORY, align 8
  %v2433 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2432, ptr %state, ptr %RDI, i64 %v2431)
  store ptr %v2433, ptr %MEMORY, align 8
  store i64 %v2430, ptr %PC, align 8
  %v2434 = add i64 %v2430, 3
  store i64 %v2434, ptr %NEXT_PC, align 8
  %v2435 = load i64, ptr %RCX, align 8
  %v2436 = load ptr, ptr %MEMORY, align 8
  %v2437 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2436, ptr %state, ptr %RBX, i64 %v2435)
  store ptr %v2437, ptr %MEMORY, align 8
  store i64 %v2434, ptr %PC, align 8
  %v2438 = add i64 %v2434, 3
  store i64 %v2438, ptr %NEXT_PC, align 8
  %v2439 = load i64, ptr %RAX, align 8
  %v2440 = load i64, ptr %RAX, align 8
  %v2441 = load ptr, ptr %MEMORY, align 8
  %v2442 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2441, ptr %state, i64 %v2439, i64 %v2440)
  store ptr %v2442, ptr %MEMORY, align 8
  store i64 %v2438, ptr %PC, align 8
  %v2443 = add i64 %v2438, 6
  store i64 %v2443, ptr %NEXT_PC, align 8
  %v2444 = add i64 %v2443, 189
  %v2445 = load ptr, ptr %MEMORY, align 8
  %v2446 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2445, ptr %state, ptr %BRANCH_TAKEN, i64 %v2444, i64 %v2443, ptr %NEXT_PC)
  store ptr %v2446, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878761, label %bb_5389878572

bb_5389878572:                                    ; preds = %bb_5389878530
  store i64 %v2443, ptr %PC, align 8
  %v2447 = add i64 %v2443, 2
  store i64 %v2447, ptr %NEXT_PC, align 8
  %v2448 = load i64, ptr %RAX, align 8
  %v2449 = load i64, ptr %RAX, align 8
  %v2450 = load ptr, ptr %MEMORY, align 8
  %v2451 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2450, ptr %state, i64 %v2448, i64 %v2449)
  store ptr %v2451, ptr %MEMORY, align 8
  store i64 %v2447, ptr %PC, align 8
  %v2452 = add i64 %v2447, 4
  store i64 %v2452, ptr %NEXT_PC, align 8
  %v2453 = load i64, ptr %RAX, align 8
  %v2454 = add i64 %v2453, 48
  %v2455 = load ptr, ptr %MEMORY, align 8
  %v2456 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2455, ptr %state, ptr %RAX, i64 %v2454)
  store ptr %v2456, ptr %MEMORY, align 8
  store i64 %v2452, ptr %PC, align 8
  %v2457 = add i64 %v2452, 5
  store i64 %v2457, ptr %NEXT_PC, align 8
  %v2458 = load i64, ptr %RSP, align 8
  %v2459 = add i64 %v2458, 48
  %v2460 = load i64, ptr %RSI, align 8
  %v2461 = load ptr, ptr %MEMORY, align 8
  %v2462 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2461, ptr %state, i64 %v2459, i64 %v2460)
  store ptr %v2462, ptr %MEMORY, align 8
  store i64 %v2457, ptr %PC, align 8
  %v2463 = add i64 %v2457, 2
  store i64 %v2463, ptr %NEXT_PC, align 8
  %v2464 = load i64, ptr %RAX, align 8
  %v2465 = load i64, ptr %RAX, align 8
  %v2466 = load ptr, ptr %MEMORY, align 8
  %v2467 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2466, ptr %state, i64 %v2464, i64 %v2465)
  store ptr %v2467, ptr %MEMORY, align 8
  store i64 %v2463, ptr %PC, align 8
  %v2468 = add i64 %v2463, 3
  store i64 %v2468, ptr %NEXT_PC, align 8
  %v2469 = load i64, ptr %RDX, align 8
  %v2470 = load ptr, ptr %MEMORY, align 8
  %v2471 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2470, ptr %state, ptr %RAX, i64 %v2469)
  store ptr %v2471, ptr %MEMORY, align 8
  store i64 %v2468, ptr %PC, align 8
  %v2472 = add i64 %v2468, 5
  store i64 %v2472, ptr %NEXT_PC, align 8
  %v2473 = load i64, ptr %RSP, align 8
  %v2474 = add i64 %v2473, 56
  %v2475 = load ptr, ptr %MEMORY, align 8
  %v2476 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2475, ptr %state, ptr %RDX, i64 %v2474)
  store ptr %v2476, ptr %MEMORY, align 8
  store i64 %v2472, ptr %PC, align 8
  %v2477 = add i64 %v2472, 5
  store i64 %v2477, ptr %NEXT_PC, align 8
  %v2478 = load i64, ptr %RSP, align 8
  %v2479 = add i64 %v2478, 56
  %v2480 = load i64, ptr %RAX, align 8
  %v2481 = load ptr, ptr %MEMORY, align 8
  %v2482 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2481, ptr %state, i64 %v2479, i64 %v2480)
  store ptr %v2482, ptr %MEMORY, align 8
  store i64 %v2477, ptr %PC, align 8
  %v2483 = add i64 %v2477, 5
  store i64 %v2483, ptr %NEXT_PC, align 8
  %v2484 = add i64 %v2483, 181
  %v2485 = load ptr, ptr %MEMORY, align 8
  %v2486 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2485, ptr %state, i64 5389878784, ptr %NEXT_PC, i64 %v2483, ptr %RETURN_PC)
  store ptr %v2486, ptr %MEMORY, align 8
  store i64 %v2483, ptr %PC, align 8
  %v2487 = add i64 %v2483, 3
  store i64 %v2487, ptr %NEXT_PC, align 8
  %v2488 = load i64, ptr %RBX, align 8
  %v2489 = add i64 %v2488, 24
  %v2490 = load ptr, ptr %MEMORY, align 8
  %v2491 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2490, ptr %state, ptr %RAX, i64 %v2489)
  store ptr %v2491, ptr %MEMORY, align 8
  store i64 %v2487, ptr %PC, align 8
  %v2492 = add i64 %v2487, 3
  store i64 %v2492, ptr %NEXT_PC, align 8
  %v2493 = load i64, ptr %RAX, align 8
  %v2494 = add i64 %v2493, 1
  %v2495 = load ptr, ptr %MEMORY, align 8
  %v2496 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2495, ptr %state, ptr %RDX, i64 %v2494)
  store ptr %v2496, ptr %MEMORY, align 8
  store i64 %v2492, ptr %PC, align 8
  %v2497 = add i64 %v2492, 3
  store i64 %v2497, ptr %NEXT_PC, align 8
  %v2498 = load i32, ptr %EDX, align 4
  %v2499 = zext i32 %v2498 to i64
  %v2500 = load i64, ptr %RBX, align 8
  %v2501 = add i64 %v2500, 28
  %v2502 = load ptr, ptr %MEMORY, align 8
  %v2503 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2502, ptr %state, i64 %v2499, i64 %v2501)
  store ptr %v2503, ptr %MEMORY, align 8
  store i64 %v2497, ptr %PC, align 8
  %v2504 = add i64 %v2497, 2
  store i64 %v2504, ptr %NEXT_PC, align 8
  %v2505 = add i64 %v2504, 18
  %v2506 = load ptr, ptr %MEMORY, align 8
  %v2507 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2506, ptr %state, ptr %BRANCH_TAKEN, i64 %v2505, i64 %v2504, ptr %NEXT_PC)
  store ptr %v2507, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878632, label %bb_5389878614

bb_5389878614:                                    ; preds = %bb_5389878572
  store i64 %v2504, ptr %PC, align 8
  %v2508 = add i64 %v2504, 6
  store i64 %v2508, ptr %NEXT_PC, align 8
  %v2509 = load ptr, ptr %MEMORY, align 8
  %v2510 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2509, ptr %state, ptr %R8, i64 134217736)
  store ptr %v2510, ptr %MEMORY, align 8
  store i64 %v2508, ptr %PC, align 8
  %v2511 = add i64 %v2508, 4
  store i64 %v2511, ptr %NEXT_PC, align 8
  %v2512 = load i64, ptr %RBX, align 8
  %v2513 = add i64 %v2512, 16
  %v2514 = load ptr, ptr %MEMORY, align 8
  %v2515 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2514, ptr %state, ptr %RCX, i64 %v2513)
  store ptr %v2515, ptr %MEMORY, align 8
  store i64 %v2511, ptr %PC, align 8
  %v2516 = add i64 %v2511, 5
  store i64 %v2516, ptr %NEXT_PC, align 8
  %v2517 = sub i64 %v2516, 644997
  %v2518 = load ptr, ptr %MEMORY, align 8
  %v2519 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2518, ptr %state, i64 5389233632, ptr %NEXT_PC, i64 %v2516, ptr %RETURN_PC)
  store ptr %v2519, ptr %MEMORY, align 8
  store i64 %v2516, ptr %PC, align 8
  %v2520 = add i64 %v2516, 3
  store i64 %v2520, ptr %NEXT_PC, align 8
  %v2521 = load i64, ptr %RBX, align 8
  %v2522 = add i64 %v2521, 24
  %v2523 = load ptr, ptr %MEMORY, align 8
  %v2524 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2523, ptr %state, ptr %RAX, i64 %v2522)
  store ptr %v2524, ptr %MEMORY, align 8
  br label %bb_5389878632

bb_5389878632:                                    ; preds = %bb_5389878614, %bb_5389878572
  %v2525 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2525, ptr %PC, align 8
  %v2526 = add i64 %v2525, 3
  store i64 %v2526, ptr %NEXT_PC, align 8
  %v2527 = load i32, ptr %EAX, align 4
  %v2528 = zext i32 %v2527 to i64
  %v2529 = load i64, ptr %RBX, align 8
  %v2530 = add i64 %v2529, 28
  %v2531 = load ptr, ptr %MEMORY, align 8
  %v2532 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2531, ptr %state, i64 %v2528, i64 %v2530)
  store ptr %v2532, ptr %MEMORY, align 8
  store i64 %v2526, ptr %PC, align 8
  %v2533 = add i64 %v2526, 2
  store i64 %v2533, ptr %NEXT_PC, align 8
  %v2534 = add i64 %v2533, 38
  %v2535 = load ptr, ptr %MEMORY, align 8
  %v2536 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2535, ptr %state, ptr %BRANCH_TAKEN, i64 %v2534, i64 %v2533, ptr %NEXT_PC)
  store ptr %v2536, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878675, label %bb_5389878637

bb_5389878637:                                    ; preds = %bb_5389878632
  store i64 %v2533, ptr %PC, align 8
  %v2537 = add i64 %v2533, 3
  store i64 %v2537, ptr %NEXT_PC, align 8
  %v2538 = load i32, ptr %EAX, align 4
  %v2539 = zext i32 %v2538 to i64
  %v2540 = load ptr, ptr %MEMORY, align 8
  %v2541 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v2540, ptr %state, ptr %RCX, i64 %v2539)
  store ptr %v2541, ptr %MEMORY, align 8
  store i64 %v2537, ptr %PC, align 8
  %v2542 = add i64 %v2537, 4
  store i64 %v2542, ptr %NEXT_PC, align 8
  %v2543 = load i64, ptr %RBX, align 8
  %v2544 = add i64 %v2543, 16
  %v2545 = load ptr, ptr %MEMORY, align 8
  %v2546 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2545, ptr %state, ptr %RAX, i64 %v2544)
  store ptr %v2546, ptr %MEMORY, align 8
  store i64 %v2542, ptr %PC, align 8
  %v2547 = add i64 %v2542, 4
  store i64 %v2547, ptr %NEXT_PC, align 8
  %v2548 = load i64, ptr %RAX, align 8
  %v2549 = load i64, ptr %RCX, align 8
  %v2550 = mul i64 %v2549, 8
  %v2551 = add i64 %v2548, %v2550
  %v2552 = load ptr, ptr %MEMORY, align 8
  %v2553 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2552, ptr %state, ptr %RDX, i64 %v2551)
  store ptr %v2553, ptr %MEMORY, align 8
  store i64 %v2547, ptr %PC, align 8
  %v2554 = add i64 %v2547, 3
  store i64 %v2554, ptr %NEXT_PC, align 8
  %v2555 = load i64, ptr %RDI, align 8
  %v2556 = load ptr, ptr %MEMORY, align 8
  %v2557 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2556, ptr %state, ptr %RAX, i64 %v2555)
  store ptr %v2557, ptr %MEMORY, align 8
  store i64 %v2554, ptr %PC, align 8
  %v2558 = add i64 %v2554, 3
  store i64 %v2558, ptr %NEXT_PC, align 8
  %v2559 = load i64, ptr %RAX, align 8
  %v2560 = load i64, ptr %RAX, align 8
  %v2561 = load ptr, ptr %MEMORY, align 8
  %v2562 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2561, ptr %state, i64 %v2559, i64 %v2560)
  store ptr %v2562, ptr %MEMORY, align 8
  store i64 %v2558, ptr %PC, align 8
  %v2563 = add i64 %v2558, 2
  store i64 %v2563, ptr %NEXT_PC, align 8
  %v2564 = add i64 %v2563, 11
  %v2565 = load ptr, ptr %MEMORY, align 8
  %v2566 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2565, ptr %state, ptr %BRANCH_TAKEN, i64 %v2564, i64 %v2563, ptr %NEXT_PC)
  store ptr %v2566, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878667, label %bb_5389878656

bb_5389878656:                                    ; preds = %bb_5389878637
  store i64 %v2563, ptr %PC, align 8
  %v2567 = add i64 %v2563, 2
  store i64 %v2567, ptr %NEXT_PC, align 8
  %v2568 = load i64, ptr %RAX, align 8
  %v2569 = load i64, ptr %RAX, align 8
  %v2570 = load ptr, ptr %MEMORY, align 8
  %v2571 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2570, ptr %state, i64 %v2568, i64 %v2569)
  store ptr %v2571, ptr %MEMORY, align 8
  store i64 %v2567, ptr %PC, align 8
  %v2572 = add i64 %v2567, 4
  store i64 %v2572, ptr %NEXT_PC, align 8
  %v2573 = load i64, ptr %RAX, align 8
  %v2574 = add i64 %v2573, 48
  %v2575 = load ptr, ptr %MEMORY, align 8
  %v2576 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2575, ptr %state, ptr %RAX, i64 %v2574)
  store ptr %v2576, ptr %MEMORY, align 8
  store i64 %v2572, ptr %PC, align 8
  %v2577 = add i64 %v2572, 2
  store i64 %v2577, ptr %NEXT_PC, align 8
  %v2578 = load i64, ptr %RAX, align 8
  %v2579 = load i64, ptr %RAX, align 8
  %v2580 = load ptr, ptr %MEMORY, align 8
  %v2581 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2580, ptr %state, i64 %v2578, i64 %v2579)
  store ptr %v2581, ptr %MEMORY, align 8
  store i64 %v2577, ptr %PC, align 8
  %v2582 = add i64 %v2577, 3
  store i64 %v2582, ptr %NEXT_PC, align 8
  %v2583 = load i64, ptr %RDI, align 8
  %v2584 = load ptr, ptr %MEMORY, align 8
  %v2585 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2584, ptr %state, ptr %RAX, i64 %v2583)
  store ptr %v2585, ptr %MEMORY, align 8
  br label %bb_5389878667

bb_5389878667:                                    ; preds = %bb_5389878656, %bb_5389878637
  %v2586 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2586, ptr %PC, align 8
  %v2587 = add i64 %v2586, 3
  store i64 %v2587, ptr %NEXT_PC, align 8
  %v2588 = load i64, ptr %RDX, align 8
  %v2589 = load i64, ptr %RAX, align 8
  %v2590 = load ptr, ptr %MEMORY, align 8
  %v2591 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2590, ptr %state, i64 %v2588, i64 %v2589)
  store ptr %v2591, ptr %MEMORY, align 8
  store i64 %v2587, ptr %PC, align 8
  %v2592 = add i64 %v2587, 3
  store i64 %v2592, ptr %NEXT_PC, align 8
  %v2593 = load i64, ptr %RBX, align 8
  %v2594 = add i64 %v2593, 24
  %v2595 = load i64, ptr %RBX, align 8
  %v2596 = add i64 %v2595, 24
  %v2597 = load ptr, ptr %MEMORY, align 8
  %v2598 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2597, ptr %state, i64 %v2594, i64 %v2596)
  store ptr %v2598, ptr %MEMORY, align 8
  store i64 %v2592, ptr %PC, align 8
  %v2599 = add i64 %v2592, 2
  store i64 %v2599, ptr %NEXT_PC, align 8
  %v2600 = add i64 %v2599, 53
  %v2601 = load ptr, ptr %MEMORY, align 8
  %v2602 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2601, ptr %state, i64 %v2600, ptr %NEXT_PC)
  store ptr %v2602, ptr %MEMORY, align 8
  br label %bb_5389878728

bb_5389878675:                                    ; preds = %bb_5389878632
  store i64 %v2533, ptr %PC, align 8
  %v2603 = add i64 %v2533, 6
  store i64 %v2603, ptr %NEXT_PC, align 8
  %v2604 = load ptr, ptr %MEMORY, align 8
  %v2605 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2604, ptr %state, ptr %R8, i64 134217736)
  store ptr %v2605, ptr %MEMORY, align 8
  store i64 %v2603, ptr %PC, align 8
  %v2606 = add i64 %v2603, 4
  store i64 %v2606, ptr %NEXT_PC, align 8
  %v2607 = load i64, ptr %RBX, align 8
  %v2608 = add i64 %v2607, 16
  %v2609 = load ptr, ptr %MEMORY, align 8
  %v2610 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2609, ptr %state, ptr %RCX, i64 %v2608)
  store ptr %v2610, ptr %MEMORY, align 8
  store i64 %v2606, ptr %PC, align 8
  %v2611 = add i64 %v2606, 3
  store i64 %v2611, ptr %NEXT_PC, align 8
  %v2612 = load i64, ptr %RDI, align 8
  %v2613 = load ptr, ptr %MEMORY, align 8
  %v2614 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2613, ptr %state, ptr %RDX, i64 %v2612)
  store ptr %v2614, ptr %MEMORY, align 8
  store i64 %v2611, ptr %PC, align 8
  %v2615 = add i64 %v2611, 5
  store i64 %v2615, ptr %NEXT_PC, align 8
  %v2616 = sub i64 %v2615, 644773
  %v2617 = load ptr, ptr %MEMORY, align 8
  %v2618 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2617, ptr %state, i64 5389233920, ptr %NEXT_PC, i64 %v2615, ptr %RETURN_PC)
  store ptr %v2618, ptr %MEMORY, align 8
  store i64 %v2615, ptr %PC, align 8
  %v2619 = add i64 %v2615, 4
  store i64 %v2619, ptr %NEXT_PC, align 8
  %v2620 = load i64, ptr %RBX, align 8
  %v2621 = add i64 %v2620, 16
  %v2622 = load ptr, ptr %MEMORY, align 8
  %v2623 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2622, ptr %state, ptr %RCX, i64 %v2621)
  store ptr %v2623, ptr %MEMORY, align 8
  store i64 %v2619, ptr %PC, align 8
  %v2624 = add i64 %v2619, 4
  store i64 %v2624, ptr %NEXT_PC, align 8
  %v2625 = load i64, ptr %RBX, align 8
  %v2626 = add i64 %v2625, 24
  %v2627 = load ptr, ptr %MEMORY, align 8
  %v2628 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %v2627, ptr %state, ptr %RDX, i64 %v2626)
  store ptr %v2628, ptr %MEMORY, align 8
  store i64 %v2624, ptr %PC, align 8
  %v2629 = add i64 %v2624, 4
  store i64 %v2629, ptr %NEXT_PC, align 8
  %v2630 = load i64, ptr %RCX, align 8
  %v2631 = load i64, ptr %RDX, align 8
  %v2632 = mul i64 %v2631, 8
  %v2633 = add i64 %v2630, %v2632
  %v2634 = load ptr, ptr %MEMORY, align 8
  %v2635 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2634, ptr %state, ptr %R8, i64 %v2633)
  store ptr %v2635, ptr %MEMORY, align 8
  store i64 %v2629, ptr %PC, align 8
  %v2636 = add i64 %v2629, 3
  store i64 %v2636, ptr %NEXT_PC, align 8
  %v2637 = load i64, ptr %RAX, align 8
  %v2638 = load ptr, ptr %MEMORY, align 8
  %v2639 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2638, ptr %state, ptr %RCX, i64 %v2637)
  store ptr %v2639, ptr %MEMORY, align 8
  store i64 %v2636, ptr %PC, align 8
  %v2640 = add i64 %v2636, 3
  store i64 %v2640, ptr %NEXT_PC, align 8
  %v2641 = load i64, ptr %RCX, align 8
  %v2642 = load i64, ptr %RCX, align 8
  %v2643 = load ptr, ptr %MEMORY, align 8
  %v2644 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2643, ptr %state, i64 %v2641, i64 %v2642)
  store ptr %v2644, ptr %MEMORY, align 8
  store i64 %v2640, ptr %PC, align 8
  %v2645 = add i64 %v2640, 2
  store i64 %v2645, ptr %NEXT_PC, align 8
  %v2646 = add i64 %v2645, 11
  %v2647 = load ptr, ptr %MEMORY, align 8
  %v2648 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2647, ptr %state, ptr %BRANCH_TAKEN, i64 %v2646, i64 %v2645, ptr %NEXT_PC)
  store ptr %v2648, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878724, label %bb_5389878713

bb_5389878713:                                    ; preds = %bb_5389878675
  store i64 %v2645, ptr %PC, align 8
  %v2649 = add i64 %v2645, 2
  store i64 %v2649, ptr %NEXT_PC, align 8
  %v2650 = load i64, ptr %RCX, align 8
  %v2651 = load i64, ptr %RCX, align 8
  %v2652 = load ptr, ptr %MEMORY, align 8
  %v2653 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2652, ptr %state, i64 %v2650, i64 %v2651)
  store ptr %v2653, ptr %MEMORY, align 8
  store i64 %v2649, ptr %PC, align 8
  %v2654 = add i64 %v2649, 4
  store i64 %v2654, ptr %NEXT_PC, align 8
  %v2655 = load i64, ptr %RCX, align 8
  %v2656 = add i64 %v2655, 48
  %v2657 = load ptr, ptr %MEMORY, align 8
  %v2658 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2657, ptr %state, ptr %RCX, i64 %v2656)
  store ptr %v2658, ptr %MEMORY, align 8
  store i64 %v2654, ptr %PC, align 8
  %v2659 = add i64 %v2654, 2
  store i64 %v2659, ptr %NEXT_PC, align 8
  %v2660 = load i64, ptr %RCX, align 8
  %v2661 = load i64, ptr %RCX, align 8
  %v2662 = load ptr, ptr %MEMORY, align 8
  %v2663 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2662, ptr %state, i64 %v2660, i64 %v2661)
  store ptr %v2663, ptr %MEMORY, align 8
  store i64 %v2659, ptr %PC, align 8
  %v2664 = add i64 %v2659, 3
  store i64 %v2664, ptr %NEXT_PC, align 8
  %v2665 = load i64, ptr %RAX, align 8
  %v2666 = load ptr, ptr %MEMORY, align 8
  %v2667 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2666, ptr %state, ptr %RCX, i64 %v2665)
  store ptr %v2667, ptr %MEMORY, align 8
  br label %bb_5389878724

bb_5389878724:                                    ; preds = %bb_5389878713, %bb_5389878675
  %v2668 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2668, ptr %PC, align 8
  %v2669 = add i64 %v2668, 4
  store i64 %v2669, ptr %NEXT_PC, align 8
  %v2670 = load i64, ptr %R8, align 8
  %v2671 = sub i64 %v2670, 8
  %v2672 = load i64, ptr %RCX, align 8
  %v2673 = load ptr, ptr %MEMORY, align 8
  %v2674 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2673, ptr %state, i64 %v2671, i64 %v2672)
  store ptr %v2674, ptr %MEMORY, align 8
  br label %bb_5389878728

bb_5389878728:                                    ; preds = %bb_5389878724, %bb_5389878667
  %v2675 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2675, ptr %PC, align 8
  %v2676 = add i64 %v2675, 3
  store i64 %v2676, ptr %NEXT_PC, align 8
  %v2677 = load i64, ptr %RDI, align 8
  %v2678 = load ptr, ptr %MEMORY, align 8
  %v2679 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2678, ptr %state, ptr %RCX, i64 %v2677)
  store ptr %v2679, ptr %MEMORY, align 8
  store i64 %v2676, ptr %PC, align 8
  %v2680 = add i64 %v2676, 4
  store i64 %v2680, ptr %NEXT_PC, align 8
  %v2681 = load i64, ptr %RBX, align 8
  %v2682 = add i64 %v2681, 48
  %v2683 = load ptr, ptr %MEMORY, align 8
  %v2684 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2683, ptr %state, ptr %RAX, i64 %v2682)
  store ptr %v2684, ptr %MEMORY, align 8
  store i64 %v2680, ptr %PC, align 8
  %v2685 = add i64 %v2680, 5
  store i64 %v2685, ptr %NEXT_PC, align 8
  %v2686 = load i64, ptr %RSP, align 8
  %v2687 = add i64 %v2686, 48
  %v2688 = load ptr, ptr %MEMORY, align 8
  %v2689 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2688, ptr %state, ptr %RSI, i64 %v2687)
  store ptr %v2689, ptr %MEMORY, align 8
  store i64 %v2685, ptr %PC, align 8
  %v2690 = add i64 %v2685, 4
  store i64 %v2690, ptr %NEXT_PC, align 8
  %v2691 = load i64, ptr %RCX, align 8
  %v2692 = add i64 %v2691, 48
  %v2693 = load i64, ptr %RAX, align 8
  %v2694 = load ptr, ptr %MEMORY, align 8
  %v2695 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2694, ptr %state, i64 %v2692, i64 %v2693)
  store ptr %v2695, ptr %MEMORY, align 8
  store i64 %v2690, ptr %PC, align 8
  %v2696 = add i64 %v2690, 2
  store i64 %v2696, ptr %NEXT_PC, align 8
  %v2697 = add i64 %v2696, 5
  %v2698 = load ptr, ptr %MEMORY, align 8
  %v2699 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2698, ptr %state, ptr %BRANCH_TAKEN, i64 %v2697, i64 %v2696, ptr %NEXT_PC)
  store ptr %v2699, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878751, label %bb_5389878746

bb_5389878746:                                    ; preds = %bb_5389878728
  store i64 %v2696, ptr %PC, align 8
  %v2700 = add i64 %v2696, 2
  store i64 %v2700, ptr %NEXT_PC, align 8
  %v2701 = load i64, ptr %RAX, align 8
  %v2702 = load i64, ptr %RAX, align 8
  %v2703 = load ptr, ptr %MEMORY, align 8
  %v2704 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2703, ptr %state, i64 %v2701, i64 %v2702)
  store ptr %v2704, ptr %MEMORY, align 8
  store i64 %v2700, ptr %PC, align 8
  %v2705 = add i64 %v2700, 3
  store i64 %v2705, ptr %NEXT_PC, align 8
  %v2706 = load i64, ptr %RDI, align 8
  %v2707 = load ptr, ptr %MEMORY, align 8
  %v2708 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2707, ptr %state, ptr %RCX, i64 %v2706)
  store ptr %v2708, ptr %MEMORY, align 8
  br label %bb_5389878751

bb_5389878751:                                    ; preds = %bb_5389878746, %bb_5389878728
  %v2709 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2709, ptr %PC, align 8
  %v2710 = add i64 %v2709, 3
  store i64 %v2710, ptr %NEXT_PC, align 8
  %v2711 = load i64, ptr %RCX, align 8
  %v2712 = load i64, ptr %RCX, align 8
  %v2713 = load ptr, ptr %MEMORY, align 8
  %v2714 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2713, ptr %state, i64 %v2711, i64 %v2712)
  store ptr %v2714, ptr %MEMORY, align 8
  store i64 %v2710, ptr %PC, align 8
  %v2715 = add i64 %v2710, 2
  store i64 %v2715, ptr %NEXT_PC, align 8
  %v2716 = add i64 %v2715, 5
  %v2717 = load ptr, ptr %MEMORY, align 8
  %v2718 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2717, ptr %state, ptr %BRANCH_TAKEN, i64 %v2716, i64 %v2715, ptr %NEXT_PC)
  store ptr %v2718, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878761, label %bb_5389878756

bb_5389878756:                                    ; preds = %bb_5389878751
  store i64 %v2715, ptr %PC, align 8
  %v2719 = add i64 %v2715, 5
  store i64 %v2719, ptr %NEXT_PC, align 8
  %v2720 = sub i64 %v2719, 2057
  %v2721 = load ptr, ptr %MEMORY, align 8
  %v2722 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2721, ptr %state, i64 5389876704, ptr %NEXT_PC, i64 %v2719, ptr %RETURN_PC)
  store ptr %v2722, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878761:                                    ; preds = %bb_5389878751, %bb_5389878530
  %v2723 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2723, ptr %PC, align 8
  %v2724 = add i64 %v2723, 5
  store i64 %v2724, ptr %NEXT_PC, align 8
  %v2725 = load i64, ptr %RSP, align 8
  %v2726 = add i64 %v2725, 64
  %v2727 = load ptr, ptr %MEMORY, align 8
  %v2728 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2727, ptr %state, ptr %RBX, i64 %v2726)
  store ptr %v2728, ptr %MEMORY, align 8
  store i64 %v2724, ptr %PC, align 8
  %v2729 = add i64 %v2724, 4
  store i64 %v2729, ptr %NEXT_PC, align 8
  %v2730 = load i64, ptr %RSP, align 8
  %v2731 = load ptr, ptr %MEMORY, align 8
  %v2732 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2731, ptr %state, ptr %RSP, i64 %v2730, i64 32)
  store ptr %v2732, ptr %MEMORY, align 8
  store i64 %v2729, ptr %PC, align 8
  %v2733 = add i64 %v2729, 1
  store i64 %v2733, ptr %NEXT_PC, align 8
  %v2734 = load ptr, ptr %MEMORY, align 8
  %v2735 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2734, ptr %state, ptr %RDI)
  store ptr %v2735, ptr %MEMORY, align 8
  store i64 %v2733, ptr %PC, align 8
  %v2736 = add i64 %v2733, 1
  store i64 %v2736, ptr %NEXT_PC, align 8
  %v2737 = load ptr, ptr %MEMORY, align 8
  %v2738 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2737, ptr %state, ptr %NEXT_PC)
  store ptr %v2738, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878772:                                    ; No predecessors!
  %v2739 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2739, ptr %PC, align 8
  %v2740 = add i64 %v2739, 1
  store i64 %v2740, ptr %NEXT_PC, align 8
  %v2741 = load ptr, ptr %MEMORY, align 8
  %v2742 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2741, ptr %state, ptr undef)
  store ptr %v2742, ptr %MEMORY, align 8
  store i64 %v2740, ptr %PC, align 8
  %v2743 = add i64 %v2740, 1
  store i64 %v2743, ptr %NEXT_PC, align 8
  %v2744 = load ptr, ptr %MEMORY, align 8
  %v2745 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2744, ptr %state, ptr undef)
  store ptr %v2745, ptr %MEMORY, align 8
  store i64 %v2743, ptr %PC, align 8
  %v2746 = add i64 %v2743, 1
  store i64 %v2746, ptr %NEXT_PC, align 8
  %v2747 = load ptr, ptr %MEMORY, align 8
  %v2748 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2747, ptr %state, ptr undef)
  store ptr %v2748, ptr %MEMORY, align 8
  store i64 %v2746, ptr %PC, align 8
  %v2749 = add i64 %v2746, 1
  store i64 %v2749, ptr %NEXT_PC, align 8
  %v2750 = load ptr, ptr %MEMORY, align 8
  %v2751 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2750, ptr %state, ptr undef)
  store ptr %v2751, ptr %MEMORY, align 8
  store i64 %v2749, ptr %PC, align 8
  %v2752 = add i64 %v2749, 1
  store i64 %v2752, ptr %NEXT_PC, align 8
  %v2753 = load ptr, ptr %MEMORY, align 8
  %v2754 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2753, ptr %state, ptr undef)
  store ptr %v2754, ptr %MEMORY, align 8
  store i64 %v2752, ptr %PC, align 8
  %v2755 = add i64 %v2752, 1
  store i64 %v2755, ptr %NEXT_PC, align 8
  %v2756 = load ptr, ptr %MEMORY, align 8
  %v2757 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2756, ptr %state, ptr undef)
  store ptr %v2757, ptr %MEMORY, align 8
  store i64 %v2755, ptr %PC, align 8
  %v2758 = add i64 %v2755, 1
  store i64 %v2758, ptr %NEXT_PC, align 8
  %v2759 = load ptr, ptr %MEMORY, align 8
  %v2760 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2759, ptr %state, ptr undef)
  store ptr %v2760, ptr %MEMORY, align 8
  store i64 %v2758, ptr %PC, align 8
  %v2761 = add i64 %v2758, 1
  store i64 %v2761, ptr %NEXT_PC, align 8
  %v2762 = load ptr, ptr %MEMORY, align 8
  %v2763 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2762, ptr %state, ptr undef)
  store ptr %v2763, ptr %MEMORY, align 8
  store i64 %v2761, ptr %PC, align 8
  %v2764 = add i64 %v2761, 1
  store i64 %v2764, ptr %NEXT_PC, align 8
  %v2765 = load ptr, ptr %MEMORY, align 8
  %v2766 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2765, ptr %state, ptr undef)
  store ptr %v2766, ptr %MEMORY, align 8
  store i64 %v2764, ptr %PC, align 8
  %v2767 = add i64 %v2764, 1
  store i64 %v2767, ptr %NEXT_PC, align 8
  %v2768 = load ptr, ptr %MEMORY, align 8
  %v2769 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2768, ptr %state, ptr undef)
  store ptr %v2769, ptr %MEMORY, align 8
  store i64 %v2767, ptr %PC, align 8
  %v2770 = add i64 %v2767, 1
  store i64 %v2770, ptr %NEXT_PC, align 8
  %v2771 = load ptr, ptr %MEMORY, align 8
  %v2772 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2771, ptr %state, ptr undef)
  store ptr %v2772, ptr %MEMORY, align 8
  store i64 %v2770, ptr %PC, align 8
  %v2773 = add i64 %v2770, 1
  store i64 %v2773, ptr %NEXT_PC, align 8
  %v2774 = load ptr, ptr %MEMORY, align 8
  %v2775 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2774, ptr %state, ptr undef)
  store ptr %v2775, ptr %MEMORY, align 8
  store i64 %v2773, ptr %PC, align 8
  %v2776 = add i64 %v2773, 2
  store i64 %v2776, ptr %NEXT_PC, align 8
  %v2777 = load i64, ptr %RBX, align 8
  %v2778 = load ptr, ptr %MEMORY, align 8
  %v2779 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2778, ptr %state, i64 %v2777)
  store ptr %v2779, ptr %MEMORY, align 8
  store i64 %v2776, ptr %PC, align 8
  %v2780 = add i64 %v2776, 2
  store i64 %v2780, ptr %NEXT_PC, align 8
  %v2781 = load i64, ptr %R13, align 8
  %v2782 = load ptr, ptr %MEMORY, align 8
  %v2783 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2782, ptr %state, i64 %v2781)
  store ptr %v2783, ptr %MEMORY, align 8
  store i64 %v2780, ptr %PC, align 8
  %v2784 = add i64 %v2780, 4
  store i64 %v2784, ptr %NEXT_PC, align 8
  %v2785 = load i64, ptr %RSP, align 8
  %v2786 = load ptr, ptr %MEMORY, align 8
  %v2787 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2786, ptr %state, ptr %RSP, i64 %v2785, i64 56)
  store ptr %v2787, ptr %MEMORY, align 8
  store i64 %v2784, ptr %PC, align 8
  %v2788 = add i64 %v2784, 4
  store i64 %v2788, ptr %NEXT_PC, align 8
  %v2789 = load i64, ptr %RCX, align 8
  %v2790 = add i64 %v2789, 24
  %v2791 = load ptr, ptr %MEMORY, align 8
  %v2792 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %v2791, ptr %state, ptr %RAX, i64 %v2790)
  store ptr %v2792, ptr %MEMORY, align 8
  store i64 %v2788, ptr %PC, align 8
  %v2793 = add i64 %v2788, 3
  store i64 %v2793, ptr %NEXT_PC, align 8
  %v2794 = load i64, ptr %R13, align 8
  %v2795 = load i32, ptr %R13D, align 4
  %v2796 = zext i32 %v2795 to i64
  %v2797 = load ptr, ptr %MEMORY, align 8
  %v2798 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2797, ptr %state, ptr %R13, i64 %v2794, i64 %v2796)
  store ptr %v2798, ptr %MEMORY, align 8
  store i64 %v2793, ptr %PC, align 8
  %v2799 = add i64 %v2793, 5
  store i64 %v2799, ptr %NEXT_PC, align 8
  %v2800 = load i64, ptr %RSP, align 8
  %v2801 = add i64 %v2800, 88
  %v2802 = load i64, ptr %RSI, align 8
  %v2803 = load ptr, ptr %MEMORY, align 8
  %v2804 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2803, ptr %state, i64 %v2801, i64 %v2802)
  store ptr %v2804, ptr %MEMORY, align 8
  store i64 %v2799, ptr %PC, align 8
  %v2805 = add i64 %v2799, 3
  store i64 %v2805, ptr %NEXT_PC, align 8
  %v2806 = load i64, ptr %RCX, align 8
  %v2807 = load ptr, ptr %MEMORY, align 8
  %v2808 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2807, ptr %state, ptr %RSI, i64 %v2806)
  store ptr %v2808, ptr %MEMORY, align 8
  store i64 %v2805, ptr %PC, align 8
  %v2809 = add i64 %v2805, 5
  store i64 %v2809, ptr %NEXT_PC, align 8
  %v2810 = load i64, ptr %RSP, align 8
  %v2811 = add i64 %v2810, 32
  %v2812 = load i64, ptr %R15, align 8
  %v2813 = load ptr, ptr %MEMORY, align 8
  %v2814 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2813, ptr %state, i64 %v2811, i64 %v2812)
  store ptr %v2814, ptr %MEMORY, align 8
  store i64 %v2809, ptr %PC, align 8
  %v2815 = add i64 %v2809, 3
  store i64 %v2815, ptr %NEXT_PC, align 8
  %v2816 = load i64, ptr %RDX, align 8
  %v2817 = load ptr, ptr %MEMORY, align 8
  %v2818 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2817, ptr %state, ptr %R15, i64 %v2816)
  store ptr %v2818, ptr %MEMORY, align 8
  store i64 %v2815, ptr %PC, align 8
  %v2819 = add i64 %v2815, 3
  store i64 %v2819, ptr %NEXT_PC, align 8
  %v2820 = load i32, ptr %R13D, align 4
  %v2821 = zext i32 %v2820 to i64
  %v2822 = load ptr, ptr %MEMORY, align 8
  %v2823 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2822, ptr %state, ptr %R9, i64 %v2821)
  store ptr %v2823, ptr %MEMORY, align 8
  store i64 %v2819, ptr %PC, align 8
  %v2824 = add i64 %v2819, 2
  store i64 %v2824, ptr %NEXT_PC, align 8
  %v2825 = load i32, ptr %EAX, align 4
  %v2826 = zext i32 %v2825 to i64
  %v2827 = load i32, ptr %EAX, align 4
  %v2828 = zext i32 %v2827 to i64
  %v2829 = load ptr, ptr %MEMORY, align 8
  %v2830 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2829, ptr %state, i64 %v2826, i64 %v2828)
  store ptr %v2830, ptr %MEMORY, align 8
  store i64 %v2824, ptr %PC, align 8
  %v2831 = add i64 %v2824, 6
  store i64 %v2831, ptr %NEXT_PC, align 8
  %v2832 = add i64 %v2831, 273
  %v2833 = load ptr, ptr %MEMORY, align 8
  %v2834 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2833, ptr %state, ptr %BRANCH_TAKEN, i64 %v2832, i64 %v2831, ptr %NEXT_PC)
  store ptr %v2834, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879099, label %bb_5389878826

bb_5389878826:                                    ; preds = %bb_5389878772
  store i64 %v2831, ptr %PC, align 8
  %v2835 = add i64 %v2831, 3
  store i64 %v2835, ptr %NEXT_PC, align 8
  %v2836 = load i64, ptr %RDX, align 8
  %v2837 = load ptr, ptr %MEMORY, align 8
  %v2838 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2837, ptr %state, ptr %RCX, i64 %v2836)
  store ptr %v2838, ptr %MEMORY, align 8
  store i64 %v2835, ptr %PC, align 8
  %v2839 = add i64 %v2835, 3
  store i64 %v2839, ptr %NEXT_PC, align 8
  %v2840 = load i64, ptr %RAX, align 8
  %v2841 = load ptr, ptr %MEMORY, align 8
  %v2842 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2841, ptr %state, ptr %R10, i64 %v2840)
  store ptr %v2842, ptr %MEMORY, align 8
  store i64 %v2839, ptr %PC, align 8
  %v2843 = add i64 %v2839, 4
  store i64 %v2843, ptr %NEXT_PC, align 8
  %v2844 = load i64, ptr %RSI, align 8
  %v2845 = add i64 %v2844, 16
  %v2846 = load ptr, ptr %MEMORY, align 8
  %v2847 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2846, ptr %state, ptr %RAX, i64 %v2845)
  store ptr %v2847, ptr %MEMORY, align 8
  store i64 %v2843, ptr %PC, align 8
  %v2848 = add i64 %v2843, 3
  store i64 %v2848, ptr %NEXT_PC, align 8
  %v2849 = load i32, ptr %R13D, align 4
  %v2850 = zext i32 %v2849 to i64
  %v2851 = load ptr, ptr %MEMORY, align 8
  %v2852 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2851, ptr %state, ptr %R8, i64 %v2850)
  store ptr %v2852, ptr %MEMORY, align 8
  br label %bb_5389878839

bb_5389878839:                                    ; preds = %bb_5389878844, %bb_5389878826
  %v2853 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2853, ptr %PC, align 8
  %v2854 = add i64 %v2853, 3
  store i64 %v2854, ptr %NEXT_PC, align 8
  %v2855 = load i64, ptr %RAX, align 8
  %v2856 = load i64, ptr %RCX, align 8
  %v2857 = load ptr, ptr %MEMORY, align 8
  %v2858 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2857, ptr %state, i64 %v2855, i64 %v2856)
  store ptr %v2858, ptr %MEMORY, align 8
  store i64 %v2854, ptr %PC, align 8
  %v2859 = add i64 %v2854, 2
  store i64 %v2859, ptr %NEXT_PC, align 8
  %v2860 = add i64 %v2859, 20
  %v2861 = load ptr, ptr %MEMORY, align 8
  %v2862 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2861, ptr %state, ptr %BRANCH_TAKEN, i64 %v2860, i64 %v2859, ptr %NEXT_PC)
  store ptr %v2862, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878864, label %bb_5389878844

bb_5389878844:                                    ; preds = %bb_5389878839
  store i64 %v2859, ptr %PC, align 8
  %v2863 = add i64 %v2859, 3
  store i64 %v2863, ptr %NEXT_PC, align 8
  %v2864 = load i64, ptr %R9, align 8
  %v2865 = load ptr, ptr %MEMORY, align 8
  %v2866 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2865, ptr %state, ptr %R9, i64 %v2864)
  store ptr %v2866, ptr %MEMORY, align 8
  store i64 %v2863, ptr %PC, align 8
  %v2867 = add i64 %v2863, 3
  store i64 %v2867, ptr %NEXT_PC, align 8
  %v2868 = load i64, ptr %R8, align 8
  %v2869 = load ptr, ptr %MEMORY, align 8
  %v2870 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2869, ptr %state, ptr %R8, i64 %v2868)
  store ptr %v2870, ptr %MEMORY, align 8
  store i64 %v2867, ptr %PC, align 8
  %v2871 = add i64 %v2867, 4
  store i64 %v2871, ptr %NEXT_PC, align 8
  %v2872 = load i64, ptr %RAX, align 8
  %v2873 = load ptr, ptr %MEMORY, align 8
  %v2874 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2873, ptr %state, ptr %RAX, i64 %v2872, i64 8)
  store ptr %v2874, ptr %MEMORY, align 8
  store i64 %v2871, ptr %PC, align 8
  %v2875 = add i64 %v2871, 3
  store i64 %v2875, ptr %NEXT_PC, align 8
  %v2876 = load i64, ptr %R8, align 8
  %v2877 = load i64, ptr %R10, align 8
  %v2878 = load ptr, ptr %MEMORY, align 8
  %v2879 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2878, ptr %state, i64 %v2876, i64 %v2877)
  store ptr %v2879, ptr %MEMORY, align 8
  store i64 %v2875, ptr %PC, align 8
  %v2880 = add i64 %v2875, 2
  store i64 %v2880, ptr %NEXT_PC, align 8
  %v2881 = sub i64 %v2880, 20
  %v2882 = load ptr, ptr %MEMORY, align 8
  %v2883 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2882, ptr %state, ptr %BRANCH_TAKEN, i64 %v2881, i64 %v2880, ptr %NEXT_PC)
  store ptr %v2883, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878839, label %bb_5389878859

bb_5389878859:                                    ; preds = %bb_5389878844
  store i64 %v2880, ptr %PC, align 8
  %v2884 = add i64 %v2880, 5
  store i64 %v2884, ptr %NEXT_PC, align 8
  %v2885 = add i64 %v2884, 235
  %v2886 = load ptr, ptr %MEMORY, align 8
  %v2887 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2886, ptr %state, i64 %v2885, ptr %NEXT_PC)
  store ptr %v2887, ptr %MEMORY, align 8
  br label %bb_5389879099

bb_5389878864:                                    ; preds = %bb_5389878839
  store i64 %v2859, ptr %PC, align 8
  %v2888 = add i64 %v2859, 4
  store i64 %v2888, ptr %NEXT_PC, align 8
  %v2889 = load i64, ptr %RSI, align 8
  %v2890 = add i64 %v2889, 48
  %v2891 = load ptr, ptr %MEMORY, align 8
  %v2892 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2891, ptr %state, ptr %RAX, i64 %v2890)
  store ptr %v2892, ptr %MEMORY, align 8
  store i64 %v2888, ptr %PC, align 8
  %v2893 = add i64 %v2888, 5
  store i64 %v2893, ptr %NEXT_PC, align 8
  %v2894 = load i64, ptr %RSP, align 8
  %v2895 = add i64 %v2894, 80
  %v2896 = load i64, ptr %RBP, align 8
  %v2897 = load ptr, ptr %MEMORY, align 8
  %v2898 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2897, ptr %state, i64 %v2895, i64 %v2896)
  store ptr %v2898, ptr %MEMORY, align 8
  store i64 %v2893, ptr %PC, align 8
  %v2899 = add i64 %v2893, 5
  store i64 %v2899, ptr %NEXT_PC, align 8
  %v2900 = load i64, ptr %RSP, align 8
  %v2901 = add i64 %v2900, 96
  %v2902 = load i64, ptr %RDI, align 8
  %v2903 = load ptr, ptr %MEMORY, align 8
  %v2904 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2903, ptr %state, i64 %v2901, i64 %v2902)
  store ptr %v2904, ptr %MEMORY, align 8
  store i64 %v2899, ptr %PC, align 8
  %v2905 = add i64 %v2899, 5
  store i64 %v2905, ptr %NEXT_PC, align 8
  %v2906 = load i64, ptr %RSP, align 8
  %v2907 = add i64 %v2906, 48
  %v2908 = load i64, ptr %R12, align 8
  %v2909 = load ptr, ptr %MEMORY, align 8
  %v2910 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2909, ptr %state, i64 %v2907, i64 %v2908)
  store ptr %v2910, ptr %MEMORY, align 8
  store i64 %v2905, ptr %PC, align 8
  %v2911 = add i64 %v2905, 5
  store i64 %v2911, ptr %NEXT_PC, align 8
  %v2912 = load i64, ptr %RSP, align 8
  %v2913 = add i64 %v2912, 40
  %v2914 = load i64, ptr %R14, align 8
  %v2915 = load ptr, ptr %MEMORY, align 8
  %v2916 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2915, ptr %state, i64 %v2913, i64 %v2914)
  store ptr %v2916, ptr %MEMORY, align 8
  store i64 %v2911, ptr %PC, align 8
  %v2917 = add i64 %v2911, 4
  store i64 %v2917, ptr %NEXT_PC, align 8
  %v2918 = load i64, ptr %RCX, align 8
  %v2919 = add i64 %v2918, 48
  %v2920 = load i64, ptr %RAX, align 8
  %v2921 = load ptr, ptr %MEMORY, align 8
  %v2922 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2921, ptr %state, i64 %v2919, i64 %v2920)
  store ptr %v2922, ptr %MEMORY, align 8
  store i64 %v2917, ptr %PC, align 8
  %v2923 = add i64 %v2917, 2
  store i64 %v2923, ptr %NEXT_PC, align 8
  %v2924 = add i64 %v2923, 2
  %v2925 = load ptr, ptr %MEMORY, align 8
  %v2926 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2925, ptr %state, ptr %BRANCH_TAKEN, i64 %v2924, i64 %v2923, ptr %NEXT_PC)
  store ptr %v2926, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878896, label %bb_5389878894

bb_5389878894:                                    ; preds = %bb_5389878864
  store i64 %v2923, ptr %PC, align 8
  %v2927 = add i64 %v2923, 2
  store i64 %v2927, ptr %NEXT_PC, align 8
  %v2928 = load i64, ptr %RAX, align 8
  %v2929 = load i64, ptr %RAX, align 8
  %v2930 = load ptr, ptr %MEMORY, align 8
  %v2931 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2930, ptr %state, i64 %v2928, i64 %v2929)
  store ptr %v2931, ptr %MEMORY, align 8
  br label %bb_5389878896

bb_5389878896:                                    ; preds = %bb_5389878894, %bb_5389878864
  %v2932 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2932, ptr %PC, align 8
  %v2933 = add i64 %v2932, 3
  store i64 %v2933, ptr %NEXT_PC, align 8
  %v2934 = load i32, ptr %R9D, align 4
  %v2935 = zext i32 %v2934 to i64
  %v2936 = load ptr, ptr %MEMORY, align 8
  %v2937 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v2936, ptr %state, ptr %RDI, i64 %v2935)
  store ptr %v2937, ptr %MEMORY, align 8
  store i64 %v2933, ptr %PC, align 8
  %v2938 = add i64 %v2933, 4
  store i64 %v2938, ptr %NEXT_PC, align 8
  %v2939 = load i64, ptr %R9, align 8
  %v2940 = add i64 %v2939, 1
  %v2941 = load ptr, ptr %MEMORY, align 8
  %v2942 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2941, ptr %state, ptr %R14, i64 %v2940)
  store ptr %v2942, ptr %MEMORY, align 8
  store i64 %v2938, ptr %PC, align 8
  %v2943 = add i64 %v2938, 3
  store i64 %v2943, ptr %NEXT_PC, align 8
  %v2944 = load i32, ptr %R14D, align 4
  %v2945 = zext i32 %v2944 to i64
  %v2946 = load ptr, ptr %MEMORY, align 8
  %v2947 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v2946, ptr %state, ptr %RBP, i64 %v2945)
  store ptr %v2947, ptr %MEMORY, align 8
  store i64 %v2943, ptr %PC, align 8
  %v2948 = add i64 %v2943, 3
  store i64 %v2948, ptr %NEXT_PC, align 8
  %v2949 = load i64, ptr %RDI, align 8
  %v2950 = load ptr, ptr %MEMORY, align 8
  %v2951 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2950, ptr %state, ptr %R12, i64 %v2949)
  store ptr %v2951, ptr %MEMORY, align 8
  store i64 %v2948, ptr %PC, align 8
  %v2952 = add i64 %v2948, 3
  store i64 %v2952, ptr %NEXT_PC, align 8
  %v2953 = load i64, ptr %RDI, align 8
  %v2954 = load i64, ptr %RBP, align 8
  %v2955 = load ptr, ptr %MEMORY, align 8
  %v2956 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2955, ptr %state, i64 %v2953, i64 %v2954)
  store ptr %v2956, ptr %MEMORY, align 8
  store i64 %v2952, ptr %PC, align 8
  %v2957 = add i64 %v2952, 2
  store i64 %v2957, ptr %NEXT_PC, align 8
  %v2958 = add i64 %v2957, 121
  %v2959 = load ptr, ptr %MEMORY, align 8
  %v2960 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2959, ptr %state, ptr %BRANCH_TAKEN, i64 %v2958, i64 %v2957, ptr %NEXT_PC)
  store ptr %v2960, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879035, label %bb_5389878914

bb_5389878914:                                    ; preds = %bb_5389879027, %bb_5389878896
  %v2961 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2961, ptr %PC, align 8
  %v2962 = add i64 %v2961, 4
  store i64 %v2962, ptr %NEXT_PC, align 8
  %v2963 = load i64, ptr %RSI, align 8
  %v2964 = add i64 %v2963, 16
  %v2965 = load ptr, ptr %MEMORY, align 8
  %v2966 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2965, ptr %state, ptr %RAX, i64 %v2964)
  store ptr %v2966, ptr %MEMORY, align 8
  store i64 %v2962, ptr %PC, align 8
  %v2967 = add i64 %v2962, 4
  store i64 %v2967, ptr %NEXT_PC, align 8
  %v2968 = load i64, ptr %RAX, align 8
  %v2969 = load i64, ptr %RDI, align 8
  %v2970 = mul i64 %v2969, 8
  %v2971 = add i64 %v2968, %v2970
  %v2972 = load ptr, ptr %MEMORY, align 8
  %v2973 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2972, ptr %state, ptr %RBX, i64 %v2971)
  store ptr %v2973, ptr %MEMORY, align 8
  store i64 %v2967, ptr %PC, align 8
  %v2974 = add i64 %v2967, 3
  store i64 %v2974, ptr %NEXT_PC, align 8
  %v2975 = load i64, ptr %RBX, align 8
  %v2976 = load i64, ptr %RBX, align 8
  %v2977 = load ptr, ptr %MEMORY, align 8
  %v2978 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2977, ptr %state, i64 %v2975, i64 %v2976)
  store ptr %v2978, ptr %MEMORY, align 8
  store i64 %v2974, ptr %PC, align 8
  %v2979 = add i64 %v2974, 2
  store i64 %v2979, ptr %NEXT_PC, align 8
  %v2980 = add i64 %v2979, 100
  %v2981 = load ptr, ptr %MEMORY, align 8
  %v2982 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2981, ptr %state, ptr %BRANCH_TAKEN, i64 %v2980, i64 %v2979, ptr %NEXT_PC)
  store ptr %v2982, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878927

bb_5389878927:                                    ; preds = %bb_5389878914
  store i64 %v2979, ptr %PC, align 8
  %v2983 = add i64 %v2979, 4
  store i64 %v2983, ptr %NEXT_PC, align 8
  %v2984 = load i64, ptr %RBX, align 8
  %v2985 = add i64 %v2984, 48
  %v2986 = load ptr, ptr %MEMORY, align 8
  %v2987 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2986, ptr %state, ptr %RCX, i64 %v2985)
  store ptr %v2987, ptr %MEMORY, align 8
  store i64 %v2983, ptr %PC, align 8
  %v2988 = add i64 %v2983, 4
  store i64 %v2988, ptr %NEXT_PC, align 8
  %v2989 = load i64, ptr %RCX, align 8
  %v2990 = add i64 %v2989, 16
  %v2991 = load ptr, ptr %MEMORY, align 8
  %v2992 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2991, ptr %state, ptr %RAX, i64 %v2990)
  store ptr %v2992, ptr %MEMORY, align 8
  store i64 %v2988, ptr %PC, align 8
  %v2993 = add i64 %v2988, 2
  store i64 %v2993, ptr %NEXT_PC, align 8
  %v2994 = load i8, ptr %AL, align 1
  %v2995 = zext i8 %v2994 to i64
  %v2996 = load ptr, ptr %MEMORY, align 8
  %v2997 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2996, ptr %state, i64 %v2995, i64 2)
  store ptr %v2997, ptr %MEMORY, align 8
  store i64 %v2993, ptr %PC, align 8
  %v2998 = add i64 %v2993, 2
  store i64 %v2998, ptr %NEXT_PC, align 8
  %v2999 = add i64 %v2998, 88
  %v3000 = load ptr, ptr %MEMORY, align 8
  %v3001 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3000, ptr %state, ptr %BRANCH_TAKEN, i64 %v2999, i64 %v2998, ptr %NEXT_PC)
  store ptr %v3001, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878939

bb_5389878939:                                    ; preds = %bb_5389878927
  store i64 %v2998, ptr %PC, align 8
  %v3002 = add i64 %v2998, 2
  store i64 %v3002, ptr %NEXT_PC, align 8
  %v3003 = load i8, ptr %AL, align 1
  %v3004 = zext i8 %v3003 to i64
  %v3005 = load ptr, ptr %MEMORY, align 8
  %v3006 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3005, ptr %state, i64 %v3004, i64 1)
  store ptr %v3006, ptr %MEMORY, align 8
  store i64 %v3002, ptr %PC, align 8
  %v3007 = add i64 %v3002, 2
  store i64 %v3007, ptr %NEXT_PC, align 8
  %v3008 = add i64 %v3007, 22
  %v3009 = load ptr, ptr %MEMORY, align 8
  %v3010 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3009, ptr %state, ptr %BRANCH_TAKEN, i64 %v3008, i64 %v3007, ptr %NEXT_PC)
  store ptr %v3010, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878965, label %bb_5389878943

bb_5389878943:                                    ; preds = %bb_5389878939
  store i64 %v3007, ptr %PC, align 8
  %v3011 = add i64 %v3007, 4
  store i64 %v3011, ptr %NEXT_PC, align 8
  %v3012 = load i64, ptr %RCX, align 8
  %v3013 = add i64 %v3012, 16
  %v3014 = load i64, ptr %RCX, align 8
  %v3015 = add i64 %v3014, 16
  %v3016 = load ptr, ptr %MEMORY, align 8
  %v3017 = call ptr @_ZN12_GLOBAL__N_13ANDI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3016, ptr %state, i64 %v3013, i64 %v3015, i64 254)
  store ptr %v3017, ptr %MEMORY, align 8
  store i64 %v3011, ptr %PC, align 8
  %v3018 = add i64 %v3011, 4
  store i64 %v3018, ptr %NEXT_PC, align 8
  %v3019 = load i64, ptr %RCX, align 8
  %v3020 = add i64 %v3019, 16
  %v3021 = load ptr, ptr %MEMORY, align 8
  %v3022 = call ptr @_ZN12_GLOBAL__N_14TESTI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3021, ptr %state, i64 %v3020, i64 2)
  store ptr %v3022, ptr %MEMORY, align 8
  store i64 %v3018, ptr %PC, align 8
  %v3023 = add i64 %v3018, 3
  store i64 %v3023, ptr %NEXT_PC, align 8
  %v3024 = load i64, ptr %RCX, align 8
  %v3025 = load i32, ptr %R13D, align 4
  %v3026 = zext i32 %v3025 to i64
  %v3027 = load ptr, ptr %MEMORY, align 8
  %v3028 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3027, ptr %state, i64 %v3024, i64 %v3026)
  store ptr %v3028, ptr %MEMORY, align 8
  store i64 %v3023, ptr %PC, align 8
  %v3029 = add i64 %v3023, 2
  store i64 %v3029, ptr %NEXT_PC, align 8
  %v3030 = add i64 %v3029, 9
  %v3031 = load ptr, ptr %MEMORY, align 8
  %v3032 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3031, ptr %state, ptr %BRANCH_TAKEN, i64 %v3030, i64 %v3029, ptr %NEXT_PC)
  store ptr %v3032, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878965, label %bb_5389878956

bb_5389878956:                                    ; preds = %bb_5389878943
  store i64 %v3029, ptr %PC, align 8
  %v3033 = add i64 %v3029, 4
  store i64 %v3033, ptr %NEXT_PC, align 8
  %v3034 = load i64, ptr %RCX, align 8
  %v3035 = add i64 %v3034, 8
  %v3036 = load ptr, ptr %MEMORY, align 8
  %v3037 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3036, ptr %state, ptr %RDX, i64 %v3035)
  store ptr %v3037, ptr %MEMORY, align 8
  store i64 %v3033, ptr %PC, align 8
  %v3038 = add i64 %v3033, 5
  store i64 %v3038, ptr %NEXT_PC, align 8
  %v3039 = sub i64 %v3038, 3621
  %v3040 = load ptr, ptr %MEMORY, align 8
  %v3041 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3040, ptr %state, i64 5389875344, ptr %NEXT_PC, i64 %v3038, ptr %RETURN_PC)
  store ptr %v3041, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878965:                                    ; preds = %bb_5389878943, %bb_5389878939
  %v3042 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3042, ptr %PC, align 8
  %v3043 = add i64 %v3042, 2
  store i64 %v3043, ptr %NEXT_PC, align 8
  %v3044 = load i64, ptr %RBX, align 8
  %v3045 = load i64, ptr %RBX, align 8
  %v3046 = load ptr, ptr %MEMORY, align 8
  %v3047 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3046, ptr %state, i64 %v3044, i64 %v3045)
  store ptr %v3047, ptr %MEMORY, align 8
  store i64 %v3043, ptr %PC, align 8
  %v3048 = add i64 %v3043, 4
  store i64 %v3048, ptr %NEXT_PC, align 8
  %v3049 = load i64, ptr %RBX, align 8
  %v3050 = add i64 %v3049, 48
  %v3051 = load ptr, ptr %MEMORY, align 8
  %v3052 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3051, ptr %state, ptr %RAX, i64 %v3050)
  store ptr %v3052, ptr %MEMORY, align 8
  store i64 %v3048, ptr %PC, align 8
  %v3053 = add i64 %v3048, 2
  store i64 %v3053, ptr %NEXT_PC, align 8
  %v3054 = load i64, ptr %RAX, align 8
  %v3055 = load i64, ptr %RAX, align 8
  %v3056 = load ptr, ptr %MEMORY, align 8
  %v3057 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3056, ptr %state, i64 %v3054, i64 %v3055)
  store ptr %v3057, ptr %MEMORY, align 8
  store i64 %v3053, ptr %PC, align 8
  %v3058 = add i64 %v3053, 4
  store i64 %v3058, ptr %NEXT_PC, align 8
  %v3059 = load i64, ptr %RBX, align 8
  %v3060 = add i64 %v3059, 48
  %v3061 = load ptr, ptr %MEMORY, align 8
  %v3062 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3061, ptr %state, ptr %RBX, i64 %v3060)
  store ptr %v3062, ptr %MEMORY, align 8
  store i64 %v3058, ptr %PC, align 8
  %v3063 = add i64 %v3058, 3
  store i64 %v3063, ptr %NEXT_PC, align 8
  %v3064 = load i64, ptr %RBX, align 8
  %v3065 = load i32, ptr %R13D, align 4
  %v3066 = zext i32 %v3065 to i64
  %v3067 = load ptr, ptr %MEMORY, align 8
  %v3068 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3067, ptr %state, i64 %v3064, i64 %v3066)
  store ptr %v3068, ptr %MEMORY, align 8
  store i64 %v3063, ptr %PC, align 8
  %v3069 = add i64 %v3063, 2
  store i64 %v3069, ptr %NEXT_PC, align 8
  %v3070 = add i64 %v3069, 45
  %v3071 = load ptr, ptr %MEMORY, align 8
  %v3072 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3071, ptr %state, ptr %BRANCH_TAKEN, i64 %v3070, i64 %v3069, ptr %NEXT_PC)
  store ptr %v3072, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878982

bb_5389878982:                                    ; preds = %bb_5389878965
  store i64 %v3069, ptr %PC, align 8
  %v3073 = add i64 %v3069, 4
  store i64 %v3073, ptr %NEXT_PC, align 8
  %v3074 = load i64, ptr %RBX, align 8
  %v3075 = add i64 %v3074, 8
  %v3076 = load ptr, ptr %MEMORY, align 8
  %v3077 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3076, ptr %state, ptr %RDX, i64 %v3075)
  store ptr %v3077, ptr %MEMORY, align 8
  store i64 %v3073, ptr %PC, align 8
  %v3078 = add i64 %v3073, 3
  store i64 %v3078, ptr %NEXT_PC, align 8
  %v3079 = load i64, ptr %RBX, align 8
  %v3080 = load ptr, ptr %MEMORY, align 8
  %v3081 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3080, ptr %state, ptr %RCX, i64 %v3079)
  store ptr %v3081, ptr %MEMORY, align 8
  store i64 %v3078, ptr %PC, align 8
  %v3082 = add i64 %v3078, 4
  store i64 %v3082, ptr %NEXT_PC, align 8
  %v3083 = load i64, ptr %RBX, align 8
  %v3084 = add i64 %v3083, 16
  %v3085 = load i64, ptr %RBX, align 8
  %v3086 = add i64 %v3085, 16
  %v3087 = load ptr, ptr %MEMORY, align 8
  %v3088 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3087, ptr %state, i64 %v3084, i64 %v3086, i64 2)
  store ptr %v3088, ptr %MEMORY, align 8
  store i64 %v3082, ptr %PC, align 8
  %v3089 = add i64 %v3082, 5
  store i64 %v3089, ptr %NEXT_PC, align 8
  %v3090 = sub i64 %v3089, 3446
  %v3091 = load ptr, ptr %MEMORY, align 8
  %v3092 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3091, ptr %state, i64 5389875552, ptr %NEXT_PC, i64 %v3089, ptr %RETURN_PC)
  store ptr %v3092, ptr %MEMORY, align 8
  store i64 %v3089, ptr %PC, align 8
  %v3093 = add i64 %v3089, 4
  store i64 %v3093, ptr %NEXT_PC, align 8
  %v3094 = load i64, ptr %RBX, align 8
  %v3095 = add i64 %v3094, 8
  %v3096 = load ptr, ptr %MEMORY, align 8
  %v3097 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3096, ptr %state, ptr %RDX, i64 %v3095)
  store ptr %v3097, ptr %MEMORY, align 8
  store i64 %v3093, ptr %PC, align 8
  %v3098 = add i64 %v3093, 7
  store i64 %v3098, ptr %NEXT_PC, align 8
  %v3099 = add i64 %v3098, 26998767
  %v3100 = load ptr, ptr %MEMORY, align 8
  %v3101 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3100, ptr %state, ptr %RCX, i64 %v3099)
  store ptr %v3101, ptr %MEMORY, align 8
  store i64 %v3098, ptr %PC, align 8
  %v3102 = add i64 %v3098, 5
  store i64 %v3102, ptr %NEXT_PC, align 8
  %v3103 = add i64 %v3102, 49594
  %v3104 = load ptr, ptr %MEMORY, align 8
  %v3105 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3104, ptr %state, i64 5389928608, ptr %NEXT_PC, i64 %v3102, ptr %RETURN_PC)
  store ptr %v3105, ptr %MEMORY, align 8
  store i64 %v3102, ptr %PC, align 8
  %v3106 = add i64 %v3102, 5
  store i64 %v3106, ptr %NEXT_PC, align 8
  %v3107 = load ptr, ptr %MEMORY, align 8
  %v3108 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3107, ptr %state, ptr %RDX, i64 24)
  store ptr %v3108, ptr %MEMORY, align 8
  store i64 %v3106, ptr %PC, align 8
  %v3109 = add i64 %v3106, 3
  store i64 %v3109, ptr %NEXT_PC, align 8
  %v3110 = load i64, ptr %RBX, align 8
  %v3111 = load ptr, ptr %MEMORY, align 8
  %v3112 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3111, ptr %state, ptr %RCX, i64 %v3110)
  store ptr %v3112, ptr %MEMORY, align 8
  store i64 %v3109, ptr %PC, align 8
  %v3113 = add i64 %v3109, 5
  store i64 %v3113, ptr %NEXT_PC, align 8
  %v3114 = sub i64 %v3113, 1165715
  %v3115 = load ptr, ptr %MEMORY, align 8
  %v3116 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3115, ptr %state, i64 5388713312, ptr %NEXT_PC, i64 %v3113, ptr %RETURN_PC)
  store ptr %v3116, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879027:                                    ; preds = %bb_5389878965, %bb_5389878927, %bb_5389878914
  %v3117 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3117, ptr %PC, align 8
  %v3118 = add i64 %v3117, 3
  store i64 %v3118, ptr %NEXT_PC, align 8
  %v3119 = load i64, ptr %RDI, align 8
  %v3120 = load ptr, ptr %MEMORY, align 8
  %v3121 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3120, ptr %state, ptr %RDI, i64 %v3119)
  store ptr %v3121, ptr %MEMORY, align 8
  store i64 %v3118, ptr %PC, align 8
  %v3122 = add i64 %v3118, 3
  store i64 %v3122, ptr %NEXT_PC, align 8
  %v3123 = load i64, ptr %RDI, align 8
  %v3124 = load i64, ptr %RBP, align 8
  %v3125 = load ptr, ptr %MEMORY, align 8
  %v3126 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3125, ptr %state, i64 %v3123, i64 %v3124)
  store ptr %v3126, ptr %MEMORY, align 8
  store i64 %v3122, ptr %PC, align 8
  %v3127 = add i64 %v3122, 2
  store i64 %v3127, ptr %NEXT_PC, align 8
  %v3128 = sub i64 %v3127, 121
  %v3129 = load ptr, ptr %MEMORY, align 8
  %v3130 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3129, ptr %state, ptr %BRANCH_TAKEN, i64 %v3128, i64 %v3127, ptr %NEXT_PC)
  store ptr %v3130, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878914, label %bb_5389879035

bb_5389879035:                                    ; preds = %bb_5389879027, %bb_5389878896
  %v3131 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3131, ptr %PC, align 8
  %v3132 = add i64 %v3131, 3
  store i64 %v3132, ptr %NEXT_PC, align 8
  %v3133 = load i64, ptr %RSI, align 8
  %v3134 = add i64 %v3133, 24
  %v3135 = load ptr, ptr %MEMORY, align 8
  %v3136 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3135, ptr %state, ptr %RAX, i64 %v3134)
  store ptr %v3136, ptr %MEMORY, align 8
  store i64 %v3132, ptr %PC, align 8
  %v3137 = add i64 %v3132, 2
  store i64 %v3137, ptr %NEXT_PC, align 8
  %v3138 = load i32, ptr %EAX, align 4
  %v3139 = zext i32 %v3138 to i64
  %v3140 = load ptr, ptr %MEMORY, align 8
  %v3141 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3140, ptr %state, ptr %RCX, i64 %v3139)
  store ptr %v3141, ptr %MEMORY, align 8
  store i64 %v3137, ptr %PC, align 8
  %v3142 = add i64 %v3137, 5
  store i64 %v3142, ptr %NEXT_PC, align 8
  %v3143 = load i64, ptr %RSP, align 8
  %v3144 = add i64 %v3143, 96
  %v3145 = load ptr, ptr %MEMORY, align 8
  %v3146 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3145, ptr %state, ptr %RDI, i64 %v3144)
  store ptr %v3146, ptr %MEMORY, align 8
  store i64 %v3142, ptr %PC, align 8
  %v3147 = add i64 %v3142, 3
  store i64 %v3147, ptr %NEXT_PC, align 8
  %v3148 = load i64, ptr %RCX, align 8
  %v3149 = load i32, ptr %R14D, align 4
  %v3150 = zext i32 %v3149 to i64
  %v3151 = load ptr, ptr %MEMORY, align 8
  %v3152 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3151, ptr %state, ptr %RCX, i64 %v3148, i64 %v3150)
  store ptr %v3152, ptr %MEMORY, align 8
  store i64 %v3147, ptr %PC, align 8
  %v3153 = add i64 %v3147, 5
  store i64 %v3153, ptr %NEXT_PC, align 8
  %v3154 = load i64, ptr %RSP, align 8
  %v3155 = add i64 %v3154, 40
  %v3156 = load ptr, ptr %MEMORY, align 8
  %v3157 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3156, ptr %state, ptr %R14, i64 %v3155)
  store ptr %v3157, ptr %MEMORY, align 8
  store i64 %v3153, ptr %PC, align 8
  %v3158 = add i64 %v3153, 2
  store i64 %v3158, ptr %NEXT_PC, align 8
  %v3159 = load i32, ptr %ECX, align 4
  %v3160 = zext i32 %v3159 to i64
  %v3161 = load i32, ptr %ECX, align 4
  %v3162 = zext i32 %v3161 to i64
  %v3163 = load ptr, ptr %MEMORY, align 8
  %v3164 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3163, ptr %state, i64 %v3160, i64 %v3162)
  store ptr %v3164, ptr %MEMORY, align 8
  store i64 %v3158, ptr %PC, align 8
  %v3165 = add i64 %v3158, 2
  store i64 %v3165, ptr %NEXT_PC, align 8
  %v3166 = add i64 %v3165, 27
  %v3167 = load ptr, ptr %MEMORY, align 8
  %v3168 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3167, ptr %state, ptr %BRANCH_TAKEN, i64 %v3166, i64 %v3165, ptr %NEXT_PC)
  store ptr %v3168, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879084, label %bb_5389879057

bb_5389879057:                                    ; preds = %bb_5389879035
  store i64 %v3165, ptr %PC, align 8
  %v3169 = add i64 %v3165, 4
  store i64 %v3169, ptr %NEXT_PC, align 8
  %v3170 = load i64, ptr %RSI, align 8
  %v3171 = add i64 %v3170, 16
  %v3172 = load ptr, ptr %MEMORY, align 8
  %v3173 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3172, ptr %state, ptr %RAX, i64 %v3171)
  store ptr %v3173, ptr %MEMORY, align 8
  store i64 %v3169, ptr %PC, align 8
  %v3174 = add i64 %v3169, 3
  store i64 %v3174, ptr %NEXT_PC, align 8
  %v3175 = load i32, ptr %ECX, align 4
  %v3176 = zext i32 %v3175 to i64
  %v3177 = load ptr, ptr %MEMORY, align 8
  %v3178 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v3177, ptr %state, ptr %R8, i64 %v3176)
  store ptr %v3178, ptr %MEMORY, align 8
  store i64 %v3174, ptr %PC, align 8
  %v3179 = add i64 %v3174, 4
  store i64 %v3179, ptr %NEXT_PC, align 8
  %v3180 = load i64, ptr %R8, align 8
  %v3181 = load ptr, ptr %MEMORY, align 8
  %v3182 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3181, ptr %state, ptr %R8, i64 %v3180, i64 3)
  store ptr %v3182, ptr %MEMORY, align 8
  store i64 %v3179, ptr %PC, align 8
  %v3183 = add i64 %v3179, 4
  store i64 %v3183, ptr %NEXT_PC, align 8
  %v3184 = load i64, ptr %RAX, align 8
  %v3185 = load i64, ptr %RBP, align 8
  %v3186 = mul i64 %v3185, 8
  %v3187 = add i64 %v3184, %v3186
  %v3188 = load ptr, ptr %MEMORY, align 8
  %v3189 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3188, ptr %state, ptr %RDX, i64 %v3187)
  store ptr %v3189, ptr %MEMORY, align 8
  store i64 %v3183, ptr %PC, align 8
  %v3190 = add i64 %v3183, 4
  store i64 %v3190, ptr %NEXT_PC, align 8
  %v3191 = load i64, ptr %RAX, align 8
  %v3192 = load i64, ptr %R12, align 8
  %v3193 = mul i64 %v3192, 8
  %v3194 = add i64 %v3191, %v3193
  %v3195 = load ptr, ptr %MEMORY, align 8
  %v3196 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3195, ptr %state, ptr %RCX, i64 %v3194)
  store ptr %v3196, ptr %MEMORY, align 8
  store i64 %v3190, ptr %PC, align 8
  %v3197 = add i64 %v3190, 5
  store i64 %v3197, ptr %NEXT_PC, align 8
  %v3198 = add i64 %v3197, 11852992
  %v3199 = load ptr, ptr %MEMORY, align 8
  %v3200 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3199, ptr %state, i64 5401732073, ptr %NEXT_PC, i64 %v3197, ptr %RETURN_PC)
  store ptr %v3200, ptr %MEMORY, align 8
  store i64 %v3197, ptr %PC, align 8
  %v3201 = add i64 %v3197, 3
  store i64 %v3201, ptr %NEXT_PC, align 8
  %v3202 = load i64, ptr %RSI, align 8
  %v3203 = add i64 %v3202, 24
  %v3204 = load ptr, ptr %MEMORY, align 8
  %v3205 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3204, ptr %state, ptr %RAX, i64 %v3203)
  store ptr %v3205, ptr %MEMORY, align 8
  br label %bb_5389879084

bb_5389879084:                                    ; preds = %bb_5389879057, %bb_5389879035
  %v3206 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3206, ptr %PC, align 8
  %v3207 = add i64 %v3206, 5
  store i64 %v3207, ptr %NEXT_PC, align 8
  %v3208 = load i64, ptr %RSP, align 8
  %v3209 = add i64 %v3208, 48
  %v3210 = load ptr, ptr %MEMORY, align 8
  %v3211 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3210, ptr %state, ptr %R12, i64 %v3209)
  store ptr %v3211, ptr %MEMORY, align 8
  store i64 %v3207, ptr %PC, align 8
  %v3212 = add i64 %v3207, 2
  store i64 %v3212, ptr %NEXT_PC, align 8
  %v3213 = load i64, ptr %RAX, align 8
  %v3214 = load ptr, ptr %MEMORY, align 8
  %v3215 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3214, ptr %state, ptr %RAX, i64 %v3213)
  store ptr %v3215, ptr %MEMORY, align 8
  store i64 %v3212, ptr %PC, align 8
  %v3216 = add i64 %v3212, 5
  store i64 %v3216, ptr %NEXT_PC, align 8
  %v3217 = load i64, ptr %RSP, align 8
  %v3218 = add i64 %v3217, 80
  %v3219 = load ptr, ptr %MEMORY, align 8
  %v3220 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3219, ptr %state, ptr %RBP, i64 %v3218)
  store ptr %v3220, ptr %MEMORY, align 8
  store i64 %v3216, ptr %PC, align 8
  %v3221 = add i64 %v3216, 3
  store i64 %v3221, ptr %NEXT_PC, align 8
  %v3222 = load i64, ptr %RSI, align 8
  %v3223 = add i64 %v3222, 24
  %v3224 = load i32, ptr %EAX, align 4
  %v3225 = zext i32 %v3224 to i64
  %v3226 = load ptr, ptr %MEMORY, align 8
  %v3227 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3226, ptr %state, i64 %v3223, i64 %v3225)
  store ptr %v3227, ptr %MEMORY, align 8
  br label %bb_5389879099

bb_5389879099:                                    ; preds = %bb_5389879084, %bb_5389878859, %bb_5389878772
  %v3228 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3228, ptr %PC, align 8
  %v3229 = add i64 %v3228, 3
  store i64 %v3229, ptr %NEXT_PC, align 8
  %v3230 = load i64, ptr %R15, align 8
  %v3231 = load ptr, ptr %MEMORY, align 8
  %v3232 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3231, ptr %state, ptr %RBX, i64 %v3230)
  store ptr %v3232, ptr %MEMORY, align 8
  store i64 %v3229, ptr %PC, align 8
  %v3233 = add i64 %v3229, 5
  store i64 %v3233, ptr %NEXT_PC, align 8
  %v3234 = load i64, ptr %RSP, align 8
  %v3235 = add i64 %v3234, 32
  %v3236 = load ptr, ptr %MEMORY, align 8
  %v3237 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3236, ptr %state, ptr %R15, i64 %v3235)
  store ptr %v3237, ptr %MEMORY, align 8
  store i64 %v3233, ptr %PC, align 8
  %v3238 = add i64 %v3233, 5
  store i64 %v3238, ptr %NEXT_PC, align 8
  %v3239 = load i64, ptr %RSP, align 8
  %v3240 = add i64 %v3239, 88
  %v3241 = load ptr, ptr %MEMORY, align 8
  %v3242 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3241, ptr %state, ptr %RSI, i64 %v3240)
  store ptr %v3242, ptr %MEMORY, align 8
  store i64 %v3238, ptr %PC, align 8
  %v3243 = add i64 %v3238, 3
  store i64 %v3243, ptr %NEXT_PC, align 8
  %v3244 = load i64, ptr %RBX, align 8
  %v3245 = load i64, ptr %RBX, align 8
  %v3246 = load ptr, ptr %MEMORY, align 8
  %v3247 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3246, ptr %state, i64 %v3244, i64 %v3245)
  store ptr %v3247, ptr %MEMORY, align 8
  store i64 %v3243, ptr %PC, align 8
  %v3248 = add i64 %v3243, 2
  store i64 %v3248, ptr %NEXT_PC, align 8
  %v3249 = add i64 %v3248, 100
  %v3250 = load ptr, ptr %MEMORY, align 8
  %v3251 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3250, ptr %state, ptr %BRANCH_TAKEN, i64 %v3249, i64 %v3248, ptr %NEXT_PC)
  store ptr %v3251, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879117:                                    ; No predecessors!
  %v3252 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3252, ptr %PC, align 8
  %v3253 = add i64 %v3252, 4
  store i64 %v3253, ptr %NEXT_PC, align 8
  %v3254 = load i64, ptr %RBX, align 8
  %v3255 = add i64 %v3254, 48
  %v3256 = load ptr, ptr %MEMORY, align 8
  %v3257 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3256, ptr %state, ptr %RCX, i64 %v3255)
  store ptr %v3257, ptr %MEMORY, align 8
  store i64 %v3253, ptr %PC, align 8
  %v3258 = add i64 %v3253, 4
  store i64 %v3258, ptr %NEXT_PC, align 8
  %v3259 = load i64, ptr %RCX, align 8
  %v3260 = add i64 %v3259, 16
  %v3261 = load ptr, ptr %MEMORY, align 8
  %v3262 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3261, ptr %state, ptr %RAX, i64 %v3260)
  store ptr %v3262, ptr %MEMORY, align 8
  store i64 %v3258, ptr %PC, align 8
  %v3263 = add i64 %v3258, 2
  store i64 %v3263, ptr %NEXT_PC, align 8
  %v3264 = load i8, ptr %AL, align 1
  %v3265 = zext i8 %v3264 to i64
  %v3266 = load ptr, ptr %MEMORY, align 8
  %v3267 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3266, ptr %state, i64 %v3265, i64 2)
  store ptr %v3267, ptr %MEMORY, align 8
  store i64 %v3263, ptr %PC, align 8
  %v3268 = add i64 %v3263, 2
  store i64 %v3268, ptr %NEXT_PC, align 8
  %v3269 = add i64 %v3268, 88
  %v3270 = load ptr, ptr %MEMORY, align 8
  %v3271 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3270, ptr %state, ptr %BRANCH_TAKEN, i64 %v3269, i64 %v3268, ptr %NEXT_PC)
  store ptr %v3271, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879129:                                    ; No predecessors!
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
