//! Build script for helix-core (simplified, no CMake dependency).
//!
//! Links against the pre-built C++ engine (helix_engine.lib) and all
//! required LLVM/MLIR static libraries directly without CMake configs.

use std::env;
use std::path::PathBuf;

fn main() {
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let project_root = manifest_dir.parent().unwrap().parent().unwrap();

    // ─── Paths ─────────────────────────────────────────────────────────
    let engine_build_dir = project_root.join("engine").join("build");

    // LLVM/MLIR lib directory — simplified detection
    let llvm_lib_dir = if let Ok(dir) = env::var("LLVM_LIB_DIR") {
        // Direct lib dir (highest priority for CI)
        PathBuf::from(dir)
    } else if let Ok(dir) = env::var("LLVM_DIR") {
        // LLVM_DIR points to lib/cmake/llvm, go up to lib
        PathBuf::from(dir)
            .parent()
            .and_then(|p| p.parent())
            .map(|p| p.to_path_buf())
            .unwrap_or_else(|| PathBuf::from(dir))
    } else if let Ok(dir) = env::var("LLVM_BUILD_DIR") {
        // LLVM_BUILD_DIR points to build root
        PathBuf::from(dir).join("lib")
    } else {
        panic!(
            "Could not determine LLVM/MLIR lib directory.\n\
             Set one of these environment variables:\n\
             - LLVM_LIB_DIR: direct path to lib dir (e.g., /path/to/llvm/lib)\n\
             - LLVM_DIR: path to LLVM CMake config (e.g., /path/to/lib/cmake/llvm)\n\
             - LLVM_BUILD_DIR: path to LLVM build root"
        );
    };

    if !llvm_lib_dir.exists() {
        panic!(
            "LLVM lib directory does not exist: {}\n\
             Check your LLVM_LIB_DIR, LLVM_DIR, or LLVM_BUILD_DIR environment variable.",
            llvm_lib_dir.display()
        );
    }

    println!("cargo:warning=Using LLVM libs from: {}", llvm_lib_dir.display());

    // ─── Link the Helix engine static library ──────────────────────────
    println!(
        "cargo:rustc-link-search=native={}",
        engine_build_dir.display()
    );
    println!("cargo:rustc-link-lib=static=helix_engine");

    // ─── Link LLVM static libraries ────────────────────────────────────
    println!("cargo:rustc-link-search=native={}", llvm_lib_dir.display());

    // Core LLVM libraries (order matters for static linking)
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
        // UB Dialect
        "MLIRUBDialect",
        // Func Dialect
        "MLIRFuncDialect",
        // Control Flow Dialect
        "MLIRControlFlowDialect",
        "MLIRSCFDialect",
        "MLIRTensorDialect",
        "MLIRAffineDialect",
        "MLIRComplexDialect",
        "MLIRMemRefDialect",
        "MLIRArithUtils",
        "MLIRTensorUtils",
        "MLIRMemRefUtils",
        "MLIRSCFUtils",
        // Additional dependencies
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
        // NVVMDialect
        "MLIRNVVMDialect",
        "MLIRDLTIDialect",
    ];

    for lib in &mlir_libs {
        println!("cargo:rustc-link-lib=static={}", lib);
    }

    // ─── Windows System Libraries ──────────────────────────────────────
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

    // On Linux/macOS, link C++ standard library and system libs
    if cfg!(target_os = "linux") {
        println!("cargo:rustc-link-lib=dylib=stdc++");
        for lib in ["tinfo", "z", "zstd", "xml2", "ffi"] {
            println!("cargo:rustc-link-lib=dylib={}", lib);
        }
    }
    if cfg!(target_os = "macos") {
        println!("cargo:rustc-link-lib=dylib=c++");
    }

    // ─── Re-run triggers ───────────────────────────────────────────────
    println!("cargo:rerun-if-env-changed=LLVM_LIB_DIR");
    println!("cargo:rerun-if-env-changed=LLVM_DIR");
    println!("cargo:rerun-if-env-changed=LLVM_BUILD_DIR");
    
    let engine_lib_name = if cfg!(target_os = "windows") {
        "helix_engine.lib"
    } else {
        "libhelix_engine.a"
    };
    println!(
        "cargo:rerun-if-changed={}",
        engine_build_dir.join(engine_lib_name).display()
    );
}
