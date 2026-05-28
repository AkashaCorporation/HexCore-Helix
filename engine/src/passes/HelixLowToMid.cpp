/// @file HelixLowToMid.cpp
/// @brief MLIR conversion pass: HelixLow Dialect → HelixMid Dialect.
///
/// This pass bridges the machine-level HelixLow representation to the
/// ISA-agnostic HelixMid representation.  Key transformations:
///
///   - Register read/write → abstract variable ref/assign
///   - Raw memory load/store → typed load/store
///   - Flag-producing arithmetic → pure value expressions
///   - CMOV → select
///   - REP MOVS/STOS → memcpy/memset intrinsics
///   - CMP/TEST + flag use → comparison expressions
///   - Function/control flow ops → mid-level equivalents
///
/// Uses the MLIR dialect conversion framework (ConversionTarget +
/// RewritePatternSet) for principled, verifiable lowering.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/dialects/HelixMidOps.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/Debug.h"

#include <format>
#include <string>

#define DEBUG_TYPE "helix-low-to-mid"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Slot ID allocation
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

/// Allocates unique slot IDs for variables during HelixLow → HelixMid
/// conversion.  Maps register names and stack offsets to slot IDs.
struct SlotAllocator {
    llvm::StringMap<uint32_t> reg_slots;
    llvm::DenseMap<int64_t, uint32_t> stack_slots;
    uint32_t next_slot = 0;

    uint32_t getOrCreateRegSlot(llvm::StringRef reg_name) {
        auto it = reg_slots.find(reg_name);
        if (it != reg_slots.end())
            return it->second;
        uint32_t id = next_slot++;
        reg_slots[reg_name] = id;
        return id;
    }

    uint32_t getOrCreateStackSlot(int64_t offset) {
        auto it = stack_slots.find(offset);
        if (it != stack_slots.end())
            return it->second;
        uint32_t id = next_slot++;
        stack_slots[offset] = id;
        return id;
    }

    uint32_t allocTemp() { return next_slot++; }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Map HelixLow BinOpKind → HelixMid BinExprKind
// ═══════════════════════════════════════════════════════════════════════════════

static mid::BinExprKind mapBinOpKind(low::BinOpKind kind) {
    switch (kind) {
    case low::BinOpKind::Add:  return mid::BinExprKind::Add;
    case low::BinOpKind::Sub:  return mid::BinExprKind::Sub;
    case low::BinOpKind::Mul:  return mid::BinExprKind::Mul;
    case low::BinOpKind::IMul: return mid::BinExprKind::Mul;
    case low::BinOpKind::Div:  return mid::BinExprKind::Div;
    case low::BinOpKind::IDiv: return mid::BinExprKind::Div;
    case low::BinOpKind::And:  return mid::BinExprKind::BitAnd;
    case low::BinOpKind::Or:   return mid::BinExprKind::BitOr;
    case low::BinOpKind::Xor:  return mid::BinExprKind::BitXor;
    case low::BinOpKind::Shl:  return mid::BinExprKind::Shl;
    case low::BinOpKind::Shr:  return mid::BinExprKind::Shr;
    case low::BinOpKind::Sar:  return mid::BinExprKind::Sar;
    case low::BinOpKind::Rol:  return mid::BinExprKind::Shl;  // approx
    case low::BinOpKind::Ror:  return mid::BinExprKind::Shr;  // approx
    }
    return mid::BinExprKind::Add;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Conversion Patterns
// ═══════════════════════════════════════════════════════════════════════════════

// FIX-087 (2026-05-20): slot_id packing = (name_hash << 16) | version
//
// `ssa_version` is stamped on every reg.read / reg.write by
// `RegisterSSARenamePass`, which runs immediately before this pass.  When
// it's absent (e.g. a custom pipeline that skips the pass), default to
// version 0 and emit a debug trace — output is still produced, but the
// FIX-087 cross-version disambiguation is disabled for that op.
static uint32_t computeSlotIdFromRegOp(Operation* op, llvm::StringRef reg_name) {
    uint32_t name_hash = static_cast<uint32_t>(llvm::hash_value(reg_name)) & 0xFFFFu;
    uint32_t version = 0;
    if (auto vAttr = op->getAttrOfType<IntegerAttr>("ssa_version")) {
        version = static_cast<uint32_t>(vAttr.getValue().getZExtValue());
    } else {
        LLVM_DEBUG(llvm::dbgs() << "[register-ssa] no version on "
                                << op->getName().getStringRef() << " "
                                << reg_name << "; defaulting to 0\n");
    }
    return (name_hash << 16) | (version & 0xFFFFu);
}

/// Convert helix_low.reg.read → helix_mid.var.ref
struct RegReadToVarRef : public OpConversionPattern<low::RegReadOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::RegReadOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto result_type = op.getResult().getType();

        // FIX-087: slot_id now encodes (name_hash << 16) | ssa_version,
        // disambiguating distinct logical defs of the same physical register.
        auto reg_name = op.getRegName();
        uint32_t slot_id = computeSlotIdFromRegOp(op.getOperation(), reg_name);

        auto new_op = rewriter.create<mid::VarRefOp>(
            op.getLoc(),
            result_type,
            rewriter.getUI32IntegerAttr(slot_id),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_low.reg.write → helix_mid.assign
struct RegWriteToAssign : public OpConversionPattern<low::RegWriteOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::RegWriteOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        // FIX-087: same versioned slot_id as RegReadToVarRef.
        auto reg_name = op.getRegName();
        uint32_t slot_id = computeSlotIdFromRegOp(op.getOperation(), reg_name);

        rewriter.create<mid::AssignOp>(
            op.getLoc(),
            rewriter.getUI32IntegerAttr(slot_id),
            adaptor.getValue(),
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

// ─── FIX-082 (Wave 19): pointer-provenance decomposition helper ──────────────
//
// When a memory-access address is shaped `llvm.add(base, llvm.constant)` (or
// symmetric `add(constant, base)`), the access is a struct-field reference.
// We recover the (base, offset) pair so MemReadToLoad / MemWriteToStore can
// emit `mid::FieldPtrOp(base, offset)` instead of leaving the raw arithmetic
// in place.  This activates the FieldPtrOp/IndexPtrOp pipeline that was
// already wired through `HelixMidToHigh::MidFieldPtrToHighField` and
// `CAstBuilder::midFieldPtr` but never fed by an emitter.
//
// Phase 2 scope (this commit): ONLY the simple `add(base, const)` shape.
// `Add(Add(base, c1), c2)`, `Add(base, Mul/Shl(idx, stride))`, and arith
// dialect variants are deferred to Phase 3.  Anything that doesn't match
// the narrow shape falls through to the original opaque-address conversion
// (no behavioural change for those addresses).
//
// Reference for the symmetry handling: `RecoverStructTypes::decomposeAddress`
// (lines 72-92), adapted here for LLVM dialect operands since the address
// chain is still in LLVM dialect form at HelixLowToMid time (the address
// arithmetic was emitted directly by `RemillToHelixLow` and never lifted
// to `mid.bin.expr`).
struct AddrFieldDecomposition {
    Value base;
    uint64_t offset;
};

static std::optional<AddrFieldDecomposition>
tryDecomposeAddrAsField(Value addr) {
    if (!addr) return std::nullopt;
    auto addOp = addr.getDefiningOp<LLVM::AddOp>();
    if (!addOp) return std::nullopt;
    auto lhs = addOp.getLhs();
    auto rhs = addOp.getRhs();
    if (!lhs || !rhs) return std::nullopt;

    auto extractConst = [](Value v) -> std::optional<uint64_t> {
        auto cst = v.getDefiningOp<LLVM::ConstantOp>();
        if (!cst) return std::nullopt;
        auto intAttr = dyn_cast<IntegerAttr>(cst.getValue());
        if (!intAttr) return std::nullopt;
        return intAttr.getValue().getZExtValue();
    };

    auto lhsConst = extractConst(lhs);
    auto rhsConst = extractConst(rhs);

    // Refuse if both operands are constants (fully-foldable; no provenance).
    if (lhsConst && rhsConst) return std::nullopt;
    // Refuse zero-offset — not a real field, just a pointer alias.
    if (rhsConst && *rhsConst == 0) return std::nullopt;
    if (lhsConst && *lhsConst == 0) return std::nullopt;

    if (rhsConst)
        return AddrFieldDecomposition{lhs, *rhsConst};
    if (lhsConst)
        return AddrFieldDecomposition{rhs, *lhsConst};
    return std::nullopt;
}

/// Convert helix_low.mem.read → helix_mid.load
struct MemReadToLoad : public OpConversionPattern<low::MemReadOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::MemReadOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        // FIX-082: if the address is `llvm.add(base, const)`, lift it to
        // `mid::FieldPtrOp(base, offset)` before constructing the LoadOp.
        // The FieldPtrOp result becomes the LoadOp's addr operand and is
        // later converted by `MidFieldPtrToHighField` (already wired) into
        // a `high::FieldAccessOp`, which `CAstBuilder` renders as
        // `base->field_0xN`.  Fallback: leave the address opaque.
        Value loadAddr = adaptor.getAddr();
        if (auto decomp = tryDecomposeAddrAsField(loadAddr)) {
            auto fieldPtr = rewriter.create<mid::FieldPtrOp>(
                op.getLoc(),
                loadAddr.getType(),
                decomp->base,
                /*field_offset=*/decomp->offset,
                /*field_name=*/StringAttr{},
                /*address=*/IntegerAttr{}
            );
            loadAddr = fieldPtr.getResult();
        }

        auto new_op = rewriter.create<mid::LoadOp>(
            op.getLoc(),
            op.getResult().getType(),
            loadAddr,
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_low.mem.write → helix_mid.store
struct MemWriteToStore : public OpConversionPattern<low::MemWriteOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::MemWriteOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        // FIX-082: same provenance lift as MemReadToLoad — emit FieldPtrOp
        // when the address is `llvm.add(base, const)`.
        Value storeAddr = adaptor.getAddr();
        if (auto decomp = tryDecomposeAddrAsField(storeAddr)) {
            auto fieldPtr = rewriter.create<mid::FieldPtrOp>(
                op.getLoc(),
                storeAddr.getType(),
                decomp->base,
                /*field_offset=*/decomp->offset,
                /*field_name=*/StringAttr{},
                /*address=*/IntegerAttr{}
            );
            storeAddr = fieldPtr.getResult();
        }

        rewriter.create<mid::StoreOp>(
            op.getLoc(),
            storeAddr,
            adaptor.getValue(),
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_low.binop → helix_mid.binexpr
/// Drops flag outputs — flag semantics resolved at this stage.
struct BinOpToBinExpr : public OpConversionPattern<low::BinOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::BinOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto mid_kind = mapBinOpKind(op.getKind());
        auto loc = op.getLoc();
        auto result_type = op.getResult().getType();

        // Ensure arithmetic operates on integer types, not pointers.
        // Pointer-typed BinOps (from address arithmetic in Remill IR)
        // must be cast to i64 to avoid crashes in downstream patterns.
        auto i64Type = rewriter.getI64Type();
        auto arith_type = isa<IntegerType>(result_type) ? result_type : i64Type;

        auto lhs = adaptor.getLhs();
        auto rhs = adaptor.getRhs();
        if (!isa<IntegerType>(lhs.getType()))
            lhs = rewriter.create<mid::CastOp>(loc, arith_type, lhs, IntegerAttr{}).getResult();
        if (!isa<IntegerType>(rhs.getType()))
            rhs = rewriter.create<mid::CastOp>(loc, arith_type, rhs, IntegerAttr{}).getResult();

        auto new_op = rewriter.create<mid::BinExprOp>(
            loc,
            arith_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid_kind),
            lhs, rhs,
            op.getAddressAttr()
        );

        // Cast back to original type if it was pointer
        Value result_val = new_op.getResult();
        if (result_type != arith_type) {
            result_val = rewriter.create<mid::CastOp>(
                loc, result_type, result_val, IntegerAttr{}).getResult();
        }

        // Replace the value result.  Flag results are constant false
        // (dead flags eliminated by DCE).
        auto i1_type = rewriter.getI1Type();
        auto false_val = rewriter.create<mlir::arith::ConstantOp>(
            loc, i1_type, rewriter.getBoolAttr(false));

        rewriter.replaceOp(op, {
            result_val,
            false_val, false_val, false_val, false_val
        });
        return success();
    }
};

/// Convert helix_low.cmp → helix_mid.binexpr with comparison kind
struct CmpToComparison : public OpConversionPattern<low::CmpOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::CmpOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto i1_type = rewriter.getI1Type();
        auto loc = op.getLoc();

        // CMP produces flags.  Create individual comparison expressions
        // for each flag that is actually used.
        // ZF: lhs == rhs
        auto zero_flag = rewriter.create<mid::BinExprOp>(
            loc, i1_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Eq),
            adaptor.getLhs(), adaptor.getRhs(),
            op.getAddressAttr()
        );

        // SF: (lhs - rhs) < 0  →  lhs < rhs (signed)
        auto sign_flag = rewriter.create<mid::BinExprOp>(
            loc, i1_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Lt),
            adaptor.getLhs(), adaptor.getRhs(),
            op.getAddressAttr()
        );

        // CF: lhs < rhs (unsigned) — approximated as same comparison
        auto carry_flag = rewriter.create<mid::BinExprOp>(
            loc, i1_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Lt),
            adaptor.getLhs(), adaptor.getRhs(),
            op.getAddressAttr()
        );

        // OF: overflow — approximate as false for now
        auto of_val = rewriter.create<mlir::arith::ConstantOp>(
            loc, i1_type, rewriter.getBoolAttr(false));

        rewriter.replaceOp(op, {
            carry_flag.getResult(),
            zero_flag.getResult(),
            sign_flag.getResult(),
            of_val
        });
        return success();
    }
};

/// Convert helix_low.test → helix_mid.binexpr (Ne/Eq with zero)
struct TestToComparison : public OpConversionPattern<low::TestOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::TestOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto i1_type = rewriter.getI1Type();
        auto loc = op.getLoc();

        // TEST lhs, rhs → AND without storing.  ZF = (lhs & rhs) == 0
        // Use i64 for arithmetic if operands are pointer-typed
        auto operand_type = adaptor.getLhs().getType();
        auto arith_type = isa<IntegerType>(operand_type) ? operand_type : rewriter.getI64Type();

        auto lhs = adaptor.getLhs();
        auto rhs = adaptor.getRhs();
        if (!isa<IntegerType>(lhs.getType()))
            lhs = rewriter.create<mid::CastOp>(loc, arith_type, lhs, IntegerAttr{}).getResult();
        if (!isa<IntegerType>(rhs.getType()))
            rhs = rewriter.create<mid::CastOp>(loc, arith_type, rhs, IntegerAttr{}).getResult();

        auto and_result = rewriter.create<mid::BinExprOp>(
            loc, arith_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::BitAnd),
            lhs, rhs,
            op.getAddressAttr()
        );

        auto zero = rewriter.create<mid::ConstantOp>(
            loc, arith_type,
            rewriter.getIntegerAttr(arith_type, 0),
            /*address=*/mlir::IntegerAttr{}
        );

        auto zero_flag = rewriter.create<mid::BinExprOp>(
            loc, i1_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Eq),
            and_result.getResult(), zero.getResult(),
            op.getAddressAttr()
        );

        // SF: sign bit of (lhs & rhs)
        auto sign_flag = rewriter.create<mid::BinExprOp>(
            loc, i1_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Lt),
            and_result.getResult(), zero.getResult(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, {zero_flag.getResult(), sign_flag.getResult()});
        return success();
    }
};

/// Convert helix_low.cmov → helix_mid.select
struct CMovToSelect : public OpConversionPattern<low::CMovOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::CMovOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<mid::SelectOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getFlagValue(),
            adaptor.getTrueVal(),
            adaptor.getFalseVal(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_low.call → helix_mid.call
struct CallToMidCall : public OpConversionPattern<low::CallOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::CallOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        llvm::errs() << "[P0-DEBUG] CallToMidCall: attempting conversion for CallOp"
                     << " target=" << (op.getTargetNameAttr() ? op.getTargetNameAttr().getValue() : "none")
                     << " nArgs=" << op.getArgs().size()
                     << " nAdaptedArgs=" << adaptor.getArgs().size()
                     << "\n";

        // Check if adapted args are valid
        for (unsigned i = 0; i < adaptor.getArgs().size(); ++i) {
            auto arg = adaptor.getArgs()[i];
            if (!arg) {
                llvm::errs() << "[P0-DEBUG] CallToMidCall: adapted arg " << i << " is NULL!\n";
            }
        }

        // Resolve the actual callee address.
        //
        // Priority:
        //   1. If target_name is "sub_<hex>", parse the callee address from it.
        //   2. If the target_addr operand is a constant, use it directly.
        //   3. Fall back to instruction address (address attr) — but mark
        //      the call as indirect so downstream passes don't confuse it
        //      with a direct call to that address.
        uint64_t callee_addr = 0;
        bool is_indirect = false;
        StringAttr callee_name_attr = op.getTargetNameAttr();

        if (callee_name_attr) {
            // Parse address from "sub_<hex>" style name.
            auto name = callee_name_attr.getValue();
            if (name.starts_with("sub_")) {
                auto hexPart = name.drop_front(4);
                uint64_t parsed = 0;
                if (!hexPart.getAsInteger(16, parsed))
                    callee_addr = parsed;
            }
        }

        if (callee_addr == 0) {
            // Try to evaluate the SSA target operand to a constant.
            auto targetVal = op.getTargetAddr();
            if (auto constOp = targetVal.getDefiningOp<LLVM::ConstantOp>()) {
                if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                    callee_addr = intAttr.getValue().getZExtValue();
            } else if (auto constOp = targetVal.getDefiningOp<arith::ConstantOp>()) {
                if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                    callee_addr = intAttr.getValue().getZExtValue();
            }
        }

        // Track vtable offset for indirect calls with base+offset pattern.
        // CALL [RAX+0x18] shows up as an AddOp where one operand is the
        // constant vtable offset and the other is the base register read.
        int64_t vtable_offset = -1;

        if (callee_addr == 0) {
            // Target is indirect (runtime-computed).  Leave callee_addr = 0
            // so downstream passes know the target is truly unresolved.
            // The instruction address is already in the `address` attribute.
            is_indirect = true;

            // Try to extract vtable offset from the target expression.
            // Pattern: target_addr = Add(base_reg, constant_offset)
            auto targetVal = op.getTargetAddr();

            // Check LLVM::AddOp pattern
            if (auto addOp = targetVal.getDefiningOp<LLVM::AddOp>()) {
                // Try RHS as constant
                if (auto rhsConst = addOp.getRhs().getDefiningOp<LLVM::ConstantOp>()) {
                    if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue()))
                        vtable_offset = intAttr.getValue().getSExtValue();
                }
                // Try LHS as constant (commuted)
                if (vtable_offset < 0) {
                    if (auto lhsConst = addOp.getLhs().getDefiningOp<LLVM::ConstantOp>()) {
                        if (auto intAttr = dyn_cast<IntegerAttr>(lhsConst.getValue()))
                            vtable_offset = intAttr.getValue().getSExtValue();
                    }
                }
            }

            // Check arith::AddIOp pattern
            if (vtable_offset < 0) {
                if (auto addOp = targetVal.getDefiningOp<arith::AddIOp>()) {
                    if (auto rhsConst = addOp.getRhs().getDefiningOp<arith::ConstantOp>()) {
                        if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue()))
                            vtable_offset = intAttr.getValue().getSExtValue();
                    }
                    if (vtable_offset < 0) {
                        if (auto lhsConst = addOp.getLhs().getDefiningOp<arith::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(lhsConst.getValue()))
                                vtable_offset = intAttr.getValue().getSExtValue();
                        }
                    }
                }
            }

            // Check helix::low::LeaOp pattern (LEA with displacement)
            if (vtable_offset < 0) {
                if (auto leaOp = targetVal.getDefiningOp<low::LeaOp>()) {
                    auto disp = leaOp.getDisplacement();
                    if (disp != 0)
                        vtable_offset = disp;
                }
            }
        }

        // Preserve the low.call's result type on mid.call so the callee's
        // return value remains a distinct SSA edge through the pipeline.
        // When the low op had no result (e.g. CMPXCHG intrinsic marker),
        // getResultTypes() is empty and mid.call also becomes resultless.
        auto midCall = rewriter.create<mid::CallOp>(
            op.getLoc(),
            /*result=*/op.getResultTypes(),
            rewriter.getI64IntegerAttr(callee_addr),
            callee_name_attr,
            adaptor.getArgs(),
            op.getAddressAttr()
        );

        if (is_indirect) {
            midCall->setAttr("is_indirect", rewriter.getUnitAttr());
            if (vtable_offset >= 0)
                midCall->setAttr("vtable_offset",
                    rewriter.getI64IntegerAttr(vtable_offset));
        }

        llvm::errs() << "[P0-DEBUG] CallToMidCall: SUCCESS → mid.call"
                     << " name=" << (callee_name_attr ? callee_name_attr.getValue() : "none")
                     << " addr=" << callee_addr
                     << " hasResult=" << (op.getNumResults() > 0)
                     << "\n";

        // replaceOp forwards SSA uses of the old result onto the new one.
        // eraseOp would leave dangling references for callers that consume
        // the call's result (e.g. the synthetic RegWrite RAX after CallOp).
        if (op.getNumResults() > 0) {
            rewriter.replaceOp(op, midCall->getResults());
        } else {
            rewriter.eraseOp(op);
        }
        return success();
    }
};

/// Convert helix_low.ret → helix_mid.return
struct RetToReturn : public OpConversionPattern<low::RetOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::RetOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<mid::ReturnOp>(
            op.getLoc(),
            /*value=*/Value{},
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_low.lea → helix_mid.binexpr (address computation)
struct LeaToBinExpr : public OpConversionPattern<low::LeaOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::LeaOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto loc = op.getLoc();
        auto result_type = op.getResult().getType();

        // LEA produces addresses — use i64 for all arithmetic to avoid
        // pointer-typed mid::BinExprOp/ConstantOp (crashes Mid patterns).
        auto i64Type = rewriter.getI64Type();
        auto arith_type = isa<IntegerType>(result_type) ? result_type : i64Type;

        // Cast operands to integer if they're pointer-typed
        auto base = adaptor.getBase();
        auto index = adaptor.getIndex();
        if (!isa<IntegerType>(base.getType()))
            base = rewriter.create<mid::CastOp>(loc, arith_type, base, IntegerAttr{}).getResult();
        if (!isa<IntegerType>(index.getType()))
            index = rewriter.create<mid::CastOp>(loc, arith_type, index, IntegerAttr{}).getResult();

        // LEA: base + index * scale + displacement
        auto scale_val = rewriter.create<mid::ConstantOp>(
            loc, arith_type,
            rewriter.getIntegerAttr(arith_type, op.getScale()),
            /*address=*/mlir::IntegerAttr{}
        );
        auto scaled_index = rewriter.create<mid::BinExprOp>(
            loc, arith_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Mul),
            index, scale_val.getResult(),
            /*address=*/mlir::IntegerAttr{}
        );

        auto base_plus_index = rewriter.create<mid::BinExprOp>(
            loc, arith_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Add),
            base, scaled_index.getResult(),
            /*address=*/mlir::IntegerAttr{}
        );

        Value final_result;
        if (op.getDisplacement() != 0) {
            auto disp_val = rewriter.create<mid::ConstantOp>(
                loc, arith_type,
                rewriter.getIntegerAttr(arith_type, op.getDisplacement()),
                /*address=*/mlir::IntegerAttr{}
            );
            auto sum = rewriter.create<mid::BinExprOp>(
                loc, arith_type,
                mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Add),
                base_plus_index.getResult(), disp_val.getResult(),
                op.getAddressAttr()
            );
            final_result = sum.getResult();
        } else {
            final_result = base_plus_index.getResult();
        }

        // Cast back to original type if it was pointer
        if (result_type != arith_type) {
            final_result = rewriter.create<mid::CastOp>(
                loc, result_type, final_result, IntegerAttr{}).getResult();
        }

        rewriter.replaceOp(op, final_result);
        return success();
    }
};

/// Convert helix_low.movzx → helix_mid.cast
struct MovZxToCast : public OpConversionPattern<low::MovZxOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::MovZxOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<mid::CastOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getSrc(),
            op.getAddressAttr()
        );
        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_low.movsx → helix_mid.cast
struct MovSxToCast : public OpConversionPattern<low::MovSxOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::MovSxOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<mid::CastOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getSrc(),
            op.getAddressAttr()
        );
        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_low.rep.movs → helix_mid.memcpy
struct RepMovsToMemcpy : public OpConversionPattern<low::RepMovsOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::RepMovsOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<mid::MemcpyOp>(
            op.getLoc(),
            adaptor.getDst(), adaptor.getSrc(), adaptor.getCount(),
            op.getAddressAttr()
        );
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_low.rep.stos → helix_mid.memset
struct RepStosToMemset : public OpConversionPattern<low::RepStosOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::RepStosOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<mid::MemsetOp>(
            op.getLoc(),
            adaptor.getDst(), adaptor.getValue(), adaptor.getCount(),
            op.getAddressAttr()
        );
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_low.nop → erase (no mid equivalent)
struct NopErase : public OpConversionPattern<low::NopOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::NopOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_low.int3 → erase
struct Int3Erase : public OpConversionPattern<low::Int3Op> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::Int3Op op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_low.unaryop → helix_mid.unexpr or binexpr
/// Inc/Dec are lowered to BinExpr(Add/Sub, x, 1) since they're
/// semantically x+1 / x-1, not unary operations.
struct UnaryOpToUnExpr : public OpConversionPattern<low::UnaryOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::UnaryOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto loc = op.getLoc();
        auto result_type = op.getResult().getType();
        auto i1_type = rewriter.getI1Type();
        auto false_val = rewriter.create<mlir::arith::ConstantOp>(
            loc, i1_type, rewriter.getBoolAttr(false));

        // Inc/Dec → BinExpr(Add/Sub, operand, 1)
        if (op.getKind() == low::UnaryOpKind::Inc ||
            op.getKind() == low::UnaryOpKind::Dec) {
            // Use integer type for arithmetic (pointer Inc/Dec = pointer + 1)
            auto arith_type = isa<IntegerType>(result_type) ? result_type : rewriter.getI64Type();
            auto one = rewriter.create<mid::ConstantOp>(
                loc, arith_type,
                rewriter.getIntegerAttr(arith_type, 1),
                /*address=*/mlir::IntegerAttr{}
            );
            auto bin_kind = (op.getKind() == low::UnaryOpKind::Inc)
                ? mid::BinExprKind::Add
                : mid::BinExprKind::Sub;
            // Cast operand to integer if pointer-typed
            auto operand = adaptor.getOperand();
            if (!isa<IntegerType>(operand.getType()))
                operand = rewriter.create<mid::CastOp>(loc, arith_type, operand, IntegerAttr{}).getResult();

            auto new_op = rewriter.create<mid::BinExprOp>(
                loc, arith_type,
                mid::BinExprKindAttr::get(rewriter.getContext(), bin_kind),
                operand, one.getResult(),
                op.getAddressAttr()
            );

            // Cast back if original was pointer
            Value inc_result = new_op.getResult();
            if (result_type != arith_type)
                inc_result = rewriter.create<mid::CastOp>(loc, result_type, inc_result, IntegerAttr{}).getResult();

            rewriter.replaceOp(op, {
                inc_result, false_val, false_val
            });
            return success();
        }

        // Neg, Not, Bswap, BSF, BSR → UnExpr
        mid::UnExprKind mid_kind;
        switch (op.getKind()) {
        case low::UnaryOpKind::Neg:   mid_kind = mid::UnExprKind::Neg; break;
        case low::UnaryOpKind::Not:   mid_kind = mid::UnExprKind::BitNot; break;
        default:                       mid_kind = mid::UnExprKind::Neg; break;
        }

        // Cast operand to integer if pointer-typed
        auto unary_type = isa<IntegerType>(result_type) ? result_type : rewriter.getI64Type();
        auto unary_operand = adaptor.getOperand();
        if (!isa<IntegerType>(unary_operand.getType()))
            unary_operand = rewriter.create<mid::CastOp>(loc, unary_type, unary_operand, IntegerAttr{}).getResult();

        auto new_op = rewriter.create<mid::UnExprOp>(
            loc, unary_type,
            mid::UnExprKindAttr::get(rewriter.getContext(), mid_kind),
            unary_operand,
            op.getAddressAttr()
        );

        Value unary_result = new_op.getResult();
        if (result_type != unary_type)
            unary_result = rewriter.create<mid::CastOp>(loc, result_type, unary_result, IntegerAttr{}).getResult();

        rewriter.replaceOp(op, {
            unary_result, false_val, false_val
        });
        return success();
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct HelixLowToMidPass
    : public PassWrapper<HelixLowToMidPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HelixLowToMidPass)

    StringRef getArgument() const final { return "helix-low-to-mid"; }
    StringRef getDescription() const final {
        return "Convert HelixLow dialect to HelixMid dialect";
    }

    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<helix::mid::HelixMidDialect>();
        registry.insert<mlir::arith::ArithDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        auto *ctx = &getContext();

        // [P0-DEBUG] Count low::CallOps before conversion
        {
            unsigned lowCalls = 0;
            module.walk([&](low::CallOp) { ++lowCalls; });
            llvm::errs() << "[P0-DEBUG] HelixLowToMid entry: "
                         << lowCalls << " low.call ops\n";
        }

        // Set up conversion target: HelixMid is legal, HelixLow is illegal
        ConversionTarget target(*ctx);
        target.addLegalDialect<helix::mid::HelixMidDialect>();
        target.addLegalDialect<mlir::arith::ArithDialect>();
        target.addLegalDialect<mlir::LLVM::LLVMDialect>();
        target.addIllegalDialect<helix::low::HelixLowDialect>();

        // Allow HelixLow ops that we don't convert yet (JmpOp, JccOp, etc.)
        // to survive — they'll be handled by subsequent passes.
        target.addLegalOp<low::JmpOp>();
        target.addLegalOp<low::JccOp>();
        target.addLegalOp<low::PushOp>();
        target.addLegalOp<low::PopOp>();
        target.addLegalOp<low::XchgOp>();

        target.addLegalOp<low::FuncOp>();

        // Populate patterns
        RewritePatternSet patterns(ctx);
        patterns.add<
            RegReadToVarRef,
            RegWriteToAssign,
            MemReadToLoad,
            MemWriteToStore,
            BinOpToBinExpr,
            CmpToComparison,
            TestToComparison,
            CMovToSelect,
            CallToMidCall,
            RetToReturn,
            LeaToBinExpr,
            MovZxToCast,
            MovSxToCast,
            RepMovsToMemcpy,
            RepStosToMemset,
            NopErase,
            Int3Erase,
            UnaryOpToUnExpr
        >(ctx);

        // Run partial conversion (some HelixLow ops may remain for now)
        if (failed(applyPartialConversion(module, target, std::move(patterns)))) {
            LLVM_DEBUG(llvm::dbgs() << "HelixLowToMid: partial conversion "
                                    << "completed with unconverted ops\n");
            // Don't signal failure — partial conversion is expected during
            // incremental evolution of the pipeline.
        }

        // ── Manual CallOp conversion for ops inside low::FuncOp ──────────
        // The dialect conversion framework does not recurse into regions of
        // ops marked as legal (low::FuncOp).  Any low::CallOps that live
        // inside a FuncOp region are invisible to applyPartialConversion.
        // Walk them manually and convert to mid::CallOp in-place.
        {
            SmallVector<low::CallOp, 16> callsToConvert;
            module.walk([&](low::CallOp call) {
                callsToConvert.push_back(call);
            });

            unsigned converted = 0;
            for (auto callOp : callsToConvert) {
                OpBuilder builder(callOp);

                uint64_t callee_addr = 0;
                bool is_indirect = false;
                StringAttr callee_name_attr = callOp.getTargetNameAttr();

                if (callee_name_attr) {
                    auto name = callee_name_attr.getValue();
                    if (name.starts_with("sub_")) {
                        auto hexPart = name.drop_front(4);
                        uint64_t parsed = 0;
                        if (!hexPart.getAsInteger(16, parsed))
                            callee_addr = parsed;
                    }
                }

                if (callee_addr == 0) {
                    auto targetVal = callOp.getTargetAddr();
                    if (auto constOp = targetVal.getDefiningOp<LLVM::ConstantOp>()) {
                        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                            callee_addr = intAttr.getValue().getZExtValue();
                    } else if (auto constOp = targetVal.getDefiningOp<arith::ConstantOp>()) {
                        if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue()))
                            callee_addr = intAttr.getValue().getZExtValue();
                    }
                }

                int64_t vtable_offset = -1;
                if (callee_addr == 0) {
                    is_indirect = true;
                    auto targetVal = callOp.getTargetAddr();
                    if (auto addOp = targetVal.getDefiningOp<LLVM::AddOp>()) {
                        if (auto rhsConst = addOp.getRhs().getDefiningOp<LLVM::ConstantOp>()) {
                            if (auto intAttr = dyn_cast<IntegerAttr>(rhsConst.getValue()))
                                vtable_offset = intAttr.getValue().getSExtValue();
                        }
                        if (vtable_offset < 0) {
                            if (auto lhsConst = addOp.getLhs().getDefiningOp<LLVM::ConstantOp>()) {
                                if (auto intAttr = dyn_cast<IntegerAttr>(lhsConst.getValue()))
                                    vtable_offset = intAttr.getValue().getSExtValue();
                            }
                        }
                    }
                }

                auto midCall = builder.create<mid::CallOp>(
                    callOp.getLoc(),
                    /*result=*/callOp->getResultTypes(),
                    builder.getI64IntegerAttr(callee_addr),
                    callee_name_attr,
                    callOp.getArgs(),
                    callOp.getAddressAttr()
                );

                if (is_indirect) {
                    midCall->setAttr("is_indirect", builder.getUnitAttr());
                    if (vtable_offset >= 0)
                        midCall->setAttr("vtable_offset",
                            builder.getI64IntegerAttr(vtable_offset));
                }

                llvm::errs() << "[P0-DEBUG] Manual CallOp→MidCall: "
                             << (callee_name_attr ? callee_name_attr.getValue() : "indirect")
                             << " addr=" << callee_addr << "\n";

                // Transfer any SSA uses of the low.call's result (e.g. the
                // synthetic RegWrite RAX from RemillToHelixLow) onto the new
                // mid.call.  Without this, erase() aborts with "operation
                // destroyed but still has uses" once the call produces a
                // value.
                if (callOp->getNumResults() > 0) {
                    callOp->getResult(0).replaceAllUsesWith(
                        midCall->getResult(0));
                }

                callOp->erase();
                ++converted;
            }

            llvm::errs() << "[P0-DEBUG] HelixLowToMid: manually converted "
                         << converted << " CallOps\n";
        }

        // ── Wave 22 Step 3-lite: variadic_call + bundle.create → mid.call ──────
        //
        // Full Step 3 (a first-class variadic_call op carried through every
        // tier with a bundle operand) is deferred as an architectural
        // follow-up — see project_wave22_step3_full_carriage_followup. Until
        // then we collapse to a plain mid::CallOp but, instead of dropping the
        // bundle, carry its recovery state forward as `helix.*` attributes.
        // HelixMidToHigh already forwards `helix.*` attrs onto the high::CallOp,
        // so CAstBuilder (Step 4) can read `helix.variadic_state` to emit the
        // opacity marker.  This attribute-based carriage is the trade-off
        // catalogued as Divergence 1 in project_wave22_step1_divergences.
        {
            SmallVector<low::VariadicCallOp, 16> vcallsToConvert;
            module.walk([&](low::VariadicCallOp v) {
                vcallsToConvert.push_back(v);
            });
            for (auto vCall : vcallsToConvert) {
                OpBuilder builder(vCall);
                StringAttr calleeNameAttr = vCall.getTargetNameAttr();
                uint64_t calleeAddr = 0;
                if (auto targetVal = vCall.getTargetAddr()) {
                    if (auto cOp = targetVal.getDefiningOp<LLVM::ConstantOp>()) {
                        if (auto ia = dyn_cast<IntegerAttr>(cOp.getValue()))
                            calleeAddr = ia.getValue().getZExtValue();
                    } else if (auto cOp =
                               targetVal.getDefiningOp<arith::ConstantOp>()) {
                        if (auto ia = dyn_cast<IntegerAttr>(cOp.getValue()))
                            calleeAddr = ia.getValue().getZExtValue();
                    }
                }
                auto midCall = builder.create<mid::CallOp>(
                    vCall.getLoc(), /*result=*/vCall->getResultTypes(),
                    builder.getI64IntegerAttr(calleeAddr), calleeNameAttr,
                    vCall.getFixedArgs(), vCall.getAddressAttr());

                // Carry the bundle's recovery state forward as helix.* attrs.
                // These are auto-propagated mid→high by HelixMidToHigh's
                // existing `helix.*` attribute forwarding, so they reach the
                // high::CallOp that Step 4 (CAstBuilder) inspects.
                if (auto bundleOp = vCall.getRawBundle()
                                         .getDefiningOp<low::BundleCreateOp>()) {
                    const char* stateStr = "opaque";
                    switch (bundleOp.getState()) {
                    case low::BundleState::Zeroed:
                        stateStr = "zeroed"; break;
                    case low::BundleState::PartiallyRecovered:
                        stateStr = "partially_recovered"; break;
                    case low::BundleState::Recovered:
                        stateStr = "recovered"; break;
                    case low::BundleState::Opaque:
                        stateStr = "opaque"; break;
                    }
                    midCall->setAttr("helix.variadic_state",
                                     builder.getStringAttr(stateStr));
                    midCall->setAttr(
                        "helix.variadic_fixed_args_count",
                        builder.getI64IntegerAttr(
                            static_cast<int64_t>(vCall.getFixedArgs().size())));
                    if (auto prov = bundleOp.getProvenance())
                        midCall->setAttr("helix.variadic_provenance",
                                         builder.getStringAttr(*prov));
                }

                if (vCall->getNumResults() > 0) {
                    vCall->getResult(0).replaceAllUsesWith(
                        midCall->getResult(0));
                }
                vCall->erase();
            }
            SmallVector<low::BundleCreateOp, 16> bundlesToErase;
            module.walk([&](low::BundleCreateOp b) {
                if (b->use_empty()) bundlesToErase.push_back(b);
            });
            for (auto b : bundlesToErase) b->erase();
            if (!vcallsToConvert.empty()) {
                llvm::errs() << "[P0-DEBUG] Wave22-Step2.5 stopgap: "
                             << vcallsToConvert.size()
                             << " variadic_call->mid.call\n";
            }
        }

        // [P0-DEBUG] Final count
        {
            unsigned lowCalls = 0, midCalls = 0;
            module.walk([&](Operation* op) {
                if (isa<low::CallOp>(op)) ++lowCalls;
                else if (isa<mid::CallOp>(op)) ++midCalls;
            });
            llvm::errs() << "[P0-DEBUG] HelixLowToMid exit: "
                         << lowCalls << " low.call, "
                         << midCalls << " mid.call\n";
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixLowToMidPass() {
    return std::make_unique<HelixLowToMidPass>();
}
