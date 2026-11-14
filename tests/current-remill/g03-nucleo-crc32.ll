; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: NUCLEO.exe
; Address: 0x140022197
; Size: 69 bytes
; Architecture: amd64_avx
; Generated: 2026-11-14T03:33:50.410Z
; ============================================================
; SemanticStatus: ok
; SemanticCoverage: 100.00% (decoded=153, lifted=153, unsupported=0, failures=0)
; UnsupportedOpcodes: none
; RequestedByteRange: [0x140022197, 0x1400221DC) domain=byte-range reason=explicit-endExclusive
; FunctionByteRange: [0x140022197, 0x1400221DC) source=explicit-endExclusive
; SemanticBodyRange: [0x140022197, 0x1400221DC) boundaryReached=true boundaryCrossed=false source=explicit-range-terminal-decode
; RemillDecodedByteSet: 100.00% (426/69 bytes) representation=union-of-decoded-intervals nativeTruncated=false
; DecodedByteCoverage: 100.00% (426/69 bytes, explicit-endExclusive)

; ModuleID = 'hexcore-remill-lift'
source_filename = "hexcore-remill-lift"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-windows-msvc-coff"

%struct.State = type { %struct.X86State }
%struct.X86State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, [8 x i8], %union.FPU, %struct.SegmentCaches, %struct.K_REG }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint128v4_t }
%struct.uint128v4_t = type { [4 x i128] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%union.anon = type { i64 }
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
%union.FPU = type { %struct.anon.11 }
%struct.anon.11 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.9, [6 x i8] }
%union.anon.9 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.K_REG = type { [8 x %struct.anon.16] }
%struct.anon.16 = type { i64, i64 }

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local i64 @__remill_read_memory_64(ptr noundef, i64 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i8 @__remill_read_memory_8(ptr noundef, i64 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local ptr @__remill_write_memory_64(ptr noundef, i64 noundef, i64 noundef) #0

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

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i8 @__remill_undefined_8() #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14IMULI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local ptr @__remill_error(ptr noundef nonnull align 16 dereferenceable(3504), i64 noundef, ptr noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2RnIjLb1EEEEP6MemoryS4_R5StateT_2InImE(ptr noundef, ptr noundef nonnull align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13NEGI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14SETZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InImEEEP6MemoryS4_R5StateT_3RnWImES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64, ptr nocapture writeonly, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_neq(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

declare !remill.function.type !5 dso_local zeroext i1 @__remill_compare_ult(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13NOTI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13NOTI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWImE2MnIhEmEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i64) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ROLI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RORI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWImE2RnImLb1EE2InImEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWImE2RnImLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHLI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i64, i64) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InImEEEP6MemoryS4_R5StateT_3RnWImE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i64, ptr nocapture writeonly) #5

define ptr @lifted_5368848791(ptr noalias %state, i64 %program_counter, ptr noalias %memory) {
bb_0:
  %ECX = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !6
  %EDX = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !7
  %EAX = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !8
  %RDI = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 11, i32 0, i32 0, !remill_register !9
  %RSI = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !10
  %RBX = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !11
  %BRANCH_TAKEN = alloca i8, align 1
  %NEXT_PC = alloca i64, align 8
  %PC = getelementptr inbounds %struct.State, ptr %state, i64 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !12
  store i64 5368848791, ptr %PC, align 8
  %BL176 = load i64, ptr %RBX, align 8
  %v1 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %memory, ptr %state, i64 %BL176)
  store i64 5368848792, ptr %PC, align 8
  %SIL174 = load i64, ptr %RSI, align 8
  %v2 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v1, ptr %state, i64 %SIL174)
  store i64 5368848793, ptr %PC, align 8
  %DIL170 = load i64, ptr %RDI, align 8
  %v3 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InImEEEP6MemoryS4_R5StateT_(ptr %v2, ptr %state, i64 %DIL170)
  %CL159 = load i64, ptr %ECX, align 8
  %v4 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %RDI, i64 %CL159)
  %DL136 = load i64, ptr %EDX, align 8
  %v5 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %RSI, i64 %DL136)
  %v6 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %EAX, i64 4294967295)
  store i64 5368848805, ptr %PC, align 8
  %DIL169 = load i64, ptr %RDI, align 8
  %v7 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3, ptr %state, i64 %DIL169, i64 %DIL169)
  store i64 5368848808, ptr %PC, align 8
  store i64 5368848810, ptr %NEXT_PC, align 8
  %v8 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3, ptr %state, ptr nonnull %BRANCH_TAKEN, i64 5368848854, i64 5368848810, ptr nonnull %NEXT_PC)
  %branch_taken = load i8, ptr %BRANCH_TAKEN, align 1
  %branch_taken.bool.not = icmp eq i8 %branch_taken, 0
  br i1 %branch_taken.bool.not, label %bb_5368848810, label %bb_5368848854

bb_5368848810:                                    ; preds = %bb_0
  %v9 = load i64, ptr %NEXT_PC, align 8
  store i64 %v9, ptr %PC, align 8
  %v10 = add i64 %v9, 3
  %SIL173 = load i64, ptr %RSI, align 8
  %v11 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnImLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3, ptr %state, i64 %SIL173, i64 %SIL173)
  store i64 %v10, ptr %PC, align 8
  %v12 = add i64 %v9, 5
  store i64 %v12, ptr %NEXT_PC, align 8
  %v13 = add i64 %v9, 44
  %v14 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3, ptr %state, ptr nonnull %BRANCH_TAKEN, i64 %v13, i64 %v12, ptr nonnull %NEXT_PC)
  %branch_taken1 = load i8, ptr %BRANCH_TAKEN, align 1
  %branch_taken.bool2.not = icmp eq i8 %branch_taken1, 0
  br i1 %branch_taken.bool2.not, label %bb_5368848815, label %bb_5368848854

bb_5368848815:                                    ; preds = %bb_5368848846, %bb_5368848810
  %v15 = load i64, ptr %NEXT_PC, align 8
  store i64 %v15, ptr %PC, align 8
  %v16 = add i64 %v15, 3
  %DIL167 = load i64, ptr %RDI, align 8
  %v17 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWImE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %EDX, i64 %DIL167)
  store i64 %v16, ptr %PC, align 8
  %AL104 = load i8, ptr %EAX, align 1
  %v18 = zext i8 %AL104 to i64
  %DL95 = load i8, ptr %EDX, align 1
  %v19 = zext i8 %DL95 to i64
  %v20 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWIhE2RnIhLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3, ptr %state, ptr nonnull %EAX, i64 %v18, i64 %v19)
  %v21 = add i64 %v15, 10
  store i64 %v21, ptr %NEXT_PC, align 8
  %v22 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %ECX, i64 8)
  br label %bb_5368848825

bb_5368848825:                                    ; preds = %bb_5368848825, %bb_5368848815
  %v23 = load i64, ptr %NEXT_PC, align 8
  %v24 = add i64 %v23, 2
  %AL94 = load i32, ptr %EAX, align 4
  %v25 = zext i32 %AL94 to i64
  %v26 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %EDX, i64 %v25)
  store i64 %v24, ptr %PC, align 8
  %v27 = add i64 %v23, 4
  %AL122 = load i64, ptr %EAX, align 8
  %v28 = call ptr @_ZN12_GLOBAL__N_13SHRI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3, ptr %state, ptr nonnull %EAX, i64 %AL122, i64 1)
  store i64 %v27, ptr %PC, align 8
  %v29 = add i64 %v23, 7
  %DL135 = load i64, ptr %EDX, align 8
  %v30 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3, ptr %state, ptr nonnull %EDX, i64 %DL135, i64 1)
  store i64 %v29, ptr %PC, align 8
  %v31 = add i64 %v23, 9
  %DL134 = load i64, ptr %EDX, align 8
  %v32 = call ptr @_ZN12_GLOBAL__N_13NEGI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %EDX, i64 %DL134)
  store i64 %v31, ptr %PC, align 8
  %v33 = add i64 %v23, 15
  %DL133 = load i64, ptr %EDX, align 8
  %v34 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWImE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3, ptr %state, ptr nonnull %EDX, i64 %DL133, i64 -306674912)
  store i64 %v33, ptr %PC, align 8
  %v35 = add i64 %v23, 17
  %AL121 = load i64, ptr %EAX, align 8
  %DL87 = load i32, ptr %EDX, align 4
  %v36 = zext i32 %DL87 to i64
  %v37 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWImE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3, ptr %state, ptr nonnull %EAX, i64 %AL121, i64 %v36)
  store i64 %v35, ptr %PC, align 8
  %v38 = add i64 %v23, 19
  %CL158 = load i64, ptr %ECX, align 8
  %v39 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %ECX, i64 %CL158)
  store i64 %v38, ptr %PC, align 8
  %v40 = add i64 %v23, 21
  store i64 %v40, ptr %NEXT_PC, align 8
  %v41 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3, ptr %state, ptr nonnull %BRANCH_TAKEN, i64 %v23, i64 %v40, ptr nonnull %NEXT_PC)
  %branch_taken3 = load i8, ptr %BRANCH_TAKEN, align 1
  %branch_taken.bool4.not = icmp eq i8 %branch_taken3, 0
  br i1 %branch_taken.bool4.not, label %bb_5368848846, label %bb_5368848825

bb_5368848846:                                    ; preds = %bb_5368848825
  %v42 = load i64, ptr %NEXT_PC, align 8
  store i64 %v42, ptr %PC, align 8
  %v43 = add i64 %v42, 3
  %DIL166 = load i64, ptr %RDI, align 8
  %v44 = call ptr @_ZN12_GLOBAL__N_13INCI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %RDI, i64 %DIL166)
  store i64 %v43, ptr %PC, align 8
  %v45 = add i64 %v42, 6
  %SIL171 = load i64, ptr %RSI, align 8
  %v46 = call ptr @_ZN12_GLOBAL__N_13DECI3RnWImE2RnImLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %RSI, i64 %SIL171)
  store i64 %v45, ptr %PC, align 8
  %v47 = add i64 %v42, 8
  store i64 %v47, ptr %NEXT_PC, align 8
  %v48 = add i64 %v42, -31
  %v49 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InImES7_S4_ImE(ptr %v3, ptr %state, ptr nonnull %BRANCH_TAKEN, i64 %v48, i64 %v47, ptr nonnull %NEXT_PC)
  %branch_taken5 = load i8, ptr %BRANCH_TAKEN, align 1
  %branch_taken.bool6.not = icmp eq i8 %branch_taken5, 0
  br i1 %branch_taken.bool6.not, label %bb_5368848854, label %bb_5368848815

bb_5368848854:                                    ; preds = %bb_5368848846, %bb_5368848810, %bb_0
  %v50 = load i64, ptr %NEXT_PC, align 8
  %v51 = add i64 %v50, 2
  %AL120 = load i64, ptr %EAX, align 8
  %v52 = call ptr @_ZN12_GLOBAL__N_13NOTI3RnWImE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3, ptr %state, ptr nonnull %EAX, i64 %AL120)
  store i64 %v51, ptr %PC, align 8
  %v53 = add i64 %v50, 3
  %v54 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3, ptr %state, ptr nonnull %RDI)
  store i64 %v53, ptr %PC, align 8
  %v55 = add i64 %v50, 4
  %v56 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3, ptr %state, ptr nonnull %RSI)
  store i64 %v55, ptr %PC, align 8
  %v57 = add i64 %v50, 5
  %v58 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWImEEEP6MemoryS4_R5StateT_(ptr %v3, ptr %state, ptr nonnull %RBX)
  store i64 %v57, ptr %PC, align 8
  %v59 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWImE(ptr %v3, ptr %state, ptr nonnull %NEXT_PC)
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
!7 = !{[4 x i8] c"EDX\00"}
!8 = !{[4 x i8] c"EAX\00"}
!9 = !{[4 x i8] c"RDI\00"}
!10 = !{[4 x i8] c"RSI\00"}
!11 = !{[4 x i8] c"RBX\00"}
!12 = !{[3 x i8] c"PC\00"}
