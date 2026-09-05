#pragma once

#include "mlir/Pass/PassInstrumentation.h"

#include <filesystem>
#include <memory>
#include <mutex>
#include <optional>
#include <string>

namespace helix {

struct VerifyAuditFailure {
    std::string pass_name;
    std::string reason;
    std::filesystem::path before_path;
    std::filesystem::path after_path;
};

class VerifyAuditState {
public:
    void beginRun(const std::filesystem::path& root_directory);
    [[nodiscard]] size_t nextSequence();
    [[nodiscard]] std::filesystem::path runDirectory() const;
    void recordFailure(VerifyAuditFailure failure);
    [[nodiscard]] std::optional<VerifyAuditFailure> firstFailure() const;

private:
    mutable std::mutex mutex_;
    std::filesystem::path run_directory_;
    std::optional<VerifyAuditFailure> first_failure_;
    size_t sequence_ = 0;
};

[[nodiscard]] std::unique_ptr<mlir::PassInstrumentation>
createVerifyAuditInstrumentation(std::shared_ptr<VerifyAuditState> state);

[[nodiscard]] bool verifyAuditEnabledFromEnvironment();
[[nodiscard]] std::filesystem::path verifyAuditRootFromEnvironment();

} // namespace helix
