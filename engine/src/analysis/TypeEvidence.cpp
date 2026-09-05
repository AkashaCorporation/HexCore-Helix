/// @file TypeEvidence.cpp
/// @brief Provenance-aware arbitration for recovered C type evidence.

#include "helix/analysis/TypeEvidence.h"

#include "mlir/IR/Builders.h"
#include "llvm/ADT/StringSwitch.h"

using namespace mlir;

namespace helix {
namespace {

TypeEvidenceSource parseSource(llvm::StringRef name) {
    return llvm::StringSwitch<TypeEvidenceSource>(name)
        .Case("dataflow", TypeEvidenceSource::DataFlow)
        .Case("structural", TypeEvidenceSource::Structural)
        .Case("interprocedural", TypeEvidenceSource::Interprocedural)
        .Case("signature-db", TypeEvidenceSource::SignatureDatabase)
        .Case("debug-info", TypeEvidenceSource::DebugInfo)
        .Case("user", TypeEvidenceSource::User)
        .Default(TypeEvidenceSource::Legacy);
}

void writeSelected(Operation* operation, llvm::StringRef spelling,
                   TypeEvidenceSource source, unsigned strength) {
    Builder builder(operation->getContext());
    auto spellingAttr = builder.getStringAttr(spelling);
    operation->setAttr("inferred_type", spellingAttr);
    operation->setAttr("helix.type.spelling", spellingAttr);
    operation->setAttr(
        "helix.type.source",
        builder.getStringAttr(typeEvidenceSourceName(source)));
    operation->setAttr(
        "helix.type.strength", builder.getI32IntegerAttr(strength));
}

} // namespace

llvm::StringRef typeEvidenceSourceName(TypeEvidenceSource source) {
    switch (source) {
    case TypeEvidenceSource::Legacy: return "legacy";
    case TypeEvidenceSource::DataFlow: return "dataflow";
    case TypeEvidenceSource::Structural: return "structural";
    case TypeEvidenceSource::Interprocedural: return "interprocedural";
    case TypeEvidenceSource::SignatureDatabase: return "signature-db";
    case TypeEvidenceSource::DebugInfo: return "debug-info";
    case TypeEvidenceSource::User: return "user";
    }
    return "legacy";
}

unsigned defaultTypeEvidenceStrength(TypeEvidenceSource source) {
    switch (source) {
    case TypeEvidenceSource::Legacy: return 10;
    case TypeEvidenceSource::DataFlow: return 40;
    case TypeEvidenceSource::Structural: return 60;
    case TypeEvidenceSource::Interprocedural: return 70;
    case TypeEvidenceSource::SignatureDatabase: return 80;
    case TypeEvidenceSource::DebugInfo: return 100;
    case TypeEvidenceSource::User: return 120;
    }
    return 10;
}

std::optional<TypeEvidence> readTypeEvidence(Operation* operation) {
    if (!operation)
        return std::nullopt;
    auto spelling = operation->getAttrOfType<StringAttr>(
        "helix.type.spelling");
    if (!spelling)
        spelling = operation->getAttrOfType<StringAttr>("inferred_type");
    if (!spelling)
        return std::nullopt;

    TypeEvidence result;
    result.spelling = spelling.getValue().str();
    if (auto source = operation->getAttrOfType<StringAttr>(
            "helix.type.source"))
        result.source = parseSource(source.getValue());
    if (auto strength = operation->getAttrOfType<IntegerAttr>(
            "helix.type.strength"))
        result.strength = static_cast<unsigned>(
            strength.getValue().getZExtValue());
    else
        result.strength = defaultTypeEvidenceStrength(result.source);
    result.conflict = operation->hasAttr("helix.type.conflict");
    return result;
}

bool applyTypeEvidence(Operation* operation, llvm::StringRef spelling,
                       TypeEvidenceSource source, unsigned strength) {
    if (!operation || spelling.trim().empty())
        return false;
    spelling = spelling.trim();
    if (strength == 0)
        strength = defaultTypeEvidenceStrength(source);

    auto current = readTypeEvidence(operation);
    Builder builder(operation->getContext());
    if (!current) {
        writeSelected(operation, spelling, source, strength);
        return true;
    }

    if (current->spelling == spelling) {
        if (strength <= current->strength)
            return false;
        writeSelected(operation, spelling, source, strength);
        operation->removeAttr("helix.type.conflict");
        operation->removeAttr("helix.type.rejected");
        return true;
    }

    const bool dataflowPointerRefinement =
        source == TypeEvidenceSource::DataFlow &&
        current->source == TypeEvidenceSource::DataFlow &&
        strength == current->strength && spelling.ends_with("*") &&
        !llvm::StringRef(current->spelling).ends_with("*");
    if (strength > current->strength || dataflowPointerRefinement) {
        operation->setAttr(
            "helix.type.overrode", builder.getStringAttr(current->spelling));
        writeSelected(operation, spelling, source, strength);
        operation->removeAttr("helix.type.conflict");
        operation->removeAttr("helix.type.rejected");
        return true;
    }

    operation->setAttr("helix.type.rejected", builder.getStringAttr(spelling));
    if (strength == current->strength)
        operation->setAttr("helix.type.conflict", builder.getUnitAttr());
    return false;
}

bool copyTypeEvidence(Operation* target, Operation* source) {
    auto evidence = readTypeEvidence(source);
    if (!evidence)
        return false;
    return applyTypeEvidence(
        target, evidence->spelling, evidence->source, evidence->strength);
}

} // namespace helix
