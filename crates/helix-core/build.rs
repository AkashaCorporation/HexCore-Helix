//! Build script for helix-core.
//!
//! This script handles:
//! 1. Building the C++ engine via CMake (when the engine/ directory exists)
//! 2. Linking the engine static library
//!
//! In Phase 1 (foundation), the C++ engine is a stub.
//! In Phase 2+, this will link against LLVM/MLIR.

use std::env;
use std::path::PathBuf;

fn main() {
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let project_root = manifest_dir.parent().unwrap().parent().unwrap();
    let engine_dir = project_root.join("engine");

    // Temporarily disable C++ engine build for testing Rust decompiler
    if false {
        let dst = cmake::Config::new(&engine_dir)
            .define("CMAKE_BUILD_TYPE", "Release")
            .define("BUILD_SHARED_LIBS", "OFF")
            .build();

        // Link the static library
        println!("cargo:rustc-link-search=native={}/lib", dst.display());
        println!("cargo:rustc-link-lib=static=helix_engine");

        // On Windows, link C++ runtime
        if cfg!(target_os = "windows") {
            println!("cargo:rustc-link-lib=dylib=msvcrt");
        }

        // On Linux/macOS, link C++ standard library
        if cfg!(target_os = "linux") {
            println!("cargo:rustc-link-lib=dylib=stdc++");
        }
        if cfg!(target_os = "macos") {
            println!("cargo:rustc-link-lib=dylib=c++");
        }

        // Re-run if engine sources change
        println!("cargo:rerun-if-changed={}", engine_dir.display());
    } else {
        // No C++ engine yet — FFI functions will be unresolved.
        // This is expected in Phase 1 when doing `cargo check` only.
        eprintln!(
            "cargo:warning=C++ engine not found at {}. FFI functions will be stubs.",
            engine_dir.display()
        );
    }

    // Re-run if FlatBuffers schemas change
    let schemas_dir = project_root.join("schemas");
    if schemas_dir.exists() {
        println!("cargo:rerun-if-changed={}", schemas_dir.display());
    }
}
