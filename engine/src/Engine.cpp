/// @file Engine.cpp
/// @brief Helix engine implementation — Phase 2 MLIR pipeline.

#include "helix/Engine.h"
#include "helix/Pipeline.h"
#include "helix/passes/Passes.h"
#include "helix/analysis/DataSectionProvider.h"
#include "helix/dialects/HelixLowDialect.h"
#include "helix/dialects/HelixMidDialect.h"     // v1.0
#include "helix/dialects/HelixHighDialect.h"

#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Dialect.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/DLTI/DLTI.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Pass/PassManager.h"

#include <cstring>
#include <cstdint>
#include <format>
#include <string_view>
#include <utility>
#include <vector>

namespace helix {

namespace {
/// RAII installer for the thread-local DataSectionProvider used by the MLIR
/// pass pipeline.  Wraps the engine's accumulated data sections in a reader
/// closure, makes it active for the current thread, and clears it on
/// destruction so a follow-up decompile on the same thread never sees stale
/// bytes from a prior run.
class ScopedDataSectionProvider {
public:
    explicit ScopedDataSectionProvider(
        const std::vector<Engine::DataSection>* sections) {
        if (!sections || sections->empty())
            return;
        // The Engine instance outlives this scope, so capturing the pointer
        // is safe — section bytes are stable for the duration of the run.
        const auto* secs = sections;
        provider_ = std::make_unique<DataSectionProvider>(
            [secs](uint64_t addr, uint8_t* buf, size_t len) -> size_t {
                for (const auto& s : *secs) {
                    if (addr < s.va_start) continue;
                    uint64_t off = addr - s.va_start;
                    if (off >= s.bytes.size()) continue;
                    size_t avail = s.bytes.size() - static_cast<size_t>(off);
                    size_t copy  = (len < avail) ? len : avail;
                    std::memcpy(buf, s.bytes.data() + off, copy);
                    return copy;
                }
                return 0;
            });
        setActiveDataSectionProvider(provider_.get());
    }

    ~ScopedDataSectionProvider() {
        if (provider_)
            setActiveDataSectionProvider(nullptr);
    }

    ScopedDataSectionProvider(const ScopedDataSectionProvider&) = delete;
    ScopedDataSectionProvider& operator=(const ScopedDataSectionProvider&) = delete;

private:
    std::unique_ptr<DataSectionProvider> provider_;
};
} // namespace

// ─── Construction ──────────────────────────────────────────────────────────────

Engine::Engine(HelixArch arch)
    : arch_(arch)
{
    // Initialize MLIR context with all required dialects.
    mlir_context_ = std::make_unique<mlir::MLIRContext>();

    // Register required dialects.
    // LLVMDialect + DLTIDialect: required by translateLLVMIRToModule()
    // HelixLow + HelixHigh: Helix pass pipeline dialects
    // cf, arith, ub, func, scf: used by passes and translation infrastructure
    mlir_context_->getOrLoadDialect<mlir::LLVM::LLVMDialect>();
    mlir_context_->getOrLoadDialect<mlir::DLTIDialect>();
    mlir_context_->getOrLoadDialect<mlir::cf::ControlFlowDialect>();
    mlir_context_->getOrLoadDialect<mlir::arith::ArithDialect>();
    mlir_context_->getOrLoadDialect<mlir::ub::UBDialect>();
    mlir_context_->getOrLoadDialect<mlir::func::FuncDialect>();
    mlir_context_->getOrLoadDialect<mlir::scf::SCFDialect>();
    mlir_context_->getOrLoadDialect<helix::low::HelixLowDialect>();
    mlir_context_->getOrLoadDialect<helix::mid::HelixMidDialect>();   // v1.0
    mlir_context_->getOrLoadDialect<helix::high::HelixHighDialect>();
    // Register all Helix passes.
    registerHelixPasses();

    // Create the decompilation pipeline.
    pipeline_ = std::make_unique<Pipeline>(mlir_context_.get(), arch, /*skip_optimization=*/false);
}

void Engine::setSkipOptimization(bool skip) {
    // Recreate pipeline with new optimization flag.
    // Safe to call before first decompile (pipeline is lazily built).
    pipeline_ = std::make_unique<Pipeline>(mlir_context_.get(), arch_, skip);
    // Re-apply preserve-cfg onto the fresh pipeline (rebuild loses state).
    if (preserve_cfg_)
        pipeline_->setPreserveCfg(true);
    if (!debug_type_info_json_.empty())
        pipeline_->setDebugTypeInfoJson(debug_type_info_json_);
}

void Engine::setPreserveCfg(bool v) {
    preserve_cfg_ = v;
    if (pipeline_)
        pipeline_->setPreserveCfg(v);
}

void Engine::enablePass(const char* name) {
    if (pipeline_ && name) {
        pipeline_->enablePass(name);
    }
}

void Engine::setUseCastLayer(bool use) {
    if (pipeline_) {
        pipeline_->setUseCastLayer(use);
    }
}

void Engine::addVariableRename(const char* old_name, const char* new_name) {
    if (pipeline_ && old_name && new_name) {
        pipeline_->addVariableRename(old_name, new_name);
    }
}

void Engine::clearVariableRenames() {
    if (pipeline_) {
        pipeline_->clearVariableRenames();
    }
}

void Engine::setFunctionStarts(const int64_t* starts, size_t len) {
    if (pipeline_ && starts && len > 0) {
        pipeline_->setFunctionStarts(starts, len);
    }
}

void Engine::setDebugTypeInfoJson(const char* json, size_t len) {
    debug_type_info_json_.assign(json ? json : "", json ? len : 0);
    if (pipeline_)
        pipeline_->setDebugTypeInfoJson(debug_type_info_json_);
}

Engine::~Engine() = default;
Engine::Engine(Engine&&) noexcept = default;
Engine& Engine::operator=(Engine&&) noexcept = default;

// ─── API ───────────────────────────────────────────────────────────────────────

const char* Engine::version() noexcept {
    return HELIX_ENGINE_VERSION;
}

HelixStatus Engine::decompile(
    const uint8_t* data,
    size_t data_len,
    uint64_t base_addr,
    uint64_t entry_addr,
    uint8_t* out_buf,
    size_t* out_len)
{
    // Input validation
    if (!data || data_len == 0) {
        last_error_ = "Input data is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (!out_buf || !out_len || *out_len == 0) {
        last_error_ = "Output buffer is null or has zero capacity";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (entry_addr < base_addr) {
        last_error_ = std::format(
            "Entry address 0x{:x} is outside the data range [0x{:x}, 0x{:x})",
            entry_addr, base_addr, base_addr + data_len
        );
        return HELIX_ERROR_INVALID_INPUT;
    }

    const uint64_t entry_offset = entry_addr - base_addr;
    if (entry_offset >= data_len) {
        last_error_ = std::format(
            "Entry address 0x{:x} is outside the data range [0x{:x}, 0x{:x})",
            entry_addr, base_addr, base_addr + data_len
        );
        return HELIX_ERROR_INVALID_INPUT;
    }

    // Phase 2 stub for binary input: needs Remill lifter integration.
    last_error_ = "Binary decompilation requires Remill lifter. Use decompileIR() with LLVM IR text.";
    return HELIX_ERROR_INTERNAL;
}

HelixStatus Engine::decompileIR(
    const char* ir_text,
    size_t ir_len,
    uint8_t* out_buf,
    size_t* out_len)
{
    // Input validation
    if (!ir_text || ir_len == 0) {
        last_error_ = "IR text is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (!out_buf || !out_len || *out_len == 0) {
        last_error_ = "Output buffer is null or has zero capacity";
        return HELIX_ERROR_INVALID_INPUT;
    }

    DecompileOutput output;
    HelixStatus status = decompileIRCombined(ir_text, ir_len, output);
    if (status != HELIX_OK)
        return status;

    // Copy FlatBuffer output to the caller's buffer.
    auto& flatbuf = output.flatbuffer;

    if (*out_len < flatbuf.size()) {
        last_error_ = std::format(
            "Output buffer too small: need {} bytes, have {}",
            flatbuf.size(), *out_len);
        *out_len = flatbuf.size();
        return HELIX_ERROR_OUT_OF_MEMORY;
    }

    std::memcpy(out_buf, flatbuf.data(), flatbuf.size());
    *out_len = flatbuf.size();
    last_error_.clear();

    return HELIX_OK;
}

HelixStatus Engine::decompileIRText(
    const char* ir_text,
    size_t ir_len,
    char* out_buf,
    size_t* out_len)
{
    // Input validation
    if (!ir_text || ir_len == 0) {
        last_error_ = "IR text is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    if (!out_buf || !out_len || *out_len == 0) {
        last_error_ = "Output buffer is null or has zero capacity";
        return HELIX_ERROR_INVALID_INPUT;
    }

    DecompileOutput output;
    HelixStatus status = decompileIRCombined(ir_text, ir_len, output);
    if (status != HELIX_OK)
        return status;

    // Copy pseudo-C text to the caller's buffer.
    auto& pseudo_c = output.pseudo_c;
    size_t needed = pseudo_c.size() + 1;  // +1 for null terminator

    if (*out_len < needed) {
        last_error_ = std::format(
            "Output buffer too small: need {} bytes, have {}",
            needed, *out_len);
        *out_len = needed;
        return HELIX_ERROR_OUT_OF_MEMORY;
    }

    std::memcpy(out_buf, pseudo_c.data(), pseudo_c.size());
    out_buf[pseudo_c.size()] = '\0';
    *out_len = needed;
    last_error_.clear();

    return HELIX_OK;
}

HelixStatus Engine::decompileIRCombined(
    const char* ir_text,
    size_t ir_len,
    DecompileOutput& output)
{
    output = {};
    if (!ir_text || ir_len == 0) {
        last_error_ = "IR text is null or empty";
        return HELIX_ERROR_INVALID_INPUT;
    }

    // MLIR can recurse deeply on large IR inputs. Native tools and Rust/N-API
    // callers must retain the documented 16 MiB worker-stack contract.
    parseHelixStringsMetadata(ir_text, ir_len);
    ScopedDataSectionProvider scopedProvider(&data_sections_);
    auto result = pipeline_->decompile(llvm::StringRef(ir_text, ir_len));
    if (!result) {
        last_error_ = result.error();
        return HELIX_ERROR_INTERNAL;
    }

    output = std::move(*result);
    last_error_.clear();
    return HELIX_OK;
}

void Engine::parseHelixStringsMetadata(const char* ir_text, size_t ir_len) {
    if (!ir_text || ir_len == 0)
        return;
    std::string_view ir(ir_text, ir_len);

    // Named metadata emitted by the disassembler: `!helix.strings = !{!N, ...}`
    constexpr std::string_view kTag = "!helix.strings";
    size_t tagPos = ir.find(kTag);
    if (tagPos == std::string_view::npos)
        return;
    size_t brace = ir.find('{', tagPos);
    size_t braceEnd = (brace == std::string_view::npos)
        ? std::string_view::npos : ir.find('}', brace);
    if (braceEnd == std::string_view::npos)
        return;
    std::string_view refList = ir.substr(brace + 1, braceEnd - brace - 1);

    // Collect referenced node ids (e.g. 90000) in `!{!90000, !90001}`.
    std::vector<std::string> nodeIds;
    for (size_t i = 0; i < refList.size();) {
        size_t bang = refList.find('!', i);
        if (bang == std::string_view::npos)
            break;
        size_t j = bang + 1;
        std::string id;
        while (j < refList.size() && refList[j] >= '0' && refList[j] <= '9')
            id.push_back(refList[j++]);
        if (!id.empty())
            nodeIds.push_back(std::move(id));
        i = j;
    }

    auto hexVal = [](char c) -> int {
        if (c >= '0' && c <= '9') return c - '0';
        if (c >= 'a' && c <= 'f') return c - 'a' + 10;
        if (c >= 'A' && c <= 'F') return c - 'A' + 10;
        return -1;
    };

    // Each node: `!<id> = !{i64 <addr>, !"<\HH-escaped bytes>"}`.
    for (const auto& id : nodeIds) {
        std::string needle = "!" + id + " = ";
        size_t p = ir.find(needle);
        if (p == std::string_view::npos)
            continue;
        size_t i64p = ir.find("i64", p);
        if (i64p == std::string_view::npos)
            continue;
        i64p += 3;
        while (i64p < ir.size() && (ir[i64p] == ' ' || ir[i64p] == '\t'))
            ++i64p;
        uint64_t addr = 0;
        bool any = false;
        while (i64p < ir.size() && ir[i64p] >= '0' && ir[i64p] <= '9') {
            addr = addr * 10 + static_cast<uint64_t>(ir[i64p] - '0');
            ++i64p;
            any = true;
        }
        if (!any)
            continue;
        size_t q = ir.find("!\"", i64p);
        if (q == std::string_view::npos)
            continue;
        q += 2;
        std::vector<uint8_t> bytes;
        while (q < ir.size() && ir[q] != '"') {
            char c = ir[q];
            if (c == '\\' && q + 2 < ir.size()) {
                int hi = hexVal(ir[q + 1]);
                int lo = hexVal(ir[q + 2]);
                if (hi >= 0 && lo >= 0) {
                    bytes.push_back(static_cast<uint8_t>((hi << 4) | lo));
                    q += 3;
                    continue;
                }
            }
            bytes.push_back(static_cast<uint8_t>(c));
            ++q;
        }
        if (!bytes.empty())
            addDataSection(addr, bytes.data(), bytes.size());
    }
}

void Engine::addDataSection(uint64_t va_start, const uint8_t* bytes, size_t len) {
    if (!bytes || len == 0)
        return;
    data_sections_.push_back(DataSection{
        va_start,
        std::vector<uint8_t>(bytes, bytes + len)
    });
}

void Engine::clearDataSections() {
    data_sections_.clear();
}

const char* Engine::lastError() const noexcept {
    return last_error_.empty() ? nullptr : last_error_.c_str();
}

} // namespace helix
