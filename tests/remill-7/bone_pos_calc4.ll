; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: wwzRetailEgs.exe
; Address: 0x14142fe90
; Size: 2250 bytes
; Architecture: amd64
; Generated: 2026-03-08T07:59:32.362Z
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
  %v1 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1, ptr %PC, align 8
  %v2 = add i64 %v1, 5
  store i64 %v2, ptr %NEXT_PC, align 8
  %v3 = load i64, ptr %RSP, align 8
  %v4 = add i64 %v3, 16
  %v5 = load i64, ptr %RSI, align 8
  %v6 = load ptr, ptr %MEMORY, align 8
  %v7 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6, ptr %state, i64 %v4, i64 %v5)
  store ptr %v7, ptr %MEMORY, align 8
  %v8 = load i64, ptr %NEXT_PC, align 8
  store i64 %v8, ptr %PC, align 8
  %v9 = add i64 %v8, 5
  store i64 %v9, ptr %NEXT_PC, align 8
  %v10 = load i64, ptr %RSP, align 8
  %v11 = add i64 %v10, 32
  %v12 = load i64, ptr %RDI, align 8
  %v13 = load ptr, ptr %MEMORY, align 8
  %v14 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v13, ptr %state, i64 %v11, i64 %v12)
  store ptr %v14, ptr %MEMORY, align 8
  %v15 = load i64, ptr %NEXT_PC, align 8
  store i64 %v15, ptr %PC, align 8
  %v16 = add i64 %v15, 5
  store i64 %v16, ptr %NEXT_PC, align 8
  %v17 = load i64, ptr %RSP, align 8
  %v18 = add i64 %v17, 24
  %v19 = load i32, ptr %R8D, align 4
  %v20 = zext i32 %v19 to i64
  %v21 = load ptr, ptr %MEMORY, align 8
  %v22 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v21, ptr %state, i64 %v18, i64 %v20)
  store ptr %v22, ptr %MEMORY, align 8
  %v23 = load i64, ptr %NEXT_PC, align 8
  store i64 %v23, ptr %PC, align 8
  %v24 = add i64 %v23, 1
  store i64 %v24, ptr %NEXT_PC, align 8
  %v25 = load i64, ptr %RBP, align 8
  %v26 = load ptr, ptr %MEMORY, align 8
  %v27 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v26, ptr %state, i64 %v25)
  store ptr %v27, ptr %MEMORY, align 8
  %v28 = load i64, ptr %NEXT_PC, align 8
  store i64 %v28, ptr %PC, align 8
  %v29 = add i64 %v28, 2
  store i64 %v29, ptr %NEXT_PC, align 8
  %v30 = load i64, ptr %R12, align 8
  %v31 = load ptr, ptr %MEMORY, align 8
  %v32 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v31, ptr %state, i64 %v30)
  store ptr %v32, ptr %MEMORY, align 8
  %v33 = load i64, ptr %NEXT_PC, align 8
  store i64 %v33, ptr %PC, align 8
  %v34 = add i64 %v33, 2
  store i64 %v34, ptr %NEXT_PC, align 8
  %v35 = load i64, ptr %R13, align 8
  %v36 = load ptr, ptr %MEMORY, align 8
  %v37 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v36, ptr %state, i64 %v35)
  store ptr %v37, ptr %MEMORY, align 8
  %v38 = load i64, ptr %NEXT_PC, align 8
  store i64 %v38, ptr %PC, align 8
  %v39 = add i64 %v38, 2
  store i64 %v39, ptr %NEXT_PC, align 8
  %v40 = load i64, ptr %R14, align 8
  %v41 = load ptr, ptr %MEMORY, align 8
  %v42 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v41, ptr %state, i64 %v40)
  store ptr %v42, ptr %MEMORY, align 8
  %v43 = load i64, ptr %NEXT_PC, align 8
  store i64 %v43, ptr %PC, align 8
  %v44 = add i64 %v43, 2
  store i64 %v44, ptr %NEXT_PC, align 8
  %v45 = load i64, ptr %R15, align 8
  %v46 = load ptr, ptr %MEMORY, align 8
  %v47 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v46, ptr %state, i64 %v45)
  store ptr %v47, ptr %MEMORY, align 8
  %v48 = load i64, ptr %NEXT_PC, align 8
  store i64 %v48, ptr %PC, align 8
  %v49 = add i64 %v48, 3
  store i64 %v49, ptr %NEXT_PC, align 8
  %v50 = load i64, ptr %RSP, align 8
  %v51 = load ptr, ptr %MEMORY, align 8
  %v52 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v51, ptr %state, ptr %RBP, i64 %v50)
  store ptr %v52, ptr %MEMORY, align 8
  %v53 = load i64, ptr %NEXT_PC, align 8
  store i64 %v53, ptr %PC, align 8
  %v54 = add i64 %v53, 4
  store i64 %v54, ptr %NEXT_PC, align 8
  %v55 = load i64, ptr %RSP, align 8
  %v56 = load ptr, ptr %MEMORY, align 8
  %v57 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v56, ptr %state, ptr %RSP, i64 %v55, i64 96)
  store ptr %v57, ptr %MEMORY, align 8
  %v58 = load i64, ptr %NEXT_PC, align 8
  store i64 %v58, ptr %PC, align 8
  %v59 = add i64 %v58, 4
  store i64 %v59, ptr %NEXT_PC, align 8
  %v60 = load i64, ptr %RBP, align 8
  %v61 = add i64 %v60, 80
  %v62 = load ptr, ptr %MEMORY, align 8
  %v63 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v62, ptr %state, ptr %RSI, i64 %v61)
  store ptr %v63, ptr %MEMORY, align 8
  %v64 = load i64, ptr %NEXT_PC, align 8
  store i64 %v64, ptr %PC, align 8
  %v65 = add i64 %v64, 2
  store i64 %v65, ptr %NEXT_PC, align 8
  %v66 = load i64, ptr %RDI, align 8
  %v67 = load i32, ptr %EDI, align 4
  %v68 = zext i32 %v67 to i64
  %v69 = load ptr, ptr %MEMORY, align 8
  %v70 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v69, ptr %state, ptr %RDI, i64 %v66, i64 %v68)
  store ptr %v70, ptr %MEMORY, align 8
  %v71 = load i64, ptr %NEXT_PC, align 8
  store i64 %v71, ptr %PC, align 8
  %v72 = add i64 %v71, 3
  store i64 %v72, ptr %NEXT_PC, align 8
  %v73 = load i32, ptr %R9D, align 4
  %v74 = zext i32 %v73 to i64
  %v75 = load ptr, ptr %MEMORY, align 8
  %v76 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v75, ptr %state, ptr %R13, i64 %v74)
  store ptr %v76, ptr %MEMORY, align 8
  %v77 = load i64, ptr %NEXT_PC, align 8
  store i64 %v77, ptr %PC, align 8
  %v78 = add i64 %v77, 3
  store i64 %v78, ptr %NEXT_PC, align 8
  %v79 = load i32, ptr %R8D, align 4
  %v80 = zext i32 %v79 to i64
  %v81 = load ptr, ptr %MEMORY, align 8
  %v82 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v81, ptr %state, ptr %R12, i64 %v80)
  store ptr %v82, ptr %MEMORY, align 8
  %v83 = load i64, ptr %NEXT_PC, align 8
  store i64 %v83, ptr %PC, align 8
  %v84 = add i64 %v83, 3
  store i64 %v84, ptr %NEXT_PC, align 8
  %v85 = load i64, ptr %RDX, align 8
  %v86 = load ptr, ptr %MEMORY, align 8
  %v87 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v86, ptr %state, ptr %R15, i64 %v85)
  store ptr %v87, ptr %MEMORY, align 8
  %v88 = load i64, ptr %NEXT_PC, align 8
  store i64 %v88, ptr %PC, align 8
  %v89 = add i64 %v88, 3
  store i64 %v89, ptr %NEXT_PC, align 8
  %v90 = load i64, ptr %RCX, align 8
  %v91 = load ptr, ptr %MEMORY, align 8
  %v92 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v91, ptr %state, ptr %R14, i64 %v90)
  store ptr %v92, ptr %MEMORY, align 8
  %v93 = load i64, ptr %NEXT_PC, align 8
  store i64 %v93, ptr %PC, align 8
  %v94 = add i64 %v93, 6
  store i64 %v94, ptr %NEXT_PC, align 8
  %v95 = load i64, ptr %RSI, align 8
  %v96 = add i64 %v95, 256
  %v97 = load ptr, ptr %MEMORY, align 8
  %v98 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v97, ptr %state, ptr %RAX, i64 %v96)
  store ptr %v98, ptr %MEMORY, align 8
  %v99 = load i64, ptr %NEXT_PC, align 8
  store i64 %v99, ptr %PC, align 8
  %v100 = add i64 %v99, 2
  store i64 %v100, ptr %NEXT_PC, align 8
  %v101 = load i32, ptr %EAX, align 4
  %v102 = zext i32 %v101 to i64
  %v103 = load i32, ptr %EAX, align 4
  %v104 = zext i32 %v103 to i64
  %v105 = load ptr, ptr %MEMORY, align 8
  %v106 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v105, ptr %state, i64 %v102, i64 %v104)
  store ptr %v106, ptr %MEMORY, align 8
  %v107 = load i64, ptr %NEXT_PC, align 8
  store i64 %v107, ptr %PC, align 8
  %v108 = add i64 %v107, 2
  store i64 %v108, ptr %NEXT_PC, align 8
  %v109 = load i64, ptr %NEXT_PC, align 8
  %v110 = add i64 %v109, 14
  %v111 = load i64, ptr %NEXT_PC, align 8
  %v112 = load ptr, ptr %MEMORY, align 8
  %v113 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v112, ptr %state, ptr %BRANCH_TAKEN, i64 %v110, i64 %v111, ptr %NEXT_PC)
  store ptr %v113, ptr %MEMORY, align 8
  br i1 true, label %bb_5389876953, label %bb_5389876939

bb_5389876939:                                    ; preds = %bb_0
  %v114 = load i64, ptr %NEXT_PC, align 8
  store i64 %v114, ptr %PC, align 8
  %v115 = add i64 %v114, 2
  store i64 %v115, ptr %NEXT_PC, align 8
  %v116 = load i64, ptr %RSI, align 8
  %v117 = load i32, ptr %EDI, align 4
  %v118 = zext i32 %v117 to i64
  %v119 = load ptr, ptr %MEMORY, align 8
  %v120 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v119, ptr %state, i64 %v116, i64 %v118)
  store ptr %v120, ptr %MEMORY, align 8
  %v121 = load i64, ptr %NEXT_PC, align 8
  store i64 %v121, ptr %PC, align 8
  %v122 = add i64 %v121, 6
  store i64 %v122, ptr %NEXT_PC, align 8
  %v123 = load i64, ptr %RSI, align 8
  %v124 = add i64 %v123, 256
  %v125 = load i64, ptr %RSI, align 8
  %v126 = add i64 %v125, 256
  %v127 = load ptr, ptr %MEMORY, align 8
  %v128 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v127, ptr %state, i64 %v124, i64 %v126)
  store ptr %v128, ptr %MEMORY, align 8
  %v129 = load i64, ptr %NEXT_PC, align 8
  store i64 %v129, ptr %PC, align 8
  %v130 = add i64 %v129, 6
  store i64 %v130, ptr %NEXT_PC, align 8
  %v131 = load i64, ptr %RSI, align 8
  %v132 = add i64 %v131, 256
  %v133 = load ptr, ptr %MEMORY, align 8
  %v134 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v133, ptr %state, ptr %RAX, i64 %v132)
  store ptr %v134, ptr %MEMORY, align 8
  br label %bb_5389876953

bb_5389876953:                                    ; preds = %bb_5389876939, %bb_0
  %v135 = load i64, ptr %NEXT_PC, align 8
  store i64 %v135, ptr %PC, align 8
  %v136 = add i64 %v135, 3
  store i64 %v136, ptr %NEXT_PC, align 8
  %v137 = load i32, ptr %EAX, align 4
  %v138 = zext i32 %v137 to i64
  %v139 = load ptr, ptr %MEMORY, align 8
  %v140 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v139, ptr %state, i64 %v138, i64 1)
  store ptr %v140, ptr %MEMORY, align 8
  %v141 = load i64, ptr %NEXT_PC, align 8
  store i64 %v141, ptr %PC, align 8
  %v142 = add i64 %v141, 2
  store i64 %v142, ptr %NEXT_PC, align 8
  %v143 = load i64, ptr %NEXT_PC, align 8
  %v144 = add i64 %v143, 76
  %v145 = load i64, ptr %NEXT_PC, align 8
  %v146 = load ptr, ptr %MEMORY, align 8
  %v147 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v146, ptr %state, ptr %BRANCH_TAKEN, i64 %v144, i64 %v145, ptr %NEXT_PC)
  store ptr %v147, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877034, label %bb_5389876958

bb_5389876958:                                    ; preds = %bb_5389876953
  %v148 = load i64, ptr %NEXT_PC, align 8
  store i64 %v148, ptr %PC, align 8
  %v149 = add i64 %v148, 4
  store i64 %v149, ptr %NEXT_PC, align 8
  %v150 = load i64, ptr %RBP, align 8
  %v151 = sub i64 %v150, 40
  %v152 = load ptr, ptr %MEMORY, align 8
  %v153 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v152, ptr %state, ptr %RCX, i64 %v151)
  store ptr %v153, ptr %MEMORY, align 8
  %v154 = load i64, ptr %NEXT_PC, align 8
  store i64 %v154, ptr %PC, align 8
  %v155 = add i64 %v154, 4
  store i64 %v155, ptr %NEXT_PC, align 8
  %v156 = load i64, ptr %RBP, align 8
  %v157 = sub i64 %v156, 8
  %v158 = load i64, ptr %RDI, align 8
  %v159 = load ptr, ptr %MEMORY, align 8
  %v160 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v159, ptr %state, i64 %v157, i64 %v158)
  store ptr %v160, ptr %MEMORY, align 8
  %v161 = load i64, ptr %NEXT_PC, align 8
  store i64 %v161, ptr %PC, align 8
  %v162 = add i64 %v161, 5
  store i64 %v162, ptr %NEXT_PC, align 8
  %v163 = load i64, ptr %NEXT_PC, align 8
  %v164 = sub i64 %v163, 18801275
  %v165 = load i64, ptr %NEXT_PC, align 8
  %v166 = load ptr, ptr %MEMORY, align 8
  %v167 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v166, ptr %state, i64 %v164, ptr %NEXT_PC, i64 %v165, ptr %RETURN_PC)
  store ptr %v167, ptr %MEMORY, align 8
  %v168 = load i64, ptr %NEXT_PC, align 8
  store i64 %v168, ptr %PC, align 8
  %v169 = add i64 %v168, 2
  store i64 %v169, ptr %NEXT_PC, align 8
  %v170 = load i64, ptr %RSI, align 8
  %v171 = load ptr, ptr %MEMORY, align 8
  %v172 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v171, ptr %state, ptr %RDX, i64 %v170)
  store ptr %v172, ptr %MEMORY, align 8
  %v173 = load i64, ptr %NEXT_PC, align 8
  store i64 %v173, ptr %PC, align 8
  %v174 = add i64 %v173, 4
  store i64 %v174, ptr %NEXT_PC, align 8
  %v175 = load i64, ptr %RBP, align 8
  %v176 = sub i64 %v175, 40
  %v177 = load ptr, ptr %MEMORY, align 8
  %v178 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v177, ptr %state, ptr %R8, i64 %v176)
  store ptr %v178, ptr %MEMORY, align 8
  %v179 = load i64, ptr %NEXT_PC, align 8
  store i64 %v179, ptr %PC, align 8
  %v180 = add i64 %v179, 3
  store i64 %v180, ptr %NEXT_PC, align 8
  %v181 = load i32, ptr %R12D, align 4
  %v182 = zext i32 %v181 to i64
  %v183 = load ptr, ptr %MEMORY, align 8
  %v184 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v183, ptr %state, ptr %R9, i64 %v182)
  store ptr %v184, ptr %MEMORY, align 8
  %v185 = load i64, ptr %NEXT_PC, align 8
  store i64 %v185, ptr %PC, align 8
  %v186 = add i64 %v185, 8
  store i64 %v186, ptr %NEXT_PC, align 8
  %v187 = load i64, ptr %RSP, align 8
  %v188 = add i64 %v187, 40
  %v189 = load ptr, ptr %MEMORY, align 8
  %v190 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v189, ptr %state, i64 %v188, i64 -1)
  store ptr %v190, ptr %MEMORY, align 8
  %v191 = load i64, ptr %NEXT_PC, align 8
  store i64 %v191, ptr %PC, align 8
  %v192 = add i64 %v191, 3
  store i64 %v192, ptr %NEXT_PC, align 8
  %v193 = load i64, ptr %R14, align 8
  %v194 = load ptr, ptr %MEMORY, align 8
  %v195 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v194, ptr %state, ptr %RCX, i64 %v193)
  store ptr %v195, ptr %MEMORY, align 8
  %v196 = load i64, ptr %NEXT_PC, align 8
  store i64 %v196, ptr %PC, align 8
  %v197 = add i64 %v196, 5
  store i64 %v197, ptr %NEXT_PC, align 8
  %v198 = load i64, ptr %RSP, align 8
  %v199 = add i64 %v198, 32
  %v200 = load i32, ptr %R13D, align 4
  %v201 = zext i32 %v200 to i64
  %v202 = load ptr, ptr %MEMORY, align 8
  %v203 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v202, ptr %state, i64 %v199, i64 %v201)
  store ptr %v203, ptr %MEMORY, align 8
  %v204 = load i64, ptr %NEXT_PC, align 8
  store i64 %v204, ptr %PC, align 8
  %v205 = add i64 %v204, 5
  store i64 %v205, ptr %NEXT_PC, align 8
  %v206 = load i64, ptr %NEXT_PC, align 8
  %v207 = add i64 %v206, 4935
  %v208 = load i64, ptr %NEXT_PC, align 8
  %v209 = load ptr, ptr %MEMORY, align 8
  %v210 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v209, ptr %state, i64 %v207, ptr %NEXT_PC, i64 %v208, ptr %RETURN_PC)
  store ptr %v210, ptr %MEMORY, align 8
  %v211 = load i64, ptr %NEXT_PC, align 8
  store i64 %v211, ptr %PC, align 8
  %v212 = add i64 %v211, 4
  store i64 %v212, ptr %NEXT_PC, align 8
  %v213 = load i64, ptr %R15, align 8
  %v214 = add i64 %v213, 32
  %v215 = load ptr, ptr %MEMORY, align 8
  %v216 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v215, ptr %state, ptr %RCX, i64 %v214)
  store ptr %v216, ptr %MEMORY, align 8
  %v217 = load i64, ptr %NEXT_PC, align 8
  store i64 %v217, ptr %PC, align 8
  %v218 = add i64 %v217, 3
  store i64 %v218, ptr %NEXT_PC, align 8
  %v219 = load i32, ptr %EAX, align 4
  %v220 = zext i32 %v219 to i64
  %v221 = load ptr, ptr %MEMORY, align 8
  %v222 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v221, ptr %state, i64 %v220, i64 -1)
  store ptr %v222, ptr %MEMORY, align 8
  %v223 = load i64, ptr %NEXT_PC, align 8
  store i64 %v223, ptr %PC, align 8
  %v224 = add i64 %v223, 4
  store i64 %v224, ptr %NEXT_PC, align 8
  %v225 = load ptr, ptr %MEMORY, align 8
  %v226 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v225, ptr %state, ptr %DIL)
  store ptr %v226, ptr %MEMORY, align 8
  %v227 = load i64, ptr %NEXT_PC, align 8
  store i64 %v227, ptr %PC, align 8
  %v228 = add i64 %v227, 3
  store i64 %v228, ptr %NEXT_PC, align 8
  %v229 = load i64, ptr %RCX, align 8
  %v230 = load i64, ptr %RCX, align 8
  %v231 = load ptr, ptr %MEMORY, align 8
  %v232 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v231, ptr %state, i64 %v229, i64 %v230)
  store ptr %v232, ptr %MEMORY, align 8
  %v233 = load i64, ptr %NEXT_PC, align 8
  store i64 %v233, ptr %PC, align 8
  %v234 = add i64 %v233, 2
  store i64 %v234, ptr %NEXT_PC, align 8
  %v235 = load i64, ptr %NEXT_PC, align 8
  %v236 = add i64 %v235, 10
  %v237 = load i64, ptr %NEXT_PC, align 8
  %v238 = load ptr, ptr %MEMORY, align 8
  %v239 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v238, ptr %state, ptr %BRANCH_TAKEN, i64 %v236, i64 %v237, ptr %NEXT_PC)
  store ptr %v239, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877027, label %bb_5389877017

bb_5389877017:                                    ; preds = %bb_5389876958
  %v240 = load i64, ptr %NEXT_PC, align 8
  store i64 %v240, ptr %PC, align 8
  %v241 = add i64 %v240, 3
  store i64 %v241, ptr %NEXT_PC, align 8
  %v242 = load i64, ptr %RCX, align 8
  %v243 = load ptr, ptr %MEMORY, align 8
  %v244 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v243, ptr %state, ptr %R8, i64 %v242)
  store ptr %v244, ptr %MEMORY, align 8
  %v245 = load i64, ptr %NEXT_PC, align 8
  store i64 %v245, ptr %PC, align 8
  %v246 = add i64 %v245, 3
  store i64 %v246, ptr %NEXT_PC, align 8
  %v247 = load i64, ptr %R15, align 8
  %v248 = load ptr, ptr %MEMORY, align 8
  %v249 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v248, ptr %state, ptr %RDX, i64 %v247)
  store ptr %v249, ptr %MEMORY, align 8
  %v250 = load i64, ptr %NEXT_PC, align 8
  store i64 %v250, ptr %PC, align 8
  %v251 = add i64 %v250, 4
  store i64 %v251, ptr %NEXT_PC, align 8
  %v252 = load i64, ptr %R8, align 8
  %v253 = add i64 %v252, 24
  %v254 = load i64, ptr %NEXT_PC, align 8
  %v255 = load ptr, ptr %MEMORY, align 8
  %v256 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v255, ptr %state, i64 %v253, ptr %NEXT_PC, i64 %v254, ptr %RETURN_PC)
  store ptr %v256, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877027:                                    ; preds = %bb_5389876958
  %v257 = load i64, ptr %NEXT_PC, align 8
  store i64 %v257, ptr %PC, align 8
  %v258 = add i64 %v257, 2
  store i64 %v258, ptr %NEXT_PC, align 8
  %v259 = load i32, ptr %EDI, align 4
  %v260 = zext i32 %v259 to i64
  %v261 = load ptr, ptr %MEMORY, align 8
  %v262 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v261, ptr %state, ptr %RAX, i64 %v260)
  store ptr %v262, ptr %MEMORY, align 8
  %v263 = load i64, ptr %NEXT_PC, align 8
  store i64 %v263, ptr %PC, align 8
  %v264 = add i64 %v263, 5
  store i64 %v264, ptr %NEXT_PC, align 8
  %v265 = load i64, ptr %NEXT_PC, align 8
  %v266 = add i64 %v265, 576
  %v267 = load ptr, ptr %MEMORY, align 8
  %v268 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v267, ptr %state, i64 %v266, ptr %NEXT_PC)
  store ptr %v268, ptr %MEMORY, align 8
  br label %bb_5389877610

bb_5389877034:                                    ; preds = %bb_5389876953
  %v269 = load i64, ptr %NEXT_PC, align 8
  store i64 %v269, ptr %PC, align 8
  %v270 = add i64 %v269, 2
  store i64 %v270, ptr %NEXT_PC, align 8
  %v271 = load i64, ptr %RAX, align 8
  %v272 = load ptr, ptr %MEMORY, align 8
  %v273 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v272, ptr %state, ptr %RAX, i64 %v271)
  store ptr %v273, ptr %MEMORY, align 8
  %v274 = load i64, ptr %NEXT_PC, align 8
  store i64 %v274, ptr %PC, align 8
  %v275 = add i64 %v274, 8
  store i64 %v275, ptr %NEXT_PC, align 8
  %v276 = load i64, ptr %RSP, align 8
  %v277 = add i64 %v276, 144
  %v278 = load i64, ptr %RBX, align 8
  %v279 = load ptr, ptr %MEMORY, align 8
  %v280 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v279, ptr %state, i64 %v277, i64 %v278)
  store ptr %v280, ptr %MEMORY, align 8
  %v281 = load i64, ptr %NEXT_PC, align 8
  store i64 %v281, ptr %PC, align 8
  %v282 = add i64 %v281, 3
  store i64 %v282, ptr %NEXT_PC, align 8
  %v283 = load i32, ptr %EAX, align 4
  %v284 = zext i32 %v283 to i64
  %v285 = load ptr, ptr %MEMORY, align 8
  %v286 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v285, ptr %state, ptr %RCX, i64 %v284)
  store ptr %v286, ptr %MEMORY, align 8
  %v287 = load i64, ptr %NEXT_PC, align 8
  store i64 %v287, ptr %PC, align 8
  %v288 = add i64 %v287, 3
  store i64 %v288, ptr %NEXT_PC, align 8
  %v289 = load i64, ptr %RSI, align 8
  %v290 = load i64, ptr %RCX, align 8
  %v291 = mul i64 %v290, 4
  %v292 = add i64 %v289, %v291
  %v293 = load ptr, ptr %MEMORY, align 8
  %v294 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v293, ptr %state, ptr %RDX, i64 %v292)
  store ptr %v294, ptr %MEMORY, align 8
  %v295 = load i64, ptr %NEXT_PC, align 8
  store i64 %v295, ptr %PC, align 8
  %v296 = add i64 %v295, 3
  store i64 %v296, ptr %NEXT_PC, align 8
  %v297 = load i64, ptr %R14, align 8
  %v298 = load ptr, ptr %MEMORY, align 8
  %v299 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v298, ptr %state, ptr %RCX, i64 %v297)
  store ptr %v299, ptr %MEMORY, align 8
  %v300 = load i64, ptr %NEXT_PC, align 8
  store i64 %v300, ptr %PC, align 8
  %v301 = add i64 %v300, 5
  store i64 %v301, ptr %NEXT_PC, align 8
  %v302 = load i64, ptr %NEXT_PC, align 8
  %v303 = add i64 %v302, 6478
  %v304 = load i64, ptr %NEXT_PC, align 8
  %v305 = load ptr, ptr %MEMORY, align 8
  %v306 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v305, ptr %state, i64 %v303, ptr %NEXT_PC, i64 %v304, ptr %RETURN_PC)
  store ptr %v306, ptr %MEMORY, align 8
  %v307 = load i64, ptr %NEXT_PC, align 8
  store i64 %v307, ptr %PC, align 8
  %v308 = add i64 %v307, 3
  store i64 %v308, ptr %NEXT_PC, align 8
  %v309 = load i32, ptr %EAX, align 4
  %v310 = zext i32 %v309 to i64
  %v311 = load ptr, ptr %MEMORY, align 8
  %v312 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v311, ptr %state, ptr %RBX, i64 %v310)
  store ptr %v312, ptr %MEMORY, align 8
  %v313 = load i64, ptr %NEXT_PC, align 8
  store i64 %v313, ptr %PC, align 8
  %v314 = add i64 %v313, 3
  store i64 %v314, ptr %NEXT_PC, align 8
  %v315 = load i32, ptr %EBX, align 4
  %v316 = zext i32 %v315 to i64
  %v317 = load ptr, ptr %MEMORY, align 8
  %v318 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v317, ptr %state, i64 %v316, i64 -1)
  store ptr %v318, ptr %MEMORY, align 8
  %v319 = load i64, ptr %NEXT_PC, align 8
  store i64 %v319, ptr %PC, align 8
  %v320 = add i64 %v319, 2
  store i64 %v320, ptr %NEXT_PC, align 8
  %v321 = load i64, ptr %NEXT_PC, align 8
  %v322 = add i64 %v321, 121
  %v323 = load i64, ptr %NEXT_PC, align 8
  %v324 = load ptr, ptr %MEMORY, align 8
  %v325 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v324, ptr %state, ptr %BRANCH_TAKEN, i64 %v322, i64 %v323, ptr %NEXT_PC)
  store ptr %v325, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877187, label %bb_5389877066

bb_5389877066:                                    ; preds = %bb_5389877034
  %v326 = load i64, ptr %NEXT_PC, align 8
  store i64 %v326, ptr %PC, align 8
  %v327 = add i64 %v326, 2
  store i64 %v327, ptr %NEXT_PC, align 8
  %v328 = load i32, ptr %EAX, align 4
  %v329 = zext i32 %v328 to i64
  %v330 = load i32, ptr %EAX, align 4
  %v331 = zext i32 %v330 to i64
  %v332 = load ptr, ptr %MEMORY, align 8
  %v333 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v332, ptr %state, i64 %v329, i64 %v331)
  store ptr %v333, ptr %MEMORY, align 8
  %v334 = load i64, ptr %NEXT_PC, align 8
  store i64 %v334, ptr %PC, align 8
  %v335 = add i64 %v334, 2
  store i64 %v335, ptr %NEXT_PC, align 8
  %v336 = load i64, ptr %NEXT_PC, align 8
  %v337 = add i64 %v336, 60
  %v338 = load i64, ptr %NEXT_PC, align 8
  %v339 = load ptr, ptr %MEMORY, align 8
  %v340 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v339, ptr %state, ptr %BRANCH_TAKEN, i64 %v337, i64 %v338, ptr %NEXT_PC)
  store ptr %v340, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877130, label %bb_5389877070

bb_5389877070:                                    ; preds = %bb_5389877066
  %v341 = load i64, ptr %NEXT_PC, align 8
  store i64 %v341, ptr %PC, align 8
  %v342 = add i64 %v341, 4
  store i64 %v342, ptr %NEXT_PC, align 8
  %v343 = load i32, ptr %EBX, align 4
  %v344 = zext i32 %v343 to i64
  %v345 = load i64, ptr %R14, align 8
  %v346 = add i64 %v345, 40
  %v347 = load ptr, ptr %MEMORY, align 8
  %v348 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v347, ptr %state, i64 %v344, i64 %v346)
  store ptr %v348, ptr %MEMORY, align 8
  %v349 = load i64, ptr %NEXT_PC, align 8
  store i64 %v349, ptr %PC, align 8
  %v350 = add i64 %v349, 2
  store i64 %v350, ptr %NEXT_PC, align 8
  %v351 = load i64, ptr %NEXT_PC, align 8
  %v352 = add i64 %v351, 54
  %v353 = load i64, ptr %NEXT_PC, align 8
  %v354 = load ptr, ptr %MEMORY, align 8
  %v355 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v354, ptr %state, ptr %BRANCH_TAKEN, i64 %v352, i64 %v353, ptr %NEXT_PC)
  store ptr %v355, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877130, label %bb_5389877076

bb_5389877076:                                    ; preds = %bb_5389877070
  %v356 = load i64, ptr %NEXT_PC, align 8
  store i64 %v356, ptr %PC, align 8
  %v357 = add i64 %v356, 4
  store i64 %v357, ptr %NEXT_PC, align 8
  %v358 = load i64, ptr %R14, align 8
  %v359 = add i64 %v358, 32
  %v360 = load ptr, ptr %MEMORY, align 8
  %v361 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v360, ptr %state, ptr %R8, i64 %v359)
  store ptr %v361, ptr %MEMORY, align 8
  %v362 = load i64, ptr %NEXT_PC, align 8
  store i64 %v362, ptr %PC, align 8
  %v363 = add i64 %v362, 3
  store i64 %v363, ptr %NEXT_PC, align 8
  %v364 = load i64, ptr %RDI, align 8
  %v365 = load ptr, ptr %MEMORY, align 8
  %v366 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v365, ptr %state, ptr %RCX, i64 %v364)
  store ptr %v366, ptr %MEMORY, align 8
  %v367 = load i64, ptr %NEXT_PC, align 8
  store i64 %v367, ptr %PC, align 8
  %v368 = add i64 %v367, 4
  store i64 %v368, ptr %NEXT_PC, align 8
  %v369 = load i64, ptr %RBX, align 8
  %v370 = load ptr, ptr %MEMORY, align 8
  %v371 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v370, ptr %state, ptr %RDX, i64 %v369, i64 56)
  store ptr %v371, ptr %MEMORY, align 8
  %v372 = load i64, ptr %NEXT_PC, align 8
  store i64 %v372, ptr %PC, align 8
  %v373 = add i64 %v372, 4
  store i64 %v373, ptr %NEXT_PC, align 8
  %v374 = load i64, ptr %R8, align 8
  %v375 = load ptr, ptr %MEMORY, align 8
  %v376 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v375, ptr %state, ptr %R8, i64 %v374, i64 8)
  store ptr %v376, ptr %MEMORY, align 8
  %v377 = load i64, ptr %NEXT_PC, align 8
  store i64 %v377, ptr %PC, align 8
  %v378 = add i64 %v377, 4
  store i64 %v378, ptr %NEXT_PC, align 8
  %v379 = load i64, ptr %RBP, align 8
  %v380 = sub i64 %v379, 8
  %v381 = load i64, ptr %RCX, align 8
  %v382 = load ptr, ptr %MEMORY, align 8
  %v383 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v382, ptr %state, i64 %v380, i64 %v381)
  store ptr %v383, ptr %MEMORY, align 8
  %v384 = load i64, ptr %NEXT_PC, align 8
  store i64 %v384, ptr %PC, align 8
  %v385 = add i64 %v384, 3
  store i64 %v385, ptr %NEXT_PC, align 8
  %v386 = load i64, ptr %R8, align 8
  %v387 = load i64, ptr %RDX, align 8
  %v388 = load ptr, ptr %MEMORY, align 8
  %v389 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v388, ptr %state, ptr %R8, i64 %v386, i64 %v387)
  store ptr %v389, ptr %MEMORY, align 8
  %v390 = load i64, ptr %NEXT_PC, align 8
  store i64 %v390, ptr %PC, align 8
  %v391 = add i64 %v390, 4
  store i64 %v391, ptr %NEXT_PC, align 8
  %v392 = load i64, ptr %R8, align 8
  %v393 = add i64 %v392, 32
  %v394 = load ptr, ptr %MEMORY, align 8
  %v395 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v394, ptr %state, ptr %R9, i64 %v393)
  store ptr %v395, ptr %MEMORY, align 8
  %v396 = load i64, ptr %NEXT_PC, align 8
  store i64 %v396, ptr %PC, align 8
  %v397 = add i64 %v396, 3
  store i64 %v397, ptr %NEXT_PC, align 8
  %v398 = load i64, ptr %R9, align 8
  %v399 = load i64, ptr %R9, align 8
  %v400 = load ptr, ptr %MEMORY, align 8
  %v401 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v400, ptr %state, i64 %v398, i64 %v399)
  store ptr %v401, ptr %MEMORY, align 8
  %v402 = load i64, ptr %NEXT_PC, align 8
  store i64 %v402, ptr %PC, align 8
  %v403 = add i64 %v402, 2
  store i64 %v403, ptr %NEXT_PC, align 8
  %v404 = load i64, ptr %NEXT_PC, align 8
  %v405 = add i64 %v404, 30
  %v406 = load i64, ptr %NEXT_PC, align 8
  %v407 = load ptr, ptr %MEMORY, align 8
  %v408 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v407, ptr %state, ptr %BRANCH_TAKEN, i64 %v405, i64 %v406, ptr %NEXT_PC)
  store ptr %v408, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877137, label %bb_5389877107

bb_5389877107:                                    ; preds = %bb_5389877076
  %v409 = load i64, ptr %NEXT_PC, align 8
  store i64 %v409, ptr %PC, align 8
  %v410 = add i64 %v409, 4
  store i64 %v410, ptr %NEXT_PC, align 8
  %v411 = load i64, ptr %RBP, align 8
  %v412 = sub i64 %v411, 8
  %v413 = load i64, ptr %R9, align 8
  %v414 = load ptr, ptr %MEMORY, align 8
  %v415 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v414, ptr %state, i64 %v412, i64 %v413)
  store ptr %v415, ptr %MEMORY, align 8
  %v416 = load i64, ptr %NEXT_PC, align 8
  store i64 %v416, ptr %PC, align 8
  %v417 = add i64 %v416, 4
  store i64 %v417, ptr %NEXT_PC, align 8
  %v418 = load i64, ptr %RBP, align 8
  %v419 = sub i64 %v418, 40
  %v420 = load ptr, ptr %MEMORY, align 8
  %v421 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v420, ptr %state, ptr %RDX, i64 %v419)
  store ptr %v421, ptr %MEMORY, align 8
  %v422 = load i64, ptr %NEXT_PC, align 8
  store i64 %v422, ptr %PC, align 8
  %v423 = add i64 %v422, 3
  store i64 %v423, ptr %NEXT_PC, align 8
  %v424 = load i64, ptr %R9, align 8
  %v425 = load ptr, ptr %MEMORY, align 8
  %v426 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v425, ptr %state, ptr %RAX, i64 %v424)
  store ptr %v426, ptr %MEMORY, align 8
  %v427 = load i64, ptr %NEXT_PC, align 8
  store i64 %v427, ptr %PC, align 8
  %v428 = add i64 %v427, 3
  store i64 %v428, ptr %NEXT_PC, align 8
  %v429 = load i64, ptr %R9, align 8
  %v430 = load ptr, ptr %MEMORY, align 8
  %v431 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v430, ptr %state, ptr %RCX, i64 %v429)
  store ptr %v431, ptr %MEMORY, align 8
  %v432 = load i64, ptr %NEXT_PC, align 8
  store i64 %v432, ptr %PC, align 8
  %v433 = add i64 %v432, 3
  store i64 %v433, ptr %NEXT_PC, align 8
  %v434 = load i64, ptr %RAX, align 8
  %v435 = add i64 %v434, 8
  %v436 = load i64, ptr %NEXT_PC, align 8
  %v437 = load ptr, ptr %MEMORY, align 8
  %v438 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v437, ptr %state, i64 %v435, ptr %NEXT_PC, i64 %v436, ptr %RETURN_PC)
  store ptr %v438, ptr %MEMORY, align 8
  %v439 = load i64, ptr %NEXT_PC, align 8
  store i64 %v439, ptr %PC, align 8
  %v440 = add i64 %v439, 4
  store i64 %v440, ptr %NEXT_PC, align 8
  %v441 = load i64, ptr %RBP, align 8
  %v442 = sub i64 %v441, 8
  %v443 = load ptr, ptr %MEMORY, align 8
  %v444 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v443, ptr %state, ptr %RCX, i64 %v442)
  store ptr %v444, ptr %MEMORY, align 8
  %v445 = load i64, ptr %NEXT_PC, align 8
  store i64 %v445, ptr %PC, align 8
  %v446 = add i64 %v445, 2
  store i64 %v446, ptr %NEXT_PC, align 8
  %v447 = load i64, ptr %NEXT_PC, align 8
  %v448 = add i64 %v447, 7
  %v449 = load ptr, ptr %MEMORY, align 8
  %v450 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v449, ptr %state, i64 %v448, ptr %NEXT_PC)
  store ptr %v450, ptr %MEMORY, align 8
  br label %bb_5389877137

bb_5389877130:                                    ; preds = %bb_5389877070, %bb_5389877066
  %v451 = load i64, ptr %NEXT_PC, align 8
  store i64 %v451, ptr %PC, align 8
  %v452 = add i64 %v451, 3
  store i64 %v452, ptr %NEXT_PC, align 8
  %v453 = load i64, ptr %RDI, align 8
  %v454 = load ptr, ptr %MEMORY, align 8
  %v455 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v454, ptr %state, ptr %RCX, i64 %v453)
  store ptr %v455, ptr %MEMORY, align 8
  %v456 = load i64, ptr %NEXT_PC, align 8
  store i64 %v456, ptr %PC, align 8
  %v457 = add i64 %v456, 4
  store i64 %v457, ptr %NEXT_PC, align 8
  %v458 = load i64, ptr %RBP, align 8
  %v459 = sub i64 %v458, 8
  %v460 = load i64, ptr %RCX, align 8
  %v461 = load ptr, ptr %MEMORY, align 8
  %v462 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v461, ptr %state, i64 %v459, i64 %v460)
  store ptr %v462, ptr %MEMORY, align 8
  br label %bb_5389877137

bb_5389877137:                                    ; preds = %bb_5389877130, %bb_5389877107, %bb_5389877076
  %v463 = load i64, ptr %NEXT_PC, align 8
  store i64 %v463, ptr %PC, align 8
  %v464 = add i64 %v463, 7
  store i64 %v464, ptr %NEXT_PC, align 8
  %v465 = load i64, ptr %RCX, align 8
  %v466 = load i64, ptr %NEXT_PC, align 8
  %v467 = add i64 %v466, 27074328
  %v468 = load ptr, ptr %MEMORY, align 8
  %v469 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v468, ptr %state, i64 %v465, i64 %v467)
  store ptr %v469, ptr %MEMORY, align 8
  %v470 = load i64, ptr %NEXT_PC, align 8
  store i64 %v470, ptr %PC, align 8
  %v471 = add i64 %v470, 4
  store i64 %v471, ptr %NEXT_PC, align 8
  %v472 = load ptr, ptr %MEMORY, align 8
  %v473 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v472, ptr %state, ptr %R12B)
  store ptr %v473, ptr %MEMORY, align 8
  %v474 = load i64, ptr %NEXT_PC, align 8
  store i64 %v474, ptr %PC, align 8
  %v475 = add i64 %v474, 3
  store i64 %v475, ptr %NEXT_PC, align 8
  %v476 = load i64, ptr %RCX, align 8
  %v477 = load i64, ptr %RCX, align 8
  %v478 = load ptr, ptr %MEMORY, align 8
  %v479 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v478, ptr %state, i64 %v476, i64 %v477)
  store ptr %v479, ptr %MEMORY, align 8
  %v480 = load i64, ptr %NEXT_PC, align 8
  store i64 %v480, ptr %PC, align 8
  %v481 = add i64 %v480, 2
  store i64 %v481, ptr %NEXT_PC, align 8
  %v482 = load i64, ptr %NEXT_PC, align 8
  %v483 = add i64 %v482, 10
  %v484 = load i64, ptr %NEXT_PC, align 8
  %v485 = load ptr, ptr %MEMORY, align 8
  %v486 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v485, ptr %state, ptr %BRANCH_TAKEN, i64 %v483, i64 %v484, ptr %NEXT_PC)
  store ptr %v486, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877163, label %bb_5389877153

bb_5389877153:                                    ; preds = %bb_5389877137
  %v487 = load i64, ptr %NEXT_PC, align 8
  store i64 %v487, ptr %PC, align 8
  %v488 = add i64 %v487, 3
  store i64 %v488, ptr %NEXT_PC, align 8
  %v489 = load i64, ptr %RCX, align 8
  %v490 = load ptr, ptr %MEMORY, align 8
  %v491 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v490, ptr %state, ptr %RAX, i64 %v489)
  store ptr %v491, ptr %MEMORY, align 8
  %v492 = load i64, ptr %NEXT_PC, align 8
  store i64 %v492, ptr %PC, align 8
  %v493 = add i64 %v492, 4
  store i64 %v493, ptr %NEXT_PC, align 8
  %v494 = load i64, ptr %RBP, align 8
  %v495 = sub i64 %v494, 40
  %v496 = load ptr, ptr %MEMORY, align 8
  %v497 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v496, ptr %state, ptr %RDX, i64 %v495)
  store ptr %v497, ptr %MEMORY, align 8
  %v498 = load i64, ptr %NEXT_PC, align 8
  store i64 %v498, ptr %PC, align 8
  %v499 = add i64 %v498, 3
  store i64 %v499, ptr %NEXT_PC, align 8
  %v500 = load i64, ptr %RAX, align 8
  %v501 = add i64 %v500, 24
  %v502 = load i64, ptr %NEXT_PC, align 8
  %v503 = load ptr, ptr %MEMORY, align 8
  %v504 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v503, ptr %state, i64 %v501, ptr %NEXT_PC, i64 %v502, ptr %RETURN_PC)
  store ptr %v504, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877163:                                    ; preds = %bb_5389877137
  %v505 = load i64, ptr %NEXT_PC, align 8
  store i64 %v505, ptr %PC, align 8
  %v506 = add i64 %v505, 3
  store i64 %v506, ptr %NEXT_PC, align 8
  %v507 = load i8, ptr %R12B, align 1
  %v508 = zext i8 %v507 to i64
  %v509 = load i8, ptr %R12B, align 1
  %v510 = zext i8 %v509 to i64
  %v511 = load ptr, ptr %MEMORY, align 8
  %v512 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v511, ptr %state, i64 %v508, i64 %v510)
  store ptr %v512, ptr %MEMORY, align 8
  %v513 = load i64, ptr %NEXT_PC, align 8
  store i64 %v513, ptr %PC, align 8
  %v514 = add i64 %v513, 2
  store i64 %v514, ptr %NEXT_PC, align 8
  %v515 = load i64, ptr %NEXT_PC, align 8
  %v516 = add i64 %v515, 15
  %v517 = load i64, ptr %NEXT_PC, align 8
  %v518 = load ptr, ptr %MEMORY, align 8
  %v519 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v518, ptr %state, ptr %BRANCH_TAKEN, i64 %v516, i64 %v517, ptr %NEXT_PC)
  store ptr %v519, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877183, label %bb_5389877168

bb_5389877168:                                    ; preds = %bb_5389877163
  %v520 = load i64, ptr %NEXT_PC, align 8
  store i64 %v520, ptr %PC, align 8
  %v521 = add i64 %v520, 2
  store i64 %v521, ptr %NEXT_PC, align 8
  %v522 = load i32, ptr %EBX, align 4
  %v523 = zext i32 %v522 to i64
  %v524 = load ptr, ptr %MEMORY, align 8
  %v525 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v524, ptr %state, ptr %RDX, i64 %v523)
  store ptr %v525, ptr %MEMORY, align 8
  %v526 = load i64, ptr %NEXT_PC, align 8
  store i64 %v526, ptr %PC, align 8
  %v527 = add i64 %v526, 3
  store i64 %v527, ptr %NEXT_PC, align 8
  %v528 = load i64, ptr %R14, align 8
  %v529 = load ptr, ptr %MEMORY, align 8
  %v530 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v529, ptr %state, ptr %RCX, i64 %v528)
  store ptr %v530, ptr %MEMORY, align 8
  %v531 = load i64, ptr %NEXT_PC, align 8
  store i64 %v531, ptr %PC, align 8
  %v532 = add i64 %v531, 5
  store i64 %v532, ptr %NEXT_PC, align 8
  %v533 = load i64, ptr %NEXT_PC, align 8
  %v534 = add i64 %v533, 5398
  %v535 = load i64, ptr %NEXT_PC, align 8
  %v536 = load ptr, ptr %MEMORY, align 8
  %v537 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v536, ptr %state, i64 %v534, ptr %NEXT_PC, i64 %v535, ptr %RETURN_PC)
  store ptr %v537, ptr %MEMORY, align 8
  %v538 = load i64, ptr %NEXT_PC, align 8
  store i64 %v538, ptr %PC, align 8
  %v539 = add i64 %v538, 5
  store i64 %v539, ptr %NEXT_PC, align 8
  %v540 = load ptr, ptr %MEMORY, align 8
  %v541 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v540, ptr %state, ptr %RBX, i64 4294967295)
  store ptr %v541, ptr %MEMORY, align 8
  br label %bb_5389877183

bb_5389877183:                                    ; preds = %bb_5389877168, %bb_5389877163
  %v542 = load i64, ptr %NEXT_PC, align 8
  store i64 %v542, ptr %PC, align 8
  %v543 = add i64 %v542, 4
  store i64 %v543, ptr %NEXT_PC, align 8
  %v544 = load i64, ptr %RBP, align 8
  %v545 = add i64 %v544, 64
  %v546 = load ptr, ptr %MEMORY, align 8
  %v547 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v546, ptr %state, ptr %R12, i64 %v545)
  store ptr %v547, ptr %MEMORY, align 8
  br label %bb_5389877187

bb_5389877187:                                    ; preds = %bb_5389877183, %bb_5389877034
  %v548 = load i64, ptr %NEXT_PC, align 8
  store i64 %v548, ptr %PC, align 8
  %v549 = add i64 %v548, 4
  store i64 %v549, ptr %NEXT_PC, align 8
  %v550 = load i64, ptr %RBP, align 8
  %v551 = add i64 %v550, 80
  %v552 = load i64, ptr %RDI, align 8
  %v553 = load ptr, ptr %MEMORY, align 8
  %v554 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v553, ptr %state, i64 %v551, i64 %v552)
  store ptr %v554, ptr %MEMORY, align 8
  %v555 = load i64, ptr %NEXT_PC, align 8
  store i64 %v555, ptr %PC, align 8
  %v556 = add i64 %v555, 3
  store i64 %v556, ptr %NEXT_PC, align 8
  %v557 = load i32, ptr %EBX, align 4
  %v558 = zext i32 %v557 to i64
  %v559 = load ptr, ptr %MEMORY, align 8
  %v560 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v559, ptr %state, i64 %v558, i64 -1)
  store ptr %v560, ptr %MEMORY, align 8
  %v561 = load i64, ptr %NEXT_PC, align 8
  store i64 %v561, ptr %PC, align 8
  %v562 = add i64 %v561, 2
  store i64 %v562, ptr %NEXT_PC, align 8
  %v563 = load i64, ptr %NEXT_PC, align 8
  %v564 = add i64 %v563, 96
  %v565 = load i64, ptr %NEXT_PC, align 8
  %v566 = load ptr, ptr %MEMORY, align 8
  %v567 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v566, ptr %state, ptr %BRANCH_TAKEN, i64 %v564, i64 %v565, ptr %NEXT_PC)
  store ptr %v567, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877292, label %bb_5389877196

bb_5389877196:                                    ; preds = %bb_5389877187
  %v568 = load i64, ptr %NEXT_PC, align 8
  store i64 %v568, ptr %PC, align 8
  %v569 = add i64 %v568, 4
  store i64 %v569, ptr %NEXT_PC, align 8
  %v570 = load i64, ptr %RBP, align 8
  %v571 = add i64 %v570, 80
  %v572 = load ptr, ptr %MEMORY, align 8
  %v573 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v572, ptr %state, ptr %RCX, i64 %v571)
  store ptr %v573, ptr %MEMORY, align 8
  %v574 = load i64, ptr %NEXT_PC, align 8
  store i64 %v574, ptr %PC, align 8
  %v575 = add i64 %v574, 5
  store i64 %v575, ptr %NEXT_PC, align 8
  %v576 = load i64, ptr %NEXT_PC, align 8
  %v577 = sub i64 %v576, 584725
  %v578 = load i64, ptr %NEXT_PC, align 8
  %v579 = load ptr, ptr %MEMORY, align 8
  %v580 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v579, ptr %state, i64 %v577, ptr %NEXT_PC, i64 %v578, ptr %RETURN_PC)
  store ptr %v580, ptr %MEMORY, align 8
  %v581 = load i64, ptr %NEXT_PC, align 8
  store i64 %v581, ptr %PC, align 8
  %v582 = add i64 %v581, 4
  store i64 %v582, ptr %NEXT_PC, align 8
  %v583 = load i64, ptr %RBP, align 8
  %v584 = sub i64 %v583, 8
  %v585 = load i64, ptr %RDI, align 8
  %v586 = load ptr, ptr %MEMORY, align 8
  %v587 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v586, ptr %state, i64 %v584, i64 %v585)
  store ptr %v587, ptr %MEMORY, align 8
  %v588 = load i64, ptr %NEXT_PC, align 8
  store i64 %v588, ptr %PC, align 8
  %v589 = add i64 %v588, 4
  store i64 %v589, ptr %NEXT_PC, align 8
  %v590 = load i64, ptr %RBP, align 8
  %v591 = add i64 %v590, 80
  %v592 = load i64, ptr %RDI, align 8
  %v593 = load ptr, ptr %MEMORY, align 8
  %v594 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v593, ptr %state, i64 %v591, i64 %v592)
  store ptr %v594, ptr %MEMORY, align 8
  %v595 = load i64, ptr %NEXT_PC, align 8
  store i64 %v595, ptr %PC, align 8
  %v596 = add i64 %v595, 2
  store i64 %v596, ptr %NEXT_PC, align 8
  %v597 = load i64, ptr %NEXT_PC, align 8
  %v598 = add i64 %v597, 30
  %v599 = load i64, ptr %NEXT_PC, align 8
  %v600 = load ptr, ptr %MEMORY, align 8
  %v601 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v600, ptr %state, ptr %BRANCH_TAKEN, i64 %v598, i64 %v599, ptr %NEXT_PC)
  store ptr %v601, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877245, label %bb_5389877215

bb_5389877215:                                    ; preds = %bb_5389877196
  %v602 = load i64, ptr %NEXT_PC, align 8
  store i64 %v602, ptr %PC, align 8
  %v603 = add i64 %v602, 7
  store i64 %v603, ptr %NEXT_PC, align 8
  %v604 = load i64, ptr %NEXT_PC, align 8
  %v605 = add i64 %v604, 27074250
  %v606 = load ptr, ptr %MEMORY, align 8
  %v607 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v606, ptr %state, ptr %RCX, i64 %v605)
  store ptr %v607, ptr %MEMORY, align 8
  %v608 = load i64, ptr %NEXT_PC, align 8
  store i64 %v608, ptr %PC, align 8
  %v609 = add i64 %v608, 4
  store i64 %v609, ptr %NEXT_PC, align 8
  %v610 = load i64, ptr %RBP, align 8
  %v611 = sub i64 %v610, 8
  %v612 = load i64, ptr %RCX, align 8
  %v613 = load ptr, ptr %MEMORY, align 8
  %v614 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v613, ptr %state, i64 %v611, i64 %v612)
  store ptr %v614, ptr %MEMORY, align 8
  %v615 = load i64, ptr %NEXT_PC, align 8
  store i64 %v615, ptr %PC, align 8
  %v616 = add i64 %v615, 3
  store i64 %v616, ptr %NEXT_PC, align 8
  %v617 = load i64, ptr %RCX, align 8
  %v618 = load i64, ptr %RCX, align 8
  %v619 = load ptr, ptr %MEMORY, align 8
  %v620 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v619, ptr %state, i64 %v617, i64 %v618)
  store ptr %v620, ptr %MEMORY, align 8
  %v621 = load i64, ptr %NEXT_PC, align 8
  store i64 %v621, ptr %PC, align 8
  %v622 = add i64 %v621, 2
  store i64 %v622, ptr %NEXT_PC, align 8
  %v623 = load i64, ptr %NEXT_PC, align 8
  %v624 = add i64 %v623, 14
  %v625 = load i64, ptr %NEXT_PC, align 8
  %v626 = load ptr, ptr %MEMORY, align 8
  %v627 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v626, ptr %state, ptr %BRANCH_TAKEN, i64 %v624, i64 %v625, ptr %NEXT_PC)
  store ptr %v627, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877245, label %bb_5389877231

bb_5389877231:                                    ; preds = %bb_5389877215
  %v628 = load i64, ptr %NEXT_PC, align 8
  store i64 %v628, ptr %PC, align 8
  %v629 = add i64 %v628, 3
  store i64 %v629, ptr %NEXT_PC, align 8
  %v630 = load i64, ptr %RCX, align 8
  %v631 = load ptr, ptr %MEMORY, align 8
  %v632 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v631, ptr %state, ptr %RAX, i64 %v630)
  store ptr %v632, ptr %MEMORY, align 8
  %v633 = load i64, ptr %NEXT_PC, align 8
  store i64 %v633, ptr %PC, align 8
  %v634 = add i64 %v633, 4
  store i64 %v634, ptr %NEXT_PC, align 8
  %v635 = load i64, ptr %RBP, align 8
  %v636 = add i64 %v635, 80
  %v637 = load ptr, ptr %MEMORY, align 8
  %v638 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v637, ptr %state, ptr %R8, i64 %v636)
  store ptr %v638, ptr %MEMORY, align 8
  %v639 = load i64, ptr %NEXT_PC, align 8
  store i64 %v639, ptr %PC, align 8
  %v640 = add i64 %v639, 4
  store i64 %v640, ptr %NEXT_PC, align 8
  %v641 = load i64, ptr %RBP, align 8
  %v642 = sub i64 %v641, 40
  %v643 = load ptr, ptr %MEMORY, align 8
  %v644 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v643, ptr %state, ptr %RDX, i64 %v642)
  store ptr %v644, ptr %MEMORY, align 8
  %v645 = load i64, ptr %NEXT_PC, align 8
  store i64 %v645, ptr %PC, align 8
  %v646 = add i64 %v645, 3
  store i64 %v646, ptr %NEXT_PC, align 8
  %v647 = load i64, ptr %RAX, align 8
  %v648 = add i64 %v647, 16
  %v649 = load i64, ptr %NEXT_PC, align 8
  %v650 = load ptr, ptr %MEMORY, align 8
  %v651 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v650, ptr %state, i64 %v648, ptr %NEXT_PC, i64 %v649, ptr %RETURN_PC)
  store ptr %v651, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877245:                                    ; preds = %bb_5389877215, %bb_5389877196
  %v652 = load i64, ptr %NEXT_PC, align 8
  store i64 %v652, ptr %PC, align 8
  %v653 = add i64 %v652, 6
  store i64 %v653, ptr %NEXT_PC, align 8
  %v654 = load i64, ptr %RSI, align 8
  %v655 = add i64 %v654, 256
  %v656 = load ptr, ptr %MEMORY, align 8
  %v657 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v656, ptr %state, ptr %RAX, i64 %v655)
  store ptr %v657, ptr %MEMORY, align 8
  %v658 = load i64, ptr %NEXT_PC, align 8
  store i64 %v658, ptr %PC, align 8
  %v659 = add i64 %v658, 4
  store i64 %v659, ptr %NEXT_PC, align 8
  %v660 = load i64, ptr %RBP, align 8
  %v661 = sub i64 %v660, 40
  %v662 = load ptr, ptr %MEMORY, align 8
  %v663 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v662, ptr %state, ptr %R8, i64 %v661)
  store ptr %v663, ptr %MEMORY, align 8
  %v664 = load i64, ptr %NEXT_PC, align 8
  store i64 %v664, ptr %PC, align 8
  %v665 = add i64 %v664, 2
  store i64 %v665, ptr %NEXT_PC, align 8
  %v666 = load i64, ptr %RAX, align 8
  %v667 = load ptr, ptr %MEMORY, align 8
  %v668 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v667, ptr %state, ptr %RAX, i64 %v666)
  store ptr %v668, ptr %MEMORY, align 8
  %v669 = load i64, ptr %NEXT_PC, align 8
  store i64 %v669, ptr %PC, align 8
  %v670 = add i64 %v669, 8
  store i64 %v670, ptr %NEXT_PC, align 8
  %v671 = load i64, ptr %RSP, align 8
  %v672 = add i64 %v671, 40
  %v673 = load ptr, ptr %MEMORY, align 8
  %v674 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v673, ptr %state, i64 %v672, i64 -1)
  store ptr %v674, ptr %MEMORY, align 8
  %v675 = load i64, ptr %NEXT_PC, align 8
  store i64 %v675, ptr %PC, align 8
  %v676 = add i64 %v675, 3
  store i64 %v676, ptr %NEXT_PC, align 8
  %v677 = load i32, ptr %EAX, align 4
  %v678 = zext i32 %v677 to i64
  %v679 = load ptr, ptr %MEMORY, align 8
  %v680 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v679, ptr %state, ptr %RCX, i64 %v678)
  store ptr %v680, ptr %MEMORY, align 8
  %v681 = load i64, ptr %NEXT_PC, align 8
  store i64 %v681, ptr %PC, align 8
  %v682 = add i64 %v681, 3
  store i64 %v682, ptr %NEXT_PC, align 8
  %v683 = load i32, ptr %R12D, align 4
  %v684 = zext i32 %v683 to i64
  %v685 = load ptr, ptr %MEMORY, align 8
  %v686 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v685, ptr %state, ptr %R9, i64 %v684)
  store ptr %v686, ptr %MEMORY, align 8
  %v687 = load i64, ptr %NEXT_PC, align 8
  store i64 %v687, ptr %PC, align 8
  %v688 = add i64 %v687, 5
  store i64 %v688, ptr %NEXT_PC, align 8
  %v689 = load i64, ptr %RSP, align 8
  %v690 = add i64 %v689, 32
  %v691 = load i32, ptr %R13D, align 4
  %v692 = zext i32 %v691 to i64
  %v693 = load ptr, ptr %MEMORY, align 8
  %v694 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v693, ptr %state, i64 %v690, i64 %v692)
  store ptr %v694, ptr %MEMORY, align 8
  %v695 = load i64, ptr %NEXT_PC, align 8
  store i64 %v695, ptr %PC, align 8
  %v696 = add i64 %v695, 3
  store i64 %v696, ptr %NEXT_PC, align 8
  %v697 = load i64, ptr %RSI, align 8
  %v698 = load i64, ptr %RCX, align 8
  %v699 = mul i64 %v698, 4
  %v700 = add i64 %v697, %v699
  %v701 = load ptr, ptr %MEMORY, align 8
  %v702 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v701, ptr %state, ptr %RDX, i64 %v700)
  store ptr %v702, ptr %MEMORY, align 8
  %v703 = load i64, ptr %NEXT_PC, align 8
  store i64 %v703, ptr %PC, align 8
  %v704 = add i64 %v703, 3
  store i64 %v704, ptr %NEXT_PC, align 8
  %v705 = load i64, ptr %R14, align 8
  %v706 = load ptr, ptr %MEMORY, align 8
  %v707 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v706, ptr %state, ptr %RCX, i64 %v705)
  store ptr %v707, ptr %MEMORY, align 8
  %v708 = load i64, ptr %NEXT_PC, align 8
  store i64 %v708, ptr %PC, align 8
  %v709 = add i64 %v708, 5
  store i64 %v709, ptr %NEXT_PC, align 8
  %v710 = load i64, ptr %NEXT_PC, align 8
  %v711 = add i64 %v710, 4649
  %v712 = load i64, ptr %NEXT_PC, align 8
  %v713 = load ptr, ptr %MEMORY, align 8
  %v714 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v713, ptr %state, i64 %v711, ptr %NEXT_PC, i64 %v712, ptr %RETURN_PC)
  store ptr %v714, ptr %MEMORY, align 8
  %v715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v715, ptr %PC, align 8
  %v716 = add i64 %v715, 5
  store i64 %v716, ptr %NEXT_PC, align 8
  %v717 = load i64, ptr %NEXT_PC, align 8
  %v718 = add i64 %v717, 227
  %v719 = load ptr, ptr %MEMORY, align 8
  %v720 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v719, ptr %state, i64 %v718, ptr %NEXT_PC)
  store ptr %v720, ptr %MEMORY, align 8
  br label %bb_5389877519

bb_5389877292:                                    ; preds = %bb_5389877187
  %v721 = load i64, ptr %NEXT_PC, align 8
  store i64 %v721, ptr %PC, align 8
  %v722 = add i64 %v721, 2
  store i64 %v722, ptr %NEXT_PC, align 8
  %v723 = load i32, ptr %EBX, align 4
  %v724 = zext i32 %v723 to i64
  %v725 = load i32, ptr %EBX, align 4
  %v726 = zext i32 %v725 to i64
  %v727 = load ptr, ptr %MEMORY, align 8
  %v728 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v727, ptr %state, i64 %v724, i64 %v726)
  store ptr %v728, ptr %MEMORY, align 8
  %v729 = load i64, ptr %NEXT_PC, align 8
  store i64 %v729, ptr %PC, align 8
  %v730 = add i64 %v729, 2
  store i64 %v730, ptr %NEXT_PC, align 8
  %v731 = load i64, ptr %NEXT_PC, align 8
  %v732 = add i64 %v731, 60
  %v733 = load i64, ptr %NEXT_PC, align 8
  %v734 = load ptr, ptr %MEMORY, align 8
  %v735 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v734, ptr %state, ptr %BRANCH_TAKEN, i64 %v732, i64 %v733, ptr %NEXT_PC)
  store ptr %v735, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877356, label %bb_5389877296

bb_5389877296:                                    ; preds = %bb_5389877292
  %v736 = load i64, ptr %NEXT_PC, align 8
  store i64 %v736, ptr %PC, align 8
  %v737 = add i64 %v736, 4
  store i64 %v737, ptr %NEXT_PC, align 8
  %v738 = load i32, ptr %EBX, align 4
  %v739 = zext i32 %v738 to i64
  %v740 = load i64, ptr %R14, align 8
  %v741 = add i64 %v740, 40
  %v742 = load ptr, ptr %MEMORY, align 8
  %v743 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v742, ptr %state, i64 %v739, i64 %v741)
  store ptr %v743, ptr %MEMORY, align 8
  %v744 = load i64, ptr %NEXT_PC, align 8
  store i64 %v744, ptr %PC, align 8
  %v745 = add i64 %v744, 2
  store i64 %v745, ptr %NEXT_PC, align 8
  %v746 = load i64, ptr %NEXT_PC, align 8
  %v747 = add i64 %v746, 54
  %v748 = load i64, ptr %NEXT_PC, align 8
  %v749 = load ptr, ptr %MEMORY, align 8
  %v750 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v749, ptr %state, ptr %BRANCH_TAKEN, i64 %v747, i64 %v748, ptr %NEXT_PC)
  store ptr %v750, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877356, label %bb_5389877302

bb_5389877302:                                    ; preds = %bb_5389877296
  %v751 = load i64, ptr %NEXT_PC, align 8
  store i64 %v751, ptr %PC, align 8
  %v752 = add i64 %v751, 4
  store i64 %v752, ptr %NEXT_PC, align 8
  %v753 = load i64, ptr %R14, align 8
  %v754 = add i64 %v753, 32
  %v755 = load ptr, ptr %MEMORY, align 8
  %v756 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v755, ptr %state, ptr %R8, i64 %v754)
  store ptr %v756, ptr %MEMORY, align 8
  %v757 = load i64, ptr %NEXT_PC, align 8
  store i64 %v757, ptr %PC, align 8
  %v758 = add i64 %v757, 3
  store i64 %v758, ptr %NEXT_PC, align 8
  %v759 = load i64, ptr %RDI, align 8
  %v760 = load ptr, ptr %MEMORY, align 8
  %v761 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v760, ptr %state, ptr %R9, i64 %v759)
  store ptr %v761, ptr %MEMORY, align 8
  %v762 = load i64, ptr %NEXT_PC, align 8
  store i64 %v762, ptr %PC, align 8
  %v763 = add i64 %v762, 4
  store i64 %v763, ptr %NEXT_PC, align 8
  %v764 = load i64, ptr %R8, align 8
  %v765 = load ptr, ptr %MEMORY, align 8
  %v766 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v765, ptr %state, ptr %R8, i64 %v764, i64 8)
  store ptr %v766, ptr %MEMORY, align 8
  %v767 = load i64, ptr %NEXT_PC, align 8
  store i64 %v767, ptr %PC, align 8
  %v768 = add i64 %v767, 3
  store i64 %v768, ptr %NEXT_PC, align 8
  %v769 = load i32, ptr %EBX, align 4
  %v770 = zext i32 %v769 to i64
  %v771 = load ptr, ptr %MEMORY, align 8
  %v772 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v771, ptr %state, ptr %RAX, i64 %v770)
  store ptr %v772, ptr %MEMORY, align 8
  %v773 = load i64, ptr %NEXT_PC, align 8
  store i64 %v773, ptr %PC, align 8
  %v774 = add i64 %v773, 4
  store i64 %v774, ptr %NEXT_PC, align 8
  %v775 = load i64, ptr %RAX, align 8
  %v776 = load ptr, ptr %MEMORY, align 8
  %v777 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v776, ptr %state, ptr %RCX, i64 %v775, i64 56)
  store ptr %v777, ptr %MEMORY, align 8
  %v778 = load i64, ptr %NEXT_PC, align 8
  store i64 %v778, ptr %PC, align 8
  %v779 = add i64 %v778, 4
  store i64 %v779, ptr %NEXT_PC, align 8
  %v780 = load i64, ptr %RBP, align 8
  %v781 = sub i64 %v780, 8
  %v782 = load i64, ptr %RDI, align 8
  %v783 = load ptr, ptr %MEMORY, align 8
  %v784 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v783, ptr %state, i64 %v781, i64 %v782)
  store ptr %v784, ptr %MEMORY, align 8
  %v785 = load i64, ptr %NEXT_PC, align 8
  store i64 %v785, ptr %PC, align 8
  %v786 = add i64 %v785, 3
  store i64 %v786, ptr %NEXT_PC, align 8
  %v787 = load i64, ptr %R8, align 8
  %v788 = load i64, ptr %RCX, align 8
  %v789 = load ptr, ptr %MEMORY, align 8
  %v790 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v789, ptr %state, ptr %R8, i64 %v787, i64 %v788)
  store ptr %v790, ptr %MEMORY, align 8
  %v791 = load i64, ptr %NEXT_PC, align 8
  store i64 %v791, ptr %PC, align 8
  %v792 = add i64 %v791, 4
  store i64 %v792, ptr %NEXT_PC, align 8
  %v793 = load i64, ptr %R8, align 8
  %v794 = add i64 %v793, 32
  %v795 = load ptr, ptr %MEMORY, align 8
  %v796 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v795, ptr %state, ptr %RCX, i64 %v794)
  store ptr %v796, ptr %MEMORY, align 8
  %v797 = load i64, ptr %NEXT_PC, align 8
  store i64 %v797, ptr %PC, align 8
  %v798 = add i64 %v797, 3
  store i64 %v798, ptr %NEXT_PC, align 8
  %v799 = load i64, ptr %RCX, align 8
  %v800 = load i64, ptr %RCX, align 8
  %v801 = load ptr, ptr %MEMORY, align 8
  %v802 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v801, ptr %state, i64 %v799, i64 %v800)
  store ptr %v802, ptr %MEMORY, align 8
  %v803 = load i64, ptr %NEXT_PC, align 8
  store i64 %v803, ptr %PC, align 8
  %v804 = add i64 %v803, 2
  store i64 %v804, ptr %NEXT_PC, align 8
  %v805 = load i64, ptr %NEXT_PC, align 8
  %v806 = add i64 %v805, 27
  %v807 = load i64, ptr %NEXT_PC, align 8
  %v808 = load ptr, ptr %MEMORY, align 8
  %v809 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v808, ptr %state, ptr %BRANCH_TAKEN, i64 %v806, i64 %v807, ptr %NEXT_PC)
  store ptr %v809, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877363, label %bb_5389877336

bb_5389877336:                                    ; preds = %bb_5389877302
  %v810 = load i64, ptr %NEXT_PC, align 8
  store i64 %v810, ptr %PC, align 8
  %v811 = add i64 %v810, 4
  store i64 %v811, ptr %NEXT_PC, align 8
  %v812 = load i64, ptr %RBP, align 8
  %v813 = sub i64 %v812, 8
  %v814 = load i64, ptr %RCX, align 8
  %v815 = load ptr, ptr %MEMORY, align 8
  %v816 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v815, ptr %state, i64 %v813, i64 %v814)
  store ptr %v816, ptr %MEMORY, align 8
  %v817 = load i64, ptr %NEXT_PC, align 8
  store i64 %v817, ptr %PC, align 8
  %v818 = add i64 %v817, 4
  store i64 %v818, ptr %NEXT_PC, align 8
  %v819 = load i64, ptr %RBP, align 8
  %v820 = sub i64 %v819, 40
  %v821 = load ptr, ptr %MEMORY, align 8
  %v822 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v821, ptr %state, ptr %RDX, i64 %v820)
  store ptr %v822, ptr %MEMORY, align 8
  %v823 = load i64, ptr %NEXT_PC, align 8
  store i64 %v823, ptr %PC, align 8
  %v824 = add i64 %v823, 3
  store i64 %v824, ptr %NEXT_PC, align 8
  %v825 = load i64, ptr %RCX, align 8
  %v826 = load ptr, ptr %MEMORY, align 8
  %v827 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v826, ptr %state, ptr %RAX, i64 %v825)
  store ptr %v827, ptr %MEMORY, align 8
  %v828 = load i64, ptr %NEXT_PC, align 8
  store i64 %v828, ptr %PC, align 8
  %v829 = add i64 %v828, 3
  store i64 %v829, ptr %NEXT_PC, align 8
  %v830 = load i64, ptr %RAX, align 8
  %v831 = add i64 %v830, 8
  %v832 = load i64, ptr %NEXT_PC, align 8
  %v833 = load ptr, ptr %MEMORY, align 8
  %v834 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v833, ptr %state, i64 %v831, ptr %NEXT_PC, i64 %v832, ptr %RETURN_PC)
  store ptr %v834, ptr %MEMORY, align 8
  %v835 = load i64, ptr %NEXT_PC, align 8
  store i64 %v835, ptr %PC, align 8
  %v836 = add i64 %v835, 4
  store i64 %v836, ptr %NEXT_PC, align 8
  %v837 = load i64, ptr %RBP, align 8
  %v838 = sub i64 %v837, 8
  %v839 = load ptr, ptr %MEMORY, align 8
  %v840 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v839, ptr %state, ptr %R9, i64 %v838)
  store ptr %v840, ptr %MEMORY, align 8
  %v841 = load i64, ptr %NEXT_PC, align 8
  store i64 %v841, ptr %PC, align 8
  %v842 = add i64 %v841, 2
  store i64 %v842, ptr %NEXT_PC, align 8
  %v843 = load i64, ptr %NEXT_PC, align 8
  %v844 = add i64 %v843, 7
  %v845 = load ptr, ptr %MEMORY, align 8
  %v846 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v845, ptr %state, i64 %v844, ptr %NEXT_PC)
  store ptr %v846, ptr %MEMORY, align 8
  br label %bb_5389877363

bb_5389877356:                                    ; preds = %bb_5389877296, %bb_5389877292
  %v847 = load i64, ptr %NEXT_PC, align 8
  store i64 %v847, ptr %PC, align 8
  %v848 = add i64 %v847, 3
  store i64 %v848, ptr %NEXT_PC, align 8
  %v849 = load i64, ptr %RDI, align 8
  %v850 = load ptr, ptr %MEMORY, align 8
  %v851 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v850, ptr %state, ptr %R9, i64 %v849)
  store ptr %v851, ptr %MEMORY, align 8
  %v852 = load i64, ptr %NEXT_PC, align 8
  store i64 %v852, ptr %PC, align 8
  %v853 = add i64 %v852, 4
  store i64 %v853, ptr %NEXT_PC, align 8
  %v854 = load i64, ptr %RBP, align 8
  %v855 = sub i64 %v854, 8
  %v856 = load i64, ptr %RDI, align 8
  %v857 = load ptr, ptr %MEMORY, align 8
  %v858 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v857, ptr %state, i64 %v855, i64 %v856)
  store ptr %v858, ptr %MEMORY, align 8
  br label %bb_5389877363

bb_5389877363:                                    ; preds = %bb_5389877356, %bb_5389877336, %bb_5389877302
  %v859 = load i64, ptr %NEXT_PC, align 8
  store i64 %v859, ptr %PC, align 8
  %v860 = add i64 %v859, 7
  store i64 %v860, ptr %NEXT_PC, align 8
  %v861 = load i64, ptr %R9, align 8
  %v862 = load i64, ptr %NEXT_PC, align 8
  %v863 = add i64 %v862, 27074102
  %v864 = load ptr, ptr %MEMORY, align 8
  %v865 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v864, ptr %state, i64 %v861, i64 %v863)
  store ptr %v865, ptr %MEMORY, align 8
  %v866 = load i64, ptr %NEXT_PC, align 8
  store i64 %v866, ptr %PC, align 8
  %v867 = add i64 %v866, 3
  store i64 %v867, ptr %NEXT_PC, align 8
  %v868 = load i64, ptr %RDI, align 8
  %v869 = load ptr, ptr %MEMORY, align 8
  %v870 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v869, ptr %state, ptr %RCX, i64 %v868)
  store ptr %v870, ptr %MEMORY, align 8
  %v871 = load i64, ptr %NEXT_PC, align 8
  store i64 %v871, ptr %PC, align 8
  %v872 = add i64 %v871, 4
  store i64 %v872, ptr %NEXT_PC, align 8
  %v873 = load i64, ptr %RBP, align 8
  %v874 = sub i64 %v873, 48
  %v875 = load i64, ptr %RCX, align 8
  %v876 = load ptr, ptr %MEMORY, align 8
  %v877 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v876, ptr %state, i64 %v874, i64 %v875)
  store ptr %v877, ptr %MEMORY, align 8
  %v878 = load i64, ptr %NEXT_PC, align 8
  store i64 %v878, ptr %PC, align 8
  %v879 = add i64 %v878, 2
  store i64 %v879, ptr %NEXT_PC, align 8
  %v880 = load i64, ptr %NEXT_PC, align 8
  %v881 = add i64 %v880, 79
  %v882 = load i64, ptr %NEXT_PC, align 8
  %v883 = load ptr, ptr %MEMORY, align 8
  %v884 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v883, ptr %state, ptr %BRANCH_TAKEN, i64 %v881, i64 %v882, ptr %NEXT_PC)
  store ptr %v884, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877458, label %bb_5389877379

bb_5389877379:                                    ; preds = %bb_5389877363
  %v885 = load i64, ptr %NEXT_PC, align 8
  store i64 %v885, ptr %PC, align 8
  %v886 = add i64 %v885, 3
  store i64 %v886, ptr %NEXT_PC, align 8
  %v887 = load i64, ptr %R9, align 8
  %v888 = load i64, ptr %R9, align 8
  %v889 = load ptr, ptr %MEMORY, align 8
  %v890 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v889, ptr %state, i64 %v887, i64 %v888)
  store ptr %v890, ptr %MEMORY, align 8
  %v891 = load i64, ptr %NEXT_PC, align 8
  store i64 %v891, ptr %PC, align 8
  %v892 = add i64 %v891, 2
  store i64 %v892, ptr %NEXT_PC, align 8
  %v893 = load i64, ptr %NEXT_PC, align 8
  %v894 = add i64 %v893, 74
  %v895 = load i64, ptr %NEXT_PC, align 8
  %v896 = load ptr, ptr %MEMORY, align 8
  %v897 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v896, ptr %state, ptr %BRANCH_TAKEN, i64 %v894, i64 %v895, ptr %NEXT_PC)
  store ptr %v897, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877458, label %bb_5389877384

bb_5389877384:                                    ; preds = %bb_5389877379
  %v898 = load i64, ptr %NEXT_PC, align 8
  store i64 %v898, ptr %PC, align 8
  %v899 = add i64 %v898, 3
  store i64 %v899, ptr %NEXT_PC, align 8
  %v900 = load i64, ptr %R9, align 8
  %v901 = load ptr, ptr %MEMORY, align 8
  %v902 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v901, ptr %state, ptr %RAX, i64 %v900)
  store ptr %v902, ptr %MEMORY, align 8
  %v903 = load i64, ptr %NEXT_PC, align 8
  store i64 %v903, ptr %PC, align 8
  %v904 = add i64 %v903, 4
  store i64 %v904, ptr %NEXT_PC, align 8
  %v905 = load i64, ptr %RBP, align 8
  %v906 = sub i64 %v905, 40
  %v907 = load ptr, ptr %MEMORY, align 8
  %v908 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v907, ptr %state, ptr %RDX, i64 %v906)
  store ptr %v908, ptr %MEMORY, align 8
  %v909 = load i64, ptr %NEXT_PC, align 8
  store i64 %v909, ptr %PC, align 8
  %v910 = add i64 %v909, 3
  store i64 %v910, ptr %NEXT_PC, align 8
  %v911 = load i64, ptr %R9, align 8
  %v912 = load ptr, ptr %MEMORY, align 8
  %v913 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v912, ptr %state, ptr %RCX, i64 %v911)
  store ptr %v913, ptr %MEMORY, align 8
  %v914 = load i64, ptr %NEXT_PC, align 8
  store i64 %v914, ptr %PC, align 8
  %v915 = add i64 %v914, 3
  store i64 %v915, ptr %NEXT_PC, align 8
  %v916 = load i64, ptr %RAX, align 8
  %v917 = add i64 %v916, 56
  %v918 = load i64, ptr %NEXT_PC, align 8
  %v919 = load ptr, ptr %MEMORY, align 8
  %v920 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v919, ptr %state, i64 %v917, ptr %NEXT_PC, i64 %v918, ptr %RETURN_PC)
  store ptr %v920, ptr %MEMORY, align 8
  %v921 = load i64, ptr %NEXT_PC, align 8
  store i64 %v921, ptr %PC, align 8
  %v922 = add i64 %v921, 3
  store i64 %v922, ptr %NEXT_PC, align 8
  %v923 = load i64, ptr %RAX, align 8
  %v924 = load ptr, ptr %MEMORY, align 8
  %v925 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v924, ptr %state, ptr %RBX, i64 %v923)
  store ptr %v925, ptr %MEMORY, align 8
  %v926 = load i64, ptr %NEXT_PC, align 8
  store i64 %v926, ptr %PC, align 8
  %v927 = add i64 %v926, 3
  store i64 %v927, ptr %NEXT_PC, align 8
  %v928 = load i64, ptr %RAX, align 8
  %v929 = load ptr, ptr %MEMORY, align 8
  %v930 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v929, ptr %state, ptr %RCX, i64 %v928)
  store ptr %v930, ptr %MEMORY, align 8
  %v931 = load i64, ptr %NEXT_PC, align 8
  store i64 %v931, ptr %PC, align 8
  %v932 = add i64 %v931, 3
  store i64 %v932, ptr %NEXT_PC, align 8
  %v933 = load i64, ptr %RCX, align 8
  %v934 = load i64, ptr %RCX, align 8
  %v935 = load ptr, ptr %MEMORY, align 8
  %v936 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v935, ptr %state, i64 %v933, i64 %v934)
  store ptr %v936, ptr %MEMORY, align 8
  %v937 = load i64, ptr %NEXT_PC, align 8
  store i64 %v937, ptr %PC, align 8
  %v938 = add i64 %v937, 2
  store i64 %v938, ptr %NEXT_PC, align 8
  %v939 = load i64, ptr %NEXT_PC, align 8
  %v940 = add i64 %v939, 8
  %v941 = load i64, ptr %NEXT_PC, align 8
  %v942 = load ptr, ptr %MEMORY, align 8
  %v943 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v942, ptr %state, ptr %BRANCH_TAKEN, i64 %v940, i64 %v941, ptr %NEXT_PC)
  store ptr %v943, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877416, label %bb_5389877408

bb_5389877408:                                    ; preds = %bb_5389877384
  %v944 = load i64, ptr %NEXT_PC, align 8
  store i64 %v944, ptr %PC, align 8
  %v945 = add i64 %v944, 2
  store i64 %v945, ptr %NEXT_PC, align 8
  %v946 = load i64, ptr %RCX, align 8
  %v947 = load i64, ptr %RCX, align 8
  %v948 = load ptr, ptr %MEMORY, align 8
  %v949 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v948, ptr %state, i64 %v946, i64 %v947)
  store ptr %v949, ptr %MEMORY, align 8
  %v950 = load i64, ptr %NEXT_PC, align 8
  store i64 %v950, ptr %PC, align 8
  %v951 = add i64 %v950, 4
  store i64 %v951, ptr %NEXT_PC, align 8
  %v952 = load i64, ptr %RCX, align 8
  %v953 = add i64 %v952, 48
  %v954 = load ptr, ptr %MEMORY, align 8
  %v955 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v954, ptr %state, ptr %RCX, i64 %v953)
  store ptr %v955, ptr %MEMORY, align 8
  %v956 = load i64, ptr %NEXT_PC, align 8
  store i64 %v956, ptr %PC, align 8
  %v957 = add i64 %v956, 2
  store i64 %v957, ptr %NEXT_PC, align 8
  %v958 = load i64, ptr %RCX, align 8
  %v959 = load i64, ptr %RCX, align 8
  %v960 = load ptr, ptr %MEMORY, align 8
  %v961 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v960, ptr %state, i64 %v958, i64 %v959)
  store ptr %v961, ptr %MEMORY, align 8
  br label %bb_5389877416

bb_5389877416:                                    ; preds = %bb_5389877408, %bb_5389877384
  %v962 = load i64, ptr %NEXT_PC, align 8
  store i64 %v962, ptr %PC, align 8
  %v963 = add i64 %v962, 4
  store i64 %v963, ptr %NEXT_PC, align 8
  %v964 = load i64, ptr %RBP, align 8
  %v965 = sub i64 %v964, 48
  %v966 = load ptr, ptr %MEMORY, align 8
  %v967 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v966, ptr %state, ptr %RCX, i64 %v965)
  store ptr %v967, ptr %MEMORY, align 8
  %v968 = load i64, ptr %NEXT_PC, align 8
  store i64 %v968, ptr %PC, align 8
  %v969 = add i64 %v968, 3
  store i64 %v969, ptr %NEXT_PC, align 8
  %v970 = load i64, ptr %RCX, align 8
  %v971 = load i64, ptr %RCX, align 8
  %v972 = load ptr, ptr %MEMORY, align 8
  %v973 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v972, ptr %state, i64 %v970, i64 %v971)
  store ptr %v973, ptr %MEMORY, align 8
  %v974 = load i64, ptr %NEXT_PC, align 8
  store i64 %v974, ptr %PC, align 8
  %v975 = add i64 %v974, 2
  store i64 %v975, ptr %NEXT_PC, align 8
  %v976 = load i64, ptr %NEXT_PC, align 8
  %v977 = add i64 %v976, 5
  %v978 = load i64, ptr %NEXT_PC, align 8
  %v979 = load ptr, ptr %MEMORY, align 8
  %v980 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v979, ptr %state, ptr %BRANCH_TAKEN, i64 %v977, i64 %v978, ptr %NEXT_PC)
  store ptr %v980, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877430, label %bb_5389877425

bb_5389877425:                                    ; preds = %bb_5389877416
  %v981 = load i64, ptr %NEXT_PC, align 8
  store i64 %v981, ptr %PC, align 8
  %v982 = add i64 %v981, 5
  store i64 %v982, ptr %NEXT_PC, align 8
  %v983 = load i64, ptr %NEXT_PC, align 8
  %v984 = sub i64 %v983, 726
  %v985 = load i64, ptr %NEXT_PC, align 8
  %v986 = load ptr, ptr %MEMORY, align 8
  %v987 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v986, ptr %state, i64 %v984, ptr %NEXT_PC, i64 %v985, ptr %RETURN_PC)
  store ptr %v987, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877430:                                    ; preds = %bb_5389877416
  %v988 = load i64, ptr %NEXT_PC, align 8
  store i64 %v988, ptr %PC, align 8
  %v989 = add i64 %v988, 3
  store i64 %v989, ptr %NEXT_PC, align 8
  %v990 = load i64, ptr %RBX, align 8
  %v991 = load ptr, ptr %MEMORY, align 8
  %v992 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v991, ptr %state, ptr %RCX, i64 %v990)
  store ptr %v992, ptr %MEMORY, align 8
  %v993 = load i64, ptr %NEXT_PC, align 8
  store i64 %v993, ptr %PC, align 8
  %v994 = add i64 %v993, 4
  store i64 %v994, ptr %NEXT_PC, align 8
  %v995 = load i64, ptr %RBP, align 8
  %v996 = sub i64 %v995, 48
  %v997 = load i64, ptr %RCX, align 8
  %v998 = load ptr, ptr %MEMORY, align 8
  %v999 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v998, ptr %state, i64 %v996, i64 %v997)
  store ptr %v999, ptr %MEMORY, align 8
  %v1000 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1000, ptr %PC, align 8
  %v1001 = add i64 %v1000, 3
  store i64 %v1001, ptr %NEXT_PC, align 8
  %v1002 = load i64, ptr %RCX, align 8
  %v1003 = load i64, ptr %RCX, align 8
  %v1004 = load ptr, ptr %MEMORY, align 8
  %v1005 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1004, ptr %state, i64 %v1002, i64 %v1003)
  store ptr %v1005, ptr %MEMORY, align 8
  %v1006 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1006, ptr %PC, align 8
  %v1007 = add i64 %v1006, 2
  store i64 %v1007, ptr %NEXT_PC, align 8
  %v1008 = load i64, ptr %NEXT_PC, align 8
  %v1009 = add i64 %v1008, 12
  %v1010 = load i64, ptr %NEXT_PC, align 8
  %v1011 = load ptr, ptr %MEMORY, align 8
  %v1012 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1011, ptr %state, ptr %BRANCH_TAKEN, i64 %v1009, i64 %v1010, ptr %NEXT_PC)
  store ptr %v1012, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877454, label %bb_5389877442

bb_5389877442:                                    ; preds = %bb_5389877430
  %v1013 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1013, ptr %PC, align 8
  %v1014 = add i64 %v1013, 4
  store i64 %v1014, ptr %NEXT_PC, align 8
  %v1015 = load i64, ptr %RCX, align 8
  %v1016 = add i64 %v1015, 48
  %v1017 = load ptr, ptr %MEMORY, align 8
  %v1018 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1017, ptr %state, ptr %RAX, i64 %v1016)
  store ptr %v1018, ptr %MEMORY, align 8
  %v1019 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1019, ptr %PC, align 8
  %v1020 = add i64 %v1019, 2
  store i64 %v1020, ptr %NEXT_PC, align 8
  %v1021 = load i64, ptr %RCX, align 8
  %v1022 = load i64, ptr %RCX, align 8
  %v1023 = load ptr, ptr %MEMORY, align 8
  %v1024 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1023, ptr %state, i64 %v1021, i64 %v1022)
  store ptr %v1024, ptr %MEMORY, align 8
  %v1025 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1025, ptr %PC, align 8
  %v1026 = add i64 %v1025, 2
  store i64 %v1026, ptr %NEXT_PC, align 8
  %v1027 = load i64, ptr %RAX, align 8
  %v1028 = load i64, ptr %RAX, align 8
  %v1029 = load ptr, ptr %MEMORY, align 8
  %v1030 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1029, ptr %state, i64 %v1027, i64 %v1028)
  store ptr %v1030, ptr %MEMORY, align 8
  %v1031 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1031, ptr %PC, align 8
  %v1032 = add i64 %v1031, 4
  store i64 %v1032, ptr %NEXT_PC, align 8
  %v1033 = load i64, ptr %RBP, align 8
  %v1034 = sub i64 %v1033, 48
  %v1035 = load ptr, ptr %MEMORY, align 8
  %v1036 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1035, ptr %state, ptr %RCX, i64 %v1034)
  store ptr %v1036, ptr %MEMORY, align 8
  br label %bb_5389877454

bb_5389877454:                                    ; preds = %bb_5389877442, %bb_5389877430
  %v1037 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1037, ptr %PC, align 8
  %v1038 = add i64 %v1037, 4
  store i64 %v1038, ptr %NEXT_PC, align 8
  %v1039 = load i64, ptr %RBP, align 8
  %v1040 = sub i64 %v1039, 8
  %v1041 = load ptr, ptr %MEMORY, align 8
  %v1042 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1041, ptr %state, ptr %R9, i64 %v1040)
  store ptr %v1042, ptr %MEMORY, align 8
  br label %bb_5389877458

bb_5389877458:                                    ; preds = %bb_5389877454, %bb_5389877379, %bb_5389877363
  %v1043 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1043, ptr %PC, align 8
  %v1044 = add i64 %v1043, 4
  store i64 %v1044, ptr %NEXT_PC, align 8
  %v1045 = load i64, ptr %RBP, align 8
  %v1046 = add i64 %v1045, 80
  %v1047 = load ptr, ptr %MEMORY, align 8
  %v1048 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1047, ptr %state, ptr %RAX, i64 %v1046)
  store ptr %v1048, ptr %MEMORY, align 8
  %v1049 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1049, ptr %PC, align 8
  %v1050 = add i64 %v1049, 3
  store i64 %v1050, ptr %NEXT_PC, align 8
  %v1051 = load i64, ptr %RAX, align 8
  %v1052 = load i64, ptr %RAX, align 8
  %v1053 = load ptr, ptr %MEMORY, align 8
  %v1054 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1053, ptr %state, i64 %v1051, i64 %v1052)
  store ptr %v1054, ptr %MEMORY, align 8
  %v1055 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1055, ptr %PC, align 8
  %v1056 = add i64 %v1055, 2
  store i64 %v1056, ptr %NEXT_PC, align 8
  %v1057 = load i64, ptr %NEXT_PC, align 8
  %v1058 = add i64 %v1057, 16
  %v1059 = load i64, ptr %NEXT_PC, align 8
  %v1060 = load ptr, ptr %MEMORY, align 8
  %v1061 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1060, ptr %state, ptr %BRANCH_TAKEN, i64 %v1058, i64 %v1059, ptr %NEXT_PC)
  store ptr %v1061, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877483, label %bb_5389877467

bb_5389877467:                                    ; preds = %bb_5389877458
  %v1062 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1062, ptr %PC, align 8
  %v1063 = add i64 %v1062, 3
  store i64 %v1063, ptr %NEXT_PC, align 8
  %v1064 = load i64, ptr %RAX, align 8
  %v1065 = load ptr, ptr %MEMORY, align 8
  %v1066 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1065, ptr %state, ptr %RCX, i64 %v1064)
  store ptr %v1066, ptr %MEMORY, align 8
  %v1067 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1067, ptr %PC, align 8
  %v1068 = add i64 %v1067, 5
  store i64 %v1068, ptr %NEXT_PC, align 8
  %v1069 = load i64, ptr %NEXT_PC, align 8
  %v1070 = sub i64 %v1069, 771
  %v1071 = load i64, ptr %NEXT_PC, align 8
  %v1072 = load ptr, ptr %MEMORY, align 8
  %v1073 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1072, ptr %state, i64 %v1070, ptr %NEXT_PC, i64 %v1071, ptr %RETURN_PC)
  store ptr %v1073, ptr %MEMORY, align 8
  %v1074 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1074, ptr %PC, align 8
  %v1075 = add i64 %v1074, 4
  store i64 %v1075, ptr %NEXT_PC, align 8
  %v1076 = load i64, ptr %RBP, align 8
  %v1077 = sub i64 %v1076, 48
  %v1078 = load ptr, ptr %MEMORY, align 8
  %v1079 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1078, ptr %state, ptr %RCX, i64 %v1077)
  store ptr %v1079, ptr %MEMORY, align 8
  %v1080 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1080, ptr %PC, align 8
  %v1081 = add i64 %v1080, 4
  store i64 %v1081, ptr %NEXT_PC, align 8
  %v1082 = load i64, ptr %RBP, align 8
  %v1083 = sub i64 %v1082, 8
  %v1084 = load ptr, ptr %MEMORY, align 8
  %v1085 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1084, ptr %state, ptr %R9, i64 %v1083)
  store ptr %v1085, ptr %MEMORY, align 8
  br label %bb_5389877483

bb_5389877483:                                    ; preds = %bb_5389877467, %bb_5389877458
  %v1086 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1086, ptr %PC, align 8
  %v1087 = add i64 %v1086, 4
  store i64 %v1087, ptr %NEXT_PC, align 8
  %v1088 = load i64, ptr %RBP, align 8
  %v1089 = add i64 %v1088, 80
  %v1090 = load i64, ptr %RCX, align 8
  %v1091 = load ptr, ptr %MEMORY, align 8
  %v1092 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1091, ptr %state, i64 %v1089, i64 %v1090)
  store ptr %v1092, ptr %MEMORY, align 8
  %v1093 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1093, ptr %PC, align 8
  %v1094 = add i64 %v1093, 3
  store i64 %v1094, ptr %NEXT_PC, align 8
  %v1095 = load i64, ptr %RCX, align 8
  %v1096 = load i64, ptr %RCX, align 8
  %v1097 = load ptr, ptr %MEMORY, align 8
  %v1098 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1097, ptr %state, i64 %v1095, i64 %v1096)
  store ptr %v1098, ptr %MEMORY, align 8
  %v1099 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1099, ptr %PC, align 8
  %v1100 = add i64 %v1099, 2
  store i64 %v1100, ptr %NEXT_PC, align 8
  %v1101 = load i64, ptr %NEXT_PC, align 8
  %v1102 = add i64 %v1101, 9
  %v1103 = load i64, ptr %NEXT_PC, align 8
  %v1104 = load ptr, ptr %MEMORY, align 8
  %v1105 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1104, ptr %state, ptr %BRANCH_TAKEN, i64 %v1102, i64 %v1103, ptr %NEXT_PC)
  store ptr %v1105, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877501, label %bb_5389877492

bb_5389877492:                                    ; preds = %bb_5389877483
  %v1106 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1106, ptr %PC, align 8
  %v1107 = add i64 %v1106, 5
  store i64 %v1107, ptr %NEXT_PC, align 8
  %v1108 = load i64, ptr %NEXT_PC, align 8
  %v1109 = sub i64 %v1108, 793
  %v1110 = load i64, ptr %NEXT_PC, align 8
  %v1111 = load ptr, ptr %MEMORY, align 8
  %v1112 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1111, ptr %state, i64 %v1109, ptr %NEXT_PC, i64 %v1110, ptr %RETURN_PC)
  store ptr %v1112, ptr %MEMORY, align 8
  %v1113 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1113, ptr %PC, align 8
  %v1114 = add i64 %v1113, 4
  store i64 %v1114, ptr %NEXT_PC, align 8
  %v1115 = load i64, ptr %RBP, align 8
  %v1116 = sub i64 %v1115, 8
  %v1117 = load ptr, ptr %MEMORY, align 8
  %v1118 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1117, ptr %state, ptr %R9, i64 %v1116)
  store ptr %v1118, ptr %MEMORY, align 8
  br label %bb_5389877501

bb_5389877501:                                    ; preds = %bb_5389877492, %bb_5389877483
  %v1119 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1119, ptr %PC, align 8
  %v1120 = add i64 %v1119, 3
  store i64 %v1120, ptr %NEXT_PC, align 8
  %v1121 = load i64, ptr %R9, align 8
  %v1122 = load i64, ptr %R9, align 8
  %v1123 = load ptr, ptr %MEMORY, align 8
  %v1124 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1123, ptr %state, i64 %v1121, i64 %v1122)
  store ptr %v1124, ptr %MEMORY, align 8
  %v1125 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1125, ptr %PC, align 8
  %v1126 = add i64 %v1125, 2
  store i64 %v1126, ptr %NEXT_PC, align 8
  %v1127 = load i64, ptr %NEXT_PC, align 8
  %v1128 = add i64 %v1127, 13
  %v1129 = load i64, ptr %NEXT_PC, align 8
  %v1130 = load ptr, ptr %MEMORY, align 8
  %v1131 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1130, ptr %state, ptr %BRANCH_TAKEN, i64 %v1128, i64 %v1129, ptr %NEXT_PC)
  store ptr %v1131, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877519, label %bb_5389877506

bb_5389877506:                                    ; preds = %bb_5389877501
  %v1132 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1132, ptr %PC, align 8
  %v1133 = add i64 %v1132, 3
  store i64 %v1133, ptr %NEXT_PC, align 8
  %v1134 = load i64, ptr %R9, align 8
  %v1135 = load ptr, ptr %MEMORY, align 8
  %v1136 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1135, ptr %state, ptr %RAX, i64 %v1134)
  store ptr %v1136, ptr %MEMORY, align 8
  %v1137 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1137, ptr %PC, align 8
  %v1138 = add i64 %v1137, 4
  store i64 %v1138, ptr %NEXT_PC, align 8
  %v1139 = load i64, ptr %RBP, align 8
  %v1140 = sub i64 %v1139, 40
  %v1141 = load ptr, ptr %MEMORY, align 8
  %v1142 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1141, ptr %state, ptr %RDX, i64 %v1140)
  store ptr %v1142, ptr %MEMORY, align 8
  %v1143 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1143, ptr %PC, align 8
  %v1144 = add i64 %v1143, 3
  store i64 %v1144, ptr %NEXT_PC, align 8
  %v1145 = load i64, ptr %R9, align 8
  %v1146 = load ptr, ptr %MEMORY, align 8
  %v1147 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1146, ptr %state, ptr %RCX, i64 %v1145)
  store ptr %v1147, ptr %MEMORY, align 8
  %v1148 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1148, ptr %PC, align 8
  %v1149 = add i64 %v1148, 3
  store i64 %v1149, ptr %NEXT_PC, align 8
  %v1150 = load i64, ptr %RAX, align 8
  %v1151 = add i64 %v1150, 24
  %v1152 = load i64, ptr %NEXT_PC, align 8
  %v1153 = load ptr, ptr %MEMORY, align 8
  %v1154 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1153, ptr %state, i64 %v1151, ptr %NEXT_PC, i64 %v1152, ptr %RETURN_PC)
  store ptr %v1154, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877519:                                    ; preds = %bb_5389877501, %bb_5389877245
  %v1155 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1155, ptr %PC, align 8
  %v1156 = add i64 %v1155, 6
  store i64 %v1156, ptr %NEXT_PC, align 8
  %v1157 = load i64, ptr %RSI, align 8
  %v1158 = add i64 %v1157, 256
  %v1159 = load i64, ptr %RSI, align 8
  %v1160 = add i64 %v1159, 256
  %v1161 = load ptr, ptr %MEMORY, align 8
  %v1162 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1161, ptr %state, i64 %v1158, i64 %v1160)
  store ptr %v1162, ptr %MEMORY, align 8
  %v1163 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1163, ptr %PC, align 8
  %v1164 = add i64 %v1163, 4
  store i64 %v1164, ptr %NEXT_PC, align 8
  %v1165 = load i64, ptr %RBP, align 8
  %v1166 = sub i64 %v1165, 40
  %v1167 = load ptr, ptr %MEMORY, align 8
  %v1168 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1167, ptr %state, ptr %RCX, i64 %v1166)
  store ptr %v1168, ptr %MEMORY, align 8
  %v1169 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1169, ptr %PC, align 8
  %v1170 = add i64 %v1169, 3
  store i64 %v1170, ptr %NEXT_PC, align 8
  %v1171 = load i64, ptr %R15, align 8
  %v1172 = load ptr, ptr %MEMORY, align 8
  %v1173 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1172, ptr %state, ptr %RDX, i64 %v1171)
  store ptr %v1173, ptr %MEMORY, align 8
  %v1174 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1174, ptr %PC, align 8
  %v1175 = add i64 %v1174, 4
  store i64 %v1175, ptr %NEXT_PC, align 8
  %v1176 = load i64, ptr %RBP, align 8
  %v1177 = sub i64 %v1176, 8
  %v1178 = load i64, ptr %RDI, align 8
  %v1179 = load ptr, ptr %MEMORY, align 8
  %v1180 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1179, ptr %state, i64 %v1177, i64 %v1178)
  store ptr %v1180, ptr %MEMORY, align 8
  %v1181 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1181, ptr %PC, align 8
  %v1182 = add i64 %v1181, 5
  store i64 %v1182, ptr %NEXT_PC, align 8
  %v1183 = load i64, ptr %NEXT_PC, align 8
  %v1184 = sub i64 %v1183, 18801845
  %v1185 = load i64, ptr %NEXT_PC, align 8
  %v1186 = load ptr, ptr %MEMORY, align 8
  %v1187 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1186, ptr %state, i64 %v1184, ptr %NEXT_PC, i64 %v1185, ptr %RETURN_PC)
  store ptr %v1187, ptr %MEMORY, align 8
  %v1188 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1188, ptr %PC, align 8
  %v1189 = add i64 %v1188, 4
  store i64 %v1189, ptr %NEXT_PC, align 8
  %v1190 = load i64, ptr %RBP, align 8
  %v1191 = add i64 %v1190, 80
  %v1192 = load ptr, ptr %MEMORY, align 8
  %v1193 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1192, ptr %state, ptr %RCX, i64 %v1191)
  store ptr %v1193, ptr %MEMORY, align 8
  %v1194 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1194, ptr %PC, align 8
  %v1195 = add i64 %v1194, 4
  store i64 %v1195, ptr %NEXT_PC, align 8
  %v1196 = load i64, ptr %RBP, align 8
  %v1197 = sub i64 %v1196, 40
  %v1198 = load ptr, ptr %MEMORY, align 8
  %v1199 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1198, ptr %state, ptr %RDX, i64 %v1197)
  store ptr %v1199, ptr %MEMORY, align 8
  %v1200 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1200, ptr %PC, align 8
  %v1201 = add i64 %v1200, 3
  store i64 %v1201, ptr %NEXT_PC, align 8
  %v1202 = load i32, ptr %R13D, align 4
  %v1203 = zext i32 %v1202 to i64
  %v1204 = load ptr, ptr %MEMORY, align 8
  %v1205 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1204, ptr %state, ptr %R9, i64 %v1203)
  store ptr %v1205, ptr %MEMORY, align 8
  %v1206 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1206, ptr %PC, align 8
  %v1207 = add i64 %v1206, 5
  store i64 %v1207, ptr %NEXT_PC, align 8
  %v1208 = load i64, ptr %RSP, align 8
  %v1209 = add i64 %v1208, 32
  %v1210 = load i64, ptr %RSI, align 8
  %v1211 = load ptr, ptr %MEMORY, align 8
  %v1212 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1211, ptr %state, i64 %v1209, i64 %v1210)
  store ptr %v1212, ptr %MEMORY, align 8
  %v1213 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1213, ptr %PC, align 8
  %v1214 = add i64 %v1213, 3
  store i64 %v1214, ptr %NEXT_PC, align 8
  %v1215 = load i32, ptr %R12D, align 4
  %v1216 = zext i32 %v1215 to i64
  %v1217 = load ptr, ptr %MEMORY, align 8
  %v1218 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1217, ptr %state, ptr %R8, i64 %v1216)
  store ptr %v1218, ptr %MEMORY, align 8
  %v1219 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1219, ptr %PC, align 8
  %v1220 = add i64 %v1219, 5
  store i64 %v1220, ptr %NEXT_PC, align 8
  %v1221 = load i64, ptr %NEXT_PC, align 8
  %v1222 = sub i64 %v1221, 685
  %v1223 = load i64, ptr %NEXT_PC, align 8
  %v1224 = load ptr, ptr %MEMORY, align 8
  %v1225 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1224, ptr %state, i64 %v1222, ptr %NEXT_PC, i64 %v1223, ptr %RETURN_PC)
  store ptr %v1225, ptr %MEMORY, align 8
  %v1226 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1226, ptr %PC, align 8
  %v1227 = add i64 %v1226, 4
  store i64 %v1227, ptr %NEXT_PC, align 8
  %v1228 = load i64, ptr %RBP, align 8
  %v1229 = add i64 %v1228, 80
  %v1230 = load ptr, ptr %MEMORY, align 8
  %v1231 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1230, ptr %state, ptr %RCX, i64 %v1229)
  store ptr %v1231, ptr %MEMORY, align 8
  %v1232 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1232, ptr %PC, align 8
  %v1233 = add i64 %v1232, 2
  store i64 %v1233, ptr %NEXT_PC, align 8
  %v1234 = load i32, ptr %EAX, align 4
  %v1235 = zext i32 %v1234 to i64
  %v1236 = load ptr, ptr %MEMORY, align 8
  %v1237 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1236, ptr %state, ptr %RBX, i64 %v1235)
  store ptr %v1237, ptr %MEMORY, align 8
  %v1238 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1238, ptr %PC, align 8
  %v1239 = add i64 %v1238, 3
  store i64 %v1239, ptr %NEXT_PC, align 8
  %v1240 = load i64, ptr %RCX, align 8
  %v1241 = load i64, ptr %RCX, align 8
  %v1242 = load ptr, ptr %MEMORY, align 8
  %v1243 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1242, ptr %state, i64 %v1240, i64 %v1241)
  store ptr %v1243, ptr %MEMORY, align 8
  %v1244 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1244, ptr %PC, align 8
  %v1245 = add i64 %v1244, 2
  store i64 %v1245, ptr %NEXT_PC, align 8
  %v1246 = load i64, ptr %NEXT_PC, align 8
  %v1247 = add i64 %v1246, 5
  %v1248 = load i64, ptr %NEXT_PC, align 8
  %v1249 = load ptr, ptr %MEMORY, align 8
  %v1250 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1249, ptr %state, ptr %BRANCH_TAKEN, i64 %v1247, i64 %v1248, ptr %NEXT_PC)
  store ptr %v1250, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877581, label %bb_5389877576

bb_5389877576:                                    ; preds = %bb_5389877519
  %v1251 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1251, ptr %PC, align 8
  %v1252 = add i64 %v1251, 5
  store i64 %v1252, ptr %NEXT_PC, align 8
  %v1253 = load i64, ptr %NEXT_PC, align 8
  %v1254 = sub i64 %v1253, 877
  %v1255 = load i64, ptr %NEXT_PC, align 8
  %v1256 = load ptr, ptr %MEMORY, align 8
  %v1257 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1256, ptr %state, i64 %v1254, ptr %NEXT_PC, i64 %v1255, ptr %RETURN_PC)
  store ptr %v1257, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877581:                                    ; preds = %bb_5389877519
  %v1258 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1258, ptr %PC, align 8
  %v1259 = add i64 %v1258, 4
  store i64 %v1259, ptr %NEXT_PC, align 8
  %v1260 = load i64, ptr %R15, align 8
  %v1261 = add i64 %v1260, 32
  %v1262 = load ptr, ptr %MEMORY, align 8
  %v1263 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1262, ptr %state, ptr %RCX, i64 %v1261)
  store ptr %v1263, ptr %MEMORY, align 8
  %v1264 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1264, ptr %PC, align 8
  %v1265 = add i64 %v1264, 3
  store i64 %v1265, ptr %NEXT_PC, align 8
  %v1266 = load i64, ptr %RCX, align 8
  %v1267 = load i64, ptr %RCX, align 8
  %v1268 = load ptr, ptr %MEMORY, align 8
  %v1269 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1268, ptr %state, i64 %v1266, i64 %v1267)
  store ptr %v1269, ptr %MEMORY, align 8
  %v1270 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1270, ptr %PC, align 8
  %v1271 = add i64 %v1270, 2
  store i64 %v1271, ptr %NEXT_PC, align 8
  %v1272 = load i64, ptr %NEXT_PC, align 8
  %v1273 = add i64 %v1272, 10
  %v1274 = load i64, ptr %NEXT_PC, align 8
  %v1275 = load ptr, ptr %MEMORY, align 8
  %v1276 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1275, ptr %state, ptr %BRANCH_TAKEN, i64 %v1273, i64 %v1274, ptr %NEXT_PC)
  store ptr %v1276, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877600, label %bb_5389877590

bb_5389877590:                                    ; preds = %bb_5389877581
  %v1277 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1277, ptr %PC, align 8
  %v1278 = add i64 %v1277, 3
  store i64 %v1278, ptr %NEXT_PC, align 8
  %v1279 = load i64, ptr %RCX, align 8
  %v1280 = load ptr, ptr %MEMORY, align 8
  %v1281 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1280, ptr %state, ptr %R8, i64 %v1279)
  store ptr %v1281, ptr %MEMORY, align 8
  %v1282 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1282, ptr %PC, align 8
  %v1283 = add i64 %v1282, 3
  store i64 %v1283, ptr %NEXT_PC, align 8
  %v1284 = load i64, ptr %R15, align 8
  %v1285 = load ptr, ptr %MEMORY, align 8
  %v1286 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1285, ptr %state, ptr %RDX, i64 %v1284)
  store ptr %v1286, ptr %MEMORY, align 8
  %v1287 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1287, ptr %PC, align 8
  %v1288 = add i64 %v1287, 4
  store i64 %v1288, ptr %NEXT_PC, align 8
  %v1289 = load i64, ptr %R8, align 8
  %v1290 = add i64 %v1289, 24
  %v1291 = load i64, ptr %NEXT_PC, align 8
  %v1292 = load ptr, ptr %MEMORY, align 8
  %v1293 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1292, ptr %state, i64 %v1290, ptr %NEXT_PC, i64 %v1291, ptr %RETURN_PC)
  store ptr %v1293, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877600:                                    ; preds = %bb_5389877581
  %v1294 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1294, ptr %PC, align 8
  %v1295 = add i64 %v1294, 2
  store i64 %v1295, ptr %NEXT_PC, align 8
  %v1296 = load i32, ptr %EBX, align 4
  %v1297 = zext i32 %v1296 to i64
  %v1298 = load ptr, ptr %MEMORY, align 8
  %v1299 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1298, ptr %state, ptr %RAX, i64 %v1297)
  store ptr %v1299, ptr %MEMORY, align 8
  %v1300 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1300, ptr %PC, align 8
  %v1301 = add i64 %v1300, 8
  store i64 %v1301, ptr %NEXT_PC, align 8
  %v1302 = load i64, ptr %RSP, align 8
  %v1303 = add i64 %v1302, 144
  %v1304 = load ptr, ptr %MEMORY, align 8
  %v1305 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1304, ptr %state, ptr %RBX, i64 %v1303)
  store ptr %v1305, ptr %MEMORY, align 8
  br label %bb_5389877610

bb_5389877610:                                    ; preds = %bb_5389877600, %bb_5389877027
  %v1306 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1306, ptr %PC, align 8
  %v1307 = add i64 %v1306, 5
  store i64 %v1307, ptr %NEXT_PC, align 8
  %v1308 = load i64, ptr %RSP, align 8
  %v1309 = add i64 %v1308, 96
  %v1310 = load ptr, ptr %MEMORY, align 8
  %v1311 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1310, ptr %state, ptr %R11, i64 %v1309)
  store ptr %v1311, ptr %MEMORY, align 8
  %v1312 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1312, ptr %PC, align 8
  %v1313 = add i64 %v1312, 4
  store i64 %v1313, ptr %NEXT_PC, align 8
  %v1314 = load i64, ptr %R11, align 8
  %v1315 = add i64 %v1314, 56
  %v1316 = load ptr, ptr %MEMORY, align 8
  %v1317 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1316, ptr %state, ptr %RSI, i64 %v1315)
  store ptr %v1317, ptr %MEMORY, align 8
  %v1318 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1318, ptr %PC, align 8
  %v1319 = add i64 %v1318, 4
  store i64 %v1319, ptr %NEXT_PC, align 8
  %v1320 = load i64, ptr %R11, align 8
  %v1321 = add i64 %v1320, 72
  %v1322 = load ptr, ptr %MEMORY, align 8
  %v1323 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1322, ptr %state, ptr %RDI, i64 %v1321)
  store ptr %v1323, ptr %MEMORY, align 8
  %v1324 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1324, ptr %PC, align 8
  %v1325 = add i64 %v1324, 3
  store i64 %v1325, ptr %NEXT_PC, align 8
  %v1326 = load i64, ptr %R11, align 8
  %v1327 = load ptr, ptr %MEMORY, align 8
  %v1328 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1327, ptr %state, ptr %RSP, i64 %v1326)
  store ptr %v1328, ptr %MEMORY, align 8
  %v1329 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1329, ptr %PC, align 8
  %v1330 = add i64 %v1329, 2
  store i64 %v1330, ptr %NEXT_PC, align 8
  %v1331 = load ptr, ptr %MEMORY, align 8
  %v1332 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1331, ptr %state, ptr %R15)
  store ptr %v1332, ptr %MEMORY, align 8
  %v1333 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1333, ptr %PC, align 8
  %v1334 = add i64 %v1333, 2
  store i64 %v1334, ptr %NEXT_PC, align 8
  %v1335 = load ptr, ptr %MEMORY, align 8
  %v1336 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1335, ptr %state, ptr %R14)
  store ptr %v1336, ptr %MEMORY, align 8
  %v1337 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1337, ptr %PC, align 8
  %v1338 = add i64 %v1337, 2
  store i64 %v1338, ptr %NEXT_PC, align 8
  %v1339 = load ptr, ptr %MEMORY, align 8
  %v1340 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1339, ptr %state, ptr %R13)
  store ptr %v1340, ptr %MEMORY, align 8
  %v1341 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1341, ptr %PC, align 8
  %v1342 = add i64 %v1341, 2
  store i64 %v1342, ptr %NEXT_PC, align 8
  %v1343 = load ptr, ptr %MEMORY, align 8
  %v1344 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1343, ptr %state, ptr %R12)
  store ptr %v1344, ptr %MEMORY, align 8
  %v1345 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1345, ptr %PC, align 8
  %v1346 = add i64 %v1345, 1
  store i64 %v1346, ptr %NEXT_PC, align 8
  %v1347 = load ptr, ptr %MEMORY, align 8
  %v1348 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1347, ptr %state, ptr %RBP)
  store ptr %v1348, ptr %MEMORY, align 8
  %v1349 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1349, ptr %PC, align 8
  %v1350 = add i64 %v1349, 1
  store i64 %v1350, ptr %NEXT_PC, align 8
  %v1351 = load ptr, ptr %MEMORY, align 8
  %v1352 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1351, ptr %state, ptr %NEXT_PC)
  store ptr %v1352, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877636:                                    ; No predecessors!
  %v1353 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1353, ptr %PC, align 8
  %v1354 = add i64 %v1353, 1
  store i64 %v1354, ptr %NEXT_PC, align 8
  %v1355 = load ptr, ptr %MEMORY, align 8
  %v1356 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1355, ptr %state, ptr undef)
  store ptr %v1356, ptr %MEMORY, align 8
  %v1357 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1357, ptr %PC, align 8
  %v1358 = add i64 %v1357, 1
  store i64 %v1358, ptr %NEXT_PC, align 8
  %v1359 = load ptr, ptr %MEMORY, align 8
  %v1360 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1359, ptr %state, ptr undef)
  store ptr %v1360, ptr %MEMORY, align 8
  %v1361 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1361, ptr %PC, align 8
  %v1362 = add i64 %v1361, 1
  store i64 %v1362, ptr %NEXT_PC, align 8
  %v1363 = load ptr, ptr %MEMORY, align 8
  %v1364 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1363, ptr %state, ptr undef)
  store ptr %v1364, ptr %MEMORY, align 8
  %v1365 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1365, ptr %PC, align 8
  %v1366 = add i64 %v1365, 1
  store i64 %v1366, ptr %NEXT_PC, align 8
  %v1367 = load ptr, ptr %MEMORY, align 8
  %v1368 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1367, ptr %state, ptr undef)
  store ptr %v1368, ptr %MEMORY, align 8
  %v1369 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1369, ptr %PC, align 8
  %v1370 = add i64 %v1369, 1
  store i64 %v1370, ptr %NEXT_PC, align 8
  %v1371 = load ptr, ptr %MEMORY, align 8
  %v1372 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1371, ptr %state, ptr undef)
  store ptr %v1372, ptr %MEMORY, align 8
  %v1373 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1373, ptr %PC, align 8
  %v1374 = add i64 %v1373, 1
  store i64 %v1374, ptr %NEXT_PC, align 8
  %v1375 = load ptr, ptr %MEMORY, align 8
  %v1376 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1375, ptr %state, ptr undef)
  store ptr %v1376, ptr %MEMORY, align 8
  %v1377 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1377, ptr %PC, align 8
  %v1378 = add i64 %v1377, 1
  store i64 %v1378, ptr %NEXT_PC, align 8
  %v1379 = load ptr, ptr %MEMORY, align 8
  %v1380 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1379, ptr %state, ptr undef)
  store ptr %v1380, ptr %MEMORY, align 8
  %v1381 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1381, ptr %PC, align 8
  %v1382 = add i64 %v1381, 1
  store i64 %v1382, ptr %NEXT_PC, align 8
  %v1383 = load ptr, ptr %MEMORY, align 8
  %v1384 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1383, ptr %state, ptr undef)
  store ptr %v1384, ptr %MEMORY, align 8
  %v1385 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1385, ptr %PC, align 8
  %v1386 = add i64 %v1385, 1
  store i64 %v1386, ptr %NEXT_PC, align 8
  %v1387 = load ptr, ptr %MEMORY, align 8
  %v1388 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1387, ptr %state, ptr undef)
  store ptr %v1388, ptr %MEMORY, align 8
  %v1389 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1389, ptr %PC, align 8
  %v1390 = add i64 %v1389, 1
  store i64 %v1390, ptr %NEXT_PC, align 8
  %v1391 = load ptr, ptr %MEMORY, align 8
  %v1392 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1391, ptr %state, ptr undef)
  store ptr %v1392, ptr %MEMORY, align 8
  %v1393 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1393, ptr %PC, align 8
  %v1394 = add i64 %v1393, 1
  store i64 %v1394, ptr %NEXT_PC, align 8
  %v1395 = load ptr, ptr %MEMORY, align 8
  %v1396 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1395, ptr %state, ptr undef)
  store ptr %v1396, ptr %MEMORY, align 8
  %v1397 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1397, ptr %PC, align 8
  %v1398 = add i64 %v1397, 1
  store i64 %v1398, ptr %NEXT_PC, align 8
  %v1399 = load ptr, ptr %MEMORY, align 8
  %v1400 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v1399, ptr %state, ptr undef)
  store ptr %v1400, ptr %MEMORY, align 8
  %v1401 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1401, ptr %PC, align 8
  %v1402 = add i64 %v1401, 5
  store i64 %v1402, ptr %NEXT_PC, align 8
  %v1403 = load i64, ptr %RSP, align 8
  %v1404 = add i64 %v1403, 16
  %v1405 = load i64, ptr %RBX, align 8
  %v1406 = load ptr, ptr %MEMORY, align 8
  %v1407 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1406, ptr %state, i64 %v1404, i64 %v1405)
  store ptr %v1407, ptr %MEMORY, align 8
  %v1408 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1408, ptr %PC, align 8
  %v1409 = add i64 %v1408, 5
  store i64 %v1409, ptr %NEXT_PC, align 8
  %v1410 = load i64, ptr %RSP, align 8
  %v1411 = add i64 %v1410, 32
  %v1412 = load i64, ptr %RBP, align 8
  %v1413 = load ptr, ptr %MEMORY, align 8
  %v1414 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1413, ptr %state, i64 %v1411, i64 %v1412)
  store ptr %v1414, ptr %MEMORY, align 8
  %v1415 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1415, ptr %PC, align 8
  %v1416 = add i64 %v1415, 1
  store i64 %v1416, ptr %NEXT_PC, align 8
  %v1417 = load i64, ptr %RDI, align 8
  %v1418 = load ptr, ptr %MEMORY, align 8
  %v1419 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1418, ptr %state, i64 %v1417)
  store ptr %v1419, ptr %MEMORY, align 8
  %v1420 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1420, ptr %PC, align 8
  %v1421 = add i64 %v1420, 4
  store i64 %v1421, ptr %NEXT_PC, align 8
  %v1422 = load i64, ptr %RSP, align 8
  %v1423 = load ptr, ptr %MEMORY, align 8
  %v1424 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1423, ptr %state, ptr %RSP, i64 %v1422, i64 80)
  store ptr %v1424, ptr %MEMORY, align 8
  %v1425 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1425, ptr %PC, align 8
  %v1426 = add i64 %v1425, 7
  store i64 %v1426, ptr %NEXT_PC, align 8
  %v1427 = load i64, ptr %R8, align 8
  %v1428 = add i64 %v1427, 256
  %v1429 = load ptr, ptr %MEMORY, align 8
  %v1430 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1429, ptr %state, ptr %RAX, i64 %v1428)
  store ptr %v1430, ptr %MEMORY, align 8
  %v1431 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1431, ptr %PC, align 8
  %v1432 = add i64 %v1431, 3
  store i64 %v1432, ptr %NEXT_PC, align 8
  %v1433 = load i64, ptr %R8, align 8
  %v1434 = load ptr, ptr %MEMORY, align 8
  %v1435 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1434, ptr %state, ptr %RDI, i64 %v1433)
  store ptr %v1435, ptr %MEMORY, align 8
  %v1436 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1436, ptr %PC, align 8
  %v1437 = add i64 %v1436, 2
  store i64 %v1437, ptr %NEXT_PC, align 8
  %v1438 = load i32, ptr %EDX, align 4
  %v1439 = zext i32 %v1438 to i64
  %v1440 = load ptr, ptr %MEMORY, align 8
  %v1441 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1440, ptr %state, ptr %RBP, i64 %v1439)
  store ptr %v1441, ptr %MEMORY, align 8
  %v1442 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1442, ptr %PC, align 8
  %v1443 = add i64 %v1442, 3
  store i64 %v1443, ptr %NEXT_PC, align 8
  %v1444 = load i64, ptr %RCX, align 8
  %v1445 = load ptr, ptr %MEMORY, align 8
  %v1446 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1445, ptr %state, ptr %RBX, i64 %v1444)
  store ptr %v1446, ptr %MEMORY, align 8
  %v1447 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1447, ptr %PC, align 8
  %v1448 = add i64 %v1447, 2
  store i64 %v1448, ptr %NEXT_PC, align 8
  %v1449 = load i32, ptr %EAX, align 4
  %v1450 = zext i32 %v1449 to i64
  %v1451 = load i32, ptr %EAX, align 4
  %v1452 = zext i32 %v1451 to i64
  %v1453 = load ptr, ptr %MEMORY, align 8
  %v1454 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1453, ptr %state, i64 %v1450, i64 %v1452)
  store ptr %v1454, ptr %MEMORY, align 8
  %v1455 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1455, ptr %PC, align 8
  %v1456 = add i64 %v1455, 6
  store i64 %v1456, ptr %NEXT_PC, align 8
  %v1457 = load i64, ptr %NEXT_PC, align 8
  %v1458 = add i64 %v1457, 318
  %v1459 = load i64, ptr %NEXT_PC, align 8
  %v1460 = load ptr, ptr %MEMORY, align 8
  %v1461 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1460, ptr %state, ptr %BRANCH_TAKEN, i64 %v1458, i64 %v1459, ptr %NEXT_PC)
  store ptr %v1461, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878004, label %bb_5389877686

bb_5389877686:                                    ; preds = %bb_5389877636
  %v1462 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1462, ptr %PC, align 8
  %v1463 = add i64 %v1462, 2
  store i64 %v1463, ptr %NEXT_PC, align 8
  %v1464 = load i64, ptr %RAX, align 8
  %v1465 = load ptr, ptr %MEMORY, align 8
  %v1466 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1465, ptr %state, ptr %RAX, i64 %v1464)
  store ptr %v1466, ptr %MEMORY, align 8
  %v1467 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1467, ptr %PC, align 8
  %v1468 = add i64 %v1467, 3
  store i64 %v1468, ptr %NEXT_PC, align 8
  %v1469 = load i32, ptr %EAX, align 4
  %v1470 = zext i32 %v1469 to i64
  %v1471 = load ptr, ptr %MEMORY, align 8
  %v1472 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v1471, ptr %state, ptr %RDX, i64 %v1470)
  store ptr %v1472, ptr %MEMORY, align 8
  %v1473 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1473, ptr %PC, align 8
  %v1474 = add i64 %v1473, 4
  store i64 %v1474, ptr %NEXT_PC, align 8
  %v1475 = load i64, ptr %R8, align 8
  %v1476 = load i64, ptr %RDX, align 8
  %v1477 = mul i64 %v1476, 4
  %v1478 = add i64 %v1475, %v1477
  %v1479 = load ptr, ptr %MEMORY, align 8
  %v1480 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1479, ptr %state, ptr %RDX, i64 %v1478)
  store ptr %v1480, ptr %MEMORY, align 8
  %v1481 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1481, ptr %PC, align 8
  %v1482 = add i64 %v1481, 5
  store i64 %v1482, ptr %NEXT_PC, align 8
  %v1483 = load i64, ptr %NEXT_PC, align 8
  %v1484 = add i64 %v1483, 5836
  %v1485 = load i64, ptr %NEXT_PC, align 8
  %v1486 = load ptr, ptr %MEMORY, align 8
  %v1487 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1486, ptr %state, i64 %v1484, ptr %NEXT_PC, i64 %v1485, ptr %RETURN_PC)
  store ptr %v1487, ptr %MEMORY, align 8
  %v1488 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1488, ptr %PC, align 8
  %v1489 = add i64 %v1488, 3
  store i64 %v1489, ptr %NEXT_PC, align 8
  %v1490 = load i32, ptr %EAX, align 4
  %v1491 = zext i32 %v1490 to i64
  %v1492 = load ptr, ptr %MEMORY, align 8
  %v1493 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1492, ptr %state, i64 %v1491, i64 -1)
  store ptr %v1493, ptr %MEMORY, align 8
  %v1494 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1494, ptr %PC, align 8
  %v1495 = add i64 %v1494, 6
  store i64 %v1495, ptr %NEXT_PC, align 8
  %v1496 = load i64, ptr %NEXT_PC, align 8
  %v1497 = add i64 %v1496, 295
  %v1498 = load i64, ptr %NEXT_PC, align 8
  %v1499 = load ptr, ptr %MEMORY, align 8
  %v1500 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1499, ptr %state, ptr %BRANCH_TAKEN, i64 %v1497, i64 %v1498, ptr %NEXT_PC)
  store ptr %v1500, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878004, label %bb_5389877709

bb_5389877709:                                    ; preds = %bb_5389877686
  %v1501 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1501, ptr %PC, align 8
  %v1502 = add i64 %v1501, 7
  store i64 %v1502, ptr %NEXT_PC, align 8
  %v1503 = load i64, ptr %RDI, align 8
  %v1504 = add i64 %v1503, 256
  %v1505 = load ptr, ptr %MEMORY, align 8
  %v1506 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1505, ptr %state, i64 %v1504, i64 1)
  store ptr %v1506, ptr %MEMORY, align 8
  %v1507 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1507, ptr %PC, align 8
  %v1508 = add i64 %v1507, 2
  store i64 %v1508, ptr %NEXT_PC, align 8
  %v1509 = load i64, ptr %NEXT_PC, align 8
  %v1510 = add i64 %v1509, 31
  %v1511 = load i64, ptr %NEXT_PC, align 8
  %v1512 = load ptr, ptr %MEMORY, align 8
  %v1513 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1512, ptr %state, ptr %BRANCH_TAKEN, i64 %v1510, i64 %v1511, ptr %NEXT_PC)
  store ptr %v1513, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877749, label %bb_5389877718

bb_5389877718:                                    ; preds = %bb_5389877709
  %v1514 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1514, ptr %PC, align 8
  %v1515 = add i64 %v1514, 2
  store i64 %v1515, ptr %NEXT_PC, align 8
  %v1516 = load i32, ptr %EAX, align 4
  %v1517 = zext i32 %v1516 to i64
  %v1518 = load ptr, ptr %MEMORY, align 8
  %v1519 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1518, ptr %state, ptr %RDX, i64 %v1517)
  store ptr %v1519, ptr %MEMORY, align 8
  %v1520 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1520, ptr %PC, align 8
  %v1521 = add i64 %v1520, 3
  store i64 %v1521, ptr %NEXT_PC, align 8
  %v1522 = load i64, ptr %RBX, align 8
  %v1523 = load ptr, ptr %MEMORY, align 8
  %v1524 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1523, ptr %state, ptr %RCX, i64 %v1522)
  store ptr %v1524, ptr %MEMORY, align 8
  %v1525 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1525, ptr %PC, align 8
  %v1526 = add i64 %v1525, 5
  store i64 %v1526, ptr %NEXT_PC, align 8
  %v1527 = load i64, ptr %NEXT_PC, align 8
  %v1528 = add i64 %v1527, 4848
  %v1529 = load i64, ptr %NEXT_PC, align 8
  %v1530 = load ptr, ptr %MEMORY, align 8
  %v1531 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1530, ptr %state, i64 %v1528, ptr %NEXT_PC, i64 %v1529, ptr %RETURN_PC)
  store ptr %v1531, ptr %MEMORY, align 8
  %v1532 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1532, ptr %PC, align 8
  %v1533 = add i64 %v1532, 5
  store i64 %v1533, ptr %NEXT_PC, align 8
  %v1534 = load ptr, ptr %MEMORY, align 8
  %v1535 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1534, ptr %state, ptr %RAX, i64 1)
  store ptr %v1535, ptr %MEMORY, align 8
  %v1536 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1536, ptr %PC, align 8
  %v1537 = add i64 %v1536, 5
  store i64 %v1537, ptr %NEXT_PC, align 8
  %v1538 = load i64, ptr %RSP, align 8
  %v1539 = add i64 %v1538, 104
  %v1540 = load ptr, ptr %MEMORY, align 8
  %v1541 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1540, ptr %state, ptr %RBX, i64 %v1539)
  store ptr %v1541, ptr %MEMORY, align 8
  %v1542 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1542, ptr %PC, align 8
  %v1543 = add i64 %v1542, 5
  store i64 %v1543, ptr %NEXT_PC, align 8
  %v1544 = load i64, ptr %RSP, align 8
  %v1545 = add i64 %v1544, 120
  %v1546 = load ptr, ptr %MEMORY, align 8
  %v1547 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1546, ptr %state, ptr %RBP, i64 %v1545)
  store ptr %v1547, ptr %MEMORY, align 8
  %v1548 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1548, ptr %PC, align 8
  %v1549 = add i64 %v1548, 4
  store i64 %v1549, ptr %NEXT_PC, align 8
  %v1550 = load i64, ptr %RSP, align 8
  %v1551 = load ptr, ptr %MEMORY, align 8
  %v1552 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1551, ptr %state, ptr %RSP, i64 %v1550, i64 80)
  store ptr %v1552, ptr %MEMORY, align 8
  %v1553 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1553, ptr %PC, align 8
  %v1554 = add i64 %v1553, 1
  store i64 %v1554, ptr %NEXT_PC, align 8
  %v1555 = load ptr, ptr %MEMORY, align 8
  %v1556 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v1555, ptr %state, ptr %RDI)
  store ptr %v1556, ptr %MEMORY, align 8
  %v1557 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1557, ptr %PC, align 8
  %v1558 = add i64 %v1557, 1
  store i64 %v1558, ptr %NEXT_PC, align 8
  %v1559 = load ptr, ptr %MEMORY, align 8
  %v1560 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v1559, ptr %state, ptr %NEXT_PC)
  store ptr %v1560, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877749:                                    ; preds = %bb_5389877709
  %v1561 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1561, ptr %PC, align 8
  %v1562 = add i64 %v1561, 2
  store i64 %v1562, ptr %NEXT_PC, align 8
  %v1563 = load i32, ptr %EAX, align 4
  %v1564 = zext i32 %v1563 to i64
  %v1565 = load i32, ptr %EAX, align 4
  %v1566 = zext i32 %v1565 to i64
  %v1567 = load ptr, ptr %MEMORY, align 8
  %v1568 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1567, ptr %state, i64 %v1564, i64 %v1566)
  store ptr %v1568, ptr %MEMORY, align 8
  %v1569 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1569, ptr %PC, align 8
  %v1570 = add i64 %v1569, 2
  store i64 %v1570, ptr %NEXT_PC, align 8
  %v1571 = load i64, ptr %NEXT_PC, align 8
  %v1572 = add i64 %v1571, 64
  %v1573 = load i64, ptr %NEXT_PC, align 8
  %v1574 = load ptr, ptr %MEMORY, align 8
  %v1575 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1574, ptr %state, ptr %BRANCH_TAKEN, i64 %v1572, i64 %v1573, ptr %NEXT_PC)
  store ptr %v1575, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877817, label %bb_5389877753

bb_5389877753:                                    ; preds = %bb_5389877749
  %v1576 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1576, ptr %PC, align 8
  %v1577 = add i64 %v1576, 3
  store i64 %v1577, ptr %NEXT_PC, align 8
  %v1578 = load i32, ptr %EAX, align 4
  %v1579 = zext i32 %v1578 to i64
  %v1580 = load i64, ptr %RBX, align 8
  %v1581 = add i64 %v1580, 40
  %v1582 = load ptr, ptr %MEMORY, align 8
  %v1583 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1582, ptr %state, i64 %v1579, i64 %v1581)
  store ptr %v1583, ptr %MEMORY, align 8
  %v1584 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1584, ptr %PC, align 8
  %v1585 = add i64 %v1584, 2
  store i64 %v1585, ptr %NEXT_PC, align 8
  %v1586 = load i64, ptr %NEXT_PC, align 8
  %v1587 = add i64 %v1586, 59
  %v1588 = load i64, ptr %NEXT_PC, align 8
  %v1589 = load ptr, ptr %MEMORY, align 8
  %v1590 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1589, ptr %state, ptr %BRANCH_TAKEN, i64 %v1587, i64 %v1588, ptr %NEXT_PC)
  store ptr %v1590, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877817, label %bb_5389877758

bb_5389877758:                                    ; preds = %bb_5389877753
  %v1591 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1591, ptr %PC, align 8
  %v1592 = add i64 %v1591, 4
  store i64 %v1592, ptr %NEXT_PC, align 8
  %v1593 = load i64, ptr %RBX, align 8
  %v1594 = add i64 %v1593, 32
  %v1595 = load ptr, ptr %MEMORY, align 8
  %v1596 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1595, ptr %state, ptr %R8, i64 %v1594)
  store ptr %v1596, ptr %MEMORY, align 8
  %v1597 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1597, ptr %PC, align 8
  %v1598 = add i64 %v1597, 2
  store i64 %v1598, ptr %NEXT_PC, align 8
  %v1599 = load i64, ptr %RBX, align 8
  %v1600 = load i32, ptr %EBX, align 4
  %v1601 = zext i32 %v1600 to i64
  %v1602 = load ptr, ptr %MEMORY, align 8
  %v1603 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1602, ptr %state, ptr %RBX, i64 %v1599, i64 %v1601)
  store ptr %v1603, ptr %MEMORY, align 8
  %v1604 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1604, ptr %PC, align 8
  %v1605 = add i64 %v1604, 4
  store i64 %v1605, ptr %NEXT_PC, align 8
  %v1606 = load i64, ptr %R8, align 8
  %v1607 = load ptr, ptr %MEMORY, align 8
  %v1608 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1607, ptr %state, ptr %R8, i64 %v1606, i64 8)
  store ptr %v1608, ptr %MEMORY, align 8
  %v1609 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1609, ptr %PC, align 8
  %v1610 = add i64 %v1609, 2
  store i64 %v1610, ptr %NEXT_PC, align 8
  %v1611 = load ptr, ptr %MEMORY, align 8
  %v1612 = call ptr @_ZN12_GLOBAL__N_18CDQE_EAXEP6MemoryR5State(ptr %v1611, ptr %state)
  store ptr %v1612, ptr %MEMORY, align 8
  %v1613 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1613, ptr %PC, align 8
  %v1614 = add i64 %v1613, 4
  store i64 %v1614, ptr %NEXT_PC, align 8
  %v1615 = load i64, ptr %RAX, align 8
  %v1616 = load ptr, ptr %MEMORY, align 8
  %v1617 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1616, ptr %state, ptr %RCX, i64 %v1615, i64 56)
  store ptr %v1617, ptr %MEMORY, align 8
  %v1618 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1618, ptr %PC, align 8
  %v1619 = add i64 %v1618, 5
  store i64 %v1619, ptr %NEXT_PC, align 8
  %v1620 = load i64, ptr %RSP, align 8
  %v1621 = add i64 %v1620, 64
  %v1622 = load i64, ptr %RBX, align 8
  %v1623 = load ptr, ptr %MEMORY, align 8
  %v1624 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1623, ptr %state, i64 %v1621, i64 %v1622)
  store ptr %v1624, ptr %MEMORY, align 8
  %v1625 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1625, ptr %PC, align 8
  %v1626 = add i64 %v1625, 3
  store i64 %v1626, ptr %NEXT_PC, align 8
  %v1627 = load i32, ptr %EBX, align 4
  %v1628 = zext i32 %v1627 to i64
  %v1629 = load ptr, ptr %MEMORY, align 8
  %v1630 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1629, ptr %state, ptr %R9, i64 %v1628)
  store ptr %v1630, ptr %MEMORY, align 8
  %v1631 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1631, ptr %PC, align 8
  %v1632 = add i64 %v1631, 3
  store i64 %v1632, ptr %NEXT_PC, align 8
  %v1633 = load i64, ptr %R8, align 8
  %v1634 = load i64, ptr %RCX, align 8
  %v1635 = load ptr, ptr %MEMORY, align 8
  %v1636 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1635, ptr %state, ptr %R8, i64 %v1633, i64 %v1634)
  store ptr %v1636, ptr %MEMORY, align 8
  %v1637 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1637, ptr %PC, align 8
  %v1638 = add i64 %v1637, 4
  store i64 %v1638, ptr %NEXT_PC, align 8
  %v1639 = load i64, ptr %R8, align 8
  %v1640 = add i64 %v1639, 32
  %v1641 = load ptr, ptr %MEMORY, align 8
  %v1642 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1641, ptr %state, ptr %RCX, i64 %v1640)
  store ptr %v1642, ptr %MEMORY, align 8
  %v1643 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1643, ptr %PC, align 8
  %v1644 = add i64 %v1643, 3
  store i64 %v1644, ptr %NEXT_PC, align 8
  %v1645 = load i64, ptr %RCX, align 8
  %v1646 = load i64, ptr %RCX, align 8
  %v1647 = load ptr, ptr %MEMORY, align 8
  %v1648 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1647, ptr %state, i64 %v1645, i64 %v1646)
  store ptr %v1648, ptr %MEMORY, align 8
  %v1649 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1649, ptr %PC, align 8
  %v1650 = add i64 %v1649, 2
  store i64 %v1650, ptr %NEXT_PC, align 8
  %v1651 = load i64, ptr %NEXT_PC, align 8
  %v1652 = add i64 %v1651, 33
  %v1653 = load i64, ptr %NEXT_PC, align 8
  %v1654 = load ptr, ptr %MEMORY, align 8
  %v1655 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1654, ptr %state, ptr %BRANCH_TAKEN, i64 %v1652, i64 %v1653, ptr %NEXT_PC)
  store ptr %v1655, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877827, label %bb_5389877794

bb_5389877794:                                    ; preds = %bb_5389877758
  %v1656 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1656, ptr %PC, align 8
  %v1657 = add i64 %v1656, 5
  store i64 %v1657, ptr %NEXT_PC, align 8
  %v1658 = load i64, ptr %RSP, align 8
  %v1659 = add i64 %v1658, 64
  %v1660 = load i64, ptr %RCX, align 8
  %v1661 = load ptr, ptr %MEMORY, align 8
  %v1662 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1661, ptr %state, i64 %v1659, i64 %v1660)
  store ptr %v1662, ptr %MEMORY, align 8
  %v1663 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1663, ptr %PC, align 8
  %v1664 = add i64 %v1663, 5
  store i64 %v1664, ptr %NEXT_PC, align 8
  %v1665 = load i64, ptr %RSP, align 8
  %v1666 = add i64 %v1665, 32
  %v1667 = load ptr, ptr %MEMORY, align 8
  %v1668 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1667, ptr %state, ptr %RDX, i64 %v1666)
  store ptr %v1668, ptr %MEMORY, align 8
  %v1669 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1669, ptr %PC, align 8
  %v1670 = add i64 %v1669, 3
  store i64 %v1670, ptr %NEXT_PC, align 8
  %v1671 = load i64, ptr %RCX, align 8
  %v1672 = load ptr, ptr %MEMORY, align 8
  %v1673 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1672, ptr %state, ptr %RAX, i64 %v1671)
  store ptr %v1673, ptr %MEMORY, align 8
  %v1674 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1674, ptr %PC, align 8
  %v1675 = add i64 %v1674, 3
  store i64 %v1675, ptr %NEXT_PC, align 8
  %v1676 = load i64, ptr %RAX, align 8
  %v1677 = add i64 %v1676, 8
  %v1678 = load i64, ptr %NEXT_PC, align 8
  %v1679 = load ptr, ptr %MEMORY, align 8
  %v1680 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1679, ptr %state, i64 %v1677, ptr %NEXT_PC, i64 %v1678, ptr %RETURN_PC)
  store ptr %v1680, ptr %MEMORY, align 8
  %v1681 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1681, ptr %PC, align 8
  %v1682 = add i64 %v1681, 5
  store i64 %v1682, ptr %NEXT_PC, align 8
  %v1683 = load i64, ptr %RSP, align 8
  %v1684 = add i64 %v1683, 64
  %v1685 = load ptr, ptr %MEMORY, align 8
  %v1686 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1685, ptr %state, ptr %R9, i64 %v1684)
  store ptr %v1686, ptr %MEMORY, align 8
  %v1687 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1687, ptr %PC, align 8
  %v1688 = add i64 %v1687, 2
  store i64 %v1688, ptr %NEXT_PC, align 8
  %v1689 = load i64, ptr %NEXT_PC, align 8
  %v1690 = add i64 %v1689, 10
  %v1691 = load ptr, ptr %MEMORY, align 8
  %v1692 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v1691, ptr %state, i64 %v1690, ptr %NEXT_PC)
  store ptr %v1692, ptr %MEMORY, align 8
  br label %bb_5389877827

bb_5389877817:                                    ; preds = %bb_5389877753, %bb_5389877749
  %v1693 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1693, ptr %PC, align 8
  %v1694 = add i64 %v1693, 2
  store i64 %v1694, ptr %NEXT_PC, align 8
  %v1695 = load i64, ptr %RBX, align 8
  %v1696 = load i32, ptr %EBX, align 4
  %v1697 = zext i32 %v1696 to i64
  %v1698 = load ptr, ptr %MEMORY, align 8
  %v1699 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1698, ptr %state, ptr %RBX, i64 %v1695, i64 %v1697)
  store ptr %v1699, ptr %MEMORY, align 8
  %v1700 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1700, ptr %PC, align 8
  %v1701 = add i64 %v1700, 3
  store i64 %v1701, ptr %NEXT_PC, align 8
  %v1702 = load i32, ptr %EBX, align 4
  %v1703 = zext i32 %v1702 to i64
  %v1704 = load ptr, ptr %MEMORY, align 8
  %v1705 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1704, ptr %state, ptr %R9, i64 %v1703)
  store ptr %v1705, ptr %MEMORY, align 8
  %v1706 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1706, ptr %PC, align 8
  %v1707 = add i64 %v1706, 5
  store i64 %v1707, ptr %NEXT_PC, align 8
  %v1708 = load i64, ptr %RSP, align 8
  %v1709 = add i64 %v1708, 64
  %v1710 = load i64, ptr %RBX, align 8
  %v1711 = load ptr, ptr %MEMORY, align 8
  %v1712 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1711, ptr %state, i64 %v1709, i64 %v1710)
  store ptr %v1712, ptr %MEMORY, align 8
  br label %bb_5389877827

bb_5389877827:                                    ; preds = %bb_5389877817, %bb_5389877794, %bb_5389877758
  %v1713 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1713, ptr %PC, align 8
  %v1714 = add i64 %v1713, 7
  store i64 %v1714, ptr %NEXT_PC, align 8
  %v1715 = load i64, ptr %R9, align 8
  %v1716 = load i64, ptr %NEXT_PC, align 8
  %v1717 = add i64 %v1716, 27073638
  %v1718 = load ptr, ptr %MEMORY, align 8
  %v1719 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1718, ptr %state, i64 %v1715, i64 %v1717)
  store ptr %v1719, ptr %MEMORY, align 8
  %v1720 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1720, ptr %PC, align 8
  %v1721 = add i64 %v1720, 3
  store i64 %v1721, ptr %NEXT_PC, align 8
  %v1722 = load i64, ptr %RBX, align 8
  %v1723 = load ptr, ptr %MEMORY, align 8
  %v1724 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1723, ptr %state, ptr %RCX, i64 %v1722)
  store ptr %v1724, ptr %MEMORY, align 8
  %v1725 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1725, ptr %PC, align 8
  %v1726 = add i64 %v1725, 5
  store i64 %v1726, ptr %NEXT_PC, align 8
  %v1727 = load i64, ptr %RSP, align 8
  %v1728 = add i64 %v1727, 112
  %v1729 = load i64, ptr %RBX, align 8
  %v1730 = load ptr, ptr %MEMORY, align 8
  %v1731 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1730, ptr %state, i64 %v1728, i64 %v1729)
  store ptr %v1731, ptr %MEMORY, align 8
  %v1732 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1732, ptr %PC, align 8
  %v1733 = add i64 %v1732, 2
  store i64 %v1733, ptr %NEXT_PC, align 8
  %v1734 = load i64, ptr %NEXT_PC, align 8
  %v1735 = add i64 %v1734, 80
  %v1736 = load i64, ptr %NEXT_PC, align 8
  %v1737 = load ptr, ptr %MEMORY, align 8
  %v1738 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1737, ptr %state, ptr %BRANCH_TAKEN, i64 %v1735, i64 %v1736, ptr %NEXT_PC)
  store ptr %v1738, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877924, label %bb_5389877844

bb_5389877844:                                    ; preds = %bb_5389877827
  %v1739 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1739, ptr %PC, align 8
  %v1740 = add i64 %v1739, 3
  store i64 %v1740, ptr %NEXT_PC, align 8
  %v1741 = load i64, ptr %R9, align 8
  %v1742 = load i64, ptr %R9, align 8
  %v1743 = load ptr, ptr %MEMORY, align 8
  %v1744 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1743, ptr %state, i64 %v1741, i64 %v1742)
  store ptr %v1744, ptr %MEMORY, align 8
  %v1745 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1745, ptr %PC, align 8
  %v1746 = add i64 %v1745, 6
  store i64 %v1746, ptr %NEXT_PC, align 8
  %v1747 = load i64, ptr %NEXT_PC, align 8
  %v1748 = add i64 %v1747, 133
  %v1749 = load i64, ptr %NEXT_PC, align 8
  %v1750 = load ptr, ptr %MEMORY, align 8
  %v1751 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1750, ptr %state, ptr %BRANCH_TAKEN, i64 %v1748, i64 %v1749, ptr %NEXT_PC)
  store ptr %v1751, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877853

bb_5389877853:                                    ; preds = %bb_5389877844
  %v1752 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1752, ptr %PC, align 8
  %v1753 = add i64 %v1752, 3
  store i64 %v1753, ptr %NEXT_PC, align 8
  %v1754 = load i64, ptr %R9, align 8
  %v1755 = load ptr, ptr %MEMORY, align 8
  %v1756 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1755, ptr %state, ptr %RAX, i64 %v1754)
  store ptr %v1756, ptr %MEMORY, align 8
  %v1757 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1757, ptr %PC, align 8
  %v1758 = add i64 %v1757, 5
  store i64 %v1758, ptr %NEXT_PC, align 8
  %v1759 = load i64, ptr %RSP, align 8
  %v1760 = add i64 %v1759, 32
  %v1761 = load ptr, ptr %MEMORY, align 8
  %v1762 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1761, ptr %state, ptr %RDX, i64 %v1760)
  store ptr %v1762, ptr %MEMORY, align 8
  %v1763 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1763, ptr %PC, align 8
  %v1764 = add i64 %v1763, 3
  store i64 %v1764, ptr %NEXT_PC, align 8
  %v1765 = load i64, ptr %R9, align 8
  %v1766 = load ptr, ptr %MEMORY, align 8
  %v1767 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1766, ptr %state, ptr %RCX, i64 %v1765)
  store ptr %v1767, ptr %MEMORY, align 8
  %v1768 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1768, ptr %PC, align 8
  %v1769 = add i64 %v1768, 5
  store i64 %v1769, ptr %NEXT_PC, align 8
  %v1770 = load i64, ptr %RSP, align 8
  %v1771 = add i64 %v1770, 96
  %v1772 = load i64, ptr %RSI, align 8
  %v1773 = load ptr, ptr %MEMORY, align 8
  %v1774 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1773, ptr %state, i64 %v1771, i64 %v1772)
  store ptr %v1774, ptr %MEMORY, align 8
  %v1775 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1775, ptr %PC, align 8
  %v1776 = add i64 %v1775, 3
  store i64 %v1776, ptr %NEXT_PC, align 8
  %v1777 = load i64, ptr %RAX, align 8
  %v1778 = add i64 %v1777, 56
  %v1779 = load i64, ptr %NEXT_PC, align 8
  %v1780 = load ptr, ptr %MEMORY, align 8
  %v1781 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1780, ptr %state, i64 %v1778, ptr %NEXT_PC, i64 %v1779, ptr %RETURN_PC)
  store ptr %v1781, ptr %MEMORY, align 8
  %v1782 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1782, ptr %PC, align 8
  %v1783 = add i64 %v1782, 3
  store i64 %v1783, ptr %NEXT_PC, align 8
  %v1784 = load i64, ptr %RAX, align 8
  %v1785 = load ptr, ptr %MEMORY, align 8
  %v1786 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1785, ptr %state, ptr %RSI, i64 %v1784)
  store ptr %v1786, ptr %MEMORY, align 8
  %v1787 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1787, ptr %PC, align 8
  %v1788 = add i64 %v1787, 3
  store i64 %v1788, ptr %NEXT_PC, align 8
  %v1789 = load i64, ptr %RAX, align 8
  %v1790 = load ptr, ptr %MEMORY, align 8
  %v1791 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1790, ptr %state, ptr %RCX, i64 %v1789)
  store ptr %v1791, ptr %MEMORY, align 8
  %v1792 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1792, ptr %PC, align 8
  %v1793 = add i64 %v1792, 3
  store i64 %v1793, ptr %NEXT_PC, align 8
  %v1794 = load i64, ptr %RCX, align 8
  %v1795 = load i64, ptr %RCX, align 8
  %v1796 = load ptr, ptr %MEMORY, align 8
  %v1797 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1796, ptr %state, i64 %v1794, i64 %v1795)
  store ptr %v1797, ptr %MEMORY, align 8
  %v1798 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1798, ptr %PC, align 8
  %v1799 = add i64 %v1798, 2
  store i64 %v1799, ptr %NEXT_PC, align 8
  %v1800 = load i64, ptr %NEXT_PC, align 8
  %v1801 = add i64 %v1800, 8
  %v1802 = load i64, ptr %NEXT_PC, align 8
  %v1803 = load ptr, ptr %MEMORY, align 8
  %v1804 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1803, ptr %state, ptr %BRANCH_TAKEN, i64 %v1801, i64 %v1802, ptr %NEXT_PC)
  store ptr %v1804, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877891, label %bb_5389877883

bb_5389877883:                                    ; preds = %bb_5389877853
  %v1805 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1805, ptr %PC, align 8
  %v1806 = add i64 %v1805, 2
  store i64 %v1806, ptr %NEXT_PC, align 8
  %v1807 = load i64, ptr %RCX, align 8
  %v1808 = load i64, ptr %RCX, align 8
  %v1809 = load ptr, ptr %MEMORY, align 8
  %v1810 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1809, ptr %state, i64 %v1807, i64 %v1808)
  store ptr %v1810, ptr %MEMORY, align 8
  %v1811 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1811, ptr %PC, align 8
  %v1812 = add i64 %v1811, 4
  store i64 %v1812, ptr %NEXT_PC, align 8
  %v1813 = load i64, ptr %RCX, align 8
  %v1814 = add i64 %v1813, 48
  %v1815 = load ptr, ptr %MEMORY, align 8
  %v1816 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1815, ptr %state, ptr %RCX, i64 %v1814)
  store ptr %v1816, ptr %MEMORY, align 8
  %v1817 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1817, ptr %PC, align 8
  %v1818 = add i64 %v1817, 2
  store i64 %v1818, ptr %NEXT_PC, align 8
  %v1819 = load i64, ptr %RCX, align 8
  %v1820 = load i64, ptr %RCX, align 8
  %v1821 = load ptr, ptr %MEMORY, align 8
  %v1822 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1821, ptr %state, i64 %v1819, i64 %v1820)
  store ptr %v1822, ptr %MEMORY, align 8
  br label %bb_5389877891

bb_5389877891:                                    ; preds = %bb_5389877883, %bb_5389877853
  %v1823 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1823, ptr %PC, align 8
  %v1824 = add i64 %v1823, 5
  store i64 %v1824, ptr %NEXT_PC, align 8
  %v1825 = load i64, ptr %RSP, align 8
  %v1826 = add i64 %v1825, 112
  %v1827 = load ptr, ptr %MEMORY, align 8
  %v1828 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1827, ptr %state, ptr %RCX, i64 %v1826)
  store ptr %v1828, ptr %MEMORY, align 8
  %v1829 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1829, ptr %PC, align 8
  %v1830 = add i64 %v1829, 3
  store i64 %v1830, ptr %NEXT_PC, align 8
  %v1831 = load i64, ptr %RCX, align 8
  %v1832 = load i64, ptr %RCX, align 8
  %v1833 = load ptr, ptr %MEMORY, align 8
  %v1834 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1833, ptr %state, i64 %v1831, i64 %v1832)
  store ptr %v1834, ptr %MEMORY, align 8
  %v1835 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1835, ptr %PC, align 8
  %v1836 = add i64 %v1835, 2
  store i64 %v1836, ptr %NEXT_PC, align 8
  %v1837 = load i64, ptr %NEXT_PC, align 8
  %v1838 = add i64 %v1837, 5
  %v1839 = load i64, ptr %NEXT_PC, align 8
  %v1840 = load ptr, ptr %MEMORY, align 8
  %v1841 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1840, ptr %state, ptr %BRANCH_TAKEN, i64 %v1838, i64 %v1839, ptr %NEXT_PC)
  store ptr %v1841, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877906, label %bb_5389877901

bb_5389877901:                                    ; preds = %bb_5389877891
  %v1842 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1842, ptr %PC, align 8
  %v1843 = add i64 %v1842, 5
  store i64 %v1843, ptr %NEXT_PC, align 8
  %v1844 = load i64, ptr %NEXT_PC, align 8
  %v1845 = sub i64 %v1844, 1202
  %v1846 = load i64, ptr %NEXT_PC, align 8
  %v1847 = load ptr, ptr %MEMORY, align 8
  %v1848 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1847, ptr %state, i64 %v1845, ptr %NEXT_PC, i64 %v1846, ptr %RETURN_PC)
  store ptr %v1848, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877906:                                    ; preds = %bb_5389877891
  %v1849 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1849, ptr %PC, align 8
  %v1850 = add i64 %v1849, 3
  store i64 %v1850, ptr %NEXT_PC, align 8
  %v1851 = load i64, ptr %RSI, align 8
  %v1852 = load ptr, ptr %MEMORY, align 8
  %v1853 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1852, ptr %state, ptr %RCX, i64 %v1851)
  store ptr %v1853, ptr %MEMORY, align 8
  %v1854 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1854, ptr %PC, align 8
  %v1855 = add i64 %v1854, 5
  store i64 %v1855, ptr %NEXT_PC, align 8
  %v1856 = load i64, ptr %RSP, align 8
  %v1857 = add i64 %v1856, 64
  %v1858 = load ptr, ptr %MEMORY, align 8
  %v1859 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1858, ptr %state, ptr %R9, i64 %v1857)
  store ptr %v1859, ptr %MEMORY, align 8
  %v1860 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1860, ptr %PC, align 8
  %v1861 = add i64 %v1860, 5
  store i64 %v1861, ptr %NEXT_PC, align 8
  %v1862 = load i64, ptr %RSP, align 8
  %v1863 = add i64 %v1862, 96
  %v1864 = load ptr, ptr %MEMORY, align 8
  %v1865 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1864, ptr %state, ptr %RSI, i64 %v1863)
  store ptr %v1865, ptr %MEMORY, align 8
  %v1866 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1866, ptr %PC, align 8
  %v1867 = add i64 %v1866, 5
  store i64 %v1867, ptr %NEXT_PC, align 8
  %v1868 = load i64, ptr %RSP, align 8
  %v1869 = add i64 %v1868, 112
  %v1870 = load i64, ptr %RCX, align 8
  %v1871 = load ptr, ptr %MEMORY, align 8
  %v1872 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1871, ptr %state, i64 %v1869, i64 %v1870)
  store ptr %v1872, ptr %MEMORY, align 8
  br label %bb_5389877924

bb_5389877924:                                    ; preds = %bb_5389877906, %bb_5389877827
  %v1873 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1873, ptr %PC, align 8
  %v1874 = add i64 %v1873, 3
  store i64 %v1874, ptr %NEXT_PC, align 8
  %v1875 = load i64, ptr %R9, align 8
  %v1876 = load i64, ptr %R9, align 8
  %v1877 = load ptr, ptr %MEMORY, align 8
  %v1878 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1877, ptr %state, i64 %v1875, i64 %v1876)
  store ptr %v1878, ptr %MEMORY, align 8
  %v1879 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1879, ptr %PC, align 8
  %v1880 = add i64 %v1879, 2
  store i64 %v1880, ptr %NEXT_PC, align 8
  %v1881 = load i64, ptr %NEXT_PC, align 8
  %v1882 = add i64 %v1881, 19
  %v1883 = load i64, ptr %NEXT_PC, align 8
  %v1884 = load ptr, ptr %MEMORY, align 8
  %v1885 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1884, ptr %state, ptr %BRANCH_TAKEN, i64 %v1882, i64 %v1883, ptr %NEXT_PC)
  store ptr %v1885, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877948, label %bb_5389877929

bb_5389877929:                                    ; preds = %bb_5389877924
  %v1886 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1886, ptr %PC, align 8
  %v1887 = add i64 %v1886, 3
  store i64 %v1887, ptr %NEXT_PC, align 8
  %v1888 = load i64, ptr %R9, align 8
  %v1889 = load ptr, ptr %MEMORY, align 8
  %v1890 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1889, ptr %state, ptr %RAX, i64 %v1888)
  store ptr %v1890, ptr %MEMORY, align 8
  %v1891 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1891, ptr %PC, align 8
  %v1892 = add i64 %v1891, 5
  store i64 %v1892, ptr %NEXT_PC, align 8
  %v1893 = load i64, ptr %RSP, align 8
  %v1894 = add i64 %v1893, 32
  %v1895 = load ptr, ptr %MEMORY, align 8
  %v1896 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v1895, ptr %state, ptr %RDX, i64 %v1894)
  store ptr %v1896, ptr %MEMORY, align 8
  %v1897 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1897, ptr %PC, align 8
  %v1898 = add i64 %v1897, 3
  store i64 %v1898, ptr %NEXT_PC, align 8
  %v1899 = load i64, ptr %R9, align 8
  %v1900 = load ptr, ptr %MEMORY, align 8
  %v1901 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1900, ptr %state, ptr %RCX, i64 %v1899)
  store ptr %v1901, ptr %MEMORY, align 8
  %v1902 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1902, ptr %PC, align 8
  %v1903 = add i64 %v1902, 3
  store i64 %v1903, ptr %NEXT_PC, align 8
  %v1904 = load i64, ptr %RAX, align 8
  %v1905 = add i64 %v1904, 24
  %v1906 = load i64, ptr %NEXT_PC, align 8
  %v1907 = load ptr, ptr %MEMORY, align 8
  %v1908 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v1907, ptr %state, i64 %v1905, ptr %NEXT_PC, i64 %v1906, ptr %RETURN_PC)
  store ptr %v1908, ptr %MEMORY, align 8
  %v1909 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1909, ptr %PC, align 8
  %v1910 = add i64 %v1909, 5
  store i64 %v1910, ptr %NEXT_PC, align 8
  %v1911 = load i64, ptr %RSP, align 8
  %v1912 = add i64 %v1911, 112
  %v1913 = load ptr, ptr %MEMORY, align 8
  %v1914 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1913, ptr %state, ptr %RCX, i64 %v1912)
  store ptr %v1914, ptr %MEMORY, align 8
  br label %bb_5389877948

bb_5389877948:                                    ; preds = %bb_5389877929, %bb_5389877924
  %v1915 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1915, ptr %PC, align 8
  %v1916 = add i64 %v1915, 3
  store i64 %v1916, ptr %NEXT_PC, align 8
  %v1917 = load i64, ptr %RCX, align 8
  %v1918 = load i64, ptr %RCX, align 8
  %v1919 = load ptr, ptr %MEMORY, align 8
  %v1920 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1919, ptr %state, i64 %v1917, i64 %v1918)
  store ptr %v1920, ptr %MEMORY, align 8
  %v1921 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1921, ptr %PC, align 8
  %v1922 = add i64 %v1921, 2
  store i64 %v1922, ptr %NEXT_PC, align 8
  %v1923 = load i64, ptr %NEXT_PC, align 8
  %v1924 = add i64 %v1923, 33
  %v1925 = load i64, ptr %NEXT_PC, align 8
  %v1926 = load ptr, ptr %MEMORY, align 8
  %v1927 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1926, ptr %state, ptr %BRANCH_TAKEN, i64 %v1924, i64 %v1925, ptr %NEXT_PC)
  store ptr %v1927, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877953

bb_5389877953:                                    ; preds = %bb_5389877948
  %v1928 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1928, ptr %PC, align 8
  %v1929 = add i64 %v1928, 6
  store i64 %v1929, ptr %NEXT_PC, align 8
  %v1930 = load i64, ptr %RDI, align 8
  %v1931 = add i64 %v1930, 256
  %v1932 = load i64, ptr %RDI, align 8
  %v1933 = add i64 %v1932, 256
  %v1934 = load ptr, ptr %MEMORY, align 8
  %v1935 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1934, ptr %state, i64 %v1931, i64 %v1933)
  store ptr %v1935, ptr %MEMORY, align 8
  %v1936 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1936, ptr %PC, align 8
  %v1937 = add i64 %v1936, 3
  store i64 %v1937, ptr %NEXT_PC, align 8
  %v1938 = load i64, ptr %RDI, align 8
  %v1939 = load ptr, ptr %MEMORY, align 8
  %v1940 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1939, ptr %state, ptr %R8, i64 %v1938)
  store ptr %v1940, ptr %MEMORY, align 8
  %v1941 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1941, ptr %PC, align 8
  %v1942 = add i64 %v1941, 2
  store i64 %v1942, ptr %NEXT_PC, align 8
  %v1943 = load i32, ptr %EBP, align 4
  %v1944 = zext i32 %v1943 to i64
  %v1945 = load ptr, ptr %MEMORY, align 8
  %v1946 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1945, ptr %state, ptr %RDX, i64 %v1944)
  store ptr %v1946, ptr %MEMORY, align 8
  %v1947 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1947, ptr %PC, align 8
  %v1948 = add i64 %v1947, 5
  store i64 %v1948, ptr %NEXT_PC, align 8
  %v1949 = load i64, ptr %NEXT_PC, align 8
  %v1950 = sub i64 %v1949, 321
  %v1951 = load i64, ptr %NEXT_PC, align 8
  %v1952 = load ptr, ptr %MEMORY, align 8
  %v1953 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1952, ptr %state, i64 %v1950, ptr %NEXT_PC, i64 %v1951, ptr %RETURN_PC)
  store ptr %v1953, ptr %MEMORY, align 8
  %v1954 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1954, ptr %PC, align 8
  %v1955 = add i64 %v1954, 5
  store i64 %v1955, ptr %NEXT_PC, align 8
  %v1956 = load i64, ptr %RSP, align 8
  %v1957 = add i64 %v1956, 112
  %v1958 = load ptr, ptr %MEMORY, align 8
  %v1959 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1958, ptr %state, ptr %RCX, i64 %v1957)
  store ptr %v1959, ptr %MEMORY, align 8
  %v1960 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1960, ptr %PC, align 8
  %v1961 = add i64 %v1960, 2
  store i64 %v1961, ptr %NEXT_PC, align 8
  %v1962 = load i32, ptr %EAX, align 4
  %v1963 = zext i32 %v1962 to i64
  %v1964 = load ptr, ptr %MEMORY, align 8
  %v1965 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1964, ptr %state, ptr %RBX, i64 %v1963)
  store ptr %v1965, ptr %MEMORY, align 8
  %v1966 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1966, ptr %PC, align 8
  %v1967 = add i64 %v1966, 3
  store i64 %v1967, ptr %NEXT_PC, align 8
  %v1968 = load i64, ptr %RCX, align 8
  %v1969 = load i64, ptr %RCX, align 8
  %v1970 = load ptr, ptr %MEMORY, align 8
  %v1971 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1970, ptr %state, i64 %v1968, i64 %v1969)
  store ptr %v1971, ptr %MEMORY, align 8
  %v1972 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1972, ptr %PC, align 8
  %v1973 = add i64 %v1972, 2
  store i64 %v1973, ptr %NEXT_PC, align 8
  %v1974 = load i64, ptr %NEXT_PC, align 8
  %v1975 = add i64 %v1974, 5
  %v1976 = load i64, ptr %NEXT_PC, align 8
  %v1977 = load ptr, ptr %MEMORY, align 8
  %v1978 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v1977, ptr %state, ptr %BRANCH_TAKEN, i64 %v1975, i64 %v1976, ptr %NEXT_PC)
  store ptr %v1978, ptr %MEMORY, align 8
  br i1 true, label %bb_5389877986, label %bb_5389877981

bb_5389877981:                                    ; preds = %bb_5389877953
  %v1979 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1979, ptr %PC, align 8
  %v1980 = add i64 %v1979, 5
  store i64 %v1980, ptr %NEXT_PC, align 8
  %v1981 = load i64, ptr %NEXT_PC, align 8
  %v1982 = sub i64 %v1981, 1282
  %v1983 = load i64, ptr %NEXT_PC, align 8
  %v1984 = load ptr, ptr %MEMORY, align 8
  %v1985 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v1984, ptr %state, i64 %v1982, ptr %NEXT_PC, i64 %v1983, ptr %RETURN_PC)
  store ptr %v1985, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389877986:                                    ; preds = %bb_5389877953, %bb_5389877948, %bb_5389877844
  %v1986 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1986, ptr %PC, align 8
  %v1987 = add i64 %v1986, 2
  store i64 %v1987, ptr %NEXT_PC, align 8
  %v1988 = load i32, ptr %EBX, align 4
  %v1989 = zext i32 %v1988 to i64
  %v1990 = load ptr, ptr %MEMORY, align 8
  %v1991 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1990, ptr %state, ptr %RAX, i64 %v1989)
  store ptr %v1991, ptr %MEMORY, align 8
  %v1992 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1992, ptr %PC, align 8
  %v1993 = add i64 %v1992, 5
  store i64 %v1993, ptr %NEXT_PC, align 8
  %v1994 = load i64, ptr %RSP, align 8
  %v1995 = add i64 %v1994, 104
  %v1996 = load ptr, ptr %MEMORY, align 8
  %v1997 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v1996, ptr %state, ptr %RBX, i64 %v1995)
  store ptr %v1997, ptr %MEMORY, align 8
  %v1998 = load i64, ptr %NEXT_PC, align 8
  store i64 %v1998, ptr %PC, align 8
  %v1999 = add i64 %v1998, 5
  store i64 %v1999, ptr %NEXT_PC, align 8
  %v2000 = load i64, ptr %RSP, align 8
  %v2001 = add i64 %v2000, 120
  %v2002 = load ptr, ptr %MEMORY, align 8
  %v2003 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2002, ptr %state, ptr %RBP, i64 %v2001)
  store ptr %v2003, ptr %MEMORY, align 8
  %v2004 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2004, ptr %PC, align 8
  %v2005 = add i64 %v2004, 4
  store i64 %v2005, ptr %NEXT_PC, align 8
  %v2006 = load i64, ptr %RSP, align 8
  %v2007 = load ptr, ptr %MEMORY, align 8
  %v2008 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2007, ptr %state, ptr %RSP, i64 %v2006, i64 80)
  store ptr %v2008, ptr %MEMORY, align 8
  %v2009 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2009, ptr %PC, align 8
  %v2010 = add i64 %v2009, 1
  store i64 %v2010, ptr %NEXT_PC, align 8
  %v2011 = load ptr, ptr %MEMORY, align 8
  %v2012 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2011, ptr %state, ptr %RDI)
  store ptr %v2012, ptr %MEMORY, align 8
  %v2013 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2013, ptr %PC, align 8
  %v2014 = add i64 %v2013, 1
  store i64 %v2014, ptr %NEXT_PC, align 8
  %v2015 = load ptr, ptr %MEMORY, align 8
  %v2016 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2015, ptr %state, ptr %NEXT_PC)
  store ptr %v2016, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878004:                                    ; preds = %bb_5389877686, %bb_5389877636
  %v2017 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2017, ptr %PC, align 8
  %v2018 = add i64 %v2017, 5
  store i64 %v2018, ptr %NEXT_PC, align 8
  %v2019 = load i64, ptr %RSP, align 8
  %v2020 = add i64 %v2019, 104
  %v2021 = load ptr, ptr %MEMORY, align 8
  %v2022 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2021, ptr %state, ptr %RBX, i64 %v2020)
  store ptr %v2022, ptr %MEMORY, align 8
  %v2023 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2023, ptr %PC, align 8
  %v2024 = add i64 %v2023, 2
  store i64 %v2024, ptr %NEXT_PC, align 8
  %v2025 = load i64, ptr %RAX, align 8
  %v2026 = load i32, ptr %EAX, align 4
  %v2027 = zext i32 %v2026 to i64
  %v2028 = load ptr, ptr %MEMORY, align 8
  %v2029 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2028, ptr %state, ptr %RAX, i64 %v2025, i64 %v2027)
  store ptr %v2029, ptr %MEMORY, align 8
  %v2030 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2030, ptr %PC, align 8
  %v2031 = add i64 %v2030, 5
  store i64 %v2031, ptr %NEXT_PC, align 8
  %v2032 = load i64, ptr %RSP, align 8
  %v2033 = add i64 %v2032, 120
  %v2034 = load ptr, ptr %MEMORY, align 8
  %v2035 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2034, ptr %state, ptr %RBP, i64 %v2033)
  store ptr %v2035, ptr %MEMORY, align 8
  %v2036 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2036, ptr %PC, align 8
  %v2037 = add i64 %v2036, 4
  store i64 %v2037, ptr %NEXT_PC, align 8
  %v2038 = load i64, ptr %RSP, align 8
  %v2039 = load ptr, ptr %MEMORY, align 8
  %v2040 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2039, ptr %state, ptr %RSP, i64 %v2038, i64 80)
  store ptr %v2040, ptr %MEMORY, align 8
  %v2041 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2041, ptr %PC, align 8
  %v2042 = add i64 %v2041, 1
  store i64 %v2042, ptr %NEXT_PC, align 8
  %v2043 = load ptr, ptr %MEMORY, align 8
  %v2044 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2043, ptr %state, ptr %RDI)
  store ptr %v2044, ptr %MEMORY, align 8
  %v2045 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2045, ptr %PC, align 8
  %v2046 = add i64 %v2045, 1
  store i64 %v2046, ptr %NEXT_PC, align 8
  %v2047 = load ptr, ptr %MEMORY, align 8
  %v2048 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2047, ptr %state, ptr %NEXT_PC)
  store ptr %v2048, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878022:                                    ; No predecessors!
  %v2049 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2049, ptr %PC, align 8
  %v2050 = add i64 %v2049, 1
  store i64 %v2050, ptr %NEXT_PC, align 8
  %v2051 = load ptr, ptr %MEMORY, align 8
  %v2052 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2051, ptr %state, ptr undef)
  store ptr %v2052, ptr %MEMORY, align 8
  %v2053 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2053, ptr %PC, align 8
  %v2054 = add i64 %v2053, 1
  store i64 %v2054, ptr %NEXT_PC, align 8
  %v2055 = load ptr, ptr %MEMORY, align 8
  %v2056 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2055, ptr %state, ptr undef)
  store ptr %v2056, ptr %MEMORY, align 8
  %v2057 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2057, ptr %PC, align 8
  %v2058 = add i64 %v2057, 1
  store i64 %v2058, ptr %NEXT_PC, align 8
  %v2059 = load ptr, ptr %MEMORY, align 8
  %v2060 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2059, ptr %state, ptr undef)
  store ptr %v2060, ptr %MEMORY, align 8
  %v2061 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2061, ptr %PC, align 8
  %v2062 = add i64 %v2061, 1
  store i64 %v2062, ptr %NEXT_PC, align 8
  %v2063 = load ptr, ptr %MEMORY, align 8
  %v2064 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2063, ptr %state, ptr undef)
  store ptr %v2064, ptr %MEMORY, align 8
  %v2065 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2065, ptr %PC, align 8
  %v2066 = add i64 %v2065, 1
  store i64 %v2066, ptr %NEXT_PC, align 8
  %v2067 = load ptr, ptr %MEMORY, align 8
  %v2068 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2067, ptr %state, ptr undef)
  store ptr %v2068, ptr %MEMORY, align 8
  %v2069 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2069, ptr %PC, align 8
  %v2070 = add i64 %v2069, 1
  store i64 %v2070, ptr %NEXT_PC, align 8
  %v2071 = load ptr, ptr %MEMORY, align 8
  %v2072 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2071, ptr %state, ptr undef)
  store ptr %v2072, ptr %MEMORY, align 8
  %v2073 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2073, ptr %PC, align 8
  %v2074 = add i64 %v2073, 1
  store i64 %v2074, ptr %NEXT_PC, align 8
  %v2075 = load ptr, ptr %MEMORY, align 8
  %v2076 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2075, ptr %state, ptr undef)
  store ptr %v2076, ptr %MEMORY, align 8
  %v2077 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2077, ptr %PC, align 8
  %v2078 = add i64 %v2077, 1
  store i64 %v2078, ptr %NEXT_PC, align 8
  %v2079 = load ptr, ptr %MEMORY, align 8
  %v2080 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2079, ptr %state, ptr undef)
  store ptr %v2080, ptr %MEMORY, align 8
  %v2081 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2081, ptr %PC, align 8
  %v2082 = add i64 %v2081, 1
  store i64 %v2082, ptr %NEXT_PC, align 8
  %v2083 = load ptr, ptr %MEMORY, align 8
  %v2084 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2083, ptr %state, ptr undef)
  store ptr %v2084, ptr %MEMORY, align 8
  %v2085 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2085, ptr %PC, align 8
  %v2086 = add i64 %v2085, 1
  store i64 %v2086, ptr %NEXT_PC, align 8
  %v2087 = load ptr, ptr %MEMORY, align 8
  %v2088 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2087, ptr %state, ptr undef)
  store ptr %v2088, ptr %MEMORY, align 8
  %v2089 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2089, ptr %PC, align 8
  %v2090 = add i64 %v2089, 5
  store i64 %v2090, ptr %NEXT_PC, align 8
  %v2091 = load i64, ptr %RSP, align 8
  %v2092 = add i64 %v2091, 8
  %v2093 = load i64, ptr %RBX, align 8
  %v2094 = load ptr, ptr %MEMORY, align 8
  %v2095 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2094, ptr %state, i64 %v2092, i64 %v2093)
  store ptr %v2095, ptr %MEMORY, align 8
  %v2096 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2096, ptr %PC, align 8
  %v2097 = add i64 %v2096, 5
  store i64 %v2097, ptr %NEXT_PC, align 8
  %v2098 = load i64, ptr %RSP, align 8
  %v2099 = add i64 %v2098, 16
  %v2100 = load i64, ptr %RSI, align 8
  %v2101 = load ptr, ptr %MEMORY, align 8
  %v2102 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2101, ptr %state, i64 %v2099, i64 %v2100)
  store ptr %v2102, ptr %MEMORY, align 8
  %v2103 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2103, ptr %PC, align 8
  %v2104 = add i64 %v2103, 1
  store i64 %v2104, ptr %NEXT_PC, align 8
  %v2105 = load i64, ptr %RDI, align 8
  %v2106 = load ptr, ptr %MEMORY, align 8
  %v2107 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2106, ptr %state, i64 %v2105)
  store ptr %v2107, ptr %MEMORY, align 8
  %v2108 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2108, ptr %PC, align 8
  %v2109 = add i64 %v2108, 4
  store i64 %v2109, ptr %NEXT_PC, align 8
  %v2110 = load i64, ptr %RSP, align 8
  %v2111 = load ptr, ptr %MEMORY, align 8
  %v2112 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2111, ptr %state, ptr %RSP, i64 %v2110, i64 32)
  store ptr %v2112, ptr %MEMORY, align 8
  %v2113 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2113, ptr %PC, align 8
  %v2114 = add i64 %v2113, 3
  store i64 %v2114, ptr %NEXT_PC, align 8
  %v2115 = load i64, ptr %RCX, align 8
  %v2116 = add i64 %v2115, 24
  %v2117 = load ptr, ptr %MEMORY, align 8
  %v2118 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2117, ptr %state, ptr %RDX, i64 %v2116)
  store ptr %v2118, ptr %MEMORY, align 8
  %v2119 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2119, ptr %PC, align 8
  %v2120 = add i64 %v2119, 2
  store i64 %v2120, ptr %NEXT_PC, align 8
  %v2121 = load i64, ptr %RSI, align 8
  %v2122 = load i32, ptr %ESI, align 4
  %v2123 = zext i32 %v2122 to i64
  %v2124 = load ptr, ptr %MEMORY, align 8
  %v2125 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2124, ptr %state, ptr %RSI, i64 %v2121, i64 %v2123)
  store ptr %v2125, ptr %MEMORY, align 8
  %v2126 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2126, ptr %PC, align 8
  %v2127 = add i64 %v2126, 3
  store i64 %v2127, ptr %NEXT_PC, align 8
  %v2128 = load i64, ptr %RCX, align 8
  %v2129 = load ptr, ptr %MEMORY, align 8
  %v2130 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2129, ptr %state, ptr %RDI, i64 %v2128)
  store ptr %v2130, ptr %MEMORY, align 8
  %v2131 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2131, ptr %PC, align 8
  %v2132 = add i64 %v2131, 2
  store i64 %v2132, ptr %NEXT_PC, align 8
  %v2133 = load i32, ptr %EDX, align 4
  %v2134 = zext i32 %v2133 to i64
  %v2135 = load i32, ptr %EDX, align 4
  %v2136 = zext i32 %v2135 to i64
  %v2137 = load ptr, ptr %MEMORY, align 8
  %v2138 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2137, ptr %state, i64 %v2134, i64 %v2136)
  store ptr %v2138, ptr %MEMORY, align 8
  %v2139 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2139, ptr %PC, align 8
  %v2140 = add i64 %v2139, 2
  store i64 %v2140, ptr %NEXT_PC, align 8
  %v2141 = load i64, ptr %NEXT_PC, align 8
  %v2142 = add i64 %v2141, 23
  %v2143 = load i64, ptr %NEXT_PC, align 8
  %v2144 = load ptr, ptr %MEMORY, align 8
  %v2145 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2144, ptr %state, ptr %BRANCH_TAKEN, i64 %v2142, i64 %v2143, ptr %NEXT_PC)
  store ptr %v2145, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878082, label %bb_5389878059

bb_5389878059:                                    ; preds = %bb_5389878022
  %v2146 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2146, ptr %PC, align 8
  %v2147 = add i64 %v2146, 4
  store i64 %v2147, ptr %NEXT_PC, align 8
  %v2148 = load i64, ptr %RCX, align 8
  %v2149 = add i64 %v2148, 16
  %v2150 = load ptr, ptr %MEMORY, align 8
  %v2151 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2150, ptr %state, ptr %RCX, i64 %v2149)
  store ptr %v2151, ptr %MEMORY, align 8
  %v2152 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2152, ptr %PC, align 8
  %v2153 = add i64 %v2152, 3
  store i64 %v2153, ptr %NEXT_PC, align 8
  %v2154 = load i64, ptr %RCX, align 8
  %v2155 = load i64, ptr %RCX, align 8
  %v2156 = load ptr, ptr %MEMORY, align 8
  %v2157 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2156, ptr %state, i64 %v2154, i64 %v2155)
  store ptr %v2157, ptr %MEMORY, align 8
  %v2158 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2158, ptr %PC, align 8
  %v2159 = add i64 %v2158, 2
  store i64 %v2159, ptr %NEXT_PC, align 8
  %v2160 = load i64, ptr %NEXT_PC, align 8
  %v2161 = add i64 %v2160, 9
  %v2162 = load i64, ptr %NEXT_PC, align 8
  %v2163 = load ptr, ptr %MEMORY, align 8
  %v2164 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2163, ptr %state, ptr %BRANCH_TAKEN, i64 %v2161, i64 %v2162, ptr %NEXT_PC)
  store ptr %v2164, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878077, label %bb_5389878068

bb_5389878068:                                    ; preds = %bb_5389878059
  %v2165 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2165, ptr %PC, align 8
  %v2166 = add i64 %v2165, 5
  store i64 %v2166, ptr %NEXT_PC, align 8
  %v2167 = load i64, ptr %NEXT_PC, align 8
  %v2168 = sub i64 %v2167, 1157081
  %v2169 = load i64, ptr %NEXT_PC, align 8
  %v2170 = load ptr, ptr %MEMORY, align 8
  %v2171 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2170, ptr %state, i64 %v2168, ptr %NEXT_PC, i64 %v2169, ptr %RETURN_PC)
  store ptr %v2171, ptr %MEMORY, align 8
  %v2172 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2172, ptr %PC, align 8
  %v2173 = add i64 %v2172, 4
  store i64 %v2173, ptr %NEXT_PC, align 8
  %v2174 = load i64, ptr %RDI, align 8
  %v2175 = add i64 %v2174, 16
  %v2176 = load i64, ptr %RSI, align 8
  %v2177 = load ptr, ptr %MEMORY, align 8
  %v2178 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2177, ptr %state, i64 %v2175, i64 %v2176)
  store ptr %v2178, ptr %MEMORY, align 8
  br label %bb_5389878077

bb_5389878077:                                    ; preds = %bb_5389878068, %bb_5389878059
  %v2179 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2179, ptr %PC, align 8
  %v2180 = add i64 %v2179, 3
  store i64 %v2180, ptr %NEXT_PC, align 8
  %v2181 = load i64, ptr %RDI, align 8
  %v2182 = add i64 %v2181, 28
  %v2183 = load i32, ptr %ESI, align 4
  %v2184 = zext i32 %v2183 to i64
  %v2185 = load ptr, ptr %MEMORY, align 8
  %v2186 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2185, ptr %state, i64 %v2182, i64 %v2184)
  store ptr %v2186, ptr %MEMORY, align 8
  %v2187 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2187, ptr %PC, align 8
  %v2188 = add i64 %v2187, 2
  store i64 %v2188, ptr %NEXT_PC, align 8
  %v2189 = load i64, ptr %NEXT_PC, align 8
  %v2190 = add i64 %v2189, 20
  %v2191 = load ptr, ptr %MEMORY, align 8
  %v2192 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2191, ptr %state, i64 %v2190, ptr %NEXT_PC)
  store ptr %v2192, ptr %MEMORY, align 8
  br label %bb_5389878102

bb_5389878082:                                    ; preds = %bb_5389878022
  %v2193 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2193, ptr %PC, align 8
  %v2194 = add i64 %v2193, 3
  store i64 %v2194, ptr %NEXT_PC, align 8
  %v2195 = load i64, ptr %RCX, align 8
  %v2196 = add i64 %v2195, 28
  %v2197 = load i32, ptr %EDX, align 4
  %v2198 = zext i32 %v2197 to i64
  %v2199 = load ptr, ptr %MEMORY, align 8
  %v2200 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2199, ptr %state, i64 %v2196, i64 %v2198)
  store ptr %v2200, ptr %MEMORY, align 8
  %v2201 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2201, ptr %PC, align 8
  %v2202 = add i64 %v2201, 2
  store i64 %v2202, ptr %NEXT_PC, align 8
  %v2203 = load i64, ptr %NEXT_PC, align 8
  %v2204 = add i64 %v2203, 15
  %v2205 = load i64, ptr %NEXT_PC, align 8
  %v2206 = load ptr, ptr %MEMORY, align 8
  %v2207 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2206, ptr %state, ptr %BRANCH_TAKEN, i64 %v2204, i64 %v2205, ptr %NEXT_PC)
  store ptr %v2207, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878102, label %bb_5389878087

bb_5389878087:                                    ; preds = %bb_5389878082
  %v2208 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2208, ptr %PC, align 8
  %v2209 = add i64 %v2208, 6
  store i64 %v2209, ptr %NEXT_PC, align 8
  %v2210 = load ptr, ptr %MEMORY, align 8
  %v2211 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2210, ptr %state, ptr %R8, i64 134217736)
  store ptr %v2211, ptr %MEMORY, align 8
  %v2212 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2212, ptr %PC, align 8
  %v2213 = add i64 %v2212, 4
  store i64 %v2213, ptr %NEXT_PC, align 8
  %v2214 = load i64, ptr %RCX, align 8
  %v2215 = load ptr, ptr %MEMORY, align 8
  %v2216 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2215, ptr %state, ptr %RCX, i64 %v2214, i64 16)
  store ptr %v2216, ptr %MEMORY, align 8
  %v2217 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2217, ptr %PC, align 8
  %v2218 = add i64 %v2217, 5
  store i64 %v2218, ptr %NEXT_PC, align 8
  %v2219 = load i64, ptr %NEXT_PC, align 8
  %v2220 = sub i64 %v2219, 644470
  %v2221 = load i64, ptr %NEXT_PC, align 8
  %v2222 = load ptr, ptr %MEMORY, align 8
  %v2223 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2222, ptr %state, i64 %v2220, ptr %NEXT_PC, i64 %v2221, ptr %RETURN_PC)
  store ptr %v2223, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878102:                                    ; preds = %bb_5389878082, %bb_5389878077
  %v2224 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2224, ptr %PC, align 8
  %v2225 = add i64 %v2224, 3
  store i64 %v2225, ptr %NEXT_PC, align 8
  %v2226 = load i64, ptr %RDI, align 8
  %v2227 = add i64 %v2226, 40
  %v2228 = load ptr, ptr %MEMORY, align 8
  %v2229 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2228, ptr %state, ptr %RDX, i64 %v2227)
  store ptr %v2229, ptr %MEMORY, align 8
  %v2230 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2230, ptr %PC, align 8
  %v2231 = add i64 %v2230, 2
  store i64 %v2231, ptr %NEXT_PC, align 8
  %v2232 = load i32, ptr %EDX, align 4
  %v2233 = zext i32 %v2232 to i64
  %v2234 = load i32, ptr %EDX, align 4
  %v2235 = zext i32 %v2234 to i64
  %v2236 = load ptr, ptr %MEMORY, align 8
  %v2237 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2236, ptr %state, i64 %v2233, i64 %v2235)
  store ptr %v2237, ptr %MEMORY, align 8
  %v2238 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2238, ptr %PC, align 8
  %v2239 = add i64 %v2238, 2
  store i64 %v2239, ptr %NEXT_PC, align 8
  %v2240 = load i64, ptr %NEXT_PC, align 8
  %v2241 = add i64 %v2240, 37
  %v2242 = load i64, ptr %NEXT_PC, align 8
  %v2243 = load ptr, ptr %MEMORY, align 8
  %v2244 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2243, ptr %state, ptr %BRANCH_TAKEN, i64 %v2241, i64 %v2242, ptr %NEXT_PC)
  store ptr %v2244, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878146, label %bb_5389878109

bb_5389878109:                                    ; preds = %bb_5389878102
  %v2245 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2245, ptr %PC, align 8
  %v2246 = add i64 %v2245, 4
  store i64 %v2246, ptr %NEXT_PC, align 8
  %v2247 = load i64, ptr %RDI, align 8
  %v2248 = add i64 %v2247, 32
  %v2249 = load ptr, ptr %MEMORY, align 8
  %v2250 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2249, ptr %state, ptr %RCX, i64 %v2248)
  store ptr %v2250, ptr %MEMORY, align 8
  %v2251 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2251, ptr %PC, align 8
  %v2252 = add i64 %v2251, 3
  store i64 %v2252, ptr %NEXT_PC, align 8
  %v2253 = load i64, ptr %RCX, align 8
  %v2254 = load i64, ptr %RCX, align 8
  %v2255 = load ptr, ptr %MEMORY, align 8
  %v2256 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2255, ptr %state, i64 %v2253, i64 %v2254)
  store ptr %v2256, ptr %MEMORY, align 8
  %v2257 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2257, ptr %PC, align 8
  %v2258 = add i64 %v2257, 2
  store i64 %v2258, ptr %NEXT_PC, align 8
  %v2259 = load i64, ptr %NEXT_PC, align 8
  %v2260 = add i64 %v2259, 9
  %v2261 = load i64, ptr %NEXT_PC, align 8
  %v2262 = load ptr, ptr %MEMORY, align 8
  %v2263 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2262, ptr %state, ptr %BRANCH_TAKEN, i64 %v2260, i64 %v2261, ptr %NEXT_PC)
  store ptr %v2263, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878127, label %bb_5389878118

bb_5389878118:                                    ; preds = %bb_5389878109
  %v2264 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2264, ptr %PC, align 8
  %v2265 = add i64 %v2264, 5
  store i64 %v2265, ptr %NEXT_PC, align 8
  %v2266 = load i64, ptr %NEXT_PC, align 8
  %v2267 = sub i64 %v2266, 1157131
  %v2268 = load i64, ptr %NEXT_PC, align 8
  %v2269 = load ptr, ptr %MEMORY, align 8
  %v2270 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2269, ptr %state, i64 %v2267, ptr %NEXT_PC, i64 %v2268, ptr %RETURN_PC)
  store ptr %v2270, ptr %MEMORY, align 8
  %v2271 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2271, ptr %PC, align 8
  %v2272 = add i64 %v2271, 4
  store i64 %v2272, ptr %NEXT_PC, align 8
  %v2273 = load i64, ptr %RDI, align 8
  %v2274 = add i64 %v2273, 32
  %v2275 = load i64, ptr %RSI, align 8
  %v2276 = load ptr, ptr %MEMORY, align 8
  %v2277 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2276, ptr %state, i64 %v2274, i64 %v2275)
  store ptr %v2277, ptr %MEMORY, align 8
  br label %bb_5389878127

bb_5389878127:                                    ; preds = %bb_5389878118, %bb_5389878109
  %v2278 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2278, ptr %PC, align 8
  %v2279 = add i64 %v2278, 3
  store i64 %v2279, ptr %NEXT_PC, align 8
  %v2280 = load i64, ptr %RDI, align 8
  %v2281 = add i64 %v2280, 44
  %v2282 = load i32, ptr %ESI, align 4
  %v2283 = zext i32 %v2282 to i64
  %v2284 = load ptr, ptr %MEMORY, align 8
  %v2285 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2284, ptr %state, i64 %v2281, i64 %v2283)
  store ptr %v2285, ptr %MEMORY, align 8
  %v2286 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2286, ptr %PC, align 8
  %v2287 = add i64 %v2286, 5
  store i64 %v2287, ptr %NEXT_PC, align 8
  %v2288 = load i64, ptr %RSP, align 8
  %v2289 = add i64 %v2288, 48
  %v2290 = load ptr, ptr %MEMORY, align 8
  %v2291 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2290, ptr %state, ptr %RBX, i64 %v2289)
  store ptr %v2291, ptr %MEMORY, align 8
  %v2292 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2292, ptr %PC, align 8
  %v2293 = add i64 %v2292, 5
  store i64 %v2293, ptr %NEXT_PC, align 8
  %v2294 = load i64, ptr %RSP, align 8
  %v2295 = add i64 %v2294, 56
  %v2296 = load ptr, ptr %MEMORY, align 8
  %v2297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2296, ptr %state, ptr %RSI, i64 %v2295)
  store ptr %v2297, ptr %MEMORY, align 8
  %v2298 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2298, ptr %PC, align 8
  %v2299 = add i64 %v2298, 4
  store i64 %v2299, ptr %NEXT_PC, align 8
  %v2300 = load i64, ptr %RSP, align 8
  %v2301 = load ptr, ptr %MEMORY, align 8
  %v2302 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2301, ptr %state, ptr %RSP, i64 %v2300, i64 32)
  store ptr %v2302, ptr %MEMORY, align 8
  %v2303 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2303, ptr %PC, align 8
  %v2304 = add i64 %v2303, 1
  store i64 %v2304, ptr %NEXT_PC, align 8
  %v2305 = load ptr, ptr %MEMORY, align 8
  %v2306 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2305, ptr %state, ptr %RDI)
  store ptr %v2306, ptr %MEMORY, align 8
  %v2307 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2307, ptr %PC, align 8
  %v2308 = add i64 %v2307, 1
  store i64 %v2308, ptr %NEXT_PC, align 8
  %v2309 = load ptr, ptr %MEMORY, align 8
  %v2310 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2309, ptr %state, ptr %NEXT_PC)
  store ptr %v2310, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878146:                                    ; preds = %bb_5389878102
  %v2311 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2311, ptr %PC, align 8
  %v2312 = add i64 %v2311, 3
  store i64 %v2312, ptr %NEXT_PC, align 8
  %v2313 = load i64, ptr %RDI, align 8
  %v2314 = add i64 %v2313, 44
  %v2315 = load i32, ptr %EDX, align 4
  %v2316 = zext i32 %v2315 to i64
  %v2317 = load ptr, ptr %MEMORY, align 8
  %v2318 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2317, ptr %state, i64 %v2314, i64 %v2316)
  store ptr %v2318, ptr %MEMORY, align 8
  %v2319 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2319, ptr %PC, align 8
  %v2320 = add i64 %v2319, 2
  store i64 %v2320, ptr %NEXT_PC, align 8
  %v2321 = load i64, ptr %NEXT_PC, align 8
  %v2322 = add i64 %v2321, 15
  %v2323 = load i64, ptr %NEXT_PC, align 8
  %v2324 = load ptr, ptr %MEMORY, align 8
  %v2325 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2324, ptr %state, ptr %BRANCH_TAKEN, i64 %v2322, i64 %v2323, ptr %NEXT_PC)
  store ptr %v2325, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878166, label %bb_5389878151

bb_5389878151:                                    ; preds = %bb_5389878146
  %v2326 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2326, ptr %PC, align 8
  %v2327 = add i64 %v2326, 6
  store i64 %v2327, ptr %NEXT_PC, align 8
  %v2328 = load ptr, ptr %MEMORY, align 8
  %v2329 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2328, ptr %state, ptr %R8, i64 134217784)
  store ptr %v2329, ptr %MEMORY, align 8
  %v2330 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2330, ptr %PC, align 8
  %v2331 = add i64 %v2330, 4
  store i64 %v2331, ptr %NEXT_PC, align 8
  %v2332 = load i64, ptr %RDI, align 8
  %v2333 = add i64 %v2332, 32
  %v2334 = load ptr, ptr %MEMORY, align 8
  %v2335 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v2334, ptr %state, ptr %RCX, i64 %v2333)
  store ptr %v2335, ptr %MEMORY, align 8
  %v2336 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2336, ptr %PC, align 8
  %v2337 = add i64 %v2336, 5
  store i64 %v2337, ptr %NEXT_PC, align 8
  %v2338 = load i64, ptr %NEXT_PC, align 8
  %v2339 = sub i64 %v2338, 644534
  %v2340 = load i64, ptr %NEXT_PC, align 8
  %v2341 = load ptr, ptr %MEMORY, align 8
  %v2342 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2341, ptr %state, i64 %v2339, ptr %NEXT_PC, i64 %v2340, ptr %RETURN_PC)
  store ptr %v2342, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878166:                                    ; preds = %bb_5389878146
  %v2343 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2343, ptr %PC, align 8
  %v2344 = add i64 %v2343, 5
  store i64 %v2344, ptr %NEXT_PC, align 8
  %v2345 = load i64, ptr %RSP, align 8
  %v2346 = add i64 %v2345, 48
  %v2347 = load ptr, ptr %MEMORY, align 8
  %v2348 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2347, ptr %state, ptr %RBX, i64 %v2346)
  store ptr %v2348, ptr %MEMORY, align 8
  %v2349 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2349, ptr %PC, align 8
  %v2350 = add i64 %v2349, 5
  store i64 %v2350, ptr %NEXT_PC, align 8
  %v2351 = load i64, ptr %RSP, align 8
  %v2352 = add i64 %v2351, 56
  %v2353 = load ptr, ptr %MEMORY, align 8
  %v2354 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2353, ptr %state, ptr %RSI, i64 %v2352)
  store ptr %v2354, ptr %MEMORY, align 8
  %v2355 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2355, ptr %PC, align 8
  %v2356 = add i64 %v2355, 4
  store i64 %v2356, ptr %NEXT_PC, align 8
  %v2357 = load i64, ptr %RSP, align 8
  %v2358 = load ptr, ptr %MEMORY, align 8
  %v2359 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2358, ptr %state, ptr %RSP, i64 %v2357, i64 32)
  store ptr %v2359, ptr %MEMORY, align 8
  %v2360 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2360, ptr %PC, align 8
  %v2361 = add i64 %v2360, 1
  store i64 %v2361, ptr %NEXT_PC, align 8
  %v2362 = load ptr, ptr %MEMORY, align 8
  %v2363 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v2362, ptr %state, ptr %RDI)
  store ptr %v2363, ptr %MEMORY, align 8
  %v2364 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2364, ptr %PC, align 8
  %v2365 = add i64 %v2364, 1
  store i64 %v2365, ptr %NEXT_PC, align 8
  %v2366 = load ptr, ptr %MEMORY, align 8
  %v2367 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2366, ptr %state, ptr %NEXT_PC)
  store ptr %v2367, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878182:                                    ; No predecessors!
  %v2368 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2368, ptr %PC, align 8
  %v2369 = add i64 %v2368, 1
  store i64 %v2369, ptr %NEXT_PC, align 8
  %v2370 = load ptr, ptr %MEMORY, align 8
  %v2371 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2370, ptr %state, ptr undef)
  store ptr %v2371, ptr %MEMORY, align 8
  %v2372 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2372, ptr %PC, align 8
  %v2373 = add i64 %v2372, 1
  store i64 %v2373, ptr %NEXT_PC, align 8
  %v2374 = load ptr, ptr %MEMORY, align 8
  %v2375 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2374, ptr %state, ptr undef)
  store ptr %v2375, ptr %MEMORY, align 8
  %v2376 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2376, ptr %PC, align 8
  %v2377 = add i64 %v2376, 1
  store i64 %v2377, ptr %NEXT_PC, align 8
  %v2378 = load ptr, ptr %MEMORY, align 8
  %v2379 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2378, ptr %state, ptr undef)
  store ptr %v2379, ptr %MEMORY, align 8
  %v2380 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2380, ptr %PC, align 8
  %v2381 = add i64 %v2380, 1
  store i64 %v2381, ptr %NEXT_PC, align 8
  %v2382 = load ptr, ptr %MEMORY, align 8
  %v2383 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2382, ptr %state, ptr undef)
  store ptr %v2383, ptr %MEMORY, align 8
  %v2384 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2384, ptr %PC, align 8
  %v2385 = add i64 %v2384, 1
  store i64 %v2385, ptr %NEXT_PC, align 8
  %v2386 = load ptr, ptr %MEMORY, align 8
  %v2387 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2386, ptr %state, ptr undef)
  store ptr %v2387, ptr %MEMORY, align 8
  %v2388 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2388, ptr %PC, align 8
  %v2389 = add i64 %v2388, 1
  store i64 %v2389, ptr %NEXT_PC, align 8
  %v2390 = load ptr, ptr %MEMORY, align 8
  %v2391 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2390, ptr %state, ptr undef)
  store ptr %v2391, ptr %MEMORY, align 8
  %v2392 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2392, ptr %PC, align 8
  %v2393 = add i64 %v2392, 1
  store i64 %v2393, ptr %NEXT_PC, align 8
  %v2394 = load ptr, ptr %MEMORY, align 8
  %v2395 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2394, ptr %state, ptr undef)
  store ptr %v2395, ptr %MEMORY, align 8
  %v2396 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2396, ptr %PC, align 8
  %v2397 = add i64 %v2396, 1
  store i64 %v2397, ptr %NEXT_PC, align 8
  %v2398 = load ptr, ptr %MEMORY, align 8
  %v2399 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2398, ptr %state, ptr undef)
  store ptr %v2399, ptr %MEMORY, align 8
  %v2400 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2400, ptr %PC, align 8
  %v2401 = add i64 %v2400, 1
  store i64 %v2401, ptr %NEXT_PC, align 8
  %v2402 = load ptr, ptr %MEMORY, align 8
  %v2403 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2402, ptr %state, ptr undef)
  store ptr %v2403, ptr %MEMORY, align 8
  %v2404 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2404, ptr %PC, align 8
  %v2405 = add i64 %v2404, 1
  store i64 %v2405, ptr %NEXT_PC, align 8
  %v2406 = load ptr, ptr %MEMORY, align 8
  %v2407 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2406, ptr %state, ptr undef)
  store ptr %v2407, ptr %MEMORY, align 8
  %v2408 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2408, ptr %PC, align 8
  %v2409 = add i64 %v2408, 4
  store i64 %v2409, ptr %NEXT_PC, align 8
  %v2410 = load i64, ptr %RCX, align 8
  %v2411 = add i64 %v2410, 8
  %v2412 = load ptr, ptr %MEMORY, align 8
  %v2413 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2412, ptr %state, ptr %RAX, i64 %v2411)
  store ptr %v2413, ptr %MEMORY, align 8
  %v2414 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2414, ptr %PC, align 8
  %v2415 = add i64 %v2414, 3
  store i64 %v2415, ptr %NEXT_PC, align 8
  %v2416 = load i64, ptr %RDX, align 8
  %v2417 = load i64, ptr %RAX, align 8
  %v2418 = load ptr, ptr %MEMORY, align 8
  %v2419 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2418, ptr %state, i64 %v2416, i64 %v2417)
  store ptr %v2419, ptr %MEMORY, align 8
  %v2420 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2420, ptr %PC, align 8
  %v2421 = add i64 %v2420, 3
  store i64 %v2421, ptr %NEXT_PC, align 8
  %v2422 = load i64, ptr %RAX, align 8
  %v2423 = load i64, ptr %RAX, align 8
  %v2424 = load ptr, ptr %MEMORY, align 8
  %v2425 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2424, ptr %state, i64 %v2422, i64 %v2423)
  store ptr %v2425, ptr %MEMORY, align 8
  %v2426 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2426, ptr %PC, align 8
  %v2427 = add i64 %v2426, 2
  store i64 %v2427, ptr %NEXT_PC, align 8
  %v2428 = load i64, ptr %NEXT_PC, align 8
  %v2429 = add i64 %v2428, 8
  %v2430 = load i64, ptr %NEXT_PC, align 8
  %v2431 = load ptr, ptr %MEMORY, align 8
  %v2432 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2431, ptr %state, ptr %BRANCH_TAKEN, i64 %v2429, i64 %v2430, ptr %NEXT_PC)
  store ptr %v2432, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878212, label %bb_5389878204

bb_5389878204:                                    ; preds = %bb_5389878182
  %v2433 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2433, ptr %PC, align 8
  %v2434 = add i64 %v2433, 2
  store i64 %v2434, ptr %NEXT_PC, align 8
  %v2435 = load i64, ptr %RAX, align 8
  %v2436 = load i64, ptr %RAX, align 8
  %v2437 = load ptr, ptr %MEMORY, align 8
  %v2438 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2437, ptr %state, i64 %v2435, i64 %v2436)
  store ptr %v2438, ptr %MEMORY, align 8
  %v2439 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2439, ptr %PC, align 8
  %v2440 = add i64 %v2439, 4
  store i64 %v2440, ptr %NEXT_PC, align 8
  %v2441 = load i64, ptr %RAX, align 8
  %v2442 = add i64 %v2441, 48
  %v2443 = load ptr, ptr %MEMORY, align 8
  %v2444 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2443, ptr %state, ptr %RAX, i64 %v2442)
  store ptr %v2444, ptr %MEMORY, align 8
  %v2445 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2445, ptr %PC, align 8
  %v2446 = add i64 %v2445, 2
  store i64 %v2446, ptr %NEXT_PC, align 8
  %v2447 = load i64, ptr %RAX, align 8
  %v2448 = load i64, ptr %RAX, align 8
  %v2449 = load ptr, ptr %MEMORY, align 8
  %v2450 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2449, ptr %state, i64 %v2447, i64 %v2448)
  store ptr %v2450, ptr %MEMORY, align 8
  br label %bb_5389878212

bb_5389878212:                                    ; preds = %bb_5389878204, %bb_5389878182
  %v2451 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2451, ptr %PC, align 8
  %v2452 = add i64 %v2451, 3
  store i64 %v2452, ptr %NEXT_PC, align 8
  %v2453 = load i64, ptr %RDX, align 8
  %v2454 = load ptr, ptr %MEMORY, align 8
  %v2455 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2454, ptr %state, ptr %RAX, i64 %v2453)
  store ptr %v2455, ptr %MEMORY, align 8
  %v2456 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2456, ptr %PC, align 8
  %v2457 = add i64 %v2456, 1
  store i64 %v2457, ptr %NEXT_PC, align 8
  %v2458 = load ptr, ptr %MEMORY, align 8
  %v2459 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v2458, ptr %state, ptr %NEXT_PC)
  store ptr %v2459, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878216:                                    ; No predecessors!
  %v2460 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2460, ptr %PC, align 8
  %v2461 = add i64 %v2460, 1
  store i64 %v2461, ptr %NEXT_PC, align 8
  %v2462 = load ptr, ptr %MEMORY, align 8
  %v2463 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2462, ptr %state, ptr undef)
  store ptr %v2463, ptr %MEMORY, align 8
  %v2464 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2464, ptr %PC, align 8
  %v2465 = add i64 %v2464, 1
  store i64 %v2465, ptr %NEXT_PC, align 8
  %v2466 = load ptr, ptr %MEMORY, align 8
  %v2467 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2466, ptr %state, ptr undef)
  store ptr %v2467, ptr %MEMORY, align 8
  %v2468 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2468, ptr %PC, align 8
  %v2469 = add i64 %v2468, 1
  store i64 %v2469, ptr %NEXT_PC, align 8
  %v2470 = load ptr, ptr %MEMORY, align 8
  %v2471 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2470, ptr %state, ptr undef)
  store ptr %v2471, ptr %MEMORY, align 8
  %v2472 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2472, ptr %PC, align 8
  %v2473 = add i64 %v2472, 1
  store i64 %v2473, ptr %NEXT_PC, align 8
  %v2474 = load ptr, ptr %MEMORY, align 8
  %v2475 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2474, ptr %state, ptr undef)
  store ptr %v2475, ptr %MEMORY, align 8
  %v2476 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2476, ptr %PC, align 8
  %v2477 = add i64 %v2476, 1
  store i64 %v2477, ptr %NEXT_PC, align 8
  %v2478 = load ptr, ptr %MEMORY, align 8
  %v2479 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2478, ptr %state, ptr undef)
  store ptr %v2479, ptr %MEMORY, align 8
  %v2480 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2480, ptr %PC, align 8
  %v2481 = add i64 %v2480, 1
  store i64 %v2481, ptr %NEXT_PC, align 8
  %v2482 = load ptr, ptr %MEMORY, align 8
  %v2483 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2482, ptr %state, ptr undef)
  store ptr %v2483, ptr %MEMORY, align 8
  %v2484 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2484, ptr %PC, align 8
  %v2485 = add i64 %v2484, 1
  store i64 %v2485, ptr %NEXT_PC, align 8
  %v2486 = load ptr, ptr %MEMORY, align 8
  %v2487 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2486, ptr %state, ptr undef)
  store ptr %v2487, ptr %MEMORY, align 8
  %v2488 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2488, ptr %PC, align 8
  %v2489 = add i64 %v2488, 1
  store i64 %v2489, ptr %NEXT_PC, align 8
  %v2490 = load ptr, ptr %MEMORY, align 8
  %v2491 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v2490, ptr %state, ptr undef)
  store ptr %v2491, ptr %MEMORY, align 8
  %v2492 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2492, ptr %PC, align 8
  %v2493 = add i64 %v2492, 2
  store i64 %v2493, ptr %NEXT_PC, align 8
  %v2494 = load i64, ptr %RBX, align 8
  %v2495 = load ptr, ptr %MEMORY, align 8
  %v2496 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2495, ptr %state, i64 %v2494)
  store ptr %v2496, ptr %MEMORY, align 8
  %v2497 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2497, ptr %PC, align 8
  %v2498 = add i64 %v2497, 4
  store i64 %v2498, ptr %NEXT_PC, align 8
  %v2499 = load i64, ptr %RSP, align 8
  %v2500 = load ptr, ptr %MEMORY, align 8
  %v2501 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2500, ptr %state, ptr %RSP, i64 %v2499, i64 32)
  store ptr %v2501, ptr %MEMORY, align 8
  %v2502 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2502, ptr %PC, align 8
  %v2503 = add i64 %v2502, 3
  store i64 %v2503, ptr %NEXT_PC, align 8
  %v2504 = load i64, ptr %RCX, align 8
  %v2505 = load ptr, ptr %MEMORY, align 8
  %v2506 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2505, ptr %state, ptr %RBX, i64 %v2504)
  store ptr %v2506, ptr %MEMORY, align 8
  %v2507 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2507, ptr %PC, align 8
  %v2508 = add i64 %v2507, 4
  store i64 %v2508, ptr %NEXT_PC, align 8
  %v2509 = load i64, ptr %RCX, align 8
  %v2510 = add i64 %v2509, 8
  %v2511 = load i64, ptr %RDX, align 8
  %v2512 = load ptr, ptr %MEMORY, align 8
  %v2513 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2512, ptr %state, i64 %v2510, i64 %v2511)
  store ptr %v2513, ptr %MEMORY, align 8
  %v2514 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2514, ptr %PC, align 8
  %v2515 = add i64 %v2514, 6
  store i64 %v2515, ptr %NEXT_PC, align 8
  %v2516 = load i64, ptr %NEXT_PC, align 8
  %v2517 = add i64 %v2516, 281
  %v2518 = load i64, ptr %NEXT_PC, align 8
  %v2519 = load ptr, ptr %MEMORY, align 8
  %v2520 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2519, ptr %state, ptr %BRANCH_TAKEN, i64 %v2517, i64 %v2518, ptr %NEXT_PC)
  store ptr %v2520, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878524, label %bb_5389878243

bb_5389878243:                                    ; preds = %bb_5389878216
  %v2521 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2521, ptr %PC, align 8
  %v2522 = add i64 %v2521, 5
  store i64 %v2522, ptr %NEXT_PC, align 8
  %v2523 = load i64, ptr %RSP, align 8
  %v2524 = add i64 %v2523, 48
  %v2525 = load i64, ptr %RBP, align 8
  %v2526 = load ptr, ptr %MEMORY, align 8
  %v2527 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2526, ptr %state, i64 %v2524, i64 %v2525)
  store ptr %v2527, ptr %MEMORY, align 8
  %v2528 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2528, ptr %PC, align 8
  %v2529 = add i64 %v2528, 4
  store i64 %v2529, ptr %NEXT_PC, align 8
  %v2530 = load i64, ptr %RCX, align 8
  %v2531 = add i64 %v2530, 48
  %v2532 = load ptr, ptr %MEMORY, align 8
  %v2533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2532, ptr %state, ptr %RBP, i64 %v2531)
  store ptr %v2533, ptr %MEMORY, align 8
  %v2534 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2534, ptr %PC, align 8
  %v2535 = add i64 %v2534, 3
  store i64 %v2535, ptr %NEXT_PC, align 8
  %v2536 = load i64, ptr %RDX, align 8
  %v2537 = load i64, ptr %RDX, align 8
  %v2538 = load ptr, ptr %MEMORY, align 8
  %v2539 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2538, ptr %state, i64 %v2536, i64 %v2537)
  store ptr %v2539, ptr %MEMORY, align 8
  %v2540 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2540, ptr %PC, align 8
  %v2541 = add i64 %v2540, 2
  store i64 %v2541, ptr %NEXT_PC, align 8
  %v2542 = load i64, ptr %NEXT_PC, align 8
  %v2543 = add i64 %v2542, 16
  %v2544 = load i64, ptr %NEXT_PC, align 8
  %v2545 = load ptr, ptr %MEMORY, align 8
  %v2546 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2545, ptr %state, ptr %BRANCH_TAKEN, i64 %v2543, i64 %v2544, ptr %NEXT_PC)
  store ptr %v2546, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878273, label %bb_5389878257

bb_5389878257:                                    ; preds = %bb_5389878243
  %v2547 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2547, ptr %PC, align 8
  %v2548 = add i64 %v2547, 4
  store i64 %v2548, ptr %NEXT_PC, align 8
  %v2549 = load i64, ptr %RDX, align 8
  %v2550 = add i64 %v2549, 48
  %v2551 = load i64, ptr %RBP, align 8
  %v2552 = load ptr, ptr %MEMORY, align 8
  %v2553 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2552, ptr %state, i64 %v2550, i64 %v2551)
  store ptr %v2553, ptr %MEMORY, align 8
  %v2554 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2554, ptr %PC, align 8
  %v2555 = add i64 %v2554, 2
  store i64 %v2555, ptr %NEXT_PC, align 8
  %v2556 = load i64, ptr %NEXT_PC, align 8
  %v2557 = add i64 %v2556, 10
  %v2558 = load i64, ptr %NEXT_PC, align 8
  %v2559 = load ptr, ptr %MEMORY, align 8
  %v2560 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2559, ptr %state, ptr %BRANCH_TAKEN, i64 %v2557, i64 %v2558, ptr %NEXT_PC)
  store ptr %v2560, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878273, label %bb_5389878263

bb_5389878263:                                    ; preds = %bb_5389878257
  %v2561 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2561, ptr %PC, align 8
  %v2562 = add i64 %v2561, 4
  store i64 %v2562, ptr %NEXT_PC, align 8
  %v2563 = load i64, ptr %RCX, align 8
  %v2564 = load i64, ptr %RBP, align 8
  %v2565 = add i64 %v2564, 8
  %v2566 = load ptr, ptr %MEMORY, align 8
  %v2567 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2566, ptr %state, i64 %v2563, i64 %v2565)
  store ptr %v2567, ptr %MEMORY, align 8
  %v2568 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2568, ptr %PC, align 8
  %v2569 = add i64 %v2568, 6
  store i64 %v2569, ptr %NEXT_PC, align 8
  %v2570 = load i64, ptr %NEXT_PC, align 8
  %v2571 = add i64 %v2570, 246
  %v2572 = load i64, ptr %NEXT_PC, align 8
  %v2573 = load ptr, ptr %MEMORY, align 8
  %v2574 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2573, ptr %state, ptr %BRANCH_TAKEN, i64 %v2571, i64 %v2572, ptr %NEXT_PC)
  store ptr %v2574, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878519, label %bb_5389878273

bb_5389878273:                                    ; preds = %bb_5389878263, %bb_5389878257, %bb_5389878243
  %v2575 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2575, ptr %PC, align 8
  %v2576 = add i64 %v2575, 5
  store i64 %v2576, ptr %NEXT_PC, align 8
  %v2577 = load i64, ptr %RSP, align 8
  %v2578 = add i64 %v2577, 64
  %v2579 = load i64, ptr %RDI, align 8
  %v2580 = load ptr, ptr %MEMORY, align 8
  %v2581 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2580, ptr %state, i64 %v2578, i64 %v2579)
  store ptr %v2581, ptr %MEMORY, align 8
  %v2582 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2582, ptr %PC, align 8
  %v2583 = add i64 %v2582, 5
  store i64 %v2583, ptr %NEXT_PC, align 8
  %v2584 = load i64, ptr %RSP, align 8
  %v2585 = add i64 %v2584, 72
  %v2586 = load i64, ptr %R14, align 8
  %v2587 = load ptr, ptr %MEMORY, align 8
  %v2588 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2587, ptr %state, i64 %v2585, i64 %v2586)
  store ptr %v2588, ptr %MEMORY, align 8
  %v2589 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2589, ptr %PC, align 8
  %v2590 = add i64 %v2589, 3
  store i64 %v2590, ptr %NEXT_PC, align 8
  %v2591 = load i64, ptr %R14, align 8
  %v2592 = load i32, ptr %R14D, align 4
  %v2593 = zext i32 %v2592 to i64
  %v2594 = load ptr, ptr %MEMORY, align 8
  %v2595 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2594, ptr %state, ptr %R14, i64 %v2591, i64 %v2593)
  store ptr %v2595, ptr %MEMORY, align 8
  %v2596 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2596, ptr %PC, align 8
  %v2597 = add i64 %v2596, 4
  store i64 %v2597, ptr %NEXT_PC, align 8
  %v2598 = load i64, ptr %RCX, align 8
  %v2599 = add i64 %v2598, 8
  %v2600 = load i64, ptr %RDX, align 8
  %v2601 = load ptr, ptr %MEMORY, align 8
  %v2602 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2601, ptr %state, i64 %v2599, i64 %v2600)
  store ptr %v2602, ptr %MEMORY, align 8
  %v2603 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2603, ptr %PC, align 8
  %v2604 = add i64 %v2603, 3
  store i64 %v2604, ptr %NEXT_PC, align 8
  %v2605 = load i64, ptr %RDX, align 8
  %v2606 = load i64, ptr %RDX, align 8
  %v2607 = load ptr, ptr %MEMORY, align 8
  %v2608 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2607, ptr %state, i64 %v2605, i64 %v2606)
  store ptr %v2608, ptr %MEMORY, align 8
  %v2609 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2609, ptr %PC, align 8
  %v2610 = add i64 %v2609, 2
  store i64 %v2610, ptr %NEXT_PC, align 8
  %v2611 = load i64, ptr %NEXT_PC, align 8
  %v2612 = add i64 %v2611, 6
  %v2613 = load i64, ptr %NEXT_PC, align 8
  %v2614 = load ptr, ptr %MEMORY, align 8
  %v2615 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2614, ptr %state, ptr %BRANCH_TAKEN, i64 %v2612, i64 %v2613, ptr %NEXT_PC)
  store ptr %v2615, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878301, label %bb_5389878295

bb_5389878295:                                    ; preds = %bb_5389878273
  %v2616 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2616, ptr %PC, align 8
  %v2617 = add i64 %v2616, 4
  store i64 %v2617, ptr %NEXT_PC, align 8
  %v2618 = load i64, ptr %RDX, align 8
  %v2619 = add i64 %v2618, 48
  %v2620 = load ptr, ptr %MEMORY, align 8
  %v2621 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2620, ptr %state, ptr %RAX, i64 %v2619)
  store ptr %v2621, ptr %MEMORY, align 8
  %v2622 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2622, ptr %PC, align 8
  %v2623 = add i64 %v2622, 2
  store i64 %v2623, ptr %NEXT_PC, align 8
  %v2624 = load i64, ptr %NEXT_PC, align 8
  %v2625 = add i64 %v2624, 46
  %v2626 = load ptr, ptr %MEMORY, align 8
  %v2627 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2626, ptr %state, i64 %v2625, ptr %NEXT_PC)
  store ptr %v2627, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878301:                                    ; preds = %bb_5389878273
  %v2628 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2628, ptr %PC, align 8
  %v2629 = add i64 %v2628, 2
  store i64 %v2629, ptr %NEXT_PC, align 8
  %v2630 = load i64, ptr %RDX, align 8
  %v2631 = load i32, ptr %EDX, align 4
  %v2632 = zext i32 %v2631 to i64
  %v2633 = load ptr, ptr %MEMORY, align 8
  %v2634 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2633, ptr %state, ptr %RDX, i64 %v2630, i64 %v2632)
  store ptr %v2634, ptr %MEMORY, align 8
  %v2635 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2635, ptr %PC, align 8
  %v2636 = add i64 %v2635, 3
  store i64 %v2636, ptr %NEXT_PC, align 8
  %v2637 = load i64, ptr %R9, align 8
  %v2638 = load i32, ptr %R9D, align 4
  %v2639 = zext i32 %v2638 to i64
  %v2640 = load ptr, ptr %MEMORY, align 8
  %v2641 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2640, ptr %state, ptr %R9, i64 %v2637, i64 %v2639)
  store ptr %v2641, ptr %MEMORY, align 8
  %v2642 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2642, ptr %PC, align 8
  %v2643 = add i64 %v2642, 3
  store i64 %v2643, ptr %NEXT_PC, align 8
  %v2644 = load i64, ptr %R8, align 8
  %v2645 = load i32, ptr %R8D, align 4
  %v2646 = zext i32 %v2645 to i64
  %v2647 = load ptr, ptr %MEMORY, align 8
  %v2648 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2647, ptr %state, ptr %R8, i64 %v2644, i64 %v2646)
  store ptr %v2648, ptr %MEMORY, align 8
  %v2649 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2649, ptr %PC, align 8
  %v2650 = add i64 %v2649, 3
  store i64 %v2650, ptr %NEXT_PC, align 8
  %v2651 = load i64, ptr %RDX, align 8
  %v2652 = add i64 %v2651, 24
  %v2653 = load ptr, ptr %MEMORY, align 8
  %v2654 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2653, ptr %state, ptr %RCX, i64 %v2652)
  store ptr %v2654, ptr %MEMORY, align 8
  %v2655 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2655, ptr %PC, align 8
  %v2656 = add i64 %v2655, 5
  store i64 %v2656, ptr %NEXT_PC, align 8
  %v2657 = load i64, ptr %NEXT_PC, align 8
  %v2658 = sub i64 %v2657, 1159245
  %v2659 = load i64, ptr %NEXT_PC, align 8
  %v2660 = load ptr, ptr %MEMORY, align 8
  %v2661 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2660, ptr %state, i64 %v2658, ptr %NEXT_PC, i64 %v2659, ptr %RETURN_PC)
  store ptr %v2661, ptr %MEMORY, align 8
  %v2662 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2662, ptr %PC, align 8
  %v2663 = add i64 %v2662, 3
  store i64 %v2663, ptr %NEXT_PC, align 8
  %v2664 = load i64, ptr %RAX, align 8
  %v2665 = load i64, ptr %RAX, align 8
  %v2666 = load ptr, ptr %MEMORY, align 8
  %v2667 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2666, ptr %state, i64 %v2664, i64 %v2665)
  store ptr %v2667, ptr %MEMORY, align 8
  %v2668 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2668, ptr %PC, align 8
  %v2669 = add i64 %v2668, 2
  store i64 %v2669, ptr %NEXT_PC, align 8
  %v2670 = load i64, ptr %NEXT_PC, align 8
  %v2671 = add i64 %v2670, 22
  %v2672 = load i64, ptr %NEXT_PC, align 8
  %v2673 = load ptr, ptr %MEMORY, align 8
  %v2674 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2673, ptr %state, ptr %BRANCH_TAKEN, i64 %v2671, i64 %v2672, ptr %NEXT_PC)
  store ptr %v2674, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878344, label %bb_5389878322

bb_5389878322:                                    ; preds = %bb_5389878301
  %v2675 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2675, ptr %PC, align 8
  %v2676 = add i64 %v2675, 4
  store i64 %v2676, ptr %NEXT_PC, align 8
  %v2677 = load i64, ptr %RAX, align 8
  %v2678 = add i64 %v2677, 16
  %v2679 = load ptr, ptr %MEMORY, align 8
  %v2680 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2679, ptr %state, ptr %RCX, i64 %v2678)
  store ptr %v2680, ptr %MEMORY, align 8
  %v2681 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2681, ptr %PC, align 8
  %v2682 = add i64 %v2681, 3
  store i64 %v2682, ptr %NEXT_PC, align 8
  %v2683 = load i8, ptr %CL, align 1
  %v2684 = zext i8 %v2683 to i64
  %v2685 = load ptr, ptr %MEMORY, align 8
  %v2686 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2685, ptr %state, ptr %CL, i64 %v2684, i64 253)
  store ptr %v2686, ptr %MEMORY, align 8
  %v2687 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2687, ptr %PC, align 8
  %v2688 = add i64 %v2687, 4
  store i64 %v2688, ptr %NEXT_PC, align 8
  %v2689 = load i64, ptr %RAX, align 8
  %v2690 = add i64 %v2689, 8
  %v2691 = load i64, ptr %RBX, align 8
  %v2692 = load ptr, ptr %MEMORY, align 8
  %v2693 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2692, ptr %state, i64 %v2690, i64 %v2691)
  store ptr %v2693, ptr %MEMORY, align 8
  %v2694 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2694, ptr %PC, align 8
  %v2695 = add i64 %v2694, 3
  store i64 %v2695, ptr %NEXT_PC, align 8
  %v2696 = load i8, ptr %CL, align 1
  %v2697 = zext i8 %v2696 to i64
  %v2698 = load ptr, ptr %MEMORY, align 8
  %v2699 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2698, ptr %state, ptr %CL, i64 %v2697, i64 1)
  store ptr %v2699, ptr %MEMORY, align 8
  %v2700 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2700, ptr %PC, align 8
  %v2701 = add i64 %v2700, 3
  store i64 %v2701, ptr %NEXT_PC, align 8
  %v2702 = load i64, ptr %RAX, align 8
  %v2703 = load i32, ptr %R14D, align 4
  %v2704 = zext i32 %v2703 to i64
  %v2705 = load ptr, ptr %MEMORY, align 8
  %v2706 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2705, ptr %state, i64 %v2702, i64 %v2704)
  store ptr %v2706, ptr %MEMORY, align 8
  %v2707 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2707, ptr %PC, align 8
  %v2708 = add i64 %v2707, 3
  store i64 %v2708, ptr %NEXT_PC, align 8
  %v2709 = load i64, ptr %RAX, align 8
  %v2710 = add i64 %v2709, 16
  %v2711 = load i8, ptr %CL, align 1
  %v2712 = zext i8 %v2711 to i64
  %v2713 = load ptr, ptr %MEMORY, align 8
  %v2714 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2713, ptr %state, i64 %v2710, i64 %v2712)
  store ptr %v2714, ptr %MEMORY, align 8
  %v2715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2715, ptr %PC, align 8
  %v2716 = add i64 %v2715, 2
  store i64 %v2716, ptr %NEXT_PC, align 8
  %v2717 = load i64, ptr %NEXT_PC, align 8
  %v2718 = add i64 %v2717, 3
  %v2719 = load ptr, ptr %MEMORY, align 8
  %v2720 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2719, ptr %state, i64 %v2718, ptr %NEXT_PC)
  store ptr %v2720, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878344:                                    ; preds = %bb_5389878301
  %v2721 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2721, ptr %PC, align 8
  %v2722 = add i64 %v2721, 3
  store i64 %v2722, ptr %NEXT_PC, align 8
  %v2723 = load i64, ptr %R14, align 8
  %v2724 = load ptr, ptr %MEMORY, align 8
  %v2725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2724, ptr %state, ptr %RAX, i64 %v2723)
  store ptr %v2725, ptr %MEMORY, align 8
  br label %bb_5389878347

bb_5389878347:                                    ; preds = %bb_5389878344, %bb_5389878322, %bb_5389878295
  %v2726 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2726, ptr %PC, align 8
  %v2727 = add i64 %v2726, 4
  store i64 %v2727, ptr %NEXT_PC, align 8
  %v2728 = load i64, ptr %RBX, align 8
  %v2729 = add i64 %v2728, 48
  %v2730 = load i64, ptr %RAX, align 8
  %v2731 = load ptr, ptr %MEMORY, align 8
  %v2732 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2731, ptr %state, i64 %v2729, i64 %v2730)
  store ptr %v2732, ptr %MEMORY, align 8
  %v2733 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2733, ptr %PC, align 8
  %v2734 = add i64 %v2733, 3
  store i64 %v2734, ptr %NEXT_PC, align 8
  %v2735 = load i32, ptr %R14D, align 4
  %v2736 = zext i32 %v2735 to i64
  %v2737 = load ptr, ptr %MEMORY, align 8
  %v2738 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2737, ptr %state, ptr %RDI, i64 %v2736)
  store ptr %v2738, ptr %MEMORY, align 8
  %v2739 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2739, ptr %PC, align 8
  %v2740 = add i64 %v2739, 4
  store i64 %v2740, ptr %NEXT_PC, align 8
  %v2741 = load i64, ptr %RBX, align 8
  %v2742 = add i64 %v2741, 40
  %v2743 = load i32, ptr %R14D, align 4
  %v2744 = zext i32 %v2743 to i64
  %v2745 = load ptr, ptr %MEMORY, align 8
  %v2746 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2745, ptr %state, i64 %v2742, i64 %v2744)
  store ptr %v2746, ptr %MEMORY, align 8
  %v2747 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2747, ptr %PC, align 8
  %v2748 = add i64 %v2747, 2
  store i64 %v2748, ptr %NEXT_PC, align 8
  %v2749 = load i64, ptr %NEXT_PC, align 8
  %v2750 = add i64 %v2749, 94
  %v2751 = load i64, ptr %NEXT_PC, align 8
  %v2752 = load ptr, ptr %MEMORY, align 8
  %v2753 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2752, ptr %state, ptr %BRANCH_TAKEN, i64 %v2750, i64 %v2751, ptr %NEXT_PC)
  store ptr %v2753, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878454, label %bb_5389878360

bb_5389878360:                                    ; preds = %bb_5389878347
  %v2754 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2754, ptr %PC, align 8
  %v2755 = add i64 %v2754, 5
  store i64 %v2755, ptr %NEXT_PC, align 8
  %v2756 = load i64, ptr %RSP, align 8
  %v2757 = add i64 %v2756, 56
  %v2758 = load i64, ptr %RSI, align 8
  %v2759 = load ptr, ptr %MEMORY, align 8
  %v2760 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2759, ptr %state, i64 %v2757, i64 %v2758)
  store ptr %v2760, ptr %MEMORY, align 8
  %v2761 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2761, ptr %PC, align 8
  %v2762 = add i64 %v2761, 3
  store i64 %v2762, ptr %NEXT_PC, align 8
  %v2763 = load i64, ptr %R14, align 8
  %v2764 = load ptr, ptr %MEMORY, align 8
  %v2765 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2764, ptr %state, ptr %RSI, i64 %v2763)
  store ptr %v2765, ptr %MEMORY, align 8
  br label %bb_5389878368

bb_5389878368:                                    ; preds = %bb_5389878438, %bb_5389878360
  %v2766 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2766, ptr %PC, align 8
  %v2767 = add i64 %v2766, 4
  store i64 %v2767, ptr %NEXT_PC, align 8
  %v2768 = load i64, ptr %RBX, align 8
  %v2769 = add i64 %v2768, 32
  %v2770 = load ptr, ptr %MEMORY, align 8
  %v2771 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2770, ptr %state, ptr %RDX, i64 %v2769)
  store ptr %v2771, ptr %MEMORY, align 8
  %v2772 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2772, ptr %PC, align 8
  %v2773 = add i64 %v2772, 4
  store i64 %v2773, ptr %NEXT_PC, align 8
  %v2774 = load i64, ptr %RDX, align 8
  %v2775 = load ptr, ptr %MEMORY, align 8
  %v2776 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2775, ptr %state, ptr %RDX, i64 %v2774, i64 8)
  store ptr %v2776, ptr %MEMORY, align 8
  %v2777 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2777, ptr %PC, align 8
  %v2778 = add i64 %v2777, 3
  store i64 %v2778, ptr %NEXT_PC, align 8
  %v2779 = load i64, ptr %RDX, align 8
  %v2780 = load i64, ptr %RSI, align 8
  %v2781 = load ptr, ptr %MEMORY, align 8
  %v2782 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2781, ptr %state, ptr %RDX, i64 %v2779, i64 %v2780)
  store ptr %v2782, ptr %MEMORY, align 8
  %v2783 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2783, ptr %PC, align 8
  %v2784 = add i64 %v2783, 4
  store i64 %v2784, ptr %NEXT_PC, align 8
  %v2785 = load i64, ptr %RDX, align 8
  %v2786 = add i64 %v2785, 32
  %v2787 = load ptr, ptr %MEMORY, align 8
  %v2788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2787, ptr %state, ptr %RCX, i64 %v2786)
  store ptr %v2788, ptr %MEMORY, align 8
  %v2789 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2789, ptr %PC, align 8
  %v2790 = add i64 %v2789, 7
  store i64 %v2790, ptr %NEXT_PC, align 8
  %v2791 = load i64, ptr %RCX, align 8
  %v2792 = load i64, ptr %NEXT_PC, align 8
  %v2793 = add i64 %v2792, 27073082
  %v2794 = load ptr, ptr %MEMORY, align 8
  %v2795 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2794, ptr %state, i64 %v2791, i64 %v2793)
  store ptr %v2795, ptr %MEMORY, align 8
  %v2796 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2796, ptr %PC, align 8
  %v2797 = add i64 %v2796, 2
  store i64 %v2797, ptr %NEXT_PC, align 8
  %v2798 = load i64, ptr %NEXT_PC, align 8
  %v2799 = add i64 %v2798, 46
  %v2800 = load i64, ptr %NEXT_PC, align 8
  %v2801 = load ptr, ptr %MEMORY, align 8
  %v2802 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2801, ptr %state, ptr %BRANCH_TAKEN, i64 %v2799, i64 %v2800, ptr %NEXT_PC)
  store ptr %v2802, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878392

bb_5389878392:                                    ; preds = %bb_5389878368
  %v2803 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2803, ptr %PC, align 8
  %v2804 = add i64 %v2803, 3
  store i64 %v2804, ptr %NEXT_PC, align 8
  %v2805 = load i64, ptr %RCX, align 8
  %v2806 = load i64, ptr %RCX, align 8
  %v2807 = load ptr, ptr %MEMORY, align 8
  %v2808 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2807, ptr %state, i64 %v2805, i64 %v2806)
  store ptr %v2808, ptr %MEMORY, align 8
  %v2809 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2809, ptr %PC, align 8
  %v2810 = add i64 %v2809, 2
  store i64 %v2810, ptr %NEXT_PC, align 8
  %v2811 = load i64, ptr %NEXT_PC, align 8
  %v2812 = add i64 %v2811, 5
  %v2813 = load i64, ptr %NEXT_PC, align 8
  %v2814 = load ptr, ptr %MEMORY, align 8
  %v2815 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2814, ptr %state, ptr %BRANCH_TAKEN, i64 %v2812, i64 %v2813, ptr %NEXT_PC)
  store ptr %v2815, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878402, label %bb_5389878397

bb_5389878397:                                    ; preds = %bb_5389878392
  %v2816 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2816, ptr %PC, align 8
  %v2817 = add i64 %v2816, 3
  store i64 %v2817, ptr %NEXT_PC, align 8
  %v2818 = load i64, ptr %R14, align 8
  %v2819 = load ptr, ptr %MEMORY, align 8
  %v2820 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2819, ptr %state, ptr %RAX, i64 %v2818)
  store ptr %v2820, ptr %MEMORY, align 8
  %v2821 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2821, ptr %PC, align 8
  %v2822 = add i64 %v2821, 2
  store i64 %v2822, ptr %NEXT_PC, align 8
  %v2823 = load i64, ptr %NEXT_PC, align 8
  %v2824 = add i64 %v2823, 6
  %v2825 = load ptr, ptr %MEMORY, align 8
  %v2826 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v2825, ptr %state, i64 %v2824, ptr %NEXT_PC)
  store ptr %v2826, ptr %MEMORY, align 8
  br label %bb_5389878408

bb_5389878402:                                    ; preds = %bb_5389878392
  %v2827 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2827, ptr %PC, align 8
  %v2828 = add i64 %v2827, 3
  store i64 %v2828, ptr %NEXT_PC, align 8
  %v2829 = load i64, ptr %RCX, align 8
  %v2830 = load ptr, ptr %MEMORY, align 8
  %v2831 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2830, ptr %state, ptr %RAX, i64 %v2829)
  store ptr %v2831, ptr %MEMORY, align 8
  %v2832 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2832, ptr %PC, align 8
  %v2833 = add i64 %v2832, 3
  store i64 %v2833, ptr %NEXT_PC, align 8
  %v2834 = load i64, ptr %RAX, align 8
  %v2835 = add i64 %v2834, 48
  %v2836 = load i64, ptr %NEXT_PC, align 8
  %v2837 = load ptr, ptr %MEMORY, align 8
  %v2838 = call ptr @_ZN12_GLOBAL__N_14CALLI2MnImEEEP6MemoryS4_R5StateT_3RnWImE2InImES9_(ptr %v2837, ptr %state, i64 %v2835, ptr %NEXT_PC, i64 %v2836, ptr %RETURN_PC)
  store ptr %v2838, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878408:                                    ; preds = %bb_5389878397
  %v2839 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2839, ptr %PC, align 8
  %v2840 = add i64 %v2839, 3
  store i64 %v2840, ptr %NEXT_PC, align 8
  %v2841 = load i64, ptr %RAX, align 8
  %v2842 = load ptr, ptr %MEMORY, align 8
  %v2843 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2842, ptr %state, ptr %RCX, i64 %v2841)
  store ptr %v2843, ptr %MEMORY, align 8
  %v2844 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2844, ptr %PC, align 8
  %v2845 = add i64 %v2844, 3
  store i64 %v2845, ptr %NEXT_PC, align 8
  %v2846 = load i64, ptr %RCX, align 8
  %v2847 = load i64, ptr %RCX, align 8
  %v2848 = load ptr, ptr %MEMORY, align 8
  %v2849 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2848, ptr %state, i64 %v2846, i64 %v2847)
  store ptr %v2849, ptr %MEMORY, align 8
  %v2850 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2850, ptr %PC, align 8
  %v2851 = add i64 %v2850, 2
  store i64 %v2851, ptr %NEXT_PC, align 8
  %v2852 = load i64, ptr %NEXT_PC, align 8
  %v2853 = add i64 %v2852, 22
  %v2854 = load i64, ptr %NEXT_PC, align 8
  %v2855 = load ptr, ptr %MEMORY, align 8
  %v2856 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2855, ptr %state, ptr %BRANCH_TAKEN, i64 %v2853, i64 %v2854, ptr %NEXT_PC)
  store ptr %v2856, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878416

bb_5389878416:                                    ; preds = %bb_5389878408
  %v2857 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2857, ptr %PC, align 8
  %v2858 = add i64 %v2857, 4
  store i64 %v2858, ptr %NEXT_PC, align 8
  %v2859 = load i64, ptr %RCX, align 8
  %v2860 = add i64 %v2859, 8
  %v2861 = load i64, ptr %RBX, align 8
  %v2862 = load ptr, ptr %MEMORY, align 8
  %v2863 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v2862, ptr %state, i64 %v2860, i64 %v2861)
  store ptr %v2863, ptr %MEMORY, align 8
  %v2864 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2864, ptr %PC, align 8
  %v2865 = add i64 %v2864, 2
  store i64 %v2865, ptr %NEXT_PC, align 8
  %v2866 = load i64, ptr %NEXT_PC, align 8
  %v2867 = add i64 %v2866, 16
  %v2868 = load i64, ptr %NEXT_PC, align 8
  %v2869 = load ptr, ptr %MEMORY, align 8
  %v2870 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2869, ptr %state, ptr %BRANCH_TAKEN, i64 %v2867, i64 %v2868, ptr %NEXT_PC)
  store ptr %v2870, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878438, label %bb_5389878422

bb_5389878422:                                    ; preds = %bb_5389878416
  %v2871 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2871, ptr %PC, align 8
  %v2872 = add i64 %v2871, 3
  store i64 %v2872, ptr %NEXT_PC, align 8
  %v2873 = load i64, ptr %RBX, align 8
  %v2874 = load ptr, ptr %MEMORY, align 8
  %v2875 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2874, ptr %state, ptr %RDX, i64 %v2873)
  store ptr %v2875, ptr %MEMORY, align 8
  %v2876 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2876, ptr %PC, align 8
  %v2877 = add i64 %v2876, 4
  store i64 %v2877, ptr %NEXT_PC, align 8
  %v2878 = load i64, ptr %RCX, align 8
  %v2879 = add i64 %v2878, 48
  %v2880 = load i64, ptr %R14, align 8
  %v2881 = load ptr, ptr %MEMORY, align 8
  %v2882 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2881, ptr %state, i64 %v2879, i64 %v2880)
  store ptr %v2882, ptr %MEMORY, align 8
  %v2883 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2883, ptr %PC, align 8
  %v2884 = add i64 %v2883, 4
  store i64 %v2884, ptr %NEXT_PC, align 8
  %v2885 = load i64, ptr %RCX, align 8
  %v2886 = add i64 %v2885, 8
  %v2887 = load i64, ptr %R14, align 8
  %v2888 = load ptr, ptr %MEMORY, align 8
  %v2889 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2888, ptr %state, i64 %v2886, i64 %v2887)
  store ptr %v2889, ptr %MEMORY, align 8
  %v2890 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2890, ptr %PC, align 8
  %v2891 = add i64 %v2890, 5
  store i64 %v2891, ptr %NEXT_PC, align 8
  %v2892 = load i64, ptr %NEXT_PC, align 8
  %v2893 = sub i64 %v2892, 214
  %v2894 = load i64, ptr %NEXT_PC, align 8
  %v2895 = load ptr, ptr %MEMORY, align 8
  %v2896 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2895, ptr %state, i64 %v2893, ptr %NEXT_PC, i64 %v2894, ptr %RETURN_PC)
  store ptr %v2896, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878438:                                    ; preds = %bb_5389878416, %bb_5389878408, %bb_5389878368
  %v2897 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2897, ptr %PC, align 8
  %v2898 = add i64 %v2897, 2
  store i64 %v2898, ptr %NEXT_PC, align 8
  %v2899 = load i64, ptr %RDI, align 8
  %v2900 = load ptr, ptr %MEMORY, align 8
  %v2901 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2900, ptr %state, ptr %RDI, i64 %v2899)
  store ptr %v2901, ptr %MEMORY, align 8
  %v2902 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2902, ptr %PC, align 8
  %v2903 = add i64 %v2902, 4
  store i64 %v2903, ptr %NEXT_PC, align 8
  %v2904 = load i64, ptr %RSI, align 8
  %v2905 = load ptr, ptr %MEMORY, align 8
  %v2906 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2905, ptr %state, ptr %RSI, i64 %v2904, i64 56)
  store ptr %v2906, ptr %MEMORY, align 8
  %v2907 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2907, ptr %PC, align 8
  %v2908 = add i64 %v2907, 3
  store i64 %v2908, ptr %NEXT_PC, align 8
  %v2909 = load i32, ptr %EDI, align 4
  %v2910 = zext i32 %v2909 to i64
  %v2911 = load i64, ptr %RBX, align 8
  %v2912 = add i64 %v2911, 40
  %v2913 = load ptr, ptr %MEMORY, align 8
  %v2914 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2913, ptr %state, i64 %v2910, i64 %v2912)
  store ptr %v2914, ptr %MEMORY, align 8
  %v2915 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2915, ptr %PC, align 8
  %v2916 = add i64 %v2915, 2
  store i64 %v2916, ptr %NEXT_PC, align 8
  %v2917 = load i64, ptr %NEXT_PC, align 8
  %v2918 = sub i64 %v2917, 81
  %v2919 = load i64, ptr %NEXT_PC, align 8
  %v2920 = load ptr, ptr %MEMORY, align 8
  %v2921 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2920, ptr %state, ptr %BRANCH_TAKEN, i64 %v2918, i64 %v2919, ptr %NEXT_PC)
  store ptr %v2921, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878368, label %bb_5389878449

bb_5389878449:                                    ; preds = %bb_5389878438
  %v2922 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2922, ptr %PC, align 8
  %v2923 = add i64 %v2922, 5
  store i64 %v2923, ptr %NEXT_PC, align 8
  %v2924 = load i64, ptr %RSP, align 8
  %v2925 = add i64 %v2924, 56
  %v2926 = load ptr, ptr %MEMORY, align 8
  %v2927 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2926, ptr %state, ptr %RSI, i64 %v2925)
  store ptr %v2927, ptr %MEMORY, align 8
  br label %bb_5389878454

bb_5389878454:                                    ; preds = %bb_5389878449, %bb_5389878347
  %v2928 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2928, ptr %PC, align 8
  %v2929 = add i64 %v2928, 5
  store i64 %v2929, ptr %NEXT_PC, align 8
  %v2930 = load i64, ptr %RSP, align 8
  %v2931 = add i64 %v2930, 72
  %v2932 = load ptr, ptr %MEMORY, align 8
  %v2933 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2932, ptr %state, ptr %R14, i64 %v2931)
  store ptr %v2933, ptr %MEMORY, align 8
  %v2934 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2934, ptr %PC, align 8
  %v2935 = add i64 %v2934, 5
  store i64 %v2935, ptr %NEXT_PC, align 8
  %v2936 = load i64, ptr %RSP, align 8
  %v2937 = add i64 %v2936, 64
  %v2938 = load ptr, ptr %MEMORY, align 8
  %v2939 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2938, ptr %state, ptr %RDI, i64 %v2937)
  store ptr %v2939, ptr %MEMORY, align 8
  %v2940 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2940, ptr %PC, align 8
  %v2941 = add i64 %v2940, 3
  store i64 %v2941, ptr %NEXT_PC, align 8
  %v2942 = load i64, ptr %RBP, align 8
  %v2943 = load i64, ptr %RBP, align 8
  %v2944 = load ptr, ptr %MEMORY, align 8
  %v2945 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2944, ptr %state, i64 %v2942, i64 %v2943)
  store ptr %v2945, ptr %MEMORY, align 8
  %v2946 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2946, ptr %PC, align 8
  %v2947 = add i64 %v2946, 2
  store i64 %v2947, ptr %NEXT_PC, align 8
  %v2948 = load i64, ptr %NEXT_PC, align 8
  %v2949 = add i64 %v2948, 42
  %v2950 = load i64, ptr %NEXT_PC, align 8
  %v2951 = load ptr, ptr %MEMORY, align 8
  %v2952 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2951, ptr %state, ptr %BRANCH_TAKEN, i64 %v2949, i64 %v2950, ptr %NEXT_PC)
  store ptr %v2952, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878511, label %bb_5389878469

bb_5389878469:                                    ; preds = %bb_5389878454
  %v2953 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2953, ptr %PC, align 8
  %v2954 = add i64 %v2953, 4
  store i64 %v2954, ptr %NEXT_PC, align 8
  %v2955 = load i64, ptr %RBX, align 8
  %v2956 = load i64, ptr %RBP, align 8
  %v2957 = add i64 %v2956, 8
  %v2958 = load ptr, ptr %MEMORY, align 8
  %v2959 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2958, ptr %state, i64 %v2955, i64 %v2957)
  store ptr %v2959, ptr %MEMORY, align 8
  %v2960 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2960, ptr %PC, align 8
  %v2961 = add i64 %v2960, 2
  store i64 %v2961, ptr %NEXT_PC, align 8
  %v2962 = load i64, ptr %NEXT_PC, align 8
  %v2963 = add i64 %v2962, 32
  %v2964 = load i64, ptr %NEXT_PC, align 8
  %v2965 = load ptr, ptr %MEMORY, align 8
  %v2966 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v2965, ptr %state, ptr %BRANCH_TAKEN, i64 %v2963, i64 %v2964, ptr %NEXT_PC)
  store ptr %v2966, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878507, label %bb_5389878475

bb_5389878475:                                    ; preds = %bb_5389878469
  %v2967 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2967, ptr %PC, align 8
  %v2968 = add i64 %v2967, 5
  store i64 %v2968, ptr %NEXT_PC, align 8
  %v2969 = load ptr, ptr %MEMORY, align 8
  %v2970 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2969, ptr %state, ptr %RDX, i64 24)
  store ptr %v2970, ptr %MEMORY, align 8
  %v2971 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2971, ptr %PC, align 8
  %v2972 = add i64 %v2971, 3
  store i64 %v2972, ptr %NEXT_PC, align 8
  %v2973 = load i64, ptr %RBP, align 8
  %v2974 = load ptr, ptr %MEMORY, align 8
  %v2975 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2974, ptr %state, ptr %RCX, i64 %v2973)
  store ptr %v2975, ptr %MEMORY, align 8
  %v2976 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2976, ptr %PC, align 8
  %v2977 = add i64 %v2976, 5
  store i64 %v2977, ptr %NEXT_PC, align 8
  %v2978 = load i64, ptr %NEXT_PC, align 8
  %v2979 = sub i64 %v2978, 1165176
  %v2980 = load i64, ptr %NEXT_PC, align 8
  %v2981 = load ptr, ptr %MEMORY, align 8
  %v2982 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v2981, ptr %state, i64 %v2979, ptr %NEXT_PC, i64 %v2980, ptr %RETURN_PC)
  store ptr %v2982, ptr %MEMORY, align 8
  %v2983 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2983, ptr %PC, align 8
  %v2984 = add i64 %v2983, 4
  store i64 %v2984, ptr %NEXT_PC, align 8
  %v2985 = load i64, ptr %RBX, align 8
  %v2986 = add i64 %v2985, 48
  %v2987 = load ptr, ptr %MEMORY, align 8
  %v2988 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2987, ptr %state, ptr %RAX, i64 %v2986)
  store ptr %v2988, ptr %MEMORY, align 8
  %v2989 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2989, ptr %PC, align 8
  %v2990 = add i64 %v2989, 5
  store i64 %v2990, ptr %NEXT_PC, align 8
  %v2991 = load i64, ptr %RSP, align 8
  %v2992 = add i64 %v2991, 48
  %v2993 = load ptr, ptr %MEMORY, align 8
  %v2994 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v2993, ptr %state, ptr %RBP, i64 %v2992)
  store ptr %v2994, ptr %MEMORY, align 8
  %v2995 = load i64, ptr %NEXT_PC, align 8
  store i64 %v2995, ptr %PC, align 8
  %v2996 = add i64 %v2995, 4
  store i64 %v2996, ptr %NEXT_PC, align 8
  %v2997 = load i64, ptr %RAX, align 8
  %v2998 = add i64 %v2997, 16
  %v2999 = load i64, ptr %RAX, align 8
  %v3000 = add i64 %v2999, 16
  %v3001 = load ptr, ptr %MEMORY, align 8
  %v3002 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3001, ptr %state, i64 %v2998, i64 %v3000, i64 1)
  store ptr %v3002, ptr %MEMORY, align 8
  %v3003 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3003, ptr %PC, align 8
  %v3004 = add i64 %v3003, 4
  store i64 %v3004, ptr %NEXT_PC, align 8
  %v3005 = load i64, ptr %RSP, align 8
  %v3006 = load ptr, ptr %MEMORY, align 8
  %v3007 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3006, ptr %state, ptr %RSP, i64 %v3005, i64 32)
  store ptr %v3007, ptr %MEMORY, align 8
  %v3008 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3008, ptr %PC, align 8
  %v3009 = add i64 %v3008, 1
  store i64 %v3009, ptr %NEXT_PC, align 8
  %v3010 = load ptr, ptr %MEMORY, align 8
  %v3011 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3010, ptr %state, ptr %RBX)
  store ptr %v3011, ptr %MEMORY, align 8
  %v3012 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3012, ptr %PC, align 8
  %v3013 = add i64 %v3012, 1
  store i64 %v3013, ptr %NEXT_PC, align 8
  %v3014 = load ptr, ptr %MEMORY, align 8
  %v3015 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3014, ptr %state, ptr %NEXT_PC)
  store ptr %v3015, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878507:                                    ; preds = %bb_5389878469
  %v3016 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3016, ptr %PC, align 8
  %v3017 = add i64 %v3016, 4
  store i64 %v3017, ptr %NEXT_PC, align 8
  %v3018 = load i64, ptr %RBP, align 8
  %v3019 = add i64 %v3018, 16
  %v3020 = load i64, ptr %RBP, align 8
  %v3021 = add i64 %v3020, 16
  %v3022 = load ptr, ptr %MEMORY, align 8
  %v3023 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3022, ptr %state, i64 %v3019, i64 %v3021, i64 1)
  store ptr %v3023, ptr %MEMORY, align 8
  br label %bb_5389878511

bb_5389878511:                                    ; preds = %bb_5389878507, %bb_5389878454
  %v3024 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3024, ptr %PC, align 8
  %v3025 = add i64 %v3024, 4
  store i64 %v3025, ptr %NEXT_PC, align 8
  %v3026 = load i64, ptr %RBX, align 8
  %v3027 = add i64 %v3026, 48
  %v3028 = load ptr, ptr %MEMORY, align 8
  %v3029 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3028, ptr %state, ptr %RAX, i64 %v3027)
  store ptr %v3029, ptr %MEMORY, align 8
  %v3030 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3030, ptr %PC, align 8
  %v3031 = add i64 %v3030, 4
  store i64 %v3031, ptr %NEXT_PC, align 8
  %v3032 = load i64, ptr %RAX, align 8
  %v3033 = add i64 %v3032, 16
  %v3034 = load i64, ptr %RAX, align 8
  %v3035 = add i64 %v3034, 16
  %v3036 = load ptr, ptr %MEMORY, align 8
  %v3037 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3036, ptr %state, i64 %v3033, i64 %v3035, i64 1)
  store ptr %v3037, ptr %MEMORY, align 8
  br label %bb_5389878519

bb_5389878519:                                    ; preds = %bb_5389878511, %bb_5389878263
  %v3038 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3038, ptr %PC, align 8
  %v3039 = add i64 %v3038, 5
  store i64 %v3039, ptr %NEXT_PC, align 8
  %v3040 = load i64, ptr %RSP, align 8
  %v3041 = add i64 %v3040, 48
  %v3042 = load ptr, ptr %MEMORY, align 8
  %v3043 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3042, ptr %state, ptr %RBP, i64 %v3041)
  store ptr %v3043, ptr %MEMORY, align 8
  br label %bb_5389878524

bb_5389878524:                                    ; preds = %bb_5389878519, %bb_5389878216
  %v3044 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3044, ptr %PC, align 8
  %v3045 = add i64 %v3044, 4
  store i64 %v3045, ptr %NEXT_PC, align 8
  %v3046 = load i64, ptr %RSP, align 8
  %v3047 = load ptr, ptr %MEMORY, align 8
  %v3048 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3047, ptr %state, ptr %RSP, i64 %v3046, i64 32)
  store ptr %v3048, ptr %MEMORY, align 8
  %v3049 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3049, ptr %PC, align 8
  %v3050 = add i64 %v3049, 1
  store i64 %v3050, ptr %NEXT_PC, align 8
  %v3051 = load ptr, ptr %MEMORY, align 8
  %v3052 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3051, ptr %state, ptr %RBX)
  store ptr %v3052, ptr %MEMORY, align 8
  %v3053 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3053, ptr %PC, align 8
  %v3054 = add i64 %v3053, 1
  store i64 %v3054, ptr %NEXT_PC, align 8
  %v3055 = load ptr, ptr %MEMORY, align 8
  %v3056 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3055, ptr %state, ptr %NEXT_PC)
  store ptr %v3056, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878530:                                    ; No predecessors!
  %v3057 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3057, ptr %PC, align 8
  %v3058 = add i64 %v3057, 1
  store i64 %v3058, ptr %NEXT_PC, align 8
  %v3059 = load ptr, ptr %MEMORY, align 8
  %v3060 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3059, ptr %state, ptr undef)
  store ptr %v3060, ptr %MEMORY, align 8
  %v3061 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3061, ptr %PC, align 8
  %v3062 = add i64 %v3061, 1
  store i64 %v3062, ptr %NEXT_PC, align 8
  %v3063 = load ptr, ptr %MEMORY, align 8
  %v3064 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3063, ptr %state, ptr undef)
  store ptr %v3064, ptr %MEMORY, align 8
  %v3065 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3065, ptr %PC, align 8
  %v3066 = add i64 %v3065, 1
  store i64 %v3066, ptr %NEXT_PC, align 8
  %v3067 = load ptr, ptr %MEMORY, align 8
  %v3068 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3067, ptr %state, ptr undef)
  store ptr %v3068, ptr %MEMORY, align 8
  %v3069 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3069, ptr %PC, align 8
  %v3070 = add i64 %v3069, 1
  store i64 %v3070, ptr %NEXT_PC, align 8
  %v3071 = load ptr, ptr %MEMORY, align 8
  %v3072 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3071, ptr %state, ptr undef)
  store ptr %v3072, ptr %MEMORY, align 8
  %v3073 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3073, ptr %PC, align 8
  %v3074 = add i64 %v3073, 1
  store i64 %v3074, ptr %NEXT_PC, align 8
  %v3075 = load ptr, ptr %MEMORY, align 8
  %v3076 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3075, ptr %state, ptr undef)
  store ptr %v3076, ptr %MEMORY, align 8
  %v3077 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3077, ptr %PC, align 8
  %v3078 = add i64 %v3077, 1
  store i64 %v3078, ptr %NEXT_PC, align 8
  %v3079 = load ptr, ptr %MEMORY, align 8
  %v3080 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3079, ptr %state, ptr undef)
  store ptr %v3080, ptr %MEMORY, align 8
  %v3081 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3081, ptr %PC, align 8
  %v3082 = add i64 %v3081, 1
  store i64 %v3082, ptr %NEXT_PC, align 8
  %v3083 = load ptr, ptr %MEMORY, align 8
  %v3084 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3083, ptr %state, ptr undef)
  store ptr %v3084, ptr %MEMORY, align 8
  %v3085 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3085, ptr %PC, align 8
  %v3086 = add i64 %v3085, 1
  store i64 %v3086, ptr %NEXT_PC, align 8
  %v3087 = load ptr, ptr %MEMORY, align 8
  %v3088 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3087, ptr %state, ptr undef)
  store ptr %v3088, ptr %MEMORY, align 8
  %v3089 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3089, ptr %PC, align 8
  %v3090 = add i64 %v3089, 1
  store i64 %v3090, ptr %NEXT_PC, align 8
  %v3091 = load ptr, ptr %MEMORY, align 8
  %v3092 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3091, ptr %state, ptr undef)
  store ptr %v3092, ptr %MEMORY, align 8
  %v3093 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3093, ptr %PC, align 8
  %v3094 = add i64 %v3093, 1
  store i64 %v3094, ptr %NEXT_PC, align 8
  %v3095 = load ptr, ptr %MEMORY, align 8
  %v3096 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3095, ptr %state, ptr undef)
  store ptr %v3096, ptr %MEMORY, align 8
  %v3097 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3097, ptr %PC, align 8
  %v3098 = add i64 %v3097, 1
  store i64 %v3098, ptr %NEXT_PC, align 8
  %v3099 = load ptr, ptr %MEMORY, align 8
  %v3100 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3099, ptr %state, ptr undef)
  store ptr %v3100, ptr %MEMORY, align 8
  %v3101 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3101, ptr %PC, align 8
  %v3102 = add i64 %v3101, 1
  store i64 %v3102, ptr %NEXT_PC, align 8
  %v3103 = load ptr, ptr %MEMORY, align 8
  %v3104 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3103, ptr %state, ptr undef)
  store ptr %v3104, ptr %MEMORY, align 8
  %v3105 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3105, ptr %PC, align 8
  %v3106 = add i64 %v3105, 1
  store i64 %v3106, ptr %NEXT_PC, align 8
  %v3107 = load ptr, ptr %MEMORY, align 8
  %v3108 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3107, ptr %state, ptr undef)
  store ptr %v3108, ptr %MEMORY, align 8
  %v3109 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3109, ptr %PC, align 8
  %v3110 = add i64 %v3109, 1
  store i64 %v3110, ptr %NEXT_PC, align 8
  %v3111 = load ptr, ptr %MEMORY, align 8
  %v3112 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3111, ptr %state, ptr undef)
  store ptr %v3112, ptr %MEMORY, align 8
  %v3113 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3113, ptr %PC, align 8
  %v3114 = add i64 %v3113, 5
  store i64 %v3114, ptr %NEXT_PC, align 8
  %v3115 = load i64, ptr %RSP, align 8
  %v3116 = add i64 %v3115, 24
  %v3117 = load i64, ptr %RBX, align 8
  %v3118 = load ptr, ptr %MEMORY, align 8
  %v3119 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3118, ptr %state, i64 %v3116, i64 %v3117)
  store ptr %v3119, ptr %MEMORY, align 8
  %v3120 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3120, ptr %PC, align 8
  %v3121 = add i64 %v3120, 1
  store i64 %v3121, ptr %NEXT_PC, align 8
  %v3122 = load i64, ptr %RDI, align 8
  %v3123 = load ptr, ptr %MEMORY, align 8
  %v3124 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v3123, ptr %state, i64 %v3122)
  store ptr %v3124, ptr %MEMORY, align 8
  %v3125 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3125, ptr %PC, align 8
  %v3126 = add i64 %v3125, 4
  store i64 %v3126, ptr %NEXT_PC, align 8
  %v3127 = load i64, ptr %RSP, align 8
  %v3128 = load ptr, ptr %MEMORY, align 8
  %v3129 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3128, ptr %state, ptr %RSP, i64 %v3127, i64 32)
  store ptr %v3129, ptr %MEMORY, align 8
  %v3130 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3130, ptr %PC, align 8
  %v3131 = add i64 %v3130, 3
  store i64 %v3131, ptr %NEXT_PC, align 8
  %v3132 = load i64, ptr %RDX, align 8
  %v3133 = load ptr, ptr %MEMORY, align 8
  %v3134 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3133, ptr %state, ptr %RAX, i64 %v3132)
  store ptr %v3134, ptr %MEMORY, align 8
  %v3135 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3135, ptr %PC, align 8
  %v3136 = add i64 %v3135, 3
  store i64 %v3136, ptr %NEXT_PC, align 8
  %v3137 = load i64, ptr %RDX, align 8
  %v3138 = load ptr, ptr %MEMORY, align 8
  %v3139 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3138, ptr %state, ptr %RDI, i64 %v3137)
  store ptr %v3139, ptr %MEMORY, align 8
  %v3140 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3140, ptr %PC, align 8
  %v3141 = add i64 %v3140, 3
  store i64 %v3141, ptr %NEXT_PC, align 8
  %v3142 = load i64, ptr %RCX, align 8
  %v3143 = load ptr, ptr %MEMORY, align 8
  %v3144 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3143, ptr %state, ptr %RBX, i64 %v3142)
  store ptr %v3144, ptr %MEMORY, align 8
  %v3145 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3145, ptr %PC, align 8
  %v3146 = add i64 %v3145, 3
  store i64 %v3146, ptr %NEXT_PC, align 8
  %v3147 = load i64, ptr %RAX, align 8
  %v3148 = load i64, ptr %RAX, align 8
  %v3149 = load ptr, ptr %MEMORY, align 8
  %v3150 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3149, ptr %state, i64 %v3147, i64 %v3148)
  store ptr %v3150, ptr %MEMORY, align 8
  %v3151 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3151, ptr %PC, align 8
  %v3152 = add i64 %v3151, 6
  store i64 %v3152, ptr %NEXT_PC, align 8
  %v3153 = load i64, ptr %NEXT_PC, align 8
  %v3154 = add i64 %v3153, 189
  %v3155 = load i64, ptr %NEXT_PC, align 8
  %v3156 = load ptr, ptr %MEMORY, align 8
  %v3157 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3156, ptr %state, ptr %BRANCH_TAKEN, i64 %v3154, i64 %v3155, ptr %NEXT_PC)
  store ptr %v3157, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878761, label %bb_5389878572

bb_5389878572:                                    ; preds = %bb_5389878530
  %v3158 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3158, ptr %PC, align 8
  %v3159 = add i64 %v3158, 2
  store i64 %v3159, ptr %NEXT_PC, align 8
  %v3160 = load i64, ptr %RAX, align 8
  %v3161 = load i64, ptr %RAX, align 8
  %v3162 = load ptr, ptr %MEMORY, align 8
  %v3163 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3162, ptr %state, i64 %v3160, i64 %v3161)
  store ptr %v3163, ptr %MEMORY, align 8
  %v3164 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3164, ptr %PC, align 8
  %v3165 = add i64 %v3164, 4
  store i64 %v3165, ptr %NEXT_PC, align 8
  %v3166 = load i64, ptr %RAX, align 8
  %v3167 = add i64 %v3166, 48
  %v3168 = load ptr, ptr %MEMORY, align 8
  %v3169 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3168, ptr %state, ptr %RAX, i64 %v3167)
  store ptr %v3169, ptr %MEMORY, align 8
  %v3170 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3170, ptr %PC, align 8
  %v3171 = add i64 %v3170, 5
  store i64 %v3171, ptr %NEXT_PC, align 8
  %v3172 = load i64, ptr %RSP, align 8
  %v3173 = add i64 %v3172, 48
  %v3174 = load i64, ptr %RSI, align 8
  %v3175 = load ptr, ptr %MEMORY, align 8
  %v3176 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3175, ptr %state, i64 %v3173, i64 %v3174)
  store ptr %v3176, ptr %MEMORY, align 8
  %v3177 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3177, ptr %PC, align 8
  %v3178 = add i64 %v3177, 2
  store i64 %v3178, ptr %NEXT_PC, align 8
  %v3179 = load i64, ptr %RAX, align 8
  %v3180 = load i64, ptr %RAX, align 8
  %v3181 = load ptr, ptr %MEMORY, align 8
  %v3182 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3181, ptr %state, i64 %v3179, i64 %v3180)
  store ptr %v3182, ptr %MEMORY, align 8
  %v3183 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3183, ptr %PC, align 8
  %v3184 = add i64 %v3183, 3
  store i64 %v3184, ptr %NEXT_PC, align 8
  %v3185 = load i64, ptr %RDX, align 8
  %v3186 = load ptr, ptr %MEMORY, align 8
  %v3187 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3186, ptr %state, ptr %RAX, i64 %v3185)
  store ptr %v3187, ptr %MEMORY, align 8
  %v3188 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3188, ptr %PC, align 8
  %v3189 = add i64 %v3188, 5
  store i64 %v3189, ptr %NEXT_PC, align 8
  %v3190 = load i64, ptr %RSP, align 8
  %v3191 = add i64 %v3190, 56
  %v3192 = load ptr, ptr %MEMORY, align 8
  %v3193 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3192, ptr %state, ptr %RDX, i64 %v3191)
  store ptr %v3193, ptr %MEMORY, align 8
  %v3194 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3194, ptr %PC, align 8
  %v3195 = add i64 %v3194, 5
  store i64 %v3195, ptr %NEXT_PC, align 8
  %v3196 = load i64, ptr %RSP, align 8
  %v3197 = add i64 %v3196, 56
  %v3198 = load i64, ptr %RAX, align 8
  %v3199 = load ptr, ptr %MEMORY, align 8
  %v3200 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3199, ptr %state, i64 %v3197, i64 %v3198)
  store ptr %v3200, ptr %MEMORY, align 8
  %v3201 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3201, ptr %PC, align 8
  %v3202 = add i64 %v3201, 5
  store i64 %v3202, ptr %NEXT_PC, align 8
  %v3203 = load i64, ptr %NEXT_PC, align 8
  %v3204 = add i64 %v3203, 181
  %v3205 = load i64, ptr %NEXT_PC, align 8
  %v3206 = load ptr, ptr %MEMORY, align 8
  %v3207 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3206, ptr %state, i64 %v3204, ptr %NEXT_PC, i64 %v3205, ptr %RETURN_PC)
  store ptr %v3207, ptr %MEMORY, align 8
  %v3208 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3208, ptr %PC, align 8
  %v3209 = add i64 %v3208, 3
  store i64 %v3209, ptr %NEXT_PC, align 8
  %v3210 = load i64, ptr %RBX, align 8
  %v3211 = add i64 %v3210, 24
  %v3212 = load ptr, ptr %MEMORY, align 8
  %v3213 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3212, ptr %state, ptr %RAX, i64 %v3211)
  store ptr %v3213, ptr %MEMORY, align 8
  %v3214 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3214, ptr %PC, align 8
  %v3215 = add i64 %v3214, 3
  store i64 %v3215, ptr %NEXT_PC, align 8
  %v3216 = load i64, ptr %RAX, align 8
  %v3217 = add i64 %v3216, 1
  %v3218 = load ptr, ptr %MEMORY, align 8
  %v3219 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3218, ptr %state, ptr %RDX, i64 %v3217)
  store ptr %v3219, ptr %MEMORY, align 8
  %v3220 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3220, ptr %PC, align 8
  %v3221 = add i64 %v3220, 3
  store i64 %v3221, ptr %NEXT_PC, align 8
  %v3222 = load i32, ptr %EDX, align 4
  %v3223 = zext i32 %v3222 to i64
  %v3224 = load i64, ptr %RBX, align 8
  %v3225 = add i64 %v3224, 28
  %v3226 = load ptr, ptr %MEMORY, align 8
  %v3227 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3226, ptr %state, i64 %v3223, i64 %v3225)
  store ptr %v3227, ptr %MEMORY, align 8
  %v3228 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3228, ptr %PC, align 8
  %v3229 = add i64 %v3228, 2
  store i64 %v3229, ptr %NEXT_PC, align 8
  %v3230 = load i64, ptr %NEXT_PC, align 8
  %v3231 = add i64 %v3230, 18
  %v3232 = load i64, ptr %NEXT_PC, align 8
  %v3233 = load ptr, ptr %MEMORY, align 8
  %v3234 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3233, ptr %state, ptr %BRANCH_TAKEN, i64 %v3231, i64 %v3232, ptr %NEXT_PC)
  store ptr %v3234, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878632, label %bb_5389878614

bb_5389878614:                                    ; preds = %bb_5389878572
  %v3235 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3235, ptr %PC, align 8
  %v3236 = add i64 %v3235, 6
  store i64 %v3236, ptr %NEXT_PC, align 8
  %v3237 = load ptr, ptr %MEMORY, align 8
  %v3238 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3237, ptr %state, ptr %R8, i64 134217736)
  store ptr %v3238, ptr %MEMORY, align 8
  %v3239 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3239, ptr %PC, align 8
  %v3240 = add i64 %v3239, 4
  store i64 %v3240, ptr %NEXT_PC, align 8
  %v3241 = load i64, ptr %RBX, align 8
  %v3242 = add i64 %v3241, 16
  %v3243 = load ptr, ptr %MEMORY, align 8
  %v3244 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3243, ptr %state, ptr %RCX, i64 %v3242)
  store ptr %v3244, ptr %MEMORY, align 8
  %v3245 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3245, ptr %PC, align 8
  %v3246 = add i64 %v3245, 5
  store i64 %v3246, ptr %NEXT_PC, align 8
  %v3247 = load i64, ptr %NEXT_PC, align 8
  %v3248 = sub i64 %v3247, 644997
  %v3249 = load i64, ptr %NEXT_PC, align 8
  %v3250 = load ptr, ptr %MEMORY, align 8
  %v3251 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3250, ptr %state, i64 %v3248, ptr %NEXT_PC, i64 %v3249, ptr %RETURN_PC)
  store ptr %v3251, ptr %MEMORY, align 8
  %v3252 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3252, ptr %PC, align 8
  %v3253 = add i64 %v3252, 3
  store i64 %v3253, ptr %NEXT_PC, align 8
  %v3254 = load i64, ptr %RBX, align 8
  %v3255 = add i64 %v3254, 24
  %v3256 = load ptr, ptr %MEMORY, align 8
  %v3257 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3256, ptr %state, ptr %RAX, i64 %v3255)
  store ptr %v3257, ptr %MEMORY, align 8
  br label %bb_5389878632

bb_5389878632:                                    ; preds = %bb_5389878614, %bb_5389878572
  %v3258 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3258, ptr %PC, align 8
  %v3259 = add i64 %v3258, 3
  store i64 %v3259, ptr %NEXT_PC, align 8
  %v3260 = load i32, ptr %EAX, align 4
  %v3261 = zext i32 %v3260 to i64
  %v3262 = load i64, ptr %RBX, align 8
  %v3263 = add i64 %v3262, 28
  %v3264 = load ptr, ptr %MEMORY, align 8
  %v3265 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3264, ptr %state, i64 %v3261, i64 %v3263)
  store ptr %v3265, ptr %MEMORY, align 8
  %v3266 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3266, ptr %PC, align 8
  %v3267 = add i64 %v3266, 2
  store i64 %v3267, ptr %NEXT_PC, align 8
  %v3268 = load i64, ptr %NEXT_PC, align 8
  %v3269 = add i64 %v3268, 38
  %v3270 = load i64, ptr %NEXT_PC, align 8
  %v3271 = load ptr, ptr %MEMORY, align 8
  %v3272 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3271, ptr %state, ptr %BRANCH_TAKEN, i64 %v3269, i64 %v3270, ptr %NEXT_PC)
  store ptr %v3272, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878675, label %bb_5389878637

bb_5389878637:                                    ; preds = %bb_5389878632
  %v3273 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3273, ptr %PC, align 8
  %v3274 = add i64 %v3273, 3
  store i64 %v3274, ptr %NEXT_PC, align 8
  %v3275 = load i32, ptr %EAX, align 4
  %v3276 = zext i32 %v3275 to i64
  %v3277 = load ptr, ptr %MEMORY, align 8
  %v3278 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v3277, ptr %state, ptr %RCX, i64 %v3276)
  store ptr %v3278, ptr %MEMORY, align 8
  %v3279 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3279, ptr %PC, align 8
  %v3280 = add i64 %v3279, 4
  store i64 %v3280, ptr %NEXT_PC, align 8
  %v3281 = load i64, ptr %RBX, align 8
  %v3282 = add i64 %v3281, 16
  %v3283 = load ptr, ptr %MEMORY, align 8
  %v3284 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3283, ptr %state, ptr %RAX, i64 %v3282)
  store ptr %v3284, ptr %MEMORY, align 8
  %v3285 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3285, ptr %PC, align 8
  %v3286 = add i64 %v3285, 4
  store i64 %v3286, ptr %NEXT_PC, align 8
  %v3287 = load i64, ptr %RAX, align 8
  %v3288 = load i64, ptr %RCX, align 8
  %v3289 = mul i64 %v3288, 8
  %v3290 = add i64 %v3287, %v3289
  %v3291 = load ptr, ptr %MEMORY, align 8
  %v3292 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3291, ptr %state, ptr %RDX, i64 %v3290)
  store ptr %v3292, ptr %MEMORY, align 8
  %v3293 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3293, ptr %PC, align 8
  %v3294 = add i64 %v3293, 3
  store i64 %v3294, ptr %NEXT_PC, align 8
  %v3295 = load i64, ptr %RDI, align 8
  %v3296 = load ptr, ptr %MEMORY, align 8
  %v3297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3296, ptr %state, ptr %RAX, i64 %v3295)
  store ptr %v3297, ptr %MEMORY, align 8
  %v3298 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3298, ptr %PC, align 8
  %v3299 = add i64 %v3298, 3
  store i64 %v3299, ptr %NEXT_PC, align 8
  %v3300 = load i64, ptr %RAX, align 8
  %v3301 = load i64, ptr %RAX, align 8
  %v3302 = load ptr, ptr %MEMORY, align 8
  %v3303 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3302, ptr %state, i64 %v3300, i64 %v3301)
  store ptr %v3303, ptr %MEMORY, align 8
  %v3304 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3304, ptr %PC, align 8
  %v3305 = add i64 %v3304, 2
  store i64 %v3305, ptr %NEXT_PC, align 8
  %v3306 = load i64, ptr %NEXT_PC, align 8
  %v3307 = add i64 %v3306, 11
  %v3308 = load i64, ptr %NEXT_PC, align 8
  %v3309 = load ptr, ptr %MEMORY, align 8
  %v3310 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3309, ptr %state, ptr %BRANCH_TAKEN, i64 %v3307, i64 %v3308, ptr %NEXT_PC)
  store ptr %v3310, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878667, label %bb_5389878656

bb_5389878656:                                    ; preds = %bb_5389878637
  %v3311 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3311, ptr %PC, align 8
  %v3312 = add i64 %v3311, 2
  store i64 %v3312, ptr %NEXT_PC, align 8
  %v3313 = load i64, ptr %RAX, align 8
  %v3314 = load i64, ptr %RAX, align 8
  %v3315 = load ptr, ptr %MEMORY, align 8
  %v3316 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3315, ptr %state, i64 %v3313, i64 %v3314)
  store ptr %v3316, ptr %MEMORY, align 8
  %v3317 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3317, ptr %PC, align 8
  %v3318 = add i64 %v3317, 4
  store i64 %v3318, ptr %NEXT_PC, align 8
  %v3319 = load i64, ptr %RAX, align 8
  %v3320 = add i64 %v3319, 48
  %v3321 = load ptr, ptr %MEMORY, align 8
  %v3322 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3321, ptr %state, ptr %RAX, i64 %v3320)
  store ptr %v3322, ptr %MEMORY, align 8
  %v3323 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3323, ptr %PC, align 8
  %v3324 = add i64 %v3323, 2
  store i64 %v3324, ptr %NEXT_PC, align 8
  %v3325 = load i64, ptr %RAX, align 8
  %v3326 = load i64, ptr %RAX, align 8
  %v3327 = load ptr, ptr %MEMORY, align 8
  %v3328 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3327, ptr %state, i64 %v3325, i64 %v3326)
  store ptr %v3328, ptr %MEMORY, align 8
  %v3329 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3329, ptr %PC, align 8
  %v3330 = add i64 %v3329, 3
  store i64 %v3330, ptr %NEXT_PC, align 8
  %v3331 = load i64, ptr %RDI, align 8
  %v3332 = load ptr, ptr %MEMORY, align 8
  %v3333 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3332, ptr %state, ptr %RAX, i64 %v3331)
  store ptr %v3333, ptr %MEMORY, align 8
  br label %bb_5389878667

bb_5389878667:                                    ; preds = %bb_5389878656, %bb_5389878637
  %v3334 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3334, ptr %PC, align 8
  %v3335 = add i64 %v3334, 3
  store i64 %v3335, ptr %NEXT_PC, align 8
  %v3336 = load i64, ptr %RDX, align 8
  %v3337 = load i64, ptr %RAX, align 8
  %v3338 = load ptr, ptr %MEMORY, align 8
  %v3339 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3338, ptr %state, i64 %v3336, i64 %v3337)
  store ptr %v3339, ptr %MEMORY, align 8
  %v3340 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3340, ptr %PC, align 8
  %v3341 = add i64 %v3340, 3
  store i64 %v3341, ptr %NEXT_PC, align 8
  %v3342 = load i64, ptr %RBX, align 8
  %v3343 = add i64 %v3342, 24
  %v3344 = load i64, ptr %RBX, align 8
  %v3345 = add i64 %v3344, 24
  %v3346 = load ptr, ptr %MEMORY, align 8
  %v3347 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3346, ptr %state, i64 %v3343, i64 %v3345)
  store ptr %v3347, ptr %MEMORY, align 8
  %v3348 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3348, ptr %PC, align 8
  %v3349 = add i64 %v3348, 2
  store i64 %v3349, ptr %NEXT_PC, align 8
  %v3350 = load i64, ptr %NEXT_PC, align 8
  %v3351 = add i64 %v3350, 53
  %v3352 = load ptr, ptr %MEMORY, align 8
  %v3353 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v3352, ptr %state, i64 %v3351, ptr %NEXT_PC)
  store ptr %v3353, ptr %MEMORY, align 8
  br label %bb_5389878728

bb_5389878675:                                    ; preds = %bb_5389878632
  %v3354 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3354, ptr %PC, align 8
  %v3355 = add i64 %v3354, 6
  store i64 %v3355, ptr %NEXT_PC, align 8
  %v3356 = load ptr, ptr %MEMORY, align 8
  %v3357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3356, ptr %state, ptr %R8, i64 134217736)
  store ptr %v3357, ptr %MEMORY, align 8
  %v3358 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3358, ptr %PC, align 8
  %v3359 = add i64 %v3358, 4
  store i64 %v3359, ptr %NEXT_PC, align 8
  %v3360 = load i64, ptr %RBX, align 8
  %v3361 = add i64 %v3360, 16
  %v3362 = load ptr, ptr %MEMORY, align 8
  %v3363 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3362, ptr %state, ptr %RCX, i64 %v3361)
  store ptr %v3363, ptr %MEMORY, align 8
  %v3364 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3364, ptr %PC, align 8
  %v3365 = add i64 %v3364, 3
  store i64 %v3365, ptr %NEXT_PC, align 8
  %v3366 = load i64, ptr %RDI, align 8
  %v3367 = load ptr, ptr %MEMORY, align 8
  %v3368 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3367, ptr %state, ptr %RDX, i64 %v3366)
  store ptr %v3368, ptr %MEMORY, align 8
  %v3369 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3369, ptr %PC, align 8
  %v3370 = add i64 %v3369, 5
  store i64 %v3370, ptr %NEXT_PC, align 8
  %v3371 = load i64, ptr %NEXT_PC, align 8
  %v3372 = sub i64 %v3371, 644773
  %v3373 = load i64, ptr %NEXT_PC, align 8
  %v3374 = load ptr, ptr %MEMORY, align 8
  %v3375 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3374, ptr %state, i64 %v3372, ptr %NEXT_PC, i64 %v3373, ptr %RETURN_PC)
  store ptr %v3375, ptr %MEMORY, align 8
  %v3376 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3376, ptr %PC, align 8
  %v3377 = add i64 %v3376, 4
  store i64 %v3377, ptr %NEXT_PC, align 8
  %v3378 = load i64, ptr %RBX, align 8
  %v3379 = add i64 %v3378, 16
  %v3380 = load ptr, ptr %MEMORY, align 8
  %v3381 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3380, ptr %state, ptr %RCX, i64 %v3379)
  store ptr %v3381, ptr %MEMORY, align 8
  %v3382 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3382, ptr %PC, align 8
  %v3383 = add i64 %v3382, 4
  store i64 %v3383, ptr %NEXT_PC, align 8
  %v3384 = load i64, ptr %RBX, align 8
  %v3385 = add i64 %v3384, 24
  %v3386 = load ptr, ptr %MEMORY, align 8
  %v3387 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %v3386, ptr %state, ptr %RDX, i64 %v3385)
  store ptr %v3387, ptr %MEMORY, align 8
  %v3388 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3388, ptr %PC, align 8
  %v3389 = add i64 %v3388, 4
  store i64 %v3389, ptr %NEXT_PC, align 8
  %v3390 = load i64, ptr %RCX, align 8
  %v3391 = load i64, ptr %RDX, align 8
  %v3392 = mul i64 %v3391, 8
  %v3393 = add i64 %v3390, %v3392
  %v3394 = load ptr, ptr %MEMORY, align 8
  %v3395 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v3394, ptr %state, ptr %R8, i64 %v3393)
  store ptr %v3395, ptr %MEMORY, align 8
  %v3396 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3396, ptr %PC, align 8
  %v3397 = add i64 %v3396, 3
  store i64 %v3397, ptr %NEXT_PC, align 8
  %v3398 = load i64, ptr %RAX, align 8
  %v3399 = load ptr, ptr %MEMORY, align 8
  %v3400 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3399, ptr %state, ptr %RCX, i64 %v3398)
  store ptr %v3400, ptr %MEMORY, align 8
  %v3401 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3401, ptr %PC, align 8
  %v3402 = add i64 %v3401, 3
  store i64 %v3402, ptr %NEXT_PC, align 8
  %v3403 = load i64, ptr %RCX, align 8
  %v3404 = load i64, ptr %RCX, align 8
  %v3405 = load ptr, ptr %MEMORY, align 8
  %v3406 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3405, ptr %state, i64 %v3403, i64 %v3404)
  store ptr %v3406, ptr %MEMORY, align 8
  %v3407 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3407, ptr %PC, align 8
  %v3408 = add i64 %v3407, 2
  store i64 %v3408, ptr %NEXT_PC, align 8
  %v3409 = load i64, ptr %NEXT_PC, align 8
  %v3410 = add i64 %v3409, 11
  %v3411 = load i64, ptr %NEXT_PC, align 8
  %v3412 = load ptr, ptr %MEMORY, align 8
  %v3413 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3412, ptr %state, ptr %BRANCH_TAKEN, i64 %v3410, i64 %v3411, ptr %NEXT_PC)
  store ptr %v3413, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878724, label %bb_5389878713

bb_5389878713:                                    ; preds = %bb_5389878675
  %v3414 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3414, ptr %PC, align 8
  %v3415 = add i64 %v3414, 2
  store i64 %v3415, ptr %NEXT_PC, align 8
  %v3416 = load i64, ptr %RCX, align 8
  %v3417 = load i64, ptr %RCX, align 8
  %v3418 = load ptr, ptr %MEMORY, align 8
  %v3419 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3418, ptr %state, i64 %v3416, i64 %v3417)
  store ptr %v3419, ptr %MEMORY, align 8
  %v3420 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3420, ptr %PC, align 8
  %v3421 = add i64 %v3420, 4
  store i64 %v3421, ptr %NEXT_PC, align 8
  %v3422 = load i64, ptr %RCX, align 8
  %v3423 = add i64 %v3422, 48
  %v3424 = load ptr, ptr %MEMORY, align 8
  %v3425 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3424, ptr %state, ptr %RCX, i64 %v3423)
  store ptr %v3425, ptr %MEMORY, align 8
  %v3426 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3426, ptr %PC, align 8
  %v3427 = add i64 %v3426, 2
  store i64 %v3427, ptr %NEXT_PC, align 8
  %v3428 = load i64, ptr %RCX, align 8
  %v3429 = load i64, ptr %RCX, align 8
  %v3430 = load ptr, ptr %MEMORY, align 8
  %v3431 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3430, ptr %state, i64 %v3428, i64 %v3429)
  store ptr %v3431, ptr %MEMORY, align 8
  %v3432 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3432, ptr %PC, align 8
  %v3433 = add i64 %v3432, 3
  store i64 %v3433, ptr %NEXT_PC, align 8
  %v3434 = load i64, ptr %RAX, align 8
  %v3435 = load ptr, ptr %MEMORY, align 8
  %v3436 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3435, ptr %state, ptr %RCX, i64 %v3434)
  store ptr %v3436, ptr %MEMORY, align 8
  br label %bb_5389878724

bb_5389878724:                                    ; preds = %bb_5389878713, %bb_5389878675
  %v3437 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3437, ptr %PC, align 8
  %v3438 = add i64 %v3437, 4
  store i64 %v3438, ptr %NEXT_PC, align 8
  %v3439 = load i64, ptr %R8, align 8
  %v3440 = sub i64 %v3439, 8
  %v3441 = load i64, ptr %RCX, align 8
  %v3442 = load ptr, ptr %MEMORY, align 8
  %v3443 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3442, ptr %state, i64 %v3440, i64 %v3441)
  store ptr %v3443, ptr %MEMORY, align 8
  br label %bb_5389878728

bb_5389878728:                                    ; preds = %bb_5389878724, %bb_5389878667
  %v3444 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3444, ptr %PC, align 8
  %v3445 = add i64 %v3444, 3
  store i64 %v3445, ptr %NEXT_PC, align 8
  %v3446 = load i64, ptr %RDI, align 8
  %v3447 = load ptr, ptr %MEMORY, align 8
  %v3448 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3447, ptr %state, ptr %RCX, i64 %v3446)
  store ptr %v3448, ptr %MEMORY, align 8
  %v3449 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3449, ptr %PC, align 8
  %v3450 = add i64 %v3449, 4
  store i64 %v3450, ptr %NEXT_PC, align 8
  %v3451 = load i64, ptr %RBX, align 8
  %v3452 = add i64 %v3451, 48
  %v3453 = load ptr, ptr %MEMORY, align 8
  %v3454 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3453, ptr %state, ptr %RAX, i64 %v3452)
  store ptr %v3454, ptr %MEMORY, align 8
  %v3455 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3455, ptr %PC, align 8
  %v3456 = add i64 %v3455, 5
  store i64 %v3456, ptr %NEXT_PC, align 8
  %v3457 = load i64, ptr %RSP, align 8
  %v3458 = add i64 %v3457, 48
  %v3459 = load ptr, ptr %MEMORY, align 8
  %v3460 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3459, ptr %state, ptr %RSI, i64 %v3458)
  store ptr %v3460, ptr %MEMORY, align 8
  %v3461 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3461, ptr %PC, align 8
  %v3462 = add i64 %v3461, 4
  store i64 %v3462, ptr %NEXT_PC, align 8
  %v3463 = load i64, ptr %RCX, align 8
  %v3464 = add i64 %v3463, 48
  %v3465 = load i64, ptr %RAX, align 8
  %v3466 = load ptr, ptr %MEMORY, align 8
  %v3467 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v3466, ptr %state, i64 %v3464, i64 %v3465)
  store ptr %v3467, ptr %MEMORY, align 8
  %v3468 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3468, ptr %PC, align 8
  %v3469 = add i64 %v3468, 2
  store i64 %v3469, ptr %NEXT_PC, align 8
  %v3470 = load i64, ptr %NEXT_PC, align 8
  %v3471 = add i64 %v3470, 5
  %v3472 = load i64, ptr %NEXT_PC, align 8
  %v3473 = load ptr, ptr %MEMORY, align 8
  %v3474 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3473, ptr %state, ptr %BRANCH_TAKEN, i64 %v3471, i64 %v3472, ptr %NEXT_PC)
  store ptr %v3474, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878751, label %bb_5389878746

bb_5389878746:                                    ; preds = %bb_5389878728
  %v3475 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3475, ptr %PC, align 8
  %v3476 = add i64 %v3475, 2
  store i64 %v3476, ptr %NEXT_PC, align 8
  %v3477 = load i64, ptr %RAX, align 8
  %v3478 = load i64, ptr %RAX, align 8
  %v3479 = load ptr, ptr %MEMORY, align 8
  %v3480 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3479, ptr %state, i64 %v3477, i64 %v3478)
  store ptr %v3480, ptr %MEMORY, align 8
  %v3481 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3481, ptr %PC, align 8
  %v3482 = add i64 %v3481, 3
  store i64 %v3482, ptr %NEXT_PC, align 8
  %v3483 = load i64, ptr %RDI, align 8
  %v3484 = load ptr, ptr %MEMORY, align 8
  %v3485 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3484, ptr %state, ptr %RCX, i64 %v3483)
  store ptr %v3485, ptr %MEMORY, align 8
  br label %bb_5389878751

bb_5389878751:                                    ; preds = %bb_5389878746, %bb_5389878728
  %v3486 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3486, ptr %PC, align 8
  %v3487 = add i64 %v3486, 3
  store i64 %v3487, ptr %NEXT_PC, align 8
  %v3488 = load i64, ptr %RCX, align 8
  %v3489 = load i64, ptr %RCX, align 8
  %v3490 = load ptr, ptr %MEMORY, align 8
  %v3491 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3490, ptr %state, i64 %v3488, i64 %v3489)
  store ptr %v3491, ptr %MEMORY, align 8
  %v3492 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3492, ptr %PC, align 8
  %v3493 = add i64 %v3492, 2
  store i64 %v3493, ptr %NEXT_PC, align 8
  %v3494 = load i64, ptr %NEXT_PC, align 8
  %v3495 = add i64 %v3494, 5
  %v3496 = load i64, ptr %NEXT_PC, align 8
  %v3497 = load ptr, ptr %MEMORY, align 8
  %v3498 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3497, ptr %state, ptr %BRANCH_TAKEN, i64 %v3495, i64 %v3496, ptr %NEXT_PC)
  store ptr %v3498, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878761, label %bb_5389878756

bb_5389878756:                                    ; preds = %bb_5389878751
  %v3499 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3499, ptr %PC, align 8
  %v3500 = add i64 %v3499, 5
  store i64 %v3500, ptr %NEXT_PC, align 8
  %v3501 = load i64, ptr %NEXT_PC, align 8
  %v3502 = sub i64 %v3501, 2057
  %v3503 = load i64, ptr %NEXT_PC, align 8
  %v3504 = load ptr, ptr %MEMORY, align 8
  %v3505 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3504, ptr %state, i64 %v3502, ptr %NEXT_PC, i64 %v3503, ptr %RETURN_PC)
  store ptr %v3505, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878761:                                    ; preds = %bb_5389878751, %bb_5389878530
  %v3506 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3506, ptr %PC, align 8
  %v3507 = add i64 %v3506, 5
  store i64 %v3507, ptr %NEXT_PC, align 8
  %v3508 = load i64, ptr %RSP, align 8
  %v3509 = add i64 %v3508, 64
  %v3510 = load ptr, ptr %MEMORY, align 8
  %v3511 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3510, ptr %state, ptr %RBX, i64 %v3509)
  store ptr %v3511, ptr %MEMORY, align 8
  %v3512 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3512, ptr %PC, align 8
  %v3513 = add i64 %v3512, 4
  store i64 %v3513, ptr %NEXT_PC, align 8
  %v3514 = load i64, ptr %RSP, align 8
  %v3515 = load ptr, ptr %MEMORY, align 8
  %v3516 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3515, ptr %state, ptr %RSP, i64 %v3514, i64 32)
  store ptr %v3516, ptr %MEMORY, align 8
  %v3517 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3517, ptr %PC, align 8
  %v3518 = add i64 %v3517, 1
  store i64 %v3518, ptr %NEXT_PC, align 8
  %v3519 = load ptr, ptr %MEMORY, align 8
  %v3520 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3519, ptr %state, ptr %RDI)
  store ptr %v3520, ptr %MEMORY, align 8
  %v3521 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3521, ptr %PC, align 8
  %v3522 = add i64 %v3521, 1
  store i64 %v3522, ptr %NEXT_PC, align 8
  %v3523 = load ptr, ptr %MEMORY, align 8
  %v3524 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3523, ptr %state, ptr %NEXT_PC)
  store ptr %v3524, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878772:                                    ; No predecessors!
  %v3525 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3525, ptr %PC, align 8
  %v3526 = add i64 %v3525, 1
  store i64 %v3526, ptr %NEXT_PC, align 8
  %v3527 = load ptr, ptr %MEMORY, align 8
  %v3528 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3527, ptr %state, ptr undef)
  store ptr %v3528, ptr %MEMORY, align 8
  %v3529 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3529, ptr %PC, align 8
  %v3530 = add i64 %v3529, 1
  store i64 %v3530, ptr %NEXT_PC, align 8
  %v3531 = load ptr, ptr %MEMORY, align 8
  %v3532 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3531, ptr %state, ptr undef)
  store ptr %v3532, ptr %MEMORY, align 8
  %v3533 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3533, ptr %PC, align 8
  %v3534 = add i64 %v3533, 1
  store i64 %v3534, ptr %NEXT_PC, align 8
  %v3535 = load ptr, ptr %MEMORY, align 8
  %v3536 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3535, ptr %state, ptr undef)
  store ptr %v3536, ptr %MEMORY, align 8
  %v3537 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3537, ptr %PC, align 8
  %v3538 = add i64 %v3537, 1
  store i64 %v3538, ptr %NEXT_PC, align 8
  %v3539 = load ptr, ptr %MEMORY, align 8
  %v3540 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3539, ptr %state, ptr undef)
  store ptr %v3540, ptr %MEMORY, align 8
  %v3541 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3541, ptr %PC, align 8
  %v3542 = add i64 %v3541, 1
  store i64 %v3542, ptr %NEXT_PC, align 8
  %v3543 = load ptr, ptr %MEMORY, align 8
  %v3544 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3543, ptr %state, ptr undef)
  store ptr %v3544, ptr %MEMORY, align 8
  %v3545 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3545, ptr %PC, align 8
  %v3546 = add i64 %v3545, 1
  store i64 %v3546, ptr %NEXT_PC, align 8
  %v3547 = load ptr, ptr %MEMORY, align 8
  %v3548 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3547, ptr %state, ptr undef)
  store ptr %v3548, ptr %MEMORY, align 8
  %v3549 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3549, ptr %PC, align 8
  %v3550 = add i64 %v3549, 1
  store i64 %v3550, ptr %NEXT_PC, align 8
  %v3551 = load ptr, ptr %MEMORY, align 8
  %v3552 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3551, ptr %state, ptr undef)
  store ptr %v3552, ptr %MEMORY, align 8
  %v3553 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3553, ptr %PC, align 8
  %v3554 = add i64 %v3553, 1
  store i64 %v3554, ptr %NEXT_PC, align 8
  %v3555 = load ptr, ptr %MEMORY, align 8
  %v3556 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3555, ptr %state, ptr undef)
  store ptr %v3556, ptr %MEMORY, align 8
  %v3557 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3557, ptr %PC, align 8
  %v3558 = add i64 %v3557, 1
  store i64 %v3558, ptr %NEXT_PC, align 8
  %v3559 = load ptr, ptr %MEMORY, align 8
  %v3560 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3559, ptr %state, ptr undef)
  store ptr %v3560, ptr %MEMORY, align 8
  %v3561 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3561, ptr %PC, align 8
  %v3562 = add i64 %v3561, 1
  store i64 %v3562, ptr %NEXT_PC, align 8
  %v3563 = load ptr, ptr %MEMORY, align 8
  %v3564 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3563, ptr %state, ptr undef)
  store ptr %v3564, ptr %MEMORY, align 8
  %v3565 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3565, ptr %PC, align 8
  %v3566 = add i64 %v3565, 1
  store i64 %v3566, ptr %NEXT_PC, align 8
  %v3567 = load ptr, ptr %MEMORY, align 8
  %v3568 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3567, ptr %state, ptr undef)
  store ptr %v3568, ptr %MEMORY, align 8
  %v3569 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3569, ptr %PC, align 8
  %v3570 = add i64 %v3569, 1
  store i64 %v3570, ptr %NEXT_PC, align 8
  %v3571 = load ptr, ptr %MEMORY, align 8
  %v3572 = call ptr @_ZN12_GLOBAL__N_16DoINT3EP6MemoryR5State3RnWImE(ptr %v3571, ptr %state, ptr undef)
  store ptr %v3572, ptr %MEMORY, align 8
  %v3573 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3573, ptr %PC, align 8
  %v3574 = add i64 %v3573, 2
  store i64 %v3574, ptr %NEXT_PC, align 8
  %v3575 = load i64, ptr %RBX, align 8
  %v3576 = load ptr, ptr %MEMORY, align 8
  %v3577 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v3576, ptr %state, i64 %v3575)
  store ptr %v3577, ptr %MEMORY, align 8
  %v3578 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3578, ptr %PC, align 8
  %v3579 = add i64 %v3578, 2
  store i64 %v3579, ptr %NEXT_PC, align 8
  %v3580 = load i64, ptr %R13, align 8
  %v3581 = load ptr, ptr %MEMORY, align 8
  %v3582 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v3581, ptr %state, i64 %v3580)
  store ptr %v3582, ptr %MEMORY, align 8
  %v3583 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3583, ptr %PC, align 8
  %v3584 = add i64 %v3583, 4
  store i64 %v3584, ptr %NEXT_PC, align 8
  %v3585 = load i64, ptr %RSP, align 8
  %v3586 = load ptr, ptr %MEMORY, align 8
  %v3587 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3586, ptr %state, ptr %RSP, i64 %v3585, i64 56)
  store ptr %v3587, ptr %MEMORY, align 8
  %v3588 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3588, ptr %PC, align 8
  %v3589 = add i64 %v3588, 4
  store i64 %v3589, ptr %NEXT_PC, align 8
  %v3590 = load i64, ptr %RCX, align 8
  %v3591 = add i64 %v3590, 24
  %v3592 = load ptr, ptr %MEMORY, align 8
  %v3593 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2MnIjElEEP6MemoryS6_R5StateT_T0_(ptr %v3592, ptr %state, ptr %RAX, i64 %v3591)
  store ptr %v3593, ptr %MEMORY, align 8
  %v3594 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3594, ptr %PC, align 8
  %v3595 = add i64 %v3594, 3
  store i64 %v3595, ptr %NEXT_PC, align 8
  %v3596 = load i64, ptr %R13, align 8
  %v3597 = load i32, ptr %R13D, align 4
  %v3598 = zext i32 %v3597 to i64
  %v3599 = load ptr, ptr %MEMORY, align 8
  %v3600 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3599, ptr %state, ptr %R13, i64 %v3596, i64 %v3598)
  store ptr %v3600, ptr %MEMORY, align 8
  %v3601 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3601, ptr %PC, align 8
  %v3602 = add i64 %v3601, 5
  store i64 %v3602, ptr %NEXT_PC, align 8
  %v3603 = load i64, ptr %RSP, align 8
  %v3604 = add i64 %v3603, 88
  %v3605 = load i64, ptr %RSI, align 8
  %v3606 = load ptr, ptr %MEMORY, align 8
  %v3607 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3606, ptr %state, i64 %v3604, i64 %v3605)
  store ptr %v3607, ptr %MEMORY, align 8
  %v3608 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3608, ptr %PC, align 8
  %v3609 = add i64 %v3608, 3
  store i64 %v3609, ptr %NEXT_PC, align 8
  %v3610 = load i64, ptr %RCX, align 8
  %v3611 = load ptr, ptr %MEMORY, align 8
  %v3612 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3611, ptr %state, ptr %RSI, i64 %v3610)
  store ptr %v3612, ptr %MEMORY, align 8
  %v3613 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3613, ptr %PC, align 8
  %v3614 = add i64 %v3613, 5
  store i64 %v3614, ptr %NEXT_PC, align 8
  %v3615 = load i64, ptr %RSP, align 8
  %v3616 = add i64 %v3615, 32
  %v3617 = load i64, ptr %R15, align 8
  %v3618 = load ptr, ptr %MEMORY, align 8
  %v3619 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3618, ptr %state, i64 %v3616, i64 %v3617)
  store ptr %v3619, ptr %MEMORY, align 8
  %v3620 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3620, ptr %PC, align 8
  %v3621 = add i64 %v3620, 3
  store i64 %v3621, ptr %NEXT_PC, align 8
  %v3622 = load i64, ptr %RDX, align 8
  %v3623 = load ptr, ptr %MEMORY, align 8
  %v3624 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3623, ptr %state, ptr %R15, i64 %v3622)
  store ptr %v3624, ptr %MEMORY, align 8
  %v3625 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3625, ptr %PC, align 8
  %v3626 = add i64 %v3625, 3
  store i64 %v3626, ptr %NEXT_PC, align 8
  %v3627 = load i32, ptr %R13D, align 4
  %v3628 = zext i32 %v3627 to i64
  %v3629 = load ptr, ptr %MEMORY, align 8
  %v3630 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3629, ptr %state, ptr %R9, i64 %v3628)
  store ptr %v3630, ptr %MEMORY, align 8
  %v3631 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3631, ptr %PC, align 8
  %v3632 = add i64 %v3631, 2
  store i64 %v3632, ptr %NEXT_PC, align 8
  %v3633 = load i32, ptr %EAX, align 4
  %v3634 = zext i32 %v3633 to i64
  %v3635 = load i32, ptr %EAX, align 4
  %v3636 = zext i32 %v3635 to i64
  %v3637 = load ptr, ptr %MEMORY, align 8
  %v3638 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3637, ptr %state, i64 %v3634, i64 %v3636)
  store ptr %v3638, ptr %MEMORY, align 8
  %v3639 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3639, ptr %PC, align 8
  %v3640 = add i64 %v3639, 6
  store i64 %v3640, ptr %NEXT_PC, align 8
  %v3641 = load i64, ptr %NEXT_PC, align 8
  %v3642 = add i64 %v3641, 273
  %v3643 = load i64, ptr %NEXT_PC, align 8
  %v3644 = load ptr, ptr %MEMORY, align 8
  %v3645 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3644, ptr %state, ptr %BRANCH_TAKEN, i64 %v3642, i64 %v3643, ptr %NEXT_PC)
  store ptr %v3645, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879099, label %bb_5389878826

bb_5389878826:                                    ; preds = %bb_5389878772
  %v3646 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3646, ptr %PC, align 8
  %v3647 = add i64 %v3646, 3
  store i64 %v3647, ptr %NEXT_PC, align 8
  %v3648 = load i64, ptr %RDX, align 8
  %v3649 = load ptr, ptr %MEMORY, align 8
  %v3650 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3649, ptr %state, ptr %RCX, i64 %v3648)
  store ptr %v3650, ptr %MEMORY, align 8
  %v3651 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3651, ptr %PC, align 8
  %v3652 = add i64 %v3651, 3
  store i64 %v3652, ptr %NEXT_PC, align 8
  %v3653 = load i64, ptr %RAX, align 8
  %v3654 = load ptr, ptr %MEMORY, align 8
  %v3655 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3654, ptr %state, ptr %R10, i64 %v3653)
  store ptr %v3655, ptr %MEMORY, align 8
  %v3656 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3656, ptr %PC, align 8
  %v3657 = add i64 %v3656, 4
  store i64 %v3657, ptr %NEXT_PC, align 8
  %v3658 = load i64, ptr %RSI, align 8
  %v3659 = add i64 %v3658, 16
  %v3660 = load ptr, ptr %MEMORY, align 8
  %v3661 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3660, ptr %state, ptr %RAX, i64 %v3659)
  store ptr %v3661, ptr %MEMORY, align 8
  %v3662 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3662, ptr %PC, align 8
  %v3663 = add i64 %v3662, 3
  store i64 %v3663, ptr %NEXT_PC, align 8
  %v3664 = load i32, ptr %R13D, align 4
  %v3665 = zext i32 %v3664 to i64
  %v3666 = load ptr, ptr %MEMORY, align 8
  %v3667 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3666, ptr %state, ptr %R8, i64 %v3665)
  store ptr %v3667, ptr %MEMORY, align 8
  br label %bb_5389878839

bb_5389878839:                                    ; preds = %bb_5389878844, %bb_5389878826
  %v3668 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3668, ptr %PC, align 8
  %v3669 = add i64 %v3668, 3
  store i64 %v3669, ptr %NEXT_PC, align 8
  %v3670 = load i64, ptr %RAX, align 8
  %v3671 = load i64, ptr %RCX, align 8
  %v3672 = load ptr, ptr %MEMORY, align 8
  %v3673 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v3672, ptr %state, i64 %v3670, i64 %v3671)
  store ptr %v3673, ptr %MEMORY, align 8
  %v3674 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3674, ptr %PC, align 8
  %v3675 = add i64 %v3674, 2
  store i64 %v3675, ptr %NEXT_PC, align 8
  %v3676 = load i64, ptr %NEXT_PC, align 8
  %v3677 = add i64 %v3676, 20
  %v3678 = load i64, ptr %NEXT_PC, align 8
  %v3679 = load ptr, ptr %MEMORY, align 8
  %v3680 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3679, ptr %state, ptr %BRANCH_TAKEN, i64 %v3677, i64 %v3678, ptr %NEXT_PC)
  store ptr %v3680, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878864, label %bb_5389878844

bb_5389878844:                                    ; preds = %bb_5389878839
  %v3681 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3681, ptr %PC, align 8
  %v3682 = add i64 %v3681, 3
  store i64 %v3682, ptr %NEXT_PC, align 8
  %v3683 = load i64, ptr %R9, align 8
  %v3684 = load ptr, ptr %MEMORY, align 8
  %v3685 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3684, ptr %state, ptr %R9, i64 %v3683)
  store ptr %v3685, ptr %MEMORY, align 8
  %v3686 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3686, ptr %PC, align 8
  %v3687 = add i64 %v3686, 3
  store i64 %v3687, ptr %NEXT_PC, align 8
  %v3688 = load i64, ptr %R8, align 8
  %v3689 = load ptr, ptr %MEMORY, align 8
  %v3690 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3689, ptr %state, ptr %R8, i64 %v3688)
  store ptr %v3690, ptr %MEMORY, align 8
  %v3691 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3691, ptr %PC, align 8
  %v3692 = add i64 %v3691, 4
  store i64 %v3692, ptr %NEXT_PC, align 8
  %v3693 = load i64, ptr %RAX, align 8
  %v3694 = load ptr, ptr %MEMORY, align 8
  %v3695 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3694, ptr %state, ptr %RAX, i64 %v3693, i64 8)
  store ptr %v3695, ptr %MEMORY, align 8
  %v3696 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3696, ptr %PC, align 8
  %v3697 = add i64 %v3696, 3
  store i64 %v3697, ptr %NEXT_PC, align 8
  %v3698 = load i64, ptr %R8, align 8
  %v3699 = load i64, ptr %R10, align 8
  %v3700 = load ptr, ptr %MEMORY, align 8
  %v3701 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3700, ptr %state, i64 %v3698, i64 %v3699)
  store ptr %v3701, ptr %MEMORY, align 8
  %v3702 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3702, ptr %PC, align 8
  %v3703 = add i64 %v3702, 2
  store i64 %v3703, ptr %NEXT_PC, align 8
  %v3704 = load i64, ptr %NEXT_PC, align 8
  %v3705 = sub i64 %v3704, 20
  %v3706 = load i64, ptr %NEXT_PC, align 8
  %v3707 = load ptr, ptr %MEMORY, align 8
  %v3708 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3707, ptr %state, ptr %BRANCH_TAKEN, i64 %v3705, i64 %v3706, ptr %NEXT_PC)
  store ptr %v3708, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878839, label %bb_5389878859

bb_5389878859:                                    ; preds = %bb_5389878844
  %v3709 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3709, ptr %PC, align 8
  %v3710 = add i64 %v3709, 5
  store i64 %v3710, ptr %NEXT_PC, align 8
  %v3711 = load i64, ptr %NEXT_PC, align 8
  %v3712 = add i64 %v3711, 235
  %v3713 = load ptr, ptr %MEMORY, align 8
  %v3714 = call ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr %v3713, ptr %state, i64 %v3712, ptr %NEXT_PC)
  store ptr %v3714, ptr %MEMORY, align 8
  br label %bb_5389879099

bb_5389878864:                                    ; preds = %bb_5389878839
  %v3715 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3715, ptr %PC, align 8
  %v3716 = add i64 %v3715, 4
  store i64 %v3716, ptr %NEXT_PC, align 8
  %v3717 = load i64, ptr %RSI, align 8
  %v3718 = add i64 %v3717, 48
  %v3719 = load ptr, ptr %MEMORY, align 8
  %v3720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3719, ptr %state, ptr %RAX, i64 %v3718)
  store ptr %v3720, ptr %MEMORY, align 8
  %v3721 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3721, ptr %PC, align 8
  %v3722 = add i64 %v3721, 5
  store i64 %v3722, ptr %NEXT_PC, align 8
  %v3723 = load i64, ptr %RSP, align 8
  %v3724 = add i64 %v3723, 80
  %v3725 = load i64, ptr %RBP, align 8
  %v3726 = load ptr, ptr %MEMORY, align 8
  %v3727 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3726, ptr %state, i64 %v3724, i64 %v3725)
  store ptr %v3727, ptr %MEMORY, align 8
  %v3728 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3728, ptr %PC, align 8
  %v3729 = add i64 %v3728, 5
  store i64 %v3729, ptr %NEXT_PC, align 8
  %v3730 = load i64, ptr %RSP, align 8
  %v3731 = add i64 %v3730, 96
  %v3732 = load i64, ptr %RDI, align 8
  %v3733 = load ptr, ptr %MEMORY, align 8
  %v3734 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3733, ptr %state, i64 %v3731, i64 %v3732)
  store ptr %v3734, ptr %MEMORY, align 8
  %v3735 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3735, ptr %PC, align 8
  %v3736 = add i64 %v3735, 5
  store i64 %v3736, ptr %NEXT_PC, align 8
  %v3737 = load i64, ptr %RSP, align 8
  %v3738 = add i64 %v3737, 48
  %v3739 = load i64, ptr %R12, align 8
  %v3740 = load ptr, ptr %MEMORY, align 8
  %v3741 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3740, ptr %state, i64 %v3738, i64 %v3739)
  store ptr %v3741, ptr %MEMORY, align 8
  %v3742 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3742, ptr %PC, align 8
  %v3743 = add i64 %v3742, 5
  store i64 %v3743, ptr %NEXT_PC, align 8
  %v3744 = load i64, ptr %RSP, align 8
  %v3745 = add i64 %v3744, 40
  %v3746 = load i64, ptr %R14, align 8
  %v3747 = load ptr, ptr %MEMORY, align 8
  %v3748 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3747, ptr %state, i64 %v3745, i64 %v3746)
  store ptr %v3748, ptr %MEMORY, align 8
  %v3749 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3749, ptr %PC, align 8
  %v3750 = add i64 %v3749, 4
  store i64 %v3750, ptr %NEXT_PC, align 8
  %v3751 = load i64, ptr %RCX, align 8
  %v3752 = add i64 %v3751, 48
  %v3753 = load i64, ptr %RAX, align 8
  %v3754 = load ptr, ptr %MEMORY, align 8
  %v3755 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnImE2InImEEEP6MemoryS6_R5StateT_T0_(ptr %v3754, ptr %state, i64 %v3752, i64 %v3753)
  store ptr %v3755, ptr %MEMORY, align 8
  %v3756 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3756, ptr %PC, align 8
  %v3757 = add i64 %v3756, 2
  store i64 %v3757, ptr %NEXT_PC, align 8
  %v3758 = load i64, ptr %NEXT_PC, align 8
  %v3759 = add i64 %v3758, 2
  %v3760 = load i64, ptr %NEXT_PC, align 8
  %v3761 = load ptr, ptr %MEMORY, align 8
  %v3762 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3761, ptr %state, ptr %BRANCH_TAKEN, i64 %v3759, i64 %v3760, ptr %NEXT_PC)
  store ptr %v3762, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878896, label %bb_5389878894

bb_5389878894:                                    ; preds = %bb_5389878864
  %v3763 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3763, ptr %PC, align 8
  %v3764 = add i64 %v3763, 2
  store i64 %v3764, ptr %NEXT_PC, align 8
  %v3765 = load i64, ptr %RAX, align 8
  %v3766 = load i64, ptr %RAX, align 8
  %v3767 = load ptr, ptr %MEMORY, align 8
  %v3768 = call ptr @_ZN12_GLOBAL__N_13INCI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3767, ptr %state, i64 %v3765, i64 %v3766)
  store ptr %v3768, ptr %MEMORY, align 8
  br label %bb_5389878896

bb_5389878896:                                    ; preds = %bb_5389878894, %bb_5389878864
  %v3769 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3769, ptr %PC, align 8
  %v3770 = add i64 %v3769, 3
  store i64 %v3770, ptr %NEXT_PC, align 8
  %v3771 = load i32, ptr %R9D, align 4
  %v3772 = zext i32 %v3771 to i64
  %v3773 = load ptr, ptr %MEMORY, align 8
  %v3774 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v3773, ptr %state, ptr %RDI, i64 %v3772)
  store ptr %v3774, ptr %MEMORY, align 8
  %v3775 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3775, ptr %PC, align 8
  %v3776 = add i64 %v3775, 4
  store i64 %v3776, ptr %NEXT_PC, align 8
  %v3777 = load i64, ptr %R9, align 8
  %v3778 = add i64 %v3777, 1
  %v3779 = load ptr, ptr %MEMORY, align 8
  %v3780 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3779, ptr %state, ptr %R14, i64 %v3778)
  store ptr %v3780, ptr %MEMORY, align 8
  %v3781 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3781, ptr %PC, align 8
  %v3782 = add i64 %v3781, 3
  store i64 %v3782, ptr %NEXT_PC, align 8
  %v3783 = load i32, ptr %R14D, align 4
  %v3784 = zext i32 %v3783 to i64
  %v3785 = load ptr, ptr %MEMORY, align 8
  %v3786 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v3785, ptr %state, ptr %RBP, i64 %v3784)
  store ptr %v3786, ptr %MEMORY, align 8
  %v3787 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3787, ptr %PC, align 8
  %v3788 = add i64 %v3787, 3
  store i64 %v3788, ptr %NEXT_PC, align 8
  %v3789 = load i64, ptr %RDI, align 8
  %v3790 = load ptr, ptr %MEMORY, align 8
  %v3791 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3790, ptr %state, ptr %R12, i64 %v3789)
  store ptr %v3791, ptr %MEMORY, align 8
  %v3792 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3792, ptr %PC, align 8
  %v3793 = add i64 %v3792, 3
  store i64 %v3793, ptr %NEXT_PC, align 8
  %v3794 = load i64, ptr %RDI, align 8
  %v3795 = load i64, ptr %RBP, align 8
  %v3796 = load ptr, ptr %MEMORY, align 8
  %v3797 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3796, ptr %state, i64 %v3794, i64 %v3795)
  store ptr %v3797, ptr %MEMORY, align 8
  %v3798 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3798, ptr %PC, align 8
  %v3799 = add i64 %v3798, 2
  store i64 %v3799, ptr %NEXT_PC, align 8
  %v3800 = load i64, ptr %NEXT_PC, align 8
  %v3801 = add i64 %v3800, 121
  %v3802 = load i64, ptr %NEXT_PC, align 8
  %v3803 = load ptr, ptr %MEMORY, align 8
  %v3804 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3803, ptr %state, ptr %BRANCH_TAKEN, i64 %v3801, i64 %v3802, ptr %NEXT_PC)
  store ptr %v3804, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879035, label %bb_5389878914

bb_5389878914:                                    ; preds = %bb_5389879027, %bb_5389878896
  %v3805 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3805, ptr %PC, align 8
  %v3806 = add i64 %v3805, 4
  store i64 %v3806, ptr %NEXT_PC, align 8
  %v3807 = load i64, ptr %RSI, align 8
  %v3808 = add i64 %v3807, 16
  %v3809 = load ptr, ptr %MEMORY, align 8
  %v3810 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3809, ptr %state, ptr %RAX, i64 %v3808)
  store ptr %v3810, ptr %MEMORY, align 8
  %v3811 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3811, ptr %PC, align 8
  %v3812 = add i64 %v3811, 4
  store i64 %v3812, ptr %NEXT_PC, align 8
  %v3813 = load i64, ptr %RAX, align 8
  %v3814 = load i64, ptr %RDI, align 8
  %v3815 = mul i64 %v3814, 8
  %v3816 = add i64 %v3813, %v3815
  %v3817 = load ptr, ptr %MEMORY, align 8
  %v3818 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3817, ptr %state, ptr %RBX, i64 %v3816)
  store ptr %v3818, ptr %MEMORY, align 8
  %v3819 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3819, ptr %PC, align 8
  %v3820 = add i64 %v3819, 3
  store i64 %v3820, ptr %NEXT_PC, align 8
  %v3821 = load i64, ptr %RBX, align 8
  %v3822 = load i64, ptr %RBX, align 8
  %v3823 = load ptr, ptr %MEMORY, align 8
  %v3824 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3823, ptr %state, i64 %v3821, i64 %v3822)
  store ptr %v3824, ptr %MEMORY, align 8
  %v3825 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3825, ptr %PC, align 8
  %v3826 = add i64 %v3825, 2
  store i64 %v3826, ptr %NEXT_PC, align 8
  %v3827 = load i64, ptr %NEXT_PC, align 8
  %v3828 = add i64 %v3827, 100
  %v3829 = load i64, ptr %NEXT_PC, align 8
  %v3830 = load ptr, ptr %MEMORY, align 8
  %v3831 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3830, ptr %state, ptr %BRANCH_TAKEN, i64 %v3828, i64 %v3829, ptr %NEXT_PC)
  store ptr %v3831, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878927

bb_5389878927:                                    ; preds = %bb_5389878914
  %v3832 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3832, ptr %PC, align 8
  %v3833 = add i64 %v3832, 4
  store i64 %v3833, ptr %NEXT_PC, align 8
  %v3834 = load i64, ptr %RBX, align 8
  %v3835 = add i64 %v3834, 48
  %v3836 = load ptr, ptr %MEMORY, align 8
  %v3837 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3836, ptr %state, ptr %RCX, i64 %v3835)
  store ptr %v3837, ptr %MEMORY, align 8
  %v3838 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3838, ptr %PC, align 8
  %v3839 = add i64 %v3838, 4
  store i64 %v3839, ptr %NEXT_PC, align 8
  %v3840 = load i64, ptr %RCX, align 8
  %v3841 = add i64 %v3840, 16
  %v3842 = load ptr, ptr %MEMORY, align 8
  %v3843 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3842, ptr %state, ptr %RAX, i64 %v3841)
  store ptr %v3843, ptr %MEMORY, align 8
  %v3844 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3844, ptr %PC, align 8
  %v3845 = add i64 %v3844, 2
  store i64 %v3845, ptr %NEXT_PC, align 8
  %v3846 = load i8, ptr %AL, align 1
  %v3847 = zext i8 %v3846 to i64
  %v3848 = load ptr, ptr %MEMORY, align 8
  %v3849 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3848, ptr %state, i64 %v3847, i64 2)
  store ptr %v3849, ptr %MEMORY, align 8
  %v3850 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3850, ptr %PC, align 8
  %v3851 = add i64 %v3850, 2
  store i64 %v3851, ptr %NEXT_PC, align 8
  %v3852 = load i64, ptr %NEXT_PC, align 8
  %v3853 = add i64 %v3852, 88
  %v3854 = load i64, ptr %NEXT_PC, align 8
  %v3855 = load ptr, ptr %MEMORY, align 8
  %v3856 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3855, ptr %state, ptr %BRANCH_TAKEN, i64 %v3853, i64 %v3854, ptr %NEXT_PC)
  store ptr %v3856, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878939

bb_5389878939:                                    ; preds = %bb_5389878927
  %v3857 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3857, ptr %PC, align 8
  %v3858 = add i64 %v3857, 2
  store i64 %v3858, ptr %NEXT_PC, align 8
  %v3859 = load i8, ptr %AL, align 1
  %v3860 = zext i8 %v3859 to i64
  %v3861 = load ptr, ptr %MEMORY, align 8
  %v3862 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3861, ptr %state, i64 %v3860, i64 1)
  store ptr %v3862, ptr %MEMORY, align 8
  %v3863 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3863, ptr %PC, align 8
  %v3864 = add i64 %v3863, 2
  store i64 %v3864, ptr %NEXT_PC, align 8
  %v3865 = load i64, ptr %NEXT_PC, align 8
  %v3866 = add i64 %v3865, 22
  %v3867 = load i64, ptr %NEXT_PC, align 8
  %v3868 = load ptr, ptr %MEMORY, align 8
  %v3869 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3868, ptr %state, ptr %BRANCH_TAKEN, i64 %v3866, i64 %v3867, ptr %NEXT_PC)
  store ptr %v3869, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878965, label %bb_5389878943

bb_5389878943:                                    ; preds = %bb_5389878939
  %v3870 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3870, ptr %PC, align 8
  %v3871 = add i64 %v3870, 4
  store i64 %v3871, ptr %NEXT_PC, align 8
  %v3872 = load i64, ptr %RCX, align 8
  %v3873 = add i64 %v3872, 16
  %v3874 = load i64, ptr %RCX, align 8
  %v3875 = add i64 %v3874, 16
  %v3876 = load ptr, ptr %MEMORY, align 8
  %v3877 = call ptr @_ZN12_GLOBAL__N_13ANDI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3876, ptr %state, i64 %v3873, i64 %v3875, i64 254)
  store ptr %v3877, ptr %MEMORY, align 8
  %v3878 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3878, ptr %PC, align 8
  %v3879 = add i64 %v3878, 4
  store i64 %v3879, ptr %NEXT_PC, align 8
  %v3880 = load i64, ptr %RCX, align 8
  %v3881 = add i64 %v3880, 16
  %v3882 = load ptr, ptr %MEMORY, align 8
  %v3883 = call ptr @_ZN12_GLOBAL__N_14TESTI2MnIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3882, ptr %state, i64 %v3881, i64 2)
  store ptr %v3883, ptr %MEMORY, align 8
  %v3884 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3884, ptr %PC, align 8
  %v3885 = add i64 %v3884, 3
  store i64 %v3885, ptr %NEXT_PC, align 8
  %v3886 = load i64, ptr %RCX, align 8
  %v3887 = load i32, ptr %R13D, align 4
  %v3888 = zext i32 %v3887 to i64
  %v3889 = load ptr, ptr %MEMORY, align 8
  %v3890 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3889, ptr %state, i64 %v3886, i64 %v3888)
  store ptr %v3890, ptr %MEMORY, align 8
  %v3891 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3891, ptr %PC, align 8
  %v3892 = add i64 %v3891, 2
  store i64 %v3892, ptr %NEXT_PC, align 8
  %v3893 = load i64, ptr %NEXT_PC, align 8
  %v3894 = add i64 %v3893, 9
  %v3895 = load i64, ptr %NEXT_PC, align 8
  %v3896 = load ptr, ptr %MEMORY, align 8
  %v3897 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3896, ptr %state, ptr %BRANCH_TAKEN, i64 %v3894, i64 %v3895, ptr %NEXT_PC)
  store ptr %v3897, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878965, label %bb_5389878956

bb_5389878956:                                    ; preds = %bb_5389878943
  %v3898 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3898, ptr %PC, align 8
  %v3899 = add i64 %v3898, 4
  store i64 %v3899, ptr %NEXT_PC, align 8
  %v3900 = load i64, ptr %RCX, align 8
  %v3901 = add i64 %v3900, 8
  %v3902 = load ptr, ptr %MEMORY, align 8
  %v3903 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3902, ptr %state, ptr %RDX, i64 %v3901)
  store ptr %v3903, ptr %MEMORY, align 8
  %v3904 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3904, ptr %PC, align 8
  %v3905 = add i64 %v3904, 5
  store i64 %v3905, ptr %NEXT_PC, align 8
  %v3906 = load i64, ptr %NEXT_PC, align 8
  %v3907 = sub i64 %v3906, 3621
  %v3908 = load i64, ptr %NEXT_PC, align 8
  %v3909 = load ptr, ptr %MEMORY, align 8
  %v3910 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3909, ptr %state, i64 %v3907, ptr %NEXT_PC, i64 %v3908, ptr %RETURN_PC)
  store ptr %v3910, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389878965:                                    ; preds = %bb_5389878943, %bb_5389878939
  %v3911 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3911, ptr %PC, align 8
  %v3912 = add i64 %v3911, 2
  store i64 %v3912, ptr %NEXT_PC, align 8
  %v3913 = load i64, ptr %RBX, align 8
  %v3914 = load i64, ptr %RBX, align 8
  %v3915 = load ptr, ptr %MEMORY, align 8
  %v3916 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3915, ptr %state, i64 %v3913, i64 %v3914)
  store ptr %v3916, ptr %MEMORY, align 8
  %v3917 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3917, ptr %PC, align 8
  %v3918 = add i64 %v3917, 4
  store i64 %v3918, ptr %NEXT_PC, align 8
  %v3919 = load i64, ptr %RBX, align 8
  %v3920 = add i64 %v3919, 48
  %v3921 = load ptr, ptr %MEMORY, align 8
  %v3922 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3921, ptr %state, ptr %RAX, i64 %v3920)
  store ptr %v3922, ptr %MEMORY, align 8
  %v3923 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3923, ptr %PC, align 8
  %v3924 = add i64 %v3923, 2
  store i64 %v3924, ptr %NEXT_PC, align 8
  %v3925 = load i64, ptr %RAX, align 8
  %v3926 = load i64, ptr %RAX, align 8
  %v3927 = load ptr, ptr %MEMORY, align 8
  %v3928 = call ptr @_ZN12_GLOBAL__N_13DECI3MnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3927, ptr %state, i64 %v3925, i64 %v3926)
  store ptr %v3928, ptr %MEMORY, align 8
  %v3929 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3929, ptr %PC, align 8
  %v3930 = add i64 %v3929, 4
  store i64 %v3930, ptr %NEXT_PC, align 8
  %v3931 = load i64, ptr %RBX, align 8
  %v3932 = add i64 %v3931, 48
  %v3933 = load ptr, ptr %MEMORY, align 8
  %v3934 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3933, ptr %state, ptr %RBX, i64 %v3932)
  store ptr %v3934, ptr %MEMORY, align 8
  %v3935 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3935, ptr %PC, align 8
  %v3936 = add i64 %v3935, 3
  store i64 %v3936, ptr %NEXT_PC, align 8
  %v3937 = load i64, ptr %RBX, align 8
  %v3938 = load i32, ptr %R13D, align 4
  %v3939 = zext i32 %v3938 to i64
  %v3940 = load ptr, ptr %MEMORY, align 8
  %v3941 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3940, ptr %state, i64 %v3937, i64 %v3939)
  store ptr %v3941, ptr %MEMORY, align 8
  %v3942 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3942, ptr %PC, align 8
  %v3943 = add i64 %v3942, 2
  store i64 %v3943, ptr %NEXT_PC, align 8
  %v3944 = load i64, ptr %NEXT_PC, align 8
  %v3945 = add i64 %v3944, 45
  %v3946 = load i64, ptr %NEXT_PC, align 8
  %v3947 = load ptr, ptr %MEMORY, align 8
  %v3948 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3947, ptr %state, ptr %BRANCH_TAKEN, i64 %v3945, i64 %v3946, ptr %NEXT_PC)
  store ptr %v3948, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879027, label %bb_5389878982

bb_5389878982:                                    ; preds = %bb_5389878965
  %v3949 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3949, ptr %PC, align 8
  %v3950 = add i64 %v3949, 4
  store i64 %v3950, ptr %NEXT_PC, align 8
  %v3951 = load i64, ptr %RBX, align 8
  %v3952 = add i64 %v3951, 8
  %v3953 = load ptr, ptr %MEMORY, align 8
  %v3954 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3953, ptr %state, ptr %RDX, i64 %v3952)
  store ptr %v3954, ptr %MEMORY, align 8
  %v3955 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3955, ptr %PC, align 8
  %v3956 = add i64 %v3955, 3
  store i64 %v3956, ptr %NEXT_PC, align 8
  %v3957 = load i64, ptr %RBX, align 8
  %v3958 = load ptr, ptr %MEMORY, align 8
  %v3959 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3958, ptr %state, ptr %RCX, i64 %v3957)
  store ptr %v3959, ptr %MEMORY, align 8
  %v3960 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3960, ptr %PC, align 8
  %v3961 = add i64 %v3960, 4
  store i64 %v3961, ptr %NEXT_PC, align 8
  %v3962 = load i64, ptr %RBX, align 8
  %v3963 = add i64 %v3962, 16
  %v3964 = load i64, ptr %RBX, align 8
  %v3965 = add i64 %v3964, 16
  %v3966 = load ptr, ptr %MEMORY, align 8
  %v3967 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIhE2MnIhE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3966, ptr %state, i64 %v3963, i64 %v3965, i64 2)
  store ptr %v3967, ptr %MEMORY, align 8
  %v3968 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3968, ptr %PC, align 8
  %v3969 = add i64 %v3968, 5
  store i64 %v3969, ptr %NEXT_PC, align 8
  %v3970 = load i64, ptr %NEXT_PC, align 8
  %v3971 = sub i64 %v3970, 3446
  %v3972 = load i64, ptr %NEXT_PC, align 8
  %v3973 = load ptr, ptr %MEMORY, align 8
  %v3974 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3973, ptr %state, i64 %v3971, ptr %NEXT_PC, i64 %v3972, ptr %RETURN_PC)
  store ptr %v3974, ptr %MEMORY, align 8
  %v3975 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3975, ptr %PC, align 8
  %v3976 = add i64 %v3975, 4
  store i64 %v3976, ptr %NEXT_PC, align 8
  %v3977 = load i64, ptr %RBX, align 8
  %v3978 = add i64 %v3977, 8
  %v3979 = load ptr, ptr %MEMORY, align 8
  %v3980 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3979, ptr %state, ptr %RDX, i64 %v3978)
  store ptr %v3980, ptr %MEMORY, align 8
  %v3981 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3981, ptr %PC, align 8
  %v3982 = add i64 %v3981, 7
  store i64 %v3982, ptr %NEXT_PC, align 8
  %v3983 = load i64, ptr %NEXT_PC, align 8
  %v3984 = add i64 %v3983, 26998767
  %v3985 = load ptr, ptr %MEMORY, align 8
  %v3986 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v3985, ptr %state, ptr %RCX, i64 %v3984)
  store ptr %v3986, ptr %MEMORY, align 8
  %v3987 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3987, ptr %PC, align 8
  %v3988 = add i64 %v3987, 5
  store i64 %v3988, ptr %NEXT_PC, align 8
  %v3989 = load i64, ptr %NEXT_PC, align 8
  %v3990 = add i64 %v3989, 49594
  %v3991 = load i64, ptr %NEXT_PC, align 8
  %v3992 = load ptr, ptr %MEMORY, align 8
  %v3993 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v3992, ptr %state, i64 %v3990, ptr %NEXT_PC, i64 %v3991, ptr %RETURN_PC)
  store ptr %v3993, ptr %MEMORY, align 8
  %v3994 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3994, ptr %PC, align 8
  %v3995 = add i64 %v3994, 5
  store i64 %v3995, ptr %NEXT_PC, align 8
  %v3996 = load ptr, ptr %MEMORY, align 8
  %v3997 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3996, ptr %state, ptr %RDX, i64 24)
  store ptr %v3997, ptr %MEMORY, align 8
  %v3998 = load i64, ptr %NEXT_PC, align 8
  store i64 %v3998, ptr %PC, align 8
  %v3999 = add i64 %v3998, 3
  store i64 %v3999, ptr %NEXT_PC, align 8
  %v4000 = load i64, ptr %RBX, align 8
  %v4001 = load ptr, ptr %MEMORY, align 8
  %v4002 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4001, ptr %state, ptr %RCX, i64 %v4000)
  store ptr %v4002, ptr %MEMORY, align 8
  %v4003 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4003, ptr %PC, align 8
  %v4004 = add i64 %v4003, 5
  store i64 %v4004, ptr %NEXT_PC, align 8
  %v4005 = load i64, ptr %NEXT_PC, align 8
  %v4006 = sub i64 %v4005, 1165715
  %v4007 = load i64, ptr %NEXT_PC, align 8
  %v4008 = load ptr, ptr %MEMORY, align 8
  %v4009 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4008, ptr %state, i64 %v4006, ptr %NEXT_PC, i64 %v4007, ptr %RETURN_PC)
  store ptr %v4009, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879027:                                    ; preds = %bb_5389878965, %bb_5389878927, %bb_5389878914
  %v4010 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4010, ptr %PC, align 8
  %v4011 = add i64 %v4010, 3
  store i64 %v4011, ptr %NEXT_PC, align 8
  %v4012 = load i64, ptr %RDI, align 8
  %v4013 = load ptr, ptr %MEMORY, align 8
  %v4014 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4013, ptr %state, ptr %RDI, i64 %v4012)
  store ptr %v4014, ptr %MEMORY, align 8
  %v4015 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4015, ptr %PC, align 8
  %v4016 = add i64 %v4015, 3
  store i64 %v4016, ptr %NEXT_PC, align 8
  %v4017 = load i64, ptr %RDI, align 8
  %v4018 = load i64, ptr %RBP, align 8
  %v4019 = load ptr, ptr %MEMORY, align 8
  %v4020 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4019, ptr %state, i64 %v4017, i64 %v4018)
  store ptr %v4020, ptr %MEMORY, align 8
  %v4021 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4021, ptr %PC, align 8
  %v4022 = add i64 %v4021, 2
  store i64 %v4022, ptr %NEXT_PC, align 8
  %v4023 = load i64, ptr %NEXT_PC, align 8
  %v4024 = sub i64 %v4023, 121
  %v4025 = load i64, ptr %NEXT_PC, align 8
  %v4026 = load ptr, ptr %MEMORY, align 8
  %v4027 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4026, ptr %state, ptr %BRANCH_TAKEN, i64 %v4024, i64 %v4025, ptr %NEXT_PC)
  store ptr %v4027, ptr %MEMORY, align 8
  br i1 true, label %bb_5389878914, label %bb_5389879035

bb_5389879035:                                    ; preds = %bb_5389879027, %bb_5389878896
  %v4028 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4028, ptr %PC, align 8
  %v4029 = add i64 %v4028, 3
  store i64 %v4029, ptr %NEXT_PC, align 8
  %v4030 = load i64, ptr %RSI, align 8
  %v4031 = add i64 %v4030, 24
  %v4032 = load ptr, ptr %MEMORY, align 8
  %v4033 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4032, ptr %state, ptr %RAX, i64 %v4031)
  store ptr %v4033, ptr %MEMORY, align 8
  %v4034 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4034, ptr %PC, align 8
  %v4035 = add i64 %v4034, 2
  store i64 %v4035, ptr %NEXT_PC, align 8
  %v4036 = load i32, ptr %EAX, align 4
  %v4037 = zext i32 %v4036 to i64
  %v4038 = load ptr, ptr %MEMORY, align 8
  %v4039 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4038, ptr %state, ptr %RCX, i64 %v4037)
  store ptr %v4039, ptr %MEMORY, align 8
  %v4040 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4040, ptr %PC, align 8
  %v4041 = add i64 %v4040, 5
  store i64 %v4041, ptr %NEXT_PC, align 8
  %v4042 = load i64, ptr %RSP, align 8
  %v4043 = add i64 %v4042, 96
  %v4044 = load ptr, ptr %MEMORY, align 8
  %v4045 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4044, ptr %state, ptr %RDI, i64 %v4043)
  store ptr %v4045, ptr %MEMORY, align 8
  %v4046 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4046, ptr %PC, align 8
  %v4047 = add i64 %v4046, 3
  store i64 %v4047, ptr %NEXT_PC, align 8
  %v4048 = load i64, ptr %RCX, align 8
  %v4049 = load i32, ptr %R14D, align 4
  %v4050 = zext i32 %v4049 to i64
  %v4051 = load ptr, ptr %MEMORY, align 8
  %v4052 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4051, ptr %state, ptr %RCX, i64 %v4048, i64 %v4050)
  store ptr %v4052, ptr %MEMORY, align 8
  %v4053 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4053, ptr %PC, align 8
  %v4054 = add i64 %v4053, 5
  store i64 %v4054, ptr %NEXT_PC, align 8
  %v4055 = load i64, ptr %RSP, align 8
  %v4056 = add i64 %v4055, 40
  %v4057 = load ptr, ptr %MEMORY, align 8
  %v4058 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4057, ptr %state, ptr %R14, i64 %v4056)
  store ptr %v4058, ptr %MEMORY, align 8
  %v4059 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4059, ptr %PC, align 8
  %v4060 = add i64 %v4059, 2
  store i64 %v4060, ptr %NEXT_PC, align 8
  %v4061 = load i32, ptr %ECX, align 4
  %v4062 = zext i32 %v4061 to i64
  %v4063 = load i32, ptr %ECX, align 4
  %v4064 = zext i32 %v4063 to i64
  %v4065 = load ptr, ptr %MEMORY, align 8
  %v4066 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4065, ptr %state, i64 %v4062, i64 %v4064)
  store ptr %v4066, ptr %MEMORY, align 8
  %v4067 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4067, ptr %PC, align 8
  %v4068 = add i64 %v4067, 2
  store i64 %v4068, ptr %NEXT_PC, align 8
  %v4069 = load i64, ptr %NEXT_PC, align 8
  %v4070 = add i64 %v4069, 27
  %v4071 = load i64, ptr %NEXT_PC, align 8
  %v4072 = load ptr, ptr %MEMORY, align 8
  %v4073 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4072, ptr %state, ptr %BRANCH_TAKEN, i64 %v4070, i64 %v4071, ptr %NEXT_PC)
  store ptr %v4073, ptr %MEMORY, align 8
  br i1 true, label %bb_5389879084, label %bb_5389879057

bb_5389879057:                                    ; preds = %bb_5389879035
  %v4074 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4074, ptr %PC, align 8
  %v4075 = add i64 %v4074, 4
  store i64 %v4075, ptr %NEXT_PC, align 8
  %v4076 = load i64, ptr %RSI, align 8
  %v4077 = add i64 %v4076, 16
  %v4078 = load ptr, ptr %MEMORY, align 8
  %v4079 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4078, ptr %state, ptr %RAX, i64 %v4077)
  store ptr %v4079, ptr %MEMORY, align 8
  %v4080 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4080, ptr %PC, align 8
  %v4081 = add i64 %v4080, 3
  store i64 %v4081, ptr %NEXT_PC, align 8
  %v4082 = load i32, ptr %ECX, align 4
  %v4083 = zext i32 %v4082 to i64
  %v4084 = load ptr, ptr %MEMORY, align 8
  %v4085 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWImE2RnIjLb1EElEEP6MemoryS6_R5StateT_T0_(ptr %v4084, ptr %state, ptr %R8, i64 %v4083)
  store ptr %v4085, ptr %MEMORY, align 8
  %v4086 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4086, ptr %PC, align 8
  %v4087 = add i64 %v4086, 4
  store i64 %v4087, ptr %NEXT_PC, align 8
  %v4088 = load i64, ptr %R8, align 8
  %v4089 = load ptr, ptr %MEMORY, align 8
  %v4090 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4089, ptr %state, ptr %R8, i64 %v4088, i64 3)
  store ptr %v4090, ptr %MEMORY, align 8
  %v4091 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4091, ptr %PC, align 8
  %v4092 = add i64 %v4091, 4
  store i64 %v4092, ptr %NEXT_PC, align 8
  %v4093 = load i64, ptr %RAX, align 8
  %v4094 = load i64, ptr %RBP, align 8
  %v4095 = mul i64 %v4094, 8
  %v4096 = add i64 %v4093, %v4095
  %v4097 = load ptr, ptr %MEMORY, align 8
  %v4098 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4097, ptr %state, ptr %RDX, i64 %v4096)
  store ptr %v4098, ptr %MEMORY, align 8
  %v4099 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4099, ptr %PC, align 8
  %v4100 = add i64 %v4099, 4
  store i64 %v4100, ptr %NEXT_PC, align 8
  %v4101 = load i64, ptr %RAX, align 8
  %v4102 = load i64, ptr %R12, align 8
  %v4103 = mul i64 %v4102, 8
  %v4104 = add i64 %v4101, %v4103
  %v4105 = load ptr, ptr %MEMORY, align 8
  %v4106 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr %v4105, ptr %state, ptr %RCX, i64 %v4104)
  store ptr %v4106, ptr %MEMORY, align 8
  %v4107 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4107, ptr %PC, align 8
  %v4108 = add i64 %v4107, 5
  store i64 %v4108, ptr %NEXT_PC, align 8
  %v4109 = load i64, ptr %NEXT_PC, align 8
  %v4110 = add i64 %v4109, 11852992
  %v4111 = load i64, ptr %NEXT_PC, align 8
  %v4112 = load ptr, ptr %MEMORY, align 8
  %v4113 = call ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr %v4112, ptr %state, i64 %v4110, ptr %NEXT_PC, i64 %v4111, ptr %RETURN_PC)
  store ptr %v4113, ptr %MEMORY, align 8
  %v4114 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4114, ptr %PC, align 8
  %v4115 = add i64 %v4114, 3
  store i64 %v4115, ptr %NEXT_PC, align 8
  %v4116 = load i64, ptr %RSI, align 8
  %v4117 = add i64 %v4116, 24
  %v4118 = load ptr, ptr %MEMORY, align 8
  %v4119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4118, ptr %state, ptr %RAX, i64 %v4117)
  store ptr %v4119, ptr %MEMORY, align 8
  br label %bb_5389879084

bb_5389879084:                                    ; preds = %bb_5389879057, %bb_5389879035
  %v4120 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4120, ptr %PC, align 8
  %v4121 = add i64 %v4120, 5
  store i64 %v4121, ptr %NEXT_PC, align 8
  %v4122 = load i64, ptr %RSP, align 8
  %v4123 = add i64 %v4122, 48
  %v4124 = load ptr, ptr %MEMORY, align 8
  %v4125 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4124, ptr %state, ptr %R12, i64 %v4123)
  store ptr %v4125, ptr %MEMORY, align 8
  %v4126 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4126, ptr %PC, align 8
  %v4127 = add i64 %v4126, 2
  store i64 %v4127, ptr %NEXT_PC, align 8
  %v4128 = load i64, ptr %RAX, align 8
  %v4129 = load ptr, ptr %MEMORY, align 8
  %v4130 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4129, ptr %state, ptr %RAX, i64 %v4128)
  store ptr %v4130, ptr %MEMORY, align 8
  %v4131 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4131, ptr %PC, align 8
  %v4132 = add i64 %v4131, 5
  store i64 %v4132, ptr %NEXT_PC, align 8
  %v4133 = load i64, ptr %RSP, align 8
  %v4134 = add i64 %v4133, 80
  %v4135 = load ptr, ptr %MEMORY, align 8
  %v4136 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4135, ptr %state, ptr %RBP, i64 %v4134)
  store ptr %v4136, ptr %MEMORY, align 8
  %v4137 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4137, ptr %PC, align 8
  %v4138 = add i64 %v4137, 3
  store i64 %v4138, ptr %NEXT_PC, align 8
  %v4139 = load i64, ptr %RSI, align 8
  %v4140 = add i64 %v4139, 24
  %v4141 = load i32, ptr %EAX, align 4
  %v4142 = zext i32 %v4141 to i64
  %v4143 = load ptr, ptr %MEMORY, align 8
  %v4144 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4143, ptr %state, i64 %v4140, i64 %v4142)
  store ptr %v4144, ptr %MEMORY, align 8
  br label %bb_5389879099

bb_5389879099:                                    ; preds = %bb_5389879084, %bb_5389878859, %bb_5389878772
  %v4145 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4145, ptr %PC, align 8
  %v4146 = add i64 %v4145, 3
  store i64 %v4146, ptr %NEXT_PC, align 8
  %v4147 = load i64, ptr %R15, align 8
  %v4148 = load ptr, ptr %MEMORY, align 8
  %v4149 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4148, ptr %state, ptr %RBX, i64 %v4147)
  store ptr %v4149, ptr %MEMORY, align 8
  %v4150 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4150, ptr %PC, align 8
  %v4151 = add i64 %v4150, 5
  store i64 %v4151, ptr %NEXT_PC, align 8
  %v4152 = load i64, ptr %RSP, align 8
  %v4153 = add i64 %v4152, 32
  %v4154 = load ptr, ptr %MEMORY, align 8
  %v4155 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4154, ptr %state, ptr %R15, i64 %v4153)
  store ptr %v4155, ptr %MEMORY, align 8
  %v4156 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4156, ptr %PC, align 8
  %v4157 = add i64 %v4156, 5
  store i64 %v4157, ptr %NEXT_PC, align 8
  %v4158 = load i64, ptr %RSP, align 8
  %v4159 = add i64 %v4158, 88
  %v4160 = load ptr, ptr %MEMORY, align 8
  %v4161 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4160, ptr %state, ptr %RSI, i64 %v4159)
  store ptr %v4161, ptr %MEMORY, align 8
  %v4162 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4162, ptr %PC, align 8
  %v4163 = add i64 %v4162, 3
  store i64 %v4163, ptr %NEXT_PC, align 8
  %v4164 = load i64, ptr %RBX, align 8
  %v4165 = load i64, ptr %RBX, align 8
  %v4166 = load ptr, ptr %MEMORY, align 8
  %v4167 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4166, ptr %state, i64 %v4164, i64 %v4165)
  store ptr %v4167, ptr %MEMORY, align 8
  %v4168 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4168, ptr %PC, align 8
  %v4169 = add i64 %v4168, 2
  store i64 %v4169, ptr %NEXT_PC, align 8
  %v4170 = load i64, ptr %NEXT_PC, align 8
  %v4171 = add i64 %v4170, 100
  %v4172 = load i64, ptr %NEXT_PC, align 8
  %v4173 = load ptr, ptr %MEMORY, align 8
  %v4174 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4173, ptr %state, ptr %BRANCH_TAKEN, i64 %v4171, i64 %v4172, ptr %NEXT_PC)
  store ptr %v4174, ptr %MEMORY, align 8
  ret ptr %memory

bb_5389879117:                                    ; No predecessors!
  %v4175 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4175, ptr %PC, align 8
  %v4176 = add i64 %v4175, 4
  store i64 %v4176, ptr %NEXT_PC, align 8
  %v4177 = load i64, ptr %RBX, align 8
  %v4178 = add i64 %v4177, 48
  %v4179 = load ptr, ptr %MEMORY, align 8
  %v4180 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2MnImEEEP6MemoryS6_R5StateT_T0_(ptr %v4179, ptr %state, ptr %RCX, i64 %v4178)
  store ptr %v4180, ptr %MEMORY, align 8
  %v4181 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4181, ptr %PC, align 8
  %v4182 = add i64 %v4181, 4
  store i64 %v4182, ptr %NEXT_PC, align 8
  %v4183 = load i64, ptr %RCX, align 8
  %v4184 = add i64 %v4183, 16
  %v4185 = load ptr, ptr %MEMORY, align 8
  %v4186 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v4185, ptr %state, ptr %RAX, i64 %v4184)
  store ptr %v4186, ptr %MEMORY, align 8
  %v4187 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4187, ptr %PC, align 8
  %v4188 = add i64 %v4187, 2
  store i64 %v4188, ptr %NEXT_PC, align 8
  %v4189 = load i8, ptr %AL, align 1
  %v4190 = zext i8 %v4189 to i64
  %v4191 = load ptr, ptr %MEMORY, align 8
  %v4192 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v4191, ptr %state, i64 %v4190, i64 2)
  store ptr %v4192, ptr %MEMORY, align 8
  %v4193 = load i64, ptr %NEXT_PC, align 8
  store i64 %v4193, ptr %PC, align 8
  %v4194 = add i64 %v4193, 2
  store i64 %v4194, ptr %NEXT_PC, align 8
  %v4195 = load i64, ptr %NEXT_PC, align 8
  %v4196 = add i64 %v4195, 88
  %v4197 = load i64, ptr %NEXT_PC, align 8
  %v4198 = load ptr, ptr %MEMORY, align 8
  %v4199 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v4198, ptr %state, ptr %BRANCH_TAKEN, i64 %v4196, i64 %v4197, ptr %NEXT_PC)
  store ptr %v4199, ptr %MEMORY, align 8
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
