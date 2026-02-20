//! Compare output: original pipeline vs HIR pipeline.
//!
//! Usage: cargo run --example compare_pipelines -- log1.txt
//!
//! Shows both outputs side by side with metrics for quality comparison.

use helix_core::decompile::{decompile_ir, decompile_ir_via_hir};

fn main() {
    let file = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "log1.txt".into());
    let ir = std::fs::read_to_string(&file)
        .unwrap_or_else(|_| panic!("Failed to read {}", file));

    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("  HexCore Helix — Pipeline Comparison: {}", file);
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    // ── Original Pipeline ────────────────────────────────────────────
    println!("\n┌─── ORIGINAL PIPELINE (transforms.rs) ─────────────────┐");
    let start = std::time::Instant::now();
    match decompile_ir(&ir) {
        Ok(output) => {
            let elapsed = start.elapsed();
            println!("{}", output.source);
            println!("├── Stats ──────────────────────────────────────────────┤");
            println!("│  Functions:    {}", output.function_count);
            println!("│  Instructions: {}", output.instruction_count);
            println!("│  Source lines: {}", output.source.lines().count());
            println!("│  Time:         {:.3} ms", elapsed.as_secs_f64() * 1000.0);
            for diag in &output.diagnostics {
                println!("│  [diag] {}", diag);
            }
        }
        Err(e) => println!("│  ERROR: {}", e),
    }
    println!("└───────────────────────────────────────────────────────┘");

    // ── HIR Pipeline ─────────────────────────────────────────────────
    println!("\n┌─── HIR PIPELINE (hir_builder → type_prop → emitter) ──┐");
    let start = std::time::Instant::now();
    match decompile_ir_via_hir(&ir) {
        Ok(output) => {
            let elapsed = start.elapsed();
            println!("{}", output.source);
            println!("├── Stats ──────────────────────────────────────────────┤");
            println!("│  Functions:    {}", output.function_count);
            println!("│  Instructions: {}", output.instruction_count);
            println!("│  Source lines: {}", output.source.lines().count());
            println!("│  Time:         {:.3} ms", elapsed.as_secs_f64() * 1000.0);
            for diag in &output.diagnostics {
                println!("│  [diag] {}", diag);
            }
        }
        Err(e) => println!("│  ERROR: {}", e),
    }
    println!("└───────────────────────────────────────────────────────┘");
}
