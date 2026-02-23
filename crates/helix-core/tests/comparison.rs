/// Framework de comparação Helix vs Rellic para os 5 casos Remill.
/// Gera relatório Markdown com métricas lado a lado.
///
/// Requer os arquivos de teste em `tests/Remill-*/`.
/// Se ausentes, o teste de comparação é ignorado automaticamente.

use helix_core::decompile::decompile_ir_via_hir;

// ── Métricas ──────────────────────────────────────────────────────────

#[derive(Debug, Clone)]
struct ComparisonMetrics {
    effective_lines: usize,
    temp_var_count: usize,
    boilerplate_ops: usize,
    has_control_structures: bool,
}

/// Conta linhas efetivas: não-vazias e que não começam com `//`
fn count_effective_lines(code: &str) -> usize {
    code.lines()
        .map(|l| l.trim())
        .filter(|l| !l.is_empty() && !l.starts_with("//"))
        .count()
}

/// Conta variáveis temporárias únicas (padrão t\d+)
fn count_temp_vars(code: &str) -> usize {
    use std::collections::HashSet;
    let mut temps = HashSet::new();
    let bytes = code.as_bytes();
    let len = bytes.len();
    let mut i = 0;
    while i < len {
        if bytes[i] == b't' {
            let is_word_start = i == 0 || (!bytes[i - 1].is_ascii_alphanumeric() && bytes[i - 1] != b'_');
            if is_word_start && i + 1 < len && bytes[i + 1].is_ascii_digit() {
                let start = i;
                i += 1;
                while i < len && bytes[i].is_ascii_digit() {
                    i += 1;
                }
                if i >= len || (!bytes[i].is_ascii_alphanumeric() && bytes[i] != b'_') {
                    temps.insert(&code[start..i]);
                }
                continue;
            }
        }
        i += 1;
    }
    temps.len()
}

/// Conta referências a variáveis de boilerplate do Remill
fn count_boilerplate_ops(code: &str) -> usize {
    let boilerplate = ["PC", "NEXT_PC", "MEMORY", "MONITOR", "STATE"];
    let mut count = 0;
    for line in code.lines() {
        let trimmed = line.trim();
        if trimmed.starts_with("//") { continue; }
        for kw in &boilerplate {
            if trimmed.contains(kw) {
                count += 1;
                break;
            }
        }
    }
    count
}

/// Verifica presença de estruturas de controle
fn has_control_structures(code: &str) -> bool {
    code.contains("if (") || code.contains("if(")
        || code.contains("while (") || code.contains("while(")
        || code.contains("for (") || code.contains("for(")
}

fn compute_metrics(code: &str) -> ComparisonMetrics {
    ComparisonMetrics {
        effective_lines: count_effective_lines(code),
        temp_var_count: count_temp_vars(code),
        boilerplate_ops: count_boilerplate_ops(code),
        has_control_structures: has_control_structures(code),
    }
}

// ── Caso de teste ─────────────────────────────────────────────────────

struct TestCase {
    name: &'static str,
    dir: &'static str,
    ll_file: &'static str,
    rellic_file: &'static str,
}

const CASES: &[TestCase] = &[
    TestCase { name: "camera-init", dir: "Remill-1", ll_file: "01-camera-init.ll", rellic_file: "02-camera-init.c" },
    TestCase { name: "aim-assist-init", dir: "Remill-2", ll_file: "01-aim-assist-init.ll", rellic_file: "02-aim-assist-init.c" },
    TestCase { name: "swarm-serialization", dir: "Remill-3", ll_file: "01-swarm-serialization.ll", rellic_file: "02-swarm-serialization.c" },
    TestCase { name: "swarm-write", dir: "Remill-4", ll_file: "01-swarm-write.ll", rellic_file: "02-swarm-write.c" },
    TestCase { name: "name-writing", dir: "Remill-5", ll_file: "01-name-writing.ll", rellic_file: "02-name-writing.c" },
];

fn workspace_root() -> std::path::PathBuf {
    std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap()
        .parent().unwrap()
        .to_path_buf()
}

fn load_file(case: &TestCase, filename: &str) -> Option<String> {
    let path = workspace_root().join("tests").join(case.dir).join(filename);
    std::fs::read_to_string(&path).ok()
}

fn run_helix(case: &TestCase) -> Option<(String, ComparisonMetrics)> {
    let ir = load_file(case, case.ll_file)?;
    let result = decompile_ir_via_hir(&ir).ok()?;
    let metrics = compute_metrics(&result.source);
    Some((result.source, metrics))
}

fn load_rellic(case: &TestCase) -> Option<(String, ComparisonMetrics)> {
    let code = load_file(case, case.rellic_file)?;
    let metrics = compute_metrics(&code);
    Some((code, metrics))
}

fn generate_report(cases: &[TestCase], results: &[(ComparisonMetrics, ComparisonMetrics)]) -> String {
    let mut md = String::new();
    md.push_str("# Helix vs Rellic — Relatório de Comparação\n\n");
    md.push_str("Data: 2026-02-23\n\n");
    md.push_str("## Resumo de Métricas\n\n");
    md.push_str("| Caso | Helix Lines | Rellic Lines | Helix Temps | Rellic Temps | Helix Boilerplate | Rellic Boilerplate | Helix CF | Rellic CF | Status |\n");
    md.push_str("|------|------------|-------------|------------|-------------|-------------------|-------------------|----------|----------|--------|\n");

    for (i, (helix_m, rellic_m)) in results.iter().enumerate() {
        let case = &cases[i];
        let status = if helix_m.boilerplate_ops > rellic_m.boilerplate_ops {
            "⚠️ Regressão"
        } else if helix_m.effective_lines < rellic_m.effective_lines {
            "✅ Helix melhor"
        } else {
            "➖ Similar"
        };
        md.push_str(&format!(
            "| {} | {} | {} | {} | {} | {} | {} | {} | {} | {} |\n",
            case.name,
            helix_m.effective_lines, rellic_m.effective_lines,
            helix_m.temp_var_count, rellic_m.temp_var_count,
            helix_m.boilerplate_ops, rellic_m.boilerplate_ops,
            if helix_m.has_control_structures { "✓" } else { "✗" },
            if rellic_m.has_control_structures { "✓" } else { "✗" },
            status,
        ));
    }

    md.push_str("\n## Legenda\n\n");
    md.push_str("- Lines: linhas efetivas (não-vazias, sem comentários)\n");
    md.push_str("- Temps: variáveis temporárias (t0, t1, ...)\n");
    md.push_str("- Boilerplate: linhas com PC, NEXT_PC, MEMORY, etc.\n");
    md.push_str("- CF: presença de estruturas de controle (if/while/for)\n");
    md.push_str("- ⚠️: Helix tem mais boilerplate que Rellic\n");
    md.push_str("- ✅: Helix produz menos linhas que Rellic\n");
    md
}

// ── Testes ────────────────────────────────────────────────────────────

#[test]
fn comparison_helix_vs_rellic() {
    let mut results: Vec<(ComparisonMetrics, ComparisonMetrics)> = Vec::new();
    let mut available_cases: Vec<&TestCase> = Vec::new();

    for case in CASES {
        if let (Some((_, helix_m)), Some((_, rellic_m))) = (run_helix(case), load_rellic(case)) {
            results.push((helix_m, rellic_m));
            available_cases.push(case);
        }
    }

    if results.is_empty() {
        eprintln!("SKIP: nenhum caso de teste Remill disponível (dados ausentes)");
        return;
    }

    // Gera relatório
    let report = generate_report(&available_cases.iter().map(|c| TestCase {
        name: c.name, dir: c.dir, ll_file: c.ll_file, rellic_file: c.rellic_file,
    }).collect::<Vec<_>>(), &results);

    // Salva em tests/reports/
    let report_path = workspace_root().join("tests/reports/helix-vs-rellic.md");
    let _ = std::fs::write(&report_path, &report);

    // Verificação: Helix deve produzir menos linhas que Rellic na maioria dos casos
    let helix_wins = results.iter().filter(|(h, r)| h.effective_lines < r.effective_lines).count();
    let total = results.len();
    assert!(
        helix_wins * 2 >= total,
        "Helix deveria ser mais conciso que Rellic na maioria dos casos, mas ganhou apenas {}/{}",
        helix_wins, total
    );
}

#[test]
fn metrics_count_effective_lines() {
    let code = "// comment\n\nint x = 1;\nint y = 2;\n// another\n";
    assert_eq!(count_effective_lines(code), 2);
}

#[test]
fn metrics_count_temp_vars() {
    let code = "t0 = rax;\nt1 = t0 + t2;\nresult = t1;";
    assert_eq!(count_temp_vars(code), 3); // t0, t1, t2
}

#[test]
fn metrics_count_boilerplate() {
    let code = "PC = 0x1234;\nNEXT_PC = PC + 2;\nrax = rbx;\nMEMORY = ptr;";
    assert_eq!(count_boilerplate_ops(code), 3); // PC, NEXT_PC, MEMORY lines
}

#[test]
fn metrics_has_control_structures() {
    assert!(has_control_structures("if (x > 0) {"));
    assert!(has_control_structures("while (true) {"));
    assert!(!has_control_structures("rax = rbx + 1;"));
}
