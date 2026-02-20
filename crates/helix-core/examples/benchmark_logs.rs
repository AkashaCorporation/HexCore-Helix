//! Benchmark runner for comparing IR decompilation quality and performance
//! across multiple log files (e.g. log1/log2/log3).

use helix_core::decompile_ir;
use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::time::{Instant, SystemTime};

#[derive(Debug, Default, Clone)]
struct HeaderMeta {
    file: Option<String>,
    address: Option<String>,
    size: Option<String>,
    arch: Option<String>,
    generated: Option<String>,
}

#[derive(Debug, Clone)]
struct LogReport {
    log_name: String,
    scenario: String,
    ir_bytes: usize,
    ir_lines: usize,
    source_lines: usize,
    function_count: usize,
    instruction_count: usize,
    diagnostics_count: usize,
    benchmark_runs: usize,
    mean_ms: f64,
    min_ms: f64,
    max_ms: f64,
    std_ms: f64,
    instructions_per_ms: f64,
    header: HeaderMeta,
    diagnostics: Vec<String>,
    source_preview: Vec<String>,
}

fn parse_header(ir_text: &str) -> HeaderMeta {
    let mut meta = HeaderMeta::default();
    for line in ir_text.lines().take(64) {
        if let Some(rest) = line.strip_prefix("; File: ") {
            meta.file = Some(rest.trim().to_string());
        } else if let Some(rest) = line.strip_prefix("; Address: ") {
            meta.address = Some(rest.trim().to_string());
        } else if let Some(rest) = line.strip_prefix("; Size: ") {
            meta.size = Some(rest.trim().to_string());
        } else if let Some(rest) = line.strip_prefix("; Architecture: ") {
            meta.arch = Some(rest.trim().to_string());
        } else if let Some(rest) = line.strip_prefix("; Generated: ") {
            meta.generated = Some(rest.trim().to_string());
        }
    }
    meta
}

fn scenario_hint(log_name: &str) -> String {
    match log_name {
        "log1.txt" => "ROTTR sample A (calls + register moves)".to_string(),
        "log2.txt" => "ROTTR sample B (LEA + memory stores)".to_string(),
        "log3.txt" => "ROTTR sample C (branch-heavy) - Tomb Raider".to_string(),
        _ => "Custom sample".to_string(),
    }
}

fn source_preview(source: &str) -> Vec<String> {
    source
        .lines()
        .filter(|line| !line.trim().is_empty())
        .take(12)
        .map(|line| line.to_string())
        .collect()
}

fn timing_stats(samples: &[f64]) -> (f64, f64, f64, f64) {
    if samples.is_empty() {
        return (0.0, 0.0, 0.0, 0.0);
    }

    let count = samples.len() as f64;
    let sum: f64 = samples.iter().sum();
    let mean = sum / count;
    let min = samples
        .iter()
        .copied()
        .fold(f64::INFINITY, |acc, v| acc.min(v));
    let max = samples
        .iter()
        .copied()
        .fold(f64::NEG_INFINITY, |acc, v| acc.max(v));

    let variance = samples
        .iter()
        .map(|v| {
            let d = *v - mean;
            d * d
        })
        .sum::<f64>()
        / count;

    (mean, min, max, variance.sqrt())
}

fn run_one(path: &Path, iterations: usize) -> Result<LogReport, String> {
    let ir =
        fs::read_to_string(path).map_err(|e| format!("failed to read {}: {e}", path.display()))?;
    let header = parse_header(&ir);
    let log_name = path
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unknown.log")
        .to_string();

    let mut timings_ms = Vec::with_capacity(iterations);
    let mut first_output = None;
    for _ in 0..iterations {
        let started = Instant::now();
        let out = decompile_ir(&ir)
            .map_err(|e| format!("decompile_ir failed for {}: {e}", path.display()))?;
        let elapsed_ms = started.elapsed().as_secs_f64() * 1000.0;
        timings_ms.push(elapsed_ms);

        if first_output.is_none() {
            first_output = Some(out);
        }
    }

    let out = first_output.unwrap_or_else(|| unreachable!("iterations >= 1"));
    let (mean_ms, min_ms, max_ms, std_ms) = timing_stats(&timings_ms);

    let instructions_per_ms = if mean_ms <= 0.0 {
        out.instruction_count as f64
    } else {
        out.instruction_count as f64 / mean_ms
    };

    Ok(LogReport {
        log_name: log_name.clone(),
        scenario: scenario_hint(&log_name),
        ir_bytes: ir.len(),
        ir_lines: ir.lines().count(),
        source_lines: out.source.lines().count(),
        function_count: out.function_count,
        instruction_count: out.instruction_count,
        diagnostics_count: out.diagnostics.len(),
        benchmark_runs: iterations,
        mean_ms,
        min_ms,
        max_ms,
        std_ms,
        instructions_per_ms,
        header,
        diagnostics: out.diagnostics,
        source_preview: source_preview(&out.source),
    })
}

fn opt_or_dash(value: Option<&str>) -> &str {
    value.unwrap_or("-")
}

fn render_report(label: &str, reports: &[LogReport], logs: &[PathBuf]) -> String {
    let now = format!("{:?}", SystemTime::now());

    let mut md = String::new();
    md.push_str("# Helix Log Comparison Report\n\n");
    md.push_str(&format!("- Label: `{}`\n", label));
    md.push_str(&format!("- Generated at: `{}`\n", now));
    md.push_str(&format!("- Logs analyzed: `{}`\n\n", logs.len()));

    md.push_str("## Summary Table\n\n");
    md.push_str("| Log | Scenario | Binary | Arch | Address | IR lines | Source lines | Functions | Instructions | Diagnostics | Mean (ms) | Min/Max (ms) | Instr/ms |\n");
    md.push_str(
        "| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: |\n",
    );

    for r in reports {
        md.push_str(&format!(
            "| `{}` | {} | {} | {} | {} | {} | {} | {} | {} | {} | {:.3} | {:.3}/{:.3} | {:.2} |\n",
            r.log_name,
            r.scenario,
            opt_or_dash(r.header.file.as_deref()),
            opt_or_dash(r.header.arch.as_deref()),
            opt_or_dash(r.header.address.as_deref()),
            r.ir_lines,
            r.source_lines,
            r.function_count,
            r.instruction_count,
            r.diagnostics_count,
            r.mean_ms,
            r.min_ms,
            r.max_ms,
            r.instructions_per_ms
        ));
    }

    md.push_str("\n## Per-Log Details\n\n");

    for r in reports {
        md.push_str(&format!("### {}\n\n", r.log_name));
        md.push_str(&format!("- Scenario: {}\n", r.scenario));
        md.push_str(&format!(
            "- Binary: {}\n",
            opt_or_dash(r.header.file.as_deref())
        ));
        md.push_str(&format!(
            "- Address: {}\n",
            opt_or_dash(r.header.address.as_deref())
        ));
        md.push_str(&format!(
            "- Input size: {} bytes (`{}`)\n",
            r.ir_bytes,
            opt_or_dash(r.header.size.as_deref())
        ));
        md.push_str(&format!(
            "- Architecture: {}\n",
            opt_or_dash(r.header.arch.as_deref())
        ));
        md.push_str(&format!(
            "- Lift generated: {}\n",
            opt_or_dash(r.header.generated.as_deref())
        ));
        md.push_str(&format!(
            "- Output: {} functions, {} instructions, {} source lines\n",
            r.function_count, r.instruction_count, r.source_lines
        ));
        md.push_str(&format!(
            "- Benchmark: {} runs, mean {:.3} ms, min {:.3} ms, max {:.3} ms, std {:.3} ms\n",
            r.benchmark_runs, r.mean_ms, r.min_ms, r.max_ms, r.std_ms
        ));
        md.push_str(&format!(
            "- Throughput: {:.2} instr/ms\n\n",
            r.instructions_per_ms
        ));

        if r.diagnostics.is_empty() {
            md.push_str("Diagnostics: `none`\n\n");
        } else {
            md.push_str("Diagnostics:\n");
            for diag in r.diagnostics.iter().take(12) {
                md.push_str(&format!("- `{}`\n", diag));
            }
            md.push('\n');
        }

        md.push_str("Source preview:\n\n```c\n");
        for line in &r.source_preview {
            md.push_str(line);
            md.push('\n');
        }
        md.push_str("```\n\n");
    }

    md.push_str("## Notes\n\n");
    md.push_str("- `log3.txt` is tagged as Tomb Raider sample because the IR header identifies `File: ROTTR.exe`.\n");
    md.push_str("- Keep this report under version control to compare future improvements in transforms and decompilation quality.\n");

    md
}

fn parse_args() -> (String, PathBuf, Vec<PathBuf>, usize) {
    let mut args = env::args().skip(1);
    let mut label = "baseline".to_string();
    let mut output = PathBuf::from("tests/reports/latest.md");
    let mut iterations: usize = 25;
    let mut logs = Vec::new();

    while let Some(arg) = args.next() {
        match arg.as_str() {
            "--label" => {
                if let Some(v) = args.next() {
                    label = v;
                }
            }
            "--output" => {
                if let Some(v) = args.next() {
                    output = PathBuf::from(v);
                }
            }
            "--iterations" => {
                if let Some(v) = args.next() {
                    iterations = v.parse::<usize>().ok().filter(|i| *i > 0).unwrap_or(25);
                }
            }
            _ => logs.push(PathBuf::from(arg)),
        }
    }

    if logs.is_empty() {
        logs.push(PathBuf::from("log1.txt"));
        logs.push(PathBuf::from("log2.txt"));
        logs.push(PathBuf::from("log3.txt"));
    }

    (label, output, logs, iterations)
}

fn main() {
    let (label, output, logs, iterations) = parse_args();

    let mut reports = Vec::new();
    for log in &logs {
        match run_one(log, iterations) {
            Ok(r) => reports.push(r),
            Err(e) => {
                eprintln!("ERROR: {e}");
                std::process::exit(1);
            }
        }
    }

    let report = render_report(&label, &reports, &logs);
    if let Some(parent) = output.parent() {
        if let Err(e) = fs::create_dir_all(parent) {
            eprintln!("ERROR: failed to create {}: {}", parent.display(), e);
            std::process::exit(1);
        }
    }
    if let Err(e) = fs::write(&output, report) {
        eprintln!("ERROR: failed to write {}: {}", output.display(), e);
        std::process::exit(1);
    }

    println!("Report written to {}", output.display());
}
