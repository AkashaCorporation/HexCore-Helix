; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: debugme.exe
; Address: 0x00401122
; Size: 4500 bytes
; Architecture: x86
; Generated: 2026-03-12T18:03:20.892Z
; ============================================================
; ModuleID = '\\?\c:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-remill\deps\remill\share\semantics\x86.bc'
source_filename = "llvm-link"
target datalayout = "e-m:x-p:32:32-i64:64-f80:32-n8:16:32-a:0:32-S32"
target triple = "i386-unknown-windows-msvc-coff"

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
%struct.Reg = type { %union.anon.1, i32 }
%union.anon.1 = type { i32 }
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
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.anon.1, %union.anon.1, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.K_REG = type { [8 x %struct.anon.18] }
%struct.anon.18 = type { i64, i64 }

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_117HandleUnsupportedEP6MemoryR5State(ptr noundef, ptr noundef nonnull align 16 dereferenceable(3504)) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i8 @__remill_read_memory_8(ptr noundef, i32 noundef) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_carry(i1 noundef zeroext, ...) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare !remill.function.type !6 i8 @llvm.ctpop.i8(i8) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_zero(i1 noundef zeroext, ...) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_sign(i1 noundef zeroext, ...) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_overflow(i1 noundef zeroext, ...) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i16 @__remill_read_memory_16(ptr noundef, i32 noundef) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local i32 @__remill_read_memory_32(ptr noundef, i32 noundef) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_write_memory_32(ptr noundef, i32 noundef, i32 noundef) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnItLb1EE2InItEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i8 @__remill_undefined_8() #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_error(ptr noundef nonnull align 16 dereferenceable(3504), i32 noundef, ptr noundef) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr noundef, ptr noundef nonnull align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14SETZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_sle(i1 noundef zeroext) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_sgt(i1 noundef zeroext) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_neq(i1 noundef zeroext) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #1

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_slt(i1 noundef zeroext) #4

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_ugt(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14JNLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14XCHGI3MnWIjE2MnIjE3RnWIjE2RnIjLb1EEEEP6MemorySA_R5StateT_T0_T1_T2_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32, ptr nocapture writeonly, i32) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local i64 @__remill_read_memory_64(ptr noundef, i32 noundef) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504)) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16) #6

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, ptr nocapture writeonly) #5

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_atomic_begin(ptr noundef) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_atomic_end(ptr noundef) #1

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_es(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_ss(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_ds(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_fs(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_gs(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_debug_reg(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_0(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_1(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_2(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_3(ptr noundef) #4

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_4(ptr noundef) #4

; Function Attrs: mustprogress noduplicate noinline nounwind optnone
declare dso_local ptr @__remill_sync_hyper_call(ptr noundef nonnull align 16 dereferenceable(3504), ptr noundef, i32 noundef) #7

define ptr @lifted_4198690(ptr noalias %state, i32 %program_counter, ptr noalias %memory) {
bb_0:
  %v1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0
  %BH = getelementptr i8, ptr %v1, i32 1, !remill_register !7
  %v2 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0
  %CH = getelementptr i8, ptr %v2, i32 1, !remill_register !8
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !9
  %AX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !10
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !11
  %DSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 9, i32 0, i32 0, !remill_register !12
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !13
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !14
  %SSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 1, i32 0, i32 0, !remill_register !15
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !16
  %ESP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !17
  %EBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !18
  %BRANCH_TAKEN = alloca i8, align 1
  %RETURN_PC = alloca i32, align 4
  %MONITOR = alloca i32, align 4
  store i32 0, ptr %MONITOR, align 4
  %STATE = alloca ptr, align 4
  store ptr %state, ptr %STATE, align 4
  %MEMORY = alloca ptr, align 4
  store ptr %memory, ptr %MEMORY, align 4
  %NEXT_PC = alloca i32, align 4
  store i32 %program_counter, ptr %NEXT_PC, align 4
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !19
  store i32 %program_counter, ptr %PC, align 4
  %v3 = add i32 %program_counter, 1
  store i32 %v3, ptr %NEXT_PC, align 4
  %v4 = load i32, ptr %EBP, align 4
  %v5 = load ptr, ptr %MEMORY, align 4
  %v6 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v5, ptr %state, i32 %v4)
  store ptr %v6, ptr %MEMORY, align 4
  store i32 %v3, ptr %PC, align 4
  %v7 = add i32 %v3, 2
  store i32 %v7, ptr %NEXT_PC, align 4
  %v8 = load i32, ptr %ESP, align 4
  %v9 = load ptr, ptr %MEMORY, align 4
  %v10 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9, ptr %state, ptr %EBP, i32 %v8)
  store ptr %v10, ptr %MEMORY, align 4
  store i32 %v7, ptr %PC, align 4
  %v11 = add i32 %v7, 1
  store i32 %v11, ptr %NEXT_PC, align 4
  %v12 = load i32, ptr %EBX, align 4
  %v13 = load ptr, ptr %MEMORY, align 4
  %v14 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v13, ptr %state, i32 %v12)
  store ptr %v14, ptr %MEMORY, align 4
  store i32 %v11, ptr %PC, align 4
  %v15 = add i32 %v11, 6
  store i32 %v15, ptr %NEXT_PC, align 4
  %v16 = load i32, ptr %ESP, align 4
  %v17 = load ptr, ptr %MEMORY, align 4
  %v18 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v17, ptr %state, ptr %ESP, i32 %v16, i32 132)
  store ptr %v18, ptr %MEMORY, align 4
  store i32 %v15, ptr %PC, align 4
  %v19 = add i32 %v15, 7
  store i32 %v19, ptr %NEXT_PC, align 4
  %v20 = load i32, ptr %EBP, align 4
  %v21 = load i32, ptr %SSBASE, align 4
  %v22 = sub i32 %v20, 12
  %v23 = add i32 %v22, %v21
  %v24 = load ptr, ptr %MEMORY, align 4
  %v25 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v24, ptr %state, i32 %v23, i32 0)
  store ptr %v25, ptr %MEMORY, align 4
  store i32 %v19, ptr %PC, align 4
  %v26 = add i32 %v19, 7
  store i32 %v26, ptr %NEXT_PC, align 4
  %v27 = load i32, ptr %EBP, align 4
  %v28 = load i32, ptr %SSBASE, align 4
  %v29 = sub i32 %v27, 16
  %v30 = add i32 %v29, %v28
  %v31 = load ptr, ptr %MEMORY, align 4
  %v32 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v31, ptr %state, i32 %v30, i32 0)
  store ptr %v32, ptr %MEMORY, align 4
  store i32 %v26, ptr %PC, align 4
  %v33 = add i32 %v26, 8
  store i32 %v33, ptr %NEXT_PC, align 4
  %v34 = load i32, ptr %ESP, align 4
  %v35 = load i32, ptr %SSBASE, align 4
  %v36 = add i32 %v34, 8
  %v37 = add i32 %v36, %v35
  %v38 = load ptr, ptr %MEMORY, align 4
  %v39 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v38, ptr %state, i32 %v37, i32 68)
  store ptr %v39, ptr %MEMORY, align 4
  store i32 %v33, ptr %PC, align 4
  %v40 = add i32 %v33, 8
  store i32 %v40, ptr %NEXT_PC, align 4
  %v41 = load i32, ptr %ESP, align 4
  %v42 = load i32, ptr %SSBASE, align 4
  %v43 = add i32 %v41, 4
  %v44 = add i32 %v43, %v42
  %v45 = load ptr, ptr %MEMORY, align 4
  %v46 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v45, ptr %state, i32 %v44, i32 0)
  store ptr %v46, ptr %MEMORY, align 4
  store i32 %v40, ptr %PC, align 4
  %v47 = add i32 %v40, 3
  store i32 %v47, ptr %NEXT_PC, align 4
  %v48 = load i32, ptr %EBP, align 4
  %v49 = sub i32 %v48, 104
  %v50 = load ptr, ptr %MEMORY, align 4
  %v51 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v50, ptr %state, ptr %EAX, i32 %v49)
  store ptr %v51, ptr %MEMORY, align 4
  store i32 %v47, ptr %PC, align 4
  %v52 = add i32 %v47, 3
  store i32 %v52, ptr %NEXT_PC, align 4
  %v53 = load i32, ptr %ESP, align 4
  %v54 = load i32, ptr %SSBASE, align 4
  %v55 = add i32 %v53, %v54
  %v56 = load i32, ptr %EAX, align 4
  %v57 = load ptr, ptr %MEMORY, align 4
  %v58 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v57, ptr %state, i32 %v55, i32 %v56)
  store ptr %v58, ptr %MEMORY, align 4
  store i32 %v52, ptr %PC, align 4
  %v59 = add i32 %v52, 5
  store i32 %v59, ptr %NEXT_PC, align 4
  %v60 = add i32 %v59, 29783
  %v61 = load ptr, ptr %MEMORY, align 4
  %v62 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v61, ptr %state, i64 4228524, ptr %NEXT_PC, i32 %v59, ptr %RETURN_PC)
  store ptr %v62, ptr %MEMORY, align 4
  store i32 %v59, ptr %PC, align 4
  %v63 = add i32 %v59, 5
  store i32 %v63, ptr %NEXT_PC, align 4
  %v64 = load ptr, ptr %MEMORY, align 4
  %v65 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v64, ptr %state, ptr %EAX, i32 16)
  store ptr %v65, ptr %MEMORY, align 4
  store i32 %v63, ptr %PC, align 4
  %v66 = add i32 %v63, 3
  store i32 %v66, ptr %NEXT_PC, align 4
  %v67 = load i32, ptr %EAX, align 4
  %v68 = load ptr, ptr %MEMORY, align 4
  %v69 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v68, ptr %state, ptr %EAX, i32 %v67, i32 1)
  store ptr %v69, ptr %MEMORY, align 4
  store i32 %v66, ptr %PC, align 4
  %v70 = add i32 %v66, 3
  store i32 %v70, ptr %NEXT_PC, align 4
  %v71 = load i32, ptr %EAX, align 4
  %v72 = load ptr, ptr %MEMORY, align 4
  %v73 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v72, ptr %state, ptr %EAX, i32 %v71, i32 47)
  store ptr %v73, ptr %MEMORY, align 4
  store i32 %v70, ptr %PC, align 4
  %v74 = add i32 %v70, 7
  store i32 %v74, ptr %NEXT_PC, align 4
  %v75 = load i32, ptr %EBP, align 4
  %v76 = load i32, ptr %SSBASE, align 4
  %v77 = sub i32 %v75, 108
  %v78 = add i32 %v77, %v76
  %v79 = load ptr, ptr %MEMORY, align 4
  %v80 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v79, ptr %state, i32 %v78, i32 16)
  store ptr %v80, ptr %MEMORY, align 4
  store i32 %v74, ptr %PC, align 4
  %v81 = add i32 %v74, 5
  store i32 %v81, ptr %NEXT_PC, align 4
  %v82 = load ptr, ptr %MEMORY, align 4
  %v83 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v82, ptr %state, ptr %EDX, i32 0)
  store ptr %v83, ptr %MEMORY, align 4
  store i32 %v81, ptr %PC, align 4
  %v84 = add i32 %v81, 3
  store i32 %v84, ptr %NEXT_PC, align 4
  %v85 = load i32, ptr %EBP, align 4
  %v86 = load i32, ptr %SSBASE, align 4
  %v87 = sub i32 %v85, 108
  %v88 = add i32 %v87, %v86
  %v89 = load ptr, ptr %MEMORY, align 4
  %v90 = call ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr %v89, ptr %state, i32 %v88, i32 %v84)
  store ptr %v90, ptr %MEMORY, align 4
  store i32 %v84, ptr %PC, align 4
  %v91 = add i32 %v84, 3
  store i32 %v91, ptr %NEXT_PC, align 4
  %v92 = load i32, ptr %EAX, align 4
  %v93 = load ptr, ptr %MEMORY, align 4
  %v94 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v93, ptr %state, ptr %EAX, i32 %v92, i32 16)
  store ptr %v94, ptr %MEMORY, align 4
  store i32 %v91, ptr %PC, align 4
  %v95 = add i32 %v91, 5
  store i32 %v95, ptr %NEXT_PC, align 4
  %v96 = add i32 %v95, 7141
  %v97 = load ptr, ptr %MEMORY, align 4
  %v98 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v97, ptr %state, i64 4205916, ptr %NEXT_PC, i32 %v95, ptr %RETURN_PC)
  store ptr %v98, ptr %MEMORY, align 4
  store i32 %v95, ptr %PC, align 4
  %v99 = add i32 %v95, 2
  store i32 %v99, ptr %NEXT_PC, align 4
  %v100 = load i32, ptr %ESP, align 4
  %v101 = load i32, ptr %EAX, align 4
  %v102 = load ptr, ptr %MEMORY, align 4
  %v103 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v102, ptr %state, ptr %ESP, i32 %v100, i32 %v101)
  store ptr %v103, ptr %MEMORY, align 4
  store i32 %v99, ptr %PC, align 4
  %v104 = add i32 %v99, 4
  store i32 %v104, ptr %NEXT_PC, align 4
  %v105 = load i32, ptr %ESP, align 4
  %v106 = add i32 %v105, 12
  %v107 = load ptr, ptr %MEMORY, align 4
  %v108 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v107, ptr %state, ptr %EAX, i32 %v106)
  store ptr %v108, ptr %MEMORY, align 4
  store i32 %v104, ptr %PC, align 4
  %v109 = add i32 %v104, 3
  store i32 %v109, ptr %NEXT_PC, align 4
  %v110 = load i32, ptr %EAX, align 4
  %v111 = load ptr, ptr %MEMORY, align 4
  %v112 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v111, ptr %state, ptr %EAX, i32 %v110, i32 15)
  store ptr %v112, ptr %MEMORY, align 4
  store i32 %v109, ptr %PC, align 4
  %v113 = add i32 %v109, 3
  store i32 %v113, ptr %NEXT_PC, align 4
  %v114 = load i32, ptr %EAX, align 4
  %v115 = load ptr, ptr %MEMORY, align 4
  %v116 = call ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v115, ptr %state, ptr %EAX, i32 %v114, i32 4)
  store ptr %v116, ptr %MEMORY, align 4
  store i32 %v113, ptr %PC, align 4
  %v117 = add i32 %v113, 3
  store i32 %v117, ptr %NEXT_PC, align 4
  %v118 = load i32, ptr %EAX, align 4
  %v119 = load ptr, ptr %MEMORY, align 4
  %v120 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v119, ptr %state, ptr %EAX, i32 %v118, i32 4)
  store ptr %v120, ptr %MEMORY, align 4
  store i32 %v117, ptr %PC, align 4
  %v121 = add i32 %v117, 3
  store i32 %v121, ptr %NEXT_PC, align 4
  %v122 = load i32, ptr %EBP, align 4
  %v123 = load i32, ptr %SSBASE, align 4
  %v124 = sub i32 %v122, 12
  %v125 = add i32 %v124, %v123
  %v126 = load i32, ptr %EAX, align 4
  %v127 = load ptr, ptr %MEMORY, align 4
  %v128 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v127, ptr %state, i32 %v125, i32 %v126)
  store ptr %v128, ptr %MEMORY, align 4
  store i32 %v121, ptr %PC, align 4
  %v129 = add i32 %v121, 8
  store i32 %v129, ptr %NEXT_PC, align 4
  %v130 = load i32, ptr %ESP, align 4
  %v131 = load i32, ptr %SSBASE, align 4
  %v132 = add i32 %v130, 8
  %v133 = add i32 %v132, %v131
  %v134 = load ptr, ptr %MEMORY, align 4
  %v135 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v134, ptr %state, i32 %v133, i32 32)
  store ptr %v135, ptr %MEMORY, align 4
  store i32 %v129, ptr %PC, align 4
  %v136 = add i32 %v129, 8
  store i32 %v136, ptr %NEXT_PC, align 4
  %v137 = load i32, ptr %ESP, align 4
  %v138 = load i32, ptr %SSBASE, align 4
  %v139 = add i32 %v137, 4
  %v140 = add i32 %v139, %v138
  %v141 = load ptr, ptr %MEMORY, align 4
  %v142 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v141, ptr %state, i32 %v140, i32 204)
  store ptr %v142, ptr %MEMORY, align 4
  store i32 %v136, ptr %PC, align 4
  %v143 = add i32 %v136, 3
  store i32 %v143, ptr %NEXT_PC, align 4
  %v144 = load i32, ptr %EBP, align 4
  %v145 = load i32, ptr %SSBASE, align 4
  %v146 = sub i32 %v144, 12
  %v147 = add i32 %v146, %v145
  %v148 = load ptr, ptr %MEMORY, align 4
  %v149 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v148, ptr %state, ptr %EAX, i32 %v147)
  store ptr %v149, ptr %MEMORY, align 4
  store i32 %v143, ptr %PC, align 4
  %v150 = add i32 %v143, 3
  store i32 %v150, ptr %NEXT_PC, align 4
  %v151 = load i32, ptr %ESP, align 4
  %v152 = load i32, ptr %SSBASE, align 4
  %v153 = add i32 %v151, %v152
  %v154 = load i32, ptr %EAX, align 4
  %v155 = load ptr, ptr %MEMORY, align 4
  %v156 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v155, ptr %state, i32 %v153, i32 %v154)
  store ptr %v156, ptr %MEMORY, align 4
  store i32 %v150, ptr %PC, align 4
  %v157 = add i32 %v150, 5
  store i32 %v157, ptr %NEXT_PC, align 4
  %v158 = add i32 %v157, 29704
  %v159 = load ptr, ptr %MEMORY, align 4
  %v160 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v159, ptr %state, i64 4228524, ptr %NEXT_PC, i32 %v157, ptr %RETURN_PC)
  store ptr %v160, ptr %MEMORY, align 4
  store i32 %v157, ptr %PC, align 4
  %v161 = add i32 %v157, 3
  store i32 %v161, ptr %NEXT_PC, align 4
  %v162 = load i32, ptr %ESP, align 4
  %v163 = load ptr, ptr %MEMORY, align 4
  %v164 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v163, ptr %state, ptr %ESP, i32 %v162, i32 -16)
  store ptr %v164, ptr %MEMORY, align 4
  store i32 %v161, ptr %PC, align 4
  %v165 = add i32 %v161, 5
  store i32 %v165, ptr %NEXT_PC, align 4
  %v166 = load i32, ptr %DSBASE, align 4
  %v167 = add i32 4239392, %v166
  %v168 = load ptr, ptr %MEMORY, align 4
  %v169 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v168, ptr %state, ptr %EAX, i32 %v167)
  store ptr %v169, ptr %MEMORY, align 4
  store i32 %v165, ptr %PC, align 4
  %v170 = add i32 %v165, 2
  store i32 %v170, ptr %NEXT_PC, align 4
  %v171 = load i32, ptr %EAX, align 4
  %v172 = load i32, ptr %EAX, align 4
  %v173 = load ptr, ptr %MEMORY, align 4
  %v174 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v173, ptr %state, i32 %v171, i32 %v172)
  store ptr %v174, ptr %MEMORY, align 4
  store i32 %v170, ptr %PC, align 4
  %v175 = add i32 %v170, 2
  store i32 %v175, ptr %NEXT_PC, align 4
  %v176 = add i32 %v175, 16
  %v177 = load ptr, ptr %MEMORY, align 4
  %v178 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v177, ptr %state, ptr %BRANCH_TAKEN, i32 %v176, i32 %v175, ptr %NEXT_PC)
  store ptr %v178, ptr %MEMORY, align 4
  br i1 true, label %bb_4198848, label %bb_4198832

bb_4198832:                                       ; preds = %bb_0
  store i32 %v175, ptr %PC, align 4
  %v179 = add i32 %v175, 3
  store i32 %v179, ptr %NEXT_PC, align 4
  %v180 = load i32, ptr %EBP, align 4
  %v181 = sub i32 %v180, 104
  %v182 = load ptr, ptr %MEMORY, align 4
  %v183 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v182, ptr %state, ptr %EAX, i32 %v181)
  store ptr %v183, ptr %MEMORY, align 4
  store i32 %v179, ptr %PC, align 4
  %v184 = add i32 %v179, 3
  store i32 %v184, ptr %NEXT_PC, align 4
  %v185 = load i32, ptr %ESP, align 4
  %v186 = load i32, ptr %SSBASE, align 4
  %v187 = add i32 %v185, %v186
  %v188 = load i32, ptr %EAX, align 4
  %v189 = load ptr, ptr %MEMORY, align 4
  %v190 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v189, ptr %state, i32 %v187, i32 %v188)
  store ptr %v190, ptr %MEMORY, align 4
  store i32 %v184, ptr %PC, align 4
  %v191 = add i32 %v184, 5
  store i32 %v191, ptr %NEXT_PC, align 4
  %v192 = load i32, ptr %DSBASE, align 4
  %v193 = add i32 4243820, %v192
  %v194 = load ptr, ptr %MEMORY, align 4
  %v195 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v194, ptr %state, ptr %EAX, i32 %v193)
  store ptr %v195, ptr %MEMORY, align 4
  store i32 %v191, ptr %PC, align 4
  %v196 = add i32 %v191, 2
  store i32 %v196, ptr %NEXT_PC, align 4
  %v197 = load i32, ptr %EAX, align 4
  %v198 = load ptr, ptr %MEMORY, align 4
  %v199 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v198, ptr %state, i32 %v197, ptr %NEXT_PC, i32 %v196, ptr %RETURN_PC)
  store ptr %v199, ptr %MEMORY, align 4
  store i32 %v196, ptr %PC, align 4
  %v200 = add i32 %v196, 3
  store i32 %v200, ptr %NEXT_PC, align 4
  %v201 = load i32, ptr %ESP, align 4
  %v202 = load ptr, ptr %MEMORY, align 4
  %v203 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v202, ptr %state, ptr %ESP, i32 %v201, i32 4)
  store ptr %v203, ptr %MEMORY, align 4
  br label %bb_4198848

bb_4198848:                                       ; preds = %bb_4198832, %bb_0
  %v204 = load i32, ptr %NEXT_PC, align 4
  store i32 %v204, ptr %PC, align 4
  %v205 = add i32 %v204, 7
  store i32 %v205, ptr %NEXT_PC, align 4
  %v206 = load i32, ptr %EBP, align 4
  %v207 = load i32, ptr %SSBASE, align 4
  %v208 = sub i32 %v206, 24
  %v209 = add i32 %v208, %v207
  %v210 = load ptr, ptr %MEMORY, align 4
  %v211 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v210, ptr %state, i32 %v209, i32 0)
  store ptr %v211, ptr %MEMORY, align 4
  store i32 %v205, ptr %PC, align 4
  %v212 = add i32 %v205, 5
  store i32 %v212, ptr %NEXT_PC, align 4
  %v213 = add i32 %v212, 7100
  %v214 = load ptr, ptr %MEMORY, align 4
  %v215 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v214, ptr %state, i64 4205960, ptr %NEXT_PC, i32 %v212, ptr %RETURN_PC)
  store ptr %v215, ptr %MEMORY, align 4
  store i32 %v212, ptr %PC, align 4
  %v216 = add i32 %v212, 3
  store i32 %v216, ptr %NEXT_PC, align 4
  %v217 = load i32, ptr %EAX, align 4
  %v218 = load i32, ptr %DSBASE, align 4
  %v219 = add i32 %v217, 4
  %v220 = add i32 %v219, %v218
  %v221 = load ptr, ptr %MEMORY, align 4
  %v222 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v221, ptr %state, ptr %EAX, i32 %v220)
  store ptr %v222, ptr %MEMORY, align 4
  store i32 %v216, ptr %PC, align 4
  %v223 = add i32 %v216, 3
  store i32 %v223, ptr %NEXT_PC, align 4
  %v224 = load i32, ptr %EBP, align 4
  %v225 = load i32, ptr %SSBASE, align 4
  %v226 = sub i32 %v224, 28
  %v227 = add i32 %v226, %v225
  %v228 = load i32, ptr %EAX, align 4
  %v229 = load ptr, ptr %MEMORY, align 4
  %v230 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v229, ptr %state, i32 %v227, i32 %v228)
  store ptr %v230, ptr %MEMORY, align 4
  store i32 %v223, ptr %PC, align 4
  %v231 = add i32 %v223, 7
  store i32 %v231, ptr %NEXT_PC, align 4
  %v232 = load i32, ptr %EBP, align 4
  %v233 = load i32, ptr %SSBASE, align 4
  %v234 = sub i32 %v232, 20
  %v235 = add i32 %v234, %v233
  %v236 = load ptr, ptr %MEMORY, align 4
  %v237 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v236, ptr %state, i32 %v235, i32 0)
  store ptr %v237, ptr %MEMORY, align 4
  store i32 %v231, ptr %PC, align 4
  %v238 = add i32 %v231, 2
  store i32 %v238, ptr %NEXT_PC, align 4
  %v239 = add i32 %v238, 34
  %v240 = load ptr, ptr %MEMORY, align 4
  %v241 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v240, ptr %state, i32 %v239, ptr %NEXT_PC)
  store ptr %v241, ptr %MEMORY, align 4
  br label %bb_4198909

bb_4198875:                                       ; preds = %bb_4198909
  store i32 %v343, ptr %PC, align 4
  %v242 = add i32 %v343, 3
  store i32 %v242, ptr %NEXT_PC, align 4
  %v243 = load i32, ptr %EBP, align 4
  %v244 = load i32, ptr %SSBASE, align 4
  %v245 = sub i32 %v243, 24
  %v246 = add i32 %v245, %v244
  %v247 = load ptr, ptr %MEMORY, align 4
  %v248 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v247, ptr %state, ptr %EAX, i32 %v246)
  store ptr %v248, ptr %MEMORY, align 4
  store i32 %v242, ptr %PC, align 4
  %v249 = add i32 %v242, 3
  store i32 %v249, ptr %NEXT_PC, align 4
  %v250 = load i32, ptr %EAX, align 4
  %v251 = load i32, ptr %EBP, align 4
  %v252 = load i32, ptr %SSBASE, align 4
  %v253 = sub i32 %v251, 28
  %v254 = add i32 %v253, %v252
  %v255 = load ptr, ptr %MEMORY, align 4
  %v256 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v255, ptr %state, i32 %v250, i32 %v254)
  store ptr %v256, ptr %MEMORY, align 4
  store i32 %v249, ptr %PC, align 4
  %v257 = add i32 %v249, 2
  store i32 %v257, ptr %NEXT_PC, align 4
  %v258 = add i32 %v257, 9
  %v259 = load ptr, ptr %MEMORY, align 4
  %v260 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v259, ptr %state, ptr %BRANCH_TAKEN, i32 %v258, i32 %v257, ptr %NEXT_PC)
  store ptr %v260, ptr %MEMORY, align 4
  br i1 true, label %bb_4198892, label %bb_4198883

bb_4198883:                                       ; preds = %bb_4198875
  store i32 %v257, ptr %PC, align 4
  %v261 = add i32 %v257, 7
  store i32 %v261, ptr %NEXT_PC, align 4
  %v262 = load i32, ptr %EBP, align 4
  %v263 = load i32, ptr %SSBASE, align 4
  %v264 = sub i32 %v262, 20
  %v265 = add i32 %v264, %v263
  %v266 = load ptr, ptr %MEMORY, align 4
  %v267 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v266, ptr %state, i32 %v265, i32 1)
  store ptr %v267, ptr %MEMORY, align 4
  store i32 %v261, ptr %PC, align 4
  %v268 = add i32 %v261, 2
  store i32 %v268, ptr %NEXT_PC, align 4
  %v269 = add i32 %v268, 56
  %v270 = load ptr, ptr %MEMORY, align 4
  %v271 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v270, ptr %state, i32 %v269, ptr %NEXT_PC)
  store ptr %v271, ptr %MEMORY, align 4
  br label %bb_4198948

bb_4198892:                                       ; preds = %bb_4198875
  store i32 %v257, ptr %PC, align 4
  %v272 = add i32 %v257, 7
  store i32 %v272, ptr %NEXT_PC, align 4
  %v273 = load i32, ptr %ESP, align 4
  %v274 = load i32, ptr %SSBASE, align 4
  %v275 = add i32 %v273, %v274
  %v276 = load ptr, ptr %MEMORY, align 4
  %v277 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v276, ptr %state, i32 %v275, i32 1000)
  store ptr %v277, ptr %MEMORY, align 4
  store i32 %v272, ptr %PC, align 4
  %v278 = add i32 %v272, 5
  store i32 %v278, ptr %NEXT_PC, align 4
  %v279 = load i32, ptr %DSBASE, align 4
  %v280 = add i32 4243864, %v279
  %v281 = load ptr, ptr %MEMORY, align 4
  %v282 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v281, ptr %state, ptr %EAX, i32 %v280)
  store ptr %v282, ptr %MEMORY, align 4
  store i32 %v278, ptr %PC, align 4
  %v283 = add i32 %v278, 2
  store i32 %v283, ptr %NEXT_PC, align 4
  %v284 = load i32, ptr %EAX, align 4
  %v285 = load ptr, ptr %MEMORY, align 4
  %v286 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v285, ptr %state, i32 %v284, ptr %NEXT_PC, i32 %v283, ptr %RETURN_PC)
  store ptr %v286, ptr %MEMORY, align 4
  store i32 %v283, ptr %PC, align 4
  %v287 = add i32 %v283, 3
  store i32 %v287, ptr %NEXT_PC, align 4
  %v288 = load i32, ptr %ESP, align 4
  %v289 = load ptr, ptr %MEMORY, align 4
  %v290 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v289, ptr %state, ptr %ESP, i32 %v288, i32 4)
  store ptr %v290, ptr %MEMORY, align 4
  br label %bb_4198909

bb_4198909:                                       ; preds = %bb_4198892, %bb_4198848
  %v291 = load i32, ptr %NEXT_PC, align 4
  store i32 %v291, ptr %PC, align 4
  %v292 = add i32 %v291, 3
  store i32 %v292, ptr %NEXT_PC, align 4
  %v293 = load i32, ptr %EBP, align 4
  %v294 = load i32, ptr %SSBASE, align 4
  %v295 = sub i32 %v293, 28
  %v296 = add i32 %v295, %v294
  %v297 = load ptr, ptr %MEMORY, align 4
  %v298 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v297, ptr %state, ptr %EAX, i32 %v296)
  store ptr %v298, ptr %MEMORY, align 4
  store i32 %v292, ptr %PC, align 4
  %v299 = add i32 %v292, 8
  store i32 %v299, ptr %NEXT_PC, align 4
  %v300 = load i32, ptr %ESP, align 4
  %v301 = load i32, ptr %SSBASE, align 4
  %v302 = add i32 %v300, 8
  %v303 = add i32 %v302, %v301
  %v304 = load ptr, ptr %MEMORY, align 4
  %v305 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v304, ptr %state, i32 %v303, i32 0)
  store ptr %v305, ptr %MEMORY, align 4
  store i32 %v299, ptr %PC, align 4
  %v306 = add i32 %v299, 4
  store i32 %v306, ptr %NEXT_PC, align 4
  %v307 = load i32, ptr %ESP, align 4
  %v308 = load i32, ptr %SSBASE, align 4
  %v309 = add i32 %v307, 4
  %v310 = add i32 %v309, %v308
  %v311 = load i32, ptr %EAX, align 4
  %v312 = load ptr, ptr %MEMORY, align 4
  %v313 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v312, ptr %state, i32 %v310, i32 %v311)
  store ptr %v313, ptr %MEMORY, align 4
  store i32 %v306, ptr %PC, align 4
  %v314 = add i32 %v306, 7
  store i32 %v314, ptr %NEXT_PC, align 4
  %v315 = load i32, ptr %ESP, align 4
  %v316 = load i32, ptr %SSBASE, align 4
  %v317 = add i32 %v315, %v316
  %v318 = load ptr, ptr %MEMORY, align 4
  %v319 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v318, ptr %state, i32 %v317, i32 4242868)
  store ptr %v319, ptr %MEMORY, align 4
  store i32 %v314, ptr %PC, align 4
  %v320 = add i32 %v314, 5
  store i32 %v320, ptr %NEXT_PC, align 4
  %v321 = add i32 %v320, 7090
  %v322 = load ptr, ptr %MEMORY, align 4
  %v323 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v322, ptr %state, i64 4206026, ptr %NEXT_PC, i32 %v320, ptr %RETURN_PC)
  store ptr %v323, ptr %MEMORY, align 4
  store i32 %v320, ptr %PC, align 4
  %v324 = add i32 %v320, 3
  store i32 %v324, ptr %NEXT_PC, align 4
  %v325 = load i32, ptr %ESP, align 4
  %v326 = load ptr, ptr %MEMORY, align 4
  %v327 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v326, ptr %state, ptr %ESP, i32 %v325, i32 12)
  store ptr %v327, ptr %MEMORY, align 4
  store i32 %v324, ptr %PC, align 4
  %v328 = add i32 %v324, 3
  store i32 %v328, ptr %NEXT_PC, align 4
  %v329 = load i32, ptr %EBP, align 4
  %v330 = load i32, ptr %SSBASE, align 4
  %v331 = sub i32 %v329, 24
  %v332 = add i32 %v331, %v330
  %v333 = load i32, ptr %EAX, align 4
  %v334 = load ptr, ptr %MEMORY, align 4
  %v335 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v334, ptr %state, i32 %v332, i32 %v333)
  store ptr %v335, ptr %MEMORY, align 4
  store i32 %v328, ptr %PC, align 4
  %v336 = add i32 %v328, 4
  store i32 %v336, ptr %NEXT_PC, align 4
  %v337 = load i32, ptr %EBP, align 4
  %v338 = load i32, ptr %SSBASE, align 4
  %v339 = sub i32 %v337, 24
  %v340 = add i32 %v339, %v338
  %v341 = load ptr, ptr %MEMORY, align 4
  %v342 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v341, ptr %state, i32 %v340, i32 0)
  store ptr %v342, ptr %MEMORY, align 4
  store i32 %v336, ptr %PC, align 4
  %v343 = add i32 %v336, 2
  store i32 %v343, ptr %NEXT_PC, align 4
  %v344 = sub i32 %v343, 73
  %v345 = load ptr, ptr %MEMORY, align 4
  %v346 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v345, ptr %state, ptr %BRANCH_TAKEN, i32 %v344, i32 %v343, ptr %NEXT_PC)
  store ptr %v346, ptr %MEMORY, align 4
  br i1 true, label %bb_4198875, label %bb_4198948

bb_4198948:                                       ; preds = %bb_4198909, %bb_4198883
  %v347 = load i32, ptr %NEXT_PC, align 4
  store i32 %v347, ptr %PC, align 4
  %v348 = add i32 %v347, 5
  store i32 %v348, ptr %NEXT_PC, align 4
  %v349 = load i32, ptr %DSBASE, align 4
  %v350 = add i32 4242872, %v349
  %v351 = load ptr, ptr %MEMORY, align 4
  %v352 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v351, ptr %state, ptr %EAX, i32 %v350)
  store ptr %v352, ptr %MEMORY, align 4
  store i32 %v348, ptr %PC, align 4
  %v353 = add i32 %v348, 3
  store i32 %v353, ptr %NEXT_PC, align 4
  %v354 = load i32, ptr %EAX, align 4
  %v355 = load ptr, ptr %MEMORY, align 4
  %v356 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v355, ptr %state, i32 %v354, i32 1)
  store ptr %v356, ptr %MEMORY, align 4
  store i32 %v353, ptr %PC, align 4
  %v357 = add i32 %v353, 2
  store i32 %v357, ptr %NEXT_PC, align 4
  %v358 = add i32 %v357, 14
  %v359 = load ptr, ptr %MEMORY, align 4
  %v360 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v359, ptr %state, ptr %BRANCH_TAKEN, i32 %v358, i32 %v357, ptr %NEXT_PC)
  store ptr %v360, ptr %MEMORY, align 4
  br i1 true, label %bb_4198972, label %bb_4198958

bb_4198958:                                       ; preds = %bb_4198948
  store i32 %v357, ptr %PC, align 4
  %v361 = add i32 %v357, 7
  store i32 %v361, ptr %NEXT_PC, align 4
  %v362 = load i32, ptr %ESP, align 4
  %v363 = load i32, ptr %SSBASE, align 4
  %v364 = add i32 %v362, %v363
  %v365 = load ptr, ptr %MEMORY, align 4
  %v366 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v365, ptr %state, i32 %v364, i32 31)
  store ptr %v366, ptr %MEMORY, align 4
  store i32 %v361, ptr %PC, align 4
  %v367 = add i32 %v361, 5
  store i32 %v367, ptr %NEXT_PC, align 4
  %v368 = add i32 %v367, 29562
  %v369 = load ptr, ptr %MEMORY, align 4
  %v370 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v369, ptr %state, i64 4228532, ptr %NEXT_PC, i32 %v367, ptr %RETURN_PC)
  store ptr %v370, ptr %MEMORY, align 4
  store i32 %v367, ptr %PC, align 4
  %v371 = add i32 %v367, 2
  store i32 %v371, ptr %NEXT_PC, align 4
  %v372 = add i32 %v371, 51
  %v373 = load ptr, ptr %MEMORY, align 4
  %v374 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v373, ptr %state, i32 %v372, ptr %NEXT_PC)
  store ptr %v374, ptr %MEMORY, align 4
  br label %bb_4199023

bb_4198972:                                       ; preds = %bb_4198948
  store i32 %v357, ptr %PC, align 4
  %v375 = add i32 %v357, 5
  store i32 %v375, ptr %NEXT_PC, align 4
  %v376 = load i32, ptr %DSBASE, align 4
  %v377 = add i32 4242872, %v376
  %v378 = load ptr, ptr %MEMORY, align 4
  %v379 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v378, ptr %state, ptr %EAX, i32 %v377)
  store ptr %v379, ptr %MEMORY, align 4
  store i32 %v375, ptr %PC, align 4
  %v380 = add i32 %v375, 2
  store i32 %v380, ptr %NEXT_PC, align 4
  %v381 = load i32, ptr %EAX, align 4
  %v382 = load i32, ptr %EAX, align 4
  %v383 = load ptr, ptr %MEMORY, align 4
  %v384 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v383, ptr %state, i32 %v381, i32 %v382)
  store ptr %v384, ptr %MEMORY, align 4
  store i32 %v380, ptr %PC, align 4
  %v385 = add i32 %v380, 2
  store i32 %v385, ptr %NEXT_PC, align 4
  %v386 = add i32 %v385, 32
  %v387 = load ptr, ptr %MEMORY, align 4
  %v388 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v387, ptr %state, ptr %BRANCH_TAKEN, i32 %v386, i32 %v385, ptr %NEXT_PC)
  store ptr %v388, ptr %MEMORY, align 4
  br i1 true, label %bb_4199013, label %bb_4198981

bb_4198981:                                       ; preds = %bb_4198972
  store i32 %v385, ptr %PC, align 4
  %v389 = add i32 %v385, 10
  store i32 %v389, ptr %NEXT_PC, align 4
  %v390 = load i32, ptr %DSBASE, align 4
  %v391 = add i32 4242872, %v390
  %v392 = load ptr, ptr %MEMORY, align 4
  %v393 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v392, ptr %state, i32 %v391, i32 1)
  store ptr %v393, ptr %MEMORY, align 4
  store i32 %v389, ptr %PC, align 4
  %v394 = add i32 %v389, 8
  store i32 %v394, ptr %NEXT_PC, align 4
  %v395 = load i32, ptr %ESP, align 4
  %v396 = load i32, ptr %SSBASE, align 4
  %v397 = add i32 %v395, 4
  %v398 = add i32 %v397, %v396
  %v399 = load ptr, ptr %MEMORY, align 4
  %v400 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v399, ptr %state, i32 %v398, i32 4247576)
  store ptr %v400, ptr %MEMORY, align 4
  store i32 %v394, ptr %PC, align 4
  %v401 = add i32 %v394, 7
  store i32 %v401, ptr %NEXT_PC, align 4
  %v402 = load i32, ptr %ESP, align 4
  %v403 = load i32, ptr %SSBASE, align 4
  %v404 = add i32 %v402, %v403
  %v405 = load ptr, ptr %MEMORY, align 4
  %v406 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v405, ptr %state, i32 %v404, i32 4247564)
  store ptr %v406, ptr %MEMORY, align 4
  store i32 %v401, ptr %PC, align 4
  %v407 = add i32 %v401, 5
  store i32 %v407, ptr %NEXT_PC, align 4
  %v408 = add i32 %v407, 29529
  %v409 = load ptr, ptr %MEMORY, align 4
  %v410 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v409, ptr %state, i64 4228540, ptr %NEXT_PC, i32 %v407, ptr %RETURN_PC)
  store ptr %v410, ptr %MEMORY, align 4
  store i32 %v407, ptr %PC, align 4
  %v411 = add i32 %v407, 2
  store i32 %v411, ptr %NEXT_PC, align 4
  %v412 = add i32 %v411, 10
  %v413 = load ptr, ptr %MEMORY, align 4
  %v414 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v413, ptr %state, i32 %v412, ptr %NEXT_PC)
  store ptr %v414, ptr %MEMORY, align 4
  br label %bb_4199023

bb_4199013:                                       ; preds = %bb_4198972
  store i32 %v385, ptr %PC, align 4
  %v415 = add i32 %v385, 10
  store i32 %v415, ptr %NEXT_PC, align 4
  %v416 = load i32, ptr %DSBASE, align 4
  %v417 = add i32 4239384, %v416
  %v418 = load ptr, ptr %MEMORY, align 4
  %v419 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v418, ptr %state, i32 %v417, i32 1)
  store ptr %v419, ptr %MEMORY, align 4
  br label %bb_4199023

bb_4199023:                                       ; preds = %bb_4199013, %bb_4198981, %bb_4198958
  %v420 = load i32, ptr %NEXT_PC, align 4
  store i32 %v420, ptr %PC, align 4
  %v421 = add i32 %v420, 5
  store i32 %v421, ptr %NEXT_PC, align 4
  %v422 = load i32, ptr %DSBASE, align 4
  %v423 = add i32 4242872, %v422
  %v424 = load ptr, ptr %MEMORY, align 4
  %v425 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v424, ptr %state, ptr %EAX, i32 %v423)
  store ptr %v425, ptr %MEMORY, align 4
  store i32 %v421, ptr %PC, align 4
  %v426 = add i32 %v421, 3
  store i32 %v426, ptr %NEXT_PC, align 4
  %v427 = load i32, ptr %EAX, align 4
  %v428 = load ptr, ptr %MEMORY, align 4
  %v429 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v428, ptr %state, i32 %v427, i32 1)
  store ptr %v429, ptr %MEMORY, align 4
  store i32 %v426, ptr %PC, align 4
  %v430 = add i32 %v426, 2
  store i32 %v430, ptr %NEXT_PC, align 4
  %v431 = add i32 %v430, 30
  %v432 = load ptr, ptr %MEMORY, align 4
  %v433 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v432, ptr %state, ptr %BRANCH_TAKEN, i32 %v431, i32 %v430, ptr %NEXT_PC)
  store ptr %v433, ptr %MEMORY, align 4
  br i1 true, label %bb_4199063, label %bb_4199033

bb_4199033:                                       ; preds = %bb_4199023
  store i32 %v430, ptr %PC, align 4
  %v434 = add i32 %v430, 8
  store i32 %v434, ptr %NEXT_PC, align 4
  %v435 = load i32, ptr %ESP, align 4
  %v436 = load i32, ptr %SSBASE, align 4
  %v437 = add i32 %v435, 4
  %v438 = add i32 %v437, %v436
  %v439 = load ptr, ptr %MEMORY, align 4
  %v440 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v439, ptr %state, i32 %v438, i32 4247560)
  store ptr %v440, ptr %MEMORY, align 4
  store i32 %v434, ptr %PC, align 4
  %v441 = add i32 %v434, 7
  store i32 %v441, ptr %NEXT_PC, align 4
  %v442 = load i32, ptr %ESP, align 4
  %v443 = load i32, ptr %SSBASE, align 4
  %v444 = add i32 %v442, %v443
  %v445 = load ptr, ptr %MEMORY, align 4
  %v446 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v445, ptr %state, i32 %v444, i32 4247552)
  store ptr %v446, ptr %MEMORY, align 4
  store i32 %v441, ptr %PC, align 4
  %v447 = add i32 %v441, 5
  store i32 %v447, ptr %NEXT_PC, align 4
  %v448 = add i32 %v447, 29487
  %v449 = load ptr, ptr %MEMORY, align 4
  %v450 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v449, ptr %state, i64 4228540, ptr %NEXT_PC, i32 %v447, ptr %RETURN_PC)
  store ptr %v450, ptr %MEMORY, align 4
  store i32 %v447, ptr %PC, align 4
  %v451 = add i32 %v447, 10
  store i32 %v451, ptr %NEXT_PC, align 4
  %v452 = load i32, ptr %DSBASE, align 4
  %v453 = add i32 4242872, %v452
  %v454 = load ptr, ptr %MEMORY, align 4
  %v455 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v454, ptr %state, i32 %v453, i32 2)
  store ptr %v455, ptr %MEMORY, align 4
  br label %bb_4199063

bb_4199063:                                       ; preds = %bb_4199033, %bb_4199023
  %v456 = load i32, ptr %NEXT_PC, align 4
  store i32 %v456, ptr %PC, align 4
  %v457 = add i32 %v456, 4
  store i32 %v457, ptr %NEXT_PC, align 4
  %v458 = load i32, ptr %EBP, align 4
  %v459 = load i32, ptr %SSBASE, align 4
  %v460 = sub i32 %v458, 20
  %v461 = add i32 %v460, %v459
  %v462 = load ptr, ptr %MEMORY, align 4
  %v463 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v462, ptr %state, i32 %v461, i32 0)
  store ptr %v463, ptr %MEMORY, align 4
  store i32 %v457, ptr %PC, align 4
  %v464 = add i32 %v457, 2
  store i32 %v464, ptr %NEXT_PC, align 4
  %v465 = add i32 %v464, 28
  %v466 = load ptr, ptr %MEMORY, align 4
  %v467 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v466, ptr %state, ptr %BRANCH_TAKEN, i32 %v465, i32 %v464, ptr %NEXT_PC)
  store ptr %v467, ptr %MEMORY, align 4
  br i1 true, label %bb_4199097, label %bb_4199069

bb_4199069:                                       ; preds = %bb_4199063
  store i32 %v464, ptr %PC, align 4
  %v468 = add i32 %v464, 7
  store i32 %v468, ptr %NEXT_PC, align 4
  %v469 = load i32, ptr %EBP, align 4
  %v470 = load i32, ptr %SSBASE, align 4
  %v471 = sub i32 %v469, 32
  %v472 = add i32 %v471, %v470
  %v473 = load ptr, ptr %MEMORY, align 4
  %v474 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v473, ptr %state, i32 %v472, i32 4242868)
  store ptr %v474, ptr %MEMORY, align 4
  store i32 %v468, ptr %PC, align 4
  %v475 = add i32 %v468, 7
  store i32 %v475, ptr %NEXT_PC, align 4
  %v476 = load i32, ptr %EBP, align 4
  %v477 = load i32, ptr %SSBASE, align 4
  %v478 = sub i32 %v476, 36
  %v479 = add i32 %v478, %v477
  %v480 = load ptr, ptr %MEMORY, align 4
  %v481 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v480, ptr %state, i32 %v479, i32 0)
  store ptr %v481, ptr %MEMORY, align 4
  store i32 %v475, ptr %PC, align 4
  %v482 = add i32 %v475, 3
  store i32 %v482, ptr %NEXT_PC, align 4
  %v483 = load i32, ptr %EBP, align 4
  %v484 = load i32, ptr %SSBASE, align 4
  %v485 = sub i32 %v483, 32
  %v486 = add i32 %v485, %v484
  %v487 = load ptr, ptr %MEMORY, align 4
  %v488 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v487, ptr %state, ptr %EAX, i32 %v486)
  store ptr %v488, ptr %MEMORY, align 4
  store i32 %v482, ptr %PC, align 4
  %v489 = add i32 %v482, 3
  store i32 %v489, ptr %NEXT_PC, align 4
  %v490 = load i32, ptr %EBP, align 4
  %v491 = load i32, ptr %SSBASE, align 4
  %v492 = sub i32 %v490, 36
  %v493 = add i32 %v492, %v491
  %v494 = load ptr, ptr %MEMORY, align 4
  %v495 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v494, ptr %state, ptr %EDX, i32 %v493)
  store ptr %v495, ptr %MEMORY, align 4
  store i32 %v489, ptr %PC, align 4
  %v496 = add i32 %v489, 2
  store i32 %v496, ptr %NEXT_PC, align 4
  %v497 = load i32, ptr %EDX, align 4
  %v498 = load ptr, ptr %MEMORY, align 4
  %v499 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v498, ptr %state, ptr %EBX, i32 %v497)
  store ptr %v499, ptr %MEMORY, align 4
  store i32 %v496, ptr %PC, align 4
  %v500 = add i32 %v496, 3
  store i32 %v500, ptr %NEXT_PC, align 4
  %v501 = load ptr, ptr %MEMORY, align 4
  %v502 = call ptr @__remill_atomic_begin(ptr %v501)
  store ptr %v502, ptr %MEMORY, align 4
  %v503 = load i32, ptr %EAX, align 4
  %v504 = load i32, ptr %DSBASE, align 4
  %v505 = add i32 %v503, %v504
  %v506 = load i32, ptr %EAX, align 4
  %v507 = load i32, ptr %DSBASE, align 4
  %v508 = add i32 %v506, %v507
  %v509 = load i32, ptr %EBX, align 4
  %v510 = load ptr, ptr %MEMORY, align 4
  %v511 = call ptr @_ZN12_GLOBAL__N_14XCHGI3MnWIjE2MnIjE3RnWIjE2RnIjLb1EEEEP6MemorySA_R5StateT_T0_T1_T2_(ptr %v510, ptr %state, i32 %v505, i32 %v508, ptr %EBX, i32 %v509)
  store ptr %v511, ptr %MEMORY, align 4
  %v512 = load ptr, ptr %MEMORY, align 4
  %v513 = call ptr @__remill_atomic_end(ptr %v512)
  store ptr %v513, ptr %MEMORY, align 4
  store i32 %v500, ptr %PC, align 4
  %v514 = add i32 %v500, 3
  store i32 %v514, ptr %NEXT_PC, align 4
  %v515 = load ptr, ptr %MEMORY, align 4
  %v516 = call ptr @__remill_atomic_begin(ptr %v515)
  store ptr %v516, ptr %MEMORY, align 4
  %v517 = load i32, ptr %EBP, align 4
  %v518 = load i32, ptr %SSBASE, align 4
  %v519 = sub i32 %v517, 36
  %v520 = add i32 %v519, %v518
  %v521 = load i32, ptr %EBX, align 4
  %v522 = load ptr, ptr %MEMORY, align 4
  %v523 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v522, ptr %state, i32 %v520, i32 %v521)
  store ptr %v523, ptr %MEMORY, align 4
  %v524 = load ptr, ptr %MEMORY, align 4
  %v525 = call ptr @__remill_atomic_end(ptr %v524)
  store ptr %v525, ptr %MEMORY, align 4
  br label %bb_4199097

bb_4199097:                                       ; preds = %bb_4199069, %bb_4199063
  %v526 = load i32, ptr %NEXT_PC, align 4
  store i32 %v526, ptr %PC, align 4
  %v527 = add i32 %v526, 5
  store i32 %v527, ptr %NEXT_PC, align 4
  %v528 = load ptr, ptr %MEMORY, align 4
  %v529 = call ptr @__remill_atomic_begin(ptr %v528)
  store ptr %v529, ptr %MEMORY, align 4
  %v530 = load i32, ptr %DSBASE, align 4
  %v531 = add i32 4235356, %v530
  %v532 = load ptr, ptr %MEMORY, align 4
  %v533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v532, ptr %state, ptr %EAX, i32 %v531)
  store ptr %v533, ptr %MEMORY, align 4
  %v534 = load ptr, ptr %MEMORY, align 4
  %v535 = call ptr @__remill_atomic_end(ptr %v534)
  store ptr %v535, ptr %MEMORY, align 4
  store i32 %v527, ptr %PC, align 4
  %v536 = add i32 %v527, 2
  store i32 %v536, ptr %NEXT_PC, align 4
  %v537 = load ptr, ptr %MEMORY, align 4
  %v538 = call ptr @__remill_atomic_begin(ptr %v537)
  store ptr %v538, ptr %MEMORY, align 4
  %v539 = load i32, ptr %EAX, align 4
  %v540 = load i32, ptr %EAX, align 4
  %v541 = load ptr, ptr %MEMORY, align 4
  %v542 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v541, ptr %state, i32 %v539, i32 %v540)
  store ptr %v542, ptr %MEMORY, align 4
  %v543 = load ptr, ptr %MEMORY, align 4
  %v544 = call ptr @__remill_atomic_end(ptr %v543)
  store ptr %v544, ptr %MEMORY, align 4
  store i32 %v536, ptr %PC, align 4
  %v545 = add i32 %v536, 2
  store i32 %v545, ptr %NEXT_PC, align 4
  %v546 = load ptr, ptr %MEMORY, align 4
  %v547 = call ptr @__remill_atomic_begin(ptr %v546)
  store ptr %v547, ptr %MEMORY, align 4
  %v548 = add i32 %v545, 33
  %v549 = load ptr, ptr %MEMORY, align 4
  %v550 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v549, ptr %state, ptr %BRANCH_TAKEN, i32 %v548, i32 %v545, ptr %NEXT_PC)
  store ptr %v550, ptr %MEMORY, align 4
  %v551 = load ptr, ptr %MEMORY, align 4
  %v552 = call ptr @__remill_atomic_end(ptr %v551)
  store ptr %v552, ptr %MEMORY, align 4
  br i1 true, label %bb_4199139, label %bb_4199106

bb_4199106:                                       ; preds = %bb_4199097
  store i32 %v545, ptr %PC, align 4
  %v553 = add i32 %v545, 5
  store i32 %v553, ptr %NEXT_PC, align 4
  %v554 = load ptr, ptr %MEMORY, align 4
  %v555 = call ptr @__remill_atomic_begin(ptr %v554)
  store ptr %v555, ptr %MEMORY, align 4
  %v556 = load i32, ptr %DSBASE, align 4
  %v557 = add i32 4235356, %v556
  %v558 = load ptr, ptr %MEMORY, align 4
  %v559 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v558, ptr %state, ptr %EAX, i32 %v557)
  store ptr %v559, ptr %MEMORY, align 4
  %v560 = load ptr, ptr %MEMORY, align 4
  %v561 = call ptr @__remill_atomic_end(ptr %v560)
  store ptr %v561, ptr %MEMORY, align 4
  store i32 %v553, ptr %PC, align 4
  %v562 = add i32 %v553, 8
  store i32 %v562, ptr %NEXT_PC, align 4
  %v563 = load ptr, ptr %MEMORY, align 4
  %v564 = call ptr @__remill_atomic_begin(ptr %v563)
  store ptr %v564, ptr %MEMORY, align 4
  %v565 = load i32, ptr %ESP, align 4
  %v566 = load i32, ptr %SSBASE, align 4
  %v567 = add i32 %v565, 8
  %v568 = add i32 %v567, %v566
  %v569 = load ptr, ptr %MEMORY, align 4
  %v570 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v569, ptr %state, i32 %v568, i32 0)
  store ptr %v570, ptr %MEMORY, align 4
  %v571 = load ptr, ptr %MEMORY, align 4
  %v572 = call ptr @__remill_atomic_end(ptr %v571)
  store ptr %v572, ptr %MEMORY, align 4
  store i32 %v562, ptr %PC, align 4
  %v573 = add i32 %v562, 8
  store i32 %v573, ptr %NEXT_PC, align 4
  %v574 = load ptr, ptr %MEMORY, align 4
  %v575 = call ptr @__remill_atomic_begin(ptr %v574)
  store ptr %v575, ptr %MEMORY, align 4
  %v576 = load i32, ptr %ESP, align 4
  %v577 = load i32, ptr %SSBASE, align 4
  %v578 = add i32 %v576, 4
  %v579 = add i32 %v578, %v577
  %v580 = load ptr, ptr %MEMORY, align 4
  %v581 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v580, ptr %state, i32 %v579, i32 2)
  store ptr %v581, ptr %MEMORY, align 4
  %v582 = load ptr, ptr %MEMORY, align 4
  %v583 = call ptr @__remill_atomic_end(ptr %v582)
  store ptr %v583, ptr %MEMORY, align 4
  store i32 %v573, ptr %PC, align 4
  %v584 = add i32 %v573, 7
  store i32 %v584, ptr %NEXT_PC, align 4
  %v585 = load ptr, ptr %MEMORY, align 4
  %v586 = call ptr @__remill_atomic_begin(ptr %v585)
  store ptr %v586, ptr %MEMORY, align 4
  %v587 = load i32, ptr %ESP, align 4
  %v588 = load i32, ptr %SSBASE, align 4
  %v589 = add i32 %v587, %v588
  %v590 = load ptr, ptr %MEMORY, align 4
  %v591 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v590, ptr %state, i32 %v589, i32 0)
  store ptr %v591, ptr %MEMORY, align 4
  %v592 = load ptr, ptr %MEMORY, align 4
  %v593 = call ptr @__remill_atomic_end(ptr %v592)
  store ptr %v593, ptr %MEMORY, align 4
  store i32 %v584, ptr %PC, align 4
  %v594 = add i32 %v584, 2
  store i32 %v594, ptr %NEXT_PC, align 4
  %v595 = load ptr, ptr %MEMORY, align 4
  %v596 = call ptr @__remill_atomic_begin(ptr %v595)
  store ptr %v596, ptr %MEMORY, align 4
  %v597 = load i32, ptr %EAX, align 4
  %v598 = load ptr, ptr %MEMORY, align 4
  %v599 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v598, ptr %state, i32 %v597, ptr %NEXT_PC, i32 %v594, ptr %RETURN_PC)
  store ptr %v599, ptr %MEMORY, align 4
  %v600 = load ptr, ptr %MEMORY, align 4
  %v601 = call ptr @__remill_atomic_end(ptr %v600)
  store ptr %v601, ptr %MEMORY, align 4
  store i32 %v594, ptr %PC, align 4
  %v602 = add i32 %v594, 3
  store i32 %v602, ptr %NEXT_PC, align 4
  %v603 = load ptr, ptr %MEMORY, align 4
  %v604 = call ptr @__remill_atomic_begin(ptr %v603)
  store ptr %v604, ptr %MEMORY, align 4
  %v605 = load i32, ptr %ESP, align 4
  %v606 = load ptr, ptr %MEMORY, align 4
  %v607 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v606, ptr %state, ptr %ESP, i32 %v605, i32 12)
  store ptr %v607, ptr %MEMORY, align 4
  %v608 = load ptr, ptr %MEMORY, align 4
  %v609 = call ptr @__remill_atomic_end(ptr %v608)
  store ptr %v609, ptr %MEMORY, align 4
  br label %bb_4199139

bb_4199139:                                       ; preds = %bb_4199106, %bb_4199097
  %v610 = load i32, ptr %NEXT_PC, align 4
  store i32 %v610, ptr %PC, align 4
  %v611 = add i32 %v610, 5
  store i32 %v611, ptr %NEXT_PC, align 4
  %v612 = load ptr, ptr %MEMORY, align 4
  %v613 = call ptr @__remill_atomic_begin(ptr %v612)
  store ptr %v613, ptr %MEMORY, align 4
  %v614 = add i32 %v611, 4570
  %v615 = load ptr, ptr %MEMORY, align 4
  %v616 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v615, ptr %state, i64 4203714, ptr %NEXT_PC, i32 %v611, ptr %RETURN_PC)
  store ptr %v616, ptr %MEMORY, align 4
  %v617 = load ptr, ptr %MEMORY, align 4
  %v618 = call ptr @__remill_atomic_end(ptr %v617)
  store ptr %v618, ptr %MEMORY, align 4
  store i32 %v611, ptr %PC, align 4
  %v619 = add i32 %v611, 7
  store i32 %v619, ptr %NEXT_PC, align 4
  %v620 = load ptr, ptr %MEMORY, align 4
  %v621 = call ptr @__remill_atomic_begin(ptr %v620)
  store ptr %v621, ptr %MEMORY, align 4
  %v622 = load i32, ptr %ESP, align 4
  %v623 = load i32, ptr %SSBASE, align 4
  %v624 = add i32 %v622, %v623
  %v625 = load ptr, ptr %MEMORY, align 4
  %v626 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v625, ptr %state, i32 %v624, i32 4201012)
  store ptr %v626, ptr %MEMORY, align 4
  %v627 = load ptr, ptr %MEMORY, align 4
  %v628 = call ptr @__remill_atomic_end(ptr %v627)
  store ptr %v628, ptr %MEMORY, align 4
  store i32 %v619, ptr %PC, align 4
  %v629 = add i32 %v619, 5
  store i32 %v629, ptr %NEXT_PC, align 4
  %v630 = load ptr, ptr %MEMORY, align 4
  %v631 = call ptr @__remill_atomic_begin(ptr %v630)
  store ptr %v631, ptr %MEMORY, align 4
  %v632 = load i32, ptr %DSBASE, align 4
  %v633 = add i32 4243860, %v632
  %v634 = load ptr, ptr %MEMORY, align 4
  %v635 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v634, ptr %state, ptr %EAX, i32 %v633)
  store ptr %v635, ptr %MEMORY, align 4
  %v636 = load ptr, ptr %MEMORY, align 4
  %v637 = call ptr @__remill_atomic_end(ptr %v636)
  store ptr %v637, ptr %MEMORY, align 4
  store i32 %v629, ptr %PC, align 4
  %v638 = add i32 %v629, 2
  store i32 %v638, ptr %NEXT_PC, align 4
  %v639 = load ptr, ptr %MEMORY, align 4
  %v640 = call ptr @__remill_atomic_begin(ptr %v639)
  store ptr %v640, ptr %MEMORY, align 4
  %v641 = load i32, ptr %EAX, align 4
  %v642 = load ptr, ptr %MEMORY, align 4
  %v643 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v642, ptr %state, i32 %v641, ptr %NEXT_PC, i32 %v638, ptr %RETURN_PC)
  store ptr %v643, ptr %MEMORY, align 4
  %v644 = load ptr, ptr %MEMORY, align 4
  %v645 = call ptr @__remill_atomic_end(ptr %v644)
  store ptr %v645, ptr %MEMORY, align 4
  store i32 %v638, ptr %PC, align 4
  %v646 = add i32 %v638, 3
  store i32 %v646, ptr %NEXT_PC, align 4
  %v647 = load ptr, ptr %MEMORY, align 4
  %v648 = call ptr @__remill_atomic_begin(ptr %v647)
  store ptr %v648, ptr %MEMORY, align 4
  %v649 = load i32, ptr %ESP, align 4
  %v650 = load ptr, ptr %MEMORY, align 4
  %v651 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v650, ptr %state, ptr %ESP, i32 %v649, i32 4)
  store ptr %v651, ptr %MEMORY, align 4
  %v652 = load ptr, ptr %MEMORY, align 4
  %v653 = call ptr @__remill_atomic_end(ptr %v652)
  store ptr %v653, ptr %MEMORY, align 4
  store i32 %v646, ptr %PC, align 4
  %v654 = add i32 %v646, 5
  store i32 %v654, ptr %NEXT_PC, align 4
  %v655 = load ptr, ptr %MEMORY, align 4
  %v656 = call ptr @__remill_atomic_begin(ptr %v655)
  store ptr %v656, ptr %MEMORY, align 4
  %v657 = load i32, ptr %DSBASE, align 4
  %v658 = add i32 4239428, %v657
  %v659 = load i32, ptr %EAX, align 4
  %v660 = load ptr, ptr %MEMORY, align 4
  %v661 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v660, ptr %state, i32 %v658, i32 %v659)
  store ptr %v661, ptr %MEMORY, align 4
  %v662 = load ptr, ptr %MEMORY, align 4
  %v663 = call ptr @__remill_atomic_end(ptr %v662)
  store ptr %v663, ptr %MEMORY, align 4
  store i32 %v654, ptr %PC, align 4
  %v664 = add i32 %v654, 5
  store i32 %v664, ptr %NEXT_PC, align 4
  %v665 = load ptr, ptr %MEMORY, align 4
  %v666 = call ptr @__remill_atomic_begin(ptr %v665)
  store ptr %v666, ptr %MEMORY, align 4
  %v667 = add i32 %v664, 722
  %v668 = load ptr, ptr %MEMORY, align 4
  %v669 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v668, ptr %state, i64 4199893, ptr %NEXT_PC, i32 %v664, ptr %RETURN_PC)
  store ptr %v669, ptr %MEMORY, align 4
  %v670 = load ptr, ptr %MEMORY, align 4
  %v671 = call ptr @__remill_atomic_end(ptr %v670)
  store ptr %v671, ptr %MEMORY, align 4
  store i32 %v664, ptr %PC, align 4
  %v672 = add i32 %v664, 5
  store i32 %v672, ptr %NEXT_PC, align 4
  %v673 = load ptr, ptr %MEMORY, align 4
  %v674 = call ptr @__remill_atomic_begin(ptr %v673)
  store ptr %v674, ptr %MEMORY, align 4
  %v675 = add i32 %v672, 4696
  %v676 = load ptr, ptr %MEMORY, align 4
  %v677 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v676, ptr %state, i64 4203872, ptr %NEXT_PC, i32 %v672, ptr %RETURN_PC)
  store ptr %v677, ptr %MEMORY, align 4
  %v678 = load ptr, ptr %MEMORY, align 4
  %v679 = call ptr @__remill_atomic_end(ptr %v678)
  store ptr %v679, ptr %MEMORY, align 4
  store i32 %v672, ptr %PC, align 4
  %v680 = add i32 %v672, 5
  store i32 %v680, ptr %NEXT_PC, align 4
  %v681 = load ptr, ptr %MEMORY, align 4
  %v682 = call ptr @__remill_atomic_begin(ptr %v681)
  store ptr %v682, ptr %MEMORY, align 4
  %v683 = load i32, ptr %DSBASE, align 4
  %v684 = add i32 4239392, %v683
  %v685 = load ptr, ptr %MEMORY, align 4
  %v686 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v685, ptr %state, ptr %EAX, i32 %v684)
  store ptr %v686, ptr %MEMORY, align 4
  %v687 = load ptr, ptr %MEMORY, align 4
  %v688 = call ptr @__remill_atomic_end(ptr %v687)
  store ptr %v688, ptr %MEMORY, align 4
  store i32 %v680, ptr %PC, align 4
  %v689 = add i32 %v680, 2
  store i32 %v689, ptr %NEXT_PC, align 4
  %v690 = load ptr, ptr %MEMORY, align 4
  %v691 = call ptr @__remill_atomic_begin(ptr %v690)
  store ptr %v691, ptr %MEMORY, align 4
  %v692 = load i32, ptr %EAX, align 4
  %v693 = load i32, ptr %EAX, align 4
  %v694 = load ptr, ptr %MEMORY, align 4
  %v695 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v694, ptr %state, i32 %v692, i32 %v693)
  store ptr %v695, ptr %MEMORY, align 4
  %v696 = load ptr, ptr %MEMORY, align 4
  %v697 = call ptr @__remill_atomic_end(ptr %v696)
  store ptr %v697, ptr %MEMORY, align 4
  store i32 %v689, ptr %PC, align 4
  %v698 = add i32 %v689, 6
  store i32 %v698, ptr %NEXT_PC, align 4
  %v699 = load ptr, ptr %MEMORY, align 4
  %v700 = call ptr @__remill_atomic_begin(ptr %v699)
  store ptr %v700, ptr %MEMORY, align 4
  %v701 = add i32 %v698, 141
  %v702 = load ptr, ptr %MEMORY, align 4
  %v703 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v702, ptr %state, ptr %BRANCH_TAKEN, i32 %v701, i32 %v698, ptr %NEXT_PC)
  store ptr %v703, ptr %MEMORY, align 4
  %v704 = load ptr, ptr %MEMORY, align 4
  %v705 = call ptr @__remill_atomic_end(ptr %v704)
  store ptr %v705, ptr %MEMORY, align 4
  br i1 true, label %bb_4199330, label %bb_4199189

bb_4199189:                                       ; preds = %bb_4199139
  store i32 %v698, ptr %PC, align 4
  %v706 = add i32 %v698, 5
  store i32 %v706, ptr %NEXT_PC, align 4
  %v707 = load ptr, ptr %MEMORY, align 4
  %v708 = call ptr @__remill_atomic_begin(ptr %v707)
  store ptr %v708, ptr %MEMORY, align 4
  %v709 = load i32, ptr %DSBASE, align 4
  %v710 = add i32 4243924, %v709
  %v711 = load ptr, ptr %MEMORY, align 4
  %v712 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v711, ptr %state, ptr %EAX, i32 %v710)
  store ptr %v712, ptr %MEMORY, align 4
  %v713 = load ptr, ptr %MEMORY, align 4
  %v714 = call ptr @__remill_atomic_end(ptr %v713)
  store ptr %v714, ptr %MEMORY, align 4
  store i32 %v706, ptr %PC, align 4
  %v715 = add i32 %v706, 2
  store i32 %v715, ptr %NEXT_PC, align 4
  %v716 = load ptr, ptr %MEMORY, align 4
  %v717 = call ptr @__remill_atomic_begin(ptr %v716)
  store ptr %v717, ptr %MEMORY, align 4
  %v718 = load i32, ptr %EAX, align 4
  %v719 = load i32, ptr %DSBASE, align 4
  %v720 = add i32 %v718, %v719
  %v721 = load ptr, ptr %MEMORY, align 4
  %v722 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v721, ptr %state, ptr %EAX, i32 %v720)
  store ptr %v722, ptr %MEMORY, align 4
  %v723 = load ptr, ptr %MEMORY, align 4
  %v724 = call ptr @__remill_atomic_end(ptr %v723)
  store ptr %v724, ptr %MEMORY, align 4
  store i32 %v715, ptr %PC, align 4
  %v725 = add i32 %v715, 3
  store i32 %v725, ptr %NEXT_PC, align 4
  %v726 = load ptr, ptr %MEMORY, align 4
  %v727 = call ptr @__remill_atomic_begin(ptr %v726)
  store ptr %v727, ptr %MEMORY, align 4
  %v728 = load i32, ptr %EBP, align 4
  %v729 = load i32, ptr %SSBASE, align 4
  %v730 = sub i32 %v728, 12
  %v731 = add i32 %v730, %v729
  %v732 = load i32, ptr %EAX, align 4
  %v733 = load ptr, ptr %MEMORY, align 4
  %v734 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v733, ptr %state, i32 %v731, i32 %v732)
  store ptr %v734, ptr %MEMORY, align 4
  %v735 = load ptr, ptr %MEMORY, align 4
  %v736 = call ptr @__remill_atomic_end(ptr %v735)
  store ptr %v736, ptr %MEMORY, align 4
  store i32 %v725, ptr %PC, align 4
  %v737 = add i32 %v725, 2
  store i32 %v737, ptr %NEXT_PC, align 4
  %v738 = load ptr, ptr %MEMORY, align 4
  %v739 = call ptr @__remill_atomic_begin(ptr %v738)
  store ptr %v739, ptr %MEMORY, align 4
  %v740 = add i32 %v737, 27
  %v741 = load ptr, ptr %MEMORY, align 4
  %v742 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v741, ptr %state, i32 %v740, ptr %NEXT_PC)
  store ptr %v742, ptr %MEMORY, align 4
  %v743 = load ptr, ptr %MEMORY, align 4
  %v744 = call ptr @__remill_atomic_end(ptr %v743)
  store ptr %v744, ptr %MEMORY, align 4
  br label %bb_4199228

bb_4199201:                                       ; preds = %bb_4199248, %bb_4199228
  %v745 = load i32, ptr %NEXT_PC, align 4
  store i32 %v745, ptr %PC, align 4
  %v746 = add i32 %v745, 3
  store i32 %v746, ptr %NEXT_PC, align 4
  %v747 = load ptr, ptr %MEMORY, align 4
  %v748 = call ptr @__remill_atomic_begin(ptr %v747)
  store ptr %v748, ptr %MEMORY, align 4
  %v749 = load i32, ptr %EBP, align 4
  %v750 = load i32, ptr %SSBASE, align 4
  %v751 = sub i32 %v749, 12
  %v752 = add i32 %v751, %v750
  %v753 = load ptr, ptr %MEMORY, align 4
  %v754 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v753, ptr %state, ptr %EAX, i32 %v752)
  store ptr %v754, ptr %MEMORY, align 4
  %v755 = load ptr, ptr %MEMORY, align 4
  %v756 = call ptr @__remill_atomic_end(ptr %v755)
  store ptr %v756, ptr %MEMORY, align 4
  store i32 %v746, ptr %PC, align 4
  %v757 = add i32 %v746, 3
  store i32 %v757, ptr %NEXT_PC, align 4
  %v758 = load ptr, ptr %MEMORY, align 4
  %v759 = call ptr @__remill_atomic_begin(ptr %v758)
  store ptr %v759, ptr %MEMORY, align 4
  %v760 = load i32, ptr %EAX, align 4
  %v761 = load i32, ptr %DSBASE, align 4
  %v762 = add i32 %v760, %v761
  %v763 = load ptr, ptr %MEMORY, align 4
  %v764 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v763, ptr %state, ptr %EAX, i32 %v762)
  store ptr %v764, ptr %MEMORY, align 4
  %v765 = load ptr, ptr %MEMORY, align 4
  %v766 = call ptr @__remill_atomic_end(ptr %v765)
  store ptr %v766, ptr %MEMORY, align 4
  store i32 %v757, ptr %PC, align 4
  %v767 = add i32 %v757, 2
  store i32 %v767, ptr %NEXT_PC, align 4
  %v768 = load ptr, ptr %MEMORY, align 4
  %v769 = call ptr @__remill_atomic_begin(ptr %v768)
  store ptr %v769, ptr %MEMORY, align 4
  %v770 = load i8, ptr %AL, align 1
  %v771 = zext i8 %v770 to i32
  %v772 = load ptr, ptr %MEMORY, align 4
  %v773 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v772, ptr %state, i32 %v771, i32 34)
  store ptr %v773, ptr %MEMORY, align 4
  %v774 = load ptr, ptr %MEMORY, align 4
  %v775 = call ptr @__remill_atomic_end(ptr %v774)
  store ptr %v775, ptr %MEMORY, align 4
  store i32 %v767, ptr %PC, align 4
  %v776 = add i32 %v767, 2
  store i32 %v776, ptr %NEXT_PC, align 4
  %v777 = load ptr, ptr %MEMORY, align 4
  %v778 = call ptr @__remill_atomic_begin(ptr %v777)
  store ptr %v778, ptr %MEMORY, align 4
  %v779 = add i32 %v776, 13
  %v780 = load ptr, ptr %MEMORY, align 4
  %v781 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v780, ptr %state, ptr %BRANCH_TAKEN, i32 %v779, i32 %v776, ptr %NEXT_PC)
  store ptr %v781, ptr %MEMORY, align 4
  %v782 = load ptr, ptr %MEMORY, align 4
  %v783 = call ptr @__remill_atomic_end(ptr %v782)
  store ptr %v783, ptr %MEMORY, align 4
  br i1 true, label %bb_4199224, label %bb_4199211

bb_4199211:                                       ; preds = %bb_4199201
  store i32 %v776, ptr %PC, align 4
  %v784 = add i32 %v776, 4
  store i32 %v784, ptr %NEXT_PC, align 4
  %v785 = load ptr, ptr %MEMORY, align 4
  %v786 = call ptr @__remill_atomic_begin(ptr %v785)
  store ptr %v786, ptr %MEMORY, align 4
  %v787 = load i32, ptr %EBP, align 4
  %v788 = load i32, ptr %SSBASE, align 4
  %v789 = sub i32 %v787, 16
  %v790 = add i32 %v789, %v788
  %v791 = load ptr, ptr %MEMORY, align 4
  %v792 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v791, ptr %state, i32 %v790, i32 0)
  store ptr %v792, ptr %MEMORY, align 4
  %v793 = load ptr, ptr %MEMORY, align 4
  %v794 = call ptr @__remill_atomic_end(ptr %v793)
  store ptr %v794, ptr %MEMORY, align 4
  store i32 %v784, ptr %PC, align 4
  %v795 = add i32 %v784, 3
  store i32 %v795, ptr %NEXT_PC, align 4
  %v796 = load ptr, ptr %MEMORY, align 4
  %v797 = call ptr @__remill_atomic_begin(ptr %v796)
  store ptr %v797, ptr %MEMORY, align 4
  %v798 = load ptr, ptr %MEMORY, align 4
  %v799 = call ptr @_ZN12_GLOBAL__N_14SETZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v798, ptr %state, ptr %AL)
  store ptr %v799, ptr %MEMORY, align 4
  %v800 = load ptr, ptr %MEMORY, align 4
  %v801 = call ptr @__remill_atomic_end(ptr %v800)
  store ptr %v801, ptr %MEMORY, align 4
  store i32 %v795, ptr %PC, align 4
  %v802 = add i32 %v795, 3
  store i32 %v802, ptr %NEXT_PC, align 4
  %v803 = load ptr, ptr %MEMORY, align 4
  %v804 = call ptr @__remill_atomic_begin(ptr %v803)
  store ptr %v804, ptr %MEMORY, align 4
  %v805 = load i8, ptr %AL, align 1
  %v806 = zext i8 %v805 to i32
  %v807 = load ptr, ptr %MEMORY, align 4
  %v808 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v807, ptr %state, ptr %EAX, i32 %v806)
  store ptr %v808, ptr %MEMORY, align 4
  %v809 = load ptr, ptr %MEMORY, align 4
  %v810 = call ptr @__remill_atomic_end(ptr %v809)
  store ptr %v810, ptr %MEMORY, align 4
  store i32 %v802, ptr %PC, align 4
  %v811 = add i32 %v802, 3
  store i32 %v811, ptr %NEXT_PC, align 4
  %v812 = load ptr, ptr %MEMORY, align 4
  %v813 = call ptr @__remill_atomic_begin(ptr %v812)
  store ptr %v813, ptr %MEMORY, align 4
  %v814 = load i32, ptr %EBP, align 4
  %v815 = load i32, ptr %SSBASE, align 4
  %v816 = sub i32 %v814, 16
  %v817 = add i32 %v816, %v815
  %v818 = load i32, ptr %EAX, align 4
  %v819 = load ptr, ptr %MEMORY, align 4
  %v820 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v819, ptr %state, i32 %v817, i32 %v818)
  store ptr %v820, ptr %MEMORY, align 4
  %v821 = load ptr, ptr %MEMORY, align 4
  %v822 = call ptr @__remill_atomic_end(ptr %v821)
  store ptr %v822, ptr %MEMORY, align 4
  br label %bb_4199224

bb_4199224:                                       ; preds = %bb_4199211, %bb_4199201
  %v823 = load i32, ptr %NEXT_PC, align 4
  store i32 %v823, ptr %PC, align 4
  %v824 = add i32 %v823, 4
  store i32 %v824, ptr %NEXT_PC, align 4
  %v825 = load ptr, ptr %MEMORY, align 4
  %v826 = call ptr @__remill_atomic_begin(ptr %v825)
  store ptr %v826, ptr %MEMORY, align 4
  %v827 = load i32, ptr %EBP, align 4
  %v828 = load i32, ptr %SSBASE, align 4
  %v829 = sub i32 %v827, 12
  %v830 = add i32 %v829, %v828
  %v831 = load i32, ptr %EBP, align 4
  %v832 = load i32, ptr %SSBASE, align 4
  %v833 = sub i32 %v831, 12
  %v834 = add i32 %v833, %v832
  %v835 = load ptr, ptr %MEMORY, align 4
  %v836 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v835, ptr %state, i32 %v830, i32 %v834, i32 1)
  store ptr %v836, ptr %MEMORY, align 4
  %v837 = load ptr, ptr %MEMORY, align 4
  %v838 = call ptr @__remill_atomic_end(ptr %v837)
  store ptr %v838, ptr %MEMORY, align 4
  br label %bb_4199228

bb_4199228:                                       ; preds = %bb_4199224, %bb_4199189
  %v839 = load i32, ptr %NEXT_PC, align 4
  store i32 %v839, ptr %PC, align 4
  %v840 = add i32 %v839, 3
  store i32 %v840, ptr %NEXT_PC, align 4
  %v841 = load ptr, ptr %MEMORY, align 4
  %v842 = call ptr @__remill_atomic_begin(ptr %v841)
  store ptr %v842, ptr %MEMORY, align 4
  %v843 = load i32, ptr %EBP, align 4
  %v844 = load i32, ptr %SSBASE, align 4
  %v845 = sub i32 %v843, 12
  %v846 = add i32 %v845, %v844
  %v847 = load ptr, ptr %MEMORY, align 4
  %v848 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v847, ptr %state, ptr %EAX, i32 %v846)
  store ptr %v848, ptr %MEMORY, align 4
  %v849 = load ptr, ptr %MEMORY, align 4
  %v850 = call ptr @__remill_atomic_end(ptr %v849)
  store ptr %v850, ptr %MEMORY, align 4
  store i32 %v840, ptr %PC, align 4
  %v851 = add i32 %v840, 3
  store i32 %v851, ptr %NEXT_PC, align 4
  %v852 = load ptr, ptr %MEMORY, align 4
  %v853 = call ptr @__remill_atomic_begin(ptr %v852)
  store ptr %v853, ptr %MEMORY, align 4
  %v854 = load i32, ptr %EAX, align 4
  %v855 = load i32, ptr %DSBASE, align 4
  %v856 = add i32 %v854, %v855
  %v857 = load ptr, ptr %MEMORY, align 4
  %v858 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v857, ptr %state, ptr %EAX, i32 %v856)
  store ptr %v858, ptr %MEMORY, align 4
  %v859 = load ptr, ptr %MEMORY, align 4
  %v860 = call ptr @__remill_atomic_end(ptr %v859)
  store ptr %v860, ptr %MEMORY, align 4
  store i32 %v851, ptr %PC, align 4
  %v861 = add i32 %v851, 2
  store i32 %v861, ptr %NEXT_PC, align 4
  %v862 = load ptr, ptr %MEMORY, align 4
  %v863 = call ptr @__remill_atomic_begin(ptr %v862)
  store ptr %v863, ptr %MEMORY, align 4
  %v864 = load i8, ptr %AL, align 1
  %v865 = zext i8 %v864 to i32
  %v866 = load ptr, ptr %MEMORY, align 4
  %v867 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v866, ptr %state, i32 %v865, i32 32)
  store ptr %v867, ptr %MEMORY, align 4
  %v868 = load ptr, ptr %MEMORY, align 4
  %v869 = call ptr @__remill_atomic_end(ptr %v868)
  store ptr %v869, ptr %MEMORY, align 4
  store i32 %v861, ptr %PC, align 4
  %v870 = add i32 %v861, 2
  store i32 %v870, ptr %NEXT_PC, align 4
  %v871 = load ptr, ptr %MEMORY, align 4
  %v872 = call ptr @__remill_atomic_begin(ptr %v871)
  store ptr %v872, ptr %MEMORY, align 4
  %v873 = sub i32 %v870, 37
  %v874 = load ptr, ptr %MEMORY, align 4
  %v875 = call ptr @_ZN12_GLOBAL__N_14JNLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v874, ptr %state, ptr %BRANCH_TAKEN, i32 %v873, i32 %v870, ptr %NEXT_PC)
  store ptr %v875, ptr %MEMORY, align 4
  %v876 = load ptr, ptr %MEMORY, align 4
  %v877 = call ptr @__remill_atomic_end(ptr %v876)
  store ptr %v877, ptr %MEMORY, align 4
  br i1 true, label %bb_4199201, label %bb_4199238

bb_4199238:                                       ; preds = %bb_4199228
  store i32 %v870, ptr %PC, align 4
  %v878 = add i32 %v870, 3
  store i32 %v878, ptr %NEXT_PC, align 4
  %v879 = load ptr, ptr %MEMORY, align 4
  %v880 = call ptr @__remill_atomic_begin(ptr %v879)
  store ptr %v880, ptr %MEMORY, align 4
  %v881 = load i32, ptr %EBP, align 4
  %v882 = load i32, ptr %SSBASE, align 4
  %v883 = sub i32 %v881, 12
  %v884 = add i32 %v883, %v882
  %v885 = load ptr, ptr %MEMORY, align 4
  %v886 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v885, ptr %state, ptr %EAX, i32 %v884)
  store ptr %v886, ptr %MEMORY, align 4
  %v887 = load ptr, ptr %MEMORY, align 4
  %v888 = call ptr @__remill_atomic_end(ptr %v887)
  store ptr %v888, ptr %MEMORY, align 4
  store i32 %v878, ptr %PC, align 4
  %v889 = add i32 %v878, 3
  store i32 %v889, ptr %NEXT_PC, align 4
  %v890 = load ptr, ptr %MEMORY, align 4
  %v891 = call ptr @__remill_atomic_begin(ptr %v890)
  store ptr %v891, ptr %MEMORY, align 4
  %v892 = load i32, ptr %EAX, align 4
  %v893 = load i32, ptr %DSBASE, align 4
  %v894 = add i32 %v892, %v893
  %v895 = load ptr, ptr %MEMORY, align 4
  %v896 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v895, ptr %state, ptr %EAX, i32 %v894)
  store ptr %v896, ptr %MEMORY, align 4
  %v897 = load ptr, ptr %MEMORY, align 4
  %v898 = call ptr @__remill_atomic_end(ptr %v897)
  store ptr %v898, ptr %MEMORY, align 4
  store i32 %v889, ptr %PC, align 4
  %v899 = add i32 %v889, 2
  store i32 %v899, ptr %NEXT_PC, align 4
  %v900 = load ptr, ptr %MEMORY, align 4
  %v901 = call ptr @__remill_atomic_begin(ptr %v900)
  store ptr %v901, ptr %MEMORY, align 4
  %v902 = load i8, ptr %AL, align 1
  %v903 = zext i8 %v902 to i32
  %v904 = load i8, ptr %AL, align 1
  %v905 = zext i8 %v904 to i32
  %v906 = load ptr, ptr %MEMORY, align 4
  %v907 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v906, ptr %state, i32 %v903, i32 %v905)
  store ptr %v907, ptr %MEMORY, align 4
  %v908 = load ptr, ptr %MEMORY, align 4
  %v909 = call ptr @__remill_atomic_end(ptr %v908)
  store ptr %v909, ptr %MEMORY, align 4
  store i32 %v899, ptr %PC, align 4
  %v910 = add i32 %v899, 2
  store i32 %v910, ptr %NEXT_PC, align 4
  %v911 = load ptr, ptr %MEMORY, align 4
  %v912 = call ptr @__remill_atomic_begin(ptr %v911)
  store ptr %v912, ptr %MEMORY, align 4
  %v913 = add i32 %v910, 14
  %v914 = load ptr, ptr %MEMORY, align 4
  %v915 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v914, ptr %state, ptr %BRANCH_TAKEN, i32 %v913, i32 %v910, ptr %NEXT_PC)
  store ptr %v915, ptr %MEMORY, align 4
  %v916 = load ptr, ptr %MEMORY, align 4
  %v917 = call ptr @__remill_atomic_end(ptr %v916)
  store ptr %v917, ptr %MEMORY, align 4
  br i1 true, label %bb_4199262, label %bb_4199248

bb_4199248:                                       ; preds = %bb_4199238
  store i32 %v910, ptr %PC, align 4
  %v918 = add i32 %v910, 4
  store i32 %v918, ptr %NEXT_PC, align 4
  %v919 = load ptr, ptr %MEMORY, align 4
  %v920 = call ptr @__remill_atomic_begin(ptr %v919)
  store ptr %v920, ptr %MEMORY, align 4
  %v921 = load i32, ptr %EBP, align 4
  %v922 = load i32, ptr %SSBASE, align 4
  %v923 = sub i32 %v921, 16
  %v924 = add i32 %v923, %v922
  %v925 = load ptr, ptr %MEMORY, align 4
  %v926 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v925, ptr %state, i32 %v924, i32 0)
  store ptr %v926, ptr %MEMORY, align 4
  %v927 = load ptr, ptr %MEMORY, align 4
  %v928 = call ptr @__remill_atomic_end(ptr %v927)
  store ptr %v928, ptr %MEMORY, align 4
  store i32 %v918, ptr %PC, align 4
  %v929 = add i32 %v918, 2
  store i32 %v929, ptr %NEXT_PC, align 4
  %v930 = load ptr, ptr %MEMORY, align 4
  %v931 = call ptr @__remill_atomic_begin(ptr %v930)
  store ptr %v931, ptr %MEMORY, align 4
  %v932 = sub i32 %v929, 53
  %v933 = load ptr, ptr %MEMORY, align 4
  %v934 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v933, ptr %state, ptr %BRANCH_TAKEN, i32 %v932, i32 %v929, ptr %NEXT_PC)
  store ptr %v934, ptr %MEMORY, align 4
  %v935 = load ptr, ptr %MEMORY, align 4
  %v936 = call ptr @__remill_atomic_end(ptr %v935)
  store ptr %v936, ptr %MEMORY, align 4
  br i1 true, label %bb_4199201, label %bb_4199254

bb_4199254:                                       ; preds = %bb_4199248
  store i32 %v929, ptr %PC, align 4
  %v937 = add i32 %v929, 2
  store i32 %v937, ptr %NEXT_PC, align 4
  %v938 = load ptr, ptr %MEMORY, align 4
  %v939 = call ptr @__remill_atomic_begin(ptr %v938)
  store ptr %v939, ptr %MEMORY, align 4
  %v940 = add i32 %v937, 6
  %v941 = load ptr, ptr %MEMORY, align 4
  %v942 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v941, ptr %state, i32 %v940, ptr %NEXT_PC)
  store ptr %v942, ptr %MEMORY, align 4
  %v943 = load ptr, ptr %MEMORY, align 4
  %v944 = call ptr @__remill_atomic_end(ptr %v943)
  store ptr %v944, ptr %MEMORY, align 4
  br label %bb_4199262

bb_4199256:                                       ; preds = %bb_4199273
  store i32 %v1047, ptr %PC, align 4
  %v945 = add i32 %v1047, 4
  store i32 %v945, ptr %NEXT_PC, align 4
  %v946 = load ptr, ptr %MEMORY, align 4
  %v947 = call ptr @__remill_atomic_begin(ptr %v946)
  store ptr %v947, ptr %MEMORY, align 4
  %v948 = load i32, ptr %EBP, align 4
  %v949 = load i32, ptr %SSBASE, align 4
  %v950 = sub i32 %v948, 12
  %v951 = add i32 %v950, %v949
  %v952 = load i32, ptr %EBP, align 4
  %v953 = load i32, ptr %SSBASE, align 4
  %v954 = sub i32 %v952, 12
  %v955 = add i32 %v954, %v953
  %v956 = load ptr, ptr %MEMORY, align 4
  %v957 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v956, ptr %state, i32 %v951, i32 %v955, i32 1)
  store ptr %v957, ptr %MEMORY, align 4
  %v958 = load ptr, ptr %MEMORY, align 4
  %v959 = call ptr @__remill_atomic_end(ptr %v958)
  store ptr %v959, ptr %MEMORY, align 4
  store i32 %v945, ptr %PC, align 4
  %v960 = add i32 %v945, 2
  store i32 %v960, ptr %NEXT_PC, align 4
  %v961 = load ptr, ptr %MEMORY, align 4
  %v962 = call ptr @__remill_atomic_begin(ptr %v961)
  store ptr %v962, ptr %MEMORY, align 4
  %v963 = add i32 %v960, 1
  %v964 = load ptr, ptr %MEMORY, align 4
  %v965 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v964, ptr %state, i32 %v963, ptr %NEXT_PC)
  store ptr %v965, ptr %MEMORY, align 4
  %v966 = load ptr, ptr %MEMORY, align 4
  %v967 = call ptr @__remill_atomic_end(ptr %v966)
  store ptr %v967, ptr %MEMORY, align 4
  br label %bb_4199263

bb_4199262:                                       ; preds = %bb_4199254, %bb_4199238
  %v968 = load i32, ptr %NEXT_PC, align 4
  store i32 %v968, ptr %PC, align 4
  %v969 = add i32 %v968, 1
  store i32 %v969, ptr %NEXT_PC, align 4
  %v970 = load ptr, ptr %MEMORY, align 4
  %v971 = call ptr @__remill_atomic_begin(ptr %v970)
  store ptr %v971, ptr %MEMORY, align 4
  %v972 = load ptr, ptr %MEMORY, align 4
  %v973 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v972, ptr %state)
  store ptr %v973, ptr %MEMORY, align 4
  %v974 = load ptr, ptr %MEMORY, align 4
  %v975 = call ptr @__remill_atomic_end(ptr %v974)
  store ptr %v975, ptr %MEMORY, align 4
  br label %bb_4199263

bb_4199263:                                       ; preds = %bb_4199262, %bb_4199256
  %v976 = load i32, ptr %NEXT_PC, align 4
  store i32 %v976, ptr %PC, align 4
  %v977 = add i32 %v976, 3
  store i32 %v977, ptr %NEXT_PC, align 4
  %v978 = load ptr, ptr %MEMORY, align 4
  %v979 = call ptr @__remill_atomic_begin(ptr %v978)
  store ptr %v979, ptr %MEMORY, align 4
  %v980 = load i32, ptr %EBP, align 4
  %v981 = load i32, ptr %SSBASE, align 4
  %v982 = sub i32 %v980, 12
  %v983 = add i32 %v982, %v981
  %v984 = load ptr, ptr %MEMORY, align 4
  %v985 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v984, ptr %state, ptr %EAX, i32 %v983)
  store ptr %v985, ptr %MEMORY, align 4
  %v986 = load ptr, ptr %MEMORY, align 4
  %v987 = call ptr @__remill_atomic_end(ptr %v986)
  store ptr %v987, ptr %MEMORY, align 4
  store i32 %v977, ptr %PC, align 4
  %v988 = add i32 %v977, 3
  store i32 %v988, ptr %NEXT_PC, align 4
  %v989 = load ptr, ptr %MEMORY, align 4
  %v990 = call ptr @__remill_atomic_begin(ptr %v989)
  store ptr %v990, ptr %MEMORY, align 4
  %v991 = load i32, ptr %EAX, align 4
  %v992 = load i32, ptr %DSBASE, align 4
  %v993 = add i32 %v991, %v992
  %v994 = load ptr, ptr %MEMORY, align 4
  %v995 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v994, ptr %state, ptr %EAX, i32 %v993)
  store ptr %v995, ptr %MEMORY, align 4
  %v996 = load ptr, ptr %MEMORY, align 4
  %v997 = call ptr @__remill_atomic_end(ptr %v996)
  store ptr %v997, ptr %MEMORY, align 4
  store i32 %v988, ptr %PC, align 4
  %v998 = add i32 %v988, 2
  store i32 %v998, ptr %NEXT_PC, align 4
  %v999 = load ptr, ptr %MEMORY, align 4
  %v1000 = call ptr @__remill_atomic_begin(ptr %v999)
  store ptr %v1000, ptr %MEMORY, align 4
  %v1001 = load i8, ptr %AL, align 1
  %v1002 = zext i8 %v1001 to i32
  %v1003 = load i8, ptr %AL, align 1
  %v1004 = zext i8 %v1003 to i32
  %v1005 = load ptr, ptr %MEMORY, align 4
  %v1006 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1005, ptr %state, i32 %v1002, i32 %v1004)
  store ptr %v1006, ptr %MEMORY, align 4
  %v1007 = load ptr, ptr %MEMORY, align 4
  %v1008 = call ptr @__remill_atomic_end(ptr %v1007)
  store ptr %v1008, ptr %MEMORY, align 4
  store i32 %v998, ptr %PC, align 4
  %v1009 = add i32 %v998, 2
  store i32 %v1009, ptr %NEXT_PC, align 4
  %v1010 = load ptr, ptr %MEMORY, align 4
  %v1011 = call ptr @__remill_atomic_begin(ptr %v1010)
  store ptr %v1011, ptr %MEMORY, align 4
  %v1012 = add i32 %v1009, 10
  %v1013 = load ptr, ptr %MEMORY, align 4
  %v1014 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1013, ptr %state, ptr %BRANCH_TAKEN, i32 %v1012, i32 %v1009, ptr %NEXT_PC)
  store ptr %v1014, ptr %MEMORY, align 4
  %v1015 = load ptr, ptr %MEMORY, align 4
  %v1016 = call ptr @__remill_atomic_end(ptr %v1015)
  store ptr %v1016, ptr %MEMORY, align 4
  br i1 true, label %bb_4199283, label %bb_4199273

bb_4199273:                                       ; preds = %bb_4199263
  store i32 %v1009, ptr %PC, align 4
  %v1017 = add i32 %v1009, 3
  store i32 %v1017, ptr %NEXT_PC, align 4
  %v1018 = load ptr, ptr %MEMORY, align 4
  %v1019 = call ptr @__remill_atomic_begin(ptr %v1018)
  store ptr %v1019, ptr %MEMORY, align 4
  %v1020 = load i32, ptr %EBP, align 4
  %v1021 = load i32, ptr %SSBASE, align 4
  %v1022 = sub i32 %v1020, 12
  %v1023 = add i32 %v1022, %v1021
  %v1024 = load ptr, ptr %MEMORY, align 4
  %v1025 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1024, ptr %state, ptr %EAX, i32 %v1023)
  store ptr %v1025, ptr %MEMORY, align 4
  %v1026 = load ptr, ptr %MEMORY, align 4
  %v1027 = call ptr @__remill_atomic_end(ptr %v1026)
  store ptr %v1027, ptr %MEMORY, align 4
  store i32 %v1017, ptr %PC, align 4
  %v1028 = add i32 %v1017, 3
  store i32 %v1028, ptr %NEXT_PC, align 4
  %v1029 = load ptr, ptr %MEMORY, align 4
  %v1030 = call ptr @__remill_atomic_begin(ptr %v1029)
  store ptr %v1030, ptr %MEMORY, align 4
  %v1031 = load i32, ptr %EAX, align 4
  %v1032 = load i32, ptr %DSBASE, align 4
  %v1033 = add i32 %v1031, %v1032
  %v1034 = load ptr, ptr %MEMORY, align 4
  %v1035 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v1034, ptr %state, ptr %EAX, i32 %v1033)
  store ptr %v1035, ptr %MEMORY, align 4
  %v1036 = load ptr, ptr %MEMORY, align 4
  %v1037 = call ptr @__remill_atomic_end(ptr %v1036)
  store ptr %v1037, ptr %MEMORY, align 4
  store i32 %v1028, ptr %PC, align 4
  %v1038 = add i32 %v1028, 2
  store i32 %v1038, ptr %NEXT_PC, align 4
  %v1039 = load ptr, ptr %MEMORY, align 4
  %v1040 = call ptr @__remill_atomic_begin(ptr %v1039)
  store ptr %v1040, ptr %MEMORY, align 4
  %v1041 = load i8, ptr %AL, align 1
  %v1042 = zext i8 %v1041 to i32
  %v1043 = load ptr, ptr %MEMORY, align 4
  %v1044 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v1043, ptr %state, i32 %v1042, i32 32)
  store ptr %v1044, ptr %MEMORY, align 4
  %v1045 = load ptr, ptr %MEMORY, align 4
  %v1046 = call ptr @__remill_atomic_end(ptr %v1045)
  store ptr %v1046, ptr %MEMORY, align 4
  store i32 %v1038, ptr %PC, align 4
  %v1047 = add i32 %v1038, 2
  store i32 %v1047, ptr %NEXT_PC, align 4
  %v1048 = load ptr, ptr %MEMORY, align 4
  %v1049 = call ptr @__remill_atomic_begin(ptr %v1048)
  store ptr %v1049, ptr %MEMORY, align 4
  %v1050 = sub i32 %v1047, 27
  %v1051 = load ptr, ptr %MEMORY, align 4
  %v1052 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1051, ptr %state, ptr %BRANCH_TAKEN, i32 %v1050, i32 %v1047, ptr %NEXT_PC)
  store ptr %v1052, ptr %MEMORY, align 4
  %v1053 = load ptr, ptr %MEMORY, align 4
  %v1054 = call ptr @__remill_atomic_end(ptr %v1053)
  store ptr %v1054, ptr %MEMORY, align 4
  br i1 true, label %bb_4199256, label %bb_4199283

bb_4199283:                                       ; preds = %bb_4199273, %bb_4199263
  %v1055 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1055, ptr %PC, align 4
  %v1056 = add i32 %v1055, 10
  store i32 %v1056, ptr %NEXT_PC, align 4
  %v1057 = load ptr, ptr %MEMORY, align 4
  %v1058 = call ptr @__remill_atomic_begin(ptr %v1057)
  store ptr %v1058, ptr %MEMORY, align 4
  %v1059 = load i32, ptr %DSBASE, align 4
  %v1060 = add i32 4242856, %v1059
  %v1061 = load ptr, ptr %MEMORY, align 4
  %v1062 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1061, ptr %state, i32 %v1060, i32 4194304)
  store ptr %v1062, ptr %MEMORY, align 4
  %v1063 = load ptr, ptr %MEMORY, align 4
  %v1064 = call ptr @__remill_atomic_end(ptr %v1063)
  store ptr %v1064, ptr %MEMORY, align 4
  store i32 %v1056, ptr %PC, align 4
  %v1065 = add i32 %v1056, 3
  store i32 %v1065, ptr %NEXT_PC, align 4
  %v1066 = load ptr, ptr %MEMORY, align 4
  %v1067 = call ptr @__remill_atomic_begin(ptr %v1066)
  store ptr %v1067, ptr %MEMORY, align 4
  %v1068 = load i32, ptr %EBP, align 4
  %v1069 = load i32, ptr %SSBASE, align 4
  %v1070 = sub i32 %v1068, 12
  %v1071 = add i32 %v1070, %v1069
  %v1072 = load ptr, ptr %MEMORY, align 4
  %v1073 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1072, ptr %state, ptr %EAX, i32 %v1071)
  store ptr %v1073, ptr %MEMORY, align 4
  %v1074 = load ptr, ptr %MEMORY, align 4
  %v1075 = call ptr @__remill_atomic_end(ptr %v1074)
  store ptr %v1075, ptr %MEMORY, align 4
  store i32 %v1065, ptr %PC, align 4
  %v1076 = add i32 %v1065, 5
  store i32 %v1076, ptr %NEXT_PC, align 4
  %v1077 = load ptr, ptr %MEMORY, align 4
  %v1078 = call ptr @__remill_atomic_begin(ptr %v1077)
  store ptr %v1078, ptr %MEMORY, align 4
  %v1079 = load i32, ptr %DSBASE, align 4
  %v1080 = add i32 4242848, %v1079
  %v1081 = load i32, ptr %EAX, align 4
  %v1082 = load ptr, ptr %MEMORY, align 4
  %v1083 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1082, ptr %state, i32 %v1080, i32 %v1081)
  store ptr %v1083, ptr %MEMORY, align 4
  %v1084 = load ptr, ptr %MEMORY, align 4
  %v1085 = call ptr @__remill_atomic_end(ptr %v1084)
  store ptr %v1085, ptr %MEMORY, align 4
  store i32 %v1076, ptr %PC, align 4
  %v1086 = add i32 %v1076, 3
  store i32 %v1086, ptr %NEXT_PC, align 4
  %v1087 = load ptr, ptr %MEMORY, align 4
  %v1088 = call ptr @__remill_atomic_begin(ptr %v1087)
  store ptr %v1088, ptr %MEMORY, align 4
  %v1089 = load i32, ptr %EBP, align 4
  %v1090 = load i32, ptr %SSBASE, align 4
  %v1091 = sub i32 %v1089, 60
  %v1092 = add i32 %v1091, %v1090
  %v1093 = load ptr, ptr %MEMORY, align 4
  %v1094 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1093, ptr %state, ptr %EAX, i32 %v1092)
  store ptr %v1094, ptr %MEMORY, align 4
  %v1095 = load ptr, ptr %MEMORY, align 4
  %v1096 = call ptr @__remill_atomic_end(ptr %v1095)
  store ptr %v1096, ptr %MEMORY, align 4
  store i32 %v1086, ptr %PC, align 4
  %v1097 = add i32 %v1086, 3
  store i32 %v1097, ptr %NEXT_PC, align 4
  %v1098 = load ptr, ptr %MEMORY, align 4
  %v1099 = call ptr @__remill_atomic_begin(ptr %v1098)
  store ptr %v1099, ptr %MEMORY, align 4
  %v1100 = load i32, ptr %EAX, align 4
  %v1101 = load ptr, ptr %MEMORY, align 4
  %v1102 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1101, ptr %state, ptr %EAX, i32 %v1100, i32 1)
  store ptr %v1102, ptr %MEMORY, align 4
  %v1103 = load ptr, ptr %MEMORY, align 4
  %v1104 = call ptr @__remill_atomic_end(ptr %v1103)
  store ptr %v1104, ptr %MEMORY, align 4
  store i32 %v1097, ptr %PC, align 4
  %v1105 = add i32 %v1097, 2
  store i32 %v1105, ptr %NEXT_PC, align 4
  %v1106 = load ptr, ptr %MEMORY, align 4
  %v1107 = call ptr @__remill_atomic_begin(ptr %v1106)
  store ptr %v1107, ptr %MEMORY, align 4
  %v1108 = load i32, ptr %EAX, align 4
  %v1109 = load i32, ptr %EAX, align 4
  %v1110 = load ptr, ptr %MEMORY, align 4
  %v1111 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1110, ptr %state, i32 %v1108, i32 %v1109)
  store ptr %v1111, ptr %MEMORY, align 4
  %v1112 = load ptr, ptr %MEMORY, align 4
  %v1113 = call ptr @__remill_atomic_end(ptr %v1112)
  store ptr %v1113, ptr %MEMORY, align 4
  store i32 %v1105, ptr %PC, align 4
  %v1114 = add i32 %v1105, 2
  store i32 %v1114, ptr %NEXT_PC, align 4
  %v1115 = load ptr, ptr %MEMORY, align 4
  %v1116 = call ptr @__remill_atomic_begin(ptr %v1115)
  store ptr %v1116, ptr %MEMORY, align 4
  %v1117 = add i32 %v1114, 9
  %v1118 = load ptr, ptr %MEMORY, align 4
  %v1119 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1118, ptr %state, ptr %BRANCH_TAKEN, i32 %v1117, i32 %v1114, ptr %NEXT_PC)
  store ptr %v1119, ptr %MEMORY, align 4
  %v1120 = load ptr, ptr %MEMORY, align 4
  %v1121 = call ptr @__remill_atomic_end(ptr %v1120)
  store ptr %v1121, ptr %MEMORY, align 4
  br i1 true, label %bb_4199320, label %bb_4199311

bb_4199311:                                       ; preds = %bb_4199283
  store i32 %v1114, ptr %PC, align 4
  %v1122 = add i32 %v1114, 4
  store i32 %v1122, ptr %NEXT_PC, align 4
  %v1123 = load ptr, ptr %MEMORY, align 4
  %v1124 = call ptr @__remill_atomic_begin(ptr %v1123)
  store ptr %v1124, ptr %MEMORY, align 4
  %v1125 = load i32, ptr %EBP, align 4
  %v1126 = load i32, ptr %SSBASE, align 4
  %v1127 = sub i32 %v1125, 56
  %v1128 = add i32 %v1127, %v1126
  %v1129 = load ptr, ptr %MEMORY, align 4
  %v1130 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1129, ptr %state, ptr %EAX, i32 %v1128)
  store ptr %v1130, ptr %MEMORY, align 4
  %v1131 = load ptr, ptr %MEMORY, align 4
  %v1132 = call ptr @__remill_atomic_end(ptr %v1131)
  store ptr %v1132, ptr %MEMORY, align 4
  store i32 %v1122, ptr %PC, align 4
  %v1133 = add i32 %v1122, 3
  store i32 %v1133, ptr %NEXT_PC, align 4
  %v1134 = load ptr, ptr %MEMORY, align 4
  %v1135 = call ptr @__remill_atomic_begin(ptr %v1134)
  store ptr %v1135, ptr %MEMORY, align 4
  %v1136 = load i16, ptr %AX, align 2
  %v1137 = zext i16 %v1136 to i32
  %v1138 = load ptr, ptr %MEMORY, align 4
  %v1139 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1138, ptr %state, ptr %EAX, i32 %v1137)
  store ptr %v1139, ptr %MEMORY, align 4
  %v1140 = load ptr, ptr %MEMORY, align 4
  %v1141 = call ptr @__remill_atomic_end(ptr %v1140)
  store ptr %v1141, ptr %MEMORY, align 4
  store i32 %v1133, ptr %PC, align 4
  %v1142 = add i32 %v1133, 2
  store i32 %v1142, ptr %NEXT_PC, align 4
  %v1143 = load ptr, ptr %MEMORY, align 4
  %v1144 = call ptr @__remill_atomic_begin(ptr %v1143)
  store ptr %v1144, ptr %MEMORY, align 4
  %v1145 = add i32 %v1142, 5
  %v1146 = load ptr, ptr %MEMORY, align 4
  %v1147 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1146, ptr %state, i32 %v1145, ptr %NEXT_PC)
  store ptr %v1147, ptr %MEMORY, align 4
  %v1148 = load ptr, ptr %MEMORY, align 4
  %v1149 = call ptr @__remill_atomic_end(ptr %v1148)
  store ptr %v1149, ptr %MEMORY, align 4
  br label %bb_4199325

bb_4199320:                                       ; preds = %bb_4199283
  store i32 %v1114, ptr %PC, align 4
  %v1150 = add i32 %v1114, 5
  store i32 %v1150, ptr %NEXT_PC, align 4
  %v1151 = load ptr, ptr %MEMORY, align 4
  %v1152 = call ptr @__remill_atomic_begin(ptr %v1151)
  store ptr %v1152, ptr %MEMORY, align 4
  %v1153 = load ptr, ptr %MEMORY, align 4
  %v1154 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1153, ptr %state, ptr %EAX, i32 10)
  store ptr %v1154, ptr %MEMORY, align 4
  %v1155 = load ptr, ptr %MEMORY, align 4
  %v1156 = call ptr @__remill_atomic_end(ptr %v1155)
  store ptr %v1156, ptr %MEMORY, align 4
  br label %bb_4199325

bb_4199325:                                       ; preds = %bb_4199320, %bb_4199311
  %v1157 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1157, ptr %PC, align 4
  %v1158 = add i32 %v1157, 5
  store i32 %v1158, ptr %NEXT_PC, align 4
  %v1159 = load ptr, ptr %MEMORY, align 4
  %v1160 = call ptr @__remill_atomic_begin(ptr %v1159)
  store ptr %v1160, ptr %MEMORY, align 4
  %v1161 = load i32, ptr %DSBASE, align 4
  %v1162 = add i32 4242852, %v1161
  %v1163 = load i32, ptr %EAX, align 4
  %v1164 = load ptr, ptr %MEMORY, align 4
  %v1165 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1164, ptr %state, i32 %v1162, i32 %v1163)
  store ptr %v1165, ptr %MEMORY, align 4
  %v1166 = load ptr, ptr %MEMORY, align 4
  %v1167 = call ptr @__remill_atomic_end(ptr %v1166)
  store ptr %v1167, ptr %MEMORY, align 4
  br label %bb_4199330

bb_4199330:                                       ; preds = %bb_4199325, %bb_4199139
  %v1168 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1168, ptr %PC, align 4
  %v1169 = add i32 %v1168, 5
  store i32 %v1169, ptr %NEXT_PC, align 4
  %v1170 = load ptr, ptr %MEMORY, align 4
  %v1171 = call ptr @__remill_atomic_begin(ptr %v1170)
  store ptr %v1171, ptr %MEMORY, align 4
  %v1172 = load i32, ptr %DSBASE, align 4
  %v1173 = add i32 4239360, %v1172
  %v1174 = load ptr, ptr %MEMORY, align 4
  %v1175 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1174, ptr %state, ptr %EAX, i32 %v1173)
  store ptr %v1175, ptr %MEMORY, align 4
  %v1176 = load ptr, ptr %MEMORY, align 4
  %v1177 = call ptr @__remill_atomic_end(ptr %v1176)
  store ptr %v1177, ptr %MEMORY, align 4
  store i32 %v1169, ptr %PC, align 4
  %v1178 = add i32 %v1169, 8
  store i32 %v1178, ptr %NEXT_PC, align 4
  %v1179 = load ptr, ptr %MEMORY, align 4
  %v1180 = call ptr @__remill_atomic_begin(ptr %v1179)
  store ptr %v1180, ptr %MEMORY, align 4
  %v1181 = load i32, ptr %ESP, align 4
  %v1182 = load i32, ptr %SSBASE, align 4
  %v1183 = add i32 %v1181, 4
  %v1184 = add i32 %v1183, %v1182
  %v1185 = load ptr, ptr %MEMORY, align 4
  %v1186 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1185, ptr %state, i32 %v1184, i32 4239364)
  store ptr %v1186, ptr %MEMORY, align 4
  %v1187 = load ptr, ptr %MEMORY, align 4
  %v1188 = call ptr @__remill_atomic_end(ptr %v1187)
  store ptr %v1188, ptr %MEMORY, align 4
  store i32 %v1178, ptr %PC, align 4
  %v1189 = add i32 %v1178, 3
  store i32 %v1189, ptr %NEXT_PC, align 4
  %v1190 = load ptr, ptr %MEMORY, align 4
  %v1191 = call ptr @__remill_atomic_begin(ptr %v1190)
  store ptr %v1191, ptr %MEMORY, align 4
  %v1192 = load i32, ptr %ESP, align 4
  %v1193 = load i32, ptr %SSBASE, align 4
  %v1194 = add i32 %v1192, %v1193
  %v1195 = load i32, ptr %EAX, align 4
  %v1196 = load ptr, ptr %MEMORY, align 4
  %v1197 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1196, ptr %state, i32 %v1194, i32 %v1195)
  store ptr %v1197, ptr %MEMORY, align 4
  %v1198 = load ptr, ptr %MEMORY, align 4
  %v1199 = call ptr @__remill_atomic_end(ptr %v1198)
  store ptr %v1199, ptr %MEMORY, align 4
  store i32 %v1189, ptr %PC, align 4
  %v1200 = add i32 %v1189, 5
  store i32 %v1200, ptr %NEXT_PC, align 4
  %v1201 = load ptr, ptr %MEMORY, align 4
  %v1202 = call ptr @__remill_atomic_begin(ptr %v1201)
  store ptr %v1202, ptr %MEMORY, align 4
  %v1203 = add i32 %v1200, 333
  %v1204 = load ptr, ptr %MEMORY, align 4
  %v1205 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1204, ptr %state, i64 4199684, ptr %NEXT_PC, i32 %v1200, ptr %RETURN_PC)
  store ptr %v1205, ptr %MEMORY, align 4
  %v1206 = load ptr, ptr %MEMORY, align 4
  %v1207 = call ptr @__remill_atomic_end(ptr %v1206)
  store ptr %v1207, ptr %MEMORY, align 4
  store i32 %v1200, ptr %PC, align 4
  %v1208 = add i32 %v1200, 5
  store i32 %v1208, ptr %NEXT_PC, align 4
  %v1209 = load ptr, ptr %MEMORY, align 4
  %v1210 = call ptr @__remill_atomic_begin(ptr %v1209)
  store ptr %v1210, ptr %MEMORY, align 4
  %v1211 = add i32 %v1208, 4661
  %v1212 = load ptr, ptr %MEMORY, align 4
  %v1213 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1212, ptr %state, i64 4204017, ptr %NEXT_PC, i32 %v1208, ptr %RETURN_PC)
  store ptr %v1213, ptr %MEMORY, align 4
  %v1214 = load ptr, ptr %MEMORY, align 4
  %v1215 = call ptr @__remill_atomic_end(ptr %v1214)
  store ptr %v1215, ptr %MEMORY, align 4
  store i32 %v1208, ptr %PC, align 4
  %v1216 = add i32 %v1208, 5
  store i32 %v1216, ptr %NEXT_PC, align 4
  %v1217 = load ptr, ptr %MEMORY, align 4
  %v1218 = call ptr @__remill_atomic_begin(ptr %v1217)
  store ptr %v1218, ptr %MEMORY, align 4
  %v1219 = load i32, ptr %DSBASE, align 4
  %v1220 = add i32 4243904, %v1219
  %v1221 = load ptr, ptr %MEMORY, align 4
  %v1222 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1221, ptr %state, ptr %EAX, i32 %v1220)
  store ptr %v1222, ptr %MEMORY, align 4
  %v1223 = load ptr, ptr %MEMORY, align 4
  %v1224 = call ptr @__remill_atomic_end(ptr %v1223)
  store ptr %v1224, ptr %MEMORY, align 4
  store i32 %v1216, ptr %PC, align 4
  %v1225 = add i32 %v1216, 6
  store i32 %v1225, ptr %NEXT_PC, align 4
  %v1226 = load ptr, ptr %MEMORY, align 4
  %v1227 = call ptr @__remill_atomic_begin(ptr %v1226)
  store ptr %v1227, ptr %MEMORY, align 4
  %v1228 = load i32, ptr %DSBASE, align 4
  %v1229 = add i32 4239368, %v1228
  %v1230 = load ptr, ptr %MEMORY, align 4
  %v1231 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1230, ptr %state, ptr %EDX, i32 %v1229)
  store ptr %v1231, ptr %MEMORY, align 4
  %v1232 = load ptr, ptr %MEMORY, align 4
  %v1233 = call ptr @__remill_atomic_end(ptr %v1232)
  store ptr %v1233, ptr %MEMORY, align 4
  store i32 %v1225, ptr %PC, align 4
  %v1234 = add i32 %v1225, 2
  store i32 %v1234, ptr %NEXT_PC, align 4
  %v1235 = load ptr, ptr %MEMORY, align 4
  %v1236 = call ptr @__remill_atomic_begin(ptr %v1235)
  store ptr %v1236, ptr %MEMORY, align 4
  %v1237 = load i32, ptr %EAX, align 4
  %v1238 = load i32, ptr %DSBASE, align 4
  %v1239 = add i32 %v1237, %v1238
  %v1240 = load i32, ptr %EDX, align 4
  %v1241 = load ptr, ptr %MEMORY, align 4
  %v1242 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1241, ptr %state, i32 %v1239, i32 %v1240)
  store ptr %v1242, ptr %MEMORY, align 4
  %v1243 = load ptr, ptr %MEMORY, align 4
  %v1244 = call ptr @__remill_atomic_end(ptr %v1243)
  store ptr %v1244, ptr %MEMORY, align 4
  store i32 %v1234, ptr %PC, align 4
  %v1245 = add i32 %v1234, 6
  store i32 %v1245, ptr %NEXT_PC, align 4
  %v1246 = load ptr, ptr %MEMORY, align 4
  %v1247 = call ptr @__remill_atomic_begin(ptr %v1246)
  store ptr %v1247, ptr %MEMORY, align 4
  %v1248 = load i32, ptr %DSBASE, align 4
  %v1249 = add i32 4239368, %v1248
  %v1250 = load ptr, ptr %MEMORY, align 4
  %v1251 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1250, ptr %state, ptr %ECX, i32 %v1249)
  store ptr %v1251, ptr %MEMORY, align 4
  %v1252 = load ptr, ptr %MEMORY, align 4
  %v1253 = call ptr @__remill_atomic_end(ptr %v1252)
  store ptr %v1253, ptr %MEMORY, align 4
  store i32 %v1245, ptr %PC, align 4
  %v1254 = add i32 %v1245, 6
  store i32 %v1254, ptr %NEXT_PC, align 4
  %v1255 = load ptr, ptr %MEMORY, align 4
  %v1256 = call ptr @__remill_atomic_begin(ptr %v1255)
  store ptr %v1256, ptr %MEMORY, align 4
  %v1257 = load i32, ptr %DSBASE, align 4
  %v1258 = add i32 4239364, %v1257
  %v1259 = load ptr, ptr %MEMORY, align 4
  %v1260 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1259, ptr %state, ptr %EDX, i32 %v1258)
  store ptr %v1260, ptr %MEMORY, align 4
  %v1261 = load ptr, ptr %MEMORY, align 4
  %v1262 = call ptr @__remill_atomic_end(ptr %v1261)
  store ptr %v1262, ptr %MEMORY, align 4
  store i32 %v1254, ptr %PC, align 4
  %v1263 = add i32 %v1254, 5
  store i32 %v1263, ptr %NEXT_PC, align 4
  %v1264 = load ptr, ptr %MEMORY, align 4
  %v1265 = call ptr @__remill_atomic_begin(ptr %v1264)
  store ptr %v1265, ptr %MEMORY, align 4
  %v1266 = load i32, ptr %DSBASE, align 4
  %v1267 = add i32 4239360, %v1266
  %v1268 = load ptr, ptr %MEMORY, align 4
  %v1269 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1268, ptr %state, ptr %EAX, i32 %v1267)
  store ptr %v1269, ptr %MEMORY, align 4
  %v1270 = load ptr, ptr %MEMORY, align 4
  %v1271 = call ptr @__remill_atomic_end(ptr %v1270)
  store ptr %v1271, ptr %MEMORY, align 4
  store i32 %v1263, ptr %PC, align 4
  %v1272 = add i32 %v1263, 4
  store i32 %v1272, ptr %NEXT_PC, align 4
  %v1273 = load ptr, ptr %MEMORY, align 4
  %v1274 = call ptr @__remill_atomic_begin(ptr %v1273)
  store ptr %v1274, ptr %MEMORY, align 4
  %v1275 = load i32, ptr %ESP, align 4
  %v1276 = load i32, ptr %SSBASE, align 4
  %v1277 = add i32 %v1275, 8
  %v1278 = add i32 %v1277, %v1276
  %v1279 = load i32, ptr %ECX, align 4
  %v1280 = load ptr, ptr %MEMORY, align 4
  %v1281 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1280, ptr %state, i32 %v1278, i32 %v1279)
  store ptr %v1281, ptr %MEMORY, align 4
  %v1282 = load ptr, ptr %MEMORY, align 4
  %v1283 = call ptr @__remill_atomic_end(ptr %v1282)
  store ptr %v1283, ptr %MEMORY, align 4
  store i32 %v1272, ptr %PC, align 4
  %v1284 = add i32 %v1272, 4
  store i32 %v1284, ptr %NEXT_PC, align 4
  %v1285 = load ptr, ptr %MEMORY, align 4
  %v1286 = call ptr @__remill_atomic_begin(ptr %v1285)
  store ptr %v1286, ptr %MEMORY, align 4
  %v1287 = load i32, ptr %ESP, align 4
  %v1288 = load i32, ptr %SSBASE, align 4
  %v1289 = add i32 %v1287, 4
  %v1290 = add i32 %v1289, %v1288
  %v1291 = load i32, ptr %EDX, align 4
  %v1292 = load ptr, ptr %MEMORY, align 4
  %v1293 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1292, ptr %state, i32 %v1290, i32 %v1291)
  store ptr %v1293, ptr %MEMORY, align 4
  %v1294 = load ptr, ptr %MEMORY, align 4
  %v1295 = call ptr @__remill_atomic_end(ptr %v1294)
  store ptr %v1295, ptr %MEMORY, align 4
  store i32 %v1284, ptr %PC, align 4
  %v1296 = add i32 %v1284, 3
  store i32 %v1296, ptr %NEXT_PC, align 4
  %v1297 = load ptr, ptr %MEMORY, align 4
  %v1298 = call ptr @__remill_atomic_begin(ptr %v1297)
  store ptr %v1298, ptr %MEMORY, align 4
  %v1299 = load i32, ptr %ESP, align 4
  %v1300 = load i32, ptr %SSBASE, align 4
  %v1301 = add i32 %v1299, %v1300
  %v1302 = load i32, ptr %EAX, align 4
  %v1303 = load ptr, ptr %MEMORY, align 4
  %v1304 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1303, ptr %state, i32 %v1301, i32 %v1302)
  store ptr %v1304, ptr %MEMORY, align 4
  %v1305 = load ptr, ptr %MEMORY, align 4
  %v1306 = call ptr @__remill_atomic_end(ptr %v1305)
  store ptr %v1306, ptr %MEMORY, align 4
  store i32 %v1296, ptr %PC, align 4
  %v1307 = add i32 %v1296, 5
  store i32 %v1307, ptr %NEXT_PC, align 4
  %v1308 = load ptr, ptr %MEMORY, align 4
  %v1309 = call ptr @__remill_atomic_begin(ptr %v1308)
  store ptr %v1309, ptr %MEMORY, align 4
  %v1310 = add i32 %v1307, 566
  %v1311 = load ptr, ptr %MEMORY, align 4
  %v1312 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1311, ptr %state, i64 4199968, ptr %NEXT_PC, i32 %v1307, ptr %RETURN_PC)
  store ptr %v1312, ptr %MEMORY, align 4
  %v1313 = load ptr, ptr %MEMORY, align 4
  %v1314 = call ptr @__remill_atomic_end(ptr %v1313)
  store ptr %v1314, ptr %MEMORY, align 4
  store i32 %v1307, ptr %PC, align 4
  %v1315 = add i32 %v1307, 5
  store i32 %v1315, ptr %NEXT_PC, align 4
  %v1316 = load ptr, ptr %MEMORY, align 4
  %v1317 = call ptr @__remill_atomic_begin(ptr %v1316)
  store ptr %v1317, ptr %MEMORY, align 4
  %v1318 = load i32, ptr %DSBASE, align 4
  %v1319 = add i32 4239376, %v1318
  %v1320 = load i32, ptr %EAX, align 4
  %v1321 = load ptr, ptr %MEMORY, align 4
  %v1322 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1321, ptr %state, i32 %v1319, i32 %v1320)
  store ptr %v1322, ptr %MEMORY, align 4
  %v1323 = load ptr, ptr %MEMORY, align 4
  %v1324 = call ptr @__remill_atomic_end(ptr %v1323)
  store ptr %v1324, ptr %MEMORY, align 4
  store i32 %v1315, ptr %PC, align 4
  %v1325 = add i32 %v1315, 5
  store i32 %v1325, ptr %NEXT_PC, align 4
  %v1326 = load ptr, ptr %MEMORY, align 4
  %v1327 = call ptr @__remill_atomic_begin(ptr %v1326)
  store ptr %v1327, ptr %MEMORY, align 4
  %v1328 = load i32, ptr %DSBASE, align 4
  %v1329 = add i32 4239380, %v1328
  %v1330 = load ptr, ptr %MEMORY, align 4
  %v1331 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1330, ptr %state, ptr %EAX, i32 %v1329)
  store ptr %v1331, ptr %MEMORY, align 4
  %v1332 = load ptr, ptr %MEMORY, align 4
  %v1333 = call ptr @__remill_atomic_end(ptr %v1332)
  store ptr %v1333, ptr %MEMORY, align 4
  store i32 %v1325, ptr %PC, align 4
  %v1334 = add i32 %v1325, 2
  store i32 %v1334, ptr %NEXT_PC, align 4
  %v1335 = load ptr, ptr %MEMORY, align 4
  %v1336 = call ptr @__remill_atomic_begin(ptr %v1335)
  store ptr %v1336, ptr %MEMORY, align 4
  %v1337 = load i32, ptr %EAX, align 4
  %v1338 = load i32, ptr %EAX, align 4
  %v1339 = load ptr, ptr %MEMORY, align 4
  %v1340 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1339, ptr %state, i32 %v1337, i32 %v1338)
  store ptr %v1340, ptr %MEMORY, align 4
  %v1341 = load ptr, ptr %MEMORY, align 4
  %v1342 = call ptr @__remill_atomic_end(ptr %v1341)
  store ptr %v1342, ptr %MEMORY, align 4
  store i32 %v1334, ptr %PC, align 4
  %v1343 = add i32 %v1334, 2
  store i32 %v1343, ptr %NEXT_PC, align 4
  %v1344 = load ptr, ptr %MEMORY, align 4
  %v1345 = call ptr @__remill_atomic_begin(ptr %v1344)
  store ptr %v1345, ptr %MEMORY, align 4
  %v1346 = add i32 %v1343, 13
  %v1347 = load ptr, ptr %MEMORY, align 4
  %v1348 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1347, ptr %state, ptr %BRANCH_TAKEN, i32 %v1346, i32 %v1343, ptr %NEXT_PC)
  store ptr %v1348, ptr %MEMORY, align 4
  %v1349 = load ptr, ptr %MEMORY, align 4
  %v1350 = call ptr @__remill_atomic_end(ptr %v1349)
  store ptr %v1350, ptr %MEMORY, align 4
  br i1 true, label %bb_4199429, label %bb_4199416

bb_4199416:                                       ; preds = %bb_4199330
  store i32 %v1343, ptr %PC, align 4
  %v1351 = add i32 %v1343, 5
  store i32 %v1351, ptr %NEXT_PC, align 4
  %v1352 = load ptr, ptr %MEMORY, align 4
  %v1353 = call ptr @__remill_atomic_begin(ptr %v1352)
  store ptr %v1353, ptr %MEMORY, align 4
  %v1354 = load i32, ptr %DSBASE, align 4
  %v1355 = add i32 4239376, %v1354
  %v1356 = load ptr, ptr %MEMORY, align 4
  %v1357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1356, ptr %state, ptr %EAX, i32 %v1355)
  store ptr %v1357, ptr %MEMORY, align 4
  %v1358 = load ptr, ptr %MEMORY, align 4
  %v1359 = call ptr @__remill_atomic_end(ptr %v1358)
  store ptr %v1359, ptr %MEMORY, align 4
  store i32 %v1351, ptr %PC, align 4
  %v1360 = add i32 %v1351, 3
  store i32 %v1360, ptr %NEXT_PC, align 4
  %v1361 = load ptr, ptr %MEMORY, align 4
  %v1362 = call ptr @__remill_atomic_begin(ptr %v1361)
  store ptr %v1362, ptr %MEMORY, align 4
  %v1363 = load i32, ptr %ESP, align 4
  %v1364 = load i32, ptr %SSBASE, align 4
  %v1365 = add i32 %v1363, %v1364
  %v1366 = load i32, ptr %EAX, align 4
  %v1367 = load ptr, ptr %MEMORY, align 4
  %v1368 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1367, ptr %state, i32 %v1365, i32 %v1366)
  store ptr %v1368, ptr %MEMORY, align 4
  %v1369 = load ptr, ptr %MEMORY, align 4
  %v1370 = call ptr @__remill_atomic_end(ptr %v1369)
  store ptr %v1370, ptr %MEMORY, align 4
  store i32 %v1360, ptr %PC, align 4
  %v1371 = add i32 %v1360, 5
  store i32 %v1371, ptr %NEXT_PC, align 4
  %v1372 = load ptr, ptr %MEMORY, align 4
  %v1373 = call ptr @__remill_atomic_begin(ptr %v1372)
  store ptr %v1373, ptr %MEMORY, align 4
  %v1374 = add i32 %v1371, 29119
  %v1375 = load ptr, ptr %MEMORY, align 4
  %v1376 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1375, ptr %state, i64 4228548, ptr %NEXT_PC, i32 %v1371, ptr %RETURN_PC)
  store ptr %v1376, ptr %MEMORY, align 4
  %v1377 = load ptr, ptr %MEMORY, align 4
  %v1378 = call ptr @__remill_atomic_end(ptr %v1377)
  store ptr %v1378, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199429:                                       ; preds = %bb_4199330
  store i32 %v1343, ptr %PC, align 4
  %v1379 = add i32 %v1343, 5
  store i32 %v1379, ptr %NEXT_PC, align 4
  %v1380 = load ptr, ptr %MEMORY, align 4
  %v1381 = call ptr @__remill_atomic_begin(ptr %v1380)
  store ptr %v1381, ptr %MEMORY, align 4
  %v1382 = load i32, ptr %DSBASE, align 4
  %v1383 = add i32 4239384, %v1382
  %v1384 = load ptr, ptr %MEMORY, align 4
  %v1385 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1384, ptr %state, ptr %EAX, i32 %v1383)
  store ptr %v1385, ptr %MEMORY, align 4
  %v1386 = load ptr, ptr %MEMORY, align 4
  %v1387 = call ptr @__remill_atomic_end(ptr %v1386)
  store ptr %v1387, ptr %MEMORY, align 4
  store i32 %v1379, ptr %PC, align 4
  %v1388 = add i32 %v1379, 2
  store i32 %v1388, ptr %NEXT_PC, align 4
  %v1389 = load ptr, ptr %MEMORY, align 4
  %v1390 = call ptr @__remill_atomic_begin(ptr %v1389)
  store ptr %v1390, ptr %MEMORY, align 4
  %v1391 = load i32, ptr %EAX, align 4
  %v1392 = load i32, ptr %EAX, align 4
  %v1393 = load ptr, ptr %MEMORY, align 4
  %v1394 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1393, ptr %state, i32 %v1391, i32 %v1392)
  store ptr %v1394, ptr %MEMORY, align 4
  %v1395 = load ptr, ptr %MEMORY, align 4
  %v1396 = call ptr @__remill_atomic_end(ptr %v1395)
  store ptr %v1396, ptr %MEMORY, align 4
  store i32 %v1388, ptr %PC, align 4
  %v1397 = add i32 %v1388, 2
  store i32 %v1397, ptr %NEXT_PC, align 4
  %v1398 = load ptr, ptr %MEMORY, align 4
  %v1399 = call ptr @__remill_atomic_begin(ptr %v1398)
  store ptr %v1399, ptr %MEMORY, align 4
  %v1400 = add i32 %v1397, 5
  %v1401 = load ptr, ptr %MEMORY, align 4
  %v1402 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1401, ptr %state, ptr %BRANCH_TAKEN, i32 %v1400, i32 %v1397, ptr %NEXT_PC)
  store ptr %v1402, ptr %MEMORY, align 4
  %v1403 = load ptr, ptr %MEMORY, align 4
  %v1404 = call ptr @__remill_atomic_end(ptr %v1403)
  store ptr %v1404, ptr %MEMORY, align 4
  br i1 true, label %bb_4199443, label %bb_4199438

bb_4199438:                                       ; preds = %bb_4199429
  store i32 %v1397, ptr %PC, align 4
  %v1405 = add i32 %v1397, 5
  store i32 %v1405, ptr %NEXT_PC, align 4
  %v1406 = load ptr, ptr %MEMORY, align 4
  %v1407 = call ptr @__remill_atomic_begin(ptr %v1406)
  store ptr %v1407, ptr %MEMORY, align 4
  %v1408 = add i32 %v1405, 29113
  %v1409 = load ptr, ptr %MEMORY, align 4
  %v1410 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1409, ptr %state, i64 4228556, ptr %NEXT_PC, i32 %v1405, ptr %RETURN_PC)
  store ptr %v1410, ptr %MEMORY, align 4
  %v1411 = load ptr, ptr %MEMORY, align 4
  %v1412 = call ptr @__remill_atomic_end(ptr %v1411)
  store ptr %v1412, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199443:                                       ; preds = %bb_4199429
  store i32 %v1397, ptr %PC, align 4
  %v1413 = add i32 %v1397, 5
  store i32 %v1413, ptr %NEXT_PC, align 4
  %v1414 = load ptr, ptr %MEMORY, align 4
  %v1415 = call ptr @__remill_atomic_begin(ptr %v1414)
  store ptr %v1415, ptr %MEMORY, align 4
  %v1416 = load i32, ptr %DSBASE, align 4
  %v1417 = add i32 4239376, %v1416
  %v1418 = load ptr, ptr %MEMORY, align 4
  %v1419 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1418, ptr %state, ptr %EAX, i32 %v1417)
  store ptr %v1419, ptr %MEMORY, align 4
  %v1420 = load ptr, ptr %MEMORY, align 4
  %v1421 = call ptr @__remill_atomic_end(ptr %v1420)
  store ptr %v1421, ptr %MEMORY, align 4
  store i32 %v1413, ptr %PC, align 4
  %v1422 = add i32 %v1413, 3
  store i32 %v1422, ptr %NEXT_PC, align 4
  %v1423 = load ptr, ptr %MEMORY, align 4
  %v1424 = call ptr @__remill_atomic_begin(ptr %v1423)
  store ptr %v1424, ptr %MEMORY, align 4
  %v1425 = load i32, ptr %EBP, align 4
  %v1426 = load i32, ptr %SSBASE, align 4
  %v1427 = sub i32 %v1425, 4
  %v1428 = add i32 %v1427, %v1426
  %v1429 = load ptr, ptr %MEMORY, align 4
  %v1430 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1429, ptr %state, ptr %EBX, i32 %v1428)
  store ptr %v1430, ptr %MEMORY, align 4
  %v1431 = load ptr, ptr %MEMORY, align 4
  %v1432 = call ptr @__remill_atomic_end(ptr %v1431)
  store ptr %v1432, ptr %MEMORY, align 4
  store i32 %v1422, ptr %PC, align 4
  %v1433 = add i32 %v1422, 1
  store i32 %v1433, ptr %NEXT_PC, align 4
  %v1434 = load ptr, ptr %MEMORY, align 4
  %v1435 = call ptr @__remill_atomic_begin(ptr %v1434)
  store ptr %v1435, ptr %MEMORY, align 4
  %v1436 = load ptr, ptr %MEMORY, align 4
  %v1437 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1436, ptr %state)
  store ptr %v1437, ptr %MEMORY, align 4
  %v1438 = load ptr, ptr %MEMORY, align 4
  %v1439 = call ptr @__remill_atomic_end(ptr %v1438)
  store ptr %v1439, ptr %MEMORY, align 4
  store i32 %v1433, ptr %PC, align 4
  %v1440 = add i32 %v1433, 1
  store i32 %v1440, ptr %NEXT_PC, align 4
  %v1441 = load ptr, ptr %MEMORY, align 4
  %v1442 = call ptr @__remill_atomic_begin(ptr %v1441)
  store ptr %v1442, ptr %MEMORY, align 4
  %v1443 = load ptr, ptr %MEMORY, align 4
  %v1444 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1443, ptr %state, ptr %NEXT_PC)
  store ptr %v1444, ptr %MEMORY, align 4
  %v1445 = load ptr, ptr %MEMORY, align 4
  %v1446 = call ptr @__remill_atomic_end(ptr %v1445)
  store ptr %v1446, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199453:                                       ; No predecessors!
  %v1447 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1447, ptr %PC, align 4
  %v1448 = add i32 %v1447, 1
  store i32 %v1448, ptr %NEXT_PC, align 4
  %v1449 = load ptr, ptr %MEMORY, align 4
  %v1450 = call ptr @__remill_atomic_begin(ptr %v1449)
  store ptr %v1450, ptr %MEMORY, align 4
  %v1451 = load i32, ptr %EBP, align 4
  %v1452 = load ptr, ptr %MEMORY, align 4
  %v1453 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1452, ptr %state, i32 %v1451)
  store ptr %v1453, ptr %MEMORY, align 4
  %v1454 = load ptr, ptr %MEMORY, align 4
  %v1455 = call ptr @__remill_atomic_end(ptr %v1454)
  store ptr %v1455, ptr %MEMORY, align 4
  store i32 %v1448, ptr %PC, align 4
  %v1456 = add i32 %v1448, 2
  store i32 %v1456, ptr %NEXT_PC, align 4
  %v1457 = load ptr, ptr %MEMORY, align 4
  %v1458 = call ptr @__remill_atomic_begin(ptr %v1457)
  store ptr %v1458, ptr %MEMORY, align 4
  %v1459 = load i32, ptr %ESP, align 4
  %v1460 = load ptr, ptr %MEMORY, align 4
  %v1461 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1460, ptr %state, ptr %EBP, i32 %v1459)
  store ptr %v1461, ptr %MEMORY, align 4
  %v1462 = load ptr, ptr %MEMORY, align 4
  %v1463 = call ptr @__remill_atomic_end(ptr %v1462)
  store ptr %v1463, ptr %MEMORY, align 4
  store i32 %v1456, ptr %PC, align 4
  %v1464 = add i32 %v1456, 3
  store i32 %v1464, ptr %NEXT_PC, align 4
  %v1465 = load ptr, ptr %MEMORY, align 4
  %v1466 = call ptr @__remill_atomic_begin(ptr %v1465)
  store ptr %v1466, ptr %MEMORY, align 4
  %v1467 = load i32, ptr %ESP, align 4
  %v1468 = load ptr, ptr %MEMORY, align 4
  %v1469 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1468, ptr %state, ptr %ESP, i32 %v1467, i32 16)
  store ptr %v1469, ptr %MEMORY, align 4
  %v1470 = load ptr, ptr %MEMORY, align 4
  %v1471 = call ptr @__remill_atomic_end(ptr %v1470)
  store ptr %v1471, ptr %MEMORY, align 4
  store i32 %v1464, ptr %PC, align 4
  %v1472 = add i32 %v1464, 10
  store i32 %v1472, ptr %NEXT_PC, align 4
  %v1473 = load ptr, ptr %MEMORY, align 4
  %v1474 = call ptr @__remill_atomic_begin(ptr %v1473)
  store ptr %v1474, ptr %MEMORY, align 4
  %v1475 = load i32, ptr %DSBASE, align 4
  %v1476 = add i32 4239412, %v1475
  %v1477 = load ptr, ptr %MEMORY, align 4
  %v1478 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1477, ptr %state, i32 %v1476, i32 1)
  store ptr %v1478, ptr %MEMORY, align 4
  %v1479 = load ptr, ptr %MEMORY, align 4
  %v1480 = call ptr @__remill_atomic_end(ptr %v1479)
  store ptr %v1480, ptr %MEMORY, align 4
  store i32 %v1472, ptr %PC, align 4
  %v1481 = add i32 %v1472, 10
  store i32 %v1481, ptr %NEXT_PC, align 4
  %v1482 = load ptr, ptr %MEMORY, align 4
  %v1483 = call ptr @__remill_atomic_begin(ptr %v1482)
  store ptr %v1483, ptr %MEMORY, align 4
  %v1484 = load i32, ptr %DSBASE, align 4
  %v1485 = add i32 4239416, %v1484
  %v1486 = load ptr, ptr %MEMORY, align 4
  %v1487 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1486, ptr %state, i32 %v1485, i32 1)
  store ptr %v1487, ptr %MEMORY, align 4
  %v1488 = load ptr, ptr %MEMORY, align 4
  %v1489 = call ptr @__remill_atomic_end(ptr %v1488)
  store ptr %v1489, ptr %MEMORY, align 4
  store i32 %v1481, ptr %PC, align 4
  %v1490 = add i32 %v1481, 10
  store i32 %v1490, ptr %NEXT_PC, align 4
  %v1491 = load ptr, ptr %MEMORY, align 4
  %v1492 = call ptr @__remill_atomic_begin(ptr %v1491)
  store ptr %v1492, ptr %MEMORY, align 4
  %v1493 = load i32, ptr %DSBASE, align 4
  %v1494 = add i32 4239420, %v1493
  %v1495 = load ptr, ptr %MEMORY, align 4
  %v1496 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1495, ptr %state, i32 %v1494, i32 1)
  store ptr %v1496, ptr %MEMORY, align 4
  %v1497 = load ptr, ptr %MEMORY, align 4
  %v1498 = call ptr @__remill_atomic_end(ptr %v1497)
  store ptr %v1498, ptr %MEMORY, align 4
  store i32 %v1490, ptr %PC, align 4
  %v1499 = add i32 %v1490, 10
  store i32 %v1499, ptr %NEXT_PC, align 4
  %v1500 = load ptr, ptr %MEMORY, align 4
  %v1501 = call ptr @__remill_atomic_begin(ptr %v1500)
  store ptr %v1501, ptr %MEMORY, align 4
  %v1502 = load i32, ptr %DSBASE, align 4
  %v1503 = add i32 4239432, %v1502
  %v1504 = load ptr, ptr %MEMORY, align 4
  %v1505 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1504, ptr %state, i32 %v1503, i32 1)
  store ptr %v1505, ptr %MEMORY, align 4
  %v1506 = load ptr, ptr %MEMORY, align 4
  %v1507 = call ptr @__remill_atomic_end(ptr %v1506)
  store ptr %v1507, ptr %MEMORY, align 4
  store i32 %v1499, ptr %PC, align 4
  %v1508 = add i32 %v1499, 7
  store i32 %v1508, ptr %NEXT_PC, align 4
  %v1509 = load ptr, ptr %MEMORY, align 4
  %v1510 = call ptr @__remill_atomic_begin(ptr %v1509)
  store ptr %v1510, ptr %MEMORY, align 4
  %v1511 = load i32, ptr %EBP, align 4
  %v1512 = load i32, ptr %SSBASE, align 4
  %v1513 = sub i32 %v1511, 4
  %v1514 = add i32 %v1513, %v1512
  %v1515 = load ptr, ptr %MEMORY, align 4
  %v1516 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1515, ptr %state, i32 %v1514, i32 4194304)
  store ptr %v1516, ptr %MEMORY, align 4
  %v1517 = load ptr, ptr %MEMORY, align 4
  %v1518 = call ptr @__remill_atomic_end(ptr %v1517)
  store ptr %v1518, ptr %MEMORY, align 4
  store i32 %v1508, ptr %PC, align 4
  %v1519 = add i32 %v1508, 3
  store i32 %v1519, ptr %NEXT_PC, align 4
  %v1520 = load ptr, ptr %MEMORY, align 4
  %v1521 = call ptr @__remill_atomic_begin(ptr %v1520)
  store ptr %v1521, ptr %MEMORY, align 4
  %v1522 = load i32, ptr %EBP, align 4
  %v1523 = load i32, ptr %SSBASE, align 4
  %v1524 = sub i32 %v1522, 4
  %v1525 = add i32 %v1524, %v1523
  %v1526 = load ptr, ptr %MEMORY, align 4
  %v1527 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1526, ptr %state, ptr %EAX, i32 %v1525)
  store ptr %v1527, ptr %MEMORY, align 4
  %v1528 = load ptr, ptr %MEMORY, align 4
  %v1529 = call ptr @__remill_atomic_end(ptr %v1528)
  store ptr %v1529, ptr %MEMORY, align 4
  store i32 %v1519, ptr %PC, align 4
  %v1530 = add i32 %v1519, 3
  store i32 %v1530, ptr %NEXT_PC, align 4
  %v1531 = load ptr, ptr %MEMORY, align 4
  %v1532 = call ptr @__remill_atomic_begin(ptr %v1531)
  store ptr %v1532, ptr %MEMORY, align 4
  %v1533 = load i32, ptr %EAX, align 4
  %v1534 = load i32, ptr %DSBASE, align 4
  %v1535 = add i32 %v1533, %v1534
  %v1536 = load ptr, ptr %MEMORY, align 4
  %v1537 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1536, ptr %state, ptr %EAX, i32 %v1535)
  store ptr %v1537, ptr %MEMORY, align 4
  %v1538 = load ptr, ptr %MEMORY, align 4
  %v1539 = call ptr @__remill_atomic_end(ptr %v1538)
  store ptr %v1539, ptr %MEMORY, align 4
  store i32 %v1530, ptr %PC, align 4
  %v1540 = add i32 %v1530, 4
  store i32 %v1540, ptr %NEXT_PC, align 4
  %v1541 = load ptr, ptr %MEMORY, align 4
  %v1542 = call ptr @__remill_atomic_begin(ptr %v1541)
  store ptr %v1542, ptr %MEMORY, align 4
  %v1543 = load i16, ptr %AX, align 2
  %v1544 = zext i16 %v1543 to i32
  %v1545 = load ptr, ptr %MEMORY, align 4
  %v1546 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnItLb1EE2InItEEEP6MemoryS6_R5StateT_T0_(ptr %v1545, ptr %state, i32 %v1544, i32 23117)
  store ptr %v1546, ptr %MEMORY, align 4
  %v1547 = load ptr, ptr %MEMORY, align 4
  %v1548 = call ptr @__remill_atomic_end(ptr %v1547)
  store ptr %v1548, ptr %MEMORY, align 4
  store i32 %v1540, ptr %PC, align 4
  %v1549 = add i32 %v1540, 2
  store i32 %v1549, ptr %NEXT_PC, align 4
  %v1550 = load ptr, ptr %MEMORY, align 4
  %v1551 = call ptr @__remill_atomic_begin(ptr %v1550)
  store ptr %v1551, ptr %MEMORY, align 4
  %v1552 = add i32 %v1549, 10
  %v1553 = load ptr, ptr %MEMORY, align 4
  %v1554 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1553, ptr %state, ptr %BRANCH_TAKEN, i32 %v1552, i32 %v1549, ptr %NEXT_PC)
  store ptr %v1554, ptr %MEMORY, align 4
  %v1555 = load ptr, ptr %MEMORY, align 4
  %v1556 = call ptr @__remill_atomic_end(ptr %v1555)
  store ptr %v1556, ptr %MEMORY, align 4
  br i1 true, label %bb_4199528, label %bb_4199518

bb_4199518:                                       ; preds = %bb_4199453
  store i32 %v1549, ptr %PC, align 4
  %v1557 = add i32 %v1549, 5
  store i32 %v1557, ptr %NEXT_PC, align 4
  %v1558 = load ptr, ptr %MEMORY, align 4
  %v1559 = call ptr @__remill_atomic_begin(ptr %v1558)
  store ptr %v1559, ptr %MEMORY, align 4
  %v1560 = load ptr, ptr %MEMORY, align 4
  %v1561 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1560, ptr %state, ptr %EAX, i32 0)
  store ptr %v1561, ptr %MEMORY, align 4
  %v1562 = load ptr, ptr %MEMORY, align 4
  %v1563 = call ptr @__remill_atomic_end(ptr %v1562)
  store ptr %v1563, ptr %MEMORY, align 4
  store i32 %v1557, ptr %PC, align 4
  %v1564 = add i32 %v1557, 5
  store i32 %v1564, ptr %NEXT_PC, align 4
  %v1565 = load ptr, ptr %MEMORY, align 4
  %v1566 = call ptr @__remill_atomic_begin(ptr %v1565)
  store ptr %v1566, ptr %MEMORY, align 4
  %v1567 = add i32 %v1564, 154
  %v1568 = load ptr, ptr %MEMORY, align 4
  %v1569 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1568, ptr %state, i32 %v1567, ptr %NEXT_PC)
  store ptr %v1569, ptr %MEMORY, align 4
  %v1570 = load ptr, ptr %MEMORY, align 4
  %v1571 = call ptr @__remill_atomic_end(ptr %v1570)
  store ptr %v1571, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199528:                                       ; preds = %bb_4199453
  store i32 %v1549, ptr %PC, align 4
  %v1572 = add i32 %v1549, 3
  store i32 %v1572, ptr %NEXT_PC, align 4
  %v1573 = load ptr, ptr %MEMORY, align 4
  %v1574 = call ptr @__remill_atomic_begin(ptr %v1573)
  store ptr %v1574, ptr %MEMORY, align 4
  %v1575 = load i32, ptr %EBP, align 4
  %v1576 = load i32, ptr %SSBASE, align 4
  %v1577 = sub i32 %v1575, 4
  %v1578 = add i32 %v1577, %v1576
  %v1579 = load ptr, ptr %MEMORY, align 4
  %v1580 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1579, ptr %state, ptr %EAX, i32 %v1578)
  store ptr %v1580, ptr %MEMORY, align 4
  %v1581 = load ptr, ptr %MEMORY, align 4
  %v1582 = call ptr @__remill_atomic_end(ptr %v1581)
  store ptr %v1582, ptr %MEMORY, align 4
  store i32 %v1572, ptr %PC, align 4
  %v1583 = add i32 %v1572, 3
  store i32 %v1583, ptr %NEXT_PC, align 4
  %v1584 = load ptr, ptr %MEMORY, align 4
  %v1585 = call ptr @__remill_atomic_begin(ptr %v1584)
  store ptr %v1585, ptr %MEMORY, align 4
  %v1586 = load i32, ptr %EAX, align 4
  %v1587 = load i32, ptr %DSBASE, align 4
  %v1588 = add i32 %v1586, 60
  %v1589 = add i32 %v1588, %v1587
  %v1590 = load ptr, ptr %MEMORY, align 4
  %v1591 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1590, ptr %state, ptr %EAX, i32 %v1589)
  store ptr %v1591, ptr %MEMORY, align 4
  %v1592 = load ptr, ptr %MEMORY, align 4
  %v1593 = call ptr @__remill_atomic_end(ptr %v1592)
  store ptr %v1593, ptr %MEMORY, align 4
  store i32 %v1583, ptr %PC, align 4
  %v1594 = add i32 %v1583, 2
  store i32 %v1594, ptr %NEXT_PC, align 4
  %v1595 = load ptr, ptr %MEMORY, align 4
  %v1596 = call ptr @__remill_atomic_begin(ptr %v1595)
  store ptr %v1596, ptr %MEMORY, align 4
  %v1597 = load i32, ptr %EAX, align 4
  %v1598 = load ptr, ptr %MEMORY, align 4
  %v1599 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1598, ptr %state, ptr %EDX, i32 %v1597)
  store ptr %v1599, ptr %MEMORY, align 4
  %v1600 = load ptr, ptr %MEMORY, align 4
  %v1601 = call ptr @__remill_atomic_end(ptr %v1600)
  store ptr %v1601, ptr %MEMORY, align 4
  store i32 %v1594, ptr %PC, align 4
  %v1602 = add i32 %v1594, 3
  store i32 %v1602, ptr %NEXT_PC, align 4
  %v1603 = load ptr, ptr %MEMORY, align 4
  %v1604 = call ptr @__remill_atomic_begin(ptr %v1603)
  store ptr %v1604, ptr %MEMORY, align 4
  %v1605 = load i32, ptr %EBP, align 4
  %v1606 = load i32, ptr %SSBASE, align 4
  %v1607 = sub i32 %v1605, 4
  %v1608 = add i32 %v1607, %v1606
  %v1609 = load ptr, ptr %MEMORY, align 4
  %v1610 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1609, ptr %state, ptr %EAX, i32 %v1608)
  store ptr %v1610, ptr %MEMORY, align 4
  %v1611 = load ptr, ptr %MEMORY, align 4
  %v1612 = call ptr @__remill_atomic_end(ptr %v1611)
  store ptr %v1612, ptr %MEMORY, align 4
  store i32 %v1602, ptr %PC, align 4
  %v1613 = add i32 %v1602, 2
  store i32 %v1613, ptr %NEXT_PC, align 4
  %v1614 = load ptr, ptr %MEMORY, align 4
  %v1615 = call ptr @__remill_atomic_begin(ptr %v1614)
  store ptr %v1615, ptr %MEMORY, align 4
  %v1616 = load i32, ptr %EAX, align 4
  %v1617 = load i32, ptr %EDX, align 4
  %v1618 = load ptr, ptr %MEMORY, align 4
  %v1619 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1618, ptr %state, ptr %EAX, i32 %v1616, i32 %v1617)
  store ptr %v1619, ptr %MEMORY, align 4
  %v1620 = load ptr, ptr %MEMORY, align 4
  %v1621 = call ptr @__remill_atomic_end(ptr %v1620)
  store ptr %v1621, ptr %MEMORY, align 4
  store i32 %v1613, ptr %PC, align 4
  %v1622 = add i32 %v1613, 3
  store i32 %v1622, ptr %NEXT_PC, align 4
  %v1623 = load ptr, ptr %MEMORY, align 4
  %v1624 = call ptr @__remill_atomic_begin(ptr %v1623)
  store ptr %v1624, ptr %MEMORY, align 4
  %v1625 = load i32, ptr %EBP, align 4
  %v1626 = load i32, ptr %SSBASE, align 4
  %v1627 = sub i32 %v1625, 8
  %v1628 = add i32 %v1627, %v1626
  %v1629 = load i32, ptr %EAX, align 4
  %v1630 = load ptr, ptr %MEMORY, align 4
  %v1631 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1630, ptr %state, i32 %v1628, i32 %v1629)
  store ptr %v1631, ptr %MEMORY, align 4
  %v1632 = load ptr, ptr %MEMORY, align 4
  %v1633 = call ptr @__remill_atomic_end(ptr %v1632)
  store ptr %v1633, ptr %MEMORY, align 4
  store i32 %v1622, ptr %PC, align 4
  %v1634 = add i32 %v1622, 3
  store i32 %v1634, ptr %NEXT_PC, align 4
  %v1635 = load ptr, ptr %MEMORY, align 4
  %v1636 = call ptr @__remill_atomic_begin(ptr %v1635)
  store ptr %v1636, ptr %MEMORY, align 4
  %v1637 = load i32, ptr %EBP, align 4
  %v1638 = load i32, ptr %SSBASE, align 4
  %v1639 = sub i32 %v1637, 8
  %v1640 = add i32 %v1639, %v1638
  %v1641 = load ptr, ptr %MEMORY, align 4
  %v1642 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1641, ptr %state, ptr %EAX, i32 %v1640)
  store ptr %v1642, ptr %MEMORY, align 4
  %v1643 = load ptr, ptr %MEMORY, align 4
  %v1644 = call ptr @__remill_atomic_end(ptr %v1643)
  store ptr %v1644, ptr %MEMORY, align 4
  store i32 %v1634, ptr %PC, align 4
  %v1645 = add i32 %v1634, 2
  store i32 %v1645, ptr %NEXT_PC, align 4
  %v1646 = load ptr, ptr %MEMORY, align 4
  %v1647 = call ptr @__remill_atomic_begin(ptr %v1646)
  store ptr %v1647, ptr %MEMORY, align 4
  %v1648 = load i32, ptr %EAX, align 4
  %v1649 = load i32, ptr %DSBASE, align 4
  %v1650 = add i32 %v1648, %v1649
  %v1651 = load ptr, ptr %MEMORY, align 4
  %v1652 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1651, ptr %state, ptr %EAX, i32 %v1650)
  store ptr %v1652, ptr %MEMORY, align 4
  %v1653 = load ptr, ptr %MEMORY, align 4
  %v1654 = call ptr @__remill_atomic_end(ptr %v1653)
  store ptr %v1654, ptr %MEMORY, align 4
  store i32 %v1645, ptr %PC, align 4
  %v1655 = add i32 %v1645, 5
  store i32 %v1655, ptr %NEXT_PC, align 4
  %v1656 = load ptr, ptr %MEMORY, align 4
  %v1657 = call ptr @__remill_atomic_begin(ptr %v1656)
  store ptr %v1657, ptr %MEMORY, align 4
  %v1658 = load i32, ptr %EAX, align 4
  %v1659 = load ptr, ptr %MEMORY, align 4
  %v1660 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1659, ptr %state, i32 %v1658, i32 17744)
  store ptr %v1660, ptr %MEMORY, align 4
  %v1661 = load ptr, ptr %MEMORY, align 4
  %v1662 = call ptr @__remill_atomic_end(ptr %v1661)
  store ptr %v1662, ptr %MEMORY, align 4
  store i32 %v1655, ptr %PC, align 4
  %v1663 = add i32 %v1655, 2
  store i32 %v1663, ptr %NEXT_PC, align 4
  %v1664 = load ptr, ptr %MEMORY, align 4
  %v1665 = call ptr @__remill_atomic_begin(ptr %v1664)
  store ptr %v1665, ptr %MEMORY, align 4
  %v1666 = add i32 %v1663, 7
  %v1667 = load ptr, ptr %MEMORY, align 4
  %v1668 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1667, ptr %state, ptr %BRANCH_TAKEN, i32 %v1666, i32 %v1663, ptr %NEXT_PC)
  store ptr %v1668, ptr %MEMORY, align 4
  %v1669 = load ptr, ptr %MEMORY, align 4
  %v1670 = call ptr @__remill_atomic_end(ptr %v1669)
  store ptr %v1670, ptr %MEMORY, align 4
  br i1 true, label %bb_4199563, label %bb_4199556

bb_4199556:                                       ; preds = %bb_4199528
  store i32 %v1663, ptr %PC, align 4
  %v1671 = add i32 %v1663, 5
  store i32 %v1671, ptr %NEXT_PC, align 4
  %v1672 = load ptr, ptr %MEMORY, align 4
  %v1673 = call ptr @__remill_atomic_begin(ptr %v1672)
  store ptr %v1673, ptr %MEMORY, align 4
  %v1674 = load ptr, ptr %MEMORY, align 4
  %v1675 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1674, ptr %state, ptr %EAX, i32 0)
  store ptr %v1675, ptr %MEMORY, align 4
  %v1676 = load ptr, ptr %MEMORY, align 4
  %v1677 = call ptr @__remill_atomic_end(ptr %v1676)
  store ptr %v1677, ptr %MEMORY, align 4
  store i32 %v1671, ptr %PC, align 4
  %v1678 = add i32 %v1671, 2
  store i32 %v1678, ptr %NEXT_PC, align 4
  %v1679 = load ptr, ptr %MEMORY, align 4
  %v1680 = call ptr @__remill_atomic_begin(ptr %v1679)
  store ptr %v1680, ptr %MEMORY, align 4
  %v1681 = add i32 %v1678, 119
  %v1682 = load ptr, ptr %MEMORY, align 4
  %v1683 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1682, ptr %state, i32 %v1681, ptr %NEXT_PC)
  store ptr %v1683, ptr %MEMORY, align 4
  %v1684 = load ptr, ptr %MEMORY, align 4
  %v1685 = call ptr @__remill_atomic_end(ptr %v1684)
  store ptr %v1685, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199563:                                       ; preds = %bb_4199528
  store i32 %v1663, ptr %PC, align 4
  %v1686 = add i32 %v1663, 3
  store i32 %v1686, ptr %NEXT_PC, align 4
  %v1687 = load ptr, ptr %MEMORY, align 4
  %v1688 = call ptr @__remill_atomic_begin(ptr %v1687)
  store ptr %v1688, ptr %MEMORY, align 4
  %v1689 = load i32, ptr %EBP, align 4
  %v1690 = load i32, ptr %SSBASE, align 4
  %v1691 = sub i32 %v1689, 8
  %v1692 = add i32 %v1691, %v1690
  %v1693 = load ptr, ptr %MEMORY, align 4
  %v1694 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1693, ptr %state, ptr %EAX, i32 %v1692)
  store ptr %v1694, ptr %MEMORY, align 4
  %v1695 = load ptr, ptr %MEMORY, align 4
  %v1696 = call ptr @__remill_atomic_end(ptr %v1695)
  store ptr %v1696, ptr %MEMORY, align 4
  store i32 %v1686, ptr %PC, align 4
  %v1697 = add i32 %v1686, 3
  store i32 %v1697, ptr %NEXT_PC, align 4
  %v1698 = load ptr, ptr %MEMORY, align 4
  %v1699 = call ptr @__remill_atomic_begin(ptr %v1698)
  store ptr %v1699, ptr %MEMORY, align 4
  %v1700 = load i32, ptr %EAX, align 4
  %v1701 = load ptr, ptr %MEMORY, align 4
  %v1702 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1701, ptr %state, ptr %EAX, i32 %v1700, i32 24)
  store ptr %v1702, ptr %MEMORY, align 4
  %v1703 = load ptr, ptr %MEMORY, align 4
  %v1704 = call ptr @__remill_atomic_end(ptr %v1703)
  store ptr %v1704, ptr %MEMORY, align 4
  store i32 %v1697, ptr %PC, align 4
  %v1705 = add i32 %v1697, 3
  store i32 %v1705, ptr %NEXT_PC, align 4
  %v1706 = load ptr, ptr %MEMORY, align 4
  %v1707 = call ptr @__remill_atomic_begin(ptr %v1706)
  store ptr %v1707, ptr %MEMORY, align 4
  %v1708 = load i32, ptr %EBP, align 4
  %v1709 = load i32, ptr %SSBASE, align 4
  %v1710 = sub i32 %v1708, 12
  %v1711 = add i32 %v1710, %v1709
  %v1712 = load i32, ptr %EAX, align 4
  %v1713 = load ptr, ptr %MEMORY, align 4
  %v1714 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1713, ptr %state, i32 %v1711, i32 %v1712)
  store ptr %v1714, ptr %MEMORY, align 4
  %v1715 = load ptr, ptr %MEMORY, align 4
  %v1716 = call ptr @__remill_atomic_end(ptr %v1715)
  store ptr %v1716, ptr %MEMORY, align 4
  store i32 %v1705, ptr %PC, align 4
  %v1717 = add i32 %v1705, 3
  store i32 %v1717, ptr %NEXT_PC, align 4
  %v1718 = load ptr, ptr %MEMORY, align 4
  %v1719 = call ptr @__remill_atomic_begin(ptr %v1718)
  store ptr %v1719, ptr %MEMORY, align 4
  %v1720 = load i32, ptr %EBP, align 4
  %v1721 = load i32, ptr %SSBASE, align 4
  %v1722 = sub i32 %v1720, 12
  %v1723 = add i32 %v1722, %v1721
  %v1724 = load ptr, ptr %MEMORY, align 4
  %v1725 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1724, ptr %state, ptr %EAX, i32 %v1723)
  store ptr %v1725, ptr %MEMORY, align 4
  %v1726 = load ptr, ptr %MEMORY, align 4
  %v1727 = call ptr @__remill_atomic_end(ptr %v1726)
  store ptr %v1727, ptr %MEMORY, align 4
  store i32 %v1717, ptr %PC, align 4
  %v1728 = add i32 %v1717, 3
  store i32 %v1728, ptr %NEXT_PC, align 4
  %v1729 = load ptr, ptr %MEMORY, align 4
  %v1730 = call ptr @__remill_atomic_begin(ptr %v1729)
  store ptr %v1730, ptr %MEMORY, align 4
  %v1731 = load i32, ptr %EAX, align 4
  %v1732 = load i32, ptr %DSBASE, align 4
  %v1733 = add i32 %v1731, %v1732
  %v1734 = load ptr, ptr %MEMORY, align 4
  %v1735 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1734, ptr %state, ptr %EAX, i32 %v1733)
  store ptr %v1735, ptr %MEMORY, align 4
  %v1736 = load ptr, ptr %MEMORY, align 4
  %v1737 = call ptr @__remill_atomic_end(ptr %v1736)
  store ptr %v1737, ptr %MEMORY, align 4
  store i32 %v1728, ptr %PC, align 4
  %v1738 = add i32 %v1728, 3
  store i32 %v1738, ptr %NEXT_PC, align 4
  %v1739 = load ptr, ptr %MEMORY, align 4
  %v1740 = call ptr @__remill_atomic_begin(ptr %v1739)
  store ptr %v1740, ptr %MEMORY, align 4
  %v1741 = load i16, ptr %AX, align 2
  %v1742 = zext i16 %v1741 to i32
  %v1743 = load ptr, ptr %MEMORY, align 4
  %v1744 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1743, ptr %state, ptr %EAX, i32 %v1742)
  store ptr %v1744, ptr %MEMORY, align 4
  %v1745 = load ptr, ptr %MEMORY, align 4
  %v1746 = call ptr @__remill_atomic_end(ptr %v1745)
  store ptr %v1746, ptr %MEMORY, align 4
  store i32 %v1738, ptr %PC, align 4
  %v1747 = add i32 %v1738, 5
  store i32 %v1747, ptr %NEXT_PC, align 4
  %v1748 = load ptr, ptr %MEMORY, align 4
  %v1749 = call ptr @__remill_atomic_begin(ptr %v1748)
  store ptr %v1749, ptr %MEMORY, align 4
  %v1750 = load i32, ptr %EAX, align 4
  %v1751 = load ptr, ptr %MEMORY, align 4
  %v1752 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1751, ptr %state, i32 %v1750, i32 267)
  store ptr %v1752, ptr %MEMORY, align 4
  %v1753 = load ptr, ptr %MEMORY, align 4
  %v1754 = call ptr @__remill_atomic_end(ptr %v1753)
  store ptr %v1754, ptr %MEMORY, align 4
  store i32 %v1747, ptr %PC, align 4
  %v1755 = add i32 %v1747, 2
  store i32 %v1755, ptr %NEXT_PC, align 4
  %v1756 = load ptr, ptr %MEMORY, align 4
  %v1757 = call ptr @__remill_atomic_begin(ptr %v1756)
  store ptr %v1757, ptr %MEMORY, align 4
  %v1758 = add i32 %v1755, 9
  %v1759 = load ptr, ptr %MEMORY, align 4
  %v1760 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1759, ptr %state, ptr %BRANCH_TAKEN, i32 %v1758, i32 %v1755, ptr %NEXT_PC)
  store ptr %v1760, ptr %MEMORY, align 4
  %v1761 = load ptr, ptr %MEMORY, align 4
  %v1762 = call ptr @__remill_atomic_end(ptr %v1761)
  store ptr %v1762, ptr %MEMORY, align 4
  br i1 true, label %bb_4199597, label %bb_4199588

bb_4199588:                                       ; preds = %bb_4199563
  store i32 %v1755, ptr %PC, align 4
  %v1763 = add i32 %v1755, 5
  store i32 %v1763, ptr %NEXT_PC, align 4
  %v1764 = load ptr, ptr %MEMORY, align 4
  %v1765 = call ptr @__remill_atomic_begin(ptr %v1764)
  store ptr %v1765, ptr %MEMORY, align 4
  %v1766 = load i32, ptr %EAX, align 4
  %v1767 = load ptr, ptr %MEMORY, align 4
  %v1768 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1767, ptr %state, i32 %v1766, i32 523)
  store ptr %v1768, ptr %MEMORY, align 4
  %v1769 = load ptr, ptr %MEMORY, align 4
  %v1770 = call ptr @__remill_atomic_end(ptr %v1769)
  store ptr %v1770, ptr %MEMORY, align 4
  store i32 %v1763, ptr %PC, align 4
  %v1771 = add i32 %v1763, 2
  store i32 %v1771, ptr %NEXT_PC, align 4
  %v1772 = load ptr, ptr %MEMORY, align 4
  %v1773 = call ptr @__remill_atomic_begin(ptr %v1772)
  store ptr %v1773, ptr %MEMORY, align 4
  %v1774 = add i32 %v1771, 39
  %v1775 = load ptr, ptr %MEMORY, align 4
  %v1776 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1775, ptr %state, ptr %BRANCH_TAKEN, i32 %v1774, i32 %v1771, ptr %NEXT_PC)
  store ptr %v1776, ptr %MEMORY, align 4
  %v1777 = load ptr, ptr %MEMORY, align 4
  %v1778 = call ptr @__remill_atomic_end(ptr %v1777)
  store ptr %v1778, ptr %MEMORY, align 4
  br i1 true, label %bb_4199634, label %bb_4199595

bb_4199595:                                       ; preds = %bb_4199588
  store i32 %v1771, ptr %PC, align 4
  %v1779 = add i32 %v1771, 2
  store i32 %v1779, ptr %NEXT_PC, align 4
  %v1780 = load ptr, ptr %MEMORY, align 4
  %v1781 = call ptr @__remill_atomic_begin(ptr %v1780)
  store ptr %v1781, ptr %MEMORY, align 4
  %v1782 = add i32 %v1779, 80
  %v1783 = load ptr, ptr %MEMORY, align 4
  %v1784 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1783, ptr %state, i32 %v1782, ptr %NEXT_PC)
  store ptr %v1784, ptr %MEMORY, align 4
  %v1785 = load ptr, ptr %MEMORY, align 4
  %v1786 = call ptr @__remill_atomic_end(ptr %v1785)
  store ptr %v1786, ptr %MEMORY, align 4
  br label %bb_4199677

bb_4199597:                                       ; preds = %bb_4199563
  store i32 %v1755, ptr %PC, align 4
  %v1787 = add i32 %v1755, 3
  store i32 %v1787, ptr %NEXT_PC, align 4
  %v1788 = load ptr, ptr %MEMORY, align 4
  %v1789 = call ptr @__remill_atomic_begin(ptr %v1788)
  store ptr %v1789, ptr %MEMORY, align 4
  %v1790 = load i32, ptr %EBP, align 4
  %v1791 = load i32, ptr %SSBASE, align 4
  %v1792 = sub i32 %v1790, 12
  %v1793 = add i32 %v1792, %v1791
  %v1794 = load ptr, ptr %MEMORY, align 4
  %v1795 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1794, ptr %state, ptr %EAX, i32 %v1793)
  store ptr %v1795, ptr %MEMORY, align 4
  %v1796 = load ptr, ptr %MEMORY, align 4
  %v1797 = call ptr @__remill_atomic_end(ptr %v1796)
  store ptr %v1797, ptr %MEMORY, align 4
  store i32 %v1787, ptr %PC, align 4
  %v1798 = add i32 %v1787, 3
  store i32 %v1798, ptr %NEXT_PC, align 4
  %v1799 = load ptr, ptr %MEMORY, align 4
  %v1800 = call ptr @__remill_atomic_begin(ptr %v1799)
  store ptr %v1800, ptr %MEMORY, align 4
  %v1801 = load i32, ptr %EAX, align 4
  %v1802 = load i32, ptr %DSBASE, align 4
  %v1803 = add i32 %v1801, 92
  %v1804 = add i32 %v1803, %v1802
  %v1805 = load ptr, ptr %MEMORY, align 4
  %v1806 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1805, ptr %state, ptr %EAX, i32 %v1804)
  store ptr %v1806, ptr %MEMORY, align 4
  %v1807 = load ptr, ptr %MEMORY, align 4
  %v1808 = call ptr @__remill_atomic_end(ptr %v1807)
  store ptr %v1808, ptr %MEMORY, align 4
  store i32 %v1798, ptr %PC, align 4
  %v1809 = add i32 %v1798, 3
  store i32 %v1809, ptr %NEXT_PC, align 4
  %v1810 = load ptr, ptr %MEMORY, align 4
  %v1811 = call ptr @__remill_atomic_begin(ptr %v1810)
  store ptr %v1811, ptr %MEMORY, align 4
  %v1812 = load i32, ptr %EAX, align 4
  %v1813 = load ptr, ptr %MEMORY, align 4
  %v1814 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1813, ptr %state, i32 %v1812, i32 14)
  store ptr %v1814, ptr %MEMORY, align 4
  %v1815 = load ptr, ptr %MEMORY, align 4
  %v1816 = call ptr @__remill_atomic_end(ptr %v1815)
  store ptr %v1816, ptr %MEMORY, align 4
  store i32 %v1809, ptr %PC, align 4
  %v1817 = add i32 %v1809, 2
  store i32 %v1817, ptr %NEXT_PC, align 4
  %v1818 = load ptr, ptr %MEMORY, align 4
  %v1819 = call ptr @__remill_atomic_begin(ptr %v1818)
  store ptr %v1819, ptr %MEMORY, align 4
  %v1820 = add i32 %v1817, 7
  %v1821 = load ptr, ptr %MEMORY, align 4
  %v1822 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1821, ptr %state, ptr %BRANCH_TAKEN, i32 %v1820, i32 %v1817, ptr %NEXT_PC)
  store ptr %v1822, ptr %MEMORY, align 4
  %v1823 = load ptr, ptr %MEMORY, align 4
  %v1824 = call ptr @__remill_atomic_end(ptr %v1823)
  store ptr %v1824, ptr %MEMORY, align 4
  br i1 true, label %bb_4199615, label %bb_4199608

bb_4199608:                                       ; preds = %bb_4199597
  store i32 %v1817, ptr %PC, align 4
  %v1825 = add i32 %v1817, 5
  store i32 %v1825, ptr %NEXT_PC, align 4
  %v1826 = load ptr, ptr %MEMORY, align 4
  %v1827 = call ptr @__remill_atomic_begin(ptr %v1826)
  store ptr %v1827, ptr %MEMORY, align 4
  %v1828 = load ptr, ptr %MEMORY, align 4
  %v1829 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1828, ptr %state, ptr %EAX, i32 0)
  store ptr %v1829, ptr %MEMORY, align 4
  %v1830 = load ptr, ptr %MEMORY, align 4
  %v1831 = call ptr @__remill_atomic_end(ptr %v1830)
  store ptr %v1831, ptr %MEMORY, align 4
  store i32 %v1825, ptr %PC, align 4
  %v1832 = add i32 %v1825, 2
  store i32 %v1832, ptr %NEXT_PC, align 4
  %v1833 = load ptr, ptr %MEMORY, align 4
  %v1834 = call ptr @__remill_atomic_begin(ptr %v1833)
  store ptr %v1834, ptr %MEMORY, align 4
  %v1835 = add i32 %v1832, 67
  %v1836 = load ptr, ptr %MEMORY, align 4
  %v1837 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1836, ptr %state, i32 %v1835, ptr %NEXT_PC)
  store ptr %v1837, ptr %MEMORY, align 4
  %v1838 = load ptr, ptr %MEMORY, align 4
  %v1839 = call ptr @__remill_atomic_end(ptr %v1838)
  store ptr %v1839, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199615:                                       ; preds = %bb_4199597
  store i32 %v1817, ptr %PC, align 4
  %v1840 = add i32 %v1817, 3
  store i32 %v1840, ptr %NEXT_PC, align 4
  %v1841 = load ptr, ptr %MEMORY, align 4
  %v1842 = call ptr @__remill_atomic_begin(ptr %v1841)
  store ptr %v1842, ptr %MEMORY, align 4
  %v1843 = load i32, ptr %EBP, align 4
  %v1844 = load i32, ptr %SSBASE, align 4
  %v1845 = sub i32 %v1843, 12
  %v1846 = add i32 %v1845, %v1844
  %v1847 = load ptr, ptr %MEMORY, align 4
  %v1848 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1847, ptr %state, ptr %EAX, i32 %v1846)
  store ptr %v1848, ptr %MEMORY, align 4
  %v1849 = load ptr, ptr %MEMORY, align 4
  %v1850 = call ptr @__remill_atomic_end(ptr %v1849)
  store ptr %v1850, ptr %MEMORY, align 4
  store i32 %v1840, ptr %PC, align 4
  %v1851 = add i32 %v1840, 6
  store i32 %v1851, ptr %NEXT_PC, align 4
  %v1852 = load ptr, ptr %MEMORY, align 4
  %v1853 = call ptr @__remill_atomic_begin(ptr %v1852)
  store ptr %v1853, ptr %MEMORY, align 4
  %v1854 = load i32, ptr %EAX, align 4
  %v1855 = load i32, ptr %DSBASE, align 4
  %v1856 = add i32 %v1854, 208
  %v1857 = add i32 %v1856, %v1855
  %v1858 = load ptr, ptr %MEMORY, align 4
  %v1859 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1858, ptr %state, ptr %EAX, i32 %v1857)
  store ptr %v1859, ptr %MEMORY, align 4
  %v1860 = load ptr, ptr %MEMORY, align 4
  %v1861 = call ptr @__remill_atomic_end(ptr %v1860)
  store ptr %v1861, ptr %MEMORY, align 4
  store i32 %v1851, ptr %PC, align 4
  %v1862 = add i32 %v1851, 2
  store i32 %v1862, ptr %NEXT_PC, align 4
  %v1863 = load ptr, ptr %MEMORY, align 4
  %v1864 = call ptr @__remill_atomic_begin(ptr %v1863)
  store ptr %v1864, ptr %MEMORY, align 4
  %v1865 = load i32, ptr %EAX, align 4
  %v1866 = load i32, ptr %EAX, align 4
  %v1867 = load ptr, ptr %MEMORY, align 4
  %v1868 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1867, ptr %state, i32 %v1865, i32 %v1866)
  store ptr %v1868, ptr %MEMORY, align 4
  %v1869 = load ptr, ptr %MEMORY, align 4
  %v1870 = call ptr @__remill_atomic_end(ptr %v1869)
  store ptr %v1870, ptr %MEMORY, align 4
  store i32 %v1862, ptr %PC, align 4
  %v1871 = add i32 %v1862, 3
  store i32 %v1871, ptr %NEXT_PC, align 4
  %v1872 = load ptr, ptr %MEMORY, align 4
  %v1873 = call ptr @__remill_atomic_begin(ptr %v1872)
  store ptr %v1873, ptr %MEMORY, align 4
  %v1874 = load ptr, ptr %MEMORY, align 4
  %v1875 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v1874, ptr %state, ptr %AL)
  store ptr %v1875, ptr %MEMORY, align 4
  %v1876 = load ptr, ptr %MEMORY, align 4
  %v1877 = call ptr @__remill_atomic_end(ptr %v1876)
  store ptr %v1877, ptr %MEMORY, align 4
  store i32 %v1871, ptr %PC, align 4
  %v1878 = add i32 %v1871, 3
  store i32 %v1878, ptr %NEXT_PC, align 4
  %v1879 = load ptr, ptr %MEMORY, align 4
  %v1880 = call ptr @__remill_atomic_begin(ptr %v1879)
  store ptr %v1880, ptr %MEMORY, align 4
  %v1881 = load i8, ptr %AL, align 1
  %v1882 = zext i8 %v1881 to i32
  %v1883 = load ptr, ptr %MEMORY, align 4
  %v1884 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1883, ptr %state, ptr %EAX, i32 %v1882)
  store ptr %v1884, ptr %MEMORY, align 4
  %v1885 = load ptr, ptr %MEMORY, align 4
  %v1886 = call ptr @__remill_atomic_end(ptr %v1885)
  store ptr %v1886, ptr %MEMORY, align 4
  store i32 %v1878, ptr %PC, align 4
  %v1887 = add i32 %v1878, 2
  store i32 %v1887, ptr %NEXT_PC, align 4
  %v1888 = load ptr, ptr %MEMORY, align 4
  %v1889 = call ptr @__remill_atomic_begin(ptr %v1888)
  store ptr %v1889, ptr %MEMORY, align 4
  %v1890 = add i32 %v1887, 48
  %v1891 = load ptr, ptr %MEMORY, align 4
  %v1892 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1891, ptr %state, i32 %v1890, ptr %NEXT_PC)
  store ptr %v1892, ptr %MEMORY, align 4
  %v1893 = load ptr, ptr %MEMORY, align 4
  %v1894 = call ptr @__remill_atomic_end(ptr %v1893)
  store ptr %v1894, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199634:                                       ; preds = %bb_4199588
  store i32 %v1771, ptr %PC, align 4
  %v1895 = add i32 %v1771, 3
  store i32 %v1895, ptr %NEXT_PC, align 4
  %v1896 = load ptr, ptr %MEMORY, align 4
  %v1897 = call ptr @__remill_atomic_begin(ptr %v1896)
  store ptr %v1897, ptr %MEMORY, align 4
  %v1898 = load i32, ptr %EBP, align 4
  %v1899 = load i32, ptr %SSBASE, align 4
  %v1900 = sub i32 %v1898, 12
  %v1901 = add i32 %v1900, %v1899
  %v1902 = load ptr, ptr %MEMORY, align 4
  %v1903 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1902, ptr %state, ptr %EAX, i32 %v1901)
  store ptr %v1903, ptr %MEMORY, align 4
  %v1904 = load ptr, ptr %MEMORY, align 4
  %v1905 = call ptr @__remill_atomic_end(ptr %v1904)
  store ptr %v1905, ptr %MEMORY, align 4
  store i32 %v1895, ptr %PC, align 4
  %v1906 = add i32 %v1895, 3
  store i32 %v1906, ptr %NEXT_PC, align 4
  %v1907 = load ptr, ptr %MEMORY, align 4
  %v1908 = call ptr @__remill_atomic_begin(ptr %v1907)
  store ptr %v1908, ptr %MEMORY, align 4
  %v1909 = load i32, ptr %EBP, align 4
  %v1910 = load i32, ptr %SSBASE, align 4
  %v1911 = sub i32 %v1909, 16
  %v1912 = add i32 %v1911, %v1910
  %v1913 = load i32, ptr %EAX, align 4
  %v1914 = load ptr, ptr %MEMORY, align 4
  %v1915 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1914, ptr %state, i32 %v1912, i32 %v1913)
  store ptr %v1915, ptr %MEMORY, align 4
  %v1916 = load ptr, ptr %MEMORY, align 4
  %v1917 = call ptr @__remill_atomic_end(ptr %v1916)
  store ptr %v1917, ptr %MEMORY, align 4
  store i32 %v1906, ptr %PC, align 4
  %v1918 = add i32 %v1906, 3
  store i32 %v1918, ptr %NEXT_PC, align 4
  %v1919 = load ptr, ptr %MEMORY, align 4
  %v1920 = call ptr @__remill_atomic_begin(ptr %v1919)
  store ptr %v1920, ptr %MEMORY, align 4
  %v1921 = load i32, ptr %EBP, align 4
  %v1922 = load i32, ptr %SSBASE, align 4
  %v1923 = sub i32 %v1921, 16
  %v1924 = add i32 %v1923, %v1922
  %v1925 = load ptr, ptr %MEMORY, align 4
  %v1926 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1925, ptr %state, ptr %EAX, i32 %v1924)
  store ptr %v1926, ptr %MEMORY, align 4
  %v1927 = load ptr, ptr %MEMORY, align 4
  %v1928 = call ptr @__remill_atomic_end(ptr %v1927)
  store ptr %v1928, ptr %MEMORY, align 4
  store i32 %v1918, ptr %PC, align 4
  %v1929 = add i32 %v1918, 3
  store i32 %v1929, ptr %NEXT_PC, align 4
  %v1930 = load ptr, ptr %MEMORY, align 4
  %v1931 = call ptr @__remill_atomic_begin(ptr %v1930)
  store ptr %v1931, ptr %MEMORY, align 4
  %v1932 = load i32, ptr %EAX, align 4
  %v1933 = load i32, ptr %DSBASE, align 4
  %v1934 = add i32 %v1932, 108
  %v1935 = add i32 %v1934, %v1933
  %v1936 = load ptr, ptr %MEMORY, align 4
  %v1937 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1936, ptr %state, ptr %EAX, i32 %v1935)
  store ptr %v1937, ptr %MEMORY, align 4
  %v1938 = load ptr, ptr %MEMORY, align 4
  %v1939 = call ptr @__remill_atomic_end(ptr %v1938)
  store ptr %v1939, ptr %MEMORY, align 4
  store i32 %v1929, ptr %PC, align 4
  %v1940 = add i32 %v1929, 3
  store i32 %v1940, ptr %NEXT_PC, align 4
  %v1941 = load ptr, ptr %MEMORY, align 4
  %v1942 = call ptr @__remill_atomic_begin(ptr %v1941)
  store ptr %v1942, ptr %MEMORY, align 4
  %v1943 = load i32, ptr %EAX, align 4
  %v1944 = load ptr, ptr %MEMORY, align 4
  %v1945 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1944, ptr %state, i32 %v1943, i32 14)
  store ptr %v1945, ptr %MEMORY, align 4
  %v1946 = load ptr, ptr %MEMORY, align 4
  %v1947 = call ptr @__remill_atomic_end(ptr %v1946)
  store ptr %v1947, ptr %MEMORY, align 4
  store i32 %v1940, ptr %PC, align 4
  %v1948 = add i32 %v1940, 2
  store i32 %v1948, ptr %NEXT_PC, align 4
  %v1949 = load ptr, ptr %MEMORY, align 4
  %v1950 = call ptr @__remill_atomic_begin(ptr %v1949)
  store ptr %v1950, ptr %MEMORY, align 4
  %v1951 = add i32 %v1948, 7
  %v1952 = load ptr, ptr %MEMORY, align 4
  %v1953 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1952, ptr %state, ptr %BRANCH_TAKEN, i32 %v1951, i32 %v1948, ptr %NEXT_PC)
  store ptr %v1953, ptr %MEMORY, align 4
  %v1954 = load ptr, ptr %MEMORY, align 4
  %v1955 = call ptr @__remill_atomic_end(ptr %v1954)
  store ptr %v1955, ptr %MEMORY, align 4
  br i1 true, label %bb_4199658, label %bb_4199651

bb_4199651:                                       ; preds = %bb_4199634
  store i32 %v1948, ptr %PC, align 4
  %v1956 = add i32 %v1948, 5
  store i32 %v1956, ptr %NEXT_PC, align 4
  %v1957 = load ptr, ptr %MEMORY, align 4
  %v1958 = call ptr @__remill_atomic_begin(ptr %v1957)
  store ptr %v1958, ptr %MEMORY, align 4
  %v1959 = load ptr, ptr %MEMORY, align 4
  %v1960 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1959, ptr %state, ptr %EAX, i32 0)
  store ptr %v1960, ptr %MEMORY, align 4
  %v1961 = load ptr, ptr %MEMORY, align 4
  %v1962 = call ptr @__remill_atomic_end(ptr %v1961)
  store ptr %v1962, ptr %MEMORY, align 4
  store i32 %v1956, ptr %PC, align 4
  %v1963 = add i32 %v1956, 2
  store i32 %v1963, ptr %NEXT_PC, align 4
  %v1964 = load ptr, ptr %MEMORY, align 4
  %v1965 = call ptr @__remill_atomic_begin(ptr %v1964)
  store ptr %v1965, ptr %MEMORY, align 4
  %v1966 = add i32 %v1963, 24
  %v1967 = load ptr, ptr %MEMORY, align 4
  %v1968 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1967, ptr %state, i32 %v1966, ptr %NEXT_PC)
  store ptr %v1968, ptr %MEMORY, align 4
  %v1969 = load ptr, ptr %MEMORY, align 4
  %v1970 = call ptr @__remill_atomic_end(ptr %v1969)
  store ptr %v1970, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199658:                                       ; preds = %bb_4199634
  store i32 %v1948, ptr %PC, align 4
  %v1971 = add i32 %v1948, 3
  store i32 %v1971, ptr %NEXT_PC, align 4
  %v1972 = load ptr, ptr %MEMORY, align 4
  %v1973 = call ptr @__remill_atomic_begin(ptr %v1972)
  store ptr %v1973, ptr %MEMORY, align 4
  %v1974 = load i32, ptr %EBP, align 4
  %v1975 = load i32, ptr %SSBASE, align 4
  %v1976 = sub i32 %v1974, 16
  %v1977 = add i32 %v1976, %v1975
  %v1978 = load ptr, ptr %MEMORY, align 4
  %v1979 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1978, ptr %state, ptr %EAX, i32 %v1977)
  store ptr %v1979, ptr %MEMORY, align 4
  %v1980 = load ptr, ptr %MEMORY, align 4
  %v1981 = call ptr @__remill_atomic_end(ptr %v1980)
  store ptr %v1981, ptr %MEMORY, align 4
  store i32 %v1971, ptr %PC, align 4
  %v1982 = add i32 %v1971, 6
  store i32 %v1982, ptr %NEXT_PC, align 4
  %v1983 = load ptr, ptr %MEMORY, align 4
  %v1984 = call ptr @__remill_atomic_begin(ptr %v1983)
  store ptr %v1984, ptr %MEMORY, align 4
  %v1985 = load i32, ptr %EAX, align 4
  %v1986 = load i32, ptr %DSBASE, align 4
  %v1987 = add i32 %v1985, 224
  %v1988 = add i32 %v1987, %v1986
  %v1989 = load ptr, ptr %MEMORY, align 4
  %v1990 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1989, ptr %state, ptr %EAX, i32 %v1988)
  store ptr %v1990, ptr %MEMORY, align 4
  %v1991 = load ptr, ptr %MEMORY, align 4
  %v1992 = call ptr @__remill_atomic_end(ptr %v1991)
  store ptr %v1992, ptr %MEMORY, align 4
  store i32 %v1982, ptr %PC, align 4
  %v1993 = add i32 %v1982, 2
  store i32 %v1993, ptr %NEXT_PC, align 4
  %v1994 = load ptr, ptr %MEMORY, align 4
  %v1995 = call ptr @__remill_atomic_begin(ptr %v1994)
  store ptr %v1995, ptr %MEMORY, align 4
  %v1996 = load i32, ptr %EAX, align 4
  %v1997 = load i32, ptr %EAX, align 4
  %v1998 = load ptr, ptr %MEMORY, align 4
  %v1999 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1998, ptr %state, i32 %v1996, i32 %v1997)
  store ptr %v1999, ptr %MEMORY, align 4
  %v2000 = load ptr, ptr %MEMORY, align 4
  %v2001 = call ptr @__remill_atomic_end(ptr %v2000)
  store ptr %v2001, ptr %MEMORY, align 4
  store i32 %v1993, ptr %PC, align 4
  %v2002 = add i32 %v1993, 3
  store i32 %v2002, ptr %NEXT_PC, align 4
  %v2003 = load ptr, ptr %MEMORY, align 4
  %v2004 = call ptr @__remill_atomic_begin(ptr %v2003)
  store ptr %v2004, ptr %MEMORY, align 4
  %v2005 = load ptr, ptr %MEMORY, align 4
  %v2006 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v2005, ptr %state, ptr %AL)
  store ptr %v2006, ptr %MEMORY, align 4
  %v2007 = load ptr, ptr %MEMORY, align 4
  %v2008 = call ptr @__remill_atomic_end(ptr %v2007)
  store ptr %v2008, ptr %MEMORY, align 4
  store i32 %v2002, ptr %PC, align 4
  %v2009 = add i32 %v2002, 3
  store i32 %v2009, ptr %NEXT_PC, align 4
  %v2010 = load ptr, ptr %MEMORY, align 4
  %v2011 = call ptr @__remill_atomic_begin(ptr %v2010)
  store ptr %v2011, ptr %MEMORY, align 4
  %v2012 = load i8, ptr %AL, align 1
  %v2013 = zext i8 %v2012 to i32
  %v2014 = load ptr, ptr %MEMORY, align 4
  %v2015 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2014, ptr %state, ptr %EAX, i32 %v2013)
  store ptr %v2015, ptr %MEMORY, align 4
  %v2016 = load ptr, ptr %MEMORY, align 4
  %v2017 = call ptr @__remill_atomic_end(ptr %v2016)
  store ptr %v2017, ptr %MEMORY, align 4
  store i32 %v2009, ptr %PC, align 4
  %v2018 = add i32 %v2009, 2
  store i32 %v2018, ptr %NEXT_PC, align 4
  %v2019 = load ptr, ptr %MEMORY, align 4
  %v2020 = call ptr @__remill_atomic_begin(ptr %v2019)
  store ptr %v2020, ptr %MEMORY, align 4
  %v2021 = add i32 %v2018, 5
  %v2022 = load ptr, ptr %MEMORY, align 4
  %v2023 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2022, ptr %state, i32 %v2021, ptr %NEXT_PC)
  store ptr %v2023, ptr %MEMORY, align 4
  %v2024 = load ptr, ptr %MEMORY, align 4
  %v2025 = call ptr @__remill_atomic_end(ptr %v2024)
  store ptr %v2025, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199677:                                       ; preds = %bb_4199595
  store i32 %v1779, ptr %PC, align 4
  %v2026 = add i32 %v1779, 5
  store i32 %v2026, ptr %NEXT_PC, align 4
  %v2027 = load ptr, ptr %MEMORY, align 4
  %v2028 = call ptr @__remill_atomic_begin(ptr %v2027)
  store ptr %v2028, ptr %MEMORY, align 4
  %v2029 = load ptr, ptr %MEMORY, align 4
  %v2030 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2029, ptr %state, ptr %EAX, i32 0)
  store ptr %v2030, ptr %MEMORY, align 4
  %v2031 = load ptr, ptr %MEMORY, align 4
  %v2032 = call ptr @__remill_atomic_end(ptr %v2031)
  store ptr %v2032, ptr %MEMORY, align 4
  br label %bb_4199682

bb_4199682:                                       ; preds = %bb_4199677, %bb_4199658, %bb_4199651, %bb_4199615, %bb_4199608, %bb_4199556, %bb_4199518
  %v2033 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2033, ptr %PC, align 4
  %v2034 = add i32 %v2033, 1
  store i32 %v2034, ptr %NEXT_PC, align 4
  %v2035 = load ptr, ptr %MEMORY, align 4
  %v2036 = call ptr @__remill_atomic_begin(ptr %v2035)
  store ptr %v2036, ptr %MEMORY, align 4
  %v2037 = load ptr, ptr %MEMORY, align 4
  %v2038 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v2037, ptr %state)
  store ptr %v2038, ptr %MEMORY, align 4
  %v2039 = load ptr, ptr %MEMORY, align 4
  %v2040 = call ptr @__remill_atomic_end(ptr %v2039)
  store ptr %v2040, ptr %MEMORY, align 4
  store i32 %v2034, ptr %PC, align 4
  %v2041 = add i32 %v2034, 1
  store i32 %v2041, ptr %NEXT_PC, align 4
  %v2042 = load ptr, ptr %MEMORY, align 4
  %v2043 = call ptr @__remill_atomic_begin(ptr %v2042)
  store ptr %v2043, ptr %MEMORY, align 4
  %v2044 = load ptr, ptr %MEMORY, align 4
  %v2045 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2044, ptr %state, ptr %NEXT_PC)
  store ptr %v2045, ptr %MEMORY, align 4
  %v2046 = load ptr, ptr %MEMORY, align 4
  %v2047 = call ptr @__remill_atomic_end(ptr %v2046)
  store ptr %v2047, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199684:                                       ; No predecessors!
  %v2048 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2048, ptr %PC, align 4
  %v2049 = add i32 %v2048, 1
  store i32 %v2049, ptr %NEXT_PC, align 4
  %v2050 = load ptr, ptr %MEMORY, align 4
  %v2051 = call ptr @__remill_atomic_begin(ptr %v2050)
  store ptr %v2051, ptr %MEMORY, align 4
  %v2052 = load i32, ptr %EBP, align 4
  %v2053 = load ptr, ptr %MEMORY, align 4
  %v2054 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2053, ptr %state, i32 %v2052)
  store ptr %v2054, ptr %MEMORY, align 4
  %v2055 = load ptr, ptr %MEMORY, align 4
  %v2056 = call ptr @__remill_atomic_end(ptr %v2055)
  store ptr %v2056, ptr %MEMORY, align 4
  store i32 %v2049, ptr %PC, align 4
  %v2057 = add i32 %v2049, 2
  store i32 %v2057, ptr %NEXT_PC, align 4
  %v2058 = load ptr, ptr %MEMORY, align 4
  %v2059 = call ptr @__remill_atomic_begin(ptr %v2058)
  store ptr %v2059, ptr %MEMORY, align 4
  %v2060 = load i32, ptr %ESP, align 4
  %v2061 = load ptr, ptr %MEMORY, align 4
  %v2062 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2061, ptr %state, ptr %EBP, i32 %v2060)
  store ptr %v2062, ptr %MEMORY, align 4
  %v2063 = load ptr, ptr %MEMORY, align 4
  %v2064 = call ptr @__remill_atomic_end(ptr %v2063)
  store ptr %v2064, ptr %MEMORY, align 4
  store i32 %v2057, ptr %PC, align 4
  %v2065 = add i32 %v2057, 1
  store i32 %v2065, ptr %NEXT_PC, align 4
  %v2066 = load ptr, ptr %MEMORY, align 4
  %v2067 = call ptr @__remill_atomic_begin(ptr %v2066)
  store ptr %v2067, ptr %MEMORY, align 4
  %v2068 = load i32, ptr %EBX, align 4
  %v2069 = load ptr, ptr %MEMORY, align 4
  %v2070 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2069, ptr %state, i32 %v2068)
  store ptr %v2070, ptr %MEMORY, align 4
  %v2071 = load ptr, ptr %MEMORY, align 4
  %v2072 = call ptr @__remill_atomic_end(ptr %v2071)
  store ptr %v2072, ptr %MEMORY, align 4
  store i32 %v2065, ptr %PC, align 4
  %v2073 = add i32 %v2065, 3
  store i32 %v2073, ptr %NEXT_PC, align 4
  %v2074 = load ptr, ptr %MEMORY, align 4
  %v2075 = call ptr @__remill_atomic_begin(ptr %v2074)
  store ptr %v2075, ptr %MEMORY, align 4
  %v2076 = load i32, ptr %ESP, align 4
  %v2077 = load ptr, ptr %MEMORY, align 4
  %v2078 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2077, ptr %state, ptr %ESP, i32 %v2076, i32 36)
  store ptr %v2078, ptr %MEMORY, align 4
  %v2079 = load ptr, ptr %MEMORY, align 4
  %v2080 = call ptr @__remill_atomic_end(ptr %v2079)
  store ptr %v2080, ptr %MEMORY, align 4
  store i32 %v2073, ptr %PC, align 4
  %v2081 = add i32 %v2073, 3
  store i32 %v2081, ptr %NEXT_PC, align 4
  %v2082 = load ptr, ptr %MEMORY, align 4
  %v2083 = call ptr @__remill_atomic_begin(ptr %v2082)
  store ptr %v2083, ptr %MEMORY, align 4
  %v2084 = load i32, ptr %EBP, align 4
  %v2085 = load i32, ptr %SSBASE, align 4
  %v2086 = add i32 %v2084, 8
  %v2087 = add i32 %v2086, %v2085
  %v2088 = load ptr, ptr %MEMORY, align 4
  %v2089 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2088, ptr %state, ptr %EAX, i32 %v2087)
  store ptr %v2089, ptr %MEMORY, align 4
  %v2090 = load ptr, ptr %MEMORY, align 4
  %v2091 = call ptr @__remill_atomic_end(ptr %v2090)
  store ptr %v2091, ptr %MEMORY, align 4
  store i32 %v2081, ptr %PC, align 4
  %v2092 = add i32 %v2081, 3
  store i32 %v2092, ptr %NEXT_PC, align 4
  %v2093 = load ptr, ptr %MEMORY, align 4
  %v2094 = call ptr @__remill_atomic_begin(ptr %v2093)
  store ptr %v2094, ptr %MEMORY, align 4
  %v2095 = load i32, ptr %EAX, align 4
  %v2096 = load ptr, ptr %MEMORY, align 4
  %v2097 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2096, ptr %state, ptr %EAX, i32 %v2095, i32 1)
  store ptr %v2097, ptr %MEMORY, align 4
  %v2098 = load ptr, ptr %MEMORY, align 4
  %v2099 = call ptr @__remill_atomic_end(ptr %v2098)
  store ptr %v2099, ptr %MEMORY, align 4
  store i32 %v2092, ptr %PC, align 4
  %v2100 = add i32 %v2092, 3
  store i32 %v2100, ptr %NEXT_PC, align 4
  %v2101 = load ptr, ptr %MEMORY, align 4
  %v2102 = call ptr @__remill_atomic_begin(ptr %v2101)
  store ptr %v2102, ptr %MEMORY, align 4
  %v2103 = load i32, ptr %EAX, align 4
  %v2104 = load ptr, ptr %MEMORY, align 4
  %v2105 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2104, ptr %state, ptr %EAX, i32 %v2103, i32 2)
  store ptr %v2105, ptr %MEMORY, align 4
  %v2106 = load ptr, ptr %MEMORY, align 4
  %v2107 = call ptr @__remill_atomic_end(ptr %v2106)
  store ptr %v2107, ptr %MEMORY, align 4
  store i32 %v2100, ptr %PC, align 4
  %v2108 = add i32 %v2100, 3
  store i32 %v2108, ptr %NEXT_PC, align 4
  %v2109 = load ptr, ptr %MEMORY, align 4
  %v2110 = call ptr @__remill_atomic_begin(ptr %v2109)
  store ptr %v2110, ptr %MEMORY, align 4
  %v2111 = load i32, ptr %ESP, align 4
  %v2112 = load i32, ptr %SSBASE, align 4
  %v2113 = add i32 %v2111, %v2112
  %v2114 = load i32, ptr %EAX, align 4
  %v2115 = load ptr, ptr %MEMORY, align 4
  %v2116 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2115, ptr %state, i32 %v2113, i32 %v2114)
  store ptr %v2116, ptr %MEMORY, align 4
  %v2117 = load ptr, ptr %MEMORY, align 4
  %v2118 = call ptr @__remill_atomic_end(ptr %v2117)
  store ptr %v2118, ptr %MEMORY, align 4
  store i32 %v2108, ptr %PC, align 4
  %v2119 = add i32 %v2108, 5
  store i32 %v2119, ptr %NEXT_PC, align 4
  %v2120 = load ptr, ptr %MEMORY, align 4
  %v2121 = call ptr @__remill_atomic_begin(ptr %v2120)
  store ptr %v2121, ptr %MEMORY, align 4
  %v2122 = add i32 %v2119, 28856
  %v2123 = load ptr, ptr %MEMORY, align 4
  %v2124 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2123, ptr %state, i64 4228564, ptr %NEXT_PC, i32 %v2119, ptr %RETURN_PC)
  store ptr %v2124, ptr %MEMORY, align 4
  %v2125 = load ptr, ptr %MEMORY, align 4
  %v2126 = call ptr @__remill_atomic_end(ptr %v2125)
  store ptr %v2126, ptr %MEMORY, align 4
  store i32 %v2119, ptr %PC, align 4
  %v2127 = add i32 %v2119, 3
  store i32 %v2127, ptr %NEXT_PC, align 4
  %v2128 = load ptr, ptr %MEMORY, align 4
  %v2129 = call ptr @__remill_atomic_begin(ptr %v2128)
  store ptr %v2129, ptr %MEMORY, align 4
  %v2130 = load i32, ptr %EBP, align 4
  %v2131 = load i32, ptr %SSBASE, align 4
  %v2132 = sub i32 %v2130, 16
  %v2133 = add i32 %v2132, %v2131
  %v2134 = load i32, ptr %EAX, align 4
  %v2135 = load ptr, ptr %MEMORY, align 4
  %v2136 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2135, ptr %state, i32 %v2133, i32 %v2134)
  store ptr %v2136, ptr %MEMORY, align 4
  %v2137 = load ptr, ptr %MEMORY, align 4
  %v2138 = call ptr @__remill_atomic_end(ptr %v2137)
  store ptr %v2138, ptr %MEMORY, align 4
  store i32 %v2127, ptr %PC, align 4
  %v2139 = add i32 %v2127, 3
  store i32 %v2139, ptr %NEXT_PC, align 4
  %v2140 = load ptr, ptr %MEMORY, align 4
  %v2141 = call ptr @__remill_atomic_begin(ptr %v2140)
  store ptr %v2141, ptr %MEMORY, align 4
  %v2142 = load i32, ptr %EBP, align 4
  %v2143 = load i32, ptr %SSBASE, align 4
  %v2144 = add i32 %v2142, 12
  %v2145 = add i32 %v2144, %v2143
  %v2146 = load ptr, ptr %MEMORY, align 4
  %v2147 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2146, ptr %state, ptr %EAX, i32 %v2145)
  store ptr %v2147, ptr %MEMORY, align 4
  %v2148 = load ptr, ptr %MEMORY, align 4
  %v2149 = call ptr @__remill_atomic_end(ptr %v2148)
  store ptr %v2149, ptr %MEMORY, align 4
  store i32 %v2139, ptr %PC, align 4
  %v2150 = add i32 %v2139, 2
  store i32 %v2150, ptr %NEXT_PC, align 4
  %v2151 = load ptr, ptr %MEMORY, align 4
  %v2152 = call ptr @__remill_atomic_begin(ptr %v2151)
  store ptr %v2152, ptr %MEMORY, align 4
  %v2153 = load i32, ptr %EAX, align 4
  %v2154 = load i32, ptr %DSBASE, align 4
  %v2155 = add i32 %v2153, %v2154
  %v2156 = load ptr, ptr %MEMORY, align 4
  %v2157 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2156, ptr %state, ptr %EAX, i32 %v2155)
  store ptr %v2157, ptr %MEMORY, align 4
  %v2158 = load ptr, ptr %MEMORY, align 4
  %v2159 = call ptr @__remill_atomic_end(ptr %v2158)
  store ptr %v2159, ptr %MEMORY, align 4
  store i32 %v2150, ptr %PC, align 4
  %v2160 = add i32 %v2150, 3
  store i32 %v2160, ptr %NEXT_PC, align 4
  %v2161 = load ptr, ptr %MEMORY, align 4
  %v2162 = call ptr @__remill_atomic_begin(ptr %v2161)
  store ptr %v2162, ptr %MEMORY, align 4
  %v2163 = load i32, ptr %EBP, align 4
  %v2164 = load i32, ptr %SSBASE, align 4
  %v2165 = sub i32 %v2163, 20
  %v2166 = add i32 %v2165, %v2164
  %v2167 = load i32, ptr %EAX, align 4
  %v2168 = load ptr, ptr %MEMORY, align 4
  %v2169 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2168, ptr %state, i32 %v2166, i32 %v2167)
  store ptr %v2169, ptr %MEMORY, align 4
  %v2170 = load ptr, ptr %MEMORY, align 4
  %v2171 = call ptr @__remill_atomic_end(ptr %v2170)
  store ptr %v2171, ptr %MEMORY, align 4
  store i32 %v2160, ptr %PC, align 4
  %v2172 = add i32 %v2160, 7
  store i32 %v2172, ptr %NEXT_PC, align 4
  %v2173 = load ptr, ptr %MEMORY, align 4
  %v2174 = call ptr @__remill_atomic_begin(ptr %v2173)
  store ptr %v2174, ptr %MEMORY, align 4
  %v2175 = load i32, ptr %EBP, align 4
  %v2176 = load i32, ptr %SSBASE, align 4
  %v2177 = sub i32 %v2175, 12
  %v2178 = add i32 %v2177, %v2176
  %v2179 = load ptr, ptr %MEMORY, align 4
  %v2180 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2179, ptr %state, i32 %v2178, i32 0)
  store ptr %v2180, ptr %MEMORY, align 4
  %v2181 = load ptr, ptr %MEMORY, align 4
  %v2182 = call ptr @__remill_atomic_end(ptr %v2181)
  store ptr %v2182, ptr %MEMORY, align 4
  store i32 %v2172, ptr %PC, align 4
  %v2183 = add i32 %v2172, 2
  store i32 %v2183, ptr %NEXT_PC, align 4
  %v2184 = load ptr, ptr %MEMORY, align 4
  %v2185 = call ptr @__remill_atomic_begin(ptr %v2184)
  store ptr %v2185, ptr %MEMORY, align 4
  %v2186 = add i32 %v2183, 117
  %v2187 = load ptr, ptr %MEMORY, align 4
  %v2188 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2187, ptr %state, i32 %v2186, ptr %NEXT_PC)
  store ptr %v2188, ptr %MEMORY, align 4
  %v2189 = load ptr, ptr %MEMORY, align 4
  %v2190 = call ptr @__remill_atomic_end(ptr %v2189)
  store ptr %v2190, ptr %MEMORY, align 4
  br label %bb_4199845

bb_4199728:                                       ; preds = %bb_4199845
  store i32 %v2560, ptr %PC, align 4
  %v2191 = add i32 %v2560, 3
  store i32 %v2191, ptr %NEXT_PC, align 4
  %v2192 = load ptr, ptr %MEMORY, align 4
  %v2193 = call ptr @__remill_atomic_begin(ptr %v2192)
  store ptr %v2193, ptr %MEMORY, align 4
  %v2194 = load i32, ptr %EBP, align 4
  %v2195 = load i32, ptr %SSBASE, align 4
  %v2196 = sub i32 %v2194, 12
  %v2197 = add i32 %v2196, %v2195
  %v2198 = load ptr, ptr %MEMORY, align 4
  %v2199 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2198, ptr %state, ptr %EAX, i32 %v2197)
  store ptr %v2199, ptr %MEMORY, align 4
  %v2200 = load ptr, ptr %MEMORY, align 4
  %v2201 = call ptr @__remill_atomic_end(ptr %v2200)
  store ptr %v2201, ptr %MEMORY, align 4
  store i32 %v2191, ptr %PC, align 4
  %v2202 = add i32 %v2191, 7
  store i32 %v2202, ptr %NEXT_PC, align 4
  %v2203 = load ptr, ptr %MEMORY, align 4
  %v2204 = call ptr @__remill_atomic_begin(ptr %v2203)
  store ptr %v2204, ptr %MEMORY, align 4
  %v2205 = load i32, ptr %EAX, align 4
  %v2206 = mul i32 %v2205, 4
  %v2207 = add i32 0, %v2206
  %v2208 = load ptr, ptr %MEMORY, align 4
  %v2209 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2208, ptr %state, ptr %EDX, i32 %v2207)
  store ptr %v2209, ptr %MEMORY, align 4
  %v2210 = load ptr, ptr %MEMORY, align 4
  %v2211 = call ptr @__remill_atomic_end(ptr %v2210)
  store ptr %v2211, ptr %MEMORY, align 4
  store i32 %v2202, ptr %PC, align 4
  %v2212 = add i32 %v2202, 3
  store i32 %v2212, ptr %NEXT_PC, align 4
  %v2213 = load ptr, ptr %MEMORY, align 4
  %v2214 = call ptr @__remill_atomic_begin(ptr %v2213)
  store ptr %v2214, ptr %MEMORY, align 4
  %v2215 = load i32, ptr %EBP, align 4
  %v2216 = load i32, ptr %SSBASE, align 4
  %v2217 = sub i32 %v2215, 20
  %v2218 = add i32 %v2217, %v2216
  %v2219 = load ptr, ptr %MEMORY, align 4
  %v2220 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2219, ptr %state, ptr %EAX, i32 %v2218)
  store ptr %v2220, ptr %MEMORY, align 4
  %v2221 = load ptr, ptr %MEMORY, align 4
  %v2222 = call ptr @__remill_atomic_end(ptr %v2221)
  store ptr %v2222, ptr %MEMORY, align 4
  store i32 %v2212, ptr %PC, align 4
  %v2223 = add i32 %v2212, 2
  store i32 %v2223, ptr %NEXT_PC, align 4
  %v2224 = load ptr, ptr %MEMORY, align 4
  %v2225 = call ptr @__remill_atomic_begin(ptr %v2224)
  store ptr %v2225, ptr %MEMORY, align 4
  %v2226 = load i32, ptr %EAX, align 4
  %v2227 = load i32, ptr %EDX, align 4
  %v2228 = load ptr, ptr %MEMORY, align 4
  %v2229 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2228, ptr %state, ptr %EAX, i32 %v2226, i32 %v2227)
  store ptr %v2229, ptr %MEMORY, align 4
  %v2230 = load ptr, ptr %MEMORY, align 4
  %v2231 = call ptr @__remill_atomic_end(ptr %v2230)
  store ptr %v2231, ptr %MEMORY, align 4
  store i32 %v2223, ptr %PC, align 4
  %v2232 = add i32 %v2223, 2
  store i32 %v2232, ptr %NEXT_PC, align 4
  %v2233 = load ptr, ptr %MEMORY, align 4
  %v2234 = call ptr @__remill_atomic_begin(ptr %v2233)
  store ptr %v2234, ptr %MEMORY, align 4
  %v2235 = load i32, ptr %EAX, align 4
  %v2236 = load i32, ptr %DSBASE, align 4
  %v2237 = add i32 %v2235, %v2236
  %v2238 = load ptr, ptr %MEMORY, align 4
  %v2239 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2238, ptr %state, ptr %EAX, i32 %v2237)
  store ptr %v2239, ptr %MEMORY, align 4
  %v2240 = load ptr, ptr %MEMORY, align 4
  %v2241 = call ptr @__remill_atomic_end(ptr %v2240)
  store ptr %v2241, ptr %MEMORY, align 4
  store i32 %v2232, ptr %PC, align 4
  %v2242 = add i32 %v2232, 3
  store i32 %v2242, ptr %NEXT_PC, align 4
  %v2243 = load ptr, ptr %MEMORY, align 4
  %v2244 = call ptr @__remill_atomic_begin(ptr %v2243)
  store ptr %v2244, ptr %MEMORY, align 4
  %v2245 = load i32, ptr %ESP, align 4
  %v2246 = load i32, ptr %SSBASE, align 4
  %v2247 = add i32 %v2245, %v2246
  %v2248 = load i32, ptr %EAX, align 4
  %v2249 = load ptr, ptr %MEMORY, align 4
  %v2250 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2249, ptr %state, i32 %v2247, i32 %v2248)
  store ptr %v2250, ptr %MEMORY, align 4
  %v2251 = load ptr, ptr %MEMORY, align 4
  %v2252 = call ptr @__remill_atomic_end(ptr %v2251)
  store ptr %v2252, ptr %MEMORY, align 4
  store i32 %v2242, ptr %PC, align 4
  %v2253 = add i32 %v2242, 5
  store i32 %v2253, ptr %NEXT_PC, align 4
  %v2254 = load ptr, ptr %MEMORY, align 4
  %v2255 = call ptr @__remill_atomic_begin(ptr %v2254)
  store ptr %v2255, ptr %MEMORY, align 4
  %v2256 = add i32 %v2253, 28819
  %v2257 = load ptr, ptr %MEMORY, align 4
  %v2258 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2257, ptr %state, i64 4228572, ptr %NEXT_PC, i32 %v2253, ptr %RETURN_PC)
  store ptr %v2258, ptr %MEMORY, align 4
  %v2259 = load ptr, ptr %MEMORY, align 4
  %v2260 = call ptr @__remill_atomic_end(ptr %v2259)
  store ptr %v2260, ptr %MEMORY, align 4
  store i32 %v2253, ptr %PC, align 4
  %v2261 = add i32 %v2253, 3
  store i32 %v2261, ptr %NEXT_PC, align 4
  %v2262 = load ptr, ptr %MEMORY, align 4
  %v2263 = call ptr @__remill_atomic_begin(ptr %v2262)
  store ptr %v2263, ptr %MEMORY, align 4
  %v2264 = load i32, ptr %EAX, align 4
  %v2265 = load ptr, ptr %MEMORY, align 4
  %v2266 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2265, ptr %state, ptr %EAX, i32 %v2264, i32 1)
  store ptr %v2266, ptr %MEMORY, align 4
  %v2267 = load ptr, ptr %MEMORY, align 4
  %v2268 = call ptr @__remill_atomic_end(ptr %v2267)
  store ptr %v2268, ptr %MEMORY, align 4
  store i32 %v2261, ptr %PC, align 4
  %v2269 = add i32 %v2261, 3
  store i32 %v2269, ptr %NEXT_PC, align 4
  %v2270 = load ptr, ptr %MEMORY, align 4
  %v2271 = call ptr @__remill_atomic_begin(ptr %v2270)
  store ptr %v2271, ptr %MEMORY, align 4
  %v2272 = load i32, ptr %EBP, align 4
  %v2273 = load i32, ptr %SSBASE, align 4
  %v2274 = sub i32 %v2272, 24
  %v2275 = add i32 %v2274, %v2273
  %v2276 = load i32, ptr %EAX, align 4
  %v2277 = load ptr, ptr %MEMORY, align 4
  %v2278 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2277, ptr %state, i32 %v2275, i32 %v2276)
  store ptr %v2278, ptr %MEMORY, align 4
  %v2279 = load ptr, ptr %MEMORY, align 4
  %v2280 = call ptr @__remill_atomic_end(ptr %v2279)
  store ptr %v2280, ptr %MEMORY, align 4
  store i32 %v2269, ptr %PC, align 4
  %v2281 = add i32 %v2269, 3
  store i32 %v2281, ptr %NEXT_PC, align 4
  %v2282 = load ptr, ptr %MEMORY, align 4
  %v2283 = call ptr @__remill_atomic_begin(ptr %v2282)
  store ptr %v2283, ptr %MEMORY, align 4
  %v2284 = load i32, ptr %EBP, align 4
  %v2285 = load i32, ptr %SSBASE, align 4
  %v2286 = sub i32 %v2284, 12
  %v2287 = add i32 %v2286, %v2285
  %v2288 = load ptr, ptr %MEMORY, align 4
  %v2289 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2288, ptr %state, ptr %EAX, i32 %v2287)
  store ptr %v2289, ptr %MEMORY, align 4
  %v2290 = load ptr, ptr %MEMORY, align 4
  %v2291 = call ptr @__remill_atomic_end(ptr %v2290)
  store ptr %v2291, ptr %MEMORY, align 4
  store i32 %v2281, ptr %PC, align 4
  %v2292 = add i32 %v2281, 7
  store i32 %v2292, ptr %NEXT_PC, align 4
  %v2293 = load ptr, ptr %MEMORY, align 4
  %v2294 = call ptr @__remill_atomic_begin(ptr %v2293)
  store ptr %v2294, ptr %MEMORY, align 4
  %v2295 = load i32, ptr %EAX, align 4
  %v2296 = mul i32 %v2295, 4
  %v2297 = add i32 0, %v2296
  %v2298 = load ptr, ptr %MEMORY, align 4
  %v2299 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2298, ptr %state, ptr %EDX, i32 %v2297)
  store ptr %v2299, ptr %MEMORY, align 4
  %v2300 = load ptr, ptr %MEMORY, align 4
  %v2301 = call ptr @__remill_atomic_end(ptr %v2300)
  store ptr %v2301, ptr %MEMORY, align 4
  store i32 %v2292, ptr %PC, align 4
  %v2302 = add i32 %v2292, 3
  store i32 %v2302, ptr %NEXT_PC, align 4
  %v2303 = load ptr, ptr %MEMORY, align 4
  %v2304 = call ptr @__remill_atomic_begin(ptr %v2303)
  store ptr %v2304, ptr %MEMORY, align 4
  %v2305 = load i32, ptr %EBP, align 4
  %v2306 = load i32, ptr %SSBASE, align 4
  %v2307 = sub i32 %v2305, 16
  %v2308 = add i32 %v2307, %v2306
  %v2309 = load ptr, ptr %MEMORY, align 4
  %v2310 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2309, ptr %state, ptr %EAX, i32 %v2308)
  store ptr %v2310, ptr %MEMORY, align 4
  %v2311 = load ptr, ptr %MEMORY, align 4
  %v2312 = call ptr @__remill_atomic_end(ptr %v2311)
  store ptr %v2312, ptr %MEMORY, align 4
  store i32 %v2302, ptr %PC, align 4
  %v2313 = add i32 %v2302, 3
  store i32 %v2313, ptr %NEXT_PC, align 4
  %v2314 = load ptr, ptr %MEMORY, align 4
  %v2315 = call ptr @__remill_atomic_begin(ptr %v2314)
  store ptr %v2315, ptr %MEMORY, align 4
  %v2316 = load i32, ptr %EDX, align 4
  %v2317 = load i32, ptr %EAX, align 4
  %v2318 = mul i32 %v2317, 1
  %v2319 = add i32 %v2316, %v2318
  %v2320 = load ptr, ptr %MEMORY, align 4
  %v2321 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2320, ptr %state, ptr %EBX, i32 %v2319)
  store ptr %v2321, ptr %MEMORY, align 4
  %v2322 = load ptr, ptr %MEMORY, align 4
  %v2323 = call ptr @__remill_atomic_end(ptr %v2322)
  store ptr %v2323, ptr %MEMORY, align 4
  store i32 %v2313, ptr %PC, align 4
  %v2324 = add i32 %v2313, 3
  store i32 %v2324, ptr %NEXT_PC, align 4
  %v2325 = load ptr, ptr %MEMORY, align 4
  %v2326 = call ptr @__remill_atomic_begin(ptr %v2325)
  store ptr %v2326, ptr %MEMORY, align 4
  %v2327 = load i32, ptr %EBP, align 4
  %v2328 = load i32, ptr %SSBASE, align 4
  %v2329 = sub i32 %v2327, 24
  %v2330 = add i32 %v2329, %v2328
  %v2331 = load ptr, ptr %MEMORY, align 4
  %v2332 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2331, ptr %state, ptr %EAX, i32 %v2330)
  store ptr %v2332, ptr %MEMORY, align 4
  %v2333 = load ptr, ptr %MEMORY, align 4
  %v2334 = call ptr @__remill_atomic_end(ptr %v2333)
  store ptr %v2334, ptr %MEMORY, align 4
  store i32 %v2324, ptr %PC, align 4
  %v2335 = add i32 %v2324, 3
  store i32 %v2335, ptr %NEXT_PC, align 4
  %v2336 = load ptr, ptr %MEMORY, align 4
  %v2337 = call ptr @__remill_atomic_begin(ptr %v2336)
  store ptr %v2337, ptr %MEMORY, align 4
  %v2338 = load i32, ptr %ESP, align 4
  %v2339 = load i32, ptr %SSBASE, align 4
  %v2340 = add i32 %v2338, %v2339
  %v2341 = load i32, ptr %EAX, align 4
  %v2342 = load ptr, ptr %MEMORY, align 4
  %v2343 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2342, ptr %state, i32 %v2340, i32 %v2341)
  store ptr %v2343, ptr %MEMORY, align 4
  %v2344 = load ptr, ptr %MEMORY, align 4
  %v2345 = call ptr @__remill_atomic_end(ptr %v2344)
  store ptr %v2345, ptr %MEMORY, align 4
  store i32 %v2335, ptr %PC, align 4
  %v2346 = add i32 %v2335, 5
  store i32 %v2346, ptr %NEXT_PC, align 4
  %v2347 = load ptr, ptr %MEMORY, align 4
  %v2348 = call ptr @__remill_atomic_begin(ptr %v2347)
  store ptr %v2348, ptr %MEMORY, align 4
  %v2349 = add i32 %v2346, 28778
  %v2350 = load ptr, ptr %MEMORY, align 4
  %v2351 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2350, ptr %state, i64 4228564, ptr %NEXT_PC, i32 %v2346, ptr %RETURN_PC)
  store ptr %v2351, ptr %MEMORY, align 4
  %v2352 = load ptr, ptr %MEMORY, align 4
  %v2353 = call ptr @__remill_atomic_end(ptr %v2352)
  store ptr %v2353, ptr %MEMORY, align 4
  store i32 %v2346, ptr %PC, align 4
  %v2354 = add i32 %v2346, 2
  store i32 %v2354, ptr %NEXT_PC, align 4
  %v2355 = load ptr, ptr %MEMORY, align 4
  %v2356 = call ptr @__remill_atomic_begin(ptr %v2355)
  store ptr %v2356, ptr %MEMORY, align 4
  %v2357 = load i32, ptr %EBX, align 4
  %v2358 = load i32, ptr %DSBASE, align 4
  %v2359 = add i32 %v2357, %v2358
  %v2360 = load i32, ptr %EAX, align 4
  %v2361 = load ptr, ptr %MEMORY, align 4
  %v2362 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2361, ptr %state, i32 %v2359, i32 %v2360)
  store ptr %v2362, ptr %MEMORY, align 4
  %v2363 = load ptr, ptr %MEMORY, align 4
  %v2364 = call ptr @__remill_atomic_end(ptr %v2363)
  store ptr %v2364, ptr %MEMORY, align 4
  store i32 %v2354, ptr %PC, align 4
  %v2365 = add i32 %v2354, 3
  store i32 %v2365, ptr %NEXT_PC, align 4
  %v2366 = load ptr, ptr %MEMORY, align 4
  %v2367 = call ptr @__remill_atomic_begin(ptr %v2366)
  store ptr %v2367, ptr %MEMORY, align 4
  %v2368 = load i32, ptr %EBP, align 4
  %v2369 = load i32, ptr %SSBASE, align 4
  %v2370 = sub i32 %v2368, 24
  %v2371 = add i32 %v2370, %v2369
  %v2372 = load ptr, ptr %MEMORY, align 4
  %v2373 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2372, ptr %state, ptr %ECX, i32 %v2371)
  store ptr %v2373, ptr %MEMORY, align 4
  %v2374 = load ptr, ptr %MEMORY, align 4
  %v2375 = call ptr @__remill_atomic_end(ptr %v2374)
  store ptr %v2375, ptr %MEMORY, align 4
  store i32 %v2365, ptr %PC, align 4
  %v2376 = add i32 %v2365, 3
  store i32 %v2376, ptr %NEXT_PC, align 4
  %v2377 = load ptr, ptr %MEMORY, align 4
  %v2378 = call ptr @__remill_atomic_begin(ptr %v2377)
  store ptr %v2378, ptr %MEMORY, align 4
  %v2379 = load i32, ptr %EBP, align 4
  %v2380 = load i32, ptr %SSBASE, align 4
  %v2381 = sub i32 %v2379, 12
  %v2382 = add i32 %v2381, %v2380
  %v2383 = load ptr, ptr %MEMORY, align 4
  %v2384 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2383, ptr %state, ptr %EAX, i32 %v2382)
  store ptr %v2384, ptr %MEMORY, align 4
  %v2385 = load ptr, ptr %MEMORY, align 4
  %v2386 = call ptr @__remill_atomic_end(ptr %v2385)
  store ptr %v2386, ptr %MEMORY, align 4
  store i32 %v2376, ptr %PC, align 4
  %v2387 = add i32 %v2376, 7
  store i32 %v2387, ptr %NEXT_PC, align 4
  %v2388 = load ptr, ptr %MEMORY, align 4
  %v2389 = call ptr @__remill_atomic_begin(ptr %v2388)
  store ptr %v2389, ptr %MEMORY, align 4
  %v2390 = load i32, ptr %EAX, align 4
  %v2391 = mul i32 %v2390, 4
  %v2392 = add i32 0, %v2391
  %v2393 = load ptr, ptr %MEMORY, align 4
  %v2394 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2393, ptr %state, ptr %EDX, i32 %v2392)
  store ptr %v2394, ptr %MEMORY, align 4
  %v2395 = load ptr, ptr %MEMORY, align 4
  %v2396 = call ptr @__remill_atomic_end(ptr %v2395)
  store ptr %v2396, ptr %MEMORY, align 4
  store i32 %v2387, ptr %PC, align 4
  %v2397 = add i32 %v2387, 3
  store i32 %v2397, ptr %NEXT_PC, align 4
  %v2398 = load ptr, ptr %MEMORY, align 4
  %v2399 = call ptr @__remill_atomic_begin(ptr %v2398)
  store ptr %v2399, ptr %MEMORY, align 4
  %v2400 = load i32, ptr %EBP, align 4
  %v2401 = load i32, ptr %SSBASE, align 4
  %v2402 = sub i32 %v2400, 20
  %v2403 = add i32 %v2402, %v2401
  %v2404 = load ptr, ptr %MEMORY, align 4
  %v2405 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2404, ptr %state, ptr %EAX, i32 %v2403)
  store ptr %v2405, ptr %MEMORY, align 4
  %v2406 = load ptr, ptr %MEMORY, align 4
  %v2407 = call ptr @__remill_atomic_end(ptr %v2406)
  store ptr %v2407, ptr %MEMORY, align 4
  store i32 %v2397, ptr %PC, align 4
  %v2408 = add i32 %v2397, 2
  store i32 %v2408, ptr %NEXT_PC, align 4
  %v2409 = load ptr, ptr %MEMORY, align 4
  %v2410 = call ptr @__remill_atomic_begin(ptr %v2409)
  store ptr %v2410, ptr %MEMORY, align 4
  %v2411 = load i32, ptr %EAX, align 4
  %v2412 = load i32, ptr %EDX, align 4
  %v2413 = load ptr, ptr %MEMORY, align 4
  %v2414 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2413, ptr %state, ptr %EAX, i32 %v2411, i32 %v2412)
  store ptr %v2414, ptr %MEMORY, align 4
  %v2415 = load ptr, ptr %MEMORY, align 4
  %v2416 = call ptr @__remill_atomic_end(ptr %v2415)
  store ptr %v2416, ptr %MEMORY, align 4
  store i32 %v2408, ptr %PC, align 4
  %v2417 = add i32 %v2408, 2
  store i32 %v2417, ptr %NEXT_PC, align 4
  %v2418 = load ptr, ptr %MEMORY, align 4
  %v2419 = call ptr @__remill_atomic_begin(ptr %v2418)
  store ptr %v2419, ptr %MEMORY, align 4
  %v2420 = load i32, ptr %EAX, align 4
  %v2421 = load i32, ptr %DSBASE, align 4
  %v2422 = add i32 %v2420, %v2421
  %v2423 = load ptr, ptr %MEMORY, align 4
  %v2424 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2423, ptr %state, ptr %EDX, i32 %v2422)
  store ptr %v2424, ptr %MEMORY, align 4
  %v2425 = load ptr, ptr %MEMORY, align 4
  %v2426 = call ptr @__remill_atomic_end(ptr %v2425)
  store ptr %v2426, ptr %MEMORY, align 4
  store i32 %v2417, ptr %PC, align 4
  %v2427 = add i32 %v2417, 3
  store i32 %v2427, ptr %NEXT_PC, align 4
  %v2428 = load ptr, ptr %MEMORY, align 4
  %v2429 = call ptr @__remill_atomic_begin(ptr %v2428)
  store ptr %v2429, ptr %MEMORY, align 4
  %v2430 = load i32, ptr %EBP, align 4
  %v2431 = load i32, ptr %SSBASE, align 4
  %v2432 = sub i32 %v2430, 12
  %v2433 = add i32 %v2432, %v2431
  %v2434 = load ptr, ptr %MEMORY, align 4
  %v2435 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2434, ptr %state, ptr %EAX, i32 %v2433)
  store ptr %v2435, ptr %MEMORY, align 4
  %v2436 = load ptr, ptr %MEMORY, align 4
  %v2437 = call ptr @__remill_atomic_end(ptr %v2436)
  store ptr %v2437, ptr %MEMORY, align 4
  store i32 %v2427, ptr %PC, align 4
  %v2438 = add i32 %v2427, 7
  store i32 %v2438, ptr %NEXT_PC, align 4
  %v2439 = load ptr, ptr %MEMORY, align 4
  %v2440 = call ptr @__remill_atomic_begin(ptr %v2439)
  store ptr %v2440, ptr %MEMORY, align 4
  %v2441 = load i32, ptr %EAX, align 4
  %v2442 = mul i32 %v2441, 4
  %v2443 = add i32 0, %v2442
  %v2444 = load ptr, ptr %MEMORY, align 4
  %v2445 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2444, ptr %state, ptr %EBX, i32 %v2443)
  store ptr %v2445, ptr %MEMORY, align 4
  %v2446 = load ptr, ptr %MEMORY, align 4
  %v2447 = call ptr @__remill_atomic_end(ptr %v2446)
  store ptr %v2447, ptr %MEMORY, align 4
  store i32 %v2438, ptr %PC, align 4
  %v2448 = add i32 %v2438, 3
  store i32 %v2448, ptr %NEXT_PC, align 4
  %v2449 = load ptr, ptr %MEMORY, align 4
  %v2450 = call ptr @__remill_atomic_begin(ptr %v2449)
  store ptr %v2450, ptr %MEMORY, align 4
  %v2451 = load i32, ptr %EBP, align 4
  %v2452 = load i32, ptr %SSBASE, align 4
  %v2453 = sub i32 %v2451, 16
  %v2454 = add i32 %v2453, %v2452
  %v2455 = load ptr, ptr %MEMORY, align 4
  %v2456 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2455, ptr %state, ptr %EAX, i32 %v2454)
  store ptr %v2456, ptr %MEMORY, align 4
  %v2457 = load ptr, ptr %MEMORY, align 4
  %v2458 = call ptr @__remill_atomic_end(ptr %v2457)
  store ptr %v2458, ptr %MEMORY, align 4
  store i32 %v2448, ptr %PC, align 4
  %v2459 = add i32 %v2448, 2
  store i32 %v2459, ptr %NEXT_PC, align 4
  %v2460 = load ptr, ptr %MEMORY, align 4
  %v2461 = call ptr @__remill_atomic_begin(ptr %v2460)
  store ptr %v2461, ptr %MEMORY, align 4
  %v2462 = load i32, ptr %EAX, align 4
  %v2463 = load i32, ptr %EBX, align 4
  %v2464 = load ptr, ptr %MEMORY, align 4
  %v2465 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2464, ptr %state, ptr %EAX, i32 %v2462, i32 %v2463)
  store ptr %v2465, ptr %MEMORY, align 4
  %v2466 = load ptr, ptr %MEMORY, align 4
  %v2467 = call ptr @__remill_atomic_end(ptr %v2466)
  store ptr %v2467, ptr %MEMORY, align 4
  store i32 %v2459, ptr %PC, align 4
  %v2468 = add i32 %v2459, 2
  store i32 %v2468, ptr %NEXT_PC, align 4
  %v2469 = load ptr, ptr %MEMORY, align 4
  %v2470 = call ptr @__remill_atomic_begin(ptr %v2469)
  store ptr %v2470, ptr %MEMORY, align 4
  %v2471 = load i32, ptr %EAX, align 4
  %v2472 = load i32, ptr %DSBASE, align 4
  %v2473 = add i32 %v2471, %v2472
  %v2474 = load ptr, ptr %MEMORY, align 4
  %v2475 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2474, ptr %state, ptr %EAX, i32 %v2473)
  store ptr %v2475, ptr %MEMORY, align 4
  %v2476 = load ptr, ptr %MEMORY, align 4
  %v2477 = call ptr @__remill_atomic_end(ptr %v2476)
  store ptr %v2477, ptr %MEMORY, align 4
  store i32 %v2468, ptr %PC, align 4
  %v2478 = add i32 %v2468, 4
  store i32 %v2478, ptr %NEXT_PC, align 4
  %v2479 = load ptr, ptr %MEMORY, align 4
  %v2480 = call ptr @__remill_atomic_begin(ptr %v2479)
  store ptr %v2480, ptr %MEMORY, align 4
  %v2481 = load i32, ptr %ESP, align 4
  %v2482 = load i32, ptr %SSBASE, align 4
  %v2483 = add i32 %v2481, 8
  %v2484 = add i32 %v2483, %v2482
  %v2485 = load i32, ptr %ECX, align 4
  %v2486 = load ptr, ptr %MEMORY, align 4
  %v2487 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2486, ptr %state, i32 %v2484, i32 %v2485)
  store ptr %v2487, ptr %MEMORY, align 4
  %v2488 = load ptr, ptr %MEMORY, align 4
  %v2489 = call ptr @__remill_atomic_end(ptr %v2488)
  store ptr %v2489, ptr %MEMORY, align 4
  store i32 %v2478, ptr %PC, align 4
  %v2490 = add i32 %v2478, 4
  store i32 %v2490, ptr %NEXT_PC, align 4
  %v2491 = load ptr, ptr %MEMORY, align 4
  %v2492 = call ptr @__remill_atomic_begin(ptr %v2491)
  store ptr %v2492, ptr %MEMORY, align 4
  %v2493 = load i32, ptr %ESP, align 4
  %v2494 = load i32, ptr %SSBASE, align 4
  %v2495 = add i32 %v2493, 4
  %v2496 = add i32 %v2495, %v2494
  %v2497 = load i32, ptr %EDX, align 4
  %v2498 = load ptr, ptr %MEMORY, align 4
  %v2499 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2498, ptr %state, i32 %v2496, i32 %v2497)
  store ptr %v2499, ptr %MEMORY, align 4
  %v2500 = load ptr, ptr %MEMORY, align 4
  %v2501 = call ptr @__remill_atomic_end(ptr %v2500)
  store ptr %v2501, ptr %MEMORY, align 4
  store i32 %v2490, ptr %PC, align 4
  %v2502 = add i32 %v2490, 3
  store i32 %v2502, ptr %NEXT_PC, align 4
  %v2503 = load ptr, ptr %MEMORY, align 4
  %v2504 = call ptr @__remill_atomic_begin(ptr %v2503)
  store ptr %v2504, ptr %MEMORY, align 4
  %v2505 = load i32, ptr %ESP, align 4
  %v2506 = load i32, ptr %SSBASE, align 4
  %v2507 = add i32 %v2505, %v2506
  %v2508 = load i32, ptr %EAX, align 4
  %v2509 = load ptr, ptr %MEMORY, align 4
  %v2510 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2509, ptr %state, i32 %v2507, i32 %v2508)
  store ptr %v2510, ptr %MEMORY, align 4
  %v2511 = load ptr, ptr %MEMORY, align 4
  %v2512 = call ptr @__remill_atomic_end(ptr %v2511)
  store ptr %v2512, ptr %MEMORY, align 4
  store i32 %v2502, ptr %PC, align 4
  %v2513 = add i32 %v2502, 5
  store i32 %v2513, ptr %NEXT_PC, align 4
  %v2514 = load ptr, ptr %MEMORY, align 4
  %v2515 = call ptr @__remill_atomic_begin(ptr %v2514)
  store ptr %v2515, ptr %MEMORY, align 4
  %v2516 = add i32 %v2513, 28739
  %v2517 = load ptr, ptr %MEMORY, align 4
  %v2518 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2517, ptr %state, i64 4228580, ptr %NEXT_PC, i32 %v2513, ptr %RETURN_PC)
  store ptr %v2518, ptr %MEMORY, align 4
  %v2519 = load ptr, ptr %MEMORY, align 4
  %v2520 = call ptr @__remill_atomic_end(ptr %v2519)
  store ptr %v2520, ptr %MEMORY, align 4
  store i32 %v2513, ptr %PC, align 4
  %v2521 = add i32 %v2513, 4
  store i32 %v2521, ptr %NEXT_PC, align 4
  %v2522 = load ptr, ptr %MEMORY, align 4
  %v2523 = call ptr @__remill_atomic_begin(ptr %v2522)
  store ptr %v2523, ptr %MEMORY, align 4
  %v2524 = load i32, ptr %EBP, align 4
  %v2525 = load i32, ptr %SSBASE, align 4
  %v2526 = sub i32 %v2524, 12
  %v2527 = add i32 %v2526, %v2525
  %v2528 = load i32, ptr %EBP, align 4
  %v2529 = load i32, ptr %SSBASE, align 4
  %v2530 = sub i32 %v2528, 12
  %v2531 = add i32 %v2530, %v2529
  %v2532 = load ptr, ptr %MEMORY, align 4
  %v2533 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2532, ptr %state, i32 %v2527, i32 %v2531, i32 1)
  store ptr %v2533, ptr %MEMORY, align 4
  %v2534 = load ptr, ptr %MEMORY, align 4
  %v2535 = call ptr @__remill_atomic_end(ptr %v2534)
  store ptr %v2535, ptr %MEMORY, align 4
  br label %bb_4199845

bb_4199845:                                       ; preds = %bb_4199728, %bb_4199684
  %v2536 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2536, ptr %PC, align 4
  %v2537 = add i32 %v2536, 3
  store i32 %v2537, ptr %NEXT_PC, align 4
  %v2538 = load ptr, ptr %MEMORY, align 4
  %v2539 = call ptr @__remill_atomic_begin(ptr %v2538)
  store ptr %v2539, ptr %MEMORY, align 4
  %v2540 = load i32, ptr %EBP, align 4
  %v2541 = load i32, ptr %SSBASE, align 4
  %v2542 = sub i32 %v2540, 12
  %v2543 = add i32 %v2542, %v2541
  %v2544 = load ptr, ptr %MEMORY, align 4
  %v2545 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2544, ptr %state, ptr %EAX, i32 %v2543)
  store ptr %v2545, ptr %MEMORY, align 4
  %v2546 = load ptr, ptr %MEMORY, align 4
  %v2547 = call ptr @__remill_atomic_end(ptr %v2546)
  store ptr %v2547, ptr %MEMORY, align 4
  store i32 %v2537, ptr %PC, align 4
  %v2548 = add i32 %v2537, 3
  store i32 %v2548, ptr %NEXT_PC, align 4
  %v2549 = load ptr, ptr %MEMORY, align 4
  %v2550 = call ptr @__remill_atomic_begin(ptr %v2549)
  store ptr %v2550, ptr %MEMORY, align 4
  %v2551 = load i32, ptr %EAX, align 4
  %v2552 = load i32, ptr %EBP, align 4
  %v2553 = load i32, ptr %SSBASE, align 4
  %v2554 = add i32 %v2552, 8
  %v2555 = add i32 %v2554, %v2553
  %v2556 = load ptr, ptr %MEMORY, align 4
  %v2557 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2556, ptr %state, i32 %v2551, i32 %v2555)
  store ptr %v2557, ptr %MEMORY, align 4
  %v2558 = load ptr, ptr %MEMORY, align 4
  %v2559 = call ptr @__remill_atomic_end(ptr %v2558)
  store ptr %v2559, ptr %MEMORY, align 4
  store i32 %v2548, ptr %PC, align 4
  %v2560 = add i32 %v2548, 2
  store i32 %v2560, ptr %NEXT_PC, align 4
  %v2561 = load ptr, ptr %MEMORY, align 4
  %v2562 = call ptr @__remill_atomic_begin(ptr %v2561)
  store ptr %v2562, ptr %MEMORY, align 4
  %v2563 = sub i32 %v2560, 125
  %v2564 = load ptr, ptr %MEMORY, align 4
  %v2565 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2564, ptr %state, ptr %BRANCH_TAKEN, i32 %v2563, i32 %v2560, ptr %NEXT_PC)
  store ptr %v2565, ptr %MEMORY, align 4
  %v2566 = load ptr, ptr %MEMORY, align 4
  %v2567 = call ptr @__remill_atomic_end(ptr %v2566)
  store ptr %v2567, ptr %MEMORY, align 4
  br i1 true, label %bb_4199728, label %bb_4199853

bb_4199853:                                       ; preds = %bb_4199845
  store i32 %v2560, ptr %PC, align 4
  %v2568 = add i32 %v2560, 3
  store i32 %v2568, ptr %NEXT_PC, align 4
  %v2569 = load ptr, ptr %MEMORY, align 4
  %v2570 = call ptr @__remill_atomic_begin(ptr %v2569)
  store ptr %v2570, ptr %MEMORY, align 4
  %v2571 = load i32, ptr %EBP, align 4
  %v2572 = load i32, ptr %SSBASE, align 4
  %v2573 = sub i32 %v2571, 12
  %v2574 = add i32 %v2573, %v2572
  %v2575 = load ptr, ptr %MEMORY, align 4
  %v2576 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2575, ptr %state, ptr %EAX, i32 %v2574)
  store ptr %v2576, ptr %MEMORY, align 4
  %v2577 = load ptr, ptr %MEMORY, align 4
  %v2578 = call ptr @__remill_atomic_end(ptr %v2577)
  store ptr %v2578, ptr %MEMORY, align 4
  store i32 %v2568, ptr %PC, align 4
  %v2579 = add i32 %v2568, 7
  store i32 %v2579, ptr %NEXT_PC, align 4
  %v2580 = load ptr, ptr %MEMORY, align 4
  %v2581 = call ptr @__remill_atomic_begin(ptr %v2580)
  store ptr %v2581, ptr %MEMORY, align 4
  %v2582 = load i32, ptr %EAX, align 4
  %v2583 = mul i32 %v2582, 4
  %v2584 = add i32 0, %v2583
  %v2585 = load ptr, ptr %MEMORY, align 4
  %v2586 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2585, ptr %state, ptr %EDX, i32 %v2584)
  store ptr %v2586, ptr %MEMORY, align 4
  %v2587 = load ptr, ptr %MEMORY, align 4
  %v2588 = call ptr @__remill_atomic_end(ptr %v2587)
  store ptr %v2588, ptr %MEMORY, align 4
  store i32 %v2579, ptr %PC, align 4
  %v2589 = add i32 %v2579, 3
  store i32 %v2589, ptr %NEXT_PC, align 4
  %v2590 = load ptr, ptr %MEMORY, align 4
  %v2591 = call ptr @__remill_atomic_begin(ptr %v2590)
  store ptr %v2591, ptr %MEMORY, align 4
  %v2592 = load i32, ptr %EBP, align 4
  %v2593 = load i32, ptr %SSBASE, align 4
  %v2594 = sub i32 %v2592, 16
  %v2595 = add i32 %v2594, %v2593
  %v2596 = load ptr, ptr %MEMORY, align 4
  %v2597 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2596, ptr %state, ptr %EAX, i32 %v2595)
  store ptr %v2597, ptr %MEMORY, align 4
  %v2598 = load ptr, ptr %MEMORY, align 4
  %v2599 = call ptr @__remill_atomic_end(ptr %v2598)
  store ptr %v2599, ptr %MEMORY, align 4
  store i32 %v2589, ptr %PC, align 4
  %v2600 = add i32 %v2589, 2
  store i32 %v2600, ptr %NEXT_PC, align 4
  %v2601 = load ptr, ptr %MEMORY, align 4
  %v2602 = call ptr @__remill_atomic_begin(ptr %v2601)
  store ptr %v2602, ptr %MEMORY, align 4
  %v2603 = load i32, ptr %EAX, align 4
  %v2604 = load i32, ptr %EDX, align 4
  %v2605 = load ptr, ptr %MEMORY, align 4
  %v2606 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2605, ptr %state, ptr %EAX, i32 %v2603, i32 %v2604)
  store ptr %v2606, ptr %MEMORY, align 4
  %v2607 = load ptr, ptr %MEMORY, align 4
  %v2608 = call ptr @__remill_atomic_end(ptr %v2607)
  store ptr %v2608, ptr %MEMORY, align 4
  store i32 %v2600, ptr %PC, align 4
  %v2609 = add i32 %v2600, 6
  store i32 %v2609, ptr %NEXT_PC, align 4
  %v2610 = load ptr, ptr %MEMORY, align 4
  %v2611 = call ptr @__remill_atomic_begin(ptr %v2610)
  store ptr %v2611, ptr %MEMORY, align 4
  %v2612 = load i32, ptr %EAX, align 4
  %v2613 = load i32, ptr %DSBASE, align 4
  %v2614 = add i32 %v2612, %v2613
  %v2615 = load ptr, ptr %MEMORY, align 4
  %v2616 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2615, ptr %state, i32 %v2614, i32 0)
  store ptr %v2616, ptr %MEMORY, align 4
  %v2617 = load ptr, ptr %MEMORY, align 4
  %v2618 = call ptr @__remill_atomic_end(ptr %v2617)
  store ptr %v2618, ptr %MEMORY, align 4
  store i32 %v2609, ptr %PC, align 4
  %v2619 = add i32 %v2609, 3
  store i32 %v2619, ptr %NEXT_PC, align 4
  %v2620 = load ptr, ptr %MEMORY, align 4
  %v2621 = call ptr @__remill_atomic_begin(ptr %v2620)
  store ptr %v2621, ptr %MEMORY, align 4
  %v2622 = load i32, ptr %EBP, align 4
  %v2623 = load i32, ptr %SSBASE, align 4
  %v2624 = add i32 %v2622, 12
  %v2625 = add i32 %v2624, %v2623
  %v2626 = load ptr, ptr %MEMORY, align 4
  %v2627 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2626, ptr %state, ptr %EAX, i32 %v2625)
  store ptr %v2627, ptr %MEMORY, align 4
  %v2628 = load ptr, ptr %MEMORY, align 4
  %v2629 = call ptr @__remill_atomic_end(ptr %v2628)
  store ptr %v2629, ptr %MEMORY, align 4
  store i32 %v2619, ptr %PC, align 4
  %v2630 = add i32 %v2619, 3
  store i32 %v2630, ptr %NEXT_PC, align 4
  %v2631 = load ptr, ptr %MEMORY, align 4
  %v2632 = call ptr @__remill_atomic_begin(ptr %v2631)
  store ptr %v2632, ptr %MEMORY, align 4
  %v2633 = load i32, ptr %EBP, align 4
  %v2634 = load i32, ptr %SSBASE, align 4
  %v2635 = sub i32 %v2633, 16
  %v2636 = add i32 %v2635, %v2634
  %v2637 = load ptr, ptr %MEMORY, align 4
  %v2638 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2637, ptr %state, ptr %EDX, i32 %v2636)
  store ptr %v2638, ptr %MEMORY, align 4
  %v2639 = load ptr, ptr %MEMORY, align 4
  %v2640 = call ptr @__remill_atomic_end(ptr %v2639)
  store ptr %v2640, ptr %MEMORY, align 4
  store i32 %v2630, ptr %PC, align 4
  %v2641 = add i32 %v2630, 2
  store i32 %v2641, ptr %NEXT_PC, align 4
  %v2642 = load ptr, ptr %MEMORY, align 4
  %v2643 = call ptr @__remill_atomic_begin(ptr %v2642)
  store ptr %v2643, ptr %MEMORY, align 4
  %v2644 = load i32, ptr %EAX, align 4
  %v2645 = load i32, ptr %DSBASE, align 4
  %v2646 = add i32 %v2644, %v2645
  %v2647 = load i32, ptr %EDX, align 4
  %v2648 = load ptr, ptr %MEMORY, align 4
  %v2649 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2648, ptr %state, i32 %v2646, i32 %v2647)
  store ptr %v2649, ptr %MEMORY, align 4
  %v2650 = load ptr, ptr %MEMORY, align 4
  %v2651 = call ptr @__remill_atomic_end(ptr %v2650)
  store ptr %v2651, ptr %MEMORY, align 4
  store i32 %v2641, ptr %PC, align 4
  %v2652 = add i32 %v2641, 3
  store i32 %v2652, ptr %NEXT_PC, align 4
  %v2653 = load ptr, ptr %MEMORY, align 4
  %v2654 = call ptr @__remill_atomic_begin(ptr %v2653)
  store ptr %v2654, ptr %MEMORY, align 4
  %v2655 = load i32, ptr %ESP, align 4
  %v2656 = load ptr, ptr %MEMORY, align 4
  %v2657 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2656, ptr %state, ptr %ESP, i32 %v2655, i32 36)
  store ptr %v2657, ptr %MEMORY, align 4
  %v2658 = load ptr, ptr %MEMORY, align 4
  %v2659 = call ptr @__remill_atomic_end(ptr %v2658)
  store ptr %v2659, ptr %MEMORY, align 4
  store i32 %v2652, ptr %PC, align 4
  %v2660 = add i32 %v2652, 1
  store i32 %v2660, ptr %NEXT_PC, align 4
  %v2661 = load ptr, ptr %MEMORY, align 4
  %v2662 = call ptr @__remill_atomic_begin(ptr %v2661)
  store ptr %v2662, ptr %MEMORY, align 4
  %v2663 = load ptr, ptr %MEMORY, align 4
  %v2664 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v2663, ptr %state, ptr %EBX)
  store ptr %v2664, ptr %MEMORY, align 4
  %v2665 = load ptr, ptr %MEMORY, align 4
  %v2666 = call ptr @__remill_atomic_end(ptr %v2665)
  store ptr %v2666, ptr %MEMORY, align 4
  store i32 %v2660, ptr %PC, align 4
  %v2667 = add i32 %v2660, 1
  store i32 %v2667, ptr %NEXT_PC, align 4
  %v2668 = load ptr, ptr %MEMORY, align 4
  %v2669 = call ptr @__remill_atomic_begin(ptr %v2668)
  store ptr %v2669, ptr %MEMORY, align 4
  %v2670 = load ptr, ptr %MEMORY, align 4
  %v2671 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v2670, ptr %state, ptr %EBP)
  store ptr %v2671, ptr %MEMORY, align 4
  %v2672 = load ptr, ptr %MEMORY, align 4
  %v2673 = call ptr @__remill_atomic_end(ptr %v2672)
  store ptr %v2673, ptr %MEMORY, align 4
  store i32 %v2667, ptr %PC, align 4
  %v2674 = add i32 %v2667, 1
  store i32 %v2674, ptr %NEXT_PC, align 4
  %v2675 = load ptr, ptr %MEMORY, align 4
  %v2676 = call ptr @__remill_atomic_begin(ptr %v2675)
  store ptr %v2676, ptr %MEMORY, align 4
  %v2677 = load ptr, ptr %MEMORY, align 4
  %v2678 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2677, ptr %state, ptr %NEXT_PC)
  store ptr %v2678, ptr %MEMORY, align 4
  %v2679 = load ptr, ptr %MEMORY, align 4
  %v2680 = call ptr @__remill_atomic_end(ptr %v2679)
  store ptr %v2680, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199888:                                       ; No predecessors!
  %v2681 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2681, ptr %PC, align 4
  %v2682 = add i32 %v2681, 1
  store i32 %v2682, ptr %NEXT_PC, align 4
  %v2683 = load ptr, ptr %MEMORY, align 4
  %v2684 = call ptr @__remill_atomic_begin(ptr %v2683)
  store ptr %v2684, ptr %MEMORY, align 4
  %v2685 = load i32, ptr %EBP, align 4
  %v2686 = load ptr, ptr %MEMORY, align 4
  %v2687 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2686, ptr %state, i32 %v2685)
  store ptr %v2687, ptr %MEMORY, align 4
  %v2688 = load ptr, ptr %MEMORY, align 4
  %v2689 = call ptr @__remill_atomic_end(ptr %v2688)
  store ptr %v2689, ptr %MEMORY, align 4
  store i32 %v2682, ptr %PC, align 4
  %v2690 = add i32 %v2682, 2
  store i32 %v2690, ptr %NEXT_PC, align 4
  %v2691 = load ptr, ptr %MEMORY, align 4
  %v2692 = call ptr @__remill_atomic_begin(ptr %v2691)
  store ptr %v2692, ptr %MEMORY, align 4
  %v2693 = load i32, ptr %ESP, align 4
  %v2694 = load ptr, ptr %MEMORY, align 4
  %v2695 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2694, ptr %state, ptr %EBP, i32 %v2693)
  store ptr %v2695, ptr %MEMORY, align 4
  %v2696 = load ptr, ptr %MEMORY, align 4
  %v2697 = call ptr @__remill_atomic_end(ptr %v2696)
  store ptr %v2697, ptr %MEMORY, align 4
  store i32 %v2690, ptr %PC, align 4
  %v2698 = add i32 %v2690, 1
  store i32 %v2698, ptr %NEXT_PC, align 4
  %v2699 = load ptr, ptr %MEMORY, align 4
  %v2700 = call ptr @__remill_atomic_begin(ptr %v2699)
  store ptr %v2700, ptr %MEMORY, align 4
  %v2701 = load ptr, ptr %MEMORY, align 4
  %v2702 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v2701, ptr %state, ptr %EBP)
  store ptr %v2702, ptr %MEMORY, align 4
  %v2703 = load ptr, ptr %MEMORY, align 4
  %v2704 = call ptr @__remill_atomic_end(ptr %v2703)
  store ptr %v2704, ptr %MEMORY, align 4
  store i32 %v2698, ptr %PC, align 4
  %v2705 = add i32 %v2698, 1
  store i32 %v2705, ptr %NEXT_PC, align 4
  %v2706 = load ptr, ptr %MEMORY, align 4
  %v2707 = call ptr @__remill_atomic_begin(ptr %v2706)
  store ptr %v2707, ptr %MEMORY, align 4
  %v2708 = load ptr, ptr %MEMORY, align 4
  %v2709 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2708, ptr %state, ptr %NEXT_PC)
  store ptr %v2709, ptr %MEMORY, align 4
  %v2710 = load ptr, ptr %MEMORY, align 4
  %v2711 = call ptr @__remill_atomic_end(ptr %v2710)
  store ptr %v2711, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199893:                                       ; No predecessors!
  %v2712 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2712, ptr %PC, align 4
  %v2713 = add i32 %v2712, 1
  store i32 %v2713, ptr %NEXT_PC, align 4
  %v2714 = load ptr, ptr %MEMORY, align 4
  %v2715 = call ptr @__remill_atomic_begin(ptr %v2714)
  store ptr %v2715, ptr %MEMORY, align 4
  %v2716 = load i32, ptr %EBP, align 4
  %v2717 = load ptr, ptr %MEMORY, align 4
  %v2718 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2717, ptr %state, i32 %v2716)
  store ptr %v2718, ptr %MEMORY, align 4
  %v2719 = load ptr, ptr %MEMORY, align 4
  %v2720 = call ptr @__remill_atomic_end(ptr %v2719)
  store ptr %v2720, ptr %MEMORY, align 4
  store i32 %v2713, ptr %PC, align 4
  %v2721 = add i32 %v2713, 2
  store i32 %v2721, ptr %NEXT_PC, align 4
  %v2722 = load ptr, ptr %MEMORY, align 4
  %v2723 = call ptr @__remill_atomic_begin(ptr %v2722)
  store ptr %v2723, ptr %MEMORY, align 4
  %v2724 = load i32, ptr %ESP, align 4
  %v2725 = load ptr, ptr %MEMORY, align 4
  %v2726 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2725, ptr %state, ptr %EBP, i32 %v2724)
  store ptr %v2726, ptr %MEMORY, align 4
  %v2727 = load ptr, ptr %MEMORY, align 4
  %v2728 = call ptr @__remill_atomic_end(ptr %v2727)
  store ptr %v2728, ptr %MEMORY, align 4
  store i32 %v2721, ptr %PC, align 4
  %v2729 = add i32 %v2721, 3
  store i32 %v2729, ptr %NEXT_PC, align 4
  %v2730 = load ptr, ptr %MEMORY, align 4
  %v2731 = call ptr @__remill_atomic_begin(ptr %v2730)
  store ptr %v2731, ptr %MEMORY, align 4
  %v2732 = load i32, ptr %ESP, align 4
  %v2733 = load ptr, ptr %MEMORY, align 4
  %v2734 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2733, ptr %state, ptr %ESP, i32 %v2732, i32 40)
  store ptr %v2734, ptr %MEMORY, align 4
  %v2735 = load ptr, ptr %MEMORY, align 4
  %v2736 = call ptr @__remill_atomic_end(ptr %v2735)
  store ptr %v2736, ptr %MEMORY, align 4
  store i32 %v2729, ptr %PC, align 4
  %v2737 = add i32 %v2729, 7
  store i32 %v2737, ptr %NEXT_PC, align 4
  %v2738 = load ptr, ptr %MEMORY, align 4
  %v2739 = call ptr @__remill_atomic_begin(ptr %v2738)
  store ptr %v2739, ptr %MEMORY, align 4
  %v2740 = load i32, ptr %EBP, align 4
  %v2741 = load i32, ptr %SSBASE, align 4
  %v2742 = sub i32 %v2740, 12
  %v2743 = add i32 %v2742, %v2741
  %v2744 = load ptr, ptr %MEMORY, align 4
  %v2745 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2744, ptr %state, i32 %v2743, i32 0)
  store ptr %v2745, ptr %MEMORY, align 4
  %v2746 = load ptr, ptr %MEMORY, align 4
  %v2747 = call ptr @__remill_atomic_end(ptr %v2746)
  store ptr %v2747, ptr %MEMORY, align 4
  store i32 %v2737, ptr %PC, align 4
  %v2748 = add i32 %v2737, 5
  store i32 %v2748, ptr %NEXT_PC, align 4
  %v2749 = load ptr, ptr %MEMORY, align 4
  %v2750 = call ptr @__remill_atomic_begin(ptr %v2749)
  store ptr %v2750, ptr %MEMORY, align 4
  %v2751 = add i32 %v2748, 5139
  %v2752 = load ptr, ptr %MEMORY, align 4
  %v2753 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2752, ptr %state, i64 4205050, ptr %NEXT_PC, i32 %v2748, ptr %RETURN_PC)
  store ptr %v2753, ptr %MEMORY, align 4
  %v2754 = load ptr, ptr %MEMORY, align 4
  %v2755 = call ptr @__remill_atomic_end(ptr %v2754)
  store ptr %v2755, ptr %MEMORY, align 4
  store i32 %v2748, ptr %PC, align 4
  %v2756 = add i32 %v2748, 8
  store i32 %v2756, ptr %NEXT_PC, align 4
  %v2757 = load ptr, ptr %MEMORY, align 4
  %v2758 = call ptr @__remill_atomic_begin(ptr %v2757)
  store ptr %v2758, ptr %MEMORY, align 4
  %v2759 = load i32, ptr %ESP, align 4
  %v2760 = load i32, ptr %SSBASE, align 4
  %v2761 = add i32 %v2759, 4
  %v2762 = add i32 %v2761, %v2760
  %v2763 = load ptr, ptr %MEMORY, align 4
  %v2764 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2763, ptr %state, i32 %v2762, i32 4235264)
  store ptr %v2764, ptr %MEMORY, align 4
  %v2765 = load ptr, ptr %MEMORY, align 4
  %v2766 = call ptr @__remill_atomic_end(ptr %v2765)
  store ptr %v2766, ptr %MEMORY, align 4
  store i32 %v2756, ptr %PC, align 4
  %v2767 = add i32 %v2756, 3
  store i32 %v2767, ptr %NEXT_PC, align 4
  %v2768 = load ptr, ptr %MEMORY, align 4
  %v2769 = call ptr @__remill_atomic_begin(ptr %v2768)
  store ptr %v2769, ptr %MEMORY, align 4
  %v2770 = load i32, ptr %ESP, align 4
  %v2771 = load i32, ptr %SSBASE, align 4
  %v2772 = add i32 %v2770, %v2771
  %v2773 = load i32, ptr %EAX, align 4
  %v2774 = load ptr, ptr %MEMORY, align 4
  %v2775 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2774, ptr %state, i32 %v2772, i32 %v2773)
  store ptr %v2775, ptr %MEMORY, align 4
  %v2776 = load ptr, ptr %MEMORY, align 4
  %v2777 = call ptr @__remill_atomic_end(ptr %v2776)
  store ptr %v2777, ptr %MEMORY, align 4
  store i32 %v2767, ptr %PC, align 4
  %v2778 = add i32 %v2767, 5
  store i32 %v2778, ptr %NEXT_PC, align 4
  %v2779 = load ptr, ptr %MEMORY, align 4
  %v2780 = call ptr @__remill_atomic_begin(ptr %v2779)
  store ptr %v2780, ptr %MEMORY, align 4
  %v2781 = load i32, ptr %DSBASE, align 4
  %v2782 = add i32 4243816, %v2781
  %v2783 = load ptr, ptr %MEMORY, align 4
  %v2784 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2783, ptr %state, ptr %EAX, i32 %v2782)
  store ptr %v2784, ptr %MEMORY, align 4
  %v2785 = load ptr, ptr %MEMORY, align 4
  %v2786 = call ptr @__remill_atomic_end(ptr %v2785)
  store ptr %v2786, ptr %MEMORY, align 4
  store i32 %v2778, ptr %PC, align 4
  %v2787 = add i32 %v2778, 2
  store i32 %v2787, ptr %NEXT_PC, align 4
  %v2788 = load ptr, ptr %MEMORY, align 4
  %v2789 = call ptr @__remill_atomic_begin(ptr %v2788)
  store ptr %v2789, ptr %MEMORY, align 4
  %v2790 = load i32, ptr %EAX, align 4
  %v2791 = load ptr, ptr %MEMORY, align 4
  %v2792 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2791, ptr %state, i32 %v2790, ptr %NEXT_PC, i32 %v2787, ptr %RETURN_PC)
  store ptr %v2792, ptr %MEMORY, align 4
  %v2793 = load ptr, ptr %MEMORY, align 4
  %v2794 = call ptr @__remill_atomic_end(ptr %v2793)
  store ptr %v2794, ptr %MEMORY, align 4
  store i32 %v2787, ptr %PC, align 4
  %v2795 = add i32 %v2787, 3
  store i32 %v2795, ptr %NEXT_PC, align 4
  %v2796 = load ptr, ptr %MEMORY, align 4
  %v2797 = call ptr @__remill_atomic_begin(ptr %v2796)
  store ptr %v2797, ptr %MEMORY, align 4
  %v2798 = load i32, ptr %ESP, align 4
  %v2799 = load ptr, ptr %MEMORY, align 4
  %v2800 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2799, ptr %state, ptr %ESP, i32 %v2798, i32 8)
  store ptr %v2800, ptr %MEMORY, align 4
  %v2801 = load ptr, ptr %MEMORY, align 4
  %v2802 = call ptr @__remill_atomic_end(ptr %v2801)
  store ptr %v2802, ptr %MEMORY, align 4
  store i32 %v2795, ptr %PC, align 4
  %v2803 = add i32 %v2795, 3
  store i32 %v2803, ptr %NEXT_PC, align 4
  %v2804 = load ptr, ptr %MEMORY, align 4
  %v2805 = call ptr @__remill_atomic_begin(ptr %v2804)
  store ptr %v2805, ptr %MEMORY, align 4
  %v2806 = load i32, ptr %EBP, align 4
  %v2807 = load i32, ptr %SSBASE, align 4
  %v2808 = sub i32 %v2806, 12
  %v2809 = add i32 %v2808, %v2807
  %v2810 = load i32, ptr %EAX, align 4
  %v2811 = load ptr, ptr %MEMORY, align 4
  %v2812 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2811, ptr %state, i32 %v2809, i32 %v2810)
  store ptr %v2812, ptr %MEMORY, align 4
  %v2813 = load ptr, ptr %MEMORY, align 4
  %v2814 = call ptr @__remill_atomic_end(ptr %v2813)
  store ptr %v2814, ptr %MEMORY, align 4
  store i32 %v2803, ptr %PC, align 4
  %v2815 = add i32 %v2803, 4
  store i32 %v2815, ptr %NEXT_PC, align 4
  %v2816 = load ptr, ptr %MEMORY, align 4
  %v2817 = call ptr @__remill_atomic_begin(ptr %v2816)
  store ptr %v2817, ptr %MEMORY, align 4
  %v2818 = load i32, ptr %EBP, align 4
  %v2819 = load i32, ptr %SSBASE, align 4
  %v2820 = sub i32 %v2818, 12
  %v2821 = add i32 %v2820, %v2819
  %v2822 = load ptr, ptr %MEMORY, align 4
  %v2823 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2822, ptr %state, i32 %v2821, i32 0)
  store ptr %v2823, ptr %MEMORY, align 4
  %v2824 = load ptr, ptr %MEMORY, align 4
  %v2825 = call ptr @__remill_atomic_end(ptr %v2824)
  store ptr %v2825, ptr %MEMORY, align 4
  store i32 %v2815, ptr %PC, align 4
  %v2826 = add i32 %v2815, 2
  store i32 %v2826, ptr %NEXT_PC, align 4
  %v2827 = load ptr, ptr %MEMORY, align 4
  %v2828 = call ptr @__remill_atomic_begin(ptr %v2827)
  store ptr %v2828, ptr %MEMORY, align 4
  %v2829 = add i32 %v2826, 12
  %v2830 = load ptr, ptr %MEMORY, align 4
  %v2831 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2830, ptr %state, ptr %BRANCH_TAKEN, i32 %v2829, i32 %v2826, ptr %NEXT_PC)
  store ptr %v2831, ptr %MEMORY, align 4
  %v2832 = load ptr, ptr %MEMORY, align 4
  %v2833 = call ptr @__remill_atomic_end(ptr %v2832)
  store ptr %v2833, ptr %MEMORY, align 4
  br i1 true, label %bb_4199953, label %bb_4199941

bb_4199941:                                       ; preds = %bb_4199893
  store i32 %v2826, ptr %PC, align 4
  %v2834 = add i32 %v2826, 7
  store i32 %v2834, ptr %NEXT_PC, align 4
  %v2835 = load ptr, ptr %MEMORY, align 4
  %v2836 = call ptr @__remill_atomic_begin(ptr %v2835)
  store ptr %v2836, ptr %MEMORY, align 4
  %v2837 = load i32, ptr %ESP, align 4
  %v2838 = load i32, ptr %SSBASE, align 4
  %v2839 = add i32 %v2837, %v2838
  %v2840 = load ptr, ptr %MEMORY, align 4
  %v2841 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2840, ptr %state, i32 %v2839, i32 4199888)
  store ptr %v2841, ptr %MEMORY, align 4
  %v2842 = load ptr, ptr %MEMORY, align 4
  %v2843 = call ptr @__remill_atomic_end(ptr %v2842)
  store ptr %v2843, ptr %MEMORY, align 4
  store i32 %v2834, ptr %PC, align 4
  %v2844 = add i32 %v2834, 3
  store i32 %v2844, ptr %NEXT_PC, align 4
  %v2845 = load ptr, ptr %MEMORY, align 4
  %v2846 = call ptr @__remill_atomic_begin(ptr %v2845)
  store ptr %v2846, ptr %MEMORY, align 4
  %v2847 = load i32, ptr %EBP, align 4
  %v2848 = load i32, ptr %SSBASE, align 4
  %v2849 = sub i32 %v2847, 12
  %v2850 = add i32 %v2849, %v2848
  %v2851 = load ptr, ptr %MEMORY, align 4
  %v2852 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2851, ptr %state, ptr %EAX, i32 %v2850)
  store ptr %v2852, ptr %MEMORY, align 4
  %v2853 = load ptr, ptr %MEMORY, align 4
  %v2854 = call ptr @__remill_atomic_end(ptr %v2853)
  store ptr %v2854, ptr %MEMORY, align 4
  store i32 %v2844, ptr %PC, align 4
  %v2855 = add i32 %v2844, 2
  store i32 %v2855, ptr %NEXT_PC, align 4
  %v2856 = load ptr, ptr %MEMORY, align 4
  %v2857 = call ptr @__remill_atomic_begin(ptr %v2856)
  store ptr %v2857, ptr %MEMORY, align 4
  %v2858 = load i32, ptr %EAX, align 4
  %v2859 = load ptr, ptr %MEMORY, align 4
  %v2860 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2859, ptr %state, i32 %v2858, ptr %NEXT_PC, i32 %v2855, ptr %RETURN_PC)
  store ptr %v2860, ptr %MEMORY, align 4
  %v2861 = load ptr, ptr %MEMORY, align 4
  %v2862 = call ptr @__remill_atomic_end(ptr %v2861)
  store ptr %v2862, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199953:                                       ; preds = %bb_4199893
  store i32 %v2826, ptr %PC, align 4
  %v2863 = add i32 %v2826, 1
  store i32 %v2863, ptr %NEXT_PC, align 4
  %v2864 = load ptr, ptr %MEMORY, align 4
  %v2865 = call ptr @__remill_atomic_begin(ptr %v2864)
  store ptr %v2865, ptr %MEMORY, align 4
  %v2866 = load ptr, ptr %MEMORY, align 4
  %v2867 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v2866, ptr %state)
  store ptr %v2867, ptr %MEMORY, align 4
  %v2868 = load ptr, ptr %MEMORY, align 4
  %v2869 = call ptr @__remill_atomic_end(ptr %v2868)
  store ptr %v2869, ptr %MEMORY, align 4
  store i32 %v2863, ptr %PC, align 4
  %v2870 = add i32 %v2863, 1
  store i32 %v2870, ptr %NEXT_PC, align 4
  %v2871 = load ptr, ptr %MEMORY, align 4
  %v2872 = call ptr @__remill_atomic_begin(ptr %v2871)
  store ptr %v2872, ptr %MEMORY, align 4
  %v2873 = load ptr, ptr %MEMORY, align 4
  %v2874 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2873, ptr %state, ptr %NEXT_PC)
  store ptr %v2874, ptr %MEMORY, align 4
  %v2875 = load ptr, ptr %MEMORY, align 4
  %v2876 = call ptr @__remill_atomic_end(ptr %v2875)
  store ptr %v2876, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199955:                                       ; No predecessors!
  %v2877 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2877, ptr %PC, align 4
  %v2878 = add i32 %v2877, 1
  store i32 %v2878, ptr %NEXT_PC, align 4
  %v2879 = load ptr, ptr %MEMORY, align 4
  %v2880 = call ptr @__remill_atomic_begin(ptr %v2879)
  store ptr %v2880, ptr %MEMORY, align 4
  %v2881 = load ptr, ptr %MEMORY, align 4
  %v2882 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2881, ptr %state)
  store ptr %v2882, ptr %MEMORY, align 4
  %v2883 = load ptr, ptr %MEMORY, align 4
  %v2884 = call ptr @__remill_atomic_end(ptr %v2883)
  store ptr %v2884, ptr %MEMORY, align 4
  store i32 %v2878, ptr %PC, align 4
  %v2885 = add i32 %v2878, 2
  store i32 %v2885, ptr %NEXT_PC, align 4
  %v2886 = load ptr, ptr %MEMORY, align 4
  %v2887 = call ptr @__remill_atomic_begin(ptr %v2886)
  store ptr %v2887, ptr %MEMORY, align 4
  %v2888 = load ptr, ptr %MEMORY, align 4
  %v2889 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2888, ptr %state)
  store ptr %v2889, ptr %MEMORY, align 4
  %v2890 = load ptr, ptr %MEMORY, align 4
  %v2891 = call ptr @__remill_atomic_end(ptr %v2890)
  store ptr %v2891, ptr %MEMORY, align 4
  store i32 %v2885, ptr %PC, align 4
  %v2892 = add i32 %v2885, 2
  store i32 %v2892, ptr %NEXT_PC, align 4
  %v2893 = load ptr, ptr %MEMORY, align 4
  %v2894 = call ptr @__remill_atomic_begin(ptr %v2893)
  store ptr %v2894, ptr %MEMORY, align 4
  %v2895 = load ptr, ptr %MEMORY, align 4
  %v2896 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2895, ptr %state)
  store ptr %v2896, ptr %MEMORY, align 4
  %v2897 = load ptr, ptr %MEMORY, align 4
  %v2898 = call ptr @__remill_atomic_end(ptr %v2897)
  store ptr %v2898, ptr %MEMORY, align 4
  store i32 %v2892, ptr %PC, align 4
  %v2899 = add i32 %v2892, 2
  store i32 %v2899, ptr %NEXT_PC, align 4
  %v2900 = load ptr, ptr %MEMORY, align 4
  %v2901 = call ptr @__remill_atomic_begin(ptr %v2900)
  store ptr %v2901, ptr %MEMORY, align 4
  %v2902 = load ptr, ptr %MEMORY, align 4
  %v2903 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2902, ptr %state)
  store ptr %v2903, ptr %MEMORY, align 4
  %v2904 = load ptr, ptr %MEMORY, align 4
  %v2905 = call ptr @__remill_atomic_end(ptr %v2904)
  store ptr %v2905, ptr %MEMORY, align 4
  store i32 %v2899, ptr %PC, align 4
  %v2906 = add i32 %v2899, 2
  store i32 %v2906, ptr %NEXT_PC, align 4
  %v2907 = load ptr, ptr %MEMORY, align 4
  %v2908 = call ptr @__remill_atomic_begin(ptr %v2907)
  store ptr %v2908, ptr %MEMORY, align 4
  %v2909 = load ptr, ptr %MEMORY, align 4
  %v2910 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2909, ptr %state)
  store ptr %v2910, ptr %MEMORY, align 4
  %v2911 = load ptr, ptr %MEMORY, align 4
  %v2912 = call ptr @__remill_atomic_end(ptr %v2911)
  store ptr %v2912, ptr %MEMORY, align 4
  store i32 %v2906, ptr %PC, align 4
  %v2913 = add i32 %v2906, 2
  store i32 %v2913, ptr %NEXT_PC, align 4
  %v2914 = load ptr, ptr %MEMORY, align 4
  %v2915 = call ptr @__remill_atomic_begin(ptr %v2914)
  store ptr %v2915, ptr %MEMORY, align 4
  %v2916 = load ptr, ptr %MEMORY, align 4
  %v2917 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2916, ptr %state)
  store ptr %v2917, ptr %MEMORY, align 4
  %v2918 = load ptr, ptr %MEMORY, align 4
  %v2919 = call ptr @__remill_atomic_end(ptr %v2918)
  store ptr %v2919, ptr %MEMORY, align 4
  store i32 %v2913, ptr %PC, align 4
  %v2920 = add i32 %v2913, 2
  store i32 %v2920, ptr %NEXT_PC, align 4
  %v2921 = load ptr, ptr %MEMORY, align 4
  %v2922 = call ptr @__remill_atomic_begin(ptr %v2921)
  store ptr %v2922, ptr %MEMORY, align 4
  %v2923 = load ptr, ptr %MEMORY, align 4
  %v2924 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2923, ptr %state)
  store ptr %v2924, ptr %MEMORY, align 4
  %v2925 = load ptr, ptr %MEMORY, align 4
  %v2926 = call ptr @__remill_atomic_end(ptr %v2925)
  store ptr %v2926, ptr %MEMORY, align 4
  store i32 %v2920, ptr %PC, align 4
  %v2927 = add i32 %v2920, 2
  store i32 %v2927, ptr %NEXT_PC, align 4
  %v2928 = load ptr, ptr %MEMORY, align 4
  %v2929 = call ptr @__remill_atomic_begin(ptr %v2928)
  store ptr %v2929, ptr %MEMORY, align 4
  %v2930 = load i32, ptr %EBP, align 4
  %v2931 = load i32, ptr %EDX, align 4
  %v2932 = load ptr, ptr %MEMORY, align 4
  %v2933 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2932, ptr %state, ptr %EBP, i32 %v2930, i32 %v2931)
  store ptr %v2933, ptr %MEMORY, align 4
  %v2934 = load ptr, ptr %MEMORY, align 4
  %v2935 = call ptr @__remill_atomic_end(ptr %v2934)
  store ptr %v2935, ptr %MEMORY, align 4
  store i32 %v2927, ptr %PC, align 4
  %v2936 = add i32 %v2927, 5
  store i32 %v2936, ptr %NEXT_PC, align 4
  %v2937 = load ptr, ptr %MEMORY, align 4
  %v2938 = call ptr @__remill_atomic_begin(ptr %v2937)
  store ptr %v2938, ptr %MEMORY, align 4
  %v2939 = load ptr, ptr %MEMORY, align 4
  %v2940 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2939, ptr %state, ptr %ECX, i32 -1905419155)
  store ptr %v2940, ptr %MEMORY, align 4
  %v2941 = load ptr, ptr %MEMORY, align 4
  %v2942 = call ptr @__remill_atomic_end(ptr %v2941)
  store ptr %v2942, ptr %MEMORY, align 4
  store i32 %v2936, ptr %PC, align 4
  %v2943 = add i32 %v2936, 2
  store i32 %v2943, ptr %NEXT_PC, align 4
  %v2944 = load ptr, ptr %MEMORY, align 4
  %v2945 = call ptr @__remill_atomic_begin(ptr %v2944)
  store ptr %v2945, ptr %MEMORY, align 4
  %v2946 = load i8, ptr %CH, align 1
  %v2947 = zext i8 %v2946 to i32
  %v2948 = load i8, ptr %BH, align 1
  %v2949 = zext i8 %v2948 to i32
  %v2950 = load ptr, ptr %MEMORY, align 4
  %v2951 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2950, ptr %state, i32 %v2947, i32 %v2949)
  store ptr %v2951, ptr %MEMORY, align 4
  %v2952 = load ptr, ptr %MEMORY, align 4
  %v2953 = call ptr @__remill_atomic_end(ptr %v2952)
  store ptr %v2953, ptr %MEMORY, align 4
  store i32 %v2943, ptr %PC, align 4
  %v2954 = add i32 %v2943, 1
  store i32 %v2954, ptr %NEXT_PC, align 4
  %v2955 = load ptr, ptr %MEMORY, align 4
  %v2956 = call ptr @__remill_atomic_begin(ptr %v2955)
  store ptr %v2956, ptr %MEMORY, align 4
  %v2957 = load ptr, ptr %MEMORY, align 4
  %v2958 = call ptr @_ZN12_GLOBAL__N_117HandleUnsupportedEP6MemoryR5State(ptr %v2957, ptr %state)
  store ptr %v2958, ptr %MEMORY, align 4
  %v2959 = load ptr, ptr %MEMORY, align 4
  %v2960 = call ptr @__remill_atomic_end(ptr %v2959)
  store ptr %v2960, ptr %MEMORY, align 4
  ret ptr %memory
}

attributes #0 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #5 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #6 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #7 = { mustprogress noduplicate noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"NumRegisterParameters", i32 0}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{!"base.helper.semantics"}
!7 = !{[3 x i8] c"BH\00"}
!8 = !{[3 x i8] c"CH\00"}
!9 = !{[4 x i8] c"ECX\00"}
!10 = !{[3 x i8] c"AX\00"}
!11 = !{[3 x i8] c"AL\00"}
!12 = !{[7 x i8] c"DSBASE\00"}
!13 = !{[4 x i8] c"EDX\00"}
!14 = !{[4 x i8] c"EAX\00"}
!15 = !{[7 x i8] c"SSBASE\00"}
!16 = !{[4 x i8] c"EBX\00"}
!17 = !{[4 x i8] c"ESP\00"}
!18 = !{[4 x i8] c"EBP\00"}
!19 = !{[3 x i8] c"PC\00"}
