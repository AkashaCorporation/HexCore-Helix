/// Testes de integração para os 5 novos casos Remill (World War Z).
/// Cada teste carrega o arquivo .ll, executa o pipeline completo e verifica
/// propriedades básicas do pseudo-C gerado.
///
/// Estes testes requerem os arquivos de teste em `tests/Remill-*/`.
/// Se os arquivos não existirem, os testes são ignorados automaticamente.
use helix_core::decompile::decompile_ir_via_hir;

/// Caminho raiz dos testes Remill (relativo à raiz do workspace)
fn workspace_root() -> std::path::PathBuf {
    std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf()
}

fn load_ir(case: &str, filename: &str) -> Option<String> {
    let path = workspace_root().join("tests").join(case).join(filename);
    std::fs::read_to_string(&path).ok()
}

/// Verificações comuns para todos os casos de integração
fn assert_valid_decompile_output(source: &str, case_name: &str) {
    // 1. Pseudo-C não-vazio
    assert!(!source.trim().is_empty(), "{}: pseudo-C vazio", case_name);

    // 2. Contém informação de tipo
    let has_type_info = source.contains("int64_t")
        || source.contains("int32_t")
        || source.contains("void")
        || source.contains("uint64_t")
        || source.contains("uint32_t");
    assert!(has_type_info, "{}: sem informação de tipo", case_name);

    // 3. Contém operação aritmética ou atribuição
    let has_assign_or_arith =
        source.contains(" = ") || source.contains(" += ") || source.contains(" -= ");
    assert!(
        has_assign_or_arith,
        "{}: sem atribuição/aritmética",
        case_name
    );

    // 4. Contém nomes de registradores reais (case-insensitive)
    let src_lower = source.to_lowercase();
    let real_regs = [
        "rax", "rbx", "rcx", "rdx", "rsp", "rbp", "rsi", "rdi", "r8", "r9", "r10", "r11", "r12",
        "r13", "r14", "r15", "al", "cl",
    ];
    let has_real_reg = real_regs.iter().any(|r| src_lower.contains(r));
    assert!(
        has_real_reg,
        "{}: sem nomes de registradores reais",
        case_name
    );

    // 5. Chaves balanceadas
    let open = source.chars().filter(|&c| c == '{').count();
    let close = source.chars().filter(|&c| c == '}').count();
    assert_eq!(
        open, close,
        "{}: chaves desbalanceadas ({} abrem, {} fecham)",
        case_name, open, close
    );
}

fn run_remill_test(case: &str, ll_file: &str) {
    let ir = match load_ir(case, ll_file) {
        Some(ir) => ir,
        None => {
            eprintln!(
                "SKIP: {}/{} não encontrado (dados de teste ausentes)",
                case, ll_file
            );
            return;
        }
    };
    let result =
        decompile_ir_via_hir(&ir).unwrap_or_else(|e| panic!("{}: pipeline falhou: {}", case, e));
    assert!(
        result.function_count > 0,
        "{}: nenhuma função recuperada",
        case
    );
    assert!(
        result.instruction_count > 0,
        "{}: nenhuma instrução decodificada",
        case
    );
    assert_valid_decompile_output(&result.source, case);
}

#[test]
fn remill_1_camera_init() {
    run_remill_test("Remill-1", "01-camera-init.ll");
}

#[test]
fn remill_2_aim_assist_init() {
    run_remill_test("Remill-2", "01-aim-assist-init.ll");
}

#[test]
fn remill_3_swarm_serialization() {
    run_remill_test("Remill-3", "01-swarm-serialization.ll");
}

#[test]
fn remill_4_swarm_write() {
    run_remill_test("Remill-4", "01-swarm-write.ll");
}

#[test]
fn remill_5_name_writing() {
    run_remill_test("Remill-5", "01-name-writing.ll");
}
