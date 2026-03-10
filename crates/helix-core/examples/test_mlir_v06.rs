//! Test v06: Run both MLIR and Rust decompilation pipelines on a Remill IR file.
//!
//! Usage:
//!   cargo run --release --example test_mlir_v06 -- <path/to/file.ll>
//!
//! Produces two output files:
//!   06-helix-mlir.c    — C++ MLIR engine output
//!   06-helix-rust.c    — Pure Rust pipeline output

use helix_core::decompile_ir;
use helix_core::ffi::EngineHandle;
use std::path::Path;

fn main() {
    let file = std::env::args().nth(1).unwrap_or_else(|| {
        eprintln!("Usage: test_mlir_v06 <path/to/remill-ir.ll>");
        std::process::exit(1);
    });

    let ir = std::fs::read_to_string(&file).unwrap_or_else(|e| {
        eprintln!("Failed to read {}: {}", file, e);
        std::process::exit(1);
    });

    let output_dir = Path::new(&file).parent().unwrap_or(Path::new("."));

    println!("╔══════════════════════════════════════════════════════════════╗");
    println!("║  HexCore Helix v06 Test — MLIR vs Rust Pipeline Comparison  ║");
    println!("╚══════════════════════════════════════════════════════════════╝");
    println!();
    println!("  Input: {}", file);
    println!(
        "  IR size: {} bytes ({} lines)",
        ir.len(),
        ir.lines().count()
    );
    println!();

    // ─── Test 1: MLIR C++ Engine ───────────────────────────────────────
    println!("━━━ Test 1: C++ MLIR Engine ━━━");
    let mlir_result = test_mlir_pipeline(&ir);
    match &mlir_result {
        Ok(source) => {
            let out_path = output_dir.join("06-helix-mlir.c");
            std::fs::write(&out_path, source).expect("Failed to write MLIR output");
            println!("  ✅ MLIR pipeline succeeded!");
            println!(
                "  Output: {} bytes ({} lines)",
                source.len(),
                source.lines().count()
            );
            println!("  Saved: {}", out_path.display());
        }
        Err(e) => {
            println!("  ❌ MLIR pipeline failed: {}", e);
        }
    }
    println!();

    // ─── Test 2: Pure Rust Pipeline ────────────────────────────────────
    println!("━━━ Test 2: Pure Rust Pipeline ━━━");
    let rust_result = test_rust_pipeline(&ir);
    match &rust_result {
        Ok(source) => {
            let out_path = output_dir.join("06-helix-rust.c");
            std::fs::write(&out_path, source).expect("Failed to write Rust output");
            println!("  ✅ Rust pipeline succeeded!");
            println!(
                "  Output: {} bytes ({} lines)",
                source.len(),
                source.lines().count()
            );
            println!("  Saved: {}", out_path.display());
        }
        Err(e) => {
            println!("  ❌ Rust pipeline failed: {}", e);
        }
    }
    println!();

    // ─── Summary ───────────────────────────────────────────────────────
    println!("━━━ Summary ━━━");
    let mlir_ok = mlir_result.is_ok();
    let rust_ok = rust_result.is_ok();

    if mlir_ok && rust_ok {
        let mlir_src = mlir_result.as_ref().unwrap();
        let rust_src = rust_result.as_ref().unwrap();
        println!(
            "  MLIR:  {} lines, {} bytes",
            mlir_src.lines().count(),
            mlir_src.len()
        );
        println!(
            "  Rust:  {} lines, {} bytes",
            rust_src.lines().count(),
            rust_src.len()
        );

        if mlir_src == rust_src {
            println!("  ⚠️  Outputs are identical (MLIR may have fallen back to Rust)");
        } else {
            println!("  ✨ Outputs differ — MLIR engine produced unique output!");
        }
    } else {
        println!("  MLIR: {}", if mlir_ok { "✅" } else { "❌" });
        println!("  Rust: {}", if rust_ok { "✅" } else { "❌" });
    }

    // ── Print MLIR output to stdout ──
    if let Ok(source) = &mlir_result {
        println!();
        println!("━━━ MLIR Output ━━━");
        println!("{}", source);
    } else if let Ok(source) = &rust_result {
        println!();
        println!("━━━ Rust Output (fallback) ━━━");
        println!("{}", source);
    }
}

fn test_mlir_pipeline(ir: &str) -> Result<String, String> {
    let start = std::time::Instant::now();

    let mut engine = EngineHandle::new(helix_core::ArchKind::X86_64)
        .map_err(|e| format!("Failed to create MLIR engine: {}", e))?;

    println!("  Engine version: {}", EngineHandle::version());
    println!("  Creating engine took: {:?}", start.elapsed());

    let decompile_start = std::time::Instant::now();
    let result = engine
        .decompile_ir_text(ir)
        .map_err(|e| format!("decompile_ir_text failed: {}", e))?;

    println!("  Decompilation took: {:?}", decompile_start.elapsed());

    Ok(result)
}

fn test_rust_pipeline(ir: &str) -> Result<String, String> {
    let start = std::time::Instant::now();

    let output = decompile_ir(ir).map_err(|e| format!("decompile_ir failed: {}", e))?;

    println!("  Decompilation took: {:?}", start.elapsed());
    println!("  Functions: {}", output.function_count);
    println!("  Instructions: {}", output.instruction_count);

    for diag in &output.diagnostics {
        println!("  [diag] {}", diag);
    }

    Ok(output.source)
}
