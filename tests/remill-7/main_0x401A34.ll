; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: debugme.exe
; Address: 0x00401a34
; Size: 3000 bytes
; Architecture: x86
; Generated: 2026-03-12T19:05:34.989Z
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
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local double @__remill_read_memory_f64(ptr noundef, i32 noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i8 @__remill_undefined_8() #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_error(ptr noundef nonnull align 16 dereferenceable(3504), i32 noundef, ptr noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr noundef, ptr noundef nonnull align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_17RET_IMMEP6MemoryR5State2InItE3RnWIjE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_sle(i1 noundef zeroext) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_neq(i1 noundef zeroext) #0

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_uge(i1 noundef zeroext) #3

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #0

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_slt(i1 noundef zeroext) #3

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_ult(i1 noundef zeroext) #3

declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_ugt(i1 noundef zeroext) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JNBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare !remill.function.type !6 double @llvm.fabs.f64(double) #1

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #2

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_write_memory_f64(ptr noundef, i32 noundef, double noundef) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13NOTI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare !remill.function.type !6 void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #5

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare !remill.function.type !6 void @llvm.memcpy.p0.p0.i32(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i32, i1 immarg) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare !remill.function.type !6 void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #5

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16) #7

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #2

declare !remill.function.type !6 dso_local void @__remill_fpu_set_rounding(i32 noundef) #3

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, ptr nocapture writeonly) #4

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13JMPI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, ptr nocapture writeonly) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture readnone, i32, i32, i32) #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare !remill.function.type !6 x86_fp80 @llvm.fabs.f80(x86_fp80) #1

declare !remill.function.type !6 dso_local i32 @__remill_fpu_exception_test(i32 noundef) #3

declare !remill.function.type !6 dso_local void @__remill_fpu_exception_clear(i32 noundef) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture readonly, i32, i32) #2

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14FXCHEP6MemoryR5State3RnWI9float80_tES6_S6_S6_2InIjES7_ItE(ptr noundef readnone returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly, ptr nocapture readonly, ptr nocapture writeonly, ptr nocapture readonly, i32, i32) #8

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare !remill.function.type !6 void @llvm.memmove.p0.p0.i32(ptr nocapture writeonly, ptr nocapture readonly, i32, i1 immarg) #6

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18DoFNINITEP6MemoryR5State(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504)) #2

define ptr @lifted_4201012(ptr noalias %state, i32 %program_counter, ptr noalias %memory) {
bb_0:
  %AX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !7
  %AL = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !8
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !9
  %EBX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0, !remill_register !10
  %ST2 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 7, i32 0, i32 2, i32 1, i32 0, i32 0, !remill_register !11
  %ST0 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 7, i32 0, i32 0, i32 1, i32 0, i32 0, !remill_register !12
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !13
  %DSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 9, i32 0, i32 0, !remill_register !14
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !15
  %SSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 1, i32 0, i32 0, !remill_register !16
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
  %v1 = add i32 %program_counter, 1
  store i32 %v1, ptr %NEXT_PC, align 4
  %v2 = load i32, ptr %EBP, align 4
  %v3 = load ptr, ptr %MEMORY, align 4
  %v4 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3, ptr %state, i32 %v2)
  store ptr %v4, ptr %MEMORY, align 4
  store i32 %v1, ptr %PC, align 4
  %v5 = add i32 %v1, 2
  store i32 %v5, ptr %NEXT_PC, align 4
  %v6 = load i32, ptr %ESP, align 4
  %v7 = load ptr, ptr %MEMORY, align 4
  %v8 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v7, ptr %state, ptr %EBP, i32 %v6)
  store ptr %v8, ptr %MEMORY, align 4
  store i32 %v5, ptr %PC, align 4
  %v9 = add i32 %v5, 3
  store i32 %v9, ptr %NEXT_PC, align 4
  %v10 = load i32, ptr %ESP, align 4
  %v11 = load ptr, ptr %MEMORY, align 4
  %v12 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v11, ptr %state, ptr %ESP, i32 %v10, i32 40)
  store ptr %v12, ptr %MEMORY, align 4
  store i32 %v9, ptr %PC, align 4
  %v13 = add i32 %v9, 7
  store i32 %v13, ptr %NEXT_PC, align 4
  %v14 = load i32, ptr %EBP, align 4
  %v15 = load i32, ptr %SSBASE, align 4
  %v16 = sub i32 %v14, 12
  %v17 = add i32 %v16, %v15
  %v18 = load ptr, ptr %MEMORY, align 4
  %v19 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v18, ptr %state, i32 %v17, i32 0)
  store ptr %v19, ptr %MEMORY, align 4
  store i32 %v13, ptr %PC, align 4
  %v20 = add i32 %v13, 7
  store i32 %v20, ptr %NEXT_PC, align 4
  %v21 = load i32, ptr %EBP, align 4
  %v22 = load i32, ptr %SSBASE, align 4
  %v23 = sub i32 %v21, 16
  %v24 = add i32 %v23, %v22
  %v25 = load ptr, ptr %MEMORY, align 4
  %v26 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v25, ptr %state, i32 %v24, i32 0)
  store ptr %v26, ptr %MEMORY, align 4
  store i32 %v20, ptr %PC, align 4
  %v27 = add i32 %v20, 3
  store i32 %v27, ptr %NEXT_PC, align 4
  %v28 = load i32, ptr %EBP, align 4
  %v29 = load i32, ptr %SSBASE, align 4
  %v30 = add i32 %v28, 8
  %v31 = add i32 %v30, %v29
  %v32 = load ptr, ptr %MEMORY, align 4
  %v33 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v32, ptr %state, ptr %EAX, i32 %v31)
  store ptr %v33, ptr %MEMORY, align 4
  store i32 %v27, ptr %PC, align 4
  %v34 = add i32 %v27, 2
  store i32 %v34, ptr %NEXT_PC, align 4
  %v35 = load i32, ptr %EAX, align 4
  %v36 = load i32, ptr %DSBASE, align 4
  %v37 = add i32 %v35, %v36
  %v38 = load ptr, ptr %MEMORY, align 4
  %v39 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v38, ptr %state, ptr %EAX, i32 %v37)
  store ptr %v39, ptr %MEMORY, align 4
  store i32 %v34, ptr %PC, align 4
  %v40 = add i32 %v34, 2
  store i32 %v40, ptr %NEXT_PC, align 4
  %v41 = load i32, ptr %EAX, align 4
  %v42 = load i32, ptr %DSBASE, align 4
  %v43 = add i32 %v41, %v42
  %v44 = load ptr, ptr %MEMORY, align 4
  %v45 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v44, ptr %state, ptr %EAX, i32 %v43)
  store ptr %v45, ptr %MEMORY, align 4
  store i32 %v40, ptr %PC, align 4
  %v46 = add i32 %v40, 5
  store i32 %v46, ptr %NEXT_PC, align 4
  %v47 = load i32, ptr %EAX, align 4
  %v48 = load ptr, ptr %MEMORY, align 4
  %v49 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v48, ptr %state, i32 %v47, i32 -1073741679)
  store ptr %v49, ptr %MEMORY, align 4
  store i32 %v46, ptr %PC, align 4
  %v50 = add i32 %v46, 2
  store i32 %v50, ptr %NEXT_PC, align 4
  %v51 = add i32 %v50, 34
  %v52 = load ptr, ptr %MEMORY, align 4
  %v53 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v52, ptr %state, ptr %BRANCH_TAKEN, i32 %v51, i32 %v50, ptr %NEXT_PC)
  store ptr %v53, ptr %MEMORY, align 4
  br i1 true, label %bb_4201080, label %bb_4201046

bb_4201046:                                       ; preds = %bb_0
  store i32 %v50, ptr %PC, align 4
  %v54 = add i32 %v50, 5
  store i32 %v54, ptr %NEXT_PC, align 4
  %v55 = load i32, ptr %EAX, align 4
  %v56 = load ptr, ptr %MEMORY, align 4
  %v57 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v56, ptr %state, i32 %v55, i32 -1073741683)
  store ptr %v57, ptr %MEMORY, align 4
  store i32 %v54, ptr %PC, align 4
  %v58 = add i32 %v54, 6
  store i32 %v58, ptr %NEXT_PC, align 4
  %v59 = add i32 %v58, 244
  %v60 = load ptr, ptr %MEMORY, align 4
  %v61 = call ptr @_ZN12_GLOBAL__N_13JNBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v60, ptr %state, ptr %BRANCH_TAKEN, i32 %v59, i32 %v58, ptr %NEXT_PC)
  store ptr %v61, ptr %MEMORY, align 4
  br i1 true, label %bb_4201301, label %bb_4201057

bb_4201057:                                       ; preds = %bb_4201046
  store i32 %v58, ptr %PC, align 4
  %v62 = add i32 %v58, 5
  store i32 %v62, ptr %NEXT_PC, align 4
  %v63 = load i32, ptr %EAX, align 4
  %v64 = load ptr, ptr %MEMORY, align 4
  %v65 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v64, ptr %state, i32 %v63, i32 -1073741819)
  store ptr %v65, ptr %MEMORY, align 4
  store i32 %v62, ptr %PC, align 4
  %v66 = add i32 %v62, 2
  store i32 %v66, ptr %NEXT_PC, align 4
  %v67 = add i32 %v66, 50
  %v68 = load ptr, ptr %MEMORY, align 4
  %v69 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v68, ptr %state, ptr %BRANCH_TAKEN, i32 %v67, i32 %v66, ptr %NEXT_PC)
  store ptr %v69, ptr %MEMORY, align 4
  br i1 true, label %bb_4201114, label %bb_4201064

bb_4201064:                                       ; preds = %bb_4201057
  store i32 %v66, ptr %PC, align 4
  %v70 = add i32 %v66, 5
  store i32 %v70, ptr %NEXT_PC, align 4
  %v71 = load i32, ptr %EAX, align 4
  %v72 = load ptr, ptr %MEMORY, align 4
  %v73 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v72, ptr %state, i32 %v71, i32 -1073741795)
  store ptr %v73, ptr %MEMORY, align 4
  store i32 %v70, ptr %PC, align 4
  %v74 = add i32 %v70, 6
  store i32 %v74, ptr %NEXT_PC, align 4
  %v75 = add i32 %v74, 134
  %v76 = load ptr, ptr %MEMORY, align 4
  %v77 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v76, ptr %state, ptr %BRANCH_TAKEN, i32 %v75, i32 %v74, ptr %NEXT_PC)
  store ptr %v77, ptr %MEMORY, align 4
  br i1 true, label %bb_4201209, label %bb_4201075

bb_4201075:                                       ; preds = %bb_4201064
  store i32 %v74, ptr %PC, align 4
  %v78 = add i32 %v74, 5
  store i32 %v78, ptr %NEXT_PC, align 4
  %v79 = add i32 %v78, 324
  %v80 = load ptr, ptr %MEMORY, align 4
  %v81 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v80, ptr %state, i32 %v79, ptr %NEXT_PC)
  store ptr %v81, ptr %MEMORY, align 4
  br label %bb_4201404

bb_4201080:                                       ; preds = %bb_0
  store i32 %v50, ptr %PC, align 4
  %v82 = add i32 %v50, 5
  store i32 %v82, ptr %NEXT_PC, align 4
  %v83 = load i32, ptr %EAX, align 4
  %v84 = load ptr, ptr %MEMORY, align 4
  %v85 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v84, ptr %state, i32 %v83, i32 -1073741676)
  store ptr %v85, ptr %MEMORY, align 4
  store i32 %v82, ptr %PC, align 4
  %v86 = add i32 %v82, 6
  store i32 %v86, ptr %NEXT_PC, align 4
  %v87 = add i32 %v86, 217
  %v88 = load ptr, ptr %MEMORY, align 4
  %v89 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v88, ptr %state, ptr %BRANCH_TAKEN, i32 %v87, i32 %v86, ptr %NEXT_PC)
  store ptr %v89, ptr %MEMORY, align 4
  br i1 true, label %bb_4201308, label %bb_4201091

bb_4201091:                                       ; preds = %bb_4201080
  store i32 %v86, ptr %PC, align 4
  %v90 = add i32 %v86, 5
  store i32 %v90, ptr %NEXT_PC, align 4
  %v91 = load i32, ptr %EAX, align 4
  %v92 = load ptr, ptr %MEMORY, align 4
  %v93 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v92, ptr %state, i32 %v91, i32 -1073741674)
  store ptr %v93, ptr %MEMORY, align 4
  store i32 %v90, ptr %PC, align 4
  %v94 = add i32 %v90, 2
  store i32 %v94, ptr %NEXT_PC, align 4
  %v95 = add i32 %v94, 111
  %v96 = load ptr, ptr %MEMORY, align 4
  %v97 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v96, ptr %state, ptr %BRANCH_TAKEN, i32 %v95, i32 %v94, ptr %NEXT_PC)
  store ptr %v97, ptr %MEMORY, align 4
  br i1 true, label %bb_4201209, label %bb_4201098

bb_4201098:                                       ; preds = %bb_4201091
  store i32 %v94, ptr %PC, align 4
  %v98 = add i32 %v94, 5
  store i32 %v98, ptr %NEXT_PC, align 4
  %v99 = load i32, ptr %EAX, align 4
  %v100 = load ptr, ptr %MEMORY, align 4
  %v101 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v100, ptr %state, i32 %v99, i32 -1073741677)
  store ptr %v101, ptr %MEMORY, align 4
  store i32 %v98, ptr %PC, align 4
  %v102 = add i32 %v98, 6
  store i32 %v102, ptr %NEXT_PC, align 4
  %v103 = add i32 %v102, 192
  %v104 = load ptr, ptr %MEMORY, align 4
  %v105 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v104, ptr %state, ptr %BRANCH_TAKEN, i32 %v103, i32 %v102, ptr %NEXT_PC)
  store ptr %v105, ptr %MEMORY, align 4
  br i1 true, label %bb_4201301, label %bb_4201109

bb_4201109:                                       ; preds = %bb_4201098
  store i32 %v102, ptr %PC, align 4
  %v106 = add i32 %v102, 5
  store i32 %v106, ptr %NEXT_PC, align 4
  %v107 = add i32 %v106, 290
  %v108 = load ptr, ptr %MEMORY, align 4
  %v109 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v108, ptr %state, i32 %v107, ptr %NEXT_PC)
  store ptr %v109, ptr %MEMORY, align 4
  br label %bb_4201404

bb_4201114:                                       ; preds = %bb_4201057
  store i32 %v66, ptr %PC, align 4
  %v110 = add i32 %v66, 8
  store i32 %v110, ptr %NEXT_PC, align 4
  %v111 = load i32, ptr %ESP, align 4
  %v112 = load i32, ptr %SSBASE, align 4
  %v113 = add i32 %v111, 4
  %v114 = add i32 %v113, %v112
  %v115 = load ptr, ptr %MEMORY, align 4
  %v116 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v115, ptr %state, i32 %v114, i32 0)
  store ptr %v116, ptr %MEMORY, align 4
  store i32 %v110, ptr %PC, align 4
  %v117 = add i32 %v110, 7
  store i32 %v117, ptr %NEXT_PC, align 4
  %v118 = load i32, ptr %ESP, align 4
  %v119 = load i32, ptr %SSBASE, align 4
  %v120 = add i32 %v118, %v119
  %v121 = load ptr, ptr %MEMORY, align 4
  %v122 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v121, ptr %state, i32 %v120, i32 11)
  store ptr %v122, ptr %MEMORY, align 4
  store i32 %v117, ptr %PC, align 4
  %v123 = add i32 %v117, 5
  store i32 %v123, ptr %NEXT_PC, align 4
  %v124 = add i32 %v123, 27486
  %v125 = load ptr, ptr %MEMORY, align 4
  %v126 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v125, ptr %state, i64 4228620, ptr %NEXT_PC, i32 %v123, ptr %RETURN_PC)
  store ptr %v126, ptr %MEMORY, align 4
  store i32 %v123, ptr %PC, align 4
  %v127 = add i32 %v123, 3
  store i32 %v127, ptr %NEXT_PC, align 4
  %v128 = load i32, ptr %EBP, align 4
  %v129 = load i32, ptr %SSBASE, align 4
  %v130 = sub i32 %v128, 20
  %v131 = add i32 %v130, %v129
  %v132 = load i32, ptr %EAX, align 4
  %v133 = load ptr, ptr %MEMORY, align 4
  %v134 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v133, ptr %state, i32 %v131, i32 %v132)
  store ptr %v134, ptr %MEMORY, align 4
  store i32 %v127, ptr %PC, align 4
  %v135 = add i32 %v127, 4
  store i32 %v135, ptr %NEXT_PC, align 4
  %v136 = load i32, ptr %EBP, align 4
  %v137 = load i32, ptr %SSBASE, align 4
  %v138 = sub i32 %v136, 20
  %v139 = add i32 %v138, %v137
  %v140 = load ptr, ptr %MEMORY, align 4
  %v141 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v140, ptr %state, i32 %v139, i32 1)
  store ptr %v141, ptr %MEMORY, align 4
  store i32 %v135, ptr %PC, align 4
  %v142 = add i32 %v135, 2
  store i32 %v142, ptr %NEXT_PC, align 4
  %v143 = add i32 %v142, 32
  %v144 = load ptr, ptr %MEMORY, align 4
  %v145 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v144, ptr %state, ptr %BRANCH_TAKEN, i32 %v143, i32 %v142, ptr %NEXT_PC)
  store ptr %v145, ptr %MEMORY, align 4
  br i1 true, label %bb_4201175, label %bb_4201143

bb_4201143:                                       ; preds = %bb_4201114
  store i32 %v142, ptr %PC, align 4
  %v146 = add i32 %v142, 8
  store i32 %v146, ptr %NEXT_PC, align 4
  %v147 = load i32, ptr %ESP, align 4
  %v148 = load i32, ptr %SSBASE, align 4
  %v149 = add i32 %v147, 4
  %v150 = add i32 %v149, %v148
  %v151 = load ptr, ptr %MEMORY, align 4
  %v152 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v151, ptr %state, i32 %v150, i32 1)
  store ptr %v152, ptr %MEMORY, align 4
  store i32 %v146, ptr %PC, align 4
  %v153 = add i32 %v146, 7
  store i32 %v153, ptr %NEXT_PC, align 4
  %v154 = load i32, ptr %ESP, align 4
  %v155 = load i32, ptr %SSBASE, align 4
  %v156 = add i32 %v154, %v155
  %v157 = load ptr, ptr %MEMORY, align 4
  %v158 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v157, ptr %state, i32 %v156, i32 11)
  store ptr %v158, ptr %MEMORY, align 4
  store i32 %v153, ptr %PC, align 4
  %v159 = add i32 %v153, 5
  store i32 %v159, ptr %NEXT_PC, align 4
  %v160 = add i32 %v159, 27457
  %v161 = load ptr, ptr %MEMORY, align 4
  %v162 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v161, ptr %state, i64 4228620, ptr %NEXT_PC, i32 %v159, ptr %RETURN_PC)
  store ptr %v162, ptr %MEMORY, align 4
  store i32 %v159, ptr %PC, align 4
  %v163 = add i32 %v159, 7
  store i32 %v163, ptr %NEXT_PC, align 4
  %v164 = load i32, ptr %EBP, align 4
  %v165 = load i32, ptr %SSBASE, align 4
  %v166 = sub i32 %v164, 12
  %v167 = add i32 %v166, %v165
  %v168 = load ptr, ptr %MEMORY, align 4
  %v169 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v168, ptr %state, i32 %v167, i32 -1)
  store ptr %v169, ptr %MEMORY, align 4
  store i32 %v163, ptr %PC, align 4
  %v170 = add i32 %v163, 5
  store i32 %v170, ptr %NEXT_PC, align 4
  %v171 = add i32 %v170, 231
  %v172 = load ptr, ptr %MEMORY, align 4
  %v173 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v172, ptr %state, i32 %v171, ptr %NEXT_PC)
  store ptr %v173, ptr %MEMORY, align 4
  br label %bb_4201406

bb_4201175:                                       ; preds = %bb_4201114
  store i32 %v142, ptr %PC, align 4
  %v174 = add i32 %v142, 4
  store i32 %v174, ptr %NEXT_PC, align 4
  %v175 = load i32, ptr %EBP, align 4
  %v176 = load i32, ptr %SSBASE, align 4
  %v177 = sub i32 %v175, 20
  %v178 = add i32 %v177, %v176
  %v179 = load ptr, ptr %MEMORY, align 4
  %v180 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v179, ptr %state, i32 %v178, i32 0)
  store ptr %v180, ptr %MEMORY, align 4
  store i32 %v174, ptr %PC, align 4
  %v181 = add i32 %v174, 6
  store i32 %v181, ptr %NEXT_PC, align 4
  %v182 = add i32 %v181, 221
  %v183 = load ptr, ptr %MEMORY, align 4
  %v184 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v183, ptr %state, ptr %BRANCH_TAKEN, i32 %v182, i32 %v181, ptr %NEXT_PC)
  store ptr %v184, ptr %MEMORY, align 4
  br i1 true, label %bb_4201406, label %bb_4201185

bb_4201185:                                       ; preds = %bb_4201175
  store i32 %v181, ptr %PC, align 4
  %v185 = add i32 %v181, 7
  store i32 %v185, ptr %NEXT_PC, align 4
  %v186 = load i32, ptr %ESP, align 4
  %v187 = load i32, ptr %SSBASE, align 4
  %v188 = add i32 %v186, %v187
  %v189 = load ptr, ptr %MEMORY, align 4
  %v190 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v189, ptr %state, i32 %v188, i32 11)
  store ptr %v190, ptr %MEMORY, align 4
  store i32 %v185, ptr %PC, align 4
  %v191 = add i32 %v185, 3
  store i32 %v191, ptr %NEXT_PC, align 4
  %v192 = load i32, ptr %EBP, align 4
  %v193 = load i32, ptr %SSBASE, align 4
  %v194 = sub i32 %v192, 20
  %v195 = add i32 %v194, %v193
  %v196 = load ptr, ptr %MEMORY, align 4
  %v197 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v196, ptr %state, ptr %EAX, i32 %v195)
  store ptr %v197, ptr %MEMORY, align 4
  store i32 %v191, ptr %PC, align 4
  %v198 = add i32 %v191, 2
  store i32 %v198, ptr %NEXT_PC, align 4
  %v199 = load i32, ptr %EAX, align 4
  %v200 = load ptr, ptr %MEMORY, align 4
  %v201 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v200, ptr %state, i32 %v199, ptr %NEXT_PC, i32 %v198, ptr %RETURN_PC)
  store ptr %v201, ptr %MEMORY, align 4
  store i32 %v198, ptr %PC, align 4
  %v202 = add i32 %v198, 7
  store i32 %v202, ptr %NEXT_PC, align 4
  %v203 = load i32, ptr %EBP, align 4
  %v204 = load i32, ptr %SSBASE, align 4
  %v205 = sub i32 %v203, 12
  %v206 = add i32 %v205, %v204
  %v207 = load ptr, ptr %MEMORY, align 4
  %v208 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v207, ptr %state, i32 %v206, i32 -1)
  store ptr %v208, ptr %MEMORY, align 4
  store i32 %v202, ptr %PC, align 4
  %v209 = add i32 %v202, 5
  store i32 %v209, ptr %NEXT_PC, align 4
  %v210 = add i32 %v209, 197
  %v211 = load ptr, ptr %MEMORY, align 4
  %v212 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v211, ptr %state, i32 %v210, ptr %NEXT_PC)
  store ptr %v212, ptr %MEMORY, align 4
  br label %bb_4201406

bb_4201209:                                       ; preds = %bb_4201091, %bb_4201064
  %v213 = load i32, ptr %NEXT_PC, align 4
  store i32 %v213, ptr %PC, align 4
  %v214 = add i32 %v213, 8
  store i32 %v214, ptr %NEXT_PC, align 4
  %v215 = load i32, ptr %ESP, align 4
  %v216 = load i32, ptr %SSBASE, align 4
  %v217 = add i32 %v215, 4
  %v218 = add i32 %v217, %v216
  %v219 = load ptr, ptr %MEMORY, align 4
  %v220 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v219, ptr %state, i32 %v218, i32 0)
  store ptr %v220, ptr %MEMORY, align 4
  store i32 %v214, ptr %PC, align 4
  %v221 = add i32 %v214, 7
  store i32 %v221, ptr %NEXT_PC, align 4
  %v222 = load i32, ptr %ESP, align 4
  %v223 = load i32, ptr %SSBASE, align 4
  %v224 = add i32 %v222, %v223
  %v225 = load ptr, ptr %MEMORY, align 4
  %v226 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v225, ptr %state, i32 %v224, i32 4)
  store ptr %v226, ptr %MEMORY, align 4
  store i32 %v221, ptr %PC, align 4
  %v227 = add i32 %v221, 5
  store i32 %v227, ptr %NEXT_PC, align 4
  %v228 = add i32 %v227, 27391
  %v229 = load ptr, ptr %MEMORY, align 4
  %v230 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v229, ptr %state, i64 4228620, ptr %NEXT_PC, i32 %v227, ptr %RETURN_PC)
  store ptr %v230, ptr %MEMORY, align 4
  store i32 %v227, ptr %PC, align 4
  %v231 = add i32 %v227, 3
  store i32 %v231, ptr %NEXT_PC, align 4
  %v232 = load i32, ptr %EBP, align 4
  %v233 = load i32, ptr %SSBASE, align 4
  %v234 = sub i32 %v232, 20
  %v235 = add i32 %v234, %v233
  %v236 = load i32, ptr %EAX, align 4
  %v237 = load ptr, ptr %MEMORY, align 4
  %v238 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v237, ptr %state, i32 %v235, i32 %v236)
  store ptr %v238, ptr %MEMORY, align 4
  store i32 %v231, ptr %PC, align 4
  %v239 = add i32 %v231, 4
  store i32 %v239, ptr %NEXT_PC, align 4
  %v240 = load i32, ptr %EBP, align 4
  %v241 = load i32, ptr %SSBASE, align 4
  %v242 = sub i32 %v240, 20
  %v243 = add i32 %v242, %v241
  %v244 = load ptr, ptr %MEMORY, align 4
  %v245 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v244, ptr %state, i32 %v243, i32 1)
  store ptr %v245, ptr %MEMORY, align 4
  store i32 %v239, ptr %PC, align 4
  %v246 = add i32 %v239, 2
  store i32 %v246, ptr %NEXT_PC, align 4
  %v247 = add i32 %v246, 32
  %v248 = load ptr, ptr %MEMORY, align 4
  %v249 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v248, ptr %state, ptr %BRANCH_TAKEN, i32 %v247, i32 %v246, ptr %NEXT_PC)
  store ptr %v249, ptr %MEMORY, align 4
  br i1 true, label %bb_4201270, label %bb_4201238

bb_4201238:                                       ; preds = %bb_4201209
  store i32 %v246, ptr %PC, align 4
  %v250 = add i32 %v246, 8
  store i32 %v250, ptr %NEXT_PC, align 4
  %v251 = load i32, ptr %ESP, align 4
  %v252 = load i32, ptr %SSBASE, align 4
  %v253 = add i32 %v251, 4
  %v254 = add i32 %v253, %v252
  %v255 = load ptr, ptr %MEMORY, align 4
  %v256 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v255, ptr %state, i32 %v254, i32 1)
  store ptr %v256, ptr %MEMORY, align 4
  store i32 %v250, ptr %PC, align 4
  %v257 = add i32 %v250, 7
  store i32 %v257, ptr %NEXT_PC, align 4
  %v258 = load i32, ptr %ESP, align 4
  %v259 = load i32, ptr %SSBASE, align 4
  %v260 = add i32 %v258, %v259
  %v261 = load ptr, ptr %MEMORY, align 4
  %v262 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v261, ptr %state, i32 %v260, i32 4)
  store ptr %v262, ptr %MEMORY, align 4
  store i32 %v257, ptr %PC, align 4
  %v263 = add i32 %v257, 5
  store i32 %v263, ptr %NEXT_PC, align 4
  %v264 = add i32 %v263, 27362
  %v265 = load ptr, ptr %MEMORY, align 4
  %v266 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v265, ptr %state, i64 4228620, ptr %NEXT_PC, i32 %v263, ptr %RETURN_PC)
  store ptr %v266, ptr %MEMORY, align 4
  store i32 %v263, ptr %PC, align 4
  %v267 = add i32 %v263, 7
  store i32 %v267, ptr %NEXT_PC, align 4
  %v268 = load i32, ptr %EBP, align 4
  %v269 = load i32, ptr %SSBASE, align 4
  %v270 = sub i32 %v268, 12
  %v271 = add i32 %v270, %v269
  %v272 = load ptr, ptr %MEMORY, align 4
  %v273 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v272, ptr %state, i32 %v271, i32 -1)
  store ptr %v273, ptr %MEMORY, align 4
  store i32 %v267, ptr %PC, align 4
  %v274 = add i32 %v267, 5
  store i32 %v274, ptr %NEXT_PC, align 4
  %v275 = add i32 %v274, 139
  %v276 = load ptr, ptr %MEMORY, align 4
  %v277 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v276, ptr %state, i32 %v275, ptr %NEXT_PC)
  store ptr %v277, ptr %MEMORY, align 4
  br label %bb_4201409

bb_4201270:                                       ; preds = %bb_4201209
  store i32 %v246, ptr %PC, align 4
  %v278 = add i32 %v246, 4
  store i32 %v278, ptr %NEXT_PC, align 4
  %v279 = load i32, ptr %EBP, align 4
  %v280 = load i32, ptr %SSBASE, align 4
  %v281 = sub i32 %v279, 20
  %v282 = add i32 %v281, %v280
  %v283 = load ptr, ptr %MEMORY, align 4
  %v284 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v283, ptr %state, i32 %v282, i32 0)
  store ptr %v284, ptr %MEMORY, align 4
  store i32 %v278, ptr %PC, align 4
  %v285 = add i32 %v278, 6
  store i32 %v285, ptr %NEXT_PC, align 4
  %v286 = add i32 %v285, 129
  %v287 = load ptr, ptr %MEMORY, align 4
  %v288 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v287, ptr %state, ptr %BRANCH_TAKEN, i32 %v286, i32 %v285, ptr %NEXT_PC)
  store ptr %v288, ptr %MEMORY, align 4
  br i1 true, label %bb_4201409, label %bb_4201280

bb_4201280:                                       ; preds = %bb_4201270
  store i32 %v285, ptr %PC, align 4
  %v289 = add i32 %v285, 7
  store i32 %v289, ptr %NEXT_PC, align 4
  %v290 = load i32, ptr %ESP, align 4
  %v291 = load i32, ptr %SSBASE, align 4
  %v292 = add i32 %v290, %v291
  %v293 = load ptr, ptr %MEMORY, align 4
  %v294 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v293, ptr %state, i32 %v292, i32 4)
  store ptr %v294, ptr %MEMORY, align 4
  store i32 %v289, ptr %PC, align 4
  %v295 = add i32 %v289, 3
  store i32 %v295, ptr %NEXT_PC, align 4
  %v296 = load i32, ptr %EBP, align 4
  %v297 = load i32, ptr %SSBASE, align 4
  %v298 = sub i32 %v296, 20
  %v299 = add i32 %v298, %v297
  %v300 = load ptr, ptr %MEMORY, align 4
  %v301 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v300, ptr %state, ptr %EAX, i32 %v299)
  store ptr %v301, ptr %MEMORY, align 4
  store i32 %v295, ptr %PC, align 4
  %v302 = add i32 %v295, 2
  store i32 %v302, ptr %NEXT_PC, align 4
  %v303 = load i32, ptr %EAX, align 4
  %v304 = load ptr, ptr %MEMORY, align 4
  %v305 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v304, ptr %state, i32 %v303, ptr %NEXT_PC, i32 %v302, ptr %RETURN_PC)
  store ptr %v305, ptr %MEMORY, align 4
  store i32 %v302, ptr %PC, align 4
  %v306 = add i32 %v302, 7
  store i32 %v306, ptr %NEXT_PC, align 4
  %v307 = load i32, ptr %EBP, align 4
  %v308 = load i32, ptr %SSBASE, align 4
  %v309 = sub i32 %v307, 12
  %v310 = add i32 %v309, %v308
  %v311 = load ptr, ptr %MEMORY, align 4
  %v312 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v311, ptr %state, i32 %v310, i32 -1)
  store ptr %v312, ptr %MEMORY, align 4
  store i32 %v306, ptr %PC, align 4
  %v313 = add i32 %v306, 2
  store i32 %v313, ptr %NEXT_PC, align 4
  %v314 = add i32 %v313, 108
  %v315 = load ptr, ptr %MEMORY, align 4
  %v316 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v315, ptr %state, i32 %v314, ptr %NEXT_PC)
  store ptr %v316, ptr %MEMORY, align 4
  br label %bb_4201409

bb_4201301:                                       ; preds = %bb_4201098, %bb_4201046
  %v317 = load i32, ptr %NEXT_PC, align 4
  store i32 %v317, ptr %PC, align 4
  %v318 = add i32 %v317, 7
  store i32 %v318, ptr %NEXT_PC, align 4
  %v319 = load i32, ptr %EBP, align 4
  %v320 = load i32, ptr %SSBASE, align 4
  %v321 = sub i32 %v319, 16
  %v322 = add i32 %v321, %v320
  %v323 = load ptr, ptr %MEMORY, align 4
  %v324 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v323, ptr %state, i32 %v322, i32 1)
  store ptr %v324, ptr %MEMORY, align 4
  br label %bb_4201308

bb_4201308:                                       ; preds = %bb_4201301, %bb_4201080
  %v325 = load i32, ptr %NEXT_PC, align 4
  store i32 %v325, ptr %PC, align 4
  %v326 = add i32 %v325, 8
  store i32 %v326, ptr %NEXT_PC, align 4
  %v327 = load i32, ptr %ESP, align 4
  %v328 = load i32, ptr %SSBASE, align 4
  %v329 = add i32 %v327, 4
  %v330 = add i32 %v329, %v328
  %v331 = load ptr, ptr %MEMORY, align 4
  %v332 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v331, ptr %state, i32 %v330, i32 0)
  store ptr %v332, ptr %MEMORY, align 4
  store i32 %v326, ptr %PC, align 4
  %v333 = add i32 %v326, 7
  store i32 %v333, ptr %NEXT_PC, align 4
  %v334 = load i32, ptr %ESP, align 4
  %v335 = load i32, ptr %SSBASE, align 4
  %v336 = add i32 %v334, %v335
  %v337 = load ptr, ptr %MEMORY, align 4
  %v338 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v337, ptr %state, i32 %v336, i32 8)
  store ptr %v338, ptr %MEMORY, align 4
  store i32 %v333, ptr %PC, align 4
  %v339 = add i32 %v333, 5
  store i32 %v339, ptr %NEXT_PC, align 4
  %v340 = add i32 %v339, 27292
  %v341 = load ptr, ptr %MEMORY, align 4
  %v342 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v341, ptr %state, i64 4228620, ptr %NEXT_PC, i32 %v339, ptr %RETURN_PC)
  store ptr %v342, ptr %MEMORY, align 4
  store i32 %v339, ptr %PC, align 4
  %v343 = add i32 %v339, 3
  store i32 %v343, ptr %NEXT_PC, align 4
  %v344 = load i32, ptr %EBP, align 4
  %v345 = load i32, ptr %SSBASE, align 4
  %v346 = sub i32 %v344, 20
  %v347 = add i32 %v346, %v345
  %v348 = load i32, ptr %EAX, align 4
  %v349 = load ptr, ptr %MEMORY, align 4
  %v350 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v349, ptr %state, i32 %v347, i32 %v348)
  store ptr %v350, ptr %MEMORY, align 4
  store i32 %v343, ptr %PC, align 4
  %v351 = add i32 %v343, 4
  store i32 %v351, ptr %NEXT_PC, align 4
  %v352 = load i32, ptr %EBP, align 4
  %v353 = load i32, ptr %SSBASE, align 4
  %v354 = sub i32 %v352, 20
  %v355 = add i32 %v354, %v353
  %v356 = load ptr, ptr %MEMORY, align 4
  %v357 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v356, ptr %state, i32 %v355, i32 1)
  store ptr %v357, ptr %MEMORY, align 4
  store i32 %v351, ptr %PC, align 4
  %v358 = add i32 %v351, 2
  store i32 %v358, ptr %NEXT_PC, align 4
  %v359 = add i32 %v358, 40
  %v360 = load ptr, ptr %MEMORY, align 4
  %v361 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v360, ptr %state, ptr %BRANCH_TAKEN, i32 %v359, i32 %v358, ptr %NEXT_PC)
  store ptr %v361, ptr %MEMORY, align 4
  br i1 true, label %bb_4201377, label %bb_4201337

bb_4201337:                                       ; preds = %bb_4201308
  store i32 %v358, ptr %PC, align 4
  %v362 = add i32 %v358, 8
  store i32 %v362, ptr %NEXT_PC, align 4
  %v363 = load i32, ptr %ESP, align 4
  %v364 = load i32, ptr %SSBASE, align 4
  %v365 = add i32 %v363, 4
  %v366 = add i32 %v365, %v364
  %v367 = load ptr, ptr %MEMORY, align 4
  %v368 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v367, ptr %state, i32 %v366, i32 1)
  store ptr %v368, ptr %MEMORY, align 4
  store i32 %v362, ptr %PC, align 4
  %v369 = add i32 %v362, 7
  store i32 %v369, ptr %NEXT_PC, align 4
  %v370 = load i32, ptr %ESP, align 4
  %v371 = load i32, ptr %SSBASE, align 4
  %v372 = add i32 %v370, %v371
  %v373 = load ptr, ptr %MEMORY, align 4
  %v374 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v373, ptr %state, i32 %v372, i32 8)
  store ptr %v374, ptr %MEMORY, align 4
  store i32 %v369, ptr %PC, align 4
  %v375 = add i32 %v369, 5
  store i32 %v375, ptr %NEXT_PC, align 4
  %v376 = add i32 %v375, 27263
  %v377 = load ptr, ptr %MEMORY, align 4
  %v378 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v377, ptr %state, i64 4228620, ptr %NEXT_PC, i32 %v375, ptr %RETURN_PC)
  store ptr %v378, ptr %MEMORY, align 4
  store i32 %v375, ptr %PC, align 4
  %v379 = add i32 %v375, 4
  store i32 %v379, ptr %NEXT_PC, align 4
  %v380 = load i32, ptr %EBP, align 4
  %v381 = load i32, ptr %SSBASE, align 4
  %v382 = sub i32 %v380, 16
  %v383 = add i32 %v382, %v381
  %v384 = load ptr, ptr %MEMORY, align 4
  %v385 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v384, ptr %state, i32 %v383, i32 0)
  store ptr %v385, ptr %MEMORY, align 4
  store i32 %v379, ptr %PC, align 4
  %v386 = add i32 %v379, 2
  store i32 %v386, ptr %NEXT_PC, align 4
  %v387 = add i32 %v386, 5
  %v388 = load ptr, ptr %MEMORY, align 4
  %v389 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v388, ptr %state, ptr %BRANCH_TAKEN, i32 %v387, i32 %v386, ptr %NEXT_PC)
  store ptr %v389, ptr %MEMORY, align 4
  br i1 true, label %bb_4201368, label %bb_4201363

bb_4201363:                                       ; preds = %bb_4201337
  store i32 %v386, ptr %PC, align 4
  %v390 = add i32 %v386, 5
  store i32 %v390, ptr %NEXT_PC, align 4
  %v391 = add i32 %v390, 2504
  %v392 = load ptr, ptr %MEMORY, align 4
  %v393 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v392, ptr %state, i64 4203872, ptr %NEXT_PC, i32 %v390, ptr %RETURN_PC)
  store ptr %v393, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201368:                                       ; preds = %bb_4201337
  store i32 %v386, ptr %PC, align 4
  %v394 = add i32 %v386, 7
  store i32 %v394, ptr %NEXT_PC, align 4
  %v395 = load i32, ptr %EBP, align 4
  %v396 = load i32, ptr %SSBASE, align 4
  %v397 = sub i32 %v395, 12
  %v398 = add i32 %v397, %v396
  %v399 = load ptr, ptr %MEMORY, align 4
  %v400 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v399, ptr %state, i32 %v398, i32 -1)
  store ptr %v400, ptr %MEMORY, align 4
  store i32 %v394, ptr %PC, align 4
  %v401 = add i32 %v394, 2
  store i32 %v401, ptr %NEXT_PC, align 4
  %v402 = add i32 %v401, 35
  %v403 = load ptr, ptr %MEMORY, align 4
  %v404 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v403, ptr %state, i32 %v402, ptr %NEXT_PC)
  store ptr %v404, ptr %MEMORY, align 4
  br label %bb_4201412

bb_4201377:                                       ; preds = %bb_4201308
  store i32 %v358, ptr %PC, align 4
  %v405 = add i32 %v358, 4
  store i32 %v405, ptr %NEXT_PC, align 4
  %v406 = load i32, ptr %EBP, align 4
  %v407 = load i32, ptr %SSBASE, align 4
  %v408 = sub i32 %v406, 20
  %v409 = add i32 %v408, %v407
  %v410 = load ptr, ptr %MEMORY, align 4
  %v411 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v410, ptr %state, i32 %v409, i32 0)
  store ptr %v411, ptr %MEMORY, align 4
  store i32 %v405, ptr %PC, align 4
  %v412 = add i32 %v405, 2
  store i32 %v412, ptr %NEXT_PC, align 4
  %v413 = add i32 %v412, 29
  %v414 = load ptr, ptr %MEMORY, align 4
  %v415 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v414, ptr %state, ptr %BRANCH_TAKEN, i32 %v413, i32 %v412, ptr %NEXT_PC)
  store ptr %v415, ptr %MEMORY, align 4
  br i1 true, label %bb_4201412, label %bb_4201383

bb_4201383:                                       ; preds = %bb_4201377
  store i32 %v412, ptr %PC, align 4
  %v416 = add i32 %v412, 7
  store i32 %v416, ptr %NEXT_PC, align 4
  %v417 = load i32, ptr %ESP, align 4
  %v418 = load i32, ptr %SSBASE, align 4
  %v419 = add i32 %v417, %v418
  %v420 = load ptr, ptr %MEMORY, align 4
  %v421 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v420, ptr %state, i32 %v419, i32 8)
  store ptr %v421, ptr %MEMORY, align 4
  store i32 %v416, ptr %PC, align 4
  %v422 = add i32 %v416, 3
  store i32 %v422, ptr %NEXT_PC, align 4
  %v423 = load i32, ptr %EBP, align 4
  %v424 = load i32, ptr %SSBASE, align 4
  %v425 = sub i32 %v423, 20
  %v426 = add i32 %v425, %v424
  %v427 = load ptr, ptr %MEMORY, align 4
  %v428 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v427, ptr %state, ptr %EAX, i32 %v426)
  store ptr %v428, ptr %MEMORY, align 4
  store i32 %v422, ptr %PC, align 4
  %v429 = add i32 %v422, 2
  store i32 %v429, ptr %NEXT_PC, align 4
  %v430 = load i32, ptr %EAX, align 4
  %v431 = load ptr, ptr %MEMORY, align 4
  %v432 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v431, ptr %state, i32 %v430, ptr %NEXT_PC, i32 %v429, ptr %RETURN_PC)
  store ptr %v432, ptr %MEMORY, align 4
  store i32 %v429, ptr %PC, align 4
  %v433 = add i32 %v429, 7
  store i32 %v433, ptr %NEXT_PC, align 4
  %v434 = load i32, ptr %EBP, align 4
  %v435 = load i32, ptr %SSBASE, align 4
  %v436 = sub i32 %v434, 12
  %v437 = add i32 %v436, %v435
  %v438 = load ptr, ptr %MEMORY, align 4
  %v439 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v438, ptr %state, i32 %v437, i32 -1)
  store ptr %v439, ptr %MEMORY, align 4
  store i32 %v433, ptr %PC, align 4
  %v440 = add i32 %v433, 2
  store i32 %v440, ptr %NEXT_PC, align 4
  %v441 = add i32 %v440, 8
  %v442 = load ptr, ptr %MEMORY, align 4
  %v443 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v442, ptr %state, i32 %v441, ptr %NEXT_PC)
  store ptr %v443, ptr %MEMORY, align 4
  br label %bb_4201412

bb_4201404:                                       ; preds = %bb_4201109, %bb_4201075
  %v444 = load i32, ptr %NEXT_PC, align 4
  store i32 %v444, ptr %PC, align 4
  %v445 = add i32 %v444, 2
  store i32 %v445, ptr %NEXT_PC, align 4
  %v446 = add i32 %v445, 7
  %v447 = load ptr, ptr %MEMORY, align 4
  %v448 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v447, ptr %state, i32 %v446, ptr %NEXT_PC)
  store ptr %v448, ptr %MEMORY, align 4
  br label %bb_4201413

bb_4201406:                                       ; preds = %bb_4201185, %bb_4201175, %bb_4201143
  %v449 = load i32, ptr %NEXT_PC, align 4
  store i32 %v449, ptr %PC, align 4
  %v450 = add i32 %v449, 1
  store i32 %v450, ptr %NEXT_PC, align 4
  %v451 = load ptr, ptr %MEMORY, align 4
  %v452 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v451, ptr %state)
  store ptr %v452, ptr %MEMORY, align 4
  store i32 %v450, ptr %PC, align 4
  %v453 = add i32 %v450, 2
  store i32 %v453, ptr %NEXT_PC, align 4
  %v454 = add i32 %v453, 4
  %v455 = load ptr, ptr %MEMORY, align 4
  %v456 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v455, ptr %state, i32 %v454, ptr %NEXT_PC)
  store ptr %v456, ptr %MEMORY, align 4
  br label %bb_4201413

bb_4201409:                                       ; preds = %bb_4201280, %bb_4201270, %bb_4201238
  %v457 = load i32, ptr %NEXT_PC, align 4
  store i32 %v457, ptr %PC, align 4
  %v458 = add i32 %v457, 1
  store i32 %v458, ptr %NEXT_PC, align 4
  %v459 = load ptr, ptr %MEMORY, align 4
  %v460 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v459, ptr %state)
  store ptr %v460, ptr %MEMORY, align 4
  store i32 %v458, ptr %PC, align 4
  %v461 = add i32 %v458, 2
  store i32 %v461, ptr %NEXT_PC, align 4
  %v462 = add i32 %v461, 1
  %v463 = load ptr, ptr %MEMORY, align 4
  %v464 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v463, ptr %state, i32 %v462, ptr %NEXT_PC)
  store ptr %v464, ptr %MEMORY, align 4
  br label %bb_4201413

bb_4201412:                                       ; preds = %bb_4201383, %bb_4201377, %bb_4201368
  %v465 = load i32, ptr %NEXT_PC, align 4
  store i32 %v465, ptr %PC, align 4
  %v466 = add i32 %v465, 1
  store i32 %v466, ptr %NEXT_PC, align 4
  %v467 = load ptr, ptr %MEMORY, align 4
  %v468 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v467, ptr %state)
  store ptr %v468, ptr %MEMORY, align 4
  br label %bb_4201413

bb_4201413:                                       ; preds = %bb_4201412, %bb_4201409, %bb_4201406, %bb_4201404
  %v469 = load i32, ptr %NEXT_PC, align 4
  store i32 %v469, ptr %PC, align 4
  %v470 = add i32 %v469, 4
  store i32 %v470, ptr %NEXT_PC, align 4
  %v471 = load i32, ptr %EBP, align 4
  %v472 = load i32, ptr %SSBASE, align 4
  %v473 = sub i32 %v471, 12
  %v474 = add i32 %v473, %v472
  %v475 = load ptr, ptr %MEMORY, align 4
  %v476 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v475, ptr %state, i32 %v474, i32 0)
  store ptr %v476, ptr %MEMORY, align 4
  store i32 %v470, ptr %PC, align 4
  %v477 = add i32 %v470, 2
  store i32 %v477, ptr %NEXT_PC, align 4
  %v478 = add i32 %v477, 29
  %v479 = load ptr, ptr %MEMORY, align 4
  %v480 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v479, ptr %state, ptr %BRANCH_TAKEN, i32 %v478, i32 %v477, ptr %NEXT_PC)
  store ptr %v480, ptr %MEMORY, align 4
  br i1 true, label %bb_4201448, label %bb_4201419

bb_4201419:                                       ; preds = %bb_4201413
  store i32 %v477, ptr %PC, align 4
  %v481 = add i32 %v477, 5
  store i32 %v481, ptr %NEXT_PC, align 4
  %v482 = load i32, ptr %DSBASE, align 4
  %v483 = add i32 4239428, %v482
  %v484 = load ptr, ptr %MEMORY, align 4
  %v485 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v484, ptr %state, ptr %EAX, i32 %v483)
  store ptr %v485, ptr %MEMORY, align 4
  store i32 %v481, ptr %PC, align 4
  %v486 = add i32 %v481, 2
  store i32 %v486, ptr %NEXT_PC, align 4
  %v487 = load i32, ptr %EAX, align 4
  %v488 = load i32, ptr %EAX, align 4
  %v489 = load ptr, ptr %MEMORY, align 4
  %v490 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v489, ptr %state, i32 %v487, i32 %v488)
  store ptr %v490, ptr %MEMORY, align 4
  store i32 %v486, ptr %PC, align 4
  %v491 = add i32 %v486, 2
  store i32 %v491, ptr %NEXT_PC, align 4
  %v492 = add i32 %v491, 20
  %v493 = load ptr, ptr %MEMORY, align 4
  %v494 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v493, ptr %state, ptr %BRANCH_TAKEN, i32 %v492, i32 %v491, ptr %NEXT_PC)
  store ptr %v494, ptr %MEMORY, align 4
  br i1 true, label %bb_4201448, label %bb_4201428

bb_4201428:                                       ; preds = %bb_4201419
  store i32 %v491, ptr %PC, align 4
  %v495 = add i32 %v491, 6
  store i32 %v495, ptr %NEXT_PC, align 4
  %v496 = load i32, ptr %DSBASE, align 4
  %v497 = add i32 4239428, %v496
  %v498 = load ptr, ptr %MEMORY, align 4
  %v499 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v498, ptr %state, ptr %EDX, i32 %v497)
  store ptr %v499, ptr %MEMORY, align 4
  store i32 %v495, ptr %PC, align 4
  %v500 = add i32 %v495, 3
  store i32 %v500, ptr %NEXT_PC, align 4
  %v501 = load i32, ptr %EBP, align 4
  %v502 = load i32, ptr %SSBASE, align 4
  %v503 = add i32 %v501, 8
  %v504 = add i32 %v503, %v502
  %v505 = load ptr, ptr %MEMORY, align 4
  %v506 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v505, ptr %state, ptr %EAX, i32 %v504)
  store ptr %v506, ptr %MEMORY, align 4
  store i32 %v500, ptr %PC, align 4
  %v507 = add i32 %v500, 3
  store i32 %v507, ptr %NEXT_PC, align 4
  %v508 = load i32, ptr %ESP, align 4
  %v509 = load i32, ptr %SSBASE, align 4
  %v510 = add i32 %v508, %v509
  %v511 = load i32, ptr %EAX, align 4
  %v512 = load ptr, ptr %MEMORY, align 4
  %v513 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v512, ptr %state, i32 %v510, i32 %v511)
  store ptr %v513, ptr %MEMORY, align 4
  store i32 %v507, ptr %PC, align 4
  %v514 = add i32 %v507, 2
  store i32 %v514, ptr %NEXT_PC, align 4
  %v515 = load i32, ptr %EDX, align 4
  %v516 = load ptr, ptr %MEMORY, align 4
  %v517 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v516, ptr %state, i32 %v515, ptr %NEXT_PC, i32 %v514, ptr %RETURN_PC)
  store ptr %v517, ptr %MEMORY, align 4
  store i32 %v514, ptr %PC, align 4
  %v518 = add i32 %v514, 3
  store i32 %v518, ptr %NEXT_PC, align 4
  %v519 = load i32, ptr %ESP, align 4
  %v520 = load ptr, ptr %MEMORY, align 4
  %v521 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v520, ptr %state, ptr %ESP, i32 %v519, i32 4)
  store ptr %v521, ptr %MEMORY, align 4
  store i32 %v518, ptr %PC, align 4
  %v522 = add i32 %v518, 3
  store i32 %v522, ptr %NEXT_PC, align 4
  %v523 = load i32, ptr %EBP, align 4
  %v524 = load i32, ptr %SSBASE, align 4
  %v525 = sub i32 %v523, 12
  %v526 = add i32 %v525, %v524
  %v527 = load i32, ptr %EAX, align 4
  %v528 = load ptr, ptr %MEMORY, align 4
  %v529 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v528, ptr %state, i32 %v526, i32 %v527)
  store ptr %v529, ptr %MEMORY, align 4
  br label %bb_4201448

bb_4201448:                                       ; preds = %bb_4201428, %bb_4201419, %bb_4201413
  %v530 = load i32, ptr %NEXT_PC, align 4
  store i32 %v530, ptr %PC, align 4
  %v531 = add i32 %v530, 3
  store i32 %v531, ptr %NEXT_PC, align 4
  %v532 = load i32, ptr %EBP, align 4
  %v533 = load i32, ptr %SSBASE, align 4
  %v534 = sub i32 %v532, 12
  %v535 = add i32 %v534, %v533
  %v536 = load ptr, ptr %MEMORY, align 4
  %v537 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v536, ptr %state, ptr %EAX, i32 %v535)
  store ptr %v537, ptr %MEMORY, align 4
  store i32 %v531, ptr %PC, align 4
  %v538 = add i32 %v531, 1
  store i32 %v538, ptr %NEXT_PC, align 4
  %v539 = load ptr, ptr %MEMORY, align 4
  %v540 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v539, ptr %state)
  store ptr %v540, ptr %MEMORY, align 4
  store i32 %v538, ptr %PC, align 4
  %v541 = add i32 %v538, 3
  store i32 %v541, ptr %NEXT_PC, align 4
  %v542 = load ptr, ptr %MEMORY, align 4
  %v543 = call ptr @_ZN12_GLOBAL__N_17RET_IMMEP6MemoryR5State2InItE3RnWIjE(ptr %v542, ptr %state, i32 4, ptr %NEXT_PC)
  store ptr %v543, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201455:                                       ; No predecessors!
  %v544 = load i32, ptr %NEXT_PC, align 4
  store i32 %v544, ptr %PC, align 4
  %v545 = add i32 %v544, 1
  store i32 %v545, ptr %NEXT_PC, align 4
  %v546 = load ptr, ptr %MEMORY, align 4
  %v547 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v546, ptr %state)
  store ptr %v547, ptr %MEMORY, align 4
  store i32 %v545, ptr %PC, align 4
  %v548 = add i32 %v545, 1
  store i32 %v548, ptr %NEXT_PC, align 4
  %v549 = load i32, ptr %EBP, align 4
  %v550 = load ptr, ptr %MEMORY, align 4
  %v551 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v550, ptr %state, i32 %v549)
  store ptr %v551, ptr %MEMORY, align 4
  store i32 %v548, ptr %PC, align 4
  %v552 = add i32 %v548, 2
  store i32 %v552, ptr %NEXT_PC, align 4
  %v553 = load i32, ptr %ESP, align 4
  %v554 = load ptr, ptr %MEMORY, align 4
  %v555 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v554, ptr %state, ptr %EBP, i32 %v553)
  store ptr %v555, ptr %MEMORY, align 4
  store i32 %v552, ptr %PC, align 4
  %v556 = add i32 %v552, 3
  store i32 %v556, ptr %NEXT_PC, align 4
  %v557 = load i32, ptr %ESP, align 4
  %v558 = load ptr, ptr %MEMORY, align 4
  %v559 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v558, ptr %state, ptr %ESP, i32 %v557, i32 8)
  store ptr %v559, ptr %MEMORY, align 4
  store i32 %v556, ptr %PC, align 4
  %v560 = add i32 %v556, 5
  store i32 %v560, ptr %NEXT_PC, align 4
  %v561 = load i32, ptr %DSBASE, align 4
  %v562 = add i32 4243908, %v561
  %v563 = load ptr, ptr %MEMORY, align 4
  %v564 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v563, ptr %state, ptr %EAX, i32 %v562)
  store ptr %v564, ptr %MEMORY, align 4
  store i32 %v560, ptr %PC, align 4
  %v565 = add i32 %v560, 2
  store i32 %v565, ptr %NEXT_PC, align 4
  %v566 = load i32, ptr %EAX, align 4
  %v567 = load ptr, ptr %MEMORY, align 4
  %v568 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v567, ptr %state, i32 %v566, ptr %NEXT_PC, i32 %v565, ptr %RETURN_PC)
  store ptr %v568, ptr %MEMORY, align 4
  store i32 %v565, ptr %PC, align 4
  %v569 = add i32 %v565, 1
  store i32 %v569, ptr %NEXT_PC, align 4
  %v570 = load ptr, ptr %MEMORY, align 4
  %v571 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v570, ptr %state)
  store ptr %v571, ptr %MEMORY, align 4
  store i32 %v569, ptr %PC, align 4
  %v572 = add i32 %v569, 1
  store i32 %v572, ptr %NEXT_PC, align 4
  %v573 = load ptr, ptr %MEMORY, align 4
  %v574 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v573, ptr %state, ptr %NEXT_PC)
  store ptr %v574, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201471:                                       ; No predecessors!
  %v575 = load i32, ptr %NEXT_PC, align 4
  store i32 %v575, ptr %PC, align 4
  %v576 = add i32 %v575, 1
  store i32 %v576, ptr %NEXT_PC, align 4
  %v577 = load ptr, ptr %MEMORY, align 4
  %v578 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v577, ptr %state)
  store ptr %v578, ptr %MEMORY, align 4
  store i32 %v576, ptr %PC, align 4
  %v579 = add i32 %v576, 1
  store i32 %v579, ptr %NEXT_PC, align 4
  %v580 = load i32, ptr %EBP, align 4
  %v581 = load ptr, ptr %MEMORY, align 4
  %v582 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v581, ptr %state, i32 %v580)
  store ptr %v582, ptr %MEMORY, align 4
  store i32 %v579, ptr %PC, align 4
  %v583 = add i32 %v579, 2
  store i32 %v583, ptr %NEXT_PC, align 4
  %v584 = load i32, ptr %ESP, align 4
  %v585 = load ptr, ptr %MEMORY, align 4
  %v586 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v585, ptr %state, ptr %EBP, i32 %v584)
  store ptr %v586, ptr %MEMORY, align 4
  store i32 %v583, ptr %PC, align 4
  %v587 = add i32 %v583, 3
  store i32 %v587, ptr %NEXT_PC, align 4
  %v588 = load i32, ptr %ESP, align 4
  %v589 = load ptr, ptr %MEMORY, align 4
  %v590 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v589, ptr %state, ptr %ESP, i32 %v588, i32 88)
  store ptr %v590, ptr %MEMORY, align 4
  store i32 %v587, ptr %PC, align 4
  %v591 = add i32 %v587, 3
  store i32 %v591, ptr %NEXT_PC, align 4
  %v592 = load i32, ptr %EBP, align 4
  %v593 = load i32, ptr %SSBASE, align 4
  %v594 = add i32 %v592, 16
  %v595 = add i32 %v594, %v593
  %v596 = load ptr, ptr %MEMORY, align 4
  %v597 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v596, ptr %state, ptr %EAX, i32 %v595)
  store ptr %v597, ptr %MEMORY, align 4
  store i32 %v591, ptr %PC, align 4
  %v598 = add i32 %v591, 3
  store i32 %v598, ptr %NEXT_PC, align 4
  %v599 = load i32, ptr %EBP, align 4
  %v600 = load i32, ptr %SSBASE, align 4
  %v601 = sub i32 %v599, 48
  %v602 = add i32 %v601, %v600
  %v603 = load i32, ptr %EAX, align 4
  %v604 = load ptr, ptr %MEMORY, align 4
  %v605 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v604, ptr %state, i32 %v602, i32 %v603)
  store ptr %v605, ptr %MEMORY, align 4
  store i32 %v598, ptr %PC, align 4
  %v606 = add i32 %v598, 3
  store i32 %v606, ptr %NEXT_PC, align 4
  %v607 = load i32, ptr %EBP, align 4
  %v608 = load i32, ptr %SSBASE, align 4
  %v609 = add i32 %v607, 20
  %v610 = add i32 %v609, %v608
  %v611 = load ptr, ptr %MEMORY, align 4
  %v612 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v611, ptr %state, ptr %EAX, i32 %v610)
  store ptr %v612, ptr %MEMORY, align 4
  store i32 %v606, ptr %PC, align 4
  %v613 = add i32 %v606, 3
  store i32 %v613, ptr %NEXT_PC, align 4
  %v614 = load i32, ptr %EBP, align 4
  %v615 = load i32, ptr %SSBASE, align 4
  %v616 = sub i32 %v614, 44
  %v617 = add i32 %v616, %v615
  %v618 = load i32, ptr %EAX, align 4
  %v619 = load ptr, ptr %MEMORY, align 4
  %v620 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v619, ptr %state, i32 %v617, i32 %v618)
  store ptr %v620, ptr %MEMORY, align 4
  store i32 %v613, ptr %PC, align 4
  %v621 = add i32 %v613, 3
  store i32 %v621, ptr %NEXT_PC, align 4
  %v622 = load i32, ptr %EBP, align 4
  %v623 = load i32, ptr %SSBASE, align 4
  %v624 = add i32 %v622, 24
  %v625 = add i32 %v624, %v623
  %v626 = load ptr, ptr %MEMORY, align 4
  %v627 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v626, ptr %state, ptr %EAX, i32 %v625)
  store ptr %v627, ptr %MEMORY, align 4
  store i32 %v621, ptr %PC, align 4
  %v628 = add i32 %v621, 3
  store i32 %v628, ptr %NEXT_PC, align 4
  %v629 = load i32, ptr %EBP, align 4
  %v630 = load i32, ptr %SSBASE, align 4
  %v631 = sub i32 %v629, 56
  %v632 = add i32 %v631, %v630
  %v633 = load i32, ptr %EAX, align 4
  %v634 = load ptr, ptr %MEMORY, align 4
  %v635 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v634, ptr %state, i32 %v632, i32 %v633)
  store ptr %v635, ptr %MEMORY, align 4
  store i32 %v628, ptr %PC, align 4
  %v636 = add i32 %v628, 3
  store i32 %v636, ptr %NEXT_PC, align 4
  %v637 = load i32, ptr %EBP, align 4
  %v638 = load i32, ptr %SSBASE, align 4
  %v639 = add i32 %v637, 28
  %v640 = add i32 %v639, %v638
  %v641 = load ptr, ptr %MEMORY, align 4
  %v642 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v641, ptr %state, ptr %EAX, i32 %v640)
  store ptr %v642, ptr %MEMORY, align 4
  store i32 %v636, ptr %PC, align 4
  %v643 = add i32 %v636, 3
  store i32 %v643, ptr %NEXT_PC, align 4
  %v644 = load i32, ptr %EBP, align 4
  %v645 = load i32, ptr %SSBASE, align 4
  %v646 = sub i32 %v644, 52
  %v647 = add i32 %v646, %v645
  %v648 = load i32, ptr %EAX, align 4
  %v649 = load ptr, ptr %MEMORY, align 4
  %v650 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v649, ptr %state, i32 %v647, i32 %v648)
  store ptr %v650, ptr %MEMORY, align 4
  store i32 %v643, ptr %PC, align 4
  %v651 = add i32 %v643, 3
  store i32 %v651, ptr %NEXT_PC, align 4
  %v652 = load i32, ptr %EBP, align 4
  %v653 = load i32, ptr %SSBASE, align 4
  %v654 = add i32 %v652, 32
  %v655 = add i32 %v654, %v653
  %v656 = load ptr, ptr %MEMORY, align 4
  %v657 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v656, ptr %state, ptr %EAX, i32 %v655)
  store ptr %v657, ptr %MEMORY, align 4
  store i32 %v651, ptr %PC, align 4
  %v658 = add i32 %v651, 3
  store i32 %v658, ptr %NEXT_PC, align 4
  %v659 = load i32, ptr %EBP, align 4
  %v660 = load i32, ptr %SSBASE, align 4
  %v661 = sub i32 %v659, 64
  %v662 = add i32 %v661, %v660
  %v663 = load i32, ptr %EAX, align 4
  %v664 = load ptr, ptr %MEMORY, align 4
  %v665 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v664, ptr %state, i32 %v662, i32 %v663)
  store ptr %v665, ptr %MEMORY, align 4
  store i32 %v658, ptr %PC, align 4
  %v666 = add i32 %v658, 3
  store i32 %v666, ptr %NEXT_PC, align 4
  %v667 = load i32, ptr %EBP, align 4
  %v668 = load i32, ptr %SSBASE, align 4
  %v669 = add i32 %v667, 36
  %v670 = add i32 %v669, %v668
  %v671 = load ptr, ptr %MEMORY, align 4
  %v672 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v671, ptr %state, ptr %EAX, i32 %v670)
  store ptr %v672, ptr %MEMORY, align 4
  store i32 %v666, ptr %PC, align 4
  %v673 = add i32 %v666, 3
  store i32 %v673, ptr %NEXT_PC, align 4
  %v674 = load i32, ptr %EBP, align 4
  %v675 = load i32, ptr %SSBASE, align 4
  %v676 = sub i32 %v674, 60
  %v677 = add i32 %v676, %v675
  %v678 = load i32, ptr %EAX, align 4
  %v679 = load ptr, ptr %MEMORY, align 4
  %v680 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v679, ptr %state, i32 %v677, i32 %v678)
  store ptr %v680, ptr %MEMORY, align 4
  store i32 %v673, ptr %PC, align 4
  %v681 = add i32 %v673, 5
  store i32 %v681, ptr %NEXT_PC, align 4
  %v682 = load i32, ptr %DSBASE, align 4
  %v683 = add i32 4239436, %v682
  %v684 = load ptr, ptr %MEMORY, align 4
  %v685 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v684, ptr %state, ptr %EAX, i32 %v683)
  store ptr %v685, ptr %MEMORY, align 4
  store i32 %v681, ptr %PC, align 4
  %v686 = add i32 %v681, 2
  store i32 %v686, ptr %NEXT_PC, align 4
  %v687 = load i32, ptr %EAX, align 4
  %v688 = load i32, ptr %EAX, align 4
  %v689 = load ptr, ptr %MEMORY, align 4
  %v690 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v689, ptr %state, i32 %v687, i32 %v688)
  store ptr %v690, ptr %MEMORY, align 4
  store i32 %v686, ptr %PC, align 4
  %v691 = add i32 %v686, 2
  store i32 %v691, ptr %NEXT_PC, align 4
  %v692 = add i32 %v691, 43
  %v693 = load ptr, ptr %MEMORY, align 4
  %v694 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v693, ptr %state, ptr %BRANCH_TAKEN, i32 %v692, i32 %v691, ptr %NEXT_PC)
  store ptr %v694, ptr %MEMORY, align 4
  br i1 true, label %bb_4201566, label %bb_4201523

bb_4201523:                                       ; preds = %bb_4201471
  store i32 %v691, ptr %PC, align 4
  %v695 = add i32 %v691, 3
  store i32 %v695, ptr %NEXT_PC, align 4
  %v696 = load i32, ptr %EBP, align 4
  %v697 = load i32, ptr %SSBASE, align 4
  %v698 = add i32 %v696, 8
  %v699 = add i32 %v698, %v697
  %v700 = load ptr, ptr %MEMORY, align 4
  %v701 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v700, ptr %state, ptr %EAX, i32 %v699)
  store ptr %v701, ptr %MEMORY, align 4
  store i32 %v695, ptr %PC, align 4
  %v702 = add i32 %v695, 3
  store i32 %v702, ptr %NEXT_PC, align 4
  %v703 = load i32, ptr %EBP, align 4
  %v704 = load i32, ptr %SSBASE, align 4
  %v705 = sub i32 %v703, 40
  %v706 = add i32 %v705, %v704
  %v707 = load i32, ptr %EAX, align 4
  %v708 = load ptr, ptr %MEMORY, align 4
  %v709 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v708, ptr %state, i32 %v706, i32 %v707)
  store ptr %v709, ptr %MEMORY, align 4
  store i32 %v702, ptr %PC, align 4
  %v710 = add i32 %v702, 3
  store i32 %v710, ptr %NEXT_PC, align 4
  %v711 = load i32, ptr %EBP, align 4
  %v712 = load i32, ptr %SSBASE, align 4
  %v713 = add i32 %v711, 12
  %v714 = add i32 %v713, %v712
  %v715 = load ptr, ptr %MEMORY, align 4
  %v716 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v715, ptr %state, ptr %EAX, i32 %v714)
  store ptr %v716, ptr %MEMORY, align 4
  store i32 %v710, ptr %PC, align 4
  %v717 = add i32 %v710, 3
  store i32 %v717, ptr %NEXT_PC, align 4
  %v718 = load i32, ptr %EBP, align 4
  %v719 = load i32, ptr %SSBASE, align 4
  %v720 = sub i32 %v718, 36
  %v721 = add i32 %v720, %v719
  %v722 = load i32, ptr %EAX, align 4
  %v723 = load ptr, ptr %MEMORY, align 4
  %v724 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v723, ptr %state, i32 %v721, i32 %v722)
  store ptr %v724, ptr %MEMORY, align 4
  store i32 %v717, ptr %PC, align 4
  %v725 = add i32 %v717, 3
  store i32 %v725, ptr %NEXT_PC, align 4
  %v726 = load i32, ptr %EBP, align 4
  %v727 = load i32, ptr %SSBASE, align 4
  %v728 = sub i32 %v726, 48
  %v729 = add i32 %v728, %v727
  %v730 = load i32, ptr %PC, align 4
  %v731 = load ptr, ptr %MEMORY, align 4
  %v732 = call ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr %v731, ptr %state, ptr undef, i32 %v729, i32 %v730, i32 325)
  store ptr %v732, ptr %MEMORY, align 4
  store i32 %v725, ptr %PC, align 4
  %v733 = add i32 %v725, 3
  store i32 %v733, ptr %NEXT_PC, align 4
  %v734 = load i32, ptr %EBP, align 4
  %v735 = load i32, ptr %SSBASE, align 4
  %v736 = sub i32 %v734, 32
  %v737 = add i32 %v736, %v735
  %v738 = load i32, ptr %PC, align 4
  %v739 = load ptr, ptr %MEMORY, align 4
  %v740 = call ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr %v739, ptr %state, i32 %v737, ptr %ST0, i32 %v738, i32 349)
  store ptr %v740, ptr %MEMORY, align 4
  store i32 %v733, ptr %PC, align 4
  %v741 = add i32 %v733, 3
  store i32 %v741, ptr %NEXT_PC, align 4
  %v742 = load i32, ptr %EBP, align 4
  %v743 = load i32, ptr %SSBASE, align 4
  %v744 = sub i32 %v742, 56
  %v745 = add i32 %v744, %v743
  %v746 = load i32, ptr %PC, align 4
  %v747 = load ptr, ptr %MEMORY, align 4
  %v748 = call ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr %v747, ptr %state, ptr undef, i32 %v745, i32 %v746, i32 325)
  store ptr %v748, ptr %MEMORY, align 4
  store i32 %v741, ptr %PC, align 4
  %v749 = add i32 %v741, 3
  store i32 %v749, ptr %NEXT_PC, align 4
  %v750 = load i32, ptr %EBP, align 4
  %v751 = load i32, ptr %SSBASE, align 4
  %v752 = sub i32 %v750, 24
  %v753 = add i32 %v752, %v751
  %v754 = load i32, ptr %PC, align 4
  %v755 = load ptr, ptr %MEMORY, align 4
  %v756 = call ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr %v755, ptr %state, i32 %v753, ptr %ST0, i32 %v754, i32 349)
  store ptr %v756, ptr %MEMORY, align 4
  store i32 %v749, ptr %PC, align 4
  %v757 = add i32 %v749, 3
  store i32 %v757, ptr %NEXT_PC, align 4
  %v758 = load i32, ptr %EBP, align 4
  %v759 = load i32, ptr %SSBASE, align 4
  %v760 = sub i32 %v758, 64
  %v761 = add i32 %v760, %v759
  %v762 = load i32, ptr %PC, align 4
  %v763 = load ptr, ptr %MEMORY, align 4
  %v764 = call ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr %v763, ptr %state, ptr undef, i32 %v761, i32 %v762, i32 325)
  store ptr %v764, ptr %MEMORY, align 4
  store i32 %v757, ptr %PC, align 4
  %v765 = add i32 %v757, 3
  store i32 %v765, ptr %NEXT_PC, align 4
  %v766 = load i32, ptr %EBP, align 4
  %v767 = load i32, ptr %SSBASE, align 4
  %v768 = sub i32 %v766, 16
  %v769 = add i32 %v768, %v767
  %v770 = load i32, ptr %PC, align 4
  %v771 = load ptr, ptr %MEMORY, align 4
  %v772 = call ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr %v771, ptr %state, i32 %v769, ptr %ST0, i32 %v770, i32 349)
  store ptr %v772, ptr %MEMORY, align 4
  store i32 %v765, ptr %PC, align 4
  %v773 = add i32 %v765, 5
  store i32 %v773, ptr %NEXT_PC, align 4
  %v774 = load i32, ptr %DSBASE, align 4
  %v775 = add i32 4239436, %v774
  %v776 = load ptr, ptr %MEMORY, align 4
  %v777 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v776, ptr %state, ptr %EAX, i32 %v775)
  store ptr %v777, ptr %MEMORY, align 4
  store i32 %v773, ptr %PC, align 4
  %v778 = add i32 %v773, 3
  store i32 %v778, ptr %NEXT_PC, align 4
  %v779 = load i32, ptr %EBP, align 4
  %v780 = sub i32 %v779, 40
  %v781 = load ptr, ptr %MEMORY, align 4
  %v782 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v781, ptr %state, ptr %EDX, i32 %v780)
  store ptr %v782, ptr %MEMORY, align 4
  store i32 %v778, ptr %PC, align 4
  %v783 = add i32 %v778, 3
  store i32 %v783, ptr %NEXT_PC, align 4
  %v784 = load i32, ptr %ESP, align 4
  %v785 = load i32, ptr %SSBASE, align 4
  %v786 = add i32 %v784, %v785
  %v787 = load i32, ptr %EDX, align 4
  %v788 = load ptr, ptr %MEMORY, align 4
  %v789 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v788, ptr %state, i32 %v786, i32 %v787)
  store ptr %v789, ptr %MEMORY, align 4
  store i32 %v783, ptr %PC, align 4
  %v790 = add i32 %v783, 2
  store i32 %v790, ptr %NEXT_PC, align 4
  %v791 = load i32, ptr %EAX, align 4
  %v792 = load ptr, ptr %MEMORY, align 4
  %v793 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v792, ptr %state, i32 %v791, ptr %NEXT_PC, i32 %v790, ptr %RETURN_PC)
  store ptr %v793, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201566:                                       ; preds = %bb_4201471
  store i32 %v691, ptr %PC, align 4
  %v794 = add i32 %v691, 1
  store i32 %v794, ptr %NEXT_PC, align 4
  %v795 = load ptr, ptr %MEMORY, align 4
  %v796 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v795, ptr %state)
  store ptr %v796, ptr %MEMORY, align 4
  store i32 %v794, ptr %PC, align 4
  %v797 = add i32 %v794, 1
  store i32 %v797, ptr %NEXT_PC, align 4
  %v798 = load ptr, ptr %MEMORY, align 4
  %v799 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v798, ptr %state, ptr %NEXT_PC)
  store ptr %v799, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201568:                                       ; No predecessors!
  %v800 = load i32, ptr %NEXT_PC, align 4
  store i32 %v800, ptr %PC, align 4
  %v801 = add i32 %v800, 1
  store i32 %v801, ptr %NEXT_PC, align 4
  %v802 = load i32, ptr %EBP, align 4
  %v803 = load ptr, ptr %MEMORY, align 4
  %v804 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v803, ptr %state, i32 %v802)
  store ptr %v804, ptr %MEMORY, align 4
  store i32 %v801, ptr %PC, align 4
  %v805 = add i32 %v801, 2
  store i32 %v805, ptr %NEXT_PC, align 4
  %v806 = load i32, ptr %ESP, align 4
  %v807 = load ptr, ptr %MEMORY, align 4
  %v808 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v807, ptr %state, ptr %EBP, i32 %v806)
  store ptr %v808, ptr %MEMORY, align 4
  store i32 %v805, ptr %PC, align 4
  %v809 = add i32 %v805, 3
  store i32 %v809, ptr %NEXT_PC, align 4
  %v810 = load i32, ptr %ESP, align 4
  %v811 = load ptr, ptr %MEMORY, align 4
  %v812 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v811, ptr %state, ptr %ESP, i32 %v810, i32 24)
  store ptr %v812, ptr %MEMORY, align 4
  store i32 %v809, ptr %PC, align 4
  %v813 = add i32 %v809, 3
  store i32 %v813, ptr %NEXT_PC, align 4
  %v814 = load i32, ptr %EBP, align 4
  %v815 = load i32, ptr %SSBASE, align 4
  %v816 = add i32 %v814, 8
  %v817 = add i32 %v816, %v815
  %v818 = load ptr, ptr %MEMORY, align 4
  %v819 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v818, ptr %state, ptr %EAX, i32 %v817)
  store ptr %v819, ptr %MEMORY, align 4
  store i32 %v813, ptr %PC, align 4
  %v820 = add i32 %v813, 5
  store i32 %v820, ptr %NEXT_PC, align 4
  %v821 = load i32, ptr %DSBASE, align 4
  %v822 = add i32 4239436, %v821
  %v823 = load i32, ptr %EAX, align 4
  %v824 = load ptr, ptr %MEMORY, align 4
  %v825 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v824, ptr %state, i32 %v822, i32 %v823)
  store ptr %v825, ptr %MEMORY, align 4
  store i32 %v820, ptr %PC, align 4
  %v826 = add i32 %v820, 3
  store i32 %v826, ptr %NEXT_PC, align 4
  %v827 = load i32, ptr %EBP, align 4
  %v828 = load i32, ptr %SSBASE, align 4
  %v829 = add i32 %v827, 8
  %v830 = add i32 %v829, %v828
  %v831 = load ptr, ptr %MEMORY, align 4
  %v832 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v831, ptr %state, ptr %EAX, i32 %v830)
  store ptr %v832, ptr %MEMORY, align 4
  store i32 %v826, ptr %PC, align 4
  %v833 = add i32 %v826, 3
  store i32 %v833, ptr %NEXT_PC, align 4
  %v834 = load i32, ptr %ESP, align 4
  %v835 = load i32, ptr %SSBASE, align 4
  %v836 = add i32 %v834, %v835
  %v837 = load i32, ptr %EAX, align 4
  %v838 = load ptr, ptr %MEMORY, align 4
  %v839 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v838, ptr %state, i32 %v836, i32 %v837)
  store ptr %v839, ptr %MEMORY, align 4
  store i32 %v833, ptr %PC, align 4
  %v840 = add i32 %v833, 5
  store i32 %v840, ptr %NEXT_PC, align 4
  %v841 = add i32 %v840, 27035
  %v842 = load ptr, ptr %MEMORY, align 4
  %v843 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v842, ptr %state, i64 4228628, ptr %NEXT_PC, i32 %v840, ptr %RETURN_PC)
  store ptr %v843, ptr %MEMORY, align 4
  store i32 %v840, ptr %PC, align 4
  %v844 = add i32 %v840, 1
  store i32 %v844, ptr %NEXT_PC, align 4
  %v845 = load ptr, ptr %MEMORY, align 4
  %v846 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v845, ptr %state)
  store ptr %v846, ptr %MEMORY, align 4
  store i32 %v844, ptr %PC, align 4
  %v847 = add i32 %v844, 1
  store i32 %v847, ptr %NEXT_PC, align 4
  %v848 = load ptr, ptr %MEMORY, align 4
  %v849 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v848, ptr %state, ptr %NEXT_PC)
  store ptr %v849, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201595:                                       ; No predecessors!
  %v850 = load i32, ptr %NEXT_PC, align 4
  store i32 %v850, ptr %PC, align 4
  %v851 = add i32 %v850, 1
  store i32 %v851, ptr %NEXT_PC, align 4
  %v852 = load i32, ptr %EBP, align 4
  %v853 = load ptr, ptr %MEMORY, align 4
  %v854 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v853, ptr %state, i32 %v852)
  store ptr %v854, ptr %MEMORY, align 4
  store i32 %v851, ptr %PC, align 4
  %v855 = add i32 %v851, 2
  store i32 %v855, ptr %NEXT_PC, align 4
  %v856 = load i32, ptr %ESP, align 4
  %v857 = load ptr, ptr %MEMORY, align 4
  %v858 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v857, ptr %state, ptr %EBP, i32 %v856)
  store ptr %v858, ptr %MEMORY, align 4
  store i32 %v855, ptr %PC, align 4
  %v859 = add i32 %v855, 3
  store i32 %v859, ptr %NEXT_PC, align 4
  %v860 = load i32, ptr %ESP, align 4
  %v861 = load ptr, ptr %MEMORY, align 4
  %v862 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v861, ptr %state, ptr %ESP, i32 %v860, i32 72)
  store ptr %v862, ptr %MEMORY, align 4
  store i32 %v859, ptr %PC, align 4
  %v863 = add i32 %v859, 3
  store i32 %v863, ptr %NEXT_PC, align 4
  %v864 = load i32, ptr %EBP, align 4
  %v865 = load i32, ptr %SSBASE, align 4
  %v866 = add i32 %v864, 8
  %v867 = add i32 %v866, %v865
  %v868 = load ptr, ptr %MEMORY, align 4
  %v869 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v868, ptr %state, ptr %EAX, i32 %v867)
  store ptr %v869, ptr %MEMORY, align 4
  store i32 %v863, ptr %PC, align 4
  %v870 = add i32 %v863, 2
  store i32 %v870, ptr %NEXT_PC, align 4
  %v871 = load i32, ptr %EAX, align 4
  %v872 = load i32, ptr %DSBASE, align 4
  %v873 = add i32 %v871, %v872
  %v874 = load ptr, ptr %MEMORY, align 4
  %v875 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v874, ptr %state, ptr %EAX, i32 %v873)
  store ptr %v875, ptr %MEMORY, align 4
  store i32 %v870, ptr %PC, align 4
  %v876 = add i32 %v870, 3
  store i32 %v876, ptr %NEXT_PC, align 4
  %v877 = load i32, ptr %EAX, align 4
  %v878 = load ptr, ptr %MEMORY, align 4
  %v879 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v878, ptr %state, i32 %v877, i32 6)
  store ptr %v879, ptr %MEMORY, align 4
  store i32 %v876, ptr %PC, align 4
  %v880 = add i32 %v876, 2
  store i32 %v880, ptr %NEXT_PC, align 4
  %v881 = add i32 %v880, 63
  %v882 = load ptr, ptr %MEMORY, align 4
  %v883 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v882, ptr %state, ptr %BRANCH_TAKEN, i32 %v881, i32 %v880, ptr %NEXT_PC)
  store ptr %v883, ptr %MEMORY, align 4
  br i1 true, label %bb_4201674, label %bb_4201611

bb_4201611:                                       ; preds = %bb_4201595
  store i32 %v880, ptr %PC, align 4
  %v884 = add i32 %v880, 7
  store i32 %v884, ptr %NEXT_PC, align 4
  %v885 = load i32, ptr %EAX, align 4
  %v886 = load i32, ptr %DSBASE, align 4
  %v887 = mul i32 %v885, 4
  %v888 = add i32 0, %v887
  %v889 = add i32 %v888, 4235640
  %v890 = add i32 %v889, %v886
  %v891 = load ptr, ptr %MEMORY, align 4
  %v892 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v891, ptr %state, ptr %EAX, i32 %v890)
  store ptr %v892, ptr %MEMORY, align 4
  store i32 %v884, ptr %PC, align 4
  %v893 = add i32 %v884, 2
  store i32 %v893, ptr %NEXT_PC, align 4
  %v894 = load i32, ptr %EAX, align 4
  %v895 = load ptr, ptr %MEMORY, align 4
  %v896 = call ptr @_ZN12_GLOBAL__N_13JMPI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v895, ptr %state, i32 %v894, ptr %NEXT_PC)
  store ptr %v896, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201620:                                       ; No predecessors!
  %v897 = load i32, ptr %NEXT_PC, align 4
  store i32 %v897, ptr %PC, align 4
  %v898 = add i32 %v897, 7
  store i32 %v898, ptr %NEXT_PC, align 4
  %v899 = load i32, ptr %EBP, align 4
  %v900 = load i32, ptr %SSBASE, align 4
  %v901 = sub i32 %v899, 12
  %v902 = add i32 %v901, %v900
  %v903 = load ptr, ptr %MEMORY, align 4
  %v904 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v903, ptr %state, i32 %v902, i32 4235360)
  store ptr %v904, ptr %MEMORY, align 4
  store i32 %v898, ptr %PC, align 4
  %v905 = add i32 %v898, 2
  store i32 %v905, ptr %NEXT_PC, align 4
  %v906 = add i32 %v905, 53
  %v907 = load ptr, ptr %MEMORY, align 4
  %v908 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v907, ptr %state, i32 %v906, ptr %NEXT_PC)
  store ptr %v908, ptr %MEMORY, align 4
  br label %bb_4201682
  store i32 %v905, ptr %PC, align 4
  %v909 = add i32 %v905, 7
  store i32 %v909, ptr %NEXT_PC, align 4
  %v910 = load i32, ptr %EBP, align 4
  %v911 = load i32, ptr %SSBASE, align 4
  %v912 = sub i32 %v910, 12
  %v913 = add i32 %v912, %v911
  %v914 = load ptr, ptr %MEMORY, align 4
  %v915 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v914, ptr %state, i32 %v913, i32 4235391)
  store ptr %v915, ptr %MEMORY, align 4
  store i32 %v909, ptr %PC, align 4
  %v916 = add i32 %v909, 2
  store i32 %v916, ptr %NEXT_PC, align 4
  %v917 = add i32 %v916, 44
  %v918 = load ptr, ptr %MEMORY, align 4
  %v919 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v918, ptr %state, i32 %v917, ptr %NEXT_PC)
  store ptr %v919, ptr %MEMORY, align 4
  br label %bb_4201682
  store i32 %v916, ptr %PC, align 4
  %v920 = add i32 %v916, 7
  store i32 %v920, ptr %NEXT_PC, align 4
  %v921 = load i32, ptr %EBP, align 4
  %v922 = load i32, ptr %SSBASE, align 4
  %v923 = sub i32 %v921, 12
  %v924 = add i32 %v923, %v922
  %v925 = load ptr, ptr %MEMORY, align 4
  %v926 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v925, ptr %state, i32 %v924, i32 4235420)
  store ptr %v926, ptr %MEMORY, align 4
  store i32 %v920, ptr %PC, align 4
  %v927 = add i32 %v920, 2
  store i32 %v927, ptr %NEXT_PC, align 4
  %v928 = add i32 %v927, 35
  %v929 = load ptr, ptr %MEMORY, align 4
  %v930 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v929, ptr %state, i32 %v928, ptr %NEXT_PC)
  store ptr %v930, ptr %MEMORY, align 4
  br label %bb_4201682
  store i32 %v927, ptr %PC, align 4
  %v931 = add i32 %v927, 7
  store i32 %v931, ptr %NEXT_PC, align 4
  %v932 = load i32, ptr %EBP, align 4
  %v933 = load i32, ptr %SSBASE, align 4
  %v934 = sub i32 %v932, 12
  %v935 = add i32 %v934, %v933
  %v936 = load ptr, ptr %MEMORY, align 4
  %v937 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v936, ptr %state, i32 %v935, i32 4235452)
  store ptr %v937, ptr %MEMORY, align 4
  store i32 %v931, ptr %PC, align 4
  %v938 = add i32 %v931, 2
  store i32 %v938, ptr %NEXT_PC, align 4
  %v939 = add i32 %v938, 26
  %v940 = load ptr, ptr %MEMORY, align 4
  %v941 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v940, ptr %state, i32 %v939, ptr %NEXT_PC)
  store ptr %v941, ptr %MEMORY, align 4
  br label %bb_4201682
  store i32 %v938, ptr %PC, align 4
  %v942 = add i32 %v938, 7
  store i32 %v942, ptr %NEXT_PC, align 4
  %v943 = load i32, ptr %EBP, align 4
  %v944 = load i32, ptr %SSBASE, align 4
  %v945 = sub i32 %v943, 12
  %v946 = add i32 %v945, %v944
  %v947 = load ptr, ptr %MEMORY, align 4
  %v948 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v947, ptr %state, i32 %v946, i32 4235492)
  store ptr %v948, ptr %MEMORY, align 4
  store i32 %v942, ptr %PC, align 4
  %v949 = add i32 %v942, 2
  store i32 %v949, ptr %NEXT_PC, align 4
  %v950 = add i32 %v949, 17
  %v951 = load ptr, ptr %MEMORY, align 4
  %v952 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v951, ptr %state, i32 %v950, ptr %NEXT_PC)
  store ptr %v952, ptr %MEMORY, align 4
  br label %bb_4201682
  store i32 %v949, ptr %PC, align 4
  %v953 = add i32 %v949, 7
  store i32 %v953, ptr %NEXT_PC, align 4
  %v954 = load i32, ptr %EBP, align 4
  %v955 = load i32, ptr %SSBASE, align 4
  %v956 = sub i32 %v954, 12
  %v957 = add i32 %v956, %v955
  %v958 = load ptr, ptr %MEMORY, align 4
  %v959 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v958, ptr %state, i32 %v957, i32 4235528)
  store ptr %v959, ptr %MEMORY, align 4
  store i32 %v953, ptr %PC, align 4
  %v960 = add i32 %v953, 2
  store i32 %v960, ptr %NEXT_PC, align 4
  %v961 = add i32 %v960, 8
  %v962 = load ptr, ptr %MEMORY, align 4
  %v963 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v962, ptr %state, i32 %v961, ptr %NEXT_PC)
  store ptr %v963, ptr %MEMORY, align 4
  br label %bb_4201682

bb_4201674:                                       ; preds = %bb_4201595
  store i32 %v880, ptr %PC, align 4
  %v964 = add i32 %v880, 7
  store i32 %v964, ptr %NEXT_PC, align 4
  %v965 = load i32, ptr %EBP, align 4
  %v966 = load i32, ptr %SSBASE, align 4
  %v967 = sub i32 %v965, 12
  %v968 = add i32 %v967, %v966
  %v969 = load ptr, ptr %MEMORY, align 4
  %v970 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v969, ptr %state, i32 %v968, i32 4235582)
  store ptr %v970, ptr %MEMORY, align 4
  store i32 %v964, ptr %PC, align 4
  %v971 = add i32 %v964, 1
  store i32 %v971, ptr %NEXT_PC, align 4
  %v972 = load ptr, ptr %MEMORY, align 4
  %v973 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v972, ptr %state)
  store ptr %v973, ptr %MEMORY, align 4
  br label %bb_4201682

bb_4201682:                                       ; preds = %bb_4201674, %bb_4201620, %bb_4201620, %bb_4201620, %bb_4201620, %bb_4201620, %bb_4201620
  %v974 = load i32, ptr %NEXT_PC, align 4
  store i32 %v974, ptr %PC, align 4
  %v975 = add i32 %v974, 3
  store i32 %v975, ptr %NEXT_PC, align 4
  %v976 = load i32, ptr %EBP, align 4
  %v977 = load i32, ptr %SSBASE, align 4
  %v978 = add i32 %v976, 8
  %v979 = add i32 %v978, %v977
  %v980 = load ptr, ptr %MEMORY, align 4
  %v981 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v980, ptr %state, ptr %EAX, i32 %v979)
  store ptr %v981, ptr %MEMORY, align 4
  store i32 %v975, ptr %PC, align 4
  %v982 = add i32 %v975, 3
  store i32 %v982, ptr %NEXT_PC, align 4
  %v983 = load i32, ptr %EAX, align 4
  %v984 = load i32, ptr %DSBASE, align 4
  %v985 = add i32 %v983, 24
  %v986 = add i32 %v985, %v984
  %v987 = load i32, ptr %PC, align 4
  %v988 = load ptr, ptr %MEMORY, align 4
  %v989 = call ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr %v988, ptr %state, ptr undef, i32 %v986, i32 %v987, i32 320)
  store ptr %v989, ptr %MEMORY, align 4
  store i32 %v982, ptr %PC, align 4
  %v990 = add i32 %v982, 3
  store i32 %v990, ptr %NEXT_PC, align 4
  %v991 = load i32, ptr %EBP, align 4
  %v992 = load i32, ptr %SSBASE, align 4
  %v993 = add i32 %v991, 8
  %v994 = add i32 %v993, %v992
  %v995 = load ptr, ptr %MEMORY, align 4
  %v996 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v995, ptr %state, ptr %EAX, i32 %v994)
  store ptr %v996, ptr %MEMORY, align 4
  store i32 %v990, ptr %PC, align 4
  %v997 = add i32 %v990, 3
  store i32 %v997, ptr %NEXT_PC, align 4
  %v998 = load i32, ptr %EAX, align 4
  %v999 = load i32, ptr %DSBASE, align 4
  %v1000 = add i32 %v998, 16
  %v1001 = add i32 %v1000, %v999
  %v1002 = load i32, ptr %PC, align 4
  %v1003 = load ptr, ptr %MEMORY, align 4
  %v1004 = call ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr %v1003, ptr %state, ptr undef, i32 %v1001, i32 %v1002, i32 320)
  store ptr %v1004, ptr %MEMORY, align 4
  store i32 %v997, ptr %PC, align 4
  %v1005 = add i32 %v997, 3
  store i32 %v1005, ptr %NEXT_PC, align 4
  %v1006 = load i32, ptr %EBP, align 4
  %v1007 = load i32, ptr %SSBASE, align 4
  %v1008 = add i32 %v1006, 8
  %v1009 = add i32 %v1008, %v1007
  %v1010 = load ptr, ptr %MEMORY, align 4
  %v1011 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1010, ptr %state, ptr %EAX, i32 %v1009)
  store ptr %v1011, ptr %MEMORY, align 4
  store i32 %v1005, ptr %PC, align 4
  %v1012 = add i32 %v1005, 3
  store i32 %v1012, ptr %NEXT_PC, align 4
  %v1013 = load i32, ptr %EAX, align 4
  %v1014 = load i32, ptr %DSBASE, align 4
  %v1015 = add i32 %v1013, 8
  %v1016 = add i32 %v1015, %v1014
  %v1017 = load i32, ptr %PC, align 4
  %v1018 = load ptr, ptr %MEMORY, align 4
  %v1019 = call ptr @_ZN12_GLOBAL__N_16FLDmemI2MnIdEEEP6MemoryS4_R5State3RnWI9float80_tET_2InIjESB_ItE(ptr %v1018, ptr %state, ptr undef, i32 %v1016, i32 %v1017, i32 320)
  store ptr %v1019, ptr %MEMORY, align 4
  store i32 %v1012, ptr %PC, align 4
  %v1020 = add i32 %v1012, 2
  store i32 %v1020, ptr %NEXT_PC, align 4
  %v1021 = load i32, ptr %PC, align 4
  %v1022 = load ptr, ptr %MEMORY, align 4
  %v1023 = call ptr @_ZN12_GLOBAL__N_14FXCHEP6MemoryR5State3RnWI9float80_tES6_S6_S6_2InIjES7_ItE(ptr %v1022, ptr %state, ptr %ST0, ptr %ST0, ptr %ST2, ptr %ST2, i32 %v1021, i32 458)
  store ptr %v1023, ptr %MEMORY, align 4
  store i32 %v1020, ptr %PC, align 4
  %v1024 = add i32 %v1020, 3
  store i32 %v1024, ptr %NEXT_PC, align 4
  %v1025 = load i32, ptr %EBP, align 4
  %v1026 = load i32, ptr %SSBASE, align 4
  %v1027 = add i32 %v1025, 8
  %v1028 = add i32 %v1027, %v1026
  %v1029 = load ptr, ptr %MEMORY, align 4
  %v1030 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1029, ptr %state, ptr %EAX, i32 %v1028)
  store ptr %v1030, ptr %MEMORY, align 4
  store i32 %v1024, ptr %PC, align 4
  %v1031 = add i32 %v1024, 3
  store i32 %v1031, ptr %NEXT_PC, align 4
  %v1032 = load i32, ptr %EAX, align 4
  %v1033 = load i32, ptr %DSBASE, align 4
  %v1034 = add i32 %v1032, 4
  %v1035 = add i32 %v1034, %v1033
  %v1036 = load ptr, ptr %MEMORY, align 4
  %v1037 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1036, ptr %state, ptr %EAX, i32 %v1035)
  store ptr %v1037, ptr %MEMORY, align 4
  store i32 %v1031, ptr %PC, align 4
  %v1038 = add i32 %v1031, 6
  store i32 %v1038, ptr %NEXT_PC, align 4
  %v1039 = load i32, ptr %DSBASE, align 4
  %v1040 = add i32 4243952, %v1039
  %v1041 = load ptr, ptr %MEMORY, align 4
  %v1042 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1041, ptr %state, ptr %EDX, i32 %v1040)
  store ptr %v1042, ptr %MEMORY, align 4
  store i32 %v1038, ptr %PC, align 4
  %v1043 = add i32 %v1038, 3
  store i32 %v1043, ptr %NEXT_PC, align 4
  %v1044 = load i32, ptr %EDX, align 4
  %v1045 = load ptr, ptr %MEMORY, align 4
  %v1046 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1045, ptr %state, ptr %EDX, i32 %v1044, i32 64)
  store ptr %v1046, ptr %MEMORY, align 4
  store i32 %v1043, ptr %PC, align 4
  %v1047 = add i32 %v1043, 4
  store i32 %v1047, ptr %NEXT_PC, align 4
  %v1048 = load i32, ptr %ESP, align 4
  %v1049 = load i32, ptr %SSBASE, align 4
  %v1050 = add i32 %v1048, 32
  %v1051 = add i32 %v1050, %v1049
  %v1052 = load i32, ptr %PC, align 4
  %v1053 = load ptr, ptr %MEMORY, align 4
  %v1054 = call ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr %v1053, ptr %state, i32 %v1051, ptr %ST0, i32 %v1052, i32 348)
  store ptr %v1054, ptr %MEMORY, align 4
  store i32 %v1047, ptr %PC, align 4
  %v1055 = add i32 %v1047, 4
  store i32 %v1055, ptr %NEXT_PC, align 4
  %v1056 = load i32, ptr %ESP, align 4
  %v1057 = load i32, ptr %SSBASE, align 4
  %v1058 = add i32 %v1056, 24
  %v1059 = add i32 %v1058, %v1057
  %v1060 = load i32, ptr %PC, align 4
  %v1061 = load ptr, ptr %MEMORY, align 4
  %v1062 = call ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr %v1061, ptr %state, i32 %v1059, ptr %ST0, i32 %v1060, i32 348)
  store ptr %v1062, ptr %MEMORY, align 4
  store i32 %v1055, ptr %PC, align 4
  %v1063 = add i32 %v1055, 4
  store i32 %v1063, ptr %NEXT_PC, align 4
  %v1064 = load i32, ptr %ESP, align 4
  %v1065 = load i32, ptr %SSBASE, align 4
  %v1066 = add i32 %v1064, 16
  %v1067 = add i32 %v1066, %v1065
  %v1068 = load i32, ptr %PC, align 4
  %v1069 = load ptr, ptr %MEMORY, align 4
  %v1070 = call ptr @_ZN12_GLOBAL__N_17FSTPmemI3MnWIdEEEP6MemoryS4_R5StateT_3RnWI9float80_tE2InIjESB_ItE(ptr %v1069, ptr %state, i32 %v1067, ptr %ST0, i32 %v1068, i32 348)
  store ptr %v1070, ptr %MEMORY, align 4
  store i32 %v1063, ptr %PC, align 4
  %v1071 = add i32 %v1063, 4
  store i32 %v1071, ptr %NEXT_PC, align 4
  %v1072 = load i32, ptr %ESP, align 4
  %v1073 = load i32, ptr %SSBASE, align 4
  %v1074 = add i32 %v1072, 12
  %v1075 = add i32 %v1074, %v1073
  %v1076 = load i32, ptr %EAX, align 4
  %v1077 = load ptr, ptr %MEMORY, align 4
  %v1078 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1077, ptr %state, i32 %v1075, i32 %v1076)
  store ptr %v1078, ptr %MEMORY, align 4
  store i32 %v1071, ptr %PC, align 4
  %v1079 = add i32 %v1071, 3
  store i32 %v1079, ptr %NEXT_PC, align 4
  %v1080 = load i32, ptr %EBP, align 4
  %v1081 = load i32, ptr %SSBASE, align 4
  %v1082 = sub i32 %v1080, 12
  %v1083 = add i32 %v1082, %v1081
  %v1084 = load ptr, ptr %MEMORY, align 4
  %v1085 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1084, ptr %state, ptr %EAX, i32 %v1083)
  store ptr %v1085, ptr %MEMORY, align 4
  store i32 %v1079, ptr %PC, align 4
  %v1086 = add i32 %v1079, 4
  store i32 %v1086, ptr %NEXT_PC, align 4
  %v1087 = load i32, ptr %ESP, align 4
  %v1088 = load i32, ptr %SSBASE, align 4
  %v1089 = add i32 %v1087, 8
  %v1090 = add i32 %v1089, %v1088
  %v1091 = load i32, ptr %EAX, align 4
  %v1092 = load ptr, ptr %MEMORY, align 4
  %v1093 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1092, ptr %state, i32 %v1090, i32 %v1091)
  store ptr %v1093, ptr %MEMORY, align 4
  store i32 %v1086, ptr %PC, align 4
  %v1094 = add i32 %v1086, 8
  store i32 %v1094, ptr %NEXT_PC, align 4
  %v1095 = load i32, ptr %ESP, align 4
  %v1096 = load i32, ptr %SSBASE, align 4
  %v1097 = add i32 %v1095, 4
  %v1098 = add i32 %v1097, %v1096
  %v1099 = load ptr, ptr %MEMORY, align 4
  %v1100 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1099, ptr %state, i32 %v1098, i32 4235596)
  store ptr %v1100, ptr %MEMORY, align 4
  store i32 %v1094, ptr %PC, align 4
  %v1101 = add i32 %v1094, 3
  store i32 %v1101, ptr %NEXT_PC, align 4
  %v1102 = load i32, ptr %ESP, align 4
  %v1103 = load i32, ptr %SSBASE, align 4
  %v1104 = add i32 %v1102, %v1103
  %v1105 = load i32, ptr %EDX, align 4
  %v1106 = load ptr, ptr %MEMORY, align 4
  %v1107 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1106, ptr %state, i32 %v1104, i32 %v1105)
  store ptr %v1107, ptr %MEMORY, align 4
  store i32 %v1101, ptr %PC, align 4
  %v1108 = add i32 %v1101, 5
  store i32 %v1108, ptr %NEXT_PC, align 4
  %v1109 = add i32 %v1108, 4308
  %v1110 = load ptr, ptr %MEMORY, align 4
  %v1111 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1110, ptr %state, i64 4206064, ptr %NEXT_PC, i32 %v1108, ptr %RETURN_PC)
  store ptr %v1111, ptr %MEMORY, align 4
  store i32 %v1108, ptr %PC, align 4
  %v1112 = add i32 %v1108, 5
  store i32 %v1112, ptr %NEXT_PC, align 4
  %v1113 = load ptr, ptr %MEMORY, align 4
  %v1114 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1113, ptr %state, ptr %EAX, i32 0)
  store ptr %v1114, ptr %MEMORY, align 4
  store i32 %v1112, ptr %PC, align 4
  %v1115 = add i32 %v1112, 1
  store i32 %v1115, ptr %NEXT_PC, align 4
  %v1116 = load ptr, ptr %MEMORY, align 4
  %v1117 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1116, ptr %state)
  store ptr %v1117, ptr %MEMORY, align 4
  store i32 %v1115, ptr %PC, align 4
  %v1118 = add i32 %v1115, 1
  store i32 %v1118, ptr %NEXT_PC, align 4
  %v1119 = load ptr, ptr %MEMORY, align 4
  %v1120 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1119, ptr %state, ptr %NEXT_PC)
  store ptr %v1120, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201763:                                       ; No predecessors!
  %v1121 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1121, ptr %PC, align 4
  %v1122 = add i32 %v1121, 1
  store i32 %v1122, ptr %NEXT_PC, align 4
  %v1123 = load ptr, ptr %MEMORY, align 4
  %v1124 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v1123, ptr %state)
  store ptr %v1124, ptr %MEMORY, align 4
  store i32 %v1122, ptr %PC, align 4
  %v1125 = add i32 %v1122, 1
  store i32 %v1125, ptr %NEXT_PC, align 4
  %v1126 = load i32, ptr %EBP, align 4
  %v1127 = load ptr, ptr %MEMORY, align 4
  %v1128 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1127, ptr %state, i32 %v1126)
  store ptr %v1128, ptr %MEMORY, align 4
  store i32 %v1125, ptr %PC, align 4
  %v1129 = add i32 %v1125, 2
  store i32 %v1129, ptr %NEXT_PC, align 4
  %v1130 = load i32, ptr %ESP, align 4
  %v1131 = load ptr, ptr %MEMORY, align 4
  %v1132 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1131, ptr %state, ptr %EBP, i32 %v1130)
  store ptr %v1132, ptr %MEMORY, align 4
  store i32 %v1129, ptr %PC, align 4
  %v1133 = add i32 %v1129, 5
  store i32 %v1133, ptr %NEXT_PC, align 4
  %v1134 = load ptr, ptr %MEMORY, align 4
  %v1135 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1134, ptr %state, ptr %EAX, i32 0)
  store ptr %v1135, ptr %MEMORY, align 4
  store i32 %v1133, ptr %PC, align 4
  %v1136 = add i32 %v1133, 1
  store i32 %v1136, ptr %NEXT_PC, align 4
  %v1137 = load ptr, ptr %MEMORY, align 4
  %v1138 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v1137, ptr %state, ptr %EBP)
  store ptr %v1138, ptr %MEMORY, align 4
  store i32 %v1136, ptr %PC, align 4
  %v1139 = add i32 %v1136, 1
  store i32 %v1139, ptr %NEXT_PC, align 4
  %v1140 = load ptr, ptr %MEMORY, align 4
  %v1141 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1140, ptr %state, ptr %NEXT_PC)
  store ptr %v1141, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201774:                                       ; No predecessors!
  %v1142 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1142, ptr %PC, align 4
  %v1143 = add i32 %v1142, 1
  store i32 %v1143, ptr %NEXT_PC, align 4
  %v1144 = load ptr, ptr %MEMORY, align 4
  %v1145 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v1144, ptr %state)
  store ptr %v1145, ptr %MEMORY, align 4
  store i32 %v1143, ptr %PC, align 4
  %v1146 = add i32 %v1143, 1
  store i32 %v1146, ptr %NEXT_PC, align 4
  %v1147 = load ptr, ptr %MEMORY, align 4
  %v1148 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v1147, ptr %state)
  store ptr %v1148, ptr %MEMORY, align 4
  store i32 %v1146, ptr %PC, align 4
  %v1149 = add i32 %v1146, 1
  store i32 %v1149, ptr %NEXT_PC, align 4
  %v1150 = load i32, ptr %EBP, align 4
  %v1151 = load ptr, ptr %MEMORY, align 4
  %v1152 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1151, ptr %state, i32 %v1150)
  store ptr %v1152, ptr %MEMORY, align 4
  store i32 %v1149, ptr %PC, align 4
  %v1153 = add i32 %v1149, 2
  store i32 %v1153, ptr %NEXT_PC, align 4
  %v1154 = load i32, ptr %ESP, align 4
  %v1155 = load ptr, ptr %MEMORY, align 4
  %v1156 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1155, ptr %state, ptr %EBP, i32 %v1154)
  store ptr %v1156, ptr %MEMORY, align 4
  store i32 %v1153, ptr %PC, align 4
  %v1157 = add i32 %v1153, 3
  store i32 %v1157, ptr %NEXT_PC, align 4
  %v1158 = load i32, ptr %ESP, align 4
  %v1159 = load ptr, ptr %MEMORY, align 4
  %v1160 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1159, ptr %state, ptr %ESP, i32 %v1158, i32 56)
  store ptr %v1160, ptr %MEMORY, align 4
  store i32 %v1157, ptr %PC, align 4
  %v1161 = add i32 %v1157, 7
  store i32 %v1161, ptr %NEXT_PC, align 4
  %v1162 = load i32, ptr %EBP, align 4
  %v1163 = load i32, ptr %SSBASE, align 4
  %v1164 = sub i32 %v1162, 24
  %v1165 = add i32 %v1164, %v1163
  %v1166 = load ptr, ptr %MEMORY, align 4
  %v1167 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1166, ptr %state, i32 %v1165, i32 0)
  store ptr %v1167, ptr %MEMORY, align 4
  store i32 %v1161, ptr %PC, align 4
  %v1168 = add i32 %v1161, 7
  store i32 %v1168, ptr %NEXT_PC, align 4
  %v1169 = load i32, ptr %EBP, align 4
  %v1170 = load i32, ptr %SSBASE, align 4
  %v1171 = sub i32 %v1169, 20
  %v1172 = add i32 %v1171, %v1170
  %v1173 = load ptr, ptr %MEMORY, align 4
  %v1174 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1173, ptr %state, i32 %v1172, i32 0)
  store ptr %v1174, ptr %MEMORY, align 4
  store i32 %v1168, ptr %PC, align 4
  %v1175 = add i32 %v1168, 5
  store i32 %v1175, ptr %NEXT_PC, align 4
  %v1176 = load i32, ptr %DSBASE, align 4
  %v1177 = add i32 4231472, %v1176
  %v1178 = load ptr, ptr %MEMORY, align 4
  %v1179 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1178, ptr %state, ptr %EAX, i32 %v1177)
  store ptr %v1179, ptr %MEMORY, align 4
  store i32 %v1175, ptr %PC, align 4
  %v1180 = add i32 %v1175, 5
  store i32 %v1180, ptr %NEXT_PC, align 4
  %v1181 = load i32, ptr %EAX, align 4
  %v1182 = load ptr, ptr %MEMORY, align 4
  %v1183 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1182, ptr %state, i32 %v1181, i32 -1153374642)
  store ptr %v1183, ptr %MEMORY, align 4
  store i32 %v1180, ptr %PC, align 4
  %v1184 = add i32 %v1180, 2
  store i32 %v1184, ptr %NEXT_PC, align 4
  %v1185 = add i32 %v1184, 14
  %v1186 = load ptr, ptr %MEMORY, align 4
  %v1187 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1186, ptr %state, ptr %BRANCH_TAKEN, i32 %v1185, i32 %v1184, ptr %NEXT_PC)
  store ptr %v1187, ptr %MEMORY, align 4
  br i1 true, label %bb_4201822, label %bb_4201808

bb_4201808:                                       ; preds = %bb_4201774
  store i32 %v1184, ptr %PC, align 4
  %v1188 = add i32 %v1184, 5
  store i32 %v1188, ptr %NEXT_PC, align 4
  %v1189 = load i32, ptr %DSBASE, align 4
  %v1190 = add i32 4231472, %v1189
  %v1191 = load ptr, ptr %MEMORY, align 4
  %v1192 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1191, ptr %state, ptr %EAX, i32 %v1190)
  store ptr %v1192, ptr %MEMORY, align 4
  store i32 %v1188, ptr %PC, align 4
  %v1193 = add i32 %v1188, 2
  store i32 %v1193, ptr %NEXT_PC, align 4
  %v1194 = load i32, ptr %EAX, align 4
  %v1195 = load ptr, ptr %MEMORY, align 4
  %v1196 = call ptr @_ZN12_GLOBAL__N_13NOTI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1195, ptr %state, ptr %EAX, i32 %v1194)
  store ptr %v1196, ptr %MEMORY, align 4
  store i32 %v1193, ptr %PC, align 4
  %v1197 = add i32 %v1193, 5
  store i32 %v1197, ptr %NEXT_PC, align 4
  %v1198 = load i32, ptr %DSBASE, align 4
  %v1199 = add i32 4231476, %v1198
  %v1200 = load i32, ptr %EAX, align 4
  %v1201 = load ptr, ptr %MEMORY, align 4
  %v1202 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1201, ptr %state, i32 %v1199, i32 %v1200)
  store ptr %v1202, ptr %MEMORY, align 4
  store i32 %v1197, ptr %PC, align 4
  %v1203 = add i32 %v1197, 2
  store i32 %v1203, ptr %NEXT_PC, align 4
  %v1204 = add i32 %v1203, 120
  %v1205 = load ptr, ptr %MEMORY, align 4
  %v1206 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1205, ptr %state, i32 %v1204, ptr %NEXT_PC)
  store ptr %v1206, ptr %MEMORY, align 4
  br label %bb_4201942

bb_4201822:                                       ; preds = %bb_4201774
  store i32 %v1184, ptr %PC, align 4
  %v1207 = add i32 %v1184, 3
  store i32 %v1207, ptr %NEXT_PC, align 4
  %v1208 = load i32, ptr %EBP, align 4
  %v1209 = sub i32 %v1208, 24
  %v1210 = load ptr, ptr %MEMORY, align 4
  %v1211 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v1210, ptr %state, ptr %EAX, i32 %v1209)
  store ptr %v1211, ptr %MEMORY, align 4
  store i32 %v1207, ptr %PC, align 4
  %v1212 = add i32 %v1207, 3
  store i32 %v1212, ptr %NEXT_PC, align 4
  %v1213 = load i32, ptr %ESP, align 4
  %v1214 = load i32, ptr %SSBASE, align 4
  %v1215 = add i32 %v1213, %v1214
  %v1216 = load i32, ptr %EAX, align 4
  %v1217 = load ptr, ptr %MEMORY, align 4
  %v1218 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1217, ptr %state, i32 %v1215, i32 %v1216)
  store ptr %v1218, ptr %MEMORY, align 4
  store i32 %v1212, ptr %PC, align 4
  %v1219 = add i32 %v1212, 5
  store i32 %v1219, ptr %NEXT_PC, align 4
  %v1220 = load i32, ptr %DSBASE, align 4
  %v1221 = add i32 4243824, %v1220
  %v1222 = load ptr, ptr %MEMORY, align 4
  %v1223 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1222, ptr %state, ptr %EAX, i32 %v1221)
  store ptr %v1223, ptr %MEMORY, align 4
  store i32 %v1219, ptr %PC, align 4
  %v1224 = add i32 %v1219, 2
  store i32 %v1224, ptr %NEXT_PC, align 4
  %v1225 = load i32, ptr %EAX, align 4
  %v1226 = load ptr, ptr %MEMORY, align 4
  %v1227 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1226, ptr %state, i32 %v1225, ptr %NEXT_PC, i32 %v1224, ptr %RETURN_PC)
  store ptr %v1227, ptr %MEMORY, align 4
  store i32 %v1224, ptr %PC, align 4
  %v1228 = add i32 %v1224, 3
  store i32 %v1228, ptr %NEXT_PC, align 4
  %v1229 = load i32, ptr %ESP, align 4
  %v1230 = load ptr, ptr %MEMORY, align 4
  %v1231 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1230, ptr %state, ptr %ESP, i32 %v1229, i32 4)
  store ptr %v1231, ptr %MEMORY, align 4
  store i32 %v1228, ptr %PC, align 4
  %v1232 = add i32 %v1228, 3
  store i32 %v1232, ptr %NEXT_PC, align 4
  %v1233 = load i32, ptr %EBP, align 4
  %v1234 = load i32, ptr %SSBASE, align 4
  %v1235 = sub i32 %v1233, 24
  %v1236 = add i32 %v1235, %v1234
  %v1237 = load ptr, ptr %MEMORY, align 4
  %v1238 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1237, ptr %state, ptr %EAX, i32 %v1236)
  store ptr %v1238, ptr %MEMORY, align 4
  store i32 %v1232, ptr %PC, align 4
  %v1239 = add i32 %v1232, 3
  store i32 %v1239, ptr %NEXT_PC, align 4
  %v1240 = load i32, ptr %EBP, align 4
  %v1241 = load i32, ptr %SSBASE, align 4
  %v1242 = sub i32 %v1240, 12
  %v1243 = add i32 %v1242, %v1241
  %v1244 = load i32, ptr %EAX, align 4
  %v1245 = load ptr, ptr %MEMORY, align 4
  %v1246 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1245, ptr %state, i32 %v1243, i32 %v1244)
  store ptr %v1246, ptr %MEMORY, align 4
  store i32 %v1239, ptr %PC, align 4
  %v1247 = add i32 %v1239, 3
  store i32 %v1247, ptr %NEXT_PC, align 4
  %v1248 = load i32, ptr %EBP, align 4
  %v1249 = load i32, ptr %SSBASE, align 4
  %v1250 = sub i32 %v1248, 20
  %v1251 = add i32 %v1250, %v1249
  %v1252 = load ptr, ptr %MEMORY, align 4
  %v1253 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1252, ptr %state, ptr %EAX, i32 %v1251)
  store ptr %v1253, ptr %MEMORY, align 4
  store i32 %v1247, ptr %PC, align 4
  %v1254 = add i32 %v1247, 3
  store i32 %v1254, ptr %NEXT_PC, align 4
  %v1255 = load i32, ptr %EBP, align 4
  %v1256 = load i32, ptr %SSBASE, align 4
  %v1257 = sub i32 %v1255, 12
  %v1258 = add i32 %v1257, %v1256
  %v1259 = load i32, ptr %EBP, align 4
  %v1260 = load i32, ptr %SSBASE, align 4
  %v1261 = sub i32 %v1259, 12
  %v1262 = add i32 %v1261, %v1260
  %v1263 = load i32, ptr %EAX, align 4
  %v1264 = load ptr, ptr %MEMORY, align 4
  %v1265 = call ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1264, ptr %state, i32 %v1258, i32 %v1262, i32 %v1263)
  store ptr %v1265, ptr %MEMORY, align 4
  store i32 %v1254, ptr %PC, align 4
  %v1266 = add i32 %v1254, 5
  store i32 %v1266, ptr %NEXT_PC, align 4
  %v1267 = load i32, ptr %DSBASE, align 4
  %v1268 = add i32 4243800, %v1267
  %v1269 = load ptr, ptr %MEMORY, align 4
  %v1270 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1269, ptr %state, ptr %EAX, i32 %v1268)
  store ptr %v1270, ptr %MEMORY, align 4
  store i32 %v1266, ptr %PC, align 4
  %v1271 = add i32 %v1266, 2
  store i32 %v1271, ptr %NEXT_PC, align 4
  %v1272 = load i32, ptr %EAX, align 4
  %v1273 = load ptr, ptr %MEMORY, align 4
  %v1274 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1273, ptr %state, i32 %v1272, ptr %NEXT_PC, i32 %v1271, ptr %RETURN_PC)
  store ptr %v1274, ptr %MEMORY, align 4
  store i32 %v1271, ptr %PC, align 4
  %v1275 = add i32 %v1271, 3
  store i32 %v1275, ptr %NEXT_PC, align 4
  %v1276 = load i32, ptr %EBP, align 4
  %v1277 = load i32, ptr %SSBASE, align 4
  %v1278 = sub i32 %v1276, 12
  %v1279 = add i32 %v1278, %v1277
  %v1280 = load i32, ptr %EBP, align 4
  %v1281 = load i32, ptr %SSBASE, align 4
  %v1282 = sub i32 %v1280, 12
  %v1283 = add i32 %v1282, %v1281
  %v1284 = load i32, ptr %EAX, align 4
  %v1285 = load ptr, ptr %MEMORY, align 4
  %v1286 = call ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1285, ptr %state, i32 %v1279, i32 %v1283, i32 %v1284)
  store ptr %v1286, ptr %MEMORY, align 4
  store i32 %v1275, ptr %PC, align 4
  %v1287 = add i32 %v1275, 5
  store i32 %v1287, ptr %NEXT_PC, align 4
  %v1288 = load i32, ptr %DSBASE, align 4
  %v1289 = add i32 4243804, %v1288
  %v1290 = load ptr, ptr %MEMORY, align 4
  %v1291 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1290, ptr %state, ptr %EAX, i32 %v1289)
  store ptr %v1291, ptr %MEMORY, align 4
  store i32 %v1287, ptr %PC, align 4
  %v1292 = add i32 %v1287, 2
  store i32 %v1292, ptr %NEXT_PC, align 4
  %v1293 = load i32, ptr %EAX, align 4
  %v1294 = load ptr, ptr %MEMORY, align 4
  %v1295 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1294, ptr %state, i32 %v1293, ptr %NEXT_PC, i32 %v1292, ptr %RETURN_PC)
  store ptr %v1295, ptr %MEMORY, align 4
  store i32 %v1292, ptr %PC, align 4
  %v1296 = add i32 %v1292, 3
  store i32 %v1296, ptr %NEXT_PC, align 4
  %v1297 = load i32, ptr %EBP, align 4
  %v1298 = load i32, ptr %SSBASE, align 4
  %v1299 = sub i32 %v1297, 12
  %v1300 = add i32 %v1299, %v1298
  %v1301 = load i32, ptr %EBP, align 4
  %v1302 = load i32, ptr %SSBASE, align 4
  %v1303 = sub i32 %v1301, 12
  %v1304 = add i32 %v1303, %v1302
  %v1305 = load i32, ptr %EAX, align 4
  %v1306 = load ptr, ptr %MEMORY, align 4
  %v1307 = call ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1306, ptr %state, i32 %v1300, i32 %v1304, i32 %v1305)
  store ptr %v1307, ptr %MEMORY, align 4
  store i32 %v1296, ptr %PC, align 4
  %v1308 = add i32 %v1296, 5
  store i32 %v1308, ptr %NEXT_PC, align 4
  %v1309 = load i32, ptr %DSBASE, align 4
  %v1310 = add i32 4243828, %v1309
  %v1311 = load ptr, ptr %MEMORY, align 4
  %v1312 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1311, ptr %state, ptr %EAX, i32 %v1310)
  store ptr %v1312, ptr %MEMORY, align 4
  store i32 %v1308, ptr %PC, align 4
  %v1313 = add i32 %v1308, 2
  store i32 %v1313, ptr %NEXT_PC, align 4
  %v1314 = load i32, ptr %EAX, align 4
  %v1315 = load ptr, ptr %MEMORY, align 4
  %v1316 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1315, ptr %state, i32 %v1314, ptr %NEXT_PC, i32 %v1313, ptr %RETURN_PC)
  store ptr %v1316, ptr %MEMORY, align 4
  store i32 %v1313, ptr %PC, align 4
  %v1317 = add i32 %v1313, 3
  store i32 %v1317, ptr %NEXT_PC, align 4
  %v1318 = load i32, ptr %EBP, align 4
  %v1319 = load i32, ptr %SSBASE, align 4
  %v1320 = sub i32 %v1318, 12
  %v1321 = add i32 %v1320, %v1319
  %v1322 = load i32, ptr %EBP, align 4
  %v1323 = load i32, ptr %SSBASE, align 4
  %v1324 = sub i32 %v1322, 12
  %v1325 = add i32 %v1324, %v1323
  %v1326 = load i32, ptr %EAX, align 4
  %v1327 = load ptr, ptr %MEMORY, align 4
  %v1328 = call ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1327, ptr %state, i32 %v1321, i32 %v1325, i32 %v1326)
  store ptr %v1328, ptr %MEMORY, align 4
  store i32 %v1317, ptr %PC, align 4
  %v1329 = add i32 %v1317, 3
  store i32 %v1329, ptr %NEXT_PC, align 4
  %v1330 = load i32, ptr %EBP, align 4
  %v1331 = sub i32 %v1330, 32
  %v1332 = load ptr, ptr %MEMORY, align 4
  %v1333 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v1332, ptr %state, ptr %EAX, i32 %v1331)
  store ptr %v1333, ptr %MEMORY, align 4
  store i32 %v1329, ptr %PC, align 4
  %v1334 = add i32 %v1329, 3
  store i32 %v1334, ptr %NEXT_PC, align 4
  %v1335 = load i32, ptr %ESP, align 4
  %v1336 = load i32, ptr %SSBASE, align 4
  %v1337 = add i32 %v1335, %v1336
  %v1338 = load i32, ptr %EAX, align 4
  %v1339 = load ptr, ptr %MEMORY, align 4
  %v1340 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1339, ptr %state, i32 %v1337, i32 %v1338)
  store ptr %v1340, ptr %MEMORY, align 4
  store i32 %v1334, ptr %PC, align 4
  %v1341 = add i32 %v1334, 5
  store i32 %v1341, ptr %NEXT_PC, align 4
  %v1342 = load i32, ptr %DSBASE, align 4
  %v1343 = add i32 4243856, %v1342
  %v1344 = load ptr, ptr %MEMORY, align 4
  %v1345 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1344, ptr %state, ptr %EAX, i32 %v1343)
  store ptr %v1345, ptr %MEMORY, align 4
  store i32 %v1341, ptr %PC, align 4
  %v1346 = add i32 %v1341, 2
  store i32 %v1346, ptr %NEXT_PC, align 4
  %v1347 = load i32, ptr %EAX, align 4
  %v1348 = load ptr, ptr %MEMORY, align 4
  %v1349 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1348, ptr %state, i32 %v1347, ptr %NEXT_PC, i32 %v1346, ptr %RETURN_PC)
  store ptr %v1349, ptr %MEMORY, align 4
  store i32 %v1346, ptr %PC, align 4
  %v1350 = add i32 %v1346, 3
  store i32 %v1350, ptr %NEXT_PC, align 4
  %v1351 = load i32, ptr %ESP, align 4
  %v1352 = load ptr, ptr %MEMORY, align 4
  %v1353 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1352, ptr %state, ptr %ESP, i32 %v1351, i32 4)
  store ptr %v1353, ptr %MEMORY, align 4
  store i32 %v1350, ptr %PC, align 4
  %v1354 = add i32 %v1350, 3
  store i32 %v1354, ptr %NEXT_PC, align 4
  %v1355 = load i32, ptr %EBP, align 4
  %v1356 = load i32, ptr %SSBASE, align 4
  %v1357 = sub i32 %v1355, 32
  %v1358 = add i32 %v1357, %v1356
  %v1359 = load ptr, ptr %MEMORY, align 4
  %v1360 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1359, ptr %state, ptr %EAX, i32 %v1358)
  store ptr %v1360, ptr %MEMORY, align 4
  store i32 %v1354, ptr %PC, align 4
  %v1361 = add i32 %v1354, 3
  store i32 %v1361, ptr %NEXT_PC, align 4
  %v1362 = load i32, ptr %EBP, align 4
  %v1363 = load i32, ptr %SSBASE, align 4
  %v1364 = sub i32 %v1362, 12
  %v1365 = add i32 %v1364, %v1363
  %v1366 = load i32, ptr %EBP, align 4
  %v1367 = load i32, ptr %SSBASE, align 4
  %v1368 = sub i32 %v1366, 12
  %v1369 = add i32 %v1368, %v1367
  %v1370 = load i32, ptr %EAX, align 4
  %v1371 = load ptr, ptr %MEMORY, align 4
  %v1372 = call ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1371, ptr %state, i32 %v1365, i32 %v1369, i32 %v1370)
  store ptr %v1372, ptr %MEMORY, align 4
  store i32 %v1361, ptr %PC, align 4
  %v1373 = add i32 %v1361, 3
  store i32 %v1373, ptr %NEXT_PC, align 4
  %v1374 = load i32, ptr %EBP, align 4
  %v1375 = load i32, ptr %SSBASE, align 4
  %v1376 = sub i32 %v1374, 28
  %v1377 = add i32 %v1376, %v1375
  %v1378 = load ptr, ptr %MEMORY, align 4
  %v1379 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1378, ptr %state, ptr %EAX, i32 %v1377)
  store ptr %v1379, ptr %MEMORY, align 4
  store i32 %v1373, ptr %PC, align 4
  %v1380 = add i32 %v1373, 3
  store i32 %v1380, ptr %NEXT_PC, align 4
  %v1381 = load i32, ptr %EBP, align 4
  %v1382 = load i32, ptr %SSBASE, align 4
  %v1383 = sub i32 %v1381, 12
  %v1384 = add i32 %v1383, %v1382
  %v1385 = load i32, ptr %EBP, align 4
  %v1386 = load i32, ptr %SSBASE, align 4
  %v1387 = sub i32 %v1385, 12
  %v1388 = add i32 %v1387, %v1386
  %v1389 = load i32, ptr %EAX, align 4
  %v1390 = load ptr, ptr %MEMORY, align 4
  %v1391 = call ptr @_ZN12_GLOBAL__N_13XORI3MnWIjE2MnIjE2RnIjLb1EEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1390, ptr %state, i32 %v1384, i32 %v1388, i32 %v1389)
  store ptr %v1391, ptr %MEMORY, align 4
  store i32 %v1380, ptr %PC, align 4
  %v1392 = add i32 %v1380, 7
  store i32 %v1392, ptr %NEXT_PC, align 4
  %v1393 = load i32, ptr %EBP, align 4
  %v1394 = load i32, ptr %SSBASE, align 4
  %v1395 = sub i32 %v1393, 12
  %v1396 = add i32 %v1395, %v1394
  %v1397 = load ptr, ptr %MEMORY, align 4
  %v1398 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1397, ptr %state, i32 %v1396, i32 -1153374642)
  store ptr %v1398, ptr %MEMORY, align 4
  store i32 %v1392, ptr %PC, align 4
  %v1399 = add i32 %v1392, 2
  store i32 %v1399, ptr %NEXT_PC, align 4
  %v1400 = add i32 %v1399, 7
  %v1401 = load ptr, ptr %MEMORY, align 4
  %v1402 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1401, ptr %state, ptr %BRANCH_TAKEN, i32 %v1400, i32 %v1399, ptr %NEXT_PC)
  store ptr %v1402, ptr %MEMORY, align 4
  br i1 true, label %bb_4201924, label %bb_4201917

bb_4201917:                                       ; preds = %bb_4201822
  store i32 %v1399, ptr %PC, align 4
  %v1403 = add i32 %v1399, 7
  store i32 %v1403, ptr %NEXT_PC, align 4
  %v1404 = load i32, ptr %EBP, align 4
  %v1405 = load i32, ptr %SSBASE, align 4
  %v1406 = sub i32 %v1404, 12
  %v1407 = add i32 %v1406, %v1405
  %v1408 = load ptr, ptr %MEMORY, align 4
  %v1409 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1408, ptr %state, i32 %v1407, i32 -1153374641)
  store ptr %v1409, ptr %MEMORY, align 4
  br label %bb_4201924

bb_4201924:                                       ; preds = %bb_4201917, %bb_4201822
  %v1410 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1410, ptr %PC, align 4
  %v1411 = add i32 %v1410, 3
  store i32 %v1411, ptr %NEXT_PC, align 4
  %v1412 = load i32, ptr %EBP, align 4
  %v1413 = load i32, ptr %SSBASE, align 4
  %v1414 = sub i32 %v1412, 12
  %v1415 = add i32 %v1414, %v1413
  %v1416 = load ptr, ptr %MEMORY, align 4
  %v1417 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1416, ptr %state, ptr %EAX, i32 %v1415)
  store ptr %v1417, ptr %MEMORY, align 4
  store i32 %v1411, ptr %PC, align 4
  %v1418 = add i32 %v1411, 5
  store i32 %v1418, ptr %NEXT_PC, align 4
  %v1419 = load i32, ptr %DSBASE, align 4
  %v1420 = add i32 4231472, %v1419
  %v1421 = load i32, ptr %EAX, align 4
  %v1422 = load ptr, ptr %MEMORY, align 4
  %v1423 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1422, ptr %state, i32 %v1420, i32 %v1421)
  store ptr %v1423, ptr %MEMORY, align 4
  store i32 %v1418, ptr %PC, align 4
  %v1424 = add i32 %v1418, 3
  store i32 %v1424, ptr %NEXT_PC, align 4
  %v1425 = load i32, ptr %EBP, align 4
  %v1426 = load i32, ptr %SSBASE, align 4
  %v1427 = sub i32 %v1425, 12
  %v1428 = add i32 %v1427, %v1426
  %v1429 = load ptr, ptr %MEMORY, align 4
  %v1430 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1429, ptr %state, ptr %EAX, i32 %v1428)
  store ptr %v1430, ptr %MEMORY, align 4
  store i32 %v1424, ptr %PC, align 4
  %v1431 = add i32 %v1424, 2
  store i32 %v1431, ptr %NEXT_PC, align 4
  %v1432 = load i32, ptr %EAX, align 4
  %v1433 = load ptr, ptr %MEMORY, align 4
  %v1434 = call ptr @_ZN12_GLOBAL__N_13NOTI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1433, ptr %state, ptr %EAX, i32 %v1432)
  store ptr %v1434, ptr %MEMORY, align 4
  store i32 %v1431, ptr %PC, align 4
  %v1435 = add i32 %v1431, 5
  store i32 %v1435, ptr %NEXT_PC, align 4
  %v1436 = load i32, ptr %DSBASE, align 4
  %v1437 = add i32 4231476, %v1436
  %v1438 = load i32, ptr %EAX, align 4
  %v1439 = load ptr, ptr %MEMORY, align 4
  %v1440 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1439, ptr %state, i32 %v1437, i32 %v1438)
  store ptr %v1440, ptr %MEMORY, align 4
  br label %bb_4201942

bb_4201942:                                       ; preds = %bb_4201924, %bb_4201808
  %v1441 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1441, ptr %PC, align 4
  %v1442 = add i32 %v1441, 1
  store i32 %v1442, ptr %NEXT_PC, align 4
  %v1443 = load ptr, ptr %MEMORY, align 4
  %v1444 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v1443, ptr %state)
  store ptr %v1444, ptr %MEMORY, align 4
  store i32 %v1442, ptr %PC, align 4
  %v1445 = add i32 %v1442, 1
  store i32 %v1445, ptr %NEXT_PC, align 4
  %v1446 = load ptr, ptr %MEMORY, align 4
  %v1447 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v1446, ptr %state, ptr %NEXT_PC)
  store ptr %v1447, ptr %MEMORY, align 4
  ret ptr %memory

bb_4201944:                                       ; No predecessors!
  %v1448 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1448, ptr %PC, align 4
  %v1449 = add i32 %v1448, 1
  store i32 %v1449, ptr %NEXT_PC, align 4
  %v1450 = load i32, ptr %EBP, align 4
  %v1451 = load ptr, ptr %MEMORY, align 4
  %v1452 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1451, ptr %state, i32 %v1450)
  store ptr %v1452, ptr %MEMORY, align 4
  store i32 %v1449, ptr %PC, align 4
  %v1453 = add i32 %v1449, 2
  store i32 %v1453, ptr %NEXT_PC, align 4
  %v1454 = load i32, ptr %ESP, align 4
  %v1455 = load ptr, ptr %MEMORY, align 4
  %v1456 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1455, ptr %state, ptr %EBP, i32 %v1454)
  store ptr %v1456, ptr %MEMORY, align 4
  store i32 %v1453, ptr %PC, align 4
  %v1457 = add i32 %v1453, 3
  store i32 %v1457, ptr %NEXT_PC, align 4
  %v1458 = load i32, ptr %ESP, align 4
  %v1459 = load ptr, ptr %MEMORY, align 4
  %v1460 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1459, ptr %state, ptr %ESP, i32 %v1458, i32 56)
  store ptr %v1460, ptr %MEMORY, align 4
  store i32 %v1457, ptr %PC, align 4
  %v1461 = add i32 %v1457, 3
  store i32 %v1461, ptr %NEXT_PC, align 4
  %v1462 = load i32, ptr %EBP, align 4
  %v1463 = load i32, ptr %SSBASE, align 4
  %v1464 = add i32 %v1462, 8
  %v1465 = add i32 %v1464, %v1463
  %v1466 = load ptr, ptr %MEMORY, align 4
  %v1467 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1466, ptr %state, ptr %EAX, i32 %v1465)
  store ptr %v1467, ptr %MEMORY, align 4
  store i32 %v1461, ptr %PC, align 4
  %v1468 = add i32 %v1461, 3
  store i32 %v1468, ptr %NEXT_PC, align 4
  %v1469 = load i32, ptr %EBP, align 4
  %v1470 = load i32, ptr %SSBASE, align 4
  %v1471 = sub i32 %v1469, 32
  %v1472 = add i32 %v1471, %v1470
  %v1473 = load i32, ptr %EAX, align 4
  %v1474 = load ptr, ptr %MEMORY, align 4
  %v1475 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1474, ptr %state, i32 %v1472, i32 %v1473)
  store ptr %v1475, ptr %MEMORY, align 4
  store i32 %v1468, ptr %PC, align 4
  %v1476 = add i32 %v1468, 3
  store i32 %v1476, ptr %NEXT_PC, align 4
  %v1477 = load i32, ptr %EBP, align 4
  %v1478 = load i32, ptr %SSBASE, align 4
  %v1479 = add i32 %v1477, 12
  %v1480 = add i32 %v1479, %v1478
  %v1481 = load ptr, ptr %MEMORY, align 4
  %v1482 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1481, ptr %state, ptr %EAX, i32 %v1480)
  store ptr %v1482, ptr %MEMORY, align 4
  store i32 %v1476, ptr %PC, align 4
  %v1483 = add i32 %v1476, 3
  store i32 %v1483, ptr %NEXT_PC, align 4
  %v1484 = load i32, ptr %EBP, align 4
  %v1485 = load i32, ptr %SSBASE, align 4
  %v1486 = sub i32 %v1484, 28
  %v1487 = add i32 %v1486, %v1485
  %v1488 = load i32, ptr %EAX, align 4
  %v1489 = load ptr, ptr %MEMORY, align 4
  %v1490 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1489, ptr %state, i32 %v1487, i32 %v1488)
  store ptr %v1490, ptr %MEMORY, align 4
  store i32 %v1483, ptr %PC, align 4
  %v1491 = add i32 %v1483, 3
  store i32 %v1491, ptr %NEXT_PC, align 4
  %v1492 = load i32, ptr %EBP, align 4
  %v1493 = load i32, ptr %SSBASE, align 4
  %v1494 = add i32 %v1492, 4
  %v1495 = add i32 %v1494, %v1493
  %v1496 = load ptr, ptr %MEMORY, align 4
  %v1497 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1496, ptr %state, ptr %EAX, i32 %v1495)
  store ptr %v1497, ptr %MEMORY, align 4
  store i32 %v1491, ptr %PC, align 4
  %v1498 = add i32 %v1491, 5
  store i32 %v1498, ptr %NEXT_PC, align 4
  %v1499 = load i32, ptr %DSBASE, align 4
  %v1500 = add i32 4239736, %v1499
  %v1501 = load i32, ptr %EAX, align 4
  %v1502 = load ptr, ptr %MEMORY, align 4
  %v1503 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1502, ptr %state, i32 %v1500, i32 %v1501)
  store ptr %v1503, ptr %MEMORY, align 4
  store i32 %v1498, ptr %PC, align 4
  %v1504 = add i32 %v1498, 2
  store i32 %v1504, ptr %NEXT_PC, align 4
  %v1505 = load i32, ptr %EBP, align 4
  %v1506 = load ptr, ptr %MEMORY, align 4
  %v1507 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1506, ptr %state, ptr %EAX, i32 %v1505)
  store ptr %v1507, ptr %MEMORY, align 4
  store i32 %v1504, ptr %PC, align 4
  %v1508 = add i32 %v1504, 3
  store i32 %v1508, ptr %NEXT_PC, align 4
  %v1509 = load i32, ptr %EAX, align 4
  %v1510 = load ptr, ptr %MEMORY, align 4
  %v1511 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1510, ptr %state, ptr %EAX, i32 %v1509, i32 4)
  store ptr %v1511, ptr %MEMORY, align 4
  store i32 %v1508, ptr %PC, align 4
  %v1512 = add i32 %v1508, 5
  store i32 %v1512, ptr %NEXT_PC, align 4
  %v1513 = load i32, ptr %DSBASE, align 4
  %v1514 = add i32 4239748, %v1513
  %v1515 = load i32, ptr %EAX, align 4
  %v1516 = load ptr, ptr %MEMORY, align 4
  %v1517 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1516, ptr %state, i32 %v1514, i32 %v1515)
  store ptr %v1517, ptr %MEMORY, align 4
  store i32 %v1512, ptr %PC, align 4
  %v1518 = add i32 %v1512, 5
  store i32 %v1518, ptr %NEXT_PC, align 4
  %v1519 = load i32, ptr %DSBASE, align 4
  %v1520 = add i32 4239736, %v1519
  %v1521 = load ptr, ptr %MEMORY, align 4
  %v1522 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1521, ptr %state, ptr %EAX, i32 %v1520)
  store ptr %v1522, ptr %MEMORY, align 4
  store i32 %v1518, ptr %PC, align 4
  %v1523 = add i32 %v1518, 5
  store i32 %v1523, ptr %NEXT_PC, align 4
  %v1524 = load i32, ptr %DSBASE, align 4
  %v1525 = add i32 4239468, %v1524
  %v1526 = load i32, ptr %EAX, align 4
  %v1527 = load ptr, ptr %MEMORY, align 4
  %v1528 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1527, ptr %state, i32 %v1525, i32 %v1526)
  store ptr %v1528, ptr %MEMORY, align 4
  store i32 %v1523, ptr %PC, align 4
  %v1529 = add i32 %v1523, 3
  store i32 %v1529, ptr %NEXT_PC, align 4
  %v1530 = load i32, ptr %EBP, align 4
  %v1531 = load i32, ptr %SSBASE, align 4
  %v1532 = sub i32 %v1530, 32
  %v1533 = add i32 %v1532, %v1531
  %v1534 = load ptr, ptr %MEMORY, align 4
  %v1535 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1534, ptr %state, ptr %EAX, i32 %v1533)
  store ptr %v1535, ptr %MEMORY, align 4
  store i32 %v1529, ptr %PC, align 4
  %v1536 = add i32 %v1529, 5
  store i32 %v1536, ptr %NEXT_PC, align 4
  %v1537 = load i32, ptr %DSBASE, align 4
  %v1538 = add i32 4239724, %v1537
  %v1539 = load i32, ptr %EAX, align 4
  %v1540 = load ptr, ptr %MEMORY, align 4
  %v1541 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1540, ptr %state, i32 %v1538, i32 %v1539)
  store ptr %v1541, ptr %MEMORY, align 4
  store i32 %v1536, ptr %PC, align 4
  %v1542 = add i32 %v1536, 10
  store i32 %v1542, ptr %NEXT_PC, align 4
  %v1543 = load i32, ptr %DSBASE, align 4
  %v1544 = add i32 4239456, %v1543
  %v1545 = load ptr, ptr %MEMORY, align 4
  %v1546 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1545, ptr %state, i32 %v1544, i32 -1073740791)
  store ptr %v1546, ptr %MEMORY, align 4
  store i32 %v1542, ptr %PC, align 4
  %v1547 = add i32 %v1542, 10
  store i32 %v1547, ptr %NEXT_PC, align 4
  %v1548 = load i32, ptr %DSBASE, align 4
  %v1549 = add i32 4239460, %v1548
  %v1550 = load ptr, ptr %MEMORY, align 4
  %v1551 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1550, ptr %state, i32 %v1549, i32 1)
  store ptr %v1551, ptr %MEMORY, align 4
  store i32 %v1547, ptr %PC, align 4
  %v1552 = add i32 %v1547, 5
  store i32 %v1552, ptr %NEXT_PC, align 4
  %v1553 = load i32, ptr %DSBASE, align 4
  %v1554 = add i32 4231472, %v1553
  %v1555 = load ptr, ptr %MEMORY, align 4
  %v1556 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1555, ptr %state, ptr %EAX, i32 %v1554)
  store ptr %v1556, ptr %MEMORY, align 4
  store i32 %v1552, ptr %PC, align 4
  %v1557 = add i32 %v1552, 3
  store i32 %v1557, ptr %NEXT_PC, align 4
  %v1558 = load i32, ptr %EBP, align 4
  %v1559 = load i32, ptr %SSBASE, align 4
  %v1560 = sub i32 %v1558, 16
  %v1561 = add i32 %v1560, %v1559
  %v1562 = load i32, ptr %EAX, align 4
  %v1563 = load ptr, ptr %MEMORY, align 4
  %v1564 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1563, ptr %state, i32 %v1561, i32 %v1562)
  store ptr %v1564, ptr %MEMORY, align 4
  store i32 %v1557, ptr %PC, align 4
  %v1565 = add i32 %v1557, 5
  store i32 %v1565, ptr %NEXT_PC, align 4
  %v1566 = load i32, ptr %DSBASE, align 4
  %v1567 = add i32 4231476, %v1566
  %v1568 = load ptr, ptr %MEMORY, align 4
  %v1569 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1568, ptr %state, ptr %EAX, i32 %v1567)
  store ptr %v1569, ptr %MEMORY, align 4
  store i32 %v1565, ptr %PC, align 4
  %v1570 = add i32 %v1565, 3
  store i32 %v1570, ptr %NEXT_PC, align 4
  %v1571 = load i32, ptr %EBP, align 4
  %v1572 = load i32, ptr %SSBASE, align 4
  %v1573 = sub i32 %v1571, 12
  %v1574 = add i32 %v1573, %v1572
  %v1575 = load i32, ptr %EAX, align 4
  %v1576 = load ptr, ptr %MEMORY, align 4
  %v1577 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1576, ptr %state, i32 %v1574, i32 %v1575)
  store ptr %v1577, ptr %MEMORY, align 4
  store i32 %v1570, ptr %PC, align 4
  %v1578 = add i32 %v1570, 7
  store i32 %v1578, ptr %NEXT_PC, align 4
  %v1579 = load i32, ptr %ESP, align 4
  %v1580 = load i32, ptr %SSBASE, align 4
  %v1581 = add i32 %v1579, %v1580
  %v1582 = load ptr, ptr %MEMORY, align 4
  %v1583 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1582, ptr %state, i32 %v1581, i32 0)
  store ptr %v1583, ptr %MEMORY, align 4
  store i32 %v1578, ptr %PC, align 4
  %v1584 = add i32 %v1578, 5
  store i32 %v1584, ptr %NEXT_PC, align 4
  %v1585 = load i32, ptr %DSBASE, align 4
  %v1586 = add i32 4243860, %v1585
  %v1587 = load ptr, ptr %MEMORY, align 4
  %v1588 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1587, ptr %state, ptr %EAX, i32 %v1586)
  store ptr %v1588, ptr %MEMORY, align 4
  store i32 %v1584, ptr %PC, align 4
  %v1589 = add i32 %v1584, 2
  store i32 %v1589, ptr %NEXT_PC, align 4
  %v1590 = load i32, ptr %EAX, align 4
  %v1591 = load ptr, ptr %MEMORY, align 4
  %v1592 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1591, ptr %state, i32 %v1590, ptr %NEXT_PC, i32 %v1589, ptr %RETURN_PC)
  store ptr %v1592, ptr %MEMORY, align 4
  store i32 %v1589, ptr %PC, align 4
  %v1593 = add i32 %v1589, 3
  store i32 %v1593, ptr %NEXT_PC, align 4
  %v1594 = load i32, ptr %ESP, align 4
  %v1595 = load ptr, ptr %MEMORY, align 4
  %v1596 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1595, ptr %state, ptr %ESP, i32 %v1594, i32 4)
  store ptr %v1596, ptr %MEMORY, align 4
  store i32 %v1593, ptr %PC, align 4
  %v1597 = add i32 %v1593, 7
  store i32 %v1597, ptr %NEXT_PC, align 4
  %v1598 = load i32, ptr %ESP, align 4
  %v1599 = load i32, ptr %SSBASE, align 4
  %v1600 = add i32 %v1598, %v1599
  %v1601 = load ptr, ptr %MEMORY, align 4
  %v1602 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1601, ptr %state, i32 %v1600, i32 4235668)
  store ptr %v1602, ptr %MEMORY, align 4
  store i32 %v1597, ptr %PC, align 4
  %v1603 = add i32 %v1597, 5
  store i32 %v1603, ptr %NEXT_PC, align 4
  %v1604 = load i32, ptr %DSBASE, align 4
  %v1605 = add i32 4243876, %v1604
  %v1606 = load ptr, ptr %MEMORY, align 4
  %v1607 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1606, ptr %state, ptr %EAX, i32 %v1605)
  store ptr %v1607, ptr %MEMORY, align 4
  store i32 %v1603, ptr %PC, align 4
  %v1608 = add i32 %v1603, 2
  store i32 %v1608, ptr %NEXT_PC, align 4
  %v1609 = load i32, ptr %EAX, align 4
  %v1610 = load ptr, ptr %MEMORY, align 4
  %v1611 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1610, ptr %state, i32 %v1609, ptr %NEXT_PC, i32 %v1608, ptr %RETURN_PC)
  store ptr %v1611, ptr %MEMORY, align 4
  store i32 %v1608, ptr %PC, align 4
  %v1612 = add i32 %v1608, 3
  store i32 %v1612, ptr %NEXT_PC, align 4
  %v1613 = load i32, ptr %ESP, align 4
  %v1614 = load ptr, ptr %MEMORY, align 4
  %v1615 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1614, ptr %state, ptr %ESP, i32 %v1613, i32 4)
  store ptr %v1615, ptr %MEMORY, align 4
  store i32 %v1612, ptr %PC, align 4
  %v1616 = add i32 %v1612, 5
  store i32 %v1616, ptr %NEXT_PC, align 4
  %v1617 = load i32, ptr %DSBASE, align 4
  %v1618 = add i32 4243796, %v1617
  %v1619 = load ptr, ptr %MEMORY, align 4
  %v1620 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1619, ptr %state, ptr %EAX, i32 %v1618)
  store ptr %v1620, ptr %MEMORY, align 4
  store i32 %v1616, ptr %PC, align 4
  %v1621 = add i32 %v1616, 2
  store i32 %v1621, ptr %NEXT_PC, align 4
  %v1622 = load i32, ptr %EAX, align 4
  %v1623 = load ptr, ptr %MEMORY, align 4
  %v1624 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1623, ptr %state, i32 %v1622, ptr %NEXT_PC, i32 %v1621, ptr %RETURN_PC)
  store ptr %v1624, ptr %MEMORY, align 4
  store i32 %v1621, ptr %PC, align 4
  %v1625 = add i32 %v1621, 8
  store i32 %v1625, ptr %NEXT_PC, align 4
  %v1626 = load i32, ptr %ESP, align 4
  %v1627 = load i32, ptr %SSBASE, align 4
  %v1628 = add i32 %v1626, 4
  %v1629 = add i32 %v1628, %v1627
  %v1630 = load ptr, ptr %MEMORY, align 4
  %v1631 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1630, ptr %state, i32 %v1629, i32 -1073740791)
  store ptr %v1631, ptr %MEMORY, align 4
  store i32 %v1625, ptr %PC, align 4
  %v1632 = add i32 %v1625, 3
  store i32 %v1632, ptr %NEXT_PC, align 4
  %v1633 = load i32, ptr %ESP, align 4
  %v1634 = load i32, ptr %SSBASE, align 4
  %v1635 = add i32 %v1633, %v1634
  %v1636 = load i32, ptr %EAX, align 4
  %v1637 = load ptr, ptr %MEMORY, align 4
  %v1638 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1637, ptr %state, i32 %v1635, i32 %v1636)
  store ptr %v1638, ptr %MEMORY, align 4
  store i32 %v1632, ptr %PC, align 4
  %v1639 = add i32 %v1632, 5
  store i32 %v1639, ptr %NEXT_PC, align 4
  %v1640 = load i32, ptr %DSBASE, align 4
  %v1641 = add i32 4243868, %v1640
  %v1642 = load ptr, ptr %MEMORY, align 4
  %v1643 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1642, ptr %state, ptr %EAX, i32 %v1641)
  store ptr %v1643, ptr %MEMORY, align 4
  store i32 %v1639, ptr %PC, align 4
  %v1644 = add i32 %v1639, 2
  store i32 %v1644, ptr %NEXT_PC, align 4
  %v1645 = load i32, ptr %EAX, align 4
  %v1646 = load ptr, ptr %MEMORY, align 4
  %v1647 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v1646, ptr %state, i32 %v1645, ptr %NEXT_PC, i32 %v1644, ptr %RETURN_PC)
  store ptr %v1647, ptr %MEMORY, align 4
  store i32 %v1644, ptr %PC, align 4
  %v1648 = add i32 %v1644, 3
  store i32 %v1648, ptr %NEXT_PC, align 4
  %v1649 = load i32, ptr %ESP, align 4
  %v1650 = load ptr, ptr %MEMORY, align 4
  %v1651 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1650, ptr %state, ptr %ESP, i32 %v1649, i32 8)
  store ptr %v1651, ptr %MEMORY, align 4
  store i32 %v1648, ptr %PC, align 4
  %v1652 = add i32 %v1648, 5
  store i32 %v1652, ptr %NEXT_PC, align 4
  %v1653 = add i32 %v1652, 26535
  %v1654 = load ptr, ptr %MEMORY, align 4
  %v1655 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1654, ptr %state, i64 4228636, ptr %NEXT_PC, i32 %v1652, ptr %RETURN_PC)
  store ptr %v1655, ptr %MEMORY, align 4
  store i32 %v1652, ptr %PC, align 4
  %v1656 = add i32 %v1652, 1
  store i32 %v1656, ptr %NEXT_PC, align 4
  %v1657 = load ptr, ptr %MEMORY, align 4
  %v1658 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v1657, ptr %state)
  store ptr %v1658, ptr %MEMORY, align 4
  store i32 %v1656, ptr %PC, align 4
  %v1659 = add i32 %v1656, 1
  store i32 %v1659, ptr %NEXT_PC, align 4
  %v1660 = load ptr, ptr %MEMORY, align 4
  %v1661 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v1660, ptr %state)
  store ptr %v1661, ptr %MEMORY, align 4
  store i32 %v1659, ptr %PC, align 4
  %v1662 = add i32 %v1659, 1
  store i32 %v1662, ptr %NEXT_PC, align 4
  %v1663 = load ptr, ptr %MEMORY, align 4
  %v1664 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v1663, ptr %state)
  store ptr %v1664, ptr %MEMORY, align 4
  store i32 %v1662, ptr %PC, align 4
  %v1665 = add i32 %v1662, 1
  store i32 %v1665, ptr %NEXT_PC, align 4
  %v1666 = load i32, ptr %EBP, align 4
  %v1667 = load ptr, ptr %MEMORY, align 4
  %v1668 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1667, ptr %state, i32 %v1666)
  store ptr %v1668, ptr %MEMORY, align 4
  store i32 %v1665, ptr %PC, align 4
  %v1669 = add i32 %v1665, 2
  store i32 %v1669, ptr %NEXT_PC, align 4
  %v1670 = load i32, ptr %ESP, align 4
  %v1671 = load ptr, ptr %MEMORY, align 4
  %v1672 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1671, ptr %state, ptr %EBP, i32 %v1670)
  store ptr %v1672, ptr %MEMORY, align 4
  store i32 %v1669, ptr %PC, align 4
  %v1673 = add i32 %v1669, 3
  store i32 %v1673, ptr %NEXT_PC, align 4
  %v1674 = load i32, ptr %ESP, align 4
  %v1675 = load ptr, ptr %MEMORY, align 4
  %v1676 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1675, ptr %state, ptr %ESP, i32 %v1674, i32 40)
  store ptr %v1676, ptr %MEMORY, align 4
  store i32 %v1673, ptr %PC, align 4
  %v1677 = add i32 %v1673, 3
  store i32 %v1677, ptr %NEXT_PC, align 4
  %v1678 = load i32, ptr %EBP, align 4
  %v1679 = add i32 %v1678, 12
  %v1680 = load ptr, ptr %MEMORY, align 4
  %v1681 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v1680, ptr %state, ptr %EAX, i32 %v1679)
  store ptr %v1681, ptr %MEMORY, align 4
  store i32 %v1677, ptr %PC, align 4
  %v1682 = add i32 %v1677, 3
  store i32 %v1682, ptr %NEXT_PC, align 4
  %v1683 = load i32, ptr %EBP, align 4
  %v1684 = load i32, ptr %SSBASE, align 4
  %v1685 = sub i32 %v1683, 12
  %v1686 = add i32 %v1685, %v1684
  %v1687 = load i32, ptr %EAX, align 4
  %v1688 = load ptr, ptr %MEMORY, align 4
  %v1689 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1688, ptr %state, i32 %v1686, i32 %v1687)
  store ptr %v1689, ptr %MEMORY, align 4
  store i32 %v1682, ptr %PC, align 4
  %v1690 = add i32 %v1682, 5
  store i32 %v1690, ptr %NEXT_PC, align 4
  %v1691 = load i32, ptr %DSBASE, align 4
  %v1692 = add i32 4243952, %v1691
  %v1693 = load ptr, ptr %MEMORY, align 4
  %v1694 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1693, ptr %state, ptr %EAX, i32 %v1692)
  store ptr %v1694, ptr %MEMORY, align 4
  store i32 %v1690, ptr %PC, align 4
  %v1695 = add i32 %v1690, 3
  store i32 %v1695, ptr %NEXT_PC, align 4
  %v1696 = load i32, ptr %EAX, align 4
  %v1697 = load ptr, ptr %MEMORY, align 4
  %v1698 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1697, ptr %state, ptr %EAX, i32 %v1696, i32 64)
  store ptr %v1698, ptr %MEMORY, align 4
  store i32 %v1695, ptr %PC, align 4
  %v1699 = add i32 %v1695, 8
  store i32 %v1699, ptr %NEXT_PC, align 4
  %v1700 = load i32, ptr %ESP, align 4
  %v1701 = load i32, ptr %SSBASE, align 4
  %v1702 = add i32 %v1700, 4
  %v1703 = add i32 %v1702, %v1701
  %v1704 = load ptr, ptr %MEMORY, align 4
  %v1705 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1704, ptr %state, i32 %v1703, i32 4235676)
  store ptr %v1705, ptr %MEMORY, align 4
  store i32 %v1699, ptr %PC, align 4
  %v1706 = add i32 %v1699, 3
  store i32 %v1706, ptr %NEXT_PC, align 4
  %v1707 = load i32, ptr %ESP, align 4
  %v1708 = load i32, ptr %SSBASE, align 4
  %v1709 = add i32 %v1707, %v1708
  %v1710 = load i32, ptr %EAX, align 4
  %v1711 = load ptr, ptr %MEMORY, align 4
  %v1712 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1711, ptr %state, i32 %v1709, i32 %v1710)
  store ptr %v1712, ptr %MEMORY, align 4
  store i32 %v1706, ptr %PC, align 4
  %v1713 = add i32 %v1706, 5
  store i32 %v1713, ptr %NEXT_PC, align 4
  %v1714 = add i32 %v1713, 3924
  %v1715 = load ptr, ptr %MEMORY, align 4
  %v1716 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1715, ptr %state, i64 4206064, ptr %NEXT_PC, i32 %v1713, ptr %RETURN_PC)
  store ptr %v1716, ptr %MEMORY, align 4
  store i32 %v1713, ptr %PC, align 4
  %v1717 = add i32 %v1713, 3
  store i32 %v1717, ptr %NEXT_PC, align 4
  %v1718 = load i32, ptr %EBP, align 4
  %v1719 = load i32, ptr %SSBASE, align 4
  %v1720 = sub i32 %v1718, 12
  %v1721 = add i32 %v1720, %v1719
  %v1722 = load ptr, ptr %MEMORY, align 4
  %v1723 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1722, ptr %state, ptr %EAX, i32 %v1721)
  store ptr %v1723, ptr %MEMORY, align 4
  store i32 %v1717, ptr %PC, align 4
  %v1724 = add i32 %v1717, 6
  store i32 %v1724, ptr %NEXT_PC, align 4
  %v1725 = load i32, ptr %DSBASE, align 4
  %v1726 = add i32 4243952, %v1725
  %v1727 = load ptr, ptr %MEMORY, align 4
  %v1728 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1727, ptr %state, ptr %EDX, i32 %v1726)
  store ptr %v1728, ptr %MEMORY, align 4
  store i32 %v1724, ptr %PC, align 4
  %v1729 = add i32 %v1724, 3
  store i32 %v1729, ptr %NEXT_PC, align 4
  %v1730 = load i32, ptr %EDX, align 4
  %v1731 = load ptr, ptr %MEMORY, align 4
  %v1732 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1731, ptr %state, ptr %EDX, i32 %v1730, i32 64)
  store ptr %v1732, ptr %MEMORY, align 4
  store i32 %v1729, ptr %PC, align 4
  %v1733 = add i32 %v1729, 4
  store i32 %v1733, ptr %NEXT_PC, align 4
  %v1734 = load i32, ptr %ESP, align 4
  %v1735 = load i32, ptr %SSBASE, align 4
  %v1736 = add i32 %v1734, 8
  %v1737 = add i32 %v1736, %v1735
  %v1738 = load i32, ptr %EAX, align 4
  %v1739 = load ptr, ptr %MEMORY, align 4
  %v1740 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1739, ptr %state, i32 %v1737, i32 %v1738)
  store ptr %v1740, ptr %MEMORY, align 4
  store i32 %v1733, ptr %PC, align 4
  %v1741 = add i32 %v1733, 3
  store i32 %v1741, ptr %NEXT_PC, align 4
  %v1742 = load i32, ptr %EBP, align 4
  %v1743 = load i32, ptr %SSBASE, align 4
  %v1744 = add i32 %v1742, 8
  %v1745 = add i32 %v1744, %v1743
  %v1746 = load ptr, ptr %MEMORY, align 4
  %v1747 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1746, ptr %state, ptr %EAX, i32 %v1745)
  store ptr %v1747, ptr %MEMORY, align 4
  store i32 %v1741, ptr %PC, align 4
  %v1748 = add i32 %v1741, 4
  store i32 %v1748, ptr %NEXT_PC, align 4
  %v1749 = load i32, ptr %ESP, align 4
  %v1750 = load i32, ptr %SSBASE, align 4
  %v1751 = add i32 %v1749, 4
  %v1752 = add i32 %v1751, %v1750
  %v1753 = load i32, ptr %EAX, align 4
  %v1754 = load ptr, ptr %MEMORY, align 4
  %v1755 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1754, ptr %state, i32 %v1752, i32 %v1753)
  store ptr %v1755, ptr %MEMORY, align 4
  store i32 %v1748, ptr %PC, align 4
  %v1756 = add i32 %v1748, 3
  store i32 %v1756, ptr %NEXT_PC, align 4
  %v1757 = load i32, ptr %ESP, align 4
  %v1758 = load i32, ptr %SSBASE, align 4
  %v1759 = add i32 %v1757, %v1758
  %v1760 = load i32, ptr %EDX, align 4
  %v1761 = load ptr, ptr %MEMORY, align 4
  %v1762 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1761, ptr %state, i32 %v1759, i32 %v1760)
  store ptr %v1762, ptr %MEMORY, align 4
  store i32 %v1756, ptr %PC, align 4
  %v1763 = add i32 %v1756, 5
  store i32 %v1763, ptr %NEXT_PC, align 4
  %v1764 = add i32 %v1763, 3957
  %v1765 = load ptr, ptr %MEMORY, align 4
  %v1766 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1765, ptr %state, i64 4206128, ptr %NEXT_PC, i32 %v1763, ptr %RETURN_PC)
  store ptr %v1766, ptr %MEMORY, align 4
  store i32 %v1763, ptr %PC, align 4
  %v1767 = add i32 %v1763, 5
  store i32 %v1767, ptr %NEXT_PC, align 4
  %v1768 = add i32 %v1767, 26460
  %v1769 = load ptr, ptr %MEMORY, align 4
  %v1770 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v1769, ptr %state, i64 4228636, ptr %NEXT_PC, i32 %v1767, ptr %RETURN_PC)
  store ptr %v1770, ptr %MEMORY, align 4
  store i32 %v1767, ptr %PC, align 4
  %v1771 = add i32 %v1767, 1
  store i32 %v1771, ptr %NEXT_PC, align 4
  %v1772 = load i32, ptr %EBP, align 4
  %v1773 = load ptr, ptr %MEMORY, align 4
  %v1774 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1773, ptr %state, i32 %v1772)
  store ptr %v1774, ptr %MEMORY, align 4
  store i32 %v1771, ptr %PC, align 4
  %v1775 = add i32 %v1771, 2
  store i32 %v1775, ptr %NEXT_PC, align 4
  %v1776 = load i32, ptr %ESP, align 4
  %v1777 = load ptr, ptr %MEMORY, align 4
  %v1778 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1777, ptr %state, ptr %EBP, i32 %v1776)
  store ptr %v1778, ptr %MEMORY, align 4
  store i32 %v1775, ptr %PC, align 4
  %v1779 = add i32 %v1775, 1
  store i32 %v1779, ptr %NEXT_PC, align 4
  %v1780 = load i32, ptr %EBX, align 4
  %v1781 = load ptr, ptr %MEMORY, align 4
  %v1782 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v1781, ptr %state, i32 %v1780)
  store ptr %v1782, ptr %MEMORY, align 4
  store i32 %v1779, ptr %PC, align 4
  %v1783 = add i32 %v1779, 3
  store i32 %v1783, ptr %NEXT_PC, align 4
  %v1784 = load i32, ptr %ESP, align 4
  %v1785 = load ptr, ptr %MEMORY, align 4
  %v1786 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1785, ptr %state, ptr %ESP, i32 %v1784, i32 68)
  store ptr %v1786, ptr %MEMORY, align 4
  store i32 %v1783, ptr %PC, align 4
  %v1787 = add i32 %v1783, 7
  store i32 %v1787, ptr %NEXT_PC, align 4
  %v1788 = load i32, ptr %EBP, align 4
  %v1789 = load i32, ptr %SSBASE, align 4
  %v1790 = sub i32 %v1788, 12
  %v1791 = add i32 %v1790, %v1789
  %v1792 = load ptr, ptr %MEMORY, align 4
  %v1793 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1792, ptr %state, i32 %v1791, i32 0)
  store ptr %v1793, ptr %MEMORY, align 4
  store i32 %v1787, ptr %PC, align 4
  %v1794 = add i32 %v1787, 2
  store i32 %v1794, ptr %NEXT_PC, align 4
  %v1795 = add i32 %v1794, 92
  %v1796 = load ptr, ptr %MEMORY, align 4
  %v1797 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v1796, ptr %state, i32 %v1795, ptr %NEXT_PC)
  store ptr %v1797, ptr %MEMORY, align 4
  br label %bb_4202284

bb_4202192:                                       ; preds = %bb_4202284
  store i32 %v1986, ptr %PC, align 4
  %v1798 = add i32 %v1986, 6
  store i32 %v1798, ptr %NEXT_PC, align 4
  %v1799 = load i32, ptr %DSBASE, align 4
  %v1800 = add i32 4240288, %v1799
  %v1801 = load ptr, ptr %MEMORY, align 4
  %v1802 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1801, ptr %state, ptr %ECX, i32 %v1800)
  store ptr %v1802, ptr %MEMORY, align 4
  store i32 %v1798, ptr %PC, align 4
  %v1803 = add i32 %v1798, 3
  store i32 %v1803, ptr %NEXT_PC, align 4
  %v1804 = load i32, ptr %EBP, align 4
  %v1805 = load i32, ptr %SSBASE, align 4
  %v1806 = sub i32 %v1804, 12
  %v1807 = add i32 %v1806, %v1805
  %v1808 = load ptr, ptr %MEMORY, align 4
  %v1809 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1808, ptr %state, ptr %EDX, i32 %v1807)
  store ptr %v1809, ptr %MEMORY, align 4
  store i32 %v1803, ptr %PC, align 4
  %v1810 = add i32 %v1803, 2
  store i32 %v1810, ptr %NEXT_PC, align 4
  %v1811 = load i32, ptr %EDX, align 4
  %v1812 = load ptr, ptr %MEMORY, align 4
  %v1813 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1812, ptr %state, ptr %EAX, i32 %v1811)
  store ptr %v1813, ptr %MEMORY, align 4
  store i32 %v1810, ptr %PC, align 4
  %v1814 = add i32 %v1810, 2
  store i32 %v1814, ptr %NEXT_PC, align 4
  %v1815 = load i32, ptr %EAX, align 4
  %v1816 = load i32, ptr %EAX, align 4
  %v1817 = load ptr, ptr %MEMORY, align 4
  %v1818 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1817, ptr %state, ptr %EAX, i32 %v1815, i32 %v1816)
  store ptr %v1818, ptr %MEMORY, align 4
  store i32 %v1814, ptr %PC, align 4
  %v1819 = add i32 %v1814, 2
  store i32 %v1819, ptr %NEXT_PC, align 4
  %v1820 = load i32, ptr %EAX, align 4
  %v1821 = load i32, ptr %EDX, align 4
  %v1822 = load ptr, ptr %MEMORY, align 4
  %v1823 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1822, ptr %state, ptr %EAX, i32 %v1820, i32 %v1821)
  store ptr %v1823, ptr %MEMORY, align 4
  store i32 %v1819, ptr %PC, align 4
  %v1824 = add i32 %v1819, 3
  store i32 %v1824, ptr %NEXT_PC, align 4
  %v1825 = load i32, ptr %EAX, align 4
  %v1826 = load ptr, ptr %MEMORY, align 4
  %v1827 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1826, ptr %state, ptr %EAX, i32 %v1825, i32 2)
  store ptr %v1827, ptr %MEMORY, align 4
  store i32 %v1824, ptr %PC, align 4
  %v1828 = add i32 %v1824, 2
  store i32 %v1828, ptr %NEXT_PC, align 4
  %v1829 = load i32, ptr %EAX, align 4
  %v1830 = load i32, ptr %ECX, align 4
  %v1831 = load ptr, ptr %MEMORY, align 4
  %v1832 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1831, ptr %state, ptr %EAX, i32 %v1829, i32 %v1830)
  store ptr %v1832, ptr %MEMORY, align 4
  store i32 %v1828, ptr %PC, align 4
  %v1833 = add i32 %v1828, 3
  store i32 %v1833, ptr %NEXT_PC, align 4
  %v1834 = load i32, ptr %EAX, align 4
  %v1835 = load i32, ptr %DSBASE, align 4
  %v1836 = add i32 %v1834, 4
  %v1837 = add i32 %v1836, %v1835
  %v1838 = load ptr, ptr %MEMORY, align 4
  %v1839 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1838, ptr %state, ptr %EAX, i32 %v1837)
  store ptr %v1839, ptr %MEMORY, align 4
  store i32 %v1833, ptr %PC, align 4
  %v1840 = add i32 %v1833, 3
  store i32 %v1840, ptr %NEXT_PC, align 4
  %v1841 = load i32, ptr %EAX, align 4
  %v1842 = load i32, ptr %EBP, align 4
  %v1843 = load i32, ptr %SSBASE, align 4
  %v1844 = add i32 %v1842, 8
  %v1845 = add i32 %v1844, %v1843
  %v1846 = load ptr, ptr %MEMORY, align 4
  %v1847 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1846, ptr %state, i32 %v1841, i32 %v1845)
  store ptr %v1847, ptr %MEMORY, align 4
  store i32 %v1840, ptr %PC, align 4
  %v1848 = add i32 %v1840, 2
  store i32 %v1848, ptr %NEXT_PC, align 4
  %v1849 = add i32 %v1848, 60
  %v1850 = load ptr, ptr %MEMORY, align 4
  %v1851 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1850, ptr %state, ptr %BRANCH_TAKEN, i32 %v1849, i32 %v1848, ptr %NEXT_PC)
  store ptr %v1851, ptr %MEMORY, align 4
  br i1 true, label %bb_4202280, label %bb_4202220

bb_4202220:                                       ; preds = %bb_4202192
  store i32 %v1848, ptr %PC, align 4
  %v1852 = add i32 %v1848, 6
  store i32 %v1852, ptr %NEXT_PC, align 4
  %v1853 = load i32, ptr %DSBASE, align 4
  %v1854 = add i32 4240288, %v1853
  %v1855 = load ptr, ptr %MEMORY, align 4
  %v1856 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1855, ptr %state, ptr %ECX, i32 %v1854)
  store ptr %v1856, ptr %MEMORY, align 4
  store i32 %v1852, ptr %PC, align 4
  %v1857 = add i32 %v1852, 3
  store i32 %v1857, ptr %NEXT_PC, align 4
  %v1858 = load i32, ptr %EBP, align 4
  %v1859 = load i32, ptr %SSBASE, align 4
  %v1860 = sub i32 %v1858, 12
  %v1861 = add i32 %v1860, %v1859
  %v1862 = load ptr, ptr %MEMORY, align 4
  %v1863 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1862, ptr %state, ptr %EDX, i32 %v1861)
  store ptr %v1863, ptr %MEMORY, align 4
  store i32 %v1857, ptr %PC, align 4
  %v1864 = add i32 %v1857, 2
  store i32 %v1864, ptr %NEXT_PC, align 4
  %v1865 = load i32, ptr %EDX, align 4
  %v1866 = load ptr, ptr %MEMORY, align 4
  %v1867 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1866, ptr %state, ptr %EAX, i32 %v1865)
  store ptr %v1867, ptr %MEMORY, align 4
  store i32 %v1864, ptr %PC, align 4
  %v1868 = add i32 %v1864, 2
  store i32 %v1868, ptr %NEXT_PC, align 4
  %v1869 = load i32, ptr %EAX, align 4
  %v1870 = load i32, ptr %EAX, align 4
  %v1871 = load ptr, ptr %MEMORY, align 4
  %v1872 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1871, ptr %state, ptr %EAX, i32 %v1869, i32 %v1870)
  store ptr %v1872, ptr %MEMORY, align 4
  store i32 %v1868, ptr %PC, align 4
  %v1873 = add i32 %v1868, 2
  store i32 %v1873, ptr %NEXT_PC, align 4
  %v1874 = load i32, ptr %EAX, align 4
  %v1875 = load i32, ptr %EDX, align 4
  %v1876 = load ptr, ptr %MEMORY, align 4
  %v1877 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1876, ptr %state, ptr %EAX, i32 %v1874, i32 %v1875)
  store ptr %v1877, ptr %MEMORY, align 4
  store i32 %v1873, ptr %PC, align 4
  %v1878 = add i32 %v1873, 3
  store i32 %v1878, ptr %NEXT_PC, align 4
  %v1879 = load i32, ptr %EAX, align 4
  %v1880 = load ptr, ptr %MEMORY, align 4
  %v1881 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1880, ptr %state, ptr %EAX, i32 %v1879, i32 2)
  store ptr %v1881, ptr %MEMORY, align 4
  store i32 %v1878, ptr %PC, align 4
  %v1882 = add i32 %v1878, 2
  store i32 %v1882, ptr %NEXT_PC, align 4
  %v1883 = load i32, ptr %EAX, align 4
  %v1884 = load i32, ptr %ECX, align 4
  %v1885 = load ptr, ptr %MEMORY, align 4
  %v1886 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1885, ptr %state, ptr %EAX, i32 %v1883, i32 %v1884)
  store ptr %v1886, ptr %MEMORY, align 4
  store i32 %v1882, ptr %PC, align 4
  %v1887 = add i32 %v1882, 3
  store i32 %v1887, ptr %NEXT_PC, align 4
  %v1888 = load i32, ptr %EAX, align 4
  %v1889 = load i32, ptr %DSBASE, align 4
  %v1890 = add i32 %v1888, 4
  %v1891 = add i32 %v1890, %v1889
  %v1892 = load ptr, ptr %MEMORY, align 4
  %v1893 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1892, ptr %state, ptr %ECX, i32 %v1891)
  store ptr %v1893, ptr %MEMORY, align 4
  store i32 %v1887, ptr %PC, align 4
  %v1894 = add i32 %v1887, 6
  store i32 %v1894, ptr %NEXT_PC, align 4
  %v1895 = load i32, ptr %DSBASE, align 4
  %v1896 = add i32 4240288, %v1895
  %v1897 = load ptr, ptr %MEMORY, align 4
  %v1898 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1897, ptr %state, ptr %EBX, i32 %v1896)
  store ptr %v1898, ptr %MEMORY, align 4
  store i32 %v1894, ptr %PC, align 4
  %v1899 = add i32 %v1894, 3
  store i32 %v1899, ptr %NEXT_PC, align 4
  %v1900 = load i32, ptr %EBP, align 4
  %v1901 = load i32, ptr %SSBASE, align 4
  %v1902 = sub i32 %v1900, 12
  %v1903 = add i32 %v1902, %v1901
  %v1904 = load ptr, ptr %MEMORY, align 4
  %v1905 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1904, ptr %state, ptr %EDX, i32 %v1903)
  store ptr %v1905, ptr %MEMORY, align 4
  store i32 %v1899, ptr %PC, align 4
  %v1906 = add i32 %v1899, 2
  store i32 %v1906, ptr %NEXT_PC, align 4
  %v1907 = load i32, ptr %EDX, align 4
  %v1908 = load ptr, ptr %MEMORY, align 4
  %v1909 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v1908, ptr %state, ptr %EAX, i32 %v1907)
  store ptr %v1909, ptr %MEMORY, align 4
  store i32 %v1906, ptr %PC, align 4
  %v1910 = add i32 %v1906, 2
  store i32 %v1910, ptr %NEXT_PC, align 4
  %v1911 = load i32, ptr %EAX, align 4
  %v1912 = load i32, ptr %EAX, align 4
  %v1913 = load ptr, ptr %MEMORY, align 4
  %v1914 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1913, ptr %state, ptr %EAX, i32 %v1911, i32 %v1912)
  store ptr %v1914, ptr %MEMORY, align 4
  store i32 %v1910, ptr %PC, align 4
  %v1915 = add i32 %v1910, 2
  store i32 %v1915, ptr %NEXT_PC, align 4
  %v1916 = load i32, ptr %EAX, align 4
  %v1917 = load i32, ptr %EDX, align 4
  %v1918 = load ptr, ptr %MEMORY, align 4
  %v1919 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1918, ptr %state, ptr %EAX, i32 %v1916, i32 %v1917)
  store ptr %v1919, ptr %MEMORY, align 4
  store i32 %v1915, ptr %PC, align 4
  %v1920 = add i32 %v1915, 3
  store i32 %v1920, ptr %NEXT_PC, align 4
  %v1921 = load i32, ptr %EAX, align 4
  %v1922 = load ptr, ptr %MEMORY, align 4
  %v1923 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1922, ptr %state, ptr %EAX, i32 %v1921, i32 2)
  store ptr %v1923, ptr %MEMORY, align 4
  store i32 %v1920, ptr %PC, align 4
  %v1924 = add i32 %v1920, 2
  store i32 %v1924, ptr %NEXT_PC, align 4
  %v1925 = load i32, ptr %EAX, align 4
  %v1926 = load i32, ptr %EBX, align 4
  %v1927 = load ptr, ptr %MEMORY, align 4
  %v1928 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1927, ptr %state, ptr %EAX, i32 %v1925, i32 %v1926)
  store ptr %v1928, ptr %MEMORY, align 4
  store i32 %v1924, ptr %PC, align 4
  %v1929 = add i32 %v1924, 3
  store i32 %v1929, ptr %NEXT_PC, align 4
  %v1930 = load i32, ptr %EAX, align 4
  %v1931 = load i32, ptr %DSBASE, align 4
  %v1932 = add i32 %v1930, 8
  %v1933 = add i32 %v1932, %v1931
  %v1934 = load ptr, ptr %MEMORY, align 4
  %v1935 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1934, ptr %state, ptr %EAX, i32 %v1933)
  store ptr %v1935, ptr %MEMORY, align 4
  store i32 %v1929, ptr %PC, align 4
  %v1936 = add i32 %v1929, 3
  store i32 %v1936, ptr %NEXT_PC, align 4
  %v1937 = load i32, ptr %EAX, align 4
  %v1938 = load i32, ptr %DSBASE, align 4
  %v1939 = add i32 %v1937, 8
  %v1940 = add i32 %v1939, %v1938
  %v1941 = load ptr, ptr %MEMORY, align 4
  %v1942 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1941, ptr %state, ptr %EAX, i32 %v1940)
  store ptr %v1942, ptr %MEMORY, align 4
  store i32 %v1936, ptr %PC, align 4
  %v1943 = add i32 %v1936, 2
  store i32 %v1943, ptr %NEXT_PC, align 4
  %v1944 = load i32, ptr %EAX, align 4
  %v1945 = load i32, ptr %ECX, align 4
  %v1946 = load ptr, ptr %MEMORY, align 4
  %v1947 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v1946, ptr %state, ptr %EAX, i32 %v1944, i32 %v1945)
  store ptr %v1947, ptr %MEMORY, align 4
  store i32 %v1943, ptr %PC, align 4
  %v1948 = add i32 %v1943, 3
  store i32 %v1948, ptr %NEXT_PC, align 4
  %v1949 = load i32, ptr %EAX, align 4
  %v1950 = load i32, ptr %EBP, align 4
  %v1951 = load i32, ptr %SSBASE, align 4
  %v1952 = add i32 %v1950, 8
  %v1953 = add i32 %v1952, %v1951
  %v1954 = load ptr, ptr %MEMORY, align 4
  %v1955 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1954, ptr %state, i32 %v1949, i32 %v1953)
  store ptr %v1955, ptr %MEMORY, align 4
  store i32 %v1948, ptr %PC, align 4
  %v1956 = add i32 %v1948, 6
  store i32 %v1956, ptr %NEXT_PC, align 4
  %v1957 = add i32 %v1956, 360
  %v1958 = load ptr, ptr %MEMORY, align 4
  %v1959 = call ptr @_ZN12_GLOBAL__N_14JNBEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1958, ptr %state, ptr %BRANCH_TAKEN, i32 %v1957, i32 %v1956, ptr %NEXT_PC)
  store ptr %v1959, ptr %MEMORY, align 4
  br i1 true, label %bb_4202640, label %bb_4202280

bb_4202280:                                       ; preds = %bb_4202220, %bb_4202192
  %v1960 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1960, ptr %PC, align 4
  %v1961 = add i32 %v1960, 4
  store i32 %v1961, ptr %NEXT_PC, align 4
  %v1962 = load i32, ptr %EBP, align 4
  %v1963 = load i32, ptr %SSBASE, align 4
  %v1964 = sub i32 %v1962, 12
  %v1965 = add i32 %v1964, %v1963
  %v1966 = load i32, ptr %EBP, align 4
  %v1967 = load i32, ptr %SSBASE, align 4
  %v1968 = sub i32 %v1966, 12
  %v1969 = add i32 %v1968, %v1967
  %v1970 = load ptr, ptr %MEMORY, align 4
  %v1971 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v1970, ptr %state, i32 %v1965, i32 %v1969, i32 1)
  store ptr %v1971, ptr %MEMORY, align 4
  br label %bb_4202284

bb_4202284:                                       ; preds = %bb_4202280, %bb_4201944
  %v1972 = load i32, ptr %NEXT_PC, align 4
  store i32 %v1972, ptr %PC, align 4
  %v1973 = add i32 %v1972, 5
  store i32 %v1973, ptr %NEXT_PC, align 4
  %v1974 = load i32, ptr %DSBASE, align 4
  %v1975 = add i32 4240292, %v1974
  %v1976 = load ptr, ptr %MEMORY, align 4
  %v1977 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1976, ptr %state, ptr %EAX, i32 %v1975)
  store ptr %v1977, ptr %MEMORY, align 4
  store i32 %v1973, ptr %PC, align 4
  %v1978 = add i32 %v1973, 3
  store i32 %v1978, ptr %NEXT_PC, align 4
  %v1979 = load i32, ptr %EBP, align 4
  %v1980 = load i32, ptr %SSBASE, align 4
  %v1981 = sub i32 %v1979, 12
  %v1982 = add i32 %v1981, %v1980
  %v1983 = load i32, ptr %EAX, align 4
  %v1984 = load ptr, ptr %MEMORY, align 4
  %v1985 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1984, ptr %state, i32 %v1982, i32 %v1983)
  store ptr %v1985, ptr %MEMORY, align 4
  store i32 %v1978, ptr %PC, align 4
  %v1986 = add i32 %v1978, 2
  store i32 %v1986, ptr %NEXT_PC, align 4
  %v1987 = sub i32 %v1986, 102
  %v1988 = load ptr, ptr %MEMORY, align 4
  %v1989 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v1988, ptr %state, ptr %BRANCH_TAKEN, i32 %v1987, i32 %v1986, ptr %NEXT_PC)
  store ptr %v1989, ptr %MEMORY, align 4
  br i1 true, label %bb_4202192, label %bb_4202294

bb_4202294:                                       ; preds = %bb_4202284
  store i32 %v1986, ptr %PC, align 4
  %v1990 = add i32 %v1986, 3
  store i32 %v1990, ptr %NEXT_PC, align 4
  %v1991 = load i32, ptr %EBP, align 4
  %v1992 = load i32, ptr %SSBASE, align 4
  %v1993 = add i32 %v1991, 8
  %v1994 = add i32 %v1993, %v1992
  %v1995 = load ptr, ptr %MEMORY, align 4
  %v1996 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v1995, ptr %state, ptr %EAX, i32 %v1994)
  store ptr %v1996, ptr %MEMORY, align 4
  store i32 %v1990, ptr %PC, align 4
  %v1997 = add i32 %v1990, 3
  store i32 %v1997, ptr %NEXT_PC, align 4
  %v1998 = load i32, ptr %ESP, align 4
  %v1999 = load i32, ptr %SSBASE, align 4
  %v2000 = add i32 %v1998, %v1999
  %v2001 = load i32, ptr %EAX, align 4
  %v2002 = load ptr, ptr %MEMORY, align 4
  %v2003 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2002, ptr %state, i32 %v2000, i32 %v2001)
  store ptr %v2003, ptr %MEMORY, align 4
  store i32 %v1997, ptr %PC, align 4
  %v2004 = add i32 %v1997, 5
  store i32 %v2004, ptr %NEXT_PC, align 4
  %v2005 = add i32 %v2004, 2137
  %v2006 = load ptr, ptr %MEMORY, align 4
  %v2007 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2006, ptr %state, i64 4204442, ptr %NEXT_PC, i32 %v2004, ptr %RETURN_PC)
  store ptr %v2007, ptr %MEMORY, align 4
  store i32 %v2004, ptr %PC, align 4
  %v2008 = add i32 %v2004, 3
  store i32 %v2008, ptr %NEXT_PC, align 4
  %v2009 = load i32, ptr %EBP, align 4
  %v2010 = load i32, ptr %SSBASE, align 4
  %v2011 = sub i32 %v2009, 16
  %v2012 = add i32 %v2011, %v2010
  %v2013 = load i32, ptr %EAX, align 4
  %v2014 = load ptr, ptr %MEMORY, align 4
  %v2015 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2014, ptr %state, i32 %v2012, i32 %v2013)
  store ptr %v2015, ptr %MEMORY, align 4
  store i32 %v2008, ptr %PC, align 4
  %v2016 = add i32 %v2008, 4
  store i32 %v2016, ptr %NEXT_PC, align 4
  %v2017 = load i32, ptr %EBP, align 4
  %v2018 = load i32, ptr %SSBASE, align 4
  %v2019 = sub i32 %v2017, 16
  %v2020 = add i32 %v2019, %v2018
  %v2021 = load ptr, ptr %MEMORY, align 4
  %v2022 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2021, ptr %state, i32 %v2020, i32 0)
  store ptr %v2022, ptr %MEMORY, align 4
  store i32 %v2016, ptr %PC, align 4
  %v2023 = add i32 %v2016, 2
  store i32 %v2023, ptr %NEXT_PC, align 4
  %v2024 = add i32 %v2023, 19
  %v2025 = load ptr, ptr %MEMORY, align 4
  %v2026 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2025, ptr %state, ptr %BRANCH_TAKEN, i32 %v2024, i32 %v2023, ptr %NEXT_PC)
  store ptr %v2026, ptr %MEMORY, align 4
  br i1 true, label %bb_4202333, label %bb_4202314

bb_4202314:                                       ; preds = %bb_4202294
  store i32 %v2023, ptr %PC, align 4
  %v2027 = add i32 %v2023, 3
  store i32 %v2027, ptr %NEXT_PC, align 4
  %v2028 = load i32, ptr %EBP, align 4
  %v2029 = load i32, ptr %SSBASE, align 4
  %v2030 = add i32 %v2028, 8
  %v2031 = add i32 %v2030, %v2029
  %v2032 = load ptr, ptr %MEMORY, align 4
  %v2033 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2032, ptr %state, ptr %EAX, i32 %v2031)
  store ptr %v2033, ptr %MEMORY, align 4
  store i32 %v2027, ptr %PC, align 4
  %v2034 = add i32 %v2027, 4
  store i32 %v2034, ptr %NEXT_PC, align 4
  %v2035 = load i32, ptr %ESP, align 4
  %v2036 = load i32, ptr %SSBASE, align 4
  %v2037 = add i32 %v2035, 4
  %v2038 = add i32 %v2037, %v2036
  %v2039 = load i32, ptr %EAX, align 4
  %v2040 = load ptr, ptr %MEMORY, align 4
  %v2041 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2040, ptr %state, i32 %v2038, i32 %v2039)
  store ptr %v2041, ptr %MEMORY, align 4
  store i32 %v2034, ptr %PC, align 4
  %v2042 = add i32 %v2034, 7
  store i32 %v2042, ptr %NEXT_PC, align 4
  %v2043 = load i32, ptr %ESP, align 4
  %v2044 = load i32, ptr %SSBASE, align 4
  %v2045 = add i32 %v2043, %v2044
  %v2046 = load ptr, ptr %MEMORY, align 4
  %v2047 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2046, ptr %state, i32 %v2045, i32 4235704)
  store ptr %v2047, ptr %MEMORY, align 4
  store i32 %v2042, ptr %PC, align 4
  %v2048 = add i32 %v2042, 5
  store i32 %v2048, ptr %NEXT_PC, align 4
  %v2049 = sub i32 %v2048, 229
  %v2050 = load ptr, ptr %MEMORY, align 4
  %v2051 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2050, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v2048, ptr %RETURN_PC)
  store ptr %v2051, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202333:                                       ; preds = %bb_4202294
  store i32 %v2023, ptr %PC, align 4
  %v2052 = add i32 %v2023, 6
  store i32 %v2052, ptr %NEXT_PC, align 4
  %v2053 = load i32, ptr %DSBASE, align 4
  %v2054 = add i32 4240288, %v2053
  %v2055 = load ptr, ptr %MEMORY, align 4
  %v2056 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2055, ptr %state, ptr %ECX, i32 %v2054)
  store ptr %v2056, ptr %MEMORY, align 4
  store i32 %v2052, ptr %PC, align 4
  %v2057 = add i32 %v2052, 3
  store i32 %v2057, ptr %NEXT_PC, align 4
  %v2058 = load i32, ptr %EBP, align 4
  %v2059 = load i32, ptr %SSBASE, align 4
  %v2060 = sub i32 %v2058, 12
  %v2061 = add i32 %v2060, %v2059
  %v2062 = load ptr, ptr %MEMORY, align 4
  %v2063 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2062, ptr %state, ptr %EDX, i32 %v2061)
  store ptr %v2063, ptr %MEMORY, align 4
  store i32 %v2057, ptr %PC, align 4
  %v2064 = add i32 %v2057, 2
  store i32 %v2064, ptr %NEXT_PC, align 4
  %v2065 = load i32, ptr %EDX, align 4
  %v2066 = load ptr, ptr %MEMORY, align 4
  %v2067 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2066, ptr %state, ptr %EAX, i32 %v2065)
  store ptr %v2067, ptr %MEMORY, align 4
  store i32 %v2064, ptr %PC, align 4
  %v2068 = add i32 %v2064, 2
  store i32 %v2068, ptr %NEXT_PC, align 4
  %v2069 = load i32, ptr %EAX, align 4
  %v2070 = load i32, ptr %EAX, align 4
  %v2071 = load ptr, ptr %MEMORY, align 4
  %v2072 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2071, ptr %state, ptr %EAX, i32 %v2069, i32 %v2070)
  store ptr %v2072, ptr %MEMORY, align 4
  store i32 %v2068, ptr %PC, align 4
  %v2073 = add i32 %v2068, 2
  store i32 %v2073, ptr %NEXT_PC, align 4
  %v2074 = load i32, ptr %EAX, align 4
  %v2075 = load i32, ptr %EDX, align 4
  %v2076 = load ptr, ptr %MEMORY, align 4
  %v2077 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2076, ptr %state, ptr %EAX, i32 %v2074, i32 %v2075)
  store ptr %v2077, ptr %MEMORY, align 4
  store i32 %v2073, ptr %PC, align 4
  %v2078 = add i32 %v2073, 3
  store i32 %v2078, ptr %NEXT_PC, align 4
  %v2079 = load i32, ptr %EAX, align 4
  %v2080 = load ptr, ptr %MEMORY, align 4
  %v2081 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2080, ptr %state, ptr %EAX, i32 %v2079, i32 2)
  store ptr %v2081, ptr %MEMORY, align 4
  store i32 %v2078, ptr %PC, align 4
  %v2082 = add i32 %v2078, 3
  store i32 %v2082, ptr %NEXT_PC, align 4
  %v2083 = load i32, ptr %ECX, align 4
  %v2084 = load i32, ptr %EAX, align 4
  %v2085 = mul i32 %v2084, 1
  %v2086 = add i32 %v2083, %v2085
  %v2087 = load ptr, ptr %MEMORY, align 4
  %v2088 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2087, ptr %state, ptr %EDX, i32 %v2086)
  store ptr %v2088, ptr %MEMORY, align 4
  store i32 %v2082, ptr %PC, align 4
  %v2089 = add i32 %v2082, 3
  store i32 %v2089, ptr %NEXT_PC, align 4
  %v2090 = load i32, ptr %EBP, align 4
  %v2091 = load i32, ptr %SSBASE, align 4
  %v2092 = sub i32 %v2090, 16
  %v2093 = add i32 %v2092, %v2091
  %v2094 = load ptr, ptr %MEMORY, align 4
  %v2095 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2094, ptr %state, ptr %EAX, i32 %v2093)
  store ptr %v2095, ptr %MEMORY, align 4
  store i32 %v2089, ptr %PC, align 4
  %v2096 = add i32 %v2089, 3
  store i32 %v2096, ptr %NEXT_PC, align 4
  %v2097 = load i32, ptr %EDX, align 4
  %v2098 = load i32, ptr %DSBASE, align 4
  %v2099 = add i32 %v2097, 8
  %v2100 = add i32 %v2099, %v2098
  %v2101 = load i32, ptr %EAX, align 4
  %v2102 = load ptr, ptr %MEMORY, align 4
  %v2103 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2102, ptr %state, i32 %v2100, i32 %v2101)
  store ptr %v2103, ptr %MEMORY, align 4
  store i32 %v2096, ptr %PC, align 4
  %v2104 = add i32 %v2096, 6
  store i32 %v2104, ptr %NEXT_PC, align 4
  %v2105 = load i32, ptr %DSBASE, align 4
  %v2106 = add i32 4240288, %v2105
  %v2107 = load ptr, ptr %MEMORY, align 4
  %v2108 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2107, ptr %state, ptr %ECX, i32 %v2106)
  store ptr %v2108, ptr %MEMORY, align 4
  store i32 %v2104, ptr %PC, align 4
  %v2109 = add i32 %v2104, 3
  store i32 %v2109, ptr %NEXT_PC, align 4
  %v2110 = load i32, ptr %EBP, align 4
  %v2111 = load i32, ptr %SSBASE, align 4
  %v2112 = sub i32 %v2110, 12
  %v2113 = add i32 %v2112, %v2111
  %v2114 = load ptr, ptr %MEMORY, align 4
  %v2115 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2114, ptr %state, ptr %EDX, i32 %v2113)
  store ptr %v2115, ptr %MEMORY, align 4
  store i32 %v2109, ptr %PC, align 4
  %v2116 = add i32 %v2109, 2
  store i32 %v2116, ptr %NEXT_PC, align 4
  %v2117 = load i32, ptr %EDX, align 4
  %v2118 = load ptr, ptr %MEMORY, align 4
  %v2119 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2118, ptr %state, ptr %EAX, i32 %v2117)
  store ptr %v2119, ptr %MEMORY, align 4
  store i32 %v2116, ptr %PC, align 4
  %v2120 = add i32 %v2116, 2
  store i32 %v2120, ptr %NEXT_PC, align 4
  %v2121 = load i32, ptr %EAX, align 4
  %v2122 = load i32, ptr %EAX, align 4
  %v2123 = load ptr, ptr %MEMORY, align 4
  %v2124 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2123, ptr %state, ptr %EAX, i32 %v2121, i32 %v2122)
  store ptr %v2124, ptr %MEMORY, align 4
  store i32 %v2120, ptr %PC, align 4
  %v2125 = add i32 %v2120, 2
  store i32 %v2125, ptr %NEXT_PC, align 4
  %v2126 = load i32, ptr %EAX, align 4
  %v2127 = load i32, ptr %EDX, align 4
  %v2128 = load ptr, ptr %MEMORY, align 4
  %v2129 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2128, ptr %state, ptr %EAX, i32 %v2126, i32 %v2127)
  store ptr %v2129, ptr %MEMORY, align 4
  store i32 %v2125, ptr %PC, align 4
  %v2130 = add i32 %v2125, 3
  store i32 %v2130, ptr %NEXT_PC, align 4
  %v2131 = load i32, ptr %EAX, align 4
  %v2132 = load ptr, ptr %MEMORY, align 4
  %v2133 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2132, ptr %state, ptr %EAX, i32 %v2131, i32 2)
  store ptr %v2133, ptr %MEMORY, align 4
  store i32 %v2130, ptr %PC, align 4
  %v2134 = add i32 %v2130, 2
  store i32 %v2134, ptr %NEXT_PC, align 4
  %v2135 = load i32, ptr %EAX, align 4
  %v2136 = load i32, ptr %ECX, align 4
  %v2137 = load ptr, ptr %MEMORY, align 4
  %v2138 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2137, ptr %state, ptr %EAX, i32 %v2135, i32 %v2136)
  store ptr %v2138, ptr %MEMORY, align 4
  store i32 %v2134, ptr %PC, align 4
  %v2139 = add i32 %v2134, 6
  store i32 %v2139, ptr %NEXT_PC, align 4
  %v2140 = load i32, ptr %EAX, align 4
  %v2141 = load i32, ptr %DSBASE, align 4
  %v2142 = add i32 %v2140, %v2141
  %v2143 = load ptr, ptr %MEMORY, align 4
  %v2144 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2143, ptr %state, i32 %v2142, i32 0)
  store ptr %v2144, ptr %MEMORY, align 4
  store i32 %v2139, ptr %PC, align 4
  %v2145 = add i32 %v2139, 6
  store i32 %v2145, ptr %NEXT_PC, align 4
  %v2146 = load i32, ptr %DSBASE, align 4
  %v2147 = add i32 4240288, %v2146
  %v2148 = load ptr, ptr %MEMORY, align 4
  %v2149 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2148, ptr %state, ptr %ECX, i32 %v2147)
  store ptr %v2149, ptr %MEMORY, align 4
  store i32 %v2145, ptr %PC, align 4
  %v2150 = add i32 %v2145, 3
  store i32 %v2150, ptr %NEXT_PC, align 4
  %v2151 = load i32, ptr %EBP, align 4
  %v2152 = load i32, ptr %SSBASE, align 4
  %v2153 = sub i32 %v2151, 12
  %v2154 = add i32 %v2153, %v2152
  %v2155 = load ptr, ptr %MEMORY, align 4
  %v2156 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2155, ptr %state, ptr %EDX, i32 %v2154)
  store ptr %v2156, ptr %MEMORY, align 4
  store i32 %v2150, ptr %PC, align 4
  %v2157 = add i32 %v2150, 2
  store i32 %v2157, ptr %NEXT_PC, align 4
  %v2158 = load i32, ptr %EDX, align 4
  %v2159 = load ptr, ptr %MEMORY, align 4
  %v2160 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2159, ptr %state, ptr %EAX, i32 %v2158)
  store ptr %v2160, ptr %MEMORY, align 4
  store i32 %v2157, ptr %PC, align 4
  %v2161 = add i32 %v2157, 2
  store i32 %v2161, ptr %NEXT_PC, align 4
  %v2162 = load i32, ptr %EAX, align 4
  %v2163 = load i32, ptr %EAX, align 4
  %v2164 = load ptr, ptr %MEMORY, align 4
  %v2165 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2164, ptr %state, ptr %EAX, i32 %v2162, i32 %v2163)
  store ptr %v2165, ptr %MEMORY, align 4
  store i32 %v2161, ptr %PC, align 4
  %v2166 = add i32 %v2161, 2
  store i32 %v2166, ptr %NEXT_PC, align 4
  %v2167 = load i32, ptr %EAX, align 4
  %v2168 = load i32, ptr %EDX, align 4
  %v2169 = load ptr, ptr %MEMORY, align 4
  %v2170 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2169, ptr %state, ptr %EAX, i32 %v2167, i32 %v2168)
  store ptr %v2170, ptr %MEMORY, align 4
  store i32 %v2166, ptr %PC, align 4
  %v2171 = add i32 %v2166, 3
  store i32 %v2171, ptr %NEXT_PC, align 4
  %v2172 = load i32, ptr %EAX, align 4
  %v2173 = load ptr, ptr %MEMORY, align 4
  %v2174 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2173, ptr %state, ptr %EAX, i32 %v2172, i32 2)
  store ptr %v2174, ptr %MEMORY, align 4
  store i32 %v2171, ptr %PC, align 4
  %v2175 = add i32 %v2171, 3
  store i32 %v2175, ptr %NEXT_PC, align 4
  %v2176 = load i32, ptr %ECX, align 4
  %v2177 = load i32, ptr %EAX, align 4
  %v2178 = mul i32 %v2177, 1
  %v2179 = add i32 %v2176, %v2178
  %v2180 = load ptr, ptr %MEMORY, align 4
  %v2181 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2180, ptr %state, ptr %EBX, i32 %v2179)
  store ptr %v2181, ptr %MEMORY, align 4
  store i32 %v2175, ptr %PC, align 4
  %v2182 = add i32 %v2175, 5
  store i32 %v2182, ptr %NEXT_PC, align 4
  %v2183 = add i32 %v2182, 2304
  %v2184 = load ptr, ptr %MEMORY, align 4
  %v2185 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2184, ptr %state, i64 4204716, ptr %NEXT_PC, i32 %v2182, ptr %RETURN_PC)
  store ptr %v2185, ptr %MEMORY, align 4
  store i32 %v2182, ptr %PC, align 4
  %v2186 = add i32 %v2182, 3
  store i32 %v2186, ptr %NEXT_PC, align 4
  %v2187 = load i32, ptr %EBP, align 4
  %v2188 = load i32, ptr %SSBASE, align 4
  %v2189 = sub i32 %v2187, 16
  %v2190 = add i32 %v2189, %v2188
  %v2191 = load ptr, ptr %MEMORY, align 4
  %v2192 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2191, ptr %state, ptr %EDX, i32 %v2190)
  store ptr %v2192, ptr %MEMORY, align 4
  store i32 %v2186, ptr %PC, align 4
  %v2193 = add i32 %v2186, 3
  store i32 %v2193, ptr %NEXT_PC, align 4
  %v2194 = load i32, ptr %EDX, align 4
  %v2195 = load i32, ptr %DSBASE, align 4
  %v2196 = add i32 %v2194, 12
  %v2197 = add i32 %v2196, %v2195
  %v2198 = load ptr, ptr %MEMORY, align 4
  %v2199 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2198, ptr %state, ptr %EDX, i32 %v2197)
  store ptr %v2199, ptr %MEMORY, align 4
  store i32 %v2193, ptr %PC, align 4
  %v2200 = add i32 %v2193, 2
  store i32 %v2200, ptr %NEXT_PC, align 4
  %v2201 = load i32, ptr %EAX, align 4
  %v2202 = load i32, ptr %EDX, align 4
  %v2203 = load ptr, ptr %MEMORY, align 4
  %v2204 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2203, ptr %state, ptr %EAX, i32 %v2201, i32 %v2202)
  store ptr %v2204, ptr %MEMORY, align 4
  store i32 %v2200, ptr %PC, align 4
  %v2205 = add i32 %v2200, 3
  store i32 %v2205, ptr %NEXT_PC, align 4
  %v2206 = load i32, ptr %EBX, align 4
  %v2207 = load i32, ptr %DSBASE, align 4
  %v2208 = add i32 %v2206, 4
  %v2209 = add i32 %v2208, %v2207
  %v2210 = load i32, ptr %EAX, align 4
  %v2211 = load ptr, ptr %MEMORY, align 4
  %v2212 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2211, ptr %state, i32 %v2209, i32 %v2210)
  store ptr %v2212, ptr %MEMORY, align 4
  store i32 %v2205, ptr %PC, align 4
  %v2213 = add i32 %v2205, 6
  store i32 %v2213, ptr %NEXT_PC, align 4
  %v2214 = load i32, ptr %DSBASE, align 4
  %v2215 = add i32 4240288, %v2214
  %v2216 = load ptr, ptr %MEMORY, align 4
  %v2217 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2216, ptr %state, ptr %ECX, i32 %v2215)
  store ptr %v2217, ptr %MEMORY, align 4
  store i32 %v2213, ptr %PC, align 4
  %v2218 = add i32 %v2213, 3
  store i32 %v2218, ptr %NEXT_PC, align 4
  %v2219 = load i32, ptr %EBP, align 4
  %v2220 = load i32, ptr %SSBASE, align 4
  %v2221 = sub i32 %v2219, 12
  %v2222 = add i32 %v2221, %v2220
  %v2223 = load ptr, ptr %MEMORY, align 4
  %v2224 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2223, ptr %state, ptr %EDX, i32 %v2222)
  store ptr %v2224, ptr %MEMORY, align 4
  store i32 %v2218, ptr %PC, align 4
  %v2225 = add i32 %v2218, 2
  store i32 %v2225, ptr %NEXT_PC, align 4
  %v2226 = load i32, ptr %EDX, align 4
  %v2227 = load ptr, ptr %MEMORY, align 4
  %v2228 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2227, ptr %state, ptr %EAX, i32 %v2226)
  store ptr %v2228, ptr %MEMORY, align 4
  store i32 %v2225, ptr %PC, align 4
  %v2229 = add i32 %v2225, 2
  store i32 %v2229, ptr %NEXT_PC, align 4
  %v2230 = load i32, ptr %EAX, align 4
  %v2231 = load i32, ptr %EAX, align 4
  %v2232 = load ptr, ptr %MEMORY, align 4
  %v2233 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2232, ptr %state, ptr %EAX, i32 %v2230, i32 %v2231)
  store ptr %v2233, ptr %MEMORY, align 4
  store i32 %v2229, ptr %PC, align 4
  %v2234 = add i32 %v2229, 2
  store i32 %v2234, ptr %NEXT_PC, align 4
  %v2235 = load i32, ptr %EAX, align 4
  %v2236 = load i32, ptr %EDX, align 4
  %v2237 = load ptr, ptr %MEMORY, align 4
  %v2238 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2237, ptr %state, ptr %EAX, i32 %v2235, i32 %v2236)
  store ptr %v2238, ptr %MEMORY, align 4
  store i32 %v2234, ptr %PC, align 4
  %v2239 = add i32 %v2234, 3
  store i32 %v2239, ptr %NEXT_PC, align 4
  %v2240 = load i32, ptr %EAX, align 4
  %v2241 = load ptr, ptr %MEMORY, align 4
  %v2242 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2241, ptr %state, ptr %EAX, i32 %v2240, i32 2)
  store ptr %v2242, ptr %MEMORY, align 4
  store i32 %v2239, ptr %PC, align 4
  %v2243 = add i32 %v2239, 2
  store i32 %v2243, ptr %NEXT_PC, align 4
  %v2244 = load i32, ptr %EAX, align 4
  %v2245 = load i32, ptr %ECX, align 4
  %v2246 = load ptr, ptr %MEMORY, align 4
  %v2247 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2246, ptr %state, ptr %EAX, i32 %v2244, i32 %v2245)
  store ptr %v2247, ptr %MEMORY, align 4
  store i32 %v2243, ptr %PC, align 4
  %v2248 = add i32 %v2243, 3
  store i32 %v2248, ptr %NEXT_PC, align 4
  %v2249 = load i32, ptr %EAX, align 4
  %v2250 = load i32, ptr %DSBASE, align 4
  %v2251 = add i32 %v2249, 4
  %v2252 = add i32 %v2251, %v2250
  %v2253 = load ptr, ptr %MEMORY, align 4
  %v2254 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2253, ptr %state, ptr %EAX, i32 %v2252)
  store ptr %v2254, ptr %MEMORY, align 4
  store i32 %v2248, ptr %PC, align 4
  %v2255 = add i32 %v2248, 8
  store i32 %v2255, ptr %NEXT_PC, align 4
  %v2256 = load i32, ptr %ESP, align 4
  %v2257 = load i32, ptr %SSBASE, align 4
  %v2258 = add i32 %v2256, 8
  %v2259 = add i32 %v2258, %v2257
  %v2260 = load ptr, ptr %MEMORY, align 4
  %v2261 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2260, ptr %state, i32 %v2259, i32 28)
  store ptr %v2261, ptr %MEMORY, align 4
  store i32 %v2255, ptr %PC, align 4
  %v2262 = add i32 %v2255, 3
  store i32 %v2262, ptr %NEXT_PC, align 4
  %v2263 = load i32, ptr %EBP, align 4
  %v2264 = sub i32 %v2263, 44
  %v2265 = load ptr, ptr %MEMORY, align 4
  %v2266 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2265, ptr %state, ptr %EDX, i32 %v2264)
  store ptr %v2266, ptr %MEMORY, align 4
  store i32 %v2262, ptr %PC, align 4
  %v2267 = add i32 %v2262, 4
  store i32 %v2267, ptr %NEXT_PC, align 4
  %v2268 = load i32, ptr %ESP, align 4
  %v2269 = load i32, ptr %SSBASE, align 4
  %v2270 = add i32 %v2268, 4
  %v2271 = add i32 %v2270, %v2269
  %v2272 = load i32, ptr %EDX, align 4
  %v2273 = load ptr, ptr %MEMORY, align 4
  %v2274 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2273, ptr %state, i32 %v2271, i32 %v2272)
  store ptr %v2274, ptr %MEMORY, align 4
  store i32 %v2267, ptr %PC, align 4
  %v2275 = add i32 %v2267, 3
  store i32 %v2275, ptr %NEXT_PC, align 4
  %v2276 = load i32, ptr %ESP, align 4
  %v2277 = load i32, ptr %SSBASE, align 4
  %v2278 = add i32 %v2276, %v2277
  %v2279 = load i32, ptr %EAX, align 4
  %v2280 = load ptr, ptr %MEMORY, align 4
  %v2281 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2280, ptr %state, i32 %v2278, i32 %v2279)
  store ptr %v2281, ptr %MEMORY, align 4
  store i32 %v2275, ptr %PC, align 4
  %v2282 = add i32 %v2275, 5
  store i32 %v2282, ptr %NEXT_PC, align 4
  %v2283 = load i32, ptr %DSBASE, align 4
  %v2284 = add i32 4243884, %v2283
  %v2285 = load ptr, ptr %MEMORY, align 4
  %v2286 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2285, ptr %state, ptr %EAX, i32 %v2284)
  store ptr %v2286, ptr %MEMORY, align 4
  store i32 %v2282, ptr %PC, align 4
  %v2287 = add i32 %v2282, 2
  store i32 %v2287, ptr %NEXT_PC, align 4
  %v2288 = load i32, ptr %EAX, align 4
  %v2289 = load ptr, ptr %MEMORY, align 4
  %v2290 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2289, ptr %state, i32 %v2288, ptr %NEXT_PC, i32 %v2287, ptr %RETURN_PC)
  store ptr %v2290, ptr %MEMORY, align 4
  store i32 %v2287, ptr %PC, align 4
  %v2291 = add i32 %v2287, 3
  store i32 %v2291, ptr %NEXT_PC, align 4
  %v2292 = load i32, ptr %ESP, align 4
  %v2293 = load ptr, ptr %MEMORY, align 4
  %v2294 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2293, ptr %state, ptr %ESP, i32 %v2292, i32 12)
  store ptr %v2294, ptr %MEMORY, align 4
  store i32 %v2291, ptr %PC, align 4
  %v2295 = add i32 %v2291, 2
  store i32 %v2295, ptr %NEXT_PC, align 4
  %v2296 = load i32, ptr %EAX, align 4
  %v2297 = load i32, ptr %EAX, align 4
  %v2298 = load ptr, ptr %MEMORY, align 4
  %v2299 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2298, ptr %state, i32 %v2296, i32 %v2297)
  store ptr %v2299, ptr %MEMORY, align 4
  store i32 %v2295, ptr %PC, align 4
  %v2300 = add i32 %v2295, 2
  store i32 %v2300, ptr %NEXT_PC, align 4
  %v2301 = add i32 %v2300, 49
  %v2302 = load ptr, ptr %MEMORY, align 4
  %v2303 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2302, ptr %state, ptr %BRANCH_TAKEN, i32 %v2301, i32 %v2300, ptr %NEXT_PC)
  store ptr %v2303, ptr %MEMORY, align 4
  br i1 true, label %bb_4202527, label %bb_4202478

bb_4202478:                                       ; preds = %bb_4202333
  store i32 %v2300, ptr %PC, align 4
  %v2304 = add i32 %v2300, 6
  store i32 %v2304, ptr %NEXT_PC, align 4
  %v2305 = load i32, ptr %DSBASE, align 4
  %v2306 = add i32 4240288, %v2305
  %v2307 = load ptr, ptr %MEMORY, align 4
  %v2308 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2307, ptr %state, ptr %ECX, i32 %v2306)
  store ptr %v2308, ptr %MEMORY, align 4
  store i32 %v2304, ptr %PC, align 4
  %v2309 = add i32 %v2304, 3
  store i32 %v2309, ptr %NEXT_PC, align 4
  %v2310 = load i32, ptr %EBP, align 4
  %v2311 = load i32, ptr %SSBASE, align 4
  %v2312 = sub i32 %v2310, 12
  %v2313 = add i32 %v2312, %v2311
  %v2314 = load ptr, ptr %MEMORY, align 4
  %v2315 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2314, ptr %state, ptr %EDX, i32 %v2313)
  store ptr %v2315, ptr %MEMORY, align 4
  store i32 %v2309, ptr %PC, align 4
  %v2316 = add i32 %v2309, 2
  store i32 %v2316, ptr %NEXT_PC, align 4
  %v2317 = load i32, ptr %EDX, align 4
  %v2318 = load ptr, ptr %MEMORY, align 4
  %v2319 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2318, ptr %state, ptr %EAX, i32 %v2317)
  store ptr %v2319, ptr %MEMORY, align 4
  store i32 %v2316, ptr %PC, align 4
  %v2320 = add i32 %v2316, 2
  store i32 %v2320, ptr %NEXT_PC, align 4
  %v2321 = load i32, ptr %EAX, align 4
  %v2322 = load i32, ptr %EAX, align 4
  %v2323 = load ptr, ptr %MEMORY, align 4
  %v2324 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2323, ptr %state, ptr %EAX, i32 %v2321, i32 %v2322)
  store ptr %v2324, ptr %MEMORY, align 4
  store i32 %v2320, ptr %PC, align 4
  %v2325 = add i32 %v2320, 2
  store i32 %v2325, ptr %NEXT_PC, align 4
  %v2326 = load i32, ptr %EAX, align 4
  %v2327 = load i32, ptr %EDX, align 4
  %v2328 = load ptr, ptr %MEMORY, align 4
  %v2329 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2328, ptr %state, ptr %EAX, i32 %v2326, i32 %v2327)
  store ptr %v2329, ptr %MEMORY, align 4
  store i32 %v2325, ptr %PC, align 4
  %v2330 = add i32 %v2325, 3
  store i32 %v2330, ptr %NEXT_PC, align 4
  %v2331 = load i32, ptr %EAX, align 4
  %v2332 = load ptr, ptr %MEMORY, align 4
  %v2333 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2332, ptr %state, ptr %EAX, i32 %v2331, i32 2)
  store ptr %v2333, ptr %MEMORY, align 4
  store i32 %v2330, ptr %PC, align 4
  %v2334 = add i32 %v2330, 2
  store i32 %v2334, ptr %NEXT_PC, align 4
  %v2335 = load i32, ptr %EAX, align 4
  %v2336 = load i32, ptr %ECX, align 4
  %v2337 = load ptr, ptr %MEMORY, align 4
  %v2338 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2337, ptr %state, ptr %EAX, i32 %v2335, i32 %v2336)
  store ptr %v2338, ptr %MEMORY, align 4
  store i32 %v2334, ptr %PC, align 4
  %v2339 = add i32 %v2334, 3
  store i32 %v2339, ptr %NEXT_PC, align 4
  %v2340 = load i32, ptr %EAX, align 4
  %v2341 = load i32, ptr %DSBASE, align 4
  %v2342 = add i32 %v2340, 4
  %v2343 = add i32 %v2342, %v2341
  %v2344 = load ptr, ptr %MEMORY, align 4
  %v2345 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2344, ptr %state, ptr %EDX, i32 %v2343)
  store ptr %v2345, ptr %MEMORY, align 4
  store i32 %v2339, ptr %PC, align 4
  %v2346 = add i32 %v2339, 3
  store i32 %v2346, ptr %NEXT_PC, align 4
  %v2347 = load i32, ptr %EBP, align 4
  %v2348 = load i32, ptr %SSBASE, align 4
  %v2349 = sub i32 %v2347, 16
  %v2350 = add i32 %v2349, %v2348
  %v2351 = load ptr, ptr %MEMORY, align 4
  %v2352 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2351, ptr %state, ptr %EAX, i32 %v2350)
  store ptr %v2352, ptr %MEMORY, align 4
  store i32 %v2346, ptr %PC, align 4
  %v2353 = add i32 %v2346, 3
  store i32 %v2353, ptr %NEXT_PC, align 4
  %v2354 = load i32, ptr %EAX, align 4
  %v2355 = load i32, ptr %DSBASE, align 4
  %v2356 = add i32 %v2354, 8
  %v2357 = add i32 %v2356, %v2355
  %v2358 = load ptr, ptr %MEMORY, align 4
  %v2359 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2358, ptr %state, ptr %EAX, i32 %v2357)
  store ptr %v2359, ptr %MEMORY, align 4
  store i32 %v2353, ptr %PC, align 4
  %v2360 = add i32 %v2353, 4
  store i32 %v2360, ptr %NEXT_PC, align 4
  %v2361 = load i32, ptr %ESP, align 4
  %v2362 = load i32, ptr %SSBASE, align 4
  %v2363 = add i32 %v2361, 8
  %v2364 = add i32 %v2363, %v2362
  %v2365 = load i32, ptr %EDX, align 4
  %v2366 = load ptr, ptr %MEMORY, align 4
  %v2367 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2366, ptr %state, i32 %v2364, i32 %v2365)
  store ptr %v2367, ptr %MEMORY, align 4
  store i32 %v2360, ptr %PC, align 4
  %v2368 = add i32 %v2360, 4
  store i32 %v2368, ptr %NEXT_PC, align 4
  %v2369 = load i32, ptr %ESP, align 4
  %v2370 = load i32, ptr %SSBASE, align 4
  %v2371 = add i32 %v2369, 4
  %v2372 = add i32 %v2371, %v2370
  %v2373 = load i32, ptr %EAX, align 4
  %v2374 = load ptr, ptr %MEMORY, align 4
  %v2375 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2374, ptr %state, i32 %v2372, i32 %v2373)
  store ptr %v2375, ptr %MEMORY, align 4
  store i32 %v2368, ptr %PC, align 4
  %v2376 = add i32 %v2368, 7
  store i32 %v2376, ptr %NEXT_PC, align 4
  %v2377 = load i32, ptr %ESP, align 4
  %v2378 = load i32, ptr %SSBASE, align 4
  %v2379 = add i32 %v2377, %v2378
  %v2380 = load ptr, ptr %MEMORY, align 4
  %v2381 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2380, ptr %state, i32 %v2379, i32 4235736)
  store ptr %v2381, ptr %MEMORY, align 4
  store i32 %v2376, ptr %PC, align 4
  %v2382 = add i32 %v2376, 5
  store i32 %v2382, ptr %NEXT_PC, align 4
  %v2383 = sub i32 %v2382, 423
  %v2384 = load ptr, ptr %MEMORY, align 4
  %v2385 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2384, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v2382, ptr %RETURN_PC)
  store ptr %v2385, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202527:                                       ; preds = %bb_4202333
  store i32 %v2300, ptr %PC, align 4
  %v2386 = add i32 %v2300, 3
  store i32 %v2386, ptr %NEXT_PC, align 4
  %v2387 = load i32, ptr %EBP, align 4
  %v2388 = load i32, ptr %SSBASE, align 4
  %v2389 = sub i32 %v2387, 24
  %v2390 = add i32 %v2389, %v2388
  %v2391 = load ptr, ptr %MEMORY, align 4
  %v2392 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2391, ptr %state, ptr %EAX, i32 %v2390)
  store ptr %v2392, ptr %MEMORY, align 4
  store i32 %v2386, ptr %PC, align 4
  %v2393 = add i32 %v2386, 3
  store i32 %v2393, ptr %NEXT_PC, align 4
  %v2394 = load i32, ptr %EAX, align 4
  %v2395 = load ptr, ptr %MEMORY, align 4
  %v2396 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2395, ptr %state, i32 %v2394, i32 64)
  store ptr %v2396, ptr %MEMORY, align 4
  store i32 %v2393, ptr %PC, align 4
  %v2397 = add i32 %v2393, 2
  store i32 %v2397, ptr %NEXT_PC, align 4
  %v2398 = add i32 %v2397, 92
  %v2399 = load ptr, ptr %MEMORY, align 4
  %v2400 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2399, ptr %state, ptr %BRANCH_TAKEN, i32 %v2398, i32 %v2397, ptr %NEXT_PC)
  store ptr %v2400, ptr %MEMORY, align 4
  br i1 true, label %bb_4202627, label %bb_4202535

bb_4202535:                                       ; preds = %bb_4202527
  store i32 %v2397, ptr %PC, align 4
  %v2401 = add i32 %v2397, 3
  store i32 %v2401, ptr %NEXT_PC, align 4
  %v2402 = load i32, ptr %EBP, align 4
  %v2403 = load i32, ptr %SSBASE, align 4
  %v2404 = sub i32 %v2402, 24
  %v2405 = add i32 %v2404, %v2403
  %v2406 = load ptr, ptr %MEMORY, align 4
  %v2407 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2406, ptr %state, ptr %EAX, i32 %v2405)
  store ptr %v2407, ptr %MEMORY, align 4
  store i32 %v2401, ptr %PC, align 4
  %v2408 = add i32 %v2401, 3
  store i32 %v2408, ptr %NEXT_PC, align 4
  %v2409 = load i32, ptr %EAX, align 4
  %v2410 = load ptr, ptr %MEMORY, align 4
  %v2411 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2410, ptr %state, i32 %v2409, i32 4)
  store ptr %v2411, ptr %MEMORY, align 4
  store i32 %v2408, ptr %PC, align 4
  %v2412 = add i32 %v2408, 2
  store i32 %v2412, ptr %NEXT_PC, align 4
  %v2413 = add i32 %v2412, 84
  %v2414 = load ptr, ptr %MEMORY, align 4
  %v2415 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2414, ptr %state, ptr %BRANCH_TAKEN, i32 %v2413, i32 %v2412, ptr %NEXT_PC)
  store ptr %v2415, ptr %MEMORY, align 4
  br i1 true, label %bb_4202627, label %bb_4202543

bb_4202543:                                       ; preds = %bb_4202535
  store i32 %v2412, ptr %PC, align 4
  %v2416 = add i32 %v2412, 6
  store i32 %v2416, ptr %NEXT_PC, align 4
  %v2417 = load i32, ptr %DSBASE, align 4
  %v2418 = add i32 4240288, %v2417
  %v2419 = load ptr, ptr %MEMORY, align 4
  %v2420 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2419, ptr %state, ptr %ECX, i32 %v2418)
  store ptr %v2420, ptr %MEMORY, align 4
  store i32 %v2416, ptr %PC, align 4
  %v2421 = add i32 %v2416, 3
  store i32 %v2421, ptr %NEXT_PC, align 4
  %v2422 = load i32, ptr %EBP, align 4
  %v2423 = load i32, ptr %SSBASE, align 4
  %v2424 = sub i32 %v2422, 12
  %v2425 = add i32 %v2424, %v2423
  %v2426 = load ptr, ptr %MEMORY, align 4
  %v2427 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2426, ptr %state, ptr %EDX, i32 %v2425)
  store ptr %v2427, ptr %MEMORY, align 4
  store i32 %v2421, ptr %PC, align 4
  %v2428 = add i32 %v2421, 2
  store i32 %v2428, ptr %NEXT_PC, align 4
  %v2429 = load i32, ptr %EDX, align 4
  %v2430 = load ptr, ptr %MEMORY, align 4
  %v2431 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2430, ptr %state, ptr %EAX, i32 %v2429)
  store ptr %v2431, ptr %MEMORY, align 4
  store i32 %v2428, ptr %PC, align 4
  %v2432 = add i32 %v2428, 2
  store i32 %v2432, ptr %NEXT_PC, align 4
  %v2433 = load i32, ptr %EAX, align 4
  %v2434 = load i32, ptr %EAX, align 4
  %v2435 = load ptr, ptr %MEMORY, align 4
  %v2436 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2435, ptr %state, ptr %EAX, i32 %v2433, i32 %v2434)
  store ptr %v2436, ptr %MEMORY, align 4
  store i32 %v2432, ptr %PC, align 4
  %v2437 = add i32 %v2432, 2
  store i32 %v2437, ptr %NEXT_PC, align 4
  %v2438 = load i32, ptr %EAX, align 4
  %v2439 = load i32, ptr %EDX, align 4
  %v2440 = load ptr, ptr %MEMORY, align 4
  %v2441 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2440, ptr %state, ptr %EAX, i32 %v2438, i32 %v2439)
  store ptr %v2441, ptr %MEMORY, align 4
  store i32 %v2437, ptr %PC, align 4
  %v2442 = add i32 %v2437, 3
  store i32 %v2442, ptr %NEXT_PC, align 4
  %v2443 = load i32, ptr %EAX, align 4
  %v2444 = load ptr, ptr %MEMORY, align 4
  %v2445 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2444, ptr %state, ptr %EAX, i32 %v2443, i32 2)
  store ptr %v2445, ptr %MEMORY, align 4
  store i32 %v2442, ptr %PC, align 4
  %v2446 = add i32 %v2442, 2
  store i32 %v2446, ptr %NEXT_PC, align 4
  %v2447 = load i32, ptr %EAX, align 4
  %v2448 = load i32, ptr %ECX, align 4
  %v2449 = load ptr, ptr %MEMORY, align 4
  %v2450 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2449, ptr %state, ptr %EAX, i32 %v2447, i32 %v2448)
  store ptr %v2450, ptr %MEMORY, align 4
  store i32 %v2446, ptr %PC, align 4
  %v2451 = add i32 %v2446, 2
  store i32 %v2451, ptr %NEXT_PC, align 4
  %v2452 = load i32, ptr %EAX, align 4
  %v2453 = load ptr, ptr %MEMORY, align 4
  %v2454 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2453, ptr %state, ptr %ECX, i32 %v2452)
  store ptr %v2454, ptr %MEMORY, align 4
  store i32 %v2451, ptr %PC, align 4
  %v2455 = add i32 %v2451, 3
  store i32 %v2455, ptr %NEXT_PC, align 4
  %v2456 = load i32, ptr %EBP, align 4
  %v2457 = load i32, ptr %SSBASE, align 4
  %v2458 = sub i32 %v2456, 32
  %v2459 = add i32 %v2458, %v2457
  %v2460 = load ptr, ptr %MEMORY, align 4
  %v2461 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2460, ptr %state, ptr %EDX, i32 %v2459)
  store ptr %v2461, ptr %MEMORY, align 4
  store i32 %v2455, ptr %PC, align 4
  %v2462 = add i32 %v2455, 3
  store i32 %v2462, ptr %NEXT_PC, align 4
  %v2463 = load i32, ptr %EBP, align 4
  %v2464 = load i32, ptr %SSBASE, align 4
  %v2465 = sub i32 %v2463, 44
  %v2466 = add i32 %v2465, %v2464
  %v2467 = load ptr, ptr %MEMORY, align 4
  %v2468 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2467, ptr %state, ptr %EAX, i32 %v2466)
  store ptr %v2468, ptr %MEMORY, align 4
  store i32 %v2462, ptr %PC, align 4
  %v2469 = add i32 %v2462, 4
  store i32 %v2469, ptr %NEXT_PC, align 4
  %v2470 = load i32, ptr %ESP, align 4
  %v2471 = load i32, ptr %SSBASE, align 4
  %v2472 = add i32 %v2470, 12
  %v2473 = add i32 %v2472, %v2471
  %v2474 = load i32, ptr %ECX, align 4
  %v2475 = load ptr, ptr %MEMORY, align 4
  %v2476 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2475, ptr %state, i32 %v2473, i32 %v2474)
  store ptr %v2476, ptr %MEMORY, align 4
  store i32 %v2469, ptr %PC, align 4
  %v2477 = add i32 %v2469, 8
  store i32 %v2477, ptr %NEXT_PC, align 4
  %v2478 = load i32, ptr %ESP, align 4
  %v2479 = load i32, ptr %SSBASE, align 4
  %v2480 = add i32 %v2478, 8
  %v2481 = add i32 %v2480, %v2479
  %v2482 = load ptr, ptr %MEMORY, align 4
  %v2483 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2482, ptr %state, i32 %v2481, i32 64)
  store ptr %v2483, ptr %MEMORY, align 4
  store i32 %v2477, ptr %PC, align 4
  %v2484 = add i32 %v2477, 4
  store i32 %v2484, ptr %NEXT_PC, align 4
  %v2485 = load i32, ptr %ESP, align 4
  %v2486 = load i32, ptr %SSBASE, align 4
  %v2487 = add i32 %v2485, 4
  %v2488 = add i32 %v2487, %v2486
  %v2489 = load i32, ptr %EDX, align 4
  %v2490 = load ptr, ptr %MEMORY, align 4
  %v2491 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2490, ptr %state, i32 %v2488, i32 %v2489)
  store ptr %v2491, ptr %MEMORY, align 4
  store i32 %v2484, ptr %PC, align 4
  %v2492 = add i32 %v2484, 3
  store i32 %v2492, ptr %NEXT_PC, align 4
  %v2493 = load i32, ptr %ESP, align 4
  %v2494 = load i32, ptr %SSBASE, align 4
  %v2495 = add i32 %v2493, %v2494
  %v2496 = load i32, ptr %EAX, align 4
  %v2497 = load ptr, ptr %MEMORY, align 4
  %v2498 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2497, ptr %state, i32 %v2495, i32 %v2496)
  store ptr %v2498, ptr %MEMORY, align 4
  store i32 %v2492, ptr %PC, align 4
  %v2499 = add i32 %v2492, 5
  store i32 %v2499, ptr %NEXT_PC, align 4
  %v2500 = load i32, ptr %DSBASE, align 4
  %v2501 = add i32 4243880, %v2500
  %v2502 = load ptr, ptr %MEMORY, align 4
  %v2503 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2502, ptr %state, ptr %EAX, i32 %v2501)
  store ptr %v2503, ptr %MEMORY, align 4
  store i32 %v2499, ptr %PC, align 4
  %v2504 = add i32 %v2499, 2
  store i32 %v2504, ptr %NEXT_PC, align 4
  %v2505 = load i32, ptr %EAX, align 4
  %v2506 = load ptr, ptr %MEMORY, align 4
  %v2507 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2506, ptr %state, i32 %v2505, ptr %NEXT_PC, i32 %v2504, ptr %RETURN_PC)
  store ptr %v2507, ptr %MEMORY, align 4
  store i32 %v2504, ptr %PC, align 4
  %v2508 = add i32 %v2504, 3
  store i32 %v2508, ptr %NEXT_PC, align 4
  %v2509 = load i32, ptr %ESP, align 4
  %v2510 = load ptr, ptr %MEMORY, align 4
  %v2511 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2510, ptr %state, ptr %ESP, i32 %v2509, i32 16)
  store ptr %v2511, ptr %MEMORY, align 4
  store i32 %v2508, ptr %PC, align 4
  %v2512 = add i32 %v2508, 2
  store i32 %v2512, ptr %NEXT_PC, align 4
  %v2513 = load i32, ptr %EAX, align 4
  %v2514 = load i32, ptr %EAX, align 4
  %v2515 = load ptr, ptr %MEMORY, align 4
  %v2516 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2515, ptr %state, i32 %v2513, i32 %v2514)
  store ptr %v2516, ptr %MEMORY, align 4
  store i32 %v2512, ptr %PC, align 4
  %v2517 = add i32 %v2512, 2
  store i32 %v2517, ptr %NEXT_PC, align 4
  %v2518 = add i32 %v2517, 23
  %v2519 = load ptr, ptr %MEMORY, align 4
  %v2520 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2519, ptr %state, ptr %BRANCH_TAKEN, i32 %v2518, i32 %v2517, ptr %NEXT_PC)
  store ptr %v2520, ptr %MEMORY, align 4
  br i1 true, label %bb_4202627, label %bb_4202604

bb_4202604:                                       ; preds = %bb_4202543
  store i32 %v2517, ptr %PC, align 4
  %v2521 = add i32 %v2517, 5
  store i32 %v2521, ptr %NEXT_PC, align 4
  %v2522 = load i32, ptr %DSBASE, align 4
  %v2523 = add i32 4243808, %v2522
  %v2524 = load ptr, ptr %MEMORY, align 4
  %v2525 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2524, ptr %state, ptr %EAX, i32 %v2523)
  store ptr %v2525, ptr %MEMORY, align 4
  store i32 %v2521, ptr %PC, align 4
  %v2526 = add i32 %v2521, 2
  store i32 %v2526, ptr %NEXT_PC, align 4
  %v2527 = load i32, ptr %EAX, align 4
  %v2528 = load ptr, ptr %MEMORY, align 4
  %v2529 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2528, ptr %state, i32 %v2527, ptr %NEXT_PC, i32 %v2526, ptr %RETURN_PC)
  store ptr %v2529, ptr %MEMORY, align 4
  store i32 %v2526, ptr %PC, align 4
  %v2530 = add i32 %v2526, 4
  store i32 %v2530, ptr %NEXT_PC, align 4
  %v2531 = load i32, ptr %ESP, align 4
  %v2532 = load i32, ptr %SSBASE, align 4
  %v2533 = add i32 %v2531, 4
  %v2534 = add i32 %v2533, %v2532
  %v2535 = load i32, ptr %EAX, align 4
  %v2536 = load ptr, ptr %MEMORY, align 4
  %v2537 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2536, ptr %state, i32 %v2534, i32 %v2535)
  store ptr %v2537, ptr %MEMORY, align 4
  store i32 %v2530, ptr %PC, align 4
  %v2538 = add i32 %v2530, 7
  store i32 %v2538, ptr %NEXT_PC, align 4
  %v2539 = load i32, ptr %ESP, align 4
  %v2540 = load i32, ptr %SSBASE, align 4
  %v2541 = add i32 %v2539, %v2540
  %v2542 = load ptr, ptr %MEMORY, align 4
  %v2543 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2542, ptr %state, i32 %v2541, i32 4235788)
  store ptr %v2543, ptr %MEMORY, align 4
  store i32 %v2538, ptr %PC, align 4
  %v2544 = add i32 %v2538, 5
  store i32 %v2544, ptr %NEXT_PC, align 4
  %v2545 = sub i32 %v2544, 523
  %v2546 = load ptr, ptr %MEMORY, align 4
  %v2547 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2546, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v2544, ptr %RETURN_PC)
  store ptr %v2547, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202627:                                       ; preds = %bb_4202543, %bb_4202535, %bb_4202527
  %v2548 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2548, ptr %PC, align 4
  %v2549 = add i32 %v2548, 5
  store i32 %v2549, ptr %NEXT_PC, align 4
  %v2550 = load i32, ptr %DSBASE, align 4
  %v2551 = add i32 4240292, %v2550
  %v2552 = load ptr, ptr %MEMORY, align 4
  %v2553 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2552, ptr %state, ptr %EAX, i32 %v2551)
  store ptr %v2553, ptr %MEMORY, align 4
  store i32 %v2549, ptr %PC, align 4
  %v2554 = add i32 %v2549, 3
  store i32 %v2554, ptr %NEXT_PC, align 4
  %v2555 = load i32, ptr %EAX, align 4
  %v2556 = load ptr, ptr %MEMORY, align 4
  %v2557 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2556, ptr %state, ptr %EAX, i32 %v2555, i32 1)
  store ptr %v2557, ptr %MEMORY, align 4
  store i32 %v2554, ptr %PC, align 4
  %v2558 = add i32 %v2554, 5
  store i32 %v2558, ptr %NEXT_PC, align 4
  %v2559 = load i32, ptr %DSBASE, align 4
  %v2560 = add i32 4240292, %v2559
  %v2561 = load i32, ptr %EAX, align 4
  %v2562 = load ptr, ptr %MEMORY, align 4
  %v2563 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2562, ptr %state, i32 %v2560, i32 %v2561)
  store ptr %v2563, ptr %MEMORY, align 4
  br label %bb_4202640

bb_4202640:                                       ; preds = %bb_4202627, %bb_4202220
  %v2564 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2564, ptr %PC, align 4
  %v2565 = add i32 %v2564, 3
  store i32 %v2565, ptr %NEXT_PC, align 4
  %v2566 = load i32, ptr %EBP, align 4
  %v2567 = load i32, ptr %SSBASE, align 4
  %v2568 = sub i32 %v2566, 4
  %v2569 = add i32 %v2568, %v2567
  %v2570 = load ptr, ptr %MEMORY, align 4
  %v2571 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2570, ptr %state, ptr %EBX, i32 %v2569)
  store ptr %v2571, ptr %MEMORY, align 4
  store i32 %v2565, ptr %PC, align 4
  %v2572 = add i32 %v2565, 1
  store i32 %v2572, ptr %NEXT_PC, align 4
  %v2573 = load ptr, ptr %MEMORY, align 4
  %v2574 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v2573, ptr %state)
  store ptr %v2574, ptr %MEMORY, align 4
  store i32 %v2572, ptr %PC, align 4
  %v2575 = add i32 %v2572, 1
  store i32 %v2575, ptr %NEXT_PC, align 4
  %v2576 = load ptr, ptr %MEMORY, align 4
  %v2577 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v2576, ptr %state, ptr %NEXT_PC)
  store ptr %v2577, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202645:                                       ; No predecessors!
  %v2578 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2578, ptr %PC, align 4
  %v2579 = add i32 %v2578, 1
  store i32 %v2579, ptr %NEXT_PC, align 4
  %v2580 = load i32, ptr %EBP, align 4
  %v2581 = load ptr, ptr %MEMORY, align 4
  %v2582 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2581, ptr %state, i32 %v2580)
  store ptr %v2582, ptr %MEMORY, align 4
  store i32 %v2579, ptr %PC, align 4
  %v2583 = add i32 %v2579, 2
  store i32 %v2583, ptr %NEXT_PC, align 4
  %v2584 = load i32, ptr %ESP, align 4
  %v2585 = load ptr, ptr %MEMORY, align 4
  %v2586 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2585, ptr %state, ptr %EBP, i32 %v2584)
  store ptr %v2586, ptr %MEMORY, align 4
  store i32 %v2583, ptr %PC, align 4
  %v2587 = add i32 %v2583, 1
  store i32 %v2587, ptr %NEXT_PC, align 4
  %v2588 = load i32, ptr %EBX, align 4
  %v2589 = load ptr, ptr %MEMORY, align 4
  %v2590 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v2589, ptr %state, i32 %v2588)
  store ptr %v2590, ptr %MEMORY, align 4
  store i32 %v2587, ptr %PC, align 4
  %v2591 = add i32 %v2587, 3
  store i32 %v2591, ptr %NEXT_PC, align 4
  %v2592 = load i32, ptr %ESP, align 4
  %v2593 = load ptr, ptr %MEMORY, align 4
  %v2594 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2593, ptr %state, ptr %ESP, i32 %v2592, i32 68)
  store ptr %v2594, ptr %MEMORY, align 4
  store i32 %v2591, ptr %PC, align 4
  %v2595 = add i32 %v2591, 7
  store i32 %v2595, ptr %NEXT_PC, align 4
  %v2596 = load i32, ptr %EBP, align 4
  %v2597 = load i32, ptr %SSBASE, align 4
  %v2598 = sub i32 %v2596, 12
  %v2599 = add i32 %v2598, %v2597
  %v2600 = load ptr, ptr %MEMORY, align 4
  %v2601 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2600, ptr %state, i32 %v2599, i32 0)
  store ptr %v2601, ptr %MEMORY, align 4
  store i32 %v2595, ptr %PC, align 4
  %v2602 = add i32 %v2595, 5
  store i32 %v2602, ptr %NEXT_PC, align 4
  %v2603 = add i32 %v2602, 217
  %v2604 = load ptr, ptr %MEMORY, align 4
  %v2605 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2604, ptr %state, i32 %v2603, ptr %NEXT_PC)
  store ptr %v2605, ptr %MEMORY, align 4
  br label %bb_4202881

bb_4202664:                                       ; preds = %bb_4202881
  store i32 %v3001, ptr %PC, align 4
  %v2606 = add i32 %v3001, 6
  store i32 %v2606, ptr %NEXT_PC, align 4
  %v2607 = load i32, ptr %DSBASE, align 4
  %v2608 = add i32 4240288, %v2607
  %v2609 = load ptr, ptr %MEMORY, align 4
  %v2610 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2609, ptr %state, ptr %ECX, i32 %v2608)
  store ptr %v2610, ptr %MEMORY, align 4
  store i32 %v2606, ptr %PC, align 4
  %v2611 = add i32 %v2606, 3
  store i32 %v2611, ptr %NEXT_PC, align 4
  %v2612 = load i32, ptr %EBP, align 4
  %v2613 = load i32, ptr %SSBASE, align 4
  %v2614 = sub i32 %v2612, 12
  %v2615 = add i32 %v2614, %v2613
  %v2616 = load ptr, ptr %MEMORY, align 4
  %v2617 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2616, ptr %state, ptr %EDX, i32 %v2615)
  store ptr %v2617, ptr %MEMORY, align 4
  store i32 %v2611, ptr %PC, align 4
  %v2618 = add i32 %v2611, 2
  store i32 %v2618, ptr %NEXT_PC, align 4
  %v2619 = load i32, ptr %EDX, align 4
  %v2620 = load ptr, ptr %MEMORY, align 4
  %v2621 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2620, ptr %state, ptr %EAX, i32 %v2619)
  store ptr %v2621, ptr %MEMORY, align 4
  store i32 %v2618, ptr %PC, align 4
  %v2622 = add i32 %v2618, 2
  store i32 %v2622, ptr %NEXT_PC, align 4
  %v2623 = load i32, ptr %EAX, align 4
  %v2624 = load i32, ptr %EAX, align 4
  %v2625 = load ptr, ptr %MEMORY, align 4
  %v2626 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2625, ptr %state, ptr %EAX, i32 %v2623, i32 %v2624)
  store ptr %v2626, ptr %MEMORY, align 4
  store i32 %v2622, ptr %PC, align 4
  %v2627 = add i32 %v2622, 2
  store i32 %v2627, ptr %NEXT_PC, align 4
  %v2628 = load i32, ptr %EAX, align 4
  %v2629 = load i32, ptr %EDX, align 4
  %v2630 = load ptr, ptr %MEMORY, align 4
  %v2631 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2630, ptr %state, ptr %EAX, i32 %v2628, i32 %v2629)
  store ptr %v2631, ptr %MEMORY, align 4
  store i32 %v2627, ptr %PC, align 4
  %v2632 = add i32 %v2627, 3
  store i32 %v2632, ptr %NEXT_PC, align 4
  %v2633 = load i32, ptr %EAX, align 4
  %v2634 = load ptr, ptr %MEMORY, align 4
  %v2635 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2634, ptr %state, ptr %EAX, i32 %v2633, i32 2)
  store ptr %v2635, ptr %MEMORY, align 4
  store i32 %v2632, ptr %PC, align 4
  %v2636 = add i32 %v2632, 2
  store i32 %v2636, ptr %NEXT_PC, align 4
  %v2637 = load i32, ptr %EAX, align 4
  %v2638 = load i32, ptr %ECX, align 4
  %v2639 = load ptr, ptr %MEMORY, align 4
  %v2640 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2639, ptr %state, ptr %EAX, i32 %v2637, i32 %v2638)
  store ptr %v2640, ptr %MEMORY, align 4
  store i32 %v2636, ptr %PC, align 4
  %v2641 = add i32 %v2636, 2
  store i32 %v2641, ptr %NEXT_PC, align 4
  %v2642 = load i32, ptr %EAX, align 4
  %v2643 = load i32, ptr %DSBASE, align 4
  %v2644 = add i32 %v2642, %v2643
  %v2645 = load ptr, ptr %MEMORY, align 4
  %v2646 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2645, ptr %state, ptr %EAX, i32 %v2644)
  store ptr %v2646, ptr %MEMORY, align 4
  store i32 %v2641, ptr %PC, align 4
  %v2647 = add i32 %v2641, 2
  store i32 %v2647, ptr %NEXT_PC, align 4
  %v2648 = load i32, ptr %EAX, align 4
  %v2649 = load i32, ptr %EAX, align 4
  %v2650 = load ptr, ptr %MEMORY, align 4
  %v2651 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2650, ptr %state, i32 %v2648, i32 %v2649)
  store ptr %v2651, ptr %MEMORY, align 4
  store i32 %v2647, ptr %PC, align 4
  %v2652 = add i32 %v2647, 6
  store i32 %v2652, ptr %NEXT_PC, align 4
  %v2653 = add i32 %v2652, 182
  %v2654 = load ptr, ptr %MEMORY, align 4
  %v2655 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2654, ptr %state, ptr %BRANCH_TAKEN, i32 %v2653, i32 %v2652, ptr %NEXT_PC)
  store ptr %v2655, ptr %MEMORY, align 4
  br i1 true, label %bb_4202876, label %bb_4202694

bb_4202694:                                       ; preds = %bb_4202664
  store i32 %v2652, ptr %PC, align 4
  %v2656 = add i32 %v2652, 6
  store i32 %v2656, ptr %NEXT_PC, align 4
  %v2657 = load i32, ptr %DSBASE, align 4
  %v2658 = add i32 4240288, %v2657
  %v2659 = load ptr, ptr %MEMORY, align 4
  %v2660 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2659, ptr %state, ptr %ECX, i32 %v2658)
  store ptr %v2660, ptr %MEMORY, align 4
  store i32 %v2656, ptr %PC, align 4
  %v2661 = add i32 %v2656, 3
  store i32 %v2661, ptr %NEXT_PC, align 4
  %v2662 = load i32, ptr %EBP, align 4
  %v2663 = load i32, ptr %SSBASE, align 4
  %v2664 = sub i32 %v2662, 12
  %v2665 = add i32 %v2664, %v2663
  %v2666 = load ptr, ptr %MEMORY, align 4
  %v2667 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2666, ptr %state, ptr %EDX, i32 %v2665)
  store ptr %v2667, ptr %MEMORY, align 4
  store i32 %v2661, ptr %PC, align 4
  %v2668 = add i32 %v2661, 2
  store i32 %v2668, ptr %NEXT_PC, align 4
  %v2669 = load i32, ptr %EDX, align 4
  %v2670 = load ptr, ptr %MEMORY, align 4
  %v2671 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2670, ptr %state, ptr %EAX, i32 %v2669)
  store ptr %v2671, ptr %MEMORY, align 4
  store i32 %v2668, ptr %PC, align 4
  %v2672 = add i32 %v2668, 2
  store i32 %v2672, ptr %NEXT_PC, align 4
  %v2673 = load i32, ptr %EAX, align 4
  %v2674 = load i32, ptr %EAX, align 4
  %v2675 = load ptr, ptr %MEMORY, align 4
  %v2676 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2675, ptr %state, ptr %EAX, i32 %v2673, i32 %v2674)
  store ptr %v2676, ptr %MEMORY, align 4
  store i32 %v2672, ptr %PC, align 4
  %v2677 = add i32 %v2672, 2
  store i32 %v2677, ptr %NEXT_PC, align 4
  %v2678 = load i32, ptr %EAX, align 4
  %v2679 = load i32, ptr %EDX, align 4
  %v2680 = load ptr, ptr %MEMORY, align 4
  %v2681 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2680, ptr %state, ptr %EAX, i32 %v2678, i32 %v2679)
  store ptr %v2681, ptr %MEMORY, align 4
  store i32 %v2677, ptr %PC, align 4
  %v2682 = add i32 %v2677, 3
  store i32 %v2682, ptr %NEXT_PC, align 4
  %v2683 = load i32, ptr %EAX, align 4
  %v2684 = load ptr, ptr %MEMORY, align 4
  %v2685 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2684, ptr %state, ptr %EAX, i32 %v2683, i32 2)
  store ptr %v2685, ptr %MEMORY, align 4
  store i32 %v2682, ptr %PC, align 4
  %v2686 = add i32 %v2682, 2
  store i32 %v2686, ptr %NEXT_PC, align 4
  %v2687 = load i32, ptr %EAX, align 4
  %v2688 = load i32, ptr %ECX, align 4
  %v2689 = load ptr, ptr %MEMORY, align 4
  %v2690 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2689, ptr %state, ptr %EAX, i32 %v2687, i32 %v2688)
  store ptr %v2690, ptr %MEMORY, align 4
  store i32 %v2686, ptr %PC, align 4
  %v2691 = add i32 %v2686, 3
  store i32 %v2691, ptr %NEXT_PC, align 4
  %v2692 = load i32, ptr %EAX, align 4
  %v2693 = load i32, ptr %DSBASE, align 4
  %v2694 = add i32 %v2692, 4
  %v2695 = add i32 %v2694, %v2693
  %v2696 = load ptr, ptr %MEMORY, align 4
  %v2697 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2696, ptr %state, ptr %EAX, i32 %v2695)
  store ptr %v2697, ptr %MEMORY, align 4
  store i32 %v2691, ptr %PC, align 4
  %v2698 = add i32 %v2691, 8
  store i32 %v2698, ptr %NEXT_PC, align 4
  %v2699 = load i32, ptr %ESP, align 4
  %v2700 = load i32, ptr %SSBASE, align 4
  %v2701 = add i32 %v2699, 8
  %v2702 = add i32 %v2701, %v2700
  %v2703 = load ptr, ptr %MEMORY, align 4
  %v2704 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2703, ptr %state, i32 %v2702, i32 28)
  store ptr %v2704, ptr %MEMORY, align 4
  store i32 %v2698, ptr %PC, align 4
  %v2705 = add i32 %v2698, 3
  store i32 %v2705, ptr %NEXT_PC, align 4
  %v2706 = load i32, ptr %EBP, align 4
  %v2707 = sub i32 %v2706, 40
  %v2708 = load ptr, ptr %MEMORY, align 4
  %v2709 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2708, ptr %state, ptr %EDX, i32 %v2707)
  store ptr %v2709, ptr %MEMORY, align 4
  store i32 %v2705, ptr %PC, align 4
  %v2710 = add i32 %v2705, 4
  store i32 %v2710, ptr %NEXT_PC, align 4
  %v2711 = load i32, ptr %ESP, align 4
  %v2712 = load i32, ptr %SSBASE, align 4
  %v2713 = add i32 %v2711, 4
  %v2714 = add i32 %v2713, %v2712
  %v2715 = load i32, ptr %EDX, align 4
  %v2716 = load ptr, ptr %MEMORY, align 4
  %v2717 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2716, ptr %state, i32 %v2714, i32 %v2715)
  store ptr %v2717, ptr %MEMORY, align 4
  store i32 %v2710, ptr %PC, align 4
  %v2718 = add i32 %v2710, 3
  store i32 %v2718, ptr %NEXT_PC, align 4
  %v2719 = load i32, ptr %ESP, align 4
  %v2720 = load i32, ptr %SSBASE, align 4
  %v2721 = add i32 %v2719, %v2720
  %v2722 = load i32, ptr %EAX, align 4
  %v2723 = load ptr, ptr %MEMORY, align 4
  %v2724 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2723, ptr %state, i32 %v2721, i32 %v2722)
  store ptr %v2724, ptr %MEMORY, align 4
  store i32 %v2718, ptr %PC, align 4
  %v2725 = add i32 %v2718, 5
  store i32 %v2725, ptr %NEXT_PC, align 4
  %v2726 = load i32, ptr %DSBASE, align 4
  %v2727 = add i32 4243884, %v2726
  %v2728 = load ptr, ptr %MEMORY, align 4
  %v2729 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2728, ptr %state, ptr %EAX, i32 %v2727)
  store ptr %v2729, ptr %MEMORY, align 4
  store i32 %v2725, ptr %PC, align 4
  %v2730 = add i32 %v2725, 2
  store i32 %v2730, ptr %NEXT_PC, align 4
  %v2731 = load i32, ptr %EAX, align 4
  %v2732 = load ptr, ptr %MEMORY, align 4
  %v2733 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2732, ptr %state, i32 %v2731, ptr %NEXT_PC, i32 %v2730, ptr %RETURN_PC)
  store ptr %v2733, ptr %MEMORY, align 4
  store i32 %v2730, ptr %PC, align 4
  %v2734 = add i32 %v2730, 3
  store i32 %v2734, ptr %NEXT_PC, align 4
  %v2735 = load i32, ptr %ESP, align 4
  %v2736 = load ptr, ptr %MEMORY, align 4
  %v2737 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2736, ptr %state, ptr %ESP, i32 %v2735, i32 12)
  store ptr %v2737, ptr %MEMORY, align 4
  store i32 %v2734, ptr %PC, align 4
  %v2738 = add i32 %v2734, 2
  store i32 %v2738, ptr %NEXT_PC, align 4
  %v2739 = load i32, ptr %EAX, align 4
  %v2740 = load i32, ptr %EAX, align 4
  %v2741 = load ptr, ptr %MEMORY, align 4
  %v2742 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v2741, ptr %state, i32 %v2739, i32 %v2740)
  store ptr %v2742, ptr %MEMORY, align 4
  store i32 %v2738, ptr %PC, align 4
  %v2743 = add i32 %v2738, 2
  store i32 %v2743, ptr %NEXT_PC, align 4
  %v2744 = add i32 %v2743, 69
  %v2745 = load ptr, ptr %MEMORY, align 4
  %v2746 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v2745, ptr %state, ptr %BRANCH_TAKEN, i32 %v2744, i32 %v2743, ptr %NEXT_PC)
  store ptr %v2746, ptr %MEMORY, align 4
  br i1 true, label %bb_4202818, label %bb_4202749

bb_4202749:                                       ; preds = %bb_4202694
  store i32 %v2743, ptr %PC, align 4
  %v2747 = add i32 %v2743, 6
  store i32 %v2747, ptr %NEXT_PC, align 4
  %v2748 = load i32, ptr %DSBASE, align 4
  %v2749 = add i32 4240288, %v2748
  %v2750 = load ptr, ptr %MEMORY, align 4
  %v2751 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2750, ptr %state, ptr %ECX, i32 %v2749)
  store ptr %v2751, ptr %MEMORY, align 4
  store i32 %v2747, ptr %PC, align 4
  %v2752 = add i32 %v2747, 3
  store i32 %v2752, ptr %NEXT_PC, align 4
  %v2753 = load i32, ptr %EBP, align 4
  %v2754 = load i32, ptr %SSBASE, align 4
  %v2755 = sub i32 %v2753, 12
  %v2756 = add i32 %v2755, %v2754
  %v2757 = load ptr, ptr %MEMORY, align 4
  %v2758 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2757, ptr %state, ptr %EDX, i32 %v2756)
  store ptr %v2758, ptr %MEMORY, align 4
  store i32 %v2752, ptr %PC, align 4
  %v2759 = add i32 %v2752, 2
  store i32 %v2759, ptr %NEXT_PC, align 4
  %v2760 = load i32, ptr %EDX, align 4
  %v2761 = load ptr, ptr %MEMORY, align 4
  %v2762 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2761, ptr %state, ptr %EAX, i32 %v2760)
  store ptr %v2762, ptr %MEMORY, align 4
  store i32 %v2759, ptr %PC, align 4
  %v2763 = add i32 %v2759, 2
  store i32 %v2763, ptr %NEXT_PC, align 4
  %v2764 = load i32, ptr %EAX, align 4
  %v2765 = load i32, ptr %EAX, align 4
  %v2766 = load ptr, ptr %MEMORY, align 4
  %v2767 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2766, ptr %state, ptr %EAX, i32 %v2764, i32 %v2765)
  store ptr %v2767, ptr %MEMORY, align 4
  store i32 %v2763, ptr %PC, align 4
  %v2768 = add i32 %v2763, 2
  store i32 %v2768, ptr %NEXT_PC, align 4
  %v2769 = load i32, ptr %EAX, align 4
  %v2770 = load i32, ptr %EDX, align 4
  %v2771 = load ptr, ptr %MEMORY, align 4
  %v2772 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2771, ptr %state, ptr %EAX, i32 %v2769, i32 %v2770)
  store ptr %v2772, ptr %MEMORY, align 4
  store i32 %v2768, ptr %PC, align 4
  %v2773 = add i32 %v2768, 3
  store i32 %v2773, ptr %NEXT_PC, align 4
  %v2774 = load i32, ptr %EAX, align 4
  %v2775 = load ptr, ptr %MEMORY, align 4
  %v2776 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2775, ptr %state, ptr %EAX, i32 %v2774, i32 2)
  store ptr %v2776, ptr %MEMORY, align 4
  store i32 %v2773, ptr %PC, align 4
  %v2777 = add i32 %v2773, 2
  store i32 %v2777, ptr %NEXT_PC, align 4
  %v2778 = load i32, ptr %EAX, align 4
  %v2779 = load i32, ptr %ECX, align 4
  %v2780 = load ptr, ptr %MEMORY, align 4
  %v2781 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2780, ptr %state, ptr %EAX, i32 %v2778, i32 %v2779)
  store ptr %v2781, ptr %MEMORY, align 4
  store i32 %v2777, ptr %PC, align 4
  %v2782 = add i32 %v2777, 3
  store i32 %v2782, ptr %NEXT_PC, align 4
  %v2783 = load i32, ptr %EAX, align 4
  %v2784 = load i32, ptr %DSBASE, align 4
  %v2785 = add i32 %v2783, 4
  %v2786 = add i32 %v2785, %v2784
  %v2787 = load ptr, ptr %MEMORY, align 4
  %v2788 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2787, ptr %state, ptr %ECX, i32 %v2786)
  store ptr %v2788, ptr %MEMORY, align 4
  store i32 %v2782, ptr %PC, align 4
  %v2789 = add i32 %v2782, 6
  store i32 %v2789, ptr %NEXT_PC, align 4
  %v2790 = load i32, ptr %DSBASE, align 4
  %v2791 = add i32 4240288, %v2790
  %v2792 = load ptr, ptr %MEMORY, align 4
  %v2793 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2792, ptr %state, ptr %EBX, i32 %v2791)
  store ptr %v2793, ptr %MEMORY, align 4
  store i32 %v2789, ptr %PC, align 4
  %v2794 = add i32 %v2789, 3
  store i32 %v2794, ptr %NEXT_PC, align 4
  %v2795 = load i32, ptr %EBP, align 4
  %v2796 = load i32, ptr %SSBASE, align 4
  %v2797 = sub i32 %v2795, 12
  %v2798 = add i32 %v2797, %v2796
  %v2799 = load ptr, ptr %MEMORY, align 4
  %v2800 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2799, ptr %state, ptr %EDX, i32 %v2798)
  store ptr %v2800, ptr %MEMORY, align 4
  store i32 %v2794, ptr %PC, align 4
  %v2801 = add i32 %v2794, 2
  store i32 %v2801, ptr %NEXT_PC, align 4
  %v2802 = load i32, ptr %EDX, align 4
  %v2803 = load ptr, ptr %MEMORY, align 4
  %v2804 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2803, ptr %state, ptr %EAX, i32 %v2802)
  store ptr %v2804, ptr %MEMORY, align 4
  store i32 %v2801, ptr %PC, align 4
  %v2805 = add i32 %v2801, 2
  store i32 %v2805, ptr %NEXT_PC, align 4
  %v2806 = load i32, ptr %EAX, align 4
  %v2807 = load i32, ptr %EAX, align 4
  %v2808 = load ptr, ptr %MEMORY, align 4
  %v2809 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2808, ptr %state, ptr %EAX, i32 %v2806, i32 %v2807)
  store ptr %v2809, ptr %MEMORY, align 4
  store i32 %v2805, ptr %PC, align 4
  %v2810 = add i32 %v2805, 2
  store i32 %v2810, ptr %NEXT_PC, align 4
  %v2811 = load i32, ptr %EAX, align 4
  %v2812 = load i32, ptr %EDX, align 4
  %v2813 = load ptr, ptr %MEMORY, align 4
  %v2814 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2813, ptr %state, ptr %EAX, i32 %v2811, i32 %v2812)
  store ptr %v2814, ptr %MEMORY, align 4
  store i32 %v2810, ptr %PC, align 4
  %v2815 = add i32 %v2810, 3
  store i32 %v2815, ptr %NEXT_PC, align 4
  %v2816 = load i32, ptr %EAX, align 4
  %v2817 = load ptr, ptr %MEMORY, align 4
  %v2818 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2817, ptr %state, ptr %EAX, i32 %v2816, i32 2)
  store ptr %v2818, ptr %MEMORY, align 4
  store i32 %v2815, ptr %PC, align 4
  %v2819 = add i32 %v2815, 2
  store i32 %v2819, ptr %NEXT_PC, align 4
  %v2820 = load i32, ptr %EAX, align 4
  %v2821 = load i32, ptr %EBX, align 4
  %v2822 = load ptr, ptr %MEMORY, align 4
  %v2823 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2822, ptr %state, ptr %EAX, i32 %v2820, i32 %v2821)
  store ptr %v2823, ptr %MEMORY, align 4
  store i32 %v2819, ptr %PC, align 4
  %v2824 = add i32 %v2819, 3
  store i32 %v2824, ptr %NEXT_PC, align 4
  %v2825 = load i32, ptr %EAX, align 4
  %v2826 = load i32, ptr %DSBASE, align 4
  %v2827 = add i32 %v2825, 8
  %v2828 = add i32 %v2827, %v2826
  %v2829 = load ptr, ptr %MEMORY, align 4
  %v2830 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2829, ptr %state, ptr %EAX, i32 %v2828)
  store ptr %v2830, ptr %MEMORY, align 4
  store i32 %v2824, ptr %PC, align 4
  %v2831 = add i32 %v2824, 3
  store i32 %v2831, ptr %NEXT_PC, align 4
  %v2832 = load i32, ptr %EAX, align 4
  %v2833 = load i32, ptr %DSBASE, align 4
  %v2834 = add i32 %v2832, 8
  %v2835 = add i32 %v2834, %v2833
  %v2836 = load ptr, ptr %MEMORY, align 4
  %v2837 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2836, ptr %state, ptr %EAX, i32 %v2835)
  store ptr %v2837, ptr %MEMORY, align 4
  store i32 %v2831, ptr %PC, align 4
  %v2838 = add i32 %v2831, 4
  store i32 %v2838, ptr %NEXT_PC, align 4
  %v2839 = load i32, ptr %ESP, align 4
  %v2840 = load i32, ptr %SSBASE, align 4
  %v2841 = add i32 %v2839, 8
  %v2842 = add i32 %v2841, %v2840
  %v2843 = load i32, ptr %ECX, align 4
  %v2844 = load ptr, ptr %MEMORY, align 4
  %v2845 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2844, ptr %state, i32 %v2842, i32 %v2843)
  store ptr %v2845, ptr %MEMORY, align 4
  store i32 %v2838, ptr %PC, align 4
  %v2846 = add i32 %v2838, 4
  store i32 %v2846, ptr %NEXT_PC, align 4
  %v2847 = load i32, ptr %ESP, align 4
  %v2848 = load i32, ptr %SSBASE, align 4
  %v2849 = add i32 %v2847, 4
  %v2850 = add i32 %v2849, %v2848
  %v2851 = load i32, ptr %EAX, align 4
  %v2852 = load ptr, ptr %MEMORY, align 4
  %v2853 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2852, ptr %state, i32 %v2850, i32 %v2851)
  store ptr %v2853, ptr %MEMORY, align 4
  store i32 %v2846, ptr %PC, align 4
  %v2854 = add i32 %v2846, 7
  store i32 %v2854, ptr %NEXT_PC, align 4
  %v2855 = load i32, ptr %ESP, align 4
  %v2856 = load i32, ptr %SSBASE, align 4
  %v2857 = add i32 %v2855, %v2856
  %v2858 = load ptr, ptr %MEMORY, align 4
  %v2859 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2858, ptr %state, i32 %v2857, i32 4235736)
  store ptr %v2859, ptr %MEMORY, align 4
  store i32 %v2854, ptr %PC, align 4
  %v2860 = add i32 %v2854, 5
  store i32 %v2860, ptr %NEXT_PC, align 4
  %v2861 = sub i32 %v2860, 714
  %v2862 = load ptr, ptr %MEMORY, align 4
  %v2863 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v2862, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v2860, ptr %RETURN_PC)
  store ptr %v2863, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202818:                                       ; preds = %bb_4202694
  store i32 %v2743, ptr %PC, align 4
  %v2864 = add i32 %v2743, 6
  store i32 %v2864, ptr %NEXT_PC, align 4
  %v2865 = load i32, ptr %DSBASE, align 4
  %v2866 = add i32 4240288, %v2865
  %v2867 = load ptr, ptr %MEMORY, align 4
  %v2868 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2867, ptr %state, ptr %ECX, i32 %v2866)
  store ptr %v2868, ptr %MEMORY, align 4
  store i32 %v2864, ptr %PC, align 4
  %v2869 = add i32 %v2864, 3
  store i32 %v2869, ptr %NEXT_PC, align 4
  %v2870 = load i32, ptr %EBP, align 4
  %v2871 = load i32, ptr %SSBASE, align 4
  %v2872 = sub i32 %v2870, 12
  %v2873 = add i32 %v2872, %v2871
  %v2874 = load ptr, ptr %MEMORY, align 4
  %v2875 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2874, ptr %state, ptr %EDX, i32 %v2873)
  store ptr %v2875, ptr %MEMORY, align 4
  store i32 %v2869, ptr %PC, align 4
  %v2876 = add i32 %v2869, 2
  store i32 %v2876, ptr %NEXT_PC, align 4
  %v2877 = load i32, ptr %EDX, align 4
  %v2878 = load ptr, ptr %MEMORY, align 4
  %v2879 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2878, ptr %state, ptr %EAX, i32 %v2877)
  store ptr %v2879, ptr %MEMORY, align 4
  store i32 %v2876, ptr %PC, align 4
  %v2880 = add i32 %v2876, 2
  store i32 %v2880, ptr %NEXT_PC, align 4
  %v2881 = load i32, ptr %EAX, align 4
  %v2882 = load i32, ptr %EAX, align 4
  %v2883 = load ptr, ptr %MEMORY, align 4
  %v2884 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2883, ptr %state, ptr %EAX, i32 %v2881, i32 %v2882)
  store ptr %v2884, ptr %MEMORY, align 4
  store i32 %v2880, ptr %PC, align 4
  %v2885 = add i32 %v2880, 2
  store i32 %v2885, ptr %NEXT_PC, align 4
  %v2886 = load i32, ptr %EAX, align 4
  %v2887 = load i32, ptr %EDX, align 4
  %v2888 = load ptr, ptr %MEMORY, align 4
  %v2889 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2888, ptr %state, ptr %EAX, i32 %v2886, i32 %v2887)
  store ptr %v2889, ptr %MEMORY, align 4
  store i32 %v2885, ptr %PC, align 4
  %v2890 = add i32 %v2885, 3
  store i32 %v2890, ptr %NEXT_PC, align 4
  %v2891 = load i32, ptr %EAX, align 4
  %v2892 = load ptr, ptr %MEMORY, align 4
  %v2893 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2892, ptr %state, ptr %EAX, i32 %v2891, i32 2)
  store ptr %v2893, ptr %MEMORY, align 4
  store i32 %v2890, ptr %PC, align 4
  %v2894 = add i32 %v2890, 2
  store i32 %v2894, ptr %NEXT_PC, align 4
  %v2895 = load i32, ptr %EAX, align 4
  %v2896 = load i32, ptr %ECX, align 4
  %v2897 = load ptr, ptr %MEMORY, align 4
  %v2898 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v2897, ptr %state, ptr %EAX, i32 %v2895, i32 %v2896)
  store ptr %v2898, ptr %MEMORY, align 4
  store i32 %v2894, ptr %PC, align 4
  %v2899 = add i32 %v2894, 2
  store i32 %v2899, ptr %NEXT_PC, align 4
  %v2900 = load i32, ptr %EAX, align 4
  %v2901 = load i32, ptr %DSBASE, align 4
  %v2902 = add i32 %v2900, %v2901
  %v2903 = load ptr, ptr %MEMORY, align 4
  %v2904 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2903, ptr %state, ptr %ECX, i32 %v2902)
  store ptr %v2904, ptr %MEMORY, align 4
  store i32 %v2899, ptr %PC, align 4
  %v2905 = add i32 %v2899, 3
  store i32 %v2905, ptr %NEXT_PC, align 4
  %v2906 = load i32, ptr %EBP, align 4
  %v2907 = load i32, ptr %SSBASE, align 4
  %v2908 = sub i32 %v2906, 28
  %v2909 = add i32 %v2908, %v2907
  %v2910 = load ptr, ptr %MEMORY, align 4
  %v2911 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2910, ptr %state, ptr %EDX, i32 %v2909)
  store ptr %v2911, ptr %MEMORY, align 4
  store i32 %v2905, ptr %PC, align 4
  %v2912 = add i32 %v2905, 3
  store i32 %v2912, ptr %NEXT_PC, align 4
  %v2913 = load i32, ptr %EBP, align 4
  %v2914 = load i32, ptr %SSBASE, align 4
  %v2915 = sub i32 %v2913, 40
  %v2916 = add i32 %v2915, %v2914
  %v2917 = load ptr, ptr %MEMORY, align 4
  %v2918 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2917, ptr %state, ptr %EAX, i32 %v2916)
  store ptr %v2918, ptr %MEMORY, align 4
  store i32 %v2912, ptr %PC, align 4
  %v2919 = add i32 %v2912, 3
  store i32 %v2919, ptr %NEXT_PC, align 4
  %v2920 = load i32, ptr %EBP, align 4
  %v2921 = sub i32 %v2920, 44
  %v2922 = load ptr, ptr %MEMORY, align 4
  %v2923 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v2922, ptr %state, ptr %EBX, i32 %v2921)
  store ptr %v2923, ptr %MEMORY, align 4
  store i32 %v2919, ptr %PC, align 4
  %v2924 = add i32 %v2919, 4
  store i32 %v2924, ptr %NEXT_PC, align 4
  %v2925 = load i32, ptr %ESP, align 4
  %v2926 = load i32, ptr %SSBASE, align 4
  %v2927 = add i32 %v2925, 12
  %v2928 = add i32 %v2927, %v2926
  %v2929 = load i32, ptr %EBX, align 4
  %v2930 = load ptr, ptr %MEMORY, align 4
  %v2931 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2930, ptr %state, i32 %v2928, i32 %v2929)
  store ptr %v2931, ptr %MEMORY, align 4
  store i32 %v2924, ptr %PC, align 4
  %v2932 = add i32 %v2924, 4
  store i32 %v2932, ptr %NEXT_PC, align 4
  %v2933 = load i32, ptr %ESP, align 4
  %v2934 = load i32, ptr %SSBASE, align 4
  %v2935 = add i32 %v2933, 8
  %v2936 = add i32 %v2935, %v2934
  %v2937 = load i32, ptr %ECX, align 4
  %v2938 = load ptr, ptr %MEMORY, align 4
  %v2939 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2938, ptr %state, i32 %v2936, i32 %v2937)
  store ptr %v2939, ptr %MEMORY, align 4
  store i32 %v2932, ptr %PC, align 4
  %v2940 = add i32 %v2932, 4
  store i32 %v2940, ptr %NEXT_PC, align 4
  %v2941 = load i32, ptr %ESP, align 4
  %v2942 = load i32, ptr %SSBASE, align 4
  %v2943 = add i32 %v2941, 4
  %v2944 = add i32 %v2943, %v2942
  %v2945 = load i32, ptr %EDX, align 4
  %v2946 = load ptr, ptr %MEMORY, align 4
  %v2947 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2946, ptr %state, i32 %v2944, i32 %v2945)
  store ptr %v2947, ptr %MEMORY, align 4
  store i32 %v2940, ptr %PC, align 4
  %v2948 = add i32 %v2940, 3
  store i32 %v2948, ptr %NEXT_PC, align 4
  %v2949 = load i32, ptr %ESP, align 4
  %v2950 = load i32, ptr %SSBASE, align 4
  %v2951 = add i32 %v2949, %v2950
  %v2952 = load i32, ptr %EAX, align 4
  %v2953 = load ptr, ptr %MEMORY, align 4
  %v2954 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v2953, ptr %state, i32 %v2951, i32 %v2952)
  store ptr %v2954, ptr %MEMORY, align 4
  store i32 %v2948, ptr %PC, align 4
  %v2955 = add i32 %v2948, 5
  store i32 %v2955, ptr %NEXT_PC, align 4
  %v2956 = load i32, ptr %DSBASE, align 4
  %v2957 = add i32 4243880, %v2956
  %v2958 = load ptr, ptr %MEMORY, align 4
  %v2959 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2958, ptr %state, ptr %EAX, i32 %v2957)
  store ptr %v2959, ptr %MEMORY, align 4
  store i32 %v2955, ptr %PC, align 4
  %v2960 = add i32 %v2955, 2
  store i32 %v2960, ptr %NEXT_PC, align 4
  %v2961 = load i32, ptr %EAX, align 4
  %v2962 = load ptr, ptr %MEMORY, align 4
  %v2963 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v2962, ptr %state, i32 %v2961, ptr %NEXT_PC, i32 %v2960, ptr %RETURN_PC)
  store ptr %v2963, ptr %MEMORY, align 4
  store i32 %v2960, ptr %PC, align 4
  %v2964 = add i32 %v2960, 3
  store i32 %v2964, ptr %NEXT_PC, align 4
  %v2965 = load i32, ptr %ESP, align 4
  %v2966 = load ptr, ptr %MEMORY, align 4
  %v2967 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2966, ptr %state, ptr %ESP, i32 %v2965, i32 16)
  store ptr %v2967, ptr %MEMORY, align 4
  store i32 %v2964, ptr %PC, align 4
  %v2968 = add i32 %v2964, 2
  store i32 %v2968, ptr %NEXT_PC, align 4
  %v2969 = add i32 %v2968, 1
  %v2970 = load ptr, ptr %MEMORY, align 4
  %v2971 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v2970, ptr %state, i32 %v2969, ptr %NEXT_PC)
  store ptr %v2971, ptr %MEMORY, align 4
  br label %bb_4202877

bb_4202876:                                       ; preds = %bb_4202664
  store i32 %v2652, ptr %PC, align 4
  %v2972 = add i32 %v2652, 1
  store i32 %v2972, ptr %NEXT_PC, align 4
  %v2973 = load ptr, ptr %MEMORY, align 4
  %v2974 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v2973, ptr %state)
  store ptr %v2974, ptr %MEMORY, align 4
  br label %bb_4202877

bb_4202877:                                       ; preds = %bb_4202876, %bb_4202818
  %v2975 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2975, ptr %PC, align 4
  %v2976 = add i32 %v2975, 4
  store i32 %v2976, ptr %NEXT_PC, align 4
  %v2977 = load i32, ptr %EBP, align 4
  %v2978 = load i32, ptr %SSBASE, align 4
  %v2979 = sub i32 %v2977, 12
  %v2980 = add i32 %v2979, %v2978
  %v2981 = load i32, ptr %EBP, align 4
  %v2982 = load i32, ptr %SSBASE, align 4
  %v2983 = sub i32 %v2981, 12
  %v2984 = add i32 %v2983, %v2982
  %v2985 = load ptr, ptr %MEMORY, align 4
  %v2986 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v2985, ptr %state, i32 %v2980, i32 %v2984, i32 1)
  store ptr %v2986, ptr %MEMORY, align 4
  br label %bb_4202881

bb_4202881:                                       ; preds = %bb_4202877, %bb_4202645
  %v2987 = load i32, ptr %NEXT_PC, align 4
  store i32 %v2987, ptr %PC, align 4
  %v2988 = add i32 %v2987, 5
  store i32 %v2988, ptr %NEXT_PC, align 4
  %v2989 = load i32, ptr %DSBASE, align 4
  %v2990 = add i32 4240292, %v2989
  %v2991 = load ptr, ptr %MEMORY, align 4
  %v2992 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2991, ptr %state, ptr %EAX, i32 %v2990)
  store ptr %v2992, ptr %MEMORY, align 4
  store i32 %v2988, ptr %PC, align 4
  %v2993 = add i32 %v2988, 3
  store i32 %v2993, ptr %NEXT_PC, align 4
  %v2994 = load i32, ptr %EBP, align 4
  %v2995 = load i32, ptr %SSBASE, align 4
  %v2996 = sub i32 %v2994, 12
  %v2997 = add i32 %v2996, %v2995
  %v2998 = load i32, ptr %EAX, align 4
  %v2999 = load ptr, ptr %MEMORY, align 4
  %v3000 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v2999, ptr %state, i32 %v2997, i32 %v2998)
  store ptr %v3000, ptr %MEMORY, align 4
  store i32 %v2993, ptr %PC, align 4
  %v3001 = add i32 %v2993, 6
  store i32 %v3001, ptr %NEXT_PC, align 4
  %v3002 = sub i32 %v3001, 231
  %v3003 = load ptr, ptr %MEMORY, align 4
  %v3004 = call ptr @_ZN12_GLOBAL__N_12JLEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3003, ptr %state, ptr %BRANCH_TAKEN, i32 %v3002, i32 %v3001, ptr %NEXT_PC)
  store ptr %v3004, ptr %MEMORY, align 4
  br i1 true, label %bb_4202664, label %bb_4202895

bb_4202895:                                       ; preds = %bb_4202881
  store i32 %v3001, ptr %PC, align 4
  %v3005 = add i32 %v3001, 3
  store i32 %v3005, ptr %NEXT_PC, align 4
  %v3006 = load i32, ptr %EBP, align 4
  %v3007 = load i32, ptr %SSBASE, align 4
  %v3008 = sub i32 %v3006, 4
  %v3009 = add i32 %v3008, %v3007
  %v3010 = load ptr, ptr %MEMORY, align 4
  %v3011 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3010, ptr %state, ptr %EBX, i32 %v3009)
  store ptr %v3011, ptr %MEMORY, align 4
  store i32 %v3005, ptr %PC, align 4
  %v3012 = add i32 %v3005, 1
  store i32 %v3012, ptr %NEXT_PC, align 4
  %v3013 = load ptr, ptr %MEMORY, align 4
  %v3014 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v3013, ptr %state)
  store ptr %v3014, ptr %MEMORY, align 4
  store i32 %v3012, ptr %PC, align 4
  %v3015 = add i32 %v3012, 1
  store i32 %v3015, ptr %NEXT_PC, align 4
  %v3016 = load ptr, ptr %MEMORY, align 4
  %v3017 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3016, ptr %state, ptr %NEXT_PC)
  store ptr %v3017, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202900:                                       ; No predecessors!
  %v3018 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3018, ptr %PC, align 4
  %v3019 = add i32 %v3018, 1
  store i32 %v3019, ptr %NEXT_PC, align 4
  %v3020 = load i32, ptr %EBP, align 4
  %v3021 = load ptr, ptr %MEMORY, align 4
  %v3022 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3021, ptr %state, i32 %v3020)
  store ptr %v3022, ptr %MEMORY, align 4
  store i32 %v3019, ptr %PC, align 4
  %v3023 = add i32 %v3019, 2
  store i32 %v3023, ptr %NEXT_PC, align 4
  %v3024 = load i32, ptr %ESP, align 4
  %v3025 = load ptr, ptr %MEMORY, align 4
  %v3026 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3025, ptr %state, ptr %EBP, i32 %v3024)
  store ptr %v3026, ptr %MEMORY, align 4
  store i32 %v3023, ptr %PC, align 4
  %v3027 = add i32 %v3023, 1
  store i32 %v3027, ptr %NEXT_PC, align 4
  %v3028 = load i32, ptr %EBX, align 4
  %v3029 = load ptr, ptr %MEMORY, align 4
  %v3030 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3029, ptr %state, i32 %v3028)
  store ptr %v3030, ptr %MEMORY, align 4
  store i32 %v3027, ptr %PC, align 4
  %v3031 = add i32 %v3027, 3
  store i32 %v3031, ptr %NEXT_PC, align 4
  %v3032 = load i32, ptr %ESP, align 4
  %v3033 = load ptr, ptr %MEMORY, align 4
  %v3034 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3033, ptr %state, ptr %ESP, i32 %v3032, i32 68)
  store ptr %v3034, ptr %MEMORY, align 4
  store i32 %v3031, ptr %PC, align 4
  %v3035 = add i32 %v3031, 7
  store i32 %v3035, ptr %NEXT_PC, align 4
  %v3036 = load i32, ptr %EBP, align 4
  %v3037 = load i32, ptr %SSBASE, align 4
  %v3038 = sub i32 %v3036, 12
  %v3039 = add i32 %v3038, %v3037
  %v3040 = load ptr, ptr %MEMORY, align 4
  %v3041 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3040, ptr %state, i32 %v3039, i32 0)
  store ptr %v3041, ptr %MEMORY, align 4
  store i32 %v3035, ptr %PC, align 4
  %v3042 = add i32 %v3035, 4
  store i32 %v3042, ptr %NEXT_PC, align 4
  %v3043 = load i32, ptr %EBP, align 4
  %v3044 = load i32, ptr %SSBASE, align 4
  %v3045 = add i32 %v3043, 16
  %v3046 = add i32 %v3045, %v3044
  %v3047 = load ptr, ptr %MEMORY, align 4
  %v3048 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3047, ptr %state, i32 %v3046, i32 0)
  store ptr %v3048, ptr %MEMORY, align 4
  store i32 %v3042, ptr %PC, align 4
  %v3049 = add i32 %v3042, 6
  store i32 %v3049, ptr %NEXT_PC, align 4
  %v3050 = add i32 %v3049, 218
  %v3051 = load ptr, ptr %MEMORY, align 4
  %v3052 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3051, ptr %state, ptr %BRANCH_TAKEN, i32 %v3050, i32 %v3049, ptr %NEXT_PC)
  store ptr %v3052, ptr %MEMORY, align 4
  br i1 true, label %bb_4203142, label %bb_4202924

bb_4202924:                                       ; preds = %bb_4202900
  store i32 %v3049, ptr %PC, align 4
  %v3053 = add i32 %v3049, 3
  store i32 %v3053, ptr %NEXT_PC, align 4
  %v3054 = load i32, ptr %EBP, align 4
  %v3055 = load i32, ptr %SSBASE, align 4
  %v3056 = add i32 %v3054, 8
  %v3057 = add i32 %v3056, %v3055
  %v3058 = load ptr, ptr %MEMORY, align 4
  %v3059 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3058, ptr %state, ptr %EAX, i32 %v3057)
  store ptr %v3059, ptr %MEMORY, align 4
  store i32 %v3053, ptr %PC, align 4
  %v3060 = add i32 %v3053, 3
  store i32 %v3060, ptr %NEXT_PC, align 4
  %v3061 = load i32, ptr %ESP, align 4
  %v3062 = load i32, ptr %SSBASE, align 4
  %v3063 = add i32 %v3061, %v3062
  %v3064 = load i32, ptr %EAX, align 4
  %v3065 = load ptr, ptr %MEMORY, align 4
  %v3066 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3065, ptr %state, i32 %v3063, i32 %v3064)
  store ptr %v3066, ptr %MEMORY, align 4
  store i32 %v3060, ptr %PC, align 4
  %v3067 = add i32 %v3060, 5
  store i32 %v3067, ptr %NEXT_PC, align 4
  %v3068 = sub i32 %v3067, 759
  %v3069 = load ptr, ptr %MEMORY, align 4
  %v3070 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3069, ptr %state, i64 4202176, ptr %NEXT_PC, i32 %v3067, ptr %RETURN_PC)
  store ptr %v3070, ptr %MEMORY, align 4
  store i32 %v3067, ptr %PC, align 4
  %v3071 = add i32 %v3067, 8
  store i32 %v3071, ptr %NEXT_PC, align 4
  %v3072 = load i32, ptr %ESP, align 4
  %v3073 = load i32, ptr %SSBASE, align 4
  %v3074 = add i32 %v3072, 8
  %v3075 = add i32 %v3074, %v3073
  %v3076 = load ptr, ptr %MEMORY, align 4
  %v3077 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3076, ptr %state, i32 %v3075, i32 28)
  store ptr %v3077, ptr %MEMORY, align 4
  store i32 %v3071, ptr %PC, align 4
  %v3078 = add i32 %v3071, 3
  store i32 %v3078, ptr %NEXT_PC, align 4
  %v3079 = load i32, ptr %EBP, align 4
  %v3080 = sub i32 %v3079, 40
  %v3081 = load ptr, ptr %MEMORY, align 4
  %v3082 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3081, ptr %state, ptr %EAX, i32 %v3080)
  store ptr %v3082, ptr %MEMORY, align 4
  store i32 %v3078, ptr %PC, align 4
  %v3083 = add i32 %v3078, 4
  store i32 %v3083, ptr %NEXT_PC, align 4
  %v3084 = load i32, ptr %ESP, align 4
  %v3085 = load i32, ptr %SSBASE, align 4
  %v3086 = add i32 %v3084, 4
  %v3087 = add i32 %v3086, %v3085
  %v3088 = load i32, ptr %EAX, align 4
  %v3089 = load ptr, ptr %MEMORY, align 4
  %v3090 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3089, ptr %state, i32 %v3087, i32 %v3088)
  store ptr %v3090, ptr %MEMORY, align 4
  store i32 %v3083, ptr %PC, align 4
  %v3091 = add i32 %v3083, 3
  store i32 %v3091, ptr %NEXT_PC, align 4
  %v3092 = load i32, ptr %EBP, align 4
  %v3093 = load i32, ptr %SSBASE, align 4
  %v3094 = add i32 %v3092, 8
  %v3095 = add i32 %v3094, %v3093
  %v3096 = load ptr, ptr %MEMORY, align 4
  %v3097 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3096, ptr %state, ptr %EAX, i32 %v3095)
  store ptr %v3097, ptr %MEMORY, align 4
  store i32 %v3091, ptr %PC, align 4
  %v3098 = add i32 %v3091, 3
  store i32 %v3098, ptr %NEXT_PC, align 4
  %v3099 = load i32, ptr %ESP, align 4
  %v3100 = load i32, ptr %SSBASE, align 4
  %v3101 = add i32 %v3099, %v3100
  %v3102 = load i32, ptr %EAX, align 4
  %v3103 = load ptr, ptr %MEMORY, align 4
  %v3104 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3103, ptr %state, i32 %v3101, i32 %v3102)
  store ptr %v3104, ptr %MEMORY, align 4
  store i32 %v3098, ptr %PC, align 4
  %v3105 = add i32 %v3098, 5
  store i32 %v3105, ptr %NEXT_PC, align 4
  %v3106 = load i32, ptr %DSBASE, align 4
  %v3107 = add i32 4243884, %v3106
  %v3108 = load ptr, ptr %MEMORY, align 4
  %v3109 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3108, ptr %state, ptr %EAX, i32 %v3107)
  store ptr %v3109, ptr %MEMORY, align 4
  store i32 %v3105, ptr %PC, align 4
  %v3110 = add i32 %v3105, 2
  store i32 %v3110, ptr %NEXT_PC, align 4
  %v3111 = load i32, ptr %EAX, align 4
  %v3112 = load ptr, ptr %MEMORY, align 4
  %v3113 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3112, ptr %state, i32 %v3111, ptr %NEXT_PC, i32 %v3110, ptr %RETURN_PC)
  store ptr %v3113, ptr %MEMORY, align 4
  store i32 %v3110, ptr %PC, align 4
  %v3114 = add i32 %v3110, 3
  store i32 %v3114, ptr %NEXT_PC, align 4
  %v3115 = load i32, ptr %ESP, align 4
  %v3116 = load ptr, ptr %MEMORY, align 4
  %v3117 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3116, ptr %state, ptr %ESP, i32 %v3115, i32 12)
  store ptr %v3117, ptr %MEMORY, align 4
  store i32 %v3114, ptr %PC, align 4
  %v3118 = add i32 %v3114, 2
  store i32 %v3118, ptr %NEXT_PC, align 4
  %v3119 = load i32, ptr %EAX, align 4
  %v3120 = load i32, ptr %EAX, align 4
  %v3121 = load ptr, ptr %MEMORY, align 4
  %v3122 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3121, ptr %state, i32 %v3119, i32 %v3120)
  store ptr %v3122, ptr %MEMORY, align 4
  store i32 %v3118, ptr %PC, align 4
  %v3123 = add i32 %v3118, 2
  store i32 %v3123, ptr %NEXT_PC, align 4
  %v3124 = add i32 %v3123, 27
  %v3125 = load ptr, ptr %MEMORY, align 4
  %v3126 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3125, ptr %state, ptr %BRANCH_TAKEN, i32 %v3124, i32 %v3123, ptr %NEXT_PC)
  store ptr %v3126, ptr %MEMORY, align 4
  br i1 true, label %bb_4202997, label %bb_4202970

bb_4202970:                                       ; preds = %bb_4202924
  store i32 %v3123, ptr %PC, align 4
  %v3127 = add i32 %v3123, 3
  store i32 %v3127, ptr %NEXT_PC, align 4
  %v3128 = load i32, ptr %EBP, align 4
  %v3129 = load i32, ptr %SSBASE, align 4
  %v3130 = add i32 %v3128, 8
  %v3131 = add i32 %v3130, %v3129
  %v3132 = load ptr, ptr %MEMORY, align 4
  %v3133 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3132, ptr %state, ptr %EAX, i32 %v3131)
  store ptr %v3133, ptr %MEMORY, align 4
  store i32 %v3127, ptr %PC, align 4
  %v3134 = add i32 %v3127, 4
  store i32 %v3134, ptr %NEXT_PC, align 4
  %v3135 = load i32, ptr %ESP, align 4
  %v3136 = load i32, ptr %SSBASE, align 4
  %v3137 = add i32 %v3135, 8
  %v3138 = add i32 %v3137, %v3136
  %v3139 = load i32, ptr %EAX, align 4
  %v3140 = load ptr, ptr %MEMORY, align 4
  %v3141 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3140, ptr %state, i32 %v3138, i32 %v3139)
  store ptr %v3141, ptr %MEMORY, align 4
  store i32 %v3134, ptr %PC, align 4
  %v3142 = add i32 %v3134, 8
  store i32 %v3142, ptr %NEXT_PC, align 4
  %v3143 = load i32, ptr %ESP, align 4
  %v3144 = load i32, ptr %SSBASE, align 4
  %v3145 = add i32 %v3143, 4
  %v3146 = add i32 %v3145, %v3144
  %v3147 = load ptr, ptr %MEMORY, align 4
  %v3148 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3147, ptr %state, i32 %v3146, i32 28)
  store ptr %v3148, ptr %MEMORY, align 4
  store i32 %v3142, ptr %PC, align 4
  %v3149 = add i32 %v3142, 7
  store i32 %v3149, ptr %NEXT_PC, align 4
  %v3150 = load i32, ptr %ESP, align 4
  %v3151 = load i32, ptr %SSBASE, align 4
  %v3152 = add i32 %v3150, %v3151
  %v3153 = load ptr, ptr %MEMORY, align 4
  %v3154 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3153, ptr %state, i32 %v3152, i32 4235736)
  store ptr %v3154, ptr %MEMORY, align 4
  store i32 %v3149, ptr %PC, align 4
  %v3155 = add i32 %v3149, 5
  store i32 %v3155, ptr %NEXT_PC, align 4
  %v3156 = sub i32 %v3155, 893
  %v3157 = load ptr, ptr %MEMORY, align 4
  %v3158 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3157, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v3155, ptr %RETURN_PC)
  store ptr %v3158, ptr %MEMORY, align 4
  ret ptr %memory

bb_4202997:                                       ; preds = %bb_4202924
  store i32 %v3123, ptr %PC, align 4
  %v3159 = add i32 %v3123, 3
  store i32 %v3159, ptr %NEXT_PC, align 4
  %v3160 = load i32, ptr %EBP, align 4
  %v3161 = load i32, ptr %SSBASE, align 4
  %v3162 = sub i32 %v3160, 20
  %v3163 = add i32 %v3162, %v3161
  %v3164 = load ptr, ptr %MEMORY, align 4
  %v3165 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3164, ptr %state, ptr %EAX, i32 %v3163)
  store ptr %v3165, ptr %MEMORY, align 4
  store i32 %v3159, ptr %PC, align 4
  %v3166 = add i32 %v3159, 3
  store i32 %v3166, ptr %NEXT_PC, align 4
  %v3167 = load i32, ptr %EAX, align 4
  %v3168 = load ptr, ptr %MEMORY, align 4
  %v3169 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3168, ptr %state, i32 %v3167, i32 64)
  store ptr %v3169, ptr %MEMORY, align 4
  store i32 %v3166, ptr %PC, align 4
  %v3170 = add i32 %v3166, 2
  store i32 %v3170, ptr %NEXT_PC, align 4
  %v3171 = add i32 %v3170, 53
  %v3172 = load ptr, ptr %MEMORY, align 4
  %v3173 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3172, ptr %state, ptr %BRANCH_TAKEN, i32 %v3171, i32 %v3170, ptr %NEXT_PC)
  store ptr %v3173, ptr %MEMORY, align 4
  br i1 true, label %bb_4203058, label %bb_4203005

bb_4203005:                                       ; preds = %bb_4202997
  store i32 %v3170, ptr %PC, align 4
  %v3174 = add i32 %v3170, 3
  store i32 %v3174, ptr %NEXT_PC, align 4
  %v3175 = load i32, ptr %EBP, align 4
  %v3176 = load i32, ptr %SSBASE, align 4
  %v3177 = sub i32 %v3175, 20
  %v3178 = add i32 %v3177, %v3176
  %v3179 = load ptr, ptr %MEMORY, align 4
  %v3180 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3179, ptr %state, ptr %EAX, i32 %v3178)
  store ptr %v3180, ptr %MEMORY, align 4
  store i32 %v3174, ptr %PC, align 4
  %v3181 = add i32 %v3174, 3
  store i32 %v3181, ptr %NEXT_PC, align 4
  %v3182 = load i32, ptr %EAX, align 4
  %v3183 = load ptr, ptr %MEMORY, align 4
  %v3184 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3183, ptr %state, i32 %v3182, i32 4)
  store ptr %v3184, ptr %MEMORY, align 4
  store i32 %v3181, ptr %PC, align 4
  %v3185 = add i32 %v3181, 2
  store i32 %v3185, ptr %NEXT_PC, align 4
  %v3186 = add i32 %v3185, 45
  %v3187 = load ptr, ptr %MEMORY, align 4
  %v3188 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3187, ptr %state, ptr %BRANCH_TAKEN, i32 %v3186, i32 %v3185, ptr %NEXT_PC)
  store ptr %v3188, ptr %MEMORY, align 4
  br i1 true, label %bb_4203058, label %bb_4203013

bb_4203013:                                       ; preds = %bb_4203005
  store i32 %v3185, ptr %PC, align 4
  %v3189 = add i32 %v3185, 7
  store i32 %v3189, ptr %NEXT_PC, align 4
  %v3190 = load i32, ptr %EBP, align 4
  %v3191 = load i32, ptr %SSBASE, align 4
  %v3192 = sub i32 %v3190, 12
  %v3193 = add i32 %v3192, %v3191
  %v3194 = load ptr, ptr %MEMORY, align 4
  %v3195 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3194, ptr %state, i32 %v3193, i32 1)
  store ptr %v3195, ptr %MEMORY, align 4
  store i32 %v3189, ptr %PC, align 4
  %v3196 = add i32 %v3189, 3
  store i32 %v3196, ptr %NEXT_PC, align 4
  %v3197 = load i32, ptr %EBP, align 4
  %v3198 = load i32, ptr %SSBASE, align 4
  %v3199 = sub i32 %v3197, 28
  %v3200 = add i32 %v3199, %v3198
  %v3201 = load ptr, ptr %MEMORY, align 4
  %v3202 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3201, ptr %state, ptr %EDX, i32 %v3200)
  store ptr %v3202, ptr %MEMORY, align 4
  store i32 %v3196, ptr %PC, align 4
  %v3203 = add i32 %v3196, 3
  store i32 %v3203, ptr %NEXT_PC, align 4
  %v3204 = load i32, ptr %EBP, align 4
  %v3205 = load i32, ptr %SSBASE, align 4
  %v3206 = sub i32 %v3204, 40
  %v3207 = add i32 %v3206, %v3205
  %v3208 = load ptr, ptr %MEMORY, align 4
  %v3209 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3208, ptr %state, ptr %EAX, i32 %v3207)
  store ptr %v3209, ptr %MEMORY, align 4
  store i32 %v3203, ptr %PC, align 4
  %v3210 = add i32 %v3203, 3
  store i32 %v3210, ptr %NEXT_PC, align 4
  %v3211 = load i32, ptr %EBP, align 4
  %v3212 = sub i32 %v3211, 44
  %v3213 = load ptr, ptr %MEMORY, align 4
  %v3214 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3213, ptr %state, ptr %ECX, i32 %v3212)
  store ptr %v3214, ptr %MEMORY, align 4
  store i32 %v3210, ptr %PC, align 4
  %v3215 = add i32 %v3210, 4
  store i32 %v3215, ptr %NEXT_PC, align 4
  %v3216 = load i32, ptr %ESP, align 4
  %v3217 = load i32, ptr %SSBASE, align 4
  %v3218 = add i32 %v3216, 12
  %v3219 = add i32 %v3218, %v3217
  %v3220 = load i32, ptr %ECX, align 4
  %v3221 = load ptr, ptr %MEMORY, align 4
  %v3222 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3221, ptr %state, i32 %v3219, i32 %v3220)
  store ptr %v3222, ptr %MEMORY, align 4
  store i32 %v3215, ptr %PC, align 4
  %v3223 = add i32 %v3215, 8
  store i32 %v3223, ptr %NEXT_PC, align 4
  %v3224 = load i32, ptr %ESP, align 4
  %v3225 = load i32, ptr %SSBASE, align 4
  %v3226 = add i32 %v3224, 8
  %v3227 = add i32 %v3226, %v3225
  %v3228 = load ptr, ptr %MEMORY, align 4
  %v3229 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3228, ptr %state, i32 %v3227, i32 64)
  store ptr %v3229, ptr %MEMORY, align 4
  store i32 %v3223, ptr %PC, align 4
  %v3230 = add i32 %v3223, 4
  store i32 %v3230, ptr %NEXT_PC, align 4
  %v3231 = load i32, ptr %ESP, align 4
  %v3232 = load i32, ptr %SSBASE, align 4
  %v3233 = add i32 %v3231, 4
  %v3234 = add i32 %v3233, %v3232
  %v3235 = load i32, ptr %EDX, align 4
  %v3236 = load ptr, ptr %MEMORY, align 4
  %v3237 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3236, ptr %state, i32 %v3234, i32 %v3235)
  store ptr %v3237, ptr %MEMORY, align 4
  store i32 %v3230, ptr %PC, align 4
  %v3238 = add i32 %v3230, 3
  store i32 %v3238, ptr %NEXT_PC, align 4
  %v3239 = load i32, ptr %ESP, align 4
  %v3240 = load i32, ptr %SSBASE, align 4
  %v3241 = add i32 %v3239, %v3240
  %v3242 = load i32, ptr %EAX, align 4
  %v3243 = load ptr, ptr %MEMORY, align 4
  %v3244 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3243, ptr %state, i32 %v3241, i32 %v3242)
  store ptr %v3244, ptr %MEMORY, align 4
  store i32 %v3238, ptr %PC, align 4
  %v3245 = add i32 %v3238, 5
  store i32 %v3245, ptr %NEXT_PC, align 4
  %v3246 = load i32, ptr %DSBASE, align 4
  %v3247 = add i32 4243880, %v3246
  %v3248 = load ptr, ptr %MEMORY, align 4
  %v3249 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3248, ptr %state, ptr %EAX, i32 %v3247)
  store ptr %v3249, ptr %MEMORY, align 4
  store i32 %v3245, ptr %PC, align 4
  %v3250 = add i32 %v3245, 2
  store i32 %v3250, ptr %NEXT_PC, align 4
  %v3251 = load i32, ptr %EAX, align 4
  %v3252 = load ptr, ptr %MEMORY, align 4
  %v3253 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3252, ptr %state, i32 %v3251, ptr %NEXT_PC, i32 %v3250, ptr %RETURN_PC)
  store ptr %v3253, ptr %MEMORY, align 4
  store i32 %v3250, ptr %PC, align 4
  %v3254 = add i32 %v3250, 3
  store i32 %v3254, ptr %NEXT_PC, align 4
  %v3255 = load i32, ptr %ESP, align 4
  %v3256 = load ptr, ptr %MEMORY, align 4
  %v3257 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3256, ptr %state, ptr %ESP, i32 %v3255, i32 16)
  store ptr %v3257, ptr %MEMORY, align 4
  br label %bb_4203058

bb_4203058:                                       ; preds = %bb_4203013, %bb_4203005, %bb_4202997
  %v3258 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3258, ptr %PC, align 4
  %v3259 = add i32 %v3258, 3
  store i32 %v3259, ptr %NEXT_PC, align 4
  %v3260 = load i32, ptr %EBP, align 4
  %v3261 = load i32, ptr %SSBASE, align 4
  %v3262 = add i32 %v3260, 16
  %v3263 = add i32 %v3262, %v3261
  %v3264 = load ptr, ptr %MEMORY, align 4
  %v3265 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3264, ptr %state, ptr %EAX, i32 %v3263)
  store ptr %v3265, ptr %MEMORY, align 4
  store i32 %v3259, ptr %PC, align 4
  %v3266 = add i32 %v3259, 4
  store i32 %v3266, ptr %NEXT_PC, align 4
  %v3267 = load i32, ptr %ESP, align 4
  %v3268 = load i32, ptr %SSBASE, align 4
  %v3269 = add i32 %v3267, 8
  %v3270 = add i32 %v3269, %v3268
  %v3271 = load i32, ptr %EAX, align 4
  %v3272 = load ptr, ptr %MEMORY, align 4
  %v3273 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3272, ptr %state, i32 %v3270, i32 %v3271)
  store ptr %v3273, ptr %MEMORY, align 4
  store i32 %v3266, ptr %PC, align 4
  %v3274 = add i32 %v3266, 3
  store i32 %v3274, ptr %NEXT_PC, align 4
  %v3275 = load i32, ptr %EBP, align 4
  %v3276 = load i32, ptr %SSBASE, align 4
  %v3277 = add i32 %v3275, 12
  %v3278 = add i32 %v3277, %v3276
  %v3279 = load ptr, ptr %MEMORY, align 4
  %v3280 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3279, ptr %state, ptr %EAX, i32 %v3278)
  store ptr %v3280, ptr %MEMORY, align 4
  store i32 %v3274, ptr %PC, align 4
  %v3281 = add i32 %v3274, 4
  store i32 %v3281, ptr %NEXT_PC, align 4
  %v3282 = load i32, ptr %ESP, align 4
  %v3283 = load i32, ptr %SSBASE, align 4
  %v3284 = add i32 %v3282, 4
  %v3285 = add i32 %v3284, %v3283
  %v3286 = load i32, ptr %EAX, align 4
  %v3287 = load ptr, ptr %MEMORY, align 4
  %v3288 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3287, ptr %state, i32 %v3285, i32 %v3286)
  store ptr %v3288, ptr %MEMORY, align 4
  store i32 %v3281, ptr %PC, align 4
  %v3289 = add i32 %v3281, 3
  store i32 %v3289, ptr %NEXT_PC, align 4
  %v3290 = load i32, ptr %EBP, align 4
  %v3291 = load i32, ptr %SSBASE, align 4
  %v3292 = add i32 %v3290, 8
  %v3293 = add i32 %v3292, %v3291
  %v3294 = load ptr, ptr %MEMORY, align 4
  %v3295 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3294, ptr %state, ptr %EAX, i32 %v3293)
  store ptr %v3295, ptr %MEMORY, align 4
  store i32 %v3289, ptr %PC, align 4
  %v3296 = add i32 %v3289, 3
  store i32 %v3296, ptr %NEXT_PC, align 4
  %v3297 = load i32, ptr %ESP, align 4
  %v3298 = load i32, ptr %SSBASE, align 4
  %v3299 = add i32 %v3297, %v3298
  %v3300 = load i32, ptr %EAX, align 4
  %v3301 = load ptr, ptr %MEMORY, align 4
  %v3302 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3301, ptr %state, i32 %v3299, i32 %v3300)
  store ptr %v3302, ptr %MEMORY, align 4
  store i32 %v3296, ptr %PC, align 4
  %v3303 = add i32 %v3296, 5
  store i32 %v3303, ptr %NEXT_PC, align 4
  %v3304 = add i32 %v3303, 25497
  %v3305 = load ptr, ptr %MEMORY, align 4
  %v3306 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3305, ptr %state, i64 4228580, ptr %NEXT_PC, i32 %v3303, ptr %RETURN_PC)
  store ptr %v3306, ptr %MEMORY, align 4
  store i32 %v3303, ptr %PC, align 4
  %v3307 = add i32 %v3303, 4
  store i32 %v3307, ptr %NEXT_PC, align 4
  %v3308 = load i32, ptr %EBP, align 4
  %v3309 = load i32, ptr %SSBASE, align 4
  %v3310 = sub i32 %v3308, 12
  %v3311 = add i32 %v3310, %v3309
  %v3312 = load ptr, ptr %MEMORY, align 4
  %v3313 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3312, ptr %state, i32 %v3311, i32 0)
  store ptr %v3313, ptr %MEMORY, align 4
  store i32 %v3307, ptr %PC, align 4
  %v3314 = add i32 %v3307, 2
  store i32 %v3314, ptr %NEXT_PC, align 4
  %v3315 = add i32 %v3314, 53
  %v3316 = load ptr, ptr %MEMORY, align 4
  %v3317 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3316, ptr %state, ptr %BRANCH_TAKEN, i32 %v3315, i32 %v3314, ptr %NEXT_PC)
  store ptr %v3317, ptr %MEMORY, align 4
  br i1 true, label %bb_4203142, label %bb_4203089

bb_4203089:                                       ; preds = %bb_4203058
  store i32 %v3314, ptr %PC, align 4
  %v3318 = add i32 %v3314, 3
  store i32 %v3318, ptr %NEXT_PC, align 4
  %v3319 = load i32, ptr %EBP, align 4
  %v3320 = load i32, ptr %SSBASE, align 4
  %v3321 = sub i32 %v3319, 20
  %v3322 = add i32 %v3321, %v3320
  %v3323 = load ptr, ptr %MEMORY, align 4
  %v3324 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3323, ptr %state, ptr %EAX, i32 %v3322)
  store ptr %v3324, ptr %MEMORY, align 4
  store i32 %v3318, ptr %PC, align 4
  %v3325 = add i32 %v3318, 3
  store i32 %v3325, ptr %NEXT_PC, align 4
  %v3326 = load i32, ptr %EAX, align 4
  %v3327 = load ptr, ptr %MEMORY, align 4
  %v3328 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3327, ptr %state, i32 %v3326, i32 64)
  store ptr %v3328, ptr %MEMORY, align 4
  store i32 %v3325, ptr %PC, align 4
  %v3329 = add i32 %v3325, 2
  store i32 %v3329, ptr %NEXT_PC, align 4
  %v3330 = add i32 %v3329, 45
  %v3331 = load ptr, ptr %MEMORY, align 4
  %v3332 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3331, ptr %state, ptr %BRANCH_TAKEN, i32 %v3330, i32 %v3329, ptr %NEXT_PC)
  store ptr %v3332, ptr %MEMORY, align 4
  br i1 true, label %bb_4203142, label %bb_4203097

bb_4203097:                                       ; preds = %bb_4203089
  store i32 %v3329, ptr %PC, align 4
  %v3333 = add i32 %v3329, 3
  store i32 %v3333, ptr %NEXT_PC, align 4
  %v3334 = load i32, ptr %EBP, align 4
  %v3335 = load i32, ptr %SSBASE, align 4
  %v3336 = sub i32 %v3334, 20
  %v3337 = add i32 %v3336, %v3335
  %v3338 = load ptr, ptr %MEMORY, align 4
  %v3339 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3338, ptr %state, ptr %EAX, i32 %v3337)
  store ptr %v3339, ptr %MEMORY, align 4
  store i32 %v3333, ptr %PC, align 4
  %v3340 = add i32 %v3333, 3
  store i32 %v3340, ptr %NEXT_PC, align 4
  %v3341 = load i32, ptr %EAX, align 4
  %v3342 = load ptr, ptr %MEMORY, align 4
  %v3343 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3342, ptr %state, i32 %v3341, i32 4)
  store ptr %v3343, ptr %MEMORY, align 4
  store i32 %v3340, ptr %PC, align 4
  %v3344 = add i32 %v3340, 2
  store i32 %v3344, ptr %NEXT_PC, align 4
  %v3345 = add i32 %v3344, 37
  %v3346 = load ptr, ptr %MEMORY, align 4
  %v3347 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3346, ptr %state, ptr %BRANCH_TAKEN, i32 %v3345, i32 %v3344, ptr %NEXT_PC)
  store ptr %v3347, ptr %MEMORY, align 4
  br i1 true, label %bb_4203142, label %bb_4203105

bb_4203105:                                       ; preds = %bb_4203097
  store i32 %v3344, ptr %PC, align 4
  %v3348 = add i32 %v3344, 3
  store i32 %v3348, ptr %NEXT_PC, align 4
  %v3349 = load i32, ptr %EBP, align 4
  %v3350 = load i32, ptr %SSBASE, align 4
  %v3351 = sub i32 %v3349, 44
  %v3352 = add i32 %v3351, %v3350
  %v3353 = load ptr, ptr %MEMORY, align 4
  %v3354 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3353, ptr %state, ptr %ECX, i32 %v3352)
  store ptr %v3354, ptr %MEMORY, align 4
  store i32 %v3348, ptr %PC, align 4
  %v3355 = add i32 %v3348, 3
  store i32 %v3355, ptr %NEXT_PC, align 4
  %v3356 = load i32, ptr %EBP, align 4
  %v3357 = load i32, ptr %SSBASE, align 4
  %v3358 = sub i32 %v3356, 28
  %v3359 = add i32 %v3358, %v3357
  %v3360 = load ptr, ptr %MEMORY, align 4
  %v3361 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3360, ptr %state, ptr %EDX, i32 %v3359)
  store ptr %v3361, ptr %MEMORY, align 4
  store i32 %v3355, ptr %PC, align 4
  %v3362 = add i32 %v3355, 3
  store i32 %v3362, ptr %NEXT_PC, align 4
  %v3363 = load i32, ptr %EBP, align 4
  %v3364 = load i32, ptr %SSBASE, align 4
  %v3365 = sub i32 %v3363, 40
  %v3366 = add i32 %v3365, %v3364
  %v3367 = load ptr, ptr %MEMORY, align 4
  %v3368 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3367, ptr %state, ptr %EAX, i32 %v3366)
  store ptr %v3368, ptr %MEMORY, align 4
  store i32 %v3362, ptr %PC, align 4
  %v3369 = add i32 %v3362, 3
  store i32 %v3369, ptr %NEXT_PC, align 4
  %v3370 = load i32, ptr %EBP, align 4
  %v3371 = sub i32 %v3370, 44
  %v3372 = load ptr, ptr %MEMORY, align 4
  %v3373 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3372, ptr %state, ptr %EBX, i32 %v3371)
  store ptr %v3373, ptr %MEMORY, align 4
  store i32 %v3369, ptr %PC, align 4
  %v3374 = add i32 %v3369, 4
  store i32 %v3374, ptr %NEXT_PC, align 4
  %v3375 = load i32, ptr %ESP, align 4
  %v3376 = load i32, ptr %SSBASE, align 4
  %v3377 = add i32 %v3375, 12
  %v3378 = add i32 %v3377, %v3376
  %v3379 = load i32, ptr %EBX, align 4
  %v3380 = load ptr, ptr %MEMORY, align 4
  %v3381 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3380, ptr %state, i32 %v3378, i32 %v3379)
  store ptr %v3381, ptr %MEMORY, align 4
  store i32 %v3374, ptr %PC, align 4
  %v3382 = add i32 %v3374, 4
  store i32 %v3382, ptr %NEXT_PC, align 4
  %v3383 = load i32, ptr %ESP, align 4
  %v3384 = load i32, ptr %SSBASE, align 4
  %v3385 = add i32 %v3383, 8
  %v3386 = add i32 %v3385, %v3384
  %v3387 = load i32, ptr %ECX, align 4
  %v3388 = load ptr, ptr %MEMORY, align 4
  %v3389 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3388, ptr %state, i32 %v3386, i32 %v3387)
  store ptr %v3389, ptr %MEMORY, align 4
  store i32 %v3382, ptr %PC, align 4
  %v3390 = add i32 %v3382, 4
  store i32 %v3390, ptr %NEXT_PC, align 4
  %v3391 = load i32, ptr %ESP, align 4
  %v3392 = load i32, ptr %SSBASE, align 4
  %v3393 = add i32 %v3391, 4
  %v3394 = add i32 %v3393, %v3392
  %v3395 = load i32, ptr %EDX, align 4
  %v3396 = load ptr, ptr %MEMORY, align 4
  %v3397 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3396, ptr %state, i32 %v3394, i32 %v3395)
  store ptr %v3397, ptr %MEMORY, align 4
  store i32 %v3390, ptr %PC, align 4
  %v3398 = add i32 %v3390, 3
  store i32 %v3398, ptr %NEXT_PC, align 4
  %v3399 = load i32, ptr %ESP, align 4
  %v3400 = load i32, ptr %SSBASE, align 4
  %v3401 = add i32 %v3399, %v3400
  %v3402 = load i32, ptr %EAX, align 4
  %v3403 = load ptr, ptr %MEMORY, align 4
  %v3404 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3403, ptr %state, i32 %v3401, i32 %v3402)
  store ptr %v3404, ptr %MEMORY, align 4
  store i32 %v3398, ptr %PC, align 4
  %v3405 = add i32 %v3398, 5
  store i32 %v3405, ptr %NEXT_PC, align 4
  %v3406 = load i32, ptr %DSBASE, align 4
  %v3407 = add i32 4243880, %v3406
  %v3408 = load ptr, ptr %MEMORY, align 4
  %v3409 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3408, ptr %state, ptr %EAX, i32 %v3407)
  store ptr %v3409, ptr %MEMORY, align 4
  store i32 %v3405, ptr %PC, align 4
  %v3410 = add i32 %v3405, 2
  store i32 %v3410, ptr %NEXT_PC, align 4
  %v3411 = load i32, ptr %EAX, align 4
  %v3412 = load ptr, ptr %MEMORY, align 4
  %v3413 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v3412, ptr %state, i32 %v3411, ptr %NEXT_PC, i32 %v3410, ptr %RETURN_PC)
  store ptr %v3413, ptr %MEMORY, align 4
  store i32 %v3410, ptr %PC, align 4
  %v3414 = add i32 %v3410, 3
  store i32 %v3414, ptr %NEXT_PC, align 4
  %v3415 = load i32, ptr %ESP, align 4
  %v3416 = load ptr, ptr %MEMORY, align 4
  %v3417 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3416, ptr %state, ptr %ESP, i32 %v3415, i32 16)
  store ptr %v3417, ptr %MEMORY, align 4
  br label %bb_4203142

bb_4203142:                                       ; preds = %bb_4203105, %bb_4203097, %bb_4203089, %bb_4203058, %bb_4202900
  %v3418 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3418, ptr %PC, align 4
  %v3419 = add i32 %v3418, 3
  store i32 %v3419, ptr %NEXT_PC, align 4
  %v3420 = load i32, ptr %EBP, align 4
  %v3421 = load i32, ptr %SSBASE, align 4
  %v3422 = sub i32 %v3420, 4
  %v3423 = add i32 %v3422, %v3421
  %v3424 = load ptr, ptr %MEMORY, align 4
  %v3425 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3424, ptr %state, ptr %EBX, i32 %v3423)
  store ptr %v3425, ptr %MEMORY, align 4
  store i32 %v3419, ptr %PC, align 4
  %v3426 = add i32 %v3419, 1
  store i32 %v3426, ptr %NEXT_PC, align 4
  %v3427 = load ptr, ptr %MEMORY, align 4
  %v3428 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v3427, ptr %state)
  store ptr %v3428, ptr %MEMORY, align 4
  store i32 %v3426, ptr %PC, align 4
  %v3429 = add i32 %v3426, 1
  store i32 %v3429, ptr %NEXT_PC, align 4
  %v3430 = load ptr, ptr %MEMORY, align 4
  %v3431 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v3430, ptr %state, ptr %NEXT_PC)
  store ptr %v3431, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203147:                                       ; No predecessors!
  %v3432 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3432, ptr %PC, align 4
  %v3433 = add i32 %v3432, 1
  store i32 %v3433, ptr %NEXT_PC, align 4
  %v3434 = load i32, ptr %EBP, align 4
  %v3435 = load ptr, ptr %MEMORY, align 4
  %v3436 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v3435, ptr %state, i32 %v3434)
  store ptr %v3436, ptr %MEMORY, align 4
  store i32 %v3433, ptr %PC, align 4
  %v3437 = add i32 %v3433, 2
  store i32 %v3437, ptr %NEXT_PC, align 4
  %v3438 = load i32, ptr %ESP, align 4
  %v3439 = load ptr, ptr %MEMORY, align 4
  %v3440 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3439, ptr %state, ptr %EBP, i32 %v3438)
  store ptr %v3440, ptr %MEMORY, align 4
  store i32 %v3437, ptr %PC, align 4
  %v3441 = add i32 %v3437, 3
  store i32 %v3441, ptr %NEXT_PC, align 4
  %v3442 = load i32, ptr %ESP, align 4
  %v3443 = load ptr, ptr %MEMORY, align 4
  %v3444 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3443, ptr %state, ptr %ESP, i32 %v3442, i32 56)
  store ptr %v3444, ptr %MEMORY, align 4
  store i32 %v3441, ptr %PC, align 4
  %v3445 = add i32 %v3441, 3
  store i32 %v3445, ptr %NEXT_PC, align 4
  %v3446 = load i32, ptr %EBP, align 4
  %v3447 = load i32, ptr %SSBASE, align 4
  %v3448 = add i32 %v3446, 12
  %v3449 = add i32 %v3448, %v3447
  %v3450 = load ptr, ptr %MEMORY, align 4
  %v3451 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3450, ptr %state, ptr %EDX, i32 %v3449)
  store ptr %v3451, ptr %MEMORY, align 4
  store i32 %v3445, ptr %PC, align 4
  %v3452 = add i32 %v3445, 3
  store i32 %v3452, ptr %NEXT_PC, align 4
  %v3453 = load i32, ptr %EBP, align 4
  %v3454 = load i32, ptr %SSBASE, align 4
  %v3455 = add i32 %v3453, 8
  %v3456 = add i32 %v3455, %v3454
  %v3457 = load ptr, ptr %MEMORY, align 4
  %v3458 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3457, ptr %state, ptr %EAX, i32 %v3456)
  store ptr %v3458, ptr %MEMORY, align 4
  store i32 %v3452, ptr %PC, align 4
  %v3459 = add i32 %v3452, 2
  store i32 %v3459, ptr %NEXT_PC, align 4
  %v3460 = load i32, ptr %EDX, align 4
  %v3461 = load ptr, ptr %MEMORY, align 4
  %v3462 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3461, ptr %state, ptr %ECX, i32 %v3460)
  store ptr %v3462, ptr %MEMORY, align 4
  store i32 %v3459, ptr %PC, align 4
  %v3463 = add i32 %v3459, 2
  store i32 %v3463, ptr %NEXT_PC, align 4
  %v3464 = load i32, ptr %ECX, align 4
  %v3465 = load i32, ptr %EAX, align 4
  %v3466 = load ptr, ptr %MEMORY, align 4
  %v3467 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3466, ptr %state, ptr %ECX, i32 %v3464, i32 %v3465)
  store ptr %v3467, ptr %MEMORY, align 4
  store i32 %v3463, ptr %PC, align 4
  %v3468 = add i32 %v3463, 2
  store i32 %v3468, ptr %NEXT_PC, align 4
  %v3469 = load i32, ptr %ECX, align 4
  %v3470 = load ptr, ptr %MEMORY, align 4
  %v3471 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3470, ptr %state, ptr %EAX, i32 %v3469)
  store ptr %v3471, ptr %MEMORY, align 4
  store i32 %v3468, ptr %PC, align 4
  %v3472 = add i32 %v3468, 3
  store i32 %v3472, ptr %NEXT_PC, align 4
  %v3473 = load i32, ptr %EBP, align 4
  %v3474 = load i32, ptr %SSBASE, align 4
  %v3475 = sub i32 %v3473, 24
  %v3476 = add i32 %v3475, %v3474
  %v3477 = load i32, ptr %EAX, align 4
  %v3478 = load ptr, ptr %MEMORY, align 4
  %v3479 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3478, ptr %state, i32 %v3476, i32 %v3477)
  store ptr %v3479, ptr %MEMORY, align 4
  store i32 %v3472, ptr %PC, align 4
  %v3480 = add i32 %v3472, 3
  store i32 %v3480, ptr %NEXT_PC, align 4
  %v3481 = load i32, ptr %EBP, align 4
  %v3482 = load i32, ptr %SSBASE, align 4
  %v3483 = add i32 %v3481, 8
  %v3484 = add i32 %v3483, %v3482
  %v3485 = load ptr, ptr %MEMORY, align 4
  %v3486 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3485, ptr %state, ptr %EAX, i32 %v3484)
  store ptr %v3486, ptr %MEMORY, align 4
  store i32 %v3480, ptr %PC, align 4
  %v3487 = add i32 %v3480, 3
  store i32 %v3487, ptr %NEXT_PC, align 4
  %v3488 = load i32, ptr %EBP, align 4
  %v3489 = load i32, ptr %SSBASE, align 4
  %v3490 = sub i32 %v3488, 12
  %v3491 = add i32 %v3490, %v3489
  %v3492 = load i32, ptr %EAX, align 4
  %v3493 = load ptr, ptr %MEMORY, align 4
  %v3494 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3493, ptr %state, i32 %v3491, i32 %v3492)
  store ptr %v3494, ptr %MEMORY, align 4
  store i32 %v3487, ptr %PC, align 4
  %v3495 = add i32 %v3487, 4
  store i32 %v3495, ptr %NEXT_PC, align 4
  %v3496 = load i32, ptr %EBP, align 4
  %v3497 = load i32, ptr %SSBASE, align 4
  %v3498 = sub i32 %v3496, 24
  %v3499 = add i32 %v3498, %v3497
  %v3500 = load ptr, ptr %MEMORY, align 4
  %v3501 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3500, ptr %state, i32 %v3499, i32 7)
  store ptr %v3501, ptr %MEMORY, align 4
  store i32 %v3495, ptr %PC, align 4
  %v3502 = add i32 %v3495, 6
  store i32 %v3502, ptr %NEXT_PC, align 4
  %v3503 = add i32 %v3502, 528
  %v3504 = load ptr, ptr %MEMORY, align 4
  %v3505 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3504, ptr %state, ptr %BRANCH_TAKEN, i32 %v3503, i32 %v3502, ptr %NEXT_PC)
  store ptr %v3505, ptr %MEMORY, align 4
  br i1 true, label %bb_4203712, label %bb_4203184

bb_4203184:                                       ; preds = %bb_4203147
  store i32 %v3502, ptr %PC, align 4
  %v3506 = add i32 %v3502, 4
  store i32 %v3506, ptr %NEXT_PC, align 4
  %v3507 = load i32, ptr %EBP, align 4
  %v3508 = load i32, ptr %SSBASE, align 4
  %v3509 = sub i32 %v3507, 24
  %v3510 = add i32 %v3509, %v3508
  %v3511 = load ptr, ptr %MEMORY, align 4
  %v3512 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3511, ptr %state, i32 %v3510, i32 11)
  store ptr %v3512, ptr %MEMORY, align 4
  store i32 %v3506, ptr %PC, align 4
  %v3513 = add i32 %v3506, 2
  store i32 %v3513, ptr %NEXT_PC, align 4
  %v3514 = add i32 %v3513, 33
  %v3515 = load ptr, ptr %MEMORY, align 4
  %v3516 = call ptr @_ZN12_GLOBAL__N_13JLEEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3515, ptr %state, ptr %BRANCH_TAKEN, i32 %v3514, i32 %v3513, ptr %NEXT_PC)
  store ptr %v3516, ptr %MEMORY, align 4
  br i1 true, label %bb_4203223, label %bb_4203190

bb_4203190:                                       ; preds = %bb_4203184
  store i32 %v3513, ptr %PC, align 4
  %v3517 = add i32 %v3513, 3
  store i32 %v3517, ptr %NEXT_PC, align 4
  %v3518 = load i32, ptr %EBP, align 4
  %v3519 = load i32, ptr %SSBASE, align 4
  %v3520 = sub i32 %v3518, 12
  %v3521 = add i32 %v3520, %v3519
  %v3522 = load ptr, ptr %MEMORY, align 4
  %v3523 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3522, ptr %state, ptr %EAX, i32 %v3521)
  store ptr %v3523, ptr %MEMORY, align 4
  store i32 %v3517, ptr %PC, align 4
  %v3524 = add i32 %v3517, 2
  store i32 %v3524, ptr %NEXT_PC, align 4
  %v3525 = load i32, ptr %EAX, align 4
  %v3526 = load i32, ptr %DSBASE, align 4
  %v3527 = add i32 %v3525, %v3526
  %v3528 = load ptr, ptr %MEMORY, align 4
  %v3529 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3528, ptr %state, ptr %EAX, i32 %v3527)
  store ptr %v3529, ptr %MEMORY, align 4
  store i32 %v3524, ptr %PC, align 4
  %v3530 = add i32 %v3524, 2
  store i32 %v3530, ptr %NEXT_PC, align 4
  %v3531 = load i32, ptr %EAX, align 4
  %v3532 = load i32, ptr %EAX, align 4
  %v3533 = load ptr, ptr %MEMORY, align 4
  %v3534 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3533, ptr %state, i32 %v3531, i32 %v3532)
  store ptr %v3534, ptr %MEMORY, align 4
  store i32 %v3530, ptr %PC, align 4
  %v3535 = add i32 %v3530, 2
  store i32 %v3535, ptr %NEXT_PC, align 4
  %v3536 = add i32 %v3535, 24
  %v3537 = load ptr, ptr %MEMORY, align 4
  %v3538 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3537, ptr %state, ptr %BRANCH_TAKEN, i32 %v3536, i32 %v3535, ptr %NEXT_PC)
  store ptr %v3538, ptr %MEMORY, align 4
  br i1 true, label %bb_4203223, label %bb_4203199

bb_4203199:                                       ; preds = %bb_4203190
  store i32 %v3535, ptr %PC, align 4
  %v3539 = add i32 %v3535, 3
  store i32 %v3539, ptr %NEXT_PC, align 4
  %v3540 = load i32, ptr %EBP, align 4
  %v3541 = load i32, ptr %SSBASE, align 4
  %v3542 = sub i32 %v3540, 12
  %v3543 = add i32 %v3542, %v3541
  %v3544 = load ptr, ptr %MEMORY, align 4
  %v3545 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3544, ptr %state, ptr %EAX, i32 %v3543)
  store ptr %v3545, ptr %MEMORY, align 4
  store i32 %v3539, ptr %PC, align 4
  %v3546 = add i32 %v3539, 3
  store i32 %v3546, ptr %NEXT_PC, align 4
  %v3547 = load i32, ptr %EAX, align 4
  %v3548 = load i32, ptr %DSBASE, align 4
  %v3549 = add i32 %v3547, 4
  %v3550 = add i32 %v3549, %v3548
  %v3551 = load ptr, ptr %MEMORY, align 4
  %v3552 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3551, ptr %state, ptr %EAX, i32 %v3550)
  store ptr %v3552, ptr %MEMORY, align 4
  store i32 %v3546, ptr %PC, align 4
  %v3553 = add i32 %v3546, 2
  store i32 %v3553, ptr %NEXT_PC, align 4
  %v3554 = load i32, ptr %EAX, align 4
  %v3555 = load i32, ptr %EAX, align 4
  %v3556 = load ptr, ptr %MEMORY, align 4
  %v3557 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3556, ptr %state, i32 %v3554, i32 %v3555)
  store ptr %v3557, ptr %MEMORY, align 4
  store i32 %v3553, ptr %PC, align 4
  %v3558 = add i32 %v3553, 2
  store i32 %v3558, ptr %NEXT_PC, align 4
  %v3559 = add i32 %v3558, 14
  %v3560 = load ptr, ptr %MEMORY, align 4
  %v3561 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3560, ptr %state, ptr %BRANCH_TAKEN, i32 %v3559, i32 %v3558, ptr %NEXT_PC)
  store ptr %v3561, ptr %MEMORY, align 4
  br i1 true, label %bb_4203223, label %bb_4203209

bb_4203209:                                       ; preds = %bb_4203199
  store i32 %v3558, ptr %PC, align 4
  %v3562 = add i32 %v3558, 3
  store i32 %v3562, ptr %NEXT_PC, align 4
  %v3563 = load i32, ptr %EBP, align 4
  %v3564 = load i32, ptr %SSBASE, align 4
  %v3565 = sub i32 %v3563, 12
  %v3566 = add i32 %v3565, %v3564
  %v3567 = load ptr, ptr %MEMORY, align 4
  %v3568 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3567, ptr %state, ptr %EAX, i32 %v3566)
  store ptr %v3568, ptr %MEMORY, align 4
  store i32 %v3562, ptr %PC, align 4
  %v3569 = add i32 %v3562, 3
  store i32 %v3569, ptr %NEXT_PC, align 4
  %v3570 = load i32, ptr %EAX, align 4
  %v3571 = load i32, ptr %DSBASE, align 4
  %v3572 = add i32 %v3570, 8
  %v3573 = add i32 %v3572, %v3571
  %v3574 = load ptr, ptr %MEMORY, align 4
  %v3575 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3574, ptr %state, ptr %EAX, i32 %v3573)
  store ptr %v3575, ptr %MEMORY, align 4
  store i32 %v3569, ptr %PC, align 4
  %v3576 = add i32 %v3569, 2
  store i32 %v3576, ptr %NEXT_PC, align 4
  %v3577 = load i32, ptr %EAX, align 4
  %v3578 = load i32, ptr %EAX, align 4
  %v3579 = load ptr, ptr %MEMORY, align 4
  %v3580 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3579, ptr %state, i32 %v3577, i32 %v3578)
  store ptr %v3580, ptr %MEMORY, align 4
  store i32 %v3576, ptr %PC, align 4
  %v3581 = add i32 %v3576, 2
  store i32 %v3581, ptr %NEXT_PC, align 4
  %v3582 = add i32 %v3581, 4
  %v3583 = load ptr, ptr %MEMORY, align 4
  %v3584 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3583, ptr %state, ptr %BRANCH_TAKEN, i32 %v3582, i32 %v3581, ptr %NEXT_PC)
  store ptr %v3584, ptr %MEMORY, align 4
  br i1 true, label %bb_4203223, label %bb_4203219

bb_4203219:                                       ; preds = %bb_4203209
  store i32 %v3581, ptr %PC, align 4
  %v3585 = add i32 %v3581, 4
  store i32 %v3585, ptr %NEXT_PC, align 4
  %v3586 = load i32, ptr %EBP, align 4
  %v3587 = load i32, ptr %SSBASE, align 4
  %v3588 = sub i32 %v3586, 12
  %v3589 = add i32 %v3588, %v3587
  %v3590 = load i32, ptr %EBP, align 4
  %v3591 = load i32, ptr %SSBASE, align 4
  %v3592 = sub i32 %v3590, 12
  %v3593 = add i32 %v3592, %v3591
  %v3594 = load ptr, ptr %MEMORY, align 4
  %v3595 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3594, ptr %state, i32 %v3589, i32 %v3593, i32 12)
  store ptr %v3595, ptr %MEMORY, align 4
  br label %bb_4203223

bb_4203223:                                       ; preds = %bb_4203219, %bb_4203209, %bb_4203199, %bb_4203190, %bb_4203184
  %v3596 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3596, ptr %PC, align 4
  %v3597 = add i32 %v3596, 3
  store i32 %v3597, ptr %NEXT_PC, align 4
  %v3598 = load i32, ptr %EBP, align 4
  %v3599 = load i32, ptr %SSBASE, align 4
  %v3600 = sub i32 %v3598, 12
  %v3601 = add i32 %v3600, %v3599
  %v3602 = load ptr, ptr %MEMORY, align 4
  %v3603 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3602, ptr %state, ptr %EAX, i32 %v3601)
  store ptr %v3603, ptr %MEMORY, align 4
  store i32 %v3597, ptr %PC, align 4
  %v3604 = add i32 %v3597, 2
  store i32 %v3604, ptr %NEXT_PC, align 4
  %v3605 = load i32, ptr %EAX, align 4
  %v3606 = load i32, ptr %DSBASE, align 4
  %v3607 = add i32 %v3605, %v3606
  %v3608 = load ptr, ptr %MEMORY, align 4
  %v3609 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3608, ptr %state, ptr %EAX, i32 %v3607)
  store ptr %v3609, ptr %MEMORY, align 4
  store i32 %v3604, ptr %PC, align 4
  %v3610 = add i32 %v3604, 2
  store i32 %v3610, ptr %NEXT_PC, align 4
  %v3611 = load i32, ptr %EAX, align 4
  %v3612 = load i32, ptr %EAX, align 4
  %v3613 = load ptr, ptr %MEMORY, align 4
  %v3614 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3613, ptr %state, i32 %v3611, i32 %v3612)
  store ptr %v3614, ptr %MEMORY, align 4
  store i32 %v3610, ptr %PC, align 4
  %v3615 = add i32 %v3610, 2
  store i32 %v3615, ptr %NEXT_PC, align 4
  %v3616 = add i32 %v3615, 10
  %v3617 = load ptr, ptr %MEMORY, align 4
  %v3618 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3617, ptr %state, ptr %BRANCH_TAKEN, i32 %v3616, i32 %v3615, ptr %NEXT_PC)
  store ptr %v3618, ptr %MEMORY, align 4
  br i1 true, label %bb_4203242, label %bb_4203232

bb_4203232:                                       ; preds = %bb_4203223
  store i32 %v3615, ptr %PC, align 4
  %v3619 = add i32 %v3615, 3
  store i32 %v3619, ptr %NEXT_PC, align 4
  %v3620 = load i32, ptr %EBP, align 4
  %v3621 = load i32, ptr %SSBASE, align 4
  %v3622 = sub i32 %v3620, 12
  %v3623 = add i32 %v3622, %v3621
  %v3624 = load ptr, ptr %MEMORY, align 4
  %v3625 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3624, ptr %state, ptr %EAX, i32 %v3623)
  store ptr %v3625, ptr %MEMORY, align 4
  store i32 %v3619, ptr %PC, align 4
  %v3626 = add i32 %v3619, 3
  store i32 %v3626, ptr %NEXT_PC, align 4
  %v3627 = load i32, ptr %EAX, align 4
  %v3628 = load i32, ptr %DSBASE, align 4
  %v3629 = add i32 %v3627, 4
  %v3630 = add i32 %v3629, %v3628
  %v3631 = load ptr, ptr %MEMORY, align 4
  %v3632 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3631, ptr %state, ptr %EAX, i32 %v3630)
  store ptr %v3632, ptr %MEMORY, align 4
  store i32 %v3626, ptr %PC, align 4
  %v3633 = add i32 %v3626, 2
  store i32 %v3633, ptr %NEXT_PC, align 4
  %v3634 = load i32, ptr %EAX, align 4
  %v3635 = load i32, ptr %EAX, align 4
  %v3636 = load ptr, ptr %MEMORY, align 4
  %v3637 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v3636, ptr %state, i32 %v3634, i32 %v3635)
  store ptr %v3637, ptr %MEMORY, align 4
  store i32 %v3633, ptr %PC, align 4
  %v3638 = add i32 %v3633, 2
  store i32 %v3638, ptr %NEXT_PC, align 4
  %v3639 = add i32 %v3638, 80
  %v3640 = load ptr, ptr %MEMORY, align 4
  %v3641 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3640, ptr %state, ptr %BRANCH_TAKEN, i32 %v3639, i32 %v3638, ptr %NEXT_PC)
  store ptr %v3641, ptr %MEMORY, align 4
  br i1 true, label %bb_4203322, label %bb_4203242

bb_4203242:                                       ; preds = %bb_4203232, %bb_4203223
  %v3642 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3642, ptr %PC, align 4
  %v3643 = add i32 %v3642, 3
  store i32 %v3643, ptr %NEXT_PC, align 4
  %v3644 = load i32, ptr %EBP, align 4
  %v3645 = load i32, ptr %SSBASE, align 4
  %v3646 = sub i32 %v3644, 12
  %v3647 = add i32 %v3646, %v3645
  %v3648 = load ptr, ptr %MEMORY, align 4
  %v3649 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3648, ptr %state, ptr %EAX, i32 %v3647)
  store ptr %v3649, ptr %MEMORY, align 4
  store i32 %v3643, ptr %PC, align 4
  %v3650 = add i32 %v3643, 3
  store i32 %v3650, ptr %NEXT_PC, align 4
  %v3651 = load i32, ptr %EBP, align 4
  %v3652 = load i32, ptr %SSBASE, align 4
  %v3653 = sub i32 %v3651, 20
  %v3654 = add i32 %v3653, %v3652
  %v3655 = load i32, ptr %EAX, align 4
  %v3656 = load ptr, ptr %MEMORY, align 4
  %v3657 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3656, ptr %state, i32 %v3654, i32 %v3655)
  store ptr %v3657, ptr %MEMORY, align 4
  store i32 %v3650, ptr %PC, align 4
  %v3658 = add i32 %v3650, 2
  store i32 %v3658, ptr %NEXT_PC, align 4
  %v3659 = add i32 %v3658, 59
  %v3660 = load ptr, ptr %MEMORY, align 4
  %v3661 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3660, ptr %state, i32 %v3659, ptr %NEXT_PC)
  store ptr %v3661, ptr %MEMORY, align 4
  br label %bb_4203309

bb_4203250:                                       ; preds = %bb_4203309
  store i32 %v3800, ptr %PC, align 4
  %v3662 = add i32 %v3800, 3
  store i32 %v3662, ptr %NEXT_PC, align 4
  %v3663 = load i32, ptr %EBP, align 4
  %v3664 = load i32, ptr %SSBASE, align 4
  %v3665 = sub i32 %v3663, 20
  %v3666 = add i32 %v3665, %v3664
  %v3667 = load ptr, ptr %MEMORY, align 4
  %v3668 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3667, ptr %state, ptr %EAX, i32 %v3666)
  store ptr %v3668, ptr %MEMORY, align 4
  store i32 %v3662, ptr %PC, align 4
  %v3669 = add i32 %v3662, 3
  store i32 %v3669, ptr %NEXT_PC, align 4
  %v3670 = load i32, ptr %EAX, align 4
  %v3671 = load i32, ptr %DSBASE, align 4
  %v3672 = add i32 %v3670, 4
  %v3673 = add i32 %v3672, %v3671
  %v3674 = load ptr, ptr %MEMORY, align 4
  %v3675 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3674, ptr %state, ptr %EDX, i32 %v3673)
  store ptr %v3675, ptr %MEMORY, align 4
  store i32 %v3669, ptr %PC, align 4
  %v3676 = add i32 %v3669, 3
  store i32 %v3676, ptr %NEXT_PC, align 4
  %v3677 = load i32, ptr %EBP, align 4
  %v3678 = load i32, ptr %SSBASE, align 4
  %v3679 = add i32 %v3677, 16
  %v3680 = add i32 %v3679, %v3678
  %v3681 = load ptr, ptr %MEMORY, align 4
  %v3682 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3681, ptr %state, ptr %EAX, i32 %v3680)
  store ptr %v3682, ptr %MEMORY, align 4
  store i32 %v3676, ptr %PC, align 4
  %v3683 = add i32 %v3676, 2
  store i32 %v3683, ptr %NEXT_PC, align 4
  %v3684 = load i32, ptr %EAX, align 4
  %v3685 = load i32, ptr %EDX, align 4
  %v3686 = load ptr, ptr %MEMORY, align 4
  %v3687 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3686, ptr %state, ptr %EAX, i32 %v3684, i32 %v3685)
  store ptr %v3687, ptr %MEMORY, align 4
  store i32 %v3683, ptr %PC, align 4
  %v3688 = add i32 %v3683, 3
  store i32 %v3688, ptr %NEXT_PC, align 4
  %v3689 = load i32, ptr %EBP, align 4
  %v3690 = load i32, ptr %SSBASE, align 4
  %v3691 = sub i32 %v3689, 24
  %v3692 = add i32 %v3691, %v3690
  %v3693 = load i32, ptr %EAX, align 4
  %v3694 = load ptr, ptr %MEMORY, align 4
  %v3695 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3694, ptr %state, i32 %v3692, i32 %v3693)
  store ptr %v3695, ptr %MEMORY, align 4
  store i32 %v3688, ptr %PC, align 4
  %v3696 = add i32 %v3688, 3
  store i32 %v3696, ptr %NEXT_PC, align 4
  %v3697 = load i32, ptr %EBP, align 4
  %v3698 = load i32, ptr %SSBASE, align 4
  %v3699 = sub i32 %v3697, 24
  %v3700 = add i32 %v3699, %v3698
  %v3701 = load ptr, ptr %MEMORY, align 4
  %v3702 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3701, ptr %state, ptr %EAX, i32 %v3700)
  store ptr %v3702, ptr %MEMORY, align 4
  store i32 %v3696, ptr %PC, align 4
  %v3703 = add i32 %v3696, 2
  store i32 %v3703, ptr %NEXT_PC, align 4
  %v3704 = load i32, ptr %EAX, align 4
  %v3705 = load i32, ptr %DSBASE, align 4
  %v3706 = add i32 %v3704, %v3705
  %v3707 = load ptr, ptr %MEMORY, align 4
  %v3708 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3707, ptr %state, ptr %EDX, i32 %v3706)
  store ptr %v3708, ptr %MEMORY, align 4
  store i32 %v3703, ptr %PC, align 4
  %v3709 = add i32 %v3703, 3
  store i32 %v3709, ptr %NEXT_PC, align 4
  %v3710 = load i32, ptr %EBP, align 4
  %v3711 = load i32, ptr %SSBASE, align 4
  %v3712 = sub i32 %v3710, 20
  %v3713 = add i32 %v3712, %v3711
  %v3714 = load ptr, ptr %MEMORY, align 4
  %v3715 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3714, ptr %state, ptr %EAX, i32 %v3713)
  store ptr %v3715, ptr %MEMORY, align 4
  store i32 %v3709, ptr %PC, align 4
  %v3716 = add i32 %v3709, 2
  store i32 %v3716, ptr %NEXT_PC, align 4
  %v3717 = load i32, ptr %EAX, align 4
  %v3718 = load i32, ptr %DSBASE, align 4
  %v3719 = add i32 %v3717, %v3718
  %v3720 = load ptr, ptr %MEMORY, align 4
  %v3721 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3720, ptr %state, ptr %EAX, i32 %v3719)
  store ptr %v3721, ptr %MEMORY, align 4
  store i32 %v3716, ptr %PC, align 4
  %v3722 = add i32 %v3716, 2
  store i32 %v3722, ptr %NEXT_PC, align 4
  %v3723 = load i32, ptr %EAX, align 4
  %v3724 = load i32, ptr %EDX, align 4
  %v3725 = load ptr, ptr %MEMORY, align 4
  %v3726 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3725, ptr %state, ptr %EAX, i32 %v3723, i32 %v3724)
  store ptr %v3726, ptr %MEMORY, align 4
  store i32 %v3722, ptr %PC, align 4
  %v3727 = add i32 %v3722, 3
  store i32 %v3727, ptr %NEXT_PC, align 4
  %v3728 = load i32, ptr %EBP, align 4
  %v3729 = load i32, ptr %SSBASE, align 4
  %v3730 = sub i32 %v3728, 36
  %v3731 = add i32 %v3730, %v3729
  %v3732 = load i32, ptr %EAX, align 4
  %v3733 = load ptr, ptr %MEMORY, align 4
  %v3734 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3733, ptr %state, i32 %v3731, i32 %v3732)
  store ptr %v3734, ptr %MEMORY, align 4
  store i32 %v3727, ptr %PC, align 4
  %v3735 = add i32 %v3727, 3
  store i32 %v3735, ptr %NEXT_PC, align 4
  %v3736 = load i32, ptr %EBP, align 4
  %v3737 = load i32, ptr %SSBASE, align 4
  %v3738 = sub i32 %v3736, 24
  %v3739 = add i32 %v3738, %v3737
  %v3740 = load ptr, ptr %MEMORY, align 4
  %v3741 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3740, ptr %state, ptr %EAX, i32 %v3739)
  store ptr %v3741, ptr %MEMORY, align 4
  store i32 %v3735, ptr %PC, align 4
  %v3742 = add i32 %v3735, 8
  store i32 %v3742, ptr %NEXT_PC, align 4
  %v3743 = load i32, ptr %ESP, align 4
  %v3744 = load i32, ptr %SSBASE, align 4
  %v3745 = add i32 %v3743, 8
  %v3746 = add i32 %v3745, %v3744
  %v3747 = load ptr, ptr %MEMORY, align 4
  %v3748 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3747, ptr %state, i32 %v3746, i32 4)
  store ptr %v3748, ptr %MEMORY, align 4
  store i32 %v3742, ptr %PC, align 4
  %v3749 = add i32 %v3742, 3
  store i32 %v3749, ptr %NEXT_PC, align 4
  %v3750 = load i32, ptr %EBP, align 4
  %v3751 = sub i32 %v3750, 36
  %v3752 = load ptr, ptr %MEMORY, align 4
  %v3753 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v3752, ptr %state, ptr %EDX, i32 %v3751)
  store ptr %v3753, ptr %MEMORY, align 4
  store i32 %v3749, ptr %PC, align 4
  %v3754 = add i32 %v3749, 4
  store i32 %v3754, ptr %NEXT_PC, align 4
  %v3755 = load i32, ptr %ESP, align 4
  %v3756 = load i32, ptr %SSBASE, align 4
  %v3757 = add i32 %v3755, 4
  %v3758 = add i32 %v3757, %v3756
  %v3759 = load i32, ptr %EDX, align 4
  %v3760 = load ptr, ptr %MEMORY, align 4
  %v3761 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3760, ptr %state, i32 %v3758, i32 %v3759)
  store ptr %v3761, ptr %MEMORY, align 4
  store i32 %v3754, ptr %PC, align 4
  %v3762 = add i32 %v3754, 3
  store i32 %v3762, ptr %NEXT_PC, align 4
  %v3763 = load i32, ptr %ESP, align 4
  %v3764 = load i32, ptr %SSBASE, align 4
  %v3765 = add i32 %v3763, %v3764
  %v3766 = load i32, ptr %EAX, align 4
  %v3767 = load ptr, ptr %MEMORY, align 4
  %v3768 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3767, ptr %state, i32 %v3765, i32 %v3766)
  store ptr %v3768, ptr %MEMORY, align 4
  store i32 %v3762, ptr %PC, align 4
  %v3769 = add i32 %v3762, 5
  store i32 %v3769, ptr %NEXT_PC, align 4
  %v3770 = sub i32 %v3769, 405
  %v3771 = load ptr, ptr %MEMORY, align 4
  %v3772 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3771, ptr %state, i64 4202900, ptr %NEXT_PC, i32 %v3769, ptr %RETURN_PC)
  store ptr %v3772, ptr %MEMORY, align 4
  store i32 %v3769, ptr %PC, align 4
  %v3773 = add i32 %v3769, 4
  store i32 %v3773, ptr %NEXT_PC, align 4
  %v3774 = load i32, ptr %EBP, align 4
  %v3775 = load i32, ptr %SSBASE, align 4
  %v3776 = sub i32 %v3774, 20
  %v3777 = add i32 %v3776, %v3775
  %v3778 = load i32, ptr %EBP, align 4
  %v3779 = load i32, ptr %SSBASE, align 4
  %v3780 = sub i32 %v3778, 20
  %v3781 = add i32 %v3780, %v3779
  %v3782 = load ptr, ptr %MEMORY, align 4
  %v3783 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3782, ptr %state, i32 %v3777, i32 %v3781, i32 8)
  store ptr %v3783, ptr %MEMORY, align 4
  br label %bb_4203309

bb_4203309:                                       ; preds = %bb_4203250, %bb_4203242
  %v3784 = load i32, ptr %NEXT_PC, align 4
  store i32 %v3784, ptr %PC, align 4
  %v3785 = add i32 %v3784, 3
  store i32 %v3785, ptr %NEXT_PC, align 4
  %v3786 = load i32, ptr %EBP, align 4
  %v3787 = load i32, ptr %SSBASE, align 4
  %v3788 = sub i32 %v3786, 20
  %v3789 = add i32 %v3788, %v3787
  %v3790 = load ptr, ptr %MEMORY, align 4
  %v3791 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3790, ptr %state, ptr %EAX, i32 %v3789)
  store ptr %v3791, ptr %MEMORY, align 4
  store i32 %v3785, ptr %PC, align 4
  %v3792 = add i32 %v3785, 3
  store i32 %v3792, ptr %NEXT_PC, align 4
  %v3793 = load i32, ptr %EAX, align 4
  %v3794 = load i32, ptr %EBP, align 4
  %v3795 = load i32, ptr %SSBASE, align 4
  %v3796 = add i32 %v3794, 12
  %v3797 = add i32 %v3796, %v3795
  %v3798 = load ptr, ptr %MEMORY, align 4
  %v3799 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3798, ptr %state, i32 %v3793, i32 %v3797)
  store ptr %v3799, ptr %MEMORY, align 4
  store i32 %v3792, ptr %PC, align 4
  %v3800 = add i32 %v3792, 2
  store i32 %v3800, ptr %NEXT_PC, align 4
  %v3801 = sub i32 %v3800, 67
  %v3802 = load ptr, ptr %MEMORY, align 4
  %v3803 = call ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3802, ptr %state, ptr %BRANCH_TAKEN, i32 %v3801, i32 %v3800, ptr %NEXT_PC)
  store ptr %v3803, ptr %MEMORY, align 4
  br i1 true, label %bb_4203250, label %bb_4203317

bb_4203317:                                       ; preds = %bb_4203309
  store i32 %v3800, ptr %PC, align 4
  %v3804 = add i32 %v3800, 5
  store i32 %v3804, ptr %NEXT_PC, align 4
  %v3805 = add i32 %v3804, 390
  %v3806 = load ptr, ptr %MEMORY, align 4
  %v3807 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3806, ptr %state, i32 %v3805, ptr %NEXT_PC)
  store ptr %v3807, ptr %MEMORY, align 4
  br label %bb_4203712

bb_4203322:                                       ; preds = %bb_4203232
  store i32 %v3638, ptr %PC, align 4
  %v3808 = add i32 %v3638, 3
  store i32 %v3808, ptr %NEXT_PC, align 4
  %v3809 = load i32, ptr %EBP, align 4
  %v3810 = load i32, ptr %SSBASE, align 4
  %v3811 = sub i32 %v3809, 12
  %v3812 = add i32 %v3811, %v3810
  %v3813 = load ptr, ptr %MEMORY, align 4
  %v3814 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3813, ptr %state, ptr %EAX, i32 %v3812)
  store ptr %v3814, ptr %MEMORY, align 4
  store i32 %v3808, ptr %PC, align 4
  %v3815 = add i32 %v3808, 3
  store i32 %v3815, ptr %NEXT_PC, align 4
  %v3816 = load i32, ptr %EAX, align 4
  %v3817 = load i32, ptr %DSBASE, align 4
  %v3818 = add i32 %v3816, 8
  %v3819 = add i32 %v3818, %v3817
  %v3820 = load ptr, ptr %MEMORY, align 4
  %v3821 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3820, ptr %state, ptr %EAX, i32 %v3819)
  store ptr %v3821, ptr %MEMORY, align 4
  store i32 %v3815, ptr %PC, align 4
  %v3822 = add i32 %v3815, 3
  store i32 %v3822, ptr %NEXT_PC, align 4
  %v3823 = load i32, ptr %EAX, align 4
  %v3824 = load ptr, ptr %MEMORY, align 4
  %v3825 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3824, ptr %state, i32 %v3823, i32 1)
  store ptr %v3825, ptr %MEMORY, align 4
  store i32 %v3822, ptr %PC, align 4
  %v3826 = add i32 %v3822, 2
  store i32 %v3826, ptr %NEXT_PC, align 4
  %v3827 = add i32 %v3826, 22
  %v3828 = load ptr, ptr %MEMORY, align 4
  %v3829 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3828, ptr %state, ptr %BRANCH_TAKEN, i32 %v3827, i32 %v3826, ptr %NEXT_PC)
  store ptr %v3829, ptr %MEMORY, align 4
  br i1 true, label %bb_4203355, label %bb_4203333

bb_4203333:                                       ; preds = %bb_4203322
  store i32 %v3826, ptr %PC, align 4
  %v3830 = add i32 %v3826, 3
  store i32 %v3830, ptr %NEXT_PC, align 4
  %v3831 = load i32, ptr %EBP, align 4
  %v3832 = load i32, ptr %SSBASE, align 4
  %v3833 = sub i32 %v3831, 12
  %v3834 = add i32 %v3833, %v3832
  %v3835 = load ptr, ptr %MEMORY, align 4
  %v3836 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3835, ptr %state, ptr %EAX, i32 %v3834)
  store ptr %v3836, ptr %MEMORY, align 4
  store i32 %v3830, ptr %PC, align 4
  %v3837 = add i32 %v3830, 3
  store i32 %v3837, ptr %NEXT_PC, align 4
  %v3838 = load i32, ptr %EAX, align 4
  %v3839 = load i32, ptr %DSBASE, align 4
  %v3840 = add i32 %v3838, 8
  %v3841 = add i32 %v3840, %v3839
  %v3842 = load ptr, ptr %MEMORY, align 4
  %v3843 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3842, ptr %state, ptr %EAX, i32 %v3841)
  store ptr %v3843, ptr %MEMORY, align 4
  store i32 %v3837, ptr %PC, align 4
  %v3844 = add i32 %v3837, 4
  store i32 %v3844, ptr %NEXT_PC, align 4
  %v3845 = load i32, ptr %ESP, align 4
  %v3846 = load i32, ptr %SSBASE, align 4
  %v3847 = add i32 %v3845, 4
  %v3848 = add i32 %v3847, %v3846
  %v3849 = load i32, ptr %EAX, align 4
  %v3850 = load ptr, ptr %MEMORY, align 4
  %v3851 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3850, ptr %state, i32 %v3848, i32 %v3849)
  store ptr %v3851, ptr %MEMORY, align 4
  store i32 %v3844, ptr %PC, align 4
  %v3852 = add i32 %v3844, 7
  store i32 %v3852, ptr %NEXT_PC, align 4
  %v3853 = load i32, ptr %ESP, align 4
  %v3854 = load i32, ptr %SSBASE, align 4
  %v3855 = add i32 %v3853, %v3854
  %v3856 = load ptr, ptr %MEMORY, align 4
  %v3857 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3856, ptr %state, i32 %v3855, i32 4235828)
  store ptr %v3857, ptr %MEMORY, align 4
  store i32 %v3852, ptr %PC, align 4
  %v3858 = add i32 %v3852, 5
  store i32 %v3858, ptr %NEXT_PC, align 4
  %v3859 = sub i32 %v3858, 1251
  %v3860 = load ptr, ptr %MEMORY, align 4
  %v3861 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v3860, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v3858, ptr %RETURN_PC)
  store ptr %v3861, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203355:                                       ; preds = %bb_4203322
  store i32 %v3826, ptr %PC, align 4
  %v3862 = add i32 %v3826, 3
  store i32 %v3862, ptr %NEXT_PC, align 4
  %v3863 = load i32, ptr %EBP, align 4
  %v3864 = load i32, ptr %SSBASE, align 4
  %v3865 = sub i32 %v3863, 12
  %v3866 = add i32 %v3865, %v3864
  %v3867 = load ptr, ptr %MEMORY, align 4
  %v3868 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3867, ptr %state, ptr %EAX, i32 %v3866)
  store ptr %v3868, ptr %MEMORY, align 4
  store i32 %v3862, ptr %PC, align 4
  %v3869 = add i32 %v3862, 3
  store i32 %v3869, ptr %NEXT_PC, align 4
  %v3870 = load i32, ptr %EAX, align 4
  %v3871 = load ptr, ptr %MEMORY, align 4
  %v3872 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3871, ptr %state, ptr %EAX, i32 %v3870, i32 12)
  store ptr %v3872, ptr %MEMORY, align 4
  store i32 %v3869, ptr %PC, align 4
  %v3873 = add i32 %v3869, 3
  store i32 %v3873, ptr %NEXT_PC, align 4
  %v3874 = load i32, ptr %EBP, align 4
  %v3875 = load i32, ptr %SSBASE, align 4
  %v3876 = sub i32 %v3874, 16
  %v3877 = add i32 %v3876, %v3875
  %v3878 = load i32, ptr %EAX, align 4
  %v3879 = load ptr, ptr %MEMORY, align 4
  %v3880 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3879, ptr %state, i32 %v3877, i32 %v3878)
  store ptr %v3880, ptr %MEMORY, align 4
  store i32 %v3873, ptr %PC, align 4
  %v3881 = add i32 %v3873, 5
  store i32 %v3881, ptr %NEXT_PC, align 4
  %v3882 = add i32 %v3881, 331
  %v3883 = load ptr, ptr %MEMORY, align 4
  %v3884 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v3883, ptr %state, i32 %v3882, ptr %NEXT_PC)
  store ptr %v3884, ptr %MEMORY, align 4
  br label %bb_4203700

bb_4203369:                                       ; preds = %bb_4203700
  store i32 %v4513, ptr %PC, align 4
  %v3885 = add i32 %v4513, 3
  store i32 %v3885, ptr %NEXT_PC, align 4
  %v3886 = load i32, ptr %EBP, align 4
  %v3887 = load i32, ptr %SSBASE, align 4
  %v3888 = sub i32 %v3886, 16
  %v3889 = add i32 %v3888, %v3887
  %v3890 = load ptr, ptr %MEMORY, align 4
  %v3891 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3890, ptr %state, ptr %EAX, i32 %v3889)
  store ptr %v3891, ptr %MEMORY, align 4
  store i32 %v3885, ptr %PC, align 4
  %v3892 = add i32 %v3885, 3
  store i32 %v3892, ptr %NEXT_PC, align 4
  %v3893 = load i32, ptr %EAX, align 4
  %v3894 = load i32, ptr %DSBASE, align 4
  %v3895 = add i32 %v3893, 4
  %v3896 = add i32 %v3895, %v3894
  %v3897 = load ptr, ptr %MEMORY, align 4
  %v3898 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3897, ptr %state, ptr %EDX, i32 %v3896)
  store ptr %v3898, ptr %MEMORY, align 4
  store i32 %v3892, ptr %PC, align 4
  %v3899 = add i32 %v3892, 3
  store i32 %v3899, ptr %NEXT_PC, align 4
  %v3900 = load i32, ptr %EBP, align 4
  %v3901 = load i32, ptr %SSBASE, align 4
  %v3902 = add i32 %v3900, 16
  %v3903 = add i32 %v3902, %v3901
  %v3904 = load ptr, ptr %MEMORY, align 4
  %v3905 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3904, ptr %state, ptr %EAX, i32 %v3903)
  store ptr %v3905, ptr %MEMORY, align 4
  store i32 %v3899, ptr %PC, align 4
  %v3906 = add i32 %v3899, 2
  store i32 %v3906, ptr %NEXT_PC, align 4
  %v3907 = load i32, ptr %EAX, align 4
  %v3908 = load i32, ptr %EDX, align 4
  %v3909 = load ptr, ptr %MEMORY, align 4
  %v3910 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3909, ptr %state, ptr %EAX, i32 %v3907, i32 %v3908)
  store ptr %v3910, ptr %MEMORY, align 4
  store i32 %v3906, ptr %PC, align 4
  %v3911 = add i32 %v3906, 3
  store i32 %v3911, ptr %NEXT_PC, align 4
  %v3912 = load i32, ptr %EBP, align 4
  %v3913 = load i32, ptr %SSBASE, align 4
  %v3914 = sub i32 %v3912, 24
  %v3915 = add i32 %v3914, %v3913
  %v3916 = load i32, ptr %EAX, align 4
  %v3917 = load ptr, ptr %MEMORY, align 4
  %v3918 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3917, ptr %state, i32 %v3915, i32 %v3916)
  store ptr %v3918, ptr %MEMORY, align 4
  store i32 %v3911, ptr %PC, align 4
  %v3919 = add i32 %v3911, 3
  store i32 %v3919, ptr %NEXT_PC, align 4
  %v3920 = load i32, ptr %EBP, align 4
  %v3921 = load i32, ptr %SSBASE, align 4
  %v3922 = sub i32 %v3920, 16
  %v3923 = add i32 %v3922, %v3921
  %v3924 = load ptr, ptr %MEMORY, align 4
  %v3925 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3924, ptr %state, ptr %EAX, i32 %v3923)
  store ptr %v3925, ptr %MEMORY, align 4
  store i32 %v3919, ptr %PC, align 4
  %v3926 = add i32 %v3919, 2
  store i32 %v3926, ptr %NEXT_PC, align 4
  %v3927 = load i32, ptr %EAX, align 4
  %v3928 = load i32, ptr %DSBASE, align 4
  %v3929 = add i32 %v3927, %v3928
  %v3930 = load ptr, ptr %MEMORY, align 4
  %v3931 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3930, ptr %state, ptr %EDX, i32 %v3929)
  store ptr %v3931, ptr %MEMORY, align 4
  store i32 %v3926, ptr %PC, align 4
  %v3932 = add i32 %v3926, 3
  store i32 %v3932, ptr %NEXT_PC, align 4
  %v3933 = load i32, ptr %EBP, align 4
  %v3934 = load i32, ptr %SSBASE, align 4
  %v3935 = add i32 %v3933, 16
  %v3936 = add i32 %v3935, %v3934
  %v3937 = load ptr, ptr %MEMORY, align 4
  %v3938 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3937, ptr %state, ptr %EAX, i32 %v3936)
  store ptr %v3938, ptr %MEMORY, align 4
  store i32 %v3932, ptr %PC, align 4
  %v3939 = add i32 %v3932, 2
  store i32 %v3939, ptr %NEXT_PC, align 4
  %v3940 = load i32, ptr %EAX, align 4
  %v3941 = load i32, ptr %EDX, align 4
  %v3942 = load ptr, ptr %MEMORY, align 4
  %v3943 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v3942, ptr %state, ptr %EAX, i32 %v3940, i32 %v3941)
  store ptr %v3943, ptr %MEMORY, align 4
  store i32 %v3939, ptr %PC, align 4
  %v3944 = add i32 %v3939, 3
  store i32 %v3944, ptr %NEXT_PC, align 4
  %v3945 = load i32, ptr %EBP, align 4
  %v3946 = load i32, ptr %SSBASE, align 4
  %v3947 = sub i32 %v3945, 28
  %v3948 = add i32 %v3947, %v3946
  %v3949 = load i32, ptr %EAX, align 4
  %v3950 = load ptr, ptr %MEMORY, align 4
  %v3951 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3950, ptr %state, i32 %v3948, i32 %v3949)
  store ptr %v3951, ptr %MEMORY, align 4
  store i32 %v3944, ptr %PC, align 4
  %v3952 = add i32 %v3944, 3
  store i32 %v3952, ptr %NEXT_PC, align 4
  %v3953 = load i32, ptr %EBP, align 4
  %v3954 = load i32, ptr %SSBASE, align 4
  %v3955 = sub i32 %v3953, 28
  %v3956 = add i32 %v3955, %v3954
  %v3957 = load ptr, ptr %MEMORY, align 4
  %v3958 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3957, ptr %state, ptr %EAX, i32 %v3956)
  store ptr %v3958, ptr %MEMORY, align 4
  store i32 %v3952, ptr %PC, align 4
  %v3959 = add i32 %v3952, 2
  store i32 %v3959, ptr %NEXT_PC, align 4
  %v3960 = load i32, ptr %EAX, align 4
  %v3961 = load i32, ptr %DSBASE, align 4
  %v3962 = add i32 %v3960, %v3961
  %v3963 = load ptr, ptr %MEMORY, align 4
  %v3964 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3963, ptr %state, ptr %EAX, i32 %v3962)
  store ptr %v3964, ptr %MEMORY, align 4
  store i32 %v3959, ptr %PC, align 4
  %v3965 = add i32 %v3959, 3
  store i32 %v3965, ptr %NEXT_PC, align 4
  %v3966 = load i32, ptr %EBP, align 4
  %v3967 = load i32, ptr %SSBASE, align 4
  %v3968 = sub i32 %v3966, 28
  %v3969 = add i32 %v3968, %v3967
  %v3970 = load i32, ptr %EAX, align 4
  %v3971 = load ptr, ptr %MEMORY, align 4
  %v3972 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v3971, ptr %state, i32 %v3969, i32 %v3970)
  store ptr %v3972, ptr %MEMORY, align 4
  store i32 %v3965, ptr %PC, align 4
  %v3973 = add i32 %v3965, 3
  store i32 %v3973, ptr %NEXT_PC, align 4
  %v3974 = load i32, ptr %EBP, align 4
  %v3975 = load i32, ptr %SSBASE, align 4
  %v3976 = sub i32 %v3974, 16
  %v3977 = add i32 %v3976, %v3975
  %v3978 = load ptr, ptr %MEMORY, align 4
  %v3979 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3978, ptr %state, ptr %EAX, i32 %v3977)
  store ptr %v3979, ptr %MEMORY, align 4
  store i32 %v3973, ptr %PC, align 4
  %v3980 = add i32 %v3973, 3
  store i32 %v3980, ptr %NEXT_PC, align 4
  %v3981 = load i32, ptr %EAX, align 4
  %v3982 = load i32, ptr %DSBASE, align 4
  %v3983 = add i32 %v3981, 8
  %v3984 = add i32 %v3983, %v3982
  %v3985 = load ptr, ptr %MEMORY, align 4
  %v3986 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3985, ptr %state, ptr %EAX, i32 %v3984)
  store ptr %v3986, ptr %MEMORY, align 4
  store i32 %v3980, ptr %PC, align 4
  %v3987 = add i32 %v3980, 5
  store i32 %v3987, ptr %NEXT_PC, align 4
  %v3988 = load i32, ptr %EAX, align 4
  %v3989 = load ptr, ptr %MEMORY, align 4
  %v3990 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v3989, ptr %state, ptr %EAX, i32 %v3988, i32 255)
  store ptr %v3990, ptr %MEMORY, align 4
  store i32 %v3987, ptr %PC, align 4
  %v3991 = add i32 %v3987, 3
  store i32 %v3991, ptr %NEXT_PC, align 4
  %v3992 = load i32, ptr %EAX, align 4
  %v3993 = load ptr, ptr %MEMORY, align 4
  %v3994 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v3993, ptr %state, i32 %v3992, i32 16)
  store ptr %v3994, ptr %MEMORY, align 4
  store i32 %v3991, ptr %PC, align 4
  %v3995 = add i32 %v3991, 2
  store i32 %v3995, ptr %NEXT_PC, align 4
  %v3996 = add i32 %v3995, 47
  %v3997 = load ptr, ptr %MEMORY, align 4
  %v3998 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v3997, ptr %state, ptr %BRANCH_TAKEN, i32 %v3996, i32 %v3995, ptr %NEXT_PC)
  store ptr %v3998, ptr %MEMORY, align 4
  br i1 true, label %bb_4203467, label %bb_4203420

bb_4203420:                                       ; preds = %bb_4203369
  store i32 %v3995, ptr %PC, align 4
  %v3999 = add i32 %v3995, 3
  store i32 %v3999, ptr %NEXT_PC, align 4
  %v4000 = load i32, ptr %EAX, align 4
  %v4001 = load ptr, ptr %MEMORY, align 4
  %v4002 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4001, ptr %state, i32 %v4000, i32 32)
  store ptr %v4002, ptr %MEMORY, align 4
  store i32 %v3999, ptr %PC, align 4
  %v4003 = add i32 %v3999, 2
  store i32 %v4003, ptr %NEXT_PC, align 4
  %v4004 = add i32 %v4003, 79
  %v4005 = load ptr, ptr %MEMORY, align 4
  %v4006 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4005, ptr %state, ptr %BRANCH_TAKEN, i32 %v4004, i32 %v4003, ptr %NEXT_PC)
  store ptr %v4006, ptr %MEMORY, align 4
  br i1 true, label %bb_4203504, label %bb_4203425

bb_4203425:                                       ; preds = %bb_4203420
  store i32 %v4003, ptr %PC, align 4
  %v4007 = add i32 %v4003, 3
  store i32 %v4007, ptr %NEXT_PC, align 4
  %v4008 = load i32, ptr %EAX, align 4
  %v4009 = load ptr, ptr %MEMORY, align 4
  %v4010 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4009, ptr %state, i32 %v4008, i32 8)
  store ptr %v4010, ptr %MEMORY, align 4
  store i32 %v4007, ptr %PC, align 4
  %v4011 = add i32 %v4007, 2
  store i32 %v4011, ptr %NEXT_PC, align 4
  %v4012 = add i32 %v4011, 84
  %v4013 = load ptr, ptr %MEMORY, align 4
  %v4014 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4013, ptr %state, ptr %BRANCH_TAKEN, i32 %v4012, i32 %v4011, ptr %NEXT_PC)
  store ptr %v4014, ptr %MEMORY, align 4
  br i1 true, label %bb_4203514, label %bb_4203430

bb_4203430:                                       ; preds = %bb_4203425
  store i32 %v4011, ptr %PC, align 4
  %v4015 = add i32 %v4011, 3
  store i32 %v4015, ptr %NEXT_PC, align 4
  %v4016 = load i32, ptr %EBP, align 4
  %v4017 = load i32, ptr %SSBASE, align 4
  %v4018 = sub i32 %v4016, 24
  %v4019 = add i32 %v4018, %v4017
  %v4020 = load ptr, ptr %MEMORY, align 4
  %v4021 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4020, ptr %state, ptr %EAX, i32 %v4019)
  store ptr %v4021, ptr %MEMORY, align 4
  store i32 %v4015, ptr %PC, align 4
  %v4022 = add i32 %v4015, 3
  store i32 %v4022, ptr %NEXT_PC, align 4
  %v4023 = load i32, ptr %EAX, align 4
  %v4024 = load i32, ptr %DSBASE, align 4
  %v4025 = add i32 %v4023, %v4024
  %v4026 = load ptr, ptr %MEMORY, align 4
  %v4027 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnIhEEEP6MemoryS6_R5StateT_T0_(ptr %v4026, ptr %state, ptr %EAX, i32 %v4025)
  store ptr %v4027, ptr %MEMORY, align 4
  store i32 %v4022, ptr %PC, align 4
  %v4028 = add i32 %v4022, 3
  store i32 %v4028, ptr %NEXT_PC, align 4
  %v4029 = load i8, ptr %AL, align 1
  %v4030 = zext i8 %v4029 to i32
  %v4031 = load ptr, ptr %MEMORY, align 4
  %v4032 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnIhLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4031, ptr %state, ptr %EAX, i32 %v4030)
  store ptr %v4032, ptr %MEMORY, align 4
  store i32 %v4028, ptr %PC, align 4
  %v4033 = add i32 %v4028, 3
  store i32 %v4033, ptr %NEXT_PC, align 4
  %v4034 = load i32, ptr %EBP, align 4
  %v4035 = load i32, ptr %SSBASE, align 4
  %v4036 = sub i32 %v4034, 32
  %v4037 = add i32 %v4036, %v4035
  %v4038 = load i32, ptr %EAX, align 4
  %v4039 = load ptr, ptr %MEMORY, align 4
  %v4040 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4039, ptr %state, i32 %v4037, i32 %v4038)
  store ptr %v4040, ptr %MEMORY, align 4
  store i32 %v4033, ptr %PC, align 4
  %v4041 = add i32 %v4033, 3
  store i32 %v4041, ptr %NEXT_PC, align 4
  %v4042 = load i32, ptr %EBP, align 4
  %v4043 = load i32, ptr %SSBASE, align 4
  %v4044 = sub i32 %v4042, 32
  %v4045 = add i32 %v4044, %v4043
  %v4046 = load ptr, ptr %MEMORY, align 4
  %v4047 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4046, ptr %state, ptr %EAX, i32 %v4045)
  store ptr %v4047, ptr %MEMORY, align 4
  store i32 %v4041, ptr %PC, align 4
  %v4048 = add i32 %v4041, 5
  store i32 %v4048, ptr %NEXT_PC, align 4
  %v4049 = load i32, ptr %EAX, align 4
  %v4050 = load ptr, ptr %MEMORY, align 4
  %v4051 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4050, ptr %state, ptr %EAX, i32 %v4049, i32 128)
  store ptr %v4051, ptr %MEMORY, align 4
  store i32 %v4048, ptr %PC, align 4
  %v4052 = add i32 %v4048, 2
  store i32 %v4052, ptr %NEXT_PC, align 4
  %v4053 = load i32, ptr %EAX, align 4
  %v4054 = load i32, ptr %EAX, align 4
  %v4055 = load ptr, ptr %MEMORY, align 4
  %v4056 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4055, ptr %state, i32 %v4053, i32 %v4054)
  store ptr %v4056, ptr %MEMORY, align 4
  store i32 %v4052, ptr %PC, align 4
  %v4057 = add i32 %v4052, 2
  store i32 %v4057, ptr %NEXT_PC, align 4
  %v4058 = add i32 %v4057, 94
  %v4059 = load ptr, ptr %MEMORY, align 4
  %v4060 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4059, ptr %state, ptr %BRANCH_TAKEN, i32 %v4058, i32 %v4057, ptr %NEXT_PC)
  store ptr %v4060, ptr %MEMORY, align 4
  br i1 true, label %bb_4203548, label %bb_4203454

bb_4203454:                                       ; preds = %bb_4203430
  store i32 %v4057, ptr %PC, align 4
  %v4061 = add i32 %v4057, 3
  store i32 %v4061, ptr %NEXT_PC, align 4
  %v4062 = load i32, ptr %EBP, align 4
  %v4063 = load i32, ptr %SSBASE, align 4
  %v4064 = sub i32 %v4062, 32
  %v4065 = add i32 %v4064, %v4063
  %v4066 = load ptr, ptr %MEMORY, align 4
  %v4067 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4066, ptr %state, ptr %EAX, i32 %v4065)
  store ptr %v4067, ptr %MEMORY, align 4
  store i32 %v4061, ptr %PC, align 4
  %v4068 = add i32 %v4061, 5
  store i32 %v4068, ptr %NEXT_PC, align 4
  %v4069 = load i32, ptr %EAX, align 4
  %v4070 = load ptr, ptr %MEMORY, align 4
  %v4071 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4070, ptr %state, ptr %EAX, i32 %v4069, i32 -256)
  store ptr %v4071, ptr %MEMORY, align 4
  store i32 %v4068, ptr %PC, align 4
  %v4072 = add i32 %v4068, 3
  store i32 %v4072, ptr %NEXT_PC, align 4
  %v4073 = load i32, ptr %EBP, align 4
  %v4074 = load i32, ptr %SSBASE, align 4
  %v4075 = sub i32 %v4073, 32
  %v4076 = add i32 %v4075, %v4074
  %v4077 = load i32, ptr %EAX, align 4
  %v4078 = load ptr, ptr %MEMORY, align 4
  %v4079 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4078, ptr %state, i32 %v4076, i32 %v4077)
  store ptr %v4079, ptr %MEMORY, align 4
  store i32 %v4072, ptr %PC, align 4
  %v4080 = add i32 %v4072, 2
  store i32 %v4080, ptr %NEXT_PC, align 4
  %v4081 = add i32 %v4080, 81
  %v4082 = load ptr, ptr %MEMORY, align 4
  %v4083 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4082, ptr %state, i32 %v4081, ptr %NEXT_PC)
  store ptr %v4083, ptr %MEMORY, align 4
  br label %bb_4203548

bb_4203467:                                       ; preds = %bb_4203369
  store i32 %v3995, ptr %PC, align 4
  %v4084 = add i32 %v3995, 3
  store i32 %v4084, ptr %NEXT_PC, align 4
  %v4085 = load i32, ptr %EBP, align 4
  %v4086 = load i32, ptr %SSBASE, align 4
  %v4087 = sub i32 %v4085, 24
  %v4088 = add i32 %v4087, %v4086
  %v4089 = load ptr, ptr %MEMORY, align 4
  %v4090 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4089, ptr %state, ptr %EAX, i32 %v4088)
  store ptr %v4090, ptr %MEMORY, align 4
  store i32 %v4084, ptr %PC, align 4
  %v4091 = add i32 %v4084, 3
  store i32 %v4091, ptr %NEXT_PC, align 4
  %v4092 = load i32, ptr %EAX, align 4
  %v4093 = load i32, ptr %DSBASE, align 4
  %v4094 = add i32 %v4092, %v4093
  %v4095 = load ptr, ptr %MEMORY, align 4
  %v4096 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2MnItEEEP6MemoryS6_R5StateT_T0_(ptr %v4095, ptr %state, ptr %EAX, i32 %v4094)
  store ptr %v4096, ptr %MEMORY, align 4
  store i32 %v4091, ptr %PC, align 4
  %v4097 = add i32 %v4091, 3
  store i32 %v4097, ptr %NEXT_PC, align 4
  %v4098 = load i16, ptr %AX, align 2
  %v4099 = zext i16 %v4098 to i32
  %v4100 = load ptr, ptr %MEMORY, align 4
  %v4101 = call ptr @_ZN12_GLOBAL__N_15MOVZXI3RnWIjE2RnItLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4100, ptr %state, ptr %EAX, i32 %v4099)
  store ptr %v4101, ptr %MEMORY, align 4
  store i32 %v4097, ptr %PC, align 4
  %v4102 = add i32 %v4097, 3
  store i32 %v4102, ptr %NEXT_PC, align 4
  %v4103 = load i32, ptr %EBP, align 4
  %v4104 = load i32, ptr %SSBASE, align 4
  %v4105 = sub i32 %v4103, 32
  %v4106 = add i32 %v4105, %v4104
  %v4107 = load i32, ptr %EAX, align 4
  %v4108 = load ptr, ptr %MEMORY, align 4
  %v4109 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4108, ptr %state, i32 %v4106, i32 %v4107)
  store ptr %v4109, ptr %MEMORY, align 4
  store i32 %v4102, ptr %PC, align 4
  %v4110 = add i32 %v4102, 3
  store i32 %v4110, ptr %NEXT_PC, align 4
  %v4111 = load i32, ptr %EBP, align 4
  %v4112 = load i32, ptr %SSBASE, align 4
  %v4113 = sub i32 %v4111, 32
  %v4114 = add i32 %v4113, %v4112
  %v4115 = load ptr, ptr %MEMORY, align 4
  %v4116 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4115, ptr %state, ptr %EAX, i32 %v4114)
  store ptr %v4116, ptr %MEMORY, align 4
  store i32 %v4110, ptr %PC, align 4
  %v4117 = add i32 %v4110, 5
  store i32 %v4117, ptr %NEXT_PC, align 4
  %v4118 = load i32, ptr %EAX, align 4
  %v4119 = load ptr, ptr %MEMORY, align 4
  %v4120 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4119, ptr %state, ptr %EAX, i32 %v4118, i32 32768)
  store ptr %v4120, ptr %MEMORY, align 4
  store i32 %v4117, ptr %PC, align 4
  %v4121 = add i32 %v4117, 2
  store i32 %v4121, ptr %NEXT_PC, align 4
  %v4122 = load i32, ptr %EAX, align 4
  %v4123 = load i32, ptr %EAX, align 4
  %v4124 = load ptr, ptr %MEMORY, align 4
  %v4125 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4124, ptr %state, i32 %v4122, i32 %v4123)
  store ptr %v4125, ptr %MEMORY, align 4
  store i32 %v4121, ptr %PC, align 4
  %v4126 = add i32 %v4121, 2
  store i32 %v4126, ptr %NEXT_PC, align 4
  %v4127 = add i32 %v4126, 60
  %v4128 = load ptr, ptr %MEMORY, align 4
  %v4129 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4128, ptr %state, ptr %BRANCH_TAKEN, i32 %v4127, i32 %v4126, ptr %NEXT_PC)
  store ptr %v4129, ptr %MEMORY, align 4
  br i1 true, label %bb_4203551, label %bb_4203491

bb_4203491:                                       ; preds = %bb_4203467
  store i32 %v4126, ptr %PC, align 4
  %v4130 = add i32 %v4126, 3
  store i32 %v4130, ptr %NEXT_PC, align 4
  %v4131 = load i32, ptr %EBP, align 4
  %v4132 = load i32, ptr %SSBASE, align 4
  %v4133 = sub i32 %v4131, 32
  %v4134 = add i32 %v4133, %v4132
  %v4135 = load ptr, ptr %MEMORY, align 4
  %v4136 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4135, ptr %state, ptr %EAX, i32 %v4134)
  store ptr %v4136, ptr %MEMORY, align 4
  store i32 %v4130, ptr %PC, align 4
  %v4137 = add i32 %v4130, 5
  store i32 %v4137, ptr %NEXT_PC, align 4
  %v4138 = load i32, ptr %EAX, align 4
  %v4139 = load ptr, ptr %MEMORY, align 4
  %v4140 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4139, ptr %state, ptr %EAX, i32 %v4138, i32 -65536)
  store ptr %v4140, ptr %MEMORY, align 4
  store i32 %v4137, ptr %PC, align 4
  %v4141 = add i32 %v4137, 3
  store i32 %v4141, ptr %NEXT_PC, align 4
  %v4142 = load i32, ptr %EBP, align 4
  %v4143 = load i32, ptr %SSBASE, align 4
  %v4144 = sub i32 %v4142, 32
  %v4145 = add i32 %v4144, %v4143
  %v4146 = load i32, ptr %EAX, align 4
  %v4147 = load ptr, ptr %MEMORY, align 4
  %v4148 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4147, ptr %state, i32 %v4145, i32 %v4146)
  store ptr %v4148, ptr %MEMORY, align 4
  store i32 %v4141, ptr %PC, align 4
  %v4149 = add i32 %v4141, 2
  store i32 %v4149, ptr %NEXT_PC, align 4
  %v4150 = add i32 %v4149, 47
  %v4151 = load ptr, ptr %MEMORY, align 4
  %v4152 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4151, ptr %state, i32 %v4150, ptr %NEXT_PC)
  store ptr %v4152, ptr %MEMORY, align 4
  br label %bb_4203551

bb_4203504:                                       ; preds = %bb_4203420
  store i32 %v4003, ptr %PC, align 4
  %v4153 = add i32 %v4003, 3
  store i32 %v4153, ptr %NEXT_PC, align 4
  %v4154 = load i32, ptr %EBP, align 4
  %v4155 = load i32, ptr %SSBASE, align 4
  %v4156 = sub i32 %v4154, 24
  %v4157 = add i32 %v4156, %v4155
  %v4158 = load ptr, ptr %MEMORY, align 4
  %v4159 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4158, ptr %state, ptr %EAX, i32 %v4157)
  store ptr %v4159, ptr %MEMORY, align 4
  store i32 %v4153, ptr %PC, align 4
  %v4160 = add i32 %v4153, 2
  store i32 %v4160, ptr %NEXT_PC, align 4
  %v4161 = load i32, ptr %EAX, align 4
  %v4162 = load i32, ptr %DSBASE, align 4
  %v4163 = add i32 %v4161, %v4162
  %v4164 = load ptr, ptr %MEMORY, align 4
  %v4165 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4164, ptr %state, ptr %EAX, i32 %v4163)
  store ptr %v4165, ptr %MEMORY, align 4
  store i32 %v4160, ptr %PC, align 4
  %v4166 = add i32 %v4160, 3
  store i32 %v4166, ptr %NEXT_PC, align 4
  %v4167 = load i32, ptr %EBP, align 4
  %v4168 = load i32, ptr %SSBASE, align 4
  %v4169 = sub i32 %v4167, 32
  %v4170 = add i32 %v4169, %v4168
  %v4171 = load i32, ptr %EAX, align 4
  %v4172 = load ptr, ptr %MEMORY, align 4
  %v4173 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4172, ptr %state, i32 %v4170, i32 %v4171)
  store ptr %v4173, ptr %MEMORY, align 4
  store i32 %v4166, ptr %PC, align 4
  %v4174 = add i32 %v4166, 2
  store i32 %v4174, ptr %NEXT_PC, align 4
  %v4175 = add i32 %v4174, 38
  %v4176 = load ptr, ptr %MEMORY, align 4
  %v4177 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4176, ptr %state, i32 %v4175, ptr %NEXT_PC)
  store ptr %v4177, ptr %MEMORY, align 4
  br label %bb_4203552

bb_4203514:                                       ; preds = %bb_4203425
  store i32 %v4011, ptr %PC, align 4
  %v4178 = add i32 %v4011, 7
  store i32 %v4178, ptr %NEXT_PC, align 4
  %v4179 = load i32, ptr %EBP, align 4
  %v4180 = load i32, ptr %SSBASE, align 4
  %v4181 = sub i32 %v4179, 32
  %v4182 = add i32 %v4181, %v4180
  %v4183 = load ptr, ptr %MEMORY, align 4
  %v4184 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4183, ptr %state, i32 %v4182, i32 0)
  store ptr %v4184, ptr %MEMORY, align 4
  store i32 %v4178, ptr %PC, align 4
  %v4185 = add i32 %v4178, 3
  store i32 %v4185, ptr %NEXT_PC, align 4
  %v4186 = load i32, ptr %EBP, align 4
  %v4187 = load i32, ptr %SSBASE, align 4
  %v4188 = sub i32 %v4186, 16
  %v4189 = add i32 %v4188, %v4187
  %v4190 = load ptr, ptr %MEMORY, align 4
  %v4191 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4190, ptr %state, ptr %EAX, i32 %v4189)
  store ptr %v4191, ptr %MEMORY, align 4
  store i32 %v4185, ptr %PC, align 4
  %v4192 = add i32 %v4185, 3
  store i32 %v4192, ptr %NEXT_PC, align 4
  %v4193 = load i32, ptr %EAX, align 4
  %v4194 = load i32, ptr %DSBASE, align 4
  %v4195 = add i32 %v4193, 8
  %v4196 = add i32 %v4195, %v4194
  %v4197 = load ptr, ptr %MEMORY, align 4
  %v4198 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4197, ptr %state, ptr %EAX, i32 %v4196)
  store ptr %v4198, ptr %MEMORY, align 4
  store i32 %v4192, ptr %PC, align 4
  %v4199 = add i32 %v4192, 5
  store i32 %v4199, ptr %NEXT_PC, align 4
  %v4200 = load i32, ptr %EAX, align 4
  %v4201 = load ptr, ptr %MEMORY, align 4
  %v4202 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4201, ptr %state, ptr %EAX, i32 %v4200, i32 255)
  store ptr %v4202, ptr %MEMORY, align 4
  store i32 %v4199, ptr %PC, align 4
  %v4203 = add i32 %v4199, 4
  store i32 %v4203, ptr %NEXT_PC, align 4
  %v4204 = load i32, ptr %ESP, align 4
  %v4205 = load i32, ptr %SSBASE, align 4
  %v4206 = add i32 %v4204, 4
  %v4207 = add i32 %v4206, %v4205
  %v4208 = load i32, ptr %EAX, align 4
  %v4209 = load ptr, ptr %MEMORY, align 4
  %v4210 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4209, ptr %state, i32 %v4207, i32 %v4208)
  store ptr %v4210, ptr %MEMORY, align 4
  store i32 %v4203, ptr %PC, align 4
  %v4211 = add i32 %v4203, 7
  store i32 %v4211, ptr %NEXT_PC, align 4
  %v4212 = load i32, ptr %ESP, align 4
  %v4213 = load i32, ptr %SSBASE, align 4
  %v4214 = add i32 %v4212, %v4213
  %v4215 = load ptr, ptr %MEMORY, align 4
  %v4216 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4215, ptr %state, i32 %v4214, i32 4235880)
  store ptr %v4216, ptr %MEMORY, align 4
  store i32 %v4211, ptr %PC, align 4
  %v4217 = add i32 %v4211, 5
  store i32 %v4217, ptr %NEXT_PC, align 4
  %v4218 = sub i32 %v4217, 1444
  %v4219 = load ptr, ptr %MEMORY, align 4
  %v4220 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4219, ptr %state, i64 4202104, ptr %NEXT_PC, i32 %v4217, ptr %RETURN_PC)
  store ptr %v4220, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203548:                                       ; preds = %bb_4203454, %bb_4203430
  %v4221 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4221, ptr %PC, align 4
  %v4222 = add i32 %v4221, 1
  store i32 %v4222, ptr %NEXT_PC, align 4
  %v4223 = load ptr, ptr %MEMORY, align 4
  %v4224 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4223, ptr %state)
  store ptr %v4224, ptr %MEMORY, align 4
  store i32 %v4222, ptr %PC, align 4
  %v4225 = add i32 %v4222, 2
  store i32 %v4225, ptr %NEXT_PC, align 4
  %v4226 = add i32 %v4225, 1
  %v4227 = load ptr, ptr %MEMORY, align 4
  %v4228 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4227, ptr %state, i32 %v4226, ptr %NEXT_PC)
  store ptr %v4228, ptr %MEMORY, align 4
  br label %bb_4203552

bb_4203551:                                       ; preds = %bb_4203491, %bb_4203467
  %v4229 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4229, ptr %PC, align 4
  %v4230 = add i32 %v4229, 1
  store i32 %v4230, ptr %NEXT_PC, align 4
  %v4231 = load ptr, ptr %MEMORY, align 4
  %v4232 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4231, ptr %state)
  store ptr %v4232, ptr %MEMORY, align 4
  br label %bb_4203552

bb_4203552:                                       ; preds = %bb_4203551, %bb_4203548, %bb_4203504
  %v4233 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4233, ptr %PC, align 4
  %v4234 = add i32 %v4233, 3
  store i32 %v4234, ptr %NEXT_PC, align 4
  %v4235 = load i32, ptr %EBP, align 4
  %v4236 = load i32, ptr %SSBASE, align 4
  %v4237 = sub i32 %v4235, 32
  %v4238 = add i32 %v4237, %v4236
  %v4239 = load ptr, ptr %MEMORY, align 4
  %v4240 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4239, ptr %state, ptr %EAX, i32 %v4238)
  store ptr %v4240, ptr %MEMORY, align 4
  store i32 %v4234, ptr %PC, align 4
  %v4241 = add i32 %v4234, 2
  store i32 %v4241, ptr %NEXT_PC, align 4
  %v4242 = load i32, ptr %EAX, align 4
  %v4243 = load ptr, ptr %MEMORY, align 4
  %v4244 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4243, ptr %state, ptr %EDX, i32 %v4242)
  store ptr %v4244, ptr %MEMORY, align 4
  store i32 %v4241, ptr %PC, align 4
  %v4245 = add i32 %v4241, 3
  store i32 %v4245, ptr %NEXT_PC, align 4
  %v4246 = load i32, ptr %EBP, align 4
  %v4247 = load i32, ptr %SSBASE, align 4
  %v4248 = sub i32 %v4246, 16
  %v4249 = add i32 %v4248, %v4247
  %v4250 = load ptr, ptr %MEMORY, align 4
  %v4251 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4250, ptr %state, ptr %EAX, i32 %v4249)
  store ptr %v4251, ptr %MEMORY, align 4
  store i32 %v4245, ptr %PC, align 4
  %v4252 = add i32 %v4245, 2
  store i32 %v4252, ptr %NEXT_PC, align 4
  %v4253 = load i32, ptr %EAX, align 4
  %v4254 = load i32, ptr %DSBASE, align 4
  %v4255 = add i32 %v4253, %v4254
  %v4256 = load ptr, ptr %MEMORY, align 4
  %v4257 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4256, ptr %state, ptr %ECX, i32 %v4255)
  store ptr %v4257, ptr %MEMORY, align 4
  store i32 %v4252, ptr %PC, align 4
  %v4258 = add i32 %v4252, 3
  store i32 %v4258, ptr %NEXT_PC, align 4
  %v4259 = load i32, ptr %EBP, align 4
  %v4260 = load i32, ptr %SSBASE, align 4
  %v4261 = add i32 %v4259, 16
  %v4262 = add i32 %v4261, %v4260
  %v4263 = load ptr, ptr %MEMORY, align 4
  %v4264 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4263, ptr %state, ptr %EAX, i32 %v4262)
  store ptr %v4264, ptr %MEMORY, align 4
  store i32 %v4258, ptr %PC, align 4
  %v4265 = add i32 %v4258, 2
  store i32 %v4265, ptr %NEXT_PC, align 4
  %v4266 = load i32, ptr %EAX, align 4
  %v4267 = load i32, ptr %ECX, align 4
  %v4268 = load ptr, ptr %MEMORY, align 4
  %v4269 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4268, ptr %state, ptr %EAX, i32 %v4266, i32 %v4267)
  store ptr %v4269, ptr %MEMORY, align 4
  store i32 %v4265, ptr %PC, align 4
  %v4270 = add i32 %v4265, 2
  store i32 %v4270, ptr %NEXT_PC, align 4
  %v4271 = load i32, ptr %EDX, align 4
  %v4272 = load ptr, ptr %MEMORY, align 4
  %v4273 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4272, ptr %state, ptr %ECX, i32 %v4271)
  store ptr %v4273, ptr %MEMORY, align 4
  store i32 %v4270, ptr %PC, align 4
  %v4274 = add i32 %v4270, 2
  store i32 %v4274, ptr %NEXT_PC, align 4
  %v4275 = load i32, ptr %ECX, align 4
  %v4276 = load i32, ptr %EAX, align 4
  %v4277 = load ptr, ptr %MEMORY, align 4
  %v4278 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4277, ptr %state, ptr %ECX, i32 %v4275, i32 %v4276)
  store ptr %v4278, ptr %MEMORY, align 4
  store i32 %v4274, ptr %PC, align 4
  %v4279 = add i32 %v4274, 2
  store i32 %v4279, ptr %NEXT_PC, align 4
  %v4280 = load i32, ptr %ECX, align 4
  %v4281 = load ptr, ptr %MEMORY, align 4
  %v4282 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4281, ptr %state, ptr %EAX, i32 %v4280)
  store ptr %v4282, ptr %MEMORY, align 4
  store i32 %v4279, ptr %PC, align 4
  %v4283 = add i32 %v4279, 3
  store i32 %v4283, ptr %NEXT_PC, align 4
  %v4284 = load i32, ptr %EBP, align 4
  %v4285 = load i32, ptr %SSBASE, align 4
  %v4286 = sub i32 %v4284, 32
  %v4287 = add i32 %v4286, %v4285
  %v4288 = load i32, ptr %EAX, align 4
  %v4289 = load ptr, ptr %MEMORY, align 4
  %v4290 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4289, ptr %state, i32 %v4287, i32 %v4288)
  store ptr %v4290, ptr %MEMORY, align 4
  store i32 %v4283, ptr %PC, align 4
  %v4291 = add i32 %v4283, 3
  store i32 %v4291, ptr %NEXT_PC, align 4
  %v4292 = load i32, ptr %EBP, align 4
  %v4293 = load i32, ptr %SSBASE, align 4
  %v4294 = sub i32 %v4292, 32
  %v4295 = add i32 %v4294, %v4293
  %v4296 = load ptr, ptr %MEMORY, align 4
  %v4297 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4296, ptr %state, ptr %EDX, i32 %v4295)
  store ptr %v4297, ptr %MEMORY, align 4
  store i32 %v4291, ptr %PC, align 4
  %v4298 = add i32 %v4291, 3
  store i32 %v4298, ptr %NEXT_PC, align 4
  %v4299 = load i32, ptr %EBP, align 4
  %v4300 = load i32, ptr %SSBASE, align 4
  %v4301 = sub i32 %v4299, 28
  %v4302 = add i32 %v4301, %v4300
  %v4303 = load ptr, ptr %MEMORY, align 4
  %v4304 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4303, ptr %state, ptr %EAX, i32 %v4302)
  store ptr %v4304, ptr %MEMORY, align 4
  store i32 %v4298, ptr %PC, align 4
  %v4305 = add i32 %v4298, 2
  store i32 %v4305, ptr %NEXT_PC, align 4
  %v4306 = load i32, ptr %EAX, align 4
  %v4307 = load i32, ptr %EDX, align 4
  %v4308 = load ptr, ptr %MEMORY, align 4
  %v4309 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4308, ptr %state, ptr %EAX, i32 %v4306, i32 %v4307)
  store ptr %v4309, ptr %MEMORY, align 4
  store i32 %v4305, ptr %PC, align 4
  %v4310 = add i32 %v4305, 3
  store i32 %v4310, ptr %NEXT_PC, align 4
  %v4311 = load i32, ptr %EBP, align 4
  %v4312 = load i32, ptr %SSBASE, align 4
  %v4313 = sub i32 %v4311, 32
  %v4314 = add i32 %v4313, %v4312
  %v4315 = load i32, ptr %EAX, align 4
  %v4316 = load ptr, ptr %MEMORY, align 4
  %v4317 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4316, ptr %state, i32 %v4314, i32 %v4315)
  store ptr %v4317, ptr %MEMORY, align 4
  store i32 %v4310, ptr %PC, align 4
  %v4318 = add i32 %v4310, 3
  store i32 %v4318, ptr %NEXT_PC, align 4
  %v4319 = load i32, ptr %EBP, align 4
  %v4320 = load i32, ptr %SSBASE, align 4
  %v4321 = sub i32 %v4319, 16
  %v4322 = add i32 %v4321, %v4320
  %v4323 = load ptr, ptr %MEMORY, align 4
  %v4324 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4323, ptr %state, ptr %EAX, i32 %v4322)
  store ptr %v4324, ptr %MEMORY, align 4
  store i32 %v4318, ptr %PC, align 4
  %v4325 = add i32 %v4318, 3
  store i32 %v4325, ptr %NEXT_PC, align 4
  %v4326 = load i32, ptr %EAX, align 4
  %v4327 = load i32, ptr %DSBASE, align 4
  %v4328 = add i32 %v4326, 8
  %v4329 = add i32 %v4328, %v4327
  %v4330 = load ptr, ptr %MEMORY, align 4
  %v4331 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4330, ptr %state, ptr %EAX, i32 %v4329)
  store ptr %v4331, ptr %MEMORY, align 4
  store i32 %v4325, ptr %PC, align 4
  %v4332 = add i32 %v4325, 5
  store i32 %v4332, ptr %NEXT_PC, align 4
  %v4333 = load i32, ptr %EAX, align 4
  %v4334 = load ptr, ptr %MEMORY, align 4
  %v4335 = call ptr @_ZN12_GLOBAL__N_13ANDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4334, ptr %state, ptr %EAX, i32 %v4333, i32 255)
  store ptr %v4335, ptr %MEMORY, align 4
  store i32 %v4332, ptr %PC, align 4
  %v4336 = add i32 %v4332, 3
  store i32 %v4336, ptr %NEXT_PC, align 4
  %v4337 = load i32, ptr %EAX, align 4
  %v4338 = load ptr, ptr %MEMORY, align 4
  %v4339 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4338, ptr %state, i32 %v4337, i32 16)
  store ptr %v4339, ptr %MEMORY, align 4
  store i32 %v4336, ptr %PC, align 4
  %v4340 = add i32 %v4336, 2
  store i32 %v4340, ptr %NEXT_PC, align 4
  %v4341 = add i32 %v4340, 38
  %v4342 = load ptr, ptr %MEMORY, align 4
  %v4343 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4342, ptr %state, ptr %BRANCH_TAKEN, i32 %v4341, i32 %v4340, ptr %NEXT_PC)
  store ptr %v4343, ptr %MEMORY, align 4
  br i1 true, label %bb_4203641, label %bb_4203603

bb_4203603:                                       ; preds = %bb_4203552
  store i32 %v4340, ptr %PC, align 4
  %v4344 = add i32 %v4340, 3
  store i32 %v4344, ptr %NEXT_PC, align 4
  %v4345 = load i32, ptr %EAX, align 4
  %v4346 = load ptr, ptr %MEMORY, align 4
  %v4347 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4346, ptr %state, i32 %v4345, i32 32)
  store ptr %v4347, ptr %MEMORY, align 4
  store i32 %v4344, ptr %PC, align 4
  %v4348 = add i32 %v4344, 2
  store i32 %v4348, ptr %NEXT_PC, align 4
  %v4349 = add i32 %v4348, 61
  %v4350 = load ptr, ptr %MEMORY, align 4
  %v4351 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4350, ptr %state, ptr %BRANCH_TAKEN, i32 %v4349, i32 %v4348, ptr %NEXT_PC)
  store ptr %v4351, ptr %MEMORY, align 4
  br i1 true, label %bb_4203669, label %bb_4203608

bb_4203608:                                       ; preds = %bb_4203603
  store i32 %v4348, ptr %PC, align 4
  %v4352 = add i32 %v4348, 3
  store i32 %v4352, ptr %NEXT_PC, align 4
  %v4353 = load i32, ptr %EAX, align 4
  %v4354 = load ptr, ptr %MEMORY, align 4
  %v4355 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4354, ptr %state, i32 %v4353, i32 8)
  store ptr %v4355, ptr %MEMORY, align 4
  store i32 %v4352, ptr %PC, align 4
  %v4356 = add i32 %v4352, 2
  store i32 %v4356, ptr %NEXT_PC, align 4
  %v4357 = add i32 %v4356, 83
  %v4358 = load ptr, ptr %MEMORY, align 4
  %v4359 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4358, ptr %state, ptr %BRANCH_TAKEN, i32 %v4357, i32 %v4356, ptr %NEXT_PC)
  store ptr %v4359, ptr %MEMORY, align 4
  br i1 true, label %bb_4203696, label %bb_4203613

bb_4203613:                                       ; preds = %bb_4203608
  store i32 %v4356, ptr %PC, align 4
  %v4360 = add i32 %v4356, 3
  store i32 %v4360, ptr %NEXT_PC, align 4
  %v4361 = load i32, ptr %EBP, align 4
  %v4362 = load i32, ptr %SSBASE, align 4
  %v4363 = sub i32 %v4361, 24
  %v4364 = add i32 %v4363, %v4362
  %v4365 = load ptr, ptr %MEMORY, align 4
  %v4366 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4365, ptr %state, ptr %EAX, i32 %v4364)
  store ptr %v4366, ptr %MEMORY, align 4
  store i32 %v4360, ptr %PC, align 4
  %v4367 = add i32 %v4360, 8
  store i32 %v4367, ptr %NEXT_PC, align 4
  %v4368 = load i32, ptr %ESP, align 4
  %v4369 = load i32, ptr %SSBASE, align 4
  %v4370 = add i32 %v4368, 8
  %v4371 = add i32 %v4370, %v4369
  %v4372 = load ptr, ptr %MEMORY, align 4
  %v4373 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4372, ptr %state, i32 %v4371, i32 1)
  store ptr %v4373, ptr %MEMORY, align 4
  store i32 %v4367, ptr %PC, align 4
  %v4374 = add i32 %v4367, 3
  store i32 %v4374, ptr %NEXT_PC, align 4
  %v4375 = load i32, ptr %EBP, align 4
  %v4376 = sub i32 %v4375, 32
  %v4377 = load ptr, ptr %MEMORY, align 4
  %v4378 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4377, ptr %state, ptr %EDX, i32 %v4376)
  store ptr %v4378, ptr %MEMORY, align 4
  store i32 %v4374, ptr %PC, align 4
  %v4379 = add i32 %v4374, 4
  store i32 %v4379, ptr %NEXT_PC, align 4
  %v4380 = load i32, ptr %ESP, align 4
  %v4381 = load i32, ptr %SSBASE, align 4
  %v4382 = add i32 %v4380, 4
  %v4383 = add i32 %v4382, %v4381
  %v4384 = load i32, ptr %EDX, align 4
  %v4385 = load ptr, ptr %MEMORY, align 4
  %v4386 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4385, ptr %state, i32 %v4383, i32 %v4384)
  store ptr %v4386, ptr %MEMORY, align 4
  store i32 %v4379, ptr %PC, align 4
  %v4387 = add i32 %v4379, 3
  store i32 %v4387, ptr %NEXT_PC, align 4
  %v4388 = load i32, ptr %ESP, align 4
  %v4389 = load i32, ptr %SSBASE, align 4
  %v4390 = add i32 %v4388, %v4389
  %v4391 = load i32, ptr %EAX, align 4
  %v4392 = load ptr, ptr %MEMORY, align 4
  %v4393 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4392, ptr %state, i32 %v4390, i32 %v4391)
  store ptr %v4393, ptr %MEMORY, align 4
  store i32 %v4387, ptr %PC, align 4
  %v4394 = add i32 %v4387, 5
  store i32 %v4394, ptr %NEXT_PC, align 4
  %v4395 = sub i32 %v4394, 739
  %v4396 = load ptr, ptr %MEMORY, align 4
  %v4397 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4396, ptr %state, i64 4202900, ptr %NEXT_PC, i32 %v4394, ptr %RETURN_PC)
  store ptr %v4397, ptr %MEMORY, align 4
  store i32 %v4394, ptr %PC, align 4
  %v4398 = add i32 %v4394, 2
  store i32 %v4398, ptr %NEXT_PC, align 4
  %v4399 = add i32 %v4398, 55
  %v4400 = load ptr, ptr %MEMORY, align 4
  %v4401 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4400, ptr %state, i32 %v4399, ptr %NEXT_PC)
  store ptr %v4401, ptr %MEMORY, align 4
  br label %bb_4203696

bb_4203641:                                       ; preds = %bb_4203552
  store i32 %v4340, ptr %PC, align 4
  %v4402 = add i32 %v4340, 3
  store i32 %v4402, ptr %NEXT_PC, align 4
  %v4403 = load i32, ptr %EBP, align 4
  %v4404 = load i32, ptr %SSBASE, align 4
  %v4405 = sub i32 %v4403, 24
  %v4406 = add i32 %v4405, %v4404
  %v4407 = load ptr, ptr %MEMORY, align 4
  %v4408 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4407, ptr %state, ptr %EAX, i32 %v4406)
  store ptr %v4408, ptr %MEMORY, align 4
  store i32 %v4402, ptr %PC, align 4
  %v4409 = add i32 %v4402, 8
  store i32 %v4409, ptr %NEXT_PC, align 4
  %v4410 = load i32, ptr %ESP, align 4
  %v4411 = load i32, ptr %SSBASE, align 4
  %v4412 = add i32 %v4410, 8
  %v4413 = add i32 %v4412, %v4411
  %v4414 = load ptr, ptr %MEMORY, align 4
  %v4415 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4414, ptr %state, i32 %v4413, i32 2)
  store ptr %v4415, ptr %MEMORY, align 4
  store i32 %v4409, ptr %PC, align 4
  %v4416 = add i32 %v4409, 3
  store i32 %v4416, ptr %NEXT_PC, align 4
  %v4417 = load i32, ptr %EBP, align 4
  %v4418 = sub i32 %v4417, 32
  %v4419 = load ptr, ptr %MEMORY, align 4
  %v4420 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4419, ptr %state, ptr %EDX, i32 %v4418)
  store ptr %v4420, ptr %MEMORY, align 4
  store i32 %v4416, ptr %PC, align 4
  %v4421 = add i32 %v4416, 4
  store i32 %v4421, ptr %NEXT_PC, align 4
  %v4422 = load i32, ptr %ESP, align 4
  %v4423 = load i32, ptr %SSBASE, align 4
  %v4424 = add i32 %v4422, 4
  %v4425 = add i32 %v4424, %v4423
  %v4426 = load i32, ptr %EDX, align 4
  %v4427 = load ptr, ptr %MEMORY, align 4
  %v4428 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4427, ptr %state, i32 %v4425, i32 %v4426)
  store ptr %v4428, ptr %MEMORY, align 4
  store i32 %v4421, ptr %PC, align 4
  %v4429 = add i32 %v4421, 3
  store i32 %v4429, ptr %NEXT_PC, align 4
  %v4430 = load i32, ptr %ESP, align 4
  %v4431 = load i32, ptr %SSBASE, align 4
  %v4432 = add i32 %v4430, %v4431
  %v4433 = load i32, ptr %EAX, align 4
  %v4434 = load ptr, ptr %MEMORY, align 4
  %v4435 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4434, ptr %state, i32 %v4432, i32 %v4433)
  store ptr %v4435, ptr %MEMORY, align 4
  store i32 %v4429, ptr %PC, align 4
  %v4436 = add i32 %v4429, 5
  store i32 %v4436, ptr %NEXT_PC, align 4
  %v4437 = sub i32 %v4436, 767
  %v4438 = load ptr, ptr %MEMORY, align 4
  %v4439 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4438, ptr %state, i64 4202900, ptr %NEXT_PC, i32 %v4436, ptr %RETURN_PC)
  store ptr %v4439, ptr %MEMORY, align 4
  store i32 %v4436, ptr %PC, align 4
  %v4440 = add i32 %v4436, 2
  store i32 %v4440, ptr %NEXT_PC, align 4
  %v4441 = add i32 %v4440, 27
  %v4442 = load ptr, ptr %MEMORY, align 4
  %v4443 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4442, ptr %state, i32 %v4441, ptr %NEXT_PC)
  store ptr %v4443, ptr %MEMORY, align 4
  br label %bb_4203696

bb_4203669:                                       ; preds = %bb_4203603
  store i32 %v4348, ptr %PC, align 4
  %v4444 = add i32 %v4348, 3
  store i32 %v4444, ptr %NEXT_PC, align 4
  %v4445 = load i32, ptr %EBP, align 4
  %v4446 = load i32, ptr %SSBASE, align 4
  %v4447 = sub i32 %v4445, 24
  %v4448 = add i32 %v4447, %v4446
  %v4449 = load ptr, ptr %MEMORY, align 4
  %v4450 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4449, ptr %state, ptr %EAX, i32 %v4448)
  store ptr %v4450, ptr %MEMORY, align 4
  store i32 %v4444, ptr %PC, align 4
  %v4451 = add i32 %v4444, 8
  store i32 %v4451, ptr %NEXT_PC, align 4
  %v4452 = load i32, ptr %ESP, align 4
  %v4453 = load i32, ptr %SSBASE, align 4
  %v4454 = add i32 %v4452, 8
  %v4455 = add i32 %v4454, %v4453
  %v4456 = load ptr, ptr %MEMORY, align 4
  %v4457 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4456, ptr %state, i32 %v4455, i32 4)
  store ptr %v4457, ptr %MEMORY, align 4
  store i32 %v4451, ptr %PC, align 4
  %v4458 = add i32 %v4451, 3
  store i32 %v4458, ptr %NEXT_PC, align 4
  %v4459 = load i32, ptr %EBP, align 4
  %v4460 = sub i32 %v4459, 32
  %v4461 = load ptr, ptr %MEMORY, align 4
  %v4462 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4461, ptr %state, ptr %EDX, i32 %v4460)
  store ptr %v4462, ptr %MEMORY, align 4
  store i32 %v4458, ptr %PC, align 4
  %v4463 = add i32 %v4458, 4
  store i32 %v4463, ptr %NEXT_PC, align 4
  %v4464 = load i32, ptr %ESP, align 4
  %v4465 = load i32, ptr %SSBASE, align 4
  %v4466 = add i32 %v4464, 4
  %v4467 = add i32 %v4466, %v4465
  %v4468 = load i32, ptr %EDX, align 4
  %v4469 = load ptr, ptr %MEMORY, align 4
  %v4470 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4469, ptr %state, i32 %v4467, i32 %v4468)
  store ptr %v4470, ptr %MEMORY, align 4
  store i32 %v4463, ptr %PC, align 4
  %v4471 = add i32 %v4463, 3
  store i32 %v4471, ptr %NEXT_PC, align 4
  %v4472 = load i32, ptr %ESP, align 4
  %v4473 = load i32, ptr %SSBASE, align 4
  %v4474 = add i32 %v4472, %v4473
  %v4475 = load i32, ptr %EAX, align 4
  %v4476 = load ptr, ptr %MEMORY, align 4
  %v4477 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4476, ptr %state, i32 %v4474, i32 %v4475)
  store ptr %v4477, ptr %MEMORY, align 4
  store i32 %v4471, ptr %PC, align 4
  %v4478 = add i32 %v4471, 5
  store i32 %v4478, ptr %NEXT_PC, align 4
  %v4479 = sub i32 %v4478, 795
  %v4480 = load ptr, ptr %MEMORY, align 4
  %v4481 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4480, ptr %state, i64 4202900, ptr %NEXT_PC, i32 %v4478, ptr %RETURN_PC)
  store ptr %v4481, ptr %MEMORY, align 4
  store i32 %v4478, ptr %PC, align 4
  %v4482 = add i32 %v4478, 1
  store i32 %v4482, ptr %NEXT_PC, align 4
  %v4483 = load ptr, ptr %MEMORY, align 4
  %v4484 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4483, ptr %state)
  store ptr %v4484, ptr %MEMORY, align 4
  br label %bb_4203696

bb_4203696:                                       ; preds = %bb_4203669, %bb_4203641, %bb_4203613, %bb_4203608
  %v4485 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4485, ptr %PC, align 4
  %v4486 = add i32 %v4485, 4
  store i32 %v4486, ptr %NEXT_PC, align 4
  %v4487 = load i32, ptr %EBP, align 4
  %v4488 = load i32, ptr %SSBASE, align 4
  %v4489 = sub i32 %v4487, 16
  %v4490 = add i32 %v4489, %v4488
  %v4491 = load i32, ptr %EBP, align 4
  %v4492 = load i32, ptr %SSBASE, align 4
  %v4493 = sub i32 %v4491, 16
  %v4494 = add i32 %v4493, %v4492
  %v4495 = load ptr, ptr %MEMORY, align 4
  %v4496 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4495, ptr %state, i32 %v4490, i32 %v4494, i32 12)
  store ptr %v4496, ptr %MEMORY, align 4
  br label %bb_4203700

bb_4203700:                                       ; preds = %bb_4203696, %bb_4203355
  %v4497 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4497, ptr %PC, align 4
  %v4498 = add i32 %v4497, 3
  store i32 %v4498, ptr %NEXT_PC, align 4
  %v4499 = load i32, ptr %EBP, align 4
  %v4500 = load i32, ptr %SSBASE, align 4
  %v4501 = sub i32 %v4499, 16
  %v4502 = add i32 %v4501, %v4500
  %v4503 = load ptr, ptr %MEMORY, align 4
  %v4504 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4503, ptr %state, ptr %EAX, i32 %v4502)
  store ptr %v4504, ptr %MEMORY, align 4
  store i32 %v4498, ptr %PC, align 4
  %v4505 = add i32 %v4498, 3
  store i32 %v4505, ptr %NEXT_PC, align 4
  %v4506 = load i32, ptr %EAX, align 4
  %v4507 = load i32, ptr %EBP, align 4
  %v4508 = load i32, ptr %SSBASE, align 4
  %v4509 = add i32 %v4507, 12
  %v4510 = add i32 %v4509, %v4508
  %v4511 = load ptr, ptr %MEMORY, align 4
  %v4512 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIjLb1EE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4511, ptr %state, i32 %v4506, i32 %v4510)
  store ptr %v4512, ptr %MEMORY, align 4
  store i32 %v4505, ptr %PC, align 4
  %v4513 = add i32 %v4505, 6
  store i32 %v4513, ptr %NEXT_PC, align 4
  %v4514 = sub i32 %v4513, 343
  %v4515 = load ptr, ptr %MEMORY, align 4
  %v4516 = call ptr @_ZN12_GLOBAL__N_12JBEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4515, ptr %state, ptr %BRANCH_TAKEN, i32 %v4514, i32 %v4513, ptr %NEXT_PC)
  store ptr %v4516, ptr %MEMORY, align 4
  br i1 true, label %bb_4203369, label %bb_4203712

bb_4203712:                                       ; preds = %bb_4203700, %bb_4203317, %bb_4203147
  %v4517 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4517, ptr %PC, align 4
  %v4518 = add i32 %v4517, 1
  store i32 %v4518, ptr %NEXT_PC, align 4
  %v4519 = load ptr, ptr %MEMORY, align 4
  %v4520 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v4519, ptr %state)
  store ptr %v4520, ptr %MEMORY, align 4
  store i32 %v4518, ptr %PC, align 4
  %v4521 = add i32 %v4518, 1
  store i32 %v4521, ptr %NEXT_PC, align 4
  %v4522 = load ptr, ptr %MEMORY, align 4
  %v4523 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4522, ptr %state, ptr %NEXT_PC)
  store ptr %v4523, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203714:                                       ; No predecessors!
  %v4524 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4524, ptr %PC, align 4
  %v4525 = add i32 %v4524, 1
  store i32 %v4525, ptr %NEXT_PC, align 4
  %v4526 = load i32, ptr %EBP, align 4
  %v4527 = load ptr, ptr %MEMORY, align 4
  %v4528 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4527, ptr %state, i32 %v4526)
  store ptr %v4528, ptr %MEMORY, align 4
  store i32 %v4525, ptr %PC, align 4
  %v4529 = add i32 %v4525, 2
  store i32 %v4529, ptr %NEXT_PC, align 4
  %v4530 = load i32, ptr %ESP, align 4
  %v4531 = load ptr, ptr %MEMORY, align 4
  %v4532 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4531, ptr %state, ptr %EBP, i32 %v4530)
  store ptr %v4532, ptr %MEMORY, align 4
  store i32 %v4529, ptr %PC, align 4
  %v4533 = add i32 %v4529, 3
  store i32 %v4533, ptr %NEXT_PC, align 4
  %v4534 = load i32, ptr %ESP, align 4
  %v4535 = load ptr, ptr %MEMORY, align 4
  %v4536 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4535, ptr %state, ptr %ESP, i32 %v4534, i32 56)
  store ptr %v4536, ptr %MEMORY, align 4
  store i32 %v4533, ptr %PC, align 4
  %v4537 = add i32 %v4533, 5
  store i32 %v4537, ptr %NEXT_PC, align 4
  %v4538 = load i32, ptr %DSBASE, align 4
  %v4539 = add i32 4240296, %v4538
  %v4540 = load ptr, ptr %MEMORY, align 4
  %v4541 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4540, ptr %state, ptr %EAX, i32 %v4539)
  store ptr %v4541, ptr %MEMORY, align 4
  store i32 %v4537, ptr %PC, align 4
  %v4542 = add i32 %v4537, 2
  store i32 %v4542, ptr %NEXT_PC, align 4
  %v4543 = load i32, ptr %EAX, align 4
  %v4544 = load i32, ptr %EAX, align 4
  %v4545 = load ptr, ptr %MEMORY, align 4
  %v4546 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4545, ptr %state, i32 %v4543, i32 %v4544)
  store ptr %v4546, ptr %MEMORY, align 4
  store i32 %v4542, ptr %PC, align 4
  %v4547 = add i32 %v4542, 6
  store i32 %v4547, ptr %NEXT_PC, align 4
  %v4548 = add i32 %v4547, 134
  %v4549 = load ptr, ptr %MEMORY, align 4
  %v4550 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4549, ptr %state, ptr %BRANCH_TAKEN, i32 %v4548, i32 %v4547, ptr %NEXT_PC)
  store ptr %v4550, ptr %MEMORY, align 4
  br i1 true, label %bb_4203867, label %bb_4203733

bb_4203733:                                       ; preds = %bb_4203714
  store i32 %v4547, ptr %PC, align 4
  %v4551 = add i32 %v4547, 5
  store i32 %v4551, ptr %NEXT_PC, align 4
  %v4552 = load i32, ptr %DSBASE, align 4
  %v4553 = add i32 4240296, %v4552
  %v4554 = load ptr, ptr %MEMORY, align 4
  %v4555 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4554, ptr %state, ptr %EAX, i32 %v4553)
  store ptr %v4555, ptr %MEMORY, align 4
  store i32 %v4551, ptr %PC, align 4
  %v4556 = add i32 %v4551, 3
  store i32 %v4556, ptr %NEXT_PC, align 4
  %v4557 = load i32, ptr %EAX, align 4
  %v4558 = load ptr, ptr %MEMORY, align 4
  %v4559 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4558, ptr %state, ptr %EAX, i32 %v4557, i32 1)
  store ptr %v4559, ptr %MEMORY, align 4
  store i32 %v4556, ptr %PC, align 4
  %v4560 = add i32 %v4556, 5
  store i32 %v4560, ptr %NEXT_PC, align 4
  %v4561 = load i32, ptr %DSBASE, align 4
  %v4562 = add i32 4240296, %v4561
  %v4563 = load i32, ptr %EAX, align 4
  %v4564 = load ptr, ptr %MEMORY, align 4
  %v4565 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4564, ptr %state, i32 %v4562, i32 %v4563)
  store ptr %v4565, ptr %MEMORY, align 4
  store i32 %v4560, ptr %PC, align 4
  %v4566 = add i32 %v4560, 5
  store i32 %v4566, ptr %NEXT_PC, align 4
  %v4567 = add i32 %v4566, 761
  %v4568 = load ptr, ptr %MEMORY, align 4
  %v4569 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4568, ptr %state, i64 4204512, ptr %NEXT_PC, i32 %v4566, ptr %RETURN_PC)
  store ptr %v4569, ptr %MEMORY, align 4
  store i32 %v4566, ptr %PC, align 4
  %v4570 = add i32 %v4566, 3
  store i32 %v4570, ptr %NEXT_PC, align 4
  %v4571 = load i32, ptr %EBP, align 4
  %v4572 = load i32, ptr %SSBASE, align 4
  %v4573 = sub i32 %v4571, 12
  %v4574 = add i32 %v4573, %v4572
  %v4575 = load i32, ptr %EAX, align 4
  %v4576 = load ptr, ptr %MEMORY, align 4
  %v4577 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4576, ptr %state, i32 %v4574, i32 %v4575)
  store ptr %v4577, ptr %MEMORY, align 4
  store i32 %v4570, ptr %PC, align 4
  %v4578 = add i32 %v4570, 3
  store i32 %v4578, ptr %NEXT_PC, align 4
  %v4579 = load i32, ptr %EBP, align 4
  %v4580 = load i32, ptr %SSBASE, align 4
  %v4581 = sub i32 %v4579, 12
  %v4582 = add i32 %v4581, %v4580
  %v4583 = load ptr, ptr %MEMORY, align 4
  %v4584 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4583, ptr %state, ptr %EDX, i32 %v4582)
  store ptr %v4584, ptr %MEMORY, align 4
  store i32 %v4578, ptr %PC, align 4
  %v4585 = add i32 %v4578, 2
  store i32 %v4585, ptr %NEXT_PC, align 4
  %v4586 = load i32, ptr %EDX, align 4
  %v4587 = load ptr, ptr %MEMORY, align 4
  %v4588 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4587, ptr %state, ptr %EAX, i32 %v4586)
  store ptr %v4588, ptr %MEMORY, align 4
  store i32 %v4585, ptr %PC, align 4
  %v4589 = add i32 %v4585, 2
  store i32 %v4589, ptr %NEXT_PC, align 4
  %v4590 = load i32, ptr %EAX, align 4
  %v4591 = load i32, ptr %EAX, align 4
  %v4592 = load ptr, ptr %MEMORY, align 4
  %v4593 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4592, ptr %state, ptr %EAX, i32 %v4590, i32 %v4591)
  store ptr %v4593, ptr %MEMORY, align 4
  store i32 %v4589, ptr %PC, align 4
  %v4594 = add i32 %v4589, 2
  store i32 %v4594, ptr %NEXT_PC, align 4
  %v4595 = load i32, ptr %EAX, align 4
  %v4596 = load i32, ptr %EDX, align 4
  %v4597 = load ptr, ptr %MEMORY, align 4
  %v4598 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4597, ptr %state, ptr %EAX, i32 %v4595, i32 %v4596)
  store ptr %v4598, ptr %MEMORY, align 4
  store i32 %v4594, ptr %PC, align 4
  %v4599 = add i32 %v4594, 3
  store i32 %v4599, ptr %NEXT_PC, align 4
  %v4600 = load i32, ptr %EAX, align 4
  %v4601 = load ptr, ptr %MEMORY, align 4
  %v4602 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4601, ptr %state, ptr %EAX, i32 %v4600, i32 2)
  store ptr %v4602, ptr %MEMORY, align 4
  store i32 %v4599, ptr %PC, align 4
  %v4603 = add i32 %v4599, 3
  store i32 %v4603, ptr %NEXT_PC, align 4
  %v4604 = load i32, ptr %EAX, align 4
  %v4605 = add i32 %v4604, 15
  %v4606 = load ptr, ptr %MEMORY, align 4
  %v4607 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4606, ptr %state, ptr %EDX, i32 %v4605)
  store ptr %v4607, ptr %MEMORY, align 4
  store i32 %v4603, ptr %PC, align 4
  %v4608 = add i32 %v4603, 5
  store i32 %v4608, ptr %NEXT_PC, align 4
  %v4609 = load ptr, ptr %MEMORY, align 4
  %v4610 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4609, ptr %state, ptr %EAX, i32 16)
  store ptr %v4610, ptr %MEMORY, align 4
  store i32 %v4608, ptr %PC, align 4
  %v4611 = add i32 %v4608, 3
  store i32 %v4611, ptr %NEXT_PC, align 4
  %v4612 = load i32, ptr %EAX, align 4
  %v4613 = load ptr, ptr %MEMORY, align 4
  %v4614 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4613, ptr %state, ptr %EAX, i32 %v4612, i32 1)
  store ptr %v4614, ptr %MEMORY, align 4
  store i32 %v4611, ptr %PC, align 4
  %v4615 = add i32 %v4611, 2
  store i32 %v4615, ptr %NEXT_PC, align 4
  %v4616 = load i32, ptr %EAX, align 4
  %v4617 = load i32, ptr %EDX, align 4
  %v4618 = load ptr, ptr %MEMORY, align 4
  %v4619 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4618, ptr %state, ptr %EAX, i32 %v4616, i32 %v4617)
  store ptr %v4619, ptr %MEMORY, align 4
  store i32 %v4615, ptr %PC, align 4
  %v4620 = add i32 %v4615, 7
  store i32 %v4620, ptr %NEXT_PC, align 4
  %v4621 = load i32, ptr %EBP, align 4
  %v4622 = load i32, ptr %SSBASE, align 4
  %v4623 = sub i32 %v4621, 28
  %v4624 = add i32 %v4623, %v4622
  %v4625 = load ptr, ptr %MEMORY, align 4
  %v4626 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4625, ptr %state, i32 %v4624, i32 16)
  store ptr %v4626, ptr %MEMORY, align 4
  store i32 %v4620, ptr %PC, align 4
  %v4627 = add i32 %v4620, 5
  store i32 %v4627, ptr %NEXT_PC, align 4
  %v4628 = load ptr, ptr %MEMORY, align 4
  %v4629 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4628, ptr %state, ptr %EDX, i32 0)
  store ptr %v4629, ptr %MEMORY, align 4
  store i32 %v4627, ptr %PC, align 4
  %v4630 = add i32 %v4627, 3
  store i32 %v4630, ptr %NEXT_PC, align 4
  %v4631 = load i32, ptr %EBP, align 4
  %v4632 = load i32, ptr %SSBASE, align 4
  %v4633 = sub i32 %v4631, 28
  %v4634 = add i32 %v4633, %v4632
  %v4635 = load ptr, ptr %MEMORY, align 4
  %v4636 = call ptr @_ZN12_GLOBAL__N_19DIVedxeaxI2MnIjEEEP6MemoryS4_R5StateT_2InIjE(ptr %v4635, ptr %state, i32 %v4634, i32 %v4630)
  store ptr %v4636, ptr %MEMORY, align 4
  store i32 %v4630, ptr %PC, align 4
  %v4637 = add i32 %v4630, 3
  store i32 %v4637, ptr %NEXT_PC, align 4
  %v4638 = load i32, ptr %EAX, align 4
  %v4639 = load ptr, ptr %MEMORY, align 4
  %v4640 = call ptr @_ZN12_GLOBAL__N_14IMULI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4639, ptr %state, ptr %EAX, i32 %v4638, i32 16)
  store ptr %v4640, ptr %MEMORY, align 4
  store i32 %v4637, ptr %PC, align 4
  %v4641 = add i32 %v4637, 5
  store i32 %v4641, ptr %NEXT_PC, align 4
  %v4642 = add i32 %v4641, 2114
  %v4643 = load ptr, ptr %MEMORY, align 4
  %v4644 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4643, ptr %state, i64 4205916, ptr %NEXT_PC, i32 %v4641, ptr %RETURN_PC)
  store ptr %v4644, ptr %MEMORY, align 4
  store i32 %v4641, ptr %PC, align 4
  %v4645 = add i32 %v4641, 2
  store i32 %v4645, ptr %NEXT_PC, align 4
  %v4646 = load i32, ptr %ESP, align 4
  %v4647 = load i32, ptr %EAX, align 4
  %v4648 = load ptr, ptr %MEMORY, align 4
  %v4649 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v4648, ptr %state, ptr %ESP, i32 %v4646, i32 %v4647)
  store ptr %v4649, ptr %MEMORY, align 4
  store i32 %v4645, ptr %PC, align 4
  %v4650 = add i32 %v4645, 4
  store i32 %v4650, ptr %NEXT_PC, align 4
  %v4651 = load i32, ptr %ESP, align 4
  %v4652 = add i32 %v4651, 12
  %v4653 = load ptr, ptr %MEMORY, align 4
  %v4654 = call ptr @_ZN12_GLOBAL__N_13LEAI3RnWIjE2MnIhEjEEP6MemoryS6_R5StateT_T0_(ptr %v4653, ptr %state, ptr %EAX, i32 %v4652)
  store ptr %v4654, ptr %MEMORY, align 4
  store i32 %v4650, ptr %PC, align 4
  %v4655 = add i32 %v4650, 3
  store i32 %v4655, ptr %NEXT_PC, align 4
  %v4656 = load i32, ptr %EAX, align 4
  %v4657 = load ptr, ptr %MEMORY, align 4
  %v4658 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4657, ptr %state, ptr %EAX, i32 %v4656, i32 15)
  store ptr %v4658, ptr %MEMORY, align 4
  store i32 %v4655, ptr %PC, align 4
  %v4659 = add i32 %v4655, 3
  store i32 %v4659, ptr %NEXT_PC, align 4
  %v4660 = load i32, ptr %EAX, align 4
  %v4661 = load ptr, ptr %MEMORY, align 4
  %v4662 = call ptr @_ZN12_GLOBAL__N_13SHRI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4661, ptr %state, ptr %EAX, i32 %v4660, i32 4)
  store ptr %v4662, ptr %MEMORY, align 4
  store i32 %v4659, ptr %PC, align 4
  %v4663 = add i32 %v4659, 3
  store i32 %v4663, ptr %NEXT_PC, align 4
  %v4664 = load i32, ptr %EAX, align 4
  %v4665 = load ptr, ptr %MEMORY, align 4
  %v4666 = call ptr @_ZN12_GLOBAL__N_13SHLI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4665, ptr %state, ptr %EAX, i32 %v4664, i32 4)
  store ptr %v4666, ptr %MEMORY, align 4
  store i32 %v4663, ptr %PC, align 4
  %v4667 = add i32 %v4663, 5
  store i32 %v4667, ptr %NEXT_PC, align 4
  %v4668 = load i32, ptr %DSBASE, align 4
  %v4669 = add i32 4240288, %v4668
  %v4670 = load i32, ptr %EAX, align 4
  %v4671 = load ptr, ptr %MEMORY, align 4
  %v4672 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4671, ptr %state, i32 %v4669, i32 %v4670)
  store ptr %v4672, ptr %MEMORY, align 4
  store i32 %v4667, ptr %PC, align 4
  %v4673 = add i32 %v4667, 10
  store i32 %v4673, ptr %NEXT_PC, align 4
  %v4674 = load i32, ptr %DSBASE, align 4
  %v4675 = add i32 4240292, %v4674
  %v4676 = load ptr, ptr %MEMORY, align 4
  %v4677 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4676, ptr %state, i32 %v4675, i32 0)
  store ptr %v4677, ptr %MEMORY, align 4
  store i32 %v4673, ptr %PC, align 4
  %v4678 = add i32 %v4673, 8
  store i32 %v4678, ptr %NEXT_PC, align 4
  %v4679 = load i32, ptr %ESP, align 4
  %v4680 = load i32, ptr %SSBASE, align 4
  %v4681 = add i32 %v4679, 8
  %v4682 = add i32 %v4681, %v4680
  %v4683 = load ptr, ptr %MEMORY, align 4
  %v4684 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4683, ptr %state, i32 %v4682, i32 4194304)
  store ptr %v4684, ptr %MEMORY, align 4
  store i32 %v4678, ptr %PC, align 4
  %v4685 = add i32 %v4678, 8
  store i32 %v4685, ptr %NEXT_PC, align 4
  %v4686 = load i32, ptr %ESP, align 4
  %v4687 = load i32, ptr %SSBASE, align 4
  %v4688 = add i32 %v4686, 4
  %v4689 = add i32 %v4688, %v4687
  %v4690 = load ptr, ptr %MEMORY, align 4
  %v4691 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4690, ptr %state, i32 %v4689, i32 4236928)
  store ptr %v4691, ptr %MEMORY, align 4
  store i32 %v4685, ptr %PC, align 4
  %v4692 = add i32 %v4685, 7
  store i32 %v4692, ptr %NEXT_PC, align 4
  %v4693 = load i32, ptr %ESP, align 4
  %v4694 = load i32, ptr %SSBASE, align 4
  %v4695 = add i32 %v4693, %v4694
  %v4696 = load ptr, ptr %MEMORY, align 4
  %v4697 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4696, ptr %state, i32 %v4695, i32 4236928)
  store ptr %v4697, ptr %MEMORY, align 4
  store i32 %v4692, ptr %PC, align 4
  %v4698 = add i32 %v4692, 5
  store i32 %v4698, ptr %NEXT_PC, align 4
  %v4699 = sub i32 %v4698, 713
  %v4700 = load ptr, ptr %MEMORY, align 4
  %v4701 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4700, ptr %state, i64 4203147, ptr %NEXT_PC, i32 %v4698, ptr %RETURN_PC)
  store ptr %v4701, ptr %MEMORY, align 4
  store i32 %v4698, ptr %PC, align 4
  %v4702 = add i32 %v4698, 5
  store i32 %v4702, ptr %NEXT_PC, align 4
  %v4703 = sub i32 %v4702, 1220
  %v4704 = load ptr, ptr %MEMORY, align 4
  %v4705 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v4704, ptr %state, i64 4202645, ptr %NEXT_PC, i32 %v4702, ptr %RETURN_PC)
  store ptr %v4705, ptr %MEMORY, align 4
  store i32 %v4702, ptr %PC, align 4
  %v4706 = add i32 %v4702, 2
  store i32 %v4706, ptr %NEXT_PC, align 4
  %v4707 = add i32 %v4706, 1
  %v4708 = load ptr, ptr %MEMORY, align 4
  %v4709 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4708, ptr %state, i32 %v4707, ptr %NEXT_PC)
  store ptr %v4709, ptr %MEMORY, align 4
  br label %bb_4203868

bb_4203867:                                       ; preds = %bb_4203714
  store i32 %v4547, ptr %PC, align 4
  %v4710 = add i32 %v4547, 1
  store i32 %v4710, ptr %NEXT_PC, align 4
  %v4711 = load ptr, ptr %MEMORY, align 4
  %v4712 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4711, ptr %state)
  store ptr %v4712, ptr %MEMORY, align 4
  br label %bb_4203868

bb_4203868:                                       ; preds = %bb_4203867, %bb_4203733
  %v4713 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4713, ptr %PC, align 4
  %v4714 = add i32 %v4713, 1
  store i32 %v4714, ptr %NEXT_PC, align 4
  %v4715 = load ptr, ptr %MEMORY, align 4
  %v4716 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v4715, ptr %state)
  store ptr %v4716, ptr %MEMORY, align 4
  store i32 %v4714, ptr %PC, align 4
  %v4717 = add i32 %v4714, 1
  store i32 %v4717, ptr %NEXT_PC, align 4
  %v4718 = load ptr, ptr %MEMORY, align 4
  %v4719 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4718, ptr %state, ptr %NEXT_PC)
  store ptr %v4719, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203870:                                       ; No predecessors!
  %v4720 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4720, ptr %PC, align 4
  %v4721 = add i32 %v4720, 1
  store i32 %v4721, ptr %NEXT_PC, align 4
  %v4722 = load ptr, ptr %MEMORY, align 4
  %v4723 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4722, ptr %state)
  store ptr %v4723, ptr %MEMORY, align 4
  store i32 %v4721, ptr %PC, align 4
  %v4724 = add i32 %v4721, 1
  store i32 %v4724, ptr %NEXT_PC, align 4
  %v4725 = load ptr, ptr %MEMORY, align 4
  %v4726 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4725, ptr %state)
  store ptr %v4726, ptr %MEMORY, align 4
  store i32 %v4724, ptr %PC, align 4
  %v4727 = add i32 %v4724, 1
  store i32 %v4727, ptr %NEXT_PC, align 4
  %v4728 = load i32, ptr %EBP, align 4
  %v4729 = load ptr, ptr %MEMORY, align 4
  %v4730 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4729, ptr %state, i32 %v4728)
  store ptr %v4730, ptr %MEMORY, align 4
  store i32 %v4727, ptr %PC, align 4
  %v4731 = add i32 %v4727, 2
  store i32 %v4731, ptr %NEXT_PC, align 4
  %v4732 = load i32, ptr %ESP, align 4
  %v4733 = load ptr, ptr %MEMORY, align 4
  %v4734 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4733, ptr %state, ptr %EBP, i32 %v4732)
  store ptr %v4734, ptr %MEMORY, align 4
  store i32 %v4731, ptr %PC, align 4
  %v4735 = add i32 %v4731, 2
  store i32 %v4735, ptr %NEXT_PC, align 4
  %v4736 = load ptr, ptr %MEMORY, align 4
  %v4737 = call ptr @_ZN12_GLOBAL__N_18DoFNINITEP6MemoryR5State(ptr %v4736, ptr %state)
  store ptr %v4737, ptr %MEMORY, align 4
  store i32 %v4735, ptr %PC, align 4
  %v4738 = add i32 %v4735, 1
  store i32 %v4738, ptr %NEXT_PC, align 4
  %v4739 = load ptr, ptr %MEMORY, align 4
  %v4740 = call ptr @_ZN12_GLOBAL__N_13POPI3RnWIjEEEP6MemoryS4_R5StateT_(ptr %v4739, ptr %state, ptr %EBP)
  store ptr %v4740, ptr %MEMORY, align 4
  store i32 %v4738, ptr %PC, align 4
  %v4741 = add i32 %v4738, 1
  store i32 %v4741, ptr %NEXT_PC, align 4
  %v4742 = load ptr, ptr %MEMORY, align 4
  %v4743 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4742, ptr %state, ptr %NEXT_PC)
  store ptr %v4743, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203879:                                       ; No predecessors!
  %v4744 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4744, ptr %PC, align 4
  %v4745 = add i32 %v4744, 1
  store i32 %v4745, ptr %NEXT_PC, align 4
  %v4746 = load ptr, ptr %MEMORY, align 4
  %v4747 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v4746, ptr %state)
  store ptr %v4747, ptr %MEMORY, align 4
  store i32 %v4745, ptr %PC, align 4
  %v4748 = add i32 %v4745, 1
  store i32 %v4748, ptr %NEXT_PC, align 4
  %v4749 = load i32, ptr %EBP, align 4
  %v4750 = load ptr, ptr %MEMORY, align 4
  %v4751 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4750, ptr %state, i32 %v4749)
  store ptr %v4751, ptr %MEMORY, align 4
  store i32 %v4748, ptr %PC, align 4
  %v4752 = add i32 %v4748, 2
  store i32 %v4752, ptr %NEXT_PC, align 4
  %v4753 = load i32, ptr %ESP, align 4
  %v4754 = load ptr, ptr %MEMORY, align 4
  %v4755 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4754, ptr %state, ptr %EBP, i32 %v4753)
  store ptr %v4755, ptr %MEMORY, align 4
  store i32 %v4752, ptr %PC, align 4
  %v4756 = add i32 %v4752, 3
  store i32 %v4756, ptr %NEXT_PC, align 4
  %v4757 = load i32, ptr %ESP, align 4
  %v4758 = load ptr, ptr %MEMORY, align 4
  %v4759 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4758, ptr %state, ptr %ESP, i32 %v4757, i32 8)
  store ptr %v4759, ptr %MEMORY, align 4
  store i32 %v4756, ptr %PC, align 4
  %v4760 = add i32 %v4756, 2
  store i32 %v4760, ptr %NEXT_PC, align 4
  %v4761 = add i32 %v4760, 22
  %v4762 = load ptr, ptr %MEMORY, align 4
  %v4763 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4762, ptr %state, i32 %v4761, ptr %NEXT_PC)
  store ptr %v4763, ptr %MEMORY, align 4
  br label %bb_4203910

bb_4203888:                                       ; preds = %bb_4203910
  store i32 %v4811, ptr %PC, align 4
  %v4764 = add i32 %v4811, 5
  store i32 %v4764, ptr %NEXT_PC, align 4
  %v4765 = load i32, ptr %DSBASE, align 4
  %v4766 = add i32 4231408, %v4765
  %v4767 = load ptr, ptr %MEMORY, align 4
  %v4768 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4767, ptr %state, ptr %EAX, i32 %v4766)
  store ptr %v4768, ptr %MEMORY, align 4
  store i32 %v4764, ptr %PC, align 4
  %v4769 = add i32 %v4764, 2
  store i32 %v4769, ptr %NEXT_PC, align 4
  %v4770 = load i32, ptr %EAX, align 4
  %v4771 = load i32, ptr %DSBASE, align 4
  %v4772 = add i32 %v4770, %v4771
  %v4773 = load ptr, ptr %MEMORY, align 4
  %v4774 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4773, ptr %state, ptr %EAX, i32 %v4772)
  store ptr %v4774, ptr %MEMORY, align 4
  store i32 %v4769, ptr %PC, align 4
  %v4775 = add i32 %v4769, 2
  store i32 %v4775, ptr %NEXT_PC, align 4
  %v4776 = load i32, ptr %EAX, align 4
  %v4777 = load ptr, ptr %MEMORY, align 4
  %v4778 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v4777, ptr %state, i32 %v4776, ptr %NEXT_PC, i32 %v4775, ptr %RETURN_PC)
  store ptr %v4778, ptr %MEMORY, align 4
  store i32 %v4775, ptr %PC, align 4
  %v4779 = add i32 %v4775, 5
  store i32 %v4779, ptr %NEXT_PC, align 4
  %v4780 = load i32, ptr %DSBASE, align 4
  %v4781 = add i32 4231408, %v4780
  %v4782 = load ptr, ptr %MEMORY, align 4
  %v4783 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4782, ptr %state, ptr %EAX, i32 %v4781)
  store ptr %v4783, ptr %MEMORY, align 4
  store i32 %v4779, ptr %PC, align 4
  %v4784 = add i32 %v4779, 3
  store i32 %v4784, ptr %NEXT_PC, align 4
  %v4785 = load i32, ptr %EAX, align 4
  %v4786 = load ptr, ptr %MEMORY, align 4
  %v4787 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4786, ptr %state, ptr %EAX, i32 %v4785, i32 4)
  store ptr %v4787, ptr %MEMORY, align 4
  store i32 %v4784, ptr %PC, align 4
  %v4788 = add i32 %v4784, 5
  store i32 %v4788, ptr %NEXT_PC, align 4
  %v4789 = load i32, ptr %DSBASE, align 4
  %v4790 = add i32 4231408, %v4789
  %v4791 = load i32, ptr %EAX, align 4
  %v4792 = load ptr, ptr %MEMORY, align 4
  %v4793 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4792, ptr %state, i32 %v4790, i32 %v4791)
  store ptr %v4793, ptr %MEMORY, align 4
  br label %bb_4203910

bb_4203910:                                       ; preds = %bb_4203888, %bb_4203879
  %v4794 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4794, ptr %PC, align 4
  %v4795 = add i32 %v4794, 5
  store i32 %v4795, ptr %NEXT_PC, align 4
  %v4796 = load i32, ptr %DSBASE, align 4
  %v4797 = add i32 4231408, %v4796
  %v4798 = load ptr, ptr %MEMORY, align 4
  %v4799 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4798, ptr %state, ptr %EAX, i32 %v4797)
  store ptr %v4799, ptr %MEMORY, align 4
  store i32 %v4795, ptr %PC, align 4
  %v4800 = add i32 %v4795, 2
  store i32 %v4800, ptr %NEXT_PC, align 4
  %v4801 = load i32, ptr %EAX, align 4
  %v4802 = load i32, ptr %DSBASE, align 4
  %v4803 = add i32 %v4801, %v4802
  %v4804 = load ptr, ptr %MEMORY, align 4
  %v4805 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4804, ptr %state, ptr %EAX, i32 %v4803)
  store ptr %v4805, ptr %MEMORY, align 4
  store i32 %v4800, ptr %PC, align 4
  %v4806 = add i32 %v4800, 2
  store i32 %v4806, ptr %NEXT_PC, align 4
  %v4807 = load i32, ptr %EAX, align 4
  %v4808 = load i32, ptr %EAX, align 4
  %v4809 = load ptr, ptr %MEMORY, align 4
  %v4810 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4809, ptr %state, i32 %v4807, i32 %v4808)
  store ptr %v4810, ptr %MEMORY, align 4
  store i32 %v4806, ptr %PC, align 4
  %v4811 = add i32 %v4806, 2
  store i32 %v4811, ptr %NEXT_PC, align 4
  %v4812 = sub i32 %v4811, 33
  %v4813 = load ptr, ptr %MEMORY, align 4
  %v4814 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4813, ptr %state, ptr %BRANCH_TAKEN, i32 %v4812, i32 %v4811, ptr %NEXT_PC)
  store ptr %v4814, ptr %MEMORY, align 4
  br i1 true, label %bb_4203888, label %bb_4203921

bb_4203921:                                       ; preds = %bb_4203910
  store i32 %v4811, ptr %PC, align 4
  %v4815 = add i32 %v4811, 1
  store i32 %v4815, ptr %NEXT_PC, align 4
  %v4816 = load ptr, ptr %MEMORY, align 4
  %v4817 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v4816, ptr %state)
  store ptr %v4817, ptr %MEMORY, align 4
  store i32 %v4815, ptr %PC, align 4
  %v4818 = add i32 %v4815, 1
  store i32 %v4818, ptr %NEXT_PC, align 4
  %v4819 = load ptr, ptr %MEMORY, align 4
  %v4820 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v4819, ptr %state, ptr %NEXT_PC)
  store ptr %v4820, ptr %MEMORY, align 4
  ret ptr %memory

bb_4203923:                                       ; No predecessors!
  %v4821 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4821, ptr %PC, align 4
  %v4822 = add i32 %v4821, 1
  store i32 %v4822, ptr %NEXT_PC, align 4
  %v4823 = load i32, ptr %EBP, align 4
  %v4824 = load ptr, ptr %MEMORY, align 4
  %v4825 = call ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr %v4824, ptr %state, i32 %v4823)
  store ptr %v4825, ptr %MEMORY, align 4
  store i32 %v4822, ptr %PC, align 4
  %v4826 = add i32 %v4822, 2
  store i32 %v4826, ptr %NEXT_PC, align 4
  %v4827 = load i32, ptr %ESP, align 4
  %v4828 = load ptr, ptr %MEMORY, align 4
  %v4829 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4828, ptr %state, ptr %EBP, i32 %v4827)
  store ptr %v4829, ptr %MEMORY, align 4
  store i32 %v4826, ptr %PC, align 4
  %v4830 = add i32 %v4826, 3
  store i32 %v4830, ptr %NEXT_PC, align 4
  %v4831 = load i32, ptr %ESP, align 4
  %v4832 = load ptr, ptr %MEMORY, align 4
  %v4833 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4832, ptr %state, ptr %ESP, i32 %v4831, i32 40)
  store ptr %v4833, ptr %MEMORY, align 4
  store i32 %v4830, ptr %PC, align 4
  %v4834 = add i32 %v4830, 5
  store i32 %v4834, ptr %NEXT_PC, align 4
  %v4835 = load i32, ptr %DSBASE, align 4
  %v4836 = add i32 4229344, %v4835
  %v4837 = load ptr, ptr %MEMORY, align 4
  %v4838 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4837, ptr %state, ptr %EAX, i32 %v4836)
  store ptr %v4838, ptr %MEMORY, align 4
  store i32 %v4834, ptr %PC, align 4
  %v4839 = add i32 %v4834, 3
  store i32 %v4839, ptr %NEXT_PC, align 4
  %v4840 = load i32, ptr %EBP, align 4
  %v4841 = load i32, ptr %SSBASE, align 4
  %v4842 = sub i32 %v4840, 12
  %v4843 = add i32 %v4842, %v4841
  %v4844 = load i32, ptr %EAX, align 4
  %v4845 = load ptr, ptr %MEMORY, align 4
  %v4846 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4845, ptr %state, i32 %v4843, i32 %v4844)
  store ptr %v4846, ptr %MEMORY, align 4
  store i32 %v4839, ptr %PC, align 4
  %v4847 = add i32 %v4839, 4
  store i32 %v4847, ptr %NEXT_PC, align 4
  %v4848 = load i32, ptr %EBP, align 4
  %v4849 = load i32, ptr %SSBASE, align 4
  %v4850 = sub i32 %v4848, 12
  %v4851 = add i32 %v4850, %v4849
  %v4852 = load ptr, ptr %MEMORY, align 4
  %v4853 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4852, ptr %state, i32 %v4851, i32 -1)
  store ptr %v4853, ptr %MEMORY, align 4
  store i32 %v4847, ptr %PC, align 4
  %v4854 = add i32 %v4847, 2
  store i32 %v4854, ptr %NEXT_PC, align 4
  %v4855 = add i32 %v4854, 30
  %v4856 = load ptr, ptr %MEMORY, align 4
  %v4857 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4856, ptr %state, ptr %BRANCH_TAKEN, i32 %v4855, i32 %v4854, ptr %NEXT_PC)
  store ptr %v4857, ptr %MEMORY, align 4
  br i1 true, label %bb_4203973, label %bb_4203943

bb_4203943:                                       ; preds = %bb_4203923
  store i32 %v4854, ptr %PC, align 4
  %v4858 = add i32 %v4854, 7
  store i32 %v4858, ptr %NEXT_PC, align 4
  %v4859 = load i32, ptr %EBP, align 4
  %v4860 = load i32, ptr %SSBASE, align 4
  %v4861 = sub i32 %v4859, 12
  %v4862 = add i32 %v4861, %v4860
  %v4863 = load ptr, ptr %MEMORY, align 4
  %v4864 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4863, ptr %state, i32 %v4862, i32 0)
  store ptr %v4864, ptr %MEMORY, align 4
  store i32 %v4858, ptr %PC, align 4
  %v4865 = add i32 %v4858, 2
  store i32 %v4865, ptr %NEXT_PC, align 4
  %v4866 = add i32 %v4865, 4
  %v4867 = load ptr, ptr %MEMORY, align 4
  %v4868 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4867, ptr %state, i32 %v4866, ptr %NEXT_PC)
  store ptr %v4868, ptr %MEMORY, align 4
  br label %bb_4203956

bb_4203952:                                       ; preds = %bb_4203956
  store i32 %v4906, ptr %PC, align 4
  %v4869 = add i32 %v4906, 4
  store i32 %v4869, ptr %NEXT_PC, align 4
  %v4870 = load i32, ptr %EBP, align 4
  %v4871 = load i32, ptr %SSBASE, align 4
  %v4872 = sub i32 %v4870, 12
  %v4873 = add i32 %v4872, %v4871
  %v4874 = load i32, ptr %EBP, align 4
  %v4875 = load i32, ptr %SSBASE, align 4
  %v4876 = sub i32 %v4874, 12
  %v4877 = add i32 %v4876, %v4875
  %v4878 = load ptr, ptr %MEMORY, align 4
  %v4879 = call ptr @_ZN12_GLOBAL__N_13ADDI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4878, ptr %state, i32 %v4873, i32 %v4877, i32 1)
  store ptr %v4879, ptr %MEMORY, align 4
  br label %bb_4203956

bb_4203956:                                       ; preds = %bb_4203952, %bb_4203943
  %v4880 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4880, ptr %PC, align 4
  %v4881 = add i32 %v4880, 3
  store i32 %v4881, ptr %NEXT_PC, align 4
  %v4882 = load i32, ptr %EBP, align 4
  %v4883 = load i32, ptr %SSBASE, align 4
  %v4884 = sub i32 %v4882, 12
  %v4885 = add i32 %v4884, %v4883
  %v4886 = load ptr, ptr %MEMORY, align 4
  %v4887 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4886, ptr %state, ptr %EAX, i32 %v4885)
  store ptr %v4887, ptr %MEMORY, align 4
  store i32 %v4881, ptr %PC, align 4
  %v4888 = add i32 %v4881, 3
  store i32 %v4888, ptr %NEXT_PC, align 4
  %v4889 = load i32, ptr %EAX, align 4
  %v4890 = load ptr, ptr %MEMORY, align 4
  %v4891 = call ptr @_ZN12_GLOBAL__N_13ADDI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4890, ptr %state, ptr %EAX, i32 %v4889, i32 1)
  store ptr %v4891, ptr %MEMORY, align 4
  store i32 %v4888, ptr %PC, align 4
  %v4892 = add i32 %v4888, 7
  store i32 %v4892, ptr %NEXT_PC, align 4
  %v4893 = load i32, ptr %EAX, align 4
  %v4894 = load i32, ptr %DSBASE, align 4
  %v4895 = mul i32 %v4893, 4
  %v4896 = add i32 0, %v4895
  %v4897 = add i32 %v4896, 4229344
  %v4898 = add i32 %v4897, %v4894
  %v4899 = load ptr, ptr %MEMORY, align 4
  %v4900 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4899, ptr %state, ptr %EAX, i32 %v4898)
  store ptr %v4900, ptr %MEMORY, align 4
  store i32 %v4892, ptr %PC, align 4
  %v4901 = add i32 %v4892, 2
  store i32 %v4901, ptr %NEXT_PC, align 4
  %v4902 = load i32, ptr %EAX, align 4
  %v4903 = load i32, ptr %EAX, align 4
  %v4904 = load ptr, ptr %MEMORY, align 4
  %v4905 = call ptr @_ZN12_GLOBAL__N_14TESTI2RnIjLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v4904, ptr %state, i32 %v4902, i32 %v4903)
  store ptr %v4905, ptr %MEMORY, align 4
  store i32 %v4901, ptr %PC, align 4
  %v4906 = add i32 %v4901, 2
  store i32 %v4906, ptr %NEXT_PC, align 4
  %v4907 = sub i32 %v4906, 21
  %v4908 = load ptr, ptr %MEMORY, align 4
  %v4909 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4908, ptr %state, ptr %BRANCH_TAKEN, i32 %v4907, i32 %v4906, ptr %NEXT_PC)
  store ptr %v4909, ptr %MEMORY, align 4
  br i1 true, label %bb_4203952, label %bb_4203973

bb_4203973:                                       ; preds = %bb_4203956, %bb_4203923
  %v4910 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4910, ptr %PC, align 4
  %v4911 = add i32 %v4910, 3
  store i32 %v4911, ptr %NEXT_PC, align 4
  %v4912 = load i32, ptr %EBP, align 4
  %v4913 = load i32, ptr %SSBASE, align 4
  %v4914 = sub i32 %v4912, 12
  %v4915 = add i32 %v4914, %v4913
  %v4916 = load ptr, ptr %MEMORY, align 4
  %v4917 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4916, ptr %state, ptr %EAX, i32 %v4915)
  store ptr %v4917, ptr %MEMORY, align 4
  store i32 %v4911, ptr %PC, align 4
  %v4918 = add i32 %v4911, 3
  store i32 %v4918, ptr %NEXT_PC, align 4
  %v4919 = load i32, ptr %EBP, align 4
  %v4920 = load i32, ptr %SSBASE, align 4
  %v4921 = sub i32 %v4919, 16
  %v4922 = add i32 %v4921, %v4920
  %v4923 = load i32, ptr %EAX, align 4
  %v4924 = load ptr, ptr %MEMORY, align 4
  %v4925 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v4924, ptr %state, i32 %v4922, i32 %v4923)
  store ptr %v4925, ptr %MEMORY, align 4
  store i32 %v4918, ptr %PC, align 4
  %v4926 = add i32 %v4918, 2
  store i32 %v4926, ptr %NEXT_PC, align 4
  %v4927 = add i32 %v4926, 16
  %v4928 = load ptr, ptr %MEMORY, align 4
  %v4929 = call ptr @_ZN12_GLOBAL__N_13JMPI2InIjEEEP6MemoryS4_R5StateT_3RnWIjE(ptr %v4928, ptr %state, i32 %v4927, ptr %NEXT_PC)
  store ptr %v4929, ptr %MEMORY, align 4
  br label %bb_4203997

bb_4203981:                                       ; preds = %bb_4203997
  store i32 %v4969, ptr %PC, align 4
  %v4930 = add i32 %v4969, 3
  store i32 %v4930, ptr %NEXT_PC, align 4
  %v4931 = load i32, ptr %EBP, align 4
  %v4932 = load i32, ptr %SSBASE, align 4
  %v4933 = sub i32 %v4931, 16
  %v4934 = add i32 %v4933, %v4932
  %v4935 = load ptr, ptr %MEMORY, align 4
  %v4936 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4935, ptr %state, ptr %EAX, i32 %v4934)
  store ptr %v4936, ptr %MEMORY, align 4
  store i32 %v4930, ptr %PC, align 4
  %v4937 = add i32 %v4930, 7
  store i32 %v4937, ptr %NEXT_PC, align 4
  %v4938 = load i32, ptr %EAX, align 4
  %v4939 = load i32, ptr %DSBASE, align 4
  %v4940 = mul i32 %v4938, 4
  %v4941 = add i32 0, %v4940
  %v4942 = add i32 %v4941, 4229344
  %v4943 = add i32 %v4942, %v4939
  %v4944 = load ptr, ptr %MEMORY, align 4
  %v4945 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4944, ptr %state, ptr %EAX, i32 %v4943)
  store ptr %v4945, ptr %MEMORY, align 4
  store i32 %v4937, ptr %PC, align 4
  %v4946 = add i32 %v4937, 2
  store i32 %v4946, ptr %NEXT_PC, align 4
  %v4947 = load i32, ptr %EAX, align 4
  %v4948 = load ptr, ptr %MEMORY, align 4
  %v4949 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v4948, ptr %state, i32 %v4947, ptr %NEXT_PC, i32 %v4946, ptr %RETURN_PC)
  store ptr %v4949, ptr %MEMORY, align 4
  store i32 %v4946, ptr %PC, align 4
  %v4950 = add i32 %v4946, 4
  store i32 %v4950, ptr %NEXT_PC, align 4
  %v4951 = load i32, ptr %EBP, align 4
  %v4952 = load i32, ptr %SSBASE, align 4
  %v4953 = sub i32 %v4951, 16
  %v4954 = add i32 %v4953, %v4952
  %v4955 = load i32, ptr %EBP, align 4
  %v4956 = load i32, ptr %SSBASE, align 4
  %v4957 = sub i32 %v4955, 16
  %v4958 = add i32 %v4957, %v4956
  %v4959 = load ptr, ptr %MEMORY, align 4
  %v4960 = call ptr @_ZN12_GLOBAL__N_13SUBI3MnWIjE2MnIjE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v4959, ptr %state, i32 %v4954, i32 %v4958, i32 1)
  store ptr %v4960, ptr %MEMORY, align 4
  br label %bb_4203997

bb_4203997:                                       ; preds = %bb_4203981, %bb_4203973
  %v4961 = load i32, ptr %NEXT_PC, align 4
  store i32 %v4961, ptr %PC, align 4
  %v4962 = add i32 %v4961, 4
  store i32 %v4962, ptr %NEXT_PC, align 4
  %v4963 = load i32, ptr %EBP, align 4
  %v4964 = load i32, ptr %SSBASE, align 4
  %v4965 = sub i32 %v4963, 16
  %v4966 = add i32 %v4965, %v4964
  %v4967 = load ptr, ptr %MEMORY, align 4
  %v4968 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4967, ptr %state, i32 %v4966, i32 0)
  store ptr %v4968, ptr %MEMORY, align 4
  store i32 %v4962, ptr %PC, align 4
  %v4969 = add i32 %v4962, 2
  store i32 %v4969, ptr %NEXT_PC, align 4
  %v4970 = sub i32 %v4969, 22
  %v4971 = load ptr, ptr %MEMORY, align 4
  %v4972 = call ptr @_ZN12_GLOBAL__N_13JNZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v4971, ptr %state, ptr %BRANCH_TAKEN, i32 %v4970, i32 %v4969, ptr %NEXT_PC)
  store ptr %v4972, ptr %MEMORY, align 4
  br i1 true, label %bb_4203981, label %bb_4204003

bb_4204003:                                       ; preds = %bb_4203997
  store i32 %v4969, ptr %PC, align 4
  %v4973 = add i32 %v4969, 7
  store i32 %v4973, ptr %NEXT_PC, align 4
  %v4974 = load i32, ptr %ESP, align 4
  %v4975 = load i32, ptr %SSBASE, align 4
  %v4976 = add i32 %v4974, %v4975
  %v4977 = load ptr, ptr %MEMORY, align 4
  %v4978 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v4977, ptr %state, i32 %v4976, i32 4203880)
  store ptr %v4978, ptr %MEMORY, align 4
  ret ptr %memory
}

attributes #0 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #8 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

!llvm.ident = !{!0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3, !4, !5}

!0 = !{!"clang version 18.1.8"}
!1 = !{i32 1, !"NumRegisterParameters", i32 0}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"frame-pointer", i32 2}
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{!"base.helper.semantics"}
!7 = !{[3 x i8] c"AX\00"}
!8 = !{[3 x i8] c"AL\00"}
!9 = !{[4 x i8] c"ECX\00"}
!10 = !{[4 x i8] c"EBX\00"}
!11 = !{[4 x i8] c"ST2\00"}
!12 = !{[4 x i8] c"ST0\00"}
!13 = !{[4 x i8] c"EDX\00"}
!14 = !{[7 x i8] c"DSBASE\00"}
!15 = !{[4 x i8] c"EAX\00"}
!16 = !{[7 x i8] c"SSBASE\00"}
!17 = !{[4 x i8] c"ESP\00"}
!18 = !{[4 x i8] c"EBP\00"}
!19 = !{[3 x i8] c"PC\00"}
