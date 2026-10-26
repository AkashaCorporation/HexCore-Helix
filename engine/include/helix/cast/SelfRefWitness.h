#pragma once

#include "helix/cast/CDecl.h"

#include <cstdint>
#include <filesystem>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

namespace helix::cast {

struct SelfRefObservation {
    uint64_t functionEntry = 0;
    std::string functionName;
    uint64_t sourceAddress = 0;
    uint64_t anchorAddress = 0;
    uint32_t targetVarId = 0;
    std::string targetName;
    std::string compoundOp;
    std::string statementPath;
    std::string targetProjection;
    std::string valueProjection;
    std::string snapshotSha256;
    unsigned ordinal = 0;
    bool identitySelfDependent = false;

    [[nodiscard]] std::string matchKey() const;
    [[nodiscard]] std::string identityKey() const;
};

struct SelfRefFunctionWitnesses {
    uint64_t functionEntry = 0;
    std::string functionName;
    std::vector<SelfRefObservation> beforeOptimizer;
    std::vector<SelfRefObservation> identityBeforeOptimizer;
    std::vector<SelfRefObservation> afterOptimizer;
    std::unordered_map<std::string, std::string> firstSeenPassByKey;
    std::unordered_map<std::string, SelfRefObservation> identityBeforeFirstVisibleByKey;
    std::unordered_map<std::string, SelfRefObservation> assignmentBeforeFirstVisibleByKey;
};

/// Collect exactly the suspicious self-reference predicate used by the final
/// confidence gate, without mutating the AST.
std::vector<SelfRefObservation> collectSelfRefObservations(const CFuncDecl& func);

/// Broader audit predicate keyed by stable varId instead of spelling. This is
/// evidence only and never changes the production confidence counter.
std::vector<SelfRefObservation> collectSelfRefIdentityObservations(const CFuncDecl& func);

/// All plain-variable assignments, used only to capture the immediate
/// pre-pass shape when a name-based self-reference first becomes visible.
std::vector<SelfRefObservation> collectAssignmentObservations(const CFuncDecl& func);

/// Persist pre/post C-AST observations for an explicit audit run. Missing
/// Low/Mid/High snapshots remain explicit `not-collected`, never inferred.
bool writeSelfRefWitnessReport(
    const std::filesystem::path& path,
    const std::vector<SelfRefFunctionWitnesses>& functions,
    std::string& error);

} // namespace helix::cast
