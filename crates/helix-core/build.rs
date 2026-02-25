//! Build script for helix-core.
//!
//! Links against the pre-built C++ engine (helix_engine.lib) and all
//! required LLVM/MLIR static libraries for the MLIR decompilation pipeline.

use std::env;
use std::path::PathBuf;

fn main() {
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let project_root = manifest_dir.parent().unwrap().parent().unwrap();

    // ─── Paths ─────────────────────────────────────────────────────────
    let engine_build_dir = project_root.join("engine").join("build");
    let llvm_build = PathBuf::from(r"C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir");
    let llvm_lib_dir = llvm_build.join("lib");

    // ─── Link the Helix engine static library ──────────────────────────
    println!("cargo:rustc-link-search=native={}", engine_build_dir.display());
    println!("cargo:rustc-link-lib=static=helix_engine");

    // ─── Link LLVM static libraries ────────────────────────────────────
    // These match the components from CMakeLists.txt:
    //   core, support, irreader, analysis, passes, target,
    //   x86codegen/asmparser/desc/info, aarch64codegen/asmparser/desc/info
    println!("cargo:rustc-link-search=native={}", llvm_lib_dir.display());

    // Core LLVM libraries (order matters for static linking — dependents first)
    let llvm_libs = [
        // High-level
        "LLVMPasses",
        "LLVMipo",
        "LLVMVectorize",
        "LLVMCoroutines",
        "LLVMLinker",
        "LLVMIRReader",
        "LLVMAsmParser",
        "LLVMIRPrinter",
        // X86 target
        "LLVMX86CodeGen",
        "LLVMX86AsmParser",
        "LLVMX86Desc",
        "LLVMX86Info",
        // AArch64 target
        "LLVMAArch64CodeGen",
        "LLVMAArch64AsmParser",
        "LLVMAArch64Desc",
        "LLVMAArch64Info",
        "LLVMAArch64Utils",
        // Code generation
        "LLVMCodeGen",
        "LLVMGlobalISel",
        "LLVMSelectionDAG",
        "LLVMAsmPrinter",
        "LLVMCFGuard",
        "LLVMCodeGenTypes",
        // Mid-level
        "LLVMScalarOpts",
        "LLVMAggressiveInstCombine",
        "LLVMInstCombine",
        "LLVMTransformUtils",
        "LLVMAnalysis",
        "LLVMTarget",
        "LLVMObjCARCOpts",
        "LLVMInstrumentation",
        // Low-level
        "LLVMBitWriter",
        "LLVMBitReader",
        "LLVMObject",
        "LLVMTextAPI",
        "LLVMMCParser",
        "LLVMMCDisassembler",
        "LLVMMC",
        "LLVMProfileData",
        "LLVMDebugInfoDWARF",
        "LLVMDebugInfoCodeView",
        "LLVMDebugInfoMSF",
        "LLVMDebugInfoPDB",
        "LLVMCore",
        "LLVMRemarks",
        "LLVMBitstreamReader",
        "LLVMBinaryFormat",
        "LLVMTargetParser",
        "LLVMSupport",
        "LLVMDemangle",
    ];

    for lib in &llvm_libs {
        println!("cargo:rustc-link-lib=static={}", lib);
    }

    // ─── Link MLIR static libraries ────────────────────────────────────
    // These match the target_link_libraries from CMakeLists.txt
    let mlir_libs = [
        // Core MLIR
        "MLIRIR",
        "MLIRDialect",
        "MLIRPass",
        "MLIRTransforms",
        "MLIRSupport",
        // Analysis
        "MLIRAnalysis",
        // LLVM Dialect and Translation
        "MLIRLLVMDialect",
        "MLIRLLVMCommonConversion",
        "MLIRTargetLLVMIRImport",
        "MLIRLLVMIRToLLVMTranslation",
        "MLIRLLVMIRToNVVMTranslation",
        // Built-in passes
        "MLIRTransformUtils",
        // Interfaces
        "MLIRSideEffectInterfaces",
        "MLIRControlFlowInterfaces",
        "MLIRFunctionInterfaces",
        "MLIRInferTypeOpInterface",
        // Arith Dialect
        "MLIRArithDialect",
        // UB Dialect (dependency of ArithDialect — PoisonOp)
        "MLIRUBDialect",
        // Func Dialect (dependency of translation infra)
        "MLIRFuncDialect",
        // Control Flow Dialect
        "MLIRControlFlowDialect",
        // Additional dependencies pulled in transitively
        "MLIRParser",
        "MLIRAsmParser",
        "MLIRBytecodeReader",
        "MLIRBytecodeWriter",
        "MLIRBytecodeOpInterface",
        "MLIRCallInterfaces",
        "MLIRCastInterfaces",
        "MLIRCopyOpInterface",
        "MLIRDataLayoutInterfaces",
        "MLIRDerivedAttributeOpInterface",
        "MLIRDestinationStyleOpInterface",
        "MLIRDialectUtils",
        "MLIRInferIntRangeInterface",
        "MLIRInferIntRangeCommon",
        "MLIRLoopLikeInterface",
        "MLIRMaskableOpInterface",
        "MLIRMaskingOpInterface",
        "MLIRMemorySlotInterfaces",
        "MLIRObservers",
        "MLIRParallelCombiningOpInterface",
        "MLIRPresburger",
        "MLIRRewrite",
        "MLIRRewritePDL",
        "MLIRPDLDialect",
        "MLIRPDLInterpDialect",
        "MLIRPDLToPDLInterp",
        "MLIRRuntimeVerifiableOpInterface",
        "MLIRShapedOpInterfaces",
        "MLIRSubsetOpInterface",
        "MLIRTilingInterface",
        "MLIRValueBoundsOpInterface",
        "MLIRViewLikeInterface",
        "MLIRTargetLLVMIRExport",
        "MLIRTargetLLVM",
        "MLIRLLVMToLLVMIRTranslation",
        "MLIRBuiltinToLLVMIRTranslation",
        "MLIRLLVMIRTransforms",
        "MLIRReconcileUnrealizedCasts",
        "MLIRConvertToLLVMInterface",
        "MLIRDebug",
        // Translation registration
        "MLIRFromLLVMIRTranslationRegistration",
        "MLIRToLLVMIRTranslationRegistration",
        // NVVMDialect pulled in by MLIRLLVMIRToNVVMTranslation
        "MLIRNVVMDialect",
        "MLIRDLTIDialect",
    ];

    for lib in &mlir_libs {
        println!("cargo:rustc-link-lib=static={}", lib);
    }

    // ─── Windows System Libraries ──────────────────────────────────────
    // LLVM/MLIR on Windows needs these system libraries
    if cfg!(target_os = "windows") {
        println!("cargo:rustc-link-lib=dylib=msvcrt");
        println!("cargo:rustc-link-lib=dylib=shell32");
        println!("cargo:rustc-link-lib=dylib=ole32");
        println!("cargo:rustc-link-lib=dylib=uuid");
        println!("cargo:rustc-link-lib=dylib=advapi32");
        println!("cargo:rustc-link-lib=dylib=ws2_32");
        println!("cargo:rustc-link-lib=dylib=userenv");
        println!("cargo:rustc-link-lib=dylib=ntdll");
        println!("cargo:rustc-link-lib=dylib=psapi");
        println!("cargo:rustc-link-lib=dylib=bcrypt");
        println!("cargo:rustc-link-lib=dylib=version");
    }

    // On Linux/macOS, link C++ standard library
    if cfg!(target_os = "linux") {
        println!("cargo:rustc-link-lib=dylib=stdc++");
    }
    if cfg!(target_os = "macos") {
        println!("cargo:rustc-link-lib=dylib=c++");
    }

    // ─── Re-run triggers ───────────────────────────────────────────────
    println!("cargo:rerun-if-changed={}", engine_build_dir.join("helix_engine.lib").display());

    let schemas_dir = project_root.join("schemas");
    if schemas_dir.exists() {
        println!("cargo:rerun-if-changed={}", schemas_dir.display());
    }
}
