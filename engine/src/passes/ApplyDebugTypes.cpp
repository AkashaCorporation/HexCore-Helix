/// @file ApplyDebugTypes.cpp
/// @brief Seed nominal DWARF/BTF/PDB types into HelixHigh operations.

#include "helix/passes/Passes.h"
#include "helix/analysis/TypeEvidence.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixHighDialect.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixLowDialect.h"

#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/Support/JSON.h"

#include <algorithm>
#include <cctype>
#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

using namespace mlir;

namespace {

struct DebugParam {
    unsigned index = 0;
    std::string name;
    std::string type;
};

struct DebugFunction {
    std::string returnType;
    std::vector<DebugParam> params;
    bool isVariadic = false;
};

struct DebugField {
    uint64_t offset = 0;
    uint64_t size = 0;
    std::string name;
    std::string type;
};

struct DebugStruct {
    std::vector<DebugField> fields;
};

struct DebugDatabase {
    std::unordered_map<std::string, DebugFunction> functions;
    std::unordered_map<std::string, DebugStruct> structs;
};

static std::optional<uint64_t> parseUnsigned(const llvm::json::Value& value) {
    if (auto n = value.getAsInteger())
        return static_cast<uint64_t>(*n);
    auto s = value.getAsString();
    if (!s)
        return std::nullopt;
    uint64_t out = 0;
    if (s->getAsInteger(0, out))
        return std::nullopt;
    return out;
}

static std::optional<DebugDatabase> parseDatabase(llvm::StringRef raw) {
    auto parsed = llvm::json::parse(raw);
    if (!parsed)
        return std::nullopt;
    auto* root = parsed->getAsObject();
    if (!root)
        return std::nullopt;

    DebugDatabase db;
    if (auto* functions = root->getObject("functions")) {
        for (const auto& [key, value] : *functions) {
            auto* obj = value.getAsObject();
            if (!obj)
                continue;
            DebugFunction fn;
            if (auto ret = obj->getString("returnType"))
                fn.returnType = ret->str();
            if (auto variadic = obj->getBoolean("variadic"))
                fn.isVariadic = *variadic;
            if (auto* params = obj->getArray("params")) {
                for (const auto& paramValue : *params) {
                    auto* paramObj = paramValue.getAsObject();
                    if (!paramObj)
                        continue;
                    DebugParam param;
                    if (auto index = paramObj->getInteger("index"))
                        param.index = static_cast<unsigned>(*index);
                    if (auto name = paramObj->getString("name"))
                        param.name = name->str();
                    if (auto type = paramObj->getString("type"))
                        param.type = type->str();
                    fn.params.push_back(std::move(param));
                }
            }
            std::sort(fn.params.begin(), fn.params.end(),
                      [](const DebugParam& a, const DebugParam& b) {
                          return a.index < b.index;
                      });
            db.functions.emplace(key.str(), std::move(fn));
        }
    }

    if (auto* structs = root->getObject("structs")) {
        for (const auto& [key, value] : *structs) {
            auto* obj = value.getAsObject();
            auto* fields = obj ? obj->getArray("fields") : nullptr;
            if (!fields)
                continue;
            DebugStruct record;
            for (const auto& fieldValue : *fields) {
                auto* fieldObj = fieldValue.getAsObject();
                if (!fieldObj)
                    continue;
                auto* offsetValue = fieldObj->get("offset");
                if (!offsetValue)
                    continue;
                auto offset = parseUnsigned(*offsetValue);
                if (!offset)
                    continue;
                DebugField field;
                field.offset = *offset;
                if (auto size = fieldObj->getInteger("size"))
                    field.size = static_cast<uint64_t>(*size);
                if (auto name = fieldObj->getString("name"))
                    field.name = name->str();
                if (auto type = fieldObj->getString("type"))
                    field.type = type->str();
                if (!field.name.empty())
                    record.fields.push_back(std::move(field));
            }
            db.structs.emplace(key.str(), std::move(record));
        }
    }
    return db;
}

static std::optional<unsigned> parseParamIndex(llvm::StringRef name) {
    if (!name.consume_front("param_"))
        return std::nullopt;
    unsigned index = 0;
    if (name.getAsInteger(10, index) || index == 0)
        return std::nullopt;
    return index - 1;
}

static std::string nominalStructName(llvm::StringRef type) {
    type = type.trim();
    for (llvm::StringRef qualifier : {"const ", "volatile ", "restrict "})
        type.consume_front(qualifier);
    type = type.trim();
    if (!type.consume_front("struct "))
        return {};
    size_t end = type.find_first_of(" *[");
    return type.take_front(end).str();
}

struct ResolvedField {
    std::string path;
    std::string type;
};

static std::optional<ResolvedField>
resolveField(const DebugDatabase& db, llvm::StringRef structName,
             uint64_t offset, unsigned depth = 0) {
    if (depth > 6)
        return std::nullopt;
    auto structIt = db.structs.find(structName.str());
    if (structIt == db.structs.end())
        return std::nullopt;

    // Prefer a concrete nested leaf. A flattened base+0x78 access into
    // kbase_va_region::jit_node should become jit_node.prev, not a fabricated
    // top-level field. Exact scalar fields still resolve directly.
    for (const auto& field : structIt->second.fields) {
        if (offset < field.offset || (field.size && offset >= field.offset + field.size))
            continue;
        // Recurse only into records embedded by value. Following a pointer
        // member (list_head::next -> list_head*) invents an arbitrarily deep
        // path for offset zero instead of naming the pointer field itself.
        if (llvm::StringRef(field.type).trim().ends_with("*"))
            continue;
        std::string nestedName = nominalStructName(field.type);
        if (nestedName.empty())
            continue;
        auto nested = resolveField(db, nestedName, offset - field.offset, depth + 1);
        if (nested)
            return ResolvedField{field.name + "." + nested->path, nested->type};
    }

    for (const auto& field : structIt->second.fields) {
        if (field.offset == offset)
            return ResolvedField{field.name, field.type};
    }
    return std::nullopt;
}

static std::string structFromPointerType(llvm::StringRef type) {
    type = type.trim();
    if (!type.ends_with("*"))
        return {};
    llvm::StringRef pointee = type.drop_back().rtrim();
    std::string nominal = nominalStructName(pointee);
    if (!nominal.empty())
        return nominal;
    // PropagateTypes serializes CTypeInfo::Struct as the bare nominal name
    // (for example `kbase_va_region*`). The database lookup below is the
    // authority that distinguishes this from a scalar typedef.
    return pointee.str();
}

static bool isSyntheticStructPointer(llvm::StringRef type) {
    return llvm::StringRef(structFromPointerType(type))
        .starts_with("auto_struct_");
}

static void propagateNominalCopyAliases(
    helix::low::FuncOp func, const DebugDatabase& db,
    const std::unordered_map<uint32_t, helix::high::VarDeclOp>& decls) {
    // RecoverVariables may coalesce multiple machine-register versions into a
    // structurally typed storage. A later direct copy from a debug-typed
    // parameter is stronger evidence than that synthetic auto_struct_N name.
    // Keep this deliberately narrower than general type propagation: only a
    // nominal pointer present in the debug database may replace a synthetic
    // struct pointer, and only across a direct VarRef-to-VarRef assignment.
    // A physical register reused for unrelated values can still appear as one
    // recovered variable at this stage. Nominal debug types must not cross
    // that ambiguity: only a single-definition local is a trustworthy copy
    // alias. Parameters are authoritative roots, never propagation targets.
    std::unordered_map<uint32_t, unsigned> assignmentCounts;
    func.walk([&](helix::high::AssignOp assign) {
        auto target =
            assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
        if (target)
            ++assignmentCounts[target.getVarId()];
    });

    bool changed = true;
    for (unsigned round = 0; changed && round < decls.size(); ++round) {
        changed = false;
        func.walk([&](helix::high::AssignOp assign) {
            auto target =
                assign.getTarget().getDefiningOp<helix::high::VarRefOp>();
            auto source =
                assign.getValue().getDefiningOp<helix::high::VarRefOp>();
            if (!target || !source)
                return;

            auto targetIt = decls.find(target.getVarId());
            auto sourceIt = decls.find(source.getVarId());
            if (targetIt == decls.end() || sourceIt == decls.end())
                return;
            auto targetDecl = targetIt->second;
            if (targetDecl.getStorage() ==
                    helix::high::StorageKind::Parameter ||
                assignmentCounts[target.getVarId()] != 1)
                return;

            auto targetType =
                targetIt->second->getAttrOfType<StringAttr>("inferred_type");
            auto sourceType =
                sourceIt->second->getAttrOfType<StringAttr>("inferred_type");
            if (!targetType || !sourceType ||
                !isSyntheticStructPointer(targetType.getValue()))
                return;

            std::string sourceStruct =
                structFromPointerType(sourceType.getValue());
            if (sourceStruct.empty() || !db.structs.contains(sourceStruct))
                return;

            changed |= helix::applyTypeEvidence(
                targetIt->second, sourceType.getValue(),
                helix::TypeEvidenceSource::DebugInfo);
        });
    }
}

static std::optional<int64_t> constantInt(Value value) {
    auto constant = value.getDefiningOp<LLVM::ConstantOp>();
    if (!constant)
        return std::nullopt;
    auto attr = dyn_cast<IntegerAttr>(constant.getValue());
    if (!attr)
        return std::nullopt;
    return attr.getValue().getSExtValue();
}

struct UnitStrideIndexedAddress {
    helix::high::VarRefOp base;
    Value index;
    uint64_t offset = 0;
};

static std::optional<UnitStrideIndexedAddress>
decomposeUnitStrideIndexedAddress(LLVM::AddOp outer) {
    Value innerValue;
    std::optional<int64_t> offset;
    if (auto rhs = constantInt(outer.getRhs())) {
        innerValue = outer.getLhs();
        offset = rhs;
    } else if (auto lhs = constantInt(outer.getLhs())) {
        innerValue = outer.getRhs();
        offset = lhs;
    }
    if (!offset || *offset < 0)
        return std::nullopt;

    auto inner = innerValue.getDefiningOp<LLVM::AddOp>();
    if (!inner)
        return std::nullopt;

    helix::high::VarRefOp base;
    Value index;
    if (auto lhs =
            inner.getLhs().getDefiningOp<helix::high::VarRefOp>()) {
        if (!constantInt(inner.getRhs())) {
            base = lhs;
            index = inner.getRhs();
        }
    }
    if (!base) {
        if (auto rhs =
                inner.getRhs().getDefiningOp<helix::high::VarRefOp>()) {
            if (!constantInt(inner.getLhs())) {
                base = rhs;
                index = inner.getLhs();
            }
        }
    }
    if (!base || !index)
        return std::nullopt;
    return UnitStrideIndexedAddress{
        base, index, static_cast<uint64_t>(*offset)};
}

static std::optional<std::string>
unitStrideArrayElementType(llvm::StringRef type) {
    type = type.trim();
    size_t open = type.rfind('[');
    if (open == llvm::StringRef::npos || !type.ends_with("]"))
        return std::nullopt;
    llvm::StringRef element = type.take_front(open).rtrim();
    llvm::StringRef count = type.slice(open + 1, type.size() - 1);
    uint64_t length = 0;
    if (element.empty() || count.getAsInteger(0, length) || length == 0)
        return std::nullopt;

    // The current address shape is base + index + fieldOffset, so it proves
    // unit stride only. Wider elements require an explicit index*stride term.
    if (element != "u8" && element != "uint8_t" &&
        element != "char" && element != "unsigned char" &&
        element != "bool")
        return std::nullopt;
    return element.str();
}

static void annotateIndexedDebugArrays(
    helix::low::FuncOp func, const DebugDatabase& db,
    const std::unordered_map<uint32_t, helix::high::VarDeclOp>& decls) {
    func.walk([&](LLVM::AddOp outer) {
        auto address = decomposeUnitStrideIndexedAddress(outer);
        if (!address)
            return;
        auto declIt = decls.find(address->base.getVarId());
        if (declIt == decls.end())
            return;
        auto baseType =
            declIt->second->getAttrOfType<StringAttr>("inferred_type");
        if (!baseType)
            return;
        std::string structName =
            structFromPointerType(baseType.getValue());
        auto structIt = db.structs.find(structName);
        if (structIt == db.structs.end())
            return;

        for (const DebugField& field : structIt->second.fields) {
            if (field.offset != address->offset)
                continue;
            auto elementType = unitStrideArrayElementType(field.type);
            if (!elementType)
                return;
            outer->setAttr("helix.debug_indexed_field_name",
                           StringAttr::get(outer.getContext(), field.name));
            outer->setAttr("helix.debug_indexed_element_type",
                           StringAttr::get(outer.getContext(), *elementType));
            outer->setAttr(
                "helix.debug_indexed_field_offset",
                IntegerAttr::get(IntegerType::get(outer.getContext(), 64),
                                 field.offset));
            return;
        }
    });
}

struct ApplyDebugTypesPass
    : public PassWrapper<ApplyDebugTypesPass, OperationPass<ModuleOp>> {
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(ApplyDebugTypesPass)

    llvm::StringRef getArgument() const final { return "apply-debug-types"; }
    llvm::StringRef getDescription() const final {
        return "Seed nominal DWARF/BTF/PDB types and field names";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<helix::low::HelixLowDialect,
                        helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        ModuleOp module = getOperation();
        auto jsonAttr = module->getAttrOfType<StringAttr>(
            "helix.debug_type_info_json");
        if (!jsonAttr)
            return;
        auto db = parseDatabase(jsonAttr.getValue());
        if (!db)
            return;
        const bool resolveCallAliases =
            module->hasAttr("helix.debug_types_seeded");
        bool sawRecoveredDeclarations = false;

        // MidToHigh intentionally preserves low.func as the region container;
        // only the operations in its body become HelixHigh operations.
        module.walk([&](helix::low::FuncOp func) {
            std::unordered_map<uint32_t, helix::high::VarDeclOp> decls;
            func.walk([&](helix::high::VarDeclOp decl) {
                decls.emplace(decl.getVarId(), decl);
            });
            sawRecoveredDeclarations |= !decls.empty();

            auto fnIt = db->functions.find(func.getSymName().str());
            if (fnIt != db->functions.end()) {
                const DebugFunction& signature = fnIt->second;
                if (!signature.returnType.empty()) {
                    func->setAttr("inferred_return_type",
                        StringAttr::get(func.getContext(), signature.returnType));
                }
                if (signature.isVariadic) {
                    func->setAttr("is_variadic",
                        UnitAttr::get(func.getContext()));
                    func->removeAttr("helix.debug_param_count");
                } else {
                    func->removeAttr("is_variadic");
                    func->setAttr(
                        "helix.debug_param_count",
                        IntegerAttr::get(
                            IntegerType::get(func.getContext(), 32),
                            signature.params.size()));
                }
                func.walk([&](helix::high::VarDeclOp decl) {
                    if (decl.getStorage() != helix::high::StorageKind::Parameter)
                        return;
                    auto index = parseParamIndex(decl.getVarName());
                    if (!index || *index >= signature.params.size())
                        return;
                    const DebugParam& param = signature.params[*index];
                    if (!param.type.empty()) {
                        helix::applyTypeEvidence(
                            decl, param.type,
                            helix::TypeEvidenceSource::DebugInfo);
                    }
                    if (!param.name.empty() &&
                        !llvm::StringRef(param.name).starts_with("param_")) {
                        decl->setAttr("helix.debug_name",
                            StringAttr::get(decl.getContext(), param.name));
                    }
                });
            }

            // The first ApplyDebugTypes run happens before calling-convention
            // recovery, while calls are still HelixLow operations. Preserve
            // exact external signatures here so RecoverCallingConvention can
            // clamp ABI register arguments without relying on its small
            // built-in signature table.
            func.walk([&](helix::low::CallOp call) {
                auto targetName = call.getTargetName();
                if (!targetName)
                    return;
                auto callIt = db->functions.find(targetName->str());
                if (callIt == db->functions.end())
                    return;
                const DebugFunction& signature = callIt->second;
                if (!signature.returnType.empty() && call.getResult()) {
                    auto typeAttr = StringAttr::get(
                        call.getContext(), signature.returnType);
                    helix::applyTypeEvidence(
                        call, signature.returnType,
                        helix::TypeEvidenceSource::DebugInfo);
                    call->setAttr("inferred_return_type", typeAttr);
                }
                if (signature.isVariadic) {
                    call->setAttr("is_variadic",
                        UnitAttr::get(call.getContext()));
                    call->removeAttr("helix.debug_param_count");
                } else {
                    call->removeAttr("is_variadic");
                    call->setAttr(
                        "helix.debug_param_count",
                        IntegerAttr::get(
                            IntegerType::get(call.getContext(), 32),
                            signature.params.size()));
                }
            });

            // Preserve the call's own nominal return type for C emission. Do
            // not use helix.type_hint here: the recovered `result` variable is
            // shared by every RAX-producing call, so global propagation from
            // it would contaminate unrelated calls and variables.
            func.walk([&](helix::high::CallOp call) {
                auto callIt = db->functions.find(call.getTargetName().str());
                if (callIt == db->functions.end() ||
                    callIt->second.returnType.empty() || !call.getResult())
                    return;
                auto typeAttr = StringAttr::get(
                    call.getContext(), callIt->second.returnType);
                helix::applyTypeEvidence(
                    call, callIt->second.returnType,
                    helix::TypeEvidenceSource::DebugInfo);
                call->setAttr("inferred_return_type", typeAttr);
            });

            propagateNominalCopyAliases(func, *db, decls);
            annotateIndexedDebugArrays(func, *db, decls);

            if (!resolveCallAliases)
                return;

            // Recover the local ABI binding emitted by RecoverVariables:
            //   typed_call -> result/RAX -> destination variable
            // The destination receives the nominal type, but the shared RAX
            // variable deliberately does not. Limit the scan to the same
            // block and stop as soon as RAX is overwritten.
            func.walk([&](helix::high::CallOp call) {
                auto returnType = call->getAttrOfType<StringAttr>(
                    "inferred_return_type");
                if (!returnType || !call.getResult())
                    return;
                for (Operation* user : call.getResult().getUsers()) {
                    auto bind = dyn_cast<helix::high::AssignOp>(user);
                    if (!bind || bind.getValue() != call.getResult())
                        continue;
                    auto accumulator = bind.getTarget()
                        .getDefiningOp<helix::high::VarRefOp>();
                    if (!accumulator || bind->getBlock() == nullptr)
                        continue;
                    auto it = bind->getIterator();
                    for (++it; it != bind->getBlock()->end(); ++it) {
                        auto assign = dyn_cast<helix::high::AssignOp>(&*it);
                        if (!assign)
                            continue;
                        auto target = assign.getTarget()
                            .getDefiningOp<helix::high::VarRefOp>();
                        if (!target)
                            continue;
                        if (target.getVarId() == accumulator.getVarId())
                            break;
                        auto source = assign.getValue()
                            .getDefiningOp<helix::high::VarRefOp>();
                        if (!source ||
                            source.getVarId() != accumulator.getVarId())
                            continue;
                        auto declIt = decls.find(target.getVarId());
                        if (declIt != decls.end())
                            helix::applyTypeEvidence(
                                declIt->second, returnType.getValue(),
                                helix::TypeEvidenceSource::DebugInfo);
                        break;
                    }
                }
            });

            std::unordered_map<uint32_t, std::string> varStructs;
            func.walk([&](helix::high::VarDeclOp decl) {
                auto type = decl->getAttrOfType<StringAttr>("inferred_type");
                if (!type)
                    return;
                std::string name = structFromPointerType(type.getValue());
                if (!name.empty())
                    varStructs[decl.getVarId()] = std::move(name);
            });

            func.walk([&](helix::high::FieldAccessOp field) {
                auto baseRef = field.getBase().getDefiningOp<helix::high::VarRefOp>();
                if (!baseRef)
                    return;
                auto typeIt = varStructs.find(baseRef.getVarId());
                if (typeIt == varStructs.end())
                    return;
                auto resolved = resolveField(
                    *db, typeIt->second, field.getFieldOffset());
                if (!resolved)
                    return;
                // field_name is an ODS inherent property, not a discardable
                // attribute. Use the generated setter so CAstBuilder observes
                // the nominal name through getFieldName().
                field.setFieldName(resolved->path);
                if (!resolved->type.empty()) {
                    auto typeAttr = StringAttr::get(
                        field.getContext(), resolved->type);
                    field->setAttr("helix.type_hint", typeAttr);
                    helix::applyTypeEvidence(
                        field, resolved->type,
                        helix::TypeEvidenceSource::DebugInfo);
                }
            });
        });
        // The pipeline also invokes this pass immediately after
        // RemillToHelixLow so the authoritative function return type is
        // available to calling-convention recovery. At that point there are
        // no recovered declarations to seed, so do not consume the two-stage
        // Tier-3.5 marker yet.
        if (!resolveCallAliases && sawRecoveredDeclarations)
            module->setAttr("helix.debug_types_seeded",
                            UnitAttr::get(module.getContext()));
    }
};

} // namespace

std::unique_ptr<mlir::Pass> helix::createApplyDebugTypesPass() {
    return std::make_unique<ApplyDebugTypesPass>();
}
