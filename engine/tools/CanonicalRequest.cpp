#include "CanonicalRequest.h"

#include "helix/Engine.h"
#include "helix/Types.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/SHA256.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <optional>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

namespace fs = std::filesystem;

namespace {

struct DataSection {
    uint64_t va = 0;
    std::vector<uint8_t> bytes;
};

struct VariableRename {
    std::string oldName;
    std::string newName;
};

struct CanonicalRequest {
    std::string requestHash;
    std::string irText;
    int architecture = HELIX_ARCH_X86_64;
    bool useCastLayer = true;
    bool skipOptimization = false;
    std::vector<int64_t> functionStarts;
    std::vector<DataSection> dataSections;
    std::vector<VariableRename> variableRenames;
    std::string debugTypeInfoJson;
};

std::string readFile(const fs::path& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) return {};
    std::ostringstream stream;
    stream << input.rdbuf();
    return stream.str();
}

bool writeFile(const fs::path& path, const void* data, size_t size) {
    std::error_code ec;
    if (path.has_parent_path()) fs::create_directories(path.parent_path(), ec);
    if (ec) return false;
    std::ofstream output(path, std::ios::binary);
    if (!output) return false;
    output.write(static_cast<const char*>(data), static_cast<std::streamsize>(size));
    return output.good();
}

std::string sha256(llvm::StringRef bytes) {
    llvm::SHA256 hash;
    hash.update(bytes);
    const auto digest = hash.final();
    static constexpr char digits[] = "0123456789abcdef";
    std::string result;
    result.reserve(digest.size() * 2);
    for (uint8_t byte : digest) {
        result.push_back(digits[byte >> 4]);
        result.push_back(digits[byte & 0xf]);
    }
    return result;
}

std::string quoteJson(llvm::StringRef value) {
    std::string result;
    llvm::raw_string_ostream output(result);
    output << llvm::json::Value(value);
    output.flush();
    return result;
}

bool appendCanonical(const llvm::json::Value& value, std::string& output, std::string& error) {
    switch (value.kind()) {
    case llvm::json::Value::Null:
        output += "null";
        return true;
    case llvm::json::Value::Boolean:
        output += *value.getAsBoolean() ? "true" : "false";
        return true;
    case llvm::json::Value::String:
        output += quoteJson(*value.getAsString());
        return true;
    case llvm::json::Value::Number:
        error = "semanticRequest contains a forbidden JSON number";
        return false;
    case llvm::json::Value::Array: {
        output.push_back('[');
        bool first = true;
        for (const auto& item : *value.getAsArray()) {
            if (!first) output.push_back(',');
            first = false;
            if (!appendCanonical(item, output, error)) return false;
        }
        output.push_back(']');
        return true;
    }
    case llvm::json::Value::Object: {
        std::vector<std::string> keys;
        const auto* object = value.getAsObject();
        keys.reserve(object->size());
        for (const auto& item : *object) keys.push_back(item.first.str());
        std::sort(keys.begin(), keys.end());
        output.push_back('{');
        bool first = true;
        for (const auto& key : keys) {
            if (!first) output.push_back(',');
            first = false;
            output += quoteJson(key);
            output.push_back(':');
            const auto* item = object->get(key);
            if (!item || !appendCanonical(*item, output, error)) return false;
        }
        output.push_back('}');
        return true;
    }
    }
    error = "semanticRequest contains an unsupported JSON value";
    return false;
}

bool isLowerSha256(llvm::StringRef value) {
    if (value.size() != 64) return false;
    return std::all_of(value.begin(), value.end(), [](char ch) {
        return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f');
    });
}

bool parseCanonicalHex(llvm::StringRef value, uint64_t& parsed) {
    if (!value.starts_with("0x") || value.size() < 3) return false;
    const llvm::StringRef digits = value.drop_front(2);
    if (digits.size() > 1 && digits.front() == '0') return false;
    if (!std::all_of(digits.begin(), digits.end(), [](char ch) {
            return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f');
        })) return false;
    return !digits.getAsInteger(16, parsed);
}

bool parseIrHex(llvm::StringRef value, uint64_t& parsed) {
    if (!(value.starts_with("0x") || value.starts_with("0X")) || value.size() < 3) return false;
    return !value.drop_front(2).getAsInteger(16, parsed);
}

bool parseIrRange(
    llvm::StringRef ir,
    uint64_t& start,
    uint64_t& end,
    std::string& sourceHash) {
    constexpr llvm::StringLiteral prefix = "; RequestedByteRange: [";
    const size_t lineStart = ir.find(prefix);
    if (lineStart == llvm::StringRef::npos) return false;
    const size_t lineEnd = ir.find('\n', lineStart);
    const llvm::StringRef line = ir.slice(lineStart, lineEnd);
    const size_t startOffset = prefix.size();
    const size_t comma = line.find(", ", startOffset);
    const size_t close = line.find(')', comma == llvm::StringRef::npos ? startOffset : comma + 2);
    constexpr llvm::StringLiteral hashPrefix = "sourceSha256=";
    const size_t hashOffset = line.find(hashPrefix);
    if (comma == llvm::StringRef::npos || close == llvm::StringRef::npos ||
        hashOffset == llvm::StringRef::npos ||
        !parseIrHex(line.slice(startOffset, comma), start) ||
        !parseIrHex(line.slice(comma + 2, close), end)) return false;
    const llvm::StringRef hash = line.slice(hashOffset + hashPrefix.size(), hashOffset + hashPrefix.size() + 64);
    if (!isLowerSha256(hash)) return false;
    sourceHash = hash.str();
    return end > start;
}

fs::path resolveArtifact(const fs::path& requestPath, llvm::StringRef artifactPath) {
    fs::path resolved{artifactPath.str()};
    return resolved.is_absolute() ? resolved.lexically_normal()
                                  : (requestPath.parent_path() / resolved).lexically_normal();
}

std::optional<std::string> requiredString(
    const llvm::json::Object& object,
    llvm::StringRef key,
    std::string& error) {
    auto value = object.getString(key);
    if (!value || value->empty()) {
        error = "missing or invalid string field: " + key.str();
        return std::nullopt;
    }
    return value->str();
}

const llvm::json::Object* requiredObject(
    const llvm::json::Object& object,
    llvm::StringRef key,
    std::string& error) {
    const auto* value = object.getObject(key);
    if (!value) error = "missing or invalid object field: " + key.str();
    return value;
}

const llvm::json::Array* requiredArray(
    const llvm::json::Object& object,
    llvm::StringRef key,
    std::string& error) {
    const auto* value = object.getArray(key);
    if (!value) error = "missing or invalid array field: " + key.str();
    return value;
}

bool loadAndVerifyArtifact(
    const fs::path& requestPath,
    const llvm::json::Object& artifact,
    std::string& bytes,
    std::string& digest,
    std::string& error) {
    const auto artifactPath = requiredString(artifact, "path", error);
    const auto expectedHash = requiredString(artifact, "sha256", error);
    if (!artifactPath || !expectedHash || !isLowerSha256(*expectedHash)) {
        if (error.empty()) error = "artifact SHA-256 must be lowercase hex";
        return false;
    }
    const fs::path resolved = resolveArtifact(requestPath, *artifactPath);
    bytes = readFile(resolved);
    if (bytes.empty() && (!fs::exists(resolved) || fs::file_size(resolved) != 0)) {
        error = "cannot read artifact: " + resolved.string();
        return false;
    }
    digest = sha256(bytes);
    if (digest != *expectedHash) {
        error = "artifact SHA-256 mismatch: " + resolved.string();
        return false;
    }
    return true;
}

int architectureFromName(llvm::StringRef name) {
    if (name == "x86_64") return HELIX_ARCH_X86_64;
    if (name == "x86") return HELIX_ARCH_X86;
    if (name == "aarch64") return HELIX_ARCH_AARCH64;
    if (name == "arm") return HELIX_ARCH_ARM;
    if (name == "mips") return HELIX_ARCH_MIPS;
    if (name == "mips64") return HELIX_ARCH_MIPS64;
    return -1;
}

bool loadCanonicalRequest(
    const fs::path& requestPath,
    CanonicalRequest& request,
    std::string& error) {
    const std::string requestText = readFile(requestPath);
    if (requestText.empty()) {
        error = "cannot read canonical request";
        return false;
    }
    auto parsed = llvm::json::parse(requestText);
    if (!parsed) {
        llvm::raw_string_ostream stream(error);
        llvm::logAllUnhandledErrors(parsed.takeError(), stream, "invalid canonical request: ");
        stream.flush();
        return false;
    }
    const auto* root = parsed->getAsObject();
    if (!root || root->getInteger("schemaVersion") != 1) {
        error = "unsupported canonical request schema";
        return false;
    }
    const auto requestHash = requiredString(*root, "requestHash", error);
    const auto* semanticValue = root->get("semanticRequest");
    const auto* semantic = semanticValue ? semanticValue->getAsObject() : nullptr;
    const auto* artifacts = requiredObject(*root, "artifacts", error);
    if (!requestHash || !semanticValue || !semantic || !artifacts) return false;
    std::string canonical;
    if (!appendCanonical(*semanticValue, canonical, error)) return false;
    const std::string computedHash = "sha256:" + sha256(canonical);
    if (*requestHash != computedHash) {
        error = "canonical requestHash mismatch";
        return false;
    }
    request.requestHash = *requestHash;

    const auto* semanticTarget = requiredObject(*semantic, "target", error);
    const auto* targetArtifact = requiredObject(*artifacts, "target", error);
    if (!semanticTarget || !targetArtifact) return false;
    std::string targetBytes;
    std::string targetHash;
    if (!loadAndVerifyArtifact(requestPath, *targetArtifact, targetBytes, targetHash, error)) return false;
    const auto semanticTargetHash = requiredString(*semanticTarget, "sha256", error);
    const auto archName = requiredString(*semanticTarget, "arch", error);
    if (!semanticTargetHash || !archName || *semanticTargetHash != targetHash) {
        if (error.empty()) error = "target semantic/artifact identity mismatch";
        return false;
    }
    request.architecture = architectureFromName(*archName);
    if (request.architecture < 0) {
        error = "unsupported canonical request architecture";
        return false;
    }

    const auto* semanticInput = requiredObject(*semantic, "input", error);
    const auto* irArtifact = requiredObject(*artifacts, "ir", error);
    if (!semanticInput || !irArtifact) return false;
    std::string irHash;
    if (!loadAndVerifyArtifact(requestPath, *irArtifact, request.irText, irHash, error)) return false;
    const auto semanticIrHash = requiredString(*semanticInput, "irSha256", error);
    const auto mediaType = requiredString(*semanticInput, "mediaType", error);
    if (!semanticIrHash || !mediaType || *semanticIrHash != irHash || *mediaType != "text/x-llvm") {
        if (error.empty()) error = "IR semantic/artifact identity mismatch";
        return false;
    }

    const auto* function = requiredObject(*semantic, "function", error);
    if (!function) return false;
    const auto entryText = requiredString(*function, "entryAddress", error);
    const auto endText = requiredString(*function, "endAddress", error);
    const auto lengthText = requiredString(*function, "byteLength", error);
    const auto extractedHash = requiredString(*function, "extractedBytesSha256", error);
    uint64_t entry = 0, end = 0, length = 0;
    if (!entryText || !endText || !lengthText || !extractedHash ||
        !parseCanonicalHex(*entryText, entry) || !parseCanonicalHex(*endText, end) ||
        !parseCanonicalHex(*lengthText, length) || end <= entry || end - entry != length ||
        !isLowerSha256(*extractedHash)) {
        if (error.empty()) error = "invalid canonical function range";
        return false;
    }
    uint64_t irStart = 0, irEnd = 0;
    std::string irSourceHash;
    if (!parseIrRange(request.irText, irStart, irEnd, irSourceHash) ||
        irStart != entry || irEnd != end || irSourceHash != *extractedHash) {
        error = "canonical function range differs from the retained IR";
        return false;
    }

    const auto* analysis = requiredObject(*semantic, "analysisContext", error);
    if (!analysis) return false;
    const auto* starts = requiredArray(*analysis, "functionStarts", error);
    if (!starts) return false;
    uint64_t previous = 0;
    bool firstStart = true;
    for (const auto& item : *starts) {
        const auto text = item.getAsString();
        uint64_t address = 0;
        if (!text || !parseCanonicalHex(*text, address) || address > INT64_MAX ||
            (!firstStart && address <= previous)) {
            error = "functionStarts must be canonical, sorted and deduplicated";
            return false;
        }
        request.functionStarts.push_back(static_cast<int64_t>(address));
        previous = address;
        firstStart = false;
    }

    if (const auto debugRef = analysis->getString("debugEnvelope")) {
        const auto* debugArtifact = requiredObject(*artifacts, "debugEnvelope", error);
        if (!debugArtifact) return false;
        const auto artifactRef = requiredString(*debugArtifact, "byteRef", error);
        std::string debugHash;
        if (!artifactRef || *artifactRef != *debugRef ||
            !loadAndVerifyArtifact(requestPath, *debugArtifact, request.debugTypeInfoJson, debugHash, error) ||
            *debugRef != "artifact:sha256:" + debugHash) {
            if (error.empty()) error = "debug envelope identity mismatch";
            return false;
        }
    } else if (!analysis->getNull("debugEnvelope")) {
        error = "analysisContext.debugEnvelope must be null or an artifact reference";
        return false;
    }

    const auto* sectionSemantics = requiredArray(*semantic, "sections", error);
    const auto* sectionArtifacts = requiredArray(*artifacts, "sections", error);
    if (!sectionSemantics || !sectionArtifacts) return false;
    std::map<std::string, const llvm::json::Object*> artifactByRef;
    for (const auto& item : *sectionArtifacts) {
        const auto* artifact = item.getAsObject();
        if (!artifact) {
            error = "section artifact must be an object";
            return false;
        }
        const auto byteRef = requiredString(*artifact, "byteRef", error);
        if (!byteRef || !artifactByRef.emplace(*byteRef, artifact).second) {
            if (error.empty()) error = "duplicate section artifact byteRef";
            return false;
        }
    }
    uint64_t priorSectionEnd = 0;
    for (const auto& item : *sectionSemantics) {
        const auto* section = item.getAsObject();
        if (!section) {
            error = "semantic section must be an object";
            return false;
        }
        const auto byteRef = requiredString(*section, "byteRef", error);
        const auto digest = requiredString(*section, "sha256", error);
        const auto vaText = requiredString(*section, "va", error);
        const auto sizeText = requiredString(*section, "size", error);
        uint64_t va = 0, size = 0;
        if (!byteRef || !digest || !vaText || !sizeText || !isLowerSha256(*digest) ||
            *byteRef != "artifact:sha256:" + *digest || !parseCanonicalHex(*vaText, va) ||
            !parseCanonicalHex(*sizeText, size) || va < priorSectionEnd) {
            if (error.empty()) error = "invalid or overlapping canonical section";
            return false;
        }
        const auto found = artifactByRef.find(*byteRef);
        if (found == artifactByRef.end()) {
            error = "canonical section artifact is missing";
            return false;
        }
        std::string sectionBytes;
        std::string sectionHash;
        if (!loadAndVerifyArtifact(requestPath, *found->second, sectionBytes, sectionHash, error) ||
            sectionHash != *digest || sectionBytes.size() != size) {
            if (error.empty()) error = "canonical section bytes differ from semantics";
            return false;
        }
        request.dataSections.push_back(DataSection{
            va,
            std::vector<uint8_t>(sectionBytes.begin(), sectionBytes.end())
        });
        priorSectionEnd = va + size;
    }

    const auto* pipeline = requiredObject(*semantic, "pipelineOptions", error);
    if (!pipeline) return false;
    const auto useCast = pipeline->getBoolean("useCastLayer");
    const auto skipOpt = pipeline->getBoolean("skipOptimization");
    const auto preserveCfg = pipeline->getBoolean("preserveCfg");
    const auto* enabledPasses = requiredArray(*pipeline, "enabledPasses", error);
    const auto* renames = requiredArray(*pipeline, "variableRenames", error);
    if (!useCast || !skipOpt || !preserveCfg || *preserveCfg || !enabledPasses ||
        !enabledPasses->empty() || !renames) {
        if (error.empty()) error = "unsupported canonical pipeline options";
        return false;
    }
    request.useCastLayer = *useCast;
    request.skipOptimization = *skipOpt;
    for (const auto& item : *renames) {
        const auto* rename = item.getAsObject();
        if (!rename) {
            error = "variable rename must be an object";
            return false;
        }
        const auto oldName = requiredString(*rename, "oldName", error);
        const auto newName = requiredString(*rename, "newName", error);
        if (!oldName || !newName) return false;
        request.variableRenames.push_back({*oldName, *newName});
    }
    return true;
}

std::string buildResultJson(
    const CanonicalRequest& request,
    llvm::StringRef cBytes,
    llvm::StringRef hastBytes,
    const HelixCombinedDecompileOutput& output) {
    llvm::json::Object root;
    root["schemaVersion"] = 1;
    root["requestHash"] = request.requestHash;
    root["hostKind"] = "cli";
    root["nativeVersion"] = helix_engine_version();
    root["functionCount"] = output.function_count;
    root["blockCount"] = output.block_count;
    root["instructionCount"] = output.instruction_count;
    root["cSha256"] = sha256(cBytes);
    root["cBytes"] = static_cast<uint64_t>(cBytes.size());
    root["hastSha256"] = sha256(hastBytes);
    root["hastBytes"] = static_cast<uint64_t>(hastBytes.size());
    std::string result;
    llvm::raw_string_ostream stream(result);
    stream << llvm::json::Value(std::move(root));
    stream << '\n';
    stream.flush();
    return result;
}

} // namespace

int runCanonicalRequest(
    const fs::path& requestPath,
    const fs::path& cOutputPath,
    const fs::path& hastOutputPath,
    const fs::path& resultOutputPath) {
    CanonicalRequest request;
    std::string error;
    if (!loadCanonicalRequest(requestPath, request, error)) {
        std::cerr << "error: " << error << "\n";
        return 1;
    }

    HelixEngineHandle* engine = helix_engine_create(request.architecture);
    if (!engine) {
        std::cerr << "error: failed to create Helix engine\n";
        return 1;
    }
    helix_engine_set_use_cast_layer(engine, request.useCastLayer ? 1 : 0);
    helix_engine_set_skip_optimization(engine, request.skipOptimization ? 1 : 0);
    helix_engine_set_preserve_cfg(engine, 0);
    if (!request.functionStarts.empty()) {
        helix_engine_set_function_starts(engine, request.functionStarts.data(), request.functionStarts.size());
    }
    if (!request.debugTypeInfoJson.empty()) {
        helix_engine_set_debug_type_info_json(
            engine, request.debugTypeInfoJson.data(), request.debugTypeInfoJson.size());
    }
    for (const auto& section : request.dataSections) {
        helix_engine_add_data_section(engine, section.va, section.bytes.data(), section.bytes.size());
    }
    for (const auto& rename : request.variableRenames) {
        helix_engine_add_variable_rename(engine, rename.oldName.c_str(), rename.newName.c_str());
    }

    HelixCombinedDecompileOutput output{};
    const int status = helix_engine_decompile_ir_combined(
        engine, request.irText.data(), request.irText.size(), &output);
    if (status != HELIX_OK) {
        const char* nativeError = helix_engine_last_error(engine);
        std::cerr << "error: canonical decompilation failed";
        if (nativeError) std::cerr << ": " << nativeError;
        std::cerr << "\n";
        helix_engine_free_decompile_output(&output);
        helix_engine_destroy(engine);
        return 1;
    }

    const llvm::StringRef cBytes(output.pseudo_c, output.pseudo_c_len);
    const llvm::StringRef hastBytes(
        reinterpret_cast<const char*>(output.flatbuffer), output.flatbuffer_len);
    const std::string resultJson = buildResultJson(request, cBytes, hastBytes, output);
    const bool wroteC = writeFile(cOutputPath, cBytes.data(), cBytes.size());
    const bool wroteHast = writeFile(hastOutputPath, hastBytes.data(), hastBytes.size());
    const bool wroteResult = resultOutputPath.empty() ||
        writeFile(resultOutputPath, resultJson.data(), resultJson.size());
    helix_engine_free_decompile_output(&output);
    helix_engine_destroy(engine);

    if (!wroteC || !wroteHast || !wroteResult) {
        std::cerr << "error: failed to write canonical output artifacts\n";
        return 1;
    }
    if (resultOutputPath.empty()) std::cout << resultJson;
    return 0;
}
