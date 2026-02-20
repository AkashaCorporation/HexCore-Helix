//! Quick test: decompile log1.txt
use helix_core::decompile_ir;

fn main() {
    let file = std::env::args().nth(1).unwrap_or_else(|| "log1.txt".into());
    let ir = std::fs::read_to_string(&file).unwrap_or_else(|_| panic!("Failed to read {}", file));
    match decompile_ir(&ir) {
        Ok(output) => {
            println!("{}", output.source);
            eprintln!("--- Stats ---");
            eprintln!("Functions: {}", output.function_count);
            eprintln!("Instructions: {}", output.instruction_count);
            for diag in &output.diagnostics {
                eprintln!("  [diag] {}", diag);
            }
        }
        Err(e) => eprintln!("ERROR: {}", e),
    }
}
