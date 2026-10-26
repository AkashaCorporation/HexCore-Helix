#include "helix/cast/SelfRefWitness.h"

#include "helix/cast/CAstNode.h"
#include "helix/cast/CExpr.h"
#include "helix/cast/CStmt.h"
#include "helix/cast/DamningDefect.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/SHA256.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>
#include <filesystem>
#include <fstream>
#include <functional>
#include <map>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>

namespace fs = std::filesystem;

namespace helix::cast {
namespace {

std::string hex(uint64_t value) {
    if (value == 0) return {};
    static constexpr char digits[] = "0123456789abcdef";
    std::string body;
    do {
        body.push_back(digits[value & 0xf]);
        value >>= 4;
    } while (value != 0);
    std::reverse(body.begin(), body.end());
    return "0x" + body;
}

std::string sha256(llvm::StringRef value) {
    llvm::SHA256 hash;
    hash.update(value);
    const auto digest = hash.final();
    static constexpr char digits[] = "0123456789abcdef";
    std::string result;
    result.reserve(64);
    for (uint8_t byte : digest) {
        result.push_back(digits[byte >> 4]);
        result.push_back(digits[byte & 0xf]);
    }
    return result;
}

std::string projectExpr(const CExpr* expr) {
    if (!expr) return "null";
    if (auto* value = llvm::dyn_cast<CIntLitExpr>(expr))
        return "int(" + std::to_string(value->value) + ")";
    if (auto* value = llvm::dyn_cast<CFloatLitExpr>(expr)) {
        std::ostringstream stream;
        stream << value->value;
        return "float(" + stream.str() + ")";
    }
    if (auto* value = llvm::dyn_cast<CStringLitExpr>(expr))
        return "string(" + sha256(value->value) + ")";
    if (auto* value = llvm::dyn_cast<CAddrLitExpr>(expr))
        return "addr(" + hex(value->addrValue) + ")";
    if (auto* value = llvm::dyn_cast<CVarRefExpr>(expr))
        return "var(" + std::to_string(value->varId) + ":" + value->varName + ")";
    if (auto* value = llvm::dyn_cast<CBinaryExpr>(expr))
        return "binary(" + std::to_string(static_cast<unsigned>(value->op)) + "," +
            projectExpr(value->lhs.get()) + "," + projectExpr(value->rhs.get()) + ")";
    if (auto* value = llvm::dyn_cast<CUnaryExpr>(expr))
        return "unary(" + std::to_string(static_cast<unsigned>(value->op)) + "," +
            projectExpr(value->operand.get()) + ")";
    if (auto* value = llvm::dyn_cast<CCastExpr>(expr))
        return "cast(" + projectExpr(value->operand.get()) + ")";
    if (auto* value = llvm::dyn_cast<CCallExpr>(expr)) {
        std::string result = "call(" + value->targetName + "@" + hex(value->targetAddr);
        for (const auto& argument : value->args) result += "," + projectExpr(argument.get());
        return result + ")";
    }
    if (auto* value = llvm::dyn_cast<CTernaryExpr>(expr))
        return "ternary(" + projectExpr(value->cond.get()) + "," +
            projectExpr(value->trueVal.get()) + "," + projectExpr(value->falseVal.get()) + ")";
    if (auto* value = llvm::dyn_cast<CSubscriptExpr>(expr))
        return "subscript(" + projectExpr(value->base.get()) + "," + projectExpr(value->index.get()) + ")";
    if (auto* value = llvm::dyn_cast<CFieldAccessExpr>(expr))
        return "field(" + projectExpr(value->base.get()) + "," + value->fieldName + "," +
            hex(value->fieldOffset) + "," + (value->isPointer ? "ptr" : "value") + ")";
    return "kind(" + std::to_string(static_cast<unsigned>(expr->getKind())) + ")";
}

bool referencesVar(const CExpr* expr, llvm::StringRef name) {
    if (!expr) return false;
    if (auto* value = llvm::dyn_cast<CVarRefExpr>(expr)) return value->varName == name;
    if (auto* value = llvm::dyn_cast<CBinaryExpr>(expr))
        return referencesVar(value->lhs.get(), name) || referencesVar(value->rhs.get(), name);
    if (auto* value = llvm::dyn_cast<CUnaryExpr>(expr)) return referencesVar(value->operand.get(), name);
    if (auto* value = llvm::dyn_cast<CCastExpr>(expr)) return referencesVar(value->operand.get(), name);
    if (auto* value = llvm::dyn_cast<CCallExpr>(expr))
        return std::any_of(value->args.begin(), value->args.end(), [&](const auto& argument) {
            return referencesVar(argument.get(), name);
        });
    if (auto* value = llvm::dyn_cast<CTernaryExpr>(expr))
        return referencesVar(value->cond.get(), name) || referencesVar(value->trueVal.get(), name) ||
            referencesVar(value->falseVal.get(), name);
    if (auto* value = llvm::dyn_cast<CSubscriptExpr>(expr))
        return referencesVar(value->base.get(), name) || referencesVar(value->index.get(), name);
    if (auto* value = llvm::dyn_cast<CFieldAccessExpr>(expr)) return referencesVar(value->base.get(), name);
    return false;
}

bool referencesVarId(const CExpr* expr, uint32_t varId) {
    if (!expr) return false;
    if (auto* value = llvm::dyn_cast<CVarRefExpr>(expr)) return value->varId == varId;
    if (auto* value = llvm::dyn_cast<CBinaryExpr>(expr))
        return referencesVarId(value->lhs.get(), varId) || referencesVarId(value->rhs.get(), varId);
    if (auto* value = llvm::dyn_cast<CUnaryExpr>(expr)) return referencesVarId(value->operand.get(), varId);
    if (auto* value = llvm::dyn_cast<CCastExpr>(expr)) return referencesVarId(value->operand.get(), varId);
    if (auto* value = llvm::dyn_cast<CCallExpr>(expr))
        return std::any_of(value->args.begin(), value->args.end(), [&](const auto& argument) {
            return referencesVarId(argument.get(), varId);
        });
    if (auto* value = llvm::dyn_cast<CTernaryExpr>(expr))
        return referencesVarId(value->cond.get(), varId) || referencesVarId(value->trueVal.get(), varId) ||
            referencesVarId(value->falseVal.get(), varId);
    if (auto* value = llvm::dyn_cast<CSubscriptExpr>(expr))
        return referencesVarId(value->base.get(), varId) || referencesVarId(value->index.get(), varId);
    if (auto* value = llvm::dyn_cast<CFieldAccessExpr>(expr)) return referencesVarId(value->base.get(), varId);
    return false;
}

std::string varNameOf(const CExpr* expr) {
    if (auto* value = llvm::dyn_cast_or_null<CVarRefExpr>(expr)) return value->varName;
    return {};
}

bool isZeroLiteral(const CExpr* expr) {
    if (auto* value = llvm::dyn_cast_or_null<CIntLitExpr>(expr)) return value->value == 0;
    return false;
}

bool isPureSelfWalk(const CExpr* expr, llvm::StringRef target) {
    const CExpr* current = expr;
    bool sawAccess = false;
    while (current) {
        if (auto* field = llvm::dyn_cast<CFieldAccessExpr>(current)) {
            sawAccess = true;
            current = field->base.get();
            continue;
        }
        if (auto* unary = llvm::dyn_cast<CUnaryExpr>(current); unary && unary->op == UnaryOp::Deref) {
            sawAccess = true;
            current = unary->operand.get();
            continue;
        }
        break;
    }
    auto* variable = llvm::dyn_cast_or_null<CVarRefExpr>(current);
    return sawAccess && variable && variable->varName == target;
}

bool isPureSelfWalkId(const CExpr* expr, uint32_t varId) {
    const CExpr* current = expr;
    bool sawAccess = false;
    while (current) {
        if (auto* field = llvm::dyn_cast<CFieldAccessExpr>(current)) {
            sawAccess = true;
            current = field->base.get();
            continue;
        }
        if (auto* unary = llvm::dyn_cast<CUnaryExpr>(current); unary && unary->op == UnaryOp::Deref) {
            sawAccess = true;
            current = unary->operand.get();
            continue;
        }
        break;
    }
    auto* variable = llvm::dyn_cast_or_null<CVarRefExpr>(current);
    return sawAccess && variable && variable->varId == varId;
}

bool isSuspicious(const CAssignStmt& assign, const CVarRefExpr& target) {
    const llvm::StringRef name = target.varName;
    const bool plainSelf = assign.compoundOp.empty() && varNameOf(assign.value.get()) == name;
    const bool selfOrAnd = (assign.compoundOp == "|=" || assign.compoundOp == "&=") &&
        varNameOf(assign.value.get()) == name;
    const bool opZero = (assign.compoundOp == "+=" || assign.compoundOp == "-=" ||
        assign.compoundOp == "|=" || assign.compoundOp == "^=") && isZeroLiteral(assign.value.get());
    const bool canonicalIncDec = assign.compoundOp == "++" || assign.compoundOp == "--";
    return !plainSelf && !selfOrAnd && !opZero && !canonicalIncDec &&
        referencesVar(assign.value.get(), name) && !isPureSelfWalk(assign.value.get(), name) &&
        !helix::cast::detail::isConditionalPreserveUpdate(assign.value.get(), name);
}

bool isSuspiciousIdentity(const CAssignStmt& assign, const CVarRefExpr& target) {
    const bool plainSelf = assign.compoundOp.empty() &&
        llvm::isa_and_nonnull<CVarRefExpr>(assign.value.get()) &&
        llvm::cast<CVarRefExpr>(assign.value.get())->varId == target.varId;
    const bool selfOrAnd = (assign.compoundOp == "|=" || assign.compoundOp == "&=") &&
        llvm::isa_and_nonnull<CVarRefExpr>(assign.value.get()) &&
        llvm::cast<CVarRefExpr>(assign.value.get())->varId == target.varId;
    const bool opZero = (assign.compoundOp == "+=" || assign.compoundOp == "-=" ||
        assign.compoundOp == "|=" || assign.compoundOp == "^=") && isZeroLiteral(assign.value.get());
    const bool canonicalIncDec = assign.compoundOp == "++" || assign.compoundOp == "--";
    return !plainSelf && !selfOrAnd && !opZero && !canonicalIncDec &&
        referencesVarId(assign.value.get(), target.varId) &&
        !isPureSelfWalkId(assign.value.get(), target.varId);
}

llvm::json::Object snapshotJson(const SelfRefObservation& observation) {
    llvm::json::Object result;
    result["path"] = observation.statementPath;
    result["projection"] = observation.targetProjection +
        (observation.compoundOp.empty() ? "=" : observation.compoundOp) + observation.valueProjection;
    result["snapshotSha256"] = observation.snapshotSha256;
    return result;
}

llvm::json::Object unavailableStage() {
    llvm::json::Object value;
    value["status"] = "not-collected";
    value["defOp"] = nullptr;
    value["useOp"] = nullptr;
    value["regName"] = nullptr;
    value["snapshotSha256"] = nullptr;
    return value;
}

} // namespace

std::string SelfRefObservation::matchKey() const {
    return std::to_string(sourceAddress) + ":" + std::to_string(targetVarId) + ":" +
        targetName + ":" + std::to_string(ordinal);
}

std::string SelfRefObservation::identityKey() const {
    return std::to_string(sourceAddress) + ":" + std::to_string(targetVarId) + ":" +
        statementPath;
}

static std::vector<SelfRefObservation> collectObservations(
    const CFuncDecl& func,
    unsigned mode) {
    std::vector<SelfRefObservation> result;
    std::unordered_map<std::string, unsigned> ordinals;
    std::function<void(const CStmt*, const std::string&)> visit;
    std::function<void(const std::vector<StmtPtr>&, const std::string&)> visitList =
        [&](const std::vector<StmtPtr>& statements, const std::string& prefix) {
            for (size_t index = 0; index < statements.size(); ++index)
                visit(statements[index].get(), prefix + "/" + std::to_string(index));
        };
    visit = [&](const CStmt* statement, const std::string& statementPath) {
        if (!statement) return;
        if (auto* assign = llvm::dyn_cast<CAssignStmt>(statement)) {
            auto* target = llvm::dyn_cast_or_null<CVarRefExpr>(assign->target.get());
			const bool accepted = target && (mode == 2 ||
				(mode == 1 ? isSuspiciousIdentity(*assign, *target) : isSuspicious(*assign, *target)));
            if (accepted) {
                const std::string ordinalKey = std::to_string(assign->getAddress()) + ":" +
					std::to_string(target->varId) + ":" + (mode == 0 ? target->varName : std::string{});
                const unsigned ordinal = ordinals[ordinalKey]++;
                const std::string targetProjection = projectExpr(assign->target.get());
                const std::string valueProjection = projectExpr(assign->value.get());
                const std::string projection = targetProjection +
                    (assign->compoundOp.empty() ? "=" : assign->compoundOp) + valueProjection;
                result.push_back(SelfRefObservation{
                    .functionEntry = func.entryAddr,
                    .functionName = func.name,
                    .sourceAddress = assign->getAddress(),
                    .anchorAddress = assign->getAddress() != 0 ? assign->getAddress() :
                        (assign->value ? assign->value->getAddress() : 0),
                    .targetVarId = target->varId,
                    .targetName = target->varName,
                    .compoundOp = assign->compoundOp,
                    .statementPath = statementPath,
                    .targetProjection = targetProjection,
                    .valueProjection = valueProjection,
                    .snapshotSha256 = sha256(projection),
                    .ordinal = ordinal,
					.identitySelfDependent = isSuspiciousIdentity(*assign, *target),
                });
            }
            return;
        }
        if (auto* value = llvm::dyn_cast<CIfStmt>(statement)) {
            visitList(value->thenBody, statementPath + "/then");
            visitList(value->elseBody, statementPath + "/else");
        } else if (auto* value = llvm::dyn_cast<CWhileStmt>(statement)) {
            visitList(value->body, statementPath + "/while");
        } else if (auto* value = llvm::dyn_cast<CDoWhileStmt>(statement)) {
            visitList(value->body, statementPath + "/do");
        } else if (auto* value = llvm::dyn_cast<CForStmt>(statement)) {
            visit(value->init.get(), statementPath + "/for-init");
            visit(value->step.get(), statementPath + "/for-step");
            visitList(value->body, statementPath + "/for-body");
        } else if (auto* value = llvm::dyn_cast<CSwitchStmt>(statement)) {
            for (size_t index = 0; index < value->cases.size(); ++index)
                visitList(value->cases[index].body, statementPath + "/case/" + std::to_string(index));
        } else if (auto* value = llvm::dyn_cast<CBlockStmt>(statement)) {
            visitList(value->stmts, statementPath + "/block");
        }
    };
    visitList(func.body, "body");
    return result;
}

std::vector<SelfRefObservation> collectSelfRefObservations(const CFuncDecl& func) {
    return collectObservations(func, 0);
}

std::vector<SelfRefObservation> collectSelfRefIdentityObservations(const CFuncDecl& func) {
    return collectObservations(func, 1);
}

std::vector<SelfRefObservation> collectAssignmentObservations(const CFuncDecl& func) {
    return collectObservations(func, 2);
}

bool writeSelfRefWitnessReport(
    const fs::path& path,
    const std::vector<SelfRefFunctionWitnesses>& functions,
    std::string& error) {
    llvm::json::Array functionArray;
    unsigned totalBefore = 0;
    unsigned totalIdentityBefore = 0;
    unsigned totalAfter = 0;
    for (const auto& function : functions) {
        totalBefore += static_cast<unsigned>(function.beforeOptimizer.size());
        totalIdentityBefore += static_cast<unsigned>(function.identityBeforeOptimizer.size());
        totalAfter += static_cast<unsigned>(function.afterOptimizer.size());
        std::unordered_map<std::string, const SelfRefObservation*> beforeByKey;
        for (const auto& observation : function.beforeOptimizer)
            beforeByKey.emplace(observation.matchKey(), &observation);
		std::unordered_map<std::string, const SelfRefObservation*> identityBeforeByKey;
		for (const auto& observation : function.identityBeforeOptimizer)
			identityBeforeByKey.emplace(observation.identityKey(), &observation);

        llvm::json::Array witnesses;
        for (const auto& after : function.afterOptimizer) {
            const auto found = beforeByKey.find(after.matchKey());
            const SelfRefObservation* before = found == beforeByKey.end() ? nullptr : found->second;
			const auto pass = function.firstSeenPassByKey.find(after.matchKey());
			const auto identityBefore = identityBeforeByKey.find(after.identityKey());
			const SelfRefObservation* identityAtEntry = identityBefore == identityBeforeByKey.end()
				? nullptr : identityBefore->second;
			const auto immediatelyBefore = function.identityBeforeFirstVisibleByKey.find(after.matchKey());
			const SelfRefObservation* identityBeforeVisible = immediatelyBefore == function.identityBeforeFirstVisibleByKey.end()
				? nullptr : &immediatelyBefore->second;
			const auto priorAssignment = function.assignmentBeforeFirstVisibleByKey.find(after.matchKey());
			const SelfRefObservation* assignmentBeforeVisible = priorAssignment == function.assignmentBeforeFirstVisibleByKey.end()
				? nullptr : &priorAssignment->second;
			const SelfRefObservation* earliestIdentity = identityAtEntry ? identityAtEntry : identityBeforeVisible;
            const std::string witnessSeed = std::to_string(function.functionEntry) + ":" +
                after.matchKey() + ":" + after.snapshotSha256;
            llvm::json::Object witness;
            witness["witnessId"] = "sha256:" + sha256(witnessSeed);
            witness["sourceAddress"] = after.sourceAddress ? llvm::json::Value(hex(after.sourceAddress)) : llvm::json::Value(nullptr);
            witness["anchorAddress"] = after.anchorAddress ? llvm::json::Value(hex(after.anchorAddress)) : llvm::json::Value(nullptr);
            witness["hastNodeId"] = nullptr;
            witness["variableIdentityId"] = "var:" + std::to_string(after.targetVarId) + ":" + after.targetName;
            witness["ssaBeforeLowToMid"] = unavailableStage();
            witness["midBeforeHigh"] = unavailableStage();
            witness["highBeforeCAst"] = unavailableStage();
			witness["cAstBeforeOpt"] = before ? llvm::json::Value(snapshotJson(*before)) :
				identityAtEntry ? llvm::json::Value(snapshotJson(*identityAtEntry)) : llvm::json::Value(nullptr);
			witness["cAstBeforeFirstVisible"] = assignmentBeforeVisible
				? llvm::json::Value(snapshotJson(*assignmentBeforeVisible)) : llvm::json::Value(nullptr);
			witness["identityDependencyBeforeFirstVisible"] = identityBeforeVisible != nullptr;
			witness["identityDependencyAtOptimizerEntry"] = before
				? llvm::json::Value(before->identitySelfDependent)
				: identityAtEntry ? llvm::json::Value(true) : llvm::json::Value(nullptr);
            witness["cAstAfterOpt"] = snapshotJson(after);
			witness["firstMergingPass"] = (before || identityAtEntry) ? "before_c_ast_optimizer" :
				earliestIdentity && pass != function.firstSeenPassByKey.end()
					? "identity_precedes_" + pass->second :
					assignmentBeforeVisible && pass != function.firstSeenPassByKey.end()
						? pass->second : "c_ast_optimizer_interval_unknown";
			witness["firstVisiblePass"] = before ? "before_c_ast_optimizer" :
				pass != function.firstSeenPassByKey.end() ? pass->second : "unknown";
			witness["category"] = earliestIdentity || before ? "suspicious_dependency" :
				assignmentBeforeVisible ? "rename_collision" : "unresolved";
            witness["compoundOp"] = after.compoundOp;
            witness["targetName"] = after.targetName;
            witnesses.push_back(std::move(witness));
        }
        llvm::json::Object functionObject;
        functionObject["entryAddress"] = hex(function.functionEntry);
        functionObject["name"] = function.functionName;
        functionObject["beforeOptimizerCount"] = static_cast<uint64_t>(function.beforeOptimizer.size());
		functionObject["identityBeforeOptimizerCount"] = static_cast<uint64_t>(function.identityBeforeOptimizer.size());
        functionObject["afterOptimizerCount"] = static_cast<uint64_t>(function.afterOptimizer.size());
        functionObject["witnesses"] = std::move(witnesses);
        functionArray.push_back(std::move(functionObject));
    }

    llvm::json::Object coverage;
    coverage["lowToMid"] = false;
    coverage["midToHigh"] = false;
    coverage["highToCAst"] = false;
    coverage["cAstBeforeOptimizer"] = true;
    coverage["cAstAfterOptimizer"] = true;
    coverage["hastNodeBinding"] = false;

    llvm::json::Object root;
    root["schemaVersion"] = 1;
    root["kind"] = "helix-self-reference-witnesses";
    root["stageCoverage"] = std::move(coverage);
    root["totalBeforeOptimizer"] = totalBefore;
	root["totalIdentityBeforeOptimizer"] = totalIdentityBefore;
    root["totalAfterOptimizer"] = totalAfter;
    root["functions"] = std::move(functionArray);

    std::error_code ec;
    if (path.has_parent_path()) fs::create_directories(path.parent_path(), ec);
    if (ec) {
        error = "cannot create witness directory: " + ec.message();
        return false;
    }
    std::ofstream output(path, std::ios::binary);
    if (!output) {
        error = "cannot open witness report: " + path.string();
        return false;
    }
    std::string json;
    llvm::raw_string_ostream stream(json);
    stream << llvm::json::Value(std::move(root)) << '\n';
    stream.flush();
    output.write(json.data(), static_cast<std::streamsize>(json.size()));
    if (!output.good()) {
        error = "cannot write witness report: " + path.string();
        return false;
    }
    return true;
}

} // namespace helix::cast
