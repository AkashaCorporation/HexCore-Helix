//! Benchmark: FlatBuffer vs JSON serialization.
//!
//! Compara tamanho e velocidade de serialização entre FlatBuffer e JSON
//! para dados de CFG e AST.
//!
//! Usage: cargo run -p helix-core --example benchmark_flatbuf

use helix_core::flatbuf::cfg::{CfgData, CfgFunctionData};
use helix_core::flatbuf::ast::{AstData, AstFunctionData};
use std::time::Instant;

fn main() {
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    println!("  HexCore Helix — FlatBuffer vs JSON Benchmark");
    println!("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    let iterations = 1000;

    // Dados de teste CFG
    let cfg_data = CfgData {
        module_name: "wwzRetailEgs.exe".into(),
        functions: (0..5).map(|i| CfgFunctionData {
            name: format!("sub_{:x}", 0x140000000u64 + i * 0x1000),
            entry_address: 0x140000000 + i * 0x1000,
            instruction_count: 42 + i as u32 * 10,
            block_count: 3 + i as u32,
        }).collect(),
    };

    // Dados de teste AST
    let source = "int64_t sub_140000000(void) {\n    rbx = (rbx + al);\n    rax = (rax + al);\n    *rax = (*rax + al);\n    rax = (rax + al);\n}\n";
    let ast_data = AstData {
        module_name: "wwzRetailEgs.exe".into(),
        functions: (0..5).map(|i| AstFunctionData {
            name: format!("sub_{:x}", 0x140000000u64 + i * 0x1000),
            address: 0x140000000 + i * 0x1000,
            source: source.to_string(),
            param_count: 0,
            local_count: 4,
            stmt_count: 4,
        }).collect(),
    };

    println!("\n┌─── CFG Serialization ─────────────────────────────────┐");
    benchmark_cfg(&cfg_data, iterations);

    println!("\n┌─── AST Serialization ─────────────────────────────────┐");
    benchmark_ast(&ast_data, iterations);

    // Gerar relatório
    generate_report(&cfg_data, &ast_data, iterations);
}

fn benchmark_cfg(data: &CfgData, iterations: usize) {
    // FlatBuffer
    let start = Instant::now();
    let mut fb_buf = Vec::new();
    for _ in 0..iterations {
        fb_buf = helix_core::flatbuf::cfg::serialize_cfg(data).unwrap();
    }
    let fb_time = start.elapsed();
    let fb_size = fb_buf.len();

    // JSON (manual, sem serde no CfgData)
    let start = Instant::now();
    let mut json_buf = String::new();
    for _ in 0..iterations {
        json_buf = cfg_to_json(data);
    }
    let json_time = start.elapsed();
    let json_size = json_buf.len();

    println!("│  FlatBuffer: {} bytes, {:.3} ms ({} iters)", fb_size, fb_time.as_secs_f64() * 1000.0, iterations);
    println!("│  JSON:       {} bytes, {:.3} ms ({} iters)", json_size, json_time.as_secs_f64() * 1000.0, iterations);
    println!("│  Size ratio: {:.1}x smaller (FB vs JSON)", json_size as f64 / fb_size as f64);
    println!("│  Speed ratio: {:.1}x faster (FB vs JSON)", json_time.as_secs_f64() / fb_time.as_secs_f64());
    println!("└───────────────────────────────────────────────────────┘");
}

fn benchmark_ast(data: &AstData, iterations: usize) {
    let start = Instant::now();
    let mut fb_buf = Vec::new();
    for _ in 0..iterations {
        fb_buf = helix_core::flatbuf::ast::serialize_ast(data).unwrap();
    }
    let fb_time = start.elapsed();
    let fb_size = fb_buf.len();

    let start = Instant::now();
    let mut json_buf = String::new();
    for _ in 0..iterations {
        json_buf = ast_to_json(data);
    }
    let json_time = start.elapsed();
    let json_size = json_buf.len();

    println!("│  FlatBuffer: {} bytes, {:.3} ms ({} iters)", fb_size, fb_time.as_secs_f64() * 1000.0, iterations);
    println!("│  JSON:       {} bytes, {:.3} ms ({} iters)", json_size, json_time.as_secs_f64() * 1000.0, iterations);
    println!("│  Size ratio: {:.1}x smaller (FB vs JSON)", json_size as f64 / fb_size as f64);
    println!("│  Speed ratio: {:.1}x faster (FB vs JSON)", json_time.as_secs_f64() / fb_time.as_secs_f64());
    println!("└───────────────────────────────────────────────────────┘");
}

fn cfg_to_json(data: &CfgData) -> String {
    let mut s = format!("{{\"name\":\"{}\",\"functions\":[", data.module_name);
    for (i, f) in data.functions.iter().enumerate() {
        if i > 0 { s.push(','); }
        s.push_str(&format!(
            "{{\"name\":\"{}\",\"entry\":{},\"instructions\":{},\"blocks\":{}}}",
            f.name, f.entry_address, f.instruction_count, f.block_count
        ));
    }
    s.push_str("]}");
    s
}

fn ast_to_json(data: &AstData) -> String {
    let mut s = format!("{{\"name\":\"{}\",\"functions\":[", data.module_name);
    for (i, f) in data.functions.iter().enumerate() {
        if i > 0 { s.push(','); }
        let escaped_source = f.source.replace('\\', "\\\\").replace('"', "\\\"").replace('\n', "\\n");
        s.push_str(&format!(
            "{{\"name\":\"{}\",\"address\":{},\"source\":\"{}\",\"params\":{},\"locals\":{},\"stmts\":{}}}",
            f.name, f.address, escaped_source, f.param_count, f.local_count, f.stmt_count
        ));
    }
    s.push_str("]}");
    s
}

fn generate_report(cfg_data: &CfgData, ast_data: &AstData, iterations: usize) {
    let cfg_fb = helix_core::flatbuf::cfg::serialize_cfg(cfg_data).unwrap();
    let cfg_json = cfg_to_json(cfg_data);
    let ast_fb = helix_core::flatbuf::ast::serialize_ast(ast_data).unwrap();
    let ast_json = ast_to_json(ast_data);

    let report = format!(
        "# FlatBuffer vs JSON — Benchmark Report\n\n\
         Data: 2026-02-23\n\
         Iterations: {}\n\n\
         ## Tamanho\n\n\
         | Tipo | FlatBuffer (bytes) | JSON (bytes) | Ratio |\n\
         |------|-------------------|-------------|-------|\n\
         | CFG  | {} | {} | {:.1}x |\n\
         | AST  | {} | {} | {:.1}x |\n\n\
         ## Notas\n\n\
         - FlatBuffer usa serialização binária zero-copy\n\
         - JSON usa serialização manual (sem serde overhead)\n\
         - Ratio = JSON/FlatBuffer (maior = FlatBuffer mais compacto)\n",
        iterations,
        cfg_fb.len(), cfg_json.len(), cfg_json.len() as f64 / cfg_fb.len() as f64,
        ast_fb.len(), ast_json.len(), ast_json.len() as f64 / ast_fb.len() as f64,
    );

    let report_path = "tests/reports/flatbuf-vs-json.md";
    // Try workspace root
    let workspace_root = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap()
        .parent().unwrap();
    let full_path = workspace_root.join(report_path);
    match std::fs::write(&full_path, &report) {
        Ok(_) => println!("\n📄 Report saved to {}", full_path.display()),
        Err(e) => eprintln!("\n⚠️  Could not save report: {}", e),
    }
}
