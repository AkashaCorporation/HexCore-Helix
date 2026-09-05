#include "helix/diagnostics/VerifyAudit.h"

#include "mlir/IR/Operation.h"
#include "mlir/IR/Verifier.h"
#include "mlir/Pass/Pass.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Process.h"
#include "llvm/Support/raw_ostream.h"

#include <atomic>
#include <cctype>
#include <cstdlib>
#include <format>
#include <unordered_map>

namespace helix {
namespace {

std::atomic<uint64_t> g_verify_run_id{0};

bool environmentFlagEnabled(const char* name) {
    const char* value = std::getenv(name);
    return value && value[0] != '\0' && std::string_view(value) != "0";
}

std::string sanitizeName(llvm::StringRef name) {
    std::string result;
    result.reserve(name.size());
    for (char ch : name) {
        const unsigned char byte = static_cast<unsigned char>(ch);
        result.push_back(std::isalnum(byte) || ch == '-' || ch == '_'
            ? ch
            : '_');
    }
    return result.empty() ? "unnamed-pass" : result;
}

void dumpOperation(mlir::Operation* operation,
                   const std::filesystem::path& path,
                   llvm::StringRef banner) {
    std::error_code error;
    llvm::raw_fd_ostream stream(path.string(), error, llvm::sys::fs::OF_Text);
    if (error)
        return;
    stream << "// " << banner << "\n";
    operation->print(stream);
    stream << '\n';
}

struct PassFrame {
    size_t sequence = 0;
    std::string name;
    std::filesystem::path before_path;
};

class VerifyAuditInstrumentation final : public mlir::PassInstrumentation {
public:
    explicit VerifyAuditInstrumentation(std::shared_ptr<VerifyAuditState> state)
        : state_(std::move(state)) {}

    void runBeforePass(mlir::Pass* pass, mlir::Operation* operation) override {
        const size_t sequence = state_->nextSequence();
        const std::string name = sanitizeName(pass->getName());
        const auto prefix = std::format("{:03}_{}", sequence, name);
        PassFrame frame{
            sequence,
            name,
            state_->runDirectory() / (prefix + "_before.mlir"),
        };
        dumpOperation(operation, frame.before_path,
                      std::format("before pass {}", pass->getName().str()));
        frames_[pass] = std::move(frame);
    }

    void runAfterPass(mlir::Pass* pass, mlir::Operation* operation) override {
        const PassFrame frame = takeFrame(pass);
        const auto after_path = state_->runDirectory() /
            std::format("{:03}_{}_after.mlir", frame.sequence, frame.name);
        dumpOperation(operation, after_path,
                      std::format("after pass {}", pass->getName().str()));
        if (mlir::failed(mlir::verify(operation))) {
            recordFirstFailure(pass, frame, after_path, "verifier-failure");
        }
    }

    void runAfterPassFailed(mlir::Pass* pass, mlir::Operation* operation) override {
        const PassFrame frame = takeFrame(pass);
        const auto after_path = state_->runDirectory() /
            std::format("{:03}_{}_failed.mlir", frame.sequence, frame.name);
        dumpOperation(operation, after_path,
                      std::format("pass signaled failure: {}", pass->getName().str()));
        const bool invalidIr = mlir::failed(mlir::verify(operation));
        recordFirstFailure(pass, frame, after_path,
                           invalidIr ? "verifier-failure"
                                     : "pass-signaled-failure");
    }

private:
    PassFrame takeFrame(mlir::Pass* pass) {
        auto iterator = frames_.find(pass);
        if (iterator == frames_.end()) {
            return PassFrame{state_->nextSequence(), sanitizeName(pass->getName()), {}};
        }
        PassFrame frame = std::move(iterator->second);
        frames_.erase(iterator);
        return frame;
    }

    void recordFirstFailure(mlir::Pass* pass,
                            const PassFrame& frame,
                            const std::filesystem::path& after_path,
                            std::string reason) {
        VerifyAuditFailure failure{
            pass->getName().str(),
            std::move(reason),
            frame.before_path,
            after_path,
        };
        state_->recordFailure(failure);
        const auto summary_path = state_->runDirectory() / "first_failure.txt";
        std::error_code error;
        llvm::raw_fd_ostream stream(summary_path.string(), error,
                                    llvm::sys::fs::OF_Text);
        if (!error) {
            stream << "pass=" << failure.pass_name << '\n'
                   << "reason=" << failure.reason << '\n'
                   << "before=" << failure.before_path.string() << '\n'
                   << "after=" << failure.after_path.string() << '\n';
        }
    }

    std::shared_ptr<VerifyAuditState> state_;
    std::unordered_map<mlir::Pass*, PassFrame> frames_;
};

} // namespace

void VerifyAuditState::beginRun(const std::filesystem::path& root_directory) {
    std::scoped_lock lock(mutex_);
    const uint64_t run_id = g_verify_run_id.fetch_add(1, std::memory_order_relaxed);
    run_directory_ = root_directory /
        std::format("run-{}-{}", llvm::sys::Process::getProcessId(), run_id);
    std::filesystem::create_directories(run_directory_);
    first_failure_.reset();
    sequence_ = 0;
}

size_t VerifyAuditState::nextSequence() {
    std::scoped_lock lock(mutex_);
    return ++sequence_;
}

std::filesystem::path VerifyAuditState::runDirectory() const {
    std::scoped_lock lock(mutex_);
    return run_directory_;
}

void VerifyAuditState::recordFailure(VerifyAuditFailure failure) {
    std::scoped_lock lock(mutex_);
    if (!first_failure_)
        first_failure_ = std::move(failure);
}

std::optional<VerifyAuditFailure> VerifyAuditState::firstFailure() const {
    std::scoped_lock lock(mutex_);
    return first_failure_;
}

std::unique_ptr<mlir::PassInstrumentation>
createVerifyAuditInstrumentation(std::shared_ptr<VerifyAuditState> state) {
    return std::make_unique<VerifyAuditInstrumentation>(std::move(state));
}

bool verifyAuditEnabledFromEnvironment() {
    return environmentFlagEnabled("HELIX_VERIFY_EACH_PASS");
}

std::filesystem::path verifyAuditRootFromEnvironment() {
    if (const char* path = std::getenv("HELIX_VERIFY_DUMP_DIR");
        path && path[0] != '\0') {
        return path;
    }
    return "helix_verify_audit";
}

} // namespace helix
