//! Debug: mostra o que o parser extrai e o que o HIR builder gera.

use helix_core::ir::hir_builder;
use helix_core::ir::hir_emitter::{self, EmitOptions};
use helix_core::ir::parser::parse_remill_ir;
use helix_core::signatures::SignatureDb;

fn main() {
    let path = "tests/Remill-1/01-camera-init.ll";
    let ir = std::fs::read_to_string(path).unwrap();

    println!("━━━ Parser Output ━━━");
    let module = parse_remill_ir(&ir).unwrap();
    println!("Instructions: {}", module.instructions.len());
    for (i, insn) in module.instructions.iter().enumerate() {
        println!(
            "  [{}] {:?} @ 0x{:x} — dst: {:?}, srcs: {:?}",
            i, insn.semantic, insn.pc, insn.dst, insn.srcs
        );
    }

    println!("\n━━━ HIR Module (before transforms) ━━━");
    let mut hir = hir_builder::build_hir(&module);
    for func in &hir.functions {
        println!("Function: {} @ 0x{:x}", func.name, func.address);
        println!(
            "  Locals: {:?}",
            func.locals
                .iter()
                .map(|l| format!("{} (id={})", l.name, l.id.0))
                .collect::<Vec<_>>()
        );
        println!("  Body ({} stmts):", func.body.len());
        for (i, stmt) in func.body.iter().enumerate() {
            println!("    [{}] {:?}", i, stmt);
        }
    }

    // Apply transforms like decompile_ir_via_hir does
    let signatures = SignatureDb::load_default();

    // Calling convention
    use helix_core::analysis::calling_convention;
    use helix_core::analysis::control_flow;
    use helix_core::analysis::type_propagation;
    use helix_core::diagnostics::DiagnosticSink;

    let cc = calling_convention::recover_calling_convention(&mut hir, &signatures);
    println!("\n━━━ After calling convention ━━━");
    println!(
        "  calls={}, args={}, eliminated={}",
        cc.calls_recovered, cc.args_recovered, cc.stmts_eliminated
    );

    let tp = type_propagation::propagate_types(&mut hir, &signatures);
    println!("━━━ After type propagation ━━━");
    println!(
        "  resolved={}, unresolved={}",
        tp.types_resolved, tp.types_unresolved
    );

    let mut sink = DiagnosticSink::new();
    let cf = control_flow::structure_control_flow(&mut hir, &mut sink);
    println!("━━━ After control flow ━━━");
    println!("  ifs={}, loops={}", cf.ifs_recovered, cf.loops_recovered);

    println!("\n━━━ Before boilerplate elimination ━━━");
    for func in &hir.functions {
        println!(
            "  Locals: {:?}",
            func.locals
                .iter()
                .map(|l| format!("{} (id={})", l.name, l.id.0))
                .collect::<Vec<_>>()
        );
        println!("  Body ({} stmts):", func.body.len());
        for (i, stmt) in func.body.iter().enumerate() {
            println!("    [{}] {:?}", i, stmt);
        }
    }

    // Boilerplate elimination + signature rewrite
    for func in &mut hir.functions {
        hir_builder::eliminate_boilerplate(func);
        hir_builder::rewrite_function_signature(func);
    }

    println!("\n━━━ After boilerplate + signature rewrite ━━━");
    for func in &hir.functions {
        println!("Function: {} @ 0x{:x}", func.name, func.address);
        println!("  Return type: {:?}", func.return_type);
        println!(
            "  Params: {:?}",
            func.params
                .iter()
                .map(|p| format!("{} (id={})", p.name, p.id.0))
                .collect::<Vec<_>>()
        );
        println!(
            "  Locals: {:?}",
            func.locals
                .iter()
                .map(|l| format!("{} (id={})", l.name, l.id.0))
                .collect::<Vec<_>>()
        );
        println!("  Body ({} stmts):", func.body.len());
        for (i, stmt) in func.body.iter().enumerate() {
            println!("    [{}] {:?}", i, stmt);
        }
    }

    println!("\n━━━ Final Pseudo-C ━━━");
    let options = EmitOptions::default();
    let source = hir_emitter::emit_module(&hir, &signatures, &options);
    println!("{}", source);
}
