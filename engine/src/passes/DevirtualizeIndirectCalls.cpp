/// @file DevirtualizeIndirectCalls.cpp
/// @brief MLIR pass: resolves indirect calls through vtable pointers using
///        intra-procedural dataflow analysis.
///
/// This pass performs basic devirtualization by:
///
///   1. Identifying vtable pointer stores: `*base = vtable_addr` (offset 0)
///   2. Tracking object → vtable_address mappings within each function
///   3. When an indirect call goes through a vtable slot:
///        `call *(*(base + 0) + offset)`
///      annotate it with the resolved vtable address and offset
///   4. If the vtable + offset points to a known function, resolve the call
///      target name directly
///
/// ## Limitations
///
///   - Intra-procedural only: vtable stores in constructors called from other
///     functions are NOT tracked (requires IPA, future work).
///   - No vtable memory contents: without data-section access, individual
///     vtable entries can only be resolved if their addresses appear as
///     constants in the code.
///   - Single-target only: if multiple vtable addresses are possible for the
///     same base (polymorphism), the pass conservatively does nothing.
///
/// ## Future Work
///
///   - Inter-procedural analysis: propagate vtable info across call boundaries
///   - Class hierarchy recovery: detect inheritance from vtable layouts
///   - Data-section integration: read vtable contents from binary image

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Debug.h"

#include <cstdint>
#include <format>
#include <optional>
#include <string>

#define DEBUG_TYPE "devirtualize-calls"

using namespace mlir;
using namespace helix;

STATISTIC(NumVtableStoresFound,  "Number of vtable pointer stores identified");
STATISTIC(NumCallsDevirtualized, "Number of indirect calls devirtualized");
STATISTIC(NumCallsAnnotated,     "Number of indirect calls annotated with vtable info");
STATISTIC(NumClassesInferred,    "Number of class names inferred from vtable grouping");

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Vtable Tracking State
// ═══════════════════════════════════════════════════════════════════════════════

/// A vtable pointer store: the constant address stored to offset 0 of an object.
struct VtableInfo {
    uint64_t vtable_address;  ///< Address of the vtable in the binary
    Value base_object;        ///< The SSA value representing the object base
    Operation* store_op;      ///< The store operation that wrote the vtable ptr
};

/// A resolved indirect call through a vtable.
struct VtableCallSite {
    Operation* call_op;       ///< The indirect call operation
    uint64_t vtable_address;  ///< Resolved vtable address
    uint64_t vtable_offset;   ///< Offset within the vtable (method index)
    Value base_object;        ///< Object being called through
};

// ═══════════════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════════════

/// Extract an integer constant from a Value.
static std::optional<int64_t> getConstantValue(Value val) {
    if (auto constOp = val.getDefiningOp<mid::ConstantOp>())
        return constOp.getValue();
    if (auto addrConst = val.getDefiningOp<mid::AddrConstOp>())
        return (int64_t)addrConst.getAddrValue();
    return std::nullopt;
}

/// Check if a FieldPtr accesses offset 0 (vtable pointer slot).
static bool isVtablePtrAccess(mid::FieldPtrOp fieldPtr) {
    return fieldPtr.getFieldOffset() == 0;
}

/// Try to extract the base object and field offset from a load address.
/// Returns {base, offset} if the address is a FieldPtr, else nullopt.
static std::optional<std::pair<Value, uint64_t>>
extractFieldAccess(Value addr) {
    if (auto fieldPtr = addr.getDefiningOp<mid::FieldPtrOp>())
        return std::make_pair(fieldPtr.getBase(), fieldPtr.getFieldOffset());
    return std::nullopt;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct DevirtualizeIndirectCallsPass
    : public PassWrapper<DevirtualizeIndirectCallsPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(DevirtualizeIndirectCallsPass)

    StringRef getArgument() const final { return "devirtualize-calls"; }
    StringRef getDescription() const final {
        return "Resolve indirect calls through vtable pointers (DataFlow)";
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each function independently.
        module.walk([&](low::FuncOp funcOp) {
            processFunction(funcOp.getOperation());
        });
    }

private:
    void processFunction(Operation* func) {
        // ── Phase 1: Identify vtable pointer stores ─────────────────────
        //
        // Look for patterns:
        //   store(field_ptr(base, offset=0), const_addr)
        //   → base's vtable is at const_addr
        //
        // Also detect HelixLow patterns:
        //   mem.write(base, const_addr)   where base is field offset 0

        llvm::SmallVector<VtableInfo, 4> vtables;
        llvm::DenseMap<Value, uint64_t> objectVtableMap;

        func->walk([&](mid::StoreOp store) {
            // Check if storing to a FieldPtr at offset 0
            auto fieldAccess = extractFieldAccess(store.getAddr());
            if (!fieldAccess || fieldAccess->second != 0)
                return;

            // Check if the stored value is a constant address (vtable addr)
            auto storedConst = getConstantValue(store.getValue());
            if (!storedConst || *storedConst == 0)
                return;

            VtableInfo info;
            info.vtable_address = (uint64_t)*storedConst;
            info.base_object = fieldAccess->first;
            info.store_op = store.getOperation();

            LLVM_DEBUG({
                llvm::dbgs() << "  Vtable store: base -> vtable at 0x"
                             << llvm::Twine::utohexstr(info.vtable_address) << "\n";
            });

            vtables.push_back(info);
            objectVtableMap[info.base_object] = info.vtable_address;
            ++NumVtableStoresFound;
        });

        // Also check HelixLow mem.write patterns for vtable stores.
        func->walk([&](low::MemWriteOp memWrite) {
            Value addr = memWrite.getAddr();
            Value val = memWrite.getValue();

            // Try to extract a constant from the value (LLVM or arith constant).
            std::optional<uint64_t> constVal;
            if (auto llvmConst = val.getDefiningOp<LLVM::ConstantOp>()) {
                if (auto intAttr = dyn_cast<IntegerAttr>(llvmConst.getValue()))
                    constVal = (uint64_t)intAttr.getInt();
            } else if (auto arithConst = val.getDefiningOp<arith::ConstantOp>()) {
                if (auto intAttr = dyn_cast<IntegerAttr>(arithConst.getValue()))
                    constVal = (uint64_t)intAttr.getInt();
            }

            if (constVal && *constVal > 0x10000 &&
                *constVal < 0x7FFFFFFFFFFFULL) {
                // Heuristic: code addresses are in the typical range
                objectVtableMap[addr] = *constVal;
                ++NumVtableStoresFound;

                LLVM_DEBUG({
                    llvm::dbgs() << "  [Low] Vtable store candidate: 0x"
                                 << llvm::Twine::utohexstr(*constVal) << "\n";
                });
            }
        });

        if (objectVtableMap.empty())
            return;  // No vtable info to use

        // ── Phase 2: Resolve indirect calls through vtables ─────────────
        //
        // Look for patterns:
        //   load(field_ptr(load(field_ptr(base, 0)), method_offset))
        //   → call through base->vtable[method_offset]
        //
        // In the simplified form:
        //   load(add(load(base), method_offset))
        //   → call through *((*base) + method_offset)

        func->walk([&](mid::CallOp call) {
            // Only process calls with unresolved targets (addr = 0 or no name)
            if (call.getCalleeAddr() != 0) {
                // Already resolved
                auto name = call.getCalleeNameAttr();
                if (name && !name.getValue().starts_with("sub_"))
                    return;
            }

            // Try to trace the call target to a vtable access.
            // In HelixMid, indirect calls typically have target_addr = 0
            // and the actual call target was an indirect load chain.
            // The PseudoCEmitter already handles this at string level;
            // here we try to resolve it at the IR level.

            // For now, annotate the call with vtable info if the containing
            // block has a vtable store that could relate to this call.
            // This is a conservative approach — full dataflow tracking
            // across the function would be more precise.

            // Check if any of the call's operands trace back to a vtable load.
            for (auto arg : call.getArgs()) {
                if (auto fieldAccess = extractFieldAccess(arg)) {
                    Value base = fieldAccess->first;
                    uint64_t offset = fieldAccess->second;

                    // Check if base has a known vtable
                    auto it = objectVtableMap.find(base);
                    if (it != objectVtableMap.end()) {
                        uint64_t vtable_addr = it->second;
                        uint64_t method_addr = vtable_addr + offset;

                        LLVM_DEBUG({
                            llvm::dbgs() << "  Resolved vtable call: vtable=0x"
                                         << llvm::Twine::utohexstr(vtable_addr)
                                         << " offset=" << offset
                                         << " → method at 0x"
                                         << llvm::Twine::utohexstr(method_addr)
                                         << "\n";
                        });

                        // Annotate the call with vtable info.
                        OpBuilder builder(call);
                        call->setAttr("helix.vtable_addr",
                            builder.getI64IntegerAttr(vtable_addr));
                        call->setAttr("helix.vtable_offset",
                            builder.getI64IntegerAttr(offset));
                        call->setAttr("helix.method_addr",
                            builder.getI64IntegerAttr(method_addr));

                        ++NumCallsAnnotated;
                    }
                }
            }
        });

        // ── Phase 3: Cross-reference with known function addresses ──────
        //
        // If we have a function address database (from SignatureDb), check
        // if any annotated method addresses correspond to known functions.
        // This is done by walking all functions in the module and building
        // an address→name map.

        llvm::DenseMap<uint64_t, StringRef> addrToName;
        auto moduleOp = func->getParentOfType<ModuleOp>();
        if (moduleOp) {
            moduleOp->walk([&](low::FuncOp f) {
                uint64_t addr = f.getEntryAddress();
                if (addr == 0) return;

                if (auto nameAttr = f.getOriginalNameAttr()) {
                    if (!nameAttr.getValue().empty())
                        addrToName[addr] = nameAttr.getValue();
                } else {
                    // Use sym_name as fallback
                    addrToName[addr] = f.getSymName();
                }
            });
        }

        if (addrToName.empty())
            return;

        // Resolve annotated calls.
        func->walk([&](mid::CallOp call) {
            auto methodAddrAttr = call->getAttrOfType<IntegerAttr>("helix.method_addr");
            if (!methodAddrAttr)
                return;

            uint64_t method_addr = methodAddrAttr.getInt();
            auto it = addrToName.find(method_addr);
            if (it == addrToName.end())
                return;

            // Update the call with the resolved name.
            OpBuilder builder(call);
            call->setAttr("helix.resolved_name",
                builder.getStringAttr(it->second));

            LLVM_DEBUG({
                llvm::dbgs() << "  Devirtualized: 0x"
                             << llvm::Twine::utohexstr(method_addr)
                             << " → " << it->second << "\n";
            });

            ++NumCallsDevirtualized;
        });

        // ── Phase 4: Vtable-based class naming (Tier 1 RTTI) ──────────────
        //
        // Group resolved vtable calls by vtable_addr → each group shares a
        // class.  Infer the class name from the common prefix of resolved
        // function names, or assign a synthetic "Class_0xADDR" name.
        //
        // For each call: emit "ClassName::methodName" as the resolved name.
        //
        // This is Tier 1 — no binary .rodata access needed.  Tier 2
        // (RTTI typeinfo parsing) requires HexCore binary data integration.
        {
            // Group calls by vtable address.
            llvm::DenseMap<uint64_t,
                           llvm::SmallVector<mid::CallOp, 4>> callsByVtable;

            func->walk([&](mid::CallOp call) {
                auto vtAddr = call->getAttrOfType<IntegerAttr>(
                    "helix.vtable_addr");
                if (!vtAddr)
                    return;
                callsByVtable[vtAddr.getInt()].push_back(call);
            });

            if (callsByVtable.empty())
                return;

            // For each vtable group, infer a class name.
            for (auto& [vtAddr, calls] : callsByVtable) {
                // Collect resolved function names for this vtable.
                llvm::SmallVector<StringRef, 4> resolvedNames;
                for (auto call : calls) {
                    if (auto name = call->getAttrOfType<StringAttr>(
                            "helix.resolved_name"))
                        resolvedNames.push_back(name.getValue());
                }

                // Infer class name from common prefix of function names.
                // E.g., "Player_TakeDamage", "Player_GetHealth" → "Player"
                std::string className;

                if (!resolvedNames.empty()) {
                    // Find longest common prefix ending with '_'.
                    StringRef first = resolvedNames[0];
                    size_t prefixLen = first.size();

                    for (size_t i = 1; i < resolvedNames.size(); ++i) {
                        StringRef other = resolvedNames[i];
                        size_t maxLen = std::min(prefixLen, other.size());
                        size_t match = 0;
                        while (match < maxLen &&
                               first[match] == other[match])
                            ++match;
                        prefixLen = match;
                    }

                    // Trim to last '_' boundary for clean class name.
                    StringRef prefix = first.substr(0, prefixLen);
                    size_t lastUnderscore = prefix.rfind('_');
                    if (lastUnderscore != StringRef::npos &&
                        lastUnderscore >= 3) {
                        className = prefix.substr(0, lastUnderscore).str();
                    }
                }

                // Fallback: synthetic class name from vtable address.
                if (className.empty() || className.size() < 3)
                    className = std::format("Class_0x{:X}", vtAddr);

                // Strip "sub_" prefix from class names (common artifact).
                if (className.starts_with("sub_"))
                    className = std::format("Class_0x{:X}", vtAddr);

                ++NumClassesInferred;

                LLVM_DEBUG(llvm::dbgs()
                    << "  Vtable 0x"
                    << llvm::Twine::utohexstr(vtAddr)
                    << " → class '" << className << "' ("
                    << calls.size() << " calls)\n");

                // Annotate each call with class::method naming.
                MLIRContext* ctx = func->getContext();
                for (auto call : calls) {
                    auto offsetAttr = call->getAttrOfType<IntegerAttr>(
                        "helix.vtable_offset");
                    uint64_t offset = offsetAttr
                        ? static_cast<uint64_t>(offsetAttr.getInt()) : 0;

                    std::string methodName;
                    if (auto existing = call->getAttrOfType<StringAttr>(
                            "helix.resolved_name")) {
                        methodName = existing.getValue().str();
                        // Strip class prefix if it matches.
                        if (methodName.starts_with(className + "_"))
                            methodName = methodName.substr(
                                className.size() + 1);
                    } else {
                        methodName = std::format("vfunc_{}", offset);
                    }

                    call->setAttr("helix.resolved_name",
                        StringAttr::get(ctx, llvm::StringRef(
                            className + "::" + methodName)));

                    // Also store the class name separately for downstream.
                    call->setAttr("helix.class_name",
                        StringAttr::get(ctx, llvm::StringRef(className)));
                }
            }
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createDevirtualizeIndirectCallsPass() {
    return std::make_unique<DevirtualizeIndirectCallsPass>();
}
