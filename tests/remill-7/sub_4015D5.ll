; ============================================================
; HexCore Remill IR Lift (EXPERIMENTAL)
; File: debugme.exe
; Address: 0x004015d5
; Size: 4500 bytes
; Architecture: x86
; Generated: 2026-03-12T19:05:35.277Z
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
declare !remill.function.type !6 dso_local i32 @__remill_read_memory_32(ptr noundef, i32 noundef) #1

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local ptr @__remill_write_memory_32(ptr noundef, i32 noundef, i32 noundef) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), i32, i32) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i8 @__remill_undefined_8() #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32, ptr nocapture writeonly, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504), ptr nocapture writeonly) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local zeroext i1 @__remill_compare_eq(i1 noundef zeroext) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr noundef readnone returned, ptr nocapture noundef nonnull readonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32, ptr nocapture writeonly) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef, ptr nocapture nonnull readnone align 16, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #3

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr noundef returned, ptr nocapture nonnull readnone align 16, ptr nocapture writeonly, i32) #0

; Function Attrs: noduplicate noinline nounwind optnone
declare !remill.function.type !6 dso_local i64 @__remill_read_memory_64(ptr noundef, i32 noundef) #1

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr noundef readnone returned, ptr nocapture noundef nonnull writeonly align 16 dereferenceable(3504), ptr nocapture writeonly, i32, i32) #0

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr noundef returned, ptr nocapture noundef nonnull align 16 dereferenceable(3504)) #0

; Function Attrs: alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none)
declare dso_local noundef ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr noundef readnone returned, ptr nocapture nonnull readnone align 16) #4

; Function Attrs: alwaysinline mustprogress nounwind
declare dso_local noundef ptr @_ZN12_GLOBAL__N_14PUSHI2InIjEEEP6MemoryS4_R5StateT_(ptr noundef, ptr nocapture noundef nonnull align 16 dereferenceable(3504), i32) #0

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_es(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_ss(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_ds(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_fs(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_segment_gs(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_debug_reg(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_0(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_1(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_2(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_3(ptr noundef) #5

declare !remill.function.type !6 dso_local ptr @__remill_x86_set_control_reg_4(ptr noundef) #5

; Function Attrs: mustprogress noduplicate noinline nounwind optnone
declare dso_local ptr @__remill_sync_hyper_call(ptr noundef nonnull align 16 dereferenceable(3504), ptr noundef, i32 noundef) #6

define ptr @lifted_4199893(ptr noalias %state, i32 %program_counter, ptr noalias %memory) {
bb_0:
  %v1 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 3, i32 0, i32 0
  %BH = getelementptr i8, ptr %v1, i32 1, !remill_register !7
  %v2 = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0
  %CH = getelementptr i8, ptr %v2, i32 1, !remill_register !8
  %ECX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 5, i32 0, i32 0, !remill_register !9
  %EDX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 7, i32 0, i32 0, !remill_register !10
  %DSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 9, i32 0, i32 0, !remill_register !11
  %EAX = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 1, i32 0, i32 0, !remill_register !12
  %SSBASE = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 5, i32 1, i32 0, i32 0, !remill_register !13
  %ESP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 13, i32 0, i32 0, !remill_register !14
  %EBP = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 15, i32 0, i32 0, !remill_register !15
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
  %PC = getelementptr inbounds %struct.State, ptr %state, i32 0, i32 0, i32 6, i32 33, i32 0, i32 0, !remill_register !16
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
  %v11 = add i32 %v7, 3
  store i32 %v11, ptr %NEXT_PC, align 4
  %v12 = load i32, ptr %ESP, align 4
  %v13 = load ptr, ptr %MEMORY, align 4
  %v14 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v13, ptr %state, ptr %ESP, i32 %v12, i32 40)
  store ptr %v14, ptr %MEMORY, align 4
  store i32 %v11, ptr %PC, align 4
  %v15 = add i32 %v11, 7
  store i32 %v15, ptr %NEXT_PC, align 4
  %v16 = load i32, ptr %EBP, align 4
  %v17 = load i32, ptr %SSBASE, align 4
  %v18 = sub i32 %v16, 12
  %v19 = add i32 %v18, %v17
  %v20 = load ptr, ptr %MEMORY, align 4
  %v21 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v20, ptr %state, i32 %v19, i32 0)
  store ptr %v21, ptr %MEMORY, align 4
  store i32 %v15, ptr %PC, align 4
  %v22 = add i32 %v15, 5
  store i32 %v22, ptr %NEXT_PC, align 4
  %v23 = add i32 %v22, 5139
  %v24 = load ptr, ptr %MEMORY, align 4
  %v25 = call ptr @_ZN12_GLOBAL__N_14CALLI2InIjEEEP6MemoryS4_R5StateT_3RnWIjES2_S9_(ptr %v24, ptr %state, i64 4205050, ptr %NEXT_PC, i32 %v22, ptr %RETURN_PC)
  store ptr %v25, ptr %MEMORY, align 4
  store i32 %v22, ptr %PC, align 4
  %v26 = add i32 %v22, 8
  store i32 %v26, ptr %NEXT_PC, align 4
  %v27 = load i32, ptr %ESP, align 4
  %v28 = load i32, ptr %SSBASE, align 4
  %v29 = add i32 %v27, 4
  %v30 = add i32 %v29, %v28
  %v31 = load ptr, ptr %MEMORY, align 4
  %v32 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v31, ptr %state, i32 %v30, i32 4235264)
  store ptr %v32, ptr %MEMORY, align 4
  store i32 %v26, ptr %PC, align 4
  %v33 = add i32 %v26, 3
  store i32 %v33, ptr %NEXT_PC, align 4
  %v34 = load i32, ptr %ESP, align 4
  %v35 = load i32, ptr %SSBASE, align 4
  %v36 = add i32 %v34, %v35
  %v37 = load i32, ptr %EAX, align 4
  %v38 = load ptr, ptr %MEMORY, align 4
  %v39 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v38, ptr %state, i32 %v36, i32 %v37)
  store ptr %v39, ptr %MEMORY, align 4
  store i32 %v33, ptr %PC, align 4
  %v40 = add i32 %v33, 5
  store i32 %v40, ptr %NEXT_PC, align 4
  %v41 = load i32, ptr %DSBASE, align 4
  %v42 = add i32 4243816, %v41
  %v43 = load ptr, ptr %MEMORY, align 4
  %v44 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v43, ptr %state, ptr %EAX, i32 %v42)
  store ptr %v44, ptr %MEMORY, align 4
  store i32 %v40, ptr %PC, align 4
  %v45 = add i32 %v40, 2
  store i32 %v45, ptr %NEXT_PC, align 4
  %v46 = load i32, ptr %EAX, align 4
  %v47 = load ptr, ptr %MEMORY, align 4
  %v48 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v47, ptr %state, i32 %v46, ptr %NEXT_PC, i32 %v45, ptr %RETURN_PC)
  store ptr %v48, ptr %MEMORY, align 4
  store i32 %v45, ptr %PC, align 4
  %v49 = add i32 %v45, 3
  store i32 %v49, ptr %NEXT_PC, align 4
  %v50 = load i32, ptr %ESP, align 4
  %v51 = load ptr, ptr %MEMORY, align 4
  %v52 = call ptr @_ZN12_GLOBAL__N_13SUBI3RnWIjE2RnIjLb1EE2InIjEEEP6MemoryS8_R5StateT_T0_T1_(ptr %v51, ptr %state, ptr %ESP, i32 %v50, i32 8)
  store ptr %v52, ptr %MEMORY, align 4
  store i32 %v49, ptr %PC, align 4
  %v53 = add i32 %v49, 3
  store i32 %v53, ptr %NEXT_PC, align 4
  %v54 = load i32, ptr %EBP, align 4
  %v55 = load i32, ptr %SSBASE, align 4
  %v56 = sub i32 %v54, 12
  %v57 = add i32 %v56, %v55
  %v58 = load i32, ptr %EAX, align 4
  %v59 = load ptr, ptr %MEMORY, align 4
  %v60 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2RnIjLb1EEEEP6MemoryS6_R5StateT_T0_(ptr %v59, ptr %state, i32 %v57, i32 %v58)
  store ptr %v60, ptr %MEMORY, align 4
  store i32 %v53, ptr %PC, align 4
  %v61 = add i32 %v53, 4
  store i32 %v61, ptr %NEXT_PC, align 4
  %v62 = load i32, ptr %EBP, align 4
  %v63 = load i32, ptr %SSBASE, align 4
  %v64 = sub i32 %v62, 12
  %v65 = add i32 %v64, %v63
  %v66 = load ptr, ptr %MEMORY, align 4
  %v67 = call ptr @_ZN12_GLOBAL__N_13CMPI2MnIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v66, ptr %state, i32 %v65, i32 0)
  store ptr %v67, ptr %MEMORY, align 4
  store i32 %v61, ptr %PC, align 4
  %v68 = add i32 %v61, 2
  store i32 %v68, ptr %NEXT_PC, align 4
  %v69 = add i32 %v68, 12
  %v70 = load ptr, ptr %MEMORY, align 4
  %v71 = call ptr @_ZN12_GLOBAL__N_12JZEP6MemoryR5State3RnWIhE2InIjES7_S4_IjE(ptr %v70, ptr %state, ptr %BRANCH_TAKEN, i32 %v69, i32 %v68, ptr %NEXT_PC)
  store ptr %v71, ptr %MEMORY, align 4
  br i1 true, label %bb_4199953, label %bb_4199941

bb_4199941:                                       ; preds = %bb_0
  store i32 %v68, ptr %PC, align 4
  %v72 = add i32 %v68, 7
  store i32 %v72, ptr %NEXT_PC, align 4
  %v73 = load i32, ptr %ESP, align 4
  %v74 = load i32, ptr %SSBASE, align 4
  %v75 = add i32 %v73, %v74
  %v76 = load ptr, ptr %MEMORY, align 4
  %v77 = call ptr @_ZN12_GLOBAL__N_13MOVI3MnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v76, ptr %state, i32 %v75, i32 4199888)
  store ptr %v77, ptr %MEMORY, align 4
  store i32 %v72, ptr %PC, align 4
  %v78 = add i32 %v72, 3
  store i32 %v78, ptr %NEXT_PC, align 4
  %v79 = load i32, ptr %EBP, align 4
  %v80 = load i32, ptr %SSBASE, align 4
  %v81 = sub i32 %v79, 12
  %v82 = add i32 %v81, %v80
  %v83 = load ptr, ptr %MEMORY, align 4
  %v84 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2MnIjEEEP6MemoryS6_R5StateT_T0_(ptr %v83, ptr %state, ptr %EAX, i32 %v82)
  store ptr %v84, ptr %MEMORY, align 4
  store i32 %v78, ptr %PC, align 4
  %v85 = add i32 %v78, 2
  store i32 %v85, ptr %NEXT_PC, align 4
  %v86 = load i32, ptr %EAX, align 4
  %v87 = load ptr, ptr %MEMORY, align 4
  %v88 = call ptr @_ZN12_GLOBAL__N_14CALLI2RnIjLb1EEEEP6MemoryS4_R5StateT_3RnWIjE2InIjES9_(ptr %v87, ptr %state, i32 %v86, ptr %NEXT_PC, i32 %v85, ptr %RETURN_PC)
  store ptr %v88, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199953:                                       ; preds = %bb_0
  store i32 %v68, ptr %PC, align 4
  %v89 = add i32 %v68, 1
  store i32 %v89, ptr %NEXT_PC, align 4
  %v90 = load ptr, ptr %MEMORY, align 4
  %v91 = call ptr @_ZN12_GLOBAL__N_110LEAVE_FULLI2InIjEEEP6MemoryS4_R5State(ptr %v90, ptr %state)
  store ptr %v91, ptr %MEMORY, align 4
  store i32 %v89, ptr %PC, align 4
  %v92 = add i32 %v89, 1
  store i32 %v92, ptr %NEXT_PC, align 4
  %v93 = load ptr, ptr %MEMORY, align 4
  %v94 = call ptr @_ZN12_GLOBAL__N_13RETEP6MemoryR5State3RnWIjE(ptr %v93, ptr %state, ptr %NEXT_PC)
  store ptr %v94, ptr %MEMORY, align 4
  ret ptr %memory

bb_4199955:                                       ; No predecessors!
  %v95 = load i32, ptr %NEXT_PC, align 4
  store i32 %v95, ptr %PC, align 4
  %v96 = add i32 %v95, 1
  store i32 %v96, ptr %NEXT_PC, align 4
  %v97 = load ptr, ptr %MEMORY, align 4
  %v98 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v97, ptr %state)
  store ptr %v98, ptr %MEMORY, align 4
  store i32 %v96, ptr %PC, align 4
  %v99 = add i32 %v96, 2
  store i32 %v99, ptr %NEXT_PC, align 4
  %v100 = load ptr, ptr %MEMORY, align 4
  %v101 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v100, ptr %state)
  store ptr %v101, ptr %MEMORY, align 4
  store i32 %v99, ptr %PC, align 4
  %v102 = add i32 %v99, 2
  store i32 %v102, ptr %NEXT_PC, align 4
  %v103 = load ptr, ptr %MEMORY, align 4
  %v104 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v103, ptr %state)
  store ptr %v104, ptr %MEMORY, align 4
  store i32 %v102, ptr %PC, align 4
  %v105 = add i32 %v102, 2
  store i32 %v105, ptr %NEXT_PC, align 4
  %v106 = load ptr, ptr %MEMORY, align 4
  %v107 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v106, ptr %state)
  store ptr %v107, ptr %MEMORY, align 4
  store i32 %v105, ptr %PC, align 4
  %v108 = add i32 %v105, 2
  store i32 %v108, ptr %NEXT_PC, align 4
  %v109 = load ptr, ptr %MEMORY, align 4
  %v110 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v109, ptr %state)
  store ptr %v110, ptr %MEMORY, align 4
  store i32 %v108, ptr %PC, align 4
  %v111 = add i32 %v108, 2
  store i32 %v111, ptr %NEXT_PC, align 4
  %v112 = load ptr, ptr %MEMORY, align 4
  %v113 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v112, ptr %state)
  store ptr %v113, ptr %MEMORY, align 4
  store i32 %v111, ptr %PC, align 4
  %v114 = add i32 %v111, 2
  store i32 %v114, ptr %NEXT_PC, align 4
  %v115 = load ptr, ptr %MEMORY, align 4
  %v116 = call ptr @_ZN12_GLOBAL__N_18NOP_IMPLIJEEEP6MemoryS2_R5StateDpT_(ptr %v115, ptr %state)
  store ptr %v116, ptr %MEMORY, align 4
  store i32 %v114, ptr %PC, align 4
  %v117 = add i32 %v114, 2
  store i32 %v117, ptr %NEXT_PC, align 4
  %v118 = load i32, ptr %EBP, align 4
  %v119 = load i32, ptr %EDX, align 4
  %v120 = load ptr, ptr %MEMORY, align 4
  %v121 = call ptr @_ZN12_GLOBAL__N_12ORI3RnWIjE2RnIjLb1EES4_EEP6MemoryS6_R5StateT_T0_T1_(ptr %v120, ptr %state, ptr %EBP, i32 %v118, i32 %v119)
  store ptr %v121, ptr %MEMORY, align 4
  store i32 %v117, ptr %PC, align 4
  %v122 = add i32 %v117, 5
  store i32 %v122, ptr %NEXT_PC, align 4
  %v123 = load ptr, ptr %MEMORY, align 4
  %v124 = call ptr @_ZN12_GLOBAL__N_13MOVI3RnWIjE2InIjEEEP6MemoryS6_R5StateT_T0_(ptr %v123, ptr %state, ptr %ECX, i32 -1905419155)
  store ptr %v124, ptr %MEMORY, align 4
  store i32 %v122, ptr %PC, align 4
  %v125 = add i32 %v122, 2
  store i32 %v125, ptr %NEXT_PC, align 4
  %v126 = load i8, ptr %CH, align 1
  %v127 = zext i8 %v126 to i32
  %v128 = load i8, ptr %BH, align 1
  %v129 = zext i8 %v128 to i32
  %v130 = load ptr, ptr %MEMORY, align 4
  %v131 = call ptr @_ZN12_GLOBAL__N_13CMPI2RnIhLb1EES2_EEP6MemoryS4_R5StateT_T0_(ptr %v130, ptr %state, i32 %v127, i32 %v129)
  store ptr %v131, ptr %MEMORY, align 4
  store i32 %v125, ptr %PC, align 4
  %v132 = add i32 %v125, 1
  store i32 %v132, ptr %NEXT_PC, align 4
  %v133 = load ptr, ptr %MEMORY, align 4
  %v134 = call ptr @_ZN12_GLOBAL__N_117HandleUnsupportedEP6MemoryR5State(ptr %v133, ptr %state)
  store ptr %v134, ptr %MEMORY, align 4
  ret ptr %memory
}

attributes #0 = { alwaysinline mustprogress nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #1 = { noduplicate noinline nounwind optnone "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #4 = { alwaysinline mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #5 = { "frame-pointer"="all" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }
attributes #6 = { mustprogress noduplicate noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "tune-cpu"="generic" }

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
!10 = !{[4 x i8] c"EDX\00"}
!11 = !{[7 x i8] c"DSBASE\00"}
!12 = !{[4 x i8] c"EAX\00"}
!13 = !{[7 x i8] c"SSBASE\00"}
!14 = !{[4 x i8] c"ESP\00"}
!15 = !{[4 x i8] c"EBP\00"}
!16 = !{[3 x i8] c"PC\00"}
