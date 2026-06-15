/// Integration test: validates output quality metrics against `output_real.txt`.
///
/// This test suite loads the real (unoptimized) decompiler output and verifies
/// that `validate_output()` correctly detects the known quality issues. It
/// establishes a baseline of violations so future pipeline improvements can be
/// measured against concrete numbers.
///
/// **Validates: Requirement 10.3** (absence of forbidden patterns in output)
use helix_core::pipeline::pseudoc_emitter::validate_output;

// ── Helpers ──────────────────────────────────────────────────────────

fn load_output_real() -> String {
    let path = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .join("engine/output_real.txt");
    std::fs::read_to_string(&path).unwrap_or_default()
}

// ── Tests ────────────────────────────────────────────────────────────

/// Sanity check: `validate_output` detects many violations in the old output.
/// This confirms the validator is working and the old output is indeed problematic.
#[test]
fn output_real_has_known_violations() {
    let output = load_output_real();
    if output.is_empty() {
        eprintln!("SKIP: output_real.txt not found");
        return;
    }

    let violations = validate_output(&output);

    // The old output should have many violations
    assert!(
        !violations.is_empty(),
        "output_real.txt should have forbidden patterns but validate_output found none"
    );

    // Categorise violations
    let undef_count = violations.iter().filter(|v| v.contains("__undef")).count();
    let mangled_count = violations.iter().filter(|v| v.contains("mangled")).count();
    let register_count = violations.iter().filter(|v| v.contains("register")).count();

    // The old output has __undef on almost every other line
    assert!(
        undef_count > 5,
        "expected many __undef violations, got {}",
        undef_count
    );
    // Multiple distinct mangled Remill names (CALL, MOV, XOR, CMP, TEST, JZ, etc.)
    assert!(
        mangled_count > 3,
        "expected mangled name violations, got {}",
        mangled_count
    );
    // Raw register names: rax, rbx, rdx, rdi, rsp, rcx, r8, r9
    assert!(
        register_count > 3,
        "expected raw register violations, got {}",
        register_count
    );
}

/// The old output declares ~125 variables all typed as `int64_t`.
/// An optimised pipeline should drastically reduce this count and use varied types.
#[test]
fn output_real_excessive_int64_declarations() {
    let output = load_output_real();
    if output.is_empty() {
        eprintln!("SKIP: output_real.txt not found");
        return;
    }

    let int64_count = output
        .lines()
        .filter(|l| l.trim().starts_with("int64_t"))
        .count();

    assert!(
        int64_count > 100,
        "expected >100 int64_t declarations in old output, got {}",
        int64_count
    );
}

/// The old output is riddled with `*(&__local)` patterns that should be resolved
/// into named local variables by RecoverStackLayout.
#[test]
fn output_real_has_local_patterns() {
    let output = load_output_real();
    if output.is_empty() {
        eprintln!("SKIP: output_real.txt not found");
        return;
    }

    let local_count = output.matches("*(&__local)").count();
    assert!(
        local_count > 10,
        "expected many *(&__local) patterns, got {}",
        local_count
    );
}

/// The old output contains `__carry()` and `__overflow()` intrinsics from dead
/// flag computations that should be eliminated by DCE.
#[test]
fn output_real_has_dead_flag_intrinsics() {
    let output = load_output_real();
    if output.is_empty() {
        eprintln!("SKIP: output_real.txt not found");
        return;
    }

    let carry_count = output.matches("__carry").count();
    let overflow_count = output.matches("__overflow").count();

    assert!(
        carry_count > 3,
        "expected multiple __carry intrinsics, got {}",
        carry_count
    );
    assert!(
        overflow_count > 3,
        "expected multiple __overflow intrinsics, got {}",
        overflow_count
    );
}

/// The old output uses function-style `cmp()` and `test()` calls instead of
/// C comparison operators. The optimised pipeline should emit `==`, `!=`, `<`, etc.
#[test]
fn output_real_has_function_style_comparisons() {
    let output = load_output_real();
    if output.is_empty() {
        eprintln!("SKIP: output_real.txt not found");
        return;
    }

    let cmp_calls = output.matches("cmp(").count();
    let test_calls = output.matches("test(").count();

    assert!(
        cmp_calls + test_calls > 2,
        "expected function-style cmp/test calls, got cmp={} test={}",
        cmp_calls,
        test_calls
    );
}

/// The old output contains mangled Remill names that should be resolved by
/// RemillToHelixLow demangling.
#[test]
fn output_real_has_mangled_remill_names() {
    let output = load_output_real();
    if output.is_empty() {
        eprintln!("SKIP: output_real.txt not found");
        return;
    }

    let mangled_count = output.matches("_ZN12_GLOBAL__N_1").count();
    assert!(
        mangled_count > 10,
        "expected many mangled Remill names, got {}",
        mangled_count
    );
}
