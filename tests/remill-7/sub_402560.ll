; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: debugme.exe
; Address: 0x00402560
; Size: 4500 bytes
; Architecture: x86
; Generated: 2026-03-12T19:05:35.497Z
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

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i8 @__remill_read_memory_8(ptr noundef, i32 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_write_memory_8(ptr noundef, i32 noundef, i8 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_carry(i1 noundef zeroext, ...) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare !remill.function.type !6 i8 @llvm.ctpop.i8(i8) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_zero(i1 noundef zeroext, ...) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_sign(i1 noundef zeroext, ...) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_flag_computation_overflow(i1 noundef zeroext, ...) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i16 @__remill_read_memory_16(ptr noundef, i32 noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local i32 @__remill_read_memory_32(ptr noundef, i32 noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_write_memory_32(ptr noundef, i32 noundef, i32 noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnItLb1EE2InItEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i8 @__remill_undefined_8() #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_17IMULeaxI2RnIjLb1EEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_error(ptr noundef nonnull align 16 dereferenceable(3504), i32 noundef, ptr noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr noundef, ptr noundef nonnull align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13NEGI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADCI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_17RET_IMMEP6MemoryR5State2InItE3RnWIjE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_ule(i1 noundef zeroext) #4

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_sle(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_sgt(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_neq(i1 noundef zeroext) #0

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_sge(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16CMOVNLI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture, i32) #2

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_uge(i1 noundef zeroext) #4

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15CMOVSI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture, i32) #3

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_ult(i1 noundef zeroext) #4

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_ugt(i1 noundef zeroext) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14JNLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWIjE2RnIhLb1EEiEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13NOTI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnItLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #5

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare !remill.function.type !6 void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare !remill.function.type !6 void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #6

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16) #7

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare !remill.function.type !6 i32 @llvm.fshr.i32(i32, i32, i32) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_111CMPXCHG_EAXI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, i32, i32) #2

declare !remill.function.type !6 dso_local ptr @__remill_compare_exchange_memory_32(ptr noundef, i32 noundef, ptr noundef nonnull align 4 dereferenceable(4), i32 noundef) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SARI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14SHRDI3RnWIjE2RnIjLb1EES4_S4_EEP6MemoryS6_R5StateT_T0_T1_T2_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, i32) #2

declare !remill.function.type !6 dso_local void @__remill_fpu_set_rounding(i32 noundef) #4

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, ptr nocapture writeonly) #5

declare !remill.function.type !6 dso_local void @__remill_fpu_exception_clear(i32 noundef) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18DoFNINITEP6MemoryR5State(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504)) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_atomic_begin(ptr noundef) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_atomic_end(ptr noundef) #0

define ptr @lifted_4203872(ptr noalias %state, i32 %program_counter, ptr noalias %memory) {
bb_0:
  %v1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0
  %DH = getelementptr i8, ptr %v1, i32 1, !remill_register !7
  %CL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !8
  %ESI = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 9, i32 0, i32 0, !remill_register !9
  %DL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !10
  %FSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 7, i32 0, i32 0, !remill_register !11
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !12
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !13
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !14
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !15
  %AX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !16
  %SSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 1, i32 0, i32 0, !remill_register !17
  %DSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 9, i32 0, i32 0, !remill_register !18
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !19
  %ESP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !20
  %EBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !21
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
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !22
  store i32 %program_counter, ptr %PC, align 4
  %v2 = add i32 %program_counter, 1
  store i32 %v2, ptr %NEXT_PC, align 4
  %v3 = load i32, ptr %EBP, align 4
  %v4 = load ptr, ptr %MEMORY, align 4
  %v5 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4, ptr %state, i32 %v3)
  store ptr %v5, ptr %MEMORY, align 4
  store i32 %v2, ptr %PC, align 4
  %v6 = add i32 %v2, 2
  store i32 %v6, ptr %NEXT_PC, align 4
  %v7 = load i32, ptr %ESP, align 4
  %v8 = load ptr, ptr %MEMORY, align 4
  %v9 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8, ptr %state, ptr %EBP, i32 %v7)
  store ptr %v9, ptr %MEMORY, align 4
  store i32 %v6, ptr %PC, align 4
  %v10 = add i32 %v6, 2
  store i32 %v10, ptr %NEXT_PC, align 4
  %v11 = load ptr, ptr %MEMORY, align 4
  %v12 = call ptr @_ZN12_GLOBAL__N_18DoFNINITEP6MemoryR5State(ptr %v11, ptr %state)
  store ptr %v12, ptr %MEMORY, align 4
  store i32 %v10, ptr %PC, align 4
  %v13 = add i32 %v10, 1
  store i32 %v13, ptr %NEXT_PC, align 4
  %v14 = load ptr, ptr %MEMORY, align 4
  %v15 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v14, ptr %state, ptr %EBP)
  store ptr %v15, ptr %MEMORY, align 4
  store i32 %v13, ptr %PC, align 4
  %v16 = add i32 %v13, 1
  store i32 %v16, ptr %NEXT_PC, align 4
  %v17 = load ptr, ptr %MEMORY, align 4
  %v18 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v17, ptr %state, ptr %NEXT_PC)
  store ptr %v18, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203879:                                       ; No predecessors!
  %v19 = load i32, ptr %NEXT_PC, align 4
  store i32 %v19, ptr %PC, align 4
  %v20 = add i32 %v19, 1
  store i32 %v20, ptr %NEXT_PC, align 4
  %v21 = load ptr, ptr %MEMORY, align 4
  %v22 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v21, ptr %state)
  store ptr %v22, ptr %MEMORY, align 4
  store i32 %v20, ptr %PC, align 4
  %v23 = add i32 %v20, 1
  store i32 %v23, ptr %NEXT_PC, align 4
  %v24 = load i32, ptr %EBP, align 4
  %v25 = load ptr, ptr %MEMORY, align 4
  %v26 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v25, ptr %state, i32 %v24)
  store ptr %v26, ptr %MEMORY, align 4
  store i32 %v23, ptr %PC, align 4
  %v27 = add i32 %v23, 2
  store i32 %v27, ptr %NEXT_PC, align 4
  %v28 = load i32, ptr %ESP, align 4
  %v29 = load ptr, ptr %MEMORY, align 4
  %v30 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v29, ptr %state, ptr %EBP, i32 %v28)
  store ptr %v30, ptr %MEMORY, align 4
  store i32 %v27, ptr %PC, align 4
  %v31 = add i32 %v27, 3
  store i32 %v31, ptr %NEXT_PC, align 4
  %v32 = load i32, ptr %ESP, align 4
  %v33 = load ptr, ptr %MEMORY, align 4
  %v34 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v33, ptr %state, ptr %ESP, i32 %v32, i32 8)
  store ptr %v34, ptr %MEMORY, align 4
  store i32 %v31, ptr %PC, align 4
  %v35 = add i32 %v31, 2
  store i32 %v35, ptr %NEXT_PC, align 4
  %v36 = add i32 %v35, 22
  %v37 = load ptr, ptr %MEMORY, align 4
  %v38 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v37, ptr %state, i32 %v36, ptr %NEXT_PC)
  store ptr %v38, ptr %MEMORY, align 4
  br label %bb_4203910

bb_4203888:                                       ; preds = %bb_4203910
  store i32 %v86, ptr %PC, align 4
  %v39 = add i32 %v86, 5
  store i32 %v39, ptr %NEXT_PC, align 4
  %v40 = load i32, ptr %DSBASE, align 4
  %v41 = add i32 4231408, %v40
  %v42 = load ptr, ptr %MEMORY, align 4
  %v43 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v42, ptr %state, ptr %EAX, i32 %v41)
  store ptr %v43, ptr %MEMORY, align 4
  store i32 %v39, ptr %PC, align 4
  %v44 = add i32 %v39, 2
  store i32 %v44, ptr %NEXT_PC, align 4
  %v45 = load i32, ptr %EAX, align 4
  %v46 = load i32, ptr %DSBASE, align 4
  %v47 = add i32 %v45, %v46
  %v48 = load ptr, ptr %MEMORY, align 4
  %v49 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v48, ptr %state, ptr %EAX, i32 %v47)
  store ptr %v49, ptr %MEMORY, align 4
  store i32 %v44, ptr %PC, align 4
  %v50 = add i32 %v44, 2
  store i32 %v50, ptr %NEXT_PC, align 4
  %v51 = load i32, ptr %EAX, align 4
  %v52 = load ptr, ptr %MEMORY, align 4
  %v53 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v52, ptr %state, i32 %v51, ptr %NEXT_PC, i32 %v50, ptr %RETURN_PC)
  store ptr %v53, ptr %MEMORY, align 4
  store i32 %v50, ptr %PC, align 4
  %v54 = add i32 %v50, 5
  store i32 %v54, ptr %NEXT_PC, align 4
  %v55 = load i32, ptr %DSBASE, align 4
  %v56 = add i32 4231408, %v55
  %v57 = load ptr, ptr %MEMORY, align 4
  %v58 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v57, ptr %state, ptr %EAX, i32 %v56)
  store ptr %v58, ptr %MEMORY, align 4
  store i32 %v54, ptr %PC, align 4
  %v59 = add i32 %v54, 3
  store i32 %v59, ptr %NEXT_PC, align 4
  %v60 = load i32, ptr %EAX, align 4
  %v61 = load ptr, ptr %MEMORY, align 4
  %v62 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v61, ptr %state, ptr %EAX, i32 %v60, i32 4)
  store ptr %v62, ptr %MEMORY, align 4
  store i32 %v59, ptr %PC, align 4
  %v63 = add i32 %v59, 5
  store i32 %v63, ptr %NEXT_PC, align 4
  %v64 = load i32, ptr %DSBASE, align 4
  %v65 = add i32 4231408, %v64
  %v66 = load i32, ptr %EAX, align 4
  %v67 = load ptr, ptr %MEMORY, align 4
  %v68 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v67, ptr %state, i32 %v65, i32 %v66)
  store ptr %v68, ptr %MEMORY, align 4
  br label %bb_4203910

bb_4203910:                                       ; preds = %bb_4203888, %bb_4203879
  %v69 = load i32, ptr %NEXT_PC, align 4
  store i32 %v69, ptr %PC, align 4
  %v70 = add i32 %v69, 5
  store i32 %v70, ptr %NEXT_PC, align 4
  %v71 = load i32, ptr %DSBASE, align 4
  %v72 = add i32 4231408, %v71
  %v73 = load ptr, ptr %MEMORY, align 4
  %v74 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v73, ptr %state, ptr %EAX, i32 %v72)
  store ptr %v74, ptr %MEMORY, align 4
  store i32 %v70, ptr %PC, align 4
  %v75 = add i32 %v70, 2
  store i32 %v75, ptr %NEXT_PC, align 4
  %v76 = load i32, ptr %EAX, align 4
  %v77 = load i32, ptr %DSBASE, align 4
  %v78 = add i32 %v76, %v77
  %v79 = load ptr, ptr %MEMORY, align 4
  %v80 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v79, ptr %state, ptr %EAX, i32 %v78)
  store ptr %v80, ptr %MEMORY, align 4
  store i32 %v75, ptr %PC, align 4
  %v81 = add i32 %v75, 2
  store i32 %v81, ptr %NEXT_PC, align 4
  %v82 = load i32, ptr %EAX, align 4
  %v83 = load i32, ptr %EAX, align 4
  %v84 = load ptr, ptr %MEMORY, align 4
  %v85 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v84, ptr %state, i32 %v82, i32 %v83)
  store ptr %v85, ptr %MEMORY, align 4
  store i32 %v81, ptr %PC, align 4
  %v86 = add i32 %v81, 2
  store i32 %v86, ptr %NEXT_PC, align 4
  %v87 = sub i32 %v86, 33
  %v88 = load ptr, ptr %MEMORY, align 4
  %v89 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v88, ptr %state, ptr %BRANCH_TAKEN, i32 %v87, i32 %v86, ptr %NEXT_PC)
  store ptr %v89, ptr %MEMORY, align 4
  br i1 true, label %bb_4203888, label %bb_4203921

bb_4203921:                                       ; preds = %bb_4203910
  store i32 %v86, ptr %PC, align 4
  %v90 = add i32 %v86, 1
  store i32 %v90, ptr %NEXT_PC, align 4
  %v91 = load ptr, ptr %MEMORY, align 4
  %v92 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v91, ptr %state)
  store ptr %v92, ptr %MEMORY, align 4
  store i32 %v90, ptr %PC, align 4
  %v93 = add i32 %v90, 1
  store i32 %v93, ptr %NEXT_PC, align 4
  %v94 = load ptr, ptr %MEMORY, align 4
  %v95 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v94, ptr %state, ptr %NEXT_PC)
  store ptr %v95, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203923:                                       ; No predecessors!
  %v96 = load i32, ptr %NEXT_PC, align 4
  store i32 %v96, ptr %PC, align 4
  %v97 = add i32 %v96, 1
  store i32 %v97, ptr %NEXT_PC, align 4
  %v98 = load i32, ptr %EBP, align 4
  %v99 = load ptr, ptr %MEMORY, align 4
  %v100 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v99, ptr %state, i32 %v98)
  store ptr %v100, ptr %MEMORY, align 4
  store i32 %v97, ptr %PC, align 4
  %v101 = add i32 %v97, 2
  store i32 %v101, ptr %NEXT_PC, align 4
  %v102 = load i32, ptr %ESP, align 4
  %v103 = load ptr, ptr %MEMORY, align 4
  %v104 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v103, ptr %state, ptr %EBP, i32 %v102)
  store ptr %v104, ptr %MEMORY, align 4
  store i32 %v101, ptr %PC, align 4
  %v105 = add i32 %v101, 3
  store i32 %v105, ptr %NEXT_PC, align 4
  %v106 = load i32, ptr %ESP, align 4
  %v107 = load ptr, ptr %MEMORY, align 4
  %v108 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v107, ptr %state, ptr %ESP, i32 %v106, i32 40)
  store ptr %v108, ptr %MEMORY, align 4
  store i32 %v105, ptr %PC, align 4
  %v109 = add i32 %v105, 5
  store i32 %v109, ptr %NEXT_PC, align 4
  %v110 = load i32, ptr %DSBASE, align 4
  %v111 = add i32 4229344, %v110
  %v112 = load ptr, ptr %MEMORY, align 4
  %v113 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v112, ptr %state, ptr %EAX, i32 %v111)
  store ptr %v113, ptr %MEMORY, align 4
  store i32 %v109, ptr %PC, align 4
  %v114 = add i32 %v109, 3
  store i32 %v114, ptr %NEXT_PC, align 4
  %v115 = load i32, ptr %EBP, align 4
  %v116 = load i32, ptr %SSBASE, align 4
  %v117 = sub i32 %v115, 12
  %v118 = add i32 %v117, %v116
  %v119 = load i32, ptr %EAX, align 4
  %v120 = load ptr, ptr %MEMORY, align 4
  %v121 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v120, ptr %state, i32 %v118, i32 %v119)
  store ptr %v121, ptr %MEMORY, align 4
  store i32 %v114, ptr %PC, align 4
  %v122 = add i32 %v114, 4
  store i32 %v122, ptr %NEXT_PC, align 4
  %v123 = load i32, ptr %EBP, align 4
  %v124 = load i32, ptr %SSBASE, align 4
  %v125 = sub i32 %v123, 12
  %v126 = add i32 %v125, %v124
  %v127 = load ptr, ptr %MEMORY, align 4
  %v128 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v127, ptr %state, i32 %v126, i32 -1)
  store ptr %v128, ptr %MEMORY, align 4
  store i32 %v122, ptr %PC, align 4
  %v129 = add i32 %v122, 2
  store i32 %v129, ptr %NEXT_PC, align 4
  %v130 = add i32 %v129, 30
  %v131 = load ptr, ptr %MEMORY, align 4
  %v132 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v131, ptr %state, ptr %BRANCH_TAKEN, i32 %v130, i32 %v129, ptr %NEXT_PC)
  store ptr %v132, ptr %MEMORY, align 4
  br i1 true, label %bb_4203973, label %bb_4203943

bb_4203943:                                       ; preds = %bb_4203923
  store i32 %v129, ptr %PC, align 4
  %v133 = add i32 %v129, 7
  store i32 %v133, ptr %NEXT_PC, align 4
  %v134 = load i32, ptr %EBP, align 4
  %v135 = load i32, ptr %SSBASE, align 4
  %v136 = sub i32 %v134, 12
  %v137 = add i32 %v136, %v135
  %v138 = load ptr, ptr %MEMORY, align 4
  %v139 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v138, ptr %state, i32 %v137, i32 0)
  store ptr %v139, ptr %MEMORY, align 4
  store i32 %v133, ptr %PC, align 4
  %v140 = add i32 %v133, 2
  store i32 %v140, ptr %NEXT_PC, align 4
  %v141 = add i32 %v140, 4
  %v142 = load ptr, ptr %MEMORY, align 4
  %v143 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v142, ptr %state, i32 %v141, ptr %NEXT_PC)
  store ptr %v143, ptr %MEMORY, align 4
  br label %bb_4203956

bb_4203952:                                       ; preds = %bb_4203956
  store i32 %v181, ptr %PC, align 4
  %v144 = add i32 %v181, 4
  store i32 %v144, ptr %NEXT_PC, align 4
  %v145 = load i32, ptr %EBP, align 4
  %v146 = load i32, ptr %SSBASE, align 4
  %v147 = sub i32 %v145, 12
  %v148 = add i32 %v147, %v146
  %v149 = load i32, ptr %EBP, align 4
  %v150 = load i32, ptr %SSBASE, align 4
  %v151 = sub i32 %v149, 12
  %v152 = add i32 %v151, %v150
  %v153 = load ptr, ptr %MEMORY, align 4
  %v154 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v153, ptr %state, i32 %v148, i32 %v152, i32 1)
  store ptr %v154, ptr %MEMORY, align 4
  br label %bb_4203956

bb_4203956:                                       ; preds = %bb_4203952, %bb_4203943
  %v155 = load i32, ptr %NEXT_PC, align 4
  store i32 %v155, ptr %PC, align 4
  %v156 = add i32 %v155, 3
  store i32 %v156, ptr %NEXT_PC, align 4
  %v157 = load i32, ptr %EBP, align 4
  %v158 = load i32, ptr %SSBASE, align 4
  %v159 = sub i32 %v157, 12
  %v160 = add i32 %v159, %v158
  %v161 = load ptr, ptr %MEMORY, align 4
  %v162 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v161, ptr %state, ptr %EAX, i32 %v160)
  store ptr %v162, ptr %MEMORY, align 4
  store i32 %v156, ptr %PC, align 4
  %v163 = add i32 %v156, 3
  store i32 %v163, ptr %NEXT_PC, align 4
  %v164 = load i32, ptr %EAX, align 4
  %v165 = load ptr, ptr %MEMORY, align 4
  %v166 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v165, ptr %state, ptr %EAX, i32 %v164, i32 1)
  store ptr %v166, ptr %MEMORY, align 4
  store i32 %v163, ptr %PC, align 4
  %v167 = add i32 %v163, 7
  store i32 %v167, ptr %NEXT_PC, align 4
  %v168 = load i32, ptr %EAX, align 4
  %v169 = load i32, ptr %DSBASE, align 4
  %v170 = mul i32 %v168, 4
  %v171 = add i32 0, %v170
  %v172 = add i32 %v171, 4229344
  %v173 = add i32 %v172, %v169
  %v174 = load ptr, ptr %MEMORY, align 4
  %v175 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v174, ptr %state, ptr %EAX, i32 %v173)
  store ptr %v175, ptr %MEMORY, align 4
  store i32 %v167, ptr %PC, align 4
  %v176 = add i32 %v167, 2
  store i32 %v176, ptr %NEXT_PC, align 4
  %v177 = load i32, ptr %EAX, align 4
  %v178 = load i32, ptr %EAX, align 4
  %v179 = load ptr, ptr %MEMORY, align 4
  %v180 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v179, ptr %state, i32 %v177, i32 %v178)
  store ptr %v180, ptr %MEMORY, align 4
  store i32 %v176, ptr %PC, align 4
  %v181 = add i32 %v176, 2
  store i32 %v181, ptr %NEXT_PC, align 4
  %v182 = sub i32 %v181, 21
  %v183 = load ptr, ptr %MEMORY, align 4
  %v184 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v183, ptr %state, ptr %BRANCH_TAKEN, i32 %v182, i32 %v181, ptr %NEXT_PC)
  store ptr %v184, ptr %MEMORY, align 4
  br i1 true, label %bb_4203952, label %bb_4203973

bb_4203973:                                       ; preds = %bb_4203956, %bb_4203923
  %v185 = load i32, ptr %NEXT_PC, align 4
  store i32 %v185, ptr %PC, align 4
  %v186 = add i32 %v185, 3
  store i32 %v186, ptr %NEXT_PC, align 4
  %v187 = load i32, ptr %EBP, align 4
  %v188 = load i32, ptr %SSBASE, align 4
  %v189 = sub i32 %v187, 12
  %v190 = add i32 %v189, %v188
  %v191 = load ptr, ptr %MEMORY, align 4
  %v192 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v191, ptr %state, ptr %EAX, i32 %v190)
  store ptr %v192, ptr %MEMORY, align 4
  store i32 %v186, ptr %PC, align 4
  %v193 = add i32 %v186, 3
  store i32 %v193, ptr %NEXT_PC, align 4
  %v194 = load i32, ptr %EBP, align 4
  %v195 = load i32, ptr %SSBASE, align 4
  %v196 = sub i32 %v194, 16
  %v197 = add i32 %v196, %v195
  %v198 = load i32, ptr %EAX, align 4
  %v199 = load ptr, ptr %MEMORY, align 4
  %v200 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v199, ptr %state, i32 %v197, i32 %v198)
  store ptr %v200, ptr %MEMORY, align 4
  store i32 %v193, ptr %PC, align 4
  %v201 = add i32 %v193, 2
  store i32 %v201, ptr %NEXT_PC, align 4
  %v202 = add i32 %v201, 16
  %v203 = load ptr, ptr %MEMORY, align 4
  %v204 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v203, ptr %state, i32 %v202, ptr %NEXT_PC)
  store ptr %v204, ptr %MEMORY, align 4
  br label %bb_4203997

bb_4203981:                                       ; preds = %bb_4203997
  store i32 %v244, ptr %PC, align 4
  %v205 = add i32 %v244, 3
  store i32 %v205, ptr %NEXT_PC, align 4
  %v206 = load i32, ptr %EBP, align 4
  %v207 = load i32, ptr %SSBASE, align 4
  %v208 = sub i32 %v206, 16
  %v209 = add i32 %v208, %v207
  %v210 = load ptr, ptr %MEMORY, align 4
  %v211 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v210, ptr %state, ptr %EAX, i32 %v209)
  store ptr %v211, ptr %MEMORY, align 4
  store i32 %v205, ptr %PC, align 4
  %v212 = add i32 %v205, 7
  store i32 %v212, ptr %NEXT_PC, align 4
  %v213 = load i32, ptr %EAX, align 4
  %v214 = load i32, ptr %DSBASE, align 4
  %v215 = mul i32 %v213, 4
  %v216 = add i32 0, %v215
  %v217 = add i32 %v216, 4229344
  %v218 = add i32 %v217, %v214
  %v219 = load ptr, ptr %MEMORY, align 4
  %v220 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v219, ptr %state, ptr %EAX, i32 %v218)
  store ptr %v220, ptr %MEMORY, align 4
  store i32 %v212, ptr %PC, align 4
  %v221 = add i32 %v212, 2
  store i32 %v221, ptr %NEXT_PC, align 4
  %v222 = load i32, ptr %EAX, align 4
  %v223 = load ptr, ptr %MEMORY, align 4
  %v224 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v223, ptr %state, i32 %v222, ptr %NEXT_PC, i32 %v221, ptr %RETURN_PC)
  store ptr %v224, ptr %MEMORY, align 4
  store i32 %v221, ptr %PC, align 4
  %v225 = add i32 %v221, 4
  store i32 %v225, ptr %NEXT_PC, align 4
  %v226 = load i32, ptr %EBP, align 4
  %v227 = load i32, ptr %SSBASE, align 4
  %v228 = sub i32 %v226, 16
  %v229 = add i32 %v228, %v227
  %v230 = load i32, ptr %EBP, align 4
  %v231 = load i32, ptr %SSBASE, align 4
  %v232 = sub i32 %v230, 16
  %v233 = add i32 %v232, %v231
  %v234 = load ptr, ptr %MEMORY, align 4
  %v235 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v234, ptr %state, i32 %v229, i32 %v233, i32 1)
  store ptr %v235, ptr %MEMORY, align 4
  br label %bb_4203997

bb_4203997:                                       ; preds = %bb_4203981, %bb_4203973
  %v236 = load i32, ptr %NEXT_PC, align 4
  store i32 %v236, ptr %PC, align 4
  %v237 = add i32 %v236, 4
  store i32 %v237, ptr %NEXT_PC, align 4
  %v238 = load i32, ptr %EBP, align 4
  %v239 = load i32, ptr %SSBASE, align 4
  %v240 = sub i32 %v238, 16
  %v241 = add i32 %v240, %v239
  %v242 = load ptr, ptr %MEMORY, align 4
  %v243 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v242, ptr %state, i32 %v241, i32 0)
  store ptr %v243, ptr %MEMORY, align 4
  store i32 %v237, ptr %PC, align 4
  %v244 = add i32 %v237, 2
  store i32 %v244, ptr %NEXT_PC, align 4
  %v245 = sub i32 %v244, 22
  %v246 = load ptr, ptr %MEMORY, align 4
  %v247 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v246, ptr %state, ptr %BRANCH_TAKEN, i32 %v245, i32 %v244, ptr %NEXT_PC)
  store ptr %v247, ptr %MEMORY, align 4
  br i1 true, label %bb_4203981, label %bb_4204003

bb_4204003:                                       ; preds = %bb_4203997
  store i32 %v244, ptr %PC, align 4
  %v248 = add i32 %v244, 7
  store i32 %v248, ptr %NEXT_PC, align 4
  %v249 = load i32, ptr %ESP, align 4
  %v250 = load i32, ptr %SSBASE, align 4
  %v251 = add i32 %v249, %v250
  %v252 = load ptr, ptr %MEMORY, align 4
  %v253 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v252, ptr %state, i32 %v251, i32 4203880)
  store ptr %v253, ptr %MEMORY, align 4
  store i32 %v248, ptr %PC, align 4
  %v254 = add i32 %v248, 5
  store i32 %v254, ptr %NEXT_PC, align 4
  %v255 = sub i32 %v254, 3493
  %v256 = load ptr, ptr %MEMORY, align 4
  %v257 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v256, ptr %state, i64 4200522, ptr %NEXT_PC, i32 %v254, ptr %RETURN_PC)
  store ptr %v257, ptr %MEMORY, align 4
  store i32 %v254, ptr %PC, align 4
  %v258 = add i32 %v254, 1
  store i32 %v258, ptr %NEXT_PC, align 4
  %v259 = load ptr, ptr %MEMORY, align 4
  %v260 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v259, ptr %state)
  store ptr %v260, ptr %MEMORY, align 4
  store i32 %v258, ptr %PC, align 4
  %v261 = add i32 %v258, 1
  store i32 %v261, ptr %NEXT_PC, align 4
  %v262 = load ptr, ptr %MEMORY, align 4
  %v263 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v262, ptr %state, ptr %NEXT_PC)
  store ptr %v263, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204017:                                       ; No predecessors!
  %v264 = load i32, ptr %NEXT_PC, align 4
  store i32 %v264, ptr %PC, align 4
  %v265 = add i32 %v264, 1
  store i32 %v265, ptr %NEXT_PC, align 4
  %v266 = load i32, ptr %EBP, align 4
  %v267 = load ptr, ptr %MEMORY, align 4
  %v268 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v267, ptr %state, i32 %v266)
  store ptr %v268, ptr %MEMORY, align 4
  store i32 %v265, ptr %PC, align 4
  %v269 = add i32 %v265, 2
  store i32 %v269, ptr %NEXT_PC, align 4
  %v270 = load i32, ptr %ESP, align 4
  %v271 = load ptr, ptr %MEMORY, align 4
  %v272 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v271, ptr %state, ptr %EBP, i32 %v270)
  store ptr %v272, ptr %MEMORY, align 4
  store i32 %v269, ptr %PC, align 4
  %v273 = add i32 %v269, 3
  store i32 %v273, ptr %NEXT_PC, align 4
  %v274 = load i32, ptr %ESP, align 4
  %v275 = load ptr, ptr %MEMORY, align 4
  %v276 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v275, ptr %state, ptr %ESP, i32 %v274, i32 8)
  store ptr %v276, ptr %MEMORY, align 4
  store i32 %v273, ptr %PC, align 4
  %v277 = add i32 %v273, 5
  store i32 %v277, ptr %NEXT_PC, align 4
  %v278 = load i32, ptr %DSBASE, align 4
  %v279 = add i32 4240300, %v278
  %v280 = load ptr, ptr %MEMORY, align 4
  %v281 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v280, ptr %state, ptr %EAX, i32 %v279)
  store ptr %v281, ptr %MEMORY, align 4
  store i32 %v277, ptr %PC, align 4
  %v282 = add i32 %v277, 2
  store i32 %v282, ptr %NEXT_PC, align 4
  %v283 = load i32, ptr %EAX, align 4
  %v284 = load i32, ptr %EAX, align 4
  %v285 = load ptr, ptr %MEMORY, align 4
  %v286 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v285, ptr %state, i32 %v283, i32 %v284)
  store ptr %v286, ptr %MEMORY, align 4
  store i32 %v282, ptr %PC, align 4
  %v287 = add i32 %v282, 2
  store i32 %v287, ptr %NEXT_PC, align 4
  %v288 = add i32 %v287, 15
  %v289 = load ptr, ptr %MEMORY, align 4
  %v290 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v289, ptr %state, ptr %BRANCH_TAKEN, i32 %v288, i32 %v287, ptr %NEXT_PC)
  store ptr %v290, ptr %MEMORY, align 4
  br i1 true, label %bb_4204047, label %bb_4204032

bb_4204032:                                       ; preds = %bb_4204017
  store i32 %v287, ptr %PC, align 4
  %v291 = add i32 %v287, 10
  store i32 %v291, ptr %NEXT_PC, align 4
  %v292 = load i32, ptr %DSBASE, align 4
  %v293 = add i32 4240300, %v292
  %v294 = load ptr, ptr %MEMORY, align 4
  %v295 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v294, ptr %state, i32 %v293, i32 1)
  store ptr %v295, ptr %MEMORY, align 4
  store i32 %v291, ptr %PC, align 4
  %v296 = add i32 %v291, 5
  store i32 %v296, ptr %NEXT_PC, align 4
  %v297 = sub i32 %v296, 124
  %v298 = load ptr, ptr %MEMORY, align 4
  %v299 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v298, ptr %state, i64 4203923, ptr %NEXT_PC, i32 %v296, ptr %RETURN_PC)
  store ptr %v299, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204047:                                       ; preds = %bb_4204017
  store i32 %v287, ptr %PC, align 4
  %v300 = add i32 %v287, 1
  store i32 %v300, ptr %NEXT_PC, align 4
  %v301 = load ptr, ptr %MEMORY, align 4
  %v302 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v301, ptr %state)
  store ptr %v302, ptr %MEMORY, align 4
  store i32 %v300, ptr %PC, align 4
  %v303 = add i32 %v300, 1
  store i32 %v303, ptr %NEXT_PC, align 4
  %v304 = load ptr, ptr %MEMORY, align 4
  %v305 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v304, ptr %state, ptr %NEXT_PC)
  store ptr %v305, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204049:                                       ; No predecessors!
  %v306 = load i32, ptr %NEXT_PC, align 4
  store i32 %v306, ptr %PC, align 4
  %v307 = add i32 %v306, 1
  store i32 %v307, ptr %NEXT_PC, align 4
  %v308 = load ptr, ptr %MEMORY, align 4
  %v309 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v308, ptr %state)
  store ptr %v309, ptr %MEMORY, align 4
  store i32 %v307, ptr %PC, align 4
  %v310 = add i32 %v307, 1
  store i32 %v310, ptr %NEXT_PC, align 4
  %v311 = load ptr, ptr %MEMORY, align 4
  %v312 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v311, ptr %state)
  store ptr %v312, ptr %MEMORY, align 4
  store i32 %v310, ptr %PC, align 4
  %v313 = add i32 %v310, 1
  store i32 %v313, ptr %NEXT_PC, align 4
  %v314 = load ptr, ptr %MEMORY, align 4
  %v315 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v314, ptr %state)
  store ptr %v315, ptr %MEMORY, align 4
  store i32 %v313, ptr %PC, align 4
  %v316 = add i32 %v313, 1
  store i32 %v316, ptr %NEXT_PC, align 4
  %v317 = load i32, ptr %EBP, align 4
  %v318 = load ptr, ptr %MEMORY, align 4
  %v319 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v318, ptr %state, i32 %v317)
  store ptr %v319, ptr %MEMORY, align 4
  store i32 %v316, ptr %PC, align 4
  %v320 = add i32 %v316, 2
  store i32 %v320, ptr %NEXT_PC, align 4
  %v321 = load i32, ptr %ESP, align 4
  %v322 = load ptr, ptr %MEMORY, align 4
  %v323 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v322, ptr %state, ptr %EBP, i32 %v321)
  store ptr %v323, ptr %MEMORY, align 4
  store i32 %v320, ptr %PC, align 4
  %v324 = add i32 %v320, 3
  store i32 %v324, ptr %NEXT_PC, align 4
  %v325 = load i32, ptr %ESP, align 4
  %v326 = load ptr, ptr %MEMORY, align 4
  %v327 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v326, ptr %state, ptr %ESP, i32 %v325, i32 16)
  store ptr %v327, ptr %MEMORY, align 4
  store i32 %v324, ptr %PC, align 4
  %v328 = add i32 %v324, 3
  store i32 %v328, ptr %NEXT_PC, align 4
  %v329 = load i32, ptr %EBP, align 4
  %v330 = load i32, ptr %SSBASE, align 4
  %v331 = add i32 %v329, 8
  %v332 = add i32 %v331, %v330
  %v333 = load ptr, ptr %MEMORY, align 4
  %v334 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v333, ptr %state, ptr %EAX, i32 %v332)
  store ptr %v334, ptr %MEMORY, align 4
  store i32 %v328, ptr %PC, align 4
  %v335 = add i32 %v328, 3
  store i32 %v335, ptr %NEXT_PC, align 4
  %v336 = load i32, ptr %EBP, align 4
  %v337 = load i32, ptr %SSBASE, align 4
  %v338 = sub i32 %v336, 4
  %v339 = add i32 %v338, %v337
  %v340 = load i32, ptr %EAX, align 4
  %v341 = load ptr, ptr %MEMORY, align 4
  %v342 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v341, ptr %state, i32 %v339, i32 %v340)
  store ptr %v342, ptr %MEMORY, align 4
  store i32 %v335, ptr %PC, align 4
  %v343 = add i32 %v335, 3
  store i32 %v343, ptr %NEXT_PC, align 4
  %v344 = load i32, ptr %EBP, align 4
  %v345 = load i32, ptr %SSBASE, align 4
  %v346 = sub i32 %v344, 4
  %v347 = add i32 %v346, %v345
  %v348 = load ptr, ptr %MEMORY, align 4
  %v349 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v348, ptr %state, ptr %EAX, i32 %v347)
  store ptr %v349, ptr %MEMORY, align 4
  store i32 %v343, ptr %PC, align 4
  %v350 = add i32 %v343, 3
  store i32 %v350, ptr %NEXT_PC, align 4
  %v351 = load i32, ptr %EAX, align 4
  %v352 = load i32, ptr %DSBASE, align 4
  %v353 = add i32 %v351, %v352
  %v354 = load ptr, ptr %MEMORY, align 4
  %v355 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v354, ptr %state, ptr %EAX, i32 %v353)
  store ptr %v355, ptr %MEMORY, align 4
  store i32 %v350, ptr %PC, align 4
  %v356 = add i32 %v350, 4
  store i32 %v356, ptr %NEXT_PC, align 4
  %v357 = load i16, ptr %AX, align 2
  %v358 = zext i16 %v357 to i32
  %v359 = load ptr, ptr %MEMORY, align 4
  %v360 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnItLb1EE2InItEEEP6MemoryS6_R5StateT_T0_(ptr %v359, ptr %state, i32 %v358, i32 23117)
  store ptr %v360, ptr %MEMORY, align 4
  store i32 %v356, ptr %PC, align 4
  %v361 = add i32 %v356, 2
  store i32 %v361, ptr %NEXT_PC, align 4
  %v362 = add i32 %v361, 7
  %v363 = load ptr, ptr %MEMORY, align 4
  %v364 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v363, ptr %state, ptr %BRANCH_TAKEN, i32 %v362, i32 %v361, ptr %NEXT_PC)
  store ptr %v364, ptr %MEMORY, align 4
  br i1 true, label %bb_4204083, label %bb_4204076

bb_4204076:                                       ; preds = %bb_4204049
  store i32 %v361, ptr %PC, align 4
  %v365 = add i32 %v361, 5
  store i32 %v365, ptr %NEXT_PC, align 4
  %v366 = load ptr, ptr %MEMORY, align 4
  %v367 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v366, ptr %state, ptr %EAX, i32 0)
  store ptr %v367, ptr %MEMORY, align 4
  store i32 %v365, ptr %PC, align 4
  %v368 = add i32 %v365, 2
  store i32 %v368, ptr %NEXT_PC, align 4
  %v369 = add i32 %v368, 68
  %v370 = load ptr, ptr %MEMORY, align 4
  %v371 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v370, ptr %state, i32 %v369, ptr %NEXT_PC)
  store ptr %v371, ptr %MEMORY, align 4
  br label %bb_4204151

bb_4204083:                                       ; preds = %bb_4204049
  store i32 %v361, ptr %PC, align 4
  %v372 = add i32 %v361, 3
  store i32 %v372, ptr %NEXT_PC, align 4
  %v373 = load i32, ptr %EBP, align 4
  %v374 = load i32, ptr %SSBASE, align 4
  %v375 = sub i32 %v373, 4
  %v376 = add i32 %v375, %v374
  %v377 = load ptr, ptr %MEMORY, align 4
  %v378 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v377, ptr %state, ptr %EAX, i32 %v376)
  store ptr %v378, ptr %MEMORY, align 4
  store i32 %v372, ptr %PC, align 4
  %v379 = add i32 %v372, 3
  store i32 %v379, ptr %NEXT_PC, align 4
  %v380 = load i32, ptr %EAX, align 4
  %v381 = load i32, ptr %DSBASE, align 4
  %v382 = add i32 %v380, 60
  %v383 = add i32 %v382, %v381
  %v384 = load ptr, ptr %MEMORY, align 4
  %v385 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v384, ptr %state, ptr %EAX, i32 %v383)
  store ptr %v385, ptr %MEMORY, align 4
  store i32 %v379, ptr %PC, align 4
  %v386 = add i32 %v379, 2
  store i32 %v386, ptr %NEXT_PC, align 4
  %v387 = load i32, ptr %EAX, align 4
  %v388 = load ptr, ptr %MEMORY, align 4
  %v389 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v388, ptr %state, ptr %EDX, i32 %v387)
  store ptr %v389, ptr %MEMORY, align 4
  store i32 %v386, ptr %PC, align 4
  %v390 = add i32 %v386, 3
  store i32 %v390, ptr %NEXT_PC, align 4
  %v391 = load i32, ptr %EBP, align 4
  %v392 = load i32, ptr %SSBASE, align 4
  %v393 = sub i32 %v391, 4
  %v394 = add i32 %v393, %v392
  %v395 = load ptr, ptr %MEMORY, align 4
  %v396 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v395, ptr %state, ptr %EAX, i32 %v394)
  store ptr %v396, ptr %MEMORY, align 4
  store i32 %v390, ptr %PC, align 4
  %v397 = add i32 %v390, 2
  store i32 %v397, ptr %NEXT_PC, align 4
  %v398 = load i32, ptr %EAX, align 4
  %v399 = load i32, ptr %EDX, align 4
  %v400 = load ptr, ptr %MEMORY, align 4
  %v401 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v400, ptr %state, ptr %EAX, i32 %v398, i32 %v399)
  store ptr %v401, ptr %MEMORY, align 4
  store i32 %v397, ptr %PC, align 4
  %v402 = add i32 %v397, 3
  store i32 %v402, ptr %NEXT_PC, align 4
  %v403 = load i32, ptr %EBP, align 4
  %v404 = load i32, ptr %SSBASE, align 4
  %v405 = sub i32 %v403, 8
  %v406 = add i32 %v405, %v404
  %v407 = load i32, ptr %EAX, align 4
  %v408 = load ptr, ptr %MEMORY, align 4
  %v409 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v408, ptr %state, i32 %v406, i32 %v407)
  store ptr %v409, ptr %MEMORY, align 4
  store i32 %v402, ptr %PC, align 4
  %v410 = add i32 %v402, 3
  store i32 %v410, ptr %NEXT_PC, align 4
  %v411 = load i32, ptr %EBP, align 4
  %v412 = load i32, ptr %SSBASE, align 4
  %v413 = sub i32 %v411, 8
  %v414 = add i32 %v413, %v412
  %v415 = load ptr, ptr %MEMORY, align 4
  %v416 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v415, ptr %state, ptr %EAX, i32 %v414)
  store ptr %v416, ptr %MEMORY, align 4
  store i32 %v410, ptr %PC, align 4
  %v417 = add i32 %v410, 2
  store i32 %v417, ptr %NEXT_PC, align 4
  %v418 = load i32, ptr %EAX, align 4
  %v419 = load i32, ptr %DSBASE, align 4
  %v420 = add i32 %v418, %v419
  %v421 = load ptr, ptr %MEMORY, align 4
  %v422 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v421, ptr %state, ptr %EAX, i32 %v420)
  store ptr %v422, ptr %MEMORY, align 4
  store i32 %v417, ptr %PC, align 4
  %v423 = add i32 %v417, 5
  store i32 %v423, ptr %NEXT_PC, align 4
  %v424 = load i32, ptr %EAX, align 4
  %v425 = load ptr, ptr %MEMORY, align 4
  %v426 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v425, ptr %state, i32 %v424, i32 17744)
  store ptr %v426, ptr %MEMORY, align 4
  store i32 %v423, ptr %PC, align 4
  %v427 = add i32 %v423, 2
  store i32 %v427, ptr %NEXT_PC, align 4
  %v428 = add i32 %v427, 7
  %v429 = load ptr, ptr %MEMORY, align 4
  %v430 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v429, ptr %state, ptr %BRANCH_TAKEN, i32 %v428, i32 %v427, ptr %NEXT_PC)
  store ptr %v430, ptr %MEMORY, align 4
  br i1 true, label %bb_4204118, label %bb_4204111

bb_4204111:                                       ; preds = %bb_4204083
  store i32 %v427, ptr %PC, align 4
  %v431 = add i32 %v427, 5
  store i32 %v431, ptr %NEXT_PC, align 4
  %v432 = load ptr, ptr %MEMORY, align 4
  %v433 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v432, ptr %state, ptr %EAX, i32 0)
  store ptr %v433, ptr %MEMORY, align 4
  store i32 %v431, ptr %PC, align 4
  %v434 = add i32 %v431, 2
  store i32 %v434, ptr %NEXT_PC, align 4
  %v435 = add i32 %v434, 33
  %v436 = load ptr, ptr %MEMORY, align 4
  %v437 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v436, ptr %state, i32 %v435, ptr %NEXT_PC)
  store ptr %v437, ptr %MEMORY, align 4
  br label %bb_4204151

bb_4204118:                                       ; preds = %bb_4204083
  store i32 %v427, ptr %PC, align 4
  %v438 = add i32 %v427, 3
  store i32 %v438, ptr %NEXT_PC, align 4
  %v439 = load i32, ptr %EBP, align 4
  %v440 = load i32, ptr %SSBASE, align 4
  %v441 = sub i32 %v439, 8
  %v442 = add i32 %v441, %v440
  %v443 = load ptr, ptr %MEMORY, align 4
  %v444 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v443, ptr %state, ptr %EAX, i32 %v442)
  store ptr %v444, ptr %MEMORY, align 4
  store i32 %v438, ptr %PC, align 4
  %v445 = add i32 %v438, 3
  store i32 %v445, ptr %NEXT_PC, align 4
  %v446 = load i32, ptr %EAX, align 4
  %v447 = load ptr, ptr %MEMORY, align 4
  %v448 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v447, ptr %state, ptr %EAX, i32 %v446, i32 24)
  store ptr %v448, ptr %MEMORY, align 4
  store i32 %v445, ptr %PC, align 4
  %v449 = add i32 %v445, 3
  store i32 %v449, ptr %NEXT_PC, align 4
  %v450 = load i32, ptr %EBP, align 4
  %v451 = load i32, ptr %SSBASE, align 4
  %v452 = sub i32 %v450, 12
  %v453 = add i32 %v452, %v451
  %v454 = load i32, ptr %EAX, align 4
  %v455 = load ptr, ptr %MEMORY, align 4
  %v456 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v455, ptr %state, i32 %v453, i32 %v454)
  store ptr %v456, ptr %MEMORY, align 4
  store i32 %v449, ptr %PC, align 4
  %v457 = add i32 %v449, 3
  store i32 %v457, ptr %NEXT_PC, align 4
  %v458 = load i32, ptr %EBP, align 4
  %v459 = load i32, ptr %SSBASE, align 4
  %v460 = sub i32 %v458, 12
  %v461 = add i32 %v460, %v459
  %v462 = load ptr, ptr %MEMORY, align 4
  %v463 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v462, ptr %state, ptr %EAX, i32 %v461)
  store ptr %v463, ptr %MEMORY, align 4
  store i32 %v457, ptr %PC, align 4
  %v464 = add i32 %v457, 3
  store i32 %v464, ptr %NEXT_PC, align 4
  %v465 = load i32, ptr %EAX, align 4
  %v466 = load i32, ptr %DSBASE, align 4
  %v467 = add i32 %v465, %v466
  %v468 = load ptr, ptr %MEMORY, align 4
  %v469 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v468, ptr %state, ptr %EAX, i32 %v467)
  store ptr %v469, ptr %MEMORY, align 4
  store i32 %v464, ptr %PC, align 4
  %v470 = add i32 %v464, 4
  store i32 %v470, ptr %NEXT_PC, align 4
  %v471 = load i16, ptr %AX, align 2
  %v472 = zext i16 %v471 to i32
  %v473 = load ptr, ptr %MEMORY, align 4
  %v474 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnItLb1EE2InItEEEP6MemoryS6_R5StateT_T0_(ptr %v473, ptr %state, i32 %v472, i32 267)
  store ptr %v474, ptr %MEMORY, align 4
  store i32 %v470, ptr %PC, align 4
  %v475 = add i32 %v470, 2
  store i32 %v475, ptr %NEXT_PC, align 4
  %v476 = add i32 %v475, 7
  %v477 = load ptr, ptr %MEMORY, align 4
  %v478 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v477, ptr %state, ptr %BRANCH_TAKEN, i32 %v476, i32 %v475, ptr %NEXT_PC)
  store ptr %v478, ptr %MEMORY, align 4
  br i1 true, label %bb_4204146, label %bb_4204139

bb_4204139:                                       ; preds = %bb_4204118
  store i32 %v475, ptr %PC, align 4
  %v479 = add i32 %v475, 5
  store i32 %v479, ptr %NEXT_PC, align 4
  %v480 = load ptr, ptr %MEMORY, align 4
  %v481 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v480, ptr %state, ptr %EAX, i32 0)
  store ptr %v481, ptr %MEMORY, align 4
  store i32 %v479, ptr %PC, align 4
  %v482 = add i32 %v479, 2
  store i32 %v482, ptr %NEXT_PC, align 4
  %v483 = add i32 %v482, 5
  %v484 = load ptr, ptr %MEMORY, align 4
  %v485 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v484, ptr %state, i32 %v483, ptr %NEXT_PC)
  store ptr %v485, ptr %MEMORY, align 4
  br label %bb_4204151

bb_4204146:                                       ; preds = %bb_4204118
  store i32 %v475, ptr %PC, align 4
  %v486 = add i32 %v475, 5
  store i32 %v486, ptr %NEXT_PC, align 4
  %v487 = load ptr, ptr %MEMORY, align 4
  %v488 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v487, ptr %state, ptr %EAX, i32 1)
  store ptr %v488, ptr %MEMORY, align 4
  br label %bb_4204151

bb_4204151:                                       ; preds = %bb_4204146, %bb_4204139, %bb_4204111, %bb_4204076
  %v489 = load i32, ptr %NEXT_PC, align 4
  store i32 %v489, ptr %PC, align 4
  %v490 = add i32 %v489, 1
  store i32 %v490, ptr %NEXT_PC, align 4
  %v491 = load ptr, ptr %MEMORY, align 4
  %v492 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v491, ptr %state)
  store ptr %v492, ptr %MEMORY, align 4
  store i32 %v490, ptr %PC, align 4
  %v493 = add i32 %v490, 1
  store i32 %v493, ptr %NEXT_PC, align 4
  %v494 = load ptr, ptr %MEMORY, align 4
  %v495 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v494, ptr %state, ptr %NEXT_PC)
  store ptr %v495, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204153:                                       ; No predecessors!
  %v496 = load i32, ptr %NEXT_PC, align 4
  store i32 %v496, ptr %PC, align 4
  %v497 = add i32 %v496, 1
  store i32 %v497, ptr %NEXT_PC, align 4
  %v498 = load i32, ptr %EBP, align 4
  %v499 = load ptr, ptr %MEMORY, align 4
  %v500 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v499, ptr %state, i32 %v498)
  store ptr %v500, ptr %MEMORY, align 4
  store i32 %v497, ptr %PC, align 4
  %v501 = add i32 %v497, 2
  store i32 %v501, ptr %NEXT_PC, align 4
  %v502 = load i32, ptr %ESP, align 4
  %v503 = load ptr, ptr %MEMORY, align 4
  %v504 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v503, ptr %state, ptr %EBP, i32 %v502)
  store ptr %v504, ptr %MEMORY, align 4
  store i32 %v501, ptr %PC, align 4
  %v505 = add i32 %v501, 3
  store i32 %v505, ptr %NEXT_PC, align 4
  %v506 = load i32, ptr %ESP, align 4
  %v507 = load ptr, ptr %MEMORY, align 4
  %v508 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v507, ptr %state, ptr %ESP, i32 %v506, i32 16)
  store ptr %v508, ptr %MEMORY, align 4
  store i32 %v505, ptr %PC, align 4
  %v509 = add i32 %v505, 3
  store i32 %v509, ptr %NEXT_PC, align 4
  %v510 = load i32, ptr %EBP, align 4
  %v511 = load i32, ptr %SSBASE, align 4
  %v512 = add i32 %v510, 8
  %v513 = add i32 %v512, %v511
  %v514 = load ptr, ptr %MEMORY, align 4
  %v515 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v514, ptr %state, ptr %EAX, i32 %v513)
  store ptr %v515, ptr %MEMORY, align 4
  store i32 %v509, ptr %PC, align 4
  %v516 = add i32 %v509, 3
  store i32 %v516, ptr %NEXT_PC, align 4
  %v517 = load i32, ptr %EAX, align 4
  %v518 = load i32, ptr %DSBASE, align 4
  %v519 = add i32 %v517, 60
  %v520 = add i32 %v519, %v518
  %v521 = load ptr, ptr %MEMORY, align 4
  %v522 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v521, ptr %state, ptr %EAX, i32 %v520)
  store ptr %v522, ptr %MEMORY, align 4
  store i32 %v516, ptr %PC, align 4
  %v523 = add i32 %v516, 2
  store i32 %v523, ptr %NEXT_PC, align 4
  %v524 = load i32, ptr %EAX, align 4
  %v525 = load ptr, ptr %MEMORY, align 4
  %v526 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v525, ptr %state, ptr %EDX, i32 %v524)
  store ptr %v526, ptr %MEMORY, align 4
  store i32 %v523, ptr %PC, align 4
  %v527 = add i32 %v523, 3
  store i32 %v527, ptr %NEXT_PC, align 4
  %v528 = load i32, ptr %EBP, align 4
  %v529 = load i32, ptr %SSBASE, align 4
  %v530 = add i32 %v528, 8
  %v531 = add i32 %v530, %v529
  %v532 = load ptr, ptr %MEMORY, align 4
  %v533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v532, ptr %state, ptr %EAX, i32 %v531)
  store ptr %v533, ptr %MEMORY, align 4
  store i32 %v527, ptr %PC, align 4
  %v534 = add i32 %v527, 2
  store i32 %v534, ptr %NEXT_PC, align 4
  %v535 = load i32, ptr %EAX, align 4
  %v536 = load i32, ptr %EDX, align 4
  %v537 = load ptr, ptr %MEMORY, align 4
  %v538 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v537, ptr %state, ptr %EAX, i32 %v535, i32 %v536)
  store ptr %v538, ptr %MEMORY, align 4
  store i32 %v534, ptr %PC, align 4
  %v539 = add i32 %v534, 3
  store i32 %v539, ptr %NEXT_PC, align 4
  %v540 = load i32, ptr %EBP, align 4
  %v541 = load i32, ptr %SSBASE, align 4
  %v542 = sub i32 %v540, 12
  %v543 = add i32 %v542, %v541
  %v544 = load i32, ptr %EAX, align 4
  %v545 = load ptr, ptr %MEMORY, align 4
  %v546 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v545, ptr %state, i32 %v543, i32 %v544)
  store ptr %v546, ptr %MEMORY, align 4
  store i32 %v539, ptr %PC, align 4
  %v547 = add i32 %v539, 7
  store i32 %v547, ptr %NEXT_PC, align 4
  %v548 = load i32, ptr %EBP, align 4
  %v549 = load i32, ptr %SSBASE, align 4
  %v550 = sub i32 %v548, 8
  %v551 = add i32 %v550, %v549
  %v552 = load ptr, ptr %MEMORY, align 4
  %v553 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v552, ptr %state, i32 %v551, i32 0)
  store ptr %v553, ptr %MEMORY, align 4
  store i32 %v547, ptr %PC, align 4
  %v554 = add i32 %v547, 3
  store i32 %v554, ptr %NEXT_PC, align 4
  %v555 = load i32, ptr %EBP, align 4
  %v556 = load i32, ptr %SSBASE, align 4
  %v557 = sub i32 %v555, 12
  %v558 = add i32 %v557, %v556
  %v559 = load ptr, ptr %MEMORY, align 4
  %v560 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v559, ptr %state, ptr %EAX, i32 %v558)
  store ptr %v560, ptr %MEMORY, align 4
  store i32 %v554, ptr %PC, align 4
  %v561 = add i32 %v554, 4
  store i32 %v561, ptr %NEXT_PC, align 4
  %v562 = load i32, ptr %EAX, align 4
  %v563 = load i32, ptr %DSBASE, align 4
  %v564 = add i32 %v562, 20
  %v565 = add i32 %v564, %v563
  %v566 = load ptr, ptr %MEMORY, align 4
  %v567 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v566, ptr %state, ptr %EAX, i32 %v565)
  store ptr %v567, ptr %MEMORY, align 4
  store i32 %v561, ptr %PC, align 4
  %v568 = add i32 %v561, 3
  store i32 %v568, ptr %NEXT_PC, align 4
  %v569 = load i16, ptr %AX, align 2
  %v570 = zext i16 %v569 to i32
  %v571 = load ptr, ptr %MEMORY, align 4
  %v572 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v571, ptr %state, ptr %EDX, i32 %v570)
  store ptr %v572, ptr %MEMORY, align 4
  store i32 %v568, ptr %PC, align 4
  %v573 = add i32 %v568, 3
  store i32 %v573, ptr %NEXT_PC, align 4
  %v574 = load i32, ptr %EBP, align 4
  %v575 = load i32, ptr %SSBASE, align 4
  %v576 = sub i32 %v574, 12
  %v577 = add i32 %v576, %v575
  %v578 = load ptr, ptr %MEMORY, align 4
  %v579 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v578, ptr %state, ptr %EAX, i32 %v577)
  store ptr %v579, ptr %MEMORY, align 4
  store i32 %v573, ptr %PC, align 4
  %v580 = add i32 %v573, 2
  store i32 %v580, ptr %NEXT_PC, align 4
  %v581 = load i32, ptr %EAX, align 4
  %v582 = load i32, ptr %EDX, align 4
  %v583 = load ptr, ptr %MEMORY, align 4
  %v584 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v583, ptr %state, ptr %EAX, i32 %v581, i32 %v582)
  store ptr %v584, ptr %MEMORY, align 4
  store i32 %v580, ptr %PC, align 4
  %v585 = add i32 %v580, 3
  store i32 %v585, ptr %NEXT_PC, align 4
  %v586 = load i32, ptr %EAX, align 4
  %v587 = load ptr, ptr %MEMORY, align 4
  %v588 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v587, ptr %state, ptr %EAX, i32 %v586, i32 24)
  store ptr %v588, ptr %MEMORY, align 4
  store i32 %v585, ptr %PC, align 4
  %v589 = add i32 %v585, 3
  store i32 %v589, ptr %NEXT_PC, align 4
  %v590 = load i32, ptr %EBP, align 4
  %v591 = load i32, ptr %SSBASE, align 4
  %v592 = sub i32 %v590, 4
  %v593 = add i32 %v592, %v591
  %v594 = load i32, ptr %EAX, align 4
  %v595 = load ptr, ptr %MEMORY, align 4
  %v596 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v595, ptr %state, i32 %v593, i32 %v594)
  store ptr %v596, ptr %MEMORY, align 4
  store i32 %v589, ptr %PC, align 4
  %v597 = add i32 %v589, 2
  store i32 %v597, ptr %NEXT_PC, align 4
  %v598 = add i32 %v597, 43
  %v599 = load ptr, ptr %MEMORY, align 4
  %v600 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v599, ptr %state, i32 %v598, ptr %NEXT_PC)
  store ptr %v600, ptr %MEMORY, align 4
  br label %bb_4204248

bb_4204205:                                       ; preds = %bb_4204248
  store i32 %v734, ptr %PC, align 4
  %v601 = add i32 %v734, 3
  store i32 %v601, ptr %NEXT_PC, align 4
  %v602 = load i32, ptr %EBP, align 4
  %v603 = load i32, ptr %SSBASE, align 4
  %v604 = sub i32 %v602, 4
  %v605 = add i32 %v604, %v603
  %v606 = load ptr, ptr %MEMORY, align 4
  %v607 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v606, ptr %state, ptr %EAX, i32 %v605)
  store ptr %v607, ptr %MEMORY, align 4
  store i32 %v601, ptr %PC, align 4
  %v608 = add i32 %v601, 3
  store i32 %v608, ptr %NEXT_PC, align 4
  %v609 = load i32, ptr %EAX, align 4
  %v610 = load i32, ptr %DSBASE, align 4
  %v611 = add i32 %v609, 12
  %v612 = add i32 %v611, %v610
  %v613 = load ptr, ptr %MEMORY, align 4
  %v614 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v613, ptr %state, ptr %EAX, i32 %v612)
  store ptr %v614, ptr %MEMORY, align 4
  store i32 %v608, ptr %PC, align 4
  %v615 = add i32 %v608, 3
  store i32 %v615, ptr %NEXT_PC, align 4
  %v616 = load i32, ptr %EAX, align 4
  %v617 = load i32, ptr %EBP, align 4
  %v618 = load i32, ptr %SSBASE, align 4
  %v619 = add i32 %v617, 12
  %v620 = add i32 %v619, %v618
  %v621 = load ptr, ptr %MEMORY, align 4
  %v622 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v621, ptr %state, i32 %v616, i32 %v620)
  store ptr %v622, ptr %MEMORY, align 4
  store i32 %v615, ptr %PC, align 4
  %v623 = add i32 %v615, 2
  store i32 %v623, ptr %NEXT_PC, align 4
  %v624 = add i32 %v623, 24
  %v625 = load ptr, ptr %MEMORY, align 4
  %v626 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v625, ptr %state, ptr %BRANCH_TAKEN, i32 %v624, i32 %v623, ptr %NEXT_PC)
  store ptr %v626, ptr %MEMORY, align 4
  br i1 true, label %bb_4204240, label %bb_4204216

bb_4204216:                                       ; preds = %bb_4204205
  store i32 %v623, ptr %PC, align 4
  %v627 = add i32 %v623, 3
  store i32 %v627, ptr %NEXT_PC, align 4
  %v628 = load i32, ptr %EBP, align 4
  %v629 = load i32, ptr %SSBASE, align 4
  %v630 = sub i32 %v628, 4
  %v631 = add i32 %v630, %v629
  %v632 = load ptr, ptr %MEMORY, align 4
  %v633 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v632, ptr %state, ptr %EAX, i32 %v631)
  store ptr %v633, ptr %MEMORY, align 4
  store i32 %v627, ptr %PC, align 4
  %v634 = add i32 %v627, 3
  store i32 %v634, ptr %NEXT_PC, align 4
  %v635 = load i32, ptr %EAX, align 4
  %v636 = load i32, ptr %DSBASE, align 4
  %v637 = add i32 %v635, 12
  %v638 = add i32 %v637, %v636
  %v639 = load ptr, ptr %MEMORY, align 4
  %v640 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v639, ptr %state, ptr %EDX, i32 %v638)
  store ptr %v640, ptr %MEMORY, align 4
  store i32 %v634, ptr %PC, align 4
  %v641 = add i32 %v634, 3
  store i32 %v641, ptr %NEXT_PC, align 4
  %v642 = load i32, ptr %EBP, align 4
  %v643 = load i32, ptr %SSBASE, align 4
  %v644 = sub i32 %v642, 4
  %v645 = add i32 %v644, %v643
  %v646 = load ptr, ptr %MEMORY, align 4
  %v647 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v646, ptr %state, ptr %EAX, i32 %v645)
  store ptr %v647, ptr %MEMORY, align 4
  store i32 %v641, ptr %PC, align 4
  %v648 = add i32 %v641, 3
  store i32 %v648, ptr %NEXT_PC, align 4
  %v649 = load i32, ptr %EAX, align 4
  %v650 = load i32, ptr %DSBASE, align 4
  %v651 = add i32 %v649, 8
  %v652 = add i32 %v651, %v650
  %v653 = load ptr, ptr %MEMORY, align 4
  %v654 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v653, ptr %state, ptr %EAX, i32 %v652)
  store ptr %v654, ptr %MEMORY, align 4
  store i32 %v648, ptr %PC, align 4
  %v655 = add i32 %v648, 2
  store i32 %v655, ptr %NEXT_PC, align 4
  %v656 = load i32, ptr %EAX, align 4
  %v657 = load i32, ptr %EDX, align 4
  %v658 = load ptr, ptr %MEMORY, align 4
  %v659 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v658, ptr %state, ptr %EAX, i32 %v656, i32 %v657)
  store ptr %v659, ptr %MEMORY, align 4
  store i32 %v655, ptr %PC, align 4
  %v660 = add i32 %v655, 3
  store i32 %v660, ptr %NEXT_PC, align 4
  %v661 = load i32, ptr %EAX, align 4
  %v662 = load i32, ptr %EBP, align 4
  %v663 = load i32, ptr %SSBASE, align 4
  %v664 = add i32 %v662, 12
  %v665 = add i32 %v664, %v663
  %v666 = load ptr, ptr %MEMORY, align 4
  %v667 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v666, ptr %state, i32 %v661, i32 %v665)
  store ptr %v667, ptr %MEMORY, align 4
  store i32 %v660, ptr %PC, align 4
  %v668 = add i32 %v660, 2
  store i32 %v668, ptr %NEXT_PC, align 4
  %v669 = add i32 %v668, 5
  %v670 = load ptr, ptr %MEMORY, align 4
  %v671 = call ptr @_ZN12_GLOBAL__N_13JBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v670, ptr %state, ptr %BRANCH_TAKEN, i32 %v669, i32 %v668, ptr %NEXT_PC)
  store ptr %v671, ptr %MEMORY, align 4
  br i1 true, label %bb_4204240, label %bb_4204235

bb_4204235:                                       ; preds = %bb_4204216
  store i32 %v668, ptr %PC, align 4
  %v672 = add i32 %v668, 3
  store i32 %v672, ptr %NEXT_PC, align 4
  %v673 = load i32, ptr %EBP, align 4
  %v674 = load i32, ptr %SSBASE, align 4
  %v675 = sub i32 %v673, 4
  %v676 = add i32 %v675, %v674
  %v677 = load ptr, ptr %MEMORY, align 4
  %v678 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v677, ptr %state, ptr %EAX, i32 %v676)
  store ptr %v678, ptr %MEMORY, align 4
  store i32 %v672, ptr %PC, align 4
  %v679 = add i32 %v672, 2
  store i32 %v679, ptr %NEXT_PC, align 4
  %v680 = add i32 %v679, 28
  %v681 = load ptr, ptr %MEMORY, align 4
  %v682 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v681, ptr %state, i32 %v680, ptr %NEXT_PC)
  store ptr %v682, ptr %MEMORY, align 4
  br label %bb_4204268

bb_4204240:                                       ; preds = %bb_4204216, %bb_4204205
  %v683 = load i32, ptr %NEXT_PC, align 4
  store i32 %v683, ptr %PC, align 4
  %v684 = add i32 %v683, 4
  store i32 %v684, ptr %NEXT_PC, align 4
  %v685 = load i32, ptr %EBP, align 4
  %v686 = load i32, ptr %SSBASE, align 4
  %v687 = sub i32 %v685, 8
  %v688 = add i32 %v687, %v686
  %v689 = load i32, ptr %EBP, align 4
  %v690 = load i32, ptr %SSBASE, align 4
  %v691 = sub i32 %v689, 8
  %v692 = add i32 %v691, %v690
  %v693 = load ptr, ptr %MEMORY, align 4
  %v694 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v693, ptr %state, i32 %v688, i32 %v692, i32 1)
  store ptr %v694, ptr %MEMORY, align 4
  store i32 %v684, ptr %PC, align 4
  %v695 = add i32 %v684, 4
  store i32 %v695, ptr %NEXT_PC, align 4
  %v696 = load i32, ptr %EBP, align 4
  %v697 = load i32, ptr %SSBASE, align 4
  %v698 = sub i32 %v696, 4
  %v699 = add i32 %v698, %v697
  %v700 = load i32, ptr %EBP, align 4
  %v701 = load i32, ptr %SSBASE, align 4
  %v702 = sub i32 %v700, 4
  %v703 = add i32 %v702, %v701
  %v704 = load ptr, ptr %MEMORY, align 4
  %v705 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v704, ptr %state, i32 %v699, i32 %v703, i32 40)
  store ptr %v705, ptr %MEMORY, align 4
  br label %bb_4204248

bb_4204248:                                       ; preds = %bb_4204240, %bb_4204153
  %v706 = load i32, ptr %NEXT_PC, align 4
  store i32 %v706, ptr %PC, align 4
  %v707 = add i32 %v706, 3
  store i32 %v707, ptr %NEXT_PC, align 4
  %v708 = load i32, ptr %EBP, align 4
  %v709 = load i32, ptr %SSBASE, align 4
  %v710 = sub i32 %v708, 12
  %v711 = add i32 %v710, %v709
  %v712 = load ptr, ptr %MEMORY, align 4
  %v713 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v712, ptr %state, ptr %EAX, i32 %v711)
  store ptr %v713, ptr %MEMORY, align 4
  store i32 %v707, ptr %PC, align 4
  %v714 = add i32 %v707, 4
  store i32 %v714, ptr %NEXT_PC, align 4
  %v715 = load i32, ptr %EAX, align 4
  %v716 = load i32, ptr %DSBASE, align 4
  %v717 = add i32 %v715, 6
  %v718 = add i32 %v717, %v716
  %v719 = load ptr, ptr %MEMORY, align 4
  %v720 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v719, ptr %state, ptr %EAX, i32 %v718)
  store ptr %v720, ptr %MEMORY, align 4
  store i32 %v714, ptr %PC, align 4
  %v721 = add i32 %v714, 3
  store i32 %v721, ptr %NEXT_PC, align 4
  %v722 = load i16, ptr %AX, align 2
  %v723 = zext i16 %v722 to i32
  %v724 = load ptr, ptr %MEMORY, align 4
  %v725 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v724, ptr %state, ptr %EAX, i32 %v723)
  store ptr %v725, ptr %MEMORY, align 4
  store i32 %v721, ptr %PC, align 4
  %v726 = add i32 %v721, 3
  store i32 %v726, ptr %NEXT_PC, align 4
  %v727 = load i32, ptr %EAX, align 4
  %v728 = load i32, ptr %EBP, align 4
  %v729 = load i32, ptr %SSBASE, align 4
  %v730 = sub i32 %v728, 8
  %v731 = add i32 %v730, %v729
  %v732 = load ptr, ptr %MEMORY, align 4
  %v733 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v732, ptr %state, i32 %v727, i32 %v731)
  store ptr %v733, ptr %MEMORY, align 4
  store i32 %v726, ptr %PC, align 4
  %v734 = add i32 %v726, 2
  store i32 %v734, ptr %NEXT_PC, align 4
  %v735 = sub i32 %v734, 58
  %v736 = load ptr, ptr %MEMORY, align 4
  %v737 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v736, ptr %state, ptr %BRANCH_TAKEN, i32 %v735, i32 %v734, ptr %NEXT_PC)
  store ptr %v737, ptr %MEMORY, align 4
  br i1 true, label %bb_4204205, label %bb_4204263

bb_4204263:                                       ; preds = %bb_4204248
  store i32 %v734, ptr %PC, align 4
  %v738 = add i32 %v734, 5
  store i32 %v738, ptr %NEXT_PC, align 4
  %v739 = load ptr, ptr %MEMORY, align 4
  %v740 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v739, ptr %state, ptr %EAX, i32 0)
  store ptr %v740, ptr %MEMORY, align 4
  br label %bb_4204268

bb_4204268:                                       ; preds = %bb_4204263, %bb_4204235
  %v741 = load i32, ptr %NEXT_PC, align 4
  store i32 %v741, ptr %PC, align 4
  %v742 = add i32 %v741, 1
  store i32 %v742, ptr %NEXT_PC, align 4
  %v743 = load ptr, ptr %MEMORY, align 4
  %v744 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v743, ptr %state)
  store ptr %v744, ptr %MEMORY, align 4
  store i32 %v742, ptr %PC, align 4
  %v745 = add i32 %v742, 1
  store i32 %v745, ptr %NEXT_PC, align 4
  %v746 = load ptr, ptr %MEMORY, align 4
  %v747 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v746, ptr %state, ptr %NEXT_PC)
  store ptr %v747, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204270:                                       ; No predecessors!
  %v748 = load i32, ptr %NEXT_PC, align 4
  store i32 %v748, ptr %PC, align 4
  %v749 = add i32 %v748, 1
  store i32 %v749, ptr %NEXT_PC, align 4
  %v750 = load i32, ptr %EBP, align 4
  %v751 = load ptr, ptr %MEMORY, align 4
  %v752 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v751, ptr %state, i32 %v750)
  store ptr %v752, ptr %MEMORY, align 4
  store i32 %v749, ptr %PC, align 4
  %v753 = add i32 %v749, 2
  store i32 %v753, ptr %NEXT_PC, align 4
  %v754 = load i32, ptr %ESP, align 4
  %v755 = load ptr, ptr %MEMORY, align 4
  %v756 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v755, ptr %state, ptr %EBP, i32 %v754)
  store ptr %v756, ptr %MEMORY, align 4
  store i32 %v753, ptr %PC, align 4
  %v757 = add i32 %v753, 3
  store i32 %v757, ptr %NEXT_PC, align 4
  %v758 = load i32, ptr %ESP, align 4
  %v759 = load ptr, ptr %MEMORY, align 4
  %v760 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v759, ptr %state, ptr %ESP, i32 %v758, i32 40)
  store ptr %v760, ptr %MEMORY, align 4
  store i32 %v757, ptr %PC, align 4
  %v761 = add i32 %v757, 3
  store i32 %v761, ptr %NEXT_PC, align 4
  %v762 = load i32, ptr %EBP, align 4
  %v763 = load i32, ptr %SSBASE, align 4
  %v764 = add i32 %v762, 8
  %v765 = add i32 %v764, %v763
  %v766 = load ptr, ptr %MEMORY, align 4
  %v767 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v766, ptr %state, ptr %EAX, i32 %v765)
  store ptr %v767, ptr %MEMORY, align 4
  store i32 %v761, ptr %PC, align 4
  %v768 = add i32 %v761, 3
  store i32 %v768, ptr %NEXT_PC, align 4
  %v769 = load i32, ptr %ESP, align 4
  %v770 = load i32, ptr %SSBASE, align 4
  %v771 = add i32 %v769, %v770
  %v772 = load i32, ptr %EAX, align 4
  %v773 = load ptr, ptr %MEMORY, align 4
  %v774 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v773, ptr %state, i32 %v771, i32 %v772)
  store ptr %v774, ptr %MEMORY, align 4
  store i32 %v768, ptr %PC, align 4
  %v775 = add i32 %v768, 5
  store i32 %v775, ptr %NEXT_PC, align 4
  %v776 = add i32 %v775, 24285
  %v777 = load ptr, ptr %MEMORY, align 4
  %v778 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v777, ptr %state, i64 4228572, ptr %NEXT_PC, i32 %v775, ptr %RETURN_PC)
  store ptr %v778, ptr %MEMORY, align 4
  store i32 %v775, ptr %PC, align 4
  %v779 = add i32 %v775, 3
  store i32 %v779, ptr %NEXT_PC, align 4
  %v780 = load i32, ptr %EAX, align 4
  %v781 = load ptr, ptr %MEMORY, align 4
  %v782 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v781, ptr %state, i32 %v780, i32 8)
  store ptr %v782, ptr %MEMORY, align 4
  store i32 %v779, ptr %PC, align 4
  %v783 = add i32 %v779, 2
  store i32 %v783, ptr %NEXT_PC, align 4
  %v784 = add i32 %v783, 10
  %v785 = load ptr, ptr %MEMORY, align 4
  %v786 = call ptr @_ZN12_GLOBAL__N_13JBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v785, ptr %state, ptr %BRANCH_TAKEN, i32 %v784, i32 %v783, ptr %NEXT_PC)
  store ptr %v786, ptr %MEMORY, align 4
  br i1 true, label %bb_4204302, label %bb_4204292

bb_4204292:                                       ; preds = %bb_4204270
  store i32 %v783, ptr %PC, align 4
  %v787 = add i32 %v783, 5
  store i32 %v787, ptr %NEXT_PC, align 4
  %v788 = load ptr, ptr %MEMORY, align 4
  %v789 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v788, ptr %state, ptr %EAX, i32 0)
  store ptr %v789, ptr %MEMORY, align 4
  store i32 %v787, ptr %PC, align 4
  %v790 = add i32 %v787, 5
  store i32 %v790, ptr %NEXT_PC, align 4
  %v791 = add i32 %v790, 138
  %v792 = load ptr, ptr %MEMORY, align 4
  %v793 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v792, ptr %state, i32 %v791, ptr %NEXT_PC)
  store ptr %v793, ptr %MEMORY, align 4
  br label %bb_4204440

bb_4204302:                                       ; preds = %bb_4204270
  store i32 %v783, ptr %PC, align 4
  %v794 = add i32 %v783, 7
  store i32 %v794, ptr %NEXT_PC, align 4
  %v795 = load i32, ptr %EBP, align 4
  %v796 = load i32, ptr %SSBASE, align 4
  %v797 = sub i32 %v795, 20
  %v798 = add i32 %v797, %v796
  %v799 = load ptr, ptr %MEMORY, align 4
  %v800 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v799, ptr %state, i32 %v798, i32 4194304)
  store ptr %v800, ptr %MEMORY, align 4
  store i32 %v794, ptr %PC, align 4
  %v801 = add i32 %v794, 3
  store i32 %v801, ptr %NEXT_PC, align 4
  %v802 = load i32, ptr %EBP, align 4
  %v803 = load i32, ptr %SSBASE, align 4
  %v804 = sub i32 %v802, 20
  %v805 = add i32 %v804, %v803
  %v806 = load ptr, ptr %MEMORY, align 4
  %v807 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v806, ptr %state, ptr %EAX, i32 %v805)
  store ptr %v807, ptr %MEMORY, align 4
  store i32 %v801, ptr %PC, align 4
  %v808 = add i32 %v801, 3
  store i32 %v808, ptr %NEXT_PC, align 4
  %v809 = load i32, ptr %ESP, align 4
  %v810 = load i32, ptr %SSBASE, align 4
  %v811 = add i32 %v809, %v810
  %v812 = load i32, ptr %EAX, align 4
  %v813 = load ptr, ptr %MEMORY, align 4
  %v814 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v813, ptr %state, i32 %v811, i32 %v812)
  store ptr %v814, ptr %MEMORY, align 4
  store i32 %v808, ptr %PC, align 4
  %v815 = add i32 %v808, 5
  store i32 %v815, ptr %NEXT_PC, align 4
  %v816 = sub i32 %v815, 268
  %v817 = load ptr, ptr %MEMORY, align 4
  %v818 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v817, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v815, ptr %RETURN_PC)
  store ptr %v818, ptr %MEMORY, align 4
  store i32 %v815, ptr %PC, align 4
  %v819 = add i32 %v815, 2
  store i32 %v819, ptr %NEXT_PC, align 4
  %v820 = load i32, ptr %EAX, align 4
  %v821 = load i32, ptr %EAX, align 4
  %v822 = load ptr, ptr %MEMORY, align 4
  %v823 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v822, ptr %state, i32 %v820, i32 %v821)
  store ptr %v823, ptr %MEMORY, align 4
  store i32 %v819, ptr %PC, align 4
  %v824 = add i32 %v819, 2
  store i32 %v824, ptr %NEXT_PC, align 4
  %v825 = add i32 %v824, 7
  %v826 = load ptr, ptr %MEMORY, align 4
  %v827 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v826, ptr %state, ptr %BRANCH_TAKEN, i32 %v825, i32 %v824, ptr %NEXT_PC)
  store ptr %v827, ptr %MEMORY, align 4
  br i1 true, label %bb_4204331, label %bb_4204324

bb_4204324:                                       ; preds = %bb_4204302
  store i32 %v824, ptr %PC, align 4
  %v828 = add i32 %v824, 5
  store i32 %v828, ptr %NEXT_PC, align 4
  %v829 = load ptr, ptr %MEMORY, align 4
  %v830 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v829, ptr %state, ptr %EAX, i32 0)
  store ptr %v830, ptr %MEMORY, align 4
  store i32 %v828, ptr %PC, align 4
  %v831 = add i32 %v828, 2
  store i32 %v831, ptr %NEXT_PC, align 4
  %v832 = add i32 %v831, 109
  %v833 = load ptr, ptr %MEMORY, align 4
  %v834 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v833, ptr %state, i32 %v832, ptr %NEXT_PC)
  store ptr %v834, ptr %MEMORY, align 4
  br label %bb_4204440

bb_4204331:                                       ; preds = %bb_4204302
  store i32 %v824, ptr %PC, align 4
  %v835 = add i32 %v824, 3
  store i32 %v835, ptr %NEXT_PC, align 4
  %v836 = load i32, ptr %EBP, align 4
  %v837 = load i32, ptr %SSBASE, align 4
  %v838 = sub i32 %v836, 20
  %v839 = add i32 %v838, %v837
  %v840 = load ptr, ptr %MEMORY, align 4
  %v841 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v840, ptr %state, ptr %EAX, i32 %v839)
  store ptr %v841, ptr %MEMORY, align 4
  store i32 %v835, ptr %PC, align 4
  %v842 = add i32 %v835, 3
  store i32 %v842, ptr %NEXT_PC, align 4
  %v843 = load i32, ptr %EAX, align 4
  %v844 = load i32, ptr %DSBASE, align 4
  %v845 = add i32 %v843, 60
  %v846 = add i32 %v845, %v844
  %v847 = load ptr, ptr %MEMORY, align 4
  %v848 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v847, ptr %state, ptr %EAX, i32 %v846)
  store ptr %v848, ptr %MEMORY, align 4
  store i32 %v842, ptr %PC, align 4
  %v849 = add i32 %v842, 2
  store i32 %v849, ptr %NEXT_PC, align 4
  %v850 = load i32, ptr %EAX, align 4
  %v851 = load ptr, ptr %MEMORY, align 4
  %v852 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v851, ptr %state, ptr %EDX, i32 %v850)
  store ptr %v852, ptr %MEMORY, align 4
  store i32 %v849, ptr %PC, align 4
  %v853 = add i32 %v849, 3
  store i32 %v853, ptr %NEXT_PC, align 4
  %v854 = load i32, ptr %EBP, align 4
  %v855 = load i32, ptr %SSBASE, align 4
  %v856 = sub i32 %v854, 20
  %v857 = add i32 %v856, %v855
  %v858 = load ptr, ptr %MEMORY, align 4
  %v859 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v858, ptr %state, ptr %EAX, i32 %v857)
  store ptr %v859, ptr %MEMORY, align 4
  store i32 %v853, ptr %PC, align 4
  %v860 = add i32 %v853, 2
  store i32 %v860, ptr %NEXT_PC, align 4
  %v861 = load i32, ptr %EAX, align 4
  %v862 = load i32, ptr %EDX, align 4
  %v863 = load ptr, ptr %MEMORY, align 4
  %v864 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v863, ptr %state, ptr %EAX, i32 %v861, i32 %v862)
  store ptr %v864, ptr %MEMORY, align 4
  store i32 %v860, ptr %PC, align 4
  %v865 = add i32 %v860, 3
  store i32 %v865, ptr %NEXT_PC, align 4
  %v866 = load i32, ptr %EBP, align 4
  %v867 = load i32, ptr %SSBASE, align 4
  %v868 = sub i32 %v866, 24
  %v869 = add i32 %v868, %v867
  %v870 = load i32, ptr %EAX, align 4
  %v871 = load ptr, ptr %MEMORY, align 4
  %v872 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v871, ptr %state, i32 %v869, i32 %v870)
  store ptr %v872, ptr %MEMORY, align 4
  store i32 %v865, ptr %PC, align 4
  %v873 = add i32 %v865, 7
  store i32 %v873, ptr %NEXT_PC, align 4
  %v874 = load i32, ptr %EBP, align 4
  %v875 = load i32, ptr %SSBASE, align 4
  %v876 = sub i32 %v874, 16
  %v877 = add i32 %v876, %v875
  %v878 = load ptr, ptr %MEMORY, align 4
  %v879 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v878, ptr %state, i32 %v877, i32 0)
  store ptr %v879, ptr %MEMORY, align 4
  store i32 %v873, ptr %PC, align 4
  %v880 = add i32 %v873, 3
  store i32 %v880, ptr %NEXT_PC, align 4
  %v881 = load i32, ptr %EBP, align 4
  %v882 = load i32, ptr %SSBASE, align 4
  %v883 = sub i32 %v881, 24
  %v884 = add i32 %v883, %v882
  %v885 = load ptr, ptr %MEMORY, align 4
  %v886 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v885, ptr %state, ptr %EAX, i32 %v884)
  store ptr %v886, ptr %MEMORY, align 4
  store i32 %v880, ptr %PC, align 4
  %v887 = add i32 %v880, 4
  store i32 %v887, ptr %NEXT_PC, align 4
  %v888 = load i32, ptr %EAX, align 4
  %v889 = load i32, ptr %DSBASE, align 4
  %v890 = add i32 %v888, 20
  %v891 = add i32 %v890, %v889
  %v892 = load ptr, ptr %MEMORY, align 4
  %v893 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v892, ptr %state, ptr %EAX, i32 %v891)
  store ptr %v893, ptr %MEMORY, align 4
  store i32 %v887, ptr %PC, align 4
  %v894 = add i32 %v887, 3
  store i32 %v894, ptr %NEXT_PC, align 4
  %v895 = load i16, ptr %AX, align 2
  %v896 = zext i16 %v895 to i32
  %v897 = load ptr, ptr %MEMORY, align 4
  %v898 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v897, ptr %state, ptr %EDX, i32 %v896)
  store ptr %v898, ptr %MEMORY, align 4
  store i32 %v894, ptr %PC, align 4
  %v899 = add i32 %v894, 3
  store i32 %v899, ptr %NEXT_PC, align 4
  %v900 = load i32, ptr %EBP, align 4
  %v901 = load i32, ptr %SSBASE, align 4
  %v902 = sub i32 %v900, 24
  %v903 = add i32 %v902, %v901
  %v904 = load ptr, ptr %MEMORY, align 4
  %v905 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v904, ptr %state, ptr %EAX, i32 %v903)
  store ptr %v905, ptr %MEMORY, align 4
  store i32 %v899, ptr %PC, align 4
  %v906 = add i32 %v899, 2
  store i32 %v906, ptr %NEXT_PC, align 4
  %v907 = load i32, ptr %EAX, align 4
  %v908 = load i32, ptr %EDX, align 4
  %v909 = load ptr, ptr %MEMORY, align 4
  %v910 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v909, ptr %state, ptr %EAX, i32 %v907, i32 %v908)
  store ptr %v910, ptr %MEMORY, align 4
  store i32 %v906, ptr %PC, align 4
  %v911 = add i32 %v906, 3
  store i32 %v911, ptr %NEXT_PC, align 4
  %v912 = load i32, ptr %EAX, align 4
  %v913 = load ptr, ptr %MEMORY, align 4
  %v914 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v913, ptr %state, ptr %EAX, i32 %v912, i32 24)
  store ptr %v914, ptr %MEMORY, align 4
  store i32 %v911, ptr %PC, align 4
  %v915 = add i32 %v911, 3
  store i32 %v915, ptr %NEXT_PC, align 4
  %v916 = load i32, ptr %EBP, align 4
  %v917 = load i32, ptr %SSBASE, align 4
  %v918 = sub i32 %v916, 12
  %v919 = add i32 %v918, %v917
  %v920 = load i32, ptr %EAX, align 4
  %v921 = load ptr, ptr %MEMORY, align 4
  %v922 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v921, ptr %state, i32 %v919, i32 %v920)
  store ptr %v922, ptr %MEMORY, align 4
  store i32 %v915, ptr %PC, align 4
  %v923 = add i32 %v915, 2
  store i32 %v923, ptr %NEXT_PC, align 4
  %v924 = add i32 %v923, 43
  %v925 = load ptr, ptr %MEMORY, align 4
  %v926 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v925, ptr %state, i32 %v924, ptr %NEXT_PC)
  store ptr %v926, ptr %MEMORY, align 4
  br label %bb_4204420

bb_4204377:                                       ; preds = %bb_4204420
  store i32 %v1037, ptr %PC, align 4
  %v927 = add i32 %v1037, 3
  store i32 %v927, ptr %NEXT_PC, align 4
  %v928 = load i32, ptr %EBP, align 4
  %v929 = load i32, ptr %SSBASE, align 4
  %v930 = sub i32 %v928, 12
  %v931 = add i32 %v930, %v929
  %v932 = load ptr, ptr %MEMORY, align 4
  %v933 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v932, ptr %state, ptr %EAX, i32 %v931)
  store ptr %v933, ptr %MEMORY, align 4
  store i32 %v927, ptr %PC, align 4
  %v934 = add i32 %v927, 8
  store i32 %v934, ptr %NEXT_PC, align 4
  %v935 = load i32, ptr %ESP, align 4
  %v936 = load i32, ptr %SSBASE, align 4
  %v937 = add i32 %v935, 8
  %v938 = add i32 %v937, %v936
  %v939 = load ptr, ptr %MEMORY, align 4
  %v940 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v939, ptr %state, i32 %v938, i32 8)
  store ptr %v940, ptr %MEMORY, align 4
  store i32 %v934, ptr %PC, align 4
  %v941 = add i32 %v934, 3
  store i32 %v941, ptr %NEXT_PC, align 4
  %v942 = load i32, ptr %EBP, align 4
  %v943 = load i32, ptr %SSBASE, align 4
  %v944 = add i32 %v942, 8
  %v945 = add i32 %v944, %v943
  %v946 = load ptr, ptr %MEMORY, align 4
  %v947 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v946, ptr %state, ptr %EDX, i32 %v945)
  store ptr %v947, ptr %MEMORY, align 4
  store i32 %v941, ptr %PC, align 4
  %v948 = add i32 %v941, 4
  store i32 %v948, ptr %NEXT_PC, align 4
  %v949 = load i32, ptr %ESP, align 4
  %v950 = load i32, ptr %SSBASE, align 4
  %v951 = add i32 %v949, 4
  %v952 = add i32 %v951, %v950
  %v953 = load i32, ptr %EDX, align 4
  %v954 = load ptr, ptr %MEMORY, align 4
  %v955 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v954, ptr %state, i32 %v952, i32 %v953)
  store ptr %v955, ptr %MEMORY, align 4
  store i32 %v948, ptr %PC, align 4
  %v956 = add i32 %v948, 3
  store i32 %v956, ptr %NEXT_PC, align 4
  %v957 = load i32, ptr %ESP, align 4
  %v958 = load i32, ptr %SSBASE, align 4
  %v959 = add i32 %v957, %v958
  %v960 = load i32, ptr %EAX, align 4
  %v961 = load ptr, ptr %MEMORY, align 4
  %v962 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v961, ptr %state, i32 %v959, i32 %v960)
  store ptr %v962, ptr %MEMORY, align 4
  store i32 %v956, ptr %PC, align 4
  %v963 = add i32 %v956, 5
  store i32 %v963, ptr %NEXT_PC, align 4
  %v964 = add i32 %v963, 24241
  %v965 = load ptr, ptr %MEMORY, align 4
  %v966 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v965, ptr %state, i64 4228644, ptr %NEXT_PC, i32 %v963, ptr %RETURN_PC)
  store ptr %v966, ptr %MEMORY, align 4
  store i32 %v963, ptr %PC, align 4
  %v967 = add i32 %v963, 2
  store i32 %v967, ptr %NEXT_PC, align 4
  %v968 = load i32, ptr %EAX, align 4
  %v969 = load i32, ptr %EAX, align 4
  %v970 = load ptr, ptr %MEMORY, align 4
  %v971 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v970, ptr %state, i32 %v968, i32 %v969)
  store ptr %v971, ptr %MEMORY, align 4
  store i32 %v967, ptr %PC, align 4
  %v972 = add i32 %v967, 2
  store i32 %v972, ptr %NEXT_PC, align 4
  %v973 = add i32 %v972, 5
  %v974 = load ptr, ptr %MEMORY, align 4
  %v975 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v974, ptr %state, ptr %BRANCH_TAKEN, i32 %v973, i32 %v972, ptr %NEXT_PC)
  store ptr %v975, ptr %MEMORY, align 4
  br i1 true, label %bb_4204412, label %bb_4204407

bb_4204407:                                       ; preds = %bb_4204377
  store i32 %v972, ptr %PC, align 4
  %v976 = add i32 %v972, 3
  store i32 %v976, ptr %NEXT_PC, align 4
  %v977 = load i32, ptr %EBP, align 4
  %v978 = load i32, ptr %SSBASE, align 4
  %v979 = sub i32 %v977, 12
  %v980 = add i32 %v979, %v978
  %v981 = load ptr, ptr %MEMORY, align 4
  %v982 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v981, ptr %state, ptr %EAX, i32 %v980)
  store ptr %v982, ptr %MEMORY, align 4
  store i32 %v976, ptr %PC, align 4
  %v983 = add i32 %v976, 2
  store i32 %v983, ptr %NEXT_PC, align 4
  %v984 = add i32 %v983, 28
  %v985 = load ptr, ptr %MEMORY, align 4
  %v986 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v985, ptr %state, i32 %v984, ptr %NEXT_PC)
  store ptr %v986, ptr %MEMORY, align 4
  br label %bb_4204440

bb_4204412:                                       ; preds = %bb_4204377
  store i32 %v972, ptr %PC, align 4
  %v987 = add i32 %v972, 4
  store i32 %v987, ptr %NEXT_PC, align 4
  %v988 = load i32, ptr %EBP, align 4
  %v989 = load i32, ptr %SSBASE, align 4
  %v990 = sub i32 %v988, 16
  %v991 = add i32 %v990, %v989
  %v992 = load i32, ptr %EBP, align 4
  %v993 = load i32, ptr %SSBASE, align 4
  %v994 = sub i32 %v992, 16
  %v995 = add i32 %v994, %v993
  %v996 = load ptr, ptr %MEMORY, align 4
  %v997 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v996, ptr %state, i32 %v991, i32 %v995, i32 1)
  store ptr %v997, ptr %MEMORY, align 4
  store i32 %v987, ptr %PC, align 4
  %v998 = add i32 %v987, 4
  store i32 %v998, ptr %NEXT_PC, align 4
  %v999 = load i32, ptr %EBP, align 4
  %v1000 = load i32, ptr %SSBASE, align 4
  %v1001 = sub i32 %v999, 12
  %v1002 = add i32 %v1001, %v1000
  %v1003 = load i32, ptr %EBP, align 4
  %v1004 = load i32, ptr %SSBASE, align 4
  %v1005 = sub i32 %v1003, 12
  %v1006 = add i32 %v1005, %v1004
  %v1007 = load ptr, ptr %MEMORY, align 4
  %v1008 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1007, ptr %state, i32 %v1002, i32 %v1006, i32 40)
  store ptr %v1008, ptr %MEMORY, align 4
  br label %bb_4204420

bb_4204420:                                       ; preds = %bb_4204412, %bb_4204331
  %v1009 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1009, ptr %PC, align 4
  %v1010 = add i32 %v1009, 3
  store i32 %v1010, ptr %NEXT_PC, align 4
  %v1011 = load i32, ptr %EBP, align 4
  %v1012 = load i32, ptr %SSBASE, align 4
  %v1013 = sub i32 %v1011, 24
  %v1014 = add i32 %v1013, %v1012
  %v1015 = load ptr, ptr %MEMORY, align 4
  %v1016 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1015, ptr %state, ptr %EAX, i32 %v1014)
  store ptr %v1016, ptr %MEMORY, align 4
  store i32 %v1010, ptr %PC, align 4
  %v1017 = add i32 %v1010, 4
  store i32 %v1017, ptr %NEXT_PC, align 4
  %v1018 = load i32, ptr %EAX, align 4
  %v1019 = load i32, ptr %DSBASE, align 4
  %v1020 = add i32 %v1018, 6
  %v1021 = add i32 %v1020, %v1019
  %v1022 = load ptr, ptr %MEMORY, align 4
  %v1023 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1022, ptr %state, ptr %EAX, i32 %v1021)
  store ptr %v1023, ptr %MEMORY, align 4
  store i32 %v1017, ptr %PC, align 4
  %v1024 = add i32 %v1017, 3
  store i32 %v1024, ptr %NEXT_PC, align 4
  %v1025 = load i16, ptr %AX, align 2
  %v1026 = zext i16 %v1025 to i32
  %v1027 = load ptr, ptr %MEMORY, align 4
  %v1028 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1027, ptr %state, ptr %EAX, i32 %v1026)
  store ptr %v1028, ptr %MEMORY, align 4
  store i32 %v1024, ptr %PC, align 4
  %v1029 = add i32 %v1024, 3
  store i32 %v1029, ptr %NEXT_PC, align 4
  %v1030 = load i32, ptr %EAX, align 4
  %v1031 = load i32, ptr %EBP, align 4
  %v1032 = load i32, ptr %SSBASE, align 4
  %v1033 = sub i32 %v1031, 16
  %v1034 = add i32 %v1033, %v1032
  %v1035 = load ptr, ptr %MEMORY, align 4
  %v1036 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1035, ptr %state, i32 %v1030, i32 %v1034)
  store ptr %v1036, ptr %MEMORY, align 4
  store i32 %v1029, ptr %PC, align 4
  %v1037 = add i32 %v1029, 2
  store i32 %v1037, ptr %NEXT_PC, align 4
  %v1038 = sub i32 %v1037, 58
  %v1039 = load ptr, ptr %MEMORY, align 4
  %v1040 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1039, ptr %state, ptr %BRANCH_TAKEN, i32 %v1038, i32 %v1037, ptr %NEXT_PC)
  store ptr %v1040, ptr %MEMORY, align 4
  br i1 true, label %bb_4204377, label %bb_4204435

bb_4204435:                                       ; preds = %bb_4204420
  store i32 %v1037, ptr %PC, align 4
  %v1041 = add i32 %v1037, 5
  store i32 %v1041, ptr %NEXT_PC, align 4
  %v1042 = load ptr, ptr %MEMORY, align 4
  %v1043 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1042, ptr %state, ptr %EAX, i32 0)
  store ptr %v1043, ptr %MEMORY, align 4
  br label %bb_4204440

bb_4204440:                                       ; preds = %bb_4204435, %bb_4204407, %bb_4204324, %bb_4204292
  %v1044 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1044, ptr %PC, align 4
  %v1045 = add i32 %v1044, 1
  store i32 %v1045, ptr %NEXT_PC, align 4
  %v1046 = load ptr, ptr %MEMORY, align 4
  %v1047 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1046, ptr %state)
  store ptr %v1047, ptr %MEMORY, align 4
  store i32 %v1045, ptr %PC, align 4
  %v1048 = add i32 %v1045, 1
  store i32 %v1048, ptr %NEXT_PC, align 4
  %v1049 = load ptr, ptr %MEMORY, align 4
  %v1050 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1049, ptr %state, ptr %NEXT_PC)
  store ptr %v1050, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204442:                                       ; No predecessors!
  %v1051 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1051, ptr %PC, align 4
  %v1052 = add i32 %v1051, 1
  store i32 %v1052, ptr %NEXT_PC, align 4
  %v1053 = load i32, ptr %EBP, align 4
  %v1054 = load ptr, ptr %MEMORY, align 4
  %v1055 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1054, ptr %state, i32 %v1053)
  store ptr %v1055, ptr %MEMORY, align 4
  store i32 %v1052, ptr %PC, align 4
  %v1056 = add i32 %v1052, 2
  store i32 %v1056, ptr %NEXT_PC, align 4
  %v1057 = load i32, ptr %ESP, align 4
  %v1058 = load ptr, ptr %MEMORY, align 4
  %v1059 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1058, ptr %state, ptr %EBP, i32 %v1057)
  store ptr %v1059, ptr %MEMORY, align 4
  store i32 %v1056, ptr %PC, align 4
  %v1060 = add i32 %v1056, 3
  store i32 %v1060, ptr %NEXT_PC, align 4
  %v1061 = load i32, ptr %ESP, align 4
  %v1062 = load ptr, ptr %MEMORY, align 4
  %v1063 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1062, ptr %state, ptr %ESP, i32 %v1061, i32 24)
  store ptr %v1063, ptr %MEMORY, align 4
  store i32 %v1060, ptr %PC, align 4
  %v1064 = add i32 %v1060, 7
  store i32 %v1064, ptr %NEXT_PC, align 4
  %v1065 = load i32, ptr %EBP, align 4
  %v1066 = load i32, ptr %SSBASE, align 4
  %v1067 = sub i32 %v1065, 4
  %v1068 = add i32 %v1067, %v1066
  %v1069 = load ptr, ptr %MEMORY, align 4
  %v1070 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1069, ptr %state, i32 %v1068, i32 4194304)
  store ptr %v1070, ptr %MEMORY, align 4
  store i32 %v1064, ptr %PC, align 4
  %v1071 = add i32 %v1064, 3
  store i32 %v1071, ptr %NEXT_PC, align 4
  %v1072 = load i32, ptr %EBP, align 4
  %v1073 = load i32, ptr %SSBASE, align 4
  %v1074 = sub i32 %v1072, 4
  %v1075 = add i32 %v1074, %v1073
  %v1076 = load ptr, ptr %MEMORY, align 4
  %v1077 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1076, ptr %state, ptr %EAX, i32 %v1075)
  store ptr %v1077, ptr %MEMORY, align 4
  store i32 %v1071, ptr %PC, align 4
  %v1078 = add i32 %v1071, 3
  store i32 %v1078, ptr %NEXT_PC, align 4
  %v1079 = load i32, ptr %ESP, align 4
  %v1080 = load i32, ptr %SSBASE, align 4
  %v1081 = add i32 %v1079, %v1080
  %v1082 = load i32, ptr %EAX, align 4
  %v1083 = load ptr, ptr %MEMORY, align 4
  %v1084 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1083, ptr %state, i32 %v1081, i32 %v1082)
  store ptr %v1084, ptr %MEMORY, align 4
  store i32 %v1078, ptr %PC, align 4
  %v1085 = add i32 %v1078, 5
  store i32 %v1085, ptr %NEXT_PC, align 4
  %v1086 = sub i32 %v1085, 414
  %v1087 = load ptr, ptr %MEMORY, align 4
  %v1088 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1087, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v1085, ptr %RETURN_PC)
  store ptr %v1088, ptr %MEMORY, align 4
  store i32 %v1085, ptr %PC, align 4
  %v1089 = add i32 %v1085, 2
  store i32 %v1089, ptr %NEXT_PC, align 4
  %v1090 = load i32, ptr %EAX, align 4
  %v1091 = load i32, ptr %EAX, align 4
  %v1092 = load ptr, ptr %MEMORY, align 4
  %v1093 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1092, ptr %state, i32 %v1090, i32 %v1091)
  store ptr %v1093, ptr %MEMORY, align 4
  store i32 %v1089, ptr %PC, align 4
  %v1094 = add i32 %v1089, 2
  store i32 %v1094, ptr %NEXT_PC, align 4
  %v1095 = add i32 %v1094, 7
  %v1096 = load ptr, ptr %MEMORY, align 4
  %v1097 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1096, ptr %state, ptr %BRANCH_TAKEN, i32 %v1095, i32 %v1094, ptr %NEXT_PC)
  store ptr %v1097, ptr %MEMORY, align 4
  br i1 true, label %bb_4204477, label %bb_4204470

bb_4204470:                                       ; preds = %bb_4204442
  store i32 %v1094, ptr %PC, align 4
  %v1098 = add i32 %v1094, 5
  store i32 %v1098, ptr %NEXT_PC, align 4
  %v1099 = load ptr, ptr %MEMORY, align 4
  %v1100 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1099, ptr %state, ptr %EAX, i32 0)
  store ptr %v1100, ptr %MEMORY, align 4
  store i32 %v1098, ptr %PC, align 4
  %v1101 = add i32 %v1098, 2
  store i32 %v1101, ptr %NEXT_PC, align 4
  %v1102 = add i32 %v1101, 33
  %v1103 = load ptr, ptr %MEMORY, align 4
  %v1104 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1103, ptr %state, i32 %v1102, ptr %NEXT_PC)
  store ptr %v1104, ptr %MEMORY, align 4
  br label %bb_4204510

bb_4204477:                                       ; preds = %bb_4204442
  store i32 %v1094, ptr %PC, align 4
  %v1105 = add i32 %v1094, 3
  store i32 %v1105, ptr %NEXT_PC, align 4
  %v1106 = load i32, ptr %EBP, align 4
  %v1107 = load i32, ptr %SSBASE, align 4
  %v1108 = add i32 %v1106, 8
  %v1109 = add i32 %v1108, %v1107
  %v1110 = load ptr, ptr %MEMORY, align 4
  %v1111 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1110, ptr %state, ptr %EDX, i32 %v1109)
  store ptr %v1111, ptr %MEMORY, align 4
  store i32 %v1105, ptr %PC, align 4
  %v1112 = add i32 %v1105, 3
  store i32 %v1112, ptr %NEXT_PC, align 4
  %v1113 = load i32, ptr %EBP, align 4
  %v1114 = load i32, ptr %SSBASE, align 4
  %v1115 = sub i32 %v1113, 4
  %v1116 = add i32 %v1115, %v1114
  %v1117 = load ptr, ptr %MEMORY, align 4
  %v1118 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1117, ptr %state, ptr %EAX, i32 %v1116)
  store ptr %v1118, ptr %MEMORY, align 4
  store i32 %v1112, ptr %PC, align 4
  %v1119 = add i32 %v1112, 2
  store i32 %v1119, ptr %NEXT_PC, align 4
  %v1120 = load i32, ptr %EDX, align 4
  %v1121 = load ptr, ptr %MEMORY, align 4
  %v1122 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1121, ptr %state, ptr %ECX, i32 %v1120)
  store ptr %v1122, ptr %MEMORY, align 4
  store i32 %v1119, ptr %PC, align 4
  %v1123 = add i32 %v1119, 2
  store i32 %v1123, ptr %NEXT_PC, align 4
  %v1124 = load i32, ptr %ECX, align 4
  %v1125 = load i32, ptr %EAX, align 4
  %v1126 = load ptr, ptr %MEMORY, align 4
  %v1127 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1126, ptr %state, ptr %ECX, i32 %v1124, i32 %v1125)
  store ptr %v1127, ptr %MEMORY, align 4
  store i32 %v1123, ptr %PC, align 4
  %v1128 = add i32 %v1123, 2
  store i32 %v1128, ptr %NEXT_PC, align 4
  %v1129 = load i32, ptr %ECX, align 4
  %v1130 = load ptr, ptr %MEMORY, align 4
  %v1131 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1130, ptr %state, ptr %EAX, i32 %v1129)
  store ptr %v1131, ptr %MEMORY, align 4
  store i32 %v1128, ptr %PC, align 4
  %v1132 = add i32 %v1128, 3
  store i32 %v1132, ptr %NEXT_PC, align 4
  %v1133 = load i32, ptr %EBP, align 4
  %v1134 = load i32, ptr %SSBASE, align 4
  %v1135 = sub i32 %v1133, 8
  %v1136 = add i32 %v1135, %v1134
  %v1137 = load i32, ptr %EAX, align 4
  %v1138 = load ptr, ptr %MEMORY, align 4
  %v1139 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1138, ptr %state, i32 %v1136, i32 %v1137)
  store ptr %v1139, ptr %MEMORY, align 4
  store i32 %v1132, ptr %PC, align 4
  %v1140 = add i32 %v1132, 3
  store i32 %v1140, ptr %NEXT_PC, align 4
  %v1141 = load i32, ptr %EBP, align 4
  %v1142 = load i32, ptr %SSBASE, align 4
  %v1143 = sub i32 %v1141, 8
  %v1144 = add i32 %v1143, %v1142
  %v1145 = load ptr, ptr %MEMORY, align 4
  %v1146 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1145, ptr %state, ptr %EAX, i32 %v1144)
  store ptr %v1146, ptr %MEMORY, align 4
  store i32 %v1140, ptr %PC, align 4
  %v1147 = add i32 %v1140, 4
  store i32 %v1147, ptr %NEXT_PC, align 4
  %v1148 = load i32, ptr %ESP, align 4
  %v1149 = load i32, ptr %SSBASE, align 4
  %v1150 = add i32 %v1148, 4
  %v1151 = add i32 %v1150, %v1149
  %v1152 = load i32, ptr %EAX, align 4
  %v1153 = load ptr, ptr %MEMORY, align 4
  %v1154 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1153, ptr %state, i32 %v1151, i32 %v1152)
  store ptr %v1154, ptr %MEMORY, align 4
  store i32 %v1147, ptr %PC, align 4
  %v1155 = add i32 %v1147, 3
  store i32 %v1155, ptr %NEXT_PC, align 4
  %v1156 = load i32, ptr %EBP, align 4
  %v1157 = load i32, ptr %SSBASE, align 4
  %v1158 = sub i32 %v1156, 4
  %v1159 = add i32 %v1158, %v1157
  %v1160 = load ptr, ptr %MEMORY, align 4
  %v1161 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1160, ptr %state, ptr %EAX, i32 %v1159)
  store ptr %v1161, ptr %MEMORY, align 4
  store i32 %v1155, ptr %PC, align 4
  %v1162 = add i32 %v1155, 3
  store i32 %v1162, ptr %NEXT_PC, align 4
  %v1163 = load i32, ptr %ESP, align 4
  %v1164 = load i32, ptr %SSBASE, align 4
  %v1165 = add i32 %v1163, %v1164
  %v1166 = load i32, ptr %EAX, align 4
  %v1167 = load ptr, ptr %MEMORY, align 4
  %v1168 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1167, ptr %state, i32 %v1165, i32 %v1166)
  store ptr %v1168, ptr %MEMORY, align 4
  store i32 %v1162, ptr %PC, align 4
  %v1169 = add i32 %v1162, 5
  store i32 %v1169, ptr %NEXT_PC, align 4
  %v1170 = sub i32 %v1169, 357
  %v1171 = load ptr, ptr %MEMORY, align 4
  %v1172 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1171, ptr %state, i64 4204153, ptr %NEXT_PC, i32 %v1169, ptr %RETURN_PC)
  store ptr %v1172, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204510:                                       ; preds = %bb_4204470
  store i32 %v1101, ptr %PC, align 4
  %v1173 = add i32 %v1101, 1
  store i32 %v1173, ptr %NEXT_PC, align 4
  %v1174 = load ptr, ptr %MEMORY, align 4
  %v1175 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1174, ptr %state)
  store ptr %v1175, ptr %MEMORY, align 4
  store i32 %v1173, ptr %PC, align 4
  %v1176 = add i32 %v1173, 1
  store i32 %v1176, ptr %NEXT_PC, align 4
  %v1177 = load ptr, ptr %MEMORY, align 4
  %v1178 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1177, ptr %state, ptr %NEXT_PC)
  store ptr %v1178, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204512:                                       ; No predecessors!
  %v1179 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1179, ptr %PC, align 4
  %v1180 = add i32 %v1179, 1
  store i32 %v1180, ptr %NEXT_PC, align 4
  %v1181 = load i32, ptr %EBP, align 4
  %v1182 = load ptr, ptr %MEMORY, align 4
  %v1183 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1182, ptr %state, i32 %v1181)
  store ptr %v1183, ptr %MEMORY, align 4
  store i32 %v1180, ptr %PC, align 4
  %v1184 = add i32 %v1180, 2
  store i32 %v1184, ptr %NEXT_PC, align 4
  %v1185 = load i32, ptr %ESP, align 4
  %v1186 = load ptr, ptr %MEMORY, align 4
  %v1187 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1186, ptr %state, ptr %EBP, i32 %v1185)
  store ptr %v1187, ptr %MEMORY, align 4
  store i32 %v1184, ptr %PC, align 4
  %v1188 = add i32 %v1184, 3
  store i32 %v1188, ptr %NEXT_PC, align 4
  %v1189 = load i32, ptr %ESP, align 4
  %v1190 = load ptr, ptr %MEMORY, align 4
  %v1191 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1190, ptr %state, ptr %ESP, i32 %v1189, i32 20)
  store ptr %v1191, ptr %MEMORY, align 4
  store i32 %v1188, ptr %PC, align 4
  %v1192 = add i32 %v1188, 7
  store i32 %v1192, ptr %NEXT_PC, align 4
  %v1193 = load i32, ptr %EBP, align 4
  %v1194 = load i32, ptr %SSBASE, align 4
  %v1195 = sub i32 %v1193, 4
  %v1196 = add i32 %v1195, %v1194
  %v1197 = load ptr, ptr %MEMORY, align 4
  %v1198 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1197, ptr %state, i32 %v1196, i32 4194304)
  store ptr %v1198, ptr %MEMORY, align 4
  store i32 %v1192, ptr %PC, align 4
  %v1199 = add i32 %v1192, 3
  store i32 %v1199, ptr %NEXT_PC, align 4
  %v1200 = load i32, ptr %EBP, align 4
  %v1201 = load i32, ptr %SSBASE, align 4
  %v1202 = sub i32 %v1200, 4
  %v1203 = add i32 %v1202, %v1201
  %v1204 = load ptr, ptr %MEMORY, align 4
  %v1205 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1204, ptr %state, ptr %EAX, i32 %v1203)
  store ptr %v1205, ptr %MEMORY, align 4
  store i32 %v1199, ptr %PC, align 4
  %v1206 = add i32 %v1199, 3
  store i32 %v1206, ptr %NEXT_PC, align 4
  %v1207 = load i32, ptr %ESP, align 4
  %v1208 = load i32, ptr %SSBASE, align 4
  %v1209 = add i32 %v1207, %v1208
  %v1210 = load i32, ptr %EAX, align 4
  %v1211 = load ptr, ptr %MEMORY, align 4
  %v1212 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1211, ptr %state, i32 %v1209, i32 %v1210)
  store ptr %v1212, ptr %MEMORY, align 4
  store i32 %v1206, ptr %PC, align 4
  %v1213 = add i32 %v1206, 5
  store i32 %v1213, ptr %NEXT_PC, align 4
  %v1214 = sub i32 %v1213, 484
  %v1215 = load ptr, ptr %MEMORY, align 4
  %v1216 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1215, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v1213, ptr %RETURN_PC)
  store ptr %v1216, ptr %MEMORY, align 4
  store i32 %v1213, ptr %PC, align 4
  %v1217 = add i32 %v1213, 2
  store i32 %v1217, ptr %NEXT_PC, align 4
  %v1218 = load i32, ptr %EAX, align 4
  %v1219 = load i32, ptr %EAX, align 4
  %v1220 = load ptr, ptr %MEMORY, align 4
  %v1221 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1220, ptr %state, i32 %v1218, i32 %v1219)
  store ptr %v1221, ptr %MEMORY, align 4
  store i32 %v1217, ptr %PC, align 4
  %v1222 = add i32 %v1217, 2
  store i32 %v1222, ptr %NEXT_PC, align 4
  %v1223 = add i32 %v1222, 7
  %v1224 = load ptr, ptr %MEMORY, align 4
  %v1225 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1224, ptr %state, ptr %BRANCH_TAKEN, i32 %v1223, i32 %v1222, ptr %NEXT_PC)
  store ptr %v1225, ptr %MEMORY, align 4
  br i1 true, label %bb_4204547, label %bb_4204540

bb_4204540:                                       ; preds = %bb_4204512
  store i32 %v1222, ptr %PC, align 4
  %v1226 = add i32 %v1222, 5
  store i32 %v1226, ptr %NEXT_PC, align 4
  %v1227 = load ptr, ptr %MEMORY, align 4
  %v1228 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1227, ptr %state, ptr %EAX, i32 0)
  store ptr %v1228, ptr %MEMORY, align 4
  store i32 %v1226, ptr %PC, align 4
  %v1229 = add i32 %v1226, 2
  store i32 %v1229, ptr %NEXT_PC, align 4
  %v1230 = add i32 %v1229, 26
  %v1231 = load ptr, ptr %MEMORY, align 4
  %v1232 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1231, ptr %state, i32 %v1230, ptr %NEXT_PC)
  store ptr %v1232, ptr %MEMORY, align 4
  br label %bb_4204573

bb_4204547:                                       ; preds = %bb_4204512
  store i32 %v1222, ptr %PC, align 4
  %v1233 = add i32 %v1222, 3
  store i32 %v1233, ptr %NEXT_PC, align 4
  %v1234 = load i32, ptr %EBP, align 4
  %v1235 = load i32, ptr %SSBASE, align 4
  %v1236 = sub i32 %v1234, 4
  %v1237 = add i32 %v1236, %v1235
  %v1238 = load ptr, ptr %MEMORY, align 4
  %v1239 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1238, ptr %state, ptr %EAX, i32 %v1237)
  store ptr %v1239, ptr %MEMORY, align 4
  store i32 %v1233, ptr %PC, align 4
  %v1240 = add i32 %v1233, 3
  store i32 %v1240, ptr %NEXT_PC, align 4
  %v1241 = load i32, ptr %EAX, align 4
  %v1242 = load i32, ptr %DSBASE, align 4
  %v1243 = add i32 %v1241, 60
  %v1244 = add i32 %v1243, %v1242
  %v1245 = load ptr, ptr %MEMORY, align 4
  %v1246 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1245, ptr %state, ptr %EAX, i32 %v1244)
  store ptr %v1246, ptr %MEMORY, align 4
  store i32 %v1240, ptr %PC, align 4
  %v1247 = add i32 %v1240, 2
  store i32 %v1247, ptr %NEXT_PC, align 4
  %v1248 = load i32, ptr %EAX, align 4
  %v1249 = load ptr, ptr %MEMORY, align 4
  %v1250 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1249, ptr %state, ptr %EDX, i32 %v1248)
  store ptr %v1250, ptr %MEMORY, align 4
  store i32 %v1247, ptr %PC, align 4
  %v1251 = add i32 %v1247, 3
  store i32 %v1251, ptr %NEXT_PC, align 4
  %v1252 = load i32, ptr %EBP, align 4
  %v1253 = load i32, ptr %SSBASE, align 4
  %v1254 = sub i32 %v1252, 4
  %v1255 = add i32 %v1254, %v1253
  %v1256 = load ptr, ptr %MEMORY, align 4
  %v1257 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1256, ptr %state, ptr %EAX, i32 %v1255)
  store ptr %v1257, ptr %MEMORY, align 4
  store i32 %v1251, ptr %PC, align 4
  %v1258 = add i32 %v1251, 2
  store i32 %v1258, ptr %NEXT_PC, align 4
  %v1259 = load i32, ptr %EAX, align 4
  %v1260 = load i32, ptr %EDX, align 4
  %v1261 = load ptr, ptr %MEMORY, align 4
  %v1262 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1261, ptr %state, ptr %EAX, i32 %v1259, i32 %v1260)
  store ptr %v1262, ptr %MEMORY, align 4
  store i32 %v1258, ptr %PC, align 4
  %v1263 = add i32 %v1258, 3
  store i32 %v1263, ptr %NEXT_PC, align 4
  %v1264 = load i32, ptr %EBP, align 4
  %v1265 = load i32, ptr %SSBASE, align 4
  %v1266 = sub i32 %v1264, 8
  %v1267 = add i32 %v1266, %v1265
  %v1268 = load i32, ptr %EAX, align 4
  %v1269 = load ptr, ptr %MEMORY, align 4
  %v1270 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1269, ptr %state, i32 %v1267, i32 %v1268)
  store ptr %v1270, ptr %MEMORY, align 4
  store i32 %v1263, ptr %PC, align 4
  %v1271 = add i32 %v1263, 3
  store i32 %v1271, ptr %NEXT_PC, align 4
  %v1272 = load i32, ptr %EBP, align 4
  %v1273 = load i32, ptr %SSBASE, align 4
  %v1274 = sub i32 %v1272, 8
  %v1275 = add i32 %v1274, %v1273
  %v1276 = load ptr, ptr %MEMORY, align 4
  %v1277 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1276, ptr %state, ptr %EAX, i32 %v1275)
  store ptr %v1277, ptr %MEMORY, align 4
  store i32 %v1271, ptr %PC, align 4
  %v1278 = add i32 %v1271, 4
  store i32 %v1278, ptr %NEXT_PC, align 4
  %v1279 = load i32, ptr %EAX, align 4
  %v1280 = load i32, ptr %DSBASE, align 4
  %v1281 = add i32 %v1279, 6
  %v1282 = add i32 %v1281, %v1280
  %v1283 = load ptr, ptr %MEMORY, align 4
  %v1284 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1283, ptr %state, ptr %EAX, i32 %v1282)
  store ptr %v1284, ptr %MEMORY, align 4
  store i32 %v1278, ptr %PC, align 4
  %v1285 = add i32 %v1278, 3
  store i32 %v1285, ptr %NEXT_PC, align 4
  %v1286 = load i16, ptr %AX, align 2
  %v1287 = zext i16 %v1286 to i32
  %v1288 = load ptr, ptr %MEMORY, align 4
  %v1289 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1288, ptr %state, ptr %EAX, i32 %v1287)
  store ptr %v1289, ptr %MEMORY, align 4
  br label %bb_4204573

bb_4204573:                                       ; preds = %bb_4204547, %bb_4204540
  %v1290 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1290, ptr %PC, align 4
  %v1291 = add i32 %v1290, 1
  store i32 %v1291, ptr %NEXT_PC, align 4
  %v1292 = load ptr, ptr %MEMORY, align 4
  %v1293 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1292, ptr %state)
  store ptr %v1293, ptr %MEMORY, align 4
  store i32 %v1291, ptr %PC, align 4
  %v1294 = add i32 %v1291, 1
  store i32 %v1294, ptr %NEXT_PC, align 4
  %v1295 = load ptr, ptr %MEMORY, align 4
  %v1296 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1295, ptr %state, ptr %NEXT_PC)
  store ptr %v1296, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204575:                                       ; No predecessors!
  %v1297 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1297, ptr %PC, align 4
  %v1298 = add i32 %v1297, 1
  store i32 %v1298, ptr %NEXT_PC, align 4
  %v1299 = load i32, ptr %EBP, align 4
  %v1300 = load ptr, ptr %MEMORY, align 4
  %v1301 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1300, ptr %state, i32 %v1299)
  store ptr %v1301, ptr %MEMORY, align 4
  store i32 %v1298, ptr %PC, align 4
  %v1302 = add i32 %v1298, 2
  store i32 %v1302, ptr %NEXT_PC, align 4
  %v1303 = load i32, ptr %ESP, align 4
  %v1304 = load ptr, ptr %MEMORY, align 4
  %v1305 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1304, ptr %state, ptr %EBP, i32 %v1303)
  store ptr %v1305, ptr %MEMORY, align 4
  store i32 %v1302, ptr %PC, align 4
  %v1306 = add i32 %v1302, 3
  store i32 %v1306, ptr %NEXT_PC, align 4
  %v1307 = load i32, ptr %ESP, align 4
  %v1308 = load ptr, ptr %MEMORY, align 4
  %v1309 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1308, ptr %state, ptr %ESP, i32 %v1307, i32 20)
  store ptr %v1309, ptr %MEMORY, align 4
  store i32 %v1306, ptr %PC, align 4
  %v1310 = add i32 %v1306, 7
  store i32 %v1310, ptr %NEXT_PC, align 4
  %v1311 = load i32, ptr %EBP, align 4
  %v1312 = load i32, ptr %SSBASE, align 4
  %v1313 = sub i32 %v1311, 12
  %v1314 = add i32 %v1313, %v1312
  %v1315 = load ptr, ptr %MEMORY, align 4
  %v1316 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1315, ptr %state, i32 %v1314, i32 4194304)
  store ptr %v1316, ptr %MEMORY, align 4
  store i32 %v1310, ptr %PC, align 4
  %v1317 = add i32 %v1310, 3
  store i32 %v1317, ptr %NEXT_PC, align 4
  %v1318 = load i32, ptr %EBP, align 4
  %v1319 = load i32, ptr %SSBASE, align 4
  %v1320 = sub i32 %v1318, 12
  %v1321 = add i32 %v1320, %v1319
  %v1322 = load ptr, ptr %MEMORY, align 4
  %v1323 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1322, ptr %state, ptr %EAX, i32 %v1321)
  store ptr %v1323, ptr %MEMORY, align 4
  store i32 %v1317, ptr %PC, align 4
  %v1324 = add i32 %v1317, 3
  store i32 %v1324, ptr %NEXT_PC, align 4
  %v1325 = load i32, ptr %ESP, align 4
  %v1326 = load i32, ptr %SSBASE, align 4
  %v1327 = add i32 %v1325, %v1326
  %v1328 = load i32, ptr %EAX, align 4
  %v1329 = load ptr, ptr %MEMORY, align 4
  %v1330 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1329, ptr %state, i32 %v1327, i32 %v1328)
  store ptr %v1330, ptr %MEMORY, align 4
  store i32 %v1324, ptr %PC, align 4
  %v1331 = add i32 %v1324, 5
  store i32 %v1331, ptr %NEXT_PC, align 4
  %v1332 = sub i32 %v1331, 547
  %v1333 = load ptr, ptr %MEMORY, align 4
  %v1334 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1333, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v1331, ptr %RETURN_PC)
  store ptr %v1334, ptr %MEMORY, align 4
  store i32 %v1331, ptr %PC, align 4
  %v1335 = add i32 %v1331, 2
  store i32 %v1335, ptr %NEXT_PC, align 4
  %v1336 = load i32, ptr %EAX, align 4
  %v1337 = load i32, ptr %EAX, align 4
  %v1338 = load ptr, ptr %MEMORY, align 4
  %v1339 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1338, ptr %state, i32 %v1336, i32 %v1337)
  store ptr %v1339, ptr %MEMORY, align 4
  store i32 %v1335, ptr %PC, align 4
  %v1340 = add i32 %v1335, 2
  store i32 %v1340, ptr %NEXT_PC, align 4
  %v1341 = add i32 %v1340, 7
  %v1342 = load ptr, ptr %MEMORY, align 4
  %v1343 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1342, ptr %state, ptr %BRANCH_TAKEN, i32 %v1341, i32 %v1340, ptr %NEXT_PC)
  store ptr %v1343, ptr %MEMORY, align 4
  br i1 true, label %bb_4204610, label %bb_4204603

bb_4204603:                                       ; preds = %bb_4204575
  store i32 %v1340, ptr %PC, align 4
  %v1344 = add i32 %v1340, 5
  store i32 %v1344, ptr %NEXT_PC, align 4
  %v1345 = load ptr, ptr %MEMORY, align 4
  %v1346 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1345, ptr %state, ptr %EAX, i32 0)
  store ptr %v1346, ptr %MEMORY, align 4
  store i32 %v1344, ptr %PC, align 4
  %v1347 = add i32 %v1344, 2
  store i32 %v1347, ptr %NEXT_PC, align 4
  %v1348 = add i32 %v1347, 104
  %v1349 = load ptr, ptr %MEMORY, align 4
  %v1350 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1349, ptr %state, i32 %v1348, ptr %NEXT_PC)
  store ptr %v1350, ptr %MEMORY, align 4
  br label %bb_4204714

bb_4204610:                                       ; preds = %bb_4204575
  store i32 %v1340, ptr %PC, align 4
  %v1351 = add i32 %v1340, 3
  store i32 %v1351, ptr %NEXT_PC, align 4
  %v1352 = load i32, ptr %EBP, align 4
  %v1353 = load i32, ptr %SSBASE, align 4
  %v1354 = sub i32 %v1352, 12
  %v1355 = add i32 %v1354, %v1353
  %v1356 = load ptr, ptr %MEMORY, align 4
  %v1357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1356, ptr %state, ptr %EAX, i32 %v1355)
  store ptr %v1357, ptr %MEMORY, align 4
  store i32 %v1351, ptr %PC, align 4
  %v1358 = add i32 %v1351, 3
  store i32 %v1358, ptr %NEXT_PC, align 4
  %v1359 = load i32, ptr %EAX, align 4
  %v1360 = load i32, ptr %DSBASE, align 4
  %v1361 = add i32 %v1359, 60
  %v1362 = add i32 %v1361, %v1360
  %v1363 = load ptr, ptr %MEMORY, align 4
  %v1364 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1363, ptr %state, ptr %EAX, i32 %v1362)
  store ptr %v1364, ptr %MEMORY, align 4
  store i32 %v1358, ptr %PC, align 4
  %v1365 = add i32 %v1358, 2
  store i32 %v1365, ptr %NEXT_PC, align 4
  %v1366 = load i32, ptr %EAX, align 4
  %v1367 = load ptr, ptr %MEMORY, align 4
  %v1368 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1367, ptr %state, ptr %EDX, i32 %v1366)
  store ptr %v1368, ptr %MEMORY, align 4
  store i32 %v1365, ptr %PC, align 4
  %v1369 = add i32 %v1365, 3
  store i32 %v1369, ptr %NEXT_PC, align 4
  %v1370 = load i32, ptr %EBP, align 4
  %v1371 = load i32, ptr %SSBASE, align 4
  %v1372 = sub i32 %v1370, 12
  %v1373 = add i32 %v1372, %v1371
  %v1374 = load ptr, ptr %MEMORY, align 4
  %v1375 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1374, ptr %state, ptr %EAX, i32 %v1373)
  store ptr %v1375, ptr %MEMORY, align 4
  store i32 %v1369, ptr %PC, align 4
  %v1376 = add i32 %v1369, 2
  store i32 %v1376, ptr %NEXT_PC, align 4
  %v1377 = load i32, ptr %EAX, align 4
  %v1378 = load i32, ptr %EDX, align 4
  %v1379 = load ptr, ptr %MEMORY, align 4
  %v1380 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1379, ptr %state, ptr %EAX, i32 %v1377, i32 %v1378)
  store ptr %v1380, ptr %MEMORY, align 4
  store i32 %v1376, ptr %PC, align 4
  %v1381 = add i32 %v1376, 3
  store i32 %v1381, ptr %NEXT_PC, align 4
  %v1382 = load i32, ptr %EBP, align 4
  %v1383 = load i32, ptr %SSBASE, align 4
  %v1384 = sub i32 %v1382, 16
  %v1385 = add i32 %v1384, %v1383
  %v1386 = load i32, ptr %EAX, align 4
  %v1387 = load ptr, ptr %MEMORY, align 4
  %v1388 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1387, ptr %state, i32 %v1385, i32 %v1386)
  store ptr %v1388, ptr %MEMORY, align 4
  store i32 %v1381, ptr %PC, align 4
  %v1389 = add i32 %v1381, 7
  store i32 %v1389, ptr %NEXT_PC, align 4
  %v1390 = load i32, ptr %EBP, align 4
  %v1391 = load i32, ptr %SSBASE, align 4
  %v1392 = sub i32 %v1390, 8
  %v1393 = add i32 %v1392, %v1391
  %v1394 = load ptr, ptr %MEMORY, align 4
  %v1395 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1394, ptr %state, i32 %v1393, i32 0)
  store ptr %v1395, ptr %MEMORY, align 4
  store i32 %v1389, ptr %PC, align 4
  %v1396 = add i32 %v1389, 3
  store i32 %v1396, ptr %NEXT_PC, align 4
  %v1397 = load i32, ptr %EBP, align 4
  %v1398 = load i32, ptr %SSBASE, align 4
  %v1399 = sub i32 %v1397, 16
  %v1400 = add i32 %v1399, %v1398
  %v1401 = load ptr, ptr %MEMORY, align 4
  %v1402 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1401, ptr %state, ptr %EAX, i32 %v1400)
  store ptr %v1402, ptr %MEMORY, align 4
  store i32 %v1396, ptr %PC, align 4
  %v1403 = add i32 %v1396, 4
  store i32 %v1403, ptr %NEXT_PC, align 4
  %v1404 = load i32, ptr %EAX, align 4
  %v1405 = load i32, ptr %DSBASE, align 4
  %v1406 = add i32 %v1404, 20
  %v1407 = add i32 %v1406, %v1405
  %v1408 = load ptr, ptr %MEMORY, align 4
  %v1409 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1408, ptr %state, ptr %EAX, i32 %v1407)
  store ptr %v1409, ptr %MEMORY, align 4
  store i32 %v1403, ptr %PC, align 4
  %v1410 = add i32 %v1403, 3
  store i32 %v1410, ptr %NEXT_PC, align 4
  %v1411 = load i16, ptr %AX, align 2
  %v1412 = zext i16 %v1411 to i32
  %v1413 = load ptr, ptr %MEMORY, align 4
  %v1414 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1413, ptr %state, ptr %EDX, i32 %v1412)
  store ptr %v1414, ptr %MEMORY, align 4
  store i32 %v1410, ptr %PC, align 4
  %v1415 = add i32 %v1410, 3
  store i32 %v1415, ptr %NEXT_PC, align 4
  %v1416 = load i32, ptr %EBP, align 4
  %v1417 = load i32, ptr %SSBASE, align 4
  %v1418 = sub i32 %v1416, 16
  %v1419 = add i32 %v1418, %v1417
  %v1420 = load ptr, ptr %MEMORY, align 4
  %v1421 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1420, ptr %state, ptr %EAX, i32 %v1419)
  store ptr %v1421, ptr %MEMORY, align 4
  store i32 %v1415, ptr %PC, align 4
  %v1422 = add i32 %v1415, 2
  store i32 %v1422, ptr %NEXT_PC, align 4
  %v1423 = load i32, ptr %EAX, align 4
  %v1424 = load i32, ptr %EDX, align 4
  %v1425 = load ptr, ptr %MEMORY, align 4
  %v1426 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1425, ptr %state, ptr %EAX, i32 %v1423, i32 %v1424)
  store ptr %v1426, ptr %MEMORY, align 4
  store i32 %v1422, ptr %PC, align 4
  %v1427 = add i32 %v1422, 3
  store i32 %v1427, ptr %NEXT_PC, align 4
  %v1428 = load i32, ptr %EAX, align 4
  %v1429 = load ptr, ptr %MEMORY, align 4
  %v1430 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1429, ptr %state, ptr %EAX, i32 %v1428, i32 24)
  store ptr %v1430, ptr %MEMORY, align 4
  store i32 %v1427, ptr %PC, align 4
  %v1431 = add i32 %v1427, 3
  store i32 %v1431, ptr %NEXT_PC, align 4
  %v1432 = load i32, ptr %EBP, align 4
  %v1433 = load i32, ptr %SSBASE, align 4
  %v1434 = sub i32 %v1432, 4
  %v1435 = add i32 %v1434, %v1433
  %v1436 = load i32, ptr %EAX, align 4
  %v1437 = load ptr, ptr %MEMORY, align 4
  %v1438 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1437, ptr %state, i32 %v1435, i32 %v1436)
  store ptr %v1438, ptr %MEMORY, align 4
  store i32 %v1431, ptr %PC, align 4
  %v1439 = add i32 %v1431, 2
  store i32 %v1439, ptr %NEXT_PC, align 4
  %v1440 = add i32 %v1439, 38
  %v1441 = load ptr, ptr %MEMORY, align 4
  %v1442 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1441, ptr %state, i32 %v1440, ptr %NEXT_PC)
  store ptr %v1442, ptr %MEMORY, align 4
  br label %bb_4204694

bb_4204656:                                       ; preds = %bb_4204694
  store i32 %v1554, ptr %PC, align 4
  %v1443 = add i32 %v1554, 3
  store i32 %v1443, ptr %NEXT_PC, align 4
  %v1444 = load i32, ptr %EBP, align 4
  %v1445 = load i32, ptr %SSBASE, align 4
  %v1446 = sub i32 %v1444, 4
  %v1447 = add i32 %v1446, %v1445
  %v1448 = load ptr, ptr %MEMORY, align 4
  %v1449 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1448, ptr %state, ptr %EAX, i32 %v1447)
  store ptr %v1449, ptr %MEMORY, align 4
  store i32 %v1443, ptr %PC, align 4
  %v1450 = add i32 %v1443, 3
  store i32 %v1450, ptr %NEXT_PC, align 4
  %v1451 = load i32, ptr %EAX, align 4
  %v1452 = load i32, ptr %DSBASE, align 4
  %v1453 = add i32 %v1451, 36
  %v1454 = add i32 %v1453, %v1452
  %v1455 = load ptr, ptr %MEMORY, align 4
  %v1456 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1455, ptr %state, ptr %EAX, i32 %v1454)
  store ptr %v1456, ptr %MEMORY, align 4
  store i32 %v1450, ptr %PC, align 4
  %v1457 = add i32 %v1450, 5
  store i32 %v1457, ptr %NEXT_PC, align 4
  %v1458 = load i32, ptr %EAX, align 4
  %v1459 = load ptr, ptr %MEMORY, align 4
  %v1460 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1459, ptr %state, ptr %EAX, i32 %v1458, i32 536870912)
  store ptr %v1460, ptr %MEMORY, align 4
  store i32 %v1457, ptr %PC, align 4
  %v1461 = add i32 %v1457, 2
  store i32 %v1461, ptr %NEXT_PC, align 4
  %v1462 = load i32, ptr %EAX, align 4
  %v1463 = load i32, ptr %EAX, align 4
  %v1464 = load ptr, ptr %MEMORY, align 4
  %v1465 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1464, ptr %state, i32 %v1462, i32 %v1463)
  store ptr %v1465, ptr %MEMORY, align 4
  store i32 %v1461, ptr %PC, align 4
  %v1466 = add i32 %v1461, 2
  store i32 %v1466, ptr %NEXT_PC, align 4
  %v1467 = add i32 %v1466, 15
  %v1468 = load ptr, ptr %MEMORY, align 4
  %v1469 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1468, ptr %state, ptr %BRANCH_TAKEN, i32 %v1467, i32 %v1466, ptr %NEXT_PC)
  store ptr %v1469, ptr %MEMORY, align 4
  br i1 true, label %bb_4204686, label %bb_4204671

bb_4204671:                                       ; preds = %bb_4204656
  store i32 %v1466, ptr %PC, align 4
  %v1470 = add i32 %v1466, 4
  store i32 %v1470, ptr %NEXT_PC, align 4
  %v1471 = load i32, ptr %EBP, align 4
  %v1472 = load i32, ptr %SSBASE, align 4
  %v1473 = add i32 %v1471, 8
  %v1474 = add i32 %v1473, %v1472
  %v1475 = load ptr, ptr %MEMORY, align 4
  %v1476 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1475, ptr %state, i32 %v1474, i32 0)
  store ptr %v1476, ptr %MEMORY, align 4
  store i32 %v1470, ptr %PC, align 4
  %v1477 = add i32 %v1470, 2
  store i32 %v1477, ptr %NEXT_PC, align 4
  %v1478 = add i32 %v1477, 5
  %v1479 = load ptr, ptr %MEMORY, align 4
  %v1480 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1479, ptr %state, ptr %BRANCH_TAKEN, i32 %v1478, i32 %v1477, ptr %NEXT_PC)
  store ptr %v1480, ptr %MEMORY, align 4
  br i1 true, label %bb_4204682, label %bb_4204677

bb_4204677:                                       ; preds = %bb_4204671
  store i32 %v1477, ptr %PC, align 4
  %v1481 = add i32 %v1477, 3
  store i32 %v1481, ptr %NEXT_PC, align 4
  %v1482 = load i32, ptr %EBP, align 4
  %v1483 = load i32, ptr %SSBASE, align 4
  %v1484 = sub i32 %v1482, 4
  %v1485 = add i32 %v1484, %v1483
  %v1486 = load ptr, ptr %MEMORY, align 4
  %v1487 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1486, ptr %state, ptr %EAX, i32 %v1485)
  store ptr %v1487, ptr %MEMORY, align 4
  store i32 %v1481, ptr %PC, align 4
  %v1488 = add i32 %v1481, 2
  store i32 %v1488, ptr %NEXT_PC, align 4
  %v1489 = add i32 %v1488, 32
  %v1490 = load ptr, ptr %MEMORY, align 4
  %v1491 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1490, ptr %state, i32 %v1489, ptr %NEXT_PC)
  store ptr %v1491, ptr %MEMORY, align 4
  br label %bb_4204714

bb_4204682:                                       ; preds = %bb_4204671
  store i32 %v1477, ptr %PC, align 4
  %v1492 = add i32 %v1477, 4
  store i32 %v1492, ptr %NEXT_PC, align 4
  %v1493 = load i32, ptr %EBP, align 4
  %v1494 = load i32, ptr %SSBASE, align 4
  %v1495 = add i32 %v1493, 8
  %v1496 = add i32 %v1495, %v1494
  %v1497 = load i32, ptr %EBP, align 4
  %v1498 = load i32, ptr %SSBASE, align 4
  %v1499 = add i32 %v1497, 8
  %v1500 = add i32 %v1499, %v1498
  %v1501 = load ptr, ptr %MEMORY, align 4
  %v1502 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1501, ptr %state, i32 %v1496, i32 %v1500, i32 1)
  store ptr %v1502, ptr %MEMORY, align 4
  br label %bb_4204686

bb_4204686:                                       ; preds = %bb_4204682, %bb_4204656
  %v1503 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1503, ptr %PC, align 4
  %v1504 = add i32 %v1503, 4
  store i32 %v1504, ptr %NEXT_PC, align 4
  %v1505 = load i32, ptr %EBP, align 4
  %v1506 = load i32, ptr %SSBASE, align 4
  %v1507 = sub i32 %v1505, 8
  %v1508 = add i32 %v1507, %v1506
  %v1509 = load i32, ptr %EBP, align 4
  %v1510 = load i32, ptr %SSBASE, align 4
  %v1511 = sub i32 %v1509, 8
  %v1512 = add i32 %v1511, %v1510
  %v1513 = load ptr, ptr %MEMORY, align 4
  %v1514 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1513, ptr %state, i32 %v1508, i32 %v1512, i32 1)
  store ptr %v1514, ptr %MEMORY, align 4
  store i32 %v1504, ptr %PC, align 4
  %v1515 = add i32 %v1504, 4
  store i32 %v1515, ptr %NEXT_PC, align 4
  %v1516 = load i32, ptr %EBP, align 4
  %v1517 = load i32, ptr %SSBASE, align 4
  %v1518 = sub i32 %v1516, 4
  %v1519 = add i32 %v1518, %v1517
  %v1520 = load i32, ptr %EBP, align 4
  %v1521 = load i32, ptr %SSBASE, align 4
  %v1522 = sub i32 %v1520, 4
  %v1523 = add i32 %v1522, %v1521
  %v1524 = load ptr, ptr %MEMORY, align 4
  %v1525 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1524, ptr %state, i32 %v1519, i32 %v1523, i32 40)
  store ptr %v1525, ptr %MEMORY, align 4
  br label %bb_4204694

bb_4204694:                                       ; preds = %bb_4204686, %bb_4204610
  %v1526 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1526, ptr %PC, align 4
  %v1527 = add i32 %v1526, 3
  store i32 %v1527, ptr %NEXT_PC, align 4
  %v1528 = load i32, ptr %EBP, align 4
  %v1529 = load i32, ptr %SSBASE, align 4
  %v1530 = sub i32 %v1528, 16
  %v1531 = add i32 %v1530, %v1529
  %v1532 = load ptr, ptr %MEMORY, align 4
  %v1533 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1532, ptr %state, ptr %EAX, i32 %v1531)
  store ptr %v1533, ptr %MEMORY, align 4
  store i32 %v1527, ptr %PC, align 4
  %v1534 = add i32 %v1527, 4
  store i32 %v1534, ptr %NEXT_PC, align 4
  %v1535 = load i32, ptr %EAX, align 4
  %v1536 = load i32, ptr %DSBASE, align 4
  %v1537 = add i32 %v1535, 6
  %v1538 = add i32 %v1537, %v1536
  %v1539 = load ptr, ptr %MEMORY, align 4
  %v1540 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v1539, ptr %state, ptr %EAX, i32 %v1538)
  store ptr %v1540, ptr %MEMORY, align 4
  store i32 %v1534, ptr %PC, align 4
  %v1541 = add i32 %v1534, 3
  store i32 %v1541, ptr %NEXT_PC, align 4
  %v1542 = load i16, ptr %AX, align 2
  %v1543 = zext i16 %v1542 to i32
  %v1544 = load ptr, ptr %MEMORY, align 4
  %v1545 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1544, ptr %state, ptr %EAX, i32 %v1543)
  store ptr %v1545, ptr %MEMORY, align 4
  store i32 %v1541, ptr %PC, align 4
  %v1546 = add i32 %v1541, 3
  store i32 %v1546, ptr %NEXT_PC, align 4
  %v1547 = load i32, ptr %EAX, align 4
  %v1548 = load i32, ptr %EBP, align 4
  %v1549 = load i32, ptr %SSBASE, align 4
  %v1550 = sub i32 %v1548, 8
  %v1551 = add i32 %v1550, %v1549
  %v1552 = load ptr, ptr %MEMORY, align 4
  %v1553 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1552, ptr %state, i32 %v1547, i32 %v1551)
  store ptr %v1553, ptr %MEMORY, align 4
  store i32 %v1546, ptr %PC, align 4
  %v1554 = add i32 %v1546, 2
  store i32 %v1554, ptr %NEXT_PC, align 4
  %v1555 = sub i32 %v1554, 53
  %v1556 = load ptr, ptr %MEMORY, align 4
  %v1557 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1556, ptr %state, ptr %BRANCH_TAKEN, i32 %v1555, i32 %v1554, ptr %NEXT_PC)
  store ptr %v1557, ptr %MEMORY, align 4
  br i1 true, label %bb_4204656, label %bb_4204709

bb_4204709:                                       ; preds = %bb_4204694
  store i32 %v1554, ptr %PC, align 4
  %v1558 = add i32 %v1554, 5
  store i32 %v1558, ptr %NEXT_PC, align 4
  %v1559 = load ptr, ptr %MEMORY, align 4
  %v1560 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1559, ptr %state, ptr %EAX, i32 0)
  store ptr %v1560, ptr %MEMORY, align 4
  br label %bb_4204714

bb_4204714:                                       ; preds = %bb_4204709, %bb_4204677, %bb_4204603
  %v1561 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1561, ptr %PC, align 4
  %v1562 = add i32 %v1561, 1
  store i32 %v1562, ptr %NEXT_PC, align 4
  %v1563 = load ptr, ptr %MEMORY, align 4
  %v1564 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1563, ptr %state)
  store ptr %v1564, ptr %MEMORY, align 4
  store i32 %v1562, ptr %PC, align 4
  %v1565 = add i32 %v1562, 1
  store i32 %v1565, ptr %NEXT_PC, align 4
  %v1566 = load ptr, ptr %MEMORY, align 4
  %v1567 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1566, ptr %state, ptr %NEXT_PC)
  store ptr %v1567, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204716:                                       ; No predecessors!
  %v1568 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1568, ptr %PC, align 4
  %v1569 = add i32 %v1568, 1
  store i32 %v1569, ptr %NEXT_PC, align 4
  %v1570 = load i32, ptr %EBP, align 4
  %v1571 = load ptr, ptr %MEMORY, align 4
  %v1572 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1571, ptr %state, i32 %v1570)
  store ptr %v1572, ptr %MEMORY, align 4
  store i32 %v1569, ptr %PC, align 4
  %v1573 = add i32 %v1569, 2
  store i32 %v1573, ptr %NEXT_PC, align 4
  %v1574 = load i32, ptr %ESP, align 4
  %v1575 = load ptr, ptr %MEMORY, align 4
  %v1576 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1575, ptr %state, ptr %EBP, i32 %v1574)
  store ptr %v1576, ptr %MEMORY, align 4
  store i32 %v1573, ptr %PC, align 4
  %v1577 = add i32 %v1573, 3
  store i32 %v1577, ptr %NEXT_PC, align 4
  %v1578 = load i32, ptr %ESP, align 4
  %v1579 = load ptr, ptr %MEMORY, align 4
  %v1580 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1579, ptr %state, ptr %ESP, i32 %v1578, i32 20)
  store ptr %v1580, ptr %MEMORY, align 4
  store i32 %v1577, ptr %PC, align 4
  %v1581 = add i32 %v1577, 7
  store i32 %v1581, ptr %NEXT_PC, align 4
  %v1582 = load i32, ptr %EBP, align 4
  %v1583 = load i32, ptr %SSBASE, align 4
  %v1584 = sub i32 %v1582, 4
  %v1585 = add i32 %v1584, %v1583
  %v1586 = load ptr, ptr %MEMORY, align 4
  %v1587 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1586, ptr %state, i32 %v1585, i32 4194304)
  store ptr %v1587, ptr %MEMORY, align 4
  store i32 %v1581, ptr %PC, align 4
  %v1588 = add i32 %v1581, 3
  store i32 %v1588, ptr %NEXT_PC, align 4
  %v1589 = load i32, ptr %EBP, align 4
  %v1590 = load i32, ptr %SSBASE, align 4
  %v1591 = sub i32 %v1589, 4
  %v1592 = add i32 %v1591, %v1590
  %v1593 = load ptr, ptr %MEMORY, align 4
  %v1594 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1593, ptr %state, ptr %EAX, i32 %v1592)
  store ptr %v1594, ptr %MEMORY, align 4
  store i32 %v1588, ptr %PC, align 4
  %v1595 = add i32 %v1588, 3
  store i32 %v1595, ptr %NEXT_PC, align 4
  %v1596 = load i32, ptr %ESP, align 4
  %v1597 = load i32, ptr %SSBASE, align 4
  %v1598 = add i32 %v1596, %v1597
  %v1599 = load i32, ptr %EAX, align 4
  %v1600 = load ptr, ptr %MEMORY, align 4
  %v1601 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1600, ptr %state, i32 %v1598, i32 %v1599)
  store ptr %v1601, ptr %MEMORY, align 4
  store i32 %v1595, ptr %PC, align 4
  %v1602 = add i32 %v1595, 5
  store i32 %v1602, ptr %NEXT_PC, align 4
  %v1603 = sub i32 %v1602, 688
  %v1604 = load ptr, ptr %MEMORY, align 4
  %v1605 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1604, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v1602, ptr %RETURN_PC)
  store ptr %v1605, ptr %MEMORY, align 4
  store i32 %v1602, ptr %PC, align 4
  %v1606 = add i32 %v1602, 2
  store i32 %v1606, ptr %NEXT_PC, align 4
  %v1607 = load i32, ptr %EAX, align 4
  %v1608 = load i32, ptr %EAX, align 4
  %v1609 = load ptr, ptr %MEMORY, align 4
  %v1610 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1609, ptr %state, i32 %v1607, i32 %v1608)
  store ptr %v1610, ptr %MEMORY, align 4
  store i32 %v1606, ptr %PC, align 4
  %v1611 = add i32 %v1606, 2
  store i32 %v1611, ptr %NEXT_PC, align 4
  %v1612 = add i32 %v1611, 7
  %v1613 = load ptr, ptr %MEMORY, align 4
  %v1614 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1613, ptr %state, ptr %BRANCH_TAKEN, i32 %v1612, i32 %v1611, ptr %NEXT_PC)
  store ptr %v1614, ptr %MEMORY, align 4
  br i1 true, label %bb_4204751, label %bb_4204744

bb_4204744:                                       ; preds = %bb_4204716
  store i32 %v1611, ptr %PC, align 4
  %v1615 = add i32 %v1611, 5
  store i32 %v1615, ptr %NEXT_PC, align 4
  %v1616 = load ptr, ptr %MEMORY, align 4
  %v1617 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1616, ptr %state, ptr %EAX, i32 0)
  store ptr %v1617, ptr %MEMORY, align 4
  store i32 %v1615, ptr %PC, align 4
  %v1618 = add i32 %v1615, 2
  store i32 %v1618, ptr %NEXT_PC, align 4
  %v1619 = add i32 %v1618, 3
  %v1620 = load ptr, ptr %MEMORY, align 4
  %v1621 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1620, ptr %state, i32 %v1619, ptr %NEXT_PC)
  store ptr %v1621, ptr %MEMORY, align 4
  br label %bb_4204754

bb_4204751:                                       ; preds = %bb_4204716
  store i32 %v1611, ptr %PC, align 4
  %v1622 = add i32 %v1611, 3
  store i32 %v1622, ptr %NEXT_PC, align 4
  %v1623 = load i32, ptr %EBP, align 4
  %v1624 = load i32, ptr %SSBASE, align 4
  %v1625 = sub i32 %v1623, 4
  %v1626 = add i32 %v1625, %v1624
  %v1627 = load ptr, ptr %MEMORY, align 4
  %v1628 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1627, ptr %state, ptr %EAX, i32 %v1626)
  store ptr %v1628, ptr %MEMORY, align 4
  br label %bb_4204754

bb_4204754:                                       ; preds = %bb_4204751, %bb_4204744
  %v1629 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1629, ptr %PC, align 4
  %v1630 = add i32 %v1629, 1
  store i32 %v1630, ptr %NEXT_PC, align 4
  %v1631 = load ptr, ptr %MEMORY, align 4
  %v1632 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1631, ptr %state)
  store ptr %v1632, ptr %MEMORY, align 4
  store i32 %v1630, ptr %PC, align 4
  %v1633 = add i32 %v1630, 1
  store i32 %v1633, ptr %NEXT_PC, align 4
  %v1634 = load ptr, ptr %MEMORY, align 4
  %v1635 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1634, ptr %state, ptr %NEXT_PC)
  store ptr %v1635, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204756:                                       ; No predecessors!
  %v1636 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1636, ptr %PC, align 4
  %v1637 = add i32 %v1636, 1
  store i32 %v1637, ptr %NEXT_PC, align 4
  %v1638 = load i32, ptr %EBP, align 4
  %v1639 = load ptr, ptr %MEMORY, align 4
  %v1640 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1639, ptr %state, i32 %v1638)
  store ptr %v1640, ptr %MEMORY, align 4
  store i32 %v1637, ptr %PC, align 4
  %v1641 = add i32 %v1637, 2
  store i32 %v1641, ptr %NEXT_PC, align 4
  %v1642 = load i32, ptr %ESP, align 4
  %v1643 = load ptr, ptr %MEMORY, align 4
  %v1644 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1643, ptr %state, ptr %EBP, i32 %v1642)
  store ptr %v1644, ptr %MEMORY, align 4
  store i32 %v1641, ptr %PC, align 4
  %v1645 = add i32 %v1641, 3
  store i32 %v1645, ptr %NEXT_PC, align 4
  %v1646 = load i32, ptr %ESP, align 4
  %v1647 = load ptr, ptr %MEMORY, align 4
  %v1648 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1647, ptr %state, ptr %ESP, i32 %v1646, i32 24)
  store ptr %v1648, ptr %MEMORY, align 4
  store i32 %v1645, ptr %PC, align 4
  %v1649 = add i32 %v1645, 7
  store i32 %v1649, ptr %NEXT_PC, align 4
  %v1650 = load i32, ptr %EBP, align 4
  %v1651 = load i32, ptr %SSBASE, align 4
  %v1652 = sub i32 %v1650, 4
  %v1653 = add i32 %v1652, %v1651
  %v1654 = load ptr, ptr %MEMORY, align 4
  %v1655 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1654, ptr %state, i32 %v1653, i32 4194304)
  store ptr %v1655, ptr %MEMORY, align 4
  store i32 %v1649, ptr %PC, align 4
  %v1656 = add i32 %v1649, 3
  store i32 %v1656, ptr %NEXT_PC, align 4
  %v1657 = load i32, ptr %EBP, align 4
  %v1658 = load i32, ptr %SSBASE, align 4
  %v1659 = sub i32 %v1657, 4
  %v1660 = add i32 %v1659, %v1658
  %v1661 = load ptr, ptr %MEMORY, align 4
  %v1662 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1661, ptr %state, ptr %EAX, i32 %v1660)
  store ptr %v1662, ptr %MEMORY, align 4
  store i32 %v1656, ptr %PC, align 4
  %v1663 = add i32 %v1656, 3
  store i32 %v1663, ptr %NEXT_PC, align 4
  %v1664 = load i32, ptr %ESP, align 4
  %v1665 = load i32, ptr %SSBASE, align 4
  %v1666 = add i32 %v1664, %v1665
  %v1667 = load i32, ptr %EAX, align 4
  %v1668 = load ptr, ptr %MEMORY, align 4
  %v1669 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1668, ptr %state, i32 %v1666, i32 %v1667)
  store ptr %v1669, ptr %MEMORY, align 4
  store i32 %v1663, ptr %PC, align 4
  %v1670 = add i32 %v1663, 5
  store i32 %v1670, ptr %NEXT_PC, align 4
  %v1671 = sub i32 %v1670, 728
  %v1672 = load ptr, ptr %MEMORY, align 4
  %v1673 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1672, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v1670, ptr %RETURN_PC)
  store ptr %v1673, ptr %MEMORY, align 4
  store i32 %v1670, ptr %PC, align 4
  %v1674 = add i32 %v1670, 2
  store i32 %v1674, ptr %NEXT_PC, align 4
  %v1675 = load i32, ptr %EAX, align 4
  %v1676 = load i32, ptr %EAX, align 4
  %v1677 = load ptr, ptr %MEMORY, align 4
  %v1678 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1677, ptr %state, i32 %v1675, i32 %v1676)
  store ptr %v1678, ptr %MEMORY, align 4
  store i32 %v1674, ptr %PC, align 4
  %v1679 = add i32 %v1674, 2
  store i32 %v1679, ptr %NEXT_PC, align 4
  %v1680 = add i32 %v1679, 7
  %v1681 = load ptr, ptr %MEMORY, align 4
  %v1682 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1681, ptr %state, ptr %BRANCH_TAKEN, i32 %v1680, i32 %v1679, ptr %NEXT_PC)
  store ptr %v1682, ptr %MEMORY, align 4
  br i1 true, label %bb_4204791, label %bb_4204784

bb_4204784:                                       ; preds = %bb_4204756
  store i32 %v1679, ptr %PC, align 4
  %v1683 = add i32 %v1679, 5
  store i32 %v1683, ptr %NEXT_PC, align 4
  %v1684 = load ptr, ptr %MEMORY, align 4
  %v1685 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1684, ptr %state, ptr %EAX, i32 0)
  store ptr %v1685, ptr %MEMORY, align 4
  store i32 %v1683, ptr %PC, align 4
  %v1686 = add i32 %v1683, 2
  store i32 %v1686, ptr %NEXT_PC, align 4
  %v1687 = add i32 %v1686, 63
  %v1688 = load ptr, ptr %MEMORY, align 4
  %v1689 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1688, ptr %state, i32 %v1687, ptr %NEXT_PC)
  store ptr %v1689, ptr %MEMORY, align 4
  br label %bb_4204854

bb_4204791:                                       ; preds = %bb_4204756
  store i32 %v1679, ptr %PC, align 4
  %v1690 = add i32 %v1679, 3
  store i32 %v1690, ptr %NEXT_PC, align 4
  %v1691 = load i32, ptr %EBP, align 4
  %v1692 = load i32, ptr %SSBASE, align 4
  %v1693 = add i32 %v1691, 8
  %v1694 = add i32 %v1693, %v1692
  %v1695 = load ptr, ptr %MEMORY, align 4
  %v1696 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1695, ptr %state, ptr %EDX, i32 %v1694)
  store ptr %v1696, ptr %MEMORY, align 4
  store i32 %v1690, ptr %PC, align 4
  %v1697 = add i32 %v1690, 3
  store i32 %v1697, ptr %NEXT_PC, align 4
  %v1698 = load i32, ptr %EBP, align 4
  %v1699 = load i32, ptr %SSBASE, align 4
  %v1700 = sub i32 %v1698, 4
  %v1701 = add i32 %v1700, %v1699
  %v1702 = load ptr, ptr %MEMORY, align 4
  %v1703 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1702, ptr %state, ptr %EAX, i32 %v1701)
  store ptr %v1703, ptr %MEMORY, align 4
  store i32 %v1697, ptr %PC, align 4
  %v1704 = add i32 %v1697, 2
  store i32 %v1704, ptr %NEXT_PC, align 4
  %v1705 = load i32, ptr %EDX, align 4
  %v1706 = load ptr, ptr %MEMORY, align 4
  %v1707 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1706, ptr %state, ptr %ECX, i32 %v1705)
  store ptr %v1707, ptr %MEMORY, align 4
  store i32 %v1704, ptr %PC, align 4
  %v1708 = add i32 %v1704, 2
  store i32 %v1708, ptr %NEXT_PC, align 4
  %v1709 = load i32, ptr %ECX, align 4
  %v1710 = load i32, ptr %EAX, align 4
  %v1711 = load ptr, ptr %MEMORY, align 4
  %v1712 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1711, ptr %state, ptr %ECX, i32 %v1709, i32 %v1710)
  store ptr %v1712, ptr %MEMORY, align 4
  store i32 %v1708, ptr %PC, align 4
  %v1713 = add i32 %v1708, 2
  store i32 %v1713, ptr %NEXT_PC, align 4
  %v1714 = load i32, ptr %ECX, align 4
  %v1715 = load ptr, ptr %MEMORY, align 4
  %v1716 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1715, ptr %state, ptr %EAX, i32 %v1714)
  store ptr %v1716, ptr %MEMORY, align 4
  store i32 %v1713, ptr %PC, align 4
  %v1717 = add i32 %v1713, 3
  store i32 %v1717, ptr %NEXT_PC, align 4
  %v1718 = load i32, ptr %EBP, align 4
  %v1719 = load i32, ptr %SSBASE, align 4
  %v1720 = sub i32 %v1718, 8
  %v1721 = add i32 %v1720, %v1719
  %v1722 = load i32, ptr %EAX, align 4
  %v1723 = load ptr, ptr %MEMORY, align 4
  %v1724 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1723, ptr %state, i32 %v1721, i32 %v1722)
  store ptr %v1724, ptr %MEMORY, align 4
  store i32 %v1717, ptr %PC, align 4
  %v1725 = add i32 %v1717, 3
  store i32 %v1725, ptr %NEXT_PC, align 4
  %v1726 = load i32, ptr %EBP, align 4
  %v1727 = load i32, ptr %SSBASE, align 4
  %v1728 = sub i32 %v1726, 8
  %v1729 = add i32 %v1728, %v1727
  %v1730 = load ptr, ptr %MEMORY, align 4
  %v1731 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1730, ptr %state, ptr %EAX, i32 %v1729)
  store ptr %v1731, ptr %MEMORY, align 4
  store i32 %v1725, ptr %PC, align 4
  %v1732 = add i32 %v1725, 4
  store i32 %v1732, ptr %NEXT_PC, align 4
  %v1733 = load i32, ptr %ESP, align 4
  %v1734 = load i32, ptr %SSBASE, align 4
  %v1735 = add i32 %v1733, 4
  %v1736 = add i32 %v1735, %v1734
  %v1737 = load i32, ptr %EAX, align 4
  %v1738 = load ptr, ptr %MEMORY, align 4
  %v1739 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1738, ptr %state, i32 %v1736, i32 %v1737)
  store ptr %v1739, ptr %MEMORY, align 4
  store i32 %v1732, ptr %PC, align 4
  %v1740 = add i32 %v1732, 3
  store i32 %v1740, ptr %NEXT_PC, align 4
  %v1741 = load i32, ptr %EBP, align 4
  %v1742 = load i32, ptr %SSBASE, align 4
  %v1743 = sub i32 %v1741, 4
  %v1744 = add i32 %v1743, %v1742
  %v1745 = load ptr, ptr %MEMORY, align 4
  %v1746 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1745, ptr %state, ptr %EAX, i32 %v1744)
  store ptr %v1746, ptr %MEMORY, align 4
  store i32 %v1740, ptr %PC, align 4
  %v1747 = add i32 %v1740, 3
  store i32 %v1747, ptr %NEXT_PC, align 4
  %v1748 = load i32, ptr %ESP, align 4
  %v1749 = load i32, ptr %SSBASE, align 4
  %v1750 = add i32 %v1748, %v1749
  %v1751 = load i32, ptr %EAX, align 4
  %v1752 = load ptr, ptr %MEMORY, align 4
  %v1753 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1752, ptr %state, i32 %v1750, i32 %v1751)
  store ptr %v1753, ptr %MEMORY, align 4
  store i32 %v1747, ptr %PC, align 4
  %v1754 = add i32 %v1747, 5
  store i32 %v1754, ptr %NEXT_PC, align 4
  %v1755 = sub i32 %v1754, 671
  %v1756 = load ptr, ptr %MEMORY, align 4
  %v1757 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1756, ptr %state, i64 4204153, ptr %NEXT_PC, i32 %v1754, ptr %RETURN_PC)
  store ptr %v1757, ptr %MEMORY, align 4
  store i32 %v1754, ptr %PC, align 4
  %v1758 = add i32 %v1754, 3
  store i32 %v1758, ptr %NEXT_PC, align 4
  %v1759 = load i32, ptr %EBP, align 4
  %v1760 = load i32, ptr %SSBASE, align 4
  %v1761 = sub i32 %v1759, 12
  %v1762 = add i32 %v1761, %v1760
  %v1763 = load i32, ptr %EAX, align 4
  %v1764 = load ptr, ptr %MEMORY, align 4
  %v1765 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1764, ptr %state, i32 %v1762, i32 %v1763)
  store ptr %v1765, ptr %MEMORY, align 4
  store i32 %v1758, ptr %PC, align 4
  %v1766 = add i32 %v1758, 4
  store i32 %v1766, ptr %NEXT_PC, align 4
  %v1767 = load i32, ptr %EBP, align 4
  %v1768 = load i32, ptr %SSBASE, align 4
  %v1769 = sub i32 %v1767, 12
  %v1770 = add i32 %v1769, %v1768
  %v1771 = load ptr, ptr %MEMORY, align 4
  %v1772 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1771, ptr %state, i32 %v1770, i32 0)
  store ptr %v1772, ptr %MEMORY, align 4
  store i32 %v1766, ptr %PC, align 4
  %v1773 = add i32 %v1766, 2
  store i32 %v1773, ptr %NEXT_PC, align 4
  %v1774 = add i32 %v1773, 7
  %v1775 = load ptr, ptr %MEMORY, align 4
  %v1776 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1775, ptr %state, ptr %BRANCH_TAKEN, i32 %v1774, i32 %v1773, ptr %NEXT_PC)
  store ptr %v1776, ptr %MEMORY, align 4
  br i1 true, label %bb_4204840, label %bb_4204833

bb_4204833:                                       ; preds = %bb_4204791
  store i32 %v1773, ptr %PC, align 4
  %v1777 = add i32 %v1773, 5
  store i32 %v1777, ptr %NEXT_PC, align 4
  %v1778 = load ptr, ptr %MEMORY, align 4
  %v1779 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1778, ptr %state, ptr %EAX, i32 0)
  store ptr %v1779, ptr %MEMORY, align 4
  store i32 %v1777, ptr %PC, align 4
  %v1780 = add i32 %v1777, 2
  store i32 %v1780, ptr %NEXT_PC, align 4
  %v1781 = add i32 %v1780, 14
  %v1782 = load ptr, ptr %MEMORY, align 4
  %v1783 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1782, ptr %state, i32 %v1781, ptr %NEXT_PC)
  store ptr %v1783, ptr %MEMORY, align 4
  br label %bb_4204854

bb_4204840:                                       ; preds = %bb_4204791
  store i32 %v1773, ptr %PC, align 4
  %v1784 = add i32 %v1773, 3
  store i32 %v1784, ptr %NEXT_PC, align 4
  %v1785 = load i32, ptr %EBP, align 4
  %v1786 = load i32, ptr %SSBASE, align 4
  %v1787 = sub i32 %v1785, 12
  %v1788 = add i32 %v1787, %v1786
  %v1789 = load ptr, ptr %MEMORY, align 4
  %v1790 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1789, ptr %state, ptr %EAX, i32 %v1788)
  store ptr %v1790, ptr %MEMORY, align 4
  store i32 %v1784, ptr %PC, align 4
  %v1791 = add i32 %v1784, 3
  store i32 %v1791, ptr %NEXT_PC, align 4
  %v1792 = load i32, ptr %EAX, align 4
  %v1793 = load i32, ptr %DSBASE, align 4
  %v1794 = add i32 %v1792, 36
  %v1795 = add i32 %v1794, %v1793
  %v1796 = load ptr, ptr %MEMORY, align 4
  %v1797 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1796, ptr %state, ptr %EAX, i32 %v1795)
  store ptr %v1797, ptr %MEMORY, align 4
  store i32 %v1791, ptr %PC, align 4
  %v1798 = add i32 %v1791, 2
  store i32 %v1798, ptr %NEXT_PC, align 4
  %v1799 = load i32, ptr %EAX, align 4
  %v1800 = load ptr, ptr %MEMORY, align 4
  %v1801 = call ptr @_ZN12_GLOBAL__N_13NOTI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1800, ptr %state, ptr %EAX, i32 %v1799)
  store ptr %v1801, ptr %MEMORY, align 4
  store i32 %v1798, ptr %PC, align 4
  %v1802 = add i32 %v1798, 3
  store i32 %v1802, ptr %NEXT_PC, align 4
  %v1803 = load i32, ptr %EAX, align 4
  %v1804 = load ptr, ptr %MEMORY, align 4
  %v1805 = call ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1804, ptr %state, ptr %EAX, i32 %v1803, i32 31)
  store ptr %v1805, ptr %MEMORY, align 4
  store i32 %v1802, ptr %PC, align 4
  %v1806 = add i32 %v1802, 3
  store i32 %v1806, ptr %NEXT_PC, align 4
  %v1807 = load i8, ptr %AL, align 1
  %v1808 = zext i8 %v1807 to i32
  %v1809 = load ptr, ptr %MEMORY, align 4
  %v1810 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1809, ptr %state, ptr %EAX, i32 %v1808)
  store ptr %v1810, ptr %MEMORY, align 4
  br label %bb_4204854

bb_4204854:                                       ; preds = %bb_4204840, %bb_4204833, %bb_4204784
  %v1811 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1811, ptr %PC, align 4
  %v1812 = add i32 %v1811, 1
  store i32 %v1812, ptr %NEXT_PC, align 4
  %v1813 = load ptr, ptr %MEMORY, align 4
  %v1814 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1813, ptr %state)
  store ptr %v1814, ptr %MEMORY, align 4
  store i32 %v1812, ptr %PC, align 4
  %v1815 = add i32 %v1812, 1
  store i32 %v1815, ptr %NEXT_PC, align 4
  %v1816 = load ptr, ptr %MEMORY, align 4
  %v1817 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1816, ptr %state, ptr %NEXT_PC)
  store ptr %v1817, ptr %MEMORY, align 4
  ret ptr %memory

bb_4204856:                                       ; No predecessors!
  %v1818 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1818, ptr %PC, align 4
  %v1819 = add i32 %v1818, 1
  store i32 %v1819, ptr %NEXT_PC, align 4
  %v1820 = load i32, ptr %EBP, align 4
  %v1821 = load ptr, ptr %MEMORY, align 4
  %v1822 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1821, ptr %state, i32 %v1820)
  store ptr %v1822, ptr %MEMORY, align 4
  store i32 %v1819, ptr %PC, align 4
  %v1823 = add i32 %v1819, 2
  store i32 %v1823, ptr %NEXT_PC, align 4
  %v1824 = load i32, ptr %ESP, align 4
  %v1825 = load ptr, ptr %MEMORY, align 4
  %v1826 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1825, ptr %state, ptr %EBP, i32 %v1824)
  store ptr %v1826, ptr %MEMORY, align 4
  store i32 %v1823, ptr %PC, align 4
  %v1827 = add i32 %v1823, 3
  store i32 %v1827, ptr %NEXT_PC, align 4
  %v1828 = load i32, ptr %ESP, align 4
  %v1829 = load ptr, ptr %MEMORY, align 4
  %v1830 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1829, ptr %state, ptr %ESP, i32 %v1828, i32 40)
  store ptr %v1830, ptr %MEMORY, align 4
  store i32 %v1827, ptr %PC, align 4
  %v1831 = add i32 %v1827, 7
  store i32 %v1831, ptr %NEXT_PC, align 4
  %v1832 = load i32, ptr %EBP, align 4
  %v1833 = load i32, ptr %SSBASE, align 4
  %v1834 = sub i32 %v1832, 8
  %v1835 = add i32 %v1834, %v1833
  %v1836 = load ptr, ptr %MEMORY, align 4
  %v1837 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1836, ptr %state, i32 %v1835, i32 4194304)
  store ptr %v1837, ptr %MEMORY, align 4
  store i32 %v1831, ptr %PC, align 4
  %v1838 = add i32 %v1831, 3
  store i32 %v1838, ptr %NEXT_PC, align 4
  %v1839 = load i32, ptr %EBP, align 4
  %v1840 = load i32, ptr %SSBASE, align 4
  %v1841 = sub i32 %v1839, 8
  %v1842 = add i32 %v1841, %v1840
  %v1843 = load ptr, ptr %MEMORY, align 4
  %v1844 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1843, ptr %state, ptr %EAX, i32 %v1842)
  store ptr %v1844, ptr %MEMORY, align 4
  store i32 %v1838, ptr %PC, align 4
  %v1845 = add i32 %v1838, 3
  store i32 %v1845, ptr %NEXT_PC, align 4
  %v1846 = load i32, ptr %ESP, align 4
  %v1847 = load i32, ptr %SSBASE, align 4
  %v1848 = add i32 %v1846, %v1847
  %v1849 = load i32, ptr %EAX, align 4
  %v1850 = load ptr, ptr %MEMORY, align 4
  %v1851 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1850, ptr %state, i32 %v1848, i32 %v1849)
  store ptr %v1851, ptr %MEMORY, align 4
  store i32 %v1845, ptr %PC, align 4
  %v1852 = add i32 %v1845, 5
  store i32 %v1852, ptr %NEXT_PC, align 4
  %v1853 = sub i32 %v1852, 828
  %v1854 = load ptr, ptr %MEMORY, align 4
  %v1855 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1854, ptr %state, i64 4204052, ptr %NEXT_PC, i32 %v1852, ptr %RETURN_PC)
  store ptr %v1855, ptr %MEMORY, align 4
  store i32 %v1852, ptr %PC, align 4
  %v1856 = add i32 %v1852, 2
  store i32 %v1856, ptr %NEXT_PC, align 4
  %v1857 = load i32, ptr %EAX, align 4
  %v1858 = load i32, ptr %EAX, align 4
  %v1859 = load ptr, ptr %MEMORY, align 4
  %v1860 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v1859, ptr %state, i32 %v1857, i32 %v1858)
  store ptr %v1860, ptr %MEMORY, align 4
  store i32 %v1856, ptr %PC, align 4
  %v1861 = add i32 %v1856, 2
  store i32 %v1861, ptr %NEXT_PC, align 4
  %v1862 = add i32 %v1861, 10
  %v1863 = load ptr, ptr %MEMORY, align 4
  %v1864 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1863, ptr %state, ptr %BRANCH_TAKEN, i32 %v1862, i32 %v1861, ptr %NEXT_PC)
  store ptr %v1864, ptr %MEMORY, align 4
  br i1 true, label %bb_4204894, label %bb_4204884

bb_4204884:                                       ; preds = %bb_4204856
  store i32 %v1861, ptr %PC, align 4
  %v1865 = add i32 %v1861, 5
  store i32 %v1865, ptr %NEXT_PC, align 4
  %v1866 = load ptr, ptr %MEMORY, align 4
  %v1867 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1866, ptr %state, ptr %EAX, i32 0)
  store ptr %v1867, ptr %MEMORY, align 4
  store i32 %v1865, ptr %PC, align 4
  %v1868 = add i32 %v1865, 5
  store i32 %v1868, ptr %NEXT_PC, align 4
  %v1869 = add i32 %v1868, 154
  %v1870 = load ptr, ptr %MEMORY, align 4
  %v1871 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1870, ptr %state, i32 %v1869, ptr %NEXT_PC)
  store ptr %v1871, ptr %MEMORY, align 4
  br label %bb_4205048

bb_4204894:                                       ; preds = %bb_4204856
  store i32 %v1861, ptr %PC, align 4
  %v1872 = add i32 %v1861, 3
  store i32 %v1872, ptr %NEXT_PC, align 4
  %v1873 = load i32, ptr %EBP, align 4
  %v1874 = load i32, ptr %SSBASE, align 4
  %v1875 = sub i32 %v1873, 8
  %v1876 = add i32 %v1875, %v1874
  %v1877 = load ptr, ptr %MEMORY, align 4
  %v1878 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1877, ptr %state, ptr %EAX, i32 %v1876)
  store ptr %v1878, ptr %MEMORY, align 4
  store i32 %v1872, ptr %PC, align 4
  %v1879 = add i32 %v1872, 3
  store i32 %v1879, ptr %NEXT_PC, align 4
  %v1880 = load i32, ptr %EAX, align 4
  %v1881 = load i32, ptr %DSBASE, align 4
  %v1882 = add i32 %v1880, 60
  %v1883 = add i32 %v1882, %v1881
  %v1884 = load ptr, ptr %MEMORY, align 4
  %v1885 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1884, ptr %state, ptr %EAX, i32 %v1883)
  store ptr %v1885, ptr %MEMORY, align 4
  store i32 %v1879, ptr %PC, align 4
  %v1886 = add i32 %v1879, 2
  store i32 %v1886, ptr %NEXT_PC, align 4
  %v1887 = load i32, ptr %EAX, align 4
  %v1888 = load ptr, ptr %MEMORY, align 4
  %v1889 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1888, ptr %state, ptr %EDX, i32 %v1887)
  store ptr %v1889, ptr %MEMORY, align 4
  store i32 %v1886, ptr %PC, align 4
  %v1890 = add i32 %v1886, 3
  store i32 %v1890, ptr %NEXT_PC, align 4
  %v1891 = load i32, ptr %EBP, align 4
  %v1892 = load i32, ptr %SSBASE, align 4
  %v1893 = sub i32 %v1891, 8
  %v1894 = add i32 %v1893, %v1892
  %v1895 = load ptr, ptr %MEMORY, align 4
  %v1896 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1895, ptr %state, ptr %EAX, i32 %v1894)
  store ptr %v1896, ptr %MEMORY, align 4
  store i32 %v1890, ptr %PC, align 4
  %v1897 = add i32 %v1890, 2
  store i32 %v1897, ptr %NEXT_PC, align 4
  %v1898 = load i32, ptr %EAX, align 4
  %v1899 = load i32, ptr %EDX, align 4
  %v1900 = load ptr, ptr %MEMORY, align 4
  %v1901 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1900, ptr %state, ptr %EAX, i32 %v1898, i32 %v1899)
  store ptr %v1901, ptr %MEMORY, align 4
  store i32 %v1897, ptr %PC, align 4
  %v1902 = add i32 %v1897, 3
  store i32 %v1902, ptr %NEXT_PC, align 4
  %v1903 = load i32, ptr %EBP, align 4
  %v1904 = load i32, ptr %SSBASE, align 4
  %v1905 = sub i32 %v1903, 12
  %v1906 = add i32 %v1905, %v1904
  %v1907 = load i32, ptr %EAX, align 4
  %v1908 = load ptr, ptr %MEMORY, align 4
  %v1909 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1908, ptr %state, i32 %v1906, i32 %v1907)
  store ptr %v1909, ptr %MEMORY, align 4
  store i32 %v1902, ptr %PC, align 4
  %v1910 = add i32 %v1902, 3
  store i32 %v1910, ptr %NEXT_PC, align 4
  %v1911 = load i32, ptr %EBP, align 4
  %v1912 = load i32, ptr %SSBASE, align 4
  %v1913 = sub i32 %v1911, 12
  %v1914 = add i32 %v1913, %v1912
  %v1915 = load ptr, ptr %MEMORY, align 4
  %v1916 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1915, ptr %state, ptr %EAX, i32 %v1914)
  store ptr %v1916, ptr %MEMORY, align 4
  store i32 %v1910, ptr %PC, align 4
  %v1917 = add i32 %v1910, 6
  store i32 %v1917, ptr %NEXT_PC, align 4
  %v1918 = load i32, ptr %EAX, align 4
  %v1919 = load i32, ptr %DSBASE, align 4
  %v1920 = add i32 %v1918, 128
  %v1921 = add i32 %v1920, %v1919
  %v1922 = load ptr, ptr %MEMORY, align 4
  %v1923 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1922, ptr %state, ptr %EAX, i32 %v1921)
  store ptr %v1923, ptr %MEMORY, align 4
  store i32 %v1917, ptr %PC, align 4
  %v1924 = add i32 %v1917, 3
  store i32 %v1924, ptr %NEXT_PC, align 4
  %v1925 = load i32, ptr %EBP, align 4
  %v1926 = load i32, ptr %SSBASE, align 4
  %v1927 = sub i32 %v1925, 16
  %v1928 = add i32 %v1927, %v1926
  %v1929 = load i32, ptr %EAX, align 4
  %v1930 = load ptr, ptr %MEMORY, align 4
  %v1931 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1930, ptr %state, i32 %v1928, i32 %v1929)
  store ptr %v1931, ptr %MEMORY, align 4
  store i32 %v1924, ptr %PC, align 4
  %v1932 = add i32 %v1924, 4
  store i32 %v1932, ptr %NEXT_PC, align 4
  %v1933 = load i32, ptr %EBP, align 4
  %v1934 = load i32, ptr %SSBASE, align 4
  %v1935 = sub i32 %v1933, 16
  %v1936 = add i32 %v1935, %v1934
  %v1937 = load ptr, ptr %MEMORY, align 4
  %v1938 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1937, ptr %state, i32 %v1936, i32 0)
  store ptr %v1938, ptr %MEMORY, align 4
  store i32 %v1932, ptr %PC, align 4
  %v1939 = add i32 %v1932, 2
  store i32 %v1939, ptr %NEXT_PC, align 4
  %v1940 = add i32 %v1939, 7
  %v1941 = load ptr, ptr %MEMORY, align 4
  %v1942 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1941, ptr %state, ptr %BRANCH_TAKEN, i32 %v1940, i32 %v1939, ptr %NEXT_PC)
  store ptr %v1942, ptr %MEMORY, align 4
  br i1 true, label %bb_4204935, label %bb_4204928

bb_4204928:                                       ; preds = %bb_4204894
  store i32 %v1939, ptr %PC, align 4
  %v1943 = add i32 %v1939, 5
  store i32 %v1943, ptr %NEXT_PC, align 4
  %v1944 = load ptr, ptr %MEMORY, align 4
  %v1945 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1944, ptr %state, ptr %EAX, i32 0)
  store ptr %v1945, ptr %MEMORY, align 4
  store i32 %v1943, ptr %PC, align 4
  %v1946 = add i32 %v1943, 2
  store i32 %v1946, ptr %NEXT_PC, align 4
  %v1947 = add i32 %v1946, 113
  %v1948 = load ptr, ptr %MEMORY, align 4
  %v1949 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1948, ptr %state, i32 %v1947, ptr %NEXT_PC)
  store ptr %v1949, ptr %MEMORY, align 4
  br label %bb_4205048

bb_4204935:                                       ; preds = %bb_4204894
  store i32 %v1939, ptr %PC, align 4
  %v1950 = add i32 %v1939, 3
  store i32 %v1950, ptr %NEXT_PC, align 4
  %v1951 = load i32, ptr %EBP, align 4
  %v1952 = load i32, ptr %SSBASE, align 4
  %v1953 = sub i32 %v1951, 16
  %v1954 = add i32 %v1953, %v1952
  %v1955 = load ptr, ptr %MEMORY, align 4
  %v1956 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1955, ptr %state, ptr %EAX, i32 %v1954)
  store ptr %v1956, ptr %MEMORY, align 4
  store i32 %v1950, ptr %PC, align 4
  %v1957 = add i32 %v1950, 4
  store i32 %v1957, ptr %NEXT_PC, align 4
  %v1958 = load i32, ptr %ESP, align 4
  %v1959 = load i32, ptr %SSBASE, align 4
  %v1960 = add i32 %v1958, 4
  %v1961 = add i32 %v1960, %v1959
  %v1962 = load i32, ptr %EAX, align 4
  %v1963 = load ptr, ptr %MEMORY, align 4
  %v1964 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1963, ptr %state, i32 %v1961, i32 %v1962)
  store ptr %v1964, ptr %MEMORY, align 4
  store i32 %v1957, ptr %PC, align 4
  %v1965 = add i32 %v1957, 3
  store i32 %v1965, ptr %NEXT_PC, align 4
  %v1966 = load i32, ptr %EBP, align 4
  %v1967 = load i32, ptr %SSBASE, align 4
  %v1968 = sub i32 %v1966, 8
  %v1969 = add i32 %v1968, %v1967
  %v1970 = load ptr, ptr %MEMORY, align 4
  %v1971 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1970, ptr %state, ptr %EAX, i32 %v1969)
  store ptr %v1971, ptr %MEMORY, align 4
  store i32 %v1965, ptr %PC, align 4
  %v1972 = add i32 %v1965, 3
  store i32 %v1972, ptr %NEXT_PC, align 4
  %v1973 = load i32, ptr %ESP, align 4
  %v1974 = load i32, ptr %SSBASE, align 4
  %v1975 = add i32 %v1973, %v1974
  %v1976 = load i32, ptr %EAX, align 4
  %v1977 = load ptr, ptr %MEMORY, align 4
  %v1978 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1977, ptr %state, i32 %v1975, i32 %v1976)
  store ptr %v1978, ptr %MEMORY, align 4
  store i32 %v1972, ptr %PC, align 4
  %v1979 = add i32 %v1972, 5
  store i32 %v1979, ptr %NEXT_PC, align 4
  %v1980 = sub i32 %v1979, 800
  %v1981 = load ptr, ptr %MEMORY, align 4
  %v1982 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1981, ptr %state, i64 4204153, ptr %NEXT_PC, i32 %v1979, ptr %RETURN_PC)
  store ptr %v1982, ptr %MEMORY, align 4
  store i32 %v1979, ptr %PC, align 4
  %v1983 = add i32 %v1979, 3
  store i32 %v1983, ptr %NEXT_PC, align 4
  %v1984 = load i32, ptr %EBP, align 4
  %v1985 = load i32, ptr %SSBASE, align 4
  %v1986 = sub i32 %v1984, 20
  %v1987 = add i32 %v1986, %v1985
  %v1988 = load i32, ptr %EAX, align 4
  %v1989 = load ptr, ptr %MEMORY, align 4
  %v1990 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1989, ptr %state, i32 %v1987, i32 %v1988)
  store ptr %v1990, ptr %MEMORY, align 4
  store i32 %v1983, ptr %PC, align 4
  %v1991 = add i32 %v1983, 4
  store i32 %v1991, ptr %NEXT_PC, align 4
  %v1992 = load i32, ptr %EBP, align 4
  %v1993 = load i32, ptr %SSBASE, align 4
  %v1994 = sub i32 %v1992, 20
  %v1995 = add i32 %v1994, %v1993
  %v1996 = load ptr, ptr %MEMORY, align 4
  %v1997 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1996, ptr %state, i32 %v1995, i32 0)
  store ptr %v1997, ptr %MEMORY, align 4
  store i32 %v1991, ptr %PC, align 4
  %v1998 = add i32 %v1991, 2
  store i32 %v1998, ptr %NEXT_PC, align 4
  %v1999 = add i32 %v1998, 7
  %v2000 = load ptr, ptr %MEMORY, align 4
  %v2001 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2000, ptr %state, ptr %BRANCH_TAKEN, i32 %v1999, i32 %v1998, ptr %NEXT_PC)
  store ptr %v2001, ptr %MEMORY, align 4
  br i1 true, label %bb_4204969, label %bb_4204962

bb_4204962:                                       ; preds = %bb_4204935
  store i32 %v1998, ptr %PC, align 4
  %v2002 = add i32 %v1998, 5
  store i32 %v2002, ptr %NEXT_PC, align 4
  %v2003 = load ptr, ptr %MEMORY, align 4
  %v2004 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2003, ptr %state, ptr %EAX, i32 0)
  store ptr %v2004, ptr %MEMORY, align 4
  store i32 %v2002, ptr %PC, align 4
  %v2005 = add i32 %v2002, 2
  store i32 %v2005, ptr %NEXT_PC, align 4
  %v2006 = add i32 %v2005, 79
  %v2007 = load ptr, ptr %MEMORY, align 4
  %v2008 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2007, ptr %state, i32 %v2006, ptr %NEXT_PC)
  store ptr %v2008, ptr %MEMORY, align 4
  br label %bb_4205048

bb_4204969:                                       ; preds = %bb_4204935
  store i32 %v1998, ptr %PC, align 4
  %v2009 = add i32 %v1998, 3
  store i32 %v2009, ptr %NEXT_PC, align 4
  %v2010 = load i32, ptr %EBP, align 4
  %v2011 = load i32, ptr %SSBASE, align 4
  %v2012 = sub i32 %v2010, 16
  %v2013 = add i32 %v2012, %v2011
  %v2014 = load ptr, ptr %MEMORY, align 4
  %v2015 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2014, ptr %state, ptr %EAX, i32 %v2013)
  store ptr %v2015, ptr %MEMORY, align 4
  store i32 %v2009, ptr %PC, align 4
  %v2016 = add i32 %v2009, 3
  store i32 %v2016, ptr %NEXT_PC, align 4
  %v2017 = load i32, ptr %EBP, align 4
  %v2018 = load i32, ptr %SSBASE, align 4
  %v2019 = sub i32 %v2017, 8
  %v2020 = add i32 %v2019, %v2018
  %v2021 = load ptr, ptr %MEMORY, align 4
  %v2022 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2021, ptr %state, ptr %EDX, i32 %v2020)
  store ptr %v2022, ptr %MEMORY, align 4
  store i32 %v2016, ptr %PC, align 4
  %v2023 = add i32 %v2016, 2
  store i32 %v2023, ptr %NEXT_PC, align 4
  %v2024 = load i32, ptr %EAX, align 4
  %v2025 = load i32, ptr %EDX, align 4
  %v2026 = load ptr, ptr %MEMORY, align 4
  %v2027 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2026, ptr %state, ptr %EAX, i32 %v2024, i32 %v2025)
  store ptr %v2027, ptr %MEMORY, align 4
  store i32 %v2023, ptr %PC, align 4
  %v2028 = add i32 %v2023, 3
  store i32 %v2028, ptr %NEXT_PC, align 4
  %v2029 = load i32, ptr %EBP, align 4
  %v2030 = load i32, ptr %SSBASE, align 4
  %v2031 = sub i32 %v2029, 4
  %v2032 = add i32 %v2031, %v2030
  %v2033 = load i32, ptr %EAX, align 4
  %v2034 = load ptr, ptr %MEMORY, align 4
  %v2035 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2034, ptr %state, i32 %v2032, i32 %v2033)
  store ptr %v2035, ptr %MEMORY, align 4
  store i32 %v2028, ptr %PC, align 4
  %v2036 = add i32 %v2028, 4
  store i32 %v2036, ptr %NEXT_PC, align 4
  %v2037 = load i32, ptr %EBP, align 4
  %v2038 = load i32, ptr %SSBASE, align 4
  %v2039 = sub i32 %v2037, 4
  %v2040 = add i32 %v2039, %v2038
  %v2041 = load ptr, ptr %MEMORY, align 4
  %v2042 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2041, ptr %state, i32 %v2040, i32 0)
  store ptr %v2042, ptr %MEMORY, align 4
  store i32 %v2036, ptr %PC, align 4
  %v2043 = add i32 %v2036, 2
  store i32 %v2043, ptr %NEXT_PC, align 4
  %v2044 = add i32 %v2043, 7
  %v2045 = load ptr, ptr %MEMORY, align 4
  %v2046 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2045, ptr %state, ptr %BRANCH_TAKEN, i32 %v2044, i32 %v2043, ptr %NEXT_PC)
  store ptr %v2046, ptr %MEMORY, align 4
  br i1 true, label %bb_4204993, label %bb_4204986

bb_4204986:                                       ; preds = %bb_4204969
  store i32 %v2043, ptr %PC, align 4
  %v2047 = add i32 %v2043, 5
  store i32 %v2047, ptr %NEXT_PC, align 4
  %v2048 = load ptr, ptr %MEMORY, align 4
  %v2049 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2048, ptr %state, ptr %EAX, i32 0)
  store ptr %v2049, ptr %MEMORY, align 4
  store i32 %v2047, ptr %PC, align 4
  %v2050 = add i32 %v2047, 2
  store i32 %v2050, ptr %NEXT_PC, align 4
  %v2051 = add i32 %v2050, 55
  %v2052 = load ptr, ptr %MEMORY, align 4
  %v2053 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2052, ptr %state, i32 %v2051, ptr %NEXT_PC)
  store ptr %v2053, ptr %MEMORY, align 4
  br label %bb_4205048

bb_4204993:                                       ; preds = %bb_4205032, %bb_4204969
  %v2054 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2054, ptr %PC, align 4
  %v2055 = add i32 %v2054, 3
  store i32 %v2055, ptr %NEXT_PC, align 4
  %v2056 = load i32, ptr %EBP, align 4
  %v2057 = load i32, ptr %SSBASE, align 4
  %v2058 = sub i32 %v2056, 4
  %v2059 = add i32 %v2058, %v2057
  %v2060 = load ptr, ptr %MEMORY, align 4
  %v2061 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2060, ptr %state, ptr %EAX, i32 %v2059)
  store ptr %v2061, ptr %MEMORY, align 4
  store i32 %v2055, ptr %PC, align 4
  %v2062 = add i32 %v2055, 3
  store i32 %v2062, ptr %NEXT_PC, align 4
  %v2063 = load i32, ptr %EAX, align 4
  %v2064 = load i32, ptr %DSBASE, align 4
  %v2065 = add i32 %v2063, 4
  %v2066 = add i32 %v2065, %v2064
  %v2067 = load ptr, ptr %MEMORY, align 4
  %v2068 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2067, ptr %state, ptr %EAX, i32 %v2066)
  store ptr %v2068, ptr %MEMORY, align 4
  store i32 %v2062, ptr %PC, align 4
  %v2069 = add i32 %v2062, 2
  store i32 %v2069, ptr %NEXT_PC, align 4
  %v2070 = load i32, ptr %EAX, align 4
  %v2071 = load i32, ptr %EAX, align 4
  %v2072 = load ptr, ptr %MEMORY, align 4
  %v2073 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2072, ptr %state, i32 %v2070, i32 %v2071)
  store ptr %v2073, ptr %MEMORY, align 4
  store i32 %v2069, ptr %PC, align 4
  %v2074 = add i32 %v2069, 2
  store i32 %v2074, ptr %NEXT_PC, align 4
  %v2075 = add i32 %v2074, 10
  %v2076 = load ptr, ptr %MEMORY, align 4
  %v2077 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2076, ptr %state, ptr %BRANCH_TAKEN, i32 %v2075, i32 %v2074, ptr %NEXT_PC)
  store ptr %v2077, ptr %MEMORY, align 4
  br i1 true, label %bb_4205013, label %bb_4205003

bb_4205003:                                       ; preds = %bb_4204993
  store i32 %v2074, ptr %PC, align 4
  %v2078 = add i32 %v2074, 3
  store i32 %v2078, ptr %NEXT_PC, align 4
  %v2079 = load i32, ptr %EBP, align 4
  %v2080 = load i32, ptr %SSBASE, align 4
  %v2081 = sub i32 %v2079, 4
  %v2082 = add i32 %v2081, %v2080
  %v2083 = load ptr, ptr %MEMORY, align 4
  %v2084 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2083, ptr %state, ptr %EAX, i32 %v2082)
  store ptr %v2084, ptr %MEMORY, align 4
  store i32 %v2078, ptr %PC, align 4
  %v2085 = add i32 %v2078, 3
  store i32 %v2085, ptr %NEXT_PC, align 4
  %v2086 = load i32, ptr %EAX, align 4
  %v2087 = load i32, ptr %DSBASE, align 4
  %v2088 = add i32 %v2086, 12
  %v2089 = add i32 %v2088, %v2087
  %v2090 = load ptr, ptr %MEMORY, align 4
  %v2091 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2090, ptr %state, ptr %EAX, i32 %v2089)
  store ptr %v2091, ptr %MEMORY, align 4
  store i32 %v2085, ptr %PC, align 4
  %v2092 = add i32 %v2085, 2
  store i32 %v2092, ptr %NEXT_PC, align 4
  %v2093 = load i32, ptr %EAX, align 4
  %v2094 = load i32, ptr %EAX, align 4
  %v2095 = load ptr, ptr %MEMORY, align 4
  %v2096 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2095, ptr %state, i32 %v2093, i32 %v2094)
  store ptr %v2096, ptr %MEMORY, align 4
  store i32 %v2092, ptr %PC, align 4
  %v2097 = add i32 %v2092, 2
  store i32 %v2097, ptr %NEXT_PC, align 4
  %v2098 = add i32 %v2097, 29
  %v2099 = load ptr, ptr %MEMORY, align 4
  %v2100 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2099, ptr %state, ptr %BRANCH_TAKEN, i32 %v2098, i32 %v2097, ptr %NEXT_PC)
  store ptr %v2100, ptr %MEMORY, align 4
  br i1 true, label %bb_4205042, label %bb_4205013

bb_4205013:                                       ; preds = %bb_4205003, %bb_4204993
  %v2101 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2101, ptr %PC, align 4
  %v2102 = add i32 %v2101, 4
  store i32 %v2102, ptr %NEXT_PC, align 4
  %v2103 = load i32, ptr %EBP, align 4
  %v2104 = load i32, ptr %SSBASE, align 4
  %v2105 = add i32 %v2103, 8
  %v2106 = add i32 %v2105, %v2104
  %v2107 = load ptr, ptr %MEMORY, align 4
  %v2108 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2107, ptr %state, i32 %v2106, i32 0)
  store ptr %v2108, ptr %MEMORY, align 4
  store i32 %v2102, ptr %PC, align 4
  %v2109 = add i32 %v2102, 2
  store i32 %v2109, ptr %NEXT_PC, align 4
  %v2110 = add i32 %v2109, 13
  %v2111 = load ptr, ptr %MEMORY, align 4
  %v2112 = call ptr @_ZN12_GLOBAL__N_14JNLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2111, ptr %state, ptr %BRANCH_TAKEN, i32 %v2110, i32 %v2109, ptr %NEXT_PC)
  store ptr %v2112, ptr %MEMORY, align 4
  br i1 true, label %bb_4205032, label %bb_4205019

bb_4205019:                                       ; preds = %bb_4205013
  store i32 %v2109, ptr %PC, align 4
  %v2113 = add i32 %v2109, 3
  store i32 %v2113, ptr %NEXT_PC, align 4
  %v2114 = load i32, ptr %EBP, align 4
  %v2115 = load i32, ptr %SSBASE, align 4
  %v2116 = sub i32 %v2114, 4
  %v2117 = add i32 %v2116, %v2115
  %v2118 = load ptr, ptr %MEMORY, align 4
  %v2119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2118, ptr %state, ptr %EAX, i32 %v2117)
  store ptr %v2119, ptr %MEMORY, align 4
  store i32 %v2113, ptr %PC, align 4
  %v2120 = add i32 %v2113, 3
  store i32 %v2120, ptr %NEXT_PC, align 4
  %v2121 = load i32, ptr %EAX, align 4
  %v2122 = load i32, ptr %DSBASE, align 4
  %v2123 = add i32 %v2121, 12
  %v2124 = add i32 %v2123, %v2122
  %v2125 = load ptr, ptr %MEMORY, align 4
  %v2126 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2125, ptr %state, ptr %EDX, i32 %v2124)
  store ptr %v2126, ptr %MEMORY, align 4
  store i32 %v2120, ptr %PC, align 4
  %v2127 = add i32 %v2120, 3
  store i32 %v2127, ptr %NEXT_PC, align 4
  %v2128 = load i32, ptr %EBP, align 4
  %v2129 = load i32, ptr %SSBASE, align 4
  %v2130 = sub i32 %v2128, 8
  %v2131 = add i32 %v2130, %v2129
  %v2132 = load ptr, ptr %MEMORY, align 4
  %v2133 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2132, ptr %state, ptr %EAX, i32 %v2131)
  store ptr %v2133, ptr %MEMORY, align 4
  store i32 %v2127, ptr %PC, align 4
  %v2134 = add i32 %v2127, 2
  store i32 %v2134, ptr %NEXT_PC, align 4
  %v2135 = load i32, ptr %EAX, align 4
  %v2136 = load i32, ptr %EDX, align 4
  %v2137 = load ptr, ptr %MEMORY, align 4
  %v2138 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2137, ptr %state, ptr %EAX, i32 %v2135, i32 %v2136)
  store ptr %v2138, ptr %MEMORY, align 4
  store i32 %v2134, ptr %PC, align 4
  %v2139 = add i32 %v2134, 2
  store i32 %v2139, ptr %NEXT_PC, align 4
  %v2140 = add i32 %v2139, 16
  %v2141 = load ptr, ptr %MEMORY, align 4
  %v2142 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2141, ptr %state, i32 %v2140, ptr %NEXT_PC)
  store ptr %v2142, ptr %MEMORY, align 4
  br label %bb_4205048

bb_4205032:                                       ; preds = %bb_4205013
  store i32 %v2109, ptr %PC, align 4
  %v2143 = add i32 %v2109, 4
  store i32 %v2143, ptr %NEXT_PC, align 4
  %v2144 = load i32, ptr %EBP, align 4
  %v2145 = load i32, ptr %SSBASE, align 4
  %v2146 = add i32 %v2144, 8
  %v2147 = add i32 %v2146, %v2145
  %v2148 = load i32, ptr %EBP, align 4
  %v2149 = load i32, ptr %SSBASE, align 4
  %v2150 = add i32 %v2148, 8
  %v2151 = add i32 %v2150, %v2149
  %v2152 = load ptr, ptr %MEMORY, align 4
  %v2153 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2152, ptr %state, i32 %v2147, i32 %v2151, i32 1)
  store ptr %v2153, ptr %MEMORY, align 4
  store i32 %v2143, ptr %PC, align 4
  %v2154 = add i32 %v2143, 4
  store i32 %v2154, ptr %NEXT_PC, align 4
  %v2155 = load i32, ptr %EBP, align 4
  %v2156 = load i32, ptr %SSBASE, align 4
  %v2157 = sub i32 %v2155, 4
  %v2158 = add i32 %v2157, %v2156
  %v2159 = load i32, ptr %EBP, align 4
  %v2160 = load i32, ptr %SSBASE, align 4
  %v2161 = sub i32 %v2159, 4
  %v2162 = add i32 %v2161, %v2160
  %v2163 = load ptr, ptr %MEMORY, align 4
  %v2164 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2163, ptr %state, i32 %v2158, i32 %v2162, i32 20)
  store ptr %v2164, ptr %MEMORY, align 4
  store i32 %v2154, ptr %PC, align 4
  %v2165 = add i32 %v2154, 2
  store i32 %v2165, ptr %NEXT_PC, align 4
  %v2166 = sub i32 %v2165, 49
  %v2167 = load ptr, ptr %MEMORY, align 4
  %v2168 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2167, ptr %state, i32 %v2166, ptr %NEXT_PC)
  store ptr %v2168, ptr %MEMORY, align 4
  br label %bb_4204993

bb_4205042:                                       ; preds = %bb_4205003
  store i32 %v2097, ptr %PC, align 4
  %v2169 = add i32 %v2097, 1
  store i32 %v2169, ptr %NEXT_PC, align 4
  %v2170 = load ptr, ptr %MEMORY, align 4
  %v2171 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2170, ptr %state)
  store ptr %v2171, ptr %MEMORY, align 4
  store i32 %v2169, ptr %PC, align 4
  %v2172 = add i32 %v2169, 5
  store i32 %v2172, ptr %NEXT_PC, align 4
  %v2173 = load ptr, ptr %MEMORY, align 4
  %v2174 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2173, ptr %state, ptr %EAX, i32 0)
  store ptr %v2174, ptr %MEMORY, align 4
  br label %bb_4205048

bb_4205048:                                       ; preds = %bb_4205042, %bb_4205019, %bb_4204986, %bb_4204962, %bb_4204928, %bb_4204884
  %v2175 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2175, ptr %PC, align 4
  %v2176 = add i32 %v2175, 1
  store i32 %v2176, ptr %NEXT_PC, align 4
  %v2177 = load ptr, ptr %MEMORY, align 4
  %v2178 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v2177, ptr %state)
  store ptr %v2178, ptr %MEMORY, align 4
  store i32 %v2176, ptr %PC, align 4
  %v2179 = add i32 %v2176, 1
  store i32 %v2179, ptr %NEXT_PC, align 4
  %v2180 = load ptr, ptr %MEMORY, align 4
  %v2181 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2180, ptr %state, ptr %NEXT_PC)
  store ptr %v2181, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205050:                                       ; No predecessors!
  %v2182 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2182, ptr %PC, align 4
  %v2183 = add i32 %v2182, 1
  store i32 %v2183, ptr %NEXT_PC, align 4
  %v2184 = load i32, ptr %EBP, align 4
  %v2185 = load ptr, ptr %MEMORY, align 4
  %v2186 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2185, ptr %state, i32 %v2184)
  store ptr %v2186, ptr %MEMORY, align 4
  store i32 %v2183, ptr %PC, align 4
  %v2187 = add i32 %v2183, 2
  store i32 %v2187, ptr %NEXT_PC, align 4
  %v2188 = load i32, ptr %ESP, align 4
  %v2189 = load ptr, ptr %MEMORY, align 4
  %v2190 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2189, ptr %state, ptr %EBP, i32 %v2188)
  store ptr %v2190, ptr %MEMORY, align 4
  store i32 %v2187, ptr %PC, align 4
  %v2191 = add i32 %v2187, 3
  store i32 %v2191, ptr %NEXT_PC, align 4
  %v2192 = load i32, ptr %ESP, align 4
  %v2193 = load ptr, ptr %MEMORY, align 4
  %v2194 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2193, ptr %state, ptr %ESP, i32 %v2192, i32 40)
  store ptr %v2194, ptr %MEMORY, align 4
  store i32 %v2191, ptr %PC, align 4
  %v2195 = add i32 %v2191, 5
  store i32 %v2195, ptr %NEXT_PC, align 4
  %v2196 = load i32, ptr %DSBASE, align 4
  %v2197 = add i32 4240304, %v2196
  %v2198 = load ptr, ptr %MEMORY, align 4
  %v2199 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2198, ptr %state, ptr %EAX, i32 %v2197)
  store ptr %v2199, ptr %MEMORY, align 4
  store i32 %v2195, ptr %PC, align 4
  %v2200 = add i32 %v2195, 2
  store i32 %v2200, ptr %NEXT_PC, align 4
  %v2201 = load i32, ptr %EAX, align 4
  %v2202 = load i32, ptr %EAX, align 4
  %v2203 = load ptr, ptr %MEMORY, align 4
  %v2204 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2203, ptr %state, i32 %v2201, i32 %v2202)
  store ptr %v2204, ptr %MEMORY, align 4
  store i32 %v2200, ptr %PC, align 4
  %v2205 = add i32 %v2200, 6
  store i32 %v2205, ptr %NEXT_PC, align 4
  %v2206 = add i32 %v2205, 282
  %v2207 = load ptr, ptr %MEMORY, align 4
  %v2208 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2207, ptr %state, ptr %BRANCH_TAKEN, i32 %v2206, i32 %v2205, ptr %NEXT_PC)
  store ptr %v2208, ptr %MEMORY, align 4
  br i1 true, label %bb_4205351, label %bb_4205069

bb_4205069:                                       ; preds = %bb_4205050
  store i32 %v2205, ptr %PC, align 4
  %v2209 = add i32 %v2205, 7
  store i32 %v2209, ptr %NEXT_PC, align 4
  %v2210 = load i32, ptr %EBP, align 4
  %v2211 = load i32, ptr %SSBASE, align 4
  %v2212 = sub i32 %v2210, 12
  %v2213 = add i32 %v2212, %v2211
  %v2214 = load ptr, ptr %MEMORY, align 4
  %v2215 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2214, ptr %state, i32 %v2213, i32 0)
  store ptr %v2215, ptr %MEMORY, align 4
  store i32 %v2209, ptr %PC, align 4
  %v2216 = add i32 %v2209, 5
  store i32 %v2216, ptr %NEXT_PC, align 4
  %v2217 = add i32 %v2216, 184
  %v2218 = load ptr, ptr %MEMORY, align 4
  %v2219 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2218, ptr %state, i32 %v2217, ptr %NEXT_PC)
  store ptr %v2219, ptr %MEMORY, align 4
  br label %bb_4205265

bb_4205081:                                       ; preds = %bb_4205265
  store i32 %v2626, ptr %PC, align 4
  %v2220 = add i32 %v2626, 3
  store i32 %v2220, ptr %NEXT_PC, align 4
  %v2221 = load i32, ptr %EBP, align 4
  %v2222 = load i32, ptr %SSBASE, align 4
  %v2223 = sub i32 %v2221, 16
  %v2224 = add i32 %v2223, %v2222
  %v2225 = load ptr, ptr %MEMORY, align 4
  %v2226 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2225, ptr %state, ptr %EAX, i32 %v2224)
  store ptr %v2226, ptr %MEMORY, align 4
  store i32 %v2220, ptr %PC, align 4
  %v2227 = add i32 %v2220, 3
  store i32 %v2227, ptr %NEXT_PC, align 4
  %v2228 = load i32, ptr %EAX, align 4
  %v2229 = load i32, ptr %DSBASE, align 4
  %v2230 = add i32 %v2228, %v2229
  %v2231 = load ptr, ptr %MEMORY, align 4
  %v2232 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2231, ptr %state, ptr %EAX, i32 %v2230)
  store ptr %v2232, ptr %MEMORY, align 4
  store i32 %v2227, ptr %PC, align 4
  %v2233 = add i32 %v2227, 2
  store i32 %v2233, ptr %NEXT_PC, align 4
  %v2234 = load i8, ptr %AL, align 1
  %v2235 = zext i8 %v2234 to i32
  %v2236 = load ptr, ptr %MEMORY, align 4
  %v2237 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2236, ptr %state, i32 %v2235, i32 109)
  store ptr %v2237, ptr %MEMORY, align 4
  store i32 %v2233, ptr %PC, align 4
  %v2238 = add i32 %v2233, 2
  store i32 %v2238, ptr %NEXT_PC, align 4
  %v2239 = add i32 %v2238, 14
  %v2240 = load ptr, ptr %MEMORY, align 4
  %v2241 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2240, ptr %state, ptr %BRANCH_TAKEN, i32 %v2239, i32 %v2238, ptr %NEXT_PC)
  store ptr %v2241, ptr %MEMORY, align 4
  br i1 true, label %bb_4205105, label %bb_4205091

bb_4205091:                                       ; preds = %bb_4205081
  store i32 %v2238, ptr %PC, align 4
  %v2242 = add i32 %v2238, 3
  store i32 %v2242, ptr %NEXT_PC, align 4
  %v2243 = load i32, ptr %EBP, align 4
  %v2244 = load i32, ptr %SSBASE, align 4
  %v2245 = sub i32 %v2243, 16
  %v2246 = add i32 %v2245, %v2244
  %v2247 = load ptr, ptr %MEMORY, align 4
  %v2248 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2247, ptr %state, ptr %EAX, i32 %v2246)
  store ptr %v2248, ptr %MEMORY, align 4
  store i32 %v2242, ptr %PC, align 4
  %v2249 = add i32 %v2242, 3
  store i32 %v2249, ptr %NEXT_PC, align 4
  %v2250 = load i32, ptr %EAX, align 4
  %v2251 = load i32, ptr %DSBASE, align 4
  %v2252 = add i32 %v2250, %v2251
  %v2253 = load ptr, ptr %MEMORY, align 4
  %v2254 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2253, ptr %state, ptr %EAX, i32 %v2252)
  store ptr %v2254, ptr %MEMORY, align 4
  store i32 %v2249, ptr %PC, align 4
  %v2255 = add i32 %v2249, 2
  store i32 %v2255, ptr %NEXT_PC, align 4
  %v2256 = load i8, ptr %AL, align 1
  %v2257 = zext i8 %v2256 to i32
  %v2258 = load ptr, ptr %MEMORY, align 4
  %v2259 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2258, ptr %state, i32 %v2257, i32 77)
  store ptr %v2259, ptr %MEMORY, align 4
  store i32 %v2255, ptr %PC, align 4
  %v2260 = add i32 %v2255, 6
  store i32 %v2260, ptr %NEXT_PC, align 4
  %v2261 = add i32 %v2260, 160
  %v2262 = load ptr, ptr %MEMORY, align 4
  %v2263 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2262, ptr %state, ptr %BRANCH_TAKEN, i32 %v2261, i32 %v2260, ptr %NEXT_PC)
  store ptr %v2263, ptr %MEMORY, align 4
  br i1 true, label %bb_4205265, label %bb_4205105

bb_4205105:                                       ; preds = %bb_4205091, %bb_4205081
  %v2264 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2264, ptr %PC, align 4
  %v2265 = add i32 %v2264, 3
  store i32 %v2265, ptr %NEXT_PC, align 4
  %v2266 = load i32, ptr %EBP, align 4
  %v2267 = load i32, ptr %SSBASE, align 4
  %v2268 = sub i32 %v2266, 16
  %v2269 = add i32 %v2268, %v2267
  %v2270 = load ptr, ptr %MEMORY, align 4
  %v2271 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2270, ptr %state, ptr %EAX, i32 %v2269)
  store ptr %v2271, ptr %MEMORY, align 4
  store i32 %v2265, ptr %PC, align 4
  %v2272 = add i32 %v2265, 3
  store i32 %v2272, ptr %NEXT_PC, align 4
  %v2273 = load i32, ptr %EAX, align 4
  %v2274 = load ptr, ptr %MEMORY, align 4
  %v2275 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2274, ptr %state, ptr %EAX, i32 %v2273, i32 1)
  store ptr %v2275, ptr %MEMORY, align 4
  store i32 %v2272, ptr %PC, align 4
  %v2276 = add i32 %v2272, 3
  store i32 %v2276, ptr %NEXT_PC, align 4
  %v2277 = load i32, ptr %EAX, align 4
  %v2278 = load i32, ptr %DSBASE, align 4
  %v2279 = add i32 %v2277, %v2278
  %v2280 = load ptr, ptr %MEMORY, align 4
  %v2281 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2280, ptr %state, ptr %EAX, i32 %v2279)
  store ptr %v2281, ptr %MEMORY, align 4
  store i32 %v2276, ptr %PC, align 4
  %v2282 = add i32 %v2276, 2
  store i32 %v2282, ptr %NEXT_PC, align 4
  %v2283 = load i8, ptr %AL, align 1
  %v2284 = zext i8 %v2283 to i32
  %v2285 = load ptr, ptr %MEMORY, align 4
  %v2286 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2285, ptr %state, i32 %v2284, i32 115)
  store ptr %v2286, ptr %MEMORY, align 4
  store i32 %v2282, ptr %PC, align 4
  %v2287 = add i32 %v2282, 2
  store i32 %v2287, ptr %NEXT_PC, align 4
  %v2288 = add i32 %v2287, 17
  %v2289 = load ptr, ptr %MEMORY, align 4
  %v2290 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2289, ptr %state, ptr %BRANCH_TAKEN, i32 %v2288, i32 %v2287, ptr %NEXT_PC)
  store ptr %v2290, ptr %MEMORY, align 4
  br i1 true, label %bb_4205135, label %bb_4205118

bb_4205118:                                       ; preds = %bb_4205105
  store i32 %v2287, ptr %PC, align 4
  %v2291 = add i32 %v2287, 3
  store i32 %v2291, ptr %NEXT_PC, align 4
  %v2292 = load i32, ptr %EBP, align 4
  %v2293 = load i32, ptr %SSBASE, align 4
  %v2294 = sub i32 %v2292, 16
  %v2295 = add i32 %v2294, %v2293
  %v2296 = load ptr, ptr %MEMORY, align 4
  %v2297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2296, ptr %state, ptr %EAX, i32 %v2295)
  store ptr %v2297, ptr %MEMORY, align 4
  store i32 %v2291, ptr %PC, align 4
  %v2298 = add i32 %v2291, 3
  store i32 %v2298, ptr %NEXT_PC, align 4
  %v2299 = load i32, ptr %EAX, align 4
  %v2300 = load ptr, ptr %MEMORY, align 4
  %v2301 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2300, ptr %state, ptr %EAX, i32 %v2299, i32 1)
  store ptr %v2301, ptr %MEMORY, align 4
  store i32 %v2298, ptr %PC, align 4
  %v2302 = add i32 %v2298, 3
  store i32 %v2302, ptr %NEXT_PC, align 4
  %v2303 = load i32, ptr %EAX, align 4
  %v2304 = load i32, ptr %DSBASE, align 4
  %v2305 = add i32 %v2303, %v2304
  %v2306 = load ptr, ptr %MEMORY, align 4
  %v2307 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2306, ptr %state, ptr %EAX, i32 %v2305)
  store ptr %v2307, ptr %MEMORY, align 4
  store i32 %v2302, ptr %PC, align 4
  %v2308 = add i32 %v2302, 2
  store i32 %v2308, ptr %NEXT_PC, align 4
  %v2309 = load i8, ptr %AL, align 1
  %v2310 = zext i8 %v2309 to i32
  %v2311 = load ptr, ptr %MEMORY, align 4
  %v2312 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2311, ptr %state, i32 %v2310, i32 83)
  store ptr %v2312, ptr %MEMORY, align 4
  store i32 %v2308, ptr %PC, align 4
  %v2313 = add i32 %v2308, 6
  store i32 %v2313, ptr %NEXT_PC, align 4
  %v2314 = add i32 %v2313, 130
  %v2315 = load ptr, ptr %MEMORY, align 4
  %v2316 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2315, ptr %state, ptr %BRANCH_TAKEN, i32 %v2314, i32 %v2313, ptr %NEXT_PC)
  store ptr %v2316, ptr %MEMORY, align 4
  br i1 true, label %bb_4205265, label %bb_4205135

bb_4205135:                                       ; preds = %bb_4205118, %bb_4205105
  %v2317 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2317, ptr %PC, align 4
  %v2318 = add i32 %v2317, 3
  store i32 %v2318, ptr %NEXT_PC, align 4
  %v2319 = load i32, ptr %EBP, align 4
  %v2320 = load i32, ptr %SSBASE, align 4
  %v2321 = sub i32 %v2319, 16
  %v2322 = add i32 %v2321, %v2320
  %v2323 = load ptr, ptr %MEMORY, align 4
  %v2324 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2323, ptr %state, ptr %EAX, i32 %v2322)
  store ptr %v2324, ptr %MEMORY, align 4
  store i32 %v2318, ptr %PC, align 4
  %v2325 = add i32 %v2318, 3
  store i32 %v2325, ptr %NEXT_PC, align 4
  %v2326 = load i32, ptr %EAX, align 4
  %v2327 = load ptr, ptr %MEMORY, align 4
  %v2328 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2327, ptr %state, ptr %EAX, i32 %v2326, i32 2)
  store ptr %v2328, ptr %MEMORY, align 4
  store i32 %v2325, ptr %PC, align 4
  %v2329 = add i32 %v2325, 3
  store i32 %v2329, ptr %NEXT_PC, align 4
  %v2330 = load i32, ptr %EAX, align 4
  %v2331 = load i32, ptr %DSBASE, align 4
  %v2332 = add i32 %v2330, %v2331
  %v2333 = load ptr, ptr %MEMORY, align 4
  %v2334 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2333, ptr %state, ptr %EAX, i32 %v2332)
  store ptr %v2334, ptr %MEMORY, align 4
  store i32 %v2329, ptr %PC, align 4
  %v2335 = add i32 %v2329, 2
  store i32 %v2335, ptr %NEXT_PC, align 4
  %v2336 = load i8, ptr %AL, align 1
  %v2337 = zext i8 %v2336 to i32
  %v2338 = load ptr, ptr %MEMORY, align 4
  %v2339 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2338, ptr %state, i32 %v2337, i32 118)
  store ptr %v2339, ptr %MEMORY, align 4
  store i32 %v2335, ptr %PC, align 4
  %v2340 = add i32 %v2335, 2
  store i32 %v2340, ptr %NEXT_PC, align 4
  %v2341 = add i32 %v2340, 13
  %v2342 = load ptr, ptr %MEMORY, align 4
  %v2343 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2342, ptr %state, ptr %BRANCH_TAKEN, i32 %v2341, i32 %v2340, ptr %NEXT_PC)
  store ptr %v2343, ptr %MEMORY, align 4
  br i1 true, label %bb_4205161, label %bb_4205148

bb_4205148:                                       ; preds = %bb_4205135
  store i32 %v2340, ptr %PC, align 4
  %v2344 = add i32 %v2340, 3
  store i32 %v2344, ptr %NEXT_PC, align 4
  %v2345 = load i32, ptr %EBP, align 4
  %v2346 = load i32, ptr %SSBASE, align 4
  %v2347 = sub i32 %v2345, 16
  %v2348 = add i32 %v2347, %v2346
  %v2349 = load ptr, ptr %MEMORY, align 4
  %v2350 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2349, ptr %state, ptr %EAX, i32 %v2348)
  store ptr %v2350, ptr %MEMORY, align 4
  store i32 %v2344, ptr %PC, align 4
  %v2351 = add i32 %v2344, 3
  store i32 %v2351, ptr %NEXT_PC, align 4
  %v2352 = load i32, ptr %EAX, align 4
  %v2353 = load ptr, ptr %MEMORY, align 4
  %v2354 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2353, ptr %state, ptr %EAX, i32 %v2352, i32 2)
  store ptr %v2354, ptr %MEMORY, align 4
  store i32 %v2351, ptr %PC, align 4
  %v2355 = add i32 %v2351, 3
  store i32 %v2355, ptr %NEXT_PC, align 4
  %v2356 = load i32, ptr %EAX, align 4
  %v2357 = load i32, ptr %DSBASE, align 4
  %v2358 = add i32 %v2356, %v2357
  %v2359 = load ptr, ptr %MEMORY, align 4
  %v2360 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2359, ptr %state, ptr %EAX, i32 %v2358)
  store ptr %v2360, ptr %MEMORY, align 4
  store i32 %v2355, ptr %PC, align 4
  %v2361 = add i32 %v2355, 2
  store i32 %v2361, ptr %NEXT_PC, align 4
  %v2362 = load i8, ptr %AL, align 1
  %v2363 = zext i8 %v2362 to i32
  %v2364 = load ptr, ptr %MEMORY, align 4
  %v2365 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2364, ptr %state, i32 %v2363, i32 86)
  store ptr %v2365, ptr %MEMORY, align 4
  store i32 %v2361, ptr %PC, align 4
  %v2366 = add i32 %v2361, 2
  store i32 %v2366, ptr %NEXT_PC, align 4
  %v2367 = add i32 %v2366, 104
  %v2368 = load ptr, ptr %MEMORY, align 4
  %v2369 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2368, ptr %state, ptr %BRANCH_TAKEN, i32 %v2367, i32 %v2366, ptr %NEXT_PC)
  store ptr %v2369, ptr %MEMORY, align 4
  br i1 true, label %bb_4205265, label %bb_4205161

bb_4205161:                                       ; preds = %bb_4205148, %bb_4205135
  %v2370 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2370, ptr %PC, align 4
  %v2371 = add i32 %v2370, 3
  store i32 %v2371, ptr %NEXT_PC, align 4
  %v2372 = load i32, ptr %EBP, align 4
  %v2373 = load i32, ptr %SSBASE, align 4
  %v2374 = sub i32 %v2372, 16
  %v2375 = add i32 %v2374, %v2373
  %v2376 = load ptr, ptr %MEMORY, align 4
  %v2377 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2376, ptr %state, ptr %EAX, i32 %v2375)
  store ptr %v2377, ptr %MEMORY, align 4
  store i32 %v2371, ptr %PC, align 4
  %v2378 = add i32 %v2371, 3
  store i32 %v2378, ptr %NEXT_PC, align 4
  %v2379 = load i32, ptr %EAX, align 4
  %v2380 = load ptr, ptr %MEMORY, align 4
  %v2381 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2380, ptr %state, ptr %EAX, i32 %v2379, i32 3)
  store ptr %v2381, ptr %MEMORY, align 4
  store i32 %v2378, ptr %PC, align 4
  %v2382 = add i32 %v2378, 3
  store i32 %v2382, ptr %NEXT_PC, align 4
  %v2383 = load i32, ptr %EAX, align 4
  %v2384 = load i32, ptr %DSBASE, align 4
  %v2385 = add i32 %v2383, %v2384
  %v2386 = load ptr, ptr %MEMORY, align 4
  %v2387 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2386, ptr %state, ptr %EAX, i32 %v2385)
  store ptr %v2387, ptr %MEMORY, align 4
  store i32 %v2382, ptr %PC, align 4
  %v2388 = add i32 %v2382, 2
  store i32 %v2388, ptr %NEXT_PC, align 4
  %v2389 = load i8, ptr %AL, align 1
  %v2390 = zext i8 %v2389 to i32
  %v2391 = load ptr, ptr %MEMORY, align 4
  %v2392 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2391, ptr %state, i32 %v2390, i32 99)
  store ptr %v2392, ptr %MEMORY, align 4
  store i32 %v2388, ptr %PC, align 4
  %v2393 = add i32 %v2388, 2
  store i32 %v2393, ptr %NEXT_PC, align 4
  %v2394 = add i32 %v2393, 13
  %v2395 = load ptr, ptr %MEMORY, align 4
  %v2396 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2395, ptr %state, ptr %BRANCH_TAKEN, i32 %v2394, i32 %v2393, ptr %NEXT_PC)
  store ptr %v2396, ptr %MEMORY, align 4
  br i1 true, label %bb_4205187, label %bb_4205174

bb_4205174:                                       ; preds = %bb_4205161
  store i32 %v2393, ptr %PC, align 4
  %v2397 = add i32 %v2393, 3
  store i32 %v2397, ptr %NEXT_PC, align 4
  %v2398 = load i32, ptr %EBP, align 4
  %v2399 = load i32, ptr %SSBASE, align 4
  %v2400 = sub i32 %v2398, 16
  %v2401 = add i32 %v2400, %v2399
  %v2402 = load ptr, ptr %MEMORY, align 4
  %v2403 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2402, ptr %state, ptr %EAX, i32 %v2401)
  store ptr %v2403, ptr %MEMORY, align 4
  store i32 %v2397, ptr %PC, align 4
  %v2404 = add i32 %v2397, 3
  store i32 %v2404, ptr %NEXT_PC, align 4
  %v2405 = load i32, ptr %EAX, align 4
  %v2406 = load ptr, ptr %MEMORY, align 4
  %v2407 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2406, ptr %state, ptr %EAX, i32 %v2405, i32 3)
  store ptr %v2407, ptr %MEMORY, align 4
  store i32 %v2404, ptr %PC, align 4
  %v2408 = add i32 %v2404, 3
  store i32 %v2408, ptr %NEXT_PC, align 4
  %v2409 = load i32, ptr %EAX, align 4
  %v2410 = load i32, ptr %DSBASE, align 4
  %v2411 = add i32 %v2409, %v2410
  %v2412 = load ptr, ptr %MEMORY, align 4
  %v2413 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2412, ptr %state, ptr %EAX, i32 %v2411)
  store ptr %v2413, ptr %MEMORY, align 4
  store i32 %v2408, ptr %PC, align 4
  %v2414 = add i32 %v2408, 2
  store i32 %v2414, ptr %NEXT_PC, align 4
  %v2415 = load i8, ptr %AL, align 1
  %v2416 = zext i8 %v2415 to i32
  %v2417 = load ptr, ptr %MEMORY, align 4
  %v2418 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2417, ptr %state, i32 %v2416, i32 67)
  store ptr %v2418, ptr %MEMORY, align 4
  store i32 %v2414, ptr %PC, align 4
  %v2419 = add i32 %v2414, 2
  store i32 %v2419, ptr %NEXT_PC, align 4
  %v2420 = add i32 %v2419, 78
  %v2421 = load ptr, ptr %MEMORY, align 4
  %v2422 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2421, ptr %state, ptr %BRANCH_TAKEN, i32 %v2420, i32 %v2419, ptr %NEXT_PC)
  store ptr %v2422, ptr %MEMORY, align 4
  br i1 true, label %bb_4205265, label %bb_4205187

bb_4205187:                                       ; preds = %bb_4205174, %bb_4205161
  %v2423 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2423, ptr %PC, align 4
  %v2424 = add i32 %v2423, 3
  store i32 %v2424, ptr %NEXT_PC, align 4
  %v2425 = load i32, ptr %EBP, align 4
  %v2426 = load i32, ptr %SSBASE, align 4
  %v2427 = sub i32 %v2425, 16
  %v2428 = add i32 %v2427, %v2426
  %v2429 = load ptr, ptr %MEMORY, align 4
  %v2430 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2429, ptr %state, ptr %EAX, i32 %v2428)
  store ptr %v2430, ptr %MEMORY, align 4
  store i32 %v2424, ptr %PC, align 4
  %v2431 = add i32 %v2424, 3
  store i32 %v2431, ptr %NEXT_PC, align 4
  %v2432 = load i32, ptr %EAX, align 4
  %v2433 = load ptr, ptr %MEMORY, align 4
  %v2434 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2433, ptr %state, ptr %EAX, i32 %v2432, i32 4)
  store ptr %v2434, ptr %MEMORY, align 4
  store i32 %v2431, ptr %PC, align 4
  %v2435 = add i32 %v2431, 3
  store i32 %v2435, ptr %NEXT_PC, align 4
  %v2436 = load i32, ptr %EAX, align 4
  %v2437 = load i32, ptr %DSBASE, align 4
  %v2438 = add i32 %v2436, %v2437
  %v2439 = load ptr, ptr %MEMORY, align 4
  %v2440 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2439, ptr %state, ptr %EAX, i32 %v2438)
  store ptr %v2440, ptr %MEMORY, align 4
  store i32 %v2435, ptr %PC, align 4
  %v2441 = add i32 %v2435, 2
  store i32 %v2441, ptr %NEXT_PC, align 4
  %v2442 = load i8, ptr %AL, align 1
  %v2443 = zext i8 %v2442 to i32
  %v2444 = load ptr, ptr %MEMORY, align 4
  %v2445 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2444, ptr %state, i32 %v2443, i32 114)
  store ptr %v2445, ptr %MEMORY, align 4
  store i32 %v2441, ptr %PC, align 4
  %v2446 = add i32 %v2441, 2
  store i32 %v2446, ptr %NEXT_PC, align 4
  %v2447 = add i32 %v2446, 13
  %v2448 = load ptr, ptr %MEMORY, align 4
  %v2449 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2448, ptr %state, ptr %BRANCH_TAKEN, i32 %v2447, i32 %v2446, ptr %NEXT_PC)
  store ptr %v2449, ptr %MEMORY, align 4
  br i1 true, label %bb_4205213, label %bb_4205200

bb_4205200:                                       ; preds = %bb_4205187
  store i32 %v2446, ptr %PC, align 4
  %v2450 = add i32 %v2446, 3
  store i32 %v2450, ptr %NEXT_PC, align 4
  %v2451 = load i32, ptr %EBP, align 4
  %v2452 = load i32, ptr %SSBASE, align 4
  %v2453 = sub i32 %v2451, 16
  %v2454 = add i32 %v2453, %v2452
  %v2455 = load ptr, ptr %MEMORY, align 4
  %v2456 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2455, ptr %state, ptr %EAX, i32 %v2454)
  store ptr %v2456, ptr %MEMORY, align 4
  store i32 %v2450, ptr %PC, align 4
  %v2457 = add i32 %v2450, 3
  store i32 %v2457, ptr %NEXT_PC, align 4
  %v2458 = load i32, ptr %EAX, align 4
  %v2459 = load ptr, ptr %MEMORY, align 4
  %v2460 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2459, ptr %state, ptr %EAX, i32 %v2458, i32 4)
  store ptr %v2460, ptr %MEMORY, align 4
  store i32 %v2457, ptr %PC, align 4
  %v2461 = add i32 %v2457, 3
  store i32 %v2461, ptr %NEXT_PC, align 4
  %v2462 = load i32, ptr %EAX, align 4
  %v2463 = load i32, ptr %DSBASE, align 4
  %v2464 = add i32 %v2462, %v2463
  %v2465 = load ptr, ptr %MEMORY, align 4
  %v2466 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2465, ptr %state, ptr %EAX, i32 %v2464)
  store ptr %v2466, ptr %MEMORY, align 4
  store i32 %v2461, ptr %PC, align 4
  %v2467 = add i32 %v2461, 2
  store i32 %v2467, ptr %NEXT_PC, align 4
  %v2468 = load i8, ptr %AL, align 1
  %v2469 = zext i8 %v2468 to i32
  %v2470 = load ptr, ptr %MEMORY, align 4
  %v2471 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2470, ptr %state, i32 %v2469, i32 82)
  store ptr %v2471, ptr %MEMORY, align 4
  store i32 %v2467, ptr %PC, align 4
  %v2472 = add i32 %v2467, 2
  store i32 %v2472, ptr %NEXT_PC, align 4
  %v2473 = add i32 %v2472, 52
  %v2474 = load ptr, ptr %MEMORY, align 4
  %v2475 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2474, ptr %state, ptr %BRANCH_TAKEN, i32 %v2473, i32 %v2472, ptr %NEXT_PC)
  store ptr %v2475, ptr %MEMORY, align 4
  br i1 true, label %bb_4205265, label %bb_4205213

bb_4205213:                                       ; preds = %bb_4205200, %bb_4205187
  %v2476 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2476, ptr %PC, align 4
  %v2477 = add i32 %v2476, 3
  store i32 %v2477, ptr %NEXT_PC, align 4
  %v2478 = load i32, ptr %EBP, align 4
  %v2479 = load i32, ptr %SSBASE, align 4
  %v2480 = sub i32 %v2478, 16
  %v2481 = add i32 %v2480, %v2479
  %v2482 = load ptr, ptr %MEMORY, align 4
  %v2483 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2482, ptr %state, ptr %EAX, i32 %v2481)
  store ptr %v2483, ptr %MEMORY, align 4
  store i32 %v2477, ptr %PC, align 4
  %v2484 = add i32 %v2477, 3
  store i32 %v2484, ptr %NEXT_PC, align 4
  %v2485 = load i32, ptr %EAX, align 4
  %v2486 = load ptr, ptr %MEMORY, align 4
  %v2487 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2486, ptr %state, ptr %EAX, i32 %v2485, i32 5)
  store ptr %v2487, ptr %MEMORY, align 4
  store i32 %v2484, ptr %PC, align 4
  %v2488 = add i32 %v2484, 3
  store i32 %v2488, ptr %NEXT_PC, align 4
  %v2489 = load i32, ptr %EAX, align 4
  %v2490 = load i32, ptr %DSBASE, align 4
  %v2491 = add i32 %v2489, %v2490
  %v2492 = load ptr, ptr %MEMORY, align 4
  %v2493 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2492, ptr %state, ptr %EAX, i32 %v2491)
  store ptr %v2493, ptr %MEMORY, align 4
  store i32 %v2488, ptr %PC, align 4
  %v2494 = add i32 %v2488, 2
  store i32 %v2494, ptr %NEXT_PC, align 4
  %v2495 = load i8, ptr %AL, align 1
  %v2496 = zext i8 %v2495 to i32
  %v2497 = load ptr, ptr %MEMORY, align 4
  %v2498 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2497, ptr %state, i32 %v2496, i32 116)
  store ptr %v2498, ptr %MEMORY, align 4
  store i32 %v2494, ptr %PC, align 4
  %v2499 = add i32 %v2494, 2
  store i32 %v2499, ptr %NEXT_PC, align 4
  %v2500 = add i32 %v2499, 67
  %v2501 = load ptr, ptr %MEMORY, align 4
  %v2502 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2501, ptr %state, ptr %BRANCH_TAKEN, i32 %v2500, i32 %v2499, ptr %NEXT_PC)
  store ptr %v2502, ptr %MEMORY, align 4
  br i1 true, label %bb_4205293, label %bb_4205226

bb_4205226:                                       ; preds = %bb_4205213
  store i32 %v2499, ptr %PC, align 4
  %v2503 = add i32 %v2499, 3
  store i32 %v2503, ptr %NEXT_PC, align 4
  %v2504 = load i32, ptr %EBP, align 4
  %v2505 = load i32, ptr %SSBASE, align 4
  %v2506 = sub i32 %v2504, 16
  %v2507 = add i32 %v2506, %v2505
  %v2508 = load ptr, ptr %MEMORY, align 4
  %v2509 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2508, ptr %state, ptr %EAX, i32 %v2507)
  store ptr %v2509, ptr %MEMORY, align 4
  store i32 %v2503, ptr %PC, align 4
  %v2510 = add i32 %v2503, 3
  store i32 %v2510, ptr %NEXT_PC, align 4
  %v2511 = load i32, ptr %EAX, align 4
  %v2512 = load ptr, ptr %MEMORY, align 4
  %v2513 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2512, ptr %state, ptr %EAX, i32 %v2511, i32 5)
  store ptr %v2513, ptr %MEMORY, align 4
  store i32 %v2510, ptr %PC, align 4
  %v2514 = add i32 %v2510, 3
  store i32 %v2514, ptr %NEXT_PC, align 4
  %v2515 = load i32, ptr %EAX, align 4
  %v2516 = load i32, ptr %DSBASE, align 4
  %v2517 = add i32 %v2515, %v2516
  %v2518 = load ptr, ptr %MEMORY, align 4
  %v2519 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2518, ptr %state, ptr %EAX, i32 %v2517)
  store ptr %v2519, ptr %MEMORY, align 4
  store i32 %v2514, ptr %PC, align 4
  %v2520 = add i32 %v2514, 2
  store i32 %v2520, ptr %NEXT_PC, align 4
  %v2521 = load i8, ptr %AL, align 1
  %v2522 = zext i8 %v2521 to i32
  %v2523 = load ptr, ptr %MEMORY, align 4
  %v2524 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2523, ptr %state, i32 %v2522, i32 84)
  store ptr %v2524, ptr %MEMORY, align 4
  store i32 %v2520, ptr %PC, align 4
  %v2525 = add i32 %v2520, 2
  store i32 %v2525, ptr %NEXT_PC, align 4
  %v2526 = add i32 %v2525, 54
  %v2527 = load ptr, ptr %MEMORY, align 4
  %v2528 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2527, ptr %state, ptr %BRANCH_TAKEN, i32 %v2526, i32 %v2525, ptr %NEXT_PC)
  store ptr %v2528, ptr %MEMORY, align 4
  br i1 true, label %bb_4205293, label %bb_4205239

bb_4205239:                                       ; preds = %bb_4205226
  store i32 %v2525, ptr %PC, align 4
  %v2529 = add i32 %v2525, 3
  store i32 %v2529, ptr %NEXT_PC, align 4
  %v2530 = load i32, ptr %EBP, align 4
  %v2531 = load i32, ptr %SSBASE, align 4
  %v2532 = sub i32 %v2530, 16
  %v2533 = add i32 %v2532, %v2531
  %v2534 = load ptr, ptr %MEMORY, align 4
  %v2535 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2534, ptr %state, ptr %EAX, i32 %v2533)
  store ptr %v2535, ptr %MEMORY, align 4
  store i32 %v2529, ptr %PC, align 4
  %v2536 = add i32 %v2529, 3
  store i32 %v2536, ptr %NEXT_PC, align 4
  %v2537 = load i32, ptr %EAX, align 4
  %v2538 = load ptr, ptr %MEMORY, align 4
  %v2539 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2538, ptr %state, ptr %EAX, i32 %v2537, i32 5)
  store ptr %v2539, ptr %MEMORY, align 4
  store i32 %v2536, ptr %PC, align 4
  %v2540 = add i32 %v2536, 3
  store i32 %v2540, ptr %NEXT_PC, align 4
  %v2541 = load i32, ptr %EAX, align 4
  %v2542 = load i32, ptr %DSBASE, align 4
  %v2543 = add i32 %v2541, %v2542
  %v2544 = load ptr, ptr %MEMORY, align 4
  %v2545 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2544, ptr %state, ptr %EAX, i32 %v2543)
  store ptr %v2545, ptr %MEMORY, align 4
  store i32 %v2540, ptr %PC, align 4
  %v2546 = add i32 %v2540, 2
  store i32 %v2546, ptr %NEXT_PC, align 4
  %v2547 = load i8, ptr %AL, align 1
  %v2548 = zext i8 %v2547 to i32
  %v2549 = load ptr, ptr %MEMORY, align 4
  %v2550 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2549, ptr %state, i32 %v2548, i32 47)
  store ptr %v2550, ptr %MEMORY, align 4
  store i32 %v2546, ptr %PC, align 4
  %v2551 = add i32 %v2546, 2
  store i32 %v2551, ptr %NEXT_PC, align 4
  %v2552 = add i32 %v2551, 13
  %v2553 = load ptr, ptr %MEMORY, align 4
  %v2554 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2553, ptr %state, ptr %BRANCH_TAKEN, i32 %v2552, i32 %v2551, ptr %NEXT_PC)
  store ptr %v2554, ptr %MEMORY, align 4
  br i1 true, label %bb_4205265, label %bb_4205252

bb_4205252:                                       ; preds = %bb_4205239
  store i32 %v2551, ptr %PC, align 4
  %v2555 = add i32 %v2551, 3
  store i32 %v2555, ptr %NEXT_PC, align 4
  %v2556 = load i32, ptr %EBP, align 4
  %v2557 = load i32, ptr %SSBASE, align 4
  %v2558 = sub i32 %v2556, 16
  %v2559 = add i32 %v2558, %v2557
  %v2560 = load ptr, ptr %MEMORY, align 4
  %v2561 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2560, ptr %state, ptr %EAX, i32 %v2559)
  store ptr %v2561, ptr %MEMORY, align 4
  store i32 %v2555, ptr %PC, align 4
  %v2562 = add i32 %v2555, 3
  store i32 %v2562, ptr %NEXT_PC, align 4
  %v2563 = load i32, ptr %EAX, align 4
  %v2564 = load ptr, ptr %MEMORY, align 4
  %v2565 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2564, ptr %state, ptr %EAX, i32 %v2563, i32 5)
  store ptr %v2565, ptr %MEMORY, align 4
  store i32 %v2562, ptr %PC, align 4
  %v2566 = add i32 %v2562, 3
  store i32 %v2566, ptr %NEXT_PC, align 4
  %v2567 = load i32, ptr %EAX, align 4
  %v2568 = load i32, ptr %DSBASE, align 4
  %v2569 = add i32 %v2567, %v2568
  %v2570 = load ptr, ptr %MEMORY, align 4
  %v2571 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2570, ptr %state, ptr %EAX, i32 %v2569)
  store ptr %v2571, ptr %MEMORY, align 4
  store i32 %v2566, ptr %PC, align 4
  %v2572 = add i32 %v2566, 2
  store i32 %v2572, ptr %NEXT_PC, align 4
  %v2573 = load i8, ptr %AL, align 1
  %v2574 = zext i8 %v2573 to i32
  %v2575 = load ptr, ptr %MEMORY, align 4
  %v2576 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v2575, ptr %state, i32 %v2574, i32 57)
  store ptr %v2576, ptr %MEMORY, align 4
  store i32 %v2572, ptr %PC, align 4
  %v2577 = add i32 %v2572, 2
  store i32 %v2577, ptr %NEXT_PC, align 4
  %v2578 = add i32 %v2577, 28
  %v2579 = load ptr, ptr %MEMORY, align 4
  %v2580 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2579, ptr %state, ptr %BRANCH_TAKEN, i32 %v2578, i32 %v2577, ptr %NEXT_PC)
  store ptr %v2580, ptr %MEMORY, align 4
  br i1 true, label %bb_4205293, label %bb_4205265

bb_4205265:                                       ; preds = %bb_4205252, %bb_4205239, %bb_4205200, %bb_4205174, %bb_4205148, %bb_4205118, %bb_4205091, %bb_4205069
  %v2581 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2581, ptr %PC, align 4
  %v2582 = add i32 %v2581, 3
  store i32 %v2582, ptr %NEXT_PC, align 4
  %v2583 = load i32, ptr %EBP, align 4
  %v2584 = load i32, ptr %SSBASE, align 4
  %v2585 = sub i32 %v2583, 12
  %v2586 = add i32 %v2585, %v2584
  %v2587 = load ptr, ptr %MEMORY, align 4
  %v2588 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2587, ptr %state, ptr %EAX, i32 %v2586)
  store ptr %v2588, ptr %MEMORY, align 4
  store i32 %v2582, ptr %PC, align 4
  %v2589 = add i32 %v2582, 4
  store i32 %v2589, ptr %NEXT_PC, align 4
  %v2590 = load i32, ptr %EBP, align 4
  %v2591 = load i32, ptr %SSBASE, align 4
  %v2592 = sub i32 %v2590, 12
  %v2593 = add i32 %v2592, %v2591
  %v2594 = load i32, ptr %EBP, align 4
  %v2595 = load i32, ptr %SSBASE, align 4
  %v2596 = sub i32 %v2594, 12
  %v2597 = add i32 %v2596, %v2595
  %v2598 = load ptr, ptr %MEMORY, align 4
  %v2599 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2598, ptr %state, i32 %v2593, i32 %v2597, i32 1)
  store ptr %v2599, ptr %MEMORY, align 4
  store i32 %v2589, ptr %PC, align 4
  %v2600 = add i32 %v2589, 3
  store i32 %v2600, ptr %NEXT_PC, align 4
  %v2601 = load i32, ptr %ESP, align 4
  %v2602 = load i32, ptr %SSBASE, align 4
  %v2603 = add i32 %v2601, %v2602
  %v2604 = load i32, ptr %EAX, align 4
  %v2605 = load ptr, ptr %MEMORY, align 4
  %v2606 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2605, ptr %state, i32 %v2603, i32 %v2604)
  store ptr %v2606, ptr %MEMORY, align 4
  store i32 %v2600, ptr %PC, align 4
  %v2607 = add i32 %v2600, 5
  store i32 %v2607, ptr %NEXT_PC, align 4
  %v2608 = sub i32 %v2607, 424
  %v2609 = load ptr, ptr %MEMORY, align 4
  %v2610 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2609, ptr %state, i64 4204856, ptr %NEXT_PC, i32 %v2607, ptr %RETURN_PC)
  store ptr %v2610, ptr %MEMORY, align 4
  store i32 %v2607, ptr %PC, align 4
  %v2611 = add i32 %v2607, 3
  store i32 %v2611, ptr %NEXT_PC, align 4
  %v2612 = load i32, ptr %EBP, align 4
  %v2613 = load i32, ptr %SSBASE, align 4
  %v2614 = sub i32 %v2612, 16
  %v2615 = add i32 %v2614, %v2613
  %v2616 = load i32, ptr %EAX, align 4
  %v2617 = load ptr, ptr %MEMORY, align 4
  %v2618 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2617, ptr %state, i32 %v2615, i32 %v2616)
  store ptr %v2618, ptr %MEMORY, align 4
  store i32 %v2611, ptr %PC, align 4
  %v2619 = add i32 %v2611, 4
  store i32 %v2619, ptr %NEXT_PC, align 4
  %v2620 = load i32, ptr %EBP, align 4
  %v2621 = load i32, ptr %SSBASE, align 4
  %v2622 = sub i32 %v2620, 16
  %v2623 = add i32 %v2622, %v2621
  %v2624 = load ptr, ptr %MEMORY, align 4
  %v2625 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2624, ptr %state, i32 %v2623, i32 0)
  store ptr %v2625, ptr %MEMORY, align 4
  store i32 %v2619, ptr %PC, align 4
  %v2626 = add i32 %v2619, 6
  store i32 %v2626, ptr %NEXT_PC, align 4
  %v2627 = sub i32 %v2626, 212
  %v2628 = load ptr, ptr %MEMORY, align 4
  %v2629 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2628, ptr %state, ptr %BRANCH_TAKEN, i32 %v2627, i32 %v2626, ptr %NEXT_PC)
  store ptr %v2629, ptr %MEMORY, align 4
  br i1 true, label %bb_4205081, label %bb_4205293

bb_4205293:                                       ; preds = %bb_4205265, %bb_4205252, %bb_4205226, %bb_4205213
  %v2630 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2630, ptr %PC, align 4
  %v2631 = add i32 %v2630, 4
  store i32 %v2631, ptr %NEXT_PC, align 4
  %v2632 = load i32, ptr %EBP, align 4
  %v2633 = load i32, ptr %SSBASE, align 4
  %v2634 = sub i32 %v2632, 16
  %v2635 = add i32 %v2634, %v2633
  %v2636 = load ptr, ptr %MEMORY, align 4
  %v2637 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2636, ptr %state, i32 %v2635, i32 0)
  store ptr %v2637, ptr %MEMORY, align 4
  store i32 %v2631, ptr %PC, align 4
  %v2638 = add i32 %v2631, 2
  store i32 %v2638, ptr %NEXT_PC, align 4
  %v2639 = add i32 %v2638, 21
  %v2640 = load ptr, ptr %MEMORY, align 4
  %v2641 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2640, ptr %state, ptr %BRANCH_TAKEN, i32 %v2639, i32 %v2638, ptr %NEXT_PC)
  store ptr %v2641, ptr %MEMORY, align 4
  br i1 true, label %bb_4205320, label %bb_4205299

bb_4205299:                                       ; preds = %bb_4205293
  store i32 %v2638, ptr %PC, align 4
  %v2642 = add i32 %v2638, 3
  store i32 %v2642, ptr %NEXT_PC, align 4
  %v2643 = load i32, ptr %EBP, align 4
  %v2644 = load i32, ptr %SSBASE, align 4
  %v2645 = sub i32 %v2643, 16
  %v2646 = add i32 %v2645, %v2644
  %v2647 = load ptr, ptr %MEMORY, align 4
  %v2648 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2647, ptr %state, ptr %EAX, i32 %v2646)
  store ptr %v2648, ptr %MEMORY, align 4
  store i32 %v2642, ptr %PC, align 4
  %v2649 = add i32 %v2642, 3
  store i32 %v2649, ptr %NEXT_PC, align 4
  %v2650 = load i32, ptr %ESP, align 4
  %v2651 = load i32, ptr %SSBASE, align 4
  %v2652 = add i32 %v2650, %v2651
  %v2653 = load i32, ptr %EAX, align 4
  %v2654 = load ptr, ptr %MEMORY, align 4
  %v2655 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2654, ptr %state, i32 %v2652, i32 %v2653)
  store ptr %v2655, ptr %MEMORY, align 4
  store i32 %v2649, ptr %PC, align 4
  %v2656 = add i32 %v2649, 5
  store i32 %v2656, ptr %NEXT_PC, align 4
  %v2657 = load i32, ptr %DSBASE, align 4
  %v2658 = add i32 4243812, %v2657
  %v2659 = load ptr, ptr %MEMORY, align 4
  %v2660 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2659, ptr %state, ptr %EAX, i32 %v2658)
  store ptr %v2660, ptr %MEMORY, align 4
  store i32 %v2656, ptr %PC, align 4
  %v2661 = add i32 %v2656, 2
  store i32 %v2661, ptr %NEXT_PC, align 4
  %v2662 = load i32, ptr %EAX, align 4
  %v2663 = load ptr, ptr %MEMORY, align 4
  %v2664 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2663, ptr %state, i32 %v2662, ptr %NEXT_PC, i32 %v2661, ptr %RETURN_PC)
  store ptr %v2664, ptr %MEMORY, align 4
  store i32 %v2661, ptr %PC, align 4
  %v2665 = add i32 %v2661, 3
  store i32 %v2665, ptr %NEXT_PC, align 4
  %v2666 = load i32, ptr %ESP, align 4
  %v2667 = load ptr, ptr %MEMORY, align 4
  %v2668 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2667, ptr %state, ptr %ESP, i32 %v2666, i32 4)
  store ptr %v2668, ptr %MEMORY, align 4
  store i32 %v2665, ptr %PC, align 4
  %v2669 = add i32 %v2665, 5
  store i32 %v2669, ptr %NEXT_PC, align 4
  %v2670 = load i32, ptr %DSBASE, align 4
  %v2671 = add i32 4240304, %v2670
  %v2672 = load i32, ptr %EAX, align 4
  %v2673 = load ptr, ptr %MEMORY, align 4
  %v2674 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2673, ptr %state, i32 %v2671, i32 %v2672)
  store ptr %v2674, ptr %MEMORY, align 4
  br label %bb_4205320

bb_4205320:                                       ; preds = %bb_4205299, %bb_4205293
  %v2675 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2675, ptr %PC, align 4
  %v2676 = add i32 %v2675, 5
  store i32 %v2676, ptr %NEXT_PC, align 4
  %v2677 = load i32, ptr %DSBASE, align 4
  %v2678 = add i32 4240304, %v2677
  %v2679 = load ptr, ptr %MEMORY, align 4
  %v2680 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2679, ptr %state, ptr %EAX, i32 %v2678)
  store ptr %v2680, ptr %MEMORY, align 4
  store i32 %v2676, ptr %PC, align 4
  %v2681 = add i32 %v2676, 2
  store i32 %v2681, ptr %NEXT_PC, align 4
  %v2682 = load i32, ptr %EAX, align 4
  %v2683 = load i32, ptr %EAX, align 4
  %v2684 = load ptr, ptr %MEMORY, align 4
  %v2685 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2684, ptr %state, i32 %v2682, i32 %v2683)
  store ptr %v2685, ptr %MEMORY, align 4
  store i32 %v2681, ptr %PC, align 4
  %v2686 = add i32 %v2681, 2
  store i32 %v2686, ptr %NEXT_PC, align 4
  %v2687 = add i32 %v2686, 22
  %v2688 = load ptr, ptr %MEMORY, align 4
  %v2689 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2688, ptr %state, ptr %BRANCH_TAKEN, i32 %v2687, i32 %v2686, ptr %NEXT_PC)
  store ptr %v2689, ptr %MEMORY, align 4
  br i1 true, label %bb_4205351, label %bb_4205329

bb_4205329:                                       ; preds = %bb_4205320
  store i32 %v2686, ptr %PC, align 4
  %v2690 = add i32 %v2686, 7
  store i32 %v2690, ptr %NEXT_PC, align 4
  %v2691 = load i32, ptr %ESP, align 4
  %v2692 = load i32, ptr %SSBASE, align 4
  %v2693 = add i32 %v2691, %v2692
  %v2694 = load ptr, ptr %MEMORY, align 4
  %v2695 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2694, ptr %state, i32 %v2693, i32 4235924)
  store ptr %v2695, ptr %MEMORY, align 4
  store i32 %v2690, ptr %PC, align 4
  %v2696 = add i32 %v2690, 5
  store i32 %v2696, ptr %NEXT_PC, align 4
  %v2697 = load i32, ptr %DSBASE, align 4
  %v2698 = add i32 4243848, %v2697
  %v2699 = load ptr, ptr %MEMORY, align 4
  %v2700 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2699, ptr %state, ptr %EAX, i32 %v2698)
  store ptr %v2700, ptr %MEMORY, align 4
  store i32 %v2696, ptr %PC, align 4
  %v2701 = add i32 %v2696, 2
  store i32 %v2701, ptr %NEXT_PC, align 4
  %v2702 = load i32, ptr %EAX, align 4
  %v2703 = load ptr, ptr %MEMORY, align 4
  %v2704 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2703, ptr %state, i32 %v2702, ptr %NEXT_PC, i32 %v2701, ptr %RETURN_PC)
  store ptr %v2704, ptr %MEMORY, align 4
  store i32 %v2701, ptr %PC, align 4
  %v2705 = add i32 %v2701, 3
  store i32 %v2705, ptr %NEXT_PC, align 4
  %v2706 = load i32, ptr %ESP, align 4
  %v2707 = load ptr, ptr %MEMORY, align 4
  %v2708 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2707, ptr %state, ptr %ESP, i32 %v2706, i32 4)
  store ptr %v2708, ptr %MEMORY, align 4
  store i32 %v2705, ptr %PC, align 4
  %v2709 = add i32 %v2705, 5
  store i32 %v2709, ptr %NEXT_PC, align 4
  %v2710 = load i32, ptr %DSBASE, align 4
  %v2711 = add i32 4240304, %v2710
  %v2712 = load i32, ptr %EAX, align 4
  %v2713 = load ptr, ptr %MEMORY, align 4
  %v2714 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2713, ptr %state, i32 %v2711, i32 %v2712)
  store ptr %v2714, ptr %MEMORY, align 4
  br label %bb_4205351

bb_4205351:                                       ; preds = %bb_4205329, %bb_4205320, %bb_4205050
  %v2715 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2715, ptr %PC, align 4
  %v2716 = add i32 %v2715, 5
  store i32 %v2716, ptr %NEXT_PC, align 4
  %v2717 = load i32, ptr %DSBASE, align 4
  %v2718 = add i32 4240304, %v2717
  %v2719 = load ptr, ptr %MEMORY, align 4
  %v2720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2719, ptr %state, ptr %EAX, i32 %v2718)
  store ptr %v2720, ptr %MEMORY, align 4
  store i32 %v2716, ptr %PC, align 4
  %v2721 = add i32 %v2716, 1
  store i32 %v2721, ptr %NEXT_PC, align 4
  %v2722 = load ptr, ptr %MEMORY, align 4
  %v2723 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v2722, ptr %state)
  store ptr %v2723, ptr %MEMORY, align 4
  store i32 %v2721, ptr %PC, align 4
  %v2724 = add i32 %v2721, 1
  store i32 %v2724, ptr %NEXT_PC, align 4
  %v2725 = load ptr, ptr %MEMORY, align 4
  %v2726 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2725, ptr %state, ptr %NEXT_PC)
  store ptr %v2726, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205358:                                       ; No predecessors!
  %v2727 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2727, ptr %PC, align 4
  %v2728 = add i32 %v2727, 1
  store i32 %v2728, ptr %NEXT_PC, align 4
  %v2729 = load ptr, ptr %MEMORY, align 4
  %v2730 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2729, ptr %state)
  store ptr %v2730, ptr %MEMORY, align 4
  store i32 %v2728, ptr %PC, align 4
  %v2731 = add i32 %v2728, 1
  store i32 %v2731, ptr %NEXT_PC, align 4
  %v2732 = load ptr, ptr %MEMORY, align 4
  %v2733 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2732, ptr %state)
  store ptr %v2733, ptr %MEMORY, align 4
  store i32 %v2731, ptr %PC, align 4
  %v2734 = add i32 %v2731, 1
  store i32 %v2734, ptr %NEXT_PC, align 4
  %v2735 = load i32, ptr %EBP, align 4
  %v2736 = load ptr, ptr %MEMORY, align 4
  %v2737 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2736, ptr %state, i32 %v2735)
  store ptr %v2737, ptr %MEMORY, align 4
  store i32 %v2734, ptr %PC, align 4
  %v2738 = add i32 %v2734, 2
  store i32 %v2738, ptr %NEXT_PC, align 4
  %v2739 = load i32, ptr %ESP, align 4
  %v2740 = load ptr, ptr %MEMORY, align 4
  %v2741 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2740, ptr %state, ptr %EBP, i32 %v2739)
  store ptr %v2741, ptr %MEMORY, align 4
  store i32 %v2738, ptr %PC, align 4
  %v2742 = add i32 %v2738, 3
  store i32 %v2742, ptr %NEXT_PC, align 4
  %v2743 = load i32, ptr %ESP, align 4
  %v2744 = load ptr, ptr %MEMORY, align 4
  %v2745 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2744, ptr %state, ptr %ESP, i32 %v2743, i32 40)
  store ptr %v2745, ptr %MEMORY, align 4
  store i32 %v2742, ptr %PC, align 4
  %v2746 = add i32 %v2742, 5
  store i32 %v2746, ptr %NEXT_PC, align 4
  %v2747 = load i32, ptr %DSBASE, align 4
  %v2748 = add i32 4240332, %v2747
  %v2749 = load ptr, ptr %MEMORY, align 4
  %v2750 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2749, ptr %state, ptr %EAX, i32 %v2748)
  store ptr %v2750, ptr %MEMORY, align 4
  store i32 %v2746, ptr %PC, align 4
  %v2751 = add i32 %v2746, 2
  store i32 %v2751, ptr %NEXT_PC, align 4
  %v2752 = load i32, ptr %EAX, align 4
  %v2753 = load i32, ptr %EAX, align 4
  %v2754 = load ptr, ptr %MEMORY, align 4
  %v2755 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2754, ptr %state, i32 %v2752, i32 %v2753)
  store ptr %v2755, ptr %MEMORY, align 4
  store i32 %v2751, ptr %PC, align 4
  %v2756 = add i32 %v2751, 2
  store i32 %v2756, ptr %NEXT_PC, align 4
  %v2757 = add i32 %v2756, 7
  %v2758 = load ptr, ptr %MEMORY, align 4
  %v2759 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2758, ptr %state, ptr %BRANCH_TAKEN, i32 %v2757, i32 %v2756, ptr %NEXT_PC)
  store ptr %v2759, ptr %MEMORY, align 4
  br i1 true, label %bb_4205382, label %bb_4205375

bb_4205375:                                       ; preds = %bb_4205358
  store i32 %v2756, ptr %PC, align 4
  %v2760 = add i32 %v2756, 5
  store i32 %v2760, ptr %NEXT_PC, align 4
  %v2761 = load ptr, ptr %MEMORY, align 4
  %v2762 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2761, ptr %state, ptr %EAX, i32 0)
  store ptr %v2762, ptr %MEMORY, align 4
  store i32 %v2760, ptr %PC, align 4
  %v2763 = add i32 %v2760, 2
  store i32 %v2763, ptr %NEXT_PC, align 4
  %v2764 = add i32 %v2763, 112
  %v2765 = load ptr, ptr %MEMORY, align 4
  %v2766 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2765, ptr %state, i32 %v2764, ptr %NEXT_PC)
  store ptr %v2766, ptr %MEMORY, align 4
  br label %bb_4205494

bb_4205382:                                       ; preds = %bb_4205358
  store i32 %v2756, ptr %PC, align 4
  %v2767 = add i32 %v2756, 8
  store i32 %v2767, ptr %NEXT_PC, align 4
  %v2768 = load i32, ptr %ESP, align 4
  %v2769 = load i32, ptr %SSBASE, align 4
  %v2770 = add i32 %v2768, 4
  %v2771 = add i32 %v2770, %v2769
  %v2772 = load ptr, ptr %MEMORY, align 4
  %v2773 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2772, ptr %state, i32 %v2771, i32 12)
  store ptr %v2773, ptr %MEMORY, align 4
  store i32 %v2767, ptr %PC, align 4
  %v2774 = add i32 %v2767, 7
  store i32 %v2774, ptr %NEXT_PC, align 4
  %v2775 = load i32, ptr %ESP, align 4
  %v2776 = load i32, ptr %SSBASE, align 4
  %v2777 = add i32 %v2775, %v2776
  %v2778 = load ptr, ptr %MEMORY, align 4
  %v2779 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2778, ptr %state, i32 %v2777, i32 1)
  store ptr %v2779, ptr %MEMORY, align 4
  store i32 %v2774, ptr %PC, align 4
  %v2780 = add i32 %v2774, 5
  store i32 %v2780, ptr %NEXT_PC, align 4
  %v2781 = add i32 %v2780, 23250
  %v2782 = load ptr, ptr %MEMORY, align 4
  %v2783 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2782, ptr %state, i64 4228652, ptr %NEXT_PC, i32 %v2780, ptr %RETURN_PC)
  store ptr %v2783, ptr %MEMORY, align 4
  store i32 %v2780, ptr %PC, align 4
  %v2784 = add i32 %v2780, 3
  store i32 %v2784, ptr %NEXT_PC, align 4
  %v2785 = load i32, ptr %EBP, align 4
  %v2786 = load i32, ptr %SSBASE, align 4
  %v2787 = sub i32 %v2785, 12
  %v2788 = add i32 %v2787, %v2786
  %v2789 = load i32, ptr %EAX, align 4
  %v2790 = load ptr, ptr %MEMORY, align 4
  %v2791 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2790, ptr %state, i32 %v2788, i32 %v2789)
  store ptr %v2791, ptr %MEMORY, align 4
  store i32 %v2784, ptr %PC, align 4
  %v2792 = add i32 %v2784, 4
  store i32 %v2792, ptr %NEXT_PC, align 4
  %v2793 = load i32, ptr %EBP, align 4
  %v2794 = load i32, ptr %SSBASE, align 4
  %v2795 = sub i32 %v2793, 12
  %v2796 = add i32 %v2795, %v2794
  %v2797 = load ptr, ptr %MEMORY, align 4
  %v2798 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2797, ptr %state, i32 %v2796, i32 0)
  store ptr %v2798, ptr %MEMORY, align 4
  store i32 %v2792, ptr %PC, align 4
  %v2799 = add i32 %v2792, 2
  store i32 %v2799, ptr %NEXT_PC, align 4
  %v2800 = add i32 %v2799, 7
  %v2801 = load ptr, ptr %MEMORY, align 4
  %v2802 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2801, ptr %state, ptr %BRANCH_TAKEN, i32 %v2800, i32 %v2799, ptr %NEXT_PC)
  store ptr %v2802, ptr %MEMORY, align 4
  br i1 true, label %bb_4205418, label %bb_4205411

bb_4205411:                                       ; preds = %bb_4205382
  store i32 %v2799, ptr %PC, align 4
  %v2803 = add i32 %v2799, 5
  store i32 %v2803, ptr %NEXT_PC, align 4
  %v2804 = load ptr, ptr %MEMORY, align 4
  %v2805 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2804, ptr %state, ptr %EAX, i32 -1)
  store ptr %v2805, ptr %MEMORY, align 4
  store i32 %v2803, ptr %PC, align 4
  %v2806 = add i32 %v2803, 2
  store i32 %v2806, ptr %NEXT_PC, align 4
  %v2807 = add i32 %v2806, 76
  %v2808 = load ptr, ptr %MEMORY, align 4
  %v2809 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2808, ptr %state, i32 %v2807, ptr %NEXT_PC)
  store ptr %v2809, ptr %MEMORY, align 4
  br label %bb_4205494

bb_4205418:                                       ; preds = %bb_4205382
  store i32 %v2799, ptr %PC, align 4
  %v2810 = add i32 %v2799, 3
  store i32 %v2810, ptr %NEXT_PC, align 4
  %v2811 = load i32, ptr %EBP, align 4
  %v2812 = load i32, ptr %SSBASE, align 4
  %v2813 = sub i32 %v2811, 12
  %v2814 = add i32 %v2813, %v2812
  %v2815 = load ptr, ptr %MEMORY, align 4
  %v2816 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2815, ptr %state, ptr %EAX, i32 %v2814)
  store ptr %v2816, ptr %MEMORY, align 4
  store i32 %v2810, ptr %PC, align 4
  %v2817 = add i32 %v2810, 3
  store i32 %v2817, ptr %NEXT_PC, align 4
  %v2818 = load i32, ptr %EBP, align 4
  %v2819 = load i32, ptr %SSBASE, align 4
  %v2820 = add i32 %v2818, 8
  %v2821 = add i32 %v2820, %v2819
  %v2822 = load ptr, ptr %MEMORY, align 4
  %v2823 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2822, ptr %state, ptr %EDX, i32 %v2821)
  store ptr %v2823, ptr %MEMORY, align 4
  store i32 %v2817, ptr %PC, align 4
  %v2824 = add i32 %v2817, 2
  store i32 %v2824, ptr %NEXT_PC, align 4
  %v2825 = load i32, ptr %EAX, align 4
  %v2826 = load i32, ptr %DSBASE, align 4
  %v2827 = add i32 %v2825, %v2826
  %v2828 = load i32, ptr %EDX, align 4
  %v2829 = load ptr, ptr %MEMORY, align 4
  %v2830 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2829, ptr %state, i32 %v2827, i32 %v2828)
  store ptr %v2830, ptr %MEMORY, align 4
  store i32 %v2824, ptr %PC, align 4
  %v2831 = add i32 %v2824, 3
  store i32 %v2831, ptr %NEXT_PC, align 4
  %v2832 = load i32, ptr %EBP, align 4
  %v2833 = load i32, ptr %SSBASE, align 4
  %v2834 = sub i32 %v2832, 12
  %v2835 = add i32 %v2834, %v2833
  %v2836 = load ptr, ptr %MEMORY, align 4
  %v2837 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2836, ptr %state, ptr %EAX, i32 %v2835)
  store ptr %v2837, ptr %MEMORY, align 4
  store i32 %v2831, ptr %PC, align 4
  %v2838 = add i32 %v2831, 3
  store i32 %v2838, ptr %NEXT_PC, align 4
  %v2839 = load i32, ptr %EBP, align 4
  %v2840 = load i32, ptr %SSBASE, align 4
  %v2841 = add i32 %v2839, 12
  %v2842 = add i32 %v2841, %v2840
  %v2843 = load ptr, ptr %MEMORY, align 4
  %v2844 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2843, ptr %state, ptr %EDX, i32 %v2842)
  store ptr %v2844, ptr %MEMORY, align 4
  store i32 %v2838, ptr %PC, align 4
  %v2845 = add i32 %v2838, 3
  store i32 %v2845, ptr %NEXT_PC, align 4
  %v2846 = load i32, ptr %EAX, align 4
  %v2847 = load i32, ptr %DSBASE, align 4
  %v2848 = add i32 %v2846, 4
  %v2849 = add i32 %v2848, %v2847
  %v2850 = load i32, ptr %EDX, align 4
  %v2851 = load ptr, ptr %MEMORY, align 4
  %v2852 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2851, ptr %state, i32 %v2849, i32 %v2850)
  store ptr %v2852, ptr %MEMORY, align 4
  store i32 %v2845, ptr %PC, align 4
  %v2853 = add i32 %v2845, 7
  store i32 %v2853, ptr %NEXT_PC, align 4
  %v2854 = load i32, ptr %ESP, align 4
  %v2855 = load i32, ptr %SSBASE, align 4
  %v2856 = add i32 %v2854, %v2855
  %v2857 = load ptr, ptr %MEMORY, align 4
  %v2858 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2857, ptr %state, i32 %v2856, i32 4240308)
  store ptr %v2858, ptr %MEMORY, align 4
  store i32 %v2853, ptr %PC, align 4
  %v2859 = add i32 %v2853, 5
  store i32 %v2859, ptr %NEXT_PC, align 4
  %v2860 = load i32, ptr %DSBASE, align 4
  %v2861 = add i32 4243788, %v2860
  %v2862 = load ptr, ptr %MEMORY, align 4
  %v2863 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2862, ptr %state, ptr %EAX, i32 %v2861)
  store ptr %v2863, ptr %MEMORY, align 4
  store i32 %v2859, ptr %PC, align 4
  %v2864 = add i32 %v2859, 2
  store i32 %v2864, ptr %NEXT_PC, align 4
  %v2865 = load i32, ptr %EAX, align 4
  %v2866 = load ptr, ptr %MEMORY, align 4
  %v2867 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2866, ptr %state, i32 %v2865, ptr %NEXT_PC, i32 %v2864, ptr %RETURN_PC)
  store ptr %v2867, ptr %MEMORY, align 4
  store i32 %v2864, ptr %PC, align 4
  %v2868 = add i32 %v2864, 3
  store i32 %v2868, ptr %NEXT_PC, align 4
  %v2869 = load i32, ptr %ESP, align 4
  %v2870 = load ptr, ptr %MEMORY, align 4
  %v2871 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2870, ptr %state, ptr %ESP, i32 %v2869, i32 4)
  store ptr %v2871, ptr %MEMORY, align 4
  store i32 %v2868, ptr %PC, align 4
  %v2872 = add i32 %v2868, 6
  store i32 %v2872, ptr %NEXT_PC, align 4
  %v2873 = load i32, ptr %DSBASE, align 4
  %v2874 = add i32 4240336, %v2873
  %v2875 = load ptr, ptr %MEMORY, align 4
  %v2876 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2875, ptr %state, ptr %EDX, i32 %v2874)
  store ptr %v2876, ptr %MEMORY, align 4
  store i32 %v2872, ptr %PC, align 4
  %v2877 = add i32 %v2872, 3
  store i32 %v2877, ptr %NEXT_PC, align 4
  %v2878 = load i32, ptr %EBP, align 4
  %v2879 = load i32, ptr %SSBASE, align 4
  %v2880 = sub i32 %v2878, 12
  %v2881 = add i32 %v2880, %v2879
  %v2882 = load ptr, ptr %MEMORY, align 4
  %v2883 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2882, ptr %state, ptr %EAX, i32 %v2881)
  store ptr %v2883, ptr %MEMORY, align 4
  store i32 %v2877, ptr %PC, align 4
  %v2884 = add i32 %v2877, 3
  store i32 %v2884, ptr %NEXT_PC, align 4
  %v2885 = load i32, ptr %EAX, align 4
  %v2886 = load i32, ptr %DSBASE, align 4
  %v2887 = add i32 %v2885, 8
  %v2888 = add i32 %v2887, %v2886
  %v2889 = load i32, ptr %EDX, align 4
  %v2890 = load ptr, ptr %MEMORY, align 4
  %v2891 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2890, ptr %state, i32 %v2888, i32 %v2889)
  store ptr %v2891, ptr %MEMORY, align 4
  store i32 %v2884, ptr %PC, align 4
  %v2892 = add i32 %v2884, 3
  store i32 %v2892, ptr %NEXT_PC, align 4
  %v2893 = load i32, ptr %EBP, align 4
  %v2894 = load i32, ptr %SSBASE, align 4
  %v2895 = sub i32 %v2893, 12
  %v2896 = add i32 %v2895, %v2894
  %v2897 = load ptr, ptr %MEMORY, align 4
  %v2898 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2897, ptr %state, ptr %EAX, i32 %v2896)
  store ptr %v2898, ptr %MEMORY, align 4
  store i32 %v2892, ptr %PC, align 4
  %v2899 = add i32 %v2892, 5
  store i32 %v2899, ptr %NEXT_PC, align 4
  %v2900 = load i32, ptr %DSBASE, align 4
  %v2901 = add i32 4240336, %v2900
  %v2902 = load i32, ptr %EAX, align 4
  %v2903 = load ptr, ptr %MEMORY, align 4
  %v2904 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2903, ptr %state, i32 %v2901, i32 %v2902)
  store ptr %v2904, ptr %MEMORY, align 4
  store i32 %v2899, ptr %PC, align 4
  %v2905 = add i32 %v2899, 7
  store i32 %v2905, ptr %NEXT_PC, align 4
  %v2906 = load i32, ptr %ESP, align 4
  %v2907 = load i32, ptr %SSBASE, align 4
  %v2908 = add i32 %v2906, %v2907
  %v2909 = load ptr, ptr %MEMORY, align 4
  %v2910 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2909, ptr %state, i32 %v2908, i32 4240308)
  store ptr %v2910, ptr %MEMORY, align 4
  store i32 %v2905, ptr %PC, align 4
  %v2911 = add i32 %v2905, 5
  store i32 %v2911, ptr %NEXT_PC, align 4
  %v2912 = load i32, ptr %DSBASE, align 4
  %v2913 = add i32 4243840, %v2912
  %v2914 = load ptr, ptr %MEMORY, align 4
  %v2915 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2914, ptr %state, ptr %EAX, i32 %v2913)
  store ptr %v2915, ptr %MEMORY, align 4
  store i32 %v2911, ptr %PC, align 4
  %v2916 = add i32 %v2911, 2
  store i32 %v2916, ptr %NEXT_PC, align 4
  %v2917 = load i32, ptr %EAX, align 4
  %v2918 = load ptr, ptr %MEMORY, align 4
  %v2919 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2918, ptr %state, i32 %v2917, ptr %NEXT_PC, i32 %v2916, ptr %RETURN_PC)
  store ptr %v2919, ptr %MEMORY, align 4
  store i32 %v2916, ptr %PC, align 4
  %v2920 = add i32 %v2916, 3
  store i32 %v2920, ptr %NEXT_PC, align 4
  %v2921 = load i32, ptr %ESP, align 4
  %v2922 = load ptr, ptr %MEMORY, align 4
  %v2923 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2922, ptr %state, ptr %ESP, i32 %v2921, i32 4)
  store ptr %v2923, ptr %MEMORY, align 4
  store i32 %v2920, ptr %PC, align 4
  %v2924 = add i32 %v2920, 5
  store i32 %v2924, ptr %NEXT_PC, align 4
  %v2925 = load ptr, ptr %MEMORY, align 4
  %v2926 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2925, ptr %state, ptr %EAX, i32 0)
  store ptr %v2926, ptr %MEMORY, align 4
  br label %bb_4205494

bb_4205494:                                       ; preds = %bb_4205418, %bb_4205411, %bb_4205375
  %v2927 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2927, ptr %PC, align 4
  %v2928 = add i32 %v2927, 1
  store i32 %v2928, ptr %NEXT_PC, align 4
  %v2929 = load ptr, ptr %MEMORY, align 4
  %v2930 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v2929, ptr %state)
  store ptr %v2930, ptr %MEMORY, align 4
  store i32 %v2928, ptr %PC, align 4
  %v2931 = add i32 %v2928, 1
  store i32 %v2931, ptr %NEXT_PC, align 4
  %v2932 = load ptr, ptr %MEMORY, align 4
  %v2933 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2932, ptr %state, ptr %NEXT_PC)
  store ptr %v2933, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205496:                                       ; No predecessors!
  %v2934 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2934, ptr %PC, align 4
  %v2935 = add i32 %v2934, 1
  store i32 %v2935, ptr %NEXT_PC, align 4
  %v2936 = load i32, ptr %EBP, align 4
  %v2937 = load ptr, ptr %MEMORY, align 4
  %v2938 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2937, ptr %state, i32 %v2936)
  store ptr %v2938, ptr %MEMORY, align 4
  store i32 %v2935, ptr %PC, align 4
  %v2939 = add i32 %v2935, 2
  store i32 %v2939, ptr %NEXT_PC, align 4
  %v2940 = load i32, ptr %ESP, align 4
  %v2941 = load ptr, ptr %MEMORY, align 4
  %v2942 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2941, ptr %state, ptr %EBP, i32 %v2940)
  store ptr %v2942, ptr %MEMORY, align 4
  store i32 %v2939, ptr %PC, align 4
  %v2943 = add i32 %v2939, 3
  store i32 %v2943, ptr %NEXT_PC, align 4
  %v2944 = load i32, ptr %ESP, align 4
  %v2945 = load ptr, ptr %MEMORY, align 4
  %v2946 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2945, ptr %state, ptr %ESP, i32 %v2944, i32 40)
  store ptr %v2946, ptr %MEMORY, align 4
  store i32 %v2943, ptr %PC, align 4
  %v2947 = add i32 %v2943, 5
  store i32 %v2947, ptr %NEXT_PC, align 4
  %v2948 = load i32, ptr %DSBASE, align 4
  %v2949 = add i32 4240332, %v2948
  %v2950 = load ptr, ptr %MEMORY, align 4
  %v2951 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2950, ptr %state, ptr %EAX, i32 %v2949)
  store ptr %v2951, ptr %MEMORY, align 4
  store i32 %v2947, ptr %PC, align 4
  %v2952 = add i32 %v2947, 2
  store i32 %v2952, ptr %NEXT_PC, align 4
  %v2953 = load i32, ptr %EAX, align 4
  %v2954 = load i32, ptr %EAX, align 4
  %v2955 = load ptr, ptr %MEMORY, align 4
  %v2956 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2955, ptr %state, i32 %v2953, i32 %v2954)
  store ptr %v2956, ptr %MEMORY, align 4
  store i32 %v2952, ptr %PC, align 4
  %v2957 = add i32 %v2952, 2
  store i32 %v2957, ptr %NEXT_PC, align 4
  %v2958 = add i32 %v2957, 10
  %v2959 = load ptr, ptr %MEMORY, align 4
  %v2960 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2959, ptr %state, ptr %BRANCH_TAKEN, i32 %v2958, i32 %v2957, ptr %NEXT_PC)
  store ptr %v2960, ptr %MEMORY, align 4
  br i1 true, label %bb_4205521, label %bb_4205511

bb_4205511:                                       ; preds = %bb_4205496
  store i32 %v2957, ptr %PC, align 4
  %v2961 = add i32 %v2957, 5
  store i32 %v2961, ptr %NEXT_PC, align 4
  %v2962 = load ptr, ptr %MEMORY, align 4
  %v2963 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2962, ptr %state, ptr %EAX, i32 0)
  store ptr %v2963, ptr %MEMORY, align 4
  store i32 %v2961, ptr %PC, align 4
  %v2964 = add i32 %v2961, 5
  store i32 %v2964, ptr %NEXT_PC, align 4
  %v2965 = add i32 %v2964, 131
  %v2966 = load ptr, ptr %MEMORY, align 4
  %v2967 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2966, ptr %state, i32 %v2965, ptr %NEXT_PC)
  store ptr %v2967, ptr %MEMORY, align 4
  br label %bb_4205652

bb_4205521:                                       ; preds = %bb_4205496
  store i32 %v2957, ptr %PC, align 4
  %v2968 = add i32 %v2957, 7
  store i32 %v2968, ptr %NEXT_PC, align 4
  %v2969 = load i32, ptr %ESP, align 4
  %v2970 = load i32, ptr %SSBASE, align 4
  %v2971 = add i32 %v2969, %v2970
  %v2972 = load ptr, ptr %MEMORY, align 4
  %v2973 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2972, ptr %state, i32 %v2971, i32 4240308)
  store ptr %v2973, ptr %MEMORY, align 4
  store i32 %v2968, ptr %PC, align 4
  %v2974 = add i32 %v2968, 5
  store i32 %v2974, ptr %NEXT_PC, align 4
  %v2975 = load i32, ptr %DSBASE, align 4
  %v2976 = add i32 4243788, %v2975
  %v2977 = load ptr, ptr %MEMORY, align 4
  %v2978 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2977, ptr %state, ptr %EAX, i32 %v2976)
  store ptr %v2978, ptr %MEMORY, align 4
  store i32 %v2974, ptr %PC, align 4
  %v2979 = add i32 %v2974, 2
  store i32 %v2979, ptr %NEXT_PC, align 4
  %v2980 = load i32, ptr %EAX, align 4
  %v2981 = load ptr, ptr %MEMORY, align 4
  %v2982 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2981, ptr %state, i32 %v2980, ptr %NEXT_PC, i32 %v2979, ptr %RETURN_PC)
  store ptr %v2982, ptr %MEMORY, align 4
  store i32 %v2979, ptr %PC, align 4
  %v2983 = add i32 %v2979, 3
  store i32 %v2983, ptr %NEXT_PC, align 4
  %v2984 = load i32, ptr %ESP, align 4
  %v2985 = load ptr, ptr %MEMORY, align 4
  %v2986 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2985, ptr %state, ptr %ESP, i32 %v2984, i32 4)
  store ptr %v2986, ptr %MEMORY, align 4
  store i32 %v2983, ptr %PC, align 4
  %v2987 = add i32 %v2983, 7
  store i32 %v2987, ptr %NEXT_PC, align 4
  %v2988 = load i32, ptr %EBP, align 4
  %v2989 = load i32, ptr %SSBASE, align 4
  %v2990 = sub i32 %v2988, 12
  %v2991 = add i32 %v2990, %v2989
  %v2992 = load ptr, ptr %MEMORY, align 4
  %v2993 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2992, ptr %state, i32 %v2991, i32 0)
  store ptr %v2993, ptr %MEMORY, align 4
  store i32 %v2987, ptr %PC, align 4
  %v2994 = add i32 %v2987, 5
  store i32 %v2994, ptr %NEXT_PC, align 4
  %v2995 = load i32, ptr %DSBASE, align 4
  %v2996 = add i32 4240336, %v2995
  %v2997 = load ptr, ptr %MEMORY, align 4
  %v2998 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2997, ptr %state, ptr %EAX, i32 %v2996)
  store ptr %v2998, ptr %MEMORY, align 4
  store i32 %v2994, ptr %PC, align 4
  %v2999 = add i32 %v2994, 3
  store i32 %v2999, ptr %NEXT_PC, align 4
  %v3000 = load i32, ptr %EBP, align 4
  %v3001 = load i32, ptr %SSBASE, align 4
  %v3002 = sub i32 %v3000, 16
  %v3003 = add i32 %v3002, %v3001
  %v3004 = load i32, ptr %EAX, align 4
  %v3005 = load ptr, ptr %MEMORY, align 4
  %v3006 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3005, ptr %state, i32 %v3003, i32 %v3004)
  store ptr %v3006, ptr %MEMORY, align 4
  store i32 %v2999, ptr %PC, align 4
  %v3007 = add i32 %v2999, 2
  store i32 %v3007, ptr %NEXT_PC, align 4
  %v3008 = add i32 %v3007, 69
  %v3009 = load ptr, ptr %MEMORY, align 4
  %v3010 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3009, ptr %state, i32 %v3008, ptr %NEXT_PC)
  store ptr %v3010, ptr %MEMORY, align 4
  br label %bb_4205624

bb_4205555:                                       ; preds = %bb_4205624
  store i32 %v3168, ptr %PC, align 4
  %v3011 = add i32 %v3168, 3
  store i32 %v3011, ptr %NEXT_PC, align 4
  %v3012 = load i32, ptr %EBP, align 4
  %v3013 = load i32, ptr %SSBASE, align 4
  %v3014 = sub i32 %v3012, 16
  %v3015 = add i32 %v3014, %v3013
  %v3016 = load ptr, ptr %MEMORY, align 4
  %v3017 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3016, ptr %state, ptr %EAX, i32 %v3015)
  store ptr %v3017, ptr %MEMORY, align 4
  store i32 %v3011, ptr %PC, align 4
  %v3018 = add i32 %v3011, 2
  store i32 %v3018, ptr %NEXT_PC, align 4
  %v3019 = load i32, ptr %EAX, align 4
  %v3020 = load i32, ptr %DSBASE, align 4
  %v3021 = add i32 %v3019, %v3020
  %v3022 = load ptr, ptr %MEMORY, align 4
  %v3023 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3022, ptr %state, ptr %EAX, i32 %v3021)
  store ptr %v3023, ptr %MEMORY, align 4
  store i32 %v3018, ptr %PC, align 4
  %v3024 = add i32 %v3018, 3
  store i32 %v3024, ptr %NEXT_PC, align 4
  %v3025 = load i32, ptr %EAX, align 4
  %v3026 = load i32, ptr %EBP, align 4
  %v3027 = load i32, ptr %SSBASE, align 4
  %v3028 = add i32 %v3026, 8
  %v3029 = add i32 %v3028, %v3027
  %v3030 = load ptr, ptr %MEMORY, align 4
  %v3031 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3030, ptr %state, i32 %v3025, i32 %v3029)
  store ptr %v3031, ptr %MEMORY, align 4
  store i32 %v3024, ptr %PC, align 4
  %v3032 = add i32 %v3024, 2
  store i32 %v3032, ptr %NEXT_PC, align 4
  %v3033 = add i32 %v3032, 44
  %v3034 = load ptr, ptr %MEMORY, align 4
  %v3035 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3034, ptr %state, ptr %BRANCH_TAKEN, i32 %v3033, i32 %v3032, ptr %NEXT_PC)
  store ptr %v3035, ptr %MEMORY, align 4
  br i1 true, label %bb_4205609, label %bb_4205565

bb_4205565:                                       ; preds = %bb_4205555
  store i32 %v3032, ptr %PC, align 4
  %v3036 = add i32 %v3032, 4
  store i32 %v3036, ptr %NEXT_PC, align 4
  %v3037 = load i32, ptr %EBP, align 4
  %v3038 = load i32, ptr %SSBASE, align 4
  %v3039 = sub i32 %v3037, 12
  %v3040 = add i32 %v3039, %v3038
  %v3041 = load ptr, ptr %MEMORY, align 4
  %v3042 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3041, ptr %state, i32 %v3040, i32 0)
  store ptr %v3042, ptr %MEMORY, align 4
  store i32 %v3036, ptr %PC, align 4
  %v3043 = add i32 %v3036, 2
  store i32 %v3043, ptr %NEXT_PC, align 4
  %v3044 = add i32 %v3043, 13
  %v3045 = load ptr, ptr %MEMORY, align 4
  %v3046 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3045, ptr %state, ptr %BRANCH_TAKEN, i32 %v3044, i32 %v3043, ptr %NEXT_PC)
  store ptr %v3046, ptr %MEMORY, align 4
  br i1 true, label %bb_4205584, label %bb_4205571

bb_4205571:                                       ; preds = %bb_4205565
  store i32 %v3043, ptr %PC, align 4
  %v3047 = add i32 %v3043, 3
  store i32 %v3047, ptr %NEXT_PC, align 4
  %v3048 = load i32, ptr %EBP, align 4
  %v3049 = load i32, ptr %SSBASE, align 4
  %v3050 = sub i32 %v3048, 16
  %v3051 = add i32 %v3050, %v3049
  %v3052 = load ptr, ptr %MEMORY, align 4
  %v3053 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3052, ptr %state, ptr %EAX, i32 %v3051)
  store ptr %v3053, ptr %MEMORY, align 4
  store i32 %v3047, ptr %PC, align 4
  %v3054 = add i32 %v3047, 3
  store i32 %v3054, ptr %NEXT_PC, align 4
  %v3055 = load i32, ptr %EAX, align 4
  %v3056 = load i32, ptr %DSBASE, align 4
  %v3057 = add i32 %v3055, 8
  %v3058 = add i32 %v3057, %v3056
  %v3059 = load ptr, ptr %MEMORY, align 4
  %v3060 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3059, ptr %state, ptr %EAX, i32 %v3058)
  store ptr %v3060, ptr %MEMORY, align 4
  store i32 %v3054, ptr %PC, align 4
  %v3061 = add i32 %v3054, 5
  store i32 %v3061, ptr %NEXT_PC, align 4
  %v3062 = load i32, ptr %DSBASE, align 4
  %v3063 = add i32 4240336, %v3062
  %v3064 = load i32, ptr %EAX, align 4
  %v3065 = load ptr, ptr %MEMORY, align 4
  %v3066 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3065, ptr %state, i32 %v3063, i32 %v3064)
  store ptr %v3066, ptr %MEMORY, align 4
  store i32 %v3061, ptr %PC, align 4
  %v3067 = add i32 %v3061, 2
  store i32 %v3067, ptr %NEXT_PC, align 4
  %v3068 = add i32 %v3067, 12
  %v3069 = load ptr, ptr %MEMORY, align 4
  %v3070 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3069, ptr %state, i32 %v3068, ptr %NEXT_PC)
  store ptr %v3070, ptr %MEMORY, align 4
  br label %bb_4205596

bb_4205584:                                       ; preds = %bb_4205565
  store i32 %v3043, ptr %PC, align 4
  %v3071 = add i32 %v3043, 3
  store i32 %v3071, ptr %NEXT_PC, align 4
  %v3072 = load i32, ptr %EBP, align 4
  %v3073 = load i32, ptr %SSBASE, align 4
  %v3074 = sub i32 %v3072, 16
  %v3075 = add i32 %v3074, %v3073
  %v3076 = load ptr, ptr %MEMORY, align 4
  %v3077 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3076, ptr %state, ptr %EAX, i32 %v3075)
  store ptr %v3077, ptr %MEMORY, align 4
  store i32 %v3071, ptr %PC, align 4
  %v3078 = add i32 %v3071, 3
  store i32 %v3078, ptr %NEXT_PC, align 4
  %v3079 = load i32, ptr %EAX, align 4
  %v3080 = load i32, ptr %DSBASE, align 4
  %v3081 = add i32 %v3079, 8
  %v3082 = add i32 %v3081, %v3080
  %v3083 = load ptr, ptr %MEMORY, align 4
  %v3084 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3083, ptr %state, ptr %EDX, i32 %v3082)
  store ptr %v3084, ptr %MEMORY, align 4
  store i32 %v3078, ptr %PC, align 4
  %v3085 = add i32 %v3078, 3
  store i32 %v3085, ptr %NEXT_PC, align 4
  %v3086 = load i32, ptr %EBP, align 4
  %v3087 = load i32, ptr %SSBASE, align 4
  %v3088 = sub i32 %v3086, 12
  %v3089 = add i32 %v3088, %v3087
  %v3090 = load ptr, ptr %MEMORY, align 4
  %v3091 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3090, ptr %state, ptr %EAX, i32 %v3089)
  store ptr %v3091, ptr %MEMORY, align 4
  store i32 %v3085, ptr %PC, align 4
  %v3092 = add i32 %v3085, 3
  store i32 %v3092, ptr %NEXT_PC, align 4
  %v3093 = load i32, ptr %EAX, align 4
  %v3094 = load i32, ptr %DSBASE, align 4
  %v3095 = add i32 %v3093, 8
  %v3096 = add i32 %v3095, %v3094
  %v3097 = load i32, ptr %EDX, align 4
  %v3098 = load ptr, ptr %MEMORY, align 4
  %v3099 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3098, ptr %state, i32 %v3096, i32 %v3097)
  store ptr %v3099, ptr %MEMORY, align 4
  br label %bb_4205596

bb_4205596:                                       ; preds = %bb_4205584, %bb_4205571
  %v3100 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3100, ptr %PC, align 4
  %v3101 = add i32 %v3100, 3
  store i32 %v3101, ptr %NEXT_PC, align 4
  %v3102 = load i32, ptr %EBP, align 4
  %v3103 = load i32, ptr %SSBASE, align 4
  %v3104 = sub i32 %v3102, 16
  %v3105 = add i32 %v3104, %v3103
  %v3106 = load ptr, ptr %MEMORY, align 4
  %v3107 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3106, ptr %state, ptr %EAX, i32 %v3105)
  store ptr %v3107, ptr %MEMORY, align 4
  store i32 %v3101, ptr %PC, align 4
  %v3108 = add i32 %v3101, 3
  store i32 %v3108, ptr %NEXT_PC, align 4
  %v3109 = load i32, ptr %ESP, align 4
  %v3110 = load i32, ptr %SSBASE, align 4
  %v3111 = add i32 %v3109, %v3110
  %v3112 = load i32, ptr %EAX, align 4
  %v3113 = load ptr, ptr %MEMORY, align 4
  %v3114 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3113, ptr %state, i32 %v3111, i32 %v3112)
  store ptr %v3114, ptr %MEMORY, align 4
  store i32 %v3108, ptr %PC, align 4
  %v3115 = add i32 %v3108, 5
  store i32 %v3115, ptr %NEXT_PC, align 4
  %v3116 = add i32 %v3115, 23053
  %v3117 = load ptr, ptr %MEMORY, align 4
  %v3118 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3117, ptr %state, i64 4228660, ptr %NEXT_PC, i32 %v3115, ptr %RETURN_PC)
  store ptr %v3118, ptr %MEMORY, align 4
  store i32 %v3115, ptr %PC, align 4
  %v3119 = add i32 %v3115, 2
  store i32 %v3119, ptr %NEXT_PC, align 4
  %v3120 = add i32 %v3119, 21
  %v3121 = load ptr, ptr %MEMORY, align 4
  %v3122 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3121, ptr %state, i32 %v3120, ptr %NEXT_PC)
  store ptr %v3122, ptr %MEMORY, align 4
  br label %bb_4205630

bb_4205609:                                       ; preds = %bb_4205555
  store i32 %v3032, ptr %PC, align 4
  %v3123 = add i32 %v3032, 3
  store i32 %v3123, ptr %NEXT_PC, align 4
  %v3124 = load i32, ptr %EBP, align 4
  %v3125 = load i32, ptr %SSBASE, align 4
  %v3126 = sub i32 %v3124, 16
  %v3127 = add i32 %v3126, %v3125
  %v3128 = load ptr, ptr %MEMORY, align 4
  %v3129 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3128, ptr %state, ptr %EAX, i32 %v3127)
  store ptr %v3129, ptr %MEMORY, align 4
  store i32 %v3123, ptr %PC, align 4
  %v3130 = add i32 %v3123, 3
  store i32 %v3130, ptr %NEXT_PC, align 4
  %v3131 = load i32, ptr %EBP, align 4
  %v3132 = load i32, ptr %SSBASE, align 4
  %v3133 = sub i32 %v3131, 12
  %v3134 = add i32 %v3133, %v3132
  %v3135 = load i32, ptr %EAX, align 4
  %v3136 = load ptr, ptr %MEMORY, align 4
  %v3137 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3136, ptr %state, i32 %v3134, i32 %v3135)
  store ptr %v3137, ptr %MEMORY, align 4
  store i32 %v3130, ptr %PC, align 4
  %v3138 = add i32 %v3130, 3
  store i32 %v3138, ptr %NEXT_PC, align 4
  %v3139 = load i32, ptr %EBP, align 4
  %v3140 = load i32, ptr %SSBASE, align 4
  %v3141 = sub i32 %v3139, 16
  %v3142 = add i32 %v3141, %v3140
  %v3143 = load ptr, ptr %MEMORY, align 4
  %v3144 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3143, ptr %state, ptr %EAX, i32 %v3142)
  store ptr %v3144, ptr %MEMORY, align 4
  store i32 %v3138, ptr %PC, align 4
  %v3145 = add i32 %v3138, 3
  store i32 %v3145, ptr %NEXT_PC, align 4
  %v3146 = load i32, ptr %EAX, align 4
  %v3147 = load i32, ptr %DSBASE, align 4
  %v3148 = add i32 %v3146, 8
  %v3149 = add i32 %v3148, %v3147
  %v3150 = load ptr, ptr %MEMORY, align 4
  %v3151 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3150, ptr %state, ptr %EAX, i32 %v3149)
  store ptr %v3151, ptr %MEMORY, align 4
  store i32 %v3145, ptr %PC, align 4
  %v3152 = add i32 %v3145, 3
  store i32 %v3152, ptr %NEXT_PC, align 4
  %v3153 = load i32, ptr %EBP, align 4
  %v3154 = load i32, ptr %SSBASE, align 4
  %v3155 = sub i32 %v3153, 16
  %v3156 = add i32 %v3155, %v3154
  %v3157 = load i32, ptr %EAX, align 4
  %v3158 = load ptr, ptr %MEMORY, align 4
  %v3159 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3158, ptr %state, i32 %v3156, i32 %v3157)
  store ptr %v3159, ptr %MEMORY, align 4
  br label %bb_4205624

bb_4205624:                                       ; preds = %bb_4205609, %bb_4205521
  %v3160 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3160, ptr %PC, align 4
  %v3161 = add i32 %v3160, 4
  store i32 %v3161, ptr %NEXT_PC, align 4
  %v3162 = load i32, ptr %EBP, align 4
  %v3163 = load i32, ptr %SSBASE, align 4
  %v3164 = sub i32 %v3162, 16
  %v3165 = add i32 %v3164, %v3163
  %v3166 = load ptr, ptr %MEMORY, align 4
  %v3167 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3166, ptr %state, i32 %v3165, i32 0)
  store ptr %v3167, ptr %MEMORY, align 4
  store i32 %v3161, ptr %PC, align 4
  %v3168 = add i32 %v3161, 2
  store i32 %v3168, ptr %NEXT_PC, align 4
  %v3169 = sub i32 %v3168, 75
  %v3170 = load ptr, ptr %MEMORY, align 4
  %v3171 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3170, ptr %state, ptr %BRANCH_TAKEN, i32 %v3169, i32 %v3168, ptr %NEXT_PC)
  store ptr %v3171, ptr %MEMORY, align 4
  br i1 true, label %bb_4205555, label %bb_4205630

bb_4205630:                                       ; preds = %bb_4205624, %bb_4205596
  %v3172 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3172, ptr %PC, align 4
  %v3173 = add i32 %v3172, 7
  store i32 %v3173, ptr %NEXT_PC, align 4
  %v3174 = load i32, ptr %ESP, align 4
  %v3175 = load i32, ptr %SSBASE, align 4
  %v3176 = add i32 %v3174, %v3175
  %v3177 = load ptr, ptr %MEMORY, align 4
  %v3178 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3177, ptr %state, i32 %v3176, i32 4240308)
  store ptr %v3178, ptr %MEMORY, align 4
  store i32 %v3173, ptr %PC, align 4
  %v3179 = add i32 %v3173, 5
  store i32 %v3179, ptr %NEXT_PC, align 4
  %v3180 = load i32, ptr %DSBASE, align 4
  %v3181 = add i32 4243840, %v3180
  %v3182 = load ptr, ptr %MEMORY, align 4
  %v3183 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3182, ptr %state, ptr %EAX, i32 %v3181)
  store ptr %v3183, ptr %MEMORY, align 4
  store i32 %v3179, ptr %PC, align 4
  %v3184 = add i32 %v3179, 2
  store i32 %v3184, ptr %NEXT_PC, align 4
  %v3185 = load i32, ptr %EAX, align 4
  %v3186 = load ptr, ptr %MEMORY, align 4
  %v3187 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3186, ptr %state, i32 %v3185, ptr %NEXT_PC, i32 %v3184, ptr %RETURN_PC)
  store ptr %v3187, ptr %MEMORY, align 4
  store i32 %v3184, ptr %PC, align 4
  %v3188 = add i32 %v3184, 3
  store i32 %v3188, ptr %NEXT_PC, align 4
  %v3189 = load i32, ptr %ESP, align 4
  %v3190 = load ptr, ptr %MEMORY, align 4
  %v3191 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3190, ptr %state, ptr %ESP, i32 %v3189, i32 4)
  store ptr %v3191, ptr %MEMORY, align 4
  store i32 %v3188, ptr %PC, align 4
  %v3192 = add i32 %v3188, 5
  store i32 %v3192, ptr %NEXT_PC, align 4
  %v3193 = load ptr, ptr %MEMORY, align 4
  %v3194 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3193, ptr %state, ptr %EAX, i32 0)
  store ptr %v3194, ptr %MEMORY, align 4
  br label %bb_4205652

bb_4205652:                                       ; preds = %bb_4205630, %bb_4205511
  %v3195 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3195, ptr %PC, align 4
  %v3196 = add i32 %v3195, 1
  store i32 %v3196, ptr %NEXT_PC, align 4
  %v3197 = load ptr, ptr %MEMORY, align 4
  %v3198 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v3197, ptr %state)
  store ptr %v3198, ptr %MEMORY, align 4
  store i32 %v3196, ptr %PC, align 4
  %v3199 = add i32 %v3196, 1
  store i32 %v3199, ptr %NEXT_PC, align 4
  %v3200 = load ptr, ptr %MEMORY, align 4
  %v3201 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3200, ptr %state, ptr %NEXT_PC)
  store ptr %v3201, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205654:                                       ; No predecessors!
  %v3202 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3202, ptr %PC, align 4
  %v3203 = add i32 %v3202, 1
  store i32 %v3203, ptr %NEXT_PC, align 4
  %v3204 = load i32, ptr %EBP, align 4
  %v3205 = load ptr, ptr %MEMORY, align 4
  %v3206 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3205, ptr %state, i32 %v3204)
  store ptr %v3206, ptr %MEMORY, align 4
  store i32 %v3203, ptr %PC, align 4
  %v3207 = add i32 %v3203, 2
  store i32 %v3207, ptr %NEXT_PC, align 4
  %v3208 = load i32, ptr %ESP, align 4
  %v3209 = load ptr, ptr %MEMORY, align 4
  %v3210 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3209, ptr %state, ptr %EBP, i32 %v3208)
  store ptr %v3210, ptr %MEMORY, align 4
  store i32 %v3207, ptr %PC, align 4
  %v3211 = add i32 %v3207, 3
  store i32 %v3211, ptr %NEXT_PC, align 4
  %v3212 = load i32, ptr %ESP, align 4
  %v3213 = load ptr, ptr %MEMORY, align 4
  %v3214 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3213, ptr %state, ptr %ESP, i32 %v3212, i32 40)
  store ptr %v3214, ptr %MEMORY, align 4
  store i32 %v3211, ptr %PC, align 4
  %v3215 = add i32 %v3211, 5
  store i32 %v3215, ptr %NEXT_PC, align 4
  %v3216 = load i32, ptr %DSBASE, align 4
  %v3217 = add i32 4240332, %v3216
  %v3218 = load ptr, ptr %MEMORY, align 4
  %v3219 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3218, ptr %state, ptr %EAX, i32 %v3217)
  store ptr %v3219, ptr %MEMORY, align 4
  store i32 %v3215, ptr %PC, align 4
  %v3220 = add i32 %v3215, 2
  store i32 %v3220, ptr %NEXT_PC, align 4
  %v3221 = load i32, ptr %EAX, align 4
  %v3222 = load i32, ptr %EAX, align 4
  %v3223 = load ptr, ptr %MEMORY, align 4
  %v3224 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3223, ptr %state, i32 %v3221, i32 %v3222)
  store ptr %v3224, ptr %MEMORY, align 4
  store i32 %v3220, ptr %PC, align 4
  %v3225 = add i32 %v3220, 2
  store i32 %v3225, ptr %NEXT_PC, align 4
  %v3226 = add i32 %v3225, 113
  %v3227 = load ptr, ptr %MEMORY, align 4
  %v3228 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3227, ptr %state, ptr %BRANCH_TAKEN, i32 %v3226, i32 %v3225, ptr %NEXT_PC)
  store ptr %v3228, ptr %MEMORY, align 4
  br i1 true, label %bb_4205782, label %bb_4205669

bb_4205669:                                       ; preds = %bb_4205654
  store i32 %v3225, ptr %PC, align 4
  %v3229 = add i32 %v3225, 7
  store i32 %v3229, ptr %NEXT_PC, align 4
  %v3230 = load i32, ptr %ESP, align 4
  %v3231 = load i32, ptr %SSBASE, align 4
  %v3232 = add i32 %v3230, %v3231
  %v3233 = load ptr, ptr %MEMORY, align 4
  %v3234 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3233, ptr %state, i32 %v3232, i32 4240308)
  store ptr %v3234, ptr %MEMORY, align 4
  store i32 %v3229, ptr %PC, align 4
  %v3235 = add i32 %v3229, 5
  store i32 %v3235, ptr %NEXT_PC, align 4
  %v3236 = load i32, ptr %DSBASE, align 4
  %v3237 = add i32 4243788, %v3236
  %v3238 = load ptr, ptr %MEMORY, align 4
  %v3239 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3238, ptr %state, ptr %EAX, i32 %v3237)
  store ptr %v3239, ptr %MEMORY, align 4
  store i32 %v3235, ptr %PC, align 4
  %v3240 = add i32 %v3235, 2
  store i32 %v3240, ptr %NEXT_PC, align 4
  %v3241 = load i32, ptr %EAX, align 4
  %v3242 = load ptr, ptr %MEMORY, align 4
  %v3243 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3242, ptr %state, i32 %v3241, ptr %NEXT_PC, i32 %v3240, ptr %RETURN_PC)
  store ptr %v3243, ptr %MEMORY, align 4
  store i32 %v3240, ptr %PC, align 4
  %v3244 = add i32 %v3240, 3
  store i32 %v3244, ptr %NEXT_PC, align 4
  %v3245 = load i32, ptr %ESP, align 4
  %v3246 = load ptr, ptr %MEMORY, align 4
  %v3247 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3246, ptr %state, ptr %ESP, i32 %v3245, i32 4)
  store ptr %v3247, ptr %MEMORY, align 4
  store i32 %v3244, ptr %PC, align 4
  %v3248 = add i32 %v3244, 5
  store i32 %v3248, ptr %NEXT_PC, align 4
  %v3249 = load i32, ptr %DSBASE, align 4
  %v3250 = add i32 4240336, %v3249
  %v3251 = load ptr, ptr %MEMORY, align 4
  %v3252 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3251, ptr %state, ptr %EAX, i32 %v3250)
  store ptr %v3252, ptr %MEMORY, align 4
  store i32 %v3248, ptr %PC, align 4
  %v3253 = add i32 %v3248, 3
  store i32 %v3253, ptr %NEXT_PC, align 4
  %v3254 = load i32, ptr %EBP, align 4
  %v3255 = load i32, ptr %SSBASE, align 4
  %v3256 = sub i32 %v3254, 12
  %v3257 = add i32 %v3256, %v3255
  %v3258 = load i32, ptr %EAX, align 4
  %v3259 = load ptr, ptr %MEMORY, align 4
  %v3260 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3259, ptr %state, i32 %v3257, i32 %v3258)
  store ptr %v3260, ptr %MEMORY, align 4
  store i32 %v3253, ptr %PC, align 4
  %v3261 = add i32 %v3253, 2
  store i32 %v3261, ptr %NEXT_PC, align 4
  %v3262 = add i32 %v3261, 61
  %v3263 = load ptr, ptr %MEMORY, align 4
  %v3264 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3263, ptr %state, i32 %v3262, ptr %NEXT_PC)
  store ptr %v3264, ptr %MEMORY, align 4
  br label %bb_4205757

bb_4205696:                                       ; preds = %bb_4205757
  store i32 %v3398, ptr %PC, align 4
  %v3265 = add i32 %v3398, 3
  store i32 %v3265, ptr %NEXT_PC, align 4
  %v3266 = load i32, ptr %EBP, align 4
  %v3267 = load i32, ptr %SSBASE, align 4
  %v3268 = sub i32 %v3266, 12
  %v3269 = add i32 %v3268, %v3267
  %v3270 = load ptr, ptr %MEMORY, align 4
  %v3271 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3270, ptr %state, ptr %EAX, i32 %v3269)
  store ptr %v3271, ptr %MEMORY, align 4
  store i32 %v3265, ptr %PC, align 4
  %v3272 = add i32 %v3265, 2
  store i32 %v3272, ptr %NEXT_PC, align 4
  %v3273 = load i32, ptr %EAX, align 4
  %v3274 = load i32, ptr %DSBASE, align 4
  %v3275 = add i32 %v3273, %v3274
  %v3276 = load ptr, ptr %MEMORY, align 4
  %v3277 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3276, ptr %state, ptr %EAX, i32 %v3275)
  store ptr %v3277, ptr %MEMORY, align 4
  store i32 %v3272, ptr %PC, align 4
  %v3278 = add i32 %v3272, 3
  store i32 %v3278, ptr %NEXT_PC, align 4
  %v3279 = load i32, ptr %ESP, align 4
  %v3280 = load i32, ptr %SSBASE, align 4
  %v3281 = add i32 %v3279, %v3280
  %v3282 = load i32, ptr %EAX, align 4
  %v3283 = load ptr, ptr %MEMORY, align 4
  %v3284 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3283, ptr %state, i32 %v3281, i32 %v3282)
  store ptr %v3284, ptr %MEMORY, align 4
  store i32 %v3278, ptr %PC, align 4
  %v3285 = add i32 %v3278, 5
  store i32 %v3285, ptr %NEXT_PC, align 4
  %v3286 = load i32, ptr %DSBASE, align 4
  %v3287 = add i32 4243872, %v3286
  %v3288 = load ptr, ptr %MEMORY, align 4
  %v3289 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3288, ptr %state, ptr %EAX, i32 %v3287)
  store ptr %v3289, ptr %MEMORY, align 4
  store i32 %v3285, ptr %PC, align 4
  %v3290 = add i32 %v3285, 2
  store i32 %v3290, ptr %NEXT_PC, align 4
  %v3291 = load i32, ptr %EAX, align 4
  %v3292 = load ptr, ptr %MEMORY, align 4
  %v3293 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3292, ptr %state, i32 %v3291, ptr %NEXT_PC, i32 %v3290, ptr %RETURN_PC)
  store ptr %v3293, ptr %MEMORY, align 4
  store i32 %v3290, ptr %PC, align 4
  %v3294 = add i32 %v3290, 3
  store i32 %v3294, ptr %NEXT_PC, align 4
  %v3295 = load i32, ptr %ESP, align 4
  %v3296 = load ptr, ptr %MEMORY, align 4
  %v3297 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3296, ptr %state, ptr %ESP, i32 %v3295, i32 4)
  store ptr %v3297, ptr %MEMORY, align 4
  store i32 %v3294, ptr %PC, align 4
  %v3298 = add i32 %v3294, 3
  store i32 %v3298, ptr %NEXT_PC, align 4
  %v3299 = load i32, ptr %EBP, align 4
  %v3300 = load i32, ptr %SSBASE, align 4
  %v3301 = sub i32 %v3299, 16
  %v3302 = add i32 %v3301, %v3300
  %v3303 = load i32, ptr %EAX, align 4
  %v3304 = load ptr, ptr %MEMORY, align 4
  %v3305 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3304, ptr %state, i32 %v3302, i32 %v3303)
  store ptr %v3305, ptr %MEMORY, align 4
  store i32 %v3298, ptr %PC, align 4
  %v3306 = add i32 %v3298, 5
  store i32 %v3306, ptr %NEXT_PC, align 4
  %v3307 = load i32, ptr %DSBASE, align 4
  %v3308 = add i32 4243808, %v3307
  %v3309 = load ptr, ptr %MEMORY, align 4
  %v3310 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3309, ptr %state, ptr %EAX, i32 %v3308)
  store ptr %v3310, ptr %MEMORY, align 4
  store i32 %v3306, ptr %PC, align 4
  %v3311 = add i32 %v3306, 2
  store i32 %v3311, ptr %NEXT_PC, align 4
  %v3312 = load i32, ptr %EAX, align 4
  %v3313 = load ptr, ptr %MEMORY, align 4
  %v3314 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3313, ptr %state, i32 %v3312, ptr %NEXT_PC, i32 %v3311, ptr %RETURN_PC)
  store ptr %v3314, ptr %MEMORY, align 4
  store i32 %v3311, ptr %PC, align 4
  %v3315 = add i32 %v3311, 2
  store i32 %v3315, ptr %NEXT_PC, align 4
  %v3316 = load i32, ptr %EAX, align 4
  %v3317 = load i32, ptr %EAX, align 4
  %v3318 = load ptr, ptr %MEMORY, align 4
  %v3319 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3318, ptr %state, i32 %v3316, i32 %v3317)
  store ptr %v3319, ptr %MEMORY, align 4
  store i32 %v3315, ptr %PC, align 4
  %v3320 = add i32 %v3315, 2
  store i32 %v3320, ptr %NEXT_PC, align 4
  %v3321 = add i32 %v3320, 20
  %v3322 = load ptr, ptr %MEMORY, align 4
  %v3323 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3322, ptr %state, ptr %BRANCH_TAKEN, i32 %v3321, i32 %v3320, ptr %NEXT_PC)
  store ptr %v3323, ptr %MEMORY, align 4
  br i1 true, label %bb_4205748, label %bb_4205728

bb_4205728:                                       ; preds = %bb_4205696
  store i32 %v3320, ptr %PC, align 4
  %v3324 = add i32 %v3320, 4
  store i32 %v3324, ptr %NEXT_PC, align 4
  %v3325 = load i32, ptr %EBP, align 4
  %v3326 = load i32, ptr %SSBASE, align 4
  %v3327 = sub i32 %v3325, 16
  %v3328 = add i32 %v3327, %v3326
  %v3329 = load ptr, ptr %MEMORY, align 4
  %v3330 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3329, ptr %state, i32 %v3328, i32 0)
  store ptr %v3330, ptr %MEMORY, align 4
  store i32 %v3324, ptr %PC, align 4
  %v3331 = add i32 %v3324, 2
  store i32 %v3331, ptr %NEXT_PC, align 4
  %v3332 = add i32 %v3331, 14
  %v3333 = load ptr, ptr %MEMORY, align 4
  %v3334 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3333, ptr %state, ptr %BRANCH_TAKEN, i32 %v3332, i32 %v3331, ptr %NEXT_PC)
  store ptr %v3334, ptr %MEMORY, align 4
  br i1 true, label %bb_4205748, label %bb_4205734

bb_4205734:                                       ; preds = %bb_4205728
  store i32 %v3331, ptr %PC, align 4
  %v3335 = add i32 %v3331, 3
  store i32 %v3335, ptr %NEXT_PC, align 4
  %v3336 = load i32, ptr %EBP, align 4
  %v3337 = load i32, ptr %SSBASE, align 4
  %v3338 = sub i32 %v3336, 12
  %v3339 = add i32 %v3338, %v3337
  %v3340 = load ptr, ptr %MEMORY, align 4
  %v3341 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3340, ptr %state, ptr %EAX, i32 %v3339)
  store ptr %v3341, ptr %MEMORY, align 4
  store i32 %v3335, ptr %PC, align 4
  %v3342 = add i32 %v3335, 3
  store i32 %v3342, ptr %NEXT_PC, align 4
  %v3343 = load i32, ptr %EAX, align 4
  %v3344 = load i32, ptr %DSBASE, align 4
  %v3345 = add i32 %v3343, 4
  %v3346 = add i32 %v3345, %v3344
  %v3347 = load ptr, ptr %MEMORY, align 4
  %v3348 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3347, ptr %state, ptr %EAX, i32 %v3346)
  store ptr %v3348, ptr %MEMORY, align 4
  store i32 %v3342, ptr %PC, align 4
  %v3349 = add i32 %v3342, 3
  store i32 %v3349, ptr %NEXT_PC, align 4
  %v3350 = load i32, ptr %EBP, align 4
  %v3351 = load i32, ptr %SSBASE, align 4
  %v3352 = sub i32 %v3350, 16
  %v3353 = add i32 %v3352, %v3351
  %v3354 = load ptr, ptr %MEMORY, align 4
  %v3355 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3354, ptr %state, ptr %EDX, i32 %v3353)
  store ptr %v3355, ptr %MEMORY, align 4
  store i32 %v3349, ptr %PC, align 4
  %v3356 = add i32 %v3349, 3
  store i32 %v3356, ptr %NEXT_PC, align 4
  %v3357 = load i32, ptr %ESP, align 4
  %v3358 = load i32, ptr %SSBASE, align 4
  %v3359 = add i32 %v3357, %v3358
  %v3360 = load i32, ptr %EDX, align 4
  %v3361 = load ptr, ptr %MEMORY, align 4
  %v3362 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3361, ptr %state, i32 %v3359, i32 %v3360)
  store ptr %v3362, ptr %MEMORY, align 4
  store i32 %v3356, ptr %PC, align 4
  %v3363 = add i32 %v3356, 2
  store i32 %v3363, ptr %NEXT_PC, align 4
  %v3364 = load i32, ptr %EAX, align 4
  %v3365 = load ptr, ptr %MEMORY, align 4
  %v3366 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3365, ptr %state, i32 %v3364, ptr %NEXT_PC, i32 %v3363, ptr %RETURN_PC)
  store ptr %v3366, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205748:                                       ; preds = %bb_4205728, %bb_4205696
  %v3367 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3367, ptr %PC, align 4
  %v3368 = add i32 %v3367, 3
  store i32 %v3368, ptr %NEXT_PC, align 4
  %v3369 = load i32, ptr %EBP, align 4
  %v3370 = load i32, ptr %SSBASE, align 4
  %v3371 = sub i32 %v3369, 12
  %v3372 = add i32 %v3371, %v3370
  %v3373 = load ptr, ptr %MEMORY, align 4
  %v3374 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3373, ptr %state, ptr %EAX, i32 %v3372)
  store ptr %v3374, ptr %MEMORY, align 4
  store i32 %v3368, ptr %PC, align 4
  %v3375 = add i32 %v3368, 3
  store i32 %v3375, ptr %NEXT_PC, align 4
  %v3376 = load i32, ptr %EAX, align 4
  %v3377 = load i32, ptr %DSBASE, align 4
  %v3378 = add i32 %v3376, 8
  %v3379 = add i32 %v3378, %v3377
  %v3380 = load ptr, ptr %MEMORY, align 4
  %v3381 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3380, ptr %state, ptr %EAX, i32 %v3379)
  store ptr %v3381, ptr %MEMORY, align 4
  store i32 %v3375, ptr %PC, align 4
  %v3382 = add i32 %v3375, 3
  store i32 %v3382, ptr %NEXT_PC, align 4
  %v3383 = load i32, ptr %EBP, align 4
  %v3384 = load i32, ptr %SSBASE, align 4
  %v3385 = sub i32 %v3383, 12
  %v3386 = add i32 %v3385, %v3384
  %v3387 = load i32, ptr %EAX, align 4
  %v3388 = load ptr, ptr %MEMORY, align 4
  %v3389 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3388, ptr %state, i32 %v3386, i32 %v3387)
  store ptr %v3389, ptr %MEMORY, align 4
  br label %bb_4205757

bb_4205757:                                       ; preds = %bb_4205748, %bb_4205669
  %v3390 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3390, ptr %PC, align 4
  %v3391 = add i32 %v3390, 4
  store i32 %v3391, ptr %NEXT_PC, align 4
  %v3392 = load i32, ptr %EBP, align 4
  %v3393 = load i32, ptr %SSBASE, align 4
  %v3394 = sub i32 %v3392, 12
  %v3395 = add i32 %v3394, %v3393
  %v3396 = load ptr, ptr %MEMORY, align 4
  %v3397 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3396, ptr %state, i32 %v3395, i32 0)
  store ptr %v3397, ptr %MEMORY, align 4
  store i32 %v3391, ptr %PC, align 4
  %v3398 = add i32 %v3391, 2
  store i32 %v3398, ptr %NEXT_PC, align 4
  %v3399 = sub i32 %v3398, 67
  %v3400 = load ptr, ptr %MEMORY, align 4
  %v3401 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3400, ptr %state, ptr %BRANCH_TAKEN, i32 %v3399, i32 %v3398, ptr %NEXT_PC)
  store ptr %v3401, ptr %MEMORY, align 4
  br i1 true, label %bb_4205696, label %bb_4205763

bb_4205763:                                       ; preds = %bb_4205757
  store i32 %v3398, ptr %PC, align 4
  %v3402 = add i32 %v3398, 7
  store i32 %v3402, ptr %NEXT_PC, align 4
  %v3403 = load i32, ptr %ESP, align 4
  %v3404 = load i32, ptr %SSBASE, align 4
  %v3405 = add i32 %v3403, %v3404
  %v3406 = load ptr, ptr %MEMORY, align 4
  %v3407 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3406, ptr %state, i32 %v3405, i32 4240308)
  store ptr %v3407, ptr %MEMORY, align 4
  store i32 %v3402, ptr %PC, align 4
  %v3408 = add i32 %v3402, 5
  store i32 %v3408, ptr %NEXT_PC, align 4
  %v3409 = load i32, ptr %DSBASE, align 4
  %v3410 = add i32 4243840, %v3409
  %v3411 = load ptr, ptr %MEMORY, align 4
  %v3412 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3411, ptr %state, ptr %EAX, i32 %v3410)
  store ptr %v3412, ptr %MEMORY, align 4
  store i32 %v3408, ptr %PC, align 4
  %v3413 = add i32 %v3408, 2
  store i32 %v3413, ptr %NEXT_PC, align 4
  %v3414 = load i32, ptr %EAX, align 4
  %v3415 = load ptr, ptr %MEMORY, align 4
  %v3416 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3415, ptr %state, i32 %v3414, ptr %NEXT_PC, i32 %v3413, ptr %RETURN_PC)
  store ptr %v3416, ptr %MEMORY, align 4
  store i32 %v3413, ptr %PC, align 4
  %v3417 = add i32 %v3413, 3
  store i32 %v3417, ptr %NEXT_PC, align 4
  %v3418 = load i32, ptr %ESP, align 4
  %v3419 = load ptr, ptr %MEMORY, align 4
  %v3420 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3419, ptr %state, ptr %ESP, i32 %v3418, i32 4)
  store ptr %v3420, ptr %MEMORY, align 4
  store i32 %v3417, ptr %PC, align 4
  %v3421 = add i32 %v3417, 2
  store i32 %v3421, ptr %NEXT_PC, align 4
  %v3422 = add i32 %v3421, 1
  %v3423 = load ptr, ptr %MEMORY, align 4
  %v3424 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3423, ptr %state, i32 %v3422, ptr %NEXT_PC)
  store ptr %v3424, ptr %MEMORY, align 4
  br label %bb_4205783

bb_4205782:                                       ; preds = %bb_4205654
  store i32 %v3225, ptr %PC, align 4
  %v3425 = add i32 %v3225, 1
  store i32 %v3425, ptr %NEXT_PC, align 4
  %v3426 = load ptr, ptr %MEMORY, align 4
  %v3427 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3426, ptr %state)
  store ptr %v3427, ptr %MEMORY, align 4
  br label %bb_4205783

bb_4205783:                                       ; preds = %bb_4205782, %bb_4205763
  %v3428 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3428, ptr %PC, align 4
  %v3429 = add i32 %v3428, 1
  store i32 %v3429, ptr %NEXT_PC, align 4
  %v3430 = load ptr, ptr %MEMORY, align 4
  %v3431 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v3430, ptr %state)
  store ptr %v3431, ptr %MEMORY, align 4
  store i32 %v3429, ptr %PC, align 4
  %v3432 = add i32 %v3429, 1
  store i32 %v3432, ptr %NEXT_PC, align 4
  %v3433 = load ptr, ptr %MEMORY, align 4
  %v3434 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3433, ptr %state, ptr %NEXT_PC)
  store ptr %v3434, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205785:                                       ; No predecessors!
  %v3435 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3435, ptr %PC, align 4
  %v3436 = add i32 %v3435, 1
  store i32 %v3436, ptr %NEXT_PC, align 4
  %v3437 = load i32, ptr %EBP, align 4
  %v3438 = load ptr, ptr %MEMORY, align 4
  %v3439 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3438, ptr %state, i32 %v3437)
  store ptr %v3439, ptr %MEMORY, align 4
  store i32 %v3436, ptr %PC, align 4
  %v3440 = add i32 %v3436, 2
  store i32 %v3440, ptr %NEXT_PC, align 4
  %v3441 = load i32, ptr %ESP, align 4
  %v3442 = load ptr, ptr %MEMORY, align 4
  %v3443 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3442, ptr %state, ptr %EBP, i32 %v3441)
  store ptr %v3443, ptr %MEMORY, align 4
  store i32 %v3440, ptr %PC, align 4
  %v3444 = add i32 %v3440, 3
  store i32 %v3444, ptr %NEXT_PC, align 4
  %v3445 = load i32, ptr %ESP, align 4
  %v3446 = load ptr, ptr %MEMORY, align 4
  %v3447 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3446, ptr %state, ptr %ESP, i32 %v3445, i32 24)
  store ptr %v3447, ptr %MEMORY, align 4
  store i32 %v3444, ptr %PC, align 4
  %v3448 = add i32 %v3444, 3
  store i32 %v3448, ptr %NEXT_PC, align 4
  %v3449 = load i32, ptr %EBP, align 4
  %v3450 = load i32, ptr %SSBASE, align 4
  %v3451 = add i32 %v3449, 12
  %v3452 = add i32 %v3451, %v3450
  %v3453 = load ptr, ptr %MEMORY, align 4
  %v3454 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3453, ptr %state, ptr %EAX, i32 %v3452)
  store ptr %v3454, ptr %MEMORY, align 4
  store i32 %v3448, ptr %PC, align 4
  %v3455 = add i32 %v3448, 3
  store i32 %v3455, ptr %NEXT_PC, align 4
  %v3456 = load i32, ptr %EAX, align 4
  %v3457 = load ptr, ptr %MEMORY, align 4
  %v3458 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3457, ptr %state, i32 %v3456, i32 1)
  store ptr %v3458, ptr %MEMORY, align 4
  store i32 %v3455, ptr %PC, align 4
  %v3459 = add i32 %v3455, 2
  store i32 %v3459, ptr %NEXT_PC, align 4
  %v3460 = add i32 %v3459, 17
  %v3461 = load ptr, ptr %MEMORY, align 4
  %v3462 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3461, ptr %state, ptr %BRANCH_TAKEN, i32 %v3460, i32 %v3459, ptr %NEXT_PC)
  store ptr %v3462, ptr %MEMORY, align 4
  br i1 true, label %bb_4205816, label %bb_4205799

bb_4205799:                                       ; preds = %bb_4205785
  store i32 %v3459, ptr %PC, align 4
  %v3463 = add i32 %v3459, 3
  store i32 %v3463, ptr %NEXT_PC, align 4
  %v3464 = load i32, ptr %EAX, align 4
  %v3465 = load ptr, ptr %MEMORY, align 4
  %v3466 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3465, ptr %state, i32 %v3464, i32 1)
  store ptr %v3466, ptr %MEMORY, align 4
  store i32 %v3463, ptr %PC, align 4
  %v3467 = add i32 %v3463, 2
  store i32 %v3467, ptr %NEXT_PC, align 4
  %v3468 = add i32 %v3467, 50
  %v3469 = load ptr, ptr %MEMORY, align 4
  %v3470 = call ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3469, ptr %state, ptr %BRANCH_TAKEN, i32 %v3468, i32 %v3467, ptr %NEXT_PC)
  store ptr %v3470, ptr %MEMORY, align 4
  br i1 true, label %bb_4205854, label %bb_4205804

bb_4205804:                                       ; preds = %bb_4205799
  store i32 %v3467, ptr %PC, align 4
  %v3471 = add i32 %v3467, 3
  store i32 %v3471, ptr %NEXT_PC, align 4
  %v3472 = load i32, ptr %EAX, align 4
  %v3473 = load ptr, ptr %MEMORY, align 4
  %v3474 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3473, ptr %state, i32 %v3472, i32 2)
  store ptr %v3474, ptr %MEMORY, align 4
  store i32 %v3471, ptr %PC, align 4
  %v3475 = add i32 %v3471, 2
  store i32 %v3475, ptr %NEXT_PC, align 4
  %v3476 = add i32 %v3475, 96
  %v3477 = load ptr, ptr %MEMORY, align 4
  %v3478 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3477, ptr %state, ptr %BRANCH_TAKEN, i32 %v3476, i32 %v3475, ptr %NEXT_PC)
  store ptr %v3478, ptr %MEMORY, align 4
  br i1 true, label %bb_4205905, label %bb_4205809

bb_4205809:                                       ; preds = %bb_4205804
  store i32 %v3475, ptr %PC, align 4
  %v3479 = add i32 %v3475, 3
  store i32 %v3479, ptr %NEXT_PC, align 4
  %v3480 = load i32, ptr %EAX, align 4
  %v3481 = load ptr, ptr %MEMORY, align 4
  %v3482 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3481, ptr %state, i32 %v3480, i32 3)
  store ptr %v3482, ptr %MEMORY, align 4
  store i32 %v3479, ptr %PC, align 4
  %v3483 = add i32 %v3479, 2
  store i32 %v3483, ptr %NEXT_PC, align 4
  %v3484 = add i32 %v3483, 84
  %v3485 = load ptr, ptr %MEMORY, align 4
  %v3486 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3485, ptr %state, ptr %BRANCH_TAKEN, i32 %v3484, i32 %v3483, ptr %NEXT_PC)
  store ptr %v3486, ptr %MEMORY, align 4
  br i1 true, label %bb_4205898, label %bb_4205814

bb_4205814:                                       ; preds = %bb_4205809
  store i32 %v3483, ptr %PC, align 4
  %v3487 = add i32 %v3483, 2
  store i32 %v3487, ptr %NEXT_PC, align 4
  %v3488 = add i32 %v3487, 93
  %v3489 = load ptr, ptr %MEMORY, align 4
  %v3490 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3489, ptr %state, i32 %v3488, ptr %NEXT_PC)
  store ptr %v3490, ptr %MEMORY, align 4
  br label %bb_4205909

bb_4205816:                                       ; preds = %bb_4205785
  store i32 %v3459, ptr %PC, align 4
  %v3491 = add i32 %v3459, 5
  store i32 %v3491, ptr %NEXT_PC, align 4
  %v3492 = load i32, ptr %DSBASE, align 4
  %v3493 = add i32 4240332, %v3492
  %v3494 = load ptr, ptr %MEMORY, align 4
  %v3495 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3494, ptr %state, ptr %EAX, i32 %v3493)
  store ptr %v3495, ptr %MEMORY, align 4
  store i32 %v3491, ptr %PC, align 4
  %v3496 = add i32 %v3491, 2
  store i32 %v3496, ptr %NEXT_PC, align 4
  %v3497 = load i32, ptr %EAX, align 4
  %v3498 = load i32, ptr %EAX, align 4
  %v3499 = load ptr, ptr %MEMORY, align 4
  %v3500 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3499, ptr %state, i32 %v3497, i32 %v3498)
  store ptr %v3500, ptr %MEMORY, align 4
  store i32 %v3496, ptr %PC, align 4
  %v3501 = add i32 %v3496, 2
  store i32 %v3501, ptr %NEXT_PC, align 4
  %v3502 = add i32 %v3501, 17
  %v3503 = load ptr, ptr %MEMORY, align 4
  %v3504 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3503, ptr %state, ptr %BRANCH_TAKEN, i32 %v3502, i32 %v3501, ptr %NEXT_PC)
  store ptr %v3504, ptr %MEMORY, align 4
  br i1 true, label %bb_4205842, label %bb_4205825

bb_4205825:                                       ; preds = %bb_4205816
  store i32 %v3501, ptr %PC, align 4
  %v3505 = add i32 %v3501, 7
  store i32 %v3505, ptr %NEXT_PC, align 4
  %v3506 = load i32, ptr %ESP, align 4
  %v3507 = load i32, ptr %SSBASE, align 4
  %v3508 = add i32 %v3506, %v3507
  %v3509 = load ptr, ptr %MEMORY, align 4
  %v3510 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3509, ptr %state, i32 %v3508, i32 4240308)
  store ptr %v3510, ptr %MEMORY, align 4
  store i32 %v3505, ptr %PC, align 4
  %v3511 = add i32 %v3505, 5
  store i32 %v3511, ptr %NEXT_PC, align 4
  %v3512 = load i32, ptr %DSBASE, align 4
  %v3513 = add i32 4243832, %v3512
  %v3514 = load ptr, ptr %MEMORY, align 4
  %v3515 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3514, ptr %state, ptr %EAX, i32 %v3513)
  store ptr %v3515, ptr %MEMORY, align 4
  store i32 %v3511, ptr %PC, align 4
  %v3516 = add i32 %v3511, 2
  store i32 %v3516, ptr %NEXT_PC, align 4
  %v3517 = load i32, ptr %EAX, align 4
  %v3518 = load ptr, ptr %MEMORY, align 4
  %v3519 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3518, ptr %state, i32 %v3517, ptr %NEXT_PC, i32 %v3516, ptr %RETURN_PC)
  store ptr %v3519, ptr %MEMORY, align 4
  store i32 %v3516, ptr %PC, align 4
  %v3520 = add i32 %v3516, 3
  store i32 %v3520, ptr %NEXT_PC, align 4
  %v3521 = load i32, ptr %ESP, align 4
  %v3522 = load ptr, ptr %MEMORY, align 4
  %v3523 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3522, ptr %state, ptr %ESP, i32 %v3521, i32 4)
  store ptr %v3523, ptr %MEMORY, align 4
  br label %bb_4205842

bb_4205842:                                       ; preds = %bb_4205825, %bb_4205816
  %v3524 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3524, ptr %PC, align 4
  %v3525 = add i32 %v3524, 10
  store i32 %v3525, ptr %NEXT_PC, align 4
  %v3526 = load i32, ptr %DSBASE, align 4
  %v3527 = add i32 4240332, %v3526
  %v3528 = load ptr, ptr %MEMORY, align 4
  %v3529 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3528, ptr %state, i32 %v3527, i32 1)
  store ptr %v3529, ptr %MEMORY, align 4
  store i32 %v3525, ptr %PC, align 4
  %v3530 = add i32 %v3525, 2
  store i32 %v3530, ptr %NEXT_PC, align 4
  %v3531 = add i32 %v3530, 55
  %v3532 = load ptr, ptr %MEMORY, align 4
  %v3533 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3532, ptr %state, i32 %v3531, ptr %NEXT_PC)
  store ptr %v3533, ptr %MEMORY, align 4
  br label %bb_4205909

bb_4205854:                                       ; preds = %bb_4205799
  store i32 %v3467, ptr %PC, align 4
  %v3534 = add i32 %v3467, 5
  store i32 %v3534, ptr %NEXT_PC, align 4
  %v3535 = sub i32 %v3534, 205
  %v3536 = load ptr, ptr %MEMORY, align 4
  %v3537 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3536, ptr %state, i64 4205654, ptr %NEXT_PC, i32 %v3534, ptr %RETURN_PC)
  store ptr %v3537, ptr %MEMORY, align 4
  store i32 %v3534, ptr %PC, align 4
  %v3538 = add i32 %v3534, 5
  store i32 %v3538, ptr %NEXT_PC, align 4
  %v3539 = load i32, ptr %DSBASE, align 4
  %v3540 = add i32 4240332, %v3539
  %v3541 = load ptr, ptr %MEMORY, align 4
  %v3542 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3541, ptr %state, ptr %EAX, i32 %v3540)
  store ptr %v3542, ptr %MEMORY, align 4
  store i32 %v3538, ptr %PC, align 4
  %v3543 = add i32 %v3538, 3
  store i32 %v3543, ptr %NEXT_PC, align 4
  %v3544 = load i32, ptr %EAX, align 4
  %v3545 = load ptr, ptr %MEMORY, align 4
  %v3546 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3545, ptr %state, i32 %v3544, i32 1)
  store ptr %v3546, ptr %MEMORY, align 4
  store i32 %v3543, ptr %PC, align 4
  %v3547 = add i32 %v3543, 2
  store i32 %v3547, ptr %NEXT_PC, align 4
  %v3548 = add i32 %v3547, 39
  %v3549 = load ptr, ptr %MEMORY, align 4
  %v3550 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3549, ptr %state, ptr %BRANCH_TAKEN, i32 %v3548, i32 %v3547, ptr %NEXT_PC)
  store ptr %v3550, ptr %MEMORY, align 4
  br i1 true, label %bb_4205908, label %bb_4205869

bb_4205869:                                       ; preds = %bb_4205854
  store i32 %v3547, ptr %PC, align 4
  %v3551 = add i32 %v3547, 10
  store i32 %v3551, ptr %NEXT_PC, align 4
  %v3552 = load i32, ptr %DSBASE, align 4
  %v3553 = add i32 4240332, %v3552
  %v3554 = load ptr, ptr %MEMORY, align 4
  %v3555 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3554, ptr %state, i32 %v3553, i32 0)
  store ptr %v3555, ptr %MEMORY, align 4
  store i32 %v3551, ptr %PC, align 4
  %v3556 = add i32 %v3551, 7
  store i32 %v3556, ptr %NEXT_PC, align 4
  %v3557 = load i32, ptr %ESP, align 4
  %v3558 = load i32, ptr %SSBASE, align 4
  %v3559 = add i32 %v3557, %v3558
  %v3560 = load ptr, ptr %MEMORY, align 4
  %v3561 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3560, ptr %state, i32 %v3559, i32 4240308)
  store ptr %v3561, ptr %MEMORY, align 4
  store i32 %v3556, ptr %PC, align 4
  %v3562 = add i32 %v3556, 5
  store i32 %v3562, ptr %NEXT_PC, align 4
  %v3563 = load i32, ptr %DSBASE, align 4
  %v3564 = add i32 4243784, %v3563
  %v3565 = load ptr, ptr %MEMORY, align 4
  %v3566 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3565, ptr %state, ptr %EAX, i32 %v3564)
  store ptr %v3566, ptr %MEMORY, align 4
  store i32 %v3562, ptr %PC, align 4
  %v3567 = add i32 %v3562, 2
  store i32 %v3567, ptr %NEXT_PC, align 4
  %v3568 = load i32, ptr %EAX, align 4
  %v3569 = load ptr, ptr %MEMORY, align 4
  %v3570 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3569, ptr %state, i32 %v3568, ptr %NEXT_PC, i32 %v3567, ptr %RETURN_PC)
  store ptr %v3570, ptr %MEMORY, align 4
  store i32 %v3567, ptr %PC, align 4
  %v3571 = add i32 %v3567, 3
  store i32 %v3571, ptr %NEXT_PC, align 4
  %v3572 = load i32, ptr %ESP, align 4
  %v3573 = load ptr, ptr %MEMORY, align 4
  %v3574 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3573, ptr %state, ptr %ESP, i32 %v3572, i32 4)
  store ptr %v3574, ptr %MEMORY, align 4
  store i32 %v3571, ptr %PC, align 4
  %v3575 = add i32 %v3571, 2
  store i32 %v3575, ptr %NEXT_PC, align 4
  %v3576 = add i32 %v3575, 10
  %v3577 = load ptr, ptr %MEMORY, align 4
  %v3578 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3577, ptr %state, i32 %v3576, ptr %NEXT_PC)
  store ptr %v3578, ptr %MEMORY, align 4
  br label %bb_4205908

bb_4205898:                                       ; preds = %bb_4205809
  store i32 %v3483, ptr %PC, align 4
  %v3579 = add i32 %v3483, 5
  store i32 %v3579, ptr %NEXT_PC, align 4
  %v3580 = sub i32 %v3579, 249
  %v3581 = load ptr, ptr %MEMORY, align 4
  %v3582 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3581, ptr %state, i64 4205654, ptr %NEXT_PC, i32 %v3579, ptr %RETURN_PC)
  store ptr %v3582, ptr %MEMORY, align 4
  store i32 %v3579, ptr %PC, align 4
  %v3583 = add i32 %v3579, 2
  store i32 %v3583, ptr %NEXT_PC, align 4
  %v3584 = add i32 %v3583, 4
  %v3585 = load ptr, ptr %MEMORY, align 4
  %v3586 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3585, ptr %state, i32 %v3584, ptr %NEXT_PC)
  store ptr %v3586, ptr %MEMORY, align 4
  br label %bb_4205909

bb_4205905:                                       ; preds = %bb_4205804
  store i32 %v3475, ptr %PC, align 4
  %v3587 = add i32 %v3475, 1
  store i32 %v3587, ptr %NEXT_PC, align 4
  %v3588 = load ptr, ptr %MEMORY, align 4
  %v3589 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3588, ptr %state)
  store ptr %v3589, ptr %MEMORY, align 4
  store i32 %v3587, ptr %PC, align 4
  %v3590 = add i32 %v3587, 2
  store i32 %v3590, ptr %NEXT_PC, align 4
  %v3591 = add i32 %v3590, 1
  %v3592 = load ptr, ptr %MEMORY, align 4
  %v3593 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3592, ptr %state, i32 %v3591, ptr %NEXT_PC)
  store ptr %v3593, ptr %MEMORY, align 4
  br label %bb_4205909

bb_4205908:                                       ; preds = %bb_4205869, %bb_4205854
  %v3594 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3594, ptr %PC, align 4
  %v3595 = add i32 %v3594, 1
  store i32 %v3595, ptr %NEXT_PC, align 4
  %v3596 = load ptr, ptr %MEMORY, align 4
  %v3597 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3596, ptr %state)
  store ptr %v3597, ptr %MEMORY, align 4
  br label %bb_4205909

bb_4205909:                                       ; preds = %bb_4205908, %bb_4205905, %bb_4205898, %bb_4205842, %bb_4205814
  %v3598 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3598, ptr %PC, align 4
  %v3599 = add i32 %v3598, 5
  store i32 %v3599, ptr %NEXT_PC, align 4
  %v3600 = load ptr, ptr %MEMORY, align 4
  %v3601 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3600, ptr %state, ptr %EAX, i32 1)
  store ptr %v3601, ptr %MEMORY, align 4
  store i32 %v3599, ptr %PC, align 4
  %v3602 = add i32 %v3599, 1
  store i32 %v3602, ptr %NEXT_PC, align 4
  %v3603 = load ptr, ptr %MEMORY, align 4
  %v3604 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v3603, ptr %state)
  store ptr %v3604, ptr %MEMORY, align 4
  store i32 %v3602, ptr %PC, align 4
  %v3605 = add i32 %v3602, 1
  store i32 %v3605, ptr %NEXT_PC, align 4
  %v3606 = load ptr, ptr %MEMORY, align 4
  %v3607 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3606, ptr %state, ptr %NEXT_PC)
  store ptr %v3607, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205916:                                       ; No predecessors!
  %v3608 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3608, ptr %PC, align 4
  %v3609 = add i32 %v3608, 1
  store i32 %v3609, ptr %NEXT_PC, align 4
  %v3610 = load i32, ptr %ECX, align 4
  %v3611 = load ptr, ptr %MEMORY, align 4
  %v3612 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3611, ptr %state, i32 %v3610)
  store ptr %v3612, ptr %MEMORY, align 4
  store i32 %v3609, ptr %PC, align 4
  %v3613 = add i32 %v3609, 1
  store i32 %v3613, ptr %NEXT_PC, align 4
  %v3614 = load i32, ptr %EAX, align 4
  %v3615 = load ptr, ptr %MEMORY, align 4
  %v3616 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3615, ptr %state, i32 %v3614)
  store ptr %v3616, ptr %MEMORY, align 4
  store i32 %v3613, ptr %PC, align 4
  %v3617 = add i32 %v3613, 5
  store i32 %v3617, ptr %NEXT_PC, align 4
  %v3618 = load i32, ptr %EAX, align 4
  %v3619 = load ptr, ptr %MEMORY, align 4
  %v3620 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3619, ptr %state, i32 %v3618, i32 4096)
  store ptr %v3620, ptr %MEMORY, align 4
  store i32 %v3617, ptr %PC, align 4
  %v3621 = add i32 %v3617, 4
  store i32 %v3621, ptr %NEXT_PC, align 4
  %v3622 = load i32, ptr %ESP, align 4
  %v3623 = add i32 %v3622, 12
  %v3624 = load ptr, ptr %MEMORY, align 4
  %v3625 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3624, ptr %state, ptr %ECX, i32 %v3623)
  store ptr %v3625, ptr %MEMORY, align 4
  store i32 %v3621, ptr %PC, align 4
  %v3626 = add i32 %v3621, 2
  store i32 %v3626, ptr %NEXT_PC, align 4
  %v3627 = add i32 %v3626, 21
  %v3628 = load ptr, ptr %MEMORY, align 4
  %v3629 = call ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3628, ptr %state, ptr %BRANCH_TAKEN, i32 %v3627, i32 %v3626, ptr %NEXT_PC)
  store ptr %v3629, ptr %MEMORY, align 4
  br i1 true, label %bb_4205950, label %bb_4205929

bb_4205929:                                       ; preds = %bb_4205929, %bb_4205916
  %v3630 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3630, ptr %PC, align 4
  %v3631 = add i32 %v3630, 6
  store i32 %v3631, ptr %NEXT_PC, align 4
  %v3632 = load i32, ptr %ECX, align 4
  %v3633 = load ptr, ptr %MEMORY, align 4
  %v3634 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3633, ptr %state, ptr %ECX, i32 %v3632, i32 4096)
  store ptr %v3634, ptr %MEMORY, align 4
  store i32 %v3631, ptr %PC, align 4
  %v3635 = add i32 %v3631, 3
  store i32 %v3635, ptr %NEXT_PC, align 4
  %v3636 = load i32, ptr %ECX, align 4
  %v3637 = load i32, ptr %DSBASE, align 4
  %v3638 = add i32 %v3636, %v3637
  %v3639 = load i32, ptr %ECX, align 4
  %v3640 = load i32, ptr %DSBASE, align 4
  %v3641 = add i32 %v3639, %v3640
  %v3642 = load ptr, ptr %MEMORY, align 4
  %v3643 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3642, ptr %state, i32 %v3638, i32 %v3641, i32 0)
  store ptr %v3643, ptr %MEMORY, align 4
  store i32 %v3635, ptr %PC, align 4
  %v3644 = add i32 %v3635, 5
  store i32 %v3644, ptr %NEXT_PC, align 4
  %v3645 = load i32, ptr %EAX, align 4
  %v3646 = load ptr, ptr %MEMORY, align 4
  %v3647 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3646, ptr %state, ptr %EAX, i32 %v3645, i32 4096)
  store ptr %v3647, ptr %MEMORY, align 4
  store i32 %v3644, ptr %PC, align 4
  %v3648 = add i32 %v3644, 5
  store i32 %v3648, ptr %NEXT_PC, align 4
  %v3649 = load i32, ptr %EAX, align 4
  %v3650 = load ptr, ptr %MEMORY, align 4
  %v3651 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3650, ptr %state, i32 %v3649, i32 4096)
  store ptr %v3651, ptr %MEMORY, align 4
  store i32 %v3648, ptr %PC, align 4
  %v3652 = add i32 %v3648, 2
  store i32 %v3652, ptr %NEXT_PC, align 4
  %v3653 = sub i32 %v3652, 21
  %v3654 = load ptr, ptr %MEMORY, align 4
  %v3655 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3654, ptr %state, ptr %BRANCH_TAKEN, i32 %v3653, i32 %v3652, ptr %NEXT_PC)
  store ptr %v3655, ptr %MEMORY, align 4
  br i1 true, label %bb_4205929, label %bb_4205950

bb_4205950:                                       ; preds = %bb_4205929, %bb_4205916
  %v3656 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3656, ptr %PC, align 4
  %v3657 = add i32 %v3656, 2
  store i32 %v3657, ptr %NEXT_PC, align 4
  %v3658 = load i32, ptr %ECX, align 4
  %v3659 = load i32, ptr %EAX, align 4
  %v3660 = load ptr, ptr %MEMORY, align 4
  %v3661 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3660, ptr %state, ptr %ECX, i32 %v3658, i32 %v3659)
  store ptr %v3661, ptr %MEMORY, align 4
  store i32 %v3657, ptr %PC, align 4
  %v3662 = add i32 %v3657, 3
  store i32 %v3662, ptr %NEXT_PC, align 4
  %v3663 = load i32, ptr %ECX, align 4
  %v3664 = load i32, ptr %DSBASE, align 4
  %v3665 = add i32 %v3663, %v3664
  %v3666 = load i32, ptr %ECX, align 4
  %v3667 = load i32, ptr %DSBASE, align 4
  %v3668 = add i32 %v3666, %v3667
  %v3669 = load ptr, ptr %MEMORY, align 4
  %v3670 = call ptr @_ZN12_GLOBAL__N_12ORI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3669, ptr %state, i32 %v3665, i32 %v3668, i32 0)
  store ptr %v3670, ptr %MEMORY, align 4
  store i32 %v3662, ptr %PC, align 4
  %v3671 = add i32 %v3662, 1
  store i32 %v3671, ptr %NEXT_PC, align 4
  %v3672 = load ptr, ptr %MEMORY, align 4
  %v3673 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v3672, ptr %state, ptr %EAX)
  store ptr %v3673, ptr %MEMORY, align 4
  store i32 %v3671, ptr %PC, align 4
  %v3674 = add i32 %v3671, 1
  store i32 %v3674, ptr %NEXT_PC, align 4
  %v3675 = load ptr, ptr %MEMORY, align 4
  %v3676 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v3675, ptr %state, ptr %ECX)
  store ptr %v3676, ptr %MEMORY, align 4
  store i32 %v3674, ptr %PC, align 4
  %v3677 = add i32 %v3674, 1
  store i32 %v3677, ptr %NEXT_PC, align 4
  %v3678 = load ptr, ptr %MEMORY, align 4
  %v3679 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3678, ptr %state, ptr %NEXT_PC)
  store ptr %v3679, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205958:                                       ; No predecessors!
  %v3680 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3680, ptr %PC, align 4
  %v3681 = add i32 %v3680, 1
  store i32 %v3681, ptr %NEXT_PC, align 4
  %v3682 = load ptr, ptr %MEMORY, align 4
  %v3683 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3682, ptr %state)
  store ptr %v3683, ptr %MEMORY, align 4
  store i32 %v3681, ptr %PC, align 4
  %v3684 = add i32 %v3681, 1
  store i32 %v3684, ptr %NEXT_PC, align 4
  %v3685 = load ptr, ptr %MEMORY, align 4
  %v3686 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3685, ptr %state)
  store ptr %v3686, ptr %MEMORY, align 4
  store i32 %v3684, ptr %PC, align 4
  %v3687 = add i32 %v3684, 1
  store i32 %v3687, ptr %NEXT_PC, align 4
  %v3688 = load i32, ptr %EBP, align 4
  %v3689 = load ptr, ptr %MEMORY, align 4
  %v3690 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3689, ptr %state, i32 %v3688)
  store ptr %v3690, ptr %MEMORY, align 4
  store i32 %v3687, ptr %PC, align 4
  %v3691 = add i32 %v3687, 2
  store i32 %v3691, ptr %NEXT_PC, align 4
  %v3692 = load i32, ptr %ESP, align 4
  %v3693 = load ptr, ptr %MEMORY, align 4
  %v3694 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3693, ptr %state, ptr %EBP, i32 %v3692)
  store ptr %v3694, ptr %MEMORY, align 4
  store i32 %v3691, ptr %PC, align 4
  %v3695 = add i32 %v3691, 1
  store i32 %v3695, ptr %NEXT_PC, align 4
  %v3696 = load i32, ptr %EBX, align 4
  %v3697 = load ptr, ptr %MEMORY, align 4
  %v3698 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3697, ptr %state, i32 %v3696)
  store ptr %v3698, ptr %MEMORY, align 4
  store i32 %v3695, ptr %PC, align 4
  %v3699 = add i32 %v3695, 3
  store i32 %v3699, ptr %NEXT_PC, align 4
  %v3700 = load i32, ptr %ESP, align 4
  %v3701 = load ptr, ptr %MEMORY, align 4
  %v3702 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3701, ptr %state, ptr %ESP, i32 %v3700, i32 16)
  store ptr %v3702, ptr %MEMORY, align 4
  store i32 %v3699, ptr %PC, align 4
  %v3703 = add i32 %v3699, 7
  store i32 %v3703, ptr %NEXT_PC, align 4
  %v3704 = load i32, ptr %FSBASE, align 4
  %v3705 = add i32 24, %v3704
  %v3706 = load ptr, ptr %MEMORY, align 4
  %v3707 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3706, ptr %state, ptr %EBX, i32 %v3705)
  store ptr %v3707, ptr %MEMORY, align 4
  store i32 %v3703, ptr %PC, align 4
  %v3708 = add i32 %v3703, 3
  store i32 %v3708, ptr %NEXT_PC, align 4
  %v3709 = load i32, ptr %EBP, align 4
  %v3710 = load i32, ptr %SSBASE, align 4
  %v3711 = sub i32 %v3709, 8
  %v3712 = add i32 %v3711, %v3710
  %v3713 = load i32, ptr %EBX, align 4
  %v3714 = load ptr, ptr %MEMORY, align 4
  %v3715 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3714, ptr %state, i32 %v3712, i32 %v3713)
  store ptr %v3715, ptr %MEMORY, align 4
  store i32 %v3708, ptr %PC, align 4
  %v3716 = add i32 %v3708, 3
  store i32 %v3716, ptr %NEXT_PC, align 4
  %v3717 = load i32, ptr %EBP, align 4
  %v3718 = load i32, ptr %SSBASE, align 4
  %v3719 = sub i32 %v3717, 8
  %v3720 = add i32 %v3719, %v3718
  %v3721 = load ptr, ptr %MEMORY, align 4
  %v3722 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3721, ptr %state, ptr %EAX, i32 %v3720)
  store ptr %v3722, ptr %MEMORY, align 4
  store i32 %v3716, ptr %PC, align 4
  %v3723 = add i32 %v3716, 3
  store i32 %v3723, ptr %NEXT_PC, align 4
  %v3724 = load i32, ptr %ESP, align 4
  %v3725 = load ptr, ptr %MEMORY, align 4
  %v3726 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3725, ptr %state, ptr %ESP, i32 %v3724, i32 16)
  store ptr %v3726, ptr %MEMORY, align 4
  store i32 %v3723, ptr %PC, align 4
  %v3727 = add i32 %v3723, 1
  store i32 %v3727, ptr %NEXT_PC, align 4
  %v3728 = load ptr, ptr %MEMORY, align 4
  %v3729 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v3728, ptr %state, ptr %EBX)
  store ptr %v3729, ptr %MEMORY, align 4
  store i32 %v3727, ptr %PC, align 4
  %v3730 = add i32 %v3727, 1
  store i32 %v3730, ptr %NEXT_PC, align 4
  %v3731 = load ptr, ptr %MEMORY, align 4
  %v3732 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v3731, ptr %state, ptr %EBP)
  store ptr %v3732, ptr %MEMORY, align 4
  store i32 %v3730, ptr %PC, align 4
  %v3733 = add i32 %v3730, 1
  store i32 %v3733, ptr %NEXT_PC, align 4
  %v3734 = load ptr, ptr %MEMORY, align 4
  %v3735 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3734, ptr %state, ptr %NEXT_PC)
  store ptr %v3735, ptr %MEMORY, align 4
  ret ptr %memory

bb_4205986:                                       ; No predecessors!
  %v3736 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3736, ptr %PC, align 4
  %v3737 = add i32 %v3736, 1
  store i32 %v3737, ptr %NEXT_PC, align 4
  %v3738 = load ptr, ptr %MEMORY, align 4
  %v3739 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3738, ptr %state)
  store ptr %v3739, ptr %MEMORY, align 4
  store i32 %v3737, ptr %PC, align 4
  %v3740 = add i32 %v3737, 1
  store i32 %v3740, ptr %NEXT_PC, align 4
  %v3741 = load ptr, ptr %MEMORY, align 4
  %v3742 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3741, ptr %state)
  store ptr %v3742, ptr %MEMORY, align 4
  store i32 %v3740, ptr %PC, align 4
  %v3743 = add i32 %v3740, 1
  store i32 %v3743, ptr %NEXT_PC, align 4
  %v3744 = load i32, ptr %EBP, align 4
  %v3745 = load ptr, ptr %MEMORY, align 4
  %v3746 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3745, ptr %state, i32 %v3744)
  store ptr %v3746, ptr %MEMORY, align 4
  store i32 %v3743, ptr %PC, align 4
  %v3747 = add i32 %v3743, 2
  store i32 %v3747, ptr %NEXT_PC, align 4
  %v3748 = load i32, ptr %ESP, align 4
  %v3749 = load ptr, ptr %MEMORY, align 4
  %v3750 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3749, ptr %state, ptr %EBP, i32 %v3748)
  store ptr %v3750, ptr %MEMORY, align 4
  store i32 %v3747, ptr %PC, align 4
  %v3751 = add i32 %v3747, 1
  store i32 %v3751, ptr %NEXT_PC, align 4
  %v3752 = load i32, ptr %EBX, align 4
  %v3753 = load ptr, ptr %MEMORY, align 4
  %v3754 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3753, ptr %state, i32 %v3752)
  store ptr %v3754, ptr %MEMORY, align 4
  store i32 %v3751, ptr %PC, align 4
  %v3755 = add i32 %v3751, 3
  store i32 %v3755, ptr %NEXT_PC, align 4
  %v3756 = load i32, ptr %ESP, align 4
  %v3757 = load ptr, ptr %MEMORY, align 4
  %v3758 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3757, ptr %state, ptr %ESP, i32 %v3756, i32 16)
  store ptr %v3758, ptr %MEMORY, align 4
  store i32 %v3755, ptr %PC, align 4
  %v3759 = add i32 %v3755, 3
  store i32 %v3759, ptr %NEXT_PC, align 4
  %v3760 = load i32, ptr %EBP, align 4
  %v3761 = load i32, ptr %SSBASE, align 4
  %v3762 = add i32 %v3760, 12
  %v3763 = add i32 %v3762, %v3761
  %v3764 = load ptr, ptr %MEMORY, align 4
  %v3765 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3764, ptr %state, ptr %EDX, i32 %v3763)
  store ptr %v3765, ptr %MEMORY, align 4
  store i32 %v3759, ptr %PC, align 4
  %v3766 = add i32 %v3759, 3
  store i32 %v3766, ptr %NEXT_PC, align 4
  %v3767 = load i32, ptr %EBP, align 4
  %v3768 = load i32, ptr %SSBASE, align 4
  %v3769 = add i32 %v3767, 8
  %v3770 = add i32 %v3769, %v3768
  %v3771 = load ptr, ptr %MEMORY, align 4
  %v3772 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3771, ptr %state, ptr %ECX, i32 %v3770)
  store ptr %v3772, ptr %MEMORY, align 4
  store i32 %v3766, ptr %PC, align 4
  %v3773 = add i32 %v3766, 3
  store i32 %v3773, ptr %NEXT_PC, align 4
  %v3774 = load i32, ptr %EBP, align 4
  %v3775 = load i32, ptr %SSBASE, align 4
  %v3776 = add i32 %v3774, 16
  %v3777 = add i32 %v3776, %v3775
  %v3778 = load ptr, ptr %MEMORY, align 4
  %v3779 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3778, ptr %state, ptr %EAX, i32 %v3777)
  store ptr %v3779, ptr %MEMORY, align 4
  store i32 %v3773, ptr %PC, align 4
  %v3780 = add i32 %v3773, 2
  store i32 %v3780, ptr %NEXT_PC, align 4
  %v3781 = load i32, ptr %EAX, align 4
  %v3782 = load ptr, ptr %MEMORY, align 4
  %v3783 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3782, ptr %state, ptr %EBX, i32 %v3781)
  store ptr %v3783, ptr %MEMORY, align 4
  store i32 %v3780, ptr %PC, align 4
  %v3784 = add i32 %v3780, 2
  store i32 %v3784, ptr %NEXT_PC, align 4
  %v3785 = load i32, ptr %EBX, align 4
  %v3786 = load ptr, ptr %MEMORY, align 4
  %v3787 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3786, ptr %state, ptr %EAX, i32 %v3785)
  store ptr %v3787, ptr %MEMORY, align 4
  store i32 %v3784, ptr %PC, align 4
  %v3788 = add i32 %v3784, 4
  store i32 %v3788, ptr %NEXT_PC, align 4
  %v3789 = load ptr, ptr %MEMORY, align 4
  %v3790 = call ptr @__remill_atomic_begin(ptr %v3789)
  store ptr %v3790, ptr %MEMORY, align 4
  %v3791 = load i32, ptr %ECX, align 4
  %v3792 = load i32, ptr %DSBASE, align 4
  %v3793 = add i32 %v3791, %v3792
  %v3794 = load i32, ptr %ECX, align 4
  %v3795 = load i32, ptr %DSBASE, align 4
  %v3796 = add i32 %v3794, %v3795
  %v3797 = load i32, ptr %EDX, align 4
  %v3798 = load ptr, ptr %MEMORY, align 4
  %v3799 = call ptr @_ZN12_GLOBAL__N_111CMPXCHG_EAXI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3798, ptr %state, i32 %v3793, i32 %v3796, i32 %v3797)
  store ptr %v3799, ptr %MEMORY, align 4
  %v3800 = load ptr, ptr %MEMORY, align 4
  %v3801 = call ptr @__remill_atomic_end(ptr %v3800)
  store ptr %v3801, ptr %MEMORY, align 4
  store i32 %v3788, ptr %PC, align 4
  %v3802 = add i32 %v3788, 2
  store i32 %v3802, ptr %NEXT_PC, align 4
  %v3803 = load ptr, ptr %MEMORY, align 4
  %v3804 = call ptr @__remill_atomic_begin(ptr %v3803)
  store ptr %v3804, ptr %MEMORY, align 4
  %v3805 = load i32, ptr %EAX, align 4
  %v3806 = load ptr, ptr %MEMORY, align 4
  %v3807 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3806, ptr %state, ptr %EBX, i32 %v3805)
  store ptr %v3807, ptr %MEMORY, align 4
  %v3808 = load ptr, ptr %MEMORY, align 4
  %v3809 = call ptr @__remill_atomic_end(ptr %v3808)
  store ptr %v3809, ptr %MEMORY, align 4
  store i32 %v3802, ptr %PC, align 4
  %v3810 = add i32 %v3802, 3
  store i32 %v3810, ptr %NEXT_PC, align 4
  %v3811 = load ptr, ptr %MEMORY, align 4
  %v3812 = call ptr @__remill_atomic_begin(ptr %v3811)
  store ptr %v3812, ptr %MEMORY, align 4
  %v3813 = load i32, ptr %EBP, align 4
  %v3814 = load i32, ptr %SSBASE, align 4
  %v3815 = sub i32 %v3813, 8
  %v3816 = add i32 %v3815, %v3814
  %v3817 = load i32, ptr %EBX, align 4
  %v3818 = load ptr, ptr %MEMORY, align 4
  %v3819 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3818, ptr %state, i32 %v3816, i32 %v3817)
  store ptr %v3819, ptr %MEMORY, align 4
  %v3820 = load ptr, ptr %MEMORY, align 4
  %v3821 = call ptr @__remill_atomic_end(ptr %v3820)
  store ptr %v3821, ptr %MEMORY, align 4
  store i32 %v3810, ptr %PC, align 4
  %v3822 = add i32 %v3810, 3
  store i32 %v3822, ptr %NEXT_PC, align 4
  %v3823 = load ptr, ptr %MEMORY, align 4
  %v3824 = call ptr @__remill_atomic_begin(ptr %v3823)
  store ptr %v3824, ptr %MEMORY, align 4
  %v3825 = load i32, ptr %EBP, align 4
  %v3826 = load i32, ptr %SSBASE, align 4
  %v3827 = sub i32 %v3825, 8
  %v3828 = add i32 %v3827, %v3826
  %v3829 = load ptr, ptr %MEMORY, align 4
  %v3830 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3829, ptr %state, ptr %EAX, i32 %v3828)
  store ptr %v3830, ptr %MEMORY, align 4
  %v3831 = load ptr, ptr %MEMORY, align 4
  %v3832 = call ptr @__remill_atomic_end(ptr %v3831)
  store ptr %v3832, ptr %MEMORY, align 4
  store i32 %v3822, ptr %PC, align 4
  %v3833 = add i32 %v3822, 3
  store i32 %v3833, ptr %NEXT_PC, align 4
  %v3834 = load ptr, ptr %MEMORY, align 4
  %v3835 = call ptr @__remill_atomic_begin(ptr %v3834)
  store ptr %v3835, ptr %MEMORY, align 4
  %v3836 = load i32, ptr %ESP, align 4
  %v3837 = load ptr, ptr %MEMORY, align 4
  %v3838 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3837, ptr %state, ptr %ESP, i32 %v3836, i32 16)
  store ptr %v3838, ptr %MEMORY, align 4
  %v3839 = load ptr, ptr %MEMORY, align 4
  %v3840 = call ptr @__remill_atomic_end(ptr %v3839)
  store ptr %v3840, ptr %MEMORY, align 4
  store i32 %v3833, ptr %PC, align 4
  %v3841 = add i32 %v3833, 1
  store i32 %v3841, ptr %NEXT_PC, align 4
  %v3842 = load ptr, ptr %MEMORY, align 4
  %v3843 = call ptr @__remill_atomic_begin(ptr %v3842)
  store ptr %v3843, ptr %MEMORY, align 4
  %v3844 = load ptr, ptr %MEMORY, align 4
  %v3845 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v3844, ptr %state, ptr %EBX)
  store ptr %v3845, ptr %MEMORY, align 4
  %v3846 = load ptr, ptr %MEMORY, align 4
  %v3847 = call ptr @__remill_atomic_end(ptr %v3846)
  store ptr %v3847, ptr %MEMORY, align 4
  store i32 %v3841, ptr %PC, align 4
  %v3848 = add i32 %v3841, 1
  store i32 %v3848, ptr %NEXT_PC, align 4
  %v3849 = load ptr, ptr %MEMORY, align 4
  %v3850 = call ptr @__remill_atomic_begin(ptr %v3849)
  store ptr %v3850, ptr %MEMORY, align 4
  %v3851 = load ptr, ptr %MEMORY, align 4
  %v3852 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v3851, ptr %state, ptr %EBP)
  store ptr %v3852, ptr %MEMORY, align 4
  %v3853 = load ptr, ptr %MEMORY, align 4
  %v3854 = call ptr @__remill_atomic_end(ptr %v3853)
  store ptr %v3854, ptr %MEMORY, align 4
  store i32 %v3848, ptr %PC, align 4
  %v3855 = add i32 %v3848, 1
  store i32 %v3855, ptr %NEXT_PC, align 4
  %v3856 = load ptr, ptr %MEMORY, align 4
  %v3857 = call ptr @__remill_atomic_begin(ptr %v3856)
  store ptr %v3857, ptr %MEMORY, align 4
  %v3858 = load ptr, ptr %MEMORY, align 4
  %v3859 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3858, ptr %state, ptr %NEXT_PC)
  store ptr %v3859, ptr %MEMORY, align 4
  %v3860 = load ptr, ptr %MEMORY, align 4
  %v3861 = call ptr @__remill_atomic_end(ptr %v3860)
  store ptr %v3861, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206026:                                       ; No predecessors!
  %v3862 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3862, ptr %PC, align 4
  %v3863 = add i32 %v3862, 1
  store i32 %v3863, ptr %NEXT_PC, align 4
  %v3864 = load ptr, ptr %MEMORY, align 4
  %v3865 = call ptr @__remill_atomic_begin(ptr %v3864)
  store ptr %v3865, ptr %MEMORY, align 4
  %v3866 = load i32, ptr %EBP, align 4
  %v3867 = load ptr, ptr %MEMORY, align 4
  %v3868 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3867, ptr %state, i32 %v3866)
  store ptr %v3868, ptr %MEMORY, align 4
  %v3869 = load ptr, ptr %MEMORY, align 4
  %v3870 = call ptr @__remill_atomic_end(ptr %v3869)
  store ptr %v3870, ptr %MEMORY, align 4
  store i32 %v3863, ptr %PC, align 4
  %v3871 = add i32 %v3863, 2
  store i32 %v3871, ptr %NEXT_PC, align 4
  %v3872 = load ptr, ptr %MEMORY, align 4
  %v3873 = call ptr @__remill_atomic_begin(ptr %v3872)
  store ptr %v3873, ptr %MEMORY, align 4
  %v3874 = load i32, ptr %ESP, align 4
  %v3875 = load ptr, ptr %MEMORY, align 4
  %v3876 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3875, ptr %state, ptr %EBP, i32 %v3874)
  store ptr %v3876, ptr %MEMORY, align 4
  %v3877 = load ptr, ptr %MEMORY, align 4
  %v3878 = call ptr @__remill_atomic_end(ptr %v3877)
  store ptr %v3878, ptr %MEMORY, align 4
  store i32 %v3871, ptr %PC, align 4
  %v3879 = add i32 %v3871, 3
  store i32 %v3879, ptr %NEXT_PC, align 4
  %v3880 = load ptr, ptr %MEMORY, align 4
  %v3881 = call ptr @__remill_atomic_begin(ptr %v3880)
  store ptr %v3881, ptr %MEMORY, align 4
  %v3882 = load i32, ptr %ESP, align 4
  %v3883 = load ptr, ptr %MEMORY, align 4
  %v3884 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3883, ptr %state, ptr %ESP, i32 %v3882, i32 12)
  store ptr %v3884, ptr %MEMORY, align 4
  %v3885 = load ptr, ptr %MEMORY, align 4
  %v3886 = call ptr @__remill_atomic_end(ptr %v3885)
  store ptr %v3886, ptr %MEMORY, align 4
  store i32 %v3879, ptr %PC, align 4
  %v3887 = add i32 %v3879, 3
  store i32 %v3887, ptr %NEXT_PC, align 4
  %v3888 = load ptr, ptr %MEMORY, align 4
  %v3889 = call ptr @__remill_atomic_begin(ptr %v3888)
  store ptr %v3889, ptr %MEMORY, align 4
  %v3890 = load i32, ptr %EBP, align 4
  %v3891 = load i32, ptr %SSBASE, align 4
  %v3892 = add i32 %v3890, 16
  %v3893 = add i32 %v3892, %v3891
  %v3894 = load ptr, ptr %MEMORY, align 4
  %v3895 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3894, ptr %state, ptr %EAX, i32 %v3893)
  store ptr %v3895, ptr %MEMORY, align 4
  %v3896 = load ptr, ptr %MEMORY, align 4
  %v3897 = call ptr @__remill_atomic_end(ptr %v3896)
  store ptr %v3897, ptr %MEMORY, align 4
  store i32 %v3887, ptr %PC, align 4
  %v3898 = add i32 %v3887, 4
  store i32 %v3898, ptr %NEXT_PC, align 4
  %v3899 = load ptr, ptr %MEMORY, align 4
  %v3900 = call ptr @__remill_atomic_begin(ptr %v3899)
  store ptr %v3900, ptr %MEMORY, align 4
  %v3901 = load i32, ptr %ESP, align 4
  %v3902 = load i32, ptr %SSBASE, align 4
  %v3903 = add i32 %v3901, 8
  %v3904 = add i32 %v3903, %v3902
  %v3905 = load i32, ptr %EAX, align 4
  %v3906 = load ptr, ptr %MEMORY, align 4
  %v3907 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3906, ptr %state, i32 %v3904, i32 %v3905)
  store ptr %v3907, ptr %MEMORY, align 4
  %v3908 = load ptr, ptr %MEMORY, align 4
  %v3909 = call ptr @__remill_atomic_end(ptr %v3908)
  store ptr %v3909, ptr %MEMORY, align 4
  store i32 %v3898, ptr %PC, align 4
  %v3910 = add i32 %v3898, 3
  store i32 %v3910, ptr %NEXT_PC, align 4
  %v3911 = load ptr, ptr %MEMORY, align 4
  %v3912 = call ptr @__remill_atomic_begin(ptr %v3911)
  store ptr %v3912, ptr %MEMORY, align 4
  %v3913 = load i32, ptr %EBP, align 4
  %v3914 = load i32, ptr %SSBASE, align 4
  %v3915 = add i32 %v3913, 12
  %v3916 = add i32 %v3915, %v3914
  %v3917 = load ptr, ptr %MEMORY, align 4
  %v3918 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3917, ptr %state, ptr %EAX, i32 %v3916)
  store ptr %v3918, ptr %MEMORY, align 4
  %v3919 = load ptr, ptr %MEMORY, align 4
  %v3920 = call ptr @__remill_atomic_end(ptr %v3919)
  store ptr %v3920, ptr %MEMORY, align 4
  store i32 %v3910, ptr %PC, align 4
  %v3921 = add i32 %v3910, 4
  store i32 %v3921, ptr %NEXT_PC, align 4
  %v3922 = load ptr, ptr %MEMORY, align 4
  %v3923 = call ptr @__remill_atomic_begin(ptr %v3922)
  store ptr %v3923, ptr %MEMORY, align 4
  %v3924 = load i32, ptr %ESP, align 4
  %v3925 = load i32, ptr %SSBASE, align 4
  %v3926 = add i32 %v3924, 4
  %v3927 = add i32 %v3926, %v3925
  %v3928 = load i32, ptr %EAX, align 4
  %v3929 = load ptr, ptr %MEMORY, align 4
  %v3930 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3929, ptr %state, i32 %v3927, i32 %v3928)
  store ptr %v3930, ptr %MEMORY, align 4
  %v3931 = load ptr, ptr %MEMORY, align 4
  %v3932 = call ptr @__remill_atomic_end(ptr %v3931)
  store ptr %v3932, ptr %MEMORY, align 4
  store i32 %v3921, ptr %PC, align 4
  %v3933 = add i32 %v3921, 3
  store i32 %v3933, ptr %NEXT_PC, align 4
  %v3934 = load ptr, ptr %MEMORY, align 4
  %v3935 = call ptr @__remill_atomic_begin(ptr %v3934)
  store ptr %v3935, ptr %MEMORY, align 4
  %v3936 = load i32, ptr %EBP, align 4
  %v3937 = load i32, ptr %SSBASE, align 4
  %v3938 = add i32 %v3936, 8
  %v3939 = add i32 %v3938, %v3937
  %v3940 = load ptr, ptr %MEMORY, align 4
  %v3941 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3940, ptr %state, ptr %EAX, i32 %v3939)
  store ptr %v3941, ptr %MEMORY, align 4
  %v3942 = load ptr, ptr %MEMORY, align 4
  %v3943 = call ptr @__remill_atomic_end(ptr %v3942)
  store ptr %v3943, ptr %MEMORY, align 4
  store i32 %v3933, ptr %PC, align 4
  %v3944 = add i32 %v3933, 3
  store i32 %v3944, ptr %NEXT_PC, align 4
  %v3945 = load ptr, ptr %MEMORY, align 4
  %v3946 = call ptr @__remill_atomic_begin(ptr %v3945)
  store ptr %v3946, ptr %MEMORY, align 4
  %v3947 = load i32, ptr %ESP, align 4
  %v3948 = load i32, ptr %SSBASE, align 4
  %v3949 = add i32 %v3947, %v3948
  %v3950 = load i32, ptr %EAX, align 4
  %v3951 = load ptr, ptr %MEMORY, align 4
  %v3952 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3951, ptr %state, i32 %v3949, i32 %v3950)
  store ptr %v3952, ptr %MEMORY, align 4
  %v3953 = load ptr, ptr %MEMORY, align 4
  %v3954 = call ptr @__remill_atomic_end(ptr %v3953)
  store ptr %v3954, ptr %MEMORY, align 4
  store i32 %v3944, ptr %PC, align 4
  %v3955 = add i32 %v3944, 5
  store i32 %v3955, ptr %NEXT_PC, align 4
  %v3956 = load ptr, ptr %MEMORY, align 4
  %v3957 = call ptr @__remill_atomic_begin(ptr %v3956)
  store ptr %v3957, ptr %MEMORY, align 4
  %v3958 = sub i32 %v3955, 69
  %v3959 = load ptr, ptr %MEMORY, align 4
  %v3960 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3959, ptr %state, i64 4205988, ptr %NEXT_PC, i32 %v3955, ptr %RETURN_PC)
  store ptr %v3960, ptr %MEMORY, align 4
  %v3961 = load ptr, ptr %MEMORY, align 4
  %v3962 = call ptr @__remill_atomic_end(ptr %v3961)
  store ptr %v3962, ptr %MEMORY, align 4
  store i32 %v3955, ptr %PC, align 4
  %v3963 = add i32 %v3955, 1
  store i32 %v3963, ptr %NEXT_PC, align 4
  %v3964 = load ptr, ptr %MEMORY, align 4
  %v3965 = call ptr @__remill_atomic_begin(ptr %v3964)
  store ptr %v3965, ptr %MEMORY, align 4
  %v3966 = load ptr, ptr %MEMORY, align 4
  %v3967 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v3966, ptr %state)
  store ptr %v3967, ptr %MEMORY, align 4
  %v3968 = load ptr, ptr %MEMORY, align 4
  %v3969 = call ptr @__remill_atomic_end(ptr %v3968)
  store ptr %v3969, ptr %MEMORY, align 4
  store i32 %v3963, ptr %PC, align 4
  %v3970 = add i32 %v3963, 3
  store i32 %v3970, ptr %NEXT_PC, align 4
  %v3971 = load ptr, ptr %MEMORY, align 4
  %v3972 = call ptr @__remill_atomic_begin(ptr %v3971)
  store ptr %v3972, ptr %MEMORY, align 4
  %v3973 = load ptr, ptr %MEMORY, align 4
  %v3974 = call ptr @_ZN12_GLOBAL__N_17RET_IMMEP6MemoryR5State2InItE3RnWIjE(ptr %v3973, ptr %state, i32 12, ptr %NEXT_PC)
  store ptr %v3974, ptr %MEMORY, align 4
  %v3975 = load ptr, ptr %MEMORY, align 4
  %v3976 = call ptr @__remill_atomic_end(ptr %v3975)
  store ptr %v3976, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206061:                                       ; No predecessors!
  %v3977 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3977, ptr %PC, align 4
  %v3978 = add i32 %v3977, 1
  store i32 %v3978, ptr %NEXT_PC, align 4
  %v3979 = load ptr, ptr %MEMORY, align 4
  %v3980 = call ptr @__remill_atomic_begin(ptr %v3979)
  store ptr %v3980, ptr %MEMORY, align 4
  %v3981 = load ptr, ptr %MEMORY, align 4
  %v3982 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3981, ptr %state)
  store ptr %v3982, ptr %MEMORY, align 4
  %v3983 = load ptr, ptr %MEMORY, align 4
  %v3984 = call ptr @__remill_atomic_end(ptr %v3983)
  store ptr %v3984, ptr %MEMORY, align 4
  store i32 %v3978, ptr %PC, align 4
  %v3985 = add i32 %v3978, 1
  store i32 %v3985, ptr %NEXT_PC, align 4
  %v3986 = load ptr, ptr %MEMORY, align 4
  %v3987 = call ptr @__remill_atomic_begin(ptr %v3986)
  store ptr %v3987, ptr %MEMORY, align 4
  %v3988 = load ptr, ptr %MEMORY, align 4
  %v3989 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3988, ptr %state)
  store ptr %v3989, ptr %MEMORY, align 4
  %v3990 = load ptr, ptr %MEMORY, align 4
  %v3991 = call ptr @__remill_atomic_end(ptr %v3990)
  store ptr %v3991, ptr %MEMORY, align 4
  store i32 %v3985, ptr %PC, align 4
  %v3992 = add i32 %v3985, 1
  store i32 %v3992, ptr %NEXT_PC, align 4
  %v3993 = load ptr, ptr %MEMORY, align 4
  %v3994 = call ptr @__remill_atomic_begin(ptr %v3993)
  store ptr %v3994, ptr %MEMORY, align 4
  %v3995 = load ptr, ptr %MEMORY, align 4
  %v3996 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v3995, ptr %state)
  store ptr %v3996, ptr %MEMORY, align 4
  %v3997 = load ptr, ptr %MEMORY, align 4
  %v3998 = call ptr @__remill_atomic_end(ptr %v3997)
  store ptr %v3998, ptr %MEMORY, align 4
  store i32 %v3992, ptr %PC, align 4
  %v3999 = add i32 %v3992, 1
  store i32 %v3999, ptr %NEXT_PC, align 4
  %v4000 = load ptr, ptr %MEMORY, align 4
  %v4001 = call ptr @__remill_atomic_begin(ptr %v4000)
  store ptr %v4001, ptr %MEMORY, align 4
  %v4002 = load i32, ptr %EBP, align 4
  %v4003 = load ptr, ptr %MEMORY, align 4
  %v4004 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4003, ptr %state, i32 %v4002)
  store ptr %v4004, ptr %MEMORY, align 4
  %v4005 = load ptr, ptr %MEMORY, align 4
  %v4006 = call ptr @__remill_atomic_end(ptr %v4005)
  store ptr %v4006, ptr %MEMORY, align 4
  store i32 %v3999, ptr %PC, align 4
  %v4007 = add i32 %v3999, 2
  store i32 %v4007, ptr %NEXT_PC, align 4
  %v4008 = load ptr, ptr %MEMORY, align 4
  %v4009 = call ptr @__remill_atomic_begin(ptr %v4008)
  store ptr %v4009, ptr %MEMORY, align 4
  %v4010 = load i32, ptr %ESP, align 4
  %v4011 = load ptr, ptr %MEMORY, align 4
  %v4012 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4011, ptr %state, ptr %EBP, i32 %v4010)
  store ptr %v4012, ptr %MEMORY, align 4
  %v4013 = load ptr, ptr %MEMORY, align 4
  %v4014 = call ptr @__remill_atomic_end(ptr %v4013)
  store ptr %v4014, ptr %MEMORY, align 4
  store i32 %v4007, ptr %PC, align 4
  %v4015 = add i32 %v4007, 1
  store i32 %v4015, ptr %NEXT_PC, align 4
  %v4016 = load ptr, ptr %MEMORY, align 4
  %v4017 = call ptr @__remill_atomic_begin(ptr %v4016)
  store ptr %v4017, ptr %MEMORY, align 4
  %v4018 = load i32, ptr %EBX, align 4
  %v4019 = load ptr, ptr %MEMORY, align 4
  %v4020 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4019, ptr %state, i32 %v4018)
  store ptr %v4020, ptr %MEMORY, align 4
  %v4021 = load ptr, ptr %MEMORY, align 4
  %v4022 = call ptr @__remill_atomic_end(ptr %v4021)
  store ptr %v4022, ptr %MEMORY, align 4
  store i32 %v4015, ptr %PC, align 4
  %v4023 = add i32 %v4015, 3
  store i32 %v4023, ptr %NEXT_PC, align 4
  %v4024 = load ptr, ptr %MEMORY, align 4
  %v4025 = call ptr @__remill_atomic_begin(ptr %v4024)
  store ptr %v4025, ptr %MEMORY, align 4
  %v4026 = load i32, ptr %ESP, align 4
  %v4027 = load ptr, ptr %MEMORY, align 4
  %v4028 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4027, ptr %state, ptr %ESP, i32 %v4026, i32 52)
  store ptr %v4028, ptr %MEMORY, align 4
  %v4029 = load ptr, ptr %MEMORY, align 4
  %v4030 = call ptr @__remill_atomic_end(ptr %v4029)
  store ptr %v4030, ptr %MEMORY, align 4
  store i32 %v4023, ptr %PC, align 4
  %v4031 = add i32 %v4023, 3
  store i32 %v4031, ptr %NEXT_PC, align 4
  %v4032 = load ptr, ptr %MEMORY, align 4
  %v4033 = call ptr @__remill_atomic_begin(ptr %v4032)
  store ptr %v4033, ptr %MEMORY, align 4
  %v4034 = load i32, ptr %EBP, align 4
  %v4035 = add i32 %v4034, 16
  %v4036 = load ptr, ptr %MEMORY, align 4
  %v4037 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4036, ptr %state, ptr %EAX, i32 %v4035)
  store ptr %v4037, ptr %MEMORY, align 4
  %v4038 = load ptr, ptr %MEMORY, align 4
  %v4039 = call ptr @__remill_atomic_end(ptr %v4038)
  store ptr %v4039, ptr %MEMORY, align 4
  store i32 %v4031, ptr %PC, align 4
  %v4040 = add i32 %v4031, 3
  store i32 %v4040, ptr %NEXT_PC, align 4
  %v4041 = load ptr, ptr %MEMORY, align 4
  %v4042 = call ptr @__remill_atomic_begin(ptr %v4041)
  store ptr %v4042, ptr %MEMORY, align 4
  %v4043 = load i32, ptr %EBP, align 4
  %v4044 = load i32, ptr %SSBASE, align 4
  %v4045 = sub i32 %v4043, 12
  %v4046 = add i32 %v4045, %v4044
  %v4047 = load i32, ptr %EAX, align 4
  %v4048 = load ptr, ptr %MEMORY, align 4
  %v4049 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4048, ptr %state, i32 %v4046, i32 %v4047)
  store ptr %v4049, ptr %MEMORY, align 4
  %v4050 = load ptr, ptr %MEMORY, align 4
  %v4051 = call ptr @__remill_atomic_end(ptr %v4050)
  store ptr %v4051, ptr %MEMORY, align 4
  store i32 %v4040, ptr %PC, align 4
  %v4052 = add i32 %v4040, 3
  store i32 %v4052, ptr %NEXT_PC, align 4
  %v4053 = load ptr, ptr %MEMORY, align 4
  %v4054 = call ptr @__remill_atomic_begin(ptr %v4053)
  store ptr %v4054, ptr %MEMORY, align 4
  %v4055 = load i32, ptr %EBP, align 4
  %v4056 = load i32, ptr %SSBASE, align 4
  %v4057 = sub i32 %v4055, 12
  %v4058 = add i32 %v4057, %v4056
  %v4059 = load ptr, ptr %MEMORY, align 4
  %v4060 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4059, ptr %state, ptr %EAX, i32 %v4058)
  store ptr %v4060, ptr %MEMORY, align 4
  %v4061 = load ptr, ptr %MEMORY, align 4
  %v4062 = call ptr @__remill_atomic_end(ptr %v4061)
  store ptr %v4062, ptr %MEMORY, align 4
  store i32 %v4052, ptr %PC, align 4
  %v4063 = add i32 %v4052, 4
  store i32 %v4063, ptr %NEXT_PC, align 4
  %v4064 = load ptr, ptr %MEMORY, align 4
  %v4065 = call ptr @__remill_atomic_begin(ptr %v4064)
  store ptr %v4065, ptr %MEMORY, align 4
  %v4066 = load i32, ptr %ESP, align 4
  %v4067 = load i32, ptr %SSBASE, align 4
  %v4068 = add i32 %v4066, 16
  %v4069 = add i32 %v4068, %v4067
  %v4070 = load i32, ptr %EAX, align 4
  %v4071 = load ptr, ptr %MEMORY, align 4
  %v4072 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4071, ptr %state, i32 %v4069, i32 %v4070)
  store ptr %v4072, ptr %MEMORY, align 4
  %v4073 = load ptr, ptr %MEMORY, align 4
  %v4074 = call ptr @__remill_atomic_end(ptr %v4073)
  store ptr %v4074, ptr %MEMORY, align 4
  store i32 %v4063, ptr %PC, align 4
  %v4075 = add i32 %v4063, 3
  store i32 %v4075, ptr %NEXT_PC, align 4
  %v4076 = load ptr, ptr %MEMORY, align 4
  %v4077 = call ptr @__remill_atomic_begin(ptr %v4076)
  store ptr %v4077, ptr %MEMORY, align 4
  %v4078 = load i32, ptr %EBP, align 4
  %v4079 = load i32, ptr %SSBASE, align 4
  %v4080 = add i32 %v4078, 12
  %v4081 = add i32 %v4080, %v4079
  %v4082 = load ptr, ptr %MEMORY, align 4
  %v4083 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4082, ptr %state, ptr %EAX, i32 %v4081)
  store ptr %v4083, ptr %MEMORY, align 4
  %v4084 = load ptr, ptr %MEMORY, align 4
  %v4085 = call ptr @__remill_atomic_end(ptr %v4084)
  store ptr %v4085, ptr %MEMORY, align 4
  store i32 %v4075, ptr %PC, align 4
  %v4086 = add i32 %v4075, 4
  store i32 %v4086, ptr %NEXT_PC, align 4
  %v4087 = load ptr, ptr %MEMORY, align 4
  %v4088 = call ptr @__remill_atomic_begin(ptr %v4087)
  store ptr %v4088, ptr %MEMORY, align 4
  %v4089 = load i32, ptr %ESP, align 4
  %v4090 = load i32, ptr %SSBASE, align 4
  %v4091 = add i32 %v4089, 12
  %v4092 = add i32 %v4091, %v4090
  %v4093 = load i32, ptr %EAX, align 4
  %v4094 = load ptr, ptr %MEMORY, align 4
  %v4095 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4094, ptr %state, i32 %v4092, i32 %v4093)
  store ptr %v4095, ptr %MEMORY, align 4
  %v4096 = load ptr, ptr %MEMORY, align 4
  %v4097 = call ptr @__remill_atomic_end(ptr %v4096)
  store ptr %v4097, ptr %MEMORY, align 4
  store i32 %v4086, ptr %PC, align 4
  %v4098 = add i32 %v4086, 8
  store i32 %v4098, ptr %NEXT_PC, align 4
  %v4099 = load ptr, ptr %MEMORY, align 4
  %v4100 = call ptr @__remill_atomic_begin(ptr %v4099)
  store ptr %v4100, ptr %MEMORY, align 4
  %v4101 = load i32, ptr %ESP, align 4
  %v4102 = load i32, ptr %SSBASE, align 4
  %v4103 = add i32 %v4101, 8
  %v4104 = add i32 %v4103, %v4102
  %v4105 = load ptr, ptr %MEMORY, align 4
  %v4106 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4105, ptr %state, i32 %v4104, i32 0)
  store ptr %v4106, ptr %MEMORY, align 4
  %v4107 = load ptr, ptr %MEMORY, align 4
  %v4108 = call ptr @__remill_atomic_end(ptr %v4107)
  store ptr %v4108, ptr %MEMORY, align 4
  store i32 %v4098, ptr %PC, align 4
  %v4109 = add i32 %v4098, 3
  store i32 %v4109, ptr %NEXT_PC, align 4
  %v4110 = load ptr, ptr %MEMORY, align 4
  %v4111 = call ptr @__remill_atomic_begin(ptr %v4110)
  store ptr %v4111, ptr %MEMORY, align 4
  %v4112 = load i32, ptr %EBP, align 4
  %v4113 = load i32, ptr %SSBASE, align 4
  %v4114 = add i32 %v4112, 8
  %v4115 = add i32 %v4114, %v4113
  %v4116 = load ptr, ptr %MEMORY, align 4
  %v4117 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4116, ptr %state, ptr %EAX, i32 %v4115)
  store ptr %v4117, ptr %MEMORY, align 4
  %v4118 = load ptr, ptr %MEMORY, align 4
  %v4119 = call ptr @__remill_atomic_end(ptr %v4118)
  store ptr %v4119, ptr %MEMORY, align 4
  store i32 %v4109, ptr %PC, align 4
  %v4120 = add i32 %v4109, 4
  store i32 %v4120, ptr %NEXT_PC, align 4
  %v4121 = load ptr, ptr %MEMORY, align 4
  %v4122 = call ptr @__remill_atomic_begin(ptr %v4121)
  store ptr %v4122, ptr %MEMORY, align 4
  %v4123 = load i32, ptr %ESP, align 4
  %v4124 = load i32, ptr %SSBASE, align 4
  %v4125 = add i32 %v4123, 4
  %v4126 = add i32 %v4125, %v4124
  %v4127 = load i32, ptr %EAX, align 4
  %v4128 = load ptr, ptr %MEMORY, align 4
  %v4129 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4128, ptr %state, i32 %v4126, i32 %v4127)
  store ptr %v4129, ptr %MEMORY, align 4
  %v4130 = load ptr, ptr %MEMORY, align 4
  %v4131 = call ptr @__remill_atomic_end(ptr %v4130)
  store ptr %v4131, ptr %MEMORY, align 4
  store i32 %v4120, ptr %PC, align 4
  %v4132 = add i32 %v4120, 7
  store i32 %v4132, ptr %NEXT_PC, align 4
  %v4133 = load ptr, ptr %MEMORY, align 4
  %v4134 = call ptr @__remill_atomic_begin(ptr %v4133)
  store ptr %v4134, ptr %MEMORY, align 4
  %v4135 = load i32, ptr %ESP, align 4
  %v4136 = load i32, ptr %SSBASE, align 4
  %v4137 = add i32 %v4135, %v4136
  %v4138 = load ptr, ptr %MEMORY, align 4
  %v4139 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4138, ptr %state, i32 %v4137, i32 12288)
  store ptr %v4139, ptr %MEMORY, align 4
  %v4140 = load ptr, ptr %MEMORY, align 4
  %v4141 = call ptr @__remill_atomic_end(ptr %v4140)
  store ptr %v4141, ptr %MEMORY, align 4
  store i32 %v4132, ptr %PC, align 4
  %v4142 = add i32 %v4132, 5
  store i32 %v4142, ptr %NEXT_PC, align 4
  %v4143 = load ptr, ptr %MEMORY, align 4
  %v4144 = call ptr @__remill_atomic_begin(ptr %v4143)
  store ptr %v4144, ptr %MEMORY, align 4
  %v4145 = add i32 %v4142, 7278
  %v4146 = load ptr, ptr %MEMORY, align 4
  %v4147 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4146, ptr %state, i64 4213396, ptr %NEXT_PC, i32 %v4142, ptr %RETURN_PC)
  store ptr %v4147, ptr %MEMORY, align 4
  %v4148 = load ptr, ptr %MEMORY, align 4
  %v4149 = call ptr @__remill_atomic_end(ptr %v4148)
  store ptr %v4149, ptr %MEMORY, align 4
  store i32 %v4142, ptr %PC, align 4
  %v4150 = add i32 %v4142, 2
  store i32 %v4150, ptr %NEXT_PC, align 4
  %v4151 = load ptr, ptr %MEMORY, align 4
  %v4152 = call ptr @__remill_atomic_begin(ptr %v4151)
  store ptr %v4152, ptr %MEMORY, align 4
  %v4153 = load i32, ptr %EAX, align 4
  %v4154 = load ptr, ptr %MEMORY, align 4
  %v4155 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4154, ptr %state, ptr %EBX, i32 %v4153)
  store ptr %v4155, ptr %MEMORY, align 4
  %v4156 = load ptr, ptr %MEMORY, align 4
  %v4157 = call ptr @__remill_atomic_end(ptr %v4156)
  store ptr %v4157, ptr %MEMORY, align 4
  store i32 %v4150, ptr %PC, align 4
  %v4158 = add i32 %v4150, 2
  store i32 %v4158, ptr %NEXT_PC, align 4
  %v4159 = load ptr, ptr %MEMORY, align 4
  %v4160 = call ptr @__remill_atomic_begin(ptr %v4159)
  store ptr %v4160, ptr %MEMORY, align 4
  %v4161 = load i32, ptr %EBX, align 4
  %v4162 = load ptr, ptr %MEMORY, align 4
  %v4163 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4162, ptr %state, ptr %EAX, i32 %v4161)
  store ptr %v4163, ptr %MEMORY, align 4
  %v4164 = load ptr, ptr %MEMORY, align 4
  %v4165 = call ptr @__remill_atomic_end(ptr %v4164)
  store ptr %v4165, ptr %MEMORY, align 4
  store i32 %v4158, ptr %PC, align 4
  %v4166 = add i32 %v4158, 3
  store i32 %v4166, ptr %NEXT_PC, align 4
  %v4167 = load ptr, ptr %MEMORY, align 4
  %v4168 = call ptr @__remill_atomic_begin(ptr %v4167)
  store ptr %v4168, ptr %MEMORY, align 4
  %v4169 = load i32, ptr %ESP, align 4
  %v4170 = load ptr, ptr %MEMORY, align 4
  %v4171 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4170, ptr %state, ptr %ESP, i32 %v4169, i32 52)
  store ptr %v4171, ptr %MEMORY, align 4
  %v4172 = load ptr, ptr %MEMORY, align 4
  %v4173 = call ptr @__remill_atomic_end(ptr %v4172)
  store ptr %v4173, ptr %MEMORY, align 4
  store i32 %v4166, ptr %PC, align 4
  %v4174 = add i32 %v4166, 1
  store i32 %v4174, ptr %NEXT_PC, align 4
  %v4175 = load ptr, ptr %MEMORY, align 4
  %v4176 = call ptr @__remill_atomic_begin(ptr %v4175)
  store ptr %v4176, ptr %MEMORY, align 4
  %v4177 = load ptr, ptr %MEMORY, align 4
  %v4178 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v4177, ptr %state, ptr %EBX)
  store ptr %v4178, ptr %MEMORY, align 4
  %v4179 = load ptr, ptr %MEMORY, align 4
  %v4180 = call ptr @__remill_atomic_end(ptr %v4179)
  store ptr %v4180, ptr %MEMORY, align 4
  store i32 %v4174, ptr %PC, align 4
  %v4181 = add i32 %v4174, 1
  store i32 %v4181, ptr %NEXT_PC, align 4
  %v4182 = load ptr, ptr %MEMORY, align 4
  %v4183 = call ptr @__remill_atomic_begin(ptr %v4182)
  store ptr %v4183, ptr %MEMORY, align 4
  %v4184 = load ptr, ptr %MEMORY, align 4
  %v4185 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v4184, ptr %state, ptr %EBP)
  store ptr %v4185, ptr %MEMORY, align 4
  %v4186 = load ptr, ptr %MEMORY, align 4
  %v4187 = call ptr @__remill_atomic_end(ptr %v4186)
  store ptr %v4187, ptr %MEMORY, align 4
  store i32 %v4181, ptr %PC, align 4
  %v4188 = add i32 %v4181, 1
  store i32 %v4188, ptr %NEXT_PC, align 4
  %v4189 = load ptr, ptr %MEMORY, align 4
  %v4190 = call ptr @__remill_atomic_begin(ptr %v4189)
  store ptr %v4190, ptr %MEMORY, align 4
  %v4191 = load ptr, ptr %MEMORY, align 4
  %v4192 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4191, ptr %state, ptr %NEXT_PC)
  store ptr %v4192, ptr %MEMORY, align 4
  %v4193 = load ptr, ptr %MEMORY, align 4
  %v4194 = call ptr @__remill_atomic_end(ptr %v4193)
  store ptr %v4194, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206128:                                       ; No predecessors!
  %v4195 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4195, ptr %PC, align 4
  %v4196 = add i32 %v4195, 1
  store i32 %v4196, ptr %NEXT_PC, align 4
  %v4197 = load ptr, ptr %MEMORY, align 4
  %v4198 = call ptr @__remill_atomic_begin(ptr %v4197)
  store ptr %v4198, ptr %MEMORY, align 4
  %v4199 = load i32, ptr %EBP, align 4
  %v4200 = load ptr, ptr %MEMORY, align 4
  %v4201 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4200, ptr %state, i32 %v4199)
  store ptr %v4201, ptr %MEMORY, align 4
  %v4202 = load ptr, ptr %MEMORY, align 4
  %v4203 = call ptr @__remill_atomic_end(ptr %v4202)
  store ptr %v4203, ptr %MEMORY, align 4
  store i32 %v4196, ptr %PC, align 4
  %v4204 = add i32 %v4196, 2
  store i32 %v4204, ptr %NEXT_PC, align 4
  %v4205 = load ptr, ptr %MEMORY, align 4
  %v4206 = call ptr @__remill_atomic_begin(ptr %v4205)
  store ptr %v4206, ptr %MEMORY, align 4
  %v4207 = load i32, ptr %ESP, align 4
  %v4208 = load ptr, ptr %MEMORY, align 4
  %v4209 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4208, ptr %state, ptr %EBP, i32 %v4207)
  store ptr %v4209, ptr %MEMORY, align 4
  %v4210 = load ptr, ptr %MEMORY, align 4
  %v4211 = call ptr @__remill_atomic_end(ptr %v4210)
  store ptr %v4211, ptr %MEMORY, align 4
  store i32 %v4204, ptr %PC, align 4
  %v4212 = add i32 %v4204, 3
  store i32 %v4212, ptr %NEXT_PC, align 4
  %v4213 = load ptr, ptr %MEMORY, align 4
  %v4214 = call ptr @__remill_atomic_begin(ptr %v4213)
  store ptr %v4214, ptr %MEMORY, align 4
  %v4215 = load i32, ptr %ESP, align 4
  %v4216 = load ptr, ptr %MEMORY, align 4
  %v4217 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4216, ptr %state, ptr %ESP, i32 %v4215, i32 40)
  store ptr %v4217, ptr %MEMORY, align 4
  %v4218 = load ptr, ptr %MEMORY, align 4
  %v4219 = call ptr @__remill_atomic_end(ptr %v4218)
  store ptr %v4219, ptr %MEMORY, align 4
  store i32 %v4212, ptr %PC, align 4
  %v4220 = add i32 %v4212, 3
  store i32 %v4220, ptr %NEXT_PC, align 4
  %v4221 = load ptr, ptr %MEMORY, align 4
  %v4222 = call ptr @__remill_atomic_begin(ptr %v4221)
  store ptr %v4222, ptr %MEMORY, align 4
  %v4223 = load i32, ptr %EBP, align 4
  %v4224 = load i32, ptr %SSBASE, align 4
  %v4225 = add i32 %v4223, 16
  %v4226 = add i32 %v4225, %v4224
  %v4227 = load ptr, ptr %MEMORY, align 4
  %v4228 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4227, ptr %state, ptr %EAX, i32 %v4226)
  store ptr %v4228, ptr %MEMORY, align 4
  %v4229 = load ptr, ptr %MEMORY, align 4
  %v4230 = call ptr @__remill_atomic_end(ptr %v4229)
  store ptr %v4230, ptr %MEMORY, align 4
  store i32 %v4220, ptr %PC, align 4
  %v4231 = add i32 %v4220, 4
  store i32 %v4231, ptr %NEXT_PC, align 4
  %v4232 = load ptr, ptr %MEMORY, align 4
  %v4233 = call ptr @__remill_atomic_begin(ptr %v4232)
  store ptr %v4233, ptr %MEMORY, align 4
  %v4234 = load i32, ptr %ESP, align 4
  %v4235 = load i32, ptr %SSBASE, align 4
  %v4236 = add i32 %v4234, 16
  %v4237 = add i32 %v4236, %v4235
  %v4238 = load i32, ptr %EAX, align 4
  %v4239 = load ptr, ptr %MEMORY, align 4
  %v4240 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4239, ptr %state, i32 %v4237, i32 %v4238)
  store ptr %v4240, ptr %MEMORY, align 4
  %v4241 = load ptr, ptr %MEMORY, align 4
  %v4242 = call ptr @__remill_atomic_end(ptr %v4241)
  store ptr %v4242, ptr %MEMORY, align 4
  store i32 %v4231, ptr %PC, align 4
  %v4243 = add i32 %v4231, 3
  store i32 %v4243, ptr %NEXT_PC, align 4
  %v4244 = load ptr, ptr %MEMORY, align 4
  %v4245 = call ptr @__remill_atomic_begin(ptr %v4244)
  store ptr %v4245, ptr %MEMORY, align 4
  %v4246 = load i32, ptr %EBP, align 4
  %v4247 = load i32, ptr %SSBASE, align 4
  %v4248 = add i32 %v4246, 12
  %v4249 = add i32 %v4248, %v4247
  %v4250 = load ptr, ptr %MEMORY, align 4
  %v4251 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4250, ptr %state, ptr %EAX, i32 %v4249)
  store ptr %v4251, ptr %MEMORY, align 4
  %v4252 = load ptr, ptr %MEMORY, align 4
  %v4253 = call ptr @__remill_atomic_end(ptr %v4252)
  store ptr %v4253, ptr %MEMORY, align 4
  store i32 %v4243, ptr %PC, align 4
  %v4254 = add i32 %v4243, 4
  store i32 %v4254, ptr %NEXT_PC, align 4
  %v4255 = load ptr, ptr %MEMORY, align 4
  %v4256 = call ptr @__remill_atomic_begin(ptr %v4255)
  store ptr %v4256, ptr %MEMORY, align 4
  %v4257 = load i32, ptr %ESP, align 4
  %v4258 = load i32, ptr %SSBASE, align 4
  %v4259 = add i32 %v4257, 12
  %v4260 = add i32 %v4259, %v4258
  %v4261 = load i32, ptr %EAX, align 4
  %v4262 = load ptr, ptr %MEMORY, align 4
  %v4263 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4262, ptr %state, i32 %v4260, i32 %v4261)
  store ptr %v4263, ptr %MEMORY, align 4
  %v4264 = load ptr, ptr %MEMORY, align 4
  %v4265 = call ptr @__remill_atomic_end(ptr %v4264)
  store ptr %v4265, ptr %MEMORY, align 4
  store i32 %v4254, ptr %PC, align 4
  %v4266 = add i32 %v4254, 8
  store i32 %v4266, ptr %NEXT_PC, align 4
  %v4267 = load ptr, ptr %MEMORY, align 4
  %v4268 = call ptr @__remill_atomic_begin(ptr %v4267)
  store ptr %v4268, ptr %MEMORY, align 4
  %v4269 = load i32, ptr %ESP, align 4
  %v4270 = load i32, ptr %SSBASE, align 4
  %v4271 = add i32 %v4269, 8
  %v4272 = add i32 %v4271, %v4270
  %v4273 = load ptr, ptr %MEMORY, align 4
  %v4274 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4273, ptr %state, i32 %v4272, i32 0)
  store ptr %v4274, ptr %MEMORY, align 4
  %v4275 = load ptr, ptr %MEMORY, align 4
  %v4276 = call ptr @__remill_atomic_end(ptr %v4275)
  store ptr %v4276, ptr %MEMORY, align 4
  store i32 %v4266, ptr %PC, align 4
  %v4277 = add i32 %v4266, 3
  store i32 %v4277, ptr %NEXT_PC, align 4
  %v4278 = load ptr, ptr %MEMORY, align 4
  %v4279 = call ptr @__remill_atomic_begin(ptr %v4278)
  store ptr %v4279, ptr %MEMORY, align 4
  %v4280 = load i32, ptr %EBP, align 4
  %v4281 = load i32, ptr %SSBASE, align 4
  %v4282 = add i32 %v4280, 8
  %v4283 = add i32 %v4282, %v4281
  %v4284 = load ptr, ptr %MEMORY, align 4
  %v4285 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4284, ptr %state, ptr %EAX, i32 %v4283)
  store ptr %v4285, ptr %MEMORY, align 4
  %v4286 = load ptr, ptr %MEMORY, align 4
  %v4287 = call ptr @__remill_atomic_end(ptr %v4286)
  store ptr %v4287, ptr %MEMORY, align 4
  store i32 %v4277, ptr %PC, align 4
  %v4288 = add i32 %v4277, 4
  store i32 %v4288, ptr %NEXT_PC, align 4
  %v4289 = load ptr, ptr %MEMORY, align 4
  %v4290 = call ptr @__remill_atomic_begin(ptr %v4289)
  store ptr %v4290, ptr %MEMORY, align 4
  %v4291 = load i32, ptr %ESP, align 4
  %v4292 = load i32, ptr %SSBASE, align 4
  %v4293 = add i32 %v4291, 4
  %v4294 = add i32 %v4293, %v4292
  %v4295 = load i32, ptr %EAX, align 4
  %v4296 = load ptr, ptr %MEMORY, align 4
  %v4297 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4296, ptr %state, i32 %v4294, i32 %v4295)
  store ptr %v4297, ptr %MEMORY, align 4
  %v4298 = load ptr, ptr %MEMORY, align 4
  %v4299 = call ptr @__remill_atomic_end(ptr %v4298)
  store ptr %v4299, ptr %MEMORY, align 4
  store i32 %v4288, ptr %PC, align 4
  %v4300 = add i32 %v4288, 7
  store i32 %v4300, ptr %NEXT_PC, align 4
  %v4301 = load ptr, ptr %MEMORY, align 4
  %v4302 = call ptr @__remill_atomic_begin(ptr %v4301)
  store ptr %v4302, ptr %MEMORY, align 4
  %v4303 = load i32, ptr %ESP, align 4
  %v4304 = load i32, ptr %SSBASE, align 4
  %v4305 = add i32 %v4303, %v4304
  %v4306 = load ptr, ptr %MEMORY, align 4
  %v4307 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4306, ptr %state, i32 %v4305, i32 12288)
  store ptr %v4307, ptr %MEMORY, align 4
  %v4308 = load ptr, ptr %MEMORY, align 4
  %v4309 = call ptr @__remill_atomic_end(ptr %v4308)
  store ptr %v4309, ptr %MEMORY, align 4
  store i32 %v4300, ptr %PC, align 4
  %v4310 = add i32 %v4300, 5
  store i32 %v4310, ptr %NEXT_PC, align 4
  %v4311 = load ptr, ptr %MEMORY, align 4
  %v4312 = call ptr @__remill_atomic_begin(ptr %v4311)
  store ptr %v4312, ptr %MEMORY, align 4
  %v4313 = add i32 %v4310, 7221
  %v4314 = load ptr, ptr %MEMORY, align 4
  %v4315 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4314, ptr %state, i64 4213396, ptr %NEXT_PC, i32 %v4310, ptr %RETURN_PC)
  store ptr %v4315, ptr %MEMORY, align 4
  %v4316 = load ptr, ptr %MEMORY, align 4
  %v4317 = call ptr @__remill_atomic_end(ptr %v4316)
  store ptr %v4317, ptr %MEMORY, align 4
  store i32 %v4310, ptr %PC, align 4
  %v4318 = add i32 %v4310, 1
  store i32 %v4318, ptr %NEXT_PC, align 4
  %v4319 = load ptr, ptr %MEMORY, align 4
  %v4320 = call ptr @__remill_atomic_begin(ptr %v4319)
  store ptr %v4320, ptr %MEMORY, align 4
  %v4321 = load ptr, ptr %MEMORY, align 4
  %v4322 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v4321, ptr %state)
  store ptr %v4322, ptr %MEMORY, align 4
  %v4323 = load ptr, ptr %MEMORY, align 4
  %v4324 = call ptr @__remill_atomic_end(ptr %v4323)
  store ptr %v4324, ptr %MEMORY, align 4
  store i32 %v4318, ptr %PC, align 4
  %v4325 = add i32 %v4318, 1
  store i32 %v4325, ptr %NEXT_PC, align 4
  %v4326 = load ptr, ptr %MEMORY, align 4
  %v4327 = call ptr @__remill_atomic_begin(ptr %v4326)
  store ptr %v4327, ptr %MEMORY, align 4
  %v4328 = load ptr, ptr %MEMORY, align 4
  %v4329 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4328, ptr %state, ptr %NEXT_PC)
  store ptr %v4329, ptr %MEMORY, align 4
  %v4330 = load ptr, ptr %MEMORY, align 4
  %v4331 = call ptr @__remill_atomic_end(ptr %v4330)
  store ptr %v4331, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206177:                                       ; No predecessors!
  %v4332 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4332, ptr %PC, align 4
  %v4333 = add i32 %v4332, 1
  store i32 %v4333, ptr %NEXT_PC, align 4
  %v4334 = load ptr, ptr %MEMORY, align 4
  %v4335 = call ptr @__remill_atomic_begin(ptr %v4334)
  store ptr %v4335, ptr %MEMORY, align 4
  %v4336 = load ptr, ptr %MEMORY, align 4
  %v4337 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4336, ptr %state)
  store ptr %v4337, ptr %MEMORY, align 4
  %v4338 = load ptr, ptr %MEMORY, align 4
  %v4339 = call ptr @__remill_atomic_end(ptr %v4338)
  store ptr %v4339, ptr %MEMORY, align 4
  store i32 %v4333, ptr %PC, align 4
  %v4340 = add i32 %v4333, 1
  store i32 %v4340, ptr %NEXT_PC, align 4
  %v4341 = load ptr, ptr %MEMORY, align 4
  %v4342 = call ptr @__remill_atomic_begin(ptr %v4341)
  store ptr %v4342, ptr %MEMORY, align 4
  %v4343 = load ptr, ptr %MEMORY, align 4
  %v4344 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4343, ptr %state)
  store ptr %v4344, ptr %MEMORY, align 4
  %v4345 = load ptr, ptr %MEMORY, align 4
  %v4346 = call ptr @__remill_atomic_end(ptr %v4345)
  store ptr %v4346, ptr %MEMORY, align 4
  store i32 %v4340, ptr %PC, align 4
  %v4347 = add i32 %v4340, 1
  store i32 %v4347, ptr %NEXT_PC, align 4
  %v4348 = load ptr, ptr %MEMORY, align 4
  %v4349 = call ptr @__remill_atomic_begin(ptr %v4348)
  store ptr %v4349, ptr %MEMORY, align 4
  %v4350 = load ptr, ptr %MEMORY, align 4
  %v4351 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4350, ptr %state)
  store ptr %v4351, ptr %MEMORY, align 4
  %v4352 = load ptr, ptr %MEMORY, align 4
  %v4353 = call ptr @__remill_atomic_end(ptr %v4352)
  store ptr %v4353, ptr %MEMORY, align 4
  store i32 %v4347, ptr %PC, align 4
  %v4354 = add i32 %v4347, 1
  store i32 %v4354, ptr %NEXT_PC, align 4
  %v4355 = load ptr, ptr %MEMORY, align 4
  %v4356 = call ptr @__remill_atomic_begin(ptr %v4355)
  store ptr %v4356, ptr %MEMORY, align 4
  %v4357 = load i32, ptr %EBP, align 4
  %v4358 = load ptr, ptr %MEMORY, align 4
  %v4359 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4358, ptr %state, i32 %v4357)
  store ptr %v4359, ptr %MEMORY, align 4
  %v4360 = load ptr, ptr %MEMORY, align 4
  %v4361 = call ptr @__remill_atomic_end(ptr %v4360)
  store ptr %v4361, ptr %MEMORY, align 4
  store i32 %v4354, ptr %PC, align 4
  %v4362 = add i32 %v4354, 2
  store i32 %v4362, ptr %NEXT_PC, align 4
  %v4363 = load ptr, ptr %MEMORY, align 4
  %v4364 = call ptr @__remill_atomic_begin(ptr %v4363)
  store ptr %v4364, ptr %MEMORY, align 4
  %v4365 = load i32, ptr %ESP, align 4
  %v4366 = load ptr, ptr %MEMORY, align 4
  %v4367 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4366, ptr %state, ptr %EBP, i32 %v4365)
  store ptr %v4367, ptr %MEMORY, align 4
  %v4368 = load ptr, ptr %MEMORY, align 4
  %v4369 = call ptr @__remill_atomic_end(ptr %v4368)
  store ptr %v4369, ptr %MEMORY, align 4
  store i32 %v4362, ptr %PC, align 4
  %v4370 = add i32 %v4362, 3
  store i32 %v4370, ptr %NEXT_PC, align 4
  %v4371 = load ptr, ptr %MEMORY, align 4
  %v4372 = call ptr @__remill_atomic_begin(ptr %v4371)
  store ptr %v4372, ptr %MEMORY, align 4
  %v4373 = load i32, ptr %ESP, align 4
  %v4374 = load ptr, ptr %MEMORY, align 4
  %v4375 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4374, ptr %state, ptr %ESP, i32 %v4373, i32 40)
  store ptr %v4375, ptr %MEMORY, align 4
  %v4376 = load ptr, ptr %MEMORY, align 4
  %v4377 = call ptr @__remill_atomic_end(ptr %v4376)
  store ptr %v4377, ptr %MEMORY, align 4
  store i32 %v4370, ptr %PC, align 4
  %v4378 = add i32 %v4370, 7
  store i32 %v4378, ptr %NEXT_PC, align 4
  %v4379 = load ptr, ptr %MEMORY, align 4
  %v4380 = call ptr @__remill_atomic_begin(ptr %v4379)
  store ptr %v4380, ptr %MEMORY, align 4
  %v4381 = load i32, ptr %ESP, align 4
  %v4382 = load i32, ptr %SSBASE, align 4
  %v4383 = add i32 %v4381, %v4382
  %v4384 = load ptr, ptr %MEMORY, align 4
  %v4385 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4384, ptr %state, i32 %v4383, i32 4235948)
  store ptr %v4385, ptr %MEMORY, align 4
  %v4386 = load ptr, ptr %MEMORY, align 4
  %v4387 = call ptr @__remill_atomic_end(ptr %v4386)
  store ptr %v4387, ptr %MEMORY, align 4
  store i32 %v4378, ptr %PC, align 4
  %v4388 = add i32 %v4378, 5
  store i32 %v4388, ptr %NEXT_PC, align 4
  %v4389 = load ptr, ptr %MEMORY, align 4
  %v4390 = call ptr @__remill_atomic_begin(ptr %v4389)
  store ptr %v4390, ptr %MEMORY, align 4
  %v4391 = add i32 %v4388, 22470
  %v4392 = load ptr, ptr %MEMORY, align 4
  %v4393 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4392, ptr %state, i64 4228668, ptr %NEXT_PC, i32 %v4388, ptr %RETURN_PC)
  store ptr %v4393, ptr %MEMORY, align 4
  %v4394 = load ptr, ptr %MEMORY, align 4
  %v4395 = call ptr @__remill_atomic_end(ptr %v4394)
  store ptr %v4395, ptr %MEMORY, align 4
  store i32 %v4388, ptr %PC, align 4
  %v4396 = add i32 %v4388, 3
  store i32 %v4396, ptr %NEXT_PC, align 4
  %v4397 = load ptr, ptr %MEMORY, align 4
  %v4398 = call ptr @__remill_atomic_begin(ptr %v4397)
  store ptr %v4398, ptr %MEMORY, align 4
  %v4399 = load i32, ptr %EBP, align 4
  %v4400 = load i32, ptr %SSBASE, align 4
  %v4401 = sub i32 %v4399, 12
  %v4402 = add i32 %v4401, %v4400
  %v4403 = load i32, ptr %EAX, align 4
  %v4404 = load ptr, ptr %MEMORY, align 4
  %v4405 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4404, ptr %state, i32 %v4402, i32 %v4403)
  store ptr %v4405, ptr %MEMORY, align 4
  %v4406 = load ptr, ptr %MEMORY, align 4
  %v4407 = call ptr @__remill_atomic_end(ptr %v4406)
  store ptr %v4407, ptr %MEMORY, align 4
  store i32 %v4396, ptr %PC, align 4
  %v4408 = add i32 %v4396, 4
  store i32 %v4408, ptr %NEXT_PC, align 4
  %v4409 = load ptr, ptr %MEMORY, align 4
  %v4410 = call ptr @__remill_atomic_begin(ptr %v4409)
  store ptr %v4410, ptr %MEMORY, align 4
  %v4411 = load i32, ptr %EBP, align 4
  %v4412 = load i32, ptr %SSBASE, align 4
  %v4413 = sub i32 %v4411, 12
  %v4414 = add i32 %v4413, %v4412
  %v4415 = load ptr, ptr %MEMORY, align 4
  %v4416 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4415, ptr %state, i32 %v4414, i32 0)
  store ptr %v4416, ptr %MEMORY, align 4
  %v4417 = load ptr, ptr %MEMORY, align 4
  %v4418 = call ptr @__remill_atomic_end(ptr %v4417)
  store ptr %v4418, ptr %MEMORY, align 4
  store i32 %v4408, ptr %PC, align 4
  %v4419 = add i32 %v4408, 2
  store i32 %v4419, ptr %NEXT_PC, align 4
  %v4420 = load ptr, ptr %MEMORY, align 4
  %v4421 = call ptr @__remill_atomic_begin(ptr %v4420)
  store ptr %v4421, ptr %MEMORY, align 4
  %v4422 = add i32 %v4419, 17
  %v4423 = load ptr, ptr %MEMORY, align 4
  %v4424 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4423, ptr %state, ptr %BRANCH_TAKEN, i32 %v4422, i32 %v4419, ptr %NEXT_PC)
  store ptr %v4424, ptr %MEMORY, align 4
  %v4425 = load ptr, ptr %MEMORY, align 4
  %v4426 = call ptr @__remill_atomic_end(ptr %v4425)
  store ptr %v4426, ptr %MEMORY, align 4
  br i1 true, label %bb_4206224, label %bb_4206207

bb_4206207:                                       ; preds = %bb_4206177
  store i32 %v4419, ptr %PC, align 4
  %v4427 = add i32 %v4419, 3
  store i32 %v4427, ptr %NEXT_PC, align 4
  %v4428 = load ptr, ptr %MEMORY, align 4
  %v4429 = call ptr @__remill_atomic_begin(ptr %v4428)
  store ptr %v4429, ptr %MEMORY, align 4
  %v4430 = load i32, ptr %EBP, align 4
  %v4431 = load i32, ptr %SSBASE, align 4
  %v4432 = sub i32 %v4430, 12
  %v4433 = add i32 %v4432, %v4431
  %v4434 = load ptr, ptr %MEMORY, align 4
  %v4435 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4434, ptr %state, ptr %EAX, i32 %v4433)
  store ptr %v4435, ptr %MEMORY, align 4
  %v4436 = load ptr, ptr %MEMORY, align 4
  %v4437 = call ptr @__remill_atomic_end(ptr %v4436)
  store ptr %v4437, ptr %MEMORY, align 4
  store i32 %v4427, ptr %PC, align 4
  %v4438 = add i32 %v4427, 3
  store i32 %v4438, ptr %NEXT_PC, align 4
  %v4439 = load ptr, ptr %MEMORY, align 4
  %v4440 = call ptr @__remill_atomic_begin(ptr %v4439)
  store ptr %v4440, ptr %MEMORY, align 4
  %v4441 = load i32, ptr %EAX, align 4
  %v4442 = load i32, ptr %DSBASE, align 4
  %v4443 = add i32 %v4441, %v4442
  %v4444 = load ptr, ptr %MEMORY, align 4
  %v4445 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v4444, ptr %state, ptr %EAX, i32 %v4443)
  store ptr %v4445, ptr %MEMORY, align 4
  %v4446 = load ptr, ptr %MEMORY, align 4
  %v4447 = call ptr @__remill_atomic_end(ptr %v4446)
  store ptr %v4447, ptr %MEMORY, align 4
  store i32 %v4438, ptr %PC, align 4
  %v4448 = add i32 %v4438, 3
  store i32 %v4448, ptr %NEXT_PC, align 4
  %v4449 = load ptr, ptr %MEMORY, align 4
  %v4450 = call ptr @__remill_atomic_begin(ptr %v4449)
  store ptr %v4450, ptr %MEMORY, align 4
  %v4451 = load i8, ptr %AL, align 1
  %v4452 = zext i8 %v4451 to i32
  %v4453 = load ptr, ptr %MEMORY, align 4
  %v4454 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWIjE2RnIhLb1EEiEEP6MemoryS6_R5StateT_T0_(ptr %v4453, ptr %state, ptr %EAX, i32 %v4452)
  store ptr %v4454, ptr %MEMORY, align 4
  %v4455 = load ptr, ptr %MEMORY, align 4
  %v4456 = call ptr @__remill_atomic_end(ptr %v4455)
  store ptr %v4456, ptr %MEMORY, align 4
  store i32 %v4448, ptr %PC, align 4
  %v4457 = add i32 %v4448, 3
  store i32 %v4457, ptr %NEXT_PC, align 4
  %v4458 = load ptr, ptr %MEMORY, align 4
  %v4459 = call ptr @__remill_atomic_begin(ptr %v4458)
  store ptr %v4459, ptr %MEMORY, align 4
  %v4460 = load i32, ptr %EAX, align 4
  %v4461 = load ptr, ptr %MEMORY, align 4
  %v4462 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4461, ptr %state, ptr %EAX, i32 %v4460, i32 48)
  store ptr %v4462, ptr %MEMORY, align 4
  %v4463 = load ptr, ptr %MEMORY, align 4
  %v4464 = call ptr @__remill_atomic_end(ptr %v4463)
  store ptr %v4464, ptr %MEMORY, align 4
  store i32 %v4457, ptr %PC, align 4
  %v4465 = add i32 %v4457, 3
  store i32 %v4465, ptr %NEXT_PC, align 4
  %v4466 = load ptr, ptr %MEMORY, align 4
  %v4467 = call ptr @__remill_atomic_begin(ptr %v4466)
  store ptr %v4467, ptr %MEMORY, align 4
  %v4468 = load i32, ptr %EAX, align 4
  %v4469 = load ptr, ptr %MEMORY, align 4
  %v4470 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4469, ptr %state, i32 %v4468, i32 2)
  store ptr %v4470, ptr %MEMORY, align 4
  %v4471 = load ptr, ptr %MEMORY, align 4
  %v4472 = call ptr @__remill_atomic_end(ptr %v4471)
  store ptr %v4472, ptr %MEMORY, align 4
  store i32 %v4465, ptr %PC, align 4
  %v4473 = add i32 %v4465, 2
  store i32 %v4473, ptr %NEXT_PC, align 4
  %v4474 = load ptr, ptr %MEMORY, align 4
  %v4475 = call ptr @__remill_atomic_begin(ptr %v4474)
  store ptr %v4475, ptr %MEMORY, align 4
  %v4476 = add i32 %v4473, 12
  %v4477 = load ptr, ptr %MEMORY, align 4
  %v4478 = call ptr @_ZN12_GLOBAL__N_13JBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4477, ptr %state, ptr %BRANCH_TAKEN, i32 %v4476, i32 %v4473, ptr %NEXT_PC)
  store ptr %v4478, ptr %MEMORY, align 4
  %v4479 = load ptr, ptr %MEMORY, align 4
  %v4480 = call ptr @__remill_atomic_end(ptr %v4479)
  store ptr %v4480, ptr %MEMORY, align 4
  br i1 true, label %bb_4206236, label %bb_4206224

bb_4206224:                                       ; preds = %bb_4206207, %bb_4206177
  %v4481 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4481, ptr %PC, align 4
  %v4482 = add i32 %v4481, 5
  store i32 %v4482, ptr %NEXT_PC, align 4
  %v4483 = load ptr, ptr %MEMORY, align 4
  %v4484 = call ptr @__remill_atomic_begin(ptr %v4483)
  store ptr %v4484, ptr %MEMORY, align 4
  %v4485 = add i32 %v4482, 9640
  %v4486 = load ptr, ptr %MEMORY, align 4
  %v4487 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4486, ptr %state, i64 4215869, ptr %NEXT_PC, i32 %v4482, ptr %RETURN_PC)
  store ptr %v4487, ptr %MEMORY, align 4
  %v4488 = load ptr, ptr %MEMORY, align 4
  %v4489 = call ptr @__remill_atomic_end(ptr %v4488)
  store ptr %v4489, ptr %MEMORY, align 4
  store i32 %v4482, ptr %PC, align 4
  %v4490 = add i32 %v4482, 3
  store i32 %v4490, ptr %NEXT_PC, align 4
  %v4491 = load ptr, ptr %MEMORY, align 4
  %v4492 = call ptr @__remill_atomic_begin(ptr %v4491)
  store ptr %v4492, ptr %MEMORY, align 4
  %v4493 = load i32, ptr %EAX, align 4
  %v4494 = load ptr, ptr %MEMORY, align 4
  %v4495 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4494, ptr %state, ptr %EAX, i32 %v4493, i32 1)
  store ptr %v4495, ptr %MEMORY, align 4
  %v4496 = load ptr, ptr %MEMORY, align 4
  %v4497 = call ptr @__remill_atomic_end(ptr %v4496)
  store ptr %v4497, ptr %MEMORY, align 4
  store i32 %v4490, ptr %PC, align 4
  %v4498 = add i32 %v4490, 2
  store i32 %v4498, ptr %NEXT_PC, align 4
  %v4499 = load ptr, ptr %MEMORY, align 4
  %v4500 = call ptr @__remill_atomic_begin(ptr %v4499)
  store ptr %v4500, ptr %MEMORY, align 4
  %v4501 = load i32, ptr %EAX, align 4
  %v4502 = load i32, ptr %EAX, align 4
  %v4503 = load ptr, ptr %MEMORY, align 4
  %v4504 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4503, ptr %state, i32 %v4501, i32 %v4502)
  store ptr %v4504, ptr %MEMORY, align 4
  %v4505 = load ptr, ptr %MEMORY, align 4
  %v4506 = call ptr @__remill_atomic_end(ptr %v4505)
  store ptr %v4506, ptr %MEMORY, align 4
  store i32 %v4498, ptr %PC, align 4
  %v4507 = add i32 %v4498, 2
  store i32 %v4507, ptr %NEXT_PC, align 4
  %v4508 = load ptr, ptr %MEMORY, align 4
  %v4509 = call ptr @__remill_atomic_begin(ptr %v4508)
  store ptr %v4509, ptr %MEMORY, align 4
  %v4510 = add i32 %v4507, 7
  %v4511 = load ptr, ptr %MEMORY, align 4
  %v4512 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4511, ptr %state, ptr %BRANCH_TAKEN, i32 %v4510, i32 %v4507, ptr %NEXT_PC)
  store ptr %v4512, ptr %MEMORY, align 4
  %v4513 = load ptr, ptr %MEMORY, align 4
  %v4514 = call ptr @__remill_atomic_end(ptr %v4513)
  store ptr %v4514, ptr %MEMORY, align 4
  br i1 true, label %bb_4206243, label %bb_4206236

bb_4206236:                                       ; preds = %bb_4206224, %bb_4206207
  %v4515 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4515, ptr %PC, align 4
  %v4516 = add i32 %v4515, 5
  store i32 %v4516, ptr %NEXT_PC, align 4
  %v4517 = load ptr, ptr %MEMORY, align 4
  %v4518 = call ptr @__remill_atomic_begin(ptr %v4517)
  store ptr %v4518, ptr %MEMORY, align 4
  %v4519 = load ptr, ptr %MEMORY, align 4
  %v4520 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4519, ptr %state, ptr %EAX, i32 2)
  store ptr %v4520, ptr %MEMORY, align 4
  %v4521 = load ptr, ptr %MEMORY, align 4
  %v4522 = call ptr @__remill_atomic_end(ptr %v4521)
  store ptr %v4522, ptr %MEMORY, align 4
  store i32 %v4516, ptr %PC, align 4
  %v4523 = add i32 %v4516, 2
  store i32 %v4523, ptr %NEXT_PC, align 4
  %v4524 = load ptr, ptr %MEMORY, align 4
  %v4525 = call ptr @__remill_atomic_begin(ptr %v4524)
  store ptr %v4525, ptr %MEMORY, align 4
  %v4526 = add i32 %v4523, 5
  %v4527 = load ptr, ptr %MEMORY, align 4
  %v4528 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4527, ptr %state, i32 %v4526, ptr %NEXT_PC)
  store ptr %v4528, ptr %MEMORY, align 4
  %v4529 = load ptr, ptr %MEMORY, align 4
  %v4530 = call ptr @__remill_atomic_end(ptr %v4529)
  store ptr %v4530, ptr %MEMORY, align 4
  br label %bb_4206248

bb_4206243:                                       ; preds = %bb_4206224
  store i32 %v4507, ptr %PC, align 4
  %v4531 = add i32 %v4507, 5
  store i32 %v4531, ptr %NEXT_PC, align 4
  %v4532 = load ptr, ptr %MEMORY, align 4
  %v4533 = call ptr @__remill_atomic_begin(ptr %v4532)
  store ptr %v4533, ptr %MEMORY, align 4
  %v4534 = load ptr, ptr %MEMORY, align 4
  %v4535 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4534, ptr %state, ptr %EAX, i32 3)
  store ptr %v4535, ptr %MEMORY, align 4
  %v4536 = load ptr, ptr %MEMORY, align 4
  %v4537 = call ptr @__remill_atomic_end(ptr %v4536)
  store ptr %v4537, ptr %MEMORY, align 4
  br label %bb_4206248

bb_4206248:                                       ; preds = %bb_4206243, %bb_4206236
  %v4538 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4538, ptr %PC, align 4
  %v4539 = add i32 %v4538, 1
  store i32 %v4539, ptr %NEXT_PC, align 4
  %v4540 = load ptr, ptr %MEMORY, align 4
  %v4541 = call ptr @__remill_atomic_begin(ptr %v4540)
  store ptr %v4541, ptr %MEMORY, align 4
  %v4542 = load ptr, ptr %MEMORY, align 4
  %v4543 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v4542, ptr %state)
  store ptr %v4543, ptr %MEMORY, align 4
  %v4544 = load ptr, ptr %MEMORY, align 4
  %v4545 = call ptr @__remill_atomic_end(ptr %v4544)
  store ptr %v4545, ptr %MEMORY, align 4
  store i32 %v4539, ptr %PC, align 4
  %v4546 = add i32 %v4539, 1
  store i32 %v4546, ptr %NEXT_PC, align 4
  %v4547 = load ptr, ptr %MEMORY, align 4
  %v4548 = call ptr @__remill_atomic_begin(ptr %v4547)
  store ptr %v4548, ptr %MEMORY, align 4
  %v4549 = load ptr, ptr %MEMORY, align 4
  %v4550 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4549, ptr %state, ptr %NEXT_PC)
  store ptr %v4550, ptr %MEMORY, align 4
  %v4551 = load ptr, ptr %MEMORY, align 4
  %v4552 = call ptr @__remill_atomic_end(ptr %v4551)
  store ptr %v4552, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206250:                                       ; No predecessors!
  %v4553 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4553, ptr %PC, align 4
  %v4554 = add i32 %v4553, 1
  store i32 %v4554, ptr %NEXT_PC, align 4
  %v4555 = load ptr, ptr %MEMORY, align 4
  %v4556 = call ptr @__remill_atomic_begin(ptr %v4555)
  store ptr %v4556, ptr %MEMORY, align 4
  %v4557 = load i32, ptr %EBP, align 4
  %v4558 = load ptr, ptr %MEMORY, align 4
  %v4559 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4558, ptr %state, i32 %v4557)
  store ptr %v4559, ptr %MEMORY, align 4
  %v4560 = load ptr, ptr %MEMORY, align 4
  %v4561 = call ptr @__remill_atomic_end(ptr %v4560)
  store ptr %v4561, ptr %MEMORY, align 4
  store i32 %v4554, ptr %PC, align 4
  %v4562 = add i32 %v4554, 2
  store i32 %v4562, ptr %NEXT_PC, align 4
  %v4563 = load ptr, ptr %MEMORY, align 4
  %v4564 = call ptr @__remill_atomic_begin(ptr %v4563)
  store ptr %v4564, ptr %MEMORY, align 4
  %v4565 = load i32, ptr %ESP, align 4
  %v4566 = load ptr, ptr %MEMORY, align 4
  %v4567 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4566, ptr %state, ptr %EBP, i32 %v4565)
  store ptr %v4567, ptr %MEMORY, align 4
  %v4568 = load ptr, ptr %MEMORY, align 4
  %v4569 = call ptr @__remill_atomic_end(ptr %v4568)
  store ptr %v4569, ptr %MEMORY, align 4
  store i32 %v4562, ptr %PC, align 4
  %v4570 = add i32 %v4562, 3
  store i32 %v4570, ptr %NEXT_PC, align 4
  %v4571 = load ptr, ptr %MEMORY, align 4
  %v4572 = call ptr @__remill_atomic_begin(ptr %v4571)
  store ptr %v4572, ptr %MEMORY, align 4
  %v4573 = load i32, ptr %ESP, align 4
  %v4574 = load ptr, ptr %MEMORY, align 4
  %v4575 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4574, ptr %state, ptr %ESP, i32 %v4573, i32 24)
  store ptr %v4575, ptr %MEMORY, align 4
  %v4576 = load ptr, ptr %MEMORY, align 4
  %v4577 = call ptr @__remill_atomic_end(ptr %v4576)
  store ptr %v4577, ptr %MEMORY, align 4
  store i32 %v4570, ptr %PC, align 4
  %v4578 = add i32 %v4570, 3
  store i32 %v4578, ptr %NEXT_PC, align 4
  %v4579 = load ptr, ptr %MEMORY, align 4
  %v4580 = call ptr @__remill_atomic_begin(ptr %v4579)
  store ptr %v4580, ptr %MEMORY, align 4
  %v4581 = load i32, ptr %EBP, align 4
  %v4582 = load i32, ptr %SSBASE, align 4
  %v4583 = add i32 %v4581, 12
  %v4584 = add i32 %v4583, %v4582
  %v4585 = load ptr, ptr %MEMORY, align 4
  %v4586 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4585, ptr %state, ptr %EAX, i32 %v4584)
  store ptr %v4586, ptr %MEMORY, align 4
  %v4587 = load ptr, ptr %MEMORY, align 4
  %v4588 = call ptr @__remill_atomic_end(ptr %v4587)
  store ptr %v4588, ptr %MEMORY, align 4
  store i32 %v4578, ptr %PC, align 4
  %v4589 = add i32 %v4578, 3
  store i32 %v4589, ptr %NEXT_PC, align 4
  %v4590 = load ptr, ptr %MEMORY, align 4
  %v4591 = call ptr @__remill_atomic_begin(ptr %v4590)
  store ptr %v4591, ptr %MEMORY, align 4
  %v4592 = load i32, ptr %EAX, align 4
  %v4593 = load i32, ptr %DSBASE, align 4
  %v4594 = add i32 %v4592, 4
  %v4595 = add i32 %v4594, %v4593
  %v4596 = load ptr, ptr %MEMORY, align 4
  %v4597 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4596, ptr %state, ptr %EAX, i32 %v4595)
  store ptr %v4597, ptr %MEMORY, align 4
  %v4598 = load ptr, ptr %MEMORY, align 4
  %v4599 = call ptr @__remill_atomic_end(ptr %v4598)
  store ptr %v4599, ptr %MEMORY, align 4
  store i32 %v4589, ptr %PC, align 4
  %v4600 = add i32 %v4589, 5
  store i32 %v4600, ptr %NEXT_PC, align 4
  %v4601 = load ptr, ptr %MEMORY, align 4
  %v4602 = call ptr @__remill_atomic_begin(ptr %v4601)
  store ptr %v4602, ptr %MEMORY, align 4
  %v4603 = load i32, ptr %EAX, align 4
  %v4604 = load ptr, ptr %MEMORY, align 4
  %v4605 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4604, ptr %state, ptr %EAX, i32 %v4603, i32 8192)
  store ptr %v4605, ptr %MEMORY, align 4
  %v4606 = load ptr, ptr %MEMORY, align 4
  %v4607 = call ptr @__remill_atomic_end(ptr %v4606)
  store ptr %v4607, ptr %MEMORY, align 4
  store i32 %v4600, ptr %PC, align 4
  %v4608 = add i32 %v4600, 2
  store i32 %v4608, ptr %NEXT_PC, align 4
  %v4609 = load ptr, ptr %MEMORY, align 4
  %v4610 = call ptr @__remill_atomic_begin(ptr %v4609)
  store ptr %v4610, ptr %MEMORY, align 4
  %v4611 = load i32, ptr %EAX, align 4
  %v4612 = load i32, ptr %EAX, align 4
  %v4613 = load ptr, ptr %MEMORY, align 4
  %v4614 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4613, ptr %state, i32 %v4611, i32 %v4612)
  store ptr %v4614, ptr %MEMORY, align 4
  %v4615 = load ptr, ptr %MEMORY, align 4
  %v4616 = call ptr @__remill_atomic_end(ptr %v4615)
  store ptr %v4616, ptr %MEMORY, align 4
  store i32 %v4608, ptr %PC, align 4
  %v4617 = add i32 %v4608, 2
  store i32 %v4617, ptr %NEXT_PC, align 4
  %v4618 = load ptr, ptr %MEMORY, align 4
  %v4619 = call ptr @__remill_atomic_begin(ptr %v4618)
  store ptr %v4619, ptr %MEMORY, align 4
  %v4620 = add i32 %v4617, 16
  %v4621 = load ptr, ptr %MEMORY, align 4
  %v4622 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4621, ptr %state, ptr %BRANCH_TAKEN, i32 %v4620, i32 %v4617, ptr %NEXT_PC)
  store ptr %v4622, ptr %MEMORY, align 4
  %v4623 = load ptr, ptr %MEMORY, align 4
  %v4624 = call ptr @__remill_atomic_end(ptr %v4623)
  store ptr %v4624, ptr %MEMORY, align 4
  br i1 true, label %bb_4206287, label %bb_4206271

bb_4206271:                                       ; preds = %bb_4206250
  store i32 %v4617, ptr %PC, align 4
  %v4625 = add i32 %v4617, 3
  store i32 %v4625, ptr %NEXT_PC, align 4
  %v4626 = load ptr, ptr %MEMORY, align 4
  %v4627 = call ptr @__remill_atomic_begin(ptr %v4626)
  store ptr %v4627, ptr %MEMORY, align 4
  %v4628 = load i32, ptr %EBP, align 4
  %v4629 = load i32, ptr %SSBASE, align 4
  %v4630 = add i32 %v4628, 12
  %v4631 = add i32 %v4630, %v4629
  %v4632 = load ptr, ptr %MEMORY, align 4
  %v4633 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4632, ptr %state, ptr %EAX, i32 %v4631)
  store ptr %v4633, ptr %MEMORY, align 4
  %v4634 = load ptr, ptr %MEMORY, align 4
  %v4635 = call ptr @__remill_atomic_end(ptr %v4634)
  store ptr %v4635, ptr %MEMORY, align 4
  store i32 %v4625, ptr %PC, align 4
  %v4636 = add i32 %v4625, 3
  store i32 %v4636, ptr %NEXT_PC, align 4
  %v4637 = load ptr, ptr %MEMORY, align 4
  %v4638 = call ptr @__remill_atomic_begin(ptr %v4637)
  store ptr %v4638, ptr %MEMORY, align 4
  %v4639 = load i32, ptr %EAX, align 4
  %v4640 = load i32, ptr %DSBASE, align 4
  %v4641 = add i32 %v4639, 36
  %v4642 = add i32 %v4641, %v4640
  %v4643 = load ptr, ptr %MEMORY, align 4
  %v4644 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4643, ptr %state, ptr %EDX, i32 %v4642)
  store ptr %v4644, ptr %MEMORY, align 4
  %v4645 = load ptr, ptr %MEMORY, align 4
  %v4646 = call ptr @__remill_atomic_end(ptr %v4645)
  store ptr %v4646, ptr %MEMORY, align 4
  store i32 %v4636, ptr %PC, align 4
  %v4647 = add i32 %v4636, 3
  store i32 %v4647, ptr %NEXT_PC, align 4
  %v4648 = load ptr, ptr %MEMORY, align 4
  %v4649 = call ptr @__remill_atomic_begin(ptr %v4648)
  store ptr %v4649, ptr %MEMORY, align 4
  %v4650 = load i32, ptr %EBP, align 4
  %v4651 = load i32, ptr %SSBASE, align 4
  %v4652 = add i32 %v4650, 12
  %v4653 = add i32 %v4652, %v4651
  %v4654 = load ptr, ptr %MEMORY, align 4
  %v4655 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4654, ptr %state, ptr %EAX, i32 %v4653)
  store ptr %v4655, ptr %MEMORY, align 4
  %v4656 = load ptr, ptr %MEMORY, align 4
  %v4657 = call ptr @__remill_atomic_end(ptr %v4656)
  store ptr %v4657, ptr %MEMORY, align 4
  store i32 %v4647, ptr %PC, align 4
  %v4658 = add i32 %v4647, 3
  store i32 %v4658, ptr %NEXT_PC, align 4
  %v4659 = load ptr, ptr %MEMORY, align 4
  %v4660 = call ptr @__remill_atomic_begin(ptr %v4659)
  store ptr %v4660, ptr %MEMORY, align 4
  %v4661 = load i32, ptr %EAX, align 4
  %v4662 = load i32, ptr %DSBASE, align 4
  %v4663 = add i32 %v4661, 32
  %v4664 = add i32 %v4663, %v4662
  %v4665 = load ptr, ptr %MEMORY, align 4
  %v4666 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4665, ptr %state, ptr %EAX, i32 %v4664)
  store ptr %v4666, ptr %MEMORY, align 4
  %v4667 = load ptr, ptr %MEMORY, align 4
  %v4668 = call ptr @__remill_atomic_end(ptr %v4667)
  store ptr %v4668, ptr %MEMORY, align 4
  store i32 %v4658, ptr %PC, align 4
  %v4669 = add i32 %v4658, 2
  store i32 %v4669, ptr %NEXT_PC, align 4
  %v4670 = load ptr, ptr %MEMORY, align 4
  %v4671 = call ptr @__remill_atomic_begin(ptr %v4670)
  store ptr %v4671, ptr %MEMORY, align 4
  %v4672 = load i32, ptr %EDX, align 4
  %v4673 = load i32, ptr %EAX, align 4
  %v4674 = load ptr, ptr %MEMORY, align 4
  %v4675 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4674, ptr %state, i32 %v4672, i32 %v4673)
  store ptr %v4675, ptr %MEMORY, align 4
  %v4676 = load ptr, ptr %MEMORY, align 4
  %v4677 = call ptr @__remill_atomic_end(ptr %v4676)
  store ptr %v4677, ptr %MEMORY, align 4
  store i32 %v4669, ptr %PC, align 4
  %v4678 = add i32 %v4669, 2
  store i32 %v4678, ptr %NEXT_PC, align 4
  %v4679 = load ptr, ptr %MEMORY, align 4
  %v4680 = call ptr @__remill_atomic_begin(ptr %v4679)
  store ptr %v4680, ptr %MEMORY, align 4
  %v4681 = add i32 %v4678, 55
  %v4682 = load ptr, ptr %MEMORY, align 4
  %v4683 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4682, ptr %state, ptr %BRANCH_TAKEN, i32 %v4681, i32 %v4678, ptr %NEXT_PC)
  store ptr %v4683, ptr %MEMORY, align 4
  %v4684 = load ptr, ptr %MEMORY, align 4
  %v4685 = call ptr @__remill_atomic_end(ptr %v4684)
  store ptr %v4685, ptr %MEMORY, align 4
  br i1 true, label %bb_4206342, label %bb_4206287

bb_4206287:                                       ; preds = %bb_4206271, %bb_4206250
  %v4686 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4686, ptr %PC, align 4
  %v4687 = add i32 %v4686, 3
  store i32 %v4687, ptr %NEXT_PC, align 4
  %v4688 = load ptr, ptr %MEMORY, align 4
  %v4689 = call ptr @__remill_atomic_begin(ptr %v4688)
  store ptr %v4689, ptr %MEMORY, align 4
  %v4690 = load i32, ptr %EBP, align 4
  %v4691 = load i32, ptr %SSBASE, align 4
  %v4692 = add i32 %v4690, 12
  %v4693 = add i32 %v4692, %v4691
  %v4694 = load ptr, ptr %MEMORY, align 4
  %v4695 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4694, ptr %state, ptr %EAX, i32 %v4693)
  store ptr %v4695, ptr %MEMORY, align 4
  %v4696 = load ptr, ptr %MEMORY, align 4
  %v4697 = call ptr @__remill_atomic_end(ptr %v4696)
  store ptr %v4697, ptr %MEMORY, align 4
  store i32 %v4687, ptr %PC, align 4
  %v4698 = add i32 %v4687, 3
  store i32 %v4698, ptr %NEXT_PC, align 4
  %v4699 = load ptr, ptr %MEMORY, align 4
  %v4700 = call ptr @__remill_atomic_begin(ptr %v4699)
  store ptr %v4700, ptr %MEMORY, align 4
  %v4701 = load i32, ptr %EAX, align 4
  %v4702 = load i32, ptr %DSBASE, align 4
  %v4703 = add i32 %v4701, 4
  %v4704 = add i32 %v4703, %v4702
  %v4705 = load ptr, ptr %MEMORY, align 4
  %v4706 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4705, ptr %state, ptr %EAX, i32 %v4704)
  store ptr %v4706, ptr %MEMORY, align 4
  %v4707 = load ptr, ptr %MEMORY, align 4
  %v4708 = call ptr @__remill_atomic_end(ptr %v4707)
  store ptr %v4708, ptr %MEMORY, align 4
  store i32 %v4698, ptr %PC, align 4
  %v4709 = add i32 %v4698, 5
  store i32 %v4709, ptr %NEXT_PC, align 4
  %v4710 = load ptr, ptr %MEMORY, align 4
  %v4711 = call ptr @__remill_atomic_begin(ptr %v4710)
  store ptr %v4711, ptr %MEMORY, align 4
  %v4712 = load i32, ptr %EAX, align 4
  %v4713 = load ptr, ptr %MEMORY, align 4
  %v4714 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4713, ptr %state, ptr %EAX, i32 %v4712, i32 4096)
  store ptr %v4714, ptr %MEMORY, align 4
  %v4715 = load ptr, ptr %MEMORY, align 4
  %v4716 = call ptr @__remill_atomic_end(ptr %v4715)
  store ptr %v4716, ptr %MEMORY, align 4
  store i32 %v4709, ptr %PC, align 4
  %v4717 = add i32 %v4709, 2
  store i32 %v4717, ptr %NEXT_PC, align 4
  %v4718 = load ptr, ptr %MEMORY, align 4
  %v4719 = call ptr @__remill_atomic_begin(ptr %v4718)
  store ptr %v4719, ptr %MEMORY, align 4
  %v4720 = load i32, ptr %EAX, align 4
  %v4721 = load i32, ptr %EAX, align 4
  %v4722 = load ptr, ptr %MEMORY, align 4
  %v4723 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4722, ptr %state, i32 %v4720, i32 %v4721)
  store ptr %v4723, ptr %MEMORY, align 4
  %v4724 = load ptr, ptr %MEMORY, align 4
  %v4725 = call ptr @__remill_atomic_end(ptr %v4724)
  store ptr %v4725, ptr %MEMORY, align 4
  store i32 %v4717, ptr %PC, align 4
  %v4726 = add i32 %v4717, 2
  store i32 %v4726, ptr %NEXT_PC, align 4
  %v4727 = load ptr, ptr %MEMORY, align 4
  %v4728 = call ptr @__remill_atomic_begin(ptr %v4727)
  store ptr %v4728, ptr %MEMORY, align 4
  %v4729 = add i32 %v4726, 22
  %v4730 = load ptr, ptr %MEMORY, align 4
  %v4731 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4730, ptr %state, ptr %BRANCH_TAKEN, i32 %v4729, i32 %v4726, ptr %NEXT_PC)
  store ptr %v4731, ptr %MEMORY, align 4
  %v4732 = load ptr, ptr %MEMORY, align 4
  %v4733 = call ptr @__remill_atomic_end(ptr %v4732)
  store ptr %v4733, ptr %MEMORY, align 4
  br i1 true, label %bb_4206324, label %bb_4206302

bb_4206302:                                       ; preds = %bb_4206287
  store i32 %v4726, ptr %PC, align 4
  %v4734 = add i32 %v4726, 3
  store i32 %v4734, ptr %NEXT_PC, align 4
  %v4735 = load ptr, ptr %MEMORY, align 4
  %v4736 = call ptr @__remill_atomic_begin(ptr %v4735)
  store ptr %v4736, ptr %MEMORY, align 4
  %v4737 = load i32, ptr %EBP, align 4
  %v4738 = load i32, ptr %SSBASE, align 4
  %v4739 = add i32 %v4737, 12
  %v4740 = add i32 %v4739, %v4738
  %v4741 = load ptr, ptr %MEMORY, align 4
  %v4742 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4741, ptr %state, ptr %EAX, i32 %v4740)
  store ptr %v4742, ptr %MEMORY, align 4
  %v4743 = load ptr, ptr %MEMORY, align 4
  %v4744 = call ptr @__remill_atomic_end(ptr %v4743)
  store ptr %v4744, ptr %MEMORY, align 4
  store i32 %v4734, ptr %PC, align 4
  %v4745 = add i32 %v4734, 2
  store i32 %v4745, ptr %NEXT_PC, align 4
  %v4746 = load ptr, ptr %MEMORY, align 4
  %v4747 = call ptr @__remill_atomic_begin(ptr %v4746)
  store ptr %v4747, ptr %MEMORY, align 4
  %v4748 = load i32, ptr %EAX, align 4
  %v4749 = load i32, ptr %DSBASE, align 4
  %v4750 = add i32 %v4748, %v4749
  %v4751 = load ptr, ptr %MEMORY, align 4
  %v4752 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4751, ptr %state, ptr %EAX, i32 %v4750)
  store ptr %v4752, ptr %MEMORY, align 4
  %v4753 = load ptr, ptr %MEMORY, align 4
  %v4754 = call ptr @__remill_atomic_end(ptr %v4753)
  store ptr %v4754, ptr %MEMORY, align 4
  store i32 %v4745, ptr %PC, align 4
  %v4755 = add i32 %v4745, 4
  store i32 %v4755, ptr %NEXT_PC, align 4
  %v4756 = load ptr, ptr %MEMORY, align 4
  %v4757 = call ptr @__remill_atomic_begin(ptr %v4756)
  store ptr %v4757, ptr %MEMORY, align 4
  %v4758 = load i32, ptr %ESP, align 4
  %v4759 = load i32, ptr %SSBASE, align 4
  %v4760 = add i32 %v4758, 4
  %v4761 = add i32 %v4760, %v4759
  %v4762 = load i32, ptr %EAX, align 4
  %v4763 = load ptr, ptr %MEMORY, align 4
  %v4764 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4763, ptr %state, i32 %v4761, i32 %v4762)
  store ptr %v4764, ptr %MEMORY, align 4
  %v4765 = load ptr, ptr %MEMORY, align 4
  %v4766 = call ptr @__remill_atomic_end(ptr %v4765)
  store ptr %v4766, ptr %MEMORY, align 4
  store i32 %v4755, ptr %PC, align 4
  %v4767 = add i32 %v4755, 3
  store i32 %v4767, ptr %NEXT_PC, align 4
  %v4768 = load ptr, ptr %MEMORY, align 4
  %v4769 = call ptr @__remill_atomic_begin(ptr %v4768)
  store ptr %v4769, ptr %MEMORY, align 4
  %v4770 = load i32, ptr %EBP, align 4
  %v4771 = load i32, ptr %SSBASE, align 4
  %v4772 = add i32 %v4770, 8
  %v4773 = add i32 %v4772, %v4771
  %v4774 = load ptr, ptr %MEMORY, align 4
  %v4775 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4774, ptr %state, ptr %EAX, i32 %v4773)
  store ptr %v4775, ptr %MEMORY, align 4
  %v4776 = load ptr, ptr %MEMORY, align 4
  %v4777 = call ptr @__remill_atomic_end(ptr %v4776)
  store ptr %v4777, ptr %MEMORY, align 4
  store i32 %v4767, ptr %PC, align 4
  %v4778 = add i32 %v4767, 3
  store i32 %v4778, ptr %NEXT_PC, align 4
  %v4779 = load ptr, ptr %MEMORY, align 4
  %v4780 = call ptr @__remill_atomic_begin(ptr %v4779)
  store ptr %v4780, ptr %MEMORY, align 4
  %v4781 = load i32, ptr %ESP, align 4
  %v4782 = load i32, ptr %SSBASE, align 4
  %v4783 = add i32 %v4781, %v4782
  %v4784 = load i32, ptr %EAX, align 4
  %v4785 = load ptr, ptr %MEMORY, align 4
  %v4786 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4785, ptr %state, i32 %v4783, i32 %v4784)
  store ptr %v4786, ptr %MEMORY, align 4
  %v4787 = load ptr, ptr %MEMORY, align 4
  %v4788 = call ptr @__remill_atomic_end(ptr %v4787)
  store ptr %v4788, ptr %MEMORY, align 4
  store i32 %v4778, ptr %PC, align 4
  %v4789 = add i32 %v4778, 5
  store i32 %v4789, ptr %NEXT_PC, align 4
  %v4790 = load ptr, ptr %MEMORY, align 4
  %v4791 = call ptr @__remill_atomic_begin(ptr %v4790)
  store ptr %v4791, ptr %MEMORY, align 4
  %v4792 = add i32 %v4789, 22354
  %v4793 = load ptr, ptr %MEMORY, align 4
  %v4794 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4793, ptr %state, i64 4228676, ptr %NEXT_PC, i32 %v4789, ptr %RETURN_PC)
  store ptr %v4794, ptr %MEMORY, align 4
  %v4795 = load ptr, ptr %MEMORY, align 4
  %v4796 = call ptr @__remill_atomic_end(ptr %v4795)
  store ptr %v4796, ptr %MEMORY, align 4
  store i32 %v4789, ptr %PC, align 4
  %v4797 = add i32 %v4789, 2
  store i32 %v4797, ptr %NEXT_PC, align 4
  %v4798 = load ptr, ptr %MEMORY, align 4
  %v4799 = call ptr @__remill_atomic_begin(ptr %v4798)
  store ptr %v4799, ptr %MEMORY, align 4
  %v4800 = add i32 %v4797, 18
  %v4801 = load ptr, ptr %MEMORY, align 4
  %v4802 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4801, ptr %state, i32 %v4800, ptr %NEXT_PC)
  store ptr %v4802, ptr %MEMORY, align 4
  %v4803 = load ptr, ptr %MEMORY, align 4
  %v4804 = call ptr @__remill_atomic_end(ptr %v4803)
  store ptr %v4804, ptr %MEMORY, align 4
  br label %bb_4206342

bb_4206324:                                       ; preds = %bb_4206287
  store i32 %v4726, ptr %PC, align 4
  %v4805 = add i32 %v4726, 3
  store i32 %v4805, ptr %NEXT_PC, align 4
  %v4806 = load ptr, ptr %MEMORY, align 4
  %v4807 = call ptr @__remill_atomic_begin(ptr %v4806)
  store ptr %v4807, ptr %MEMORY, align 4
  %v4808 = load i32, ptr %EBP, align 4
  %v4809 = load i32, ptr %SSBASE, align 4
  %v4810 = add i32 %v4808, 12
  %v4811 = add i32 %v4810, %v4809
  %v4812 = load ptr, ptr %MEMORY, align 4
  %v4813 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4812, ptr %state, ptr %EAX, i32 %v4811)
  store ptr %v4813, ptr %MEMORY, align 4
  %v4814 = load ptr, ptr %MEMORY, align 4
  %v4815 = call ptr @__remill_atomic_end(ptr %v4814)
  store ptr %v4815, ptr %MEMORY, align 4
  store i32 %v4805, ptr %PC, align 4
  %v4816 = add i32 %v4805, 2
  store i32 %v4816, ptr %NEXT_PC, align 4
  %v4817 = load ptr, ptr %MEMORY, align 4
  %v4818 = call ptr @__remill_atomic_begin(ptr %v4817)
  store ptr %v4818, ptr %MEMORY, align 4
  %v4819 = load i32, ptr %EAX, align 4
  %v4820 = load i32, ptr %DSBASE, align 4
  %v4821 = add i32 %v4819, %v4820
  %v4822 = load ptr, ptr %MEMORY, align 4
  %v4823 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4822, ptr %state, ptr %EDX, i32 %v4821)
  store ptr %v4823, ptr %MEMORY, align 4
  %v4824 = load ptr, ptr %MEMORY, align 4
  %v4825 = call ptr @__remill_atomic_end(ptr %v4824)
  store ptr %v4825, ptr %MEMORY, align 4
  store i32 %v4816, ptr %PC, align 4
  %v4826 = add i32 %v4816, 3
  store i32 %v4826, ptr %NEXT_PC, align 4
  %v4827 = load ptr, ptr %MEMORY, align 4
  %v4828 = call ptr @__remill_atomic_begin(ptr %v4827)
  store ptr %v4828, ptr %MEMORY, align 4
  %v4829 = load i32, ptr %EBP, align 4
  %v4830 = load i32, ptr %SSBASE, align 4
  %v4831 = add i32 %v4829, 12
  %v4832 = add i32 %v4831, %v4830
  %v4833 = load ptr, ptr %MEMORY, align 4
  %v4834 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4833, ptr %state, ptr %EAX, i32 %v4832)
  store ptr %v4834, ptr %MEMORY, align 4
  %v4835 = load ptr, ptr %MEMORY, align 4
  %v4836 = call ptr @__remill_atomic_end(ptr %v4835)
  store ptr %v4836, ptr %MEMORY, align 4
  store i32 %v4826, ptr %PC, align 4
  %v4837 = add i32 %v4826, 3
  store i32 %v4837, ptr %NEXT_PC, align 4
  %v4838 = load ptr, ptr %MEMORY, align 4
  %v4839 = call ptr @__remill_atomic_begin(ptr %v4838)
  store ptr %v4839, ptr %MEMORY, align 4
  %v4840 = load i32, ptr %EAX, align 4
  %v4841 = load i32, ptr %DSBASE, align 4
  %v4842 = add i32 %v4840, 32
  %v4843 = add i32 %v4842, %v4841
  %v4844 = load ptr, ptr %MEMORY, align 4
  %v4845 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4844, ptr %state, ptr %EAX, i32 %v4843)
  store ptr %v4845, ptr %MEMORY, align 4
  %v4846 = load ptr, ptr %MEMORY, align 4
  %v4847 = call ptr @__remill_atomic_end(ptr %v4846)
  store ptr %v4847, ptr %MEMORY, align 4
  store i32 %v4837, ptr %PC, align 4
  %v4848 = add i32 %v4837, 2
  store i32 %v4848, ptr %NEXT_PC, align 4
  %v4849 = load ptr, ptr %MEMORY, align 4
  %v4850 = call ptr @__remill_atomic_begin(ptr %v4849)
  store ptr %v4850, ptr %MEMORY, align 4
  %v4851 = load i32, ptr %EDX, align 4
  %v4852 = load i32, ptr %EAX, align 4
  %v4853 = load ptr, ptr %MEMORY, align 4
  %v4854 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4853, ptr %state, ptr %EDX, i32 %v4851, i32 %v4852)
  store ptr %v4854, ptr %MEMORY, align 4
  %v4855 = load ptr, ptr %MEMORY, align 4
  %v4856 = call ptr @__remill_atomic_end(ptr %v4855)
  store ptr %v4856, ptr %MEMORY, align 4
  store i32 %v4848, ptr %PC, align 4
  %v4857 = add i32 %v4848, 3
  store i32 %v4857, ptr %NEXT_PC, align 4
  %v4858 = load ptr, ptr %MEMORY, align 4
  %v4859 = call ptr @__remill_atomic_begin(ptr %v4858)
  store ptr %v4859, ptr %MEMORY, align 4
  %v4860 = load i32, ptr %EBP, align 4
  %v4861 = load i32, ptr %SSBASE, align 4
  %v4862 = add i32 %v4860, 8
  %v4863 = add i32 %v4862, %v4861
  %v4864 = load ptr, ptr %MEMORY, align 4
  %v4865 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4864, ptr %state, ptr %EAX, i32 %v4863)
  store ptr %v4865, ptr %MEMORY, align 4
  %v4866 = load ptr, ptr %MEMORY, align 4
  %v4867 = call ptr @__remill_atomic_end(ptr %v4866)
  store ptr %v4867, ptr %MEMORY, align 4
  store i32 %v4857, ptr %PC, align 4
  %v4868 = add i32 %v4857, 2
  store i32 %v4868, ptr %NEXT_PC, align 4
  %v4869 = load ptr, ptr %MEMORY, align 4
  %v4870 = call ptr @__remill_atomic_begin(ptr %v4869)
  store ptr %v4870, ptr %MEMORY, align 4
  %v4871 = load i32, ptr %EDX, align 4
  %v4872 = load i32, ptr %DSBASE, align 4
  %v4873 = add i32 %v4871, %v4872
  %v4874 = load i8, ptr %AL, align 1
  %v4875 = zext i8 %v4874 to i32
  %v4876 = load ptr, ptr %MEMORY, align 4
  %v4877 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4876, ptr %state, i32 %v4873, i32 %v4875)
  store ptr %v4877, ptr %MEMORY, align 4
  %v4878 = load ptr, ptr %MEMORY, align 4
  %v4879 = call ptr @__remill_atomic_end(ptr %v4878)
  store ptr %v4879, ptr %MEMORY, align 4
  br label %bb_4206342

bb_4206342:                                       ; preds = %bb_4206324, %bb_4206302, %bb_4206271
  %v4880 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4880, ptr %PC, align 4
  %v4881 = add i32 %v4880, 3
  store i32 %v4881, ptr %NEXT_PC, align 4
  %v4882 = load ptr, ptr %MEMORY, align 4
  %v4883 = call ptr @__remill_atomic_begin(ptr %v4882)
  store ptr %v4883, ptr %MEMORY, align 4
  %v4884 = load i32, ptr %EBP, align 4
  %v4885 = load i32, ptr %SSBASE, align 4
  %v4886 = add i32 %v4884, 12
  %v4887 = add i32 %v4886, %v4885
  %v4888 = load ptr, ptr %MEMORY, align 4
  %v4889 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4888, ptr %state, ptr %EAX, i32 %v4887)
  store ptr %v4889, ptr %MEMORY, align 4
  %v4890 = load ptr, ptr %MEMORY, align 4
  %v4891 = call ptr @__remill_atomic_end(ptr %v4890)
  store ptr %v4891, ptr %MEMORY, align 4
  store i32 %v4881, ptr %PC, align 4
  %v4892 = add i32 %v4881, 3
  store i32 %v4892, ptr %NEXT_PC, align 4
  %v4893 = load ptr, ptr %MEMORY, align 4
  %v4894 = call ptr @__remill_atomic_begin(ptr %v4893)
  store ptr %v4894, ptr %MEMORY, align 4
  %v4895 = load i32, ptr %EAX, align 4
  %v4896 = load i32, ptr %DSBASE, align 4
  %v4897 = add i32 %v4895, 32
  %v4898 = add i32 %v4897, %v4896
  %v4899 = load ptr, ptr %MEMORY, align 4
  %v4900 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4899, ptr %state, ptr %EAX, i32 %v4898)
  store ptr %v4900, ptr %MEMORY, align 4
  %v4901 = load ptr, ptr %MEMORY, align 4
  %v4902 = call ptr @__remill_atomic_end(ptr %v4901)
  store ptr %v4902, ptr %MEMORY, align 4
  store i32 %v4892, ptr %PC, align 4
  %v4903 = add i32 %v4892, 3
  store i32 %v4903, ptr %NEXT_PC, align 4
  %v4904 = load ptr, ptr %MEMORY, align 4
  %v4905 = call ptr @__remill_atomic_begin(ptr %v4904)
  store ptr %v4905, ptr %MEMORY, align 4
  %v4906 = load i32, ptr %EAX, align 4
  %v4907 = add i32 %v4906, 1
  %v4908 = load ptr, ptr %MEMORY, align 4
  %v4909 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4908, ptr %state, ptr %EDX, i32 %v4907)
  store ptr %v4909, ptr %MEMORY, align 4
  %v4910 = load ptr, ptr %MEMORY, align 4
  %v4911 = call ptr @__remill_atomic_end(ptr %v4910)
  store ptr %v4911, ptr %MEMORY, align 4
  store i32 %v4903, ptr %PC, align 4
  %v4912 = add i32 %v4903, 3
  store i32 %v4912, ptr %NEXT_PC, align 4
  %v4913 = load ptr, ptr %MEMORY, align 4
  %v4914 = call ptr @__remill_atomic_begin(ptr %v4913)
  store ptr %v4914, ptr %MEMORY, align 4
  %v4915 = load i32, ptr %EBP, align 4
  %v4916 = load i32, ptr %SSBASE, align 4
  %v4917 = add i32 %v4915, 12
  %v4918 = add i32 %v4917, %v4916
  %v4919 = load ptr, ptr %MEMORY, align 4
  %v4920 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4919, ptr %state, ptr %EAX, i32 %v4918)
  store ptr %v4920, ptr %MEMORY, align 4
  %v4921 = load ptr, ptr %MEMORY, align 4
  %v4922 = call ptr @__remill_atomic_end(ptr %v4921)
  store ptr %v4922, ptr %MEMORY, align 4
  store i32 %v4912, ptr %PC, align 4
  %v4923 = add i32 %v4912, 3
  store i32 %v4923, ptr %NEXT_PC, align 4
  %v4924 = load ptr, ptr %MEMORY, align 4
  %v4925 = call ptr @__remill_atomic_begin(ptr %v4924)
  store ptr %v4925, ptr %MEMORY, align 4
  %v4926 = load i32, ptr %EAX, align 4
  %v4927 = load i32, ptr %DSBASE, align 4
  %v4928 = add i32 %v4926, 32
  %v4929 = add i32 %v4928, %v4927
  %v4930 = load i32, ptr %EDX, align 4
  %v4931 = load ptr, ptr %MEMORY, align 4
  %v4932 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4931, ptr %state, i32 %v4929, i32 %v4930)
  store ptr %v4932, ptr %MEMORY, align 4
  %v4933 = load ptr, ptr %MEMORY, align 4
  %v4934 = call ptr @__remill_atomic_end(ptr %v4933)
  store ptr %v4934, ptr %MEMORY, align 4
  store i32 %v4923, ptr %PC, align 4
  %v4935 = add i32 %v4923, 1
  store i32 %v4935, ptr %NEXT_PC, align 4
  %v4936 = load ptr, ptr %MEMORY, align 4
  %v4937 = call ptr @__remill_atomic_begin(ptr %v4936)
  store ptr %v4937, ptr %MEMORY, align 4
  %v4938 = load ptr, ptr %MEMORY, align 4
  %v4939 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v4938, ptr %state)
  store ptr %v4939, ptr %MEMORY, align 4
  %v4940 = load ptr, ptr %MEMORY, align 4
  %v4941 = call ptr @__remill_atomic_end(ptr %v4940)
  store ptr %v4941, ptr %MEMORY, align 4
  store i32 %v4935, ptr %PC, align 4
  %v4942 = add i32 %v4935, 1
  store i32 %v4942, ptr %NEXT_PC, align 4
  %v4943 = load ptr, ptr %MEMORY, align 4
  %v4944 = call ptr @__remill_atomic_begin(ptr %v4943)
  store ptr %v4944, ptr %MEMORY, align 4
  %v4945 = load ptr, ptr %MEMORY, align 4
  %v4946 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4945, ptr %state, ptr %NEXT_PC)
  store ptr %v4946, ptr %MEMORY, align 4
  %v4947 = load ptr, ptr %MEMORY, align 4
  %v4948 = call ptr @__remill_atomic_end(ptr %v4947)
  store ptr %v4948, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206359:                                       ; No predecessors!
  %v4949 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4949, ptr %PC, align 4
  %v4950 = add i32 %v4949, 1
  store i32 %v4950, ptr %NEXT_PC, align 4
  %v4951 = load ptr, ptr %MEMORY, align 4
  %v4952 = call ptr @__remill_atomic_begin(ptr %v4951)
  store ptr %v4952, ptr %MEMORY, align 4
  %v4953 = load i32, ptr %EBP, align 4
  %v4954 = load ptr, ptr %MEMORY, align 4
  %v4955 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4954, ptr %state, i32 %v4953)
  store ptr %v4955, ptr %MEMORY, align 4
  %v4956 = load ptr, ptr %MEMORY, align 4
  %v4957 = call ptr @__remill_atomic_end(ptr %v4956)
  store ptr %v4957, ptr %MEMORY, align 4
  store i32 %v4950, ptr %PC, align 4
  %v4958 = add i32 %v4950, 2
  store i32 %v4958, ptr %NEXT_PC, align 4
  %v4959 = load ptr, ptr %MEMORY, align 4
  %v4960 = call ptr @__remill_atomic_begin(ptr %v4959)
  store ptr %v4960, ptr %MEMORY, align 4
  %v4961 = load i32, ptr %ESP, align 4
  %v4962 = load ptr, ptr %MEMORY, align 4
  %v4963 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4962, ptr %state, ptr %EBP, i32 %v4961)
  store ptr %v4963, ptr %MEMORY, align 4
  %v4964 = load ptr, ptr %MEMORY, align 4
  %v4965 = call ptr @__remill_atomic_end(ptr %v4964)
  store ptr %v4965, ptr %MEMORY, align 4
  store i32 %v4958, ptr %PC, align 4
  %v4966 = add i32 %v4958, 3
  store i32 %v4966, ptr %NEXT_PC, align 4
  %v4967 = load ptr, ptr %MEMORY, align 4
  %v4968 = call ptr @__remill_atomic_begin(ptr %v4967)
  store ptr %v4968, ptr %MEMORY, align 4
  %v4969 = load i32, ptr %ESP, align 4
  %v4970 = load ptr, ptr %MEMORY, align 4
  %v4971 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4970, ptr %state, ptr %ESP, i32 %v4969, i32 24)
  store ptr %v4971, ptr %MEMORY, align 4
  %v4972 = load ptr, ptr %MEMORY, align 4
  %v4973 = call ptr @__remill_atomic_end(ptr %v4972)
  store ptr %v4973, ptr %MEMORY, align 4
  store i32 %v4966, ptr %PC, align 4
  %v4974 = add i32 %v4966, 3
  store i32 %v4974, ptr %NEXT_PC, align 4
  %v4975 = load ptr, ptr %MEMORY, align 4
  %v4976 = call ptr @__remill_atomic_begin(ptr %v4975)
  store ptr %v4976, ptr %MEMORY, align 4
  %v4977 = load i32, ptr %EBP, align 4
  %v4978 = load i32, ptr %SSBASE, align 4
  %v4979 = add i32 %v4977, 16
  %v4980 = add i32 %v4979, %v4978
  %v4981 = load ptr, ptr %MEMORY, align 4
  %v4982 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4981, ptr %state, ptr %EAX, i32 %v4980)
  store ptr %v4982, ptr %MEMORY, align 4
  %v4983 = load ptr, ptr %MEMORY, align 4
  %v4984 = call ptr @__remill_atomic_end(ptr %v4983)
  store ptr %v4984, ptr %MEMORY, align 4
  store i32 %v4974, ptr %PC, align 4
  %v4985 = add i32 %v4974, 3
  store i32 %v4985, ptr %NEXT_PC, align 4
  %v4986 = load ptr, ptr %MEMORY, align 4
  %v4987 = call ptr @__remill_atomic_begin(ptr %v4986)
  store ptr %v4987, ptr %MEMORY, align 4
  %v4988 = load i32, ptr %EAX, align 4
  %v4989 = load i32, ptr %DSBASE, align 4
  %v4990 = add i32 %v4988, 12
  %v4991 = add i32 %v4990, %v4989
  %v4992 = load ptr, ptr %MEMORY, align 4
  %v4993 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4992, ptr %state, ptr %EAX, i32 %v4991)
  store ptr %v4993, ptr %MEMORY, align 4
  %v4994 = load ptr, ptr %MEMORY, align 4
  %v4995 = call ptr @__remill_atomic_end(ptr %v4994)
  store ptr %v4995, ptr %MEMORY, align 4
  store i32 %v4985, ptr %PC, align 4
  %v4996 = add i32 %v4985, 2
  store i32 %v4996, ptr %NEXT_PC, align 4
  %v4997 = load ptr, ptr %MEMORY, align 4
  %v4998 = call ptr @__remill_atomic_begin(ptr %v4997)
  store ptr %v4998, ptr %MEMORY, align 4
  %v4999 = load i32, ptr %EAX, align 4
  %v5000 = load i32, ptr %EAX, align 4
  %v5001 = load ptr, ptr %MEMORY, align 4
  %v5002 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5001, ptr %state, i32 %v4999, i32 %v5000)
  store ptr %v5002, ptr %MEMORY, align 4
  %v5003 = load ptr, ptr %MEMORY, align 4
  %v5004 = call ptr @__remill_atomic_end(ptr %v5003)
  store ptr %v5004, ptr %MEMORY, align 4
  store i32 %v4996, ptr %PC, align 4
  %v5005 = add i32 %v4996, 2
  store i32 %v5005, ptr %NEXT_PC, align 4
  %v5006 = load ptr, ptr %MEMORY, align 4
  %v5007 = call ptr @__remill_atomic_begin(ptr %v5006)
  store ptr %v5007, ptr %MEMORY, align 4
  %v5008 = add i32 %v5005, 20
  %v5009 = load ptr, ptr %MEMORY, align 4
  %v5010 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5009, ptr %state, ptr %BRANCH_TAKEN, i32 %v5008, i32 %v5005, ptr %NEXT_PC)
  store ptr %v5010, ptr %MEMORY, align 4
  %v5011 = load ptr, ptr %MEMORY, align 4
  %v5012 = call ptr @__remill_atomic_end(ptr %v5011)
  store ptr %v5012, ptr %MEMORY, align 4
  br i1 true, label %bb_4206395, label %bb_4206375

bb_4206375:                                       ; preds = %bb_4206359
  store i32 %v5005, ptr %PC, align 4
  %v5013 = add i32 %v5005, 3
  store i32 %v5013, ptr %NEXT_PC, align 4
  %v5014 = load ptr, ptr %MEMORY, align 4
  %v5015 = call ptr @__remill_atomic_begin(ptr %v5014)
  store ptr %v5015, ptr %MEMORY, align 4
  %v5016 = load i32, ptr %EBP, align 4
  %v5017 = load i32, ptr %SSBASE, align 4
  %v5018 = add i32 %v5016, 16
  %v5019 = add i32 %v5018, %v5017
  %v5020 = load ptr, ptr %MEMORY, align 4
  %v5021 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5020, ptr %state, ptr %EAX, i32 %v5019)
  store ptr %v5021, ptr %MEMORY, align 4
  %v5022 = load ptr, ptr %MEMORY, align 4
  %v5023 = call ptr @__remill_atomic_end(ptr %v5022)
  store ptr %v5023, ptr %MEMORY, align 4
  store i32 %v5013, ptr %PC, align 4
  %v5024 = add i32 %v5013, 3
  store i32 %v5024, ptr %NEXT_PC, align 4
  %v5025 = load ptr, ptr %MEMORY, align 4
  %v5026 = call ptr @__remill_atomic_begin(ptr %v5025)
  store ptr %v5026, ptr %MEMORY, align 4
  %v5027 = load i32, ptr %EAX, align 4
  %v5028 = load i32, ptr %DSBASE, align 4
  %v5029 = add i32 %v5027, 12
  %v5030 = add i32 %v5029, %v5028
  %v5031 = load ptr, ptr %MEMORY, align 4
  %v5032 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5031, ptr %state, ptr %EAX, i32 %v5030)
  store ptr %v5032, ptr %MEMORY, align 4
  %v5033 = load ptr, ptr %MEMORY, align 4
  %v5034 = call ptr @__remill_atomic_end(ptr %v5033)
  store ptr %v5034, ptr %MEMORY, align 4
  store i32 %v5024, ptr %PC, align 4
  %v5035 = add i32 %v5024, 3
  store i32 %v5035, ptr %NEXT_PC, align 4
  %v5036 = load ptr, ptr %MEMORY, align 4
  %v5037 = call ptr @__remill_atomic_begin(ptr %v5036)
  store ptr %v5037, ptr %MEMORY, align 4
  %v5038 = load i32, ptr %EAX, align 4
  %v5039 = load i32, ptr %EBP, align 4
  %v5040 = load i32, ptr %SSBASE, align 4
  %v5041 = add i32 %v5039, 12
  %v5042 = add i32 %v5041, %v5040
  %v5043 = load ptr, ptr %MEMORY, align 4
  %v5044 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5043, ptr %state, i32 %v5038, i32 %v5042)
  store ptr %v5044, ptr %MEMORY, align 4
  %v5045 = load ptr, ptr %MEMORY, align 4
  %v5046 = call ptr @__remill_atomic_end(ptr %v5045)
  store ptr %v5046, ptr %MEMORY, align 4
  store i32 %v5035, ptr %PC, align 4
  %v5047 = add i32 %v5035, 2
  store i32 %v5047, ptr %NEXT_PC, align 4
  %v5048 = load ptr, ptr %MEMORY, align 4
  %v5049 = call ptr @__remill_atomic_begin(ptr %v5048)
  store ptr %v5049, ptr %MEMORY, align 4
  %v5050 = add i32 %v5047, 9
  %v5051 = load ptr, ptr %MEMORY, align 4
  %v5052 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5051, ptr %state, ptr %BRANCH_TAKEN, i32 %v5050, i32 %v5047, ptr %NEXT_PC)
  store ptr %v5052, ptr %MEMORY, align 4
  %v5053 = load ptr, ptr %MEMORY, align 4
  %v5054 = call ptr @__remill_atomic_end(ptr %v5053)
  store ptr %v5054, ptr %MEMORY, align 4
  br i1 true, label %bb_4206395, label %bb_4206386

bb_4206386:                                       ; preds = %bb_4206375
  store i32 %v5047, ptr %PC, align 4
  %v5055 = add i32 %v5047, 3
  store i32 %v5055, ptr %NEXT_PC, align 4
  %v5056 = load ptr, ptr %MEMORY, align 4
  %v5057 = call ptr @__remill_atomic_begin(ptr %v5056)
  store ptr %v5057, ptr %MEMORY, align 4
  %v5058 = load i32, ptr %EBP, align 4
  %v5059 = load i32, ptr %SSBASE, align 4
  %v5060 = add i32 %v5058, 16
  %v5061 = add i32 %v5060, %v5059
  %v5062 = load ptr, ptr %MEMORY, align 4
  %v5063 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5062, ptr %state, ptr %EAX, i32 %v5061)
  store ptr %v5063, ptr %MEMORY, align 4
  %v5064 = load ptr, ptr %MEMORY, align 4
  %v5065 = call ptr @__remill_atomic_end(ptr %v5064)
  store ptr %v5065, ptr %MEMORY, align 4
  store i32 %v5055, ptr %PC, align 4
  %v5066 = add i32 %v5055, 3
  store i32 %v5066, ptr %NEXT_PC, align 4
  %v5067 = load ptr, ptr %MEMORY, align 4
  %v5068 = call ptr @__remill_atomic_begin(ptr %v5067)
  store ptr %v5068, ptr %MEMORY, align 4
  %v5069 = load i32, ptr %EAX, align 4
  %v5070 = load i32, ptr %DSBASE, align 4
  %v5071 = add i32 %v5069, 12
  %v5072 = add i32 %v5071, %v5070
  %v5073 = load ptr, ptr %MEMORY, align 4
  %v5074 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5073, ptr %state, ptr %EAX, i32 %v5072)
  store ptr %v5074, ptr %MEMORY, align 4
  %v5075 = load ptr, ptr %MEMORY, align 4
  %v5076 = call ptr @__remill_atomic_end(ptr %v5075)
  store ptr %v5076, ptr %MEMORY, align 4
  store i32 %v5066, ptr %PC, align 4
  %v5077 = add i32 %v5066, 3
  store i32 %v5077, ptr %NEXT_PC, align 4
  %v5078 = load ptr, ptr %MEMORY, align 4
  %v5079 = call ptr @__remill_atomic_begin(ptr %v5078)
  store ptr %v5079, ptr %MEMORY, align 4
  %v5080 = load i32, ptr %EBP, align 4
  %v5081 = load i32, ptr %SSBASE, align 4
  %v5082 = add i32 %v5080, 12
  %v5083 = add i32 %v5082, %v5081
  %v5084 = load i32, ptr %EAX, align 4
  %v5085 = load ptr, ptr %MEMORY, align 4
  %v5086 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5085, ptr %state, i32 %v5083, i32 %v5084)
  store ptr %v5086, ptr %MEMORY, align 4
  %v5087 = load ptr, ptr %MEMORY, align 4
  %v5088 = call ptr @__remill_atomic_end(ptr %v5087)
  store ptr %v5088, ptr %MEMORY, align 4
  br label %bb_4206395

bb_4206395:                                       ; preds = %bb_4206386, %bb_4206375, %bb_4206359
  %v5089 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5089, ptr %PC, align 4
  %v5090 = add i32 %v5089, 3
  store i32 %v5090, ptr %NEXT_PC, align 4
  %v5091 = load ptr, ptr %MEMORY, align 4
  %v5092 = call ptr @__remill_atomic_begin(ptr %v5091)
  store ptr %v5092, ptr %MEMORY, align 4
  %v5093 = load i32, ptr %EBP, align 4
  %v5094 = load i32, ptr %SSBASE, align 4
  %v5095 = add i32 %v5093, 16
  %v5096 = add i32 %v5095, %v5094
  %v5097 = load ptr, ptr %MEMORY, align 4
  %v5098 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5097, ptr %state, ptr %EAX, i32 %v5096)
  store ptr %v5098, ptr %MEMORY, align 4
  %v5099 = load ptr, ptr %MEMORY, align 4
  %v5100 = call ptr @__remill_atomic_end(ptr %v5099)
  store ptr %v5100, ptr %MEMORY, align 4
  store i32 %v5090, ptr %PC, align 4
  %v5101 = add i32 %v5090, 3
  store i32 %v5101, ptr %NEXT_PC, align 4
  %v5102 = load ptr, ptr %MEMORY, align 4
  %v5103 = call ptr @__remill_atomic_begin(ptr %v5102)
  store ptr %v5103, ptr %MEMORY, align 4
  %v5104 = load i32, ptr %EAX, align 4
  %v5105 = load i32, ptr %DSBASE, align 4
  %v5106 = add i32 %v5104, 8
  %v5107 = add i32 %v5106, %v5105
  %v5108 = load ptr, ptr %MEMORY, align 4
  %v5109 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5108, ptr %state, ptr %EAX, i32 %v5107)
  store ptr %v5109, ptr %MEMORY, align 4
  %v5110 = load ptr, ptr %MEMORY, align 4
  %v5111 = call ptr @__remill_atomic_end(ptr %v5110)
  store ptr %v5111, ptr %MEMORY, align 4
  store i32 %v5101, ptr %PC, align 4
  %v5112 = add i32 %v5101, 3
  store i32 %v5112, ptr %NEXT_PC, align 4
  %v5113 = load ptr, ptr %MEMORY, align 4
  %v5114 = call ptr @__remill_atomic_begin(ptr %v5113)
  store ptr %v5114, ptr %MEMORY, align 4
  %v5115 = load i32, ptr %EAX, align 4
  %v5116 = load i32, ptr %EBP, align 4
  %v5117 = load i32, ptr %SSBASE, align 4
  %v5118 = add i32 %v5116, 12
  %v5119 = add i32 %v5118, %v5117
  %v5120 = load ptr, ptr %MEMORY, align 4
  %v5121 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5120, ptr %state, i32 %v5115, i32 %v5119)
  store ptr %v5121, ptr %MEMORY, align 4
  %v5122 = load ptr, ptr %MEMORY, align 4
  %v5123 = call ptr @__remill_atomic_end(ptr %v5122)
  store ptr %v5123, ptr %MEMORY, align 4
  store i32 %v5112, ptr %PC, align 4
  %v5124 = add i32 %v5112, 2
  store i32 %v5124, ptr %NEXT_PC, align 4
  %v5125 = load ptr, ptr %MEMORY, align 4
  %v5126 = call ptr @__remill_atomic_begin(ptr %v5125)
  store ptr %v5126, ptr %MEMORY, align 4
  %v5127 = add i32 %v5124, 19
  %v5128 = load ptr, ptr %MEMORY, align 4
  %v5129 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5128, ptr %state, ptr %BRANCH_TAKEN, i32 %v5127, i32 %v5124, ptr %NEXT_PC)
  store ptr %v5129, ptr %MEMORY, align 4
  %v5130 = load ptr, ptr %MEMORY, align 4
  %v5131 = call ptr @__remill_atomic_end(ptr %v5130)
  store ptr %v5131, ptr %MEMORY, align 4
  br i1 true, label %bb_4206425, label %bb_4206406

bb_4206406:                                       ; preds = %bb_4206395
  store i32 %v5124, ptr %PC, align 4
  %v5132 = add i32 %v5124, 3
  store i32 %v5132, ptr %NEXT_PC, align 4
  %v5133 = load ptr, ptr %MEMORY, align 4
  %v5134 = call ptr @__remill_atomic_begin(ptr %v5133)
  store ptr %v5134, ptr %MEMORY, align 4
  %v5135 = load i32, ptr %EBP, align 4
  %v5136 = load i32, ptr %SSBASE, align 4
  %v5137 = add i32 %v5135, 16
  %v5138 = add i32 %v5137, %v5136
  %v5139 = load ptr, ptr %MEMORY, align 4
  %v5140 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5139, ptr %state, ptr %EAX, i32 %v5138)
  store ptr %v5140, ptr %MEMORY, align 4
  %v5141 = load ptr, ptr %MEMORY, align 4
  %v5142 = call ptr @__remill_atomic_end(ptr %v5141)
  store ptr %v5142, ptr %MEMORY, align 4
  store i32 %v5132, ptr %PC, align 4
  %v5143 = add i32 %v5132, 3
  store i32 %v5143, ptr %NEXT_PC, align 4
  %v5144 = load ptr, ptr %MEMORY, align 4
  %v5145 = call ptr @__remill_atomic_begin(ptr %v5144)
  store ptr %v5145, ptr %MEMORY, align 4
  %v5146 = load i32, ptr %EAX, align 4
  %v5147 = load i32, ptr %DSBASE, align 4
  %v5148 = add i32 %v5146, 8
  %v5149 = add i32 %v5148, %v5147
  %v5150 = load ptr, ptr %MEMORY, align 4
  %v5151 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5150, ptr %state, ptr %EAX, i32 %v5149)
  store ptr %v5151, ptr %MEMORY, align 4
  %v5152 = load ptr, ptr %MEMORY, align 4
  %v5153 = call ptr @__remill_atomic_end(ptr %v5152)
  store ptr %v5153, ptr %MEMORY, align 4
  store i32 %v5143, ptr %PC, align 4
  %v5154 = add i32 %v5143, 2
  store i32 %v5154, ptr %NEXT_PC, align 4
  %v5155 = load ptr, ptr %MEMORY, align 4
  %v5156 = call ptr @__remill_atomic_begin(ptr %v5155)
  store ptr %v5156, ptr %MEMORY, align 4
  %v5157 = load i32, ptr %EAX, align 4
  %v5158 = load ptr, ptr %MEMORY, align 4
  %v5159 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5158, ptr %state, ptr %EDX, i32 %v5157)
  store ptr %v5159, ptr %MEMORY, align 4
  %v5160 = load ptr, ptr %MEMORY, align 4
  %v5161 = call ptr @__remill_atomic_end(ptr %v5160)
  store ptr %v5161, ptr %MEMORY, align 4
  store i32 %v5154, ptr %PC, align 4
  %v5162 = add i32 %v5154, 3
  store i32 %v5162, ptr %NEXT_PC, align 4
  %v5163 = load ptr, ptr %MEMORY, align 4
  %v5164 = call ptr @__remill_atomic_begin(ptr %v5163)
  store ptr %v5164, ptr %MEMORY, align 4
  %v5165 = load i32, ptr %EDX, align 4
  %v5166 = load i32, ptr %EBP, align 4
  %v5167 = load i32, ptr %SSBASE, align 4
  %v5168 = add i32 %v5166, 12
  %v5169 = add i32 %v5168, %v5167
  %v5170 = load ptr, ptr %MEMORY, align 4
  %v5171 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5170, ptr %state, ptr %EDX, i32 %v5165, i32 %v5169)
  store ptr %v5171, ptr %MEMORY, align 4
  %v5172 = load ptr, ptr %MEMORY, align 4
  %v5173 = call ptr @__remill_atomic_end(ptr %v5172)
  store ptr %v5173, ptr %MEMORY, align 4
  store i32 %v5162, ptr %PC, align 4
  %v5174 = add i32 %v5162, 3
  store i32 %v5174, ptr %NEXT_PC, align 4
  %v5175 = load ptr, ptr %MEMORY, align 4
  %v5176 = call ptr @__remill_atomic_begin(ptr %v5175)
  store ptr %v5176, ptr %MEMORY, align 4
  %v5177 = load i32, ptr %EBP, align 4
  %v5178 = load i32, ptr %SSBASE, align 4
  %v5179 = add i32 %v5177, 16
  %v5180 = add i32 %v5179, %v5178
  %v5181 = load ptr, ptr %MEMORY, align 4
  %v5182 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5181, ptr %state, ptr %EAX, i32 %v5180)
  store ptr %v5182, ptr %MEMORY, align 4
  %v5183 = load ptr, ptr %MEMORY, align 4
  %v5184 = call ptr @__remill_atomic_end(ptr %v5183)
  store ptr %v5184, ptr %MEMORY, align 4
  store i32 %v5174, ptr %PC, align 4
  %v5185 = add i32 %v5174, 3
  store i32 %v5185, ptr %NEXT_PC, align 4
  %v5186 = load ptr, ptr %MEMORY, align 4
  %v5187 = call ptr @__remill_atomic_begin(ptr %v5186)
  store ptr %v5187, ptr %MEMORY, align 4
  %v5188 = load i32, ptr %EAX, align 4
  %v5189 = load i32, ptr %DSBASE, align 4
  %v5190 = add i32 %v5188, 8
  %v5191 = add i32 %v5190, %v5189
  %v5192 = load i32, ptr %EDX, align 4
  %v5193 = load ptr, ptr %MEMORY, align 4
  %v5194 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5193, ptr %state, i32 %v5191, i32 %v5192)
  store ptr %v5194, ptr %MEMORY, align 4
  %v5195 = load ptr, ptr %MEMORY, align 4
  %v5196 = call ptr @__remill_atomic_end(ptr %v5195)
  store ptr %v5196, ptr %MEMORY, align 4
  store i32 %v5185, ptr %PC, align 4
  %v5197 = add i32 %v5185, 2
  store i32 %v5197, ptr %NEXT_PC, align 4
  %v5198 = load ptr, ptr %MEMORY, align 4
  %v5199 = call ptr @__remill_atomic_begin(ptr %v5198)
  store ptr %v5199, ptr %MEMORY, align 4
  %v5200 = add i32 %v5197, 10
  %v5201 = load ptr, ptr %MEMORY, align 4
  %v5202 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v5201, ptr %state, i32 %v5200, ptr %NEXT_PC)
  store ptr %v5202, ptr %MEMORY, align 4
  %v5203 = load ptr, ptr %MEMORY, align 4
  %v5204 = call ptr @__remill_atomic_end(ptr %v5203)
  store ptr %v5204, ptr %MEMORY, align 4
  br label %bb_4206435

bb_4206425:                                       ; preds = %bb_4206395
  store i32 %v5124, ptr %PC, align 4
  %v5205 = add i32 %v5124, 3
  store i32 %v5205, ptr %NEXT_PC, align 4
  %v5206 = load ptr, ptr %MEMORY, align 4
  %v5207 = call ptr @__remill_atomic_begin(ptr %v5206)
  store ptr %v5207, ptr %MEMORY, align 4
  %v5208 = load i32, ptr %EBP, align 4
  %v5209 = load i32, ptr %SSBASE, align 4
  %v5210 = add i32 %v5208, 16
  %v5211 = add i32 %v5210, %v5209
  %v5212 = load ptr, ptr %MEMORY, align 4
  %v5213 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5212, ptr %state, ptr %EAX, i32 %v5211)
  store ptr %v5213, ptr %MEMORY, align 4
  %v5214 = load ptr, ptr %MEMORY, align 4
  %v5215 = call ptr @__remill_atomic_end(ptr %v5214)
  store ptr %v5215, ptr %MEMORY, align 4
  store i32 %v5205, ptr %PC, align 4
  %v5216 = add i32 %v5205, 7
  store i32 %v5216, ptr %NEXT_PC, align 4
  %v5217 = load ptr, ptr %MEMORY, align 4
  %v5218 = call ptr @__remill_atomic_begin(ptr %v5217)
  store ptr %v5218, ptr %MEMORY, align 4
  %v5219 = load i32, ptr %EAX, align 4
  %v5220 = load i32, ptr %DSBASE, align 4
  %v5221 = add i32 %v5219, 8
  %v5222 = add i32 %v5221, %v5220
  %v5223 = load ptr, ptr %MEMORY, align 4
  %v5224 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5223, ptr %state, i32 %v5222, i32 -1)
  store ptr %v5224, ptr %MEMORY, align 4
  %v5225 = load ptr, ptr %MEMORY, align 4
  %v5226 = call ptr @__remill_atomic_end(ptr %v5225)
  store ptr %v5226, ptr %MEMORY, align 4
  br label %bb_4206435

bb_4206435:                                       ; preds = %bb_4206425, %bb_4206406
  %v5227 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5227, ptr %PC, align 4
  %v5228 = add i32 %v5227, 3
  store i32 %v5228, ptr %NEXT_PC, align 4
  %v5229 = load ptr, ptr %MEMORY, align 4
  %v5230 = call ptr @__remill_atomic_begin(ptr %v5229)
  store ptr %v5230, ptr %MEMORY, align 4
  %v5231 = load i32, ptr %EBP, align 4
  %v5232 = load i32, ptr %SSBASE, align 4
  %v5233 = add i32 %v5231, 16
  %v5234 = add i32 %v5233, %v5232
  %v5235 = load ptr, ptr %MEMORY, align 4
  %v5236 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5235, ptr %state, ptr %EAX, i32 %v5234)
  store ptr %v5236, ptr %MEMORY, align 4
  %v5237 = load ptr, ptr %MEMORY, align 4
  %v5238 = call ptr @__remill_atomic_end(ptr %v5237)
  store ptr %v5238, ptr %MEMORY, align 4
  store i32 %v5228, ptr %PC, align 4
  %v5239 = add i32 %v5228, 3
  store i32 %v5239, ptr %NEXT_PC, align 4
  %v5240 = load ptr, ptr %MEMORY, align 4
  %v5241 = call ptr @__remill_atomic_begin(ptr %v5240)
  store ptr %v5241, ptr %MEMORY, align 4
  %v5242 = load i32, ptr %EAX, align 4
  %v5243 = load i32, ptr %DSBASE, align 4
  %v5244 = add i32 %v5242, 8
  %v5245 = add i32 %v5244, %v5243
  %v5246 = load ptr, ptr %MEMORY, align 4
  %v5247 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5246, ptr %state, ptr %EAX, i32 %v5245)
  store ptr %v5247, ptr %MEMORY, align 4
  %v5248 = load ptr, ptr %MEMORY, align 4
  %v5249 = call ptr @__remill_atomic_end(ptr %v5248)
  store ptr %v5249, ptr %MEMORY, align 4
  store i32 %v5239, ptr %PC, align 4
  %v5250 = add i32 %v5239, 2
  store i32 %v5250, ptr %NEXT_PC, align 4
  %v5251 = load ptr, ptr %MEMORY, align 4
  %v5252 = call ptr @__remill_atomic_begin(ptr %v5251)
  store ptr %v5252, ptr %MEMORY, align 4
  %v5253 = load i32, ptr %EAX, align 4
  %v5254 = load i32, ptr %EAX, align 4
  %v5255 = load ptr, ptr %MEMORY, align 4
  %v5256 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5255, ptr %state, i32 %v5253, i32 %v5254)
  store ptr %v5256, ptr %MEMORY, align 4
  %v5257 = load ptr, ptr %MEMORY, align 4
  %v5258 = call ptr @__remill_atomic_end(ptr %v5257)
  store ptr %v5258, ptr %MEMORY, align 4
  store i32 %v5250, ptr %PC, align 4
  %v5259 = add i32 %v5250, 2
  store i32 %v5259, ptr %NEXT_PC, align 4
  %v5260 = load ptr, ptr %MEMORY, align 4
  %v5261 = call ptr @__remill_atomic_begin(ptr %v5260)
  store ptr %v5261, ptr %MEMORY, align 4
  %v5262 = add i32 %v5259, 92
  %v5263 = load ptr, ptr %MEMORY, align 4
  %v5264 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5263, ptr %state, ptr %BRANCH_TAKEN, i32 %v5262, i32 %v5259, ptr %NEXT_PC)
  store ptr %v5264, ptr %MEMORY, align 4
  %v5265 = load ptr, ptr %MEMORY, align 4
  %v5266 = call ptr @__remill_atomic_end(ptr %v5265)
  store ptr %v5266, ptr %MEMORY, align 4
  br i1 true, label %bb_4206537, label %bb_4206445

bb_4206445:                                       ; preds = %bb_4206435
  store i32 %v5259, ptr %PC, align 4
  %v5267 = add i32 %v5259, 3
  store i32 %v5267, ptr %NEXT_PC, align 4
  %v5268 = load ptr, ptr %MEMORY, align 4
  %v5269 = call ptr @__remill_atomic_begin(ptr %v5268)
  store ptr %v5269, ptr %MEMORY, align 4
  %v5270 = load i32, ptr %EBP, align 4
  %v5271 = load i32, ptr %SSBASE, align 4
  %v5272 = add i32 %v5270, 16
  %v5273 = add i32 %v5272, %v5271
  %v5274 = load ptr, ptr %MEMORY, align 4
  %v5275 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5274, ptr %state, ptr %EAX, i32 %v5273)
  store ptr %v5275, ptr %MEMORY, align 4
  %v5276 = load ptr, ptr %MEMORY, align 4
  %v5277 = call ptr @__remill_atomic_end(ptr %v5276)
  store ptr %v5277, ptr %MEMORY, align 4
  store i32 %v5267, ptr %PC, align 4
  %v5278 = add i32 %v5267, 3
  store i32 %v5278, ptr %NEXT_PC, align 4
  %v5279 = load ptr, ptr %MEMORY, align 4
  %v5280 = call ptr @__remill_atomic_begin(ptr %v5279)
  store ptr %v5280, ptr %MEMORY, align 4
  %v5281 = load i32, ptr %EAX, align 4
  %v5282 = load i32, ptr %DSBASE, align 4
  %v5283 = add i32 %v5281, 4
  %v5284 = add i32 %v5283, %v5282
  %v5285 = load ptr, ptr %MEMORY, align 4
  %v5286 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5285, ptr %state, ptr %EAX, i32 %v5284)
  store ptr %v5286, ptr %MEMORY, align 4
  %v5287 = load ptr, ptr %MEMORY, align 4
  %v5288 = call ptr @__remill_atomic_end(ptr %v5287)
  store ptr %v5288, ptr %MEMORY, align 4
  store i32 %v5278, ptr %PC, align 4
  %v5289 = add i32 %v5278, 5
  store i32 %v5289, ptr %NEXT_PC, align 4
  %v5290 = load ptr, ptr %MEMORY, align 4
  %v5291 = call ptr @__remill_atomic_begin(ptr %v5290)
  store ptr %v5291, ptr %MEMORY, align 4
  %v5292 = load i32, ptr %EAX, align 4
  %v5293 = load ptr, ptr %MEMORY, align 4
  %v5294 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5293, ptr %state, ptr %EAX, i32 %v5292, i32 1024)
  store ptr %v5294, ptr %MEMORY, align 4
  %v5295 = load ptr, ptr %MEMORY, align 4
  %v5296 = call ptr @__remill_atomic_end(ptr %v5295)
  store ptr %v5296, ptr %MEMORY, align 4
  store i32 %v5289, ptr %PC, align 4
  %v5297 = add i32 %v5289, 2
  store i32 %v5297, ptr %NEXT_PC, align 4
  %v5298 = load ptr, ptr %MEMORY, align 4
  %v5299 = call ptr @__remill_atomic_begin(ptr %v5298)
  store ptr %v5299, ptr %MEMORY, align 4
  %v5300 = load i32, ptr %EAX, align 4
  %v5301 = load i32, ptr %EAX, align 4
  %v5302 = load ptr, ptr %MEMORY, align 4
  %v5303 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5302, ptr %state, i32 %v5300, i32 %v5301)
  store ptr %v5303, ptr %MEMORY, align 4
  %v5304 = load ptr, ptr %MEMORY, align 4
  %v5305 = call ptr @__remill_atomic_end(ptr %v5304)
  store ptr %v5305, ptr %MEMORY, align 4
  store i32 %v5297, ptr %PC, align 4
  %v5306 = add i32 %v5297, 2
  store i32 %v5306, ptr %NEXT_PC, align 4
  %v5307 = load ptr, ptr %MEMORY, align 4
  %v5308 = call ptr @__remill_atomic_begin(ptr %v5307)
  store ptr %v5308, ptr %MEMORY, align 4
  %v5309 = add i32 %v5306, 77
  %v5310 = load ptr, ptr %MEMORY, align 4
  %v5311 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5310, ptr %state, ptr %BRANCH_TAKEN, i32 %v5309, i32 %v5306, ptr %NEXT_PC)
  store ptr %v5311, ptr %MEMORY, align 4
  %v5312 = load ptr, ptr %MEMORY, align 4
  %v5313 = call ptr @__remill_atomic_end(ptr %v5312)
  store ptr %v5313, ptr %MEMORY, align 4
  br i1 true, label %bb_4206537, label %bb_4206460

bb_4206460:                                       ; preds = %bb_4206445
  store i32 %v5306, ptr %PC, align 4
  %v5314 = add i32 %v5306, 2
  store i32 %v5314, ptr %NEXT_PC, align 4
  %v5315 = load ptr, ptr %MEMORY, align 4
  %v5316 = call ptr @__remill_atomic_begin(ptr %v5315)
  store ptr %v5316, ptr %MEMORY, align 4
  %v5317 = add i32 %v5314, 19
  %v5318 = load ptr, ptr %MEMORY, align 4
  %v5319 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v5318, ptr %state, i32 %v5317, ptr %NEXT_PC)
  store ptr %v5319, ptr %MEMORY, align 4
  %v5320 = load ptr, ptr %MEMORY, align 4
  %v5321 = call ptr @__remill_atomic_end(ptr %v5320)
  store ptr %v5321, ptr %MEMORY, align 4
  br label %bb_4206481

bb_4206462:                                       ; preds = %bb_4206481
  store i32 %v5444, ptr %PC, align 4
  %v5322 = add i32 %v5444, 3
  store i32 %v5322, ptr %NEXT_PC, align 4
  %v5323 = load ptr, ptr %MEMORY, align 4
  %v5324 = call ptr @__remill_atomic_begin(ptr %v5323)
  store ptr %v5324, ptr %MEMORY, align 4
  %v5325 = load i32, ptr %EBP, align 4
  %v5326 = load i32, ptr %SSBASE, align 4
  %v5327 = add i32 %v5325, 16
  %v5328 = add i32 %v5327, %v5326
  %v5329 = load ptr, ptr %MEMORY, align 4
  %v5330 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5329, ptr %state, ptr %EAX, i32 %v5328)
  store ptr %v5330, ptr %MEMORY, align 4
  %v5331 = load ptr, ptr %MEMORY, align 4
  %v5332 = call ptr @__remill_atomic_end(ptr %v5331)
  store ptr %v5332, ptr %MEMORY, align 4
  store i32 %v5322, ptr %PC, align 4
  %v5333 = add i32 %v5322, 4
  store i32 %v5333, ptr %NEXT_PC, align 4
  %v5334 = load ptr, ptr %MEMORY, align 4
  %v5335 = call ptr @__remill_atomic_begin(ptr %v5334)
  store ptr %v5335, ptr %MEMORY, align 4
  %v5336 = load i32, ptr %ESP, align 4
  %v5337 = load i32, ptr %SSBASE, align 4
  %v5338 = add i32 %v5336, 4
  %v5339 = add i32 %v5338, %v5337
  %v5340 = load i32, ptr %EAX, align 4
  %v5341 = load ptr, ptr %MEMORY, align 4
  %v5342 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5341, ptr %state, i32 %v5339, i32 %v5340)
  store ptr %v5342, ptr %MEMORY, align 4
  %v5343 = load ptr, ptr %MEMORY, align 4
  %v5344 = call ptr @__remill_atomic_end(ptr %v5343)
  store ptr %v5344, ptr %MEMORY, align 4
  store i32 %v5333, ptr %PC, align 4
  %v5345 = add i32 %v5333, 7
  store i32 %v5345, ptr %NEXT_PC, align 4
  %v5346 = load ptr, ptr %MEMORY, align 4
  %v5347 = call ptr @__remill_atomic_begin(ptr %v5346)
  store ptr %v5347, ptr %MEMORY, align 4
  %v5348 = load i32, ptr %ESP, align 4
  %v5349 = load i32, ptr %SSBASE, align 4
  %v5350 = add i32 %v5348, %v5349
  %v5351 = load ptr, ptr %MEMORY, align 4
  %v5352 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5351, ptr %state, i32 %v5350, i32 32)
  store ptr %v5352, ptr %MEMORY, align 4
  %v5353 = load ptr, ptr %MEMORY, align 4
  %v5354 = call ptr @__remill_atomic_end(ptr %v5353)
  store ptr %v5354, ptr %MEMORY, align 4
  store i32 %v5345, ptr %PC, align 4
  %v5355 = add i32 %v5345, 5
  store i32 %v5355, ptr %NEXT_PC, align 4
  %v5356 = load ptr, ptr %MEMORY, align 4
  %v5357 = call ptr @__remill_atomic_begin(ptr %v5356)
  store ptr %v5357, ptr %MEMORY, align 4
  %v5358 = sub i32 %v5355, 231
  %v5359 = load ptr, ptr %MEMORY, align 4
  %v5360 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v5359, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v5355, ptr %RETURN_PC)
  store ptr %v5360, ptr %MEMORY, align 4
  %v5361 = load ptr, ptr %MEMORY, align 4
  %v5362 = call ptr @__remill_atomic_end(ptr %v5361)
  store ptr %v5362, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206481:                                       ; preds = %bb_4206460
  store i32 %v5314, ptr %PC, align 4
  %v5363 = add i32 %v5314, 3
  store i32 %v5363, ptr %NEXT_PC, align 4
  %v5364 = load ptr, ptr %MEMORY, align 4
  %v5365 = call ptr @__remill_atomic_begin(ptr %v5364)
  store ptr %v5365, ptr %MEMORY, align 4
  %v5366 = load i32, ptr %EBP, align 4
  %v5367 = load i32, ptr %SSBASE, align 4
  %v5368 = add i32 %v5366, 16
  %v5369 = add i32 %v5368, %v5367
  %v5370 = load ptr, ptr %MEMORY, align 4
  %v5371 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5370, ptr %state, ptr %EAX, i32 %v5369)
  store ptr %v5371, ptr %MEMORY, align 4
  %v5372 = load ptr, ptr %MEMORY, align 4
  %v5373 = call ptr @__remill_atomic_end(ptr %v5372)
  store ptr %v5373, ptr %MEMORY, align 4
  store i32 %v5363, ptr %PC, align 4
  %v5374 = add i32 %v5363, 3
  store i32 %v5374, ptr %NEXT_PC, align 4
  %v5375 = load ptr, ptr %MEMORY, align 4
  %v5376 = call ptr @__remill_atomic_begin(ptr %v5375)
  store ptr %v5376, ptr %MEMORY, align 4
  %v5377 = load i32, ptr %EAX, align 4
  %v5378 = load i32, ptr %DSBASE, align 4
  %v5379 = add i32 %v5377, 8
  %v5380 = add i32 %v5379, %v5378
  %v5381 = load ptr, ptr %MEMORY, align 4
  %v5382 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5381, ptr %state, ptr %EAX, i32 %v5380)
  store ptr %v5382, ptr %MEMORY, align 4
  %v5383 = load ptr, ptr %MEMORY, align 4
  %v5384 = call ptr @__remill_atomic_end(ptr %v5383)
  store ptr %v5384, ptr %MEMORY, align 4
  store i32 %v5374, ptr %PC, align 4
  %v5385 = add i32 %v5374, 2
  store i32 %v5385, ptr %NEXT_PC, align 4
  %v5386 = load ptr, ptr %MEMORY, align 4
  %v5387 = call ptr @__remill_atomic_begin(ptr %v5386)
  store ptr %v5387, ptr %MEMORY, align 4
  %v5388 = load i32, ptr %EAX, align 4
  %v5389 = load i32, ptr %EAX, align 4
  %v5390 = load ptr, ptr %MEMORY, align 4
  %v5391 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5390, ptr %state, i32 %v5388, i32 %v5389)
  store ptr %v5391, ptr %MEMORY, align 4
  %v5392 = load ptr, ptr %MEMORY, align 4
  %v5393 = call ptr @__remill_atomic_end(ptr %v5392)
  store ptr %v5393, ptr %MEMORY, align 4
  store i32 %v5385, ptr %PC, align 4
  %v5394 = add i32 %v5385, 3
  store i32 %v5394, ptr %NEXT_PC, align 4
  %v5395 = load ptr, ptr %MEMORY, align 4
  %v5396 = call ptr @__remill_atomic_begin(ptr %v5395)
  store ptr %v5396, ptr %MEMORY, align 4
  %v5397 = load ptr, ptr %MEMORY, align 4
  %v5398 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v5397, ptr %state, ptr %DL)
  store ptr %v5398, ptr %MEMORY, align 4
  %v5399 = load ptr, ptr %MEMORY, align 4
  %v5400 = call ptr @__remill_atomic_end(ptr %v5399)
  store ptr %v5400, ptr %MEMORY, align 4
  store i32 %v5394, ptr %PC, align 4
  %v5401 = add i32 %v5394, 3
  store i32 %v5401, ptr %NEXT_PC, align 4
  %v5402 = load ptr, ptr %MEMORY, align 4
  %v5403 = call ptr @__remill_atomic_begin(ptr %v5402)
  store ptr %v5403, ptr %MEMORY, align 4
  %v5404 = load i32, ptr %EAX, align 4
  %v5405 = sub i32 %v5404, 1
  %v5406 = load ptr, ptr %MEMORY, align 4
  %v5407 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v5406, ptr %state, ptr %ECX, i32 %v5405)
  store ptr %v5407, ptr %MEMORY, align 4
  %v5408 = load ptr, ptr %MEMORY, align 4
  %v5409 = call ptr @__remill_atomic_end(ptr %v5408)
  store ptr %v5409, ptr %MEMORY, align 4
  store i32 %v5401, ptr %PC, align 4
  %v5410 = add i32 %v5401, 3
  store i32 %v5410, ptr %NEXT_PC, align 4
  %v5411 = load ptr, ptr %MEMORY, align 4
  %v5412 = call ptr @__remill_atomic_begin(ptr %v5411)
  store ptr %v5412, ptr %MEMORY, align 4
  %v5413 = load i32, ptr %EBP, align 4
  %v5414 = load i32, ptr %SSBASE, align 4
  %v5415 = add i32 %v5413, 16
  %v5416 = add i32 %v5415, %v5414
  %v5417 = load ptr, ptr %MEMORY, align 4
  %v5418 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5417, ptr %state, ptr %EAX, i32 %v5416)
  store ptr %v5418, ptr %MEMORY, align 4
  %v5419 = load ptr, ptr %MEMORY, align 4
  %v5420 = call ptr @__remill_atomic_end(ptr %v5419)
  store ptr %v5420, ptr %MEMORY, align 4
  store i32 %v5410, ptr %PC, align 4
  %v5421 = add i32 %v5410, 3
  store i32 %v5421, ptr %NEXT_PC, align 4
  %v5422 = load ptr, ptr %MEMORY, align 4
  %v5423 = call ptr @__remill_atomic_begin(ptr %v5422)
  store ptr %v5423, ptr %MEMORY, align 4
  %v5424 = load i32, ptr %EAX, align 4
  %v5425 = load i32, ptr %DSBASE, align 4
  %v5426 = add i32 %v5424, 8
  %v5427 = add i32 %v5426, %v5425
  %v5428 = load i32, ptr %ECX, align 4
  %v5429 = load ptr, ptr %MEMORY, align 4
  %v5430 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5429, ptr %state, i32 %v5427, i32 %v5428)
  store ptr %v5430, ptr %MEMORY, align 4
  %v5431 = load ptr, ptr %MEMORY, align 4
  %v5432 = call ptr @__remill_atomic_end(ptr %v5431)
  store ptr %v5432, ptr %MEMORY, align 4
  store i32 %v5421, ptr %PC, align 4
  %v5433 = add i32 %v5421, 2
  store i32 %v5433, ptr %NEXT_PC, align 4
  %v5434 = load ptr, ptr %MEMORY, align 4
  %v5435 = call ptr @__remill_atomic_begin(ptr %v5434)
  store ptr %v5435, ptr %MEMORY, align 4
  %v5436 = load i8, ptr %DL, align 1
  %v5437 = zext i8 %v5436 to i32
  %v5438 = load i8, ptr %DL, align 1
  %v5439 = zext i8 %v5438 to i32
  %v5440 = load ptr, ptr %MEMORY, align 4
  %v5441 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5440, ptr %state, i32 %v5437, i32 %v5439)
  store ptr %v5441, ptr %MEMORY, align 4
  %v5442 = load ptr, ptr %MEMORY, align 4
  %v5443 = call ptr @__remill_atomic_end(ptr %v5442)
  store ptr %v5443, ptr %MEMORY, align 4
  store i32 %v5433, ptr %PC, align 4
  %v5444 = add i32 %v5433, 2
  store i32 %v5444, ptr %NEXT_PC, align 4
  %v5445 = load ptr, ptr %MEMORY, align 4
  %v5446 = call ptr @__remill_atomic_begin(ptr %v5445)
  store ptr %v5446, ptr %MEMORY, align 4
  %v5447 = sub i32 %v5444, 43
  %v5448 = load ptr, ptr %MEMORY, align 4
  %v5449 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5448, ptr %state, ptr %BRANCH_TAKEN, i32 %v5447, i32 %v5444, ptr %NEXT_PC)
  store ptr %v5449, ptr %MEMORY, align 4
  %v5450 = load ptr, ptr %MEMORY, align 4
  %v5451 = call ptr @__remill_atomic_end(ptr %v5450)
  store ptr %v5451, ptr %MEMORY, align 4
  br i1 true, label %bb_4206462, label %bb_4206505

bb_4206505:                                       ; preds = %bb_4206481
  store i32 %v5444, ptr %PC, align 4
  %v5452 = add i32 %v5444, 2
  store i32 %v5452, ptr %NEXT_PC, align 4
  %v5453 = load ptr, ptr %MEMORY, align 4
  %v5454 = call ptr @__remill_atomic_begin(ptr %v5453)
  store ptr %v5454, ptr %MEMORY, align 4
  %v5455 = add i32 %v5452, 30
  %v5456 = load ptr, ptr %MEMORY, align 4
  %v5457 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v5456, ptr %state, i32 %v5455, ptr %NEXT_PC)
  store ptr %v5457, ptr %MEMORY, align 4
  %v5458 = load ptr, ptr %MEMORY, align 4
  %v5459 = call ptr @__remill_atomic_end(ptr %v5458)
  store ptr %v5459, ptr %MEMORY, align 4
  br label %bb_4206537

bb_4206507:                                       ; preds = %bb_4206538
  store i32 %v5608, ptr %PC, align 4
  %v5460 = add i32 %v5608, 3
  store i32 %v5460, ptr %NEXT_PC, align 4
  %v5461 = load ptr, ptr %MEMORY, align 4
  %v5462 = call ptr @__remill_atomic_begin(ptr %v5461)
  store ptr %v5462, ptr %MEMORY, align 4
  %v5463 = load i32, ptr %EBP, align 4
  %v5464 = load i32, ptr %SSBASE, align 4
  %v5465 = add i32 %v5463, 8
  %v5466 = add i32 %v5465, %v5464
  %v5467 = load ptr, ptr %MEMORY, align 4
  %v5468 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5467, ptr %state, ptr %EAX, i32 %v5466)
  store ptr %v5468, ptr %MEMORY, align 4
  %v5469 = load ptr, ptr %MEMORY, align 4
  %v5470 = call ptr @__remill_atomic_end(ptr %v5469)
  store ptr %v5470, ptr %MEMORY, align 4
  store i32 %v5460, ptr %PC, align 4
  %v5471 = add i32 %v5460, 3
  store i32 %v5471, ptr %NEXT_PC, align 4
  %v5472 = load ptr, ptr %MEMORY, align 4
  %v5473 = call ptr @__remill_atomic_begin(ptr %v5472)
  store ptr %v5473, ptr %MEMORY, align 4
  %v5474 = load i32, ptr %EAX, align 4
  %v5475 = load i32, ptr %DSBASE, align 4
  %v5476 = add i32 %v5474, %v5475
  %v5477 = load ptr, ptr %MEMORY, align 4
  %v5478 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v5477, ptr %state, ptr %EAX, i32 %v5476)
  store ptr %v5478, ptr %MEMORY, align 4
  %v5479 = load ptr, ptr %MEMORY, align 4
  %v5480 = call ptr @__remill_atomic_end(ptr %v5479)
  store ptr %v5480, ptr %MEMORY, align 4
  store i32 %v5471, ptr %PC, align 4
  %v5481 = add i32 %v5471, 3
  store i32 %v5481, ptr %NEXT_PC, align 4
  %v5482 = load ptr, ptr %MEMORY, align 4
  %v5483 = call ptr @__remill_atomic_begin(ptr %v5482)
  store ptr %v5483, ptr %MEMORY, align 4
  %v5484 = load i8, ptr %AL, align 1
  %v5485 = zext i8 %v5484 to i32
  %v5486 = load ptr, ptr %MEMORY, align 4
  %v5487 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWIjE2RnIhLb1EEiEEP6MemoryS6_R5StateT_T0_(ptr %v5486, ptr %state, ptr %EAX, i32 %v5485)
  store ptr %v5487, ptr %MEMORY, align 4
  %v5488 = load ptr, ptr %MEMORY, align 4
  %v5489 = call ptr @__remill_atomic_end(ptr %v5488)
  store ptr %v5489, ptr %MEMORY, align 4
  store i32 %v5481, ptr %PC, align 4
  %v5490 = add i32 %v5481, 4
  store i32 %v5490, ptr %NEXT_PC, align 4
  %v5491 = load ptr, ptr %MEMORY, align 4
  %v5492 = call ptr @__remill_atomic_begin(ptr %v5491)
  store ptr %v5492, ptr %MEMORY, align 4
  %v5493 = load i32, ptr %EBP, align 4
  %v5494 = load i32, ptr %SSBASE, align 4
  %v5495 = add i32 %v5493, 8
  %v5496 = add i32 %v5495, %v5494
  %v5497 = load i32, ptr %EBP, align 4
  %v5498 = load i32, ptr %SSBASE, align 4
  %v5499 = add i32 %v5497, 8
  %v5500 = add i32 %v5499, %v5498
  %v5501 = load ptr, ptr %MEMORY, align 4
  %v5502 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5501, ptr %state, i32 %v5496, i32 %v5500, i32 1)
  store ptr %v5502, ptr %MEMORY, align 4
  %v5503 = load ptr, ptr %MEMORY, align 4
  %v5504 = call ptr @__remill_atomic_end(ptr %v5503)
  store ptr %v5504, ptr %MEMORY, align 4
  store i32 %v5490, ptr %PC, align 4
  %v5505 = add i32 %v5490, 3
  store i32 %v5505, ptr %NEXT_PC, align 4
  %v5506 = load ptr, ptr %MEMORY, align 4
  %v5507 = call ptr @__remill_atomic_begin(ptr %v5506)
  store ptr %v5507, ptr %MEMORY, align 4
  %v5508 = load i32, ptr %EBP, align 4
  %v5509 = load i32, ptr %SSBASE, align 4
  %v5510 = add i32 %v5508, 16
  %v5511 = add i32 %v5510, %v5509
  %v5512 = load ptr, ptr %MEMORY, align 4
  %v5513 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5512, ptr %state, ptr %EDX, i32 %v5511)
  store ptr %v5513, ptr %MEMORY, align 4
  %v5514 = load ptr, ptr %MEMORY, align 4
  %v5515 = call ptr @__remill_atomic_end(ptr %v5514)
  store ptr %v5515, ptr %MEMORY, align 4
  store i32 %v5505, ptr %PC, align 4
  %v5516 = add i32 %v5505, 4
  store i32 %v5516, ptr %NEXT_PC, align 4
  %v5517 = load ptr, ptr %MEMORY, align 4
  %v5518 = call ptr @__remill_atomic_begin(ptr %v5517)
  store ptr %v5518, ptr %MEMORY, align 4
  %v5519 = load i32, ptr %ESP, align 4
  %v5520 = load i32, ptr %SSBASE, align 4
  %v5521 = add i32 %v5519, 4
  %v5522 = add i32 %v5521, %v5520
  %v5523 = load i32, ptr %EDX, align 4
  %v5524 = load ptr, ptr %MEMORY, align 4
  %v5525 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5524, ptr %state, i32 %v5522, i32 %v5523)
  store ptr %v5525, ptr %MEMORY, align 4
  %v5526 = load ptr, ptr %MEMORY, align 4
  %v5527 = call ptr @__remill_atomic_end(ptr %v5526)
  store ptr %v5527, ptr %MEMORY, align 4
  store i32 %v5516, ptr %PC, align 4
  %v5528 = add i32 %v5516, 3
  store i32 %v5528, ptr %NEXT_PC, align 4
  %v5529 = load ptr, ptr %MEMORY, align 4
  %v5530 = call ptr @__remill_atomic_begin(ptr %v5529)
  store ptr %v5530, ptr %MEMORY, align 4
  %v5531 = load i32, ptr %ESP, align 4
  %v5532 = load i32, ptr %SSBASE, align 4
  %v5533 = add i32 %v5531, %v5532
  %v5534 = load i32, ptr %EAX, align 4
  %v5535 = load ptr, ptr %MEMORY, align 4
  %v5536 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5535, ptr %state, i32 %v5533, i32 %v5534)
  store ptr %v5536, ptr %MEMORY, align 4
  %v5537 = load ptr, ptr %MEMORY, align 4
  %v5538 = call ptr @__remill_atomic_end(ptr %v5537)
  store ptr %v5538, ptr %MEMORY, align 4
  store i32 %v5528, ptr %PC, align 4
  %v5539 = add i32 %v5528, 5
  store i32 %v5539, ptr %NEXT_PC, align 4
  %v5540 = load ptr, ptr %MEMORY, align 4
  %v5541 = call ptr @__remill_atomic_begin(ptr %v5540)
  store ptr %v5541, ptr %MEMORY, align 4
  %v5542 = sub i32 %v5539, 285
  %v5543 = load ptr, ptr %MEMORY, align 4
  %v5544 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v5543, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v5539, ptr %RETURN_PC)
  store ptr %v5544, ptr %MEMORY, align 4
  %v5545 = load ptr, ptr %MEMORY, align 4
  %v5546 = call ptr @__remill_atomic_end(ptr %v5545)
  store ptr %v5546, ptr %MEMORY, align 4
  store i32 %v5539, ptr %PC, align 4
  %v5547 = add i32 %v5539, 2
  store i32 %v5547, ptr %NEXT_PC, align 4
  %v5548 = load ptr, ptr %MEMORY, align 4
  %v5549 = call ptr @__remill_atomic_begin(ptr %v5548)
  store ptr %v5549, ptr %MEMORY, align 4
  %v5550 = add i32 %v5547, 1
  %v5551 = load ptr, ptr %MEMORY, align 4
  %v5552 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v5551, ptr %state, i32 %v5550, ptr %NEXT_PC)
  store ptr %v5552, ptr %MEMORY, align 4
  %v5553 = load ptr, ptr %MEMORY, align 4
  %v5554 = call ptr @__remill_atomic_end(ptr %v5553)
  store ptr %v5554, ptr %MEMORY, align 4
  br label %bb_4206538

bb_4206537:                                       ; preds = %bb_4206505, %bb_4206445, %bb_4206435
  %v5555 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5555, ptr %PC, align 4
  %v5556 = add i32 %v5555, 1
  store i32 %v5556, ptr %NEXT_PC, align 4
  %v5557 = load ptr, ptr %MEMORY, align 4
  %v5558 = call ptr @__remill_atomic_begin(ptr %v5557)
  store ptr %v5558, ptr %MEMORY, align 4
  %v5559 = load ptr, ptr %MEMORY, align 4
  %v5560 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v5559, ptr %state)
  store ptr %v5560, ptr %MEMORY, align 4
  %v5561 = load ptr, ptr %MEMORY, align 4
  %v5562 = call ptr @__remill_atomic_end(ptr %v5561)
  store ptr %v5562, ptr %MEMORY, align 4
  br label %bb_4206538

bb_4206538:                                       ; preds = %bb_4206537, %bb_4206507
  %v5563 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5563, ptr %PC, align 4
  %v5564 = add i32 %v5563, 4
  store i32 %v5564, ptr %NEXT_PC, align 4
  %v5565 = load ptr, ptr %MEMORY, align 4
  %v5566 = call ptr @__remill_atomic_begin(ptr %v5565)
  store ptr %v5566, ptr %MEMORY, align 4
  %v5567 = load i32, ptr %EBP, align 4
  %v5568 = load i32, ptr %SSBASE, align 4
  %v5569 = add i32 %v5567, 12
  %v5570 = add i32 %v5569, %v5568
  %v5571 = load ptr, ptr %MEMORY, align 4
  %v5572 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5571, ptr %state, i32 %v5570, i32 0)
  store ptr %v5572, ptr %MEMORY, align 4
  %v5573 = load ptr, ptr %MEMORY, align 4
  %v5574 = call ptr @__remill_atomic_end(ptr %v5573)
  store ptr %v5574, ptr %MEMORY, align 4
  store i32 %v5564, ptr %PC, align 4
  %v5575 = add i32 %v5564, 3
  store i32 %v5575, ptr %NEXT_PC, align 4
  %v5576 = load ptr, ptr %MEMORY, align 4
  %v5577 = call ptr @__remill_atomic_begin(ptr %v5576)
  store ptr %v5577, ptr %MEMORY, align 4
  %v5578 = load ptr, ptr %MEMORY, align 4
  %v5579 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v5578, ptr %state, ptr %AL)
  store ptr %v5579, ptr %MEMORY, align 4
  %v5580 = load ptr, ptr %MEMORY, align 4
  %v5581 = call ptr @__remill_atomic_end(ptr %v5580)
  store ptr %v5581, ptr %MEMORY, align 4
  store i32 %v5575, ptr %PC, align 4
  %v5582 = add i32 %v5575, 4
  store i32 %v5582, ptr %NEXT_PC, align 4
  %v5583 = load ptr, ptr %MEMORY, align 4
  %v5584 = call ptr @__remill_atomic_begin(ptr %v5583)
  store ptr %v5584, ptr %MEMORY, align 4
  %v5585 = load i32, ptr %EBP, align 4
  %v5586 = load i32, ptr %SSBASE, align 4
  %v5587 = add i32 %v5585, 12
  %v5588 = add i32 %v5587, %v5586
  %v5589 = load i32, ptr %EBP, align 4
  %v5590 = load i32, ptr %SSBASE, align 4
  %v5591 = add i32 %v5589, 12
  %v5592 = add i32 %v5591, %v5590
  %v5593 = load ptr, ptr %MEMORY, align 4
  %v5594 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5593, ptr %state, i32 %v5588, i32 %v5592, i32 1)
  store ptr %v5594, ptr %MEMORY, align 4
  %v5595 = load ptr, ptr %MEMORY, align 4
  %v5596 = call ptr @__remill_atomic_end(ptr %v5595)
  store ptr %v5596, ptr %MEMORY, align 4
  store i32 %v5582, ptr %PC, align 4
  %v5597 = add i32 %v5582, 2
  store i32 %v5597, ptr %NEXT_PC, align 4
  %v5598 = load ptr, ptr %MEMORY, align 4
  %v5599 = call ptr @__remill_atomic_begin(ptr %v5598)
  store ptr %v5599, ptr %MEMORY, align 4
  %v5600 = load i8, ptr %AL, align 1
  %v5601 = zext i8 %v5600 to i32
  %v5602 = load i8, ptr %AL, align 1
  %v5603 = zext i8 %v5602 to i32
  %v5604 = load ptr, ptr %MEMORY, align 4
  %v5605 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5604, ptr %state, i32 %v5601, i32 %v5603)
  store ptr %v5605, ptr %MEMORY, align 4
  %v5606 = load ptr, ptr %MEMORY, align 4
  %v5607 = call ptr @__remill_atomic_end(ptr %v5606)
  store ptr %v5607, ptr %MEMORY, align 4
  store i32 %v5597, ptr %PC, align 4
  %v5608 = add i32 %v5597, 2
  store i32 %v5608, ptr %NEXT_PC, align 4
  %v5609 = load ptr, ptr %MEMORY, align 4
  %v5610 = call ptr @__remill_atomic_begin(ptr %v5609)
  store ptr %v5610, ptr %MEMORY, align 4
  %v5611 = sub i32 %v5608, 46
  %v5612 = load ptr, ptr %MEMORY, align 4
  %v5613 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5612, ptr %state, ptr %BRANCH_TAKEN, i32 %v5611, i32 %v5608, ptr %NEXT_PC)
  store ptr %v5613, ptr %MEMORY, align 4
  %v5614 = load ptr, ptr %MEMORY, align 4
  %v5615 = call ptr @__remill_atomic_end(ptr %v5614)
  store ptr %v5615, ptr %MEMORY, align 4
  br i1 true, label %bb_4206507, label %bb_4206553

bb_4206553:                                       ; preds = %bb_4206538
  store i32 %v5608, ptr %PC, align 4
  %v5616 = add i32 %v5608, 2
  store i32 %v5616, ptr %NEXT_PC, align 4
  %v5617 = load ptr, ptr %MEMORY, align 4
  %v5618 = call ptr @__remill_atomic_begin(ptr %v5617)
  store ptr %v5618, ptr %MEMORY, align 4
  %v5619 = add i32 %v5616, 19
  %v5620 = load ptr, ptr %MEMORY, align 4
  %v5621 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v5620, ptr %state, i32 %v5619, ptr %NEXT_PC)
  store ptr %v5621, ptr %MEMORY, align 4
  %v5622 = load ptr, ptr %MEMORY, align 4
  %v5623 = call ptr @__remill_atomic_end(ptr %v5622)
  store ptr %v5623, ptr %MEMORY, align 4
  br label %bb_4206574

bb_4206555:                                       ; preds = %bb_4206574
  store i32 %v5746, ptr %PC, align 4
  %v5624 = add i32 %v5746, 3
  store i32 %v5624, ptr %NEXT_PC, align 4
  %v5625 = load ptr, ptr %MEMORY, align 4
  %v5626 = call ptr @__remill_atomic_begin(ptr %v5625)
  store ptr %v5626, ptr %MEMORY, align 4
  %v5627 = load i32, ptr %EBP, align 4
  %v5628 = load i32, ptr %SSBASE, align 4
  %v5629 = add i32 %v5627, 16
  %v5630 = add i32 %v5629, %v5628
  %v5631 = load ptr, ptr %MEMORY, align 4
  %v5632 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5631, ptr %state, ptr %EAX, i32 %v5630)
  store ptr %v5632, ptr %MEMORY, align 4
  %v5633 = load ptr, ptr %MEMORY, align 4
  %v5634 = call ptr @__remill_atomic_end(ptr %v5633)
  store ptr %v5634, ptr %MEMORY, align 4
  store i32 %v5624, ptr %PC, align 4
  %v5635 = add i32 %v5624, 4
  store i32 %v5635, ptr %NEXT_PC, align 4
  %v5636 = load ptr, ptr %MEMORY, align 4
  %v5637 = call ptr @__remill_atomic_begin(ptr %v5636)
  store ptr %v5637, ptr %MEMORY, align 4
  %v5638 = load i32, ptr %ESP, align 4
  %v5639 = load i32, ptr %SSBASE, align 4
  %v5640 = add i32 %v5638, 4
  %v5641 = add i32 %v5640, %v5639
  %v5642 = load i32, ptr %EAX, align 4
  %v5643 = load ptr, ptr %MEMORY, align 4
  %v5644 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5643, ptr %state, i32 %v5641, i32 %v5642)
  store ptr %v5644, ptr %MEMORY, align 4
  %v5645 = load ptr, ptr %MEMORY, align 4
  %v5646 = call ptr @__remill_atomic_end(ptr %v5645)
  store ptr %v5646, ptr %MEMORY, align 4
  store i32 %v5635, ptr %PC, align 4
  %v5647 = add i32 %v5635, 7
  store i32 %v5647, ptr %NEXT_PC, align 4
  %v5648 = load ptr, ptr %MEMORY, align 4
  %v5649 = call ptr @__remill_atomic_begin(ptr %v5648)
  store ptr %v5649, ptr %MEMORY, align 4
  %v5650 = load i32, ptr %ESP, align 4
  %v5651 = load i32, ptr %SSBASE, align 4
  %v5652 = add i32 %v5650, %v5651
  %v5653 = load ptr, ptr %MEMORY, align 4
  %v5654 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5653, ptr %state, i32 %v5652, i32 32)
  store ptr %v5654, ptr %MEMORY, align 4
  %v5655 = load ptr, ptr %MEMORY, align 4
  %v5656 = call ptr @__remill_atomic_end(ptr %v5655)
  store ptr %v5656, ptr %MEMORY, align 4
  store i32 %v5647, ptr %PC, align 4
  %v5657 = add i32 %v5647, 5
  store i32 %v5657, ptr %NEXT_PC, align 4
  %v5658 = load ptr, ptr %MEMORY, align 4
  %v5659 = call ptr @__remill_atomic_begin(ptr %v5658)
  store ptr %v5659, ptr %MEMORY, align 4
  %v5660 = sub i32 %v5657, 324
  %v5661 = load ptr, ptr %MEMORY, align 4
  %v5662 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v5661, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v5657, ptr %RETURN_PC)
  store ptr %v5662, ptr %MEMORY, align 4
  %v5663 = load ptr, ptr %MEMORY, align 4
  %v5664 = call ptr @__remill_atomic_end(ptr %v5663)
  store ptr %v5664, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206574:                                       ; preds = %bb_4206553
  store i32 %v5616, ptr %PC, align 4
  %v5665 = add i32 %v5616, 3
  store i32 %v5665, ptr %NEXT_PC, align 4
  %v5666 = load ptr, ptr %MEMORY, align 4
  %v5667 = call ptr @__remill_atomic_begin(ptr %v5666)
  store ptr %v5667, ptr %MEMORY, align 4
  %v5668 = load i32, ptr %EBP, align 4
  %v5669 = load i32, ptr %SSBASE, align 4
  %v5670 = add i32 %v5668, 16
  %v5671 = add i32 %v5670, %v5669
  %v5672 = load ptr, ptr %MEMORY, align 4
  %v5673 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5672, ptr %state, ptr %EAX, i32 %v5671)
  store ptr %v5673, ptr %MEMORY, align 4
  %v5674 = load ptr, ptr %MEMORY, align 4
  %v5675 = call ptr @__remill_atomic_end(ptr %v5674)
  store ptr %v5675, ptr %MEMORY, align 4
  store i32 %v5665, ptr %PC, align 4
  %v5676 = add i32 %v5665, 3
  store i32 %v5676, ptr %NEXT_PC, align 4
  %v5677 = load ptr, ptr %MEMORY, align 4
  %v5678 = call ptr @__remill_atomic_begin(ptr %v5677)
  store ptr %v5678, ptr %MEMORY, align 4
  %v5679 = load i32, ptr %EAX, align 4
  %v5680 = load i32, ptr %DSBASE, align 4
  %v5681 = add i32 %v5679, 8
  %v5682 = add i32 %v5681, %v5680
  %v5683 = load ptr, ptr %MEMORY, align 4
  %v5684 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5683, ptr %state, ptr %EAX, i32 %v5682)
  store ptr %v5684, ptr %MEMORY, align 4
  %v5685 = load ptr, ptr %MEMORY, align 4
  %v5686 = call ptr @__remill_atomic_end(ptr %v5685)
  store ptr %v5686, ptr %MEMORY, align 4
  store i32 %v5676, ptr %PC, align 4
  %v5687 = add i32 %v5676, 2
  store i32 %v5687, ptr %NEXT_PC, align 4
  %v5688 = load ptr, ptr %MEMORY, align 4
  %v5689 = call ptr @__remill_atomic_begin(ptr %v5688)
  store ptr %v5689, ptr %MEMORY, align 4
  %v5690 = load i32, ptr %EAX, align 4
  %v5691 = load i32, ptr %EAX, align 4
  %v5692 = load ptr, ptr %MEMORY, align 4
  %v5693 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5692, ptr %state, i32 %v5690, i32 %v5691)
  store ptr %v5693, ptr %MEMORY, align 4
  %v5694 = load ptr, ptr %MEMORY, align 4
  %v5695 = call ptr @__remill_atomic_end(ptr %v5694)
  store ptr %v5695, ptr %MEMORY, align 4
  store i32 %v5687, ptr %PC, align 4
  %v5696 = add i32 %v5687, 3
  store i32 %v5696, ptr %NEXT_PC, align 4
  %v5697 = load ptr, ptr %MEMORY, align 4
  %v5698 = call ptr @__remill_atomic_begin(ptr %v5697)
  store ptr %v5698, ptr %MEMORY, align 4
  %v5699 = load ptr, ptr %MEMORY, align 4
  %v5700 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v5699, ptr %state, ptr %DL)
  store ptr %v5700, ptr %MEMORY, align 4
  %v5701 = load ptr, ptr %MEMORY, align 4
  %v5702 = call ptr @__remill_atomic_end(ptr %v5701)
  store ptr %v5702, ptr %MEMORY, align 4
  store i32 %v5696, ptr %PC, align 4
  %v5703 = add i32 %v5696, 3
  store i32 %v5703, ptr %NEXT_PC, align 4
  %v5704 = load ptr, ptr %MEMORY, align 4
  %v5705 = call ptr @__remill_atomic_begin(ptr %v5704)
  store ptr %v5705, ptr %MEMORY, align 4
  %v5706 = load i32, ptr %EAX, align 4
  %v5707 = sub i32 %v5706, 1
  %v5708 = load ptr, ptr %MEMORY, align 4
  %v5709 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v5708, ptr %state, ptr %ECX, i32 %v5707)
  store ptr %v5709, ptr %MEMORY, align 4
  %v5710 = load ptr, ptr %MEMORY, align 4
  %v5711 = call ptr @__remill_atomic_end(ptr %v5710)
  store ptr %v5711, ptr %MEMORY, align 4
  store i32 %v5703, ptr %PC, align 4
  %v5712 = add i32 %v5703, 3
  store i32 %v5712, ptr %NEXT_PC, align 4
  %v5713 = load ptr, ptr %MEMORY, align 4
  %v5714 = call ptr @__remill_atomic_begin(ptr %v5713)
  store ptr %v5714, ptr %MEMORY, align 4
  %v5715 = load i32, ptr %EBP, align 4
  %v5716 = load i32, ptr %SSBASE, align 4
  %v5717 = add i32 %v5715, 16
  %v5718 = add i32 %v5717, %v5716
  %v5719 = load ptr, ptr %MEMORY, align 4
  %v5720 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5719, ptr %state, ptr %EAX, i32 %v5718)
  store ptr %v5720, ptr %MEMORY, align 4
  %v5721 = load ptr, ptr %MEMORY, align 4
  %v5722 = call ptr @__remill_atomic_end(ptr %v5721)
  store ptr %v5722, ptr %MEMORY, align 4
  store i32 %v5712, ptr %PC, align 4
  %v5723 = add i32 %v5712, 3
  store i32 %v5723, ptr %NEXT_PC, align 4
  %v5724 = load ptr, ptr %MEMORY, align 4
  %v5725 = call ptr @__remill_atomic_begin(ptr %v5724)
  store ptr %v5725, ptr %MEMORY, align 4
  %v5726 = load i32, ptr %EAX, align 4
  %v5727 = load i32, ptr %DSBASE, align 4
  %v5728 = add i32 %v5726, 8
  %v5729 = add i32 %v5728, %v5727
  %v5730 = load i32, ptr %ECX, align 4
  %v5731 = load ptr, ptr %MEMORY, align 4
  %v5732 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5731, ptr %state, i32 %v5729, i32 %v5730)
  store ptr %v5732, ptr %MEMORY, align 4
  %v5733 = load ptr, ptr %MEMORY, align 4
  %v5734 = call ptr @__remill_atomic_end(ptr %v5733)
  store ptr %v5734, ptr %MEMORY, align 4
  store i32 %v5723, ptr %PC, align 4
  %v5735 = add i32 %v5723, 2
  store i32 %v5735, ptr %NEXT_PC, align 4
  %v5736 = load ptr, ptr %MEMORY, align 4
  %v5737 = call ptr @__remill_atomic_begin(ptr %v5736)
  store ptr %v5737, ptr %MEMORY, align 4
  %v5738 = load i8, ptr %DL, align 1
  %v5739 = zext i8 %v5738 to i32
  %v5740 = load i8, ptr %DL, align 1
  %v5741 = zext i8 %v5740 to i32
  %v5742 = load ptr, ptr %MEMORY, align 4
  %v5743 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v5742, ptr %state, i32 %v5739, i32 %v5741)
  store ptr %v5743, ptr %MEMORY, align 4
  %v5744 = load ptr, ptr %MEMORY, align 4
  %v5745 = call ptr @__remill_atomic_end(ptr %v5744)
  store ptr %v5745, ptr %MEMORY, align 4
  store i32 %v5735, ptr %PC, align 4
  %v5746 = add i32 %v5735, 2
  store i32 %v5746, ptr %NEXT_PC, align 4
  %v5747 = load ptr, ptr %MEMORY, align 4
  %v5748 = call ptr @__remill_atomic_begin(ptr %v5747)
  store ptr %v5748, ptr %MEMORY, align 4
  %v5749 = sub i32 %v5746, 43
  %v5750 = load ptr, ptr %MEMORY, align 4
  %v5751 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5750, ptr %state, ptr %BRANCH_TAKEN, i32 %v5749, i32 %v5746, ptr %NEXT_PC)
  store ptr %v5751, ptr %MEMORY, align 4
  %v5752 = load ptr, ptr %MEMORY, align 4
  %v5753 = call ptr @__remill_atomic_end(ptr %v5752)
  store ptr %v5753, ptr %MEMORY, align 4
  br i1 true, label %bb_4206555, label %bb_4206598

bb_4206598:                                       ; preds = %bb_4206574
  store i32 %v5746, ptr %PC, align 4
  %v5754 = add i32 %v5746, 1
  store i32 %v5754, ptr %NEXT_PC, align 4
  %v5755 = load ptr, ptr %MEMORY, align 4
  %v5756 = call ptr @__remill_atomic_begin(ptr %v5755)
  store ptr %v5756, ptr %MEMORY, align 4
  %v5757 = load ptr, ptr %MEMORY, align 4
  %v5758 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v5757, ptr %state)
  store ptr %v5758, ptr %MEMORY, align 4
  %v5759 = load ptr, ptr %MEMORY, align 4
  %v5760 = call ptr @__remill_atomic_end(ptr %v5759)
  store ptr %v5760, ptr %MEMORY, align 4
  store i32 %v5754, ptr %PC, align 4
  %v5761 = add i32 %v5754, 1
  store i32 %v5761, ptr %NEXT_PC, align 4
  %v5762 = load ptr, ptr %MEMORY, align 4
  %v5763 = call ptr @__remill_atomic_begin(ptr %v5762)
  store ptr %v5763, ptr %MEMORY, align 4
  %v5764 = load ptr, ptr %MEMORY, align 4
  %v5765 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v5764, ptr %state, ptr %NEXT_PC)
  store ptr %v5765, ptr %MEMORY, align 4
  %v5766 = load ptr, ptr %MEMORY, align 4
  %v5767 = call ptr @__remill_atomic_end(ptr %v5766)
  store ptr %v5767, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206600:                                       ; No predecessors!
  %v5768 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5768, ptr %PC, align 4
  %v5769 = add i32 %v5768, 1
  store i32 %v5769, ptr %NEXT_PC, align 4
  %v5770 = load ptr, ptr %MEMORY, align 4
  %v5771 = call ptr @__remill_atomic_begin(ptr %v5770)
  store ptr %v5771, ptr %MEMORY, align 4
  %v5772 = load i32, ptr %EBP, align 4
  %v5773 = load ptr, ptr %MEMORY, align 4
  %v5774 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v5773, ptr %state, i32 %v5772)
  store ptr %v5774, ptr %MEMORY, align 4
  %v5775 = load ptr, ptr %MEMORY, align 4
  %v5776 = call ptr @__remill_atomic_end(ptr %v5775)
  store ptr %v5776, ptr %MEMORY, align 4
  store i32 %v5769, ptr %PC, align 4
  %v5777 = add i32 %v5769, 2
  store i32 %v5777, ptr %NEXT_PC, align 4
  %v5778 = load ptr, ptr %MEMORY, align 4
  %v5779 = call ptr @__remill_atomic_begin(ptr %v5778)
  store ptr %v5779, ptr %MEMORY, align 4
  %v5780 = load i32, ptr %ESP, align 4
  %v5781 = load ptr, ptr %MEMORY, align 4
  %v5782 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5781, ptr %state, ptr %EBP, i32 %v5780)
  store ptr %v5782, ptr %MEMORY, align 4
  %v5783 = load ptr, ptr %MEMORY, align 4
  %v5784 = call ptr @__remill_atomic_end(ptr %v5783)
  store ptr %v5784, ptr %MEMORY, align 4
  store i32 %v5777, ptr %PC, align 4
  %v5785 = add i32 %v5777, 3
  store i32 %v5785, ptr %NEXT_PC, align 4
  %v5786 = load ptr, ptr %MEMORY, align 4
  %v5787 = call ptr @__remill_atomic_begin(ptr %v5786)
  store ptr %v5787, ptr %MEMORY, align 4
  %v5788 = load i32, ptr %ESP, align 4
  %v5789 = load ptr, ptr %MEMORY, align 4
  %v5790 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5789, ptr %state, ptr %ESP, i32 %v5788, i32 24)
  store ptr %v5790, ptr %MEMORY, align 4
  %v5791 = load ptr, ptr %MEMORY, align 4
  %v5792 = call ptr @__remill_atomic_end(ptr %v5791)
  store ptr %v5792, ptr %MEMORY, align 4
  store i32 %v5785, ptr %PC, align 4
  %v5793 = add i32 %v5785, 4
  store i32 %v5793, ptr %NEXT_PC, align 4
  %v5794 = load ptr, ptr %MEMORY, align 4
  %v5795 = call ptr @__remill_atomic_begin(ptr %v5794)
  store ptr %v5795, ptr %MEMORY, align 4
  %v5796 = load i32, ptr %EBP, align 4
  %v5797 = load i32, ptr %SSBASE, align 4
  %v5798 = add i32 %v5796, 8
  %v5799 = add i32 %v5798, %v5797
  %v5800 = load ptr, ptr %MEMORY, align 4
  %v5801 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5800, ptr %state, i32 %v5799, i32 0)
  store ptr %v5801, ptr %MEMORY, align 4
  %v5802 = load ptr, ptr %MEMORY, align 4
  %v5803 = call ptr @__remill_atomic_end(ptr %v5802)
  store ptr %v5803, ptr %MEMORY, align 4
  store i32 %v5793, ptr %PC, align 4
  %v5804 = add i32 %v5793, 2
  store i32 %v5804, ptr %NEXT_PC, align 4
  %v5805 = load ptr, ptr %MEMORY, align 4
  %v5806 = call ptr @__remill_atomic_begin(ptr %v5805)
  store ptr %v5806, ptr %MEMORY, align 4
  %v5807 = add i32 %v5804, 7
  %v5808 = load ptr, ptr %MEMORY, align 4
  %v5809 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v5808, ptr %state, ptr %BRANCH_TAKEN, i32 %v5807, i32 %v5804, ptr %NEXT_PC)
  store ptr %v5809, ptr %MEMORY, align 4
  %v5810 = load ptr, ptr %MEMORY, align 4
  %v5811 = call ptr @__remill_atomic_end(ptr %v5810)
  store ptr %v5811, ptr %MEMORY, align 4
  br i1 true, label %bb_4206619, label %bb_4206612

bb_4206612:                                       ; preds = %bb_4206600
  store i32 %v5804, ptr %PC, align 4
  %v5812 = add i32 %v5804, 7
  store i32 %v5812, ptr %NEXT_PC, align 4
  %v5813 = load ptr, ptr %MEMORY, align 4
  %v5814 = call ptr @__remill_atomic_begin(ptr %v5813)
  store ptr %v5814, ptr %MEMORY, align 4
  %v5815 = load i32, ptr %EBP, align 4
  %v5816 = load i32, ptr %SSBASE, align 4
  %v5817 = add i32 %v5815, 8
  %v5818 = add i32 %v5817, %v5816
  %v5819 = load ptr, ptr %MEMORY, align 4
  %v5820 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5819, ptr %state, i32 %v5818, i32 4235971)
  store ptr %v5820, ptr %MEMORY, align 4
  %v5821 = load ptr, ptr %MEMORY, align 4
  %v5822 = call ptr @__remill_atomic_end(ptr %v5821)
  store ptr %v5822, ptr %MEMORY, align 4
  br label %bb_4206619

bb_4206619:                                       ; preds = %bb_4206612, %bb_4206600
  %v5823 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5823, ptr %PC, align 4
  %v5824 = add i32 %v5823, 3
  store i32 %v5824, ptr %NEXT_PC, align 4
  %v5825 = load ptr, ptr %MEMORY, align 4
  %v5826 = call ptr @__remill_atomic_begin(ptr %v5825)
  store ptr %v5826, ptr %MEMORY, align 4
  %v5827 = load i32, ptr %EBP, align 4
  %v5828 = load i32, ptr %SSBASE, align 4
  %v5829 = add i32 %v5827, 8
  %v5830 = add i32 %v5829, %v5828
  %v5831 = load ptr, ptr %MEMORY, align 4
  %v5832 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5831, ptr %state, ptr %EAX, i32 %v5830)
  store ptr %v5832, ptr %MEMORY, align 4
  %v5833 = load ptr, ptr %MEMORY, align 4
  %v5834 = call ptr @__remill_atomic_end(ptr %v5833)
  store ptr %v5834, ptr %MEMORY, align 4
  store i32 %v5824, ptr %PC, align 4
  %v5835 = add i32 %v5824, 3
  store i32 %v5835, ptr %NEXT_PC, align 4
  %v5836 = load ptr, ptr %MEMORY, align 4
  %v5837 = call ptr @__remill_atomic_begin(ptr %v5836)
  store ptr %v5837, ptr %MEMORY, align 4
  %v5838 = load i32, ptr %ESP, align 4
  %v5839 = load i32, ptr %SSBASE, align 4
  %v5840 = add i32 %v5838, %v5839
  %v5841 = load i32, ptr %EAX, align 4
  %v5842 = load ptr, ptr %MEMORY, align 4
  %v5843 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5842, ptr %state, i32 %v5840, i32 %v5841)
  store ptr %v5843, ptr %MEMORY, align 4
  %v5844 = load ptr, ptr %MEMORY, align 4
  %v5845 = call ptr @__remill_atomic_end(ptr %v5844)
  store ptr %v5845, ptr %MEMORY, align 4
  store i32 %v5835, ptr %PC, align 4
  %v5846 = add i32 %v5835, 5
  store i32 %v5846, ptr %NEXT_PC, align 4
  %v5847 = load ptr, ptr %MEMORY, align 4
  %v5848 = call ptr @__remill_atomic_begin(ptr %v5847)
  store ptr %v5848, ptr %MEMORY, align 4
  %v5849 = add i32 %v5846, 21942
  %v5850 = load ptr, ptr %MEMORY, align 4
  %v5851 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v5850, ptr %state, i64 4228572, ptr %NEXT_PC, i32 %v5846, ptr %RETURN_PC)
  store ptr %v5851, ptr %MEMORY, align 4
  %v5852 = load ptr, ptr %MEMORY, align 4
  %v5853 = call ptr @__remill_atomic_end(ptr %v5852)
  store ptr %v5853, ptr %MEMORY, align 4
  store i32 %v5846, ptr %PC, align 4
  %v5854 = add i32 %v5846, 3
  store i32 %v5854, ptr %NEXT_PC, align 4
  %v5855 = load ptr, ptr %MEMORY, align 4
  %v5856 = call ptr @__remill_atomic_begin(ptr %v5855)
  store ptr %v5856, ptr %MEMORY, align 4
  %v5857 = load i32, ptr %EBP, align 4
  %v5858 = load i32, ptr %SSBASE, align 4
  %v5859 = add i32 %v5857, 12
  %v5860 = add i32 %v5859, %v5858
  %v5861 = load ptr, ptr %MEMORY, align 4
  %v5862 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5861, ptr %state, ptr %EDX, i32 %v5860)
  store ptr %v5862, ptr %MEMORY, align 4
  %v5863 = load ptr, ptr %MEMORY, align 4
  %v5864 = call ptr @__remill_atomic_end(ptr %v5863)
  store ptr %v5864, ptr %MEMORY, align 4
  store i32 %v5854, ptr %PC, align 4
  %v5865 = add i32 %v5854, 4
  store i32 %v5865, ptr %NEXT_PC, align 4
  %v5866 = load ptr, ptr %MEMORY, align 4
  %v5867 = call ptr @__remill_atomic_begin(ptr %v5866)
  store ptr %v5867, ptr %MEMORY, align 4
  %v5868 = load i32, ptr %ESP, align 4
  %v5869 = load i32, ptr %SSBASE, align 4
  %v5870 = add i32 %v5868, 8
  %v5871 = add i32 %v5870, %v5869
  %v5872 = load i32, ptr %EDX, align 4
  %v5873 = load ptr, ptr %MEMORY, align 4
  %v5874 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5873, ptr %state, i32 %v5871, i32 %v5872)
  store ptr %v5874, ptr %MEMORY, align 4
  %v5875 = load ptr, ptr %MEMORY, align 4
  %v5876 = call ptr @__remill_atomic_end(ptr %v5875)
  store ptr %v5876, ptr %MEMORY, align 4
  store i32 %v5865, ptr %PC, align 4
  %v5877 = add i32 %v5865, 4
  store i32 %v5877, ptr %NEXT_PC, align 4
  %v5878 = load ptr, ptr %MEMORY, align 4
  %v5879 = call ptr @__remill_atomic_begin(ptr %v5878)
  store ptr %v5879, ptr %MEMORY, align 4
  %v5880 = load i32, ptr %ESP, align 4
  %v5881 = load i32, ptr %SSBASE, align 4
  %v5882 = add i32 %v5880, 4
  %v5883 = add i32 %v5882, %v5881
  %v5884 = load i32, ptr %EAX, align 4
  %v5885 = load ptr, ptr %MEMORY, align 4
  %v5886 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5885, ptr %state, i32 %v5883, i32 %v5884)
  store ptr %v5886, ptr %MEMORY, align 4
  %v5887 = load ptr, ptr %MEMORY, align 4
  %v5888 = call ptr @__remill_atomic_end(ptr %v5887)
  store ptr %v5888, ptr %MEMORY, align 4
  store i32 %v5877, ptr %PC, align 4
  %v5889 = add i32 %v5877, 3
  store i32 %v5889, ptr %NEXT_PC, align 4
  %v5890 = load ptr, ptr %MEMORY, align 4
  %v5891 = call ptr @__remill_atomic_begin(ptr %v5890)
  store ptr %v5891, ptr %MEMORY, align 4
  %v5892 = load i32, ptr %EBP, align 4
  %v5893 = load i32, ptr %SSBASE, align 4
  %v5894 = add i32 %v5892, 8
  %v5895 = add i32 %v5894, %v5893
  %v5896 = load ptr, ptr %MEMORY, align 4
  %v5897 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5896, ptr %state, ptr %EAX, i32 %v5895)
  store ptr %v5897, ptr %MEMORY, align 4
  %v5898 = load ptr, ptr %MEMORY, align 4
  %v5899 = call ptr @__remill_atomic_end(ptr %v5898)
  store ptr %v5899, ptr %MEMORY, align 4
  store i32 %v5889, ptr %PC, align 4
  %v5900 = add i32 %v5889, 3
  store i32 %v5900, ptr %NEXT_PC, align 4
  %v5901 = load ptr, ptr %MEMORY, align 4
  %v5902 = call ptr @__remill_atomic_begin(ptr %v5901)
  store ptr %v5902, ptr %MEMORY, align 4
  %v5903 = load i32, ptr %ESP, align 4
  %v5904 = load i32, ptr %SSBASE, align 4
  %v5905 = add i32 %v5903, %v5904
  %v5906 = load i32, ptr %EAX, align 4
  %v5907 = load ptr, ptr %MEMORY, align 4
  %v5908 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5907, ptr %state, i32 %v5905, i32 %v5906)
  store ptr %v5908, ptr %MEMORY, align 4
  %v5909 = load ptr, ptr %MEMORY, align 4
  %v5910 = call ptr @__remill_atomic_end(ptr %v5909)
  store ptr %v5910, ptr %MEMORY, align 4
  store i32 %v5900, ptr %PC, align 4
  %v5911 = add i32 %v5900, 5
  store i32 %v5911, ptr %NEXT_PC, align 4
  %v5912 = load ptr, ptr %MEMORY, align 4
  %v5913 = call ptr @__remill_atomic_begin(ptr %v5912)
  store ptr %v5913, ptr %MEMORY, align 4
  %v5914 = sub i32 %v5911, 293
  %v5915 = load ptr, ptr %MEMORY, align 4
  %v5916 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v5915, ptr %state, i64 4206359, ptr %NEXT_PC, i32 %v5911, ptr %RETURN_PC)
  store ptr %v5916, ptr %MEMORY, align 4
  %v5917 = load ptr, ptr %MEMORY, align 4
  %v5918 = call ptr @__remill_atomic_end(ptr %v5917)
  store ptr %v5918, ptr %MEMORY, align 4
  store i32 %v5911, ptr %PC, align 4
  %v5919 = add i32 %v5911, 1
  store i32 %v5919, ptr %NEXT_PC, align 4
  %v5920 = load ptr, ptr %MEMORY, align 4
  %v5921 = call ptr @__remill_atomic_begin(ptr %v5920)
  store ptr %v5921, ptr %MEMORY, align 4
  %v5922 = load ptr, ptr %MEMORY, align 4
  %v5923 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v5922, ptr %state)
  store ptr %v5923, ptr %MEMORY, align 4
  %v5924 = load ptr, ptr %MEMORY, align 4
  %v5925 = call ptr @__remill_atomic_end(ptr %v5924)
  store ptr %v5925, ptr %MEMORY, align 4
  store i32 %v5919, ptr %PC, align 4
  %v5926 = add i32 %v5919, 1
  store i32 %v5926, ptr %NEXT_PC, align 4
  %v5927 = load ptr, ptr %MEMORY, align 4
  %v5928 = call ptr @__remill_atomic_begin(ptr %v5927)
  store ptr %v5928, ptr %MEMORY, align 4
  %v5929 = load ptr, ptr %MEMORY, align 4
  %v5930 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v5929, ptr %state, ptr %NEXT_PC)
  store ptr %v5930, ptr %MEMORY, align 4
  %v5931 = load ptr, ptr %MEMORY, align 4
  %v5932 = call ptr @__remill_atomic_end(ptr %v5931)
  store ptr %v5932, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206654:                                       ; No predecessors!
  %v5933 = load i32, ptr %NEXT_PC, align 4
  store i32 %v5933, ptr %PC, align 4
  %v5934 = add i32 %v5933, 1
  store i32 %v5934, ptr %NEXT_PC, align 4
  %v5935 = load ptr, ptr %MEMORY, align 4
  %v5936 = call ptr @__remill_atomic_begin(ptr %v5935)
  store ptr %v5936, ptr %MEMORY, align 4
  %v5937 = load i32, ptr %EBP, align 4
  %v5938 = load ptr, ptr %MEMORY, align 4
  %v5939 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v5938, ptr %state, i32 %v5937)
  store ptr %v5939, ptr %MEMORY, align 4
  %v5940 = load ptr, ptr %MEMORY, align 4
  %v5941 = call ptr @__remill_atomic_end(ptr %v5940)
  store ptr %v5941, ptr %MEMORY, align 4
  store i32 %v5934, ptr %PC, align 4
  %v5942 = add i32 %v5934, 2
  store i32 %v5942, ptr %NEXT_PC, align 4
  %v5943 = load ptr, ptr %MEMORY, align 4
  %v5944 = call ptr @__remill_atomic_begin(ptr %v5943)
  store ptr %v5944, ptr %MEMORY, align 4
  %v5945 = load i32, ptr %ESP, align 4
  %v5946 = load ptr, ptr %MEMORY, align 4
  %v5947 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5946, ptr %state, ptr %EBP, i32 %v5945)
  store ptr %v5947, ptr %MEMORY, align 4
  %v5948 = load ptr, ptr %MEMORY, align 4
  %v5949 = call ptr @__remill_atomic_end(ptr %v5948)
  store ptr %v5949, ptr %MEMORY, align 4
  store i32 %v5942, ptr %PC, align 4
  %v5950 = add i32 %v5942, 3
  store i32 %v5950, ptr %NEXT_PC, align 4
  %v5951 = load ptr, ptr %MEMORY, align 4
  %v5952 = call ptr @__remill_atomic_begin(ptr %v5951)
  store ptr %v5952, ptr %MEMORY, align 4
  %v5953 = load i32, ptr %ESP, align 4
  %v5954 = load ptr, ptr %MEMORY, align 4
  %v5955 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v5954, ptr %state, ptr %ESP, i32 %v5953, i32 56)
  store ptr %v5955, ptr %MEMORY, align 4
  %v5956 = load ptr, ptr %MEMORY, align 4
  %v5957 = call ptr @__remill_atomic_end(ptr %v5956)
  store ptr %v5957, ptr %MEMORY, align 4
  store i32 %v5950, ptr %PC, align 4
  %v5958 = add i32 %v5950, 3
  store i32 %v5958, ptr %NEXT_PC, align 4
  %v5959 = load ptr, ptr %MEMORY, align 4
  %v5960 = call ptr @__remill_atomic_begin(ptr %v5959)
  store ptr %v5960, ptr %MEMORY, align 4
  %v5961 = load i32, ptr %EBP, align 4
  %v5962 = sub i32 %v5961, 36
  %v5963 = load ptr, ptr %MEMORY, align 4
  %v5964 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v5963, ptr %state, ptr %EAX, i32 %v5962)
  store ptr %v5964, ptr %MEMORY, align 4
  %v5965 = load ptr, ptr %MEMORY, align 4
  %v5966 = call ptr @__remill_atomic_end(ptr %v5965)
  store ptr %v5966, ptr %MEMORY, align 4
  store i32 %v5958, ptr %PC, align 4
  %v5967 = add i32 %v5958, 4
  store i32 %v5967, ptr %NEXT_PC, align 4
  %v5968 = load ptr, ptr %MEMORY, align 4
  %v5969 = call ptr @__remill_atomic_begin(ptr %v5968)
  store ptr %v5969, ptr %MEMORY, align 4
  %v5970 = load i32, ptr %ESP, align 4
  %v5971 = load i32, ptr %SSBASE, align 4
  %v5972 = add i32 %v5970, 8
  %v5973 = add i32 %v5972, %v5971
  %v5974 = load i32, ptr %EAX, align 4
  %v5975 = load ptr, ptr %MEMORY, align 4
  %v5976 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v5975, ptr %state, i32 %v5973, i32 %v5974)
  store ptr %v5976, ptr %MEMORY, align 4
  %v5977 = load ptr, ptr %MEMORY, align 4
  %v5978 = call ptr @__remill_atomic_end(ptr %v5977)
  store ptr %v5978, ptr %MEMORY, align 4
  store i32 %v5967, ptr %PC, align 4
  %v5979 = add i32 %v5967, 8
  store i32 %v5979, ptr %NEXT_PC, align 4
  %v5980 = load ptr, ptr %MEMORY, align 4
  %v5981 = call ptr @__remill_atomic_begin(ptr %v5980)
  store ptr %v5981, ptr %MEMORY, align 4
  %v5982 = load i32, ptr %ESP, align 4
  %v5983 = load i32, ptr %SSBASE, align 4
  %v5984 = add i32 %v5982, 4
  %v5985 = add i32 %v5984, %v5983
  %v5986 = load ptr, ptr %MEMORY, align 4
  %v5987 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v5986, ptr %state, i32 %v5985, i32 0)
  store ptr %v5987, ptr %MEMORY, align 4
  %v5988 = load ptr, ptr %MEMORY, align 4
  %v5989 = call ptr @__remill_atomic_end(ptr %v5988)
  store ptr %v5989, ptr %MEMORY, align 4
  store i32 %v5979, ptr %PC, align 4
  %v5990 = add i32 %v5979, 3
  store i32 %v5990, ptr %NEXT_PC, align 4
  %v5991 = load ptr, ptr %MEMORY, align 4
  %v5992 = call ptr @__remill_atomic_begin(ptr %v5991)
  store ptr %v5992, ptr %MEMORY, align 4
  %v5993 = load i32, ptr %EBP, align 4
  %v5994 = sub i32 %v5993, 32
  %v5995 = load ptr, ptr %MEMORY, align 4
  %v5996 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v5995, ptr %state, ptr %EAX, i32 %v5994)
  store ptr %v5996, ptr %MEMORY, align 4
  %v5997 = load ptr, ptr %MEMORY, align 4
  %v5998 = call ptr @__remill_atomic_end(ptr %v5997)
  store ptr %v5998, ptr %MEMORY, align 4
  store i32 %v5990, ptr %PC, align 4
  %v5999 = add i32 %v5990, 3
  store i32 %v5999, ptr %NEXT_PC, align 4
  %v6000 = load ptr, ptr %MEMORY, align 4
  %v6001 = call ptr @__remill_atomic_begin(ptr %v6000)
  store ptr %v6001, ptr %MEMORY, align 4
  %v6002 = load i32, ptr %ESP, align 4
  %v6003 = load i32, ptr %SSBASE, align 4
  %v6004 = add i32 %v6002, %v6003
  %v6005 = load i32, ptr %EAX, align 4
  %v6006 = load ptr, ptr %MEMORY, align 4
  %v6007 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6006, ptr %state, i32 %v6004, i32 %v6005)
  store ptr %v6007, ptr %MEMORY, align 4
  %v6008 = load ptr, ptr %MEMORY, align 4
  %v6009 = call ptr @__remill_atomic_end(ptr %v6008)
  store ptr %v6009, ptr %MEMORY, align 4
  store i32 %v5999, ptr %PC, align 4
  %v6010 = add i32 %v5999, 5
  store i32 %v6010, ptr %NEXT_PC, align 4
  %v6011 = load ptr, ptr %MEMORY, align 4
  %v6012 = call ptr @__remill_atomic_begin(ptr %v6011)
  store ptr %v6012, ptr %MEMORY, align 4
  %v6013 = add i32 %v6010, 9400
  %v6014 = load ptr, ptr %MEMORY, align 4
  %v6015 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v6014, ptr %state, i64 4216086, ptr %NEXT_PC, i32 %v6010, ptr %RETURN_PC)
  store ptr %v6015, ptr %MEMORY, align 4
  %v6016 = load ptr, ptr %MEMORY, align 4
  %v6017 = call ptr @__remill_atomic_end(ptr %v6016)
  store ptr %v6017, ptr %MEMORY, align 4
  store i32 %v6010, ptr %PC, align 4
  %v6018 = add i32 %v6010, 3
  store i32 %v6018, ptr %NEXT_PC, align 4
  %v6019 = load ptr, ptr %MEMORY, align 4
  %v6020 = call ptr @__remill_atomic_begin(ptr %v6019)
  store ptr %v6020, ptr %MEMORY, align 4
  %v6021 = load i32, ptr %EBP, align 4
  %v6022 = load i32, ptr %SSBASE, align 4
  %v6023 = sub i32 %v6021, 12
  %v6024 = add i32 %v6023, %v6022
  %v6025 = load i32, ptr %EAX, align 4
  %v6026 = load ptr, ptr %MEMORY, align 4
  %v6027 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6026, ptr %state, i32 %v6024, i32 %v6025)
  store ptr %v6027, ptr %MEMORY, align 4
  %v6028 = load ptr, ptr %MEMORY, align 4
  %v6029 = call ptr @__remill_atomic_end(ptr %v6028)
  store ptr %v6029, ptr %MEMORY, align 4
  store i32 %v6018, ptr %PC, align 4
  %v6030 = add i32 %v6018, 3
  store i32 %v6030, ptr %NEXT_PC, align 4
  %v6031 = load ptr, ptr %MEMORY, align 4
  %v6032 = call ptr @__remill_atomic_begin(ptr %v6031)
  store ptr %v6032, ptr %MEMORY, align 4
  %v6033 = load i32, ptr %EBP, align 4
  %v6034 = load i32, ptr %SSBASE, align 4
  %v6035 = add i32 %v6033, 16
  %v6036 = add i32 %v6035, %v6034
  %v6037 = load ptr, ptr %MEMORY, align 4
  %v6038 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6037, ptr %state, ptr %EAX, i32 %v6036)
  store ptr %v6038, ptr %MEMORY, align 4
  %v6039 = load ptr, ptr %MEMORY, align 4
  %v6040 = call ptr @__remill_atomic_end(ptr %v6039)
  store ptr %v6040, ptr %MEMORY, align 4
  store i32 %v6030, ptr %PC, align 4
  %v6041 = add i32 %v6030, 3
  store i32 %v6041, ptr %NEXT_PC, align 4
  %v6042 = load ptr, ptr %MEMORY, align 4
  %v6043 = call ptr @__remill_atomic_begin(ptr %v6042)
  store ptr %v6043, ptr %MEMORY, align 4
  %v6044 = load i32, ptr %EAX, align 4
  %v6045 = load i32, ptr %DSBASE, align 4
  %v6046 = add i32 %v6044, 12
  %v6047 = add i32 %v6046, %v6045
  %v6048 = load ptr, ptr %MEMORY, align 4
  %v6049 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6048, ptr %state, ptr %EAX, i32 %v6047)
  store ptr %v6049, ptr %MEMORY, align 4
  %v6050 = load ptr, ptr %MEMORY, align 4
  %v6051 = call ptr @__remill_atomic_end(ptr %v6050)
  store ptr %v6051, ptr %MEMORY, align 4
  store i32 %v6041, ptr %PC, align 4
  %v6052 = add i32 %v6041, 2
  store i32 %v6052, ptr %NEXT_PC, align 4
  %v6053 = load ptr, ptr %MEMORY, align 4
  %v6054 = call ptr @__remill_atomic_begin(ptr %v6053)
  store ptr %v6054, ptr %MEMORY, align 4
  %v6055 = load i32, ptr %EAX, align 4
  %v6056 = load i32, ptr %EAX, align 4
  %v6057 = load ptr, ptr %MEMORY, align 4
  %v6058 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6057, ptr %state, i32 %v6055, i32 %v6056)
  store ptr %v6058, ptr %MEMORY, align 4
  %v6059 = load ptr, ptr %MEMORY, align 4
  %v6060 = call ptr @__remill_atomic_end(ptr %v6059)
  store ptr %v6060, ptr %MEMORY, align 4
  store i32 %v6052, ptr %PC, align 4
  %v6061 = add i32 %v6052, 2
  store i32 %v6061, ptr %NEXT_PC, align 4
  %v6062 = load ptr, ptr %MEMORY, align 4
  %v6063 = call ptr @__remill_atomic_begin(ptr %v6062)
  store ptr %v6063, ptr %MEMORY, align 4
  %v6064 = add i32 %v6061, 20
  %v6065 = load ptr, ptr %MEMORY, align 4
  %v6066 = call ptr @_ZN12_GLOBAL__N_12JSEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6065, ptr %state, ptr %BRANCH_TAKEN, i32 %v6064, i32 %v6061, ptr %NEXT_PC)
  store ptr %v6066, ptr %MEMORY, align 4
  %v6067 = load ptr, ptr %MEMORY, align 4
  %v6068 = call ptr @__remill_atomic_end(ptr %v6067)
  store ptr %v6068, ptr %MEMORY, align 4
  br i1 true, label %bb_4206719, label %bb_4206699

bb_4206699:                                       ; preds = %bb_4206654
  store i32 %v6061, ptr %PC, align 4
  %v6069 = add i32 %v6061, 3
  store i32 %v6069, ptr %NEXT_PC, align 4
  %v6070 = load ptr, ptr %MEMORY, align 4
  %v6071 = call ptr @__remill_atomic_begin(ptr %v6070)
  store ptr %v6071, ptr %MEMORY, align 4
  %v6072 = load i32, ptr %EBP, align 4
  %v6073 = load i32, ptr %SSBASE, align 4
  %v6074 = add i32 %v6072, 16
  %v6075 = add i32 %v6074, %v6073
  %v6076 = load ptr, ptr %MEMORY, align 4
  %v6077 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6076, ptr %state, ptr %EAX, i32 %v6075)
  store ptr %v6077, ptr %MEMORY, align 4
  %v6078 = load ptr, ptr %MEMORY, align 4
  %v6079 = call ptr @__remill_atomic_end(ptr %v6078)
  store ptr %v6079, ptr %MEMORY, align 4
  store i32 %v6069, ptr %PC, align 4
  %v6080 = add i32 %v6069, 3
  store i32 %v6080, ptr %NEXT_PC, align 4
  %v6081 = load ptr, ptr %MEMORY, align 4
  %v6082 = call ptr @__remill_atomic_begin(ptr %v6081)
  store ptr %v6082, ptr %MEMORY, align 4
  %v6083 = load i32, ptr %EAX, align 4
  %v6084 = load i32, ptr %DSBASE, align 4
  %v6085 = add i32 %v6083, 12
  %v6086 = add i32 %v6085, %v6084
  %v6087 = load ptr, ptr %MEMORY, align 4
  %v6088 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6087, ptr %state, ptr %EAX, i32 %v6086)
  store ptr %v6088, ptr %MEMORY, align 4
  %v6089 = load ptr, ptr %MEMORY, align 4
  %v6090 = call ptr @__remill_atomic_end(ptr %v6089)
  store ptr %v6090, ptr %MEMORY, align 4
  store i32 %v6080, ptr %PC, align 4
  %v6091 = add i32 %v6080, 3
  store i32 %v6091, ptr %NEXT_PC, align 4
  %v6092 = load ptr, ptr %MEMORY, align 4
  %v6093 = call ptr @__remill_atomic_begin(ptr %v6092)
  store ptr %v6093, ptr %MEMORY, align 4
  %v6094 = load i32, ptr %EAX, align 4
  %v6095 = load i32, ptr %EBP, align 4
  %v6096 = load i32, ptr %SSBASE, align 4
  %v6097 = add i32 %v6095, 12
  %v6098 = add i32 %v6097, %v6096
  %v6099 = load ptr, ptr %MEMORY, align 4
  %v6100 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6099, ptr %state, i32 %v6094, i32 %v6098)
  store ptr %v6100, ptr %MEMORY, align 4
  %v6101 = load ptr, ptr %MEMORY, align 4
  %v6102 = call ptr @__remill_atomic_end(ptr %v6101)
  store ptr %v6102, ptr %MEMORY, align 4
  store i32 %v6091, ptr %PC, align 4
  %v6103 = add i32 %v6091, 2
  store i32 %v6103, ptr %NEXT_PC, align 4
  %v6104 = load ptr, ptr %MEMORY, align 4
  %v6105 = call ptr @__remill_atomic_begin(ptr %v6104)
  store ptr %v6105, ptr %MEMORY, align 4
  %v6106 = add i32 %v6103, 9
  %v6107 = load ptr, ptr %MEMORY, align 4
  %v6108 = call ptr @_ZN12_GLOBAL__N_13JNLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6107, ptr %state, ptr %BRANCH_TAKEN, i32 %v6106, i32 %v6103, ptr %NEXT_PC)
  store ptr %v6108, ptr %MEMORY, align 4
  %v6109 = load ptr, ptr %MEMORY, align 4
  %v6110 = call ptr @__remill_atomic_end(ptr %v6109)
  store ptr %v6110, ptr %MEMORY, align 4
  br i1 true, label %bb_4206719, label %bb_4206710

bb_4206710:                                       ; preds = %bb_4206699
  store i32 %v6103, ptr %PC, align 4
  %v6111 = add i32 %v6103, 3
  store i32 %v6111, ptr %NEXT_PC, align 4
  %v6112 = load ptr, ptr %MEMORY, align 4
  %v6113 = call ptr @__remill_atomic_begin(ptr %v6112)
  store ptr %v6113, ptr %MEMORY, align 4
  %v6114 = load i32, ptr %EBP, align 4
  %v6115 = load i32, ptr %SSBASE, align 4
  %v6116 = add i32 %v6114, 16
  %v6117 = add i32 %v6116, %v6115
  %v6118 = load ptr, ptr %MEMORY, align 4
  %v6119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6118, ptr %state, ptr %EAX, i32 %v6117)
  store ptr %v6119, ptr %MEMORY, align 4
  %v6120 = load ptr, ptr %MEMORY, align 4
  %v6121 = call ptr @__remill_atomic_end(ptr %v6120)
  store ptr %v6121, ptr %MEMORY, align 4
  store i32 %v6111, ptr %PC, align 4
  %v6122 = add i32 %v6111, 3
  store i32 %v6122, ptr %NEXT_PC, align 4
  %v6123 = load ptr, ptr %MEMORY, align 4
  %v6124 = call ptr @__remill_atomic_begin(ptr %v6123)
  store ptr %v6124, ptr %MEMORY, align 4
  %v6125 = load i32, ptr %EAX, align 4
  %v6126 = load i32, ptr %DSBASE, align 4
  %v6127 = add i32 %v6125, 12
  %v6128 = add i32 %v6127, %v6126
  %v6129 = load ptr, ptr %MEMORY, align 4
  %v6130 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6129, ptr %state, ptr %EAX, i32 %v6128)
  store ptr %v6130, ptr %MEMORY, align 4
  %v6131 = load ptr, ptr %MEMORY, align 4
  %v6132 = call ptr @__remill_atomic_end(ptr %v6131)
  store ptr %v6132, ptr %MEMORY, align 4
  store i32 %v6122, ptr %PC, align 4
  %v6133 = add i32 %v6122, 3
  store i32 %v6133, ptr %NEXT_PC, align 4
  %v6134 = load ptr, ptr %MEMORY, align 4
  %v6135 = call ptr @__remill_atomic_begin(ptr %v6134)
  store ptr %v6135, ptr %MEMORY, align 4
  %v6136 = load i32, ptr %EBP, align 4
  %v6137 = load i32, ptr %SSBASE, align 4
  %v6138 = add i32 %v6136, 12
  %v6139 = add i32 %v6138, %v6137
  %v6140 = load i32, ptr %EAX, align 4
  %v6141 = load ptr, ptr %MEMORY, align 4
  %v6142 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6141, ptr %state, i32 %v6139, i32 %v6140)
  store ptr %v6142, ptr %MEMORY, align 4
  %v6143 = load ptr, ptr %MEMORY, align 4
  %v6144 = call ptr @__remill_atomic_end(ptr %v6143)
  store ptr %v6144, ptr %MEMORY, align 4
  br label %bb_4206719

bb_4206719:                                       ; preds = %bb_4206710, %bb_4206699, %bb_4206654
  %v6145 = load i32, ptr %NEXT_PC, align 4
  store i32 %v6145, ptr %PC, align 4
  %v6146 = add i32 %v6145, 3
  store i32 %v6146, ptr %NEXT_PC, align 4
  %v6147 = load ptr, ptr %MEMORY, align 4
  %v6148 = call ptr @__remill_atomic_begin(ptr %v6147)
  store ptr %v6148, ptr %MEMORY, align 4
  %v6149 = load i32, ptr %EBP, align 4
  %v6150 = load i32, ptr %SSBASE, align 4
  %v6151 = add i32 %v6149, 16
  %v6152 = add i32 %v6151, %v6150
  %v6153 = load ptr, ptr %MEMORY, align 4
  %v6154 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6153, ptr %state, ptr %EAX, i32 %v6152)
  store ptr %v6154, ptr %MEMORY, align 4
  %v6155 = load ptr, ptr %MEMORY, align 4
  %v6156 = call ptr @__remill_atomic_end(ptr %v6155)
  store ptr %v6156, ptr %MEMORY, align 4
  store i32 %v6146, ptr %PC, align 4
  %v6157 = add i32 %v6146, 3
  store i32 %v6157, ptr %NEXT_PC, align 4
  %v6158 = load ptr, ptr %MEMORY, align 4
  %v6159 = call ptr @__remill_atomic_begin(ptr %v6158)
  store ptr %v6159, ptr %MEMORY, align 4
  %v6160 = load i32, ptr %EAX, align 4
  %v6161 = load i32, ptr %DSBASE, align 4
  %v6162 = add i32 %v6160, 8
  %v6163 = add i32 %v6162, %v6161
  %v6164 = load ptr, ptr %MEMORY, align 4
  %v6165 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6164, ptr %state, ptr %EAX, i32 %v6163)
  store ptr %v6165, ptr %MEMORY, align 4
  %v6166 = load ptr, ptr %MEMORY, align 4
  %v6167 = call ptr @__remill_atomic_end(ptr %v6166)
  store ptr %v6167, ptr %MEMORY, align 4
  store i32 %v6157, ptr %PC, align 4
  %v6168 = add i32 %v6157, 3
  store i32 %v6168, ptr %NEXT_PC, align 4
  %v6169 = load ptr, ptr %MEMORY, align 4
  %v6170 = call ptr @__remill_atomic_begin(ptr %v6169)
  store ptr %v6170, ptr %MEMORY, align 4
  %v6171 = load i32, ptr %EAX, align 4
  %v6172 = load i32, ptr %EBP, align 4
  %v6173 = load i32, ptr %SSBASE, align 4
  %v6174 = add i32 %v6172, 12
  %v6175 = add i32 %v6174, %v6173
  %v6176 = load ptr, ptr %MEMORY, align 4
  %v6177 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6176, ptr %state, i32 %v6171, i32 %v6175)
  store ptr %v6177, ptr %MEMORY, align 4
  %v6178 = load ptr, ptr %MEMORY, align 4
  %v6179 = call ptr @__remill_atomic_end(ptr %v6178)
  store ptr %v6179, ptr %MEMORY, align 4
  store i32 %v6168, ptr %PC, align 4
  %v6180 = add i32 %v6168, 2
  store i32 %v6180, ptr %NEXT_PC, align 4
  %v6181 = load ptr, ptr %MEMORY, align 4
  %v6182 = call ptr @__remill_atomic_begin(ptr %v6181)
  store ptr %v6182, ptr %MEMORY, align 4
  %v6183 = add i32 %v6180, 19
  %v6184 = load ptr, ptr %MEMORY, align 4
  %v6185 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6184, ptr %state, ptr %BRANCH_TAKEN, i32 %v6183, i32 %v6180, ptr %NEXT_PC)
  store ptr %v6185, ptr %MEMORY, align 4
  %v6186 = load ptr, ptr %MEMORY, align 4
  %v6187 = call ptr @__remill_atomic_end(ptr %v6186)
  store ptr %v6187, ptr %MEMORY, align 4
  br i1 true, label %bb_4206749, label %bb_4206730

bb_4206730:                                       ; preds = %bb_4206719
  store i32 %v6180, ptr %PC, align 4
  %v6188 = add i32 %v6180, 3
  store i32 %v6188, ptr %NEXT_PC, align 4
  %v6189 = load ptr, ptr %MEMORY, align 4
  %v6190 = call ptr @__remill_atomic_begin(ptr %v6189)
  store ptr %v6190, ptr %MEMORY, align 4
  %v6191 = load i32, ptr %EBP, align 4
  %v6192 = load i32, ptr %SSBASE, align 4
  %v6193 = add i32 %v6191, 16
  %v6194 = add i32 %v6193, %v6192
  %v6195 = load ptr, ptr %MEMORY, align 4
  %v6196 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6195, ptr %state, ptr %EAX, i32 %v6194)
  store ptr %v6196, ptr %MEMORY, align 4
  %v6197 = load ptr, ptr %MEMORY, align 4
  %v6198 = call ptr @__remill_atomic_end(ptr %v6197)
  store ptr %v6198, ptr %MEMORY, align 4
  store i32 %v6188, ptr %PC, align 4
  %v6199 = add i32 %v6188, 3
  store i32 %v6199, ptr %NEXT_PC, align 4
  %v6200 = load ptr, ptr %MEMORY, align 4
  %v6201 = call ptr @__remill_atomic_begin(ptr %v6200)
  store ptr %v6201, ptr %MEMORY, align 4
  %v6202 = load i32, ptr %EAX, align 4
  %v6203 = load i32, ptr %DSBASE, align 4
  %v6204 = add i32 %v6202, 8
  %v6205 = add i32 %v6204, %v6203
  %v6206 = load ptr, ptr %MEMORY, align 4
  %v6207 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6206, ptr %state, ptr %EAX, i32 %v6205)
  store ptr %v6207, ptr %MEMORY, align 4
  %v6208 = load ptr, ptr %MEMORY, align 4
  %v6209 = call ptr @__remill_atomic_end(ptr %v6208)
  store ptr %v6209, ptr %MEMORY, align 4
  store i32 %v6199, ptr %PC, align 4
  %v6210 = add i32 %v6199, 2
  store i32 %v6210, ptr %NEXT_PC, align 4
  %v6211 = load ptr, ptr %MEMORY, align 4
  %v6212 = call ptr @__remill_atomic_begin(ptr %v6211)
  store ptr %v6212, ptr %MEMORY, align 4
  %v6213 = load i32, ptr %EAX, align 4
  %v6214 = load ptr, ptr %MEMORY, align 4
  %v6215 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6214, ptr %state, ptr %EDX, i32 %v6213)
  store ptr %v6215, ptr %MEMORY, align 4
  %v6216 = load ptr, ptr %MEMORY, align 4
  %v6217 = call ptr @__remill_atomic_end(ptr %v6216)
  store ptr %v6217, ptr %MEMORY, align 4
  store i32 %v6210, ptr %PC, align 4
  %v6218 = add i32 %v6210, 3
  store i32 %v6218, ptr %NEXT_PC, align 4
  %v6219 = load ptr, ptr %MEMORY, align 4
  %v6220 = call ptr @__remill_atomic_begin(ptr %v6219)
  store ptr %v6220, ptr %MEMORY, align 4
  %v6221 = load i32, ptr %EDX, align 4
  %v6222 = load i32, ptr %EBP, align 4
  %v6223 = load i32, ptr %SSBASE, align 4
  %v6224 = add i32 %v6222, 12
  %v6225 = add i32 %v6224, %v6223
  %v6226 = load ptr, ptr %MEMORY, align 4
  %v6227 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2MnIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v6226, ptr %state, ptr %EDX, i32 %v6221, i32 %v6225)
  store ptr %v6227, ptr %MEMORY, align 4
  %v6228 = load ptr, ptr %MEMORY, align 4
  %v6229 = call ptr @__remill_atomic_end(ptr %v6228)
  store ptr %v6229, ptr %MEMORY, align 4
  store i32 %v6218, ptr %PC, align 4
  %v6230 = add i32 %v6218, 3
  store i32 %v6230, ptr %NEXT_PC, align 4
  %v6231 = load ptr, ptr %MEMORY, align 4
  %v6232 = call ptr @__remill_atomic_begin(ptr %v6231)
  store ptr %v6232, ptr %MEMORY, align 4
  %v6233 = load i32, ptr %EBP, align 4
  %v6234 = load i32, ptr %SSBASE, align 4
  %v6235 = add i32 %v6233, 16
  %v6236 = add i32 %v6235, %v6234
  %v6237 = load ptr, ptr %MEMORY, align 4
  %v6238 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6237, ptr %state, ptr %EAX, i32 %v6236)
  store ptr %v6238, ptr %MEMORY, align 4
  %v6239 = load ptr, ptr %MEMORY, align 4
  %v6240 = call ptr @__remill_atomic_end(ptr %v6239)
  store ptr %v6240, ptr %MEMORY, align 4
  store i32 %v6230, ptr %PC, align 4
  %v6241 = add i32 %v6230, 3
  store i32 %v6241, ptr %NEXT_PC, align 4
  %v6242 = load ptr, ptr %MEMORY, align 4
  %v6243 = call ptr @__remill_atomic_begin(ptr %v6242)
  store ptr %v6243, ptr %MEMORY, align 4
  %v6244 = load i32, ptr %EAX, align 4
  %v6245 = load i32, ptr %DSBASE, align 4
  %v6246 = add i32 %v6244, 8
  %v6247 = add i32 %v6246, %v6245
  %v6248 = load i32, ptr %EDX, align 4
  %v6249 = load ptr, ptr %MEMORY, align 4
  %v6250 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6249, ptr %state, i32 %v6247, i32 %v6248)
  store ptr %v6250, ptr %MEMORY, align 4
  %v6251 = load ptr, ptr %MEMORY, align 4
  %v6252 = call ptr @__remill_atomic_end(ptr %v6251)
  store ptr %v6252, ptr %MEMORY, align 4
  store i32 %v6241, ptr %PC, align 4
  %v6253 = add i32 %v6241, 2
  store i32 %v6253, ptr %NEXT_PC, align 4
  %v6254 = load ptr, ptr %MEMORY, align 4
  %v6255 = call ptr @__remill_atomic_begin(ptr %v6254)
  store ptr %v6255, ptr %MEMORY, align 4
  %v6256 = add i32 %v6253, 10
  %v6257 = load ptr, ptr %MEMORY, align 4
  %v6258 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6257, ptr %state, i32 %v6256, ptr %NEXT_PC)
  store ptr %v6258, ptr %MEMORY, align 4
  %v6259 = load ptr, ptr %MEMORY, align 4
  %v6260 = call ptr @__remill_atomic_end(ptr %v6259)
  store ptr %v6260, ptr %MEMORY, align 4
  br label %bb_4206759

bb_4206749:                                       ; preds = %bb_4206719
  store i32 %v6180, ptr %PC, align 4
  %v6261 = add i32 %v6180, 3
  store i32 %v6261, ptr %NEXT_PC, align 4
  %v6262 = load ptr, ptr %MEMORY, align 4
  %v6263 = call ptr @__remill_atomic_begin(ptr %v6262)
  store ptr %v6263, ptr %MEMORY, align 4
  %v6264 = load i32, ptr %EBP, align 4
  %v6265 = load i32, ptr %SSBASE, align 4
  %v6266 = add i32 %v6264, 16
  %v6267 = add i32 %v6266, %v6265
  %v6268 = load ptr, ptr %MEMORY, align 4
  %v6269 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6268, ptr %state, ptr %EAX, i32 %v6267)
  store ptr %v6269, ptr %MEMORY, align 4
  %v6270 = load ptr, ptr %MEMORY, align 4
  %v6271 = call ptr @__remill_atomic_end(ptr %v6270)
  store ptr %v6271, ptr %MEMORY, align 4
  store i32 %v6261, ptr %PC, align 4
  %v6272 = add i32 %v6261, 7
  store i32 %v6272, ptr %NEXT_PC, align 4
  %v6273 = load ptr, ptr %MEMORY, align 4
  %v6274 = call ptr @__remill_atomic_begin(ptr %v6273)
  store ptr %v6274, ptr %MEMORY, align 4
  %v6275 = load i32, ptr %EAX, align 4
  %v6276 = load i32, ptr %DSBASE, align 4
  %v6277 = add i32 %v6275, 8
  %v6278 = add i32 %v6277, %v6276
  %v6279 = load ptr, ptr %MEMORY, align 4
  %v6280 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6279, ptr %state, i32 %v6278, i32 -1)
  store ptr %v6280, ptr %MEMORY, align 4
  %v6281 = load ptr, ptr %MEMORY, align 4
  %v6282 = call ptr @__remill_atomic_end(ptr %v6281)
  store ptr %v6282, ptr %MEMORY, align 4
  br label %bb_4206759

bb_4206759:                                       ; preds = %bb_4206749, %bb_4206730
  %v6283 = load i32, ptr %NEXT_PC, align 4
  store i32 %v6283, ptr %PC, align 4
  %v6284 = add i32 %v6283, 3
  store i32 %v6284, ptr %NEXT_PC, align 4
  %v6285 = load ptr, ptr %MEMORY, align 4
  %v6286 = call ptr @__remill_atomic_begin(ptr %v6285)
  store ptr %v6286, ptr %MEMORY, align 4
  %v6287 = load i32, ptr %EBP, align 4
  %v6288 = load i32, ptr %SSBASE, align 4
  %v6289 = add i32 %v6287, 16
  %v6290 = add i32 %v6289, %v6288
  %v6291 = load ptr, ptr %MEMORY, align 4
  %v6292 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6291, ptr %state, ptr %EAX, i32 %v6290)
  store ptr %v6292, ptr %MEMORY, align 4
  %v6293 = load ptr, ptr %MEMORY, align 4
  %v6294 = call ptr @__remill_atomic_end(ptr %v6293)
  store ptr %v6294, ptr %MEMORY, align 4
  store i32 %v6284, ptr %PC, align 4
  %v6295 = add i32 %v6284, 3
  store i32 %v6295, ptr %NEXT_PC, align 4
  %v6296 = load ptr, ptr %MEMORY, align 4
  %v6297 = call ptr @__remill_atomic_begin(ptr %v6296)
  store ptr %v6297, ptr %MEMORY, align 4
  %v6298 = load i32, ptr %EAX, align 4
  %v6299 = load i32, ptr %DSBASE, align 4
  %v6300 = add i32 %v6298, 8
  %v6301 = add i32 %v6300, %v6299
  %v6302 = load ptr, ptr %MEMORY, align 4
  %v6303 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6302, ptr %state, ptr %EAX, i32 %v6301)
  store ptr %v6303, ptr %MEMORY, align 4
  %v6304 = load ptr, ptr %MEMORY, align 4
  %v6305 = call ptr @__remill_atomic_end(ptr %v6304)
  store ptr %v6305, ptr %MEMORY, align 4
  store i32 %v6295, ptr %PC, align 4
  %v6306 = add i32 %v6295, 2
  store i32 %v6306, ptr %NEXT_PC, align 4
  %v6307 = load ptr, ptr %MEMORY, align 4
  %v6308 = call ptr @__remill_atomic_begin(ptr %v6307)
  store ptr %v6308, ptr %MEMORY, align 4
  %v6309 = load i32, ptr %EAX, align 4
  %v6310 = load i32, ptr %EAX, align 4
  %v6311 = load ptr, ptr %MEMORY, align 4
  %v6312 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6311, ptr %state, i32 %v6309, i32 %v6310)
  store ptr %v6312, ptr %MEMORY, align 4
  %v6313 = load ptr, ptr %MEMORY, align 4
  %v6314 = call ptr @__remill_atomic_end(ptr %v6313)
  store ptr %v6314, ptr %MEMORY, align 4
  store i32 %v6306, ptr %PC, align 4
  %v6315 = add i32 %v6306, 2
  store i32 %v6315, ptr %NEXT_PC, align 4
  %v6316 = load ptr, ptr %MEMORY, align 4
  %v6317 = call ptr @__remill_atomic_begin(ptr %v6316)
  store ptr %v6317, ptr %MEMORY, align 4
  %v6318 = add i32 %v6315, 115
  %v6319 = load ptr, ptr %MEMORY, align 4
  %v6320 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6319, ptr %state, ptr %BRANCH_TAKEN, i32 %v6318, i32 %v6315, ptr %NEXT_PC)
  store ptr %v6320, ptr %MEMORY, align 4
  %v6321 = load ptr, ptr %MEMORY, align 4
  %v6322 = call ptr @__remill_atomic_end(ptr %v6321)
  store ptr %v6322, ptr %MEMORY, align 4
  br i1 true, label %bb_4206884, label %bb_4206769

bb_4206769:                                       ; preds = %bb_4206759
  store i32 %v6315, ptr %PC, align 4
  %v6323 = add i32 %v6315, 3
  store i32 %v6323, ptr %NEXT_PC, align 4
  %v6324 = load ptr, ptr %MEMORY, align 4
  %v6325 = call ptr @__remill_atomic_begin(ptr %v6324)
  store ptr %v6325, ptr %MEMORY, align 4
  %v6326 = load i32, ptr %EBP, align 4
  %v6327 = load i32, ptr %SSBASE, align 4
  %v6328 = add i32 %v6326, 16
  %v6329 = add i32 %v6328, %v6327
  %v6330 = load ptr, ptr %MEMORY, align 4
  %v6331 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6330, ptr %state, ptr %EAX, i32 %v6329)
  store ptr %v6331, ptr %MEMORY, align 4
  %v6332 = load ptr, ptr %MEMORY, align 4
  %v6333 = call ptr @__remill_atomic_end(ptr %v6332)
  store ptr %v6333, ptr %MEMORY, align 4
  store i32 %v6323, ptr %PC, align 4
  %v6334 = add i32 %v6323, 3
  store i32 %v6334, ptr %NEXT_PC, align 4
  %v6335 = load ptr, ptr %MEMORY, align 4
  %v6336 = call ptr @__remill_atomic_begin(ptr %v6335)
  store ptr %v6336, ptr %MEMORY, align 4
  %v6337 = load i32, ptr %EAX, align 4
  %v6338 = load i32, ptr %DSBASE, align 4
  %v6339 = add i32 %v6337, 4
  %v6340 = add i32 %v6339, %v6338
  %v6341 = load ptr, ptr %MEMORY, align 4
  %v6342 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6341, ptr %state, ptr %EAX, i32 %v6340)
  store ptr %v6342, ptr %MEMORY, align 4
  %v6343 = load ptr, ptr %MEMORY, align 4
  %v6344 = call ptr @__remill_atomic_end(ptr %v6343)
  store ptr %v6344, ptr %MEMORY, align 4
  store i32 %v6334, ptr %PC, align 4
  %v6345 = add i32 %v6334, 5
  store i32 %v6345, ptr %NEXT_PC, align 4
  %v6346 = load ptr, ptr %MEMORY, align 4
  %v6347 = call ptr @__remill_atomic_begin(ptr %v6346)
  store ptr %v6347, ptr %MEMORY, align 4
  %v6348 = load i32, ptr %EAX, align 4
  %v6349 = load ptr, ptr %MEMORY, align 4
  %v6350 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v6349, ptr %state, ptr %EAX, i32 %v6348, i32 1024)
  store ptr %v6350, ptr %MEMORY, align 4
  %v6351 = load ptr, ptr %MEMORY, align 4
  %v6352 = call ptr @__remill_atomic_end(ptr %v6351)
  store ptr %v6352, ptr %MEMORY, align 4
  store i32 %v6345, ptr %PC, align 4
  %v6353 = add i32 %v6345, 2
  store i32 %v6353, ptr %NEXT_PC, align 4
  %v6354 = load ptr, ptr %MEMORY, align 4
  %v6355 = call ptr @__remill_atomic_begin(ptr %v6354)
  store ptr %v6355, ptr %MEMORY, align 4
  %v6356 = load i32, ptr %EAX, align 4
  %v6357 = load i32, ptr %EAX, align 4
  %v6358 = load ptr, ptr %MEMORY, align 4
  %v6359 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6358, ptr %state, i32 %v6356, i32 %v6357)
  store ptr %v6359, ptr %MEMORY, align 4
  %v6360 = load ptr, ptr %MEMORY, align 4
  %v6361 = call ptr @__remill_atomic_end(ptr %v6360)
  store ptr %v6361, ptr %MEMORY, align 4
  store i32 %v6353, ptr %PC, align 4
  %v6362 = add i32 %v6353, 2
  store i32 %v6362, ptr %NEXT_PC, align 4
  %v6363 = load ptr, ptr %MEMORY, align 4
  %v6364 = call ptr @__remill_atomic_begin(ptr %v6363)
  store ptr %v6364, ptr %MEMORY, align 4
  %v6365 = add i32 %v6362, 100
  %v6366 = load ptr, ptr %MEMORY, align 4
  %v6367 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6366, ptr %state, ptr %BRANCH_TAKEN, i32 %v6365, i32 %v6362, ptr %NEXT_PC)
  store ptr %v6367, ptr %MEMORY, align 4
  %v6368 = load ptr, ptr %MEMORY, align 4
  %v6369 = call ptr @__remill_atomic_end(ptr %v6368)
  store ptr %v6369, ptr %MEMORY, align 4
  br i1 true, label %bb_4206884, label %bb_4206784

bb_4206784:                                       ; preds = %bb_4206769
  store i32 %v6362, ptr %PC, align 4
  %v6370 = add i32 %v6362, 2
  store i32 %v6370, ptr %NEXT_PC, align 4
  %v6371 = load ptr, ptr %MEMORY, align 4
  %v6372 = call ptr @__remill_atomic_begin(ptr %v6371)
  store ptr %v6372, ptr %MEMORY, align 4
  %v6373 = add i32 %v6370, 19
  %v6374 = load ptr, ptr %MEMORY, align 4
  %v6375 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6374, ptr %state, i32 %v6373, ptr %NEXT_PC)
  store ptr %v6375, ptr %MEMORY, align 4
  %v6376 = load ptr, ptr %MEMORY, align 4
  %v6377 = call ptr @__remill_atomic_end(ptr %v6376)
  store ptr %v6377, ptr %MEMORY, align 4
  br label %bb_4206805

bb_4206786:                                       ; preds = %bb_4206805
  store i32 %v6500, ptr %PC, align 4
  %v6378 = add i32 %v6500, 3
  store i32 %v6378, ptr %NEXT_PC, align 4
  %v6379 = load ptr, ptr %MEMORY, align 4
  %v6380 = call ptr @__remill_atomic_begin(ptr %v6379)
  store ptr %v6380, ptr %MEMORY, align 4
  %v6381 = load i32, ptr %EBP, align 4
  %v6382 = load i32, ptr %SSBASE, align 4
  %v6383 = add i32 %v6381, 16
  %v6384 = add i32 %v6383, %v6382
  %v6385 = load ptr, ptr %MEMORY, align 4
  %v6386 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6385, ptr %state, ptr %EAX, i32 %v6384)
  store ptr %v6386, ptr %MEMORY, align 4
  %v6387 = load ptr, ptr %MEMORY, align 4
  %v6388 = call ptr @__remill_atomic_end(ptr %v6387)
  store ptr %v6388, ptr %MEMORY, align 4
  store i32 %v6378, ptr %PC, align 4
  %v6389 = add i32 %v6378, 4
  store i32 %v6389, ptr %NEXT_PC, align 4
  %v6390 = load ptr, ptr %MEMORY, align 4
  %v6391 = call ptr @__remill_atomic_begin(ptr %v6390)
  store ptr %v6391, ptr %MEMORY, align 4
  %v6392 = load i32, ptr %ESP, align 4
  %v6393 = load i32, ptr %SSBASE, align 4
  %v6394 = add i32 %v6392, 4
  %v6395 = add i32 %v6394, %v6393
  %v6396 = load i32, ptr %EAX, align 4
  %v6397 = load ptr, ptr %MEMORY, align 4
  %v6398 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6397, ptr %state, i32 %v6395, i32 %v6396)
  store ptr %v6398, ptr %MEMORY, align 4
  %v6399 = load ptr, ptr %MEMORY, align 4
  %v6400 = call ptr @__remill_atomic_end(ptr %v6399)
  store ptr %v6400, ptr %MEMORY, align 4
  store i32 %v6389, ptr %PC, align 4
  %v6401 = add i32 %v6389, 7
  store i32 %v6401, ptr %NEXT_PC, align 4
  %v6402 = load ptr, ptr %MEMORY, align 4
  %v6403 = call ptr @__remill_atomic_begin(ptr %v6402)
  store ptr %v6403, ptr %MEMORY, align 4
  %v6404 = load i32, ptr %ESP, align 4
  %v6405 = load i32, ptr %SSBASE, align 4
  %v6406 = add i32 %v6404, %v6405
  %v6407 = load ptr, ptr %MEMORY, align 4
  %v6408 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6407, ptr %state, i32 %v6406, i32 32)
  store ptr %v6408, ptr %MEMORY, align 4
  %v6409 = load ptr, ptr %MEMORY, align 4
  %v6410 = call ptr @__remill_atomic_end(ptr %v6409)
  store ptr %v6410, ptr %MEMORY, align 4
  store i32 %v6401, ptr %PC, align 4
  %v6411 = add i32 %v6401, 5
  store i32 %v6411, ptr %NEXT_PC, align 4
  %v6412 = load ptr, ptr %MEMORY, align 4
  %v6413 = call ptr @__remill_atomic_begin(ptr %v6412)
  store ptr %v6413, ptr %MEMORY, align 4
  %v6414 = sub i32 %v6411, 555
  %v6415 = load ptr, ptr %MEMORY, align 4
  %v6416 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v6415, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v6411, ptr %RETURN_PC)
  store ptr %v6416, ptr %MEMORY, align 4
  %v6417 = load ptr, ptr %MEMORY, align 4
  %v6418 = call ptr @__remill_atomic_end(ptr %v6417)
  store ptr %v6418, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206805:                                       ; preds = %bb_4206784
  store i32 %v6370, ptr %PC, align 4
  %v6419 = add i32 %v6370, 3
  store i32 %v6419, ptr %NEXT_PC, align 4
  %v6420 = load ptr, ptr %MEMORY, align 4
  %v6421 = call ptr @__remill_atomic_begin(ptr %v6420)
  store ptr %v6421, ptr %MEMORY, align 4
  %v6422 = load i32, ptr %EBP, align 4
  %v6423 = load i32, ptr %SSBASE, align 4
  %v6424 = add i32 %v6422, 16
  %v6425 = add i32 %v6424, %v6423
  %v6426 = load ptr, ptr %MEMORY, align 4
  %v6427 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6426, ptr %state, ptr %EAX, i32 %v6425)
  store ptr %v6427, ptr %MEMORY, align 4
  %v6428 = load ptr, ptr %MEMORY, align 4
  %v6429 = call ptr @__remill_atomic_end(ptr %v6428)
  store ptr %v6429, ptr %MEMORY, align 4
  store i32 %v6419, ptr %PC, align 4
  %v6430 = add i32 %v6419, 3
  store i32 %v6430, ptr %NEXT_PC, align 4
  %v6431 = load ptr, ptr %MEMORY, align 4
  %v6432 = call ptr @__remill_atomic_begin(ptr %v6431)
  store ptr %v6432, ptr %MEMORY, align 4
  %v6433 = load i32, ptr %EAX, align 4
  %v6434 = load i32, ptr %DSBASE, align 4
  %v6435 = add i32 %v6433, 8
  %v6436 = add i32 %v6435, %v6434
  %v6437 = load ptr, ptr %MEMORY, align 4
  %v6438 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6437, ptr %state, ptr %EAX, i32 %v6436)
  store ptr %v6438, ptr %MEMORY, align 4
  %v6439 = load ptr, ptr %MEMORY, align 4
  %v6440 = call ptr @__remill_atomic_end(ptr %v6439)
  store ptr %v6440, ptr %MEMORY, align 4
  store i32 %v6430, ptr %PC, align 4
  %v6441 = add i32 %v6430, 2
  store i32 %v6441, ptr %NEXT_PC, align 4
  %v6442 = load ptr, ptr %MEMORY, align 4
  %v6443 = call ptr @__remill_atomic_begin(ptr %v6442)
  store ptr %v6443, ptr %MEMORY, align 4
  %v6444 = load i32, ptr %EAX, align 4
  %v6445 = load i32, ptr %EAX, align 4
  %v6446 = load ptr, ptr %MEMORY, align 4
  %v6447 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6446, ptr %state, i32 %v6444, i32 %v6445)
  store ptr %v6447, ptr %MEMORY, align 4
  %v6448 = load ptr, ptr %MEMORY, align 4
  %v6449 = call ptr @__remill_atomic_end(ptr %v6448)
  store ptr %v6449, ptr %MEMORY, align 4
  store i32 %v6441, ptr %PC, align 4
  %v6450 = add i32 %v6441, 3
  store i32 %v6450, ptr %NEXT_PC, align 4
  %v6451 = load ptr, ptr %MEMORY, align 4
  %v6452 = call ptr @__remill_atomic_begin(ptr %v6451)
  store ptr %v6452, ptr %MEMORY, align 4
  %v6453 = load ptr, ptr %MEMORY, align 4
  %v6454 = call ptr @_ZN12_GLOBAL__N_15SETNZI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v6453, ptr %state, ptr %DL)
  store ptr %v6454, ptr %MEMORY, align 4
  %v6455 = load ptr, ptr %MEMORY, align 4
  %v6456 = call ptr @__remill_atomic_end(ptr %v6455)
  store ptr %v6456, ptr %MEMORY, align 4
  store i32 %v6450, ptr %PC, align 4
  %v6457 = add i32 %v6450, 3
  store i32 %v6457, ptr %NEXT_PC, align 4
  %v6458 = load ptr, ptr %MEMORY, align 4
  %v6459 = call ptr @__remill_atomic_begin(ptr %v6458)
  store ptr %v6459, ptr %MEMORY, align 4
  %v6460 = load i32, ptr %EAX, align 4
  %v6461 = sub i32 %v6460, 1
  %v6462 = load ptr, ptr %MEMORY, align 4
  %v6463 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v6462, ptr %state, ptr %ECX, i32 %v6461)
  store ptr %v6463, ptr %MEMORY, align 4
  %v6464 = load ptr, ptr %MEMORY, align 4
  %v6465 = call ptr @__remill_atomic_end(ptr %v6464)
  store ptr %v6465, ptr %MEMORY, align 4
  store i32 %v6457, ptr %PC, align 4
  %v6466 = add i32 %v6457, 3
  store i32 %v6466, ptr %NEXT_PC, align 4
  %v6467 = load ptr, ptr %MEMORY, align 4
  %v6468 = call ptr @__remill_atomic_begin(ptr %v6467)
  store ptr %v6468, ptr %MEMORY, align 4
  %v6469 = load i32, ptr %EBP, align 4
  %v6470 = load i32, ptr %SSBASE, align 4
  %v6471 = add i32 %v6469, 16
  %v6472 = add i32 %v6471, %v6470
  %v6473 = load ptr, ptr %MEMORY, align 4
  %v6474 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6473, ptr %state, ptr %EAX, i32 %v6472)
  store ptr %v6474, ptr %MEMORY, align 4
  %v6475 = load ptr, ptr %MEMORY, align 4
  %v6476 = call ptr @__remill_atomic_end(ptr %v6475)
  store ptr %v6476, ptr %MEMORY, align 4
  store i32 %v6466, ptr %PC, align 4
  %v6477 = add i32 %v6466, 3
  store i32 %v6477, ptr %NEXT_PC, align 4
  %v6478 = load ptr, ptr %MEMORY, align 4
  %v6479 = call ptr @__remill_atomic_begin(ptr %v6478)
  store ptr %v6479, ptr %MEMORY, align 4
  %v6480 = load i32, ptr %EAX, align 4
  %v6481 = load i32, ptr %DSBASE, align 4
  %v6482 = add i32 %v6480, 8
  %v6483 = add i32 %v6482, %v6481
  %v6484 = load i32, ptr %ECX, align 4
  %v6485 = load ptr, ptr %MEMORY, align 4
  %v6486 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6485, ptr %state, i32 %v6483, i32 %v6484)
  store ptr %v6486, ptr %MEMORY, align 4
  %v6487 = load ptr, ptr %MEMORY, align 4
  %v6488 = call ptr @__remill_atomic_end(ptr %v6487)
  store ptr %v6488, ptr %MEMORY, align 4
  store i32 %v6477, ptr %PC, align 4
  %v6489 = add i32 %v6477, 2
  store i32 %v6489, ptr %NEXT_PC, align 4
  %v6490 = load ptr, ptr %MEMORY, align 4
  %v6491 = call ptr @__remill_atomic_begin(ptr %v6490)
  store ptr %v6491, ptr %MEMORY, align 4
  %v6492 = load i8, ptr %DL, align 1
  %v6493 = zext i8 %v6492 to i32
  %v6494 = load i8, ptr %DL, align 1
  %v6495 = zext i8 %v6494 to i32
  %v6496 = load ptr, ptr %MEMORY, align 4
  %v6497 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6496, ptr %state, i32 %v6493, i32 %v6495)
  store ptr %v6497, ptr %MEMORY, align 4
  %v6498 = load ptr, ptr %MEMORY, align 4
  %v6499 = call ptr @__remill_atomic_end(ptr %v6498)
  store ptr %v6499, ptr %MEMORY, align 4
  store i32 %v6489, ptr %PC, align 4
  %v6500 = add i32 %v6489, 2
  store i32 %v6500, ptr %NEXT_PC, align 4
  %v6501 = load ptr, ptr %MEMORY, align 4
  %v6502 = call ptr @__remill_atomic_begin(ptr %v6501)
  store ptr %v6502, ptr %MEMORY, align 4
  %v6503 = sub i32 %v6500, 43
  %v6504 = load ptr, ptr %MEMORY, align 4
  %v6505 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6504, ptr %state, ptr %BRANCH_TAKEN, i32 %v6503, i32 %v6500, ptr %NEXT_PC)
  store ptr %v6505, ptr %MEMORY, align 4
  %v6506 = load ptr, ptr %MEMORY, align 4
  %v6507 = call ptr @__remill_atomic_end(ptr %v6506)
  store ptr %v6507, ptr %MEMORY, align 4
  br i1 true, label %bb_4206786, label %bb_4206829

bb_4206829:                                       ; preds = %bb_4206805
  store i32 %v6500, ptr %PC, align 4
  %v6508 = add i32 %v6500, 2
  store i32 %v6508, ptr %NEXT_PC, align 4
  %v6509 = load ptr, ptr %MEMORY, align 4
  %v6510 = call ptr @__remill_atomic_begin(ptr %v6509)
  store ptr %v6510, ptr %MEMORY, align 4
  %v6511 = add i32 %v6508, 53
  %v6512 = load ptr, ptr %MEMORY, align 4
  %v6513 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6512, ptr %state, i32 %v6511, ptr %NEXT_PC)
  store ptr %v6513, ptr %MEMORY, align 4
  %v6514 = load ptr, ptr %MEMORY, align 4
  %v6515 = call ptr @__remill_atomic_end(ptr %v6514)
  store ptr %v6515, ptr %MEMORY, align 4
  br label %bb_4206884

bb_4206831:                                       ; preds = %bb_4206900
  store i32 %v6882, ptr %PC, align 4
  %v6516 = add i32 %v6882, 3
  store i32 %v6516, ptr %NEXT_PC, align 4
  %v6517 = load ptr, ptr %MEMORY, align 4
  %v6518 = call ptr @__remill_atomic_begin(ptr %v6517)
  store ptr %v6518, ptr %MEMORY, align 4
  %v6519 = load i32, ptr %EBP, align 4
  %v6520 = sub i32 %v6519, 32
  %v6521 = load ptr, ptr %MEMORY, align 4
  %v6522 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v6521, ptr %state, ptr %EAX, i32 %v6520)
  store ptr %v6522, ptr %MEMORY, align 4
  %v6523 = load ptr, ptr %MEMORY, align 4
  %v6524 = call ptr @__remill_atomic_end(ptr %v6523)
  store ptr %v6524, ptr %MEMORY, align 4
  store i32 %v6516, ptr %PC, align 4
  %v6525 = add i32 %v6516, 3
  store i32 %v6525, ptr %NEXT_PC, align 4
  %v6526 = load ptr, ptr %MEMORY, align 4
  %v6527 = call ptr @__remill_atomic_begin(ptr %v6526)
  store ptr %v6527, ptr %MEMORY, align 4
  %v6528 = load i32, ptr %EBP, align 4
  %v6529 = load i32, ptr %SSBASE, align 4
  %v6530 = sub i32 %v6528, 16
  %v6531 = add i32 %v6530, %v6529
  %v6532 = load i32, ptr %EAX, align 4
  %v6533 = load ptr, ptr %MEMORY, align 4
  %v6534 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6533, ptr %state, i32 %v6531, i32 %v6532)
  store ptr %v6534, ptr %MEMORY, align 4
  %v6535 = load ptr, ptr %MEMORY, align 4
  %v6536 = call ptr @__remill_atomic_end(ptr %v6535)
  store ptr %v6536, ptr %MEMORY, align 4
  store i32 %v6525, ptr %PC, align 4
  %v6537 = add i32 %v6525, 2
  store i32 %v6537, ptr %NEXT_PC, align 4
  %v6538 = load ptr, ptr %MEMORY, align 4
  %v6539 = call ptr @__remill_atomic_begin(ptr %v6538)
  store ptr %v6539, ptr %MEMORY, align 4
  %v6540 = add i32 %v6537, 28
  %v6541 = load ptr, ptr %MEMORY, align 4
  %v6542 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6541, ptr %state, i32 %v6540, ptr %NEXT_PC)
  store ptr %v6542, ptr %MEMORY, align 4
  %v6543 = load ptr, ptr %MEMORY, align 4
  %v6544 = call ptr @__remill_atomic_end(ptr %v6543)
  store ptr %v6544, ptr %MEMORY, align 4
  br label %bb_4206867

bb_4206839:                                       ; preds = %bb_4206867
  store i32 %v6676, ptr %PC, align 4
  %v6545 = add i32 %v6676, 3
  store i32 %v6545, ptr %NEXT_PC, align 4
  %v6546 = load ptr, ptr %MEMORY, align 4
  %v6547 = call ptr @__remill_atomic_begin(ptr %v6546)
  store ptr %v6547, ptr %MEMORY, align 4
  %v6548 = load i32, ptr %EBP, align 4
  %v6549 = load i32, ptr %SSBASE, align 4
  %v6550 = sub i32 %v6548, 16
  %v6551 = add i32 %v6550, %v6549
  %v6552 = load ptr, ptr %MEMORY, align 4
  %v6553 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6552, ptr %state, ptr %EAX, i32 %v6551)
  store ptr %v6553, ptr %MEMORY, align 4
  %v6554 = load ptr, ptr %MEMORY, align 4
  %v6555 = call ptr @__remill_atomic_end(ptr %v6554)
  store ptr %v6555, ptr %MEMORY, align 4
  store i32 %v6545, ptr %PC, align 4
  %v6556 = add i32 %v6545, 3
  store i32 %v6556, ptr %NEXT_PC, align 4
  %v6557 = load ptr, ptr %MEMORY, align 4
  %v6558 = call ptr @__remill_atomic_begin(ptr %v6557)
  store ptr %v6558, ptr %MEMORY, align 4
  %v6559 = load i32, ptr %EAX, align 4
  %v6560 = load i32, ptr %DSBASE, align 4
  %v6561 = add i32 %v6559, %v6560
  %v6562 = load ptr, ptr %MEMORY, align 4
  %v6563 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v6562, ptr %state, ptr %EAX, i32 %v6561)
  store ptr %v6563, ptr %MEMORY, align 4
  %v6564 = load ptr, ptr %MEMORY, align 4
  %v6565 = call ptr @__remill_atomic_end(ptr %v6564)
  store ptr %v6565, ptr %MEMORY, align 4
  store i32 %v6556, ptr %PC, align 4
  %v6566 = add i32 %v6556, 3
  store i32 %v6566, ptr %NEXT_PC, align 4
  %v6567 = load ptr, ptr %MEMORY, align 4
  %v6568 = call ptr @__remill_atomic_begin(ptr %v6567)
  store ptr %v6568, ptr %MEMORY, align 4
  %v6569 = load i8, ptr %AL, align 1
  %v6570 = zext i8 %v6569 to i32
  %v6571 = load ptr, ptr %MEMORY, align 4
  %v6572 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWIjE2RnIhLb1EEiEEP6MemoryS6_R5StateT_T0_(ptr %v6571, ptr %state, ptr %EAX, i32 %v6570)
  store ptr %v6572, ptr %MEMORY, align 4
  %v6573 = load ptr, ptr %MEMORY, align 4
  %v6574 = call ptr @__remill_atomic_end(ptr %v6573)
  store ptr %v6574, ptr %MEMORY, align 4
  store i32 %v6566, ptr %PC, align 4
  %v6575 = add i32 %v6566, 4
  store i32 %v6575, ptr %NEXT_PC, align 4
  %v6576 = load ptr, ptr %MEMORY, align 4
  %v6577 = call ptr @__remill_atomic_begin(ptr %v6576)
  store ptr %v6577, ptr %MEMORY, align 4
  %v6578 = load i32, ptr %EBP, align 4
  %v6579 = load i32, ptr %SSBASE, align 4
  %v6580 = sub i32 %v6578, 16
  %v6581 = add i32 %v6580, %v6579
  %v6582 = load i32, ptr %EBP, align 4
  %v6583 = load i32, ptr %SSBASE, align 4
  %v6584 = sub i32 %v6582, 16
  %v6585 = add i32 %v6584, %v6583
  %v6586 = load ptr, ptr %MEMORY, align 4
  %v6587 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v6586, ptr %state, i32 %v6581, i32 %v6585, i32 1)
  store ptr %v6587, ptr %MEMORY, align 4
  %v6588 = load ptr, ptr %MEMORY, align 4
  %v6589 = call ptr @__remill_atomic_end(ptr %v6588)
  store ptr %v6589, ptr %MEMORY, align 4
  store i32 %v6575, ptr %PC, align 4
  %v6590 = add i32 %v6575, 3
  store i32 %v6590, ptr %NEXT_PC, align 4
  %v6591 = load ptr, ptr %MEMORY, align 4
  %v6592 = call ptr @__remill_atomic_begin(ptr %v6591)
  store ptr %v6592, ptr %MEMORY, align 4
  %v6593 = load i32, ptr %EBP, align 4
  %v6594 = load i32, ptr %SSBASE, align 4
  %v6595 = add i32 %v6593, 16
  %v6596 = add i32 %v6595, %v6594
  %v6597 = load ptr, ptr %MEMORY, align 4
  %v6598 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6597, ptr %state, ptr %EDX, i32 %v6596)
  store ptr %v6598, ptr %MEMORY, align 4
  %v6599 = load ptr, ptr %MEMORY, align 4
  %v6600 = call ptr @__remill_atomic_end(ptr %v6599)
  store ptr %v6600, ptr %MEMORY, align 4
  store i32 %v6590, ptr %PC, align 4
  %v6601 = add i32 %v6590, 4
  store i32 %v6601, ptr %NEXT_PC, align 4
  %v6602 = load ptr, ptr %MEMORY, align 4
  %v6603 = call ptr @__remill_atomic_begin(ptr %v6602)
  store ptr %v6603, ptr %MEMORY, align 4
  %v6604 = load i32, ptr %ESP, align 4
  %v6605 = load i32, ptr %SSBASE, align 4
  %v6606 = add i32 %v6604, 4
  %v6607 = add i32 %v6606, %v6605
  %v6608 = load i32, ptr %EDX, align 4
  %v6609 = load ptr, ptr %MEMORY, align 4
  %v6610 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6609, ptr %state, i32 %v6607, i32 %v6608)
  store ptr %v6610, ptr %MEMORY, align 4
  %v6611 = load ptr, ptr %MEMORY, align 4
  %v6612 = call ptr @__remill_atomic_end(ptr %v6611)
  store ptr %v6612, ptr %MEMORY, align 4
  store i32 %v6601, ptr %PC, align 4
  %v6613 = add i32 %v6601, 3
  store i32 %v6613, ptr %NEXT_PC, align 4
  %v6614 = load ptr, ptr %MEMORY, align 4
  %v6615 = call ptr @__remill_atomic_begin(ptr %v6614)
  store ptr %v6615, ptr %MEMORY, align 4
  %v6616 = load i32, ptr %ESP, align 4
  %v6617 = load i32, ptr %SSBASE, align 4
  %v6618 = add i32 %v6616, %v6617
  %v6619 = load i32, ptr %EAX, align 4
  %v6620 = load ptr, ptr %MEMORY, align 4
  %v6621 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6620, ptr %state, i32 %v6618, i32 %v6619)
  store ptr %v6621, ptr %MEMORY, align 4
  %v6622 = load ptr, ptr %MEMORY, align 4
  %v6623 = call ptr @__remill_atomic_end(ptr %v6622)
  store ptr %v6623, ptr %MEMORY, align 4
  store i32 %v6613, ptr %PC, align 4
  %v6624 = add i32 %v6613, 5
  store i32 %v6624, ptr %NEXT_PC, align 4
  %v6625 = load ptr, ptr %MEMORY, align 4
  %v6626 = call ptr @__remill_atomic_begin(ptr %v6625)
  store ptr %v6626, ptr %MEMORY, align 4
  %v6627 = sub i32 %v6624, 617
  %v6628 = load ptr, ptr %MEMORY, align 4
  %v6629 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v6628, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v6624, ptr %RETURN_PC)
  store ptr %v6629, ptr %MEMORY, align 4
  %v6630 = load ptr, ptr %MEMORY, align 4
  %v6631 = call ptr @__remill_atomic_end(ptr %v6630)
  store ptr %v6631, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206867:                                       ; preds = %bb_4206831
  store i32 %v6537, ptr %PC, align 4
  %v6632 = add i32 %v6537, 4
  store i32 %v6632, ptr %NEXT_PC, align 4
  %v6633 = load ptr, ptr %MEMORY, align 4
  %v6634 = call ptr @__remill_atomic_begin(ptr %v6633)
  store ptr %v6634, ptr %MEMORY, align 4
  %v6635 = load i32, ptr %EBP, align 4
  %v6636 = load i32, ptr %SSBASE, align 4
  %v6637 = sub i32 %v6635, 12
  %v6638 = add i32 %v6637, %v6636
  %v6639 = load ptr, ptr %MEMORY, align 4
  %v6640 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6639, ptr %state, i32 %v6638, i32 0)
  store ptr %v6640, ptr %MEMORY, align 4
  %v6641 = load ptr, ptr %MEMORY, align 4
  %v6642 = call ptr @__remill_atomic_end(ptr %v6641)
  store ptr %v6642, ptr %MEMORY, align 4
  store i32 %v6632, ptr %PC, align 4
  %v6643 = add i32 %v6632, 3
  store i32 %v6643, ptr %NEXT_PC, align 4
  %v6644 = load ptr, ptr %MEMORY, align 4
  %v6645 = call ptr @__remill_atomic_begin(ptr %v6644)
  store ptr %v6645, ptr %MEMORY, align 4
  %v6646 = load ptr, ptr %MEMORY, align 4
  %v6647 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v6646, ptr %state, ptr %AL)
  store ptr %v6647, ptr %MEMORY, align 4
  %v6648 = load ptr, ptr %MEMORY, align 4
  %v6649 = call ptr @__remill_atomic_end(ptr %v6648)
  store ptr %v6649, ptr %MEMORY, align 4
  store i32 %v6643, ptr %PC, align 4
  %v6650 = add i32 %v6643, 4
  store i32 %v6650, ptr %NEXT_PC, align 4
  %v6651 = load ptr, ptr %MEMORY, align 4
  %v6652 = call ptr @__remill_atomic_begin(ptr %v6651)
  store ptr %v6652, ptr %MEMORY, align 4
  %v6653 = load i32, ptr %EBP, align 4
  %v6654 = load i32, ptr %SSBASE, align 4
  %v6655 = sub i32 %v6653, 12
  %v6656 = add i32 %v6655, %v6654
  %v6657 = load i32, ptr %EBP, align 4
  %v6658 = load i32, ptr %SSBASE, align 4
  %v6659 = sub i32 %v6657, 12
  %v6660 = add i32 %v6659, %v6658
  %v6661 = load ptr, ptr %MEMORY, align 4
  %v6662 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v6661, ptr %state, i32 %v6656, i32 %v6660, i32 1)
  store ptr %v6662, ptr %MEMORY, align 4
  %v6663 = load ptr, ptr %MEMORY, align 4
  %v6664 = call ptr @__remill_atomic_end(ptr %v6663)
  store ptr %v6664, ptr %MEMORY, align 4
  store i32 %v6650, ptr %PC, align 4
  %v6665 = add i32 %v6650, 2
  store i32 %v6665, ptr %NEXT_PC, align 4
  %v6666 = load ptr, ptr %MEMORY, align 4
  %v6667 = call ptr @__remill_atomic_begin(ptr %v6666)
  store ptr %v6667, ptr %MEMORY, align 4
  %v6668 = load i8, ptr %AL, align 1
  %v6669 = zext i8 %v6668 to i32
  %v6670 = load i8, ptr %AL, align 1
  %v6671 = zext i8 %v6670 to i32
  %v6672 = load ptr, ptr %MEMORY, align 4
  %v6673 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6672, ptr %state, i32 %v6669, i32 %v6671)
  store ptr %v6673, ptr %MEMORY, align 4
  %v6674 = load ptr, ptr %MEMORY, align 4
  %v6675 = call ptr @__remill_atomic_end(ptr %v6674)
  store ptr %v6675, ptr %MEMORY, align 4
  store i32 %v6665, ptr %PC, align 4
  %v6676 = add i32 %v6665, 2
  store i32 %v6676, ptr %NEXT_PC, align 4
  %v6677 = load ptr, ptr %MEMORY, align 4
  %v6678 = call ptr @__remill_atomic_begin(ptr %v6677)
  store ptr %v6678, ptr %MEMORY, align 4
  %v6679 = sub i32 %v6676, 43
  %v6680 = load ptr, ptr %MEMORY, align 4
  %v6681 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6680, ptr %state, ptr %BRANCH_TAKEN, i32 %v6679, i32 %v6676, ptr %NEXT_PC)
  store ptr %v6681, ptr %MEMORY, align 4
  %v6682 = load ptr, ptr %MEMORY, align 4
  %v6683 = call ptr @__remill_atomic_end(ptr %v6682)
  store ptr %v6683, ptr %MEMORY, align 4
  br i1 true, label %bb_4206839, label %bb_4206882

bb_4206882:                                       ; preds = %bb_4206867
  store i32 %v6676, ptr %PC, align 4
  %v6684 = add i32 %v6676, 2
  store i32 %v6684, ptr %NEXT_PC, align 4
  %v6685 = load ptr, ptr %MEMORY, align 4
  %v6686 = call ptr @__remill_atomic_begin(ptr %v6685)
  store ptr %v6686, ptr %MEMORY, align 4
  %v6687 = add i32 %v6684, 1
  %v6688 = load ptr, ptr %MEMORY, align 4
  %v6689 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6688, ptr %state, i32 %v6687, ptr %NEXT_PC)
  store ptr %v6689, ptr %MEMORY, align 4
  %v6690 = load ptr, ptr %MEMORY, align 4
  %v6691 = call ptr @__remill_atomic_end(ptr %v6690)
  store ptr %v6691, ptr %MEMORY, align 4
  br label %bb_4206885

bb_4206884:                                       ; preds = %bb_4206829, %bb_4206769, %bb_4206759
  %v6692 = load i32, ptr %NEXT_PC, align 4
  store i32 %v6692, ptr %PC, align 4
  %v6693 = add i32 %v6692, 1
  store i32 %v6693, ptr %NEXT_PC, align 4
  %v6694 = load ptr, ptr %MEMORY, align 4
  %v6695 = call ptr @__remill_atomic_begin(ptr %v6694)
  store ptr %v6695, ptr %MEMORY, align 4
  %v6696 = load ptr, ptr %MEMORY, align 4
  %v6697 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v6696, ptr %state)
  store ptr %v6697, ptr %MEMORY, align 4
  %v6698 = load ptr, ptr %MEMORY, align 4
  %v6699 = call ptr @__remill_atomic_end(ptr %v6698)
  store ptr %v6699, ptr %MEMORY, align 4
  br label %bb_4206885

bb_4206885:                                       ; preds = %bb_4206884, %bb_4206882
  %v6700 = load i32, ptr %NEXT_PC, align 4
  store i32 %v6700, ptr %PC, align 4
  %v6701 = add i32 %v6700, 4
  store i32 %v6701, ptr %NEXT_PC, align 4
  %v6702 = load ptr, ptr %MEMORY, align 4
  %v6703 = call ptr @__remill_atomic_begin(ptr %v6702)
  store ptr %v6703, ptr %MEMORY, align 4
  %v6704 = load i32, ptr %EBP, align 4
  %v6705 = load i32, ptr %SSBASE, align 4
  %v6706 = add i32 %v6704, 12
  %v6707 = add i32 %v6706, %v6705
  %v6708 = load ptr, ptr %MEMORY, align 4
  %v6709 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6708, ptr %state, i32 %v6707, i32 0)
  store ptr %v6709, ptr %MEMORY, align 4
  %v6710 = load ptr, ptr %MEMORY, align 4
  %v6711 = call ptr @__remill_atomic_end(ptr %v6710)
  store ptr %v6711, ptr %MEMORY, align 4
  store i32 %v6701, ptr %PC, align 4
  %v6712 = add i32 %v6701, 3
  store i32 %v6712, ptr %NEXT_PC, align 4
  %v6713 = load ptr, ptr %MEMORY, align 4
  %v6714 = call ptr @__remill_atomic_begin(ptr %v6713)
  store ptr %v6714, ptr %MEMORY, align 4
  %v6715 = load ptr, ptr %MEMORY, align 4
  %v6716 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v6715, ptr %state, ptr %AL)
  store ptr %v6716, ptr %MEMORY, align 4
  %v6717 = load ptr, ptr %MEMORY, align 4
  %v6718 = call ptr @__remill_atomic_end(ptr %v6717)
  store ptr %v6718, ptr %MEMORY, align 4
  store i32 %v6712, ptr %PC, align 4
  %v6719 = add i32 %v6712, 4
  store i32 %v6719, ptr %NEXT_PC, align 4
  %v6720 = load ptr, ptr %MEMORY, align 4
  %v6721 = call ptr @__remill_atomic_begin(ptr %v6720)
  store ptr %v6721, ptr %MEMORY, align 4
  %v6722 = load i32, ptr %EBP, align 4
  %v6723 = load i32, ptr %SSBASE, align 4
  %v6724 = add i32 %v6722, 12
  %v6725 = add i32 %v6724, %v6723
  %v6726 = load i32, ptr %EBP, align 4
  %v6727 = load i32, ptr %SSBASE, align 4
  %v6728 = add i32 %v6726, 12
  %v6729 = add i32 %v6728, %v6727
  %v6730 = load ptr, ptr %MEMORY, align 4
  %v6731 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v6730, ptr %state, i32 %v6725, i32 %v6729, i32 1)
  store ptr %v6731, ptr %MEMORY, align 4
  %v6732 = load ptr, ptr %MEMORY, align 4
  %v6733 = call ptr @__remill_atomic_end(ptr %v6732)
  store ptr %v6733, ptr %MEMORY, align 4
  store i32 %v6719, ptr %PC, align 4
  %v6734 = add i32 %v6719, 2
  store i32 %v6734, ptr %NEXT_PC, align 4
  %v6735 = load ptr, ptr %MEMORY, align 4
  %v6736 = call ptr @__remill_atomic_begin(ptr %v6735)
  store ptr %v6736, ptr %MEMORY, align 4
  %v6737 = load i8, ptr %AL, align 1
  %v6738 = zext i8 %v6737 to i32
  %v6739 = load i8, ptr %AL, align 1
  %v6740 = zext i8 %v6739 to i32
  %v6741 = load ptr, ptr %MEMORY, align 4
  %v6742 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6741, ptr %state, i32 %v6738, i32 %v6740)
  store ptr %v6742, ptr %MEMORY, align 4
  %v6743 = load ptr, ptr %MEMORY, align 4
  %v6744 = call ptr @__remill_atomic_end(ptr %v6743)
  store ptr %v6744, ptr %MEMORY, align 4
  store i32 %v6734, ptr %PC, align 4
  %v6745 = add i32 %v6734, 2
  store i32 %v6745, ptr %NEXT_PC, align 4
  %v6746 = load ptr, ptr %MEMORY, align 4
  %v6747 = call ptr @__remill_atomic_begin(ptr %v6746)
  store ptr %v6747, ptr %MEMORY, align 4
  %v6748 = add i32 %v6745, 67
  %v6749 = load ptr, ptr %MEMORY, align 4
  %v6750 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6749, ptr %state, ptr %BRANCH_TAKEN, i32 %v6748, i32 %v6745, ptr %NEXT_PC)
  store ptr %v6750, ptr %MEMORY, align 4
  %v6751 = load ptr, ptr %MEMORY, align 4
  %v6752 = call ptr @__remill_atomic_end(ptr %v6751)
  store ptr %v6752, ptr %MEMORY, align 4
  br i1 true, label %bb_4206967, label %bb_4206900

bb_4206900:                                       ; preds = %bb_4206885
  store i32 %v6745, ptr %PC, align 4
  %v6753 = add i32 %v6745, 3
  store i32 %v6753, ptr %NEXT_PC, align 4
  %v6754 = load ptr, ptr %MEMORY, align 4
  %v6755 = call ptr @__remill_atomic_begin(ptr %v6754)
  store ptr %v6755, ptr %MEMORY, align 4
  %v6756 = load i32, ptr %EBP, align 4
  %v6757 = load i32, ptr %SSBASE, align 4
  %v6758 = add i32 %v6756, 8
  %v6759 = add i32 %v6758, %v6757
  %v6760 = load ptr, ptr %MEMORY, align 4
  %v6761 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6760, ptr %state, ptr %EAX, i32 %v6759)
  store ptr %v6761, ptr %MEMORY, align 4
  %v6762 = load ptr, ptr %MEMORY, align 4
  %v6763 = call ptr @__remill_atomic_end(ptr %v6762)
  store ptr %v6763, ptr %MEMORY, align 4
  store i32 %v6753, ptr %PC, align 4
  %v6764 = add i32 %v6753, 3
  store i32 %v6764, ptr %NEXT_PC, align 4
  %v6765 = load ptr, ptr %MEMORY, align 4
  %v6766 = call ptr @__remill_atomic_begin(ptr %v6765)
  store ptr %v6766, ptr %MEMORY, align 4
  %v6767 = load i32, ptr %EAX, align 4
  %v6768 = load i32, ptr %DSBASE, align 4
  %v6769 = add i32 %v6767, %v6768
  %v6770 = load ptr, ptr %MEMORY, align 4
  %v6771 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v6770, ptr %state, ptr %EAX, i32 %v6769)
  store ptr %v6771, ptr %MEMORY, align 4
  %v6772 = load ptr, ptr %MEMORY, align 4
  %v6773 = call ptr @__remill_atomic_end(ptr %v6772)
  store ptr %v6773, ptr %MEMORY, align 4
  store i32 %v6764, ptr %PC, align 4
  %v6774 = add i32 %v6764, 3
  store i32 %v6774, ptr %NEXT_PC, align 4
  %v6775 = load ptr, ptr %MEMORY, align 4
  %v6776 = call ptr @__remill_atomic_begin(ptr %v6775)
  store ptr %v6776, ptr %MEMORY, align 4
  %v6777 = load i16, ptr %AX, align 2
  %v6778 = zext i16 %v6777 to i32
  %v6779 = load ptr, ptr %MEMORY, align 4
  %v6780 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6779, ptr %state, ptr %EAX, i32 %v6778)
  store ptr %v6780, ptr %MEMORY, align 4
  %v6781 = load ptr, ptr %MEMORY, align 4
  %v6782 = call ptr @__remill_atomic_end(ptr %v6781)
  store ptr %v6782, ptr %MEMORY, align 4
  store i32 %v6774, ptr %PC, align 4
  %v6783 = add i32 %v6774, 4
  store i32 %v6783, ptr %NEXT_PC, align 4
  %v6784 = load ptr, ptr %MEMORY, align 4
  %v6785 = call ptr @__remill_atomic_begin(ptr %v6784)
  store ptr %v6785, ptr %MEMORY, align 4
  %v6786 = load i32, ptr %EBP, align 4
  %v6787 = load i32, ptr %SSBASE, align 4
  %v6788 = add i32 %v6786, 8
  %v6789 = add i32 %v6788, %v6787
  %v6790 = load i32, ptr %EBP, align 4
  %v6791 = load i32, ptr %SSBASE, align 4
  %v6792 = add i32 %v6790, 8
  %v6793 = add i32 %v6792, %v6791
  %v6794 = load ptr, ptr %MEMORY, align 4
  %v6795 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v6794, ptr %state, i32 %v6789, i32 %v6793, i32 2)
  store ptr %v6795, ptr %MEMORY, align 4
  %v6796 = load ptr, ptr %MEMORY, align 4
  %v6797 = call ptr @__remill_atomic_end(ptr %v6796)
  store ptr %v6797, ptr %MEMORY, align 4
  store i32 %v6783, ptr %PC, align 4
  %v6798 = add i32 %v6783, 3
  store i32 %v6798, ptr %NEXT_PC, align 4
  %v6799 = load ptr, ptr %MEMORY, align 4
  %v6800 = call ptr @__remill_atomic_begin(ptr %v6799)
  store ptr %v6800, ptr %MEMORY, align 4
  %v6801 = load i32, ptr %EBP, align 4
  %v6802 = sub i32 %v6801, 36
  %v6803 = load ptr, ptr %MEMORY, align 4
  %v6804 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v6803, ptr %state, ptr %EDX, i32 %v6802)
  store ptr %v6804, ptr %MEMORY, align 4
  %v6805 = load ptr, ptr %MEMORY, align 4
  %v6806 = call ptr @__remill_atomic_end(ptr %v6805)
  store ptr %v6806, ptr %MEMORY, align 4
  store i32 %v6798, ptr %PC, align 4
  %v6807 = add i32 %v6798, 4
  store i32 %v6807, ptr %NEXT_PC, align 4
  %v6808 = load ptr, ptr %MEMORY, align 4
  %v6809 = call ptr @__remill_atomic_begin(ptr %v6808)
  store ptr %v6809, ptr %MEMORY, align 4
  %v6810 = load i32, ptr %ESP, align 4
  %v6811 = load i32, ptr %SSBASE, align 4
  %v6812 = add i32 %v6810, 8
  %v6813 = add i32 %v6812, %v6811
  %v6814 = load i32, ptr %EDX, align 4
  %v6815 = load ptr, ptr %MEMORY, align 4
  %v6816 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6815, ptr %state, i32 %v6813, i32 %v6814)
  store ptr %v6816, ptr %MEMORY, align 4
  %v6817 = load ptr, ptr %MEMORY, align 4
  %v6818 = call ptr @__remill_atomic_end(ptr %v6817)
  store ptr %v6818, ptr %MEMORY, align 4
  store i32 %v6807, ptr %PC, align 4
  %v6819 = add i32 %v6807, 4
  store i32 %v6819, ptr %NEXT_PC, align 4
  %v6820 = load ptr, ptr %MEMORY, align 4
  %v6821 = call ptr @__remill_atomic_begin(ptr %v6820)
  store ptr %v6821, ptr %MEMORY, align 4
  %v6822 = load i32, ptr %ESP, align 4
  %v6823 = load i32, ptr %SSBASE, align 4
  %v6824 = add i32 %v6822, 4
  %v6825 = add i32 %v6824, %v6823
  %v6826 = load i32, ptr %EAX, align 4
  %v6827 = load ptr, ptr %MEMORY, align 4
  %v6828 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6827, ptr %state, i32 %v6825, i32 %v6826)
  store ptr %v6828, ptr %MEMORY, align 4
  %v6829 = load ptr, ptr %MEMORY, align 4
  %v6830 = call ptr @__remill_atomic_end(ptr %v6829)
  store ptr %v6830, ptr %MEMORY, align 4
  store i32 %v6819, ptr %PC, align 4
  %v6831 = add i32 %v6819, 3
  store i32 %v6831, ptr %NEXT_PC, align 4
  %v6832 = load ptr, ptr %MEMORY, align 4
  %v6833 = call ptr @__remill_atomic_begin(ptr %v6832)
  store ptr %v6833, ptr %MEMORY, align 4
  %v6834 = load i32, ptr %EBP, align 4
  %v6835 = sub i32 %v6834, 32
  %v6836 = load ptr, ptr %MEMORY, align 4
  %v6837 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v6836, ptr %state, ptr %EAX, i32 %v6835)
  store ptr %v6837, ptr %MEMORY, align 4
  %v6838 = load ptr, ptr %MEMORY, align 4
  %v6839 = call ptr @__remill_atomic_end(ptr %v6838)
  store ptr %v6839, ptr %MEMORY, align 4
  store i32 %v6831, ptr %PC, align 4
  %v6840 = add i32 %v6831, 3
  store i32 %v6840, ptr %NEXT_PC, align 4
  %v6841 = load ptr, ptr %MEMORY, align 4
  %v6842 = call ptr @__remill_atomic_begin(ptr %v6841)
  store ptr %v6842, ptr %MEMORY, align 4
  %v6843 = load i32, ptr %ESP, align 4
  %v6844 = load i32, ptr %SSBASE, align 4
  %v6845 = add i32 %v6843, %v6844
  %v6846 = load i32, ptr %EAX, align 4
  %v6847 = load ptr, ptr %MEMORY, align 4
  %v6848 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6847, ptr %state, i32 %v6845, i32 %v6846)
  store ptr %v6848, ptr %MEMORY, align 4
  %v6849 = load ptr, ptr %MEMORY, align 4
  %v6850 = call ptr @__remill_atomic_end(ptr %v6849)
  store ptr %v6850, ptr %MEMORY, align 4
  store i32 %v6840, ptr %PC, align 4
  %v6851 = add i32 %v6840, 5
  store i32 %v6851, ptr %NEXT_PC, align 4
  %v6852 = load ptr, ptr %MEMORY, align 4
  %v6853 = call ptr @__remill_atomic_begin(ptr %v6852)
  store ptr %v6853, ptr %MEMORY, align 4
  %v6854 = add i32 %v6851, 9151
  %v6855 = load ptr, ptr %MEMORY, align 4
  %v6856 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v6855, ptr %state, i64 4216086, ptr %NEXT_PC, i32 %v6851, ptr %RETURN_PC)
  store ptr %v6856, ptr %MEMORY, align 4
  %v6857 = load ptr, ptr %MEMORY, align 4
  %v6858 = call ptr @__remill_atomic_end(ptr %v6857)
  store ptr %v6858, ptr %MEMORY, align 4
  store i32 %v6851, ptr %PC, align 4
  %v6859 = add i32 %v6851, 3
  store i32 %v6859, ptr %NEXT_PC, align 4
  %v6860 = load ptr, ptr %MEMORY, align 4
  %v6861 = call ptr @__remill_atomic_begin(ptr %v6860)
  store ptr %v6861, ptr %MEMORY, align 4
  %v6862 = load i32, ptr %EBP, align 4
  %v6863 = load i32, ptr %SSBASE, align 4
  %v6864 = sub i32 %v6862, 12
  %v6865 = add i32 %v6864, %v6863
  %v6866 = load i32, ptr %EAX, align 4
  %v6867 = load ptr, ptr %MEMORY, align 4
  %v6868 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6867, ptr %state, i32 %v6865, i32 %v6866)
  store ptr %v6868, ptr %MEMORY, align 4
  %v6869 = load ptr, ptr %MEMORY, align 4
  %v6870 = call ptr @__remill_atomic_end(ptr %v6869)
  store ptr %v6870, ptr %MEMORY, align 4
  store i32 %v6859, ptr %PC, align 4
  %v6871 = add i32 %v6859, 4
  store i32 %v6871, ptr %NEXT_PC, align 4
  %v6872 = load ptr, ptr %MEMORY, align 4
  %v6873 = call ptr @__remill_atomic_begin(ptr %v6872)
  store ptr %v6873, ptr %MEMORY, align 4
  %v6874 = load i32, ptr %EBP, align 4
  %v6875 = load i32, ptr %SSBASE, align 4
  %v6876 = sub i32 %v6874, 12
  %v6877 = add i32 %v6876, %v6875
  %v6878 = load ptr, ptr %MEMORY, align 4
  %v6879 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6878, ptr %state, i32 %v6877, i32 0)
  store ptr %v6879, ptr %MEMORY, align 4
  %v6880 = load ptr, ptr %MEMORY, align 4
  %v6881 = call ptr @__remill_atomic_end(ptr %v6880)
  store ptr %v6881, ptr %MEMORY, align 4
  store i32 %v6871, ptr %PC, align 4
  %v6882 = add i32 %v6871, 2
  store i32 %v6882, ptr %NEXT_PC, align 4
  %v6883 = load ptr, ptr %MEMORY, align 4
  %v6884 = call ptr @__remill_atomic_begin(ptr %v6883)
  store ptr %v6884, ptr %MEMORY, align 4
  %v6885 = sub i32 %v6882, 113
  %v6886 = load ptr, ptr %MEMORY, align 4
  %v6887 = call ptr @_ZN12_GLOBAL__N_14JNLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v6886, ptr %state, ptr %BRANCH_TAKEN, i32 %v6885, i32 %v6882, ptr %NEXT_PC)
  store ptr %v6887, ptr %MEMORY, align 4
  %v6888 = load ptr, ptr %MEMORY, align 4
  %v6889 = call ptr @__remill_atomic_end(ptr %v6888)
  store ptr %v6889, ptr %MEMORY, align 4
  br i1 true, label %bb_4206831, label %bb_4206944

bb_4206944:                                       ; preds = %bb_4206900
  store i32 %v6882, ptr %PC, align 4
  %v6890 = add i32 %v6882, 2
  store i32 %v6890, ptr %NEXT_PC, align 4
  %v6891 = load ptr, ptr %MEMORY, align 4
  %v6892 = call ptr @__remill_atomic_begin(ptr %v6891)
  store ptr %v6892, ptr %MEMORY, align 4
  %v6893 = add i32 %v6890, 21
  %v6894 = load ptr, ptr %MEMORY, align 4
  %v6895 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6894, ptr %state, i32 %v6893, ptr %NEXT_PC)
  store ptr %v6895, ptr %MEMORY, align 4
  %v6896 = load ptr, ptr %MEMORY, align 4
  %v6897 = call ptr @__remill_atomic_end(ptr %v6896)
  store ptr %v6897, ptr %MEMORY, align 4
  br label %bb_4206967

bb_4206946:                                       ; preds = %bb_4206968
  store i32 %v7037, ptr %PC, align 4
  %v6898 = add i32 %v7037, 3
  store i32 %v6898, ptr %NEXT_PC, align 4
  %v6899 = load ptr, ptr %MEMORY, align 4
  %v6900 = call ptr @__remill_atomic_begin(ptr %v6899)
  store ptr %v6900, ptr %MEMORY, align 4
  %v6901 = load i32, ptr %EBP, align 4
  %v6902 = load i32, ptr %SSBASE, align 4
  %v6903 = add i32 %v6901, 16
  %v6904 = add i32 %v6903, %v6902
  %v6905 = load ptr, ptr %MEMORY, align 4
  %v6906 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6905, ptr %state, ptr %EAX, i32 %v6904)
  store ptr %v6906, ptr %MEMORY, align 4
  %v6907 = load ptr, ptr %MEMORY, align 4
  %v6908 = call ptr @__remill_atomic_end(ptr %v6907)
  store ptr %v6908, ptr %MEMORY, align 4
  store i32 %v6898, ptr %PC, align 4
  %v6909 = add i32 %v6898, 4
  store i32 %v6909, ptr %NEXT_PC, align 4
  %v6910 = load ptr, ptr %MEMORY, align 4
  %v6911 = call ptr @__remill_atomic_begin(ptr %v6910)
  store ptr %v6911, ptr %MEMORY, align 4
  %v6912 = load i32, ptr %ESP, align 4
  %v6913 = load i32, ptr %SSBASE, align 4
  %v6914 = add i32 %v6912, 4
  %v6915 = add i32 %v6914, %v6913
  %v6916 = load i32, ptr %EAX, align 4
  %v6917 = load ptr, ptr %MEMORY, align 4
  %v6918 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v6917, ptr %state, i32 %v6915, i32 %v6916)
  store ptr %v6918, ptr %MEMORY, align 4
  %v6919 = load ptr, ptr %MEMORY, align 4
  %v6920 = call ptr @__remill_atomic_end(ptr %v6919)
  store ptr %v6920, ptr %MEMORY, align 4
  store i32 %v6909, ptr %PC, align 4
  %v6921 = add i32 %v6909, 7
  store i32 %v6921, ptr %NEXT_PC, align 4
  %v6922 = load ptr, ptr %MEMORY, align 4
  %v6923 = call ptr @__remill_atomic_begin(ptr %v6922)
  store ptr %v6923, ptr %MEMORY, align 4
  %v6924 = load i32, ptr %ESP, align 4
  %v6925 = load i32, ptr %SSBASE, align 4
  %v6926 = add i32 %v6924, %v6925
  %v6927 = load ptr, ptr %MEMORY, align 4
  %v6928 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6927, ptr %state, i32 %v6926, i32 32)
  store ptr %v6928, ptr %MEMORY, align 4
  %v6929 = load ptr, ptr %MEMORY, align 4
  %v6930 = call ptr @__remill_atomic_end(ptr %v6929)
  store ptr %v6930, ptr %MEMORY, align 4
  store i32 %v6921, ptr %PC, align 4
  %v6931 = add i32 %v6921, 5
  store i32 %v6931, ptr %NEXT_PC, align 4
  %v6932 = load ptr, ptr %MEMORY, align 4
  %v6933 = call ptr @__remill_atomic_begin(ptr %v6932)
  store ptr %v6933, ptr %MEMORY, align 4
  %v6934 = sub i32 %v6931, 715
  %v6935 = load ptr, ptr %MEMORY, align 4
  %v6936 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v6935, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v6931, ptr %RETURN_PC)
  store ptr %v6936, ptr %MEMORY, align 4
  %v6937 = load ptr, ptr %MEMORY, align 4
  %v6938 = call ptr @__remill_atomic_end(ptr %v6937)
  store ptr %v6938, ptr %MEMORY, align 4
  store i32 %v6931, ptr %PC, align 4
  %v6939 = add i32 %v6931, 2
  store i32 %v6939, ptr %NEXT_PC, align 4
  %v6940 = load ptr, ptr %MEMORY, align 4
  %v6941 = call ptr @__remill_atomic_begin(ptr %v6940)
  store ptr %v6941, ptr %MEMORY, align 4
  %v6942 = add i32 %v6939, 1
  %v6943 = load ptr, ptr %MEMORY, align 4
  %v6944 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v6943, ptr %state, i32 %v6942, ptr %NEXT_PC)
  store ptr %v6944, ptr %MEMORY, align 4
  %v6945 = load ptr, ptr %MEMORY, align 4
  %v6946 = call ptr @__remill_atomic_end(ptr %v6945)
  store ptr %v6946, ptr %MEMORY, align 4
  br label %bb_4206968

bb_4206967:                                       ; preds = %bb_4206944, %bb_4206885
  %v6947 = load i32, ptr %NEXT_PC, align 4
  store i32 %v6947, ptr %PC, align 4
  %v6948 = add i32 %v6947, 1
  store i32 %v6948, ptr %NEXT_PC, align 4
  %v6949 = load ptr, ptr %MEMORY, align 4
  %v6950 = call ptr @__remill_atomic_begin(ptr %v6949)
  store ptr %v6950, ptr %MEMORY, align 4
  %v6951 = load ptr, ptr %MEMORY, align 4
  %v6952 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v6951, ptr %state)
  store ptr %v6952, ptr %MEMORY, align 4
  %v6953 = load ptr, ptr %MEMORY, align 4
  %v6954 = call ptr @__remill_atomic_end(ptr %v6953)
  store ptr %v6954, ptr %MEMORY, align 4
  br label %bb_4206968

bb_4206968:                                       ; preds = %bb_4206967, %bb_4206946
  %v6955 = load i32, ptr %NEXT_PC, align 4
  store i32 %v6955, ptr %PC, align 4
  %v6956 = add i32 %v6955, 3
  store i32 %v6956, ptr %NEXT_PC, align 4
  %v6957 = load ptr, ptr %MEMORY, align 4
  %v6958 = call ptr @__remill_atomic_begin(ptr %v6957)
  store ptr %v6958, ptr %MEMORY, align 4
  %v6959 = load i32, ptr %EBP, align 4
  %v6960 = load i32, ptr %SSBASE, align 4
  %v6961 = add i32 %v6959, 16
  %v6962 = add i32 %v6961, %v6960
  %v6963 = load ptr, ptr %MEMORY, align 4
  %v6964 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6963, ptr %state, ptr %EAX, i32 %v6962)
  store ptr %v6964, ptr %MEMORY, align 4
  %v6965 = load ptr, ptr %MEMORY, align 4
  %v6966 = call ptr @__remill_atomic_end(ptr %v6965)
  store ptr %v6966, ptr %MEMORY, align 4
  store i32 %v6956, ptr %PC, align 4
  %v6967 = add i32 %v6956, 3
  store i32 %v6967, ptr %NEXT_PC, align 4
  %v6968 = load ptr, ptr %MEMORY, align 4
  %v6969 = call ptr @__remill_atomic_begin(ptr %v6968)
  store ptr %v6969, ptr %MEMORY, align 4
  %v6970 = load i32, ptr %EAX, align 4
  %v6971 = load i32, ptr %DSBASE, align 4
  %v6972 = add i32 %v6970, 8
  %v6973 = add i32 %v6972, %v6971
  %v6974 = load ptr, ptr %MEMORY, align 4
  %v6975 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v6974, ptr %state, ptr %EAX, i32 %v6973)
  store ptr %v6975, ptr %MEMORY, align 4
  %v6976 = load ptr, ptr %MEMORY, align 4
  %v6977 = call ptr @__remill_atomic_end(ptr %v6976)
  store ptr %v6977, ptr %MEMORY, align 4
  store i32 %v6967, ptr %PC, align 4
  %v6978 = add i32 %v6967, 2
  store i32 %v6978, ptr %NEXT_PC, align 4
  %v6979 = load ptr, ptr %MEMORY, align 4
  %v6980 = call ptr @__remill_atomic_begin(ptr %v6979)
  store ptr %v6980, ptr %MEMORY, align 4
  %v6981 = load i32, ptr %EAX, align 4
  %v6982 = load i32, ptr %EAX, align 4
  %v6983 = load ptr, ptr %MEMORY, align 4
  %v6984 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v6983, ptr %state, i32 %v6981, i32 %v6982)
  store ptr %v6984, ptr %MEMORY, align 4
  %v6985 = load ptr, ptr %MEMORY, align 4
  %v6986 = call ptr @__remill_atomic_end(ptr %v6985)
  store ptr %v6986, ptr %MEMORY, align 4
  store i32 %v6978, ptr %PC, align 4
  %v6987 = add i32 %v6978, 3
  store i32 %v6987, ptr %NEXT_PC, align 4
  %v6988 = load ptr, ptr %MEMORY, align 4
  %v6989 = call ptr @__remill_atomic_begin(ptr %v6988)
  store ptr %v6989, ptr %MEMORY, align 4
  %v6990 = load ptr, ptr %MEMORY, align 4
  %v6991 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v6990, ptr %state, ptr %DL)
  store ptr %v6991, ptr %MEMORY, align 4
  %v6992 = load ptr, ptr %MEMORY, align 4
  %v6993 = call ptr @__remill_atomic_end(ptr %v6992)
  store ptr %v6993, ptr %MEMORY, align 4
  store i32 %v6987, ptr %PC, align 4
  %v6994 = add i32 %v6987, 3
  store i32 %v6994, ptr %NEXT_PC, align 4
  %v6995 = load ptr, ptr %MEMORY, align 4
  %v6996 = call ptr @__remill_atomic_begin(ptr %v6995)
  store ptr %v6996, ptr %MEMORY, align 4
  %v6997 = load i32, ptr %EAX, align 4
  %v6998 = sub i32 %v6997, 1
  %v6999 = load ptr, ptr %MEMORY, align 4
  %v7000 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v6999, ptr %state, ptr %ECX, i32 %v6998)
  store ptr %v7000, ptr %MEMORY, align 4
  %v7001 = load ptr, ptr %MEMORY, align 4
  %v7002 = call ptr @__remill_atomic_end(ptr %v7001)
  store ptr %v7002, ptr %MEMORY, align 4
  store i32 %v6994, ptr %PC, align 4
  %v7003 = add i32 %v6994, 3
  store i32 %v7003, ptr %NEXT_PC, align 4
  %v7004 = load ptr, ptr %MEMORY, align 4
  %v7005 = call ptr @__remill_atomic_begin(ptr %v7004)
  store ptr %v7005, ptr %MEMORY, align 4
  %v7006 = load i32, ptr %EBP, align 4
  %v7007 = load i32, ptr %SSBASE, align 4
  %v7008 = add i32 %v7006, 16
  %v7009 = add i32 %v7008, %v7007
  %v7010 = load ptr, ptr %MEMORY, align 4
  %v7011 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7010, ptr %state, ptr %EAX, i32 %v7009)
  store ptr %v7011, ptr %MEMORY, align 4
  %v7012 = load ptr, ptr %MEMORY, align 4
  %v7013 = call ptr @__remill_atomic_end(ptr %v7012)
  store ptr %v7013, ptr %MEMORY, align 4
  store i32 %v7003, ptr %PC, align 4
  %v7014 = add i32 %v7003, 3
  store i32 %v7014, ptr %NEXT_PC, align 4
  %v7015 = load ptr, ptr %MEMORY, align 4
  %v7016 = call ptr @__remill_atomic_begin(ptr %v7015)
  store ptr %v7016, ptr %MEMORY, align 4
  %v7017 = load i32, ptr %EAX, align 4
  %v7018 = load i32, ptr %DSBASE, align 4
  %v7019 = add i32 %v7017, 8
  %v7020 = add i32 %v7019, %v7018
  %v7021 = load i32, ptr %ECX, align 4
  %v7022 = load ptr, ptr %MEMORY, align 4
  %v7023 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7022, ptr %state, i32 %v7020, i32 %v7021)
  store ptr %v7023, ptr %MEMORY, align 4
  %v7024 = load ptr, ptr %MEMORY, align 4
  %v7025 = call ptr @__remill_atomic_end(ptr %v7024)
  store ptr %v7025, ptr %MEMORY, align 4
  store i32 %v7014, ptr %PC, align 4
  %v7026 = add i32 %v7014, 2
  store i32 %v7026, ptr %NEXT_PC, align 4
  %v7027 = load ptr, ptr %MEMORY, align 4
  %v7028 = call ptr @__remill_atomic_begin(ptr %v7027)
  store ptr %v7028, ptr %MEMORY, align 4
  %v7029 = load i8, ptr %DL, align 1
  %v7030 = zext i8 %v7029 to i32
  %v7031 = load i8, ptr %DL, align 1
  %v7032 = zext i8 %v7031 to i32
  %v7033 = load ptr, ptr %MEMORY, align 4
  %v7034 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v7033, ptr %state, i32 %v7030, i32 %v7032)
  store ptr %v7034, ptr %MEMORY, align 4
  %v7035 = load ptr, ptr %MEMORY, align 4
  %v7036 = call ptr @__remill_atomic_end(ptr %v7035)
  store ptr %v7036, ptr %MEMORY, align 4
  store i32 %v7026, ptr %PC, align 4
  %v7037 = add i32 %v7026, 2
  store i32 %v7037, ptr %NEXT_PC, align 4
  %v7038 = load ptr, ptr %MEMORY, align 4
  %v7039 = call ptr @__remill_atomic_begin(ptr %v7038)
  store ptr %v7039, ptr %MEMORY, align 4
  %v7040 = sub i32 %v7037, 46
  %v7041 = load ptr, ptr %MEMORY, align 4
  %v7042 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v7041, ptr %state, ptr %BRANCH_TAKEN, i32 %v7040, i32 %v7037, ptr %NEXT_PC)
  store ptr %v7042, ptr %MEMORY, align 4
  %v7043 = load ptr, ptr %MEMORY, align 4
  %v7044 = call ptr @__remill_atomic_end(ptr %v7043)
  store ptr %v7044, ptr %MEMORY, align 4
  br i1 true, label %bb_4206946, label %bb_4206992

bb_4206992:                                       ; preds = %bb_4206968
  store i32 %v7037, ptr %PC, align 4
  %v7045 = add i32 %v7037, 1
  store i32 %v7045, ptr %NEXT_PC, align 4
  %v7046 = load ptr, ptr %MEMORY, align 4
  %v7047 = call ptr @__remill_atomic_begin(ptr %v7046)
  store ptr %v7047, ptr %MEMORY, align 4
  %v7048 = load ptr, ptr %MEMORY, align 4
  %v7049 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v7048, ptr %state)
  store ptr %v7049, ptr %MEMORY, align 4
  %v7050 = load ptr, ptr %MEMORY, align 4
  %v7051 = call ptr @__remill_atomic_end(ptr %v7050)
  store ptr %v7051, ptr %MEMORY, align 4
  store i32 %v7045, ptr %PC, align 4
  %v7052 = add i32 %v7045, 1
  store i32 %v7052, ptr %NEXT_PC, align 4
  %v7053 = load ptr, ptr %MEMORY, align 4
  %v7054 = call ptr @__remill_atomic_begin(ptr %v7053)
  store ptr %v7054, ptr %MEMORY, align 4
  %v7055 = load ptr, ptr %MEMORY, align 4
  %v7056 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v7055, ptr %state, ptr %NEXT_PC)
  store ptr %v7056, ptr %MEMORY, align 4
  %v7057 = load ptr, ptr %MEMORY, align 4
  %v7058 = call ptr @__remill_atomic_end(ptr %v7057)
  store ptr %v7058, ptr %MEMORY, align 4
  ret ptr %memory

bb_4206994:                                       ; No predecessors!
  %v7059 = load i32, ptr %NEXT_PC, align 4
  store i32 %v7059, ptr %PC, align 4
  %v7060 = add i32 %v7059, 1
  store i32 %v7060, ptr %NEXT_PC, align 4
  %v7061 = load ptr, ptr %MEMORY, align 4
  %v7062 = call ptr @__remill_atomic_begin(ptr %v7061)
  store ptr %v7062, ptr %MEMORY, align 4
  %v7063 = load i32, ptr %EBP, align 4
  %v7064 = load ptr, ptr %MEMORY, align 4
  %v7065 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v7064, ptr %state, i32 %v7063)
  store ptr %v7065, ptr %MEMORY, align 4
  %v7066 = load ptr, ptr %MEMORY, align 4
  %v7067 = call ptr @__remill_atomic_end(ptr %v7066)
  store ptr %v7067, ptr %MEMORY, align 4
  store i32 %v7060, ptr %PC, align 4
  %v7068 = add i32 %v7060, 2
  store i32 %v7068, ptr %NEXT_PC, align 4
  %v7069 = load ptr, ptr %MEMORY, align 4
  %v7070 = call ptr @__remill_atomic_begin(ptr %v7069)
  store ptr %v7070, ptr %MEMORY, align 4
  %v7071 = load i32, ptr %ESP, align 4
  %v7072 = load ptr, ptr %MEMORY, align 4
  %v7073 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7072, ptr %state, ptr %EBP, i32 %v7071)
  store ptr %v7073, ptr %MEMORY, align 4
  %v7074 = load ptr, ptr %MEMORY, align 4
  %v7075 = call ptr @__remill_atomic_end(ptr %v7074)
  store ptr %v7075, ptr %MEMORY, align 4
  store i32 %v7068, ptr %PC, align 4
  %v7076 = add i32 %v7068, 3
  store i32 %v7076, ptr %NEXT_PC, align 4
  %v7077 = load ptr, ptr %MEMORY, align 4
  %v7078 = call ptr @__remill_atomic_begin(ptr %v7077)
  store ptr %v7078, ptr %MEMORY, align 4
  %v7079 = load i32, ptr %ESP, align 4
  %v7080 = load ptr, ptr %MEMORY, align 4
  %v7081 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7080, ptr %state, ptr %ESP, i32 %v7079, i32 24)
  store ptr %v7081, ptr %MEMORY, align 4
  %v7082 = load ptr, ptr %MEMORY, align 4
  %v7083 = call ptr @__remill_atomic_end(ptr %v7082)
  store ptr %v7083, ptr %MEMORY, align 4
  store i32 %v7076, ptr %PC, align 4
  %v7084 = add i32 %v7076, 4
  store i32 %v7084, ptr %NEXT_PC, align 4
  %v7085 = load ptr, ptr %MEMORY, align 4
  %v7086 = call ptr @__remill_atomic_begin(ptr %v7085)
  store ptr %v7086, ptr %MEMORY, align 4
  %v7087 = load i32, ptr %EBP, align 4
  %v7088 = load i32, ptr %SSBASE, align 4
  %v7089 = add i32 %v7087, 8
  %v7090 = add i32 %v7089, %v7088
  %v7091 = load ptr, ptr %MEMORY, align 4
  %v7092 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7091, ptr %state, i32 %v7090, i32 0)
  store ptr %v7092, ptr %MEMORY, align 4
  %v7093 = load ptr, ptr %MEMORY, align 4
  %v7094 = call ptr @__remill_atomic_end(ptr %v7093)
  store ptr %v7094, ptr %MEMORY, align 4
  store i32 %v7084, ptr %PC, align 4
  %v7095 = add i32 %v7084, 2
  store i32 %v7095, ptr %NEXT_PC, align 4
  %v7096 = load ptr, ptr %MEMORY, align 4
  %v7097 = call ptr @__remill_atomic_begin(ptr %v7096)
  store ptr %v7097, ptr %MEMORY, align 4
  %v7098 = add i32 %v7095, 7
  %v7099 = load ptr, ptr %MEMORY, align 4
  %v7100 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v7099, ptr %state, ptr %BRANCH_TAKEN, i32 %v7098, i32 %v7095, ptr %NEXT_PC)
  store ptr %v7100, ptr %MEMORY, align 4
  %v7101 = load ptr, ptr %MEMORY, align 4
  %v7102 = call ptr @__remill_atomic_end(ptr %v7101)
  store ptr %v7102, ptr %MEMORY, align 4
  br i1 true, label %bb_4207013, label %bb_4207006

bb_4207006:                                       ; preds = %bb_4206994
  store i32 %v7095, ptr %PC, align 4
  %v7103 = add i32 %v7095, 7
  store i32 %v7103, ptr %NEXT_PC, align 4
  %v7104 = load ptr, ptr %MEMORY, align 4
  %v7105 = call ptr @__remill_atomic_begin(ptr %v7104)
  store ptr %v7105, ptr %MEMORY, align 4
  %v7106 = load i32, ptr %EBP, align 4
  %v7107 = load i32, ptr %SSBASE, align 4
  %v7108 = add i32 %v7106, 8
  %v7109 = add i32 %v7108, %v7107
  %v7110 = load ptr, ptr %MEMORY, align 4
  %v7111 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7110, ptr %state, i32 %v7109, i32 4235978)
  store ptr %v7111, ptr %MEMORY, align 4
  %v7112 = load ptr, ptr %MEMORY, align 4
  %v7113 = call ptr @__remill_atomic_end(ptr %v7112)
  store ptr %v7113, ptr %MEMORY, align 4
  br label %bb_4207013

bb_4207013:                                       ; preds = %bb_4207006, %bb_4206994
  %v7114 = load i32, ptr %NEXT_PC, align 4
  store i32 %v7114, ptr %PC, align 4
  %v7115 = add i32 %v7114, 3
  store i32 %v7115, ptr %NEXT_PC, align 4
  %v7116 = load ptr, ptr %MEMORY, align 4
  %v7117 = call ptr @__remill_atomic_begin(ptr %v7116)
  store ptr %v7117, ptr %MEMORY, align 4
  %v7118 = load i32, ptr %EBP, align 4
  %v7119 = load i32, ptr %SSBASE, align 4
  %v7120 = add i32 %v7118, 8
  %v7121 = add i32 %v7120, %v7119
  %v7122 = load ptr, ptr %MEMORY, align 4
  %v7123 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7122, ptr %state, ptr %EAX, i32 %v7121)
  store ptr %v7123, ptr %MEMORY, align 4
  %v7124 = load ptr, ptr %MEMORY, align 4
  %v7125 = call ptr @__remill_atomic_end(ptr %v7124)
  store ptr %v7125, ptr %MEMORY, align 4
  store i32 %v7115, ptr %PC, align 4
  %v7126 = add i32 %v7115, 3
  store i32 %v7126, ptr %NEXT_PC, align 4
  %v7127 = load ptr, ptr %MEMORY, align 4
  %v7128 = call ptr @__remill_atomic_begin(ptr %v7127)
  store ptr %v7128, ptr %MEMORY, align 4
  %v7129 = load i32, ptr %ESP, align 4
  %v7130 = load i32, ptr %SSBASE, align 4
  %v7131 = add i32 %v7129, %v7130
  %v7132 = load i32, ptr %EAX, align 4
  %v7133 = load ptr, ptr %MEMORY, align 4
  %v7134 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7133, ptr %state, i32 %v7131, i32 %v7132)
  store ptr %v7134, ptr %MEMORY, align 4
  %v7135 = load ptr, ptr %MEMORY, align 4
  %v7136 = call ptr @__remill_atomic_end(ptr %v7135)
  store ptr %v7136, ptr %MEMORY, align 4
  store i32 %v7126, ptr %PC, align 4
  %v7137 = add i32 %v7126, 5
  store i32 %v7137, ptr %NEXT_PC, align 4
  %v7138 = load ptr, ptr %MEMORY, align 4
  %v7139 = call ptr @__remill_atomic_begin(ptr %v7138)
  store ptr %v7139, ptr %MEMORY, align 4
  %v7140 = add i32 %v7137, 21660
  %v7141 = load ptr, ptr %MEMORY, align 4
  %v7142 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v7141, ptr %state, i64 4228684, ptr %NEXT_PC, i32 %v7137, ptr %RETURN_PC)
  store ptr %v7142, ptr %MEMORY, align 4
  %v7143 = load ptr, ptr %MEMORY, align 4
  %v7144 = call ptr @__remill_atomic_end(ptr %v7143)
  store ptr %v7144, ptr %MEMORY, align 4
  store i32 %v7137, ptr %PC, align 4
  %v7145 = add i32 %v7137, 3
  store i32 %v7145, ptr %NEXT_PC, align 4
  %v7146 = load ptr, ptr %MEMORY, align 4
  %v7147 = call ptr @__remill_atomic_begin(ptr %v7146)
  store ptr %v7147, ptr %MEMORY, align 4
  %v7148 = load i32, ptr %EBP, align 4
  %v7149 = load i32, ptr %SSBASE, align 4
  %v7150 = add i32 %v7148, 12
  %v7151 = add i32 %v7150, %v7149
  %v7152 = load ptr, ptr %MEMORY, align 4
  %v7153 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7152, ptr %state, ptr %EDX, i32 %v7151)
  store ptr %v7153, ptr %MEMORY, align 4
  %v7154 = load ptr, ptr %MEMORY, align 4
  %v7155 = call ptr @__remill_atomic_end(ptr %v7154)
  store ptr %v7155, ptr %MEMORY, align 4
  store i32 %v7145, ptr %PC, align 4
  %v7156 = add i32 %v7145, 4
  store i32 %v7156, ptr %NEXT_PC, align 4
  %v7157 = load ptr, ptr %MEMORY, align 4
  %v7158 = call ptr @__remill_atomic_begin(ptr %v7157)
  store ptr %v7158, ptr %MEMORY, align 4
  %v7159 = load i32, ptr %ESP, align 4
  %v7160 = load i32, ptr %SSBASE, align 4
  %v7161 = add i32 %v7159, 8
  %v7162 = add i32 %v7161, %v7160
  %v7163 = load i32, ptr %EDX, align 4
  %v7164 = load ptr, ptr %MEMORY, align 4
  %v7165 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7164, ptr %state, i32 %v7162, i32 %v7163)
  store ptr %v7165, ptr %MEMORY, align 4
  %v7166 = load ptr, ptr %MEMORY, align 4
  %v7167 = call ptr @__remill_atomic_end(ptr %v7166)
  store ptr %v7167, ptr %MEMORY, align 4
  store i32 %v7156, ptr %PC, align 4
  %v7168 = add i32 %v7156, 4
  store i32 %v7168, ptr %NEXT_PC, align 4
  %v7169 = load ptr, ptr %MEMORY, align 4
  %v7170 = call ptr @__remill_atomic_begin(ptr %v7169)
  store ptr %v7170, ptr %MEMORY, align 4
  %v7171 = load i32, ptr %ESP, align 4
  %v7172 = load i32, ptr %SSBASE, align 4
  %v7173 = add i32 %v7171, 4
  %v7174 = add i32 %v7173, %v7172
  %v7175 = load i32, ptr %EAX, align 4
  %v7176 = load ptr, ptr %MEMORY, align 4
  %v7177 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7176, ptr %state, i32 %v7174, i32 %v7175)
  store ptr %v7177, ptr %MEMORY, align 4
  %v7178 = load ptr, ptr %MEMORY, align 4
  %v7179 = call ptr @__remill_atomic_end(ptr %v7178)
  store ptr %v7179, ptr %MEMORY, align 4
  store i32 %v7168, ptr %PC, align 4
  %v7180 = add i32 %v7168, 3
  store i32 %v7180, ptr %NEXT_PC, align 4
  %v7181 = load ptr, ptr %MEMORY, align 4
  %v7182 = call ptr @__remill_atomic_begin(ptr %v7181)
  store ptr %v7182, ptr %MEMORY, align 4
  %v7183 = load i32, ptr %EBP, align 4
  %v7184 = load i32, ptr %SSBASE, align 4
  %v7185 = add i32 %v7183, 8
  %v7186 = add i32 %v7185, %v7184
  %v7187 = load ptr, ptr %MEMORY, align 4
  %v7188 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7187, ptr %state, ptr %EAX, i32 %v7186)
  store ptr %v7188, ptr %MEMORY, align 4
  %v7189 = load ptr, ptr %MEMORY, align 4
  %v7190 = call ptr @__remill_atomic_end(ptr %v7189)
  store ptr %v7190, ptr %MEMORY, align 4
  store i32 %v7180, ptr %PC, align 4
  %v7191 = add i32 %v7180, 3
  store i32 %v7191, ptr %NEXT_PC, align 4
  %v7192 = load ptr, ptr %MEMORY, align 4
  %v7193 = call ptr @__remill_atomic_begin(ptr %v7192)
  store ptr %v7193, ptr %MEMORY, align 4
  %v7194 = load i32, ptr %ESP, align 4
  %v7195 = load i32, ptr %SSBASE, align 4
  %v7196 = add i32 %v7194, %v7195
  %v7197 = load i32, ptr %EAX, align 4
  %v7198 = load ptr, ptr %MEMORY, align 4
  %v7199 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7198, ptr %state, i32 %v7196, i32 %v7197)
  store ptr %v7199, ptr %MEMORY, align 4
  %v7200 = load ptr, ptr %MEMORY, align 4
  %v7201 = call ptr @__remill_atomic_end(ptr %v7200)
  store ptr %v7201, ptr %MEMORY, align 4
  store i32 %v7191, ptr %PC, align 4
  %v7202 = add i32 %v7191, 5
  store i32 %v7202, ptr %NEXT_PC, align 4
  %v7203 = load ptr, ptr %MEMORY, align 4
  %v7204 = call ptr @__remill_atomic_begin(ptr %v7203)
  store ptr %v7204, ptr %MEMORY, align 4
  %v7205 = sub i32 %v7202, 392
  %v7206 = load ptr, ptr %MEMORY, align 4
  %v7207 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v7206, ptr %state, i64 4206654, ptr %NEXT_PC, i32 %v7202, ptr %RETURN_PC)
  store ptr %v7207, ptr %MEMORY, align 4
  %v7208 = load ptr, ptr %MEMORY, align 4
  %v7209 = call ptr @__remill_atomic_end(ptr %v7208)
  store ptr %v7209, ptr %MEMORY, align 4
  store i32 %v7202, ptr %PC, align 4
  %v7210 = add i32 %v7202, 1
  store i32 %v7210, ptr %NEXT_PC, align 4
  %v7211 = load ptr, ptr %MEMORY, align 4
  %v7212 = call ptr @__remill_atomic_begin(ptr %v7211)
  store ptr %v7212, ptr %MEMORY, align 4
  %v7213 = load ptr, ptr %MEMORY, align 4
  %v7214 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v7213, ptr %state)
  store ptr %v7214, ptr %MEMORY, align 4
  %v7215 = load ptr, ptr %MEMORY, align 4
  %v7216 = call ptr @__remill_atomic_end(ptr %v7215)
  store ptr %v7216, ptr %MEMORY, align 4
  store i32 %v7210, ptr %PC, align 4
  %v7217 = add i32 %v7210, 1
  store i32 %v7217, ptr %NEXT_PC, align 4
  %v7218 = load ptr, ptr %MEMORY, align 4
  %v7219 = call ptr @__remill_atomic_begin(ptr %v7218)
  store ptr %v7219, ptr %MEMORY, align 4
  %v7220 = load ptr, ptr %MEMORY, align 4
  %v7221 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v7220, ptr %state, ptr %NEXT_PC)
  store ptr %v7221, ptr %MEMORY, align 4
  %v7222 = load ptr, ptr %MEMORY, align 4
  %v7223 = call ptr @__remill_atomic_end(ptr %v7222)
  store ptr %v7223, ptr %MEMORY, align 4
  ret ptr %memory

bb_4207048:                                       ; No predecessors!
  %v7224 = load i32, ptr %NEXT_PC, align 4
  store i32 %v7224, ptr %PC, align 4
  %v7225 = add i32 %v7224, 1
  store i32 %v7225, ptr %NEXT_PC, align 4
  %v7226 = load ptr, ptr %MEMORY, align 4
  %v7227 = call ptr @__remill_atomic_begin(ptr %v7226)
  store ptr %v7227, ptr %MEMORY, align 4
  %v7228 = load i32, ptr %EBP, align 4
  %v7229 = load ptr, ptr %MEMORY, align 4
  %v7230 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v7229, ptr %state, i32 %v7228)
  store ptr %v7230, ptr %MEMORY, align 4
  %v7231 = load ptr, ptr %MEMORY, align 4
  %v7232 = call ptr @__remill_atomic_end(ptr %v7231)
  store ptr %v7232, ptr %MEMORY, align 4
  store i32 %v7225, ptr %PC, align 4
  %v7233 = add i32 %v7225, 2
  store i32 %v7233, ptr %NEXT_PC, align 4
  %v7234 = load ptr, ptr %MEMORY, align 4
  %v7235 = call ptr @__remill_atomic_begin(ptr %v7234)
  store ptr %v7235, ptr %MEMORY, align 4
  %v7236 = load i32, ptr %ESP, align 4
  %v7237 = load ptr, ptr %MEMORY, align 4
  %v7238 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7237, ptr %state, ptr %EBP, i32 %v7236)
  store ptr %v7238, ptr %MEMORY, align 4
  %v7239 = load ptr, ptr %MEMORY, align 4
  %v7240 = call ptr @__remill_atomic_end(ptr %v7239)
  store ptr %v7240, ptr %MEMORY, align 4
  store i32 %v7233, ptr %PC, align 4
  %v7241 = add i32 %v7233, 3
  store i32 %v7241, ptr %NEXT_PC, align 4
  %v7242 = load ptr, ptr %MEMORY, align 4
  %v7243 = call ptr @__remill_atomic_begin(ptr %v7242)
  store ptr %v7243, ptr %MEMORY, align 4
  %v7244 = load i32, ptr %ESP, align 4
  %v7245 = load ptr, ptr %MEMORY, align 4
  %v7246 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7245, ptr %state, ptr %ESP, i32 %v7244, i32 4)
  store ptr %v7246, ptr %MEMORY, align 4
  %v7247 = load ptr, ptr %MEMORY, align 4
  %v7248 = call ptr @__remill_atomic_end(ptr %v7247)
  store ptr %v7248, ptr %MEMORY, align 4
  store i32 %v7241, ptr %PC, align 4
  %v7249 = add i32 %v7241, 3
  store i32 %v7249, ptr %NEXT_PC, align 4
  %v7250 = load ptr, ptr %MEMORY, align 4
  %v7251 = call ptr @__remill_atomic_begin(ptr %v7250)
  store ptr %v7251, ptr %MEMORY, align 4
  %v7252 = load i32, ptr %EBP, align 4
  %v7253 = load i32, ptr %SSBASE, align 4
  %v7254 = add i32 %v7252, 12
  %v7255 = add i32 %v7254, %v7253
  %v7256 = load ptr, ptr %MEMORY, align 4
  %v7257 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7256, ptr %state, ptr %EAX, i32 %v7255)
  store ptr %v7257, ptr %MEMORY, align 4
  %v7258 = load ptr, ptr %MEMORY, align 4
  %v7259 = call ptr @__remill_atomic_end(ptr %v7258)
  store ptr %v7259, ptr %MEMORY, align 4
  store i32 %v7249, ptr %PC, align 4
  %v7260 = add i32 %v7249, 3
  store i32 %v7260, ptr %NEXT_PC, align 4
  %v7261 = load ptr, ptr %MEMORY, align 4
  %v7262 = call ptr @__remill_atomic_begin(ptr %v7261)
  store ptr %v7262, ptr %MEMORY, align 4
  %v7263 = load i32, ptr %EAX, align 4
  %v7264 = load ptr, ptr %MEMORY, align 4
  %v7265 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7264, ptr %state, ptr %EAX, i32 %v7263, i32 63)
  store ptr %v7265, ptr %MEMORY, align 4
  %v7266 = load ptr, ptr %MEMORY, align 4
  %v7267 = call ptr @__remill_atomic_end(ptr %v7266)
  store ptr %v7267, ptr %MEMORY, align 4
  store i32 %v7260, ptr %PC, align 4
  %v7268 = add i32 %v7260, 3
  store i32 %v7268, ptr %NEXT_PC, align 4
  %v7269 = load ptr, ptr %MEMORY, align 4
  %v7270 = call ptr @__remill_atomic_begin(ptr %v7269)
  store ptr %v7270, ptr %MEMORY, align 4
  %v7271 = load i32, ptr %EBP, align 4
  %v7272 = load i32, ptr %SSBASE, align 4
  %v7273 = add i32 %v7271, 12
  %v7274 = add i32 %v7273, %v7272
  %v7275 = load ptr, ptr %MEMORY, align 4
  %v7276 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7275, ptr %state, ptr %EDX, i32 %v7274)
  store ptr %v7276, ptr %MEMORY, align 4
  %v7277 = load ptr, ptr %MEMORY, align 4
  %v7278 = call ptr @__remill_atomic_end(ptr %v7277)
  store ptr %v7278, ptr %MEMORY, align 4
  store i32 %v7268, ptr %PC, align 4
  %v7279 = add i32 %v7268, 3
  store i32 %v7279, ptr %NEXT_PC, align 4
  %v7280 = load ptr, ptr %MEMORY, align 4
  %v7281 = call ptr @__remill_atomic_begin(ptr %v7280)
  store ptr %v7281, ptr %MEMORY, align 4
  %v7282 = load i32, ptr %EBP, align 4
  %v7283 = load i32, ptr %SSBASE, align 4
  %v7284 = sub i32 %v7282, 4
  %v7285 = add i32 %v7284, %v7283
  %v7286 = load i32, ptr %EDX, align 4
  %v7287 = load ptr, ptr %MEMORY, align 4
  %v7288 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7287, ptr %state, i32 %v7285, i32 %v7286)
  store ptr %v7288, ptr %MEMORY, align 4
  %v7289 = load ptr, ptr %MEMORY, align 4
  %v7290 = call ptr @__remill_atomic_end(ptr %v7289)
  store ptr %v7290, ptr %MEMORY, align 4
  store i32 %v7279, ptr %PC, align 4
  %v7291 = add i32 %v7279, 5
  store i32 %v7291, ptr %NEXT_PC, align 4
  %v7292 = load ptr, ptr %MEMORY, align 4
  %v7293 = call ptr @__remill_atomic_begin(ptr %v7292)
  store ptr %v7293, ptr %MEMORY, align 4
  %v7294 = load ptr, ptr %MEMORY, align 4
  %v7295 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7294, ptr %state, ptr %EDX, i32 0)
  store ptr %v7295, ptr %MEMORY, align 4
  %v7296 = load ptr, ptr %MEMORY, align 4
  %v7297 = call ptr @__remill_atomic_end(ptr %v7296)
  store ptr %v7297, ptr %MEMORY, align 4
  store i32 %v7291, ptr %PC, align 4
  %v7298 = add i32 %v7291, 3
  store i32 %v7298, ptr %NEXT_PC, align 4
  %v7299 = load ptr, ptr %MEMORY, align 4
  %v7300 = call ptr @__remill_atomic_begin(ptr %v7299)
  store ptr %v7300, ptr %MEMORY, align 4
  %v7301 = load i32, ptr %EBP, align 4
  %v7302 = load i32, ptr %SSBASE, align 4
  %v7303 = sub i32 %v7301, 4
  %v7304 = add i32 %v7303, %v7302
  %v7305 = load ptr, ptr %MEMORY, align 4
  %v7306 = call ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr %v7305, ptr %state, i32 %v7304, i32 %v7298)
  store ptr %v7306, ptr %MEMORY, align 4
  %v7307 = load ptr, ptr %MEMORY, align 4
  %v7308 = call ptr @__remill_atomic_end(ptr %v7307)
  store ptr %v7308, ptr %MEMORY, align 4
  store i32 %v7298, ptr %PC, align 4
  %v7309 = add i32 %v7298, 2
  store i32 %v7309, ptr %NEXT_PC, align 4
  %v7310 = load ptr, ptr %MEMORY, align 4
  %v7311 = call ptr @__remill_atomic_begin(ptr %v7310)
  store ptr %v7311, ptr %MEMORY, align 4
  %v7312 = load i32, ptr %EAX, align 4
  %v7313 = load ptr, ptr %MEMORY, align 4
  %v7314 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7313, ptr %state, ptr %EDX, i32 %v7312)
  store ptr %v7314, ptr %MEMORY, align 4
  %v7315 = load ptr, ptr %MEMORY, align 4
  %v7316 = call ptr @__remill_atomic_end(ptr %v7315)
  store ptr %v7316, ptr %MEMORY, align 4
  store i32 %v7309, ptr %PC, align 4
  %v7317 = add i32 %v7309, 3
  store i32 %v7317, ptr %NEXT_PC, align 4
  %v7318 = load ptr, ptr %MEMORY, align 4
  %v7319 = call ptr @__remill_atomic_begin(ptr %v7318)
  store ptr %v7319, ptr %MEMORY, align 4
  %v7320 = load i32, ptr %EBP, align 4
  %v7321 = load i32, ptr %SSBASE, align 4
  %v7322 = add i32 %v7320, 8
  %v7323 = add i32 %v7322, %v7321
  %v7324 = load ptr, ptr %MEMORY, align 4
  %v7325 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7324, ptr %state, ptr %EAX, i32 %v7323)
  store ptr %v7325, ptr %MEMORY, align 4
  %v7326 = load ptr, ptr %MEMORY, align 4
  %v7327 = call ptr @__remill_atomic_end(ptr %v7326)
  store ptr %v7327, ptr %MEMORY, align 4
  store i32 %v7317, ptr %PC, align 4
  %v7328 = add i32 %v7317, 2
  store i32 %v7328, ptr %NEXT_PC, align 4
  %v7329 = load ptr, ptr %MEMORY, align 4
  %v7330 = call ptr @__remill_atomic_begin(ptr %v7329)
  store ptr %v7330, ptr %MEMORY, align 4
  %v7331 = load i32, ptr %EAX, align 4
  %v7332 = load i32, ptr %EDX, align 4
  %v7333 = load ptr, ptr %MEMORY, align 4
  %v7334 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v7333, ptr %state, ptr %EAX, i32 %v7331, i32 %v7332)
  store ptr %v7334, ptr %MEMORY, align 4
  %v7335 = load ptr, ptr %MEMORY, align 4
  %v7336 = call ptr @__remill_atomic_end(ptr %v7335)
  store ptr %v7336, ptr %MEMORY, align 4
  store i32 %v7328, ptr %PC, align 4
  %v7337 = add i32 %v7328, 3
  store i32 %v7337, ptr %NEXT_PC, align 4
  %v7338 = load ptr, ptr %MEMORY, align 4
  %v7339 = call ptr @__remill_atomic_begin(ptr %v7338)
  store ptr %v7339, ptr %MEMORY, align 4
  %v7340 = load i32, ptr %EBP, align 4
  %v7341 = load i32, ptr %SSBASE, align 4
  %v7342 = add i32 %v7340, 12
  %v7343 = add i32 %v7342, %v7341
  %v7344 = load i32, ptr %EAX, align 4
  %v7345 = load ptr, ptr %MEMORY, align 4
  %v7346 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7345, ptr %state, i32 %v7343, i32 %v7344)
  store ptr %v7346, ptr %MEMORY, align 4
  %v7347 = load ptr, ptr %MEMORY, align 4
  %v7348 = call ptr @__remill_atomic_end(ptr %v7347)
  store ptr %v7348, ptr %MEMORY, align 4
  store i32 %v7337, ptr %PC, align 4
  %v7349 = add i32 %v7337, 3
  store i32 %v7349, ptr %NEXT_PC, align 4
  %v7350 = load ptr, ptr %MEMORY, align 4
  %v7351 = call ptr @__remill_atomic_begin(ptr %v7350)
  store ptr %v7351, ptr %MEMORY, align 4
  %v7352 = load i32, ptr %EBP, align 4
  %v7353 = load i32, ptr %SSBASE, align 4
  %v7354 = add i32 %v7352, 16
  %v7355 = add i32 %v7354, %v7353
  %v7356 = load ptr, ptr %MEMORY, align 4
  %v7357 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7356, ptr %state, ptr %EAX, i32 %v7355)
  store ptr %v7357, ptr %MEMORY, align 4
  %v7358 = load ptr, ptr %MEMORY, align 4
  %v7359 = call ptr @__remill_atomic_end(ptr %v7358)
  store ptr %v7359, ptr %MEMORY, align 4
  store i32 %v7349, ptr %PC, align 4
  %v7360 = add i32 %v7349, 3
  store i32 %v7360, ptr %NEXT_PC, align 4
  %v7361 = load ptr, ptr %MEMORY, align 4
  %v7362 = call ptr @__remill_atomic_begin(ptr %v7361)
  store ptr %v7362, ptr %MEMORY, align 4
  %v7363 = load i32, ptr %EAX, align 4
  %v7364 = load i32, ptr %DSBASE, align 4
  %v7365 = add i32 %v7363, 12
  %v7366 = add i32 %v7365, %v7364
  %v7367 = load ptr, ptr %MEMORY, align 4
  %v7368 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7367, ptr %state, ptr %EAX, i32 %v7366)
  store ptr %v7368, ptr %MEMORY, align 4
  %v7369 = load ptr, ptr %MEMORY, align 4
  %v7370 = call ptr @__remill_atomic_end(ptr %v7369)
  store ptr %v7370, ptr %MEMORY, align 4
  store i32 %v7360, ptr %PC, align 4
  %v7371 = add i32 %v7360, 5
  store i32 %v7371, ptr %NEXT_PC, align 4
  %v7372 = load ptr, ptr %MEMORY, align 4
  %v7373 = call ptr @__remill_atomic_begin(ptr %v7372)
  store ptr %v7373, ptr %MEMORY, align 4
  %v7374 = load ptr, ptr %MEMORY, align 4
  %v7375 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7374, ptr %state, ptr %EDX, i32 0)
  store ptr %v7375, ptr %MEMORY, align 4
  %v7376 = load ptr, ptr %MEMORY, align 4
  %v7377 = call ptr @__remill_atomic_end(ptr %v7376)
  store ptr %v7377, ptr %MEMORY, align 4
  store i32 %v7371, ptr %PC, align 4
  %v7378 = add i32 %v7371, 2
  store i32 %v7378, ptr %NEXT_PC, align 4
  %v7379 = load ptr, ptr %MEMORY, align 4
  %v7380 = call ptr @__remill_atomic_begin(ptr %v7379)
  store ptr %v7380, ptr %MEMORY, align 4
  %v7381 = load i32, ptr %EAX, align 4
  %v7382 = load i32, ptr %EAX, align 4
  %v7383 = load ptr, ptr %MEMORY, align 4
  %v7384 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v7383, ptr %state, i32 %v7381, i32 %v7382)
  store ptr %v7384, ptr %MEMORY, align 4
  %v7385 = load ptr, ptr %MEMORY, align 4
  %v7386 = call ptr @__remill_atomic_end(ptr %v7385)
  store ptr %v7386, ptr %MEMORY, align 4
  store i32 %v7378, ptr %PC, align 4
  %v7387 = add i32 %v7378, 3
  store i32 %v7387, ptr %NEXT_PC, align 4
  %v7388 = load ptr, ptr %MEMORY, align 4
  %v7389 = call ptr @__remill_atomic_begin(ptr %v7388)
  store ptr %v7389, ptr %MEMORY, align 4
  %v7390 = load i32, ptr %EDX, align 4
  %v7391 = load ptr, ptr %MEMORY, align 4
  %v7392 = call ptr @_ZN12_GLOBAL__N_15CMOVSI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7391, ptr %state, ptr %EAX, i32 %v7390)
  store ptr %v7392, ptr %MEMORY, align 4
  %v7393 = load ptr, ptr %MEMORY, align 4
  %v7394 = call ptr @__remill_atomic_end(ptr %v7393)
  store ptr %v7394, ptr %MEMORY, align 4
  store i32 %v7387, ptr %PC, align 4
  %v7395 = add i32 %v7387, 3
  store i32 %v7395, ptr %NEXT_PC, align 4
  %v7396 = load ptr, ptr %MEMORY, align 4
  %v7397 = call ptr @__remill_atomic_begin(ptr %v7396)
  store ptr %v7397, ptr %MEMORY, align 4
  %v7398 = load i32, ptr %EBP, align 4
  %v7399 = load i32, ptr %SSBASE, align 4
  %v7400 = add i32 %v7398, 12
  %v7401 = add i32 %v7400, %v7399
  %v7402 = load i32, ptr %EBP, align 4
  %v7403 = load i32, ptr %SSBASE, align 4
  %v7404 = add i32 %v7402, 12
  %v7405 = add i32 %v7404, %v7403
  %v7406 = load i32, ptr %EAX, align 4
  %v7407 = load ptr, ptr %MEMORY, align 4
  %v7408 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7407, ptr %state, i32 %v7401, i32 %v7405, i32 %v7406)
  store ptr %v7408, ptr %MEMORY, align 4
  %v7409 = load ptr, ptr %MEMORY, align 4
  %v7410 = call ptr @__remill_atomic_end(ptr %v7409)
  store ptr %v7410, ptr %MEMORY, align 4
  store i32 %v7395, ptr %PC, align 4
  %v7411 = add i32 %v7395, 3
  store i32 %v7411, ptr %NEXT_PC, align 4
  %v7412 = load ptr, ptr %MEMORY, align 4
  %v7413 = call ptr @__remill_atomic_begin(ptr %v7412)
  store ptr %v7413, ptr %MEMORY, align 4
  %v7414 = load i32, ptr %EBP, align 4
  %v7415 = load i32, ptr %SSBASE, align 4
  %v7416 = add i32 %v7414, 16
  %v7417 = add i32 %v7416, %v7415
  %v7418 = load ptr, ptr %MEMORY, align 4
  %v7419 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7418, ptr %state, ptr %EAX, i32 %v7417)
  store ptr %v7419, ptr %MEMORY, align 4
  %v7420 = load ptr, ptr %MEMORY, align 4
  %v7421 = call ptr @__remill_atomic_end(ptr %v7420)
  store ptr %v7421, ptr %MEMORY, align 4
  store i32 %v7411, ptr %PC, align 4
  %v7422 = add i32 %v7411, 3
  store i32 %v7422, ptr %NEXT_PC, align 4
  %v7423 = load ptr, ptr %MEMORY, align 4
  %v7424 = call ptr @__remill_atomic_begin(ptr %v7423)
  store ptr %v7424, ptr %MEMORY, align 4
  %v7425 = load i32, ptr %EAX, align 4
  %v7426 = load i32, ptr %DSBASE, align 4
  %v7427 = add i32 %v7425, 4
  %v7428 = add i32 %v7427, %v7426
  %v7429 = load ptr, ptr %MEMORY, align 4
  %v7430 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7429, ptr %state, ptr %EAX, i32 %v7428)
  store ptr %v7430, ptr %MEMORY, align 4
  %v7431 = load ptr, ptr %MEMORY, align 4
  %v7432 = call ptr @__remill_atomic_end(ptr %v7431)
  store ptr %v7432, ptr %MEMORY, align 4
  store i32 %v7422, ptr %PC, align 4
  %v7433 = add i32 %v7422, 5
  store i32 %v7433, ptr %NEXT_PC, align 4
  %v7434 = load ptr, ptr %MEMORY, align 4
  %v7435 = call ptr @__remill_atomic_begin(ptr %v7434)
  store ptr %v7435, ptr %MEMORY, align 4
  %v7436 = load i32, ptr %EAX, align 4
  %v7437 = load ptr, ptr %MEMORY, align 4
  %v7438 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7437, ptr %state, ptr %EAX, i32 %v7436, i32 4096)
  store ptr %v7438, ptr %MEMORY, align 4
  %v7439 = load ptr, ptr %MEMORY, align 4
  %v7440 = call ptr @__remill_atomic_end(ptr %v7439)
  store ptr %v7440, ptr %MEMORY, align 4
  store i32 %v7433, ptr %PC, align 4
  %v7441 = add i32 %v7433, 2
  store i32 %v7441, ptr %NEXT_PC, align 4
  %v7442 = load ptr, ptr %MEMORY, align 4
  %v7443 = call ptr @__remill_atomic_begin(ptr %v7442)
  store ptr %v7443, ptr %MEMORY, align 4
  %v7444 = load i32, ptr %EAX, align 4
  %v7445 = load i32, ptr %EAX, align 4
  %v7446 = load ptr, ptr %MEMORY, align 4
  %v7447 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v7446, ptr %state, i32 %v7444, i32 %v7445)
  store ptr %v7447, ptr %MEMORY, align 4
  %v7448 = load ptr, ptr %MEMORY, align 4
  %v7449 = call ptr @__remill_atomic_end(ptr %v7448)
  store ptr %v7449, ptr %MEMORY, align 4
  store i32 %v7441, ptr %PC, align 4
  %v7450 = add i32 %v7441, 2
  store i32 %v7450, ptr %NEXT_PC, align 4
  %v7451 = load ptr, ptr %MEMORY, align 4
  %v7452 = call ptr @__remill_atomic_begin(ptr %v7451)
  store ptr %v7452, ptr %MEMORY, align 4
  %v7453 = add i32 %v7450, 38
  %v7454 = load ptr, ptr %MEMORY, align 4
  %v7455 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v7454, ptr %state, ptr %BRANCH_TAKEN, i32 %v7453, i32 %v7450, ptr %NEXT_PC)
  store ptr %v7455, ptr %MEMORY, align 4
  %v7456 = load ptr, ptr %MEMORY, align 4
  %v7457 = call ptr @__remill_atomic_end(ptr %v7456)
  store ptr %v7457, ptr %MEMORY, align 4
  br i1 true, label %bb_4207156, label %bb_4207118

bb_4207118:                                       ; preds = %bb_4207048
  store i32 %v7450, ptr %PC, align 4
  %v7458 = add i32 %v7450, 3
  store i32 %v7458, ptr %NEXT_PC, align 4
  %v7459 = load ptr, ptr %MEMORY, align 4
  %v7460 = call ptr @__remill_atomic_begin(ptr %v7459)
  store ptr %v7460, ptr %MEMORY, align 4
  %v7461 = load i32, ptr %EBP, align 4
  %v7462 = load i32, ptr %SSBASE, align 4
  %v7463 = add i32 %v7461, 16
  %v7464 = add i32 %v7463, %v7462
  %v7465 = load ptr, ptr %MEMORY, align 4
  %v7466 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7465, ptr %state, ptr %EAX, i32 %v7464)
  store ptr %v7466, ptr %MEMORY, align 4
  %v7467 = load ptr, ptr %MEMORY, align 4
  %v7468 = call ptr @__remill_atomic_end(ptr %v7467)
  store ptr %v7468, ptr %MEMORY, align 4
  store i32 %v7458, ptr %PC, align 4
  %v7469 = add i32 %v7458, 4
  store i32 %v7469, ptr %NEXT_PC, align 4
  %v7470 = load ptr, ptr %MEMORY, align 4
  %v7471 = call ptr @__remill_atomic_begin(ptr %v7470)
  store ptr %v7471, ptr %MEMORY, align 4
  %v7472 = load i32, ptr %EAX, align 4
  %v7473 = load i32, ptr %DSBASE, align 4
  %v7474 = add i32 %v7472, 28
  %v7475 = add i32 %v7474, %v7473
  %v7476 = load ptr, ptr %MEMORY, align 4
  %v7477 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v7476, ptr %state, ptr %EAX, i32 %v7475)
  store ptr %v7477, ptr %MEMORY, align 4
  %v7478 = load ptr, ptr %MEMORY, align 4
  %v7479 = call ptr @__remill_atomic_end(ptr %v7478)
  store ptr %v7479, ptr %MEMORY, align 4
  store i32 %v7469, ptr %PC, align 4
  %v7480 = add i32 %v7469, 3
  store i32 %v7480, ptr %NEXT_PC, align 4
  %v7481 = load ptr, ptr %MEMORY, align 4
  %v7482 = call ptr @__remill_atomic_begin(ptr %v7481)
  store ptr %v7482, ptr %MEMORY, align 4
  %v7483 = load i16, ptr %AX, align 2
  %v7484 = zext i16 %v7483 to i32
  %v7485 = load i16, ptr %AX, align 2
  %v7486 = zext i16 %v7485 to i32
  %v7487 = load ptr, ptr %MEMORY, align 4
  %v7488 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnItLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v7487, ptr %state, i32 %v7484, i32 %v7486)
  store ptr %v7488, ptr %MEMORY, align 4
  %v7489 = load ptr, ptr %MEMORY, align 4
  %v7490 = call ptr @__remill_atomic_end(ptr %v7489)
  store ptr %v7490, ptr %MEMORY, align 4
  store i32 %v7480, ptr %PC, align 4
  %v7491 = add i32 %v7480, 2
  store i32 %v7491, ptr %NEXT_PC, align 4
  %v7492 = load ptr, ptr %MEMORY, align 4
  %v7493 = call ptr @__remill_atomic_begin(ptr %v7492)
  store ptr %v7493, ptr %MEMORY, align 4
  %v7494 = add i32 %v7491, 26
  %v7495 = load ptr, ptr %MEMORY, align 4
  %v7496 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v7495, ptr %state, ptr %BRANCH_TAKEN, i32 %v7494, i32 %v7491, ptr %NEXT_PC)
  store ptr %v7496, ptr %MEMORY, align 4
  %v7497 = load ptr, ptr %MEMORY, align 4
  %v7498 = call ptr @__remill_atomic_end(ptr %v7497)
  store ptr %v7498, ptr %MEMORY, align 4
  br i1 true, label %bb_4207156, label %bb_4207130

bb_4207130:                                       ; preds = %bb_4207118
  store i32 %v7491, ptr %PC, align 4
  %v7499 = add i32 %v7491, 3
  store i32 %v7499, ptr %NEXT_PC, align 4
  %v7500 = load ptr, ptr %MEMORY, align 4
  %v7501 = call ptr @__remill_atomic_begin(ptr %v7500)
  store ptr %v7501, ptr %MEMORY, align 4
  %v7502 = load i32, ptr %EBP, align 4
  %v7503 = load i32, ptr %SSBASE, align 4
  %v7504 = add i32 %v7502, 12
  %v7505 = add i32 %v7504, %v7503
  %v7506 = load ptr, ptr %MEMORY, align 4
  %v7507 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7506, ptr %state, ptr %ECX, i32 %v7505)
  store ptr %v7507, ptr %MEMORY, align 4
  %v7508 = load ptr, ptr %MEMORY, align 4
  %v7509 = call ptr @__remill_atomic_end(ptr %v7508)
  store ptr %v7509, ptr %MEMORY, align 4
  store i32 %v7499, ptr %PC, align 4
  %v7510 = add i32 %v7499, 5
  store i32 %v7510, ptr %NEXT_PC, align 4
  %v7511 = load ptr, ptr %MEMORY, align 4
  %v7512 = call ptr @__remill_atomic_begin(ptr %v7511)
  store ptr %v7512, ptr %MEMORY, align 4
  %v7513 = load ptr, ptr %MEMORY, align 4
  %v7514 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7513, ptr %state, ptr %EDX, i32 1431655766)
  store ptr %v7514, ptr %MEMORY, align 4
  %v7515 = load ptr, ptr %MEMORY, align 4
  %v7516 = call ptr @__remill_atomic_end(ptr %v7515)
  store ptr %v7516, ptr %MEMORY, align 4
  store i32 %v7510, ptr %PC, align 4
  %v7517 = add i32 %v7510, 2
  store i32 %v7517, ptr %NEXT_PC, align 4
  %v7518 = load ptr, ptr %MEMORY, align 4
  %v7519 = call ptr @__remill_atomic_begin(ptr %v7518)
  store ptr %v7519, ptr %MEMORY, align 4
  %v7520 = load i32, ptr %ECX, align 4
  %v7521 = load ptr, ptr %MEMORY, align 4
  %v7522 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7521, ptr %state, ptr %EAX, i32 %v7520)
  store ptr %v7522, ptr %MEMORY, align 4
  %v7523 = load ptr, ptr %MEMORY, align 4
  %v7524 = call ptr @__remill_atomic_end(ptr %v7523)
  store ptr %v7524, ptr %MEMORY, align 4
  store i32 %v7517, ptr %PC, align 4
  %v7525 = add i32 %v7517, 2
  store i32 %v7525, ptr %NEXT_PC, align 4
  %v7526 = load ptr, ptr %MEMORY, align 4
  %v7527 = call ptr @__remill_atomic_begin(ptr %v7526)
  store ptr %v7527, ptr %MEMORY, align 4
  %v7528 = load i32, ptr %EDX, align 4
  %v7529 = load ptr, ptr %MEMORY, align 4
  %v7530 = call ptr @_ZN12_GLOBAL__N_17IMULeaxI2RnIjLb1EEEEP6MemoryS4_R5StateT_(ptr %v7529, ptr %state, i32 %v7528)
  store ptr %v7530, ptr %MEMORY, align 4
  %v7531 = load ptr, ptr %MEMORY, align 4
  %v7532 = call ptr @__remill_atomic_end(ptr %v7531)
  store ptr %v7532, ptr %MEMORY, align 4
  store i32 %v7525, ptr %PC, align 4
  %v7533 = add i32 %v7525, 2
  store i32 %v7533, ptr %NEXT_PC, align 4
  %v7534 = load ptr, ptr %MEMORY, align 4
  %v7535 = call ptr @__remill_atomic_begin(ptr %v7534)
  store ptr %v7535, ptr %MEMORY, align 4
  %v7536 = load i32, ptr %ECX, align 4
  %v7537 = load ptr, ptr %MEMORY, align 4
  %v7538 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7537, ptr %state, ptr %EAX, i32 %v7536)
  store ptr %v7538, ptr %MEMORY, align 4
  %v7539 = load ptr, ptr %MEMORY, align 4
  %v7540 = call ptr @__remill_atomic_end(ptr %v7539)
  store ptr %v7540, ptr %MEMORY, align 4
  store i32 %v7533, ptr %PC, align 4
  %v7541 = add i32 %v7533, 3
  store i32 %v7541, ptr %NEXT_PC, align 4
  %v7542 = load ptr, ptr %MEMORY, align 4
  %v7543 = call ptr @__remill_atomic_begin(ptr %v7542)
  store ptr %v7543, ptr %MEMORY, align 4
  %v7544 = load i32, ptr %EAX, align 4
  %v7545 = load ptr, ptr %MEMORY, align 4
  %v7546 = call ptr @_ZN12_GLOBAL__N_13SARI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7545, ptr %state, ptr %EAX, i32 %v7544, i32 31)
  store ptr %v7546, ptr %MEMORY, align 4
  %v7547 = load ptr, ptr %MEMORY, align 4
  %v7548 = call ptr @__remill_atomic_end(ptr %v7547)
  store ptr %v7548, ptr %MEMORY, align 4
  store i32 %v7541, ptr %PC, align 4
  %v7549 = add i32 %v7541, 2
  store i32 %v7549, ptr %NEXT_PC, align 4
  %v7550 = load ptr, ptr %MEMORY, align 4
  %v7551 = call ptr @__remill_atomic_begin(ptr %v7550)
  store ptr %v7551, ptr %MEMORY, align 4
  %v7552 = load i32, ptr %EDX, align 4
  %v7553 = load ptr, ptr %MEMORY, align 4
  %v7554 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7553, ptr %state, ptr %ECX, i32 %v7552)
  store ptr %v7554, ptr %MEMORY, align 4
  %v7555 = load ptr, ptr %MEMORY, align 4
  %v7556 = call ptr @__remill_atomic_end(ptr %v7555)
  store ptr %v7556, ptr %MEMORY, align 4
  store i32 %v7549, ptr %PC, align 4
  %v7557 = add i32 %v7549, 2
  store i32 %v7557, ptr %NEXT_PC, align 4
  %v7558 = load ptr, ptr %MEMORY, align 4
  %v7559 = call ptr @__remill_atomic_begin(ptr %v7558)
  store ptr %v7559, ptr %MEMORY, align 4
  %v7560 = load i32, ptr %ECX, align 4
  %v7561 = load i32, ptr %EAX, align 4
  %v7562 = load ptr, ptr %MEMORY, align 4
  %v7563 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v7562, ptr %state, ptr %ECX, i32 %v7560, i32 %v7561)
  store ptr %v7563, ptr %MEMORY, align 4
  %v7564 = load ptr, ptr %MEMORY, align 4
  %v7565 = call ptr @__remill_atomic_end(ptr %v7564)
  store ptr %v7565, ptr %MEMORY, align 4
  store i32 %v7557, ptr %PC, align 4
  %v7566 = add i32 %v7557, 2
  store i32 %v7566, ptr %NEXT_PC, align 4
  %v7567 = load ptr, ptr %MEMORY, align 4
  %v7568 = call ptr @__remill_atomic_begin(ptr %v7567)
  store ptr %v7568, ptr %MEMORY, align 4
  %v7569 = load i32, ptr %ECX, align 4
  %v7570 = load ptr, ptr %MEMORY, align 4
  %v7571 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7570, ptr %state, ptr %EAX, i32 %v7569)
  store ptr %v7571, ptr %MEMORY, align 4
  %v7572 = load ptr, ptr %MEMORY, align 4
  %v7573 = call ptr @__remill_atomic_end(ptr %v7572)
  store ptr %v7573, ptr %MEMORY, align 4
  store i32 %v7566, ptr %PC, align 4
  %v7574 = add i32 %v7566, 3
  store i32 %v7574, ptr %NEXT_PC, align 4
  %v7575 = load ptr, ptr %MEMORY, align 4
  %v7576 = call ptr @__remill_atomic_begin(ptr %v7575)
  store ptr %v7576, ptr %MEMORY, align 4
  %v7577 = load i32, ptr %EBP, align 4
  %v7578 = load i32, ptr %SSBASE, align 4
  %v7579 = add i32 %v7577, 12
  %v7580 = add i32 %v7579, %v7578
  %v7581 = load i32, ptr %EBP, align 4
  %v7582 = load i32, ptr %SSBASE, align 4
  %v7583 = add i32 %v7581, 12
  %v7584 = add i32 %v7583, %v7582
  %v7585 = load i32, ptr %EAX, align 4
  %v7586 = load ptr, ptr %MEMORY, align 4
  %v7587 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7586, ptr %state, i32 %v7580, i32 %v7584, i32 %v7585)
  store ptr %v7587, ptr %MEMORY, align 4
  %v7588 = load ptr, ptr %MEMORY, align 4
  %v7589 = call ptr @__remill_atomic_end(ptr %v7588)
  store ptr %v7589, ptr %MEMORY, align 4
  br label %bb_4207156

bb_4207156:                                       ; preds = %bb_4207130, %bb_4207118, %bb_4207048
  %v7590 = load i32, ptr %NEXT_PC, align 4
  store i32 %v7590, ptr %PC, align 4
  %v7591 = add i32 %v7590, 3
  store i32 %v7591, ptr %NEXT_PC, align 4
  %v7592 = load ptr, ptr %MEMORY, align 4
  %v7593 = call ptr @__remill_atomic_begin(ptr %v7592)
  store ptr %v7593, ptr %MEMORY, align 4
  %v7594 = load i32, ptr %EBP, align 4
  %v7595 = load i32, ptr %SSBASE, align 4
  %v7596 = add i32 %v7594, 16
  %v7597 = add i32 %v7596, %v7595
  %v7598 = load ptr, ptr %MEMORY, align 4
  %v7599 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7598, ptr %state, ptr %EAX, i32 %v7597)
  store ptr %v7599, ptr %MEMORY, align 4
  %v7600 = load ptr, ptr %MEMORY, align 4
  %v7601 = call ptr @__remill_atomic_end(ptr %v7600)
  store ptr %v7601, ptr %MEMORY, align 4
  store i32 %v7591, ptr %PC, align 4
  %v7602 = add i32 %v7591, 3
  store i32 %v7602, ptr %NEXT_PC, align 4
  %v7603 = load ptr, ptr %MEMORY, align 4
  %v7604 = call ptr @__remill_atomic_begin(ptr %v7603)
  store ptr %v7604, ptr %MEMORY, align 4
  %v7605 = load i32, ptr %EAX, align 4
  %v7606 = load i32, ptr %DSBASE, align 4
  %v7607 = add i32 %v7605, 8
  %v7608 = add i32 %v7607, %v7606
  %v7609 = load ptr, ptr %MEMORY, align 4
  %v7610 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7609, ptr %state, ptr %EDX, i32 %v7608)
  store ptr %v7610, ptr %MEMORY, align 4
  %v7611 = load ptr, ptr %MEMORY, align 4
  %v7612 = call ptr @__remill_atomic_end(ptr %v7611)
  store ptr %v7612, ptr %MEMORY, align 4
  store i32 %v7602, ptr %PC, align 4
  %v7613 = add i32 %v7602, 3
  store i32 %v7613, ptr %NEXT_PC, align 4
  %v7614 = load ptr, ptr %MEMORY, align 4
  %v7615 = call ptr @__remill_atomic_begin(ptr %v7614)
  store ptr %v7615, ptr %MEMORY, align 4
  %v7616 = load i32, ptr %EBP, align 4
  %v7617 = load i32, ptr %SSBASE, align 4
  %v7618 = add i32 %v7616, 12
  %v7619 = add i32 %v7618, %v7617
  %v7620 = load ptr, ptr %MEMORY, align 4
  %v7621 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7620, ptr %state, ptr %EAX, i32 %v7619)
  store ptr %v7621, ptr %MEMORY, align 4
  %v7622 = load ptr, ptr %MEMORY, align 4
  %v7623 = call ptr @__remill_atomic_end(ptr %v7622)
  store ptr %v7623, ptr %MEMORY, align 4
  store i32 %v7613, ptr %PC, align 4
  %v7624 = add i32 %v7613, 2
  store i32 %v7624, ptr %NEXT_PC, align 4
  %v7625 = load ptr, ptr %MEMORY, align 4
  %v7626 = call ptr @__remill_atomic_begin(ptr %v7625)
  store ptr %v7626, ptr %MEMORY, align 4
  %v7627 = load i32, ptr %EDX, align 4
  %v7628 = load i32, ptr %EAX, align 4
  %v7629 = load ptr, ptr %MEMORY, align 4
  %v7630 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v7629, ptr %state, i32 %v7627, i32 %v7628)
  store ptr %v7630, ptr %MEMORY, align 4
  %v7631 = load ptr, ptr %MEMORY, align 4
  %v7632 = call ptr @__remill_atomic_end(ptr %v7631)
  store ptr %v7632, ptr %MEMORY, align 4
  store i32 %v7624, ptr %PC, align 4
  %v7633 = add i32 %v7624, 3
  store i32 %v7633, ptr %NEXT_PC, align 4
  %v7634 = load ptr, ptr %MEMORY, align 4
  %v7635 = call ptr @__remill_atomic_begin(ptr %v7634)
  store ptr %v7635, ptr %MEMORY, align 4
  %v7636 = load i32, ptr %EDX, align 4
  %v7637 = load ptr, ptr %MEMORY, align 4
  %v7638 = call ptr @_ZN12_GLOBAL__N_16CMOVNLI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7637, ptr %state, ptr %EAX, i32 %v7636)
  store ptr %v7638, ptr %MEMORY, align 4
  %v7639 = load ptr, ptr %MEMORY, align 4
  %v7640 = call ptr @__remill_atomic_end(ptr %v7639)
  store ptr %v7640, ptr %MEMORY, align 4
  store i32 %v7633, ptr %PC, align 4
  %v7641 = add i32 %v7633, 1
  store i32 %v7641, ptr %NEXT_PC, align 4
  %v7642 = load ptr, ptr %MEMORY, align 4
  %v7643 = call ptr @__remill_atomic_begin(ptr %v7642)
  store ptr %v7643, ptr %MEMORY, align 4
  %v7644 = load ptr, ptr %MEMORY, align 4
  %v7645 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v7644, ptr %state)
  store ptr %v7645, ptr %MEMORY, align 4
  %v7646 = load ptr, ptr %MEMORY, align 4
  %v7647 = call ptr @__remill_atomic_end(ptr %v7646)
  store ptr %v7647, ptr %MEMORY, align 4
  store i32 %v7641, ptr %PC, align 4
  %v7648 = add i32 %v7641, 1
  store i32 %v7648, ptr %NEXT_PC, align 4
  %v7649 = load ptr, ptr %MEMORY, align 4
  %v7650 = call ptr @__remill_atomic_begin(ptr %v7649)
  store ptr %v7650, ptr %MEMORY, align 4
  %v7651 = load ptr, ptr %MEMORY, align 4
  %v7652 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v7651, ptr %state, ptr %NEXT_PC)
  store ptr %v7652, ptr %MEMORY, align 4
  %v7653 = load ptr, ptr %MEMORY, align 4
  %v7654 = call ptr @__remill_atomic_end(ptr %v7653)
  store ptr %v7654, ptr %MEMORY, align 4
  ret ptr %memory

bb_4207172:                                       ; No predecessors!
  %v7655 = load i32, ptr %NEXT_PC, align 4
  store i32 %v7655, ptr %PC, align 4
  %v7656 = add i32 %v7655, 1
  store i32 %v7656, ptr %NEXT_PC, align 4
  %v7657 = load ptr, ptr %MEMORY, align 4
  %v7658 = call ptr @__remill_atomic_begin(ptr %v7657)
  store ptr %v7658, ptr %MEMORY, align 4
  %v7659 = load i32, ptr %EBP, align 4
  %v7660 = load ptr, ptr %MEMORY, align 4
  %v7661 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v7660, ptr %state, i32 %v7659)
  store ptr %v7661, ptr %MEMORY, align 4
  %v7662 = load ptr, ptr %MEMORY, align 4
  %v7663 = call ptr @__remill_atomic_end(ptr %v7662)
  store ptr %v7663, ptr %MEMORY, align 4
  store i32 %v7656, ptr %PC, align 4
  %v7664 = add i32 %v7656, 2
  store i32 %v7664, ptr %NEXT_PC, align 4
  %v7665 = load ptr, ptr %MEMORY, align 4
  %v7666 = call ptr @__remill_atomic_begin(ptr %v7665)
  store ptr %v7666, ptr %MEMORY, align 4
  %v7667 = load i32, ptr %ESP, align 4
  %v7668 = load ptr, ptr %MEMORY, align 4
  %v7669 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7668, ptr %state, ptr %EBP, i32 %v7667)
  store ptr %v7669, ptr %MEMORY, align 4
  %v7670 = load ptr, ptr %MEMORY, align 4
  %v7671 = call ptr @__remill_atomic_end(ptr %v7670)
  store ptr %v7671, ptr %MEMORY, align 4
  store i32 %v7664, ptr %PC, align 4
  %v7672 = add i32 %v7664, 1
  store i32 %v7672, ptr %NEXT_PC, align 4
  %v7673 = load ptr, ptr %MEMORY, align 4
  %v7674 = call ptr @__remill_atomic_begin(ptr %v7673)
  store ptr %v7674, ptr %MEMORY, align 4
  %v7675 = load i32, ptr %ESI, align 4
  %v7676 = load ptr, ptr %MEMORY, align 4
  %v7677 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v7676, ptr %state, i32 %v7675)
  store ptr %v7677, ptr %MEMORY, align 4
  %v7678 = load ptr, ptr %MEMORY, align 4
  %v7679 = call ptr @__remill_atomic_end(ptr %v7678)
  store ptr %v7679, ptr %MEMORY, align 4
  store i32 %v7672, ptr %PC, align 4
  %v7680 = add i32 %v7672, 1
  store i32 %v7680, ptr %NEXT_PC, align 4
  %v7681 = load ptr, ptr %MEMORY, align 4
  %v7682 = call ptr @__remill_atomic_begin(ptr %v7681)
  store ptr %v7682, ptr %MEMORY, align 4
  %v7683 = load i32, ptr %EBX, align 4
  %v7684 = load ptr, ptr %MEMORY, align 4
  %v7685 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v7684, ptr %state, i32 %v7683)
  store ptr %v7685, ptr %MEMORY, align 4
  %v7686 = load ptr, ptr %MEMORY, align 4
  %v7687 = call ptr @__remill_atomic_end(ptr %v7686)
  store ptr %v7687, ptr %MEMORY, align 4
  store i32 %v7680, ptr %PC, align 4
  %v7688 = add i32 %v7680, 3
  store i32 %v7688, ptr %NEXT_PC, align 4
  %v7689 = load ptr, ptr %MEMORY, align 4
  %v7690 = call ptr @__remill_atomic_begin(ptr %v7689)
  store ptr %v7690, ptr %MEMORY, align 4
  %v7691 = load i32, ptr %ESP, align 4
  %v7692 = load ptr, ptr %MEMORY, align 4
  %v7693 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7692, ptr %state, ptr %ESP, i32 %v7691, i32 48)
  store ptr %v7693, ptr %MEMORY, align 4
  %v7694 = load ptr, ptr %MEMORY, align 4
  %v7695 = call ptr @__remill_atomic_end(ptr %v7694)
  store ptr %v7695, ptr %MEMORY, align 4
  store i32 %v7688, ptr %PC, align 4
  %v7696 = add i32 %v7688, 3
  store i32 %v7696, ptr %NEXT_PC, align 4
  %v7697 = load ptr, ptr %MEMORY, align 4
  %v7698 = call ptr @__remill_atomic_begin(ptr %v7697)
  store ptr %v7698, ptr %MEMORY, align 4
  %v7699 = load i32, ptr %EBP, align 4
  %v7700 = load i32, ptr %SSBASE, align 4
  %v7701 = add i32 %v7699, 8
  %v7702 = add i32 %v7701, %v7700
  %v7703 = load ptr, ptr %MEMORY, align 4
  %v7704 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7703, ptr %state, ptr %EAX, i32 %v7702)
  store ptr %v7704, ptr %MEMORY, align 4
  %v7705 = load ptr, ptr %MEMORY, align 4
  %v7706 = call ptr @__remill_atomic_end(ptr %v7705)
  store ptr %v7706, ptr %MEMORY, align 4
  store i32 %v7696, ptr %PC, align 4
  %v7707 = add i32 %v7696, 3
  store i32 %v7707, ptr %NEXT_PC, align 4
  %v7708 = load ptr, ptr %MEMORY, align 4
  %v7709 = call ptr @__remill_atomic_begin(ptr %v7708)
  store ptr %v7709, ptr %MEMORY, align 4
  %v7710 = load i32, ptr %EBP, align 4
  %v7711 = load i32, ptr %SSBASE, align 4
  %v7712 = sub i32 %v7710, 32
  %v7713 = add i32 %v7712, %v7711
  %v7714 = load i32, ptr %EAX, align 4
  %v7715 = load ptr, ptr %MEMORY, align 4
  %v7716 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7715, ptr %state, i32 %v7713, i32 %v7714)
  store ptr %v7716, ptr %MEMORY, align 4
  %v7717 = load ptr, ptr %MEMORY, align 4
  %v7718 = call ptr @__remill_atomic_end(ptr %v7717)
  store ptr %v7718, ptr %MEMORY, align 4
  store i32 %v7707, ptr %PC, align 4
  %v7719 = add i32 %v7707, 3
  store i32 %v7719, ptr %NEXT_PC, align 4
  %v7720 = load ptr, ptr %MEMORY, align 4
  %v7721 = call ptr @__remill_atomic_begin(ptr %v7720)
  store ptr %v7721, ptr %MEMORY, align 4
  %v7722 = load i32, ptr %EBP, align 4
  %v7723 = load i32, ptr %SSBASE, align 4
  %v7724 = add i32 %v7722, 12
  %v7725 = add i32 %v7724, %v7723
  %v7726 = load ptr, ptr %MEMORY, align 4
  %v7727 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7726, ptr %state, ptr %EAX, i32 %v7725)
  store ptr %v7727, ptr %MEMORY, align 4
  %v7728 = load ptr, ptr %MEMORY, align 4
  %v7729 = call ptr @__remill_atomic_end(ptr %v7728)
  store ptr %v7729, ptr %MEMORY, align 4
  store i32 %v7719, ptr %PC, align 4
  %v7730 = add i32 %v7719, 3
  store i32 %v7730, ptr %NEXT_PC, align 4
  %v7731 = load ptr, ptr %MEMORY, align 4
  %v7732 = call ptr @__remill_atomic_begin(ptr %v7731)
  store ptr %v7732, ptr %MEMORY, align 4
  %v7733 = load i32, ptr %EBP, align 4
  %v7734 = load i32, ptr %SSBASE, align 4
  %v7735 = sub i32 %v7733, 28
  %v7736 = add i32 %v7735, %v7734
  %v7737 = load i32, ptr %EAX, align 4
  %v7738 = load ptr, ptr %MEMORY, align 4
  %v7739 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7738, ptr %state, i32 %v7736, i32 %v7737)
  store ptr %v7739, ptr %MEMORY, align 4
  %v7740 = load ptr, ptr %MEMORY, align 4
  %v7741 = call ptr @__remill_atomic_end(ptr %v7740)
  store ptr %v7741, ptr %MEMORY, align 4
  store i32 %v7730, ptr %PC, align 4
  %v7742 = add i32 %v7730, 2
  store i32 %v7742, ptr %NEXT_PC, align 4
  %v7743 = load ptr, ptr %MEMORY, align 4
  %v7744 = call ptr @__remill_atomic_begin(ptr %v7743)
  store ptr %v7744, ptr %MEMORY, align 4
  %v7745 = load i32, ptr %ESP, align 4
  %v7746 = load ptr, ptr %MEMORY, align 4
  %v7747 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7746, ptr %state, ptr %EAX, i32 %v7745)
  store ptr %v7747, ptr %MEMORY, align 4
  %v7748 = load ptr, ptr %MEMORY, align 4
  %v7749 = call ptr @__remill_atomic_end(ptr %v7748)
  store ptr %v7749, ptr %MEMORY, align 4
  store i32 %v7742, ptr %PC, align 4
  %v7750 = add i32 %v7742, 2
  store i32 %v7750, ptr %NEXT_PC, align 4
  %v7751 = load ptr, ptr %MEMORY, align 4
  %v7752 = call ptr @__remill_atomic_begin(ptr %v7751)
  store ptr %v7752, ptr %MEMORY, align 4
  %v7753 = load i32, ptr %EAX, align 4
  %v7754 = load ptr, ptr %MEMORY, align 4
  %v7755 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7754, ptr %state, ptr %EBX, i32 %v7753)
  store ptr %v7755, ptr %MEMORY, align 4
  %v7756 = load ptr, ptr %MEMORY, align 4
  %v7757 = call ptr @__remill_atomic_end(ptr %v7756)
  store ptr %v7757, ptr %MEMORY, align 4
  store i32 %v7750, ptr %PC, align 4
  %v7758 = add i32 %v7750, 3
  store i32 %v7758, ptr %NEXT_PC, align 4
  %v7759 = load ptr, ptr %MEMORY, align 4
  %v7760 = call ptr @__remill_atomic_begin(ptr %v7759)
  store ptr %v7760, ptr %MEMORY, align 4
  %v7761 = load i32, ptr %EBP, align 4
  %v7762 = load i32, ptr %SSBASE, align 4
  %v7763 = add i32 %v7761, 16
  %v7764 = add i32 %v7763, %v7762
  %v7765 = load ptr, ptr %MEMORY, align 4
  %v7766 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7765, ptr %state, ptr %EAX, i32 %v7764)
  store ptr %v7766, ptr %MEMORY, align 4
  %v7767 = load ptr, ptr %MEMORY, align 4
  %v7768 = call ptr @__remill_atomic_end(ptr %v7767)
  store ptr %v7768, ptr %MEMORY, align 4
  store i32 %v7758, ptr %PC, align 4
  %v7769 = add i32 %v7758, 4
  store i32 %v7769, ptr %NEXT_PC, align 4
  %v7770 = load ptr, ptr %MEMORY, align 4
  %v7771 = call ptr @__remill_atomic_begin(ptr %v7770)
  store ptr %v7771, ptr %MEMORY, align 4
  %v7772 = load i32, ptr %ESP, align 4
  %v7773 = load i32, ptr %SSBASE, align 4
  %v7774 = add i32 %v7772, 8
  %v7775 = add i32 %v7774, %v7773
  %v7776 = load i32, ptr %EAX, align 4
  %v7777 = load ptr, ptr %MEMORY, align 4
  %v7778 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7777, ptr %state, i32 %v7775, i32 %v7776)
  store ptr %v7778, ptr %MEMORY, align 4
  %v7779 = load ptr, ptr %MEMORY, align 4
  %v7780 = call ptr @__remill_atomic_end(ptr %v7779)
  store ptr %v7780, ptr %MEMORY, align 4
  store i32 %v7769, ptr %PC, align 4
  %v7781 = add i32 %v7769, 8
  store i32 %v7781, ptr %NEXT_PC, align 4
  %v7782 = load ptr, ptr %MEMORY, align 4
  %v7783 = call ptr @__remill_atomic_begin(ptr %v7782)
  store ptr %v7783, ptr %MEMORY, align 4
  %v7784 = load i32, ptr %ESP, align 4
  %v7785 = load i32, ptr %SSBASE, align 4
  %v7786 = add i32 %v7784, 4
  %v7787 = add i32 %v7786, %v7785
  %v7788 = load ptr, ptr %MEMORY, align 4
  %v7789 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7788, ptr %state, i32 %v7787, i32 3)
  store ptr %v7789, ptr %MEMORY, align 4
  %v7790 = load ptr, ptr %MEMORY, align 4
  %v7791 = call ptr @__remill_atomic_end(ptr %v7790)
  store ptr %v7791, ptr %MEMORY, align 4
  store i32 %v7781, ptr %PC, align 4
  %v7792 = add i32 %v7781, 7
  store i32 %v7792, ptr %NEXT_PC, align 4
  %v7793 = load ptr, ptr %MEMORY, align 4
  %v7794 = call ptr @__remill_atomic_begin(ptr %v7793)
  store ptr %v7794, ptr %MEMORY, align 4
  %v7795 = load i32, ptr %ESP, align 4
  %v7796 = load i32, ptr %SSBASE, align 4
  %v7797 = add i32 %v7795, %v7796
  %v7798 = load ptr, ptr %MEMORY, align 4
  %v7799 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7798, ptr %state, i32 %v7797, i32 1)
  store ptr %v7799, ptr %MEMORY, align 4
  %v7800 = load ptr, ptr %MEMORY, align 4
  %v7801 = call ptr @__remill_atomic_end(ptr %v7800)
  store ptr %v7801, ptr %MEMORY, align 4
  store i32 %v7792, ptr %PC, align 4
  %v7802 = add i32 %v7792, 5
  store i32 %v7802, ptr %NEXT_PC, align 4
  %v7803 = load ptr, ptr %MEMORY, align 4
  %v7804 = call ptr @__remill_atomic_begin(ptr %v7803)
  store ptr %v7804, ptr %MEMORY, align 4
  %v7805 = sub i32 %v7802, 175
  %v7806 = load ptr, ptr %MEMORY, align 4
  %v7807 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v7806, ptr %state, i64 4207048, ptr %NEXT_PC, i32 %v7802, ptr %RETURN_PC)
  store ptr %v7807, ptr %MEMORY, align 4
  %v7808 = load ptr, ptr %MEMORY, align 4
  %v7809 = call ptr @__remill_atomic_end(ptr %v7808)
  store ptr %v7809, ptr %MEMORY, align 4
  store i32 %v7802, ptr %PC, align 4
  %v7810 = add i32 %v7802, 3
  store i32 %v7810, ptr %NEXT_PC, align 4
  %v7811 = load ptr, ptr %MEMORY, align 4
  %v7812 = call ptr @__remill_atomic_begin(ptr %v7811)
  store ptr %v7812, ptr %MEMORY, align 4
  %v7813 = load i32, ptr %EAX, align 4
  %v7814 = sub i32 %v7813, 1
  %v7815 = load ptr, ptr %MEMORY, align 4
  %v7816 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v7815, ptr %state, ptr %EDX, i32 %v7814)
  store ptr %v7816, ptr %MEMORY, align 4
  %v7817 = load ptr, ptr %MEMORY, align 4
  %v7818 = call ptr @__remill_atomic_end(ptr %v7817)
  store ptr %v7818, ptr %MEMORY, align 4
  store i32 %v7810, ptr %PC, align 4
  %v7819 = add i32 %v7810, 3
  store i32 %v7819, ptr %NEXT_PC, align 4
  %v7820 = load ptr, ptr %MEMORY, align 4
  %v7821 = call ptr @__remill_atomic_begin(ptr %v7820)
  store ptr %v7821, ptr %MEMORY, align 4
  %v7822 = load i32, ptr %EBP, align 4
  %v7823 = load i32, ptr %SSBASE, align 4
  %v7824 = sub i32 %v7822, 20
  %v7825 = add i32 %v7824, %v7823
  %v7826 = load i32, ptr %EDX, align 4
  %v7827 = load ptr, ptr %MEMORY, align 4
  %v7828 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7827, ptr %state, i32 %v7825, i32 %v7826)
  store ptr %v7828, ptr %MEMORY, align 4
  %v7829 = load ptr, ptr %MEMORY, align 4
  %v7830 = call ptr @__remill_atomic_end(ptr %v7829)
  store ptr %v7830, ptr %MEMORY, align 4
  store i32 %v7819, ptr %PC, align 4
  %v7831 = add i32 %v7819, 5
  store i32 %v7831, ptr %NEXT_PC, align 4
  %v7832 = load ptr, ptr %MEMORY, align 4
  %v7833 = call ptr @__remill_atomic_begin(ptr %v7832)
  store ptr %v7833, ptr %MEMORY, align 4
  %v7834 = load ptr, ptr %MEMORY, align 4
  %v7835 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7834, ptr %state, ptr %EDX, i32 16)
  store ptr %v7835, ptr %MEMORY, align 4
  %v7836 = load ptr, ptr %MEMORY, align 4
  %v7837 = call ptr @__remill_atomic_end(ptr %v7836)
  store ptr %v7837, ptr %MEMORY, align 4
  store i32 %v7831, ptr %PC, align 4
  %v7838 = add i32 %v7831, 3
  store i32 %v7838, ptr %NEXT_PC, align 4
  %v7839 = load ptr, ptr %MEMORY, align 4
  %v7840 = call ptr @__remill_atomic_begin(ptr %v7839)
  store ptr %v7840, ptr %MEMORY, align 4
  %v7841 = load i32, ptr %EDX, align 4
  %v7842 = load ptr, ptr %MEMORY, align 4
  %v7843 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7842, ptr %state, ptr %EDX, i32 %v7841, i32 1)
  store ptr %v7843, ptr %MEMORY, align 4
  %v7844 = load ptr, ptr %MEMORY, align 4
  %v7845 = call ptr @__remill_atomic_end(ptr %v7844)
  store ptr %v7845, ptr %MEMORY, align 4
  store i32 %v7838, ptr %PC, align 4
  %v7846 = add i32 %v7838, 2
  store i32 %v7846, ptr %NEXT_PC, align 4
  %v7847 = load ptr, ptr %MEMORY, align 4
  %v7848 = call ptr @__remill_atomic_begin(ptr %v7847)
  store ptr %v7848, ptr %MEMORY, align 4
  %v7849 = load i32, ptr %EAX, align 4
  %v7850 = load i32, ptr %EDX, align 4
  %v7851 = load ptr, ptr %MEMORY, align 4
  %v7852 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v7851, ptr %state, ptr %EAX, i32 %v7849, i32 %v7850)
  store ptr %v7852, ptr %MEMORY, align 4
  %v7853 = load ptr, ptr %MEMORY, align 4
  %v7854 = call ptr @__remill_atomic_end(ptr %v7853)
  store ptr %v7854, ptr %MEMORY, align 4
  store i32 %v7846, ptr %PC, align 4
  %v7855 = add i32 %v7846, 7
  store i32 %v7855, ptr %NEXT_PC, align 4
  %v7856 = load ptr, ptr %MEMORY, align 4
  %v7857 = call ptr @__remill_atomic_begin(ptr %v7856)
  store ptr %v7857, ptr %MEMORY, align 4
  %v7858 = load i32, ptr %EBP, align 4
  %v7859 = load i32, ptr %SSBASE, align 4
  %v7860 = sub i32 %v7858, 36
  %v7861 = add i32 %v7860, %v7859
  %v7862 = load ptr, ptr %MEMORY, align 4
  %v7863 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7862, ptr %state, i32 %v7861, i32 16)
  store ptr %v7863, ptr %MEMORY, align 4
  %v7864 = load ptr, ptr %MEMORY, align 4
  %v7865 = call ptr @__remill_atomic_end(ptr %v7864)
  store ptr %v7865, ptr %MEMORY, align 4
  store i32 %v7855, ptr %PC, align 4
  %v7866 = add i32 %v7855, 5
  store i32 %v7866, ptr %NEXT_PC, align 4
  %v7867 = load ptr, ptr %MEMORY, align 4
  %v7868 = call ptr @__remill_atomic_begin(ptr %v7867)
  store ptr %v7868, ptr %MEMORY, align 4
  %v7869 = load ptr, ptr %MEMORY, align 4
  %v7870 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7869, ptr %state, ptr %EDX, i32 0)
  store ptr %v7870, ptr %MEMORY, align 4
  %v7871 = load ptr, ptr %MEMORY, align 4
  %v7872 = call ptr @__remill_atomic_end(ptr %v7871)
  store ptr %v7872, ptr %MEMORY, align 4
  store i32 %v7866, ptr %PC, align 4
  %v7873 = add i32 %v7866, 3
  store i32 %v7873, ptr %NEXT_PC, align 4
  %v7874 = load ptr, ptr %MEMORY, align 4
  %v7875 = call ptr @__remill_atomic_begin(ptr %v7874)
  store ptr %v7875, ptr %MEMORY, align 4
  %v7876 = load i32, ptr %EBP, align 4
  %v7877 = load i32, ptr %SSBASE, align 4
  %v7878 = sub i32 %v7876, 36
  %v7879 = add i32 %v7878, %v7877
  %v7880 = load ptr, ptr %MEMORY, align 4
  %v7881 = call ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr %v7880, ptr %state, i32 %v7879, i32 %v7873)
  store ptr %v7881, ptr %MEMORY, align 4
  %v7882 = load ptr, ptr %MEMORY, align 4
  %v7883 = call ptr @__remill_atomic_end(ptr %v7882)
  store ptr %v7883, ptr %MEMORY, align 4
  store i32 %v7873, ptr %PC, align 4
  %v7884 = add i32 %v7873, 3
  store i32 %v7884, ptr %NEXT_PC, align 4
  %v7885 = load ptr, ptr %MEMORY, align 4
  %v7886 = call ptr @__remill_atomic_begin(ptr %v7885)
  store ptr %v7886, ptr %MEMORY, align 4
  %v7887 = load i32, ptr %EAX, align 4
  %v7888 = load ptr, ptr %MEMORY, align 4
  %v7889 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7888, ptr %state, ptr %EAX, i32 %v7887, i32 16)
  store ptr %v7889, ptr %MEMORY, align 4
  %v7890 = load ptr, ptr %MEMORY, align 4
  %v7891 = call ptr @__remill_atomic_end(ptr %v7890)
  store ptr %v7891, ptr %MEMORY, align 4
  store i32 %v7884, ptr %PC, align 4
  %v7892 = add i32 %v7884, 5
  store i32 %v7892, ptr %NEXT_PC, align 4
  %v7893 = load ptr, ptr %MEMORY, align 4
  %v7894 = call ptr @__remill_atomic_begin(ptr %v7893)
  store ptr %v7894, ptr %MEMORY, align 4
  %v7895 = sub i32 %v7892, 1346
  %v7896 = load ptr, ptr %MEMORY, align 4
  %v7897 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v7896, ptr %state, i64 4205916, ptr %NEXT_PC, i32 %v7892, ptr %RETURN_PC)
  store ptr %v7897, ptr %MEMORY, align 4
  %v7898 = load ptr, ptr %MEMORY, align 4
  %v7899 = call ptr @__remill_atomic_end(ptr %v7898)
  store ptr %v7899, ptr %MEMORY, align 4
  store i32 %v7892, ptr %PC, align 4
  %v7900 = add i32 %v7892, 2
  store i32 %v7900, ptr %NEXT_PC, align 4
  %v7901 = load ptr, ptr %MEMORY, align 4
  %v7902 = call ptr @__remill_atomic_begin(ptr %v7901)
  store ptr %v7902, ptr %MEMORY, align 4
  %v7903 = load i32, ptr %ESP, align 4
  %v7904 = load i32, ptr %EAX, align 4
  %v7905 = load ptr, ptr %MEMORY, align 4
  %v7906 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v7905, ptr %state, ptr %ESP, i32 %v7903, i32 %v7904)
  store ptr %v7906, ptr %MEMORY, align 4
  %v7907 = load ptr, ptr %MEMORY, align 4
  %v7908 = call ptr @__remill_atomic_end(ptr %v7907)
  store ptr %v7908, ptr %MEMORY, align 4
  store i32 %v7900, ptr %PC, align 4
  %v7909 = add i32 %v7900, 4
  store i32 %v7909, ptr %NEXT_PC, align 4
  %v7910 = load ptr, ptr %MEMORY, align 4
  %v7911 = call ptr @__remill_atomic_begin(ptr %v7910)
  store ptr %v7911, ptr %MEMORY, align 4
  %v7912 = load i32, ptr %ESP, align 4
  %v7913 = add i32 %v7912, 16
  %v7914 = load ptr, ptr %MEMORY, align 4
  %v7915 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v7914, ptr %state, ptr %EAX, i32 %v7913)
  store ptr %v7915, ptr %MEMORY, align 4
  %v7916 = load ptr, ptr %MEMORY, align 4
  %v7917 = call ptr @__remill_atomic_end(ptr %v7916)
  store ptr %v7917, ptr %MEMORY, align 4
  store i32 %v7909, ptr %PC, align 4
  %v7918 = add i32 %v7909, 3
  store i32 %v7918, ptr %NEXT_PC, align 4
  %v7919 = load ptr, ptr %MEMORY, align 4
  %v7920 = call ptr @__remill_atomic_begin(ptr %v7919)
  store ptr %v7920, ptr %MEMORY, align 4
  %v7921 = load i32, ptr %EAX, align 4
  %v7922 = load ptr, ptr %MEMORY, align 4
  %v7923 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7922, ptr %state, ptr %EAX, i32 %v7921, i32 0)
  store ptr %v7923, ptr %MEMORY, align 4
  %v7924 = load ptr, ptr %MEMORY, align 4
  %v7925 = call ptr @__remill_atomic_end(ptr %v7924)
  store ptr %v7925, ptr %MEMORY, align 4
  store i32 %v7918, ptr %PC, align 4
  %v7926 = add i32 %v7918, 3
  store i32 %v7926, ptr %NEXT_PC, align 4
  %v7927 = load ptr, ptr %MEMORY, align 4
  %v7928 = call ptr @__remill_atomic_begin(ptr %v7927)
  store ptr %v7928, ptr %MEMORY, align 4
  %v7929 = load i32, ptr %EBP, align 4
  %v7930 = load i32, ptr %SSBASE, align 4
  %v7931 = sub i32 %v7929, 24
  %v7932 = add i32 %v7931, %v7930
  %v7933 = load i32, ptr %EAX, align 4
  %v7934 = load ptr, ptr %MEMORY, align 4
  %v7935 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7934, ptr %state, i32 %v7932, i32 %v7933)
  store ptr %v7935, ptr %MEMORY, align 4
  %v7936 = load ptr, ptr %MEMORY, align 4
  %v7937 = call ptr @__remill_atomic_end(ptr %v7936)
  store ptr %v7937, ptr %MEMORY, align 4
  store i32 %v7926, ptr %PC, align 4
  %v7938 = add i32 %v7926, 3
  store i32 %v7938, ptr %NEXT_PC, align 4
  %v7939 = load ptr, ptr %MEMORY, align 4
  %v7940 = call ptr @__remill_atomic_begin(ptr %v7939)
  store ptr %v7940, ptr %MEMORY, align 4
  %v7941 = load i32, ptr %EBP, align 4
  %v7942 = load i32, ptr %SSBASE, align 4
  %v7943 = sub i32 %v7941, 24
  %v7944 = add i32 %v7943, %v7942
  %v7945 = load ptr, ptr %MEMORY, align 4
  %v7946 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7945, ptr %state, ptr %EAX, i32 %v7944)
  store ptr %v7946, ptr %MEMORY, align 4
  %v7947 = load ptr, ptr %MEMORY, align 4
  %v7948 = call ptr @__remill_atomic_end(ptr %v7947)
  store ptr %v7948, ptr %MEMORY, align 4
  store i32 %v7938, ptr %PC, align 4
  %v7949 = add i32 %v7938, 3
  store i32 %v7949, ptr %NEXT_PC, align 4
  %v7950 = load ptr, ptr %MEMORY, align 4
  %v7951 = call ptr @__remill_atomic_begin(ptr %v7950)
  store ptr %v7951, ptr %MEMORY, align 4
  %v7952 = load i32, ptr %EBP, align 4
  %v7953 = load i32, ptr %SSBASE, align 4
  %v7954 = sub i32 %v7952, 12
  %v7955 = add i32 %v7954, %v7953
  %v7956 = load i32, ptr %EAX, align 4
  %v7957 = load ptr, ptr %MEMORY, align 4
  %v7958 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7957, ptr %state, i32 %v7955, i32 %v7956)
  store ptr %v7958, ptr %MEMORY, align 4
  %v7959 = load ptr, ptr %MEMORY, align 4
  %v7960 = call ptr @__remill_atomic_end(ptr %v7959)
  store ptr %v7960, ptr %MEMORY, align 4
  store i32 %v7949, ptr %PC, align 4
  %v7961 = add i32 %v7949, 3
  store i32 %v7961, ptr %NEXT_PC, align 4
  %v7962 = load ptr, ptr %MEMORY, align 4
  %v7963 = call ptr @__remill_atomic_begin(ptr %v7962)
  store ptr %v7963, ptr %MEMORY, align 4
  %v7964 = load i32, ptr %EBP, align 4
  %v7965 = load i32, ptr %SSBASE, align 4
  %v7966 = add i32 %v7964, 16
  %v7967 = add i32 %v7966, %v7965
  %v7968 = load ptr, ptr %MEMORY, align 4
  %v7969 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7968, ptr %state, ptr %EAX, i32 %v7967)
  store ptr %v7969, ptr %MEMORY, align 4
  %v7970 = load ptr, ptr %MEMORY, align 4
  %v7971 = call ptr @__remill_atomic_end(ptr %v7970)
  store ptr %v7971, ptr %MEMORY, align 4
  store i32 %v7961, ptr %PC, align 4
  %v7972 = add i32 %v7961, 3
  store i32 %v7972, ptr %NEXT_PC, align 4
  %v7973 = load ptr, ptr %MEMORY, align 4
  %v7974 = call ptr @__remill_atomic_begin(ptr %v7973)
  store ptr %v7974, ptr %MEMORY, align 4
  %v7975 = load i32, ptr %EAX, align 4
  %v7976 = load i32, ptr %DSBASE, align 4
  %v7977 = add i32 %v7975, 4
  %v7978 = add i32 %v7977, %v7976
  %v7979 = load ptr, ptr %MEMORY, align 4
  %v7980 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v7979, ptr %state, ptr %EAX, i32 %v7978)
  store ptr %v7980, ptr %MEMORY, align 4
  %v7981 = load ptr, ptr %MEMORY, align 4
  %v7982 = call ptr @__remill_atomic_end(ptr %v7981)
  store ptr %v7982, ptr %MEMORY, align 4
  store i32 %v7972, ptr %PC, align 4
  %v7983 = add i32 %v7972, 5
  store i32 %v7983, ptr %NEXT_PC, align 4
  %v7984 = load ptr, ptr %MEMORY, align 4
  %v7985 = call ptr @__remill_atomic_begin(ptr %v7984)
  store ptr %v7985, ptr %MEMORY, align 4
  %v7986 = load i32, ptr %EAX, align 4
  %v7987 = load ptr, ptr %MEMORY, align 4
  %v7988 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v7987, ptr %state, ptr %EAX, i32 %v7986, i32 128)
  store ptr %v7988, ptr %MEMORY, align 4
  %v7989 = load ptr, ptr %MEMORY, align 4
  %v7990 = call ptr @__remill_atomic_end(ptr %v7989)
  store ptr %v7990, ptr %MEMORY, align 4
  store i32 %v7983, ptr %PC, align 4
  %v7991 = add i32 %v7983, 2
  store i32 %v7991, ptr %NEXT_PC, align 4
  %v7992 = load ptr, ptr %MEMORY, align 4
  %v7993 = call ptr @__remill_atomic_begin(ptr %v7992)
  store ptr %v7993, ptr %MEMORY, align 4
  %v7994 = load i32, ptr %EAX, align 4
  %v7995 = load i32, ptr %EAX, align 4
  %v7996 = load ptr, ptr %MEMORY, align 4
  %v7997 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v7996, ptr %state, i32 %v7994, i32 %v7995)
  store ptr %v7997, ptr %MEMORY, align 4
  %v7998 = load ptr, ptr %MEMORY, align 4
  %v7999 = call ptr @__remill_atomic_end(ptr %v7998)
  store ptr %v7999, ptr %MEMORY, align 4
  store i32 %v7991, ptr %PC, align 4
  %v8000 = add i32 %v7991, 6
  store i32 %v8000, ptr %NEXT_PC, align 4
  %v8001 = load ptr, ptr %MEMORY, align 4
  %v8002 = call ptr @__remill_atomic_begin(ptr %v8001)
  store ptr %v8002, ptr %MEMORY, align 4
  %v8003 = add i32 %v8000, 223
  %v8004 = load ptr, ptr %MEMORY, align 4
  %v8005 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8004, ptr %state, ptr %BRANCH_TAKEN, i32 %v8003, i32 %v8000, ptr %NEXT_PC)
  store ptr %v8005, ptr %MEMORY, align 4
  %v8006 = load ptr, ptr %MEMORY, align 4
  %v8007 = call ptr @__remill_atomic_end(ptr %v8006)
  store ptr %v8007, ptr %MEMORY, align 4
  br i1 true, label %bb_4207522, label %bb_4207299

bb_4207299:                                       ; preds = %bb_4207172
  store i32 %v8000, ptr %PC, align 4
  %v8008 = add i32 %v8000, 3
  store i32 %v8008, ptr %NEXT_PC, align 4
  %v8009 = load ptr, ptr %MEMORY, align 4
  %v8010 = call ptr @__remill_atomic_begin(ptr %v8009)
  store ptr %v8010, ptr %MEMORY, align 4
  %v8011 = load i32, ptr %EBP, align 4
  %v8012 = load i32, ptr %SSBASE, align 4
  %v8013 = sub i32 %v8011, 32
  %v8014 = add i32 %v8013, %v8012
  %v8015 = load ptr, ptr %MEMORY, align 4
  %v8016 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8015, ptr %state, ptr %EAX, i32 %v8014)
  store ptr %v8016, ptr %MEMORY, align 4
  %v8017 = load ptr, ptr %MEMORY, align 4
  %v8018 = call ptr @__remill_atomic_end(ptr %v8017)
  store ptr %v8018, ptr %MEMORY, align 4
  store i32 %v8008, ptr %PC, align 4
  %v8019 = add i32 %v8008, 3
  store i32 %v8019, ptr %NEXT_PC, align 4
  %v8020 = load ptr, ptr %MEMORY, align 4
  %v8021 = call ptr @__remill_atomic_begin(ptr %v8020)
  store ptr %v8021, ptr %MEMORY, align 4
  %v8022 = load i32, ptr %EBP, align 4
  %v8023 = load i32, ptr %SSBASE, align 4
  %v8024 = sub i32 %v8022, 28
  %v8025 = add i32 %v8024, %v8023
  %v8026 = load ptr, ptr %MEMORY, align 4
  %v8027 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8026, ptr %state, ptr %EDX, i32 %v8025)
  store ptr %v8027, ptr %MEMORY, align 4
  %v8028 = load ptr, ptr %MEMORY, align 4
  %v8029 = call ptr @__remill_atomic_end(ptr %v8028)
  store ptr %v8029, ptr %MEMORY, align 4
  store i32 %v8019, ptr %PC, align 4
  %v8030 = add i32 %v8019, 2
  store i32 %v8030, ptr %NEXT_PC, align 4
  %v8031 = load ptr, ptr %MEMORY, align 4
  %v8032 = call ptr @__remill_atomic_begin(ptr %v8031)
  store ptr %v8032, ptr %MEMORY, align 4
  %v8033 = load i32, ptr %EDX, align 4
  %v8034 = load i32, ptr %EDX, align 4
  %v8035 = load ptr, ptr %MEMORY, align 4
  %v8036 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v8035, ptr %state, i32 %v8033, i32 %v8034)
  store ptr %v8036, ptr %MEMORY, align 4
  %v8037 = load ptr, ptr %MEMORY, align 4
  %v8038 = call ptr @__remill_atomic_end(ptr %v8037)
  store ptr %v8038, ptr %MEMORY, align 4
  store i32 %v8030, ptr %PC, align 4
  %v8039 = add i32 %v8030, 2
  store i32 %v8039, ptr %NEXT_PC, align 4
  %v8040 = load ptr, ptr %MEMORY, align 4
  %v8041 = call ptr @__remill_atomic_begin(ptr %v8040)
  store ptr %v8041, ptr %MEMORY, align 4
  %v8042 = add i32 %v8039, 24
  %v8043 = load ptr, ptr %MEMORY, align 4
  %v8044 = call ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8043, ptr %state, ptr %BRANCH_TAKEN, i32 %v8042, i32 %v8039, ptr %NEXT_PC)
  store ptr %v8044, ptr %MEMORY, align 4
  %v8045 = load ptr, ptr %MEMORY, align 4
  %v8046 = call ptr @__remill_atomic_end(ptr %v8045)
  store ptr %v8046, ptr %MEMORY, align 4
  br i1 true, label %bb_4207333, label %bb_4207309

bb_4207309:                                       ; preds = %bb_4207299
  store i32 %v8039, ptr %PC, align 4
  %v8047 = add i32 %v8039, 3
  store i32 %v8047, ptr %NEXT_PC, align 4
  %v8048 = load ptr, ptr %MEMORY, align 4
  %v8049 = call ptr @__remill_atomic_begin(ptr %v8048)
  store ptr %v8049, ptr %MEMORY, align 4
  %v8050 = load i32, ptr %EBP, align 4
  %v8051 = load i32, ptr %SSBASE, align 4
  %v8052 = sub i32 %v8050, 32
  %v8053 = add i32 %v8052, %v8051
  %v8054 = load ptr, ptr %MEMORY, align 4
  %v8055 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8054, ptr %state, ptr %EAX, i32 %v8053)
  store ptr %v8055, ptr %MEMORY, align 4
  %v8056 = load ptr, ptr %MEMORY, align 4
  %v8057 = call ptr @__remill_atomic_end(ptr %v8056)
  store ptr %v8057, ptr %MEMORY, align 4
  store i32 %v8047, ptr %PC, align 4
  %v8058 = add i32 %v8047, 3
  store i32 %v8058, ptr %NEXT_PC, align 4
  %v8059 = load ptr, ptr %MEMORY, align 4
  %v8060 = call ptr @__remill_atomic_begin(ptr %v8059)
  store ptr %v8060, ptr %MEMORY, align 4
  %v8061 = load i32, ptr %EBP, align 4
  %v8062 = load i32, ptr %SSBASE, align 4
  %v8063 = sub i32 %v8061, 28
  %v8064 = add i32 %v8063, %v8062
  %v8065 = load ptr, ptr %MEMORY, align 4
  %v8066 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8065, ptr %state, ptr %EDX, i32 %v8064)
  store ptr %v8066, ptr %MEMORY, align 4
  %v8067 = load ptr, ptr %MEMORY, align 4
  %v8068 = call ptr @__remill_atomic_end(ptr %v8067)
  store ptr %v8068, ptr %MEMORY, align 4
  store i32 %v8058, ptr %PC, align 4
  %v8069 = add i32 %v8058, 2
  store i32 %v8069, ptr %NEXT_PC, align 4
  %v8070 = load ptr, ptr %MEMORY, align 4
  %v8071 = call ptr @__remill_atomic_begin(ptr %v8070)
  store ptr %v8071, ptr %MEMORY, align 4
  %v8072 = load i32, ptr %EAX, align 4
  %v8073 = load ptr, ptr %MEMORY, align 4
  %v8074 = call ptr @_ZN12_GLOBAL__N_13NEGI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8073, ptr %state, ptr %EAX, i32 %v8072)
  store ptr %v8074, ptr %MEMORY, align 4
  %v8075 = load ptr, ptr %MEMORY, align 4
  %v8076 = call ptr @__remill_atomic_end(ptr %v8075)
  store ptr %v8076, ptr %MEMORY, align 4
  store i32 %v8069, ptr %PC, align 4
  %v8077 = add i32 %v8069, 3
  store i32 %v8077, ptr %NEXT_PC, align 4
  %v8078 = load ptr, ptr %MEMORY, align 4
  %v8079 = call ptr @__remill_atomic_begin(ptr %v8078)
  store ptr %v8079, ptr %MEMORY, align 4
  %v8080 = load i32, ptr %EDX, align 4
  %v8081 = load ptr, ptr %MEMORY, align 4
  %v8082 = call ptr @_ZN12_GLOBAL__N_13ADCI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8081, ptr %state, ptr %EDX, i32 %v8080, i32 0)
  store ptr %v8082, ptr %MEMORY, align 4
  %v8083 = load ptr, ptr %MEMORY, align 4
  %v8084 = call ptr @__remill_atomic_end(ptr %v8083)
  store ptr %v8084, ptr %MEMORY, align 4
  store i32 %v8077, ptr %PC, align 4
  %v8085 = add i32 %v8077, 2
  store i32 %v8085, ptr %NEXT_PC, align 4
  %v8086 = load ptr, ptr %MEMORY, align 4
  %v8087 = call ptr @__remill_atomic_begin(ptr %v8086)
  store ptr %v8087, ptr %MEMORY, align 4
  %v8088 = load i32, ptr %EDX, align 4
  %v8089 = load ptr, ptr %MEMORY, align 4
  %v8090 = call ptr @_ZN12_GLOBAL__N_13NEGI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8089, ptr %state, ptr %EDX, i32 %v8088)
  store ptr %v8090, ptr %MEMORY, align 4
  %v8091 = load ptr, ptr %MEMORY, align 4
  %v8092 = call ptr @__remill_atomic_end(ptr %v8091)
  store ptr %v8092, ptr %MEMORY, align 4
  store i32 %v8085, ptr %PC, align 4
  %v8093 = add i32 %v8085, 3
  store i32 %v8093, ptr %NEXT_PC, align 4
  %v8094 = load ptr, ptr %MEMORY, align 4
  %v8095 = call ptr @__remill_atomic_begin(ptr %v8094)
  store ptr %v8095, ptr %MEMORY, align 4
  %v8096 = load i32, ptr %EBP, align 4
  %v8097 = load i32, ptr %SSBASE, align 4
  %v8098 = sub i32 %v8096, 32
  %v8099 = add i32 %v8098, %v8097
  %v8100 = load i32, ptr %EAX, align 4
  %v8101 = load ptr, ptr %MEMORY, align 4
  %v8102 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8101, ptr %state, i32 %v8099, i32 %v8100)
  store ptr %v8102, ptr %MEMORY, align 4
  %v8103 = load ptr, ptr %MEMORY, align 4
  %v8104 = call ptr @__remill_atomic_end(ptr %v8103)
  store ptr %v8104, ptr %MEMORY, align 4
  store i32 %v8093, ptr %PC, align 4
  %v8105 = add i32 %v8093, 3
  store i32 %v8105, ptr %NEXT_PC, align 4
  %v8106 = load ptr, ptr %MEMORY, align 4
  %v8107 = call ptr @__remill_atomic_begin(ptr %v8106)
  store ptr %v8107, ptr %MEMORY, align 4
  %v8108 = load i32, ptr %EBP, align 4
  %v8109 = load i32, ptr %SSBASE, align 4
  %v8110 = sub i32 %v8108, 28
  %v8111 = add i32 %v8110, %v8109
  %v8112 = load i32, ptr %EDX, align 4
  %v8113 = load ptr, ptr %MEMORY, align 4
  %v8114 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8113, ptr %state, i32 %v8111, i32 %v8112)
  store ptr %v8114, ptr %MEMORY, align 4
  %v8115 = load ptr, ptr %MEMORY, align 4
  %v8116 = call ptr @__remill_atomic_end(ptr %v8115)
  store ptr %v8116, ptr %MEMORY, align 4
  store i32 %v8105, ptr %PC, align 4
  %v8117 = add i32 %v8105, 5
  store i32 %v8117, ptr %NEXT_PC, align 4
  %v8118 = load ptr, ptr %MEMORY, align 4
  %v8119 = call ptr @__remill_atomic_begin(ptr %v8118)
  store ptr %v8119, ptr %MEMORY, align 4
  %v8120 = add i32 %v8117, 189
  %v8121 = load ptr, ptr %MEMORY, align 4
  %v8122 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v8121, ptr %state, i32 %v8120, ptr %NEXT_PC)
  store ptr %v8122, ptr %MEMORY, align 4
  %v8123 = load ptr, ptr %MEMORY, align 4
  %v8124 = call ptr @__remill_atomic_end(ptr %v8123)
  store ptr %v8124, ptr %MEMORY, align 4
  br label %bb_4207522

bb_4207333:                                       ; preds = %bb_4207299
  store i32 %v8039, ptr %PC, align 4
  %v8125 = add i32 %v8039, 3
  store i32 %v8125, ptr %NEXT_PC, align 4
  %v8126 = load ptr, ptr %MEMORY, align 4
  %v8127 = call ptr @__remill_atomic_begin(ptr %v8126)
  store ptr %v8127, ptr %MEMORY, align 4
  %v8128 = load i32, ptr %EBP, align 4
  %v8129 = load i32, ptr %SSBASE, align 4
  %v8130 = add i32 %v8128, 16
  %v8131 = add i32 %v8130, %v8129
  %v8132 = load ptr, ptr %MEMORY, align 4
  %v8133 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8132, ptr %state, ptr %EAX, i32 %v8131)
  store ptr %v8133, ptr %MEMORY, align 4
  %v8134 = load ptr, ptr %MEMORY, align 4
  %v8135 = call ptr @__remill_atomic_end(ptr %v8134)
  store ptr %v8135, ptr %MEMORY, align 4
  store i32 %v8125, ptr %PC, align 4
  %v8136 = add i32 %v8125, 3
  store i32 %v8136, ptr %NEXT_PC, align 4
  %v8137 = load ptr, ptr %MEMORY, align 4
  %v8138 = call ptr @__remill_atomic_begin(ptr %v8137)
  store ptr %v8138, ptr %MEMORY, align 4
  %v8139 = load i32, ptr %EAX, align 4
  %v8140 = load i32, ptr %DSBASE, align 4
  %v8141 = add i32 %v8139, 4
  %v8142 = add i32 %v8141, %v8140
  %v8143 = load ptr, ptr %MEMORY, align 4
  %v8144 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8143, ptr %state, ptr %EAX, i32 %v8142)
  store ptr %v8144, ptr %MEMORY, align 4
  %v8145 = load ptr, ptr %MEMORY, align 4
  %v8146 = call ptr @__remill_atomic_end(ptr %v8145)
  store ptr %v8146, ptr %MEMORY, align 4
  store i32 %v8136, ptr %PC, align 4
  %v8147 = add i32 %v8136, 2
  store i32 %v8147, ptr %NEXT_PC, align 4
  %v8148 = load ptr, ptr %MEMORY, align 4
  %v8149 = call ptr @__remill_atomic_begin(ptr %v8148)
  store ptr %v8149, ptr %MEMORY, align 4
  %v8150 = load i32, ptr %EAX, align 4
  %v8151 = load ptr, ptr %MEMORY, align 4
  %v8152 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8151, ptr %state, ptr %EDX, i32 %v8150)
  store ptr %v8152, ptr %MEMORY, align 4
  %v8153 = load ptr, ptr %MEMORY, align 4
  %v8154 = call ptr @__remill_atomic_end(ptr %v8153)
  store ptr %v8154, ptr %MEMORY, align 4
  store i32 %v8147, ptr %PC, align 4
  %v8155 = add i32 %v8147, 3
  store i32 %v8155, ptr %NEXT_PC, align 4
  %v8156 = load ptr, ptr %MEMORY, align 4
  %v8157 = call ptr @__remill_atomic_begin(ptr %v8156)
  store ptr %v8157, ptr %MEMORY, align 4
  %v8158 = load i8, ptr %DL, align 1
  %v8159 = zext i8 %v8158 to i32
  %v8160 = load ptr, ptr %MEMORY, align 4
  %v8161 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8160, ptr %state, ptr %DL, i32 %v8159, i32 127)
  store ptr %v8161, ptr %MEMORY, align 4
  %v8162 = load ptr, ptr %MEMORY, align 4
  %v8163 = call ptr @__remill_atomic_end(ptr %v8162)
  store ptr %v8163, ptr %MEMORY, align 4
  store i32 %v8155, ptr %PC, align 4
  %v8164 = add i32 %v8155, 3
  store i32 %v8164, ptr %NEXT_PC, align 4
  %v8165 = load ptr, ptr %MEMORY, align 4
  %v8166 = call ptr @__remill_atomic_begin(ptr %v8165)
  store ptr %v8166, ptr %MEMORY, align 4
  %v8167 = load i32, ptr %EBP, align 4
  %v8168 = load i32, ptr %SSBASE, align 4
  %v8169 = add i32 %v8167, 16
  %v8170 = add i32 %v8169, %v8168
  %v8171 = load ptr, ptr %MEMORY, align 4
  %v8172 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8171, ptr %state, ptr %EAX, i32 %v8170)
  store ptr %v8172, ptr %MEMORY, align 4
  %v8173 = load ptr, ptr %MEMORY, align 4
  %v8174 = call ptr @__remill_atomic_end(ptr %v8173)
  store ptr %v8174, ptr %MEMORY, align 4
  store i32 %v8164, ptr %PC, align 4
  %v8175 = add i32 %v8164, 3
  store i32 %v8175, ptr %NEXT_PC, align 4
  %v8176 = load ptr, ptr %MEMORY, align 4
  %v8177 = call ptr @__remill_atomic_begin(ptr %v8176)
  store ptr %v8177, ptr %MEMORY, align 4
  %v8178 = load i32, ptr %EAX, align 4
  %v8179 = load i32, ptr %DSBASE, align 4
  %v8180 = add i32 %v8178, 4
  %v8181 = add i32 %v8180, %v8179
  %v8182 = load i32, ptr %EDX, align 4
  %v8183 = load ptr, ptr %MEMORY, align 4
  %v8184 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8183, ptr %state, i32 %v8181, i32 %v8182)
  store ptr %v8184, ptr %MEMORY, align 4
  %v8185 = load ptr, ptr %MEMORY, align 4
  %v8186 = call ptr @__remill_atomic_end(ptr %v8185)
  store ptr %v8186, ptr %MEMORY, align 4
  store i32 %v8175, ptr %PC, align 4
  %v8187 = add i32 %v8175, 5
  store i32 %v8187, ptr %NEXT_PC, align 4
  %v8188 = load ptr, ptr %MEMORY, align 4
  %v8189 = call ptr @__remill_atomic_begin(ptr %v8188)
  store ptr %v8189, ptr %MEMORY, align 4
  %v8190 = add i32 %v8187, 167
  %v8191 = load ptr, ptr %MEMORY, align 4
  %v8192 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v8191, ptr %state, i32 %v8190, ptr %NEXT_PC)
  store ptr %v8192, ptr %MEMORY, align 4
  %v8193 = load ptr, ptr %MEMORY, align 4
  %v8194 = call ptr @__remill_atomic_end(ptr %v8193)
  store ptr %v8194, ptr %MEMORY, align 4
  br label %bb_4207522

bb_4207355:                                       ; preds = %bb_4207523
  store i32 %v8749, ptr %PC, align 4
  %v8195 = add i32 %v8749, 3
  store i32 %v8195, ptr %NEXT_PC, align 4
  %v8196 = load ptr, ptr %MEMORY, align 4
  %v8197 = call ptr @__remill_atomic_begin(ptr %v8196)
  store ptr %v8197, ptr %MEMORY, align 4
  %v8198 = load i32, ptr %EBP, align 4
  %v8199 = load i32, ptr %SSBASE, align 4
  %v8200 = sub i32 %v8198, 24
  %v8201 = add i32 %v8200, %v8199
  %v8202 = load ptr, ptr %MEMORY, align 4
  %v8203 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8202, ptr %state, ptr %EAX, i32 %v8201)
  store ptr %v8203, ptr %MEMORY, align 4
  %v8204 = load ptr, ptr %MEMORY, align 4
  %v8205 = call ptr @__remill_atomic_end(ptr %v8204)
  store ptr %v8205, ptr %MEMORY, align 4
  store i32 %v8195, ptr %PC, align 4
  %v8206 = add i32 %v8195, 3
  store i32 %v8206, ptr %NEXT_PC, align 4
  %v8207 = load ptr, ptr %MEMORY, align 4
  %v8208 = call ptr @__remill_atomic_begin(ptr %v8207)
  store ptr %v8208, ptr %MEMORY, align 4
  %v8209 = load i32, ptr %EAX, align 4
  %v8210 = load i32, ptr %EBP, align 4
  %v8211 = load i32, ptr %SSBASE, align 4
  %v8212 = sub i32 %v8210, 12
  %v8213 = add i32 %v8212, %v8211
  %v8214 = load ptr, ptr %MEMORY, align 4
  %v8215 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8214, ptr %state, i32 %v8209, i32 %v8213)
  store ptr %v8215, ptr %MEMORY, align 4
  %v8216 = load ptr, ptr %MEMORY, align 4
  %v8217 = call ptr @__remill_atomic_end(ptr %v8216)
  store ptr %v8217, ptr %MEMORY, align 4
  store i32 %v8206, ptr %PC, align 4
  %v8218 = add i32 %v8206, 2
  store i32 %v8218, ptr %NEXT_PC, align 4
  %v8219 = load ptr, ptr %MEMORY, align 4
  %v8220 = call ptr @__remill_atomic_begin(ptr %v8219)
  store ptr %v8220, ptr %MEMORY, align 4
  %v8221 = add i32 %v8218, 69
  %v8222 = load ptr, ptr %MEMORY, align 4
  %v8223 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8222, ptr %state, ptr %BRANCH_TAKEN, i32 %v8221, i32 %v8218, ptr %NEXT_PC)
  store ptr %v8223, ptr %MEMORY, align 4
  %v8224 = load ptr, ptr %MEMORY, align 4
  %v8225 = call ptr @__remill_atomic_end(ptr %v8224)
  store ptr %v8225, ptr %MEMORY, align 4
  br i1 true, label %bb_4207432, label %bb_4207363

bb_4207363:                                       ; preds = %bb_4207355
  store i32 %v8218, ptr %PC, align 4
  %v8226 = add i32 %v8218, 3
  store i32 %v8226, ptr %NEXT_PC, align 4
  %v8227 = load ptr, ptr %MEMORY, align 4
  %v8228 = call ptr @__remill_atomic_begin(ptr %v8227)
  store ptr %v8228, ptr %MEMORY, align 4
  %v8229 = load i32, ptr %EBP, align 4
  %v8230 = load i32, ptr %SSBASE, align 4
  %v8231 = add i32 %v8229, 16
  %v8232 = add i32 %v8231, %v8230
  %v8233 = load ptr, ptr %MEMORY, align 4
  %v8234 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8233, ptr %state, ptr %EAX, i32 %v8232)
  store ptr %v8234, ptr %MEMORY, align 4
  %v8235 = load ptr, ptr %MEMORY, align 4
  %v8236 = call ptr @__remill_atomic_end(ptr %v8235)
  store ptr %v8236, ptr %MEMORY, align 4
  store i32 %v8226, ptr %PC, align 4
  %v8237 = add i32 %v8226, 3
  store i32 %v8237, ptr %NEXT_PC, align 4
  %v8238 = load ptr, ptr %MEMORY, align 4
  %v8239 = call ptr @__remill_atomic_begin(ptr %v8238)
  store ptr %v8239, ptr %MEMORY, align 4
  %v8240 = load i32, ptr %EAX, align 4
  %v8241 = load i32, ptr %DSBASE, align 4
  %v8242 = add i32 %v8240, 4
  %v8243 = add i32 %v8242, %v8241
  %v8244 = load ptr, ptr %MEMORY, align 4
  %v8245 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8244, ptr %state, ptr %EAX, i32 %v8243)
  store ptr %v8245, ptr %MEMORY, align 4
  %v8246 = load ptr, ptr %MEMORY, align 4
  %v8247 = call ptr @__remill_atomic_end(ptr %v8246)
  store ptr %v8247, ptr %MEMORY, align 4
  store i32 %v8237, ptr %PC, align 4
  %v8248 = add i32 %v8237, 5
  store i32 %v8248, ptr %NEXT_PC, align 4
  %v8249 = load ptr, ptr %MEMORY, align 4
  %v8250 = call ptr @__remill_atomic_begin(ptr %v8249)
  store ptr %v8250, ptr %MEMORY, align 4
  %v8251 = load i32, ptr %EAX, align 4
  %v8252 = load ptr, ptr %MEMORY, align 4
  %v8253 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8252, ptr %state, ptr %EAX, i32 %v8251, i32 4096)
  store ptr %v8253, ptr %MEMORY, align 4
  %v8254 = load ptr, ptr %MEMORY, align 4
  %v8255 = call ptr @__remill_atomic_end(ptr %v8254)
  store ptr %v8255, ptr %MEMORY, align 4
  store i32 %v8248, ptr %PC, align 4
  %v8256 = add i32 %v8248, 2
  store i32 %v8256, ptr %NEXT_PC, align 4
  %v8257 = load ptr, ptr %MEMORY, align 4
  %v8258 = call ptr @__remill_atomic_begin(ptr %v8257)
  store ptr %v8258, ptr %MEMORY, align 4
  %v8259 = load i32, ptr %EAX, align 4
  %v8260 = load i32, ptr %EAX, align 4
  %v8261 = load ptr, ptr %MEMORY, align 4
  %v8262 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v8261, ptr %state, i32 %v8259, i32 %v8260)
  store ptr %v8262, ptr %MEMORY, align 4
  %v8263 = load ptr, ptr %MEMORY, align 4
  %v8264 = call ptr @__remill_atomic_end(ptr %v8263)
  store ptr %v8264, ptr %MEMORY, align 4
  store i32 %v8256, ptr %PC, align 4
  %v8265 = add i32 %v8256, 2
  store i32 %v8265, ptr %NEXT_PC, align 4
  %v8266 = load ptr, ptr %MEMORY, align 4
  %v8267 = call ptr @__remill_atomic_begin(ptr %v8266)
  store ptr %v8267, ptr %MEMORY, align 4
  %v8268 = add i32 %v8265, 54
  %v8269 = load ptr, ptr %MEMORY, align 4
  %v8270 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8269, ptr %state, ptr %BRANCH_TAKEN, i32 %v8268, i32 %v8265, ptr %NEXT_PC)
  store ptr %v8270, ptr %MEMORY, align 4
  %v8271 = load ptr, ptr %MEMORY, align 4
  %v8272 = call ptr @__remill_atomic_end(ptr %v8271)
  store ptr %v8272, ptr %MEMORY, align 4
  br i1 true, label %bb_4207432, label %bb_4207378

bb_4207378:                                       ; preds = %bb_4207363
  store i32 %v8265, ptr %PC, align 4
  %v8273 = add i32 %v8265, 3
  store i32 %v8273, ptr %NEXT_PC, align 4
  %v8274 = load ptr, ptr %MEMORY, align 4
  %v8275 = call ptr @__remill_atomic_begin(ptr %v8274)
  store ptr %v8275, ptr %MEMORY, align 4
  %v8276 = load i32, ptr %EBP, align 4
  %v8277 = load i32, ptr %SSBASE, align 4
  %v8278 = add i32 %v8276, 16
  %v8279 = add i32 %v8278, %v8277
  %v8280 = load ptr, ptr %MEMORY, align 4
  %v8281 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8280, ptr %state, ptr %EAX, i32 %v8279)
  store ptr %v8281, ptr %MEMORY, align 4
  %v8282 = load ptr, ptr %MEMORY, align 4
  %v8283 = call ptr @__remill_atomic_end(ptr %v8282)
  store ptr %v8283, ptr %MEMORY, align 4
  store i32 %v8273, ptr %PC, align 4
  %v8284 = add i32 %v8273, 4
  store i32 %v8284, ptr %NEXT_PC, align 4
  %v8285 = load ptr, ptr %MEMORY, align 4
  %v8286 = call ptr @__remill_atomic_begin(ptr %v8285)
  store ptr %v8286, ptr %MEMORY, align 4
  %v8287 = load i32, ptr %EAX, align 4
  %v8288 = load i32, ptr %DSBASE, align 4
  %v8289 = add i32 %v8287, 28
  %v8290 = add i32 %v8289, %v8288
  %v8291 = load ptr, ptr %MEMORY, align 4
  %v8292 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v8291, ptr %state, ptr %EAX, i32 %v8290)
  store ptr %v8292, ptr %MEMORY, align 4
  %v8293 = load ptr, ptr %MEMORY, align 4
  %v8294 = call ptr @__remill_atomic_end(ptr %v8293)
  store ptr %v8294, ptr %MEMORY, align 4
  store i32 %v8284, ptr %PC, align 4
  %v8295 = add i32 %v8284, 3
  store i32 %v8295, ptr %NEXT_PC, align 4
  %v8296 = load ptr, ptr %MEMORY, align 4
  %v8297 = call ptr @__remill_atomic_begin(ptr %v8296)
  store ptr %v8297, ptr %MEMORY, align 4
  %v8298 = load i16, ptr %AX, align 2
  %v8299 = zext i16 %v8298 to i32
  %v8300 = load i16, ptr %AX, align 2
  %v8301 = zext i16 %v8300 to i32
  %v8302 = load ptr, ptr %MEMORY, align 4
  %v8303 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnItLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v8302, ptr %state, i32 %v8299, i32 %v8301)
  store ptr %v8303, ptr %MEMORY, align 4
  %v8304 = load ptr, ptr %MEMORY, align 4
  %v8305 = call ptr @__remill_atomic_end(ptr %v8304)
  store ptr %v8305, ptr %MEMORY, align 4
  store i32 %v8295, ptr %PC, align 4
  %v8306 = add i32 %v8295, 2
  store i32 %v8306, ptr %NEXT_PC, align 4
  %v8307 = load ptr, ptr %MEMORY, align 4
  %v8308 = call ptr @__remill_atomic_begin(ptr %v8307)
  store ptr %v8308, ptr %MEMORY, align 4
  %v8309 = add i32 %v8306, 42
  %v8310 = load ptr, ptr %MEMORY, align 4
  %v8311 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8310, ptr %state, ptr %BRANCH_TAKEN, i32 %v8309, i32 %v8306, ptr %NEXT_PC)
  store ptr %v8311, ptr %MEMORY, align 4
  %v8312 = load ptr, ptr %MEMORY, align 4
  %v8313 = call ptr @__remill_atomic_end(ptr %v8312)
  store ptr %v8313, ptr %MEMORY, align 4
  br i1 true, label %bb_4207432, label %bb_4207390

bb_4207390:                                       ; preds = %bb_4207378
  store i32 %v8306, ptr %PC, align 4
  %v8314 = add i32 %v8306, 3
  store i32 %v8314, ptr %NEXT_PC, align 4
  %v8315 = load ptr, ptr %MEMORY, align 4
  %v8316 = call ptr @__remill_atomic_begin(ptr %v8315)
  store ptr %v8316, ptr %MEMORY, align 4
  %v8317 = load i32, ptr %EBP, align 4
  %v8318 = load i32, ptr %SSBASE, align 4
  %v8319 = sub i32 %v8317, 12
  %v8320 = add i32 %v8319, %v8318
  %v8321 = load ptr, ptr %MEMORY, align 4
  %v8322 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8321, ptr %state, ptr %EDX, i32 %v8320)
  store ptr %v8322, ptr %MEMORY, align 4
  %v8323 = load ptr, ptr %MEMORY, align 4
  %v8324 = call ptr @__remill_atomic_end(ptr %v8323)
  store ptr %v8324, ptr %MEMORY, align 4
  store i32 %v8314, ptr %PC, align 4
  %v8325 = add i32 %v8314, 3
  store i32 %v8325, ptr %NEXT_PC, align 4
  %v8326 = load ptr, ptr %MEMORY, align 4
  %v8327 = call ptr @__remill_atomic_begin(ptr %v8326)
  store ptr %v8327, ptr %MEMORY, align 4
  %v8328 = load i32, ptr %EBP, align 4
  %v8329 = load i32, ptr %SSBASE, align 4
  %v8330 = sub i32 %v8328, 24
  %v8331 = add i32 %v8330, %v8329
  %v8332 = load ptr, ptr %MEMORY, align 4
  %v8333 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8332, ptr %state, ptr %EAX, i32 %v8331)
  store ptr %v8333, ptr %MEMORY, align 4
  %v8334 = load ptr, ptr %MEMORY, align 4
  %v8335 = call ptr @__remill_atomic_end(ptr %v8334)
  store ptr %v8335, ptr %MEMORY, align 4
  store i32 %v8325, ptr %PC, align 4
  %v8336 = add i32 %v8325, 2
  store i32 %v8336, ptr %NEXT_PC, align 4
  %v8337 = load ptr, ptr %MEMORY, align 4
  %v8338 = call ptr @__remill_atomic_begin(ptr %v8337)
  store ptr %v8338, ptr %MEMORY, align 4
  %v8339 = load i32, ptr %EDX, align 4
  %v8340 = load i32, ptr %EAX, align 4
  %v8341 = load ptr, ptr %MEMORY, align 4
  %v8342 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v8341, ptr %state, ptr %EDX, i32 %v8339, i32 %v8340)
  store ptr %v8342, ptr %MEMORY, align 4
  %v8343 = load ptr, ptr %MEMORY, align 4
  %v8344 = call ptr @__remill_atomic_end(ptr %v8343)
  store ptr %v8344, ptr %MEMORY, align 4
  store i32 %v8336, ptr %PC, align 4
  %v8345 = add i32 %v8336, 2
  store i32 %v8345, ptr %NEXT_PC, align 4
  %v8346 = load ptr, ptr %MEMORY, align 4
  %v8347 = call ptr @__remill_atomic_begin(ptr %v8346)
  store ptr %v8347, ptr %MEMORY, align 4
  %v8348 = load i32, ptr %EDX, align 4
  %v8349 = load ptr, ptr %MEMORY, align 4
  %v8350 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8349, ptr %state, ptr %EAX, i32 %v8348)
  store ptr %v8350, ptr %MEMORY, align 4
  %v8351 = load ptr, ptr %MEMORY, align 4
  %v8352 = call ptr @__remill_atomic_end(ptr %v8351)
  store ptr %v8352, ptr %MEMORY, align 4
  store i32 %v8345, ptr %PC, align 4
  %v8353 = add i32 %v8345, 3
  store i32 %v8353, ptr %NEXT_PC, align 4
  %v8354 = load ptr, ptr %MEMORY, align 4
  %v8355 = call ptr @__remill_atomic_begin(ptr %v8354)
  store ptr %v8355, ptr %MEMORY, align 4
  %v8356 = load i32, ptr %EAX, align 4
  %v8357 = load ptr, ptr %MEMORY, align 4
  %v8358 = call ptr @_ZN12_GLOBAL__N_13SARI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8357, ptr %state, ptr %EAX, i32 %v8356, i32 31)
  store ptr %v8358, ptr %MEMORY, align 4
  %v8359 = load ptr, ptr %MEMORY, align 4
  %v8360 = call ptr @__remill_atomic_end(ptr %v8359)
  store ptr %v8360, ptr %MEMORY, align 4
  store i32 %v8353, ptr %PC, align 4
  %v8361 = add i32 %v8353, 3
  store i32 %v8361, ptr %NEXT_PC, align 4
  %v8362 = load ptr, ptr %MEMORY, align 4
  %v8363 = call ptr @__remill_atomic_begin(ptr %v8362)
  store ptr %v8363, ptr %MEMORY, align 4
  %v8364 = load i32, ptr %EAX, align 4
  %v8365 = load ptr, ptr %MEMORY, align 4
  %v8366 = call ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8365, ptr %state, ptr %EAX, i32 %v8364, i32 30)
  store ptr %v8366, ptr %MEMORY, align 4
  %v8367 = load ptr, ptr %MEMORY, align 4
  %v8368 = call ptr @__remill_atomic_end(ptr %v8367)
  store ptr %v8368, ptr %MEMORY, align 4
  store i32 %v8361, ptr %PC, align 4
  %v8369 = add i32 %v8361, 2
  store i32 %v8369, ptr %NEXT_PC, align 4
  %v8370 = load ptr, ptr %MEMORY, align 4
  %v8371 = call ptr @__remill_atomic_begin(ptr %v8370)
  store ptr %v8371, ptr %MEMORY, align 4
  %v8372 = load i32, ptr %EDX, align 4
  %v8373 = load i32, ptr %EAX, align 4
  %v8374 = load ptr, ptr %MEMORY, align 4
  %v8375 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v8374, ptr %state, ptr %EDX, i32 %v8372, i32 %v8373)
  store ptr %v8375, ptr %MEMORY, align 4
  %v8376 = load ptr, ptr %MEMORY, align 4
  %v8377 = call ptr @__remill_atomic_end(ptr %v8376)
  store ptr %v8377, ptr %MEMORY, align 4
  store i32 %v8369, ptr %PC, align 4
  %v8378 = add i32 %v8369, 3
  store i32 %v8378, ptr %NEXT_PC, align 4
  %v8379 = load ptr, ptr %MEMORY, align 4
  %v8380 = call ptr @__remill_atomic_begin(ptr %v8379)
  store ptr %v8380, ptr %MEMORY, align 4
  %v8381 = load i32, ptr %EDX, align 4
  %v8382 = load ptr, ptr %MEMORY, align 4
  %v8383 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8382, ptr %state, ptr %EDX, i32 %v8381, i32 3)
  store ptr %v8383, ptr %MEMORY, align 4
  %v8384 = load ptr, ptr %MEMORY, align 4
  %v8385 = call ptr @__remill_atomic_end(ptr %v8384)
  store ptr %v8385, ptr %MEMORY, align 4
  store i32 %v8378, ptr %PC, align 4
  %v8386 = add i32 %v8378, 2
  store i32 %v8386, ptr %NEXT_PC, align 4
  %v8387 = load ptr, ptr %MEMORY, align 4
  %v8388 = call ptr @__remill_atomic_begin(ptr %v8387)
  store ptr %v8388, ptr %MEMORY, align 4
  %v8389 = load i32, ptr %EDX, align 4
  %v8390 = load ptr, ptr %MEMORY, align 4
  %v8391 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8390, ptr %state, ptr %ECX, i32 %v8389)
  store ptr %v8391, ptr %MEMORY, align 4
  %v8392 = load ptr, ptr %MEMORY, align 4
  %v8393 = call ptr @__remill_atomic_end(ptr %v8392)
  store ptr %v8393, ptr %MEMORY, align 4
  store i32 %v8386, ptr %PC, align 4
  %v8394 = add i32 %v8386, 2
  store i32 %v8394, ptr %NEXT_PC, align 4
  %v8395 = load ptr, ptr %MEMORY, align 4
  %v8396 = call ptr @__remill_atomic_begin(ptr %v8395)
  store ptr %v8396, ptr %MEMORY, align 4
  %v8397 = load i32, ptr %ECX, align 4
  %v8398 = load i32, ptr %EAX, align 4
  %v8399 = load ptr, ptr %MEMORY, align 4
  %v8400 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v8399, ptr %state, ptr %ECX, i32 %v8397, i32 %v8398)
  store ptr %v8400, ptr %MEMORY, align 4
  %v8401 = load ptr, ptr %MEMORY, align 4
  %v8402 = call ptr @__remill_atomic_end(ptr %v8401)
  store ptr %v8402, ptr %MEMORY, align 4
  store i32 %v8394, ptr %PC, align 4
  %v8403 = add i32 %v8394, 2
  store i32 %v8403, ptr %NEXT_PC, align 4
  %v8404 = load ptr, ptr %MEMORY, align 4
  %v8405 = call ptr @__remill_atomic_begin(ptr %v8404)
  store ptr %v8405, ptr %MEMORY, align 4
  %v8406 = load i32, ptr %ECX, align 4
  %v8407 = load ptr, ptr %MEMORY, align 4
  %v8408 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8407, ptr %state, ptr %EAX, i32 %v8406)
  store ptr %v8408, ptr %MEMORY, align 4
  %v8409 = load ptr, ptr %MEMORY, align 4
  %v8410 = call ptr @__remill_atomic_end(ptr %v8409)
  store ptr %v8410, ptr %MEMORY, align 4
  store i32 %v8403, ptr %PC, align 4
  %v8411 = add i32 %v8403, 3
  store i32 %v8411, ptr %NEXT_PC, align 4
  %v8412 = load ptr, ptr %MEMORY, align 4
  %v8413 = call ptr @__remill_atomic_begin(ptr %v8412)
  store ptr %v8413, ptr %MEMORY, align 4
  %v8414 = load i32, ptr %EAX, align 4
  %v8415 = load ptr, ptr %MEMORY, align 4
  %v8416 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8415, ptr %state, i32 %v8414, i32 3)
  store ptr %v8416, ptr %MEMORY, align 4
  %v8417 = load ptr, ptr %MEMORY, align 4
  %v8418 = call ptr @__remill_atomic_end(ptr %v8417)
  store ptr %v8418, ptr %MEMORY, align 4
  store i32 %v8411, ptr %PC, align 4
  %v8419 = add i32 %v8411, 2
  store i32 %v8419, ptr %NEXT_PC, align 4
  %v8420 = load ptr, ptr %MEMORY, align 4
  %v8421 = call ptr @__remill_atomic_begin(ptr %v8420)
  store ptr %v8421, ptr %MEMORY, align 4
  %v8422 = add i32 %v8419, 10
  %v8423 = load ptr, ptr %MEMORY, align 4
  %v8424 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8423, ptr %state, ptr %BRANCH_TAKEN, i32 %v8422, i32 %v8419, ptr %NEXT_PC)
  store ptr %v8424, ptr %MEMORY, align 4
  %v8425 = load ptr, ptr %MEMORY, align 4
  %v8426 = call ptr @__remill_atomic_end(ptr %v8425)
  store ptr %v8426, ptr %MEMORY, align 4
  br i1 true, label %bb_4207432, label %bb_4207422

bb_4207422:                                       ; preds = %bb_4207390
  store i32 %v8419, ptr %PC, align 4
  %v8427 = add i32 %v8419, 3
  store i32 %v8427, ptr %NEXT_PC, align 4
  %v8428 = load ptr, ptr %MEMORY, align 4
  %v8429 = call ptr @__remill_atomic_begin(ptr %v8428)
  store ptr %v8429, ptr %MEMORY, align 4
  %v8430 = load i32, ptr %EBP, align 4
  %v8431 = load i32, ptr %SSBASE, align 4
  %v8432 = sub i32 %v8430, 12
  %v8433 = add i32 %v8432, %v8431
  %v8434 = load ptr, ptr %MEMORY, align 4
  %v8435 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8434, ptr %state, ptr %EAX, i32 %v8433)
  store ptr %v8435, ptr %MEMORY, align 4
  %v8436 = load ptr, ptr %MEMORY, align 4
  %v8437 = call ptr @__remill_atomic_end(ptr %v8436)
  store ptr %v8437, ptr %MEMORY, align 4
  store i32 %v8427, ptr %PC, align 4
  %v8438 = add i32 %v8427, 3
  store i32 %v8438, ptr %NEXT_PC, align 4
  %v8439 = load ptr, ptr %MEMORY, align 4
  %v8440 = call ptr @__remill_atomic_begin(ptr %v8439)
  store ptr %v8440, ptr %MEMORY, align 4
  %v8441 = load i32, ptr %EAX, align 4
  %v8442 = load i32, ptr %DSBASE, align 4
  %v8443 = add i32 %v8441, %v8442
  %v8444 = load ptr, ptr %MEMORY, align 4
  %v8445 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v8444, ptr %state, i32 %v8443, i32 44)
  store ptr %v8445, ptr %MEMORY, align 4
  %v8446 = load ptr, ptr %MEMORY, align 4
  %v8447 = call ptr @__remill_atomic_end(ptr %v8446)
  store ptr %v8447, ptr %MEMORY, align 4
  store i32 %v8438, ptr %PC, align 4
  %v8448 = add i32 %v8438, 4
  store i32 %v8448, ptr %NEXT_PC, align 4
  %v8449 = load ptr, ptr %MEMORY, align 4
  %v8450 = call ptr @__remill_atomic_begin(ptr %v8449)
  store ptr %v8450, ptr %MEMORY, align 4
  %v8451 = load i32, ptr %EBP, align 4
  %v8452 = load i32, ptr %SSBASE, align 4
  %v8453 = sub i32 %v8451, 12
  %v8454 = add i32 %v8453, %v8452
  %v8455 = load i32, ptr %EBP, align 4
  %v8456 = load i32, ptr %SSBASE, align 4
  %v8457 = sub i32 %v8455, 12
  %v8458 = add i32 %v8457, %v8456
  %v8459 = load ptr, ptr %MEMORY, align 4
  %v8460 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8459, ptr %state, i32 %v8454, i32 %v8458, i32 1)
  store ptr %v8460, ptr %MEMORY, align 4
  %v8461 = load ptr, ptr %MEMORY, align 4
  %v8462 = call ptr @__remill_atomic_end(ptr %v8461)
  store ptr %v8462, ptr %MEMORY, align 4
  br label %bb_4207432

bb_4207432:                                       ; preds = %bb_4207422, %bb_4207390, %bb_4207378, %bb_4207363, %bb_4207355
  %v8463 = load i32, ptr %NEXT_PC, align 4
  store i32 %v8463, ptr %PC, align 4
  %v8464 = add i32 %v8463, 3
  store i32 %v8464, ptr %NEXT_PC, align 4
  %v8465 = load ptr, ptr %MEMORY, align 4
  %v8466 = call ptr @__remill_atomic_begin(ptr %v8465)
  store ptr %v8466, ptr %MEMORY, align 4
  %v8467 = load i32, ptr %EBP, align 4
  %v8468 = load i32, ptr %SSBASE, align 4
  %v8469 = sub i32 %v8467, 32
  %v8470 = add i32 %v8469, %v8468
  %v8471 = load ptr, ptr %MEMORY, align 4
  %v8472 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8471, ptr %state, ptr %EAX, i32 %v8470)
  store ptr %v8472, ptr %MEMORY, align 4
  %v8473 = load ptr, ptr %MEMORY, align 4
  %v8474 = call ptr @__remill_atomic_end(ptr %v8473)
  store ptr %v8474, ptr %MEMORY, align 4
  store i32 %v8464, ptr %PC, align 4
  %v8475 = add i32 %v8464, 3
  store i32 %v8475, ptr %NEXT_PC, align 4
  %v8476 = load ptr, ptr %MEMORY, align 4
  %v8477 = call ptr @__remill_atomic_begin(ptr %v8476)
  store ptr %v8477, ptr %MEMORY, align 4
  %v8478 = load i32, ptr %EBP, align 4
  %v8479 = load i32, ptr %SSBASE, align 4
  %v8480 = sub i32 %v8478, 28
  %v8481 = add i32 %v8480, %v8479
  %v8482 = load ptr, ptr %MEMORY, align 4
  %v8483 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8482, ptr %state, ptr %EDX, i32 %v8481)
  store ptr %v8483, ptr %MEMORY, align 4
  %v8484 = load ptr, ptr %MEMORY, align 4
  %v8485 = call ptr @__remill_atomic_end(ptr %v8484)
  store ptr %v8485, ptr %MEMORY, align 4
  store i32 %v8475, ptr %PC, align 4
  %v8486 = add i32 %v8475, 8
  store i32 %v8486, ptr %NEXT_PC, align 4
  %v8487 = load ptr, ptr %MEMORY, align 4
  %v8488 = call ptr @__remill_atomic_begin(ptr %v8487)
  store ptr %v8488, ptr %MEMORY, align 4
  %v8489 = load i32, ptr %ESP, align 4
  %v8490 = load i32, ptr %SSBASE, align 4
  %v8491 = add i32 %v8489, 8
  %v8492 = add i32 %v8491, %v8490
  %v8493 = load ptr, ptr %MEMORY, align 4
  %v8494 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8493, ptr %state, i32 %v8492, i32 10)
  store ptr %v8494, ptr %MEMORY, align 4
  %v8495 = load ptr, ptr %MEMORY, align 4
  %v8496 = call ptr @__remill_atomic_end(ptr %v8495)
  store ptr %v8496, ptr %MEMORY, align 4
  store i32 %v8486, ptr %PC, align 4
  %v8497 = add i32 %v8486, 8
  store i32 %v8497, ptr %NEXT_PC, align 4
  %v8498 = load ptr, ptr %MEMORY, align 4
  %v8499 = call ptr @__remill_atomic_begin(ptr %v8498)
  store ptr %v8499, ptr %MEMORY, align 4
  %v8500 = load i32, ptr %ESP, align 4
  %v8501 = load i32, ptr %SSBASE, align 4
  %v8502 = add i32 %v8500, 12
  %v8503 = add i32 %v8502, %v8501
  %v8504 = load ptr, ptr %MEMORY, align 4
  %v8505 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8504, ptr %state, i32 %v8503, i32 0)
  store ptr %v8505, ptr %MEMORY, align 4
  %v8506 = load ptr, ptr %MEMORY, align 4
  %v8507 = call ptr @__remill_atomic_end(ptr %v8506)
  store ptr %v8507, ptr %MEMORY, align 4
  store i32 %v8497, ptr %PC, align 4
  %v8508 = add i32 %v8497, 3
  store i32 %v8508, ptr %NEXT_PC, align 4
  %v8509 = load ptr, ptr %MEMORY, align 4
  %v8510 = call ptr @__remill_atomic_begin(ptr %v8509)
  store ptr %v8510, ptr %MEMORY, align 4
  %v8511 = load i32, ptr %ESP, align 4
  %v8512 = load i32, ptr %SSBASE, align 4
  %v8513 = add i32 %v8511, %v8512
  %v8514 = load i32, ptr %EAX, align 4
  %v8515 = load ptr, ptr %MEMORY, align 4
  %v8516 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8515, ptr %state, i32 %v8513, i32 %v8514)
  store ptr %v8516, ptr %MEMORY, align 4
  %v8517 = load ptr, ptr %MEMORY, align 4
  %v8518 = call ptr @__remill_atomic_end(ptr %v8517)
  store ptr %v8518, ptr %MEMORY, align 4
  store i32 %v8508, ptr %PC, align 4
  %v8519 = add i32 %v8508, 4
  store i32 %v8519, ptr %NEXT_PC, align 4
  %v8520 = load ptr, ptr %MEMORY, align 4
  %v8521 = call ptr @__remill_atomic_begin(ptr %v8520)
  store ptr %v8521, ptr %MEMORY, align 4
  %v8522 = load i32, ptr %ESP, align 4
  %v8523 = load i32, ptr %SSBASE, align 4
  %v8524 = add i32 %v8522, 4
  %v8525 = add i32 %v8524, %v8523
  %v8526 = load i32, ptr %EDX, align 4
  %v8527 = load ptr, ptr %MEMORY, align 4
  %v8528 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8527, ptr %state, i32 %v8525, i32 %v8526)
  store ptr %v8528, ptr %MEMORY, align 4
  %v8529 = load ptr, ptr %MEMORY, align 4
  %v8530 = call ptr @__remill_atomic_end(ptr %v8529)
  store ptr %v8530, ptr %MEMORY, align 4
  store i32 %v8519, ptr %PC, align 4
  %v8531 = add i32 %v8519, 5
  store i32 %v8531, ptr %NEXT_PC, align 4
  %v8532 = load ptr, ptr %MEMORY, align 4
  %v8533 = call ptr @__remill_atomic_begin(ptr %v8532)
  store ptr %v8533, ptr %MEMORY, align 4
  %v8534 = add i32 %v8531, 21286
  %v8535 = load ptr, ptr %MEMORY, align 4
  %v8536 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v8535, ptr %state, i64 4228752, ptr %NEXT_PC, i32 %v8531, ptr %RETURN_PC)
  store ptr %v8536, ptr %MEMORY, align 4
  %v8537 = load ptr, ptr %MEMORY, align 4
  %v8538 = call ptr @__remill_atomic_end(ptr %v8537)
  store ptr %v8538, ptr %MEMORY, align 4
  store i32 %v8531, ptr %PC, align 4
  %v8539 = add i32 %v8531, 3
  store i32 %v8539, ptr %NEXT_PC, align 4
  %v8540 = load ptr, ptr %MEMORY, align 4
  %v8541 = call ptr @__remill_atomic_begin(ptr %v8540)
  store ptr %v8541, ptr %MEMORY, align 4
  %v8542 = load i32, ptr %EAX, align 4
  %v8543 = load ptr, ptr %MEMORY, align 4
  %v8544 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8543, ptr %state, ptr %EAX, i32 %v8542, i32 48)
  store ptr %v8544, ptr %MEMORY, align 4
  %v8545 = load ptr, ptr %MEMORY, align 4
  %v8546 = call ptr @__remill_atomic_end(ptr %v8545)
  store ptr %v8546, ptr %MEMORY, align 4
  store i32 %v8539, ptr %PC, align 4
  %v8547 = add i32 %v8539, 2
  store i32 %v8547, ptr %NEXT_PC, align 4
  %v8548 = load ptr, ptr %MEMORY, align 4
  %v8549 = call ptr @__remill_atomic_begin(ptr %v8548)
  store ptr %v8549, ptr %MEMORY, align 4
  %v8550 = load i32, ptr %EAX, align 4
  %v8551 = load ptr, ptr %MEMORY, align 4
  %v8552 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8551, ptr %state, ptr %EDX, i32 %v8550)
  store ptr %v8552, ptr %MEMORY, align 4
  %v8553 = load ptr, ptr %MEMORY, align 4
  %v8554 = call ptr @__remill_atomic_end(ptr %v8553)
  store ptr %v8554, ptr %MEMORY, align 4
  store i32 %v8547, ptr %PC, align 4
  %v8555 = add i32 %v8547, 3
  store i32 %v8555, ptr %NEXT_PC, align 4
  %v8556 = load ptr, ptr %MEMORY, align 4
  %v8557 = call ptr @__remill_atomic_begin(ptr %v8556)
  store ptr %v8557, ptr %MEMORY, align 4
  %v8558 = load i32, ptr %EBP, align 4
  %v8559 = load i32, ptr %SSBASE, align 4
  %v8560 = sub i32 %v8558, 12
  %v8561 = add i32 %v8560, %v8559
  %v8562 = load ptr, ptr %MEMORY, align 4
  %v8563 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8562, ptr %state, ptr %EAX, i32 %v8561)
  store ptr %v8563, ptr %MEMORY, align 4
  %v8564 = load ptr, ptr %MEMORY, align 4
  %v8565 = call ptr @__remill_atomic_end(ptr %v8564)
  store ptr %v8565, ptr %MEMORY, align 4
  store i32 %v8555, ptr %PC, align 4
  %v8566 = add i32 %v8555, 2
  store i32 %v8566, ptr %NEXT_PC, align 4
  %v8567 = load ptr, ptr %MEMORY, align 4
  %v8568 = call ptr @__remill_atomic_begin(ptr %v8567)
  store ptr %v8568, ptr %MEMORY, align 4
  %v8569 = load i32, ptr %EAX, align 4
  %v8570 = load i32, ptr %DSBASE, align 4
  %v8571 = add i32 %v8569, %v8570
  %v8572 = load i8, ptr %DL, align 1
  %v8573 = zext i8 %v8572 to i32
  %v8574 = load ptr, ptr %MEMORY, align 4
  %v8575 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8574, ptr %state, i32 %v8571, i32 %v8573)
  store ptr %v8575, ptr %MEMORY, align 4
  %v8576 = load ptr, ptr %MEMORY, align 4
  %v8577 = call ptr @__remill_atomic_end(ptr %v8576)
  store ptr %v8577, ptr %MEMORY, align 4
  store i32 %v8566, ptr %PC, align 4
  %v8578 = add i32 %v8566, 4
  store i32 %v8578, ptr %NEXT_PC, align 4
  %v8579 = load ptr, ptr %MEMORY, align 4
  %v8580 = call ptr @__remill_atomic_begin(ptr %v8579)
  store ptr %v8580, ptr %MEMORY, align 4
  %v8581 = load i32, ptr %EBP, align 4
  %v8582 = load i32, ptr %SSBASE, align 4
  %v8583 = sub i32 %v8581, 12
  %v8584 = add i32 %v8583, %v8582
  %v8585 = load i32, ptr %EBP, align 4
  %v8586 = load i32, ptr %SSBASE, align 4
  %v8587 = sub i32 %v8585, 12
  %v8588 = add i32 %v8587, %v8586
  %v8589 = load ptr, ptr %MEMORY, align 4
  %v8590 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8589, ptr %state, i32 %v8584, i32 %v8588, i32 1)
  store ptr %v8590, ptr %MEMORY, align 4
  %v8591 = load ptr, ptr %MEMORY, align 4
  %v8592 = call ptr @__remill_atomic_end(ptr %v8591)
  store ptr %v8592, ptr %MEMORY, align 4
  store i32 %v8578, ptr %PC, align 4
  %v8593 = add i32 %v8578, 3
  store i32 %v8593, ptr %NEXT_PC, align 4
  %v8594 = load ptr, ptr %MEMORY, align 4
  %v8595 = call ptr @__remill_atomic_begin(ptr %v8594)
  store ptr %v8595, ptr %MEMORY, align 4
  %v8596 = load i32, ptr %EBP, align 4
  %v8597 = load i32, ptr %SSBASE, align 4
  %v8598 = sub i32 %v8596, 32
  %v8599 = add i32 %v8598, %v8597
  %v8600 = load ptr, ptr %MEMORY, align 4
  %v8601 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8600, ptr %state, ptr %EAX, i32 %v8599)
  store ptr %v8601, ptr %MEMORY, align 4
  %v8602 = load ptr, ptr %MEMORY, align 4
  %v8603 = call ptr @__remill_atomic_end(ptr %v8602)
  store ptr %v8603, ptr %MEMORY, align 4
  store i32 %v8593, ptr %PC, align 4
  %v8604 = add i32 %v8593, 3
  store i32 %v8604, ptr %NEXT_PC, align 4
  %v8605 = load ptr, ptr %MEMORY, align 4
  %v8606 = call ptr @__remill_atomic_begin(ptr %v8605)
  store ptr %v8606, ptr %MEMORY, align 4
  %v8607 = load i32, ptr %EBP, align 4
  %v8608 = load i32, ptr %SSBASE, align 4
  %v8609 = sub i32 %v8607, 28
  %v8610 = add i32 %v8609, %v8608
  %v8611 = load ptr, ptr %MEMORY, align 4
  %v8612 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8611, ptr %state, ptr %EDX, i32 %v8610)
  store ptr %v8612, ptr %MEMORY, align 4
  %v8613 = load ptr, ptr %MEMORY, align 4
  %v8614 = call ptr @__remill_atomic_end(ptr %v8613)
  store ptr %v8614, ptr %MEMORY, align 4
  store i32 %v8604, ptr %PC, align 4
  %v8615 = add i32 %v8604, 8
  store i32 %v8615, ptr %NEXT_PC, align 4
  %v8616 = load ptr, ptr %MEMORY, align 4
  %v8617 = call ptr @__remill_atomic_begin(ptr %v8616)
  store ptr %v8617, ptr %MEMORY, align 4
  %v8618 = load i32, ptr %ESP, align 4
  %v8619 = load i32, ptr %SSBASE, align 4
  %v8620 = add i32 %v8618, 8
  %v8621 = add i32 %v8620, %v8619
  %v8622 = load ptr, ptr %MEMORY, align 4
  %v8623 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8622, ptr %state, i32 %v8621, i32 10)
  store ptr %v8623, ptr %MEMORY, align 4
  %v8624 = load ptr, ptr %MEMORY, align 4
  %v8625 = call ptr @__remill_atomic_end(ptr %v8624)
  store ptr %v8625, ptr %MEMORY, align 4
  store i32 %v8615, ptr %PC, align 4
  %v8626 = add i32 %v8615, 8
  store i32 %v8626, ptr %NEXT_PC, align 4
  %v8627 = load ptr, ptr %MEMORY, align 4
  %v8628 = call ptr @__remill_atomic_begin(ptr %v8627)
  store ptr %v8628, ptr %MEMORY, align 4
  %v8629 = load i32, ptr %ESP, align 4
  %v8630 = load i32, ptr %SSBASE, align 4
  %v8631 = add i32 %v8629, 12
  %v8632 = add i32 %v8631, %v8630
  %v8633 = load ptr, ptr %MEMORY, align 4
  %v8634 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8633, ptr %state, i32 %v8632, i32 0)
  store ptr %v8634, ptr %MEMORY, align 4
  %v8635 = load ptr, ptr %MEMORY, align 4
  %v8636 = call ptr @__remill_atomic_end(ptr %v8635)
  store ptr %v8636, ptr %MEMORY, align 4
  store i32 %v8626, ptr %PC, align 4
  %v8637 = add i32 %v8626, 3
  store i32 %v8637, ptr %NEXT_PC, align 4
  %v8638 = load ptr, ptr %MEMORY, align 4
  %v8639 = call ptr @__remill_atomic_begin(ptr %v8638)
  store ptr %v8639, ptr %MEMORY, align 4
  %v8640 = load i32, ptr %ESP, align 4
  %v8641 = load i32, ptr %SSBASE, align 4
  %v8642 = add i32 %v8640, %v8641
  %v8643 = load i32, ptr %EAX, align 4
  %v8644 = load ptr, ptr %MEMORY, align 4
  %v8645 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8644, ptr %state, i32 %v8642, i32 %v8643)
  store ptr %v8645, ptr %MEMORY, align 4
  %v8646 = load ptr, ptr %MEMORY, align 4
  %v8647 = call ptr @__remill_atomic_end(ptr %v8646)
  store ptr %v8647, ptr %MEMORY, align 4
  store i32 %v8637, ptr %PC, align 4
  %v8648 = add i32 %v8637, 4
  store i32 %v8648, ptr %NEXT_PC, align 4
  %v8649 = load ptr, ptr %MEMORY, align 4
  %v8650 = call ptr @__remill_atomic_begin(ptr %v8649)
  store ptr %v8650, ptr %MEMORY, align 4
  %v8651 = load i32, ptr %ESP, align 4
  %v8652 = load i32, ptr %SSBASE, align 4
  %v8653 = add i32 %v8651, 4
  %v8654 = add i32 %v8653, %v8652
  %v8655 = load i32, ptr %EDX, align 4
  %v8656 = load ptr, ptr %MEMORY, align 4
  %v8657 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8656, ptr %state, i32 %v8654, i32 %v8655)
  store ptr %v8657, ptr %MEMORY, align 4
  %v8658 = load ptr, ptr %MEMORY, align 4
  %v8659 = call ptr @__remill_atomic_end(ptr %v8658)
  store ptr %v8659, ptr %MEMORY, align 4
  store i32 %v8648, ptr %PC, align 4
  %v8660 = add i32 %v8648, 5
  store i32 %v8660, ptr %NEXT_PC, align 4
  %v8661 = load ptr, ptr %MEMORY, align 4
  %v8662 = call ptr @__remill_atomic_begin(ptr %v8661)
  store ptr %v8662, ptr %MEMORY, align 4
  %v8663 = add i32 %v8660, 21558
  %v8664 = load ptr, ptr %MEMORY, align 4
  %v8665 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v8664, ptr %state, i64 4229072, ptr %NEXT_PC, i32 %v8660, ptr %RETURN_PC)
  store ptr %v8665, ptr %MEMORY, align 4
  %v8666 = load ptr, ptr %MEMORY, align 4
  %v8667 = call ptr @__remill_atomic_end(ptr %v8666)
  store ptr %v8667, ptr %MEMORY, align 4
  store i32 %v8660, ptr %PC, align 4
  %v8668 = add i32 %v8660, 3
  store i32 %v8668, ptr %NEXT_PC, align 4
  %v8669 = load ptr, ptr %MEMORY, align 4
  %v8670 = call ptr @__remill_atomic_begin(ptr %v8669)
  store ptr %v8670, ptr %MEMORY, align 4
  %v8671 = load i32, ptr %EBP, align 4
  %v8672 = load i32, ptr %SSBASE, align 4
  %v8673 = sub i32 %v8671, 32
  %v8674 = add i32 %v8673, %v8672
  %v8675 = load i32, ptr %EAX, align 4
  %v8676 = load ptr, ptr %MEMORY, align 4
  %v8677 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8676, ptr %state, i32 %v8674, i32 %v8675)
  store ptr %v8677, ptr %MEMORY, align 4
  %v8678 = load ptr, ptr %MEMORY, align 4
  %v8679 = call ptr @__remill_atomic_end(ptr %v8678)
  store ptr %v8679, ptr %MEMORY, align 4
  store i32 %v8668, ptr %PC, align 4
  %v8680 = add i32 %v8668, 3
  store i32 %v8680, ptr %NEXT_PC, align 4
  %v8681 = load ptr, ptr %MEMORY, align 4
  %v8682 = call ptr @__remill_atomic_begin(ptr %v8681)
  store ptr %v8682, ptr %MEMORY, align 4
  %v8683 = load i32, ptr %EBP, align 4
  %v8684 = load i32, ptr %SSBASE, align 4
  %v8685 = sub i32 %v8683, 28
  %v8686 = add i32 %v8685, %v8684
  %v8687 = load i32, ptr %EDX, align 4
  %v8688 = load ptr, ptr %MEMORY, align 4
  %v8689 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8688, ptr %state, i32 %v8686, i32 %v8687)
  store ptr %v8689, ptr %MEMORY, align 4
  %v8690 = load ptr, ptr %MEMORY, align 4
  %v8691 = call ptr @__remill_atomic_end(ptr %v8690)
  store ptr %v8691, ptr %MEMORY, align 4
  store i32 %v8680, ptr %PC, align 4
  %v8692 = add i32 %v8680, 2
  store i32 %v8692, ptr %NEXT_PC, align 4
  %v8693 = load ptr, ptr %MEMORY, align 4
  %v8694 = call ptr @__remill_atomic_begin(ptr %v8693)
  store ptr %v8694, ptr %MEMORY, align 4
  %v8695 = add i32 %v8692, 1
  %v8696 = load ptr, ptr %MEMORY, align 4
  %v8697 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v8696, ptr %state, i32 %v8695, ptr %NEXT_PC)
  store ptr %v8697, ptr %MEMORY, align 4
  %v8698 = load ptr, ptr %MEMORY, align 4
  %v8699 = call ptr @__remill_atomic_end(ptr %v8698)
  store ptr %v8699, ptr %MEMORY, align 4
  br label %bb_4207523

bb_4207522:                                       ; preds = %bb_4207333, %bb_4207309, %bb_4207172
  %v8700 = load i32, ptr %NEXT_PC, align 4
  store i32 %v8700, ptr %PC, align 4
  %v8701 = add i32 %v8700, 1
  store i32 %v8701, ptr %NEXT_PC, align 4
  %v8702 = load ptr, ptr %MEMORY, align 4
  %v8703 = call ptr @__remill_atomic_begin(ptr %v8702)
  store ptr %v8703, ptr %MEMORY, align 4
  %v8704 = load ptr, ptr %MEMORY, align 4
  %v8705 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v8704, ptr %state)
  store ptr %v8705, ptr %MEMORY, align 4
  %v8706 = load ptr, ptr %MEMORY, align 4
  %v8707 = call ptr @__remill_atomic_end(ptr %v8706)
  store ptr %v8707, ptr %MEMORY, align 4
  br label %bb_4207523

bb_4207523:                                       ; preds = %bb_4207522, %bb_4207432
  %v8708 = load i32, ptr %NEXT_PC, align 4
  store i32 %v8708, ptr %PC, align 4
  %v8709 = add i32 %v8708, 3
  store i32 %v8709, ptr %NEXT_PC, align 4
  %v8710 = load ptr, ptr %MEMORY, align 4
  %v8711 = call ptr @__remill_atomic_begin(ptr %v8710)
  store ptr %v8711, ptr %MEMORY, align 4
  %v8712 = load i32, ptr %EBP, align 4
  %v8713 = load i32, ptr %SSBASE, align 4
  %v8714 = sub i32 %v8712, 32
  %v8715 = add i32 %v8714, %v8713
  %v8716 = load ptr, ptr %MEMORY, align 4
  %v8717 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8716, ptr %state, ptr %EAX, i32 %v8715)
  store ptr %v8717, ptr %MEMORY, align 4
  %v8718 = load ptr, ptr %MEMORY, align 4
  %v8719 = call ptr @__remill_atomic_end(ptr %v8718)
  store ptr %v8719, ptr %MEMORY, align 4
  store i32 %v8709, ptr %PC, align 4
  %v8720 = add i32 %v8709, 3
  store i32 %v8720, ptr %NEXT_PC, align 4
  %v8721 = load ptr, ptr %MEMORY, align 4
  %v8722 = call ptr @__remill_atomic_begin(ptr %v8721)
  store ptr %v8722, ptr %MEMORY, align 4
  %v8723 = load i32, ptr %EBP, align 4
  %v8724 = load i32, ptr %SSBASE, align 4
  %v8725 = sub i32 %v8723, 28
  %v8726 = add i32 %v8725, %v8724
  %v8727 = load ptr, ptr %MEMORY, align 4
  %v8728 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8727, ptr %state, ptr %EDX, i32 %v8726)
  store ptr %v8728, ptr %MEMORY, align 4
  %v8729 = load ptr, ptr %MEMORY, align 4
  %v8730 = call ptr @__remill_atomic_end(ptr %v8729)
  store ptr %v8730, ptr %MEMORY, align 4
  store i32 %v8720, ptr %PC, align 4
  %v8731 = add i32 %v8720, 2
  store i32 %v8731, ptr %NEXT_PC, align 4
  %v8732 = load ptr, ptr %MEMORY, align 4
  %v8733 = call ptr @__remill_atomic_begin(ptr %v8732)
  store ptr %v8733, ptr %MEMORY, align 4
  %v8734 = load i32, ptr %EAX, align 4
  %v8735 = load i32, ptr %EDX, align 4
  %v8736 = load ptr, ptr %MEMORY, align 4
  %v8737 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v8736, ptr %state, ptr %EAX, i32 %v8734, i32 %v8735)
  store ptr %v8737, ptr %MEMORY, align 4
  %v8738 = load ptr, ptr %MEMORY, align 4
  %v8739 = call ptr @__remill_atomic_end(ptr %v8738)
  store ptr %v8739, ptr %MEMORY, align 4
  store i32 %v8731, ptr %PC, align 4
  %v8740 = add i32 %v8731, 2
  store i32 %v8740, ptr %NEXT_PC, align 4
  %v8741 = load ptr, ptr %MEMORY, align 4
  %v8742 = call ptr @__remill_atomic_begin(ptr %v8741)
  store ptr %v8742, ptr %MEMORY, align 4
  %v8743 = load i32, ptr %EAX, align 4
  %v8744 = load i32, ptr %EAX, align 4
  %v8745 = load ptr, ptr %MEMORY, align 4
  %v8746 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v8745, ptr %state, i32 %v8743, i32 %v8744)
  store ptr %v8746, ptr %MEMORY, align 4
  %v8747 = load ptr, ptr %MEMORY, align 4
  %v8748 = call ptr @__remill_atomic_end(ptr %v8747)
  store ptr %v8748, ptr %MEMORY, align 4
  store i32 %v8740, ptr %PC, align 4
  %v8749 = add i32 %v8740, 6
  store i32 %v8749, ptr %NEXT_PC, align 4
  %v8750 = load ptr, ptr %MEMORY, align 4
  %v8751 = call ptr @__remill_atomic_begin(ptr %v8750)
  store ptr %v8751, ptr %MEMORY, align 4
  %v8752 = sub i32 %v8749, 184
  %v8753 = load ptr, ptr %MEMORY, align 4
  %v8754 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8753, ptr %state, ptr %BRANCH_TAKEN, i32 %v8752, i32 %v8749, ptr %NEXT_PC)
  store ptr %v8754, ptr %MEMORY, align 4
  %v8755 = load ptr, ptr %MEMORY, align 4
  %v8756 = call ptr @__remill_atomic_end(ptr %v8755)
  store ptr %v8756, ptr %MEMORY, align 4
  br i1 true, label %bb_4207355, label %bb_4207539

bb_4207539:                                       ; preds = %bb_4207523
  store i32 %v8749, ptr %PC, align 4
  %v8757 = add i32 %v8749, 3
  store i32 %v8757, ptr %NEXT_PC, align 4
  %v8758 = load ptr, ptr %MEMORY, align 4
  %v8759 = call ptr @__remill_atomic_begin(ptr %v8758)
  store ptr %v8759, ptr %MEMORY, align 4
  %v8760 = load i32, ptr %EBP, align 4
  %v8761 = load i32, ptr %SSBASE, align 4
  %v8762 = add i32 %v8760, 16
  %v8763 = add i32 %v8762, %v8761
  %v8764 = load ptr, ptr %MEMORY, align 4
  %v8765 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8764, ptr %state, ptr %EAX, i32 %v8763)
  store ptr %v8765, ptr %MEMORY, align 4
  %v8766 = load ptr, ptr %MEMORY, align 4
  %v8767 = call ptr @__remill_atomic_end(ptr %v8766)
  store ptr %v8767, ptr %MEMORY, align 4
  store i32 %v8757, ptr %PC, align 4
  %v8768 = add i32 %v8757, 3
  store i32 %v8768, ptr %NEXT_PC, align 4
  %v8769 = load ptr, ptr %MEMORY, align 4
  %v8770 = call ptr @__remill_atomic_begin(ptr %v8769)
  store ptr %v8770, ptr %MEMORY, align 4
  %v8771 = load i32, ptr %EAX, align 4
  %v8772 = load i32, ptr %DSBASE, align 4
  %v8773 = add i32 %v8771, 12
  %v8774 = add i32 %v8773, %v8772
  %v8775 = load ptr, ptr %MEMORY, align 4
  %v8776 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8775, ptr %state, ptr %EAX, i32 %v8774)
  store ptr %v8776, ptr %MEMORY, align 4
  %v8777 = load ptr, ptr %MEMORY, align 4
  %v8778 = call ptr @__remill_atomic_end(ptr %v8777)
  store ptr %v8778, ptr %MEMORY, align 4
  store i32 %v8768, ptr %PC, align 4
  %v8779 = add i32 %v8768, 2
  store i32 %v8779, ptr %NEXT_PC, align 4
  %v8780 = load ptr, ptr %MEMORY, align 4
  %v8781 = call ptr @__remill_atomic_begin(ptr %v8780)
  store ptr %v8781, ptr %MEMORY, align 4
  %v8782 = load i32, ptr %EAX, align 4
  %v8783 = load i32, ptr %EAX, align 4
  %v8784 = load ptr, ptr %MEMORY, align 4
  %v8785 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v8784, ptr %state, i32 %v8782, i32 %v8783)
  store ptr %v8785, ptr %MEMORY, align 4
  %v8786 = load ptr, ptr %MEMORY, align 4
  %v8787 = call ptr @__remill_atomic_end(ptr %v8786)
  store ptr %v8787, ptr %MEMORY, align 4
  store i32 %v8779, ptr %PC, align 4
  %v8788 = add i32 %v8779, 2
  store i32 %v8788, ptr %NEXT_PC, align 4
  %v8789 = load ptr, ptr %MEMORY, align 4
  %v8790 = call ptr @__remill_atomic_begin(ptr %v8789)
  store ptr %v8790, ptr %MEMORY, align 4
  %v8791 = add i32 %v8788, 58
  %v8792 = load ptr, ptr %MEMORY, align 4
  %v8793 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8792, ptr %state, ptr %BRANCH_TAKEN, i32 %v8791, i32 %v8788, ptr %NEXT_PC)
  store ptr %v8793, ptr %MEMORY, align 4
  %v8794 = load ptr, ptr %MEMORY, align 4
  %v8795 = call ptr @__remill_atomic_end(ptr %v8794)
  store ptr %v8795, ptr %MEMORY, align 4
  br i1 true, label %bb_4207607, label %bb_4207549

bb_4207549:                                       ; preds = %bb_4207539
  store i32 %v8788, ptr %PC, align 4
  %v8796 = add i32 %v8788, 3
  store i32 %v8796, ptr %NEXT_PC, align 4
  %v8797 = load ptr, ptr %MEMORY, align 4
  %v8798 = call ptr @__remill_atomic_begin(ptr %v8797)
  store ptr %v8798, ptr %MEMORY, align 4
  %v8799 = load i32, ptr %EBP, align 4
  %v8800 = load i32, ptr %SSBASE, align 4
  %v8801 = add i32 %v8799, 16
  %v8802 = add i32 %v8801, %v8800
  %v8803 = load ptr, ptr %MEMORY, align 4
  %v8804 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8803, ptr %state, ptr %EAX, i32 %v8802)
  store ptr %v8804, ptr %MEMORY, align 4
  %v8805 = load ptr, ptr %MEMORY, align 4
  %v8806 = call ptr @__remill_atomic_end(ptr %v8805)
  store ptr %v8806, ptr %MEMORY, align 4
  store i32 %v8796, ptr %PC, align 4
  %v8807 = add i32 %v8796, 3
  store i32 %v8807, ptr %NEXT_PC, align 4
  %v8808 = load ptr, ptr %MEMORY, align 4
  %v8809 = call ptr @__remill_atomic_begin(ptr %v8808)
  store ptr %v8809, ptr %MEMORY, align 4
  %v8810 = load i32, ptr %EAX, align 4
  %v8811 = load i32, ptr %DSBASE, align 4
  %v8812 = add i32 %v8810, 12
  %v8813 = add i32 %v8812, %v8811
  %v8814 = load ptr, ptr %MEMORY, align 4
  %v8815 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8814, ptr %state, ptr %EAX, i32 %v8813)
  store ptr %v8815, ptr %MEMORY, align 4
  %v8816 = load ptr, ptr %MEMORY, align 4
  %v8817 = call ptr @__remill_atomic_end(ptr %v8816)
  store ptr %v8817, ptr %MEMORY, align 4
  store i32 %v8807, ptr %PC, align 4
  %v8818 = add i32 %v8807, 3
  store i32 %v8818, ptr %NEXT_PC, align 4
  %v8819 = load ptr, ptr %MEMORY, align 4
  %v8820 = call ptr @__remill_atomic_begin(ptr %v8819)
  store ptr %v8820, ptr %MEMORY, align 4
  %v8821 = load i32, ptr %EBP, align 4
  %v8822 = load i32, ptr %SSBASE, align 4
  %v8823 = sub i32 %v8821, 24
  %v8824 = add i32 %v8823, %v8822
  %v8825 = load ptr, ptr %MEMORY, align 4
  %v8826 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8825, ptr %state, ptr %EDX, i32 %v8824)
  store ptr %v8826, ptr %MEMORY, align 4
  %v8827 = load ptr, ptr %MEMORY, align 4
  %v8828 = call ptr @__remill_atomic_end(ptr %v8827)
  store ptr %v8828, ptr %MEMORY, align 4
  store i32 %v8818, ptr %PC, align 4
  %v8829 = add i32 %v8818, 2
  store i32 %v8829, ptr %NEXT_PC, align 4
  %v8830 = load ptr, ptr %MEMORY, align 4
  %v8831 = call ptr @__remill_atomic_begin(ptr %v8830)
  store ptr %v8831, ptr %MEMORY, align 4
  %v8832 = load i32, ptr %EDX, align 4
  %v8833 = load ptr, ptr %MEMORY, align 4
  %v8834 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8833, ptr %state, ptr %ECX, i32 %v8832)
  store ptr %v8834, ptr %MEMORY, align 4
  %v8835 = load ptr, ptr %MEMORY, align 4
  %v8836 = call ptr @__remill_atomic_end(ptr %v8835)
  store ptr %v8836, ptr %MEMORY, align 4
  store i32 %v8829, ptr %PC, align 4
  %v8837 = add i32 %v8829, 3
  store i32 %v8837, ptr %NEXT_PC, align 4
  %v8838 = load ptr, ptr %MEMORY, align 4
  %v8839 = call ptr @__remill_atomic_begin(ptr %v8838)
  store ptr %v8839, ptr %MEMORY, align 4
  %v8840 = load i32, ptr %EBP, align 4
  %v8841 = load i32, ptr %SSBASE, align 4
  %v8842 = sub i32 %v8840, 12
  %v8843 = add i32 %v8842, %v8841
  %v8844 = load ptr, ptr %MEMORY, align 4
  %v8845 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8844, ptr %state, ptr %EDX, i32 %v8843)
  store ptr %v8845, ptr %MEMORY, align 4
  %v8846 = load ptr, ptr %MEMORY, align 4
  %v8847 = call ptr @__remill_atomic_end(ptr %v8846)
  store ptr %v8847, ptr %MEMORY, align 4
  store i32 %v8837, ptr %PC, align 4
  %v8848 = add i32 %v8837, 2
  store i32 %v8848, ptr %NEXT_PC, align 4
  %v8849 = load ptr, ptr %MEMORY, align 4
  %v8850 = call ptr @__remill_atomic_begin(ptr %v8849)
  store ptr %v8850, ptr %MEMORY, align 4
  %v8851 = load i32, ptr %ECX, align 4
  %v8852 = load ptr, ptr %MEMORY, align 4
  %v8853 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8852, ptr %state, ptr %ESI, i32 %v8851)
  store ptr %v8853, ptr %MEMORY, align 4
  %v8854 = load ptr, ptr %MEMORY, align 4
  %v8855 = call ptr @__remill_atomic_end(ptr %v8854)
  store ptr %v8855, ptr %MEMORY, align 4
  store i32 %v8848, ptr %PC, align 4
  %v8856 = add i32 %v8848, 2
  store i32 %v8856, ptr %NEXT_PC, align 4
  %v8857 = load ptr, ptr %MEMORY, align 4
  %v8858 = call ptr @__remill_atomic_begin(ptr %v8857)
  store ptr %v8858, ptr %MEMORY, align 4
  %v8859 = load i32, ptr %ESI, align 4
  %v8860 = load i32, ptr %EDX, align 4
  %v8861 = load ptr, ptr %MEMORY, align 4
  %v8862 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v8861, ptr %state, ptr %ESI, i32 %v8859, i32 %v8860)
  store ptr %v8862, ptr %MEMORY, align 4
  %v8863 = load ptr, ptr %MEMORY, align 4
  %v8864 = call ptr @__remill_atomic_end(ptr %v8863)
  store ptr %v8864, ptr %MEMORY, align 4
  store i32 %v8856, ptr %PC, align 4
  %v8865 = add i32 %v8856, 2
  store i32 %v8865, ptr %NEXT_PC, align 4
  %v8866 = load ptr, ptr %MEMORY, align 4
  %v8867 = call ptr @__remill_atomic_begin(ptr %v8866)
  store ptr %v8867, ptr %MEMORY, align 4
  %v8868 = load i32, ptr %ESI, align 4
  %v8869 = load ptr, ptr %MEMORY, align 4
  %v8870 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8869, ptr %state, ptr %EDX, i32 %v8868)
  store ptr %v8870, ptr %MEMORY, align 4
  %v8871 = load ptr, ptr %MEMORY, align 4
  %v8872 = call ptr @__remill_atomic_end(ptr %v8871)
  store ptr %v8872, ptr %MEMORY, align 4
  store i32 %v8865, ptr %PC, align 4
  %v8873 = add i32 %v8865, 2
  store i32 %v8873, ptr %NEXT_PC, align 4
  %v8874 = load ptr, ptr %MEMORY, align 4
  %v8875 = call ptr @__remill_atomic_begin(ptr %v8874)
  store ptr %v8875, ptr %MEMORY, align 4
  %v8876 = load i32, ptr %EAX, align 4
  %v8877 = load i32, ptr %EDX, align 4
  %v8878 = load ptr, ptr %MEMORY, align 4
  %v8879 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v8878, ptr %state, ptr %EAX, i32 %v8876, i32 %v8877)
  store ptr %v8879, ptr %MEMORY, align 4
  %v8880 = load ptr, ptr %MEMORY, align 4
  %v8881 = call ptr @__remill_atomic_end(ptr %v8880)
  store ptr %v8881, ptr %MEMORY, align 4
  store i32 %v8873, ptr %PC, align 4
  %v8882 = add i32 %v8873, 3
  store i32 %v8882, ptr %NEXT_PC, align 4
  %v8883 = load ptr, ptr %MEMORY, align 4
  %v8884 = call ptr @__remill_atomic_begin(ptr %v8883)
  store ptr %v8884, ptr %MEMORY, align 4
  %v8885 = load i32, ptr %EBP, align 4
  %v8886 = load i32, ptr %SSBASE, align 4
  %v8887 = sub i32 %v8885, 16
  %v8888 = add i32 %v8887, %v8886
  %v8889 = load i32, ptr %EAX, align 4
  %v8890 = load ptr, ptr %MEMORY, align 4
  %v8891 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v8890, ptr %state, i32 %v8888, i32 %v8889)
  store ptr %v8891, ptr %MEMORY, align 4
  %v8892 = load ptr, ptr %MEMORY, align 4
  %v8893 = call ptr @__remill_atomic_end(ptr %v8892)
  store ptr %v8893, ptr %MEMORY, align 4
  store i32 %v8882, ptr %PC, align 4
  %v8894 = add i32 %v8882, 4
  store i32 %v8894, ptr %NEXT_PC, align 4
  %v8895 = load ptr, ptr %MEMORY, align 4
  %v8896 = call ptr @__remill_atomic_begin(ptr %v8895)
  store ptr %v8896, ptr %MEMORY, align 4
  %v8897 = load i32, ptr %EBP, align 4
  %v8898 = load i32, ptr %SSBASE, align 4
  %v8899 = sub i32 %v8897, 16
  %v8900 = add i32 %v8899, %v8898
  %v8901 = load ptr, ptr %MEMORY, align 4
  %v8902 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8901, ptr %state, i32 %v8900, i32 0)
  store ptr %v8902, ptr %MEMORY, align 4
  %v8903 = load ptr, ptr %MEMORY, align 4
  %v8904 = call ptr @__remill_atomic_end(ptr %v8903)
  store ptr %v8904, ptr %MEMORY, align 4
  store i32 %v8894, ptr %PC, align 4
  %v8905 = add i32 %v8894, 2
  store i32 %v8905, ptr %NEXT_PC, align 4
  %v8906 = load ptr, ptr %MEMORY, align 4
  %v8907 = call ptr @__remill_atomic_begin(ptr %v8906)
  store ptr %v8907, ptr %MEMORY, align 4
  %v8908 = add i32 %v8905, 27
  %v8909 = load ptr, ptr %MEMORY, align 4
  %v8910 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v8909, ptr %state, ptr %BRANCH_TAKEN, i32 %v8908, i32 %v8905, ptr %NEXT_PC)
  store ptr %v8910, ptr %MEMORY, align 4
  %v8911 = load ptr, ptr %MEMORY, align 4
  %v8912 = call ptr @__remill_atomic_end(ptr %v8911)
  store ptr %v8912, ptr %MEMORY, align 4
  br i1 true, label %bb_4207607, label %bb_4207580

bb_4207580:                                       ; preds = %bb_4207549
  store i32 %v8905, ptr %PC, align 4
  %v8913 = add i32 %v8905, 2
  store i32 %v8913, ptr %NEXT_PC, align 4
  %v8914 = load ptr, ptr %MEMORY, align 4
  %v8915 = call ptr @__remill_atomic_begin(ptr %v8914)
  store ptr %v8915, ptr %MEMORY, align 4
  %v8916 = add i32 %v8913, 10
  %v8917 = load ptr, ptr %MEMORY, align 4
  %v8918 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v8917, ptr %state, i32 %v8916, ptr %NEXT_PC)
  store ptr %v8918, ptr %MEMORY, align 4
  %v8919 = load ptr, ptr %MEMORY, align 4
  %v8920 = call ptr @__remill_atomic_end(ptr %v8919)
  store ptr %v8920, ptr %MEMORY, align 4
  br label %bb_4207592

bb_4207582:                                       ; preds = %bb_4207592
  store i32 %v9002, ptr %PC, align 4
  %v8921 = add i32 %v9002, 3
  store i32 %v8921, ptr %NEXT_PC, align 4
  %v8922 = load ptr, ptr %MEMORY, align 4
  %v8923 = call ptr @__remill_atomic_begin(ptr %v8922)
  store ptr %v8923, ptr %MEMORY, align 4
  %v8924 = load i32, ptr %EBP, align 4
  %v8925 = load i32, ptr %SSBASE, align 4
  %v8926 = sub i32 %v8924, 12
  %v8927 = add i32 %v8926, %v8925
  %v8928 = load ptr, ptr %MEMORY, align 4
  %v8929 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8928, ptr %state, ptr %EAX, i32 %v8927)
  store ptr %v8929, ptr %MEMORY, align 4
  %v8930 = load ptr, ptr %MEMORY, align 4
  %v8931 = call ptr @__remill_atomic_end(ptr %v8930)
  store ptr %v8931, ptr %MEMORY, align 4
  store i32 %v8921, ptr %PC, align 4
  %v8932 = add i32 %v8921, 3
  store i32 %v8932, ptr %NEXT_PC, align 4
  %v8933 = load ptr, ptr %MEMORY, align 4
  %v8934 = call ptr @__remill_atomic_begin(ptr %v8933)
  store ptr %v8934, ptr %MEMORY, align 4
  %v8935 = load i32, ptr %EAX, align 4
  %v8936 = load i32, ptr %DSBASE, align 4
  %v8937 = add i32 %v8935, %v8936
  %v8938 = load ptr, ptr %MEMORY, align 4
  %v8939 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v8938, ptr %state, i32 %v8937, i32 48)
  store ptr %v8939, ptr %MEMORY, align 4
  %v8940 = load ptr, ptr %MEMORY, align 4
  %v8941 = call ptr @__remill_atomic_end(ptr %v8940)
  store ptr %v8941, ptr %MEMORY, align 4
  store i32 %v8932, ptr %PC, align 4
  %v8942 = add i32 %v8932, 4
  store i32 %v8942, ptr %NEXT_PC, align 4
  %v8943 = load ptr, ptr %MEMORY, align 4
  %v8944 = call ptr @__remill_atomic_begin(ptr %v8943)
  store ptr %v8944, ptr %MEMORY, align 4
  %v8945 = load i32, ptr %EBP, align 4
  %v8946 = load i32, ptr %SSBASE, align 4
  %v8947 = sub i32 %v8945, 12
  %v8948 = add i32 %v8947, %v8946
  %v8949 = load i32, ptr %EBP, align 4
  %v8950 = load i32, ptr %SSBASE, align 4
  %v8951 = sub i32 %v8949, 12
  %v8952 = add i32 %v8951, %v8950
  %v8953 = load ptr, ptr %MEMORY, align 4
  %v8954 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8953, ptr %state, i32 %v8948, i32 %v8952, i32 1)
  store ptr %v8954, ptr %MEMORY, align 4
  %v8955 = load ptr, ptr %MEMORY, align 4
  %v8956 = call ptr @__remill_atomic_end(ptr %v8955)
  store ptr %v8956, ptr %MEMORY, align 4
  br label %bb_4207592

bb_4207592:                                       ; preds = %bb_4207582, %bb_4207580
  %v8957 = load i32, ptr %NEXT_PC, align 4
  store i32 %v8957, ptr %PC, align 4
  %v8958 = add i32 %v8957, 4
  store i32 %v8958, ptr %NEXT_PC, align 4
  %v8959 = load ptr, ptr %MEMORY, align 4
  %v8960 = call ptr @__remill_atomic_begin(ptr %v8959)
  store ptr %v8960, ptr %MEMORY, align 4
  %v8961 = load i32, ptr %EBP, align 4
  %v8962 = load i32, ptr %SSBASE, align 4
  %v8963 = sub i32 %v8961, 16
  %v8964 = add i32 %v8963, %v8962
  %v8965 = load ptr, ptr %MEMORY, align 4
  %v8966 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v8965, ptr %state, i32 %v8964, i32 0)
  store ptr %v8966, ptr %MEMORY, align 4
  %v8967 = load ptr, ptr %MEMORY, align 4
  %v8968 = call ptr @__remill_atomic_end(ptr %v8967)
  store ptr %v8968, ptr %MEMORY, align 4
  store i32 %v8958, ptr %PC, align 4
  %v8969 = add i32 %v8958, 3
  store i32 %v8969, ptr %NEXT_PC, align 4
  %v8970 = load ptr, ptr %MEMORY, align 4
  %v8971 = call ptr @__remill_atomic_begin(ptr %v8970)
  store ptr %v8971, ptr %MEMORY, align 4
  %v8972 = load ptr, ptr %MEMORY, align 4
  %v8973 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v8972, ptr %state, ptr %AL)
  store ptr %v8973, ptr %MEMORY, align 4
  %v8974 = load ptr, ptr %MEMORY, align 4
  %v8975 = call ptr @__remill_atomic_end(ptr %v8974)
  store ptr %v8975, ptr %MEMORY, align 4
  store i32 %v8969, ptr %PC, align 4
  %v8976 = add i32 %v8969, 4
  store i32 %v8976, ptr %NEXT_PC, align 4
  %v8977 = load ptr, ptr %MEMORY, align 4
  %v8978 = call ptr @__remill_atomic_begin(ptr %v8977)
  store ptr %v8978, ptr %MEMORY, align 4
  %v8979 = load i32, ptr %EBP, align 4
  %v8980 = load i32, ptr %SSBASE, align 4
  %v8981 = sub i32 %v8979, 16
  %v8982 = add i32 %v8981, %v8980
  %v8983 = load i32, ptr %EBP, align 4
  %v8984 = load i32, ptr %SSBASE, align 4
  %v8985 = sub i32 %v8983, 16
  %v8986 = add i32 %v8985, %v8984
  %v8987 = load ptr, ptr %MEMORY, align 4
  %v8988 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v8987, ptr %state, i32 %v8982, i32 %v8986, i32 1)
  store ptr %v8988, ptr %MEMORY, align 4
  %v8989 = load ptr, ptr %MEMORY, align 4
  %v8990 = call ptr @__remill_atomic_end(ptr %v8989)
  store ptr %v8990, ptr %MEMORY, align 4
  store i32 %v8976, ptr %PC, align 4
  %v8991 = add i32 %v8976, 2
  store i32 %v8991, ptr %NEXT_PC, align 4
  %v8992 = load ptr, ptr %MEMORY, align 4
  %v8993 = call ptr @__remill_atomic_begin(ptr %v8992)
  store ptr %v8993, ptr %MEMORY, align 4
  %v8994 = load i8, ptr %AL, align 1
  %v8995 = zext i8 %v8994 to i32
  %v8996 = load i8, ptr %AL, align 1
  %v8997 = zext i8 %v8996 to i32
  %v8998 = load ptr, ptr %MEMORY, align 4
  %v8999 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v8998, ptr %state, i32 %v8995, i32 %v8997)
  store ptr %v8999, ptr %MEMORY, align 4
  %v9000 = load ptr, ptr %MEMORY, align 4
  %v9001 = call ptr @__remill_atomic_end(ptr %v9000)
  store ptr %v9001, ptr %MEMORY, align 4
  store i32 %v8991, ptr %PC, align 4
  %v9002 = add i32 %v8991, 2
  store i32 %v9002, ptr %NEXT_PC, align 4
  %v9003 = load ptr, ptr %MEMORY, align 4
  %v9004 = call ptr @__remill_atomic_begin(ptr %v9003)
  store ptr %v9004, ptr %MEMORY, align 4
  %v9005 = sub i32 %v9002, 25
  %v9006 = load ptr, ptr %MEMORY, align 4
  %v9007 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9006, ptr %state, ptr %BRANCH_TAKEN, i32 %v9005, i32 %v9002, ptr %NEXT_PC)
  store ptr %v9007, ptr %MEMORY, align 4
  %v9008 = load ptr, ptr %MEMORY, align 4
  %v9009 = call ptr @__remill_atomic_end(ptr %v9008)
  store ptr %v9009, ptr %MEMORY, align 4
  br i1 true, label %bb_4207582, label %bb_4207607

bb_4207607:                                       ; preds = %bb_4207592, %bb_4207549, %bb_4207539
  %v9010 = load i32, ptr %NEXT_PC, align 4
  store i32 %v9010, ptr %PC, align 4
  %v9011 = add i32 %v9010, 3
  store i32 %v9011, ptr %NEXT_PC, align 4
  %v9012 = load ptr, ptr %MEMORY, align 4
  %v9013 = call ptr @__remill_atomic_begin(ptr %v9012)
  store ptr %v9013, ptr %MEMORY, align 4
  %v9014 = load i32, ptr %EBP, align 4
  %v9015 = load i32, ptr %SSBASE, align 4
  %v9016 = sub i32 %v9014, 24
  %v9017 = add i32 %v9016, %v9015
  %v9018 = load ptr, ptr %MEMORY, align 4
  %v9019 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9018, ptr %state, ptr %EAX, i32 %v9017)
  store ptr %v9019, ptr %MEMORY, align 4
  %v9020 = load ptr, ptr %MEMORY, align 4
  %v9021 = call ptr @__remill_atomic_end(ptr %v9020)
  store ptr %v9021, ptr %MEMORY, align 4
  store i32 %v9011, ptr %PC, align 4
  %v9022 = add i32 %v9011, 3
  store i32 %v9022, ptr %NEXT_PC, align 4
  %v9023 = load ptr, ptr %MEMORY, align 4
  %v9024 = call ptr @__remill_atomic_begin(ptr %v9023)
  store ptr %v9024, ptr %MEMORY, align 4
  %v9025 = load i32, ptr %EAX, align 4
  %v9026 = load i32, ptr %EBP, align 4
  %v9027 = load i32, ptr %SSBASE, align 4
  %v9028 = sub i32 %v9026, 12
  %v9029 = add i32 %v9028, %v9027
  %v9030 = load ptr, ptr %MEMORY, align 4
  %v9031 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9030, ptr %state, i32 %v9025, i32 %v9029)
  store ptr %v9031, ptr %MEMORY, align 4
  %v9032 = load ptr, ptr %MEMORY, align 4
  %v9033 = call ptr @__remill_atomic_end(ptr %v9032)
  store ptr %v9033, ptr %MEMORY, align 4
  store i32 %v9022, ptr %PC, align 4
  %v9034 = add i32 %v9022, 2
  store i32 %v9034, ptr %NEXT_PC, align 4
  %v9035 = load ptr, ptr %MEMORY, align 4
  %v9036 = call ptr @__remill_atomic_begin(ptr %v9035)
  store ptr %v9036, ptr %MEMORY, align 4
  %v9037 = add i32 %v9034, 20
  %v9038 = load ptr, ptr %MEMORY, align 4
  %v9039 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9038, ptr %state, ptr %BRANCH_TAKEN, i32 %v9037, i32 %v9034, ptr %NEXT_PC)
  store ptr %v9039, ptr %MEMORY, align 4
  %v9040 = load ptr, ptr %MEMORY, align 4
  %v9041 = call ptr @__remill_atomic_end(ptr %v9040)
  store ptr %v9041, ptr %MEMORY, align 4
  br i1 true, label %bb_4207635, label %bb_4207615

bb_4207615:                                       ; preds = %bb_4207607
  store i32 %v9034, ptr %PC, align 4
  %v9042 = add i32 %v9034, 3
  store i32 %v9042, ptr %NEXT_PC, align 4
  %v9043 = load ptr, ptr %MEMORY, align 4
  %v9044 = call ptr @__remill_atomic_begin(ptr %v9043)
  store ptr %v9044, ptr %MEMORY, align 4
  %v9045 = load i32, ptr %EBP, align 4
  %v9046 = load i32, ptr %SSBASE, align 4
  %v9047 = add i32 %v9045, 16
  %v9048 = add i32 %v9047, %v9046
  %v9049 = load ptr, ptr %MEMORY, align 4
  %v9050 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9049, ptr %state, ptr %EAX, i32 %v9048)
  store ptr %v9050, ptr %MEMORY, align 4
  %v9051 = load ptr, ptr %MEMORY, align 4
  %v9052 = call ptr @__remill_atomic_end(ptr %v9051)
  store ptr %v9052, ptr %MEMORY, align 4
  store i32 %v9042, ptr %PC, align 4
  %v9053 = add i32 %v9042, 3
  store i32 %v9053, ptr %NEXT_PC, align 4
  %v9054 = load ptr, ptr %MEMORY, align 4
  %v9055 = call ptr @__remill_atomic_begin(ptr %v9054)
  store ptr %v9055, ptr %MEMORY, align 4
  %v9056 = load i32, ptr %EAX, align 4
  %v9057 = load i32, ptr %DSBASE, align 4
  %v9058 = add i32 %v9056, 12
  %v9059 = add i32 %v9058, %v9057
  %v9060 = load ptr, ptr %MEMORY, align 4
  %v9061 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9060, ptr %state, ptr %EAX, i32 %v9059)
  store ptr %v9061, ptr %MEMORY, align 4
  %v9062 = load ptr, ptr %MEMORY, align 4
  %v9063 = call ptr @__remill_atomic_end(ptr %v9062)
  store ptr %v9063, ptr %MEMORY, align 4
  store i32 %v9053, ptr %PC, align 4
  %v9064 = add i32 %v9053, 2
  store i32 %v9064, ptr %NEXT_PC, align 4
  %v9065 = load ptr, ptr %MEMORY, align 4
  %v9066 = call ptr @__remill_atomic_begin(ptr %v9065)
  store ptr %v9066, ptr %MEMORY, align 4
  %v9067 = load i32, ptr %EAX, align 4
  %v9068 = load i32, ptr %EAX, align 4
  %v9069 = load ptr, ptr %MEMORY, align 4
  %v9070 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9069, ptr %state, i32 %v9067, i32 %v9068)
  store ptr %v9070, ptr %MEMORY, align 4
  %v9071 = load ptr, ptr %MEMORY, align 4
  %v9072 = call ptr @__remill_atomic_end(ptr %v9071)
  store ptr %v9072, ptr %MEMORY, align 4
  store i32 %v9064, ptr %PC, align 4
  %v9073 = add i32 %v9064, 2
  store i32 %v9073, ptr %NEXT_PC, align 4
  %v9074 = load ptr, ptr %MEMORY, align 4
  %v9075 = call ptr @__remill_atomic_begin(ptr %v9074)
  store ptr %v9075, ptr %MEMORY, align 4
  %v9076 = add i32 %v9073, 10
  %v9077 = load ptr, ptr %MEMORY, align 4
  %v9078 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9077, ptr %state, ptr %BRANCH_TAKEN, i32 %v9076, i32 %v9073, ptr %NEXT_PC)
  store ptr %v9078, ptr %MEMORY, align 4
  %v9079 = load ptr, ptr %MEMORY, align 4
  %v9080 = call ptr @__remill_atomic_end(ptr %v9079)
  store ptr %v9080, ptr %MEMORY, align 4
  br i1 true, label %bb_4207635, label %bb_4207625

bb_4207625:                                       ; preds = %bb_4207615
  store i32 %v9073, ptr %PC, align 4
  %v9081 = add i32 %v9073, 3
  store i32 %v9081, ptr %NEXT_PC, align 4
  %v9082 = load ptr, ptr %MEMORY, align 4
  %v9083 = call ptr @__remill_atomic_begin(ptr %v9082)
  store ptr %v9083, ptr %MEMORY, align 4
  %v9084 = load i32, ptr %EBP, align 4
  %v9085 = load i32, ptr %SSBASE, align 4
  %v9086 = sub i32 %v9084, 12
  %v9087 = add i32 %v9086, %v9085
  %v9088 = load ptr, ptr %MEMORY, align 4
  %v9089 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9088, ptr %state, ptr %EAX, i32 %v9087)
  store ptr %v9089, ptr %MEMORY, align 4
  %v9090 = load ptr, ptr %MEMORY, align 4
  %v9091 = call ptr @__remill_atomic_end(ptr %v9090)
  store ptr %v9091, ptr %MEMORY, align 4
  store i32 %v9081, ptr %PC, align 4
  %v9092 = add i32 %v9081, 3
  store i32 %v9092, ptr %NEXT_PC, align 4
  %v9093 = load ptr, ptr %MEMORY, align 4
  %v9094 = call ptr @__remill_atomic_begin(ptr %v9093)
  store ptr %v9094, ptr %MEMORY, align 4
  %v9095 = load i32, ptr %EAX, align 4
  %v9096 = load i32, ptr %DSBASE, align 4
  %v9097 = add i32 %v9095, %v9096
  %v9098 = load ptr, ptr %MEMORY, align 4
  %v9099 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v9098, ptr %state, i32 %v9097, i32 48)
  store ptr %v9099, ptr %MEMORY, align 4
  %v9100 = load ptr, ptr %MEMORY, align 4
  %v9101 = call ptr @__remill_atomic_end(ptr %v9100)
  store ptr %v9101, ptr %MEMORY, align 4
  store i32 %v9092, ptr %PC, align 4
  %v9102 = add i32 %v9092, 4
  store i32 %v9102, ptr %NEXT_PC, align 4
  %v9103 = load ptr, ptr %MEMORY, align 4
  %v9104 = call ptr @__remill_atomic_begin(ptr %v9103)
  store ptr %v9104, ptr %MEMORY, align 4
  %v9105 = load i32, ptr %EBP, align 4
  %v9106 = load i32, ptr %SSBASE, align 4
  %v9107 = sub i32 %v9105, 12
  %v9108 = add i32 %v9107, %v9106
  %v9109 = load i32, ptr %EBP, align 4
  %v9110 = load i32, ptr %SSBASE, align 4
  %v9111 = sub i32 %v9109, 12
  %v9112 = add i32 %v9111, %v9110
  %v9113 = load ptr, ptr %MEMORY, align 4
  %v9114 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9113, ptr %state, i32 %v9108, i32 %v9112, i32 1)
  store ptr %v9114, ptr %MEMORY, align 4
  %v9115 = load ptr, ptr %MEMORY, align 4
  %v9116 = call ptr @__remill_atomic_end(ptr %v9115)
  store ptr %v9116, ptr %MEMORY, align 4
  br label %bb_4207635

bb_4207635:                                       ; preds = %bb_4207625, %bb_4207615, %bb_4207607
  %v9117 = load i32, ptr %NEXT_PC, align 4
  store i32 %v9117, ptr %PC, align 4
  %v9118 = add i32 %v9117, 3
  store i32 %v9118, ptr %NEXT_PC, align 4
  %v9119 = load ptr, ptr %MEMORY, align 4
  %v9120 = call ptr @__remill_atomic_begin(ptr %v9119)
  store ptr %v9120, ptr %MEMORY, align 4
  %v9121 = load i32, ptr %EBP, align 4
  %v9122 = load i32, ptr %SSBASE, align 4
  %v9123 = add i32 %v9121, 16
  %v9124 = add i32 %v9123, %v9122
  %v9125 = load ptr, ptr %MEMORY, align 4
  %v9126 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9125, ptr %state, ptr %EAX, i32 %v9124)
  store ptr %v9126, ptr %MEMORY, align 4
  %v9127 = load ptr, ptr %MEMORY, align 4
  %v9128 = call ptr @__remill_atomic_end(ptr %v9127)
  store ptr %v9128, ptr %MEMORY, align 4
  store i32 %v9118, ptr %PC, align 4
  %v9129 = add i32 %v9118, 3
  store i32 %v9129, ptr %NEXT_PC, align 4
  %v9130 = load ptr, ptr %MEMORY, align 4
  %v9131 = call ptr @__remill_atomic_begin(ptr %v9130)
  store ptr %v9131, ptr %MEMORY, align 4
  %v9132 = load i32, ptr %EAX, align 4
  %v9133 = load i32, ptr %DSBASE, align 4
  %v9134 = add i32 %v9132, 8
  %v9135 = add i32 %v9134, %v9133
  %v9136 = load ptr, ptr %MEMORY, align 4
  %v9137 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9136, ptr %state, ptr %EAX, i32 %v9135)
  store ptr %v9137, ptr %MEMORY, align 4
  %v9138 = load ptr, ptr %MEMORY, align 4
  %v9139 = call ptr @__remill_atomic_end(ptr %v9138)
  store ptr %v9139, ptr %MEMORY, align 4
  store i32 %v9129, ptr %PC, align 4
  %v9140 = add i32 %v9129, 2
  store i32 %v9140, ptr %NEXT_PC, align 4
  %v9141 = load ptr, ptr %MEMORY, align 4
  %v9142 = call ptr @__remill_atomic_begin(ptr %v9141)
  store ptr %v9142, ptr %MEMORY, align 4
  %v9143 = load i32, ptr %EAX, align 4
  %v9144 = load i32, ptr %EAX, align 4
  %v9145 = load ptr, ptr %MEMORY, align 4
  %v9146 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9145, ptr %state, i32 %v9143, i32 %v9144)
  store ptr %v9146, ptr %MEMORY, align 4
  %v9147 = load ptr, ptr %MEMORY, align 4
  %v9148 = call ptr @__remill_atomic_end(ptr %v9147)
  store ptr %v9148, ptr %MEMORY, align 4
  store i32 %v9140, ptr %PC, align 4
  %v9149 = add i32 %v9140, 6
  store i32 %v9149, ptr %NEXT_PC, align 4
  %v9150 = load ptr, ptr %MEMORY, align 4
  %v9151 = call ptr @__remill_atomic_begin(ptr %v9150)
  store ptr %v9151, ptr %MEMORY, align 4
  %v9152 = add i32 %v9149, 198
  %v9153 = load ptr, ptr %MEMORY, align 4
  %v9154 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9153, ptr %state, ptr %BRANCH_TAKEN, i32 %v9152, i32 %v9149, ptr %NEXT_PC)
  store ptr %v9154, ptr %MEMORY, align 4
  %v9155 = load ptr, ptr %MEMORY, align 4
  %v9156 = call ptr @__remill_atomic_end(ptr %v9155)
  store ptr %v9156, ptr %MEMORY, align 4
  br i1 true, label %bb_4207847, label %bb_4207649

bb_4207649:                                       ; preds = %bb_4207635
  store i32 %v9149, ptr %PC, align 4
  %v9157 = add i32 %v9149, 3
  store i32 %v9157, ptr %NEXT_PC, align 4
  %v9158 = load ptr, ptr %MEMORY, align 4
  %v9159 = call ptr @__remill_atomic_begin(ptr %v9158)
  store ptr %v9159, ptr %MEMORY, align 4
  %v9160 = load i32, ptr %EBP, align 4
  %v9161 = load i32, ptr %SSBASE, align 4
  %v9162 = add i32 %v9160, 16
  %v9163 = add i32 %v9162, %v9161
  %v9164 = load ptr, ptr %MEMORY, align 4
  %v9165 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9164, ptr %state, ptr %EAX, i32 %v9163)
  store ptr %v9165, ptr %MEMORY, align 4
  %v9166 = load ptr, ptr %MEMORY, align 4
  %v9167 = call ptr @__remill_atomic_end(ptr %v9166)
  store ptr %v9167, ptr %MEMORY, align 4
  store i32 %v9157, ptr %PC, align 4
  %v9168 = add i32 %v9157, 3
  store i32 %v9168, ptr %NEXT_PC, align 4
  %v9169 = load ptr, ptr %MEMORY, align 4
  %v9170 = call ptr @__remill_atomic_begin(ptr %v9169)
  store ptr %v9170, ptr %MEMORY, align 4
  %v9171 = load i32, ptr %EAX, align 4
  %v9172 = load i32, ptr %DSBASE, align 4
  %v9173 = add i32 %v9171, 8
  %v9174 = add i32 %v9173, %v9172
  %v9175 = load ptr, ptr %MEMORY, align 4
  %v9176 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9175, ptr %state, ptr %EAX, i32 %v9174)
  store ptr %v9176, ptr %MEMORY, align 4
  %v9177 = load ptr, ptr %MEMORY, align 4
  %v9178 = call ptr @__remill_atomic_end(ptr %v9177)
  store ptr %v9178, ptr %MEMORY, align 4
  store i32 %v9168, ptr %PC, align 4
  %v9179 = add i32 %v9168, 3
  store i32 %v9179, ptr %NEXT_PC, align 4
  %v9180 = load ptr, ptr %MEMORY, align 4
  %v9181 = call ptr @__remill_atomic_begin(ptr %v9180)
  store ptr %v9181, ptr %MEMORY, align 4
  %v9182 = load i32, ptr %EBP, align 4
  %v9183 = load i32, ptr %SSBASE, align 4
  %v9184 = sub i32 %v9182, 24
  %v9185 = add i32 %v9184, %v9183
  %v9186 = load ptr, ptr %MEMORY, align 4
  %v9187 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9186, ptr %state, ptr %EDX, i32 %v9185)
  store ptr %v9187, ptr %MEMORY, align 4
  %v9188 = load ptr, ptr %MEMORY, align 4
  %v9189 = call ptr @__remill_atomic_end(ptr %v9188)
  store ptr %v9189, ptr %MEMORY, align 4
  store i32 %v9179, ptr %PC, align 4
  %v9190 = add i32 %v9179, 2
  store i32 %v9190, ptr %NEXT_PC, align 4
  %v9191 = load ptr, ptr %MEMORY, align 4
  %v9192 = call ptr @__remill_atomic_begin(ptr %v9191)
  store ptr %v9192, ptr %MEMORY, align 4
  %v9193 = load i32, ptr %EDX, align 4
  %v9194 = load ptr, ptr %MEMORY, align 4
  %v9195 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9194, ptr %state, ptr %ECX, i32 %v9193)
  store ptr %v9195, ptr %MEMORY, align 4
  %v9196 = load ptr, ptr %MEMORY, align 4
  %v9197 = call ptr @__remill_atomic_end(ptr %v9196)
  store ptr %v9197, ptr %MEMORY, align 4
  store i32 %v9190, ptr %PC, align 4
  %v9198 = add i32 %v9190, 3
  store i32 %v9198, ptr %NEXT_PC, align 4
  %v9199 = load ptr, ptr %MEMORY, align 4
  %v9200 = call ptr @__remill_atomic_begin(ptr %v9199)
  store ptr %v9200, ptr %MEMORY, align 4
  %v9201 = load i32, ptr %EBP, align 4
  %v9202 = load i32, ptr %SSBASE, align 4
  %v9203 = sub i32 %v9201, 12
  %v9204 = add i32 %v9203, %v9202
  %v9205 = load ptr, ptr %MEMORY, align 4
  %v9206 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9205, ptr %state, ptr %EDX, i32 %v9204)
  store ptr %v9206, ptr %MEMORY, align 4
  %v9207 = load ptr, ptr %MEMORY, align 4
  %v9208 = call ptr @__remill_atomic_end(ptr %v9207)
  store ptr %v9208, ptr %MEMORY, align 4
  store i32 %v9198, ptr %PC, align 4
  %v9209 = add i32 %v9198, 2
  store i32 %v9209, ptr %NEXT_PC, align 4
  %v9210 = load ptr, ptr %MEMORY, align 4
  %v9211 = call ptr @__remill_atomic_begin(ptr %v9210)
  store ptr %v9211, ptr %MEMORY, align 4
  %v9212 = load i32, ptr %ECX, align 4
  %v9213 = load ptr, ptr %MEMORY, align 4
  %v9214 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9213, ptr %state, ptr %ESI, i32 %v9212)
  store ptr %v9214, ptr %MEMORY, align 4
  %v9215 = load ptr, ptr %MEMORY, align 4
  %v9216 = call ptr @__remill_atomic_end(ptr %v9215)
  store ptr %v9216, ptr %MEMORY, align 4
  store i32 %v9209, ptr %PC, align 4
  %v9217 = add i32 %v9209, 2
  store i32 %v9217, ptr %NEXT_PC, align 4
  %v9218 = load ptr, ptr %MEMORY, align 4
  %v9219 = call ptr @__remill_atomic_begin(ptr %v9218)
  store ptr %v9219, ptr %MEMORY, align 4
  %v9220 = load i32, ptr %ESI, align 4
  %v9221 = load i32, ptr %EDX, align 4
  %v9222 = load ptr, ptr %MEMORY, align 4
  %v9223 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v9222, ptr %state, ptr %ESI, i32 %v9220, i32 %v9221)
  store ptr %v9223, ptr %MEMORY, align 4
  %v9224 = load ptr, ptr %MEMORY, align 4
  %v9225 = call ptr @__remill_atomic_end(ptr %v9224)
  store ptr %v9225, ptr %MEMORY, align 4
  store i32 %v9217, ptr %PC, align 4
  %v9226 = add i32 %v9217, 2
  store i32 %v9226, ptr %NEXT_PC, align 4
  %v9227 = load ptr, ptr %MEMORY, align 4
  %v9228 = call ptr @__remill_atomic_begin(ptr %v9227)
  store ptr %v9228, ptr %MEMORY, align 4
  %v9229 = load i32, ptr %ESI, align 4
  %v9230 = load ptr, ptr %MEMORY, align 4
  %v9231 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9230, ptr %state, ptr %EDX, i32 %v9229)
  store ptr %v9231, ptr %MEMORY, align 4
  %v9232 = load ptr, ptr %MEMORY, align 4
  %v9233 = call ptr @__remill_atomic_end(ptr %v9232)
  store ptr %v9233, ptr %MEMORY, align 4
  store i32 %v9226, ptr %PC, align 4
  %v9234 = add i32 %v9226, 2
  store i32 %v9234, ptr %NEXT_PC, align 4
  %v9235 = load ptr, ptr %MEMORY, align 4
  %v9236 = call ptr @__remill_atomic_begin(ptr %v9235)
  store ptr %v9236, ptr %MEMORY, align 4
  %v9237 = load i32, ptr %EDX, align 4
  %v9238 = load i32, ptr %EAX, align 4
  %v9239 = load ptr, ptr %MEMORY, align 4
  %v9240 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v9239, ptr %state, ptr %EDX, i32 %v9237, i32 %v9238)
  store ptr %v9240, ptr %MEMORY, align 4
  %v9241 = load ptr, ptr %MEMORY, align 4
  %v9242 = call ptr @__remill_atomic_end(ptr %v9241)
  store ptr %v9242, ptr %MEMORY, align 4
  store i32 %v9234, ptr %PC, align 4
  %v9243 = add i32 %v9234, 3
  store i32 %v9243, ptr %NEXT_PC, align 4
  %v9244 = load ptr, ptr %MEMORY, align 4
  %v9245 = call ptr @__remill_atomic_begin(ptr %v9244)
  store ptr %v9245, ptr %MEMORY, align 4
  %v9246 = load i32, ptr %EBP, align 4
  %v9247 = load i32, ptr %SSBASE, align 4
  %v9248 = add i32 %v9246, 16
  %v9249 = add i32 %v9248, %v9247
  %v9250 = load ptr, ptr %MEMORY, align 4
  %v9251 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9250, ptr %state, ptr %EAX, i32 %v9249)
  store ptr %v9251, ptr %MEMORY, align 4
  %v9252 = load ptr, ptr %MEMORY, align 4
  %v9253 = call ptr @__remill_atomic_end(ptr %v9252)
  store ptr %v9253, ptr %MEMORY, align 4
  store i32 %v9243, ptr %PC, align 4
  %v9254 = add i32 %v9243, 3
  store i32 %v9254, ptr %NEXT_PC, align 4
  %v9255 = load ptr, ptr %MEMORY, align 4
  %v9256 = call ptr @__remill_atomic_begin(ptr %v9255)
  store ptr %v9256, ptr %MEMORY, align 4
  %v9257 = load i32, ptr %EAX, align 4
  %v9258 = load i32, ptr %DSBASE, align 4
  %v9259 = add i32 %v9257, 8
  %v9260 = add i32 %v9259, %v9258
  %v9261 = load i32, ptr %EDX, align 4
  %v9262 = load ptr, ptr %MEMORY, align 4
  %v9263 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9262, ptr %state, i32 %v9260, i32 %v9261)
  store ptr %v9263, ptr %MEMORY, align 4
  %v9264 = load ptr, ptr %MEMORY, align 4
  %v9265 = call ptr @__remill_atomic_end(ptr %v9264)
  store ptr %v9265, ptr %MEMORY, align 4
  store i32 %v9254, ptr %PC, align 4
  %v9266 = add i32 %v9254, 3
  store i32 %v9266, ptr %NEXT_PC, align 4
  %v9267 = load ptr, ptr %MEMORY, align 4
  %v9268 = call ptr @__remill_atomic_begin(ptr %v9267)
  store ptr %v9268, ptr %MEMORY, align 4
  %v9269 = load i32, ptr %EBP, align 4
  %v9270 = load i32, ptr %SSBASE, align 4
  %v9271 = add i32 %v9269, 16
  %v9272 = add i32 %v9271, %v9270
  %v9273 = load ptr, ptr %MEMORY, align 4
  %v9274 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9273, ptr %state, ptr %EAX, i32 %v9272)
  store ptr %v9274, ptr %MEMORY, align 4
  %v9275 = load ptr, ptr %MEMORY, align 4
  %v9276 = call ptr @__remill_atomic_end(ptr %v9275)
  store ptr %v9276, ptr %MEMORY, align 4
  store i32 %v9266, ptr %PC, align 4
  %v9277 = add i32 %v9266, 3
  store i32 %v9277, ptr %NEXT_PC, align 4
  %v9278 = load ptr, ptr %MEMORY, align 4
  %v9279 = call ptr @__remill_atomic_begin(ptr %v9278)
  store ptr %v9279, ptr %MEMORY, align 4
  %v9280 = load i32, ptr %EAX, align 4
  %v9281 = load i32, ptr %DSBASE, align 4
  %v9282 = add i32 %v9280, 8
  %v9283 = add i32 %v9282, %v9281
  %v9284 = load ptr, ptr %MEMORY, align 4
  %v9285 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9284, ptr %state, ptr %EAX, i32 %v9283)
  store ptr %v9285, ptr %MEMORY, align 4
  %v9286 = load ptr, ptr %MEMORY, align 4
  %v9287 = call ptr @__remill_atomic_end(ptr %v9286)
  store ptr %v9287, ptr %MEMORY, align 4
  store i32 %v9277, ptr %PC, align 4
  %v9288 = add i32 %v9277, 2
  store i32 %v9288, ptr %NEXT_PC, align 4
  %v9289 = load ptr, ptr %MEMORY, align 4
  %v9290 = call ptr @__remill_atomic_begin(ptr %v9289)
  store ptr %v9290, ptr %MEMORY, align 4
  %v9291 = load i32, ptr %EAX, align 4
  %v9292 = load i32, ptr %EAX, align 4
  %v9293 = load ptr, ptr %MEMORY, align 4
  %v9294 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9293, ptr %state, i32 %v9291, i32 %v9292)
  store ptr %v9294, ptr %MEMORY, align 4
  %v9295 = load ptr, ptr %MEMORY, align 4
  %v9296 = call ptr @__remill_atomic_end(ptr %v9295)
  store ptr %v9296, ptr %MEMORY, align 4
  store i32 %v9288, ptr %PC, align 4
  %v9297 = add i32 %v9288, 6
  store i32 %v9297, ptr %NEXT_PC, align 4
  %v9298 = load ptr, ptr %MEMORY, align 4
  %v9299 = call ptr @__remill_atomic_begin(ptr %v9298)
  store ptr %v9299, ptr %MEMORY, align 4
  %v9300 = add i32 %v9297, 156
  %v9301 = load ptr, ptr %MEMORY, align 4
  %v9302 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9301, ptr %state, ptr %BRANCH_TAKEN, i32 %v9300, i32 %v9297, ptr %NEXT_PC)
  store ptr %v9302, ptr %MEMORY, align 4
  %v9303 = load ptr, ptr %MEMORY, align 4
  %v9304 = call ptr @__remill_atomic_end(ptr %v9303)
  store ptr %v9304, ptr %MEMORY, align 4
  br i1 true, label %bb_4207847, label %bb_4207691

bb_4207691:                                       ; preds = %bb_4207649
  store i32 %v9297, ptr %PC, align 4
  %v9305 = add i32 %v9297, 3
  store i32 %v9305, ptr %NEXT_PC, align 4
  %v9306 = load ptr, ptr %MEMORY, align 4
  %v9307 = call ptr @__remill_atomic_begin(ptr %v9306)
  store ptr %v9307, ptr %MEMORY, align 4
  %v9308 = load i32, ptr %EBP, align 4
  %v9309 = load i32, ptr %SSBASE, align 4
  %v9310 = add i32 %v9308, 16
  %v9311 = add i32 %v9310, %v9309
  %v9312 = load ptr, ptr %MEMORY, align 4
  %v9313 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9312, ptr %state, ptr %EAX, i32 %v9311)
  store ptr %v9313, ptr %MEMORY, align 4
  %v9314 = load ptr, ptr %MEMORY, align 4
  %v9315 = call ptr @__remill_atomic_end(ptr %v9314)
  store ptr %v9315, ptr %MEMORY, align 4
  store i32 %v9305, ptr %PC, align 4
  %v9316 = add i32 %v9305, 3
  store i32 %v9316, ptr %NEXT_PC, align 4
  %v9317 = load ptr, ptr %MEMORY, align 4
  %v9318 = call ptr @__remill_atomic_begin(ptr %v9317)
  store ptr %v9318, ptr %MEMORY, align 4
  %v9319 = load i32, ptr %EAX, align 4
  %v9320 = load i32, ptr %DSBASE, align 4
  %v9321 = add i32 %v9319, 4
  %v9322 = add i32 %v9321, %v9320
  %v9323 = load ptr, ptr %MEMORY, align 4
  %v9324 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9323, ptr %state, ptr %EAX, i32 %v9322)
  store ptr %v9324, ptr %MEMORY, align 4
  %v9325 = load ptr, ptr %MEMORY, align 4
  %v9326 = call ptr @__remill_atomic_end(ptr %v9325)
  store ptr %v9326, ptr %MEMORY, align 4
  store i32 %v9316, ptr %PC, align 4
  %v9327 = add i32 %v9316, 5
  store i32 %v9327, ptr %NEXT_PC, align 4
  %v9328 = load ptr, ptr %MEMORY, align 4
  %v9329 = call ptr @__remill_atomic_begin(ptr %v9328)
  store ptr %v9329, ptr %MEMORY, align 4
  %v9330 = load i32, ptr %EAX, align 4
  %v9331 = load ptr, ptr %MEMORY, align 4
  %v9332 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9331, ptr %state, ptr %EAX, i32 %v9330, i32 448)
  store ptr %v9332, ptr %MEMORY, align 4
  %v9333 = load ptr, ptr %MEMORY, align 4
  %v9334 = call ptr @__remill_atomic_end(ptr %v9333)
  store ptr %v9334, ptr %MEMORY, align 4
  store i32 %v9327, ptr %PC, align 4
  %v9335 = add i32 %v9327, 2
  store i32 %v9335, ptr %NEXT_PC, align 4
  %v9336 = load ptr, ptr %MEMORY, align 4
  %v9337 = call ptr @__remill_atomic_begin(ptr %v9336)
  store ptr %v9337, ptr %MEMORY, align 4
  %v9338 = load i32, ptr %EAX, align 4
  %v9339 = load i32, ptr %EAX, align 4
  %v9340 = load ptr, ptr %MEMORY, align 4
  %v9341 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9340, ptr %state, i32 %v9338, i32 %v9339)
  store ptr %v9341, ptr %MEMORY, align 4
  %v9342 = load ptr, ptr %MEMORY, align 4
  %v9343 = call ptr @__remill_atomic_end(ptr %v9342)
  store ptr %v9343, ptr %MEMORY, align 4
  store i32 %v9335, ptr %PC, align 4
  %v9344 = add i32 %v9335, 2
  store i32 %v9344, ptr %NEXT_PC, align 4
  %v9345 = load ptr, ptr %MEMORY, align 4
  %v9346 = call ptr @__remill_atomic_begin(ptr %v9345)
  store ptr %v9346, ptr %MEMORY, align 4
  %v9347 = add i32 %v9344, 15
  %v9348 = load ptr, ptr %MEMORY, align 4
  %v9349 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9348, ptr %state, ptr %BRANCH_TAKEN, i32 %v9347, i32 %v9344, ptr %NEXT_PC)
  store ptr %v9349, ptr %MEMORY, align 4
  %v9350 = load ptr, ptr %MEMORY, align 4
  %v9351 = call ptr @__remill_atomic_end(ptr %v9350)
  store ptr %v9351, ptr %MEMORY, align 4
  br i1 true, label %bb_4207721, label %bb_4207706

bb_4207706:                                       ; preds = %bb_4207691
  store i32 %v9344, ptr %PC, align 4
  %v9352 = add i32 %v9344, 3
  store i32 %v9352, ptr %NEXT_PC, align 4
  %v9353 = load ptr, ptr %MEMORY, align 4
  %v9354 = call ptr @__remill_atomic_begin(ptr %v9353)
  store ptr %v9354, ptr %MEMORY, align 4
  %v9355 = load i32, ptr %EBP, align 4
  %v9356 = load i32, ptr %SSBASE, align 4
  %v9357 = add i32 %v9355, 16
  %v9358 = add i32 %v9357, %v9356
  %v9359 = load ptr, ptr %MEMORY, align 4
  %v9360 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9359, ptr %state, ptr %EAX, i32 %v9358)
  store ptr %v9360, ptr %MEMORY, align 4
  %v9361 = load ptr, ptr %MEMORY, align 4
  %v9362 = call ptr @__remill_atomic_end(ptr %v9361)
  store ptr %v9362, ptr %MEMORY, align 4
  store i32 %v9352, ptr %PC, align 4
  %v9363 = add i32 %v9352, 3
  store i32 %v9363, ptr %NEXT_PC, align 4
  %v9364 = load ptr, ptr %MEMORY, align 4
  %v9365 = call ptr @__remill_atomic_begin(ptr %v9364)
  store ptr %v9365, ptr %MEMORY, align 4
  %v9366 = load i32, ptr %EAX, align 4
  %v9367 = load i32, ptr %DSBASE, align 4
  %v9368 = add i32 %v9366, 8
  %v9369 = add i32 %v9368, %v9367
  %v9370 = load ptr, ptr %MEMORY, align 4
  %v9371 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9370, ptr %state, ptr %EAX, i32 %v9369)
  store ptr %v9371, ptr %MEMORY, align 4
  %v9372 = load ptr, ptr %MEMORY, align 4
  %v9373 = call ptr @__remill_atomic_end(ptr %v9372)
  store ptr %v9373, ptr %MEMORY, align 4
  store i32 %v9363, ptr %PC, align 4
  %v9374 = add i32 %v9363, 3
  store i32 %v9374, ptr %NEXT_PC, align 4
  %v9375 = load ptr, ptr %MEMORY, align 4
  %v9376 = call ptr @__remill_atomic_begin(ptr %v9375)
  store ptr %v9376, ptr %MEMORY, align 4
  %v9377 = load i32, ptr %EAX, align 4
  %v9378 = sub i32 %v9377, 1
  %v9379 = load ptr, ptr %MEMORY, align 4
  %v9380 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v9379, ptr %state, ptr %EDX, i32 %v9378)
  store ptr %v9380, ptr %MEMORY, align 4
  %v9381 = load ptr, ptr %MEMORY, align 4
  %v9382 = call ptr @__remill_atomic_end(ptr %v9381)
  store ptr %v9382, ptr %MEMORY, align 4
  store i32 %v9374, ptr %PC, align 4
  %v9383 = add i32 %v9374, 3
  store i32 %v9383, ptr %NEXT_PC, align 4
  %v9384 = load ptr, ptr %MEMORY, align 4
  %v9385 = call ptr @__remill_atomic_begin(ptr %v9384)
  store ptr %v9385, ptr %MEMORY, align 4
  %v9386 = load i32, ptr %EBP, align 4
  %v9387 = load i32, ptr %SSBASE, align 4
  %v9388 = add i32 %v9386, 16
  %v9389 = add i32 %v9388, %v9387
  %v9390 = load ptr, ptr %MEMORY, align 4
  %v9391 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9390, ptr %state, ptr %EAX, i32 %v9389)
  store ptr %v9391, ptr %MEMORY, align 4
  %v9392 = load ptr, ptr %MEMORY, align 4
  %v9393 = call ptr @__remill_atomic_end(ptr %v9392)
  store ptr %v9393, ptr %MEMORY, align 4
  store i32 %v9383, ptr %PC, align 4
  %v9394 = add i32 %v9383, 3
  store i32 %v9394, ptr %NEXT_PC, align 4
  %v9395 = load ptr, ptr %MEMORY, align 4
  %v9396 = call ptr @__remill_atomic_begin(ptr %v9395)
  store ptr %v9396, ptr %MEMORY, align 4
  %v9397 = load i32, ptr %EAX, align 4
  %v9398 = load i32, ptr %DSBASE, align 4
  %v9399 = add i32 %v9397, 8
  %v9400 = add i32 %v9399, %v9398
  %v9401 = load i32, ptr %EDX, align 4
  %v9402 = load ptr, ptr %MEMORY, align 4
  %v9403 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9402, ptr %state, i32 %v9400, i32 %v9401)
  store ptr %v9403, ptr %MEMORY, align 4
  %v9404 = load ptr, ptr %MEMORY, align 4
  %v9405 = call ptr @__remill_atomic_end(ptr %v9404)
  store ptr %v9405, ptr %MEMORY, align 4
  br label %bb_4207721

bb_4207721:                                       ; preds = %bb_4207706, %bb_4207691
  %v9406 = load i32, ptr %NEXT_PC, align 4
  store i32 %v9406, ptr %PC, align 4
  %v9407 = add i32 %v9406, 3
  store i32 %v9407, ptr %NEXT_PC, align 4
  %v9408 = load ptr, ptr %MEMORY, align 4
  %v9409 = call ptr @__remill_atomic_begin(ptr %v9408)
  store ptr %v9409, ptr %MEMORY, align 4
  %v9410 = load i32, ptr %EBP, align 4
  %v9411 = load i32, ptr %SSBASE, align 4
  %v9412 = add i32 %v9410, 16
  %v9413 = add i32 %v9412, %v9411
  %v9414 = load ptr, ptr %MEMORY, align 4
  %v9415 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9414, ptr %state, ptr %EAX, i32 %v9413)
  store ptr %v9415, ptr %MEMORY, align 4
  %v9416 = load ptr, ptr %MEMORY, align 4
  %v9417 = call ptr @__remill_atomic_end(ptr %v9416)
  store ptr %v9417, ptr %MEMORY, align 4
  store i32 %v9407, ptr %PC, align 4
  %v9418 = add i32 %v9407, 3
  store i32 %v9418, ptr %NEXT_PC, align 4
  %v9419 = load ptr, ptr %MEMORY, align 4
  %v9420 = call ptr @__remill_atomic_begin(ptr %v9419)
  store ptr %v9420, ptr %MEMORY, align 4
  %v9421 = load i32, ptr %EAX, align 4
  %v9422 = load i32, ptr %DSBASE, align 4
  %v9423 = add i32 %v9421, 12
  %v9424 = add i32 %v9423, %v9422
  %v9425 = load ptr, ptr %MEMORY, align 4
  %v9426 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9425, ptr %state, ptr %EAX, i32 %v9424)
  store ptr %v9426, ptr %MEMORY, align 4
  %v9427 = load ptr, ptr %MEMORY, align 4
  %v9428 = call ptr @__remill_atomic_end(ptr %v9427)
  store ptr %v9428, ptr %MEMORY, align 4
  store i32 %v9418, ptr %PC, align 4
  %v9429 = add i32 %v9418, 2
  store i32 %v9429, ptr %NEXT_PC, align 4
  %v9430 = load ptr, ptr %MEMORY, align 4
  %v9431 = call ptr @__remill_atomic_begin(ptr %v9430)
  store ptr %v9431, ptr %MEMORY, align 4
  %v9432 = load i32, ptr %EAX, align 4
  %v9433 = load i32, ptr %EAX, align 4
  %v9434 = load ptr, ptr %MEMORY, align 4
  %v9435 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9434, ptr %state, i32 %v9432, i32 %v9433)
  store ptr %v9435, ptr %MEMORY, align 4
  %v9436 = load ptr, ptr %MEMORY, align 4
  %v9437 = call ptr @__remill_atomic_end(ptr %v9436)
  store ptr %v9437, ptr %MEMORY, align 4
  store i32 %v9429, ptr %PC, align 4
  %v9438 = add i32 %v9429, 2
  store i32 %v9438, ptr %NEXT_PC, align 4
  %v9439 = load ptr, ptr %MEMORY, align 4
  %v9440 = call ptr @__remill_atomic_begin(ptr %v9439)
  store ptr %v9440, ptr %MEMORY, align 4
  %v9441 = add i32 %v9438, 56
  %v9442 = load ptr, ptr %MEMORY, align 4
  %v9443 = call ptr @_ZN12_GLOBAL__N_13JNSEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9442, ptr %state, ptr %BRANCH_TAKEN, i32 %v9441, i32 %v9438, ptr %NEXT_PC)
  store ptr %v9443, ptr %MEMORY, align 4
  %v9444 = load ptr, ptr %MEMORY, align 4
  %v9445 = call ptr @__remill_atomic_end(ptr %v9444)
  store ptr %v9445, ptr %MEMORY, align 4
  br i1 true, label %bb_4207787, label %bb_4207731

bb_4207731:                                       ; preds = %bb_4207721
  store i32 %v9438, ptr %PC, align 4
  %v9446 = add i32 %v9438, 3
  store i32 %v9446, ptr %NEXT_PC, align 4
  %v9447 = load ptr, ptr %MEMORY, align 4
  %v9448 = call ptr @__remill_atomic_begin(ptr %v9447)
  store ptr %v9448, ptr %MEMORY, align 4
  %v9449 = load i32, ptr %EBP, align 4
  %v9450 = load i32, ptr %SSBASE, align 4
  %v9451 = add i32 %v9449, 16
  %v9452 = add i32 %v9451, %v9450
  %v9453 = load ptr, ptr %MEMORY, align 4
  %v9454 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9453, ptr %state, ptr %EAX, i32 %v9452)
  store ptr %v9454, ptr %MEMORY, align 4
  %v9455 = load ptr, ptr %MEMORY, align 4
  %v9456 = call ptr @__remill_atomic_end(ptr %v9455)
  store ptr %v9456, ptr %MEMORY, align 4
  store i32 %v9446, ptr %PC, align 4
  %v9457 = add i32 %v9446, 3
  store i32 %v9457, ptr %NEXT_PC, align 4
  %v9458 = load ptr, ptr %MEMORY, align 4
  %v9459 = call ptr @__remill_atomic_begin(ptr %v9458)
  store ptr %v9459, ptr %MEMORY, align 4
  %v9460 = load i32, ptr %EAX, align 4
  %v9461 = load i32, ptr %DSBASE, align 4
  %v9462 = add i32 %v9460, 4
  %v9463 = add i32 %v9462, %v9461
  %v9464 = load ptr, ptr %MEMORY, align 4
  %v9465 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9464, ptr %state, ptr %EAX, i32 %v9463)
  store ptr %v9465, ptr %MEMORY, align 4
  %v9466 = load ptr, ptr %MEMORY, align 4
  %v9467 = call ptr @__remill_atomic_end(ptr %v9466)
  store ptr %v9467, ptr %MEMORY, align 4
  store i32 %v9457, ptr %PC, align 4
  %v9468 = add i32 %v9457, 5
  store i32 %v9468, ptr %NEXT_PC, align 4
  %v9469 = load ptr, ptr %MEMORY, align 4
  %v9470 = call ptr @__remill_atomic_begin(ptr %v9469)
  store ptr %v9470, ptr %MEMORY, align 4
  %v9471 = load i32, ptr %EAX, align 4
  %v9472 = load ptr, ptr %MEMORY, align 4
  %v9473 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9472, ptr %state, ptr %EAX, i32 %v9471, i32 1536)
  store ptr %v9473, ptr %MEMORY, align 4
  %v9474 = load ptr, ptr %MEMORY, align 4
  %v9475 = call ptr @__remill_atomic_end(ptr %v9474)
  store ptr %v9475, ptr %MEMORY, align 4
  store i32 %v9468, ptr %PC, align 4
  %v9476 = add i32 %v9468, 5
  store i32 %v9476, ptr %NEXT_PC, align 4
  %v9477 = load ptr, ptr %MEMORY, align 4
  %v9478 = call ptr @__remill_atomic_begin(ptr %v9477)
  store ptr %v9478, ptr %MEMORY, align 4
  %v9479 = load i32, ptr %EAX, align 4
  %v9480 = load ptr, ptr %MEMORY, align 4
  %v9481 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9480, ptr %state, i32 %v9479, i32 512)
  store ptr %v9481, ptr %MEMORY, align 4
  %v9482 = load ptr, ptr %MEMORY, align 4
  %v9483 = call ptr @__remill_atomic_end(ptr %v9482)
  store ptr %v9483, ptr %MEMORY, align 4
  store i32 %v9476, ptr %PC, align 4
  %v9484 = add i32 %v9476, 2
  store i32 %v9484, ptr %NEXT_PC, align 4
  %v9485 = load ptr, ptr %MEMORY, align 4
  %v9486 = call ptr @__remill_atomic_begin(ptr %v9485)
  store ptr %v9486, ptr %MEMORY, align 4
  %v9487 = add i32 %v9484, 38
  %v9488 = load ptr, ptr %MEMORY, align 4
  %v9489 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9488, ptr %state, ptr %BRANCH_TAKEN, i32 %v9487, i32 %v9484, ptr %NEXT_PC)
  store ptr %v9489, ptr %MEMORY, align 4
  %v9490 = load ptr, ptr %MEMORY, align 4
  %v9491 = call ptr @__remill_atomic_end(ptr %v9490)
  store ptr %v9491, ptr %MEMORY, align 4
  br i1 true, label %bb_4207787, label %bb_4207749

bb_4207749:                                       ; preds = %bb_4207731
  store i32 %v9484, ptr %PC, align 4
  %v9492 = add i32 %v9484, 2
  store i32 %v9492, ptr %NEXT_PC, align 4
  %v9493 = load ptr, ptr %MEMORY, align 4
  %v9494 = call ptr @__remill_atomic_begin(ptr %v9493)
  store ptr %v9494, ptr %MEMORY, align 4
  %v9495 = add i32 %v9492, 10
  %v9496 = load ptr, ptr %MEMORY, align 4
  %v9497 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v9496, ptr %state, i32 %v9495, ptr %NEXT_PC)
  store ptr %v9497, ptr %MEMORY, align 4
  %v9498 = load ptr, ptr %MEMORY, align 4
  %v9499 = call ptr @__remill_atomic_end(ptr %v9498)
  store ptr %v9499, ptr %MEMORY, align 4
  br label %bb_4207761

bb_4207751:                                       ; preds = %bb_4207761
  store i32 %v9618, ptr %PC, align 4
  %v9500 = add i32 %v9618, 3
  store i32 %v9500, ptr %NEXT_PC, align 4
  %v9501 = load ptr, ptr %MEMORY, align 4
  %v9502 = call ptr @__remill_atomic_begin(ptr %v9501)
  store ptr %v9502, ptr %MEMORY, align 4
  %v9503 = load i32, ptr %EBP, align 4
  %v9504 = load i32, ptr %SSBASE, align 4
  %v9505 = sub i32 %v9503, 12
  %v9506 = add i32 %v9505, %v9504
  %v9507 = load ptr, ptr %MEMORY, align 4
  %v9508 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9507, ptr %state, ptr %EAX, i32 %v9506)
  store ptr %v9508, ptr %MEMORY, align 4
  %v9509 = load ptr, ptr %MEMORY, align 4
  %v9510 = call ptr @__remill_atomic_end(ptr %v9509)
  store ptr %v9510, ptr %MEMORY, align 4
  store i32 %v9500, ptr %PC, align 4
  %v9511 = add i32 %v9500, 3
  store i32 %v9511, ptr %NEXT_PC, align 4
  %v9512 = load ptr, ptr %MEMORY, align 4
  %v9513 = call ptr @__remill_atomic_begin(ptr %v9512)
  store ptr %v9513, ptr %MEMORY, align 4
  %v9514 = load i32, ptr %EAX, align 4
  %v9515 = load i32, ptr %DSBASE, align 4
  %v9516 = add i32 %v9514, %v9515
  %v9517 = load ptr, ptr %MEMORY, align 4
  %v9518 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v9517, ptr %state, i32 %v9516, i32 48)
  store ptr %v9518, ptr %MEMORY, align 4
  %v9519 = load ptr, ptr %MEMORY, align 4
  %v9520 = call ptr @__remill_atomic_end(ptr %v9519)
  store ptr %v9520, ptr %MEMORY, align 4
  store i32 %v9511, ptr %PC, align 4
  %v9521 = add i32 %v9511, 4
  store i32 %v9521, ptr %NEXT_PC, align 4
  %v9522 = load ptr, ptr %MEMORY, align 4
  %v9523 = call ptr @__remill_atomic_begin(ptr %v9522)
  store ptr %v9523, ptr %MEMORY, align 4
  %v9524 = load i32, ptr %EBP, align 4
  %v9525 = load i32, ptr %SSBASE, align 4
  %v9526 = sub i32 %v9524, 12
  %v9527 = add i32 %v9526, %v9525
  %v9528 = load i32, ptr %EBP, align 4
  %v9529 = load i32, ptr %SSBASE, align 4
  %v9530 = sub i32 %v9528, 12
  %v9531 = add i32 %v9530, %v9529
  %v9532 = load ptr, ptr %MEMORY, align 4
  %v9533 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9532, ptr %state, i32 %v9527, i32 %v9531, i32 1)
  store ptr %v9533, ptr %MEMORY, align 4
  %v9534 = load ptr, ptr %MEMORY, align 4
  %v9535 = call ptr @__remill_atomic_end(ptr %v9534)
  store ptr %v9535, ptr %MEMORY, align 4
  br label %bb_4207761

bb_4207761:                                       ; preds = %bb_4207751, %bb_4207749
  %v9536 = load i32, ptr %NEXT_PC, align 4
  store i32 %v9536, ptr %PC, align 4
  %v9537 = add i32 %v9536, 3
  store i32 %v9537, ptr %NEXT_PC, align 4
  %v9538 = load ptr, ptr %MEMORY, align 4
  %v9539 = call ptr @__remill_atomic_begin(ptr %v9538)
  store ptr %v9539, ptr %MEMORY, align 4
  %v9540 = load i32, ptr %EBP, align 4
  %v9541 = load i32, ptr %SSBASE, align 4
  %v9542 = add i32 %v9540, 16
  %v9543 = add i32 %v9542, %v9541
  %v9544 = load ptr, ptr %MEMORY, align 4
  %v9545 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9544, ptr %state, ptr %EAX, i32 %v9543)
  store ptr %v9545, ptr %MEMORY, align 4
  %v9546 = load ptr, ptr %MEMORY, align 4
  %v9547 = call ptr @__remill_atomic_end(ptr %v9546)
  store ptr %v9547, ptr %MEMORY, align 4
  store i32 %v9537, ptr %PC, align 4
  %v9548 = add i32 %v9537, 3
  store i32 %v9548, ptr %NEXT_PC, align 4
  %v9549 = load ptr, ptr %MEMORY, align 4
  %v9550 = call ptr @__remill_atomic_begin(ptr %v9549)
  store ptr %v9550, ptr %MEMORY, align 4
  %v9551 = load i32, ptr %EAX, align 4
  %v9552 = load i32, ptr %DSBASE, align 4
  %v9553 = add i32 %v9551, 8
  %v9554 = add i32 %v9553, %v9552
  %v9555 = load ptr, ptr %MEMORY, align 4
  %v9556 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9555, ptr %state, ptr %EAX, i32 %v9554)
  store ptr %v9556, ptr %MEMORY, align 4
  %v9557 = load ptr, ptr %MEMORY, align 4
  %v9558 = call ptr @__remill_atomic_end(ptr %v9557)
  store ptr %v9558, ptr %MEMORY, align 4
  store i32 %v9548, ptr %PC, align 4
  %v9559 = add i32 %v9548, 2
  store i32 %v9559, ptr %NEXT_PC, align 4
  %v9560 = load ptr, ptr %MEMORY, align 4
  %v9561 = call ptr @__remill_atomic_begin(ptr %v9560)
  store ptr %v9561, ptr %MEMORY, align 4
  %v9562 = load i32, ptr %EAX, align 4
  %v9563 = load i32, ptr %EAX, align 4
  %v9564 = load ptr, ptr %MEMORY, align 4
  %v9565 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9564, ptr %state, i32 %v9562, i32 %v9563)
  store ptr %v9565, ptr %MEMORY, align 4
  %v9566 = load ptr, ptr %MEMORY, align 4
  %v9567 = call ptr @__remill_atomic_end(ptr %v9566)
  store ptr %v9567, ptr %MEMORY, align 4
  store i32 %v9559, ptr %PC, align 4
  %v9568 = add i32 %v9559, 3
  store i32 %v9568, ptr %NEXT_PC, align 4
  %v9569 = load ptr, ptr %MEMORY, align 4
  %v9570 = call ptr @__remill_atomic_begin(ptr %v9569)
  store ptr %v9570, ptr %MEMORY, align 4
  %v9571 = load ptr, ptr %MEMORY, align 4
  %v9572 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v9571, ptr %state, ptr %DL)
  store ptr %v9572, ptr %MEMORY, align 4
  %v9573 = load ptr, ptr %MEMORY, align 4
  %v9574 = call ptr @__remill_atomic_end(ptr %v9573)
  store ptr %v9574, ptr %MEMORY, align 4
  store i32 %v9568, ptr %PC, align 4
  %v9575 = add i32 %v9568, 3
  store i32 %v9575, ptr %NEXT_PC, align 4
  %v9576 = load ptr, ptr %MEMORY, align 4
  %v9577 = call ptr @__remill_atomic_begin(ptr %v9576)
  store ptr %v9577, ptr %MEMORY, align 4
  %v9578 = load i32, ptr %EAX, align 4
  %v9579 = sub i32 %v9578, 1
  %v9580 = load ptr, ptr %MEMORY, align 4
  %v9581 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v9580, ptr %state, ptr %ECX, i32 %v9579)
  store ptr %v9581, ptr %MEMORY, align 4
  %v9582 = load ptr, ptr %MEMORY, align 4
  %v9583 = call ptr @__remill_atomic_end(ptr %v9582)
  store ptr %v9583, ptr %MEMORY, align 4
  store i32 %v9575, ptr %PC, align 4
  %v9584 = add i32 %v9575, 3
  store i32 %v9584, ptr %NEXT_PC, align 4
  %v9585 = load ptr, ptr %MEMORY, align 4
  %v9586 = call ptr @__remill_atomic_begin(ptr %v9585)
  store ptr %v9586, ptr %MEMORY, align 4
  %v9587 = load i32, ptr %EBP, align 4
  %v9588 = load i32, ptr %SSBASE, align 4
  %v9589 = add i32 %v9587, 16
  %v9590 = add i32 %v9589, %v9588
  %v9591 = load ptr, ptr %MEMORY, align 4
  %v9592 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9591, ptr %state, ptr %EAX, i32 %v9590)
  store ptr %v9592, ptr %MEMORY, align 4
  %v9593 = load ptr, ptr %MEMORY, align 4
  %v9594 = call ptr @__remill_atomic_end(ptr %v9593)
  store ptr %v9594, ptr %MEMORY, align 4
  store i32 %v9584, ptr %PC, align 4
  %v9595 = add i32 %v9584, 3
  store i32 %v9595, ptr %NEXT_PC, align 4
  %v9596 = load ptr, ptr %MEMORY, align 4
  %v9597 = call ptr @__remill_atomic_begin(ptr %v9596)
  store ptr %v9597, ptr %MEMORY, align 4
  %v9598 = load i32, ptr %EAX, align 4
  %v9599 = load i32, ptr %DSBASE, align 4
  %v9600 = add i32 %v9598, 8
  %v9601 = add i32 %v9600, %v9599
  %v9602 = load i32, ptr %ECX, align 4
  %v9603 = load ptr, ptr %MEMORY, align 4
  %v9604 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9603, ptr %state, i32 %v9601, i32 %v9602)
  store ptr %v9604, ptr %MEMORY, align 4
  %v9605 = load ptr, ptr %MEMORY, align 4
  %v9606 = call ptr @__remill_atomic_end(ptr %v9605)
  store ptr %v9606, ptr %MEMORY, align 4
  store i32 %v9595, ptr %PC, align 4
  %v9607 = add i32 %v9595, 2
  store i32 %v9607, ptr %NEXT_PC, align 4
  %v9608 = load ptr, ptr %MEMORY, align 4
  %v9609 = call ptr @__remill_atomic_begin(ptr %v9608)
  store ptr %v9609, ptr %MEMORY, align 4
  %v9610 = load i8, ptr %DL, align 1
  %v9611 = zext i8 %v9610 to i32
  %v9612 = load i8, ptr %DL, align 1
  %v9613 = zext i8 %v9612 to i32
  %v9614 = load ptr, ptr %MEMORY, align 4
  %v9615 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9614, ptr %state, i32 %v9611, i32 %v9613)
  store ptr %v9615, ptr %MEMORY, align 4
  %v9616 = load ptr, ptr %MEMORY, align 4
  %v9617 = call ptr @__remill_atomic_end(ptr %v9616)
  store ptr %v9617, ptr %MEMORY, align 4
  store i32 %v9607, ptr %PC, align 4
  %v9618 = add i32 %v9607, 2
  store i32 %v9618, ptr %NEXT_PC, align 4
  %v9619 = load ptr, ptr %MEMORY, align 4
  %v9620 = call ptr @__remill_atomic_begin(ptr %v9619)
  store ptr %v9620, ptr %MEMORY, align 4
  %v9621 = sub i32 %v9618, 34
  %v9622 = load ptr, ptr %MEMORY, align 4
  %v9623 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9622, ptr %state, ptr %BRANCH_TAKEN, i32 %v9621, i32 %v9618, ptr %NEXT_PC)
  store ptr %v9623, ptr %MEMORY, align 4
  %v9624 = load ptr, ptr %MEMORY, align 4
  %v9625 = call ptr @__remill_atomic_end(ptr %v9624)
  store ptr %v9625, ptr %MEMORY, align 4
  br i1 true, label %bb_4207751, label %bb_4207785

bb_4207785:                                       ; preds = %bb_4207761
  store i32 %v9618, ptr %PC, align 4
  %v9626 = add i32 %v9618, 2
  store i32 %v9626, ptr %NEXT_PC, align 4
  %v9627 = load ptr, ptr %MEMORY, align 4
  %v9628 = call ptr @__remill_atomic_begin(ptr %v9627)
  store ptr %v9628, ptr %MEMORY, align 4
  %v9629 = add i32 %v9626, 60
  %v9630 = load ptr, ptr %MEMORY, align 4
  %v9631 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v9630, ptr %state, i32 %v9629, ptr %NEXT_PC)
  store ptr %v9631, ptr %MEMORY, align 4
  %v9632 = load ptr, ptr %MEMORY, align 4
  %v9633 = call ptr @__remill_atomic_end(ptr %v9632)
  store ptr %v9633, ptr %MEMORY, align 4
  br label %bb_4207847

bb_4207787:                                       ; preds = %bb_4207731, %bb_4207721
  %v9634 = load i32, ptr %NEXT_PC, align 4
  store i32 %v9634, ptr %PC, align 4
  %v9635 = add i32 %v9634, 3
  store i32 %v9635, ptr %NEXT_PC, align 4
  %v9636 = load ptr, ptr %MEMORY, align 4
  %v9637 = call ptr @__remill_atomic_begin(ptr %v9636)
  store ptr %v9637, ptr %MEMORY, align 4
  %v9638 = load i32, ptr %EBP, align 4
  %v9639 = load i32, ptr %SSBASE, align 4
  %v9640 = add i32 %v9638, 16
  %v9641 = add i32 %v9640, %v9639
  %v9642 = load ptr, ptr %MEMORY, align 4
  %v9643 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9642, ptr %state, ptr %EAX, i32 %v9641)
  store ptr %v9643, ptr %MEMORY, align 4
  %v9644 = load ptr, ptr %MEMORY, align 4
  %v9645 = call ptr @__remill_atomic_end(ptr %v9644)
  store ptr %v9645, ptr %MEMORY, align 4
  store i32 %v9635, ptr %PC, align 4
  %v9646 = add i32 %v9635, 3
  store i32 %v9646, ptr %NEXT_PC, align 4
  %v9647 = load ptr, ptr %MEMORY, align 4
  %v9648 = call ptr @__remill_atomic_begin(ptr %v9647)
  store ptr %v9648, ptr %MEMORY, align 4
  %v9649 = load i32, ptr %EAX, align 4
  %v9650 = load i32, ptr %DSBASE, align 4
  %v9651 = add i32 %v9649, 4
  %v9652 = add i32 %v9651, %v9650
  %v9653 = load ptr, ptr %MEMORY, align 4
  %v9654 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9653, ptr %state, ptr %EAX, i32 %v9652)
  store ptr %v9654, ptr %MEMORY, align 4
  %v9655 = load ptr, ptr %MEMORY, align 4
  %v9656 = call ptr @__remill_atomic_end(ptr %v9655)
  store ptr %v9656, ptr %MEMORY, align 4
  store i32 %v9646, ptr %PC, align 4
  %v9657 = add i32 %v9646, 5
  store i32 %v9657, ptr %NEXT_PC, align 4
  %v9658 = load ptr, ptr %MEMORY, align 4
  %v9659 = call ptr @__remill_atomic_begin(ptr %v9658)
  store ptr %v9659, ptr %MEMORY, align 4
  %v9660 = load i32, ptr %EAX, align 4
  %v9661 = load ptr, ptr %MEMORY, align 4
  %v9662 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9661, ptr %state, ptr %EAX, i32 %v9660, i32 1024)
  store ptr %v9662, ptr %MEMORY, align 4
  %v9663 = load ptr, ptr %MEMORY, align 4
  %v9664 = call ptr @__remill_atomic_end(ptr %v9663)
  store ptr %v9664, ptr %MEMORY, align 4
  store i32 %v9657, ptr %PC, align 4
  %v9665 = add i32 %v9657, 2
  store i32 %v9665, ptr %NEXT_PC, align 4
  %v9666 = load ptr, ptr %MEMORY, align 4
  %v9667 = call ptr @__remill_atomic_begin(ptr %v9666)
  store ptr %v9667, ptr %MEMORY, align 4
  %v9668 = load i32, ptr %EAX, align 4
  %v9669 = load i32, ptr %EAX, align 4
  %v9670 = load ptr, ptr %MEMORY, align 4
  %v9671 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9670, ptr %state, i32 %v9668, i32 %v9669)
  store ptr %v9671, ptr %MEMORY, align 4
  %v9672 = load ptr, ptr %MEMORY, align 4
  %v9673 = call ptr @__remill_atomic_end(ptr %v9672)
  store ptr %v9673, ptr %MEMORY, align 4
  store i32 %v9665, ptr %PC, align 4
  %v9674 = add i32 %v9665, 2
  store i32 %v9674, ptr %NEXT_PC, align 4
  %v9675 = load ptr, ptr %MEMORY, align 4
  %v9676 = call ptr @__remill_atomic_begin(ptr %v9675)
  store ptr %v9676, ptr %MEMORY, align 4
  %v9677 = add i32 %v9674, 45
  %v9678 = load ptr, ptr %MEMORY, align 4
  %v9679 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9678, ptr %state, ptr %BRANCH_TAKEN, i32 %v9677, i32 %v9674, ptr %NEXT_PC)
  store ptr %v9679, ptr %MEMORY, align 4
  %v9680 = load ptr, ptr %MEMORY, align 4
  %v9681 = call ptr @__remill_atomic_end(ptr %v9680)
  store ptr %v9681, ptr %MEMORY, align 4
  br i1 true, label %bb_4207847, label %bb_4207802

bb_4207802:                                       ; preds = %bb_4207787
  store i32 %v9674, ptr %PC, align 4
  %v9682 = add i32 %v9674, 2
  store i32 %v9682, ptr %NEXT_PC, align 4
  %v9683 = load ptr, ptr %MEMORY, align 4
  %v9684 = call ptr @__remill_atomic_begin(ptr %v9683)
  store ptr %v9684, ptr %MEMORY, align 4
  %v9685 = add i32 %v9682, 19
  %v9686 = load ptr, ptr %MEMORY, align 4
  %v9687 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v9686, ptr %state, i32 %v9685, ptr %NEXT_PC)
  store ptr %v9687, ptr %MEMORY, align 4
  %v9688 = load ptr, ptr %MEMORY, align 4
  %v9689 = call ptr @__remill_atomic_end(ptr %v9688)
  store ptr %v9689, ptr %MEMORY, align 4
  br label %bb_4207823

bb_4207804:                                       ; preds = %bb_4207823
  store i32 %v9812, ptr %PC, align 4
  %v9690 = add i32 %v9812, 3
  store i32 %v9690, ptr %NEXT_PC, align 4
  %v9691 = load ptr, ptr %MEMORY, align 4
  %v9692 = call ptr @__remill_atomic_begin(ptr %v9691)
  store ptr %v9692, ptr %MEMORY, align 4
  %v9693 = load i32, ptr %EBP, align 4
  %v9694 = load i32, ptr %SSBASE, align 4
  %v9695 = add i32 %v9693, 16
  %v9696 = add i32 %v9695, %v9694
  %v9697 = load ptr, ptr %MEMORY, align 4
  %v9698 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9697, ptr %state, ptr %EAX, i32 %v9696)
  store ptr %v9698, ptr %MEMORY, align 4
  %v9699 = load ptr, ptr %MEMORY, align 4
  %v9700 = call ptr @__remill_atomic_end(ptr %v9699)
  store ptr %v9700, ptr %MEMORY, align 4
  store i32 %v9690, ptr %PC, align 4
  %v9701 = add i32 %v9690, 4
  store i32 %v9701, ptr %NEXT_PC, align 4
  %v9702 = load ptr, ptr %MEMORY, align 4
  %v9703 = call ptr @__remill_atomic_begin(ptr %v9702)
  store ptr %v9703, ptr %MEMORY, align 4
  %v9704 = load i32, ptr %ESP, align 4
  %v9705 = load i32, ptr %SSBASE, align 4
  %v9706 = add i32 %v9704, 4
  %v9707 = add i32 %v9706, %v9705
  %v9708 = load i32, ptr %EAX, align 4
  %v9709 = load ptr, ptr %MEMORY, align 4
  %v9710 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9709, ptr %state, i32 %v9707, i32 %v9708)
  store ptr %v9710, ptr %MEMORY, align 4
  %v9711 = load ptr, ptr %MEMORY, align 4
  %v9712 = call ptr @__remill_atomic_end(ptr %v9711)
  store ptr %v9712, ptr %MEMORY, align 4
  store i32 %v9701, ptr %PC, align 4
  %v9713 = add i32 %v9701, 7
  store i32 %v9713, ptr %NEXT_PC, align 4
  %v9714 = load ptr, ptr %MEMORY, align 4
  %v9715 = call ptr @__remill_atomic_begin(ptr %v9714)
  store ptr %v9715, ptr %MEMORY, align 4
  %v9716 = load i32, ptr %ESP, align 4
  %v9717 = load i32, ptr %SSBASE, align 4
  %v9718 = add i32 %v9716, %v9717
  %v9719 = load ptr, ptr %MEMORY, align 4
  %v9720 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9719, ptr %state, i32 %v9718, i32 32)
  store ptr %v9720, ptr %MEMORY, align 4
  %v9721 = load ptr, ptr %MEMORY, align 4
  %v9722 = call ptr @__remill_atomic_end(ptr %v9721)
  store ptr %v9722, ptr %MEMORY, align 4
  store i32 %v9713, ptr %PC, align 4
  %v9723 = add i32 %v9713, 5
  store i32 %v9723, ptr %NEXT_PC, align 4
  %v9724 = load ptr, ptr %MEMORY, align 4
  %v9725 = call ptr @__remill_atomic_begin(ptr %v9724)
  store ptr %v9725, ptr %MEMORY, align 4
  %v9726 = sub i32 %v9723, 1573
  %v9727 = load ptr, ptr %MEMORY, align 4
  %v9728 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v9727, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v9723, ptr %RETURN_PC)
  store ptr %v9728, ptr %MEMORY, align 4
  %v9729 = load ptr, ptr %MEMORY, align 4
  %v9730 = call ptr @__remill_atomic_end(ptr %v9729)
  store ptr %v9730, ptr %MEMORY, align 4
  ret ptr %memory

bb_4207823:                                       ; preds = %bb_4207802
  store i32 %v9682, ptr %PC, align 4
  %v9731 = add i32 %v9682, 3
  store i32 %v9731, ptr %NEXT_PC, align 4
  %v9732 = load ptr, ptr %MEMORY, align 4
  %v9733 = call ptr @__remill_atomic_begin(ptr %v9732)
  store ptr %v9733, ptr %MEMORY, align 4
  %v9734 = load i32, ptr %EBP, align 4
  %v9735 = load i32, ptr %SSBASE, align 4
  %v9736 = add i32 %v9734, 16
  %v9737 = add i32 %v9736, %v9735
  %v9738 = load ptr, ptr %MEMORY, align 4
  %v9739 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9738, ptr %state, ptr %EAX, i32 %v9737)
  store ptr %v9739, ptr %MEMORY, align 4
  %v9740 = load ptr, ptr %MEMORY, align 4
  %v9741 = call ptr @__remill_atomic_end(ptr %v9740)
  store ptr %v9741, ptr %MEMORY, align 4
  store i32 %v9731, ptr %PC, align 4
  %v9742 = add i32 %v9731, 3
  store i32 %v9742, ptr %NEXT_PC, align 4
  %v9743 = load ptr, ptr %MEMORY, align 4
  %v9744 = call ptr @__remill_atomic_begin(ptr %v9743)
  store ptr %v9744, ptr %MEMORY, align 4
  %v9745 = load i32, ptr %EAX, align 4
  %v9746 = load i32, ptr %DSBASE, align 4
  %v9747 = add i32 %v9745, 8
  %v9748 = add i32 %v9747, %v9746
  %v9749 = load ptr, ptr %MEMORY, align 4
  %v9750 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9749, ptr %state, ptr %EAX, i32 %v9748)
  store ptr %v9750, ptr %MEMORY, align 4
  %v9751 = load ptr, ptr %MEMORY, align 4
  %v9752 = call ptr @__remill_atomic_end(ptr %v9751)
  store ptr %v9752, ptr %MEMORY, align 4
  store i32 %v9742, ptr %PC, align 4
  %v9753 = add i32 %v9742, 2
  store i32 %v9753, ptr %NEXT_PC, align 4
  %v9754 = load ptr, ptr %MEMORY, align 4
  %v9755 = call ptr @__remill_atomic_begin(ptr %v9754)
  store ptr %v9755, ptr %MEMORY, align 4
  %v9756 = load i32, ptr %EAX, align 4
  %v9757 = load i32, ptr %EAX, align 4
  %v9758 = load ptr, ptr %MEMORY, align 4
  %v9759 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9758, ptr %state, i32 %v9756, i32 %v9757)
  store ptr %v9759, ptr %MEMORY, align 4
  %v9760 = load ptr, ptr %MEMORY, align 4
  %v9761 = call ptr @__remill_atomic_end(ptr %v9760)
  store ptr %v9761, ptr %MEMORY, align 4
  store i32 %v9753, ptr %PC, align 4
  %v9762 = add i32 %v9753, 3
  store i32 %v9762, ptr %NEXT_PC, align 4
  %v9763 = load ptr, ptr %MEMORY, align 4
  %v9764 = call ptr @__remill_atomic_begin(ptr %v9763)
  store ptr %v9764, ptr %MEMORY, align 4
  %v9765 = load ptr, ptr %MEMORY, align 4
  %v9766 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v9765, ptr %state, ptr %DL)
  store ptr %v9766, ptr %MEMORY, align 4
  %v9767 = load ptr, ptr %MEMORY, align 4
  %v9768 = call ptr @__remill_atomic_end(ptr %v9767)
  store ptr %v9768, ptr %MEMORY, align 4
  store i32 %v9762, ptr %PC, align 4
  %v9769 = add i32 %v9762, 3
  store i32 %v9769, ptr %NEXT_PC, align 4
  %v9770 = load ptr, ptr %MEMORY, align 4
  %v9771 = call ptr @__remill_atomic_begin(ptr %v9770)
  store ptr %v9771, ptr %MEMORY, align 4
  %v9772 = load i32, ptr %EAX, align 4
  %v9773 = sub i32 %v9772, 1
  %v9774 = load ptr, ptr %MEMORY, align 4
  %v9775 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v9774, ptr %state, ptr %ECX, i32 %v9773)
  store ptr %v9775, ptr %MEMORY, align 4
  %v9776 = load ptr, ptr %MEMORY, align 4
  %v9777 = call ptr @__remill_atomic_end(ptr %v9776)
  store ptr %v9777, ptr %MEMORY, align 4
  store i32 %v9769, ptr %PC, align 4
  %v9778 = add i32 %v9769, 3
  store i32 %v9778, ptr %NEXT_PC, align 4
  %v9779 = load ptr, ptr %MEMORY, align 4
  %v9780 = call ptr @__remill_atomic_begin(ptr %v9779)
  store ptr %v9780, ptr %MEMORY, align 4
  %v9781 = load i32, ptr %EBP, align 4
  %v9782 = load i32, ptr %SSBASE, align 4
  %v9783 = add i32 %v9781, 16
  %v9784 = add i32 %v9783, %v9782
  %v9785 = load ptr, ptr %MEMORY, align 4
  %v9786 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9785, ptr %state, ptr %EAX, i32 %v9784)
  store ptr %v9786, ptr %MEMORY, align 4
  %v9787 = load ptr, ptr %MEMORY, align 4
  %v9788 = call ptr @__remill_atomic_end(ptr %v9787)
  store ptr %v9788, ptr %MEMORY, align 4
  store i32 %v9778, ptr %PC, align 4
  %v9789 = add i32 %v9778, 3
  store i32 %v9789, ptr %NEXT_PC, align 4
  %v9790 = load ptr, ptr %MEMORY, align 4
  %v9791 = call ptr @__remill_atomic_begin(ptr %v9790)
  store ptr %v9791, ptr %MEMORY, align 4
  %v9792 = load i32, ptr %EAX, align 4
  %v9793 = load i32, ptr %DSBASE, align 4
  %v9794 = add i32 %v9792, 8
  %v9795 = add i32 %v9794, %v9793
  %v9796 = load i32, ptr %ECX, align 4
  %v9797 = load ptr, ptr %MEMORY, align 4
  %v9798 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v9797, ptr %state, i32 %v9795, i32 %v9796)
  store ptr %v9798, ptr %MEMORY, align 4
  %v9799 = load ptr, ptr %MEMORY, align 4
  %v9800 = call ptr @__remill_atomic_end(ptr %v9799)
  store ptr %v9800, ptr %MEMORY, align 4
  store i32 %v9789, ptr %PC, align 4
  %v9801 = add i32 %v9789, 2
  store i32 %v9801, ptr %NEXT_PC, align 4
  %v9802 = load ptr, ptr %MEMORY, align 4
  %v9803 = call ptr @__remill_atomic_begin(ptr %v9802)
  store ptr %v9803, ptr %MEMORY, align 4
  %v9804 = load i8, ptr %DL, align 1
  %v9805 = zext i8 %v9804 to i32
  %v9806 = load i8, ptr %DL, align 1
  %v9807 = zext i8 %v9806 to i32
  %v9808 = load ptr, ptr %MEMORY, align 4
  %v9809 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9808, ptr %state, i32 %v9805, i32 %v9807)
  store ptr %v9809, ptr %MEMORY, align 4
  %v9810 = load ptr, ptr %MEMORY, align 4
  %v9811 = call ptr @__remill_atomic_end(ptr %v9810)
  store ptr %v9811, ptr %MEMORY, align 4
  store i32 %v9801, ptr %PC, align 4
  %v9812 = add i32 %v9801, 2
  store i32 %v9812, ptr %NEXT_PC, align 4
  %v9813 = load ptr, ptr %MEMORY, align 4
  %v9814 = call ptr @__remill_atomic_begin(ptr %v9813)
  store ptr %v9814, ptr %MEMORY, align 4
  %v9815 = sub i32 %v9812, 43
  %v9816 = load ptr, ptr %MEMORY, align 4
  %v9817 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9816, ptr %state, ptr %BRANCH_TAKEN, i32 %v9815, i32 %v9812, ptr %NEXT_PC)
  store ptr %v9817, ptr %MEMORY, align 4
  %v9818 = load ptr, ptr %MEMORY, align 4
  %v9819 = call ptr @__remill_atomic_end(ptr %v9818)
  store ptr %v9819, ptr %MEMORY, align 4
  br i1 true, label %bb_4207804, label %bb_4207847

bb_4207847:                                       ; preds = %bb_4207823, %bb_4207787, %bb_4207785, %bb_4207649, %bb_4207635
  %v9820 = load i32, ptr %NEXT_PC, align 4
  store i32 %v9820, ptr %PC, align 4
  %v9821 = add i32 %v9820, 3
  store i32 %v9821, ptr %NEXT_PC, align 4
  %v9822 = load ptr, ptr %MEMORY, align 4
  %v9823 = call ptr @__remill_atomic_begin(ptr %v9822)
  store ptr %v9823, ptr %MEMORY, align 4
  %v9824 = load i32, ptr %EBP, align 4
  %v9825 = load i32, ptr %SSBASE, align 4
  %v9826 = add i32 %v9824, 16
  %v9827 = add i32 %v9826, %v9825
  %v9828 = load ptr, ptr %MEMORY, align 4
  %v9829 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9828, ptr %state, ptr %EAX, i32 %v9827)
  store ptr %v9829, ptr %MEMORY, align 4
  %v9830 = load ptr, ptr %MEMORY, align 4
  %v9831 = call ptr @__remill_atomic_end(ptr %v9830)
  store ptr %v9831, ptr %MEMORY, align 4
  store i32 %v9821, ptr %PC, align 4
  %v9832 = add i32 %v9821, 3
  store i32 %v9832, ptr %NEXT_PC, align 4
  %v9833 = load ptr, ptr %MEMORY, align 4
  %v9834 = call ptr @__remill_atomic_begin(ptr %v9833)
  store ptr %v9834, ptr %MEMORY, align 4
  %v9835 = load i32, ptr %EAX, align 4
  %v9836 = load i32, ptr %DSBASE, align 4
  %v9837 = add i32 %v9835, 4
  %v9838 = add i32 %v9837, %v9836
  %v9839 = load ptr, ptr %MEMORY, align 4
  %v9840 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9839, ptr %state, ptr %EAX, i32 %v9838)
  store ptr %v9840, ptr %MEMORY, align 4
  %v9841 = load ptr, ptr %MEMORY, align 4
  %v9842 = call ptr @__remill_atomic_end(ptr %v9841)
  store ptr %v9842, ptr %MEMORY, align 4
  store i32 %v9832, ptr %PC, align 4
  %v9843 = add i32 %v9832, 5
  store i32 %v9843, ptr %NEXT_PC, align 4
  %v9844 = load ptr, ptr %MEMORY, align 4
  %v9845 = call ptr @__remill_atomic_begin(ptr %v9844)
  store ptr %v9845, ptr %MEMORY, align 4
  %v9846 = load i32, ptr %EAX, align 4
  %v9847 = load ptr, ptr %MEMORY, align 4
  %v9848 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9847, ptr %state, ptr %EAX, i32 %v9846, i32 128)
  store ptr %v9848, ptr %MEMORY, align 4
  %v9849 = load ptr, ptr %MEMORY, align 4
  %v9850 = call ptr @__remill_atomic_end(ptr %v9849)
  store ptr %v9850, ptr %MEMORY, align 4
  store i32 %v9843, ptr %PC, align 4
  %v9851 = add i32 %v9843, 2
  store i32 %v9851, ptr %NEXT_PC, align 4
  %v9852 = load ptr, ptr %MEMORY, align 4
  %v9853 = call ptr @__remill_atomic_begin(ptr %v9852)
  store ptr %v9853, ptr %MEMORY, align 4
  %v9854 = load i32, ptr %EAX, align 4
  %v9855 = load i32, ptr %EAX, align 4
  %v9856 = load ptr, ptr %MEMORY, align 4
  %v9857 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9856, ptr %state, i32 %v9854, i32 %v9855)
  store ptr %v9857, ptr %MEMORY, align 4
  %v9858 = load ptr, ptr %MEMORY, align 4
  %v9859 = call ptr @__remill_atomic_end(ptr %v9858)
  store ptr %v9859, ptr %MEMORY, align 4
  store i32 %v9851, ptr %PC, align 4
  %v9860 = add i32 %v9851, 2
  store i32 %v9860, ptr %NEXT_PC, align 4
  %v9861 = load ptr, ptr %MEMORY, align 4
  %v9862 = call ptr @__remill_atomic_begin(ptr %v9861)
  store ptr %v9862, ptr %MEMORY, align 4
  %v9863 = add i32 %v9860, 12
  %v9864 = load ptr, ptr %MEMORY, align 4
  %v9865 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9864, ptr %state, ptr %BRANCH_TAKEN, i32 %v9863, i32 %v9860, ptr %NEXT_PC)
  store ptr %v9865, ptr %MEMORY, align 4
  %v9866 = load ptr, ptr %MEMORY, align 4
  %v9867 = call ptr @__remill_atomic_end(ptr %v9866)
  store ptr %v9867, ptr %MEMORY, align 4
  br i1 true, label %bb_4207874, label %bb_4207862

bb_4207862:                                       ; preds = %bb_4207847
  store i32 %v9860, ptr %PC, align 4
  %v9868 = add i32 %v9860, 3
  store i32 %v9868, ptr %NEXT_PC, align 4
  %v9869 = load ptr, ptr %MEMORY, align 4
  %v9870 = call ptr @__remill_atomic_begin(ptr %v9869)
  store ptr %v9870, ptr %MEMORY, align 4
  %v9871 = load i32, ptr %EBP, align 4
  %v9872 = load i32, ptr %SSBASE, align 4
  %v9873 = sub i32 %v9871, 12
  %v9874 = add i32 %v9873, %v9872
  %v9875 = load ptr, ptr %MEMORY, align 4
  %v9876 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9875, ptr %state, ptr %EAX, i32 %v9874)
  store ptr %v9876, ptr %MEMORY, align 4
  %v9877 = load ptr, ptr %MEMORY, align 4
  %v9878 = call ptr @__remill_atomic_end(ptr %v9877)
  store ptr %v9878, ptr %MEMORY, align 4
  store i32 %v9868, ptr %PC, align 4
  %v9879 = add i32 %v9868, 3
  store i32 %v9879, ptr %NEXT_PC, align 4
  %v9880 = load ptr, ptr %MEMORY, align 4
  %v9881 = call ptr @__remill_atomic_begin(ptr %v9880)
  store ptr %v9881, ptr %MEMORY, align 4
  %v9882 = load i32, ptr %EAX, align 4
  %v9883 = load i32, ptr %DSBASE, align 4
  %v9884 = add i32 %v9882, %v9883
  %v9885 = load ptr, ptr %MEMORY, align 4
  %v9886 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v9885, ptr %state, i32 %v9884, i32 45)
  store ptr %v9886, ptr %MEMORY, align 4
  %v9887 = load ptr, ptr %MEMORY, align 4
  %v9888 = call ptr @__remill_atomic_end(ptr %v9887)
  store ptr %v9888, ptr %MEMORY, align 4
  store i32 %v9879, ptr %PC, align 4
  %v9889 = add i32 %v9879, 4
  store i32 %v9889, ptr %NEXT_PC, align 4
  %v9890 = load ptr, ptr %MEMORY, align 4
  %v9891 = call ptr @__remill_atomic_begin(ptr %v9890)
  store ptr %v9891, ptr %MEMORY, align 4
  %v9892 = load i32, ptr %EBP, align 4
  %v9893 = load i32, ptr %SSBASE, align 4
  %v9894 = sub i32 %v9892, 12
  %v9895 = add i32 %v9894, %v9893
  %v9896 = load i32, ptr %EBP, align 4
  %v9897 = load i32, ptr %SSBASE, align 4
  %v9898 = sub i32 %v9896, 12
  %v9899 = add i32 %v9898, %v9897
  %v9900 = load ptr, ptr %MEMORY, align 4
  %v9901 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9900, ptr %state, i32 %v9895, i32 %v9899, i32 1)
  store ptr %v9901, ptr %MEMORY, align 4
  %v9902 = load ptr, ptr %MEMORY, align 4
  %v9903 = call ptr @__remill_atomic_end(ptr %v9902)
  store ptr %v9903, ptr %MEMORY, align 4
  store i32 %v9889, ptr %PC, align 4
  %v9904 = add i32 %v9889, 2
  store i32 %v9904, ptr %NEXT_PC, align 4
  %v9905 = load ptr, ptr %MEMORY, align 4
  %v9906 = call ptr @__remill_atomic_begin(ptr %v9905)
  store ptr %v9906, ptr %MEMORY, align 4
  %v9907 = add i32 %v9904, 82
  %v9908 = load ptr, ptr %MEMORY, align 4
  %v9909 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v9908, ptr %state, i32 %v9907, ptr %NEXT_PC)
  store ptr %v9909, ptr %MEMORY, align 4
  %v9910 = load ptr, ptr %MEMORY, align 4
  %v9911 = call ptr @__remill_atomic_end(ptr %v9910)
  store ptr %v9911, ptr %MEMORY, align 4
  br label %bb_4207956

bb_4207874:                                       ; preds = %bb_4207847
  store i32 %v9860, ptr %PC, align 4
  %v9912 = add i32 %v9860, 3
  store i32 %v9912, ptr %NEXT_PC, align 4
  %v9913 = load ptr, ptr %MEMORY, align 4
  %v9914 = call ptr @__remill_atomic_begin(ptr %v9913)
  store ptr %v9914, ptr %MEMORY, align 4
  %v9915 = load i32, ptr %EBP, align 4
  %v9916 = load i32, ptr %SSBASE, align 4
  %v9917 = add i32 %v9915, 16
  %v9918 = add i32 %v9917, %v9916
  %v9919 = load ptr, ptr %MEMORY, align 4
  %v9920 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9919, ptr %state, ptr %EAX, i32 %v9918)
  store ptr %v9920, ptr %MEMORY, align 4
  %v9921 = load ptr, ptr %MEMORY, align 4
  %v9922 = call ptr @__remill_atomic_end(ptr %v9921)
  store ptr %v9922, ptr %MEMORY, align 4
  store i32 %v9912, ptr %PC, align 4
  %v9923 = add i32 %v9912, 3
  store i32 %v9923, ptr %NEXT_PC, align 4
  %v9924 = load ptr, ptr %MEMORY, align 4
  %v9925 = call ptr @__remill_atomic_begin(ptr %v9924)
  store ptr %v9925, ptr %MEMORY, align 4
  %v9926 = load i32, ptr %EAX, align 4
  %v9927 = load i32, ptr %DSBASE, align 4
  %v9928 = add i32 %v9926, 4
  %v9929 = add i32 %v9928, %v9927
  %v9930 = load ptr, ptr %MEMORY, align 4
  %v9931 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9930, ptr %state, ptr %EAX, i32 %v9929)
  store ptr %v9931, ptr %MEMORY, align 4
  %v9932 = load ptr, ptr %MEMORY, align 4
  %v9933 = call ptr @__remill_atomic_end(ptr %v9932)
  store ptr %v9933, ptr %MEMORY, align 4
  store i32 %v9923, ptr %PC, align 4
  %v9934 = add i32 %v9923, 5
  store i32 %v9934, ptr %NEXT_PC, align 4
  %v9935 = load ptr, ptr %MEMORY, align 4
  %v9936 = call ptr @__remill_atomic_begin(ptr %v9935)
  store ptr %v9936, ptr %MEMORY, align 4
  %v9937 = load i32, ptr %EAX, align 4
  %v9938 = load ptr, ptr %MEMORY, align 4
  %v9939 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9938, ptr %state, ptr %EAX, i32 %v9937, i32 256)
  store ptr %v9939, ptr %MEMORY, align 4
  %v9940 = load ptr, ptr %MEMORY, align 4
  %v9941 = call ptr @__remill_atomic_end(ptr %v9940)
  store ptr %v9941, ptr %MEMORY, align 4
  store i32 %v9934, ptr %PC, align 4
  %v9942 = add i32 %v9934, 2
  store i32 %v9942, ptr %NEXT_PC, align 4
  %v9943 = load ptr, ptr %MEMORY, align 4
  %v9944 = call ptr @__remill_atomic_begin(ptr %v9943)
  store ptr %v9944, ptr %MEMORY, align 4
  %v9945 = load i32, ptr %EAX, align 4
  %v9946 = load i32, ptr %EAX, align 4
  %v9947 = load ptr, ptr %MEMORY, align 4
  %v9948 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v9947, ptr %state, i32 %v9945, i32 %v9946)
  store ptr %v9948, ptr %MEMORY, align 4
  %v9949 = load ptr, ptr %MEMORY, align 4
  %v9950 = call ptr @__remill_atomic_end(ptr %v9949)
  store ptr %v9950, ptr %MEMORY, align 4
  store i32 %v9942, ptr %PC, align 4
  %v9951 = add i32 %v9942, 2
  store i32 %v9951, ptr %NEXT_PC, align 4
  %v9952 = load ptr, ptr %MEMORY, align 4
  %v9953 = call ptr @__remill_atomic_begin(ptr %v9952)
  store ptr %v9953, ptr %MEMORY, align 4
  %v9954 = add i32 %v9951, 12
  %v9955 = load ptr, ptr %MEMORY, align 4
  %v9956 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v9955, ptr %state, ptr %BRANCH_TAKEN, i32 %v9954, i32 %v9951, ptr %NEXT_PC)
  store ptr %v9956, ptr %MEMORY, align 4
  %v9957 = load ptr, ptr %MEMORY, align 4
  %v9958 = call ptr @__remill_atomic_end(ptr %v9957)
  store ptr %v9958, ptr %MEMORY, align 4
  br i1 true, label %bb_4207901, label %bb_4207889

bb_4207889:                                       ; preds = %bb_4207874
  store i32 %v9951, ptr %PC, align 4
  %v9959 = add i32 %v9951, 3
  store i32 %v9959, ptr %NEXT_PC, align 4
  %v9960 = load ptr, ptr %MEMORY, align 4
  %v9961 = call ptr @__remill_atomic_begin(ptr %v9960)
  store ptr %v9961, ptr %MEMORY, align 4
  %v9962 = load i32, ptr %EBP, align 4
  %v9963 = load i32, ptr %SSBASE, align 4
  %v9964 = sub i32 %v9962, 12
  %v9965 = add i32 %v9964, %v9963
  %v9966 = load ptr, ptr %MEMORY, align 4
  %v9967 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v9966, ptr %state, ptr %EAX, i32 %v9965)
  store ptr %v9967, ptr %MEMORY, align 4
  %v9968 = load ptr, ptr %MEMORY, align 4
  %v9969 = call ptr @__remill_atomic_end(ptr %v9968)
  store ptr %v9969, ptr %MEMORY, align 4
  store i32 %v9959, ptr %PC, align 4
  %v9970 = add i32 %v9959, 3
  store i32 %v9970, ptr %NEXT_PC, align 4
  %v9971 = load ptr, ptr %MEMORY, align 4
  %v9972 = call ptr @__remill_atomic_begin(ptr %v9971)
  store ptr %v9972, ptr %MEMORY, align 4
  %v9973 = load i32, ptr %EAX, align 4
  %v9974 = load i32, ptr %DSBASE, align 4
  %v9975 = add i32 %v9973, %v9974
  %v9976 = load ptr, ptr %MEMORY, align 4
  %v9977 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v9976, ptr %state, i32 %v9975, i32 43)
  store ptr %v9977, ptr %MEMORY, align 4
  %v9978 = load ptr, ptr %MEMORY, align 4
  %v9979 = call ptr @__remill_atomic_end(ptr %v9978)
  store ptr %v9979, ptr %MEMORY, align 4
  store i32 %v9970, ptr %PC, align 4
  %v9980 = add i32 %v9970, 4
  store i32 %v9980, ptr %NEXT_PC, align 4
  %v9981 = load ptr, ptr %MEMORY, align 4
  %v9982 = call ptr @__remill_atomic_begin(ptr %v9981)
  store ptr %v9982, ptr %MEMORY, align 4
  %v9983 = load i32, ptr %EBP, align 4
  %v9984 = load i32, ptr %SSBASE, align 4
  %v9985 = sub i32 %v9983, 12
  %v9986 = add i32 %v9985, %v9984
  %v9987 = load i32, ptr %EBP, align 4
  %v9988 = load i32, ptr %SSBASE, align 4
  %v9989 = sub i32 %v9987, 12
  %v9990 = add i32 %v9989, %v9988
  %v9991 = load ptr, ptr %MEMORY, align 4
  %v9992 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v9991, ptr %state, i32 %v9986, i32 %v9990, i32 1)
  store ptr %v9992, ptr %MEMORY, align 4
  %v9993 = load ptr, ptr %MEMORY, align 4
  %v9994 = call ptr @__remill_atomic_end(ptr %v9993)
  store ptr %v9994, ptr %MEMORY, align 4
  store i32 %v9980, ptr %PC, align 4
  %v9995 = add i32 %v9980, 2
  store i32 %v9995, ptr %NEXT_PC, align 4
  %v9996 = load ptr, ptr %MEMORY, align 4
  %v9997 = call ptr @__remill_atomic_begin(ptr %v9996)
  store ptr %v9997, ptr %MEMORY, align 4
  %v9998 = add i32 %v9995, 55
  %v9999 = load ptr, ptr %MEMORY, align 4
  %v10000 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v9999, ptr %state, i32 %v9998, ptr %NEXT_PC)
  store ptr %v10000, ptr %MEMORY, align 4
  %v10001 = load ptr, ptr %MEMORY, align 4
  %v10002 = call ptr @__remill_atomic_end(ptr %v10001)
  store ptr %v10002, ptr %MEMORY, align 4
  br label %bb_4207956

bb_4207901:                                       ; preds = %bb_4207874
  store i32 %v9951, ptr %PC, align 4
  %v10003 = add i32 %v9951, 3
  store i32 %v10003, ptr %NEXT_PC, align 4
  %v10004 = load ptr, ptr %MEMORY, align 4
  %v10005 = call ptr @__remill_atomic_begin(ptr %v10004)
  store ptr %v10005, ptr %MEMORY, align 4
  %v10006 = load i32, ptr %EBP, align 4
  %v10007 = load i32, ptr %SSBASE, align 4
  %v10008 = add i32 %v10006, 16
  %v10009 = add i32 %v10008, %v10007
  %v10010 = load ptr, ptr %MEMORY, align 4
  %v10011 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10010, ptr %state, ptr %EAX, i32 %v10009)
  store ptr %v10011, ptr %MEMORY, align 4
  %v10012 = load ptr, ptr %MEMORY, align 4
  %v10013 = call ptr @__remill_atomic_end(ptr %v10012)
  store ptr %v10013, ptr %MEMORY, align 4
  store i32 %v10003, ptr %PC, align 4
  %v10014 = add i32 %v10003, 3
  store i32 %v10014, ptr %NEXT_PC, align 4
  %v10015 = load ptr, ptr %MEMORY, align 4
  %v10016 = call ptr @__remill_atomic_begin(ptr %v10015)
  store ptr %v10016, ptr %MEMORY, align 4
  %v10017 = load i32, ptr %EAX, align 4
  %v10018 = load i32, ptr %DSBASE, align 4
  %v10019 = add i32 %v10017, 4
  %v10020 = add i32 %v10019, %v10018
  %v10021 = load ptr, ptr %MEMORY, align 4
  %v10022 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10021, ptr %state, ptr %EAX, i32 %v10020)
  store ptr %v10022, ptr %MEMORY, align 4
  %v10023 = load ptr, ptr %MEMORY, align 4
  %v10024 = call ptr @__remill_atomic_end(ptr %v10023)
  store ptr %v10024, ptr %MEMORY, align 4
  store i32 %v10014, ptr %PC, align 4
  %v10025 = add i32 %v10014, 3
  store i32 %v10025, ptr %NEXT_PC, align 4
  %v10026 = load ptr, ptr %MEMORY, align 4
  %v10027 = call ptr @__remill_atomic_begin(ptr %v10026)
  store ptr %v10027, ptr %MEMORY, align 4
  %v10028 = load i32, ptr %EAX, align 4
  %v10029 = load ptr, ptr %MEMORY, align 4
  %v10030 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10029, ptr %state, ptr %EAX, i32 %v10028, i32 64)
  store ptr %v10030, ptr %MEMORY, align 4
  %v10031 = load ptr, ptr %MEMORY, align 4
  %v10032 = call ptr @__remill_atomic_end(ptr %v10031)
  store ptr %v10032, ptr %MEMORY, align 4
  store i32 %v10025, ptr %PC, align 4
  %v10033 = add i32 %v10025, 2
  store i32 %v10033, ptr %NEXT_PC, align 4
  %v10034 = load ptr, ptr %MEMORY, align 4
  %v10035 = call ptr @__remill_atomic_begin(ptr %v10034)
  store ptr %v10035, ptr %MEMORY, align 4
  %v10036 = load i32, ptr %EAX, align 4
  %v10037 = load i32, ptr %EAX, align 4
  %v10038 = load ptr, ptr %MEMORY, align 4
  %v10039 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v10038, ptr %state, i32 %v10036, i32 %v10037)
  store ptr %v10039, ptr %MEMORY, align 4
  %v10040 = load ptr, ptr %MEMORY, align 4
  %v10041 = call ptr @__remill_atomic_end(ptr %v10040)
  store ptr %v10041, ptr %MEMORY, align 4
  store i32 %v10033, ptr %PC, align 4
  %v10042 = add i32 %v10033, 2
  store i32 %v10042, ptr %NEXT_PC, align 4
  %v10043 = load ptr, ptr %MEMORY, align 4
  %v10044 = call ptr @__remill_atomic_begin(ptr %v10043)
  store ptr %v10044, ptr %MEMORY, align 4
  %v10045 = add i32 %v10042, 42
  %v10046 = load ptr, ptr %MEMORY, align 4
  %v10047 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v10046, ptr %state, ptr %BRANCH_TAKEN, i32 %v10045, i32 %v10042, ptr %NEXT_PC)
  store ptr %v10047, ptr %MEMORY, align 4
  %v10048 = load ptr, ptr %MEMORY, align 4
  %v10049 = call ptr @__remill_atomic_end(ptr %v10048)
  store ptr %v10049, ptr %MEMORY, align 4
  br i1 true, label %bb_4207956, label %bb_4207914

bb_4207914:                                       ; preds = %bb_4207901
  store i32 %v10042, ptr %PC, align 4
  %v10050 = add i32 %v10042, 3
  store i32 %v10050, ptr %NEXT_PC, align 4
  %v10051 = load ptr, ptr %MEMORY, align 4
  %v10052 = call ptr @__remill_atomic_begin(ptr %v10051)
  store ptr %v10052, ptr %MEMORY, align 4
  %v10053 = load i32, ptr %EBP, align 4
  %v10054 = load i32, ptr %SSBASE, align 4
  %v10055 = sub i32 %v10053, 12
  %v10056 = add i32 %v10055, %v10054
  %v10057 = load ptr, ptr %MEMORY, align 4
  %v10058 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10057, ptr %state, ptr %EAX, i32 %v10056)
  store ptr %v10058, ptr %MEMORY, align 4
  %v10059 = load ptr, ptr %MEMORY, align 4
  %v10060 = call ptr @__remill_atomic_end(ptr %v10059)
  store ptr %v10060, ptr %MEMORY, align 4
  store i32 %v10050, ptr %PC, align 4
  %v10061 = add i32 %v10050, 3
  store i32 %v10061, ptr %NEXT_PC, align 4
  %v10062 = load ptr, ptr %MEMORY, align 4
  %v10063 = call ptr @__remill_atomic_begin(ptr %v10062)
  store ptr %v10063, ptr %MEMORY, align 4
  %v10064 = load i32, ptr %EAX, align 4
  %v10065 = load i32, ptr %DSBASE, align 4
  %v10066 = add i32 %v10064, %v10065
  %v10067 = load ptr, ptr %MEMORY, align 4
  %v10068 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v10067, ptr %state, i32 %v10066, i32 32)
  store ptr %v10068, ptr %MEMORY, align 4
  %v10069 = load ptr, ptr %MEMORY, align 4
  %v10070 = call ptr @__remill_atomic_end(ptr %v10069)
  store ptr %v10070, ptr %MEMORY, align 4
  store i32 %v10061, ptr %PC, align 4
  %v10071 = add i32 %v10061, 4
  store i32 %v10071, ptr %NEXT_PC, align 4
  %v10072 = load ptr, ptr %MEMORY, align 4
  %v10073 = call ptr @__remill_atomic_begin(ptr %v10072)
  store ptr %v10073, ptr %MEMORY, align 4
  %v10074 = load i32, ptr %EBP, align 4
  %v10075 = load i32, ptr %SSBASE, align 4
  %v10076 = sub i32 %v10074, 12
  %v10077 = add i32 %v10076, %v10075
  %v10078 = load i32, ptr %EBP, align 4
  %v10079 = load i32, ptr %SSBASE, align 4
  %v10080 = sub i32 %v10078, 12
  %v10081 = add i32 %v10080, %v10079
  %v10082 = load ptr, ptr %MEMORY, align 4
  %v10083 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10082, ptr %state, i32 %v10077, i32 %v10081, i32 1)
  store ptr %v10083, ptr %MEMORY, align 4
  %v10084 = load ptr, ptr %MEMORY, align 4
  %v10085 = call ptr @__remill_atomic_end(ptr %v10084)
  store ptr %v10085, ptr %MEMORY, align 4
  store i32 %v10071, ptr %PC, align 4
  %v10086 = add i32 %v10071, 2
  store i32 %v10086, ptr %NEXT_PC, align 4
  %v10087 = load ptr, ptr %MEMORY, align 4
  %v10088 = call ptr @__remill_atomic_begin(ptr %v10087)
  store ptr %v10088, ptr %MEMORY, align 4
  %v10089 = add i32 %v10086, 30
  %v10090 = load ptr, ptr %MEMORY, align 4
  %v10091 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v10090, ptr %state, i32 %v10089, ptr %NEXT_PC)
  store ptr %v10091, ptr %MEMORY, align 4
  %v10092 = load ptr, ptr %MEMORY, align 4
  %v10093 = call ptr @__remill_atomic_end(ptr %v10092)
  store ptr %v10093, ptr %MEMORY, align 4
  br label %bb_4207956

bb_4207926:                                       ; preds = %bb_4207957
  store i32 %v10221, ptr %PC, align 4
  %v10094 = add i32 %v10221, 4
  store i32 %v10094, ptr %NEXT_PC, align 4
  %v10095 = load ptr, ptr %MEMORY, align 4
  %v10096 = call ptr @__remill_atomic_begin(ptr %v10095)
  store ptr %v10096, ptr %MEMORY, align 4
  %v10097 = load i32, ptr %EBP, align 4
  %v10098 = load i32, ptr %SSBASE, align 4
  %v10099 = sub i32 %v10097, 12
  %v10100 = add i32 %v10099, %v10098
  %v10101 = load i32, ptr %EBP, align 4
  %v10102 = load i32, ptr %SSBASE, align 4
  %v10103 = sub i32 %v10101, 12
  %v10104 = add i32 %v10103, %v10102
  %v10105 = load ptr, ptr %MEMORY, align 4
  %v10106 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10105, ptr %state, i32 %v10100, i32 %v10104, i32 1)
  store ptr %v10106, ptr %MEMORY, align 4
  %v10107 = load ptr, ptr %MEMORY, align 4
  %v10108 = call ptr @__remill_atomic_end(ptr %v10107)
  store ptr %v10108, ptr %MEMORY, align 4
  store i32 %v10094, ptr %PC, align 4
  %v10109 = add i32 %v10094, 3
  store i32 %v10109, ptr %NEXT_PC, align 4
  %v10110 = load ptr, ptr %MEMORY, align 4
  %v10111 = call ptr @__remill_atomic_begin(ptr %v10110)
  store ptr %v10111, ptr %MEMORY, align 4
  %v10112 = load i32, ptr %EBP, align 4
  %v10113 = load i32, ptr %SSBASE, align 4
  %v10114 = sub i32 %v10112, 12
  %v10115 = add i32 %v10114, %v10113
  %v10116 = load ptr, ptr %MEMORY, align 4
  %v10117 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10116, ptr %state, ptr %EAX, i32 %v10115)
  store ptr %v10117, ptr %MEMORY, align 4
  %v10118 = load ptr, ptr %MEMORY, align 4
  %v10119 = call ptr @__remill_atomic_end(ptr %v10118)
  store ptr %v10119, ptr %MEMORY, align 4
  store i32 %v10109, ptr %PC, align 4
  %v10120 = add i32 %v10109, 3
  store i32 %v10120, ptr %NEXT_PC, align 4
  %v10121 = load ptr, ptr %MEMORY, align 4
  %v10122 = call ptr @__remill_atomic_begin(ptr %v10121)
  store ptr %v10122, ptr %MEMORY, align 4
  %v10123 = load i32, ptr %EAX, align 4
  %v10124 = load i32, ptr %DSBASE, align 4
  %v10125 = add i32 %v10123, %v10124
  %v10126 = load ptr, ptr %MEMORY, align 4
  %v10127 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v10126, ptr %state, ptr %EAX, i32 %v10125)
  store ptr %v10127, ptr %MEMORY, align 4
  %v10128 = load ptr, ptr %MEMORY, align 4
  %v10129 = call ptr @__remill_atomic_end(ptr %v10128)
  store ptr %v10129, ptr %MEMORY, align 4
  store i32 %v10120, ptr %PC, align 4
  %v10130 = add i32 %v10120, 3
  store i32 %v10130, ptr %NEXT_PC, align 4
  %v10131 = load ptr, ptr %MEMORY, align 4
  %v10132 = call ptr @__remill_atomic_begin(ptr %v10131)
  store ptr %v10132, ptr %MEMORY, align 4
  %v10133 = load i8, ptr %AL, align 1
  %v10134 = zext i8 %v10133 to i32
  %v10135 = load ptr, ptr %MEMORY, align 4
  %v10136 = call ptr @_ZN12_GLOBAL__N_15MOVSXI3RnWIjE2RnIhLb1EEiEEP6MemoryS6_R5StateT_T0_(ptr %v10135, ptr %state, ptr %EAX, i32 %v10134)
  store ptr %v10136, ptr %MEMORY, align 4
  %v10137 = load ptr, ptr %MEMORY, align 4
  %v10138 = call ptr @__remill_atomic_end(ptr %v10137)
  store ptr %v10138, ptr %MEMORY, align 4
  store i32 %v10130, ptr %PC, align 4
  %v10139 = add i32 %v10130, 3
  store i32 %v10139, ptr %NEXT_PC, align 4
  %v10140 = load ptr, ptr %MEMORY, align 4
  %v10141 = call ptr @__remill_atomic_begin(ptr %v10140)
  store ptr %v10141, ptr %MEMORY, align 4
  %v10142 = load i32, ptr %EBP, align 4
  %v10143 = load i32, ptr %SSBASE, align 4
  %v10144 = add i32 %v10142, 16
  %v10145 = add i32 %v10144, %v10143
  %v10146 = load ptr, ptr %MEMORY, align 4
  %v10147 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10146, ptr %state, ptr %EDX, i32 %v10145)
  store ptr %v10147, ptr %MEMORY, align 4
  %v10148 = load ptr, ptr %MEMORY, align 4
  %v10149 = call ptr @__remill_atomic_end(ptr %v10148)
  store ptr %v10149, ptr %MEMORY, align 4
  store i32 %v10139, ptr %PC, align 4
  %v10150 = add i32 %v10139, 4
  store i32 %v10150, ptr %NEXT_PC, align 4
  %v10151 = load ptr, ptr %MEMORY, align 4
  %v10152 = call ptr @__remill_atomic_begin(ptr %v10151)
  store ptr %v10152, ptr %MEMORY, align 4
  %v10153 = load i32, ptr %ESP, align 4
  %v10154 = load i32, ptr %SSBASE, align 4
  %v10155 = add i32 %v10153, 4
  %v10156 = add i32 %v10155, %v10154
  %v10157 = load i32, ptr %EDX, align 4
  %v10158 = load ptr, ptr %MEMORY, align 4
  %v10159 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10158, ptr %state, i32 %v10156, i32 %v10157)
  store ptr %v10159, ptr %MEMORY, align 4
  %v10160 = load ptr, ptr %MEMORY, align 4
  %v10161 = call ptr @__remill_atomic_end(ptr %v10160)
  store ptr %v10161, ptr %MEMORY, align 4
  store i32 %v10150, ptr %PC, align 4
  %v10162 = add i32 %v10150, 3
  store i32 %v10162, ptr %NEXT_PC, align 4
  %v10163 = load ptr, ptr %MEMORY, align 4
  %v10164 = call ptr @__remill_atomic_begin(ptr %v10163)
  store ptr %v10164, ptr %MEMORY, align 4
  %v10165 = load i32, ptr %ESP, align 4
  %v10166 = load i32, ptr %SSBASE, align 4
  %v10167 = add i32 %v10165, %v10166
  %v10168 = load i32, ptr %EAX, align 4
  %v10169 = load ptr, ptr %MEMORY, align 4
  %v10170 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10169, ptr %state, i32 %v10167, i32 %v10168)
  store ptr %v10170, ptr %MEMORY, align 4
  %v10171 = load ptr, ptr %MEMORY, align 4
  %v10172 = call ptr @__remill_atomic_end(ptr %v10171)
  store ptr %v10172, ptr %MEMORY, align 4
  store i32 %v10162, ptr %PC, align 4
  %v10173 = add i32 %v10162, 5
  store i32 %v10173, ptr %NEXT_PC, align 4
  %v10174 = load ptr, ptr %MEMORY, align 4
  %v10175 = call ptr @__remill_atomic_begin(ptr %v10174)
  store ptr %v10175, ptr %MEMORY, align 4
  %v10176 = sub i32 %v10173, 1704
  %v10177 = load ptr, ptr %MEMORY, align 4
  %v10178 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v10177, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v10173, ptr %RETURN_PC)
  store ptr %v10178, ptr %MEMORY, align 4
  %v10179 = load ptr, ptr %MEMORY, align 4
  %v10180 = call ptr @__remill_atomic_end(ptr %v10179)
  store ptr %v10180, ptr %MEMORY, align 4
  store i32 %v10173, ptr %PC, align 4
  %v10181 = add i32 %v10173, 2
  store i32 %v10181, ptr %NEXT_PC, align 4
  %v10182 = load ptr, ptr %MEMORY, align 4
  %v10183 = call ptr @__remill_atomic_begin(ptr %v10182)
  store ptr %v10183, ptr %MEMORY, align 4
  %v10184 = add i32 %v10181, 1
  %v10185 = load ptr, ptr %MEMORY, align 4
  %v10186 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v10185, ptr %state, i32 %v10184, ptr %NEXT_PC)
  store ptr %v10186, ptr %MEMORY, align 4
  %v10187 = load ptr, ptr %MEMORY, align 4
  %v10188 = call ptr @__remill_atomic_end(ptr %v10187)
  store ptr %v10188, ptr %MEMORY, align 4
  br label %bb_4207957

bb_4207956:                                       ; preds = %bb_4207914, %bb_4207901, %bb_4207889, %bb_4207862
  %v10189 = load i32, ptr %NEXT_PC, align 4
  store i32 %v10189, ptr %PC, align 4
  %v10190 = add i32 %v10189, 1
  store i32 %v10190, ptr %NEXT_PC, align 4
  %v10191 = load ptr, ptr %MEMORY, align 4
  %v10192 = call ptr @__remill_atomic_begin(ptr %v10191)
  store ptr %v10192, ptr %MEMORY, align 4
  %v10193 = load ptr, ptr %MEMORY, align 4
  %v10194 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v10193, ptr %state)
  store ptr %v10194, ptr %MEMORY, align 4
  %v10195 = load ptr, ptr %MEMORY, align 4
  %v10196 = call ptr @__remill_atomic_end(ptr %v10195)
  store ptr %v10196, ptr %MEMORY, align 4
  br label %bb_4207957

bb_4207957:                                       ; preds = %bb_4207956, %bb_4207926
  %v10197 = load i32, ptr %NEXT_PC, align 4
  store i32 %v10197, ptr %PC, align 4
  %v10198 = add i32 %v10197, 3
  store i32 %v10198, ptr %NEXT_PC, align 4
  %v10199 = load ptr, ptr %MEMORY, align 4
  %v10200 = call ptr @__remill_atomic_begin(ptr %v10199)
  store ptr %v10200, ptr %MEMORY, align 4
  %v10201 = load i32, ptr %EBP, align 4
  %v10202 = load i32, ptr %SSBASE, align 4
  %v10203 = sub i32 %v10201, 24
  %v10204 = add i32 %v10203, %v10202
  %v10205 = load ptr, ptr %MEMORY, align 4
  %v10206 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10205, ptr %state, ptr %EAX, i32 %v10204)
  store ptr %v10206, ptr %MEMORY, align 4
  %v10207 = load ptr, ptr %MEMORY, align 4
  %v10208 = call ptr @__remill_atomic_end(ptr %v10207)
  store ptr %v10208, ptr %MEMORY, align 4
  store i32 %v10198, ptr %PC, align 4
  %v10209 = add i32 %v10198, 3
  store i32 %v10209, ptr %NEXT_PC, align 4
  %v10210 = load ptr, ptr %MEMORY, align 4
  %v10211 = call ptr @__remill_atomic_begin(ptr %v10210)
  store ptr %v10211, ptr %MEMORY, align 4
  %v10212 = load i32, ptr %EAX, align 4
  %v10213 = load i32, ptr %EBP, align 4
  %v10214 = load i32, ptr %SSBASE, align 4
  %v10215 = sub i32 %v10213, 12
  %v10216 = add i32 %v10215, %v10214
  %v10217 = load ptr, ptr %MEMORY, align 4
  %v10218 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10217, ptr %state, i32 %v10212, i32 %v10216)
  store ptr %v10218, ptr %MEMORY, align 4
  %v10219 = load ptr, ptr %MEMORY, align 4
  %v10220 = call ptr @__remill_atomic_end(ptr %v10219)
  store ptr %v10220, ptr %MEMORY, align 4
  store i32 %v10209, ptr %PC, align 4
  %v10221 = add i32 %v10209, 2
  store i32 %v10221, ptr %NEXT_PC, align 4
  %v10222 = load ptr, ptr %MEMORY, align 4
  %v10223 = call ptr @__remill_atomic_begin(ptr %v10222)
  store ptr %v10223, ptr %MEMORY, align 4
  %v10224 = sub i32 %v10221, 39
  %v10225 = load ptr, ptr %MEMORY, align 4
  %v10226 = call ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v10225, ptr %state, ptr %BRANCH_TAKEN, i32 %v10224, i32 %v10221, ptr %NEXT_PC)
  store ptr %v10226, ptr %MEMORY, align 4
  %v10227 = load ptr, ptr %MEMORY, align 4
  %v10228 = call ptr @__remill_atomic_end(ptr %v10227)
  store ptr %v10228, ptr %MEMORY, align 4
  br i1 true, label %bb_4207926, label %bb_4207965

bb_4207965:                                       ; preds = %bb_4207957
  store i32 %v10221, ptr %PC, align 4
  %v10229 = add i32 %v10221, 2
  store i32 %v10229, ptr %NEXT_PC, align 4
  %v10230 = load ptr, ptr %MEMORY, align 4
  %v10231 = call ptr @__remill_atomic_begin(ptr %v10230)
  store ptr %v10231, ptr %MEMORY, align 4
  %v10232 = add i32 %v10229, 19
  %v10233 = load ptr, ptr %MEMORY, align 4
  %v10234 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v10233, ptr %state, i32 %v10232, ptr %NEXT_PC)
  store ptr %v10234, ptr %MEMORY, align 4
  %v10235 = load ptr, ptr %MEMORY, align 4
  %v10236 = call ptr @__remill_atomic_end(ptr %v10235)
  store ptr %v10236, ptr %MEMORY, align 4
  br label %bb_4207986

bb_4207967:                                       ; preds = %bb_4207986
  store i32 %v10359, ptr %PC, align 4
  %v10237 = add i32 %v10359, 3
  store i32 %v10237, ptr %NEXT_PC, align 4
  %v10238 = load ptr, ptr %MEMORY, align 4
  %v10239 = call ptr @__remill_atomic_begin(ptr %v10238)
  store ptr %v10239, ptr %MEMORY, align 4
  %v10240 = load i32, ptr %EBP, align 4
  %v10241 = load i32, ptr %SSBASE, align 4
  %v10242 = add i32 %v10240, 16
  %v10243 = add i32 %v10242, %v10241
  %v10244 = load ptr, ptr %MEMORY, align 4
  %v10245 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10244, ptr %state, ptr %EAX, i32 %v10243)
  store ptr %v10245, ptr %MEMORY, align 4
  %v10246 = load ptr, ptr %MEMORY, align 4
  %v10247 = call ptr @__remill_atomic_end(ptr %v10246)
  store ptr %v10247, ptr %MEMORY, align 4
  store i32 %v10237, ptr %PC, align 4
  %v10248 = add i32 %v10237, 4
  store i32 %v10248, ptr %NEXT_PC, align 4
  %v10249 = load ptr, ptr %MEMORY, align 4
  %v10250 = call ptr @__remill_atomic_begin(ptr %v10249)
  store ptr %v10250, ptr %MEMORY, align 4
  %v10251 = load i32, ptr %ESP, align 4
  %v10252 = load i32, ptr %SSBASE, align 4
  %v10253 = add i32 %v10251, 4
  %v10254 = add i32 %v10253, %v10252
  %v10255 = load i32, ptr %EAX, align 4
  %v10256 = load ptr, ptr %MEMORY, align 4
  %v10257 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10256, ptr %state, i32 %v10254, i32 %v10255)
  store ptr %v10257, ptr %MEMORY, align 4
  %v10258 = load ptr, ptr %MEMORY, align 4
  %v10259 = call ptr @__remill_atomic_end(ptr %v10258)
  store ptr %v10259, ptr %MEMORY, align 4
  store i32 %v10248, ptr %PC, align 4
  %v10260 = add i32 %v10248, 7
  store i32 %v10260, ptr %NEXT_PC, align 4
  %v10261 = load ptr, ptr %MEMORY, align 4
  %v10262 = call ptr @__remill_atomic_begin(ptr %v10261)
  store ptr %v10262, ptr %MEMORY, align 4
  %v10263 = load i32, ptr %ESP, align 4
  %v10264 = load i32, ptr %SSBASE, align 4
  %v10265 = add i32 %v10263, %v10264
  %v10266 = load ptr, ptr %MEMORY, align 4
  %v10267 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10266, ptr %state, i32 %v10265, i32 32)
  store ptr %v10267, ptr %MEMORY, align 4
  %v10268 = load ptr, ptr %MEMORY, align 4
  %v10269 = call ptr @__remill_atomic_end(ptr %v10268)
  store ptr %v10269, ptr %MEMORY, align 4
  store i32 %v10260, ptr %PC, align 4
  %v10270 = add i32 %v10260, 5
  store i32 %v10270, ptr %NEXT_PC, align 4
  %v10271 = load ptr, ptr %MEMORY, align 4
  %v10272 = call ptr @__remill_atomic_begin(ptr %v10271)
  store ptr %v10272, ptr %MEMORY, align 4
  %v10273 = sub i32 %v10270, 1736
  %v10274 = load ptr, ptr %MEMORY, align 4
  %v10275 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v10274, ptr %state, i64 4206250, ptr %NEXT_PC, i32 %v10270, ptr %RETURN_PC)
  store ptr %v10275, ptr %MEMORY, align 4
  %v10276 = load ptr, ptr %MEMORY, align 4
  %v10277 = call ptr @__remill_atomic_end(ptr %v10276)
  store ptr %v10277, ptr %MEMORY, align 4
  ret ptr %memory

bb_4207986:                                       ; preds = %bb_4207965
  store i32 %v10229, ptr %PC, align 4
  %v10278 = add i32 %v10229, 3
  store i32 %v10278, ptr %NEXT_PC, align 4
  %v10279 = load ptr, ptr %MEMORY, align 4
  %v10280 = call ptr @__remill_atomic_begin(ptr %v10279)
  store ptr %v10280, ptr %MEMORY, align 4
  %v10281 = load i32, ptr %EBP, align 4
  %v10282 = load i32, ptr %SSBASE, align 4
  %v10283 = add i32 %v10281, 16
  %v10284 = add i32 %v10283, %v10282
  %v10285 = load ptr, ptr %MEMORY, align 4
  %v10286 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10285, ptr %state, ptr %EAX, i32 %v10284)
  store ptr %v10286, ptr %MEMORY, align 4
  %v10287 = load ptr, ptr %MEMORY, align 4
  %v10288 = call ptr @__remill_atomic_end(ptr %v10287)
  store ptr %v10288, ptr %MEMORY, align 4
  store i32 %v10278, ptr %PC, align 4
  %v10289 = add i32 %v10278, 3
  store i32 %v10289, ptr %NEXT_PC, align 4
  %v10290 = load ptr, ptr %MEMORY, align 4
  %v10291 = call ptr @__remill_atomic_begin(ptr %v10290)
  store ptr %v10291, ptr %MEMORY, align 4
  %v10292 = load i32, ptr %EAX, align 4
  %v10293 = load i32, ptr %DSBASE, align 4
  %v10294 = add i32 %v10292, 8
  %v10295 = add i32 %v10294, %v10293
  %v10296 = load ptr, ptr %MEMORY, align 4
  %v10297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10296, ptr %state, ptr %EAX, i32 %v10295)
  store ptr %v10297, ptr %MEMORY, align 4
  %v10298 = load ptr, ptr %MEMORY, align 4
  %v10299 = call ptr @__remill_atomic_end(ptr %v10298)
  store ptr %v10299, ptr %MEMORY, align 4
  store i32 %v10289, ptr %PC, align 4
  %v10300 = add i32 %v10289, 2
  store i32 %v10300, ptr %NEXT_PC, align 4
  %v10301 = load ptr, ptr %MEMORY, align 4
  %v10302 = call ptr @__remill_atomic_begin(ptr %v10301)
  store ptr %v10302, ptr %MEMORY, align 4
  %v10303 = load i32, ptr %EAX, align 4
  %v10304 = load i32, ptr %EAX, align 4
  %v10305 = load ptr, ptr %MEMORY, align 4
  %v10306 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v10305, ptr %state, i32 %v10303, i32 %v10304)
  store ptr %v10306, ptr %MEMORY, align 4
  %v10307 = load ptr, ptr %MEMORY, align 4
  %v10308 = call ptr @__remill_atomic_end(ptr %v10307)
  store ptr %v10308, ptr %MEMORY, align 4
  store i32 %v10300, ptr %PC, align 4
  %v10309 = add i32 %v10300, 3
  store i32 %v10309, ptr %NEXT_PC, align 4
  %v10310 = load ptr, ptr %MEMORY, align 4
  %v10311 = call ptr @__remill_atomic_begin(ptr %v10310)
  store ptr %v10311, ptr %MEMORY, align 4
  %v10312 = load ptr, ptr %MEMORY, align 4
  %v10313 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v10312, ptr %state, ptr %DL)
  store ptr %v10313, ptr %MEMORY, align 4
  %v10314 = load ptr, ptr %MEMORY, align 4
  %v10315 = call ptr @__remill_atomic_end(ptr %v10314)
  store ptr %v10315, ptr %MEMORY, align 4
  store i32 %v10309, ptr %PC, align 4
  %v10316 = add i32 %v10309, 3
  store i32 %v10316, ptr %NEXT_PC, align 4
  %v10317 = load ptr, ptr %MEMORY, align 4
  %v10318 = call ptr @__remill_atomic_begin(ptr %v10317)
  store ptr %v10318, ptr %MEMORY, align 4
  %v10319 = load i32, ptr %EAX, align 4
  %v10320 = sub i32 %v10319, 1
  %v10321 = load ptr, ptr %MEMORY, align 4
  %v10322 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v10321, ptr %state, ptr %ECX, i32 %v10320)
  store ptr %v10322, ptr %MEMORY, align 4
  %v10323 = load ptr, ptr %MEMORY, align 4
  %v10324 = call ptr @__remill_atomic_end(ptr %v10323)
  store ptr %v10324, ptr %MEMORY, align 4
  store i32 %v10316, ptr %PC, align 4
  %v10325 = add i32 %v10316, 3
  store i32 %v10325, ptr %NEXT_PC, align 4
  %v10326 = load ptr, ptr %MEMORY, align 4
  %v10327 = call ptr @__remill_atomic_begin(ptr %v10326)
  store ptr %v10327, ptr %MEMORY, align 4
  %v10328 = load i32, ptr %EBP, align 4
  %v10329 = load i32, ptr %SSBASE, align 4
  %v10330 = add i32 %v10328, 16
  %v10331 = add i32 %v10330, %v10329
  %v10332 = load ptr, ptr %MEMORY, align 4
  %v10333 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10332, ptr %state, ptr %EAX, i32 %v10331)
  store ptr %v10333, ptr %MEMORY, align 4
  %v10334 = load ptr, ptr %MEMORY, align 4
  %v10335 = call ptr @__remill_atomic_end(ptr %v10334)
  store ptr %v10335, ptr %MEMORY, align 4
  store i32 %v10325, ptr %PC, align 4
  %v10336 = add i32 %v10325, 3
  store i32 %v10336, ptr %NEXT_PC, align 4
  %v10337 = load ptr, ptr %MEMORY, align 4
  %v10338 = call ptr @__remill_atomic_begin(ptr %v10337)
  store ptr %v10338, ptr %MEMORY, align 4
  %v10339 = load i32, ptr %EAX, align 4
  %v10340 = load i32, ptr %DSBASE, align 4
  %v10341 = add i32 %v10339, 8
  %v10342 = add i32 %v10341, %v10340
  %v10343 = load i32, ptr %ECX, align 4
  %v10344 = load ptr, ptr %MEMORY, align 4
  %v10345 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10344, ptr %state, i32 %v10342, i32 %v10343)
  store ptr %v10345, ptr %MEMORY, align 4
  %v10346 = load ptr, ptr %MEMORY, align 4
  %v10347 = call ptr @__remill_atomic_end(ptr %v10346)
  store ptr %v10347, ptr %MEMORY, align 4
  store i32 %v10336, ptr %PC, align 4
  %v10348 = add i32 %v10336, 2
  store i32 %v10348, ptr %NEXT_PC, align 4
  %v10349 = load ptr, ptr %MEMORY, align 4
  %v10350 = call ptr @__remill_atomic_begin(ptr %v10349)
  store ptr %v10350, ptr %MEMORY, align 4
  %v10351 = load i8, ptr %DL, align 1
  %v10352 = zext i8 %v10351 to i32
  %v10353 = load i8, ptr %DL, align 1
  %v10354 = zext i8 %v10353 to i32
  %v10355 = load ptr, ptr %MEMORY, align 4
  %v10356 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v10355, ptr %state, i32 %v10352, i32 %v10354)
  store ptr %v10356, ptr %MEMORY, align 4
  %v10357 = load ptr, ptr %MEMORY, align 4
  %v10358 = call ptr @__remill_atomic_end(ptr %v10357)
  store ptr %v10358, ptr %MEMORY, align 4
  store i32 %v10348, ptr %PC, align 4
  %v10359 = add i32 %v10348, 2
  store i32 %v10359, ptr %NEXT_PC, align 4
  %v10360 = load ptr, ptr %MEMORY, align 4
  %v10361 = call ptr @__remill_atomic_begin(ptr %v10360)
  store ptr %v10361, ptr %MEMORY, align 4
  %v10362 = sub i32 %v10359, 43
  %v10363 = load ptr, ptr %MEMORY, align 4
  %v10364 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v10363, ptr %state, ptr %BRANCH_TAKEN, i32 %v10362, i32 %v10359, ptr %NEXT_PC)
  store ptr %v10364, ptr %MEMORY, align 4
  %v10365 = load ptr, ptr %MEMORY, align 4
  %v10366 = call ptr @__remill_atomic_end(ptr %v10365)
  store ptr %v10366, ptr %MEMORY, align 4
  br i1 true, label %bb_4207967, label %bb_4208010

bb_4208010:                                       ; preds = %bb_4207986
  store i32 %v10359, ptr %PC, align 4
  %v10367 = add i32 %v10359, 2
  store i32 %v10367, ptr %NEXT_PC, align 4
  %v10368 = load ptr, ptr %MEMORY, align 4
  %v10369 = call ptr @__remill_atomic_begin(ptr %v10368)
  store ptr %v10369, ptr %MEMORY, align 4
  %v10370 = load i32, ptr %EBX, align 4
  %v10371 = load ptr, ptr %MEMORY, align 4
  %v10372 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10371, ptr %state, ptr %ESP, i32 %v10370)
  store ptr %v10372, ptr %MEMORY, align 4
  %v10373 = load ptr, ptr %MEMORY, align 4
  %v10374 = call ptr @__remill_atomic_end(ptr %v10373)
  store ptr %v10374, ptr %MEMORY, align 4
  store i32 %v10367, ptr %PC, align 4
  %v10375 = add i32 %v10367, 3
  store i32 %v10375, ptr %NEXT_PC, align 4
  %v10376 = load ptr, ptr %MEMORY, align 4
  %v10377 = call ptr @__remill_atomic_begin(ptr %v10376)
  store ptr %v10377, ptr %MEMORY, align 4
  %v10378 = load i32, ptr %EBP, align 4
  %v10379 = sub i32 %v10378, 8
  %v10380 = load ptr, ptr %MEMORY, align 4
  %v10381 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v10380, ptr %state, ptr %ESP, i32 %v10379)
  store ptr %v10381, ptr %MEMORY, align 4
  %v10382 = load ptr, ptr %MEMORY, align 4
  %v10383 = call ptr @__remill_atomic_end(ptr %v10382)
  store ptr %v10383, ptr %MEMORY, align 4
  store i32 %v10375, ptr %PC, align 4
  %v10384 = add i32 %v10375, 1
  store i32 %v10384, ptr %NEXT_PC, align 4
  %v10385 = load ptr, ptr %MEMORY, align 4
  %v10386 = call ptr @__remill_atomic_begin(ptr %v10385)
  store ptr %v10386, ptr %MEMORY, align 4
  %v10387 = load ptr, ptr %MEMORY, align 4
  %v10388 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v10387, ptr %state, ptr %EBX)
  store ptr %v10388, ptr %MEMORY, align 4
  %v10389 = load ptr, ptr %MEMORY, align 4
  %v10390 = call ptr @__remill_atomic_end(ptr %v10389)
  store ptr %v10390, ptr %MEMORY, align 4
  store i32 %v10384, ptr %PC, align 4
  %v10391 = add i32 %v10384, 1
  store i32 %v10391, ptr %NEXT_PC, align 4
  %v10392 = load ptr, ptr %MEMORY, align 4
  %v10393 = call ptr @__remill_atomic_begin(ptr %v10392)
  store ptr %v10393, ptr %MEMORY, align 4
  %v10394 = load ptr, ptr %MEMORY, align 4
  %v10395 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v10394, ptr %state, ptr %ESI)
  store ptr %v10395, ptr %MEMORY, align 4
  %v10396 = load ptr, ptr %MEMORY, align 4
  %v10397 = call ptr @__remill_atomic_end(ptr %v10396)
  store ptr %v10397, ptr %MEMORY, align 4
  store i32 %v10391, ptr %PC, align 4
  %v10398 = add i32 %v10391, 1
  store i32 %v10398, ptr %NEXT_PC, align 4
  %v10399 = load ptr, ptr %MEMORY, align 4
  %v10400 = call ptr @__remill_atomic_begin(ptr %v10399)
  store ptr %v10400, ptr %MEMORY, align 4
  %v10401 = load ptr, ptr %MEMORY, align 4
  %v10402 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v10401, ptr %state, ptr %EBP)
  store ptr %v10402, ptr %MEMORY, align 4
  %v10403 = load ptr, ptr %MEMORY, align 4
  %v10404 = call ptr @__remill_atomic_end(ptr %v10403)
  store ptr %v10404, ptr %MEMORY, align 4
  store i32 %v10398, ptr %PC, align 4
  %v10405 = add i32 %v10398, 1
  store i32 %v10405, ptr %NEXT_PC, align 4
  %v10406 = load ptr, ptr %MEMORY, align 4
  %v10407 = call ptr @__remill_atomic_begin(ptr %v10406)
  store ptr %v10407, ptr %MEMORY, align 4
  %v10408 = load ptr, ptr %MEMORY, align 4
  %v10409 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v10408, ptr %state, ptr %NEXT_PC)
  store ptr %v10409, ptr %MEMORY, align 4
  %v10410 = load ptr, ptr %MEMORY, align 4
  %v10411 = call ptr @__remill_atomic_end(ptr %v10410)
  store ptr %v10411, ptr %MEMORY, align 4
  ret ptr %memory

bb_4208019:                                       ; No predecessors!
  %v10412 = load i32, ptr %NEXT_PC, align 4
  store i32 %v10412, ptr %PC, align 4
  %v10413 = add i32 %v10412, 1
  store i32 %v10413, ptr %NEXT_PC, align 4
  %v10414 = load ptr, ptr %MEMORY, align 4
  %v10415 = call ptr @__remill_atomic_begin(ptr %v10414)
  store ptr %v10415, ptr %MEMORY, align 4
  %v10416 = load i32, ptr %EBP, align 4
  %v10417 = load ptr, ptr %MEMORY, align 4
  %v10418 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v10417, ptr %state, i32 %v10416)
  store ptr %v10418, ptr %MEMORY, align 4
  %v10419 = load ptr, ptr %MEMORY, align 4
  %v10420 = call ptr @__remill_atomic_end(ptr %v10419)
  store ptr %v10420, ptr %MEMORY, align 4
  store i32 %v10413, ptr %PC, align 4
  %v10421 = add i32 %v10413, 2
  store i32 %v10421, ptr %NEXT_PC, align 4
  %v10422 = load ptr, ptr %MEMORY, align 4
  %v10423 = call ptr @__remill_atomic_begin(ptr %v10422)
  store ptr %v10423, ptr %MEMORY, align 4
  %v10424 = load i32, ptr %ESP, align 4
  %v10425 = load ptr, ptr %MEMORY, align 4
  %v10426 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10425, ptr %state, ptr %EBP, i32 %v10424)
  store ptr %v10426, ptr %MEMORY, align 4
  %v10427 = load ptr, ptr %MEMORY, align 4
  %v10428 = call ptr @__remill_atomic_end(ptr %v10427)
  store ptr %v10428, ptr %MEMORY, align 4
  store i32 %v10421, ptr %PC, align 4
  %v10429 = add i32 %v10421, 1
  store i32 %v10429, ptr %NEXT_PC, align 4
  %v10430 = load ptr, ptr %MEMORY, align 4
  %v10431 = call ptr @__remill_atomic_begin(ptr %v10430)
  store ptr %v10431, ptr %MEMORY, align 4
  %v10432 = load i32, ptr %ESI, align 4
  %v10433 = load ptr, ptr %MEMORY, align 4
  %v10434 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v10433, ptr %state, i32 %v10432)
  store ptr %v10434, ptr %MEMORY, align 4
  %v10435 = load ptr, ptr %MEMORY, align 4
  %v10436 = call ptr @__remill_atomic_end(ptr %v10435)
  store ptr %v10436, ptr %MEMORY, align 4
  store i32 %v10429, ptr %PC, align 4
  %v10437 = add i32 %v10429, 1
  store i32 %v10437, ptr %NEXT_PC, align 4
  %v10438 = load ptr, ptr %MEMORY, align 4
  %v10439 = call ptr @__remill_atomic_begin(ptr %v10438)
  store ptr %v10439, ptr %MEMORY, align 4
  %v10440 = load i32, ptr %EBX, align 4
  %v10441 = load ptr, ptr %MEMORY, align 4
  %v10442 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v10441, ptr %state, i32 %v10440)
  store ptr %v10442, ptr %MEMORY, align 4
  %v10443 = load ptr, ptr %MEMORY, align 4
  %v10444 = call ptr @__remill_atomic_end(ptr %v10443)
  store ptr %v10444, ptr %MEMORY, align 4
  store i32 %v10437, ptr %PC, align 4
  %v10445 = add i32 %v10437, 3
  store i32 %v10445, ptr %NEXT_PC, align 4
  %v10446 = load ptr, ptr %MEMORY, align 4
  %v10447 = call ptr @__remill_atomic_begin(ptr %v10446)
  store ptr %v10447, ptr %MEMORY, align 4
  %v10448 = load i32, ptr %ESP, align 4
  %v10449 = load ptr, ptr %MEMORY, align 4
  %v10450 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10449, ptr %state, ptr %ESP, i32 %v10448, i32 64)
  store ptr %v10450, ptr %MEMORY, align 4
  %v10451 = load ptr, ptr %MEMORY, align 4
  %v10452 = call ptr @__remill_atomic_end(ptr %v10451)
  store ptr %v10452, ptr %MEMORY, align 4
  store i32 %v10445, ptr %PC, align 4
  %v10453 = add i32 %v10445, 3
  store i32 %v10453, ptr %NEXT_PC, align 4
  %v10454 = load ptr, ptr %MEMORY, align 4
  %v10455 = call ptr @__remill_atomic_begin(ptr %v10454)
  store ptr %v10455, ptr %MEMORY, align 4
  %v10456 = load i32, ptr %EBP, align 4
  %v10457 = load i32, ptr %SSBASE, align 4
  %v10458 = add i32 %v10456, 12
  %v10459 = add i32 %v10458, %v10457
  %v10460 = load ptr, ptr %MEMORY, align 4
  %v10461 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10460, ptr %state, ptr %EAX, i32 %v10459)
  store ptr %v10461, ptr %MEMORY, align 4
  %v10462 = load ptr, ptr %MEMORY, align 4
  %v10463 = call ptr @__remill_atomic_end(ptr %v10462)
  store ptr %v10463, ptr %MEMORY, align 4
  store i32 %v10453, ptr %PC, align 4
  %v10464 = add i32 %v10453, 3
  store i32 %v10464, ptr %NEXT_PC, align 4
  %v10465 = load ptr, ptr %MEMORY, align 4
  %v10466 = call ptr @__remill_atomic_begin(ptr %v10465)
  store ptr %v10466, ptr %MEMORY, align 4
  %v10467 = load i32, ptr %EBP, align 4
  %v10468 = load i32, ptr %SSBASE, align 4
  %v10469 = sub i32 %v10467, 48
  %v10470 = add i32 %v10469, %v10468
  %v10471 = load i32, ptr %EAX, align 4
  %v10472 = load ptr, ptr %MEMORY, align 4
  %v10473 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10472, ptr %state, i32 %v10470, i32 %v10471)
  store ptr %v10473, ptr %MEMORY, align 4
  %v10474 = load ptr, ptr %MEMORY, align 4
  %v10475 = call ptr @__remill_atomic_end(ptr %v10474)
  store ptr %v10475, ptr %MEMORY, align 4
  store i32 %v10464, ptr %PC, align 4
  %v10476 = add i32 %v10464, 3
  store i32 %v10476, ptr %NEXT_PC, align 4
  %v10477 = load ptr, ptr %MEMORY, align 4
  %v10478 = call ptr @__remill_atomic_begin(ptr %v10477)
  store ptr %v10478, ptr %MEMORY, align 4
  %v10479 = load i32, ptr %EBP, align 4
  %v10480 = load i32, ptr %SSBASE, align 4
  %v10481 = add i32 %v10479, 16
  %v10482 = add i32 %v10481, %v10480
  %v10483 = load ptr, ptr %MEMORY, align 4
  %v10484 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10483, ptr %state, ptr %EAX, i32 %v10482)
  store ptr %v10484, ptr %MEMORY, align 4
  %v10485 = load ptr, ptr %MEMORY, align 4
  %v10486 = call ptr @__remill_atomic_end(ptr %v10485)
  store ptr %v10486, ptr %MEMORY, align 4
  store i32 %v10476, ptr %PC, align 4
  %v10487 = add i32 %v10476, 3
  store i32 %v10487, ptr %NEXT_PC, align 4
  %v10488 = load ptr, ptr %MEMORY, align 4
  %v10489 = call ptr @__remill_atomic_begin(ptr %v10488)
  store ptr %v10489, ptr %MEMORY, align 4
  %v10490 = load i32, ptr %EBP, align 4
  %v10491 = load i32, ptr %SSBASE, align 4
  %v10492 = sub i32 %v10490, 44
  %v10493 = add i32 %v10492, %v10491
  %v10494 = load i32, ptr %EAX, align 4
  %v10495 = load ptr, ptr %MEMORY, align 4
  %v10496 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10495, ptr %state, i32 %v10493, i32 %v10494)
  store ptr %v10496, ptr %MEMORY, align 4
  %v10497 = load ptr, ptr %MEMORY, align 4
  %v10498 = call ptr @__remill_atomic_end(ptr %v10497)
  store ptr %v10498, ptr %MEMORY, align 4
  store i32 %v10487, ptr %PC, align 4
  %v10499 = add i32 %v10487, 2
  store i32 %v10499, ptr %NEXT_PC, align 4
  %v10500 = load ptr, ptr %MEMORY, align 4
  %v10501 = call ptr @__remill_atomic_begin(ptr %v10500)
  store ptr %v10501, ptr %MEMORY, align 4
  %v10502 = load i32, ptr %ESP, align 4
  %v10503 = load ptr, ptr %MEMORY, align 4
  %v10504 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10503, ptr %state, ptr %EAX, i32 %v10502)
  store ptr %v10504, ptr %MEMORY, align 4
  %v10505 = load ptr, ptr %MEMORY, align 4
  %v10506 = call ptr @__remill_atomic_end(ptr %v10505)
  store ptr %v10506, ptr %MEMORY, align 4
  store i32 %v10499, ptr %PC, align 4
  %v10507 = add i32 %v10499, 2
  store i32 %v10507, ptr %NEXT_PC, align 4
  %v10508 = load ptr, ptr %MEMORY, align 4
  %v10509 = call ptr @__remill_atomic_begin(ptr %v10508)
  store ptr %v10509, ptr %MEMORY, align 4
  %v10510 = load i32, ptr %EAX, align 4
  %v10511 = load ptr, ptr %MEMORY, align 4
  %v10512 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10511, ptr %state, ptr %EBX, i32 %v10510)
  store ptr %v10512, ptr %MEMORY, align 4
  %v10513 = load ptr, ptr %MEMORY, align 4
  %v10514 = call ptr @__remill_atomic_end(ptr %v10513)
  store ptr %v10514, ptr %MEMORY, align 4
  store i32 %v10507, ptr %PC, align 4
  %v10515 = add i32 %v10507, 4
  store i32 %v10515, ptr %NEXT_PC, align 4
  %v10516 = load ptr, ptr %MEMORY, align 4
  %v10517 = call ptr @__remill_atomic_begin(ptr %v10516)
  store ptr %v10517, ptr %MEMORY, align 4
  %v10518 = load i32, ptr %EBP, align 4
  %v10519 = load i32, ptr %SSBASE, align 4
  %v10520 = add i32 %v10518, 8
  %v10521 = add i32 %v10520, %v10519
  %v10522 = load ptr, ptr %MEMORY, align 4
  %v10523 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10522, ptr %state, i32 %v10521, i32 111)
  store ptr %v10523, ptr %MEMORY, align 4
  %v10524 = load ptr, ptr %MEMORY, align 4
  %v10525 = call ptr @__remill_atomic_end(ptr %v10524)
  store ptr %v10525, ptr %MEMORY, align 4
  store i32 %v10515, ptr %PC, align 4
  %v10526 = add i32 %v10515, 2
  store i32 %v10526, ptr %NEXT_PC, align 4
  %v10527 = load ptr, ptr %MEMORY, align 4
  %v10528 = call ptr @__remill_atomic_begin(ptr %v10527)
  store ptr %v10528, ptr %MEMORY, align 4
  %v10529 = add i32 %v10526, 7
  %v10530 = load ptr, ptr %MEMORY, align 4
  %v10531 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v10530, ptr %state, ptr %BRANCH_TAKEN, i32 %v10529, i32 %v10526, ptr %NEXT_PC)
  store ptr %v10531, ptr %MEMORY, align 4
  %v10532 = load ptr, ptr %MEMORY, align 4
  %v10533 = call ptr @__remill_atomic_end(ptr %v10532)
  store ptr %v10533, ptr %MEMORY, align 4
  br i1 true, label %bb_4208056, label %bb_4208049

bb_4208049:                                       ; preds = %bb_4208019
  store i32 %v10526, ptr %PC, align 4
  %v10534 = add i32 %v10526, 5
  store i32 %v10534, ptr %NEXT_PC, align 4
  %v10535 = load ptr, ptr %MEMORY, align 4
  %v10536 = call ptr @__remill_atomic_begin(ptr %v10535)
  store ptr %v10536, ptr %MEMORY, align 4
  %v10537 = load ptr, ptr %MEMORY, align 4
  %v10538 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10537, ptr %state, ptr %EAX, i32 7)
  store ptr %v10538, ptr %MEMORY, align 4
  %v10539 = load ptr, ptr %MEMORY, align 4
  %v10540 = call ptr @__remill_atomic_end(ptr %v10539)
  store ptr %v10540, ptr %MEMORY, align 4
  store i32 %v10534, ptr %PC, align 4
  %v10541 = add i32 %v10534, 2
  store i32 %v10541, ptr %NEXT_PC, align 4
  %v10542 = load ptr, ptr %MEMORY, align 4
  %v10543 = call ptr @__remill_atomic_begin(ptr %v10542)
  store ptr %v10543, ptr %MEMORY, align 4
  %v10544 = add i32 %v10541, 5
  %v10545 = load ptr, ptr %MEMORY, align 4
  %v10546 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v10545, ptr %state, i32 %v10544, ptr %NEXT_PC)
  store ptr %v10546, ptr %MEMORY, align 4
  %v10547 = load ptr, ptr %MEMORY, align 4
  %v10548 = call ptr @__remill_atomic_end(ptr %v10547)
  store ptr %v10548, ptr %MEMORY, align 4
  br label %bb_4208061

bb_4208056:                                       ; preds = %bb_4208019
  store i32 %v10526, ptr %PC, align 4
  %v10549 = add i32 %v10526, 5
  store i32 %v10549, ptr %NEXT_PC, align 4
  %v10550 = load ptr, ptr %MEMORY, align 4
  %v10551 = call ptr @__remill_atomic_begin(ptr %v10550)
  store ptr %v10551, ptr %MEMORY, align 4
  %v10552 = load ptr, ptr %MEMORY, align 4
  %v10553 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10552, ptr %state, ptr %EAX, i32 15)
  store ptr %v10553, ptr %MEMORY, align 4
  %v10554 = load ptr, ptr %MEMORY, align 4
  %v10555 = call ptr @__remill_atomic_end(ptr %v10554)
  store ptr %v10555, ptr %MEMORY, align 4
  br label %bb_4208061

bb_4208061:                                       ; preds = %bb_4208056, %bb_4208049
  %v10556 = load i32, ptr %NEXT_PC, align 4
  store i32 %v10556, ptr %PC, align 4
  %v10557 = add i32 %v10556, 3
  store i32 %v10557, ptr %NEXT_PC, align 4
  %v10558 = load ptr, ptr %MEMORY, align 4
  %v10559 = call ptr @__remill_atomic_begin(ptr %v10558)
  store ptr %v10559, ptr %MEMORY, align 4
  %v10560 = load i32, ptr %EBP, align 4
  %v10561 = load i32, ptr %SSBASE, align 4
  %v10562 = sub i32 %v10560, 20
  %v10563 = add i32 %v10562, %v10561
  %v10564 = load i32, ptr %EAX, align 4
  %v10565 = load ptr, ptr %MEMORY, align 4
  %v10566 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10565, ptr %state, i32 %v10563, i32 %v10564)
  store ptr %v10566, ptr %MEMORY, align 4
  %v10567 = load ptr, ptr %MEMORY, align 4
  %v10568 = call ptr @__remill_atomic_end(ptr %v10567)
  store ptr %v10568, ptr %MEMORY, align 4
  store i32 %v10557, ptr %PC, align 4
  %v10569 = add i32 %v10557, 4
  store i32 %v10569, ptr %NEXT_PC, align 4
  %v10570 = load ptr, ptr %MEMORY, align 4
  %v10571 = call ptr @__remill_atomic_begin(ptr %v10570)
  store ptr %v10571, ptr %MEMORY, align 4
  %v10572 = load i32, ptr %EBP, align 4
  %v10573 = load i32, ptr %SSBASE, align 4
  %v10574 = add i32 %v10572, 8
  %v10575 = add i32 %v10574, %v10573
  %v10576 = load ptr, ptr %MEMORY, align 4
  %v10577 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10576, ptr %state, i32 %v10575, i32 111)
  store ptr %v10577, ptr %MEMORY, align 4
  %v10578 = load ptr, ptr %MEMORY, align 4
  %v10579 = call ptr @__remill_atomic_end(ptr %v10578)
  store ptr %v10579, ptr %MEMORY, align 4
  store i32 %v10569, ptr %PC, align 4
  %v10580 = add i32 %v10569, 2
  store i32 %v10580, ptr %NEXT_PC, align 4
  %v10581 = load ptr, ptr %MEMORY, align 4
  %v10582 = call ptr @__remill_atomic_begin(ptr %v10581)
  store ptr %v10582, ptr %MEMORY, align 4
  %v10583 = add i32 %v10580, 7
  %v10584 = load ptr, ptr %MEMORY, align 4
  %v10585 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v10584, ptr %state, ptr %BRANCH_TAKEN, i32 %v10583, i32 %v10580, ptr %NEXT_PC)
  store ptr %v10585, ptr %MEMORY, align 4
  %v10586 = load ptr, ptr %MEMORY, align 4
  %v10587 = call ptr @__remill_atomic_end(ptr %v10586)
  store ptr %v10587, ptr %MEMORY, align 4
  br i1 true, label %bb_4208077, label %bb_4208070

bb_4208070:                                       ; preds = %bb_4208061
  store i32 %v10580, ptr %PC, align 4
  %v10588 = add i32 %v10580, 5
  store i32 %v10588, ptr %NEXT_PC, align 4
  %v10589 = load ptr, ptr %MEMORY, align 4
  %v10590 = call ptr @__remill_atomic_begin(ptr %v10589)
  store ptr %v10590, ptr %MEMORY, align 4
  %v10591 = load ptr, ptr %MEMORY, align 4
  %v10592 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10591, ptr %state, ptr %EAX, i32 3)
  store ptr %v10592, ptr %MEMORY, align 4
  %v10593 = load ptr, ptr %MEMORY, align 4
  %v10594 = call ptr @__remill_atomic_end(ptr %v10593)
  store ptr %v10594, ptr %MEMORY, align 4
  store i32 %v10588, ptr %PC, align 4
  %v10595 = add i32 %v10588, 2
  store i32 %v10595, ptr %NEXT_PC, align 4
  %v10596 = load ptr, ptr %MEMORY, align 4
  %v10597 = call ptr @__remill_atomic_begin(ptr %v10596)
  store ptr %v10597, ptr %MEMORY, align 4
  %v10598 = add i32 %v10595, 5
  %v10599 = load ptr, ptr %MEMORY, align 4
  %v10600 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v10599, ptr %state, i32 %v10598, ptr %NEXT_PC)
  store ptr %v10600, ptr %MEMORY, align 4
  %v10601 = load ptr, ptr %MEMORY, align 4
  %v10602 = call ptr @__remill_atomic_end(ptr %v10601)
  store ptr %v10602, ptr %MEMORY, align 4
  br label %bb_4208082

bb_4208077:                                       ; preds = %bb_4208061
  store i32 %v10580, ptr %PC, align 4
  %v10603 = add i32 %v10580, 5
  store i32 %v10603, ptr %NEXT_PC, align 4
  %v10604 = load ptr, ptr %MEMORY, align 4
  %v10605 = call ptr @__remill_atomic_begin(ptr %v10604)
  store ptr %v10605, ptr %MEMORY, align 4
  %v10606 = load ptr, ptr %MEMORY, align 4
  %v10607 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10606, ptr %state, ptr %EAX, i32 4)
  store ptr %v10607, ptr %MEMORY, align 4
  %v10608 = load ptr, ptr %MEMORY, align 4
  %v10609 = call ptr @__remill_atomic_end(ptr %v10608)
  store ptr %v10609, ptr %MEMORY, align 4
  br label %bb_4208082

bb_4208082:                                       ; preds = %bb_4208077, %bb_4208070
  %v10610 = load i32, ptr %NEXT_PC, align 4
  store i32 %v10610, ptr %PC, align 4
  %v10611 = add i32 %v10610, 3
  store i32 %v10611, ptr %NEXT_PC, align 4
  %v10612 = load ptr, ptr %MEMORY, align 4
  %v10613 = call ptr @__remill_atomic_begin(ptr %v10612)
  store ptr %v10613, ptr %MEMORY, align 4
  %v10614 = load i32, ptr %EBP, align 4
  %v10615 = load i32, ptr %SSBASE, align 4
  %v10616 = sub i32 %v10614, 24
  %v10617 = add i32 %v10616, %v10615
  %v10618 = load i32, ptr %EAX, align 4
  %v10619 = load ptr, ptr %MEMORY, align 4
  %v10620 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10619, ptr %state, i32 %v10617, i32 %v10618)
  store ptr %v10620, ptr %MEMORY, align 4
  %v10621 = load ptr, ptr %MEMORY, align 4
  %v10622 = call ptr @__remill_atomic_end(ptr %v10621)
  store ptr %v10622, ptr %MEMORY, align 4
  store i32 %v10611, ptr %PC, align 4
  %v10623 = add i32 %v10611, 3
  store i32 %v10623, ptr %NEXT_PC, align 4
  %v10624 = load ptr, ptr %MEMORY, align 4
  %v10625 = call ptr @__remill_atomic_begin(ptr %v10624)
  store ptr %v10625, ptr %MEMORY, align 4
  %v10626 = load i32, ptr %EBP, align 4
  %v10627 = load i32, ptr %SSBASE, align 4
  %v10628 = add i32 %v10626, 20
  %v10629 = add i32 %v10628, %v10627
  %v10630 = load ptr, ptr %MEMORY, align 4
  %v10631 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10630, ptr %state, ptr %EAX, i32 %v10629)
  store ptr %v10631, ptr %MEMORY, align 4
  %v10632 = load ptr, ptr %MEMORY, align 4
  %v10633 = call ptr @__remill_atomic_end(ptr %v10632)
  store ptr %v10633, ptr %MEMORY, align 4
  store i32 %v10623, ptr %PC, align 4
  %v10634 = add i32 %v10623, 4
  store i32 %v10634, ptr %NEXT_PC, align 4
  %v10635 = load ptr, ptr %MEMORY, align 4
  %v10636 = call ptr @__remill_atomic_begin(ptr %v10635)
  store ptr %v10636, ptr %MEMORY, align 4
  %v10637 = load i32, ptr %ESP, align 4
  %v10638 = load i32, ptr %SSBASE, align 4
  %v10639 = add i32 %v10637, 8
  %v10640 = add i32 %v10639, %v10638
  %v10641 = load i32, ptr %EAX, align 4
  %v10642 = load ptr, ptr %MEMORY, align 4
  %v10643 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10642, ptr %state, i32 %v10640, i32 %v10641)
  store ptr %v10643, ptr %MEMORY, align 4
  %v10644 = load ptr, ptr %MEMORY, align 4
  %v10645 = call ptr @__remill_atomic_end(ptr %v10644)
  store ptr %v10645, ptr %MEMORY, align 4
  store i32 %v10634, ptr %PC, align 4
  %v10646 = add i32 %v10634, 3
  store i32 %v10646, ptr %NEXT_PC, align 4
  %v10647 = load ptr, ptr %MEMORY, align 4
  %v10648 = call ptr @__remill_atomic_begin(ptr %v10647)
  store ptr %v10648, ptr %MEMORY, align 4
  %v10649 = load i32, ptr %EBP, align 4
  %v10650 = load i32, ptr %SSBASE, align 4
  %v10651 = sub i32 %v10649, 24
  %v10652 = add i32 %v10651, %v10650
  %v10653 = load ptr, ptr %MEMORY, align 4
  %v10654 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10653, ptr %state, ptr %EAX, i32 %v10652)
  store ptr %v10654, ptr %MEMORY, align 4
  %v10655 = load ptr, ptr %MEMORY, align 4
  %v10656 = call ptr @__remill_atomic_end(ptr %v10655)
  store ptr %v10656, ptr %MEMORY, align 4
  store i32 %v10646, ptr %PC, align 4
  %v10657 = add i32 %v10646, 4
  store i32 %v10657, ptr %NEXT_PC, align 4
  %v10658 = load ptr, ptr %MEMORY, align 4
  %v10659 = call ptr @__remill_atomic_begin(ptr %v10658)
  store ptr %v10659, ptr %MEMORY, align 4
  %v10660 = load i32, ptr %ESP, align 4
  %v10661 = load i32, ptr %SSBASE, align 4
  %v10662 = add i32 %v10660, 4
  %v10663 = add i32 %v10662, %v10661
  %v10664 = load i32, ptr %EAX, align 4
  %v10665 = load ptr, ptr %MEMORY, align 4
  %v10666 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10665, ptr %state, i32 %v10663, i32 %v10664)
  store ptr %v10666, ptr %MEMORY, align 4
  %v10667 = load ptr, ptr %MEMORY, align 4
  %v10668 = call ptr @__remill_atomic_end(ptr %v10667)
  store ptr %v10668, ptr %MEMORY, align 4
  store i32 %v10657, ptr %PC, align 4
  %v10669 = add i32 %v10657, 7
  store i32 %v10669, ptr %NEXT_PC, align 4
  %v10670 = load ptr, ptr %MEMORY, align 4
  %v10671 = call ptr @__remill_atomic_begin(ptr %v10670)
  store ptr %v10671, ptr %MEMORY, align 4
  %v10672 = load i32, ptr %ESP, align 4
  %v10673 = load i32, ptr %SSBASE, align 4
  %v10674 = add i32 %v10672, %v10673
  %v10675 = load ptr, ptr %MEMORY, align 4
  %v10676 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10675, ptr %state, i32 %v10674, i32 2)
  store ptr %v10676, ptr %MEMORY, align 4
  %v10677 = load ptr, ptr %MEMORY, align 4
  %v10678 = call ptr @__remill_atomic_end(ptr %v10677)
  store ptr %v10678, ptr %MEMORY, align 4
  store i32 %v10669, ptr %PC, align 4
  %v10679 = add i32 %v10669, 5
  store i32 %v10679, ptr %NEXT_PC, align 4
  %v10680 = load ptr, ptr %MEMORY, align 4
  %v10681 = call ptr @__remill_atomic_begin(ptr %v10680)
  store ptr %v10681, ptr %MEMORY, align 4
  %v10682 = sub i32 %v10679, 1063
  %v10683 = load ptr, ptr %MEMORY, align 4
  %v10684 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v10683, ptr %state, i64 4207048, ptr %NEXT_PC, i32 %v10679, ptr %RETURN_PC)
  store ptr %v10684, ptr %MEMORY, align 4
  %v10685 = load ptr, ptr %MEMORY, align 4
  %v10686 = call ptr @__remill_atomic_end(ptr %v10685)
  store ptr %v10686, ptr %MEMORY, align 4
  store i32 %v10679, ptr %PC, align 4
  %v10687 = add i32 %v10679, 3
  store i32 %v10687, ptr %NEXT_PC, align 4
  %v10688 = load ptr, ptr %MEMORY, align 4
  %v10689 = call ptr @__remill_atomic_begin(ptr %v10688)
  store ptr %v10689, ptr %MEMORY, align 4
  %v10690 = load i32, ptr %EAX, align 4
  %v10691 = sub i32 %v10690, 1
  %v10692 = load ptr, ptr %MEMORY, align 4
  %v10693 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v10692, ptr %state, ptr %EDX, i32 %v10691)
  store ptr %v10693, ptr %MEMORY, align 4
  %v10694 = load ptr, ptr %MEMORY, align 4
  %v10695 = call ptr @__remill_atomic_end(ptr %v10694)
  store ptr %v10695, ptr %MEMORY, align 4
  store i32 %v10687, ptr %PC, align 4
  %v10696 = add i32 %v10687, 3
  store i32 %v10696, ptr %NEXT_PC, align 4
  %v10697 = load ptr, ptr %MEMORY, align 4
  %v10698 = call ptr @__remill_atomic_begin(ptr %v10697)
  store ptr %v10698, ptr %MEMORY, align 4
  %v10699 = load i32, ptr %EBP, align 4
  %v10700 = load i32, ptr %SSBASE, align 4
  %v10701 = sub i32 %v10699, 28
  %v10702 = add i32 %v10701, %v10700
  %v10703 = load i32, ptr %EDX, align 4
  %v10704 = load ptr, ptr %MEMORY, align 4
  %v10705 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10704, ptr %state, i32 %v10702, i32 %v10703)
  store ptr %v10705, ptr %MEMORY, align 4
  %v10706 = load ptr, ptr %MEMORY, align 4
  %v10707 = call ptr @__remill_atomic_end(ptr %v10706)
  store ptr %v10707, ptr %MEMORY, align 4
  store i32 %v10696, ptr %PC, align 4
  %v10708 = add i32 %v10696, 5
  store i32 %v10708, ptr %NEXT_PC, align 4
  %v10709 = load ptr, ptr %MEMORY, align 4
  %v10710 = call ptr @__remill_atomic_begin(ptr %v10709)
  store ptr %v10710, ptr %MEMORY, align 4
  %v10711 = load ptr, ptr %MEMORY, align 4
  %v10712 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10711, ptr %state, ptr %EDX, i32 16)
  store ptr %v10712, ptr %MEMORY, align 4
  %v10713 = load ptr, ptr %MEMORY, align 4
  %v10714 = call ptr @__remill_atomic_end(ptr %v10713)
  store ptr %v10714, ptr %MEMORY, align 4
  store i32 %v10708, ptr %PC, align 4
  %v10715 = add i32 %v10708, 3
  store i32 %v10715, ptr %NEXT_PC, align 4
  %v10716 = load ptr, ptr %MEMORY, align 4
  %v10717 = call ptr @__remill_atomic_begin(ptr %v10716)
  store ptr %v10717, ptr %MEMORY, align 4
  %v10718 = load i32, ptr %EDX, align 4
  %v10719 = load ptr, ptr %MEMORY, align 4
  %v10720 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10719, ptr %state, ptr %EDX, i32 %v10718, i32 1)
  store ptr %v10720, ptr %MEMORY, align 4
  %v10721 = load ptr, ptr %MEMORY, align 4
  %v10722 = call ptr @__remill_atomic_end(ptr %v10721)
  store ptr %v10722, ptr %MEMORY, align 4
  store i32 %v10715, ptr %PC, align 4
  %v10723 = add i32 %v10715, 2
  store i32 %v10723, ptr %NEXT_PC, align 4
  %v10724 = load ptr, ptr %MEMORY, align 4
  %v10725 = call ptr @__remill_atomic_begin(ptr %v10724)
  store ptr %v10725, ptr %MEMORY, align 4
  %v10726 = load i32, ptr %EAX, align 4
  %v10727 = load i32, ptr %EDX, align 4
  %v10728 = load ptr, ptr %MEMORY, align 4
  %v10729 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v10728, ptr %state, ptr %EAX, i32 %v10726, i32 %v10727)
  store ptr %v10729, ptr %MEMORY, align 4
  %v10730 = load ptr, ptr %MEMORY, align 4
  %v10731 = call ptr @__remill_atomic_end(ptr %v10730)
  store ptr %v10731, ptr %MEMORY, align 4
  store i32 %v10723, ptr %PC, align 4
  %v10732 = add i32 %v10723, 7
  store i32 %v10732, ptr %NEXT_PC, align 4
  %v10733 = load ptr, ptr %MEMORY, align 4
  %v10734 = call ptr @__remill_atomic_begin(ptr %v10733)
  store ptr %v10734, ptr %MEMORY, align 4
  %v10735 = load i32, ptr %EBP, align 4
  %v10736 = load i32, ptr %SSBASE, align 4
  %v10737 = sub i32 %v10735, 52
  %v10738 = add i32 %v10737, %v10736
  %v10739 = load ptr, ptr %MEMORY, align 4
  %v10740 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10739, ptr %state, i32 %v10738, i32 16)
  store ptr %v10740, ptr %MEMORY, align 4
  %v10741 = load ptr, ptr %MEMORY, align 4
  %v10742 = call ptr @__remill_atomic_end(ptr %v10741)
  store ptr %v10742, ptr %MEMORY, align 4
  store i32 %v10732, ptr %PC, align 4
  %v10743 = add i32 %v10732, 5
  store i32 %v10743, ptr %NEXT_PC, align 4
  %v10744 = load ptr, ptr %MEMORY, align 4
  %v10745 = call ptr @__remill_atomic_begin(ptr %v10744)
  store ptr %v10745, ptr %MEMORY, align 4
  %v10746 = load ptr, ptr %MEMORY, align 4
  %v10747 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10746, ptr %state, ptr %EDX, i32 0)
  store ptr %v10747, ptr %MEMORY, align 4
  %v10748 = load ptr, ptr %MEMORY, align 4
  %v10749 = call ptr @__remill_atomic_end(ptr %v10748)
  store ptr %v10749, ptr %MEMORY, align 4
  store i32 %v10743, ptr %PC, align 4
  %v10750 = add i32 %v10743, 3
  store i32 %v10750, ptr %NEXT_PC, align 4
  %v10751 = load ptr, ptr %MEMORY, align 4
  %v10752 = call ptr @__remill_atomic_begin(ptr %v10751)
  store ptr %v10752, ptr %MEMORY, align 4
  %v10753 = load i32, ptr %EBP, align 4
  %v10754 = load i32, ptr %SSBASE, align 4
  %v10755 = sub i32 %v10753, 52
  %v10756 = add i32 %v10755, %v10754
  %v10757 = load ptr, ptr %MEMORY, align 4
  %v10758 = call ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr %v10757, ptr %state, i32 %v10756, i32 %v10750)
  store ptr %v10758, ptr %MEMORY, align 4
  %v10759 = load ptr, ptr %MEMORY, align 4
  %v10760 = call ptr @__remill_atomic_end(ptr %v10759)
  store ptr %v10760, ptr %MEMORY, align 4
  store i32 %v10750, ptr %PC, align 4
  %v10761 = add i32 %v10750, 3
  store i32 %v10761, ptr %NEXT_PC, align 4
  %v10762 = load ptr, ptr %MEMORY, align 4
  %v10763 = call ptr @__remill_atomic_begin(ptr %v10762)
  store ptr %v10763, ptr %MEMORY, align 4
  %v10764 = load i32, ptr %EAX, align 4
  %v10765 = load ptr, ptr %MEMORY, align 4
  %v10766 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10765, ptr %state, ptr %EAX, i32 %v10764, i32 16)
  store ptr %v10766, ptr %MEMORY, align 4
  %v10767 = load ptr, ptr %MEMORY, align 4
  %v10768 = call ptr @__remill_atomic_end(ptr %v10767)
  store ptr %v10768, ptr %MEMORY, align 4
  store i32 %v10761, ptr %PC, align 4
  %v10769 = add i32 %v10761, 5
  store i32 %v10769, ptr %NEXT_PC, align 4
  %v10770 = load ptr, ptr %MEMORY, align 4
  %v10771 = call ptr @__remill_atomic_begin(ptr %v10770)
  store ptr %v10771, ptr %MEMORY, align 4
  %v10772 = sub i32 %v10769, 2234
  %v10773 = load ptr, ptr %MEMORY, align 4
  %v10774 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v10773, ptr %state, i64 4205916, ptr %NEXT_PC, i32 %v10769, ptr %RETURN_PC)
  store ptr %v10774, ptr %MEMORY, align 4
  %v10775 = load ptr, ptr %MEMORY, align 4
  %v10776 = call ptr @__remill_atomic_end(ptr %v10775)
  store ptr %v10776, ptr %MEMORY, align 4
  store i32 %v10769, ptr %PC, align 4
  %v10777 = add i32 %v10769, 2
  store i32 %v10777, ptr %NEXT_PC, align 4
  %v10778 = load ptr, ptr %MEMORY, align 4
  %v10779 = call ptr @__remill_atomic_begin(ptr %v10778)
  store ptr %v10779, ptr %MEMORY, align 4
  %v10780 = load i32, ptr %ESP, align 4
  %v10781 = load i32, ptr %EAX, align 4
  %v10782 = load ptr, ptr %MEMORY, align 4
  %v10783 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v10782, ptr %state, ptr %ESP, i32 %v10780, i32 %v10781)
  store ptr %v10783, ptr %MEMORY, align 4
  %v10784 = load ptr, ptr %MEMORY, align 4
  %v10785 = call ptr @__remill_atomic_end(ptr %v10784)
  store ptr %v10785, ptr %MEMORY, align 4
  store i32 %v10777, ptr %PC, align 4
  %v10786 = add i32 %v10777, 4
  store i32 %v10786, ptr %NEXT_PC, align 4
  %v10787 = load ptr, ptr %MEMORY, align 4
  %v10788 = call ptr @__remill_atomic_begin(ptr %v10787)
  store ptr %v10788, ptr %MEMORY, align 4
  %v10789 = load i32, ptr %ESP, align 4
  %v10790 = add i32 %v10789, 12
  %v10791 = load ptr, ptr %MEMORY, align 4
  %v10792 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v10791, ptr %state, ptr %EAX, i32 %v10790)
  store ptr %v10792, ptr %MEMORY, align 4
  %v10793 = load ptr, ptr %MEMORY, align 4
  %v10794 = call ptr @__remill_atomic_end(ptr %v10793)
  store ptr %v10794, ptr %MEMORY, align 4
  store i32 %v10786, ptr %PC, align 4
  %v10795 = add i32 %v10786, 3
  store i32 %v10795, ptr %NEXT_PC, align 4
  %v10796 = load ptr, ptr %MEMORY, align 4
  %v10797 = call ptr @__remill_atomic_begin(ptr %v10796)
  store ptr %v10797, ptr %MEMORY, align 4
  %v10798 = load i32, ptr %EAX, align 4
  %v10799 = load ptr, ptr %MEMORY, align 4
  %v10800 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10799, ptr %state, ptr %EAX, i32 %v10798, i32 0)
  store ptr %v10800, ptr %MEMORY, align 4
  %v10801 = load ptr, ptr %MEMORY, align 4
  %v10802 = call ptr @__remill_atomic_end(ptr %v10801)
  store ptr %v10802, ptr %MEMORY, align 4
  store i32 %v10795, ptr %PC, align 4
  %v10803 = add i32 %v10795, 3
  store i32 %v10803, ptr %NEXT_PC, align 4
  %v10804 = load ptr, ptr %MEMORY, align 4
  %v10805 = call ptr @__remill_atomic_begin(ptr %v10804)
  store ptr %v10805, ptr %MEMORY, align 4
  %v10806 = load i32, ptr %EBP, align 4
  %v10807 = load i32, ptr %SSBASE, align 4
  %v10808 = sub i32 %v10806, 32
  %v10809 = add i32 %v10808, %v10807
  %v10810 = load i32, ptr %EAX, align 4
  %v10811 = load ptr, ptr %MEMORY, align 4
  %v10812 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10811, ptr %state, i32 %v10809, i32 %v10810)
  store ptr %v10812, ptr %MEMORY, align 4
  %v10813 = load ptr, ptr %MEMORY, align 4
  %v10814 = call ptr @__remill_atomic_end(ptr %v10813)
  store ptr %v10814, ptr %MEMORY, align 4
  store i32 %v10803, ptr %PC, align 4
  %v10815 = add i32 %v10803, 3
  store i32 %v10815, ptr %NEXT_PC, align 4
  %v10816 = load ptr, ptr %MEMORY, align 4
  %v10817 = call ptr @__remill_atomic_begin(ptr %v10816)
  store ptr %v10817, ptr %MEMORY, align 4
  %v10818 = load i32, ptr %EBP, align 4
  %v10819 = load i32, ptr %SSBASE, align 4
  %v10820 = sub i32 %v10818, 32
  %v10821 = add i32 %v10820, %v10819
  %v10822 = load ptr, ptr %MEMORY, align 4
  %v10823 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10822, ptr %state, ptr %EAX, i32 %v10821)
  store ptr %v10823, ptr %MEMORY, align 4
  %v10824 = load ptr, ptr %MEMORY, align 4
  %v10825 = call ptr @__remill_atomic_end(ptr %v10824)
  store ptr %v10825, ptr %MEMORY, align 4
  store i32 %v10815, ptr %PC, align 4
  %v10826 = add i32 %v10815, 3
  store i32 %v10826, ptr %NEXT_PC, align 4
  %v10827 = load ptr, ptr %MEMORY, align 4
  %v10828 = call ptr @__remill_atomic_begin(ptr %v10827)
  store ptr %v10828, ptr %MEMORY, align 4
  %v10829 = load i32, ptr %EBP, align 4
  %v10830 = load i32, ptr %SSBASE, align 4
  %v10831 = sub i32 %v10829, 16
  %v10832 = add i32 %v10831, %v10830
  %v10833 = load i32, ptr %EAX, align 4
  %v10834 = load ptr, ptr %MEMORY, align 4
  %v10835 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10834, ptr %state, i32 %v10832, i32 %v10833)
  store ptr %v10835, ptr %MEMORY, align 4
  %v10836 = load ptr, ptr %MEMORY, align 4
  %v10837 = call ptr @__remill_atomic_end(ptr %v10836)
  store ptr %v10837, ptr %MEMORY, align 4
  store i32 %v10826, ptr %PC, align 4
  %v10838 = add i32 %v10826, 2
  store i32 %v10838, ptr %NEXT_PC, align 4
  %v10839 = load ptr, ptr %MEMORY, align 4
  %v10840 = call ptr @__remill_atomic_begin(ptr %v10839)
  store ptr %v10840, ptr %MEMORY, align 4
  %v10841 = add i32 %v10838, 99
  %v10842 = load ptr, ptr %MEMORY, align 4
  %v10843 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v10842, ptr %state, i32 %v10841, ptr %NEXT_PC)
  store ptr %v10843, ptr %MEMORY, align 4
  %v10844 = load ptr, ptr %MEMORY, align 4
  %v10845 = call ptr @__remill_atomic_end(ptr %v10844)
  store ptr %v10845, ptr %MEMORY, align 4
  br label %bb_4208269

bb_4208170:                                       ; preds = %bb_4208269
  store i32 %v11264, ptr %PC, align 4
  %v10846 = add i32 %v11264, 3
  store i32 %v10846, ptr %NEXT_PC, align 4
  %v10847 = load ptr, ptr %MEMORY, align 4
  %v10848 = call ptr @__remill_atomic_begin(ptr %v10847)
  store ptr %v10848, ptr %MEMORY, align 4
  %v10849 = load i32, ptr %EBP, align 4
  %v10850 = load i32, ptr %SSBASE, align 4
  %v10851 = sub i32 %v10849, 16
  %v10852 = add i32 %v10851, %v10850
  %v10853 = load ptr, ptr %MEMORY, align 4
  %v10854 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10853, ptr %state, ptr %EAX, i32 %v10852)
  store ptr %v10854, ptr %MEMORY, align 4
  %v10855 = load ptr, ptr %MEMORY, align 4
  %v10856 = call ptr @__remill_atomic_end(ptr %v10855)
  store ptr %v10856, ptr %MEMORY, align 4
  store i32 %v10846, ptr %PC, align 4
  %v10857 = add i32 %v10846, 3
  store i32 %v10857, ptr %NEXT_PC, align 4
  %v10858 = load ptr, ptr %MEMORY, align 4
  %v10859 = call ptr @__remill_atomic_begin(ptr %v10858)
  store ptr %v10859, ptr %MEMORY, align 4
  %v10860 = load i32, ptr %EBP, align 4
  %v10861 = load i32, ptr %SSBASE, align 4
  %v10862 = sub i32 %v10860, 36
  %v10863 = add i32 %v10862, %v10861
  %v10864 = load i32, ptr %EAX, align 4
  %v10865 = load ptr, ptr %MEMORY, align 4
  %v10866 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10865, ptr %state, i32 %v10863, i32 %v10864)
  store ptr %v10866, ptr %MEMORY, align 4
  %v10867 = load ptr, ptr %MEMORY, align 4
  %v10868 = call ptr @__remill_atomic_end(ptr %v10867)
  store ptr %v10868, ptr %MEMORY, align 4
  store i32 %v10857, ptr %PC, align 4
  %v10869 = add i32 %v10857, 3
  store i32 %v10869, ptr %NEXT_PC, align 4
  %v10870 = load ptr, ptr %MEMORY, align 4
  %v10871 = call ptr @__remill_atomic_begin(ptr %v10870)
  store ptr %v10871, ptr %MEMORY, align 4
  %v10872 = load i32, ptr %EBP, align 4
  %v10873 = load i32, ptr %SSBASE, align 4
  %v10874 = sub i32 %v10872, 48
  %v10875 = add i32 %v10874, %v10873
  %v10876 = load ptr, ptr %MEMORY, align 4
  %v10877 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10876, ptr %state, ptr %EAX, i32 %v10875)
  store ptr %v10877, ptr %MEMORY, align 4
  %v10878 = load ptr, ptr %MEMORY, align 4
  %v10879 = call ptr @__remill_atomic_end(ptr %v10878)
  store ptr %v10879, ptr %MEMORY, align 4
  store i32 %v10869, ptr %PC, align 4
  %v10880 = add i32 %v10869, 3
  store i32 %v10880, ptr %NEXT_PC, align 4
  %v10881 = load ptr, ptr %MEMORY, align 4
  %v10882 = call ptr @__remill_atomic_begin(ptr %v10881)
  store ptr %v10882, ptr %MEMORY, align 4
  %v10883 = load i32, ptr %EBP, align 4
  %v10884 = load i32, ptr %SSBASE, align 4
  %v10885 = sub i32 %v10883, 44
  %v10886 = add i32 %v10885, %v10884
  %v10887 = load ptr, ptr %MEMORY, align 4
  %v10888 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10887, ptr %state, ptr %EDX, i32 %v10886)
  store ptr %v10888, ptr %MEMORY, align 4
  %v10889 = load ptr, ptr %MEMORY, align 4
  %v10890 = call ptr @__remill_atomic_end(ptr %v10889)
  store ptr %v10890, ptr %MEMORY, align 4
  store i32 %v10880, ptr %PC, align 4
  %v10891 = add i32 %v10880, 2
  store i32 %v10891, ptr %NEXT_PC, align 4
  %v10892 = load ptr, ptr %MEMORY, align 4
  %v10893 = call ptr @__remill_atomic_begin(ptr %v10892)
  store ptr %v10893, ptr %MEMORY, align 4
  %v10894 = load i32, ptr %EAX, align 4
  %v10895 = load ptr, ptr %MEMORY, align 4
  %v10896 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10895, ptr %state, ptr %EDX, i32 %v10894)
  store ptr %v10896, ptr %MEMORY, align 4
  %v10897 = load ptr, ptr %MEMORY, align 4
  %v10898 = call ptr @__remill_atomic_end(ptr %v10897)
  store ptr %v10898, ptr %MEMORY, align 4
  store i32 %v10891, ptr %PC, align 4
  %v10899 = add i32 %v10891, 3
  store i32 %v10899, ptr %NEXT_PC, align 4
  %v10900 = load ptr, ptr %MEMORY, align 4
  %v10901 = call ptr @__remill_atomic_begin(ptr %v10900)
  store ptr %v10901, ptr %MEMORY, align 4
  %v10902 = load i32, ptr %EBP, align 4
  %v10903 = load i32, ptr %SSBASE, align 4
  %v10904 = sub i32 %v10902, 20
  %v10905 = add i32 %v10904, %v10903
  %v10906 = load ptr, ptr %MEMORY, align 4
  %v10907 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10906, ptr %state, ptr %EAX, i32 %v10905)
  store ptr %v10907, ptr %MEMORY, align 4
  %v10908 = load ptr, ptr %MEMORY, align 4
  %v10909 = call ptr @__remill_atomic_end(ptr %v10908)
  store ptr %v10909, ptr %MEMORY, align 4
  store i32 %v10899, ptr %PC, align 4
  %v10910 = add i32 %v10899, 2
  store i32 %v10910, ptr %NEXT_PC, align 4
  %v10911 = load ptr, ptr %MEMORY, align 4
  %v10912 = call ptr @__remill_atomic_begin(ptr %v10911)
  store ptr %v10912, ptr %MEMORY, align 4
  %v10913 = load i32, ptr %EAX, align 4
  %v10914 = load i32, ptr %EDX, align 4
  %v10915 = load ptr, ptr %MEMORY, align 4
  %v10916 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v10915, ptr %state, ptr %EAX, i32 %v10913, i32 %v10914)
  store ptr %v10916, ptr %MEMORY, align 4
  %v10917 = load ptr, ptr %MEMORY, align 4
  %v10918 = call ptr @__remill_atomic_end(ptr %v10917)
  store ptr %v10918, ptr %MEMORY, align 4
  store i32 %v10910, ptr %PC, align 4
  %v10919 = add i32 %v10910, 3
  store i32 %v10919, ptr %NEXT_PC, align 4
  %v10920 = load ptr, ptr %MEMORY, align 4
  %v10921 = call ptr @__remill_atomic_begin(ptr %v10920)
  store ptr %v10921, ptr %MEMORY, align 4
  %v10922 = load i32, ptr %EAX, align 4
  %v10923 = load ptr, ptr %MEMORY, align 4
  %v10924 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v10923, ptr %state, ptr %EAX, i32 %v10922, i32 48)
  store ptr %v10924, ptr %MEMORY, align 4
  %v10925 = load ptr, ptr %MEMORY, align 4
  %v10926 = call ptr @__remill_atomic_end(ptr %v10925)
  store ptr %v10926, ptr %MEMORY, align 4
  store i32 %v10919, ptr %PC, align 4
  %v10927 = add i32 %v10919, 2
  store i32 %v10927, ptr %NEXT_PC, align 4
  %v10928 = load ptr, ptr %MEMORY, align 4
  %v10929 = call ptr @__remill_atomic_begin(ptr %v10928)
  store ptr %v10929, ptr %MEMORY, align 4
  %v10930 = load i32, ptr %EAX, align 4
  %v10931 = load ptr, ptr %MEMORY, align 4
  %v10932 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10931, ptr %state, ptr %EDX, i32 %v10930)
  store ptr %v10932, ptr %MEMORY, align 4
  %v10933 = load ptr, ptr %MEMORY, align 4
  %v10934 = call ptr @__remill_atomic_end(ptr %v10933)
  store ptr %v10934, ptr %MEMORY, align 4
  store i32 %v10927, ptr %PC, align 4
  %v10935 = add i32 %v10927, 3
  store i32 %v10935, ptr %NEXT_PC, align 4
  %v10936 = load ptr, ptr %MEMORY, align 4
  %v10937 = call ptr @__remill_atomic_begin(ptr %v10936)
  store ptr %v10937, ptr %MEMORY, align 4
  %v10938 = load i32, ptr %EBP, align 4
  %v10939 = load i32, ptr %SSBASE, align 4
  %v10940 = sub i32 %v10938, 36
  %v10941 = add i32 %v10940, %v10939
  %v10942 = load ptr, ptr %MEMORY, align 4
  %v10943 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10942, ptr %state, ptr %EAX, i32 %v10941)
  store ptr %v10943, ptr %MEMORY, align 4
  %v10944 = load ptr, ptr %MEMORY, align 4
  %v10945 = call ptr @__remill_atomic_end(ptr %v10944)
  store ptr %v10945, ptr %MEMORY, align 4
  store i32 %v10935, ptr %PC, align 4
  %v10946 = add i32 %v10935, 2
  store i32 %v10946, ptr %NEXT_PC, align 4
  %v10947 = load ptr, ptr %MEMORY, align 4
  %v10948 = call ptr @__remill_atomic_begin(ptr %v10947)
  store ptr %v10948, ptr %MEMORY, align 4
  %v10949 = load i32, ptr %EAX, align 4
  %v10950 = load i32, ptr %DSBASE, align 4
  %v10951 = add i32 %v10949, %v10950
  %v10952 = load i8, ptr %DL, align 1
  %v10953 = zext i8 %v10952 to i32
  %v10954 = load ptr, ptr %MEMORY, align 4
  %v10955 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v10954, ptr %state, i32 %v10951, i32 %v10953)
  store ptr %v10955, ptr %MEMORY, align 4
  %v10956 = load ptr, ptr %MEMORY, align 4
  %v10957 = call ptr @__remill_atomic_end(ptr %v10956)
  store ptr %v10957, ptr %MEMORY, align 4
  store i32 %v10946, ptr %PC, align 4
  %v10958 = add i32 %v10946, 3
  store i32 %v10958, ptr %NEXT_PC, align 4
  %v10959 = load ptr, ptr %MEMORY, align 4
  %v10960 = call ptr @__remill_atomic_begin(ptr %v10959)
  store ptr %v10960, ptr %MEMORY, align 4
  %v10961 = load i32, ptr %EBP, align 4
  %v10962 = load i32, ptr %SSBASE, align 4
  %v10963 = sub i32 %v10961, 36
  %v10964 = add i32 %v10963, %v10962
  %v10965 = load ptr, ptr %MEMORY, align 4
  %v10966 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v10965, ptr %state, ptr %EAX, i32 %v10964)
  store ptr %v10966, ptr %MEMORY, align 4
  %v10967 = load ptr, ptr %MEMORY, align 4
  %v10968 = call ptr @__remill_atomic_end(ptr %v10967)
  store ptr %v10968, ptr %MEMORY, align 4
  store i32 %v10958, ptr %PC, align 4
  %v10969 = add i32 %v10958, 3
  store i32 %v10969, ptr %NEXT_PC, align 4
  %v10970 = load ptr, ptr %MEMORY, align 4
  %v10971 = call ptr @__remill_atomic_begin(ptr %v10970)
  store ptr %v10971, ptr %MEMORY, align 4
  %v10972 = load i32, ptr %EAX, align 4
  %v10973 = load i32, ptr %DSBASE, align 4
  %v10974 = add i32 %v10972, %v10973
  %v10975 = load ptr, ptr %MEMORY, align 4
  %v10976 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v10975, ptr %state, ptr %EAX, i32 %v10974)
  store ptr %v10976, ptr %MEMORY, align 4
  %v10977 = load ptr, ptr %MEMORY, align 4
  %v10978 = call ptr @__remill_atomic_end(ptr %v10977)
  store ptr %v10978, ptr %MEMORY, align 4
  store i32 %v10969, ptr %PC, align 4
  %v10979 = add i32 %v10969, 2
  store i32 %v10979, ptr %NEXT_PC, align 4
  %v10980 = load ptr, ptr %MEMORY, align 4
  %v10981 = call ptr @__remill_atomic_begin(ptr %v10980)
  store ptr %v10981, ptr %MEMORY, align 4
  %v10982 = load i8, ptr %AL, align 1
  %v10983 = zext i8 %v10982 to i32
  %v10984 = load ptr, ptr %MEMORY, align 4
  %v10985 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v10984, ptr %state, i32 %v10983, i32 57)
  store ptr %v10985, ptr %MEMORY, align 4
  %v10986 = load ptr, ptr %MEMORY, align 4
  %v10987 = call ptr @__remill_atomic_end(ptr %v10986)
  store ptr %v10987, ptr %MEMORY, align 4
  store i32 %v10979, ptr %PC, align 4
  %v10988 = add i32 %v10979, 3
  store i32 %v10988, ptr %NEXT_PC, align 4
  %v10989 = load ptr, ptr %MEMORY, align 4
  %v10990 = call ptr @__remill_atomic_begin(ptr %v10989)
  store ptr %v10990, ptr %MEMORY, align 4
  %v10991 = load ptr, ptr %MEMORY, align 4
  %v10992 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v10991, ptr %state, ptr %AL)
  store ptr %v10992, ptr %MEMORY, align 4
  %v10993 = load ptr, ptr %MEMORY, align 4
  %v10994 = call ptr @__remill_atomic_end(ptr %v10993)
  store ptr %v10994, ptr %MEMORY, align 4
  store i32 %v10988, ptr %PC, align 4
  %v10995 = add i32 %v10988, 4
  store i32 %v10995, ptr %NEXT_PC, align 4
  %v10996 = load ptr, ptr %MEMORY, align 4
  %v10997 = call ptr @__remill_atomic_begin(ptr %v10996)
  store ptr %v10997, ptr %MEMORY, align 4
  %v10998 = load i32, ptr %EBP, align 4
  %v10999 = load i32, ptr %SSBASE, align 4
  %v11000 = sub i32 %v10998, 16
  %v11001 = add i32 %v11000, %v10999
  %v11002 = load i32, ptr %EBP, align 4
  %v11003 = load i32, ptr %SSBASE, align 4
  %v11004 = sub i32 %v11002, 16
  %v11005 = add i32 %v11004, %v11003
  %v11006 = load ptr, ptr %MEMORY, align 4
  %v11007 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11006, ptr %state, i32 %v11001, i32 %v11005, i32 1)
  store ptr %v11007, ptr %MEMORY, align 4
  %v11008 = load ptr, ptr %MEMORY, align 4
  %v11009 = call ptr @__remill_atomic_end(ptr %v11008)
  store ptr %v11009, ptr %MEMORY, align 4
  store i32 %v10995, ptr %PC, align 4
  %v11010 = add i32 %v10995, 2
  store i32 %v11010, ptr %NEXT_PC, align 4
  %v11011 = load ptr, ptr %MEMORY, align 4
  %v11012 = call ptr @__remill_atomic_begin(ptr %v11011)
  store ptr %v11012, ptr %MEMORY, align 4
  %v11013 = load i8, ptr %AL, align 1
  %v11014 = zext i8 %v11013 to i32
  %v11015 = load i8, ptr %AL, align 1
  %v11016 = zext i8 %v11015 to i32
  %v11017 = load ptr, ptr %MEMORY, align 4
  %v11018 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v11017, ptr %state, i32 %v11014, i32 %v11016)
  store ptr %v11018, ptr %MEMORY, align 4
  %v11019 = load ptr, ptr %MEMORY, align 4
  %v11020 = call ptr @__remill_atomic_end(ptr %v11019)
  store ptr %v11020, ptr %MEMORY, align 4
  store i32 %v11010, ptr %PC, align 4
  %v11021 = add i32 %v11010, 2
  store i32 %v11021, ptr %NEXT_PC, align 4
  %v11022 = load ptr, ptr %MEMORY, align 4
  %v11023 = call ptr @__remill_atomic_begin(ptr %v11022)
  store ptr %v11023, ptr %MEMORY, align 4
  %v11024 = add i32 %v11021, 22
  %v11025 = load ptr, ptr %MEMORY, align 4
  %v11026 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11025, ptr %state, ptr %BRANCH_TAKEN, i32 %v11024, i32 %v11021, ptr %NEXT_PC)
  store ptr %v11026, ptr %MEMORY, align 4
  %v11027 = load ptr, ptr %MEMORY, align 4
  %v11028 = call ptr @__remill_atomic_end(ptr %v11027)
  store ptr %v11028, ptr %MEMORY, align 4
  br i1 true, label %bb_4208240, label %bb_4208218

bb_4208218:                                       ; preds = %bb_4208170
  store i32 %v11021, ptr %PC, align 4
  %v11029 = add i32 %v11021, 3
  store i32 %v11029, ptr %NEXT_PC, align 4
  %v11030 = load ptr, ptr %MEMORY, align 4
  %v11031 = call ptr @__remill_atomic_begin(ptr %v11030)
  store ptr %v11031, ptr %MEMORY, align 4
  %v11032 = load i32, ptr %EBP, align 4
  %v11033 = load i32, ptr %SSBASE, align 4
  %v11034 = sub i32 %v11032, 36
  %v11035 = add i32 %v11034, %v11033
  %v11036 = load ptr, ptr %MEMORY, align 4
  %v11037 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11036, ptr %state, ptr %EAX, i32 %v11035)
  store ptr %v11037, ptr %MEMORY, align 4
  %v11038 = load ptr, ptr %MEMORY, align 4
  %v11039 = call ptr @__remill_atomic_end(ptr %v11038)
  store ptr %v11039, ptr %MEMORY, align 4
  store i32 %v11029, ptr %PC, align 4
  %v11040 = add i32 %v11029, 3
  store i32 %v11040, ptr %NEXT_PC, align 4
  %v11041 = load ptr, ptr %MEMORY, align 4
  %v11042 = call ptr @__remill_atomic_begin(ptr %v11041)
  store ptr %v11042, ptr %MEMORY, align 4
  %v11043 = load i32, ptr %EAX, align 4
  %v11044 = load i32, ptr %DSBASE, align 4
  %v11045 = add i32 %v11043, %v11044
  %v11046 = load ptr, ptr %MEMORY, align 4
  %v11047 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v11046, ptr %state, ptr %EAX, i32 %v11045)
  store ptr %v11047, ptr %MEMORY, align 4
  %v11048 = load ptr, ptr %MEMORY, align 4
  %v11049 = call ptr @__remill_atomic_end(ptr %v11048)
  store ptr %v11049, ptr %MEMORY, align 4
  store i32 %v11040, ptr %PC, align 4
  %v11050 = add i32 %v11040, 3
  store i32 %v11050, ptr %NEXT_PC, align 4
  %v11051 = load ptr, ptr %MEMORY, align 4
  %v11052 = call ptr @__remill_atomic_begin(ptr %v11051)
  store ptr %v11052, ptr %MEMORY, align 4
  %v11053 = load i32, ptr %EAX, align 4
  %v11054 = load ptr, ptr %MEMORY, align 4
  %v11055 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11054, ptr %state, ptr %EAX, i32 %v11053, i32 7)
  store ptr %v11055, ptr %MEMORY, align 4
  %v11056 = load ptr, ptr %MEMORY, align 4
  %v11057 = call ptr @__remill_atomic_end(ptr %v11056)
  store ptr %v11057, ptr %MEMORY, align 4
  store i32 %v11050, ptr %PC, align 4
  %v11058 = add i32 %v11050, 3
  store i32 %v11058, ptr %NEXT_PC, align 4
  %v11059 = load ptr, ptr %MEMORY, align 4
  %v11060 = call ptr @__remill_atomic_begin(ptr %v11059)
  store ptr %v11060, ptr %MEMORY, align 4
  %v11061 = load i32, ptr %EBP, align 4
  %v11062 = load i32, ptr %SSBASE, align 4
  %v11063 = add i32 %v11061, 8
  %v11064 = add i32 %v11063, %v11062
  %v11065 = load ptr, ptr %MEMORY, align 4
  %v11066 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11065, ptr %state, ptr %EDX, i32 %v11064)
  store ptr %v11066, ptr %MEMORY, align 4
  %v11067 = load ptr, ptr %MEMORY, align 4
  %v11068 = call ptr @__remill_atomic_end(ptr %v11067)
  store ptr %v11068, ptr %MEMORY, align 4
  store i32 %v11058, ptr %PC, align 4
  %v11069 = add i32 %v11058, 3
  store i32 %v11069, ptr %NEXT_PC, align 4
  %v11070 = load ptr, ptr %MEMORY, align 4
  %v11071 = call ptr @__remill_atomic_begin(ptr %v11070)
  store ptr %v11071, ptr %MEMORY, align 4
  %v11072 = load i32, ptr %EDX, align 4
  %v11073 = load ptr, ptr %MEMORY, align 4
  %v11074 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11073, ptr %state, ptr %EDX, i32 %v11072, i32 32)
  store ptr %v11074, ptr %MEMORY, align 4
  %v11075 = load ptr, ptr %MEMORY, align 4
  %v11076 = call ptr @__remill_atomic_end(ptr %v11075)
  store ptr %v11076, ptr %MEMORY, align 4
  store i32 %v11069, ptr %PC, align 4
  %v11077 = add i32 %v11069, 2
  store i32 %v11077, ptr %NEXT_PC, align 4
  %v11078 = load ptr, ptr %MEMORY, align 4
  %v11079 = call ptr @__remill_atomic_begin(ptr %v11078)
  store ptr %v11079, ptr %MEMORY, align 4
  %v11080 = load i32, ptr %EDX, align 4
  %v11081 = load i32, ptr %EAX, align 4
  %v11082 = load ptr, ptr %MEMORY, align 4
  %v11083 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v11082, ptr %state, ptr %EDX, i32 %v11080, i32 %v11081)
  store ptr %v11083, ptr %MEMORY, align 4
  %v11084 = load ptr, ptr %MEMORY, align 4
  %v11085 = call ptr @__remill_atomic_end(ptr %v11084)
  store ptr %v11085, ptr %MEMORY, align 4
  store i32 %v11077, ptr %PC, align 4
  %v11086 = add i32 %v11077, 3
  store i32 %v11086, ptr %NEXT_PC, align 4
  %v11087 = load ptr, ptr %MEMORY, align 4
  %v11088 = call ptr @__remill_atomic_begin(ptr %v11087)
  store ptr %v11088, ptr %MEMORY, align 4
  %v11089 = load i32, ptr %EBP, align 4
  %v11090 = load i32, ptr %SSBASE, align 4
  %v11091 = sub i32 %v11089, 36
  %v11092 = add i32 %v11091, %v11090
  %v11093 = load ptr, ptr %MEMORY, align 4
  %v11094 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11093, ptr %state, ptr %EAX, i32 %v11092)
  store ptr %v11094, ptr %MEMORY, align 4
  %v11095 = load ptr, ptr %MEMORY, align 4
  %v11096 = call ptr @__remill_atomic_end(ptr %v11095)
  store ptr %v11096, ptr %MEMORY, align 4
  store i32 %v11086, ptr %PC, align 4
  %v11097 = add i32 %v11086, 2
  store i32 %v11097, ptr %NEXT_PC, align 4
  %v11098 = load ptr, ptr %MEMORY, align 4
  %v11099 = call ptr @__remill_atomic_begin(ptr %v11098)
  store ptr %v11099, ptr %MEMORY, align 4
  %v11100 = load i32, ptr %EAX, align 4
  %v11101 = load i32, ptr %DSBASE, align 4
  %v11102 = add i32 %v11100, %v11101
  %v11103 = load i8, ptr %DL, align 1
  %v11104 = zext i8 %v11103 to i32
  %v11105 = load ptr, ptr %MEMORY, align 4
  %v11106 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11105, ptr %state, i32 %v11102, i32 %v11104)
  store ptr %v11106, ptr %MEMORY, align 4
  %v11107 = load ptr, ptr %MEMORY, align 4
  %v11108 = call ptr @__remill_atomic_end(ptr %v11107)
  store ptr %v11108, ptr %MEMORY, align 4
  br label %bb_4208240

bb_4208240:                                       ; preds = %bb_4208218, %bb_4208170
  %v11109 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11109, ptr %PC, align 4
  %v11110 = add i32 %v11109, 3
  store i32 %v11110, ptr %NEXT_PC, align 4
  %v11111 = load ptr, ptr %MEMORY, align 4
  %v11112 = call ptr @__remill_atomic_begin(ptr %v11111)
  store ptr %v11112, ptr %MEMORY, align 4
  %v11113 = load i32, ptr %EBP, align 4
  %v11114 = load i32, ptr %SSBASE, align 4
  %v11115 = sub i32 %v11113, 48
  %v11116 = add i32 %v11115, %v11114
  %v11117 = load ptr, ptr %MEMORY, align 4
  %v11118 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11117, ptr %state, ptr %EAX, i32 %v11116)
  store ptr %v11118, ptr %MEMORY, align 4
  %v11119 = load ptr, ptr %MEMORY, align 4
  %v11120 = call ptr @__remill_atomic_end(ptr %v11119)
  store ptr %v11120, ptr %MEMORY, align 4
  store i32 %v11110, ptr %PC, align 4
  %v11121 = add i32 %v11110, 3
  store i32 %v11121, ptr %NEXT_PC, align 4
  %v11122 = load ptr, ptr %MEMORY, align 4
  %v11123 = call ptr @__remill_atomic_begin(ptr %v11122)
  store ptr %v11123, ptr %MEMORY, align 4
  %v11124 = load i32, ptr %EBP, align 4
  %v11125 = load i32, ptr %SSBASE, align 4
  %v11126 = sub i32 %v11124, 44
  %v11127 = add i32 %v11126, %v11125
  %v11128 = load ptr, ptr %MEMORY, align 4
  %v11129 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11128, ptr %state, ptr %EDX, i32 %v11127)
  store ptr %v11129, ptr %MEMORY, align 4
  %v11130 = load ptr, ptr %MEMORY, align 4
  %v11131 = call ptr @__remill_atomic_end(ptr %v11130)
  store ptr %v11131, ptr %MEMORY, align 4
  store i32 %v11121, ptr %PC, align 4
  %v11132 = add i32 %v11121, 3
  store i32 %v11132, ptr %NEXT_PC, align 4
  %v11133 = load ptr, ptr %MEMORY, align 4
  %v11134 = call ptr @__remill_atomic_begin(ptr %v11133)
  store ptr %v11134, ptr %MEMORY, align 4
  %v11135 = load i32, ptr %EBP, align 4
  %v11136 = load i32, ptr %SSBASE, align 4
  %v11137 = sub i32 %v11135, 24
  %v11138 = add i32 %v11137, %v11136
  %v11139 = load ptr, ptr %MEMORY, align 4
  %v11140 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11139, ptr %state, ptr %ECX, i32 %v11138)
  store ptr %v11140, ptr %MEMORY, align 4
  %v11141 = load ptr, ptr %MEMORY, align 4
  %v11142 = call ptr @__remill_atomic_end(ptr %v11141)
  store ptr %v11142, ptr %MEMORY, align 4
  store i32 %v11132, ptr %PC, align 4
  %v11143 = add i32 %v11132, 3
  store i32 %v11143, ptr %NEXT_PC, align 4
  %v11144 = load ptr, ptr %MEMORY, align 4
  %v11145 = call ptr @__remill_atomic_begin(ptr %v11144)
  store ptr %v11145, ptr %MEMORY, align 4
  %v11146 = load i32, ptr %EAX, align 4
  %v11147 = load i32, ptr %EDX, align 4
  %v11148 = load i8, ptr %CL, align 1
  %v11149 = zext i8 %v11148 to i32
  %v11150 = load ptr, ptr %MEMORY, align 4
  %v11151 = call ptr @_ZN12_GLOBAL__N_14SHRDI3RnWIjE2RnIjLb1EES4_S4_EEP6MemoryS6_R5StateT_T0_T1_T2_(ptr %v11150, ptr %state, ptr %EAX, i32 %v11146, i32 %v11147, i32 %v11149)
  store ptr %v11151, ptr %MEMORY, align 4
  %v11152 = load ptr, ptr %MEMORY, align 4
  %v11153 = call ptr @__remill_atomic_end(ptr %v11152)
  store ptr %v11153, ptr %MEMORY, align 4
  store i32 %v11143, ptr %PC, align 4
  %v11154 = add i32 %v11143, 2
  store i32 %v11154, ptr %NEXT_PC, align 4
  %v11155 = load ptr, ptr %MEMORY, align 4
  %v11156 = call ptr @__remill_atomic_begin(ptr %v11155)
  store ptr %v11156, ptr %MEMORY, align 4
  %v11157 = load i32, ptr %EDX, align 4
  %v11158 = load i8, ptr %CL, align 1
  %v11159 = zext i8 %v11158 to i32
  %v11160 = load ptr, ptr %MEMORY, align 4
  %v11161 = call ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v11160, ptr %state, ptr %EDX, i32 %v11157, i32 %v11159)
  store ptr %v11161, ptr %MEMORY, align 4
  %v11162 = load ptr, ptr %MEMORY, align 4
  %v11163 = call ptr @__remill_atomic_end(ptr %v11162)
  store ptr %v11163, ptr %MEMORY, align 4
  store i32 %v11154, ptr %PC, align 4
  %v11164 = add i32 %v11154, 3
  store i32 %v11164, ptr %NEXT_PC, align 4
  %v11165 = load ptr, ptr %MEMORY, align 4
  %v11166 = call ptr @__remill_atomic_begin(ptr %v11165)
  store ptr %v11166, ptr %MEMORY, align 4
  %v11167 = load i8, ptr %CL, align 1
  %v11168 = zext i8 %v11167 to i32
  %v11169 = load ptr, ptr %MEMORY, align 4
  %v11170 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v11169, ptr %state, i32 %v11168, i32 32)
  store ptr %v11170, ptr %MEMORY, align 4
  %v11171 = load ptr, ptr %MEMORY, align 4
  %v11172 = call ptr @__remill_atomic_end(ptr %v11171)
  store ptr %v11172, ptr %MEMORY, align 4
  store i32 %v11164, ptr %PC, align 4
  %v11173 = add i32 %v11164, 2
  store i32 %v11173, ptr %NEXT_PC, align 4
  %v11174 = load ptr, ptr %MEMORY, align 4
  %v11175 = call ptr @__remill_atomic_begin(ptr %v11174)
  store ptr %v11175, ptr %MEMORY, align 4
  %v11176 = add i32 %v11173, 4
  %v11177 = load ptr, ptr %MEMORY, align 4
  %v11178 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11177, ptr %state, ptr %BRANCH_TAKEN, i32 %v11176, i32 %v11173, ptr %NEXT_PC)
  store ptr %v11178, ptr %MEMORY, align 4
  %v11179 = load ptr, ptr %MEMORY, align 4
  %v11180 = call ptr @__remill_atomic_end(ptr %v11179)
  store ptr %v11180, ptr %MEMORY, align 4
  br i1 true, label %bb_4208263, label %bb_4208259

bb_4208259:                                       ; preds = %bb_4208240
  store i32 %v11173, ptr %PC, align 4
  %v11181 = add i32 %v11173, 2
  store i32 %v11181, ptr %NEXT_PC, align 4
  %v11182 = load ptr, ptr %MEMORY, align 4
  %v11183 = call ptr @__remill_atomic_begin(ptr %v11182)
  store ptr %v11183, ptr %MEMORY, align 4
  %v11184 = load i32, ptr %EDX, align 4
  %v11185 = load ptr, ptr %MEMORY, align 4
  %v11186 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11185, ptr %state, ptr %EAX, i32 %v11184)
  store ptr %v11186, ptr %MEMORY, align 4
  %v11187 = load ptr, ptr %MEMORY, align 4
  %v11188 = call ptr @__remill_atomic_end(ptr %v11187)
  store ptr %v11188, ptr %MEMORY, align 4
  store i32 %v11181, ptr %PC, align 4
  %v11189 = add i32 %v11181, 2
  store i32 %v11189, ptr %NEXT_PC, align 4
  %v11190 = load ptr, ptr %MEMORY, align 4
  %v11191 = call ptr @__remill_atomic_begin(ptr %v11190)
  store ptr %v11191, ptr %MEMORY, align 4
  %v11192 = load i32, ptr %EDX, align 4
  %v11193 = load i32, ptr %EDX, align 4
  %v11194 = load ptr, ptr %MEMORY, align 4
  %v11195 = call ptr @_ZN12_GLOBAL__N_13XORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v11194, ptr %state, ptr %EDX, i32 %v11192, i32 %v11193)
  store ptr %v11195, ptr %MEMORY, align 4
  %v11196 = load ptr, ptr %MEMORY, align 4
  %v11197 = call ptr @__remill_atomic_end(ptr %v11196)
  store ptr %v11197, ptr %MEMORY, align 4
  br label %bb_4208263

bb_4208263:                                       ; preds = %bb_4208259, %bb_4208240
  %v11198 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11198, ptr %PC, align 4
  %v11199 = add i32 %v11198, 3
  store i32 %v11199, ptr %NEXT_PC, align 4
  %v11200 = load ptr, ptr %MEMORY, align 4
  %v11201 = call ptr @__remill_atomic_begin(ptr %v11200)
  store ptr %v11201, ptr %MEMORY, align 4
  %v11202 = load i32, ptr %EBP, align 4
  %v11203 = load i32, ptr %SSBASE, align 4
  %v11204 = sub i32 %v11202, 48
  %v11205 = add i32 %v11204, %v11203
  %v11206 = load i32, ptr %EAX, align 4
  %v11207 = load ptr, ptr %MEMORY, align 4
  %v11208 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11207, ptr %state, i32 %v11205, i32 %v11206)
  store ptr %v11208, ptr %MEMORY, align 4
  %v11209 = load ptr, ptr %MEMORY, align 4
  %v11210 = call ptr @__remill_atomic_end(ptr %v11209)
  store ptr %v11210, ptr %MEMORY, align 4
  store i32 %v11199, ptr %PC, align 4
  %v11211 = add i32 %v11199, 3
  store i32 %v11211, ptr %NEXT_PC, align 4
  %v11212 = load ptr, ptr %MEMORY, align 4
  %v11213 = call ptr @__remill_atomic_begin(ptr %v11212)
  store ptr %v11213, ptr %MEMORY, align 4
  %v11214 = load i32, ptr %EBP, align 4
  %v11215 = load i32, ptr %SSBASE, align 4
  %v11216 = sub i32 %v11214, 44
  %v11217 = add i32 %v11216, %v11215
  %v11218 = load i32, ptr %EDX, align 4
  %v11219 = load ptr, ptr %MEMORY, align 4
  %v11220 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11219, ptr %state, i32 %v11217, i32 %v11218)
  store ptr %v11220, ptr %MEMORY, align 4
  %v11221 = load ptr, ptr %MEMORY, align 4
  %v11222 = call ptr @__remill_atomic_end(ptr %v11221)
  store ptr %v11222, ptr %MEMORY, align 4
  br label %bb_4208269

bb_4208269:                                       ; preds = %bb_4208263, %bb_4208082
  %v11223 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11223, ptr %PC, align 4
  %v11224 = add i32 %v11223, 3
  store i32 %v11224, ptr %NEXT_PC, align 4
  %v11225 = load ptr, ptr %MEMORY, align 4
  %v11226 = call ptr @__remill_atomic_begin(ptr %v11225)
  store ptr %v11226, ptr %MEMORY, align 4
  %v11227 = load i32, ptr %EBP, align 4
  %v11228 = load i32, ptr %SSBASE, align 4
  %v11229 = sub i32 %v11227, 48
  %v11230 = add i32 %v11229, %v11228
  %v11231 = load ptr, ptr %MEMORY, align 4
  %v11232 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11231, ptr %state, ptr %EAX, i32 %v11230)
  store ptr %v11232, ptr %MEMORY, align 4
  %v11233 = load ptr, ptr %MEMORY, align 4
  %v11234 = call ptr @__remill_atomic_end(ptr %v11233)
  store ptr %v11234, ptr %MEMORY, align 4
  store i32 %v11224, ptr %PC, align 4
  %v11235 = add i32 %v11224, 3
  store i32 %v11235, ptr %NEXT_PC, align 4
  %v11236 = load ptr, ptr %MEMORY, align 4
  %v11237 = call ptr @__remill_atomic_begin(ptr %v11236)
  store ptr %v11237, ptr %MEMORY, align 4
  %v11238 = load i32, ptr %EBP, align 4
  %v11239 = load i32, ptr %SSBASE, align 4
  %v11240 = sub i32 %v11238, 44
  %v11241 = add i32 %v11240, %v11239
  %v11242 = load ptr, ptr %MEMORY, align 4
  %v11243 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11242, ptr %state, ptr %EDX, i32 %v11241)
  store ptr %v11243, ptr %MEMORY, align 4
  %v11244 = load ptr, ptr %MEMORY, align 4
  %v11245 = call ptr @__remill_atomic_end(ptr %v11244)
  store ptr %v11245, ptr %MEMORY, align 4
  store i32 %v11235, ptr %PC, align 4
  %v11246 = add i32 %v11235, 2
  store i32 %v11246, ptr %NEXT_PC, align 4
  %v11247 = load ptr, ptr %MEMORY, align 4
  %v11248 = call ptr @__remill_atomic_begin(ptr %v11247)
  store ptr %v11248, ptr %MEMORY, align 4
  %v11249 = load i32, ptr %EAX, align 4
  %v11250 = load i32, ptr %EDX, align 4
  %v11251 = load ptr, ptr %MEMORY, align 4
  %v11252 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v11251, ptr %state, ptr %EAX, i32 %v11249, i32 %v11250)
  store ptr %v11252, ptr %MEMORY, align 4
  %v11253 = load ptr, ptr %MEMORY, align 4
  %v11254 = call ptr @__remill_atomic_end(ptr %v11253)
  store ptr %v11254, ptr %MEMORY, align 4
  store i32 %v11246, ptr %PC, align 4
  %v11255 = add i32 %v11246, 2
  store i32 %v11255, ptr %NEXT_PC, align 4
  %v11256 = load ptr, ptr %MEMORY, align 4
  %v11257 = call ptr @__remill_atomic_begin(ptr %v11256)
  store ptr %v11257, ptr %MEMORY, align 4
  %v11258 = load i32, ptr %EAX, align 4
  %v11259 = load i32, ptr %EAX, align 4
  %v11260 = load ptr, ptr %MEMORY, align 4
  %v11261 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v11260, ptr %state, i32 %v11258, i32 %v11259)
  store ptr %v11261, ptr %MEMORY, align 4
  %v11262 = load ptr, ptr %MEMORY, align 4
  %v11263 = call ptr @__remill_atomic_end(ptr %v11262)
  store ptr %v11263, ptr %MEMORY, align 4
  store i32 %v11255, ptr %PC, align 4
  %v11264 = add i32 %v11255, 2
  store i32 %v11264, ptr %NEXT_PC, align 4
  %v11265 = load ptr, ptr %MEMORY, align 4
  %v11266 = call ptr @__remill_atomic_begin(ptr %v11265)
  store ptr %v11266, ptr %MEMORY, align 4
  %v11267 = sub i32 %v11264, 111
  %v11268 = load ptr, ptr %MEMORY, align 4
  %v11269 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11268, ptr %state, ptr %BRANCH_TAKEN, i32 %v11267, i32 %v11264, ptr %NEXT_PC)
  store ptr %v11269, ptr %MEMORY, align 4
  %v11270 = load ptr, ptr %MEMORY, align 4
  %v11271 = call ptr @__remill_atomic_end(ptr %v11270)
  store ptr %v11271, ptr %MEMORY, align 4
  br i1 true, label %bb_4208170, label %bb_4208281

bb_4208281:                                       ; preds = %bb_4208269
  store i32 %v11264, ptr %PC, align 4
  %v11272 = add i32 %v11264, 3
  store i32 %v11272, ptr %NEXT_PC, align 4
  %v11273 = load ptr, ptr %MEMORY, align 4
  %v11274 = call ptr @__remill_atomic_begin(ptr %v11273)
  store ptr %v11274, ptr %MEMORY, align 4
  %v11275 = load i32, ptr %EBP, align 4
  %v11276 = load i32, ptr %SSBASE, align 4
  %v11277 = sub i32 %v11275, 32
  %v11278 = add i32 %v11277, %v11276
  %v11279 = load ptr, ptr %MEMORY, align 4
  %v11280 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11279, ptr %state, ptr %EAX, i32 %v11278)
  store ptr %v11280, ptr %MEMORY, align 4
  %v11281 = load ptr, ptr %MEMORY, align 4
  %v11282 = call ptr @__remill_atomic_end(ptr %v11281)
  store ptr %v11282, ptr %MEMORY, align 4
  store i32 %v11272, ptr %PC, align 4
  %v11283 = add i32 %v11272, 3
  store i32 %v11283, ptr %NEXT_PC, align 4
  %v11284 = load ptr, ptr %MEMORY, align 4
  %v11285 = call ptr @__remill_atomic_begin(ptr %v11284)
  store ptr %v11285, ptr %MEMORY, align 4
  %v11286 = load i32, ptr %EAX, align 4
  %v11287 = load i32, ptr %EBP, align 4
  %v11288 = load i32, ptr %SSBASE, align 4
  %v11289 = sub i32 %v11287, 16
  %v11290 = add i32 %v11289, %v11288
  %v11291 = load ptr, ptr %MEMORY, align 4
  %v11292 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11291, ptr %state, i32 %v11286, i32 %v11290)
  store ptr %v11292, ptr %MEMORY, align 4
  %v11293 = load ptr, ptr %MEMORY, align 4
  %v11294 = call ptr @__remill_atomic_end(ptr %v11293)
  store ptr %v11294, ptr %MEMORY, align 4
  store i32 %v11283, ptr %PC, align 4
  %v11295 = add i32 %v11283, 2
  store i32 %v11295, ptr %NEXT_PC, align 4
  %v11296 = load ptr, ptr %MEMORY, align 4
  %v11297 = call ptr @__remill_atomic_begin(ptr %v11296)
  store ptr %v11297, ptr %MEMORY, align 4
  %v11298 = add i32 %v11295, 17
  %v11299 = load ptr, ptr %MEMORY, align 4
  %v11300 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11299, ptr %state, ptr %BRANCH_TAKEN, i32 %v11298, i32 %v11295, ptr %NEXT_PC)
  store ptr %v11300, ptr %MEMORY, align 4
  %v11301 = load ptr, ptr %MEMORY, align 4
  %v11302 = call ptr @__remill_atomic_end(ptr %v11301)
  store ptr %v11302, ptr %MEMORY, align 4
  br i1 true, label %bb_4208306, label %bb_4208289

bb_4208289:                                       ; preds = %bb_4208281
  store i32 %v11295, ptr %PC, align 4
  %v11303 = add i32 %v11295, 3
  store i32 %v11303, ptr %NEXT_PC, align 4
  %v11304 = load ptr, ptr %MEMORY, align 4
  %v11305 = call ptr @__remill_atomic_begin(ptr %v11304)
  store ptr %v11305, ptr %MEMORY, align 4
  %v11306 = load i32, ptr %EBP, align 4
  %v11307 = load i32, ptr %SSBASE, align 4
  %v11308 = add i32 %v11306, 20
  %v11309 = add i32 %v11308, %v11307
  %v11310 = load ptr, ptr %MEMORY, align 4
  %v11311 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11310, ptr %state, ptr %EAX, i32 %v11309)
  store ptr %v11311, ptr %MEMORY, align 4
  %v11312 = load ptr, ptr %MEMORY, align 4
  %v11313 = call ptr @__remill_atomic_end(ptr %v11312)
  store ptr %v11313, ptr %MEMORY, align 4
  store i32 %v11303, ptr %PC, align 4
  %v11314 = add i32 %v11303, 3
  store i32 %v11314, ptr %NEXT_PC, align 4
  %v11315 = load ptr, ptr %MEMORY, align 4
  %v11316 = call ptr @__remill_atomic_begin(ptr %v11315)
  store ptr %v11316, ptr %MEMORY, align 4
  %v11317 = load i32, ptr %EAX, align 4
  %v11318 = load i32, ptr %DSBASE, align 4
  %v11319 = add i32 %v11317, 4
  %v11320 = add i32 %v11319, %v11318
  %v11321 = load ptr, ptr %MEMORY, align 4
  %v11322 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11321, ptr %state, ptr %EAX, i32 %v11320)
  store ptr %v11322, ptr %MEMORY, align 4
  %v11323 = load ptr, ptr %MEMORY, align 4
  %v11324 = call ptr @__remill_atomic_end(ptr %v11323)
  store ptr %v11324, ptr %MEMORY, align 4
  store i32 %v11314, ptr %PC, align 4
  %v11325 = add i32 %v11314, 2
  store i32 %v11325, ptr %NEXT_PC, align 4
  %v11326 = load ptr, ptr %MEMORY, align 4
  %v11327 = call ptr @__remill_atomic_begin(ptr %v11326)
  store ptr %v11327, ptr %MEMORY, align 4
  %v11328 = load i32, ptr %EAX, align 4
  %v11329 = load ptr, ptr %MEMORY, align 4
  %v11330 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11329, ptr %state, ptr %EDX, i32 %v11328)
  store ptr %v11330, ptr %MEMORY, align 4
  %v11331 = load ptr, ptr %MEMORY, align 4
  %v11332 = call ptr @__remill_atomic_end(ptr %v11331)
  store ptr %v11332, ptr %MEMORY, align 4
  store i32 %v11325, ptr %PC, align 4
  %v11333 = add i32 %v11325, 3
  store i32 %v11333, ptr %NEXT_PC, align 4
  %v11334 = load ptr, ptr %MEMORY, align 4
  %v11335 = call ptr @__remill_atomic_begin(ptr %v11334)
  store ptr %v11335, ptr %MEMORY, align 4
  %v11336 = load i8, ptr %DH, align 1
  %v11337 = zext i8 %v11336 to i32
  %v11338 = load ptr, ptr %MEMORY, align 4
  %v11339 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIhE2RnIhLb1EE2InIhEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11338, ptr %state, ptr %DH, i32 %v11337, i32 247)
  store ptr %v11339, ptr %MEMORY, align 4
  %v11340 = load ptr, ptr %MEMORY, align 4
  %v11341 = call ptr @__remill_atomic_end(ptr %v11340)
  store ptr %v11341, ptr %MEMORY, align 4
  store i32 %v11333, ptr %PC, align 4
  %v11342 = add i32 %v11333, 3
  store i32 %v11342, ptr %NEXT_PC, align 4
  %v11343 = load ptr, ptr %MEMORY, align 4
  %v11344 = call ptr @__remill_atomic_begin(ptr %v11343)
  store ptr %v11344, ptr %MEMORY, align 4
  %v11345 = load i32, ptr %EBP, align 4
  %v11346 = load i32, ptr %SSBASE, align 4
  %v11347 = add i32 %v11345, 20
  %v11348 = add i32 %v11347, %v11346
  %v11349 = load ptr, ptr %MEMORY, align 4
  %v11350 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11349, ptr %state, ptr %EAX, i32 %v11348)
  store ptr %v11350, ptr %MEMORY, align 4
  %v11351 = load ptr, ptr %MEMORY, align 4
  %v11352 = call ptr @__remill_atomic_end(ptr %v11351)
  store ptr %v11352, ptr %MEMORY, align 4
  store i32 %v11342, ptr %PC, align 4
  %v11353 = add i32 %v11342, 3
  store i32 %v11353, ptr %NEXT_PC, align 4
  %v11354 = load ptr, ptr %MEMORY, align 4
  %v11355 = call ptr @__remill_atomic_begin(ptr %v11354)
  store ptr %v11355, ptr %MEMORY, align 4
  %v11356 = load i32, ptr %EAX, align 4
  %v11357 = load i32, ptr %DSBASE, align 4
  %v11358 = add i32 %v11356, 4
  %v11359 = add i32 %v11358, %v11357
  %v11360 = load i32, ptr %EDX, align 4
  %v11361 = load ptr, ptr %MEMORY, align 4
  %v11362 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11361, ptr %state, i32 %v11359, i32 %v11360)
  store ptr %v11362, ptr %MEMORY, align 4
  %v11363 = load ptr, ptr %MEMORY, align 4
  %v11364 = call ptr @__remill_atomic_end(ptr %v11363)
  store ptr %v11364, ptr %MEMORY, align 4
  br label %bb_4208306

bb_4208306:                                       ; preds = %bb_4208289, %bb_4208281
  %v11365 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11365, ptr %PC, align 4
  %v11366 = add i32 %v11365, 3
  store i32 %v11366, ptr %NEXT_PC, align 4
  %v11367 = load ptr, ptr %MEMORY, align 4
  %v11368 = call ptr @__remill_atomic_begin(ptr %v11367)
  store ptr %v11368, ptr %MEMORY, align 4
  %v11369 = load i32, ptr %EBP, align 4
  %v11370 = load i32, ptr %SSBASE, align 4
  %v11371 = add i32 %v11369, 20
  %v11372 = add i32 %v11371, %v11370
  %v11373 = load ptr, ptr %MEMORY, align 4
  %v11374 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11373, ptr %state, ptr %EAX, i32 %v11372)
  store ptr %v11374, ptr %MEMORY, align 4
  %v11375 = load ptr, ptr %MEMORY, align 4
  %v11376 = call ptr @__remill_atomic_end(ptr %v11375)
  store ptr %v11376, ptr %MEMORY, align 4
  store i32 %v11366, ptr %PC, align 4
  %v11377 = add i32 %v11366, 3
  store i32 %v11377, ptr %NEXT_PC, align 4
  %v11378 = load ptr, ptr %MEMORY, align 4
  %v11379 = call ptr @__remill_atomic_begin(ptr %v11378)
  store ptr %v11379, ptr %MEMORY, align 4
  %v11380 = load i32, ptr %EAX, align 4
  %v11381 = load i32, ptr %DSBASE, align 4
  %v11382 = add i32 %v11380, 12
  %v11383 = add i32 %v11382, %v11381
  %v11384 = load ptr, ptr %MEMORY, align 4
  %v11385 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11384, ptr %state, ptr %EAX, i32 %v11383)
  store ptr %v11385, ptr %MEMORY, align 4
  %v11386 = load ptr, ptr %MEMORY, align 4
  %v11387 = call ptr @__remill_atomic_end(ptr %v11386)
  store ptr %v11387, ptr %MEMORY, align 4
  store i32 %v11377, ptr %PC, align 4
  %v11388 = add i32 %v11377, 3
  store i32 %v11388, ptr %NEXT_PC, align 4
  %v11389 = load ptr, ptr %MEMORY, align 4
  %v11390 = call ptr @__remill_atomic_begin(ptr %v11389)
  store ptr %v11390, ptr %MEMORY, align 4
  %v11391 = load i32, ptr %EBP, align 4
  %v11392 = load i32, ptr %SSBASE, align 4
  %v11393 = sub i32 %v11391, 12
  %v11394 = add i32 %v11393, %v11392
  %v11395 = load i32, ptr %EAX, align 4
  %v11396 = load ptr, ptr %MEMORY, align 4
  %v11397 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11396, ptr %state, i32 %v11394, i32 %v11395)
  store ptr %v11397, ptr %MEMORY, align 4
  %v11398 = load ptr, ptr %MEMORY, align 4
  %v11399 = call ptr @__remill_atomic_end(ptr %v11398)
  store ptr %v11399, ptr %MEMORY, align 4
  store i32 %v11388, ptr %PC, align 4
  %v11400 = add i32 %v11388, 4
  store i32 %v11400, ptr %NEXT_PC, align 4
  %v11401 = load ptr, ptr %MEMORY, align 4
  %v11402 = call ptr @__remill_atomic_begin(ptr %v11401)
  store ptr %v11402, ptr %MEMORY, align 4
  %v11403 = load i32, ptr %EBP, align 4
  %v11404 = load i32, ptr %SSBASE, align 4
  %v11405 = sub i32 %v11403, 12
  %v11406 = add i32 %v11405, %v11404
  %v11407 = load ptr, ptr %MEMORY, align 4
  %v11408 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11407, ptr %state, i32 %v11406, i32 0)
  store ptr %v11408, ptr %MEMORY, align 4
  %v11409 = load ptr, ptr %MEMORY, align 4
  %v11410 = call ptr @__remill_atomic_end(ptr %v11409)
  store ptr %v11410, ptr %MEMORY, align 4
  store i32 %v11400, ptr %PC, align 4
  %v11411 = add i32 %v11400, 2
  store i32 %v11411, ptr %NEXT_PC, align 4
  %v11412 = load ptr, ptr %MEMORY, align 4
  %v11413 = call ptr @__remill_atomic_begin(ptr %v11412)
  store ptr %v11413, ptr %MEMORY, align 4
  %v11414 = add i32 %v11411, 52
  %v11415 = load ptr, ptr %MEMORY, align 4
  %v11416 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11415, ptr %state, ptr %BRANCH_TAKEN, i32 %v11414, i32 %v11411, ptr %NEXT_PC)
  store ptr %v11416, ptr %MEMORY, align 4
  %v11417 = load ptr, ptr %MEMORY, align 4
  %v11418 = call ptr @__remill_atomic_end(ptr %v11417)
  store ptr %v11418, ptr %MEMORY, align 4
  ret ptr %memory

bb_4208321:                                       ; No predecessors!
  %v11419 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11419, ptr %PC, align 4
  %v11420 = add i32 %v11419, 3
  store i32 %v11420, ptr %NEXT_PC, align 4
  %v11421 = load ptr, ptr %MEMORY, align 4
  %v11422 = call ptr @__remill_atomic_begin(ptr %v11421)
  store ptr %v11422, ptr %MEMORY, align 4
  %v11423 = load i32, ptr %EBP, align 4
  %v11424 = load i32, ptr %SSBASE, align 4
  %v11425 = sub i32 %v11423, 32
  %v11426 = add i32 %v11425, %v11424
  %v11427 = load ptr, ptr %MEMORY, align 4
  %v11428 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11427, ptr %state, ptr %EAX, i32 %v11426)
  store ptr %v11428, ptr %MEMORY, align 4
  %v11429 = load ptr, ptr %MEMORY, align 4
  %v11430 = call ptr @__remill_atomic_end(ptr %v11429)
  store ptr %v11430, ptr %MEMORY, align 4
  store i32 %v11420, ptr %PC, align 4
  %v11431 = add i32 %v11420, 2
  store i32 %v11431, ptr %NEXT_PC, align 4
  %v11432 = load ptr, ptr %MEMORY, align 4
  %v11433 = call ptr @__remill_atomic_begin(ptr %v11432)
  store ptr %v11433, ptr %MEMORY, align 4
  %v11434 = load i32, ptr %EAX, align 4
  %v11435 = load ptr, ptr %MEMORY, align 4
  %v11436 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11435, ptr %state, ptr %EDX, i32 %v11434)
  store ptr %v11436, ptr %MEMORY, align 4
  %v11437 = load ptr, ptr %MEMORY, align 4
  %v11438 = call ptr @__remill_atomic_end(ptr %v11437)
  store ptr %v11438, ptr %MEMORY, align 4
  store i32 %v11431, ptr %PC, align 4
  %v11439 = add i32 %v11431, 3
  store i32 %v11439, ptr %NEXT_PC, align 4
  %v11440 = load ptr, ptr %MEMORY, align 4
  %v11441 = call ptr @__remill_atomic_begin(ptr %v11440)
  store ptr %v11441, ptr %MEMORY, align 4
  %v11442 = load i32, ptr %EBP, align 4
  %v11443 = load i32, ptr %SSBASE, align 4
  %v11444 = sub i32 %v11442, 16
  %v11445 = add i32 %v11444, %v11443
  %v11446 = load ptr, ptr %MEMORY, align 4
  %v11447 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11446, ptr %state, ptr %EAX, i32 %v11445)
  store ptr %v11447, ptr %MEMORY, align 4
  %v11448 = load ptr, ptr %MEMORY, align 4
  %v11449 = call ptr @__remill_atomic_end(ptr %v11448)
  store ptr %v11449, ptr %MEMORY, align 4
  store i32 %v11439, ptr %PC, align 4
  %v11450 = add i32 %v11439, 2
  store i32 %v11450, ptr %NEXT_PC, align 4
  %v11451 = load ptr, ptr %MEMORY, align 4
  %v11452 = call ptr @__remill_atomic_begin(ptr %v11451)
  store ptr %v11452, ptr %MEMORY, align 4
  %v11453 = load i32, ptr %EDX, align 4
  %v11454 = load ptr, ptr %MEMORY, align 4
  %v11455 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11454, ptr %state, ptr %ECX, i32 %v11453)
  store ptr %v11455, ptr %MEMORY, align 4
  %v11456 = load ptr, ptr %MEMORY, align 4
  %v11457 = call ptr @__remill_atomic_end(ptr %v11456)
  store ptr %v11457, ptr %MEMORY, align 4
  store i32 %v11450, ptr %PC, align 4
  %v11458 = add i32 %v11450, 2
  store i32 %v11458, ptr %NEXT_PC, align 4
  %v11459 = load ptr, ptr %MEMORY, align 4
  %v11460 = call ptr @__remill_atomic_begin(ptr %v11459)
  store ptr %v11460, ptr %MEMORY, align 4
  %v11461 = load i32, ptr %ECX, align 4
  %v11462 = load i32, ptr %EAX, align 4
  %v11463 = load ptr, ptr %MEMORY, align 4
  %v11464 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v11463, ptr %state, ptr %ECX, i32 %v11461, i32 %v11462)
  store ptr %v11464, ptr %MEMORY, align 4
  %v11465 = load ptr, ptr %MEMORY, align 4
  %v11466 = call ptr @__remill_atomic_end(ptr %v11465)
  store ptr %v11466, ptr %MEMORY, align 4
  store i32 %v11458, ptr %PC, align 4
  %v11467 = add i32 %v11458, 2
  store i32 %v11467, ptr %NEXT_PC, align 4
  %v11468 = load ptr, ptr %MEMORY, align 4
  %v11469 = call ptr @__remill_atomic_begin(ptr %v11468)
  store ptr %v11469, ptr %MEMORY, align 4
  %v11470 = load i32, ptr %ECX, align 4
  %v11471 = load ptr, ptr %MEMORY, align 4
  %v11472 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v11471, ptr %state, ptr %EAX, i32 %v11470)
  store ptr %v11472, ptr %MEMORY, align 4
  %v11473 = load ptr, ptr %MEMORY, align 4
  %v11474 = call ptr @__remill_atomic_end(ptr %v11473)
  store ptr %v11474, ptr %MEMORY, align 4
  store i32 %v11467, ptr %PC, align 4
  %v11475 = add i32 %v11467, 3
  store i32 %v11475, ptr %NEXT_PC, align 4
  %v11476 = load ptr, ptr %MEMORY, align 4
  %v11477 = call ptr @__remill_atomic_begin(ptr %v11476)
  store ptr %v11477, ptr %MEMORY, align 4
  %v11478 = load i32, ptr %EBP, align 4
  %v11479 = load i32, ptr %SSBASE, align 4
  %v11480 = sub i32 %v11478, 12
  %v11481 = add i32 %v11480, %v11479
  %v11482 = load i32, ptr %EBP, align 4
  %v11483 = load i32, ptr %SSBASE, align 4
  %v11484 = sub i32 %v11482, 12
  %v11485 = add i32 %v11484, %v11483
  %v11486 = load i32, ptr %EAX, align 4
  %v11487 = load ptr, ptr %MEMORY, align 4
  %v11488 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11487, ptr %state, i32 %v11481, i32 %v11485, i32 %v11486)
  store ptr %v11488, ptr %MEMORY, align 4
  %v11489 = load ptr, ptr %MEMORY, align 4
  %v11490 = call ptr @__remill_atomic_end(ptr %v11489)
  store ptr %v11490, ptr %MEMORY, align 4
  store i32 %v11475, ptr %PC, align 4
  %v11491 = add i32 %v11475, 4
  store i32 %v11491, ptr %NEXT_PC, align 4
  %v11492 = load ptr, ptr %MEMORY, align 4
  %v11493 = call ptr @__remill_atomic_begin(ptr %v11492)
  store ptr %v11493, ptr %MEMORY, align 4
  %v11494 = load i32, ptr %EBP, align 4
  %v11495 = load i32, ptr %SSBASE, align 4
  %v11496 = sub i32 %v11494, 12
  %v11497 = add i32 %v11496, %v11495
  %v11498 = load ptr, ptr %MEMORY, align 4
  %v11499 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11498, ptr %state, i32 %v11497, i32 0)
  store ptr %v11499, ptr %MEMORY, align 4
  %v11500 = load ptr, ptr %MEMORY, align 4
  %v11501 = call ptr @__remill_atomic_end(ptr %v11500)
  store ptr %v11501, ptr %MEMORY, align 4
  store i32 %v11491, ptr %PC, align 4
  %v11502 = add i32 %v11491, 2
  store i32 %v11502, ptr %NEXT_PC, align 4
  %v11503 = load ptr, ptr %MEMORY, align 4
  %v11504 = call ptr @__remill_atomic_begin(ptr %v11503)
  store ptr %v11504, ptr %MEMORY, align 4
  %v11505 = add i32 %v11502, 29
  %v11506 = load ptr, ptr %MEMORY, align 4
  %v11507 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11506, ptr %state, ptr %BRANCH_TAKEN, i32 %v11505, i32 %v11502, ptr %NEXT_PC)
  store ptr %v11507, ptr %MEMORY, align 4
  %v11508 = load ptr, ptr %MEMORY, align 4
  %v11509 = call ptr @__remill_atomic_end(ptr %v11508)
  store ptr %v11509, ptr %MEMORY, align 4
  ret ptr %memory

bb_4208344:                                       ; No predecessors!
  %v11510 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11510, ptr %PC, align 4
  %v11511 = add i32 %v11510, 2
  store i32 %v11511, ptr %NEXT_PC, align 4
  %v11512 = load ptr, ptr %MEMORY, align 4
  %v11513 = call ptr @__remill_atomic_begin(ptr %v11512)
  store ptr %v11513, ptr %MEMORY, align 4
  %v11514 = add i32 %v11511, 10
  %v11515 = load ptr, ptr %MEMORY, align 4
  %v11516 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v11515, ptr %state, i32 %v11514, ptr %NEXT_PC)
  store ptr %v11516, ptr %MEMORY, align 4
  %v11517 = load ptr, ptr %MEMORY, align 4
  %v11518 = call ptr @__remill_atomic_end(ptr %v11517)
  store ptr %v11518, ptr %MEMORY, align 4
  br label %bb_4208356

bb_4208346:                                       ; preds = %bb_4208356
  store i32 %v11600, ptr %PC, align 4
  %v11519 = add i32 %v11600, 3
  store i32 %v11519, ptr %NEXT_PC, align 4
  %v11520 = load ptr, ptr %MEMORY, align 4
  %v11521 = call ptr @__remill_atomic_begin(ptr %v11520)
  store ptr %v11521, ptr %MEMORY, align 4
  %v11522 = load i32, ptr %EBP, align 4
  %v11523 = load i32, ptr %SSBASE, align 4
  %v11524 = sub i32 %v11522, 16
  %v11525 = add i32 %v11524, %v11523
  %v11526 = load ptr, ptr %MEMORY, align 4
  %v11527 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11526, ptr %state, ptr %EAX, i32 %v11525)
  store ptr %v11527, ptr %MEMORY, align 4
  %v11528 = load ptr, ptr %MEMORY, align 4
  %v11529 = call ptr @__remill_atomic_end(ptr %v11528)
  store ptr %v11529, ptr %MEMORY, align 4
  store i32 %v11519, ptr %PC, align 4
  %v11530 = add i32 %v11519, 3
  store i32 %v11530, ptr %NEXT_PC, align 4
  %v11531 = load ptr, ptr %MEMORY, align 4
  %v11532 = call ptr @__remill_atomic_begin(ptr %v11531)
  store ptr %v11532, ptr %MEMORY, align 4
  %v11533 = load i32, ptr %EAX, align 4
  %v11534 = load i32, ptr %DSBASE, align 4
  %v11535 = add i32 %v11533, %v11534
  %v11536 = load ptr, ptr %MEMORY, align 4
  %v11537 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIhE2InIhEEEP6MemoryS6_R5StateT_T0_(ptr %v11536, ptr %state, i32 %v11535, i32 48)
  store ptr %v11537, ptr %MEMORY, align 4
  %v11538 = load ptr, ptr %MEMORY, align 4
  %v11539 = call ptr @__remill_atomic_end(ptr %v11538)
  store ptr %v11539, ptr %MEMORY, align 4
  store i32 %v11530, ptr %PC, align 4
  %v11540 = add i32 %v11530, 4
  store i32 %v11540, ptr %NEXT_PC, align 4
  %v11541 = load ptr, ptr %MEMORY, align 4
  %v11542 = call ptr @__remill_atomic_begin(ptr %v11541)
  store ptr %v11542, ptr %MEMORY, align 4
  %v11543 = load i32, ptr %EBP, align 4
  %v11544 = load i32, ptr %SSBASE, align 4
  %v11545 = sub i32 %v11543, 16
  %v11546 = add i32 %v11545, %v11544
  %v11547 = load i32, ptr %EBP, align 4
  %v11548 = load i32, ptr %SSBASE, align 4
  %v11549 = sub i32 %v11547, 16
  %v11550 = add i32 %v11549, %v11548
  %v11551 = load ptr, ptr %MEMORY, align 4
  %v11552 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11551, ptr %state, i32 %v11546, i32 %v11550, i32 1)
  store ptr %v11552, ptr %MEMORY, align 4
  %v11553 = load ptr, ptr %MEMORY, align 4
  %v11554 = call ptr @__remill_atomic_end(ptr %v11553)
  store ptr %v11554, ptr %MEMORY, align 4
  br label %bb_4208356

bb_4208356:                                       ; preds = %bb_4208346, %bb_4208344
  %v11555 = load i32, ptr %NEXT_PC, align 4
  store i32 %v11555, ptr %PC, align 4
  %v11556 = add i32 %v11555, 4
  store i32 %v11556, ptr %NEXT_PC, align 4
  %v11557 = load ptr, ptr %MEMORY, align 4
  %v11558 = call ptr @__remill_atomic_begin(ptr %v11557)
  store ptr %v11558, ptr %MEMORY, align 4
  %v11559 = load i32, ptr %EBP, align 4
  %v11560 = load i32, ptr %SSBASE, align 4
  %v11561 = sub i32 %v11559, 12
  %v11562 = add i32 %v11561, %v11560
  %v11563 = load ptr, ptr %MEMORY, align 4
  %v11564 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v11563, ptr %state, i32 %v11562, i32 0)
  store ptr %v11564, ptr %MEMORY, align 4
  %v11565 = load ptr, ptr %MEMORY, align 4
  %v11566 = call ptr @__remill_atomic_end(ptr %v11565)
  store ptr %v11566, ptr %MEMORY, align 4
  store i32 %v11556, ptr %PC, align 4
  %v11567 = add i32 %v11556, 3
  store i32 %v11567, ptr %NEXT_PC, align 4
  %v11568 = load ptr, ptr %MEMORY, align 4
  %v11569 = call ptr @__remill_atomic_begin(ptr %v11568)
  store ptr %v11569, ptr %MEMORY, align 4
  %v11570 = load ptr, ptr %MEMORY, align 4
  %v11571 = call ptr @_ZN12_GLOBAL__N_16SETNLEI3RnWIhEEEP6MemoryS4_R5StateT_(ptr %v11570, ptr %state, ptr %AL)
  store ptr %v11571, ptr %MEMORY, align 4
  %v11572 = load ptr, ptr %MEMORY, align 4
  %v11573 = call ptr @__remill_atomic_end(ptr %v11572)
  store ptr %v11573, ptr %MEMORY, align 4
  store i32 %v11567, ptr %PC, align 4
  %v11574 = add i32 %v11567, 4
  store i32 %v11574, ptr %NEXT_PC, align 4
  %v11575 = load ptr, ptr %MEMORY, align 4
  %v11576 = call ptr @__remill_atomic_begin(ptr %v11575)
  store ptr %v11576, ptr %MEMORY, align 4
  %v11577 = load i32, ptr %EBP, align 4
  %v11578 = load i32, ptr %SSBASE, align 4
  %v11579 = sub i32 %v11577, 12
  %v11580 = add i32 %v11579, %v11578
  %v11581 = load i32, ptr %EBP, align 4
  %v11582 = load i32, ptr %SSBASE, align 4
  %v11583 = sub i32 %v11581, 12
  %v11584 = add i32 %v11583, %v11582
  %v11585 = load ptr, ptr %MEMORY, align 4
  %v11586 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11585, ptr %state, i32 %v11580, i32 %v11584, i32 1)
  store ptr %v11586, ptr %MEMORY, align 4
  %v11587 = load ptr, ptr %MEMORY, align 4
  %v11588 = call ptr @__remill_atomic_end(ptr %v11587)
  store ptr %v11588, ptr %MEMORY, align 4
  store i32 %v11574, ptr %PC, align 4
  %v11589 = add i32 %v11574, 2
  store i32 %v11589, ptr %NEXT_PC, align 4
  %v11590 = load ptr, ptr %MEMORY, align 4
  %v11591 = call ptr @__remill_atomic_begin(ptr %v11590)
  store ptr %v11591, ptr %MEMORY, align 4
  %v11592 = load i8, ptr %AL, align 1
  %v11593 = zext i8 %v11592 to i32
  %v11594 = load i8, ptr %AL, align 1
  %v11595 = zext i8 %v11594 to i32
  %v11596 = load ptr, ptr %MEMORY, align 4
  %v11597 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v11596, ptr %state, i32 %v11593, i32 %v11595)
  store ptr %v11597, ptr %MEMORY, align 4
  %v11598 = load ptr, ptr %MEMORY, align 4
  %v11599 = call ptr @__remill_atomic_end(ptr %v11598)
  store ptr %v11599, ptr %MEMORY, align 4
  store i32 %v11589, ptr %PC, align 4
  %v11600 = add i32 %v11589, 2
  store i32 %v11600, ptr %NEXT_PC, align 4
  %v11601 = load ptr, ptr %MEMORY, align 4
  %v11602 = call ptr @__remill_atomic_begin(ptr %v11601)
  store ptr %v11602, ptr %MEMORY, align 4
  %v11603 = sub i32 %v11600, 25
  %v11604 = load ptr, ptr %MEMORY, align 4
  %v11605 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v11604, ptr %state, ptr %BRANCH_TAKEN, i32 %v11603, i32 %v11600, ptr %NEXT_PC)
  store ptr %v11605, ptr %MEMORY, align 4
  %v11606 = load ptr, ptr %MEMORY, align 4
  %v11607 = call ptr @__remill_atomic_end(ptr %v11606)
  store ptr %v11607, ptr %MEMORY, align 4
  br i1 true, label %bb_4208346, label %bb_4208371

bb_4208371:                                       ; preds = %bb_4208356
  ret ptr %memory
}

attributes #0 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #5 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"NumRegisterParameters", i32 0}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{!"base.helper.semantics"}
!7 = !{[3 x i8] c"DH\00"}
!8 = !{[3 x i8] c"CL\00"}
!9 = !{[4 x i8] c"ESI\00"}
!10 = !{[3 x i8] c"DL\00"}
!11 = !{[7 x i8] c"FSBASE\00"}
!12 = !{[4 x i8] c"EBX\00"}
!13 = !{[3 x i8] c"AL\00"}
!14 = !{[4 x i8] c"ECX\00"}
!15 = !{[4 x i8] c"EDX\00"}
!16 = !{[3 x i8] c"AX\00"}
!17 = !{[7 x i8] c"SSBASE\00"}
!18 = !{[7 x i8] c"DSBASE\00"}
!19 = !{[4 x i8] c"EAX\00"}
!20 = !{[4 x i8] c"ESP\00"}
!21 = !{[4 x i8] c"EBP\00"}
!22 = !{[3 x i8] c"PC\00"}
