#pragma once
/// @file TypeEvidence.h
/// @brief Provenance-aware arbitration for recovered C type evidence.

#include "mlir/IR/Operation.h"

#include <optional>
#include <string>

namespace helix {

enum class TypeEvidenceSource {
    Legacy,
    DataFlow,
    Structural,
    Interprocedural,
    SignatureDatabase,
    DebugInfo,
    User,
};

struct TypeEvidence {
    std::string spelling;
    TypeEvidenceSource source = TypeEvidenceSource::Legacy;
    unsigned strength = 0;
    bool conflict = false;
};

llvm::StringRef typeEvidenceSourceName(TypeEvidenceSource source);
unsigned defaultTypeEvidenceStrength(TypeEvidenceSource source);

std::optional<TypeEvidence> readTypeEvidence(mlir::Operation* operation);

/// Apply evidence without allowing a weaker source to overwrite a stronger
/// source. Returns true when the selected type spelling or authority changes.
bool applyTypeEvidence(
    mlir::Operation* operation, llvm::StringRef spelling,
    TypeEvidenceSource source, unsigned strength = 0);

bool copyTypeEvidence(
    mlir::Operation* target, mlir::Operation* source);

} // namespace helix
