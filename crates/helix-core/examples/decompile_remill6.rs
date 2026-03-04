//! Decompila o caso Remill-6 (função complexa do WWZ) e salva o resultado.

use helix_core::decompile::decompile_ir_via_hir;

fn main() {
    let ir_path = "tests/remill-6/01-name-writing.ll";
    let out_path = "tests/remill-6/07-helix-optimized.c";

    let ir = std::fs::read_to_string(ir_path)
        .unwrap_or_else(|e| panic!("Falha ao ler {}: {}", ir_path, e));

    match decompile_ir_via_hir(&ir) {
        Ok(result) => {
            std::fs::write(out_path, &result.source)
                .unwrap_or_else(|e| panic!("Falha ao escrever {}: {}", out_path, e));

            println!("✅ {} → {}", ir_path, out_path);
            println!("   Funções: {}", result.function_count);
            println!("   Instruções: {}", result.instruction_count);
            println!("   Linhas: {}", result.source.lines().count());
            println!("\nDiagnostics:");
            for d in &result.diagnostics {
                println!("   {}", d);
            }
            println!("\n━━━ Output ━━━");
            println!("{}", result.source);
        }
        Err(e) => {
            eprintln!("❌ ERRO: {}", e);
            std::process::exit(1);
        }
    }
}
