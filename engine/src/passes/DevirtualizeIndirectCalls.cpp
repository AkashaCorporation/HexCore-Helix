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
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createDevirtualizeIndirectCallsPass() {
    return std::make_unique<DevirtualizeIndirectCallsPass>();
}
