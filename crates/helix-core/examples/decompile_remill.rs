//! Gera o pseudo-C do Helix para os 5 casos Remill e salva ao lado do output Rellic.
//!
//! Usage: cargo run -p helix-core --example decompile_remill

use helix_core::decompile::decompile_ir_via_hir;

fn main() {
    let cases = [
        ("Remill-1", "01-camera-init.ll", "04-camera-init.helix.c"),
        ("Remill-2", "01-aim-assist-init.ll", "04-aim-assist-init.helix.c"),
        ("Remill-3", "01-swarm-serialization.ll", "04-swarm-serialization.helix.c"),
        ("Remill-4", "01-swarm-write.ll", "04-swarm-write.helix.c"),
        ("Remill-5", "01-name-writing.ll", "04-name-writing.helix.c"),
        ("remill-7", "bone_pos_calc.ll", "bone_pos_calc.helix.c"),
    ];

    for (dir, ll_file, out_file) in &cases {
        let ir_path = format!("tests/{}/{}", dir, ll_file);
        let out_path = format!("tests/{}/{}", dir, out_file);

        let ir = std::fs::read_to_string(&ir_path)
            .unwrap_or_else(|e| panic!("Falha ao ler {}: {}", ir_path, e));

        match decompile_ir_via_hir(&ir) {
            Ok(result) => {
                std::fs::write(&out_path, &result.source)
                    .unwrap_or_else(|e| panic!("Falha ao escrever {}: {}", out_path, e));
                println!("✅ {} → {} ({} funções, {} instruções, {} linhas)",
                    ir_path, out_path,
                    result.function_count,
                    result.instruction_count,
                    result.source.lines().count(),
                );
            }
            Err(e) => {
                eprintln!("❌ {} → ERRO: {}", ir_path, e);
            }
        }
    }
}
