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
#include "helix/dialects/HelixHighOps.h"
#include "helix/utils/Debug.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/Debug.h"

#include <format>
#include <cstdlib>
#include <string>

#define DEBUG_TYPE "helix-low-to-mid"

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Slot ID allocation
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

static void copyRecoveryAttrs(Operation* source, Operation* target) {
    for (NamedAttribute attribute : source->getAttrs()) {
        StringRef name = attribute.getName().getValue();
        if (name.starts_with("helix.") || name == "inferred_type")
            target->setAttr(attribute.getName(), attribute.getValue());
    }
}

static mid::SlotKind mapRecoveredStorage(high::StorageKind storage) {
    switch (storage) {
    case high::StorageKind::Stack:     return mid::SlotKind::Stack;
    case high::StorageKind::Register:  return mid::SlotKind::Register;
    case high::StorageKind::Global:    return mid::SlotKind::Global;
    case high::StorageKind::Parameter: return mid::SlotKind::Param;
    case high::StorageKind::Temporary: return mid::SlotKind::Temp;
    }
    return mid::SlotKind::Temp;
}

static mid::CastKind mapRecoveredCast(high::CastKind kind) {
    return static_cast<mid::CastKind>(static_cast<uint32_t>(kind));
}

static void normalizeRecoveredHighToMid(ModuleOp module) {
    SmallVector<high::AssignOp, 64> assignments;
    SmallVector<high::ReturnOp, 8> returns;
    SmallVector<high::CastOp, 64> casts;
    SmallVector<high::IntLitOp, 16> literals;
    SmallVector<high::VarRefOp, 128> references;
    SmallVector<high::VarDeclOp, 64> declarations;
    module.walk([&](high::AssignOp op) { assignments.push_back(op); });
    module.walk([&](high::ReturnOp op) { returns.push_back(op); });
    module.walk([&](high::CastOp op) { casts.push_back(op); });
    module.walk([&](high::IntLitOp op) { literals.push_back(op); });
    module.walk([&](high::VarRefOp op) { references.push_back(op); });
    module.walk([&](high::VarDeclOp op) { declarations.push_back(op); });

    for (high::AssignOp op : assignments) {
        auto target = op.getTarget().getDefiningOp<high::VarRefOp>();
        if (!target)
            continue;
        OpBuilder builder(op);
        auto replacement = builder.create<mid::AssignOp>(
            op.getLoc(), target.getVarIdAttr(), op.getValue(),
            op.getAddressAttr());
        copyRecoveryAttrs(op, replacement);
        op.erase();
    }

    for (high::ReturnOp op : returns) {
        OpBuilder builder(op);
        auto replacement = builder.create<mid::ReturnOp>(
            op.getLoc(), op.getValue(), op.getAddressAttr());
        copyRecoveryAttrs(op, replacement);
        op.erase();
    }

    for (high::CastOp op : casts) {
        if (!op)
            continue;
        OpBuilder builder(op);
        mid::CastKindAttr kindAttr;
        if (auto kind = op.getCastKind()) {
            kindAttr = mid::CastKindAttr::get(
                module.getContext(), mapRecoveredCast(*kind));
        }
        auto replacement = builder.create<mid::CastOp>(
            op.getLoc(), op.getResult().getType(), op.getInput(),
            op.getAddressAttr(), kindAttr);
        copyRecoveryAttrs(op, replacement);
        op.getResult().replaceAllUsesWith(replacement.getResult());
        op.erase();
    }

    for (high::IntLitOp op : literals) {
        if (!op)
            continue;
        OpBuilder builder(op);
        auto replacement = builder.create<mid::ConstantOp>(
            op.getLoc(), op.getResult().getType(), op.getValueAttr(),
            op.getAddressAttr());
        copyRecoveryAttrs(op, replacement);
        op.getResult().replaceAllUsesWith(replacement.getResult());
        op.erase();
    }

    for (high::VarRefOp op : references) {
        if (!op)
            continue;
        OpBuilder builder(op);
        auto replacement = builder.create<mid::VarRefOp>(
            op.getLoc(), op.getResult().getType(), op.getVarIdAttr(),
            op.getAddressAttr());
        replacement->setAttr(
            "helix.recovered_name", builder.getStringAttr(op.getVarName()));
        copyRecoveryAttrs(op, replacement);
        op.getResult().replaceAllUsesWith(replacement.getResult());
        op.erase();
    }

    for (high::VarDeclOp op : declarations) {
        if (!op)
            continue;
        OpBuilder builder(op);
        auto replacement = builder.create<mid::VarDeclOp>(
            op.getLoc(), op.getVarIdAttr(),
            mid::SlotKindAttr::get(
                module.getContext(), mapRecoveredStorage(op.getStorage())),
            op.getStackOffsetAttr(), op.getInit(), op.getAddressAttr());
        replacement->setAttr(
            "helix.recovered_name", builder.getStringAttr(op.getVarName()));
        copyRecoveryAttrs(op, replacement);
        op.erase();
    }
}

static IntegerAttr getUI64Attr(Builder& builder, uint64_t value) {
    auto type = IntegerType::get(
        builder.getContext(), 64, IntegerType::Unsigned);
    return IntegerAttr::get(type, llvm::APInt(64, value, false));
}

static IntegerAttr getSI64Attr(Builder& builder, int64_t value) {
    auto type = IntegerType::get(
        builder.getContext(), 64, IntegerType::Signed);
    return IntegerAttr::get(type, llvm::APInt(64, value, true));
}

/// Collapse the temporary Low variadic-call bundle carriage before dialect
/// conversion. Full conversion must see the resulting Mid call, not reject
/// bundle.create before the old post-conversion cleanup gets a chance to run.
static unsigned collapseVariadicCallsToMid(ModuleOp module) {
    SmallVector<low::VariadicCallOp, 16> calls;
    module.walk([&](low::VariadicCallOp op) { calls.push_back(op); });

    for (low::VariadicCallOp call : calls) {
        OpBuilder builder(call);
        uint64_t calleeAddress = 0;
        if (Value target = call.getTargetAddr()) {
            if (auto constant = target.getDefiningOp<LLVM::ConstantOp>()) {
                if (auto value = dyn_cast<IntegerAttr>(constant.getValue()))
                    calleeAddress = value.getValue().getZExtValue();
            } else if (auto constant =
                           target.getDefiningOp<arith::ConstantOp>()) {
                if (auto value = dyn_cast<IntegerAttr>(constant.getValue()))
                    calleeAddress = value.getValue().getZExtValue();
            }
        }

        auto replacement = builder.create<mid::CallOp>(
            call.getLoc(), call->getResultTypes(),
            getUI64Attr(builder, calleeAddress), call.getTargetNameAttr(),
            call.getFixedArgs(), call.getAddressAttr());

        if (auto bundle =
                call.getRawBundle().getDefiningOp<low::BundleCreateOp>()) {
            const char* state = "opaque";
            switch (bundle.getState()) {
            case low::BundleState::Zeroed:
                state = "zeroed";
                break;
            case low::BundleState::PartiallyRecovered:
                state = "partially_recovered";
                break;
            case low::BundleState::Recovered:
                state = "recovered";
                break;
            case low::BundleState::Opaque:
                break;
            }
            replacement->setAttr(
                "helix.variadic_state", builder.getStringAttr(state));
            replacement->setAttr(
                "helix.variadic_fixed_args_count",
                builder.getI64IntegerAttr(
                    static_cast<int64_t>(call.getFixedArgs().size())));
            if (auto provenance = bundle.getProvenance()) {
                replacement->setAttr(
                    "helix.variadic_provenance",
                    builder.getStringAttr(*provenance));
            }
        }

        if (call->getNumResults() > 0) {
            for (auto [oldResult, newResult] :
                 llvm::zip(call->getResults(), replacement->getResults())) {
                oldResult.replaceAllUsesWith(newResult);
            }
        }
        call.erase();
    }

    SmallVector<low::BundleCreateOp, 16> unusedBundles;
    module.walk([&](low::BundleCreateOp bundle) {
        if (bundle->use_empty())
            unusedBundles.push_back(bundle);
    });
    for (low::BundleCreateOp bundle : unusedBundles)
        bundle.erase();

    return calls.size();
}

struct ResultFlags {
    Value zero;
    Value sign;
};

static Value createBoolBinary(
        ConversionPatternRewriter& rewriter, Location loc,
        mid::BinExprKind kind, Value lhs, Value rhs, IntegerAttr address) {
    return rewriter.create<mid::BinExprOp>(
        loc, rewriter.getI1Type(),
        mid::BinExprKindAttr::get(rewriter.getContext(), kind),
        lhs, rhs, address).getResult();
}

static Value createUnknownValue(
        ConversionPatternRewriter& rewriter, Location loc, Type type,
        llvm::StringRef reason, IntegerAttr address) {
    return rewriter.create<mid::UnknownValueOp>(
        loc, type, rewriter.getStringAttr(reason), address).getResult();
}

static Value coerceToIntegerType(
        ConversionPatternRewriter& rewriter, Location loc, Value value,
        Type targetType) {
    if (value.getType() == targetType)
        return value;
    return rewriter.create<mid::CastOp>(
        loc, targetType, value, IntegerAttr{},
        mid::CastKindAttr{}).getResult();
}

static mid::BinExprOp createFixedWidthBinary(
        ConversionPatternRewriter& rewriter, Location loc,
        mid::BinExprKind kind, Value lhs, Value rhs, Type resultType,
        IntegerAttr address) {
    auto result = rewriter.create<mid::BinExprOp>(
        loc, resultType,
        mid::BinExprKindAttr::get(rewriter.getContext(), kind),
        lhs, rhs, address);
    result->setAttr("helix.fixed_width_unsigned", rewriter.getUnitAttr());
    return result;
}

static ResultFlags createZeroAndSignFlags(
        ConversionPatternRewriter& rewriter, Location loc, Value result,
        Type arithmeticType, IntegerAttr address, bool forceWidth = false) {
    auto zero = rewriter.create<mid::ConstantOp>(
        loc, arithmeticType, getSI64Attr(rewriter, 0), IntegerAttr{});
    auto zeroFlag = rewriter.create<mid::BinExprOp>(
        loc, rewriter.getI1Type(),
        mid::BinExprKindAttr::get(
            rewriter.getContext(), mid::BinExprKind::Eq),
        result, zero.getResult(), address);
    if (forceWidth)
        zeroFlag->setAttr("helix.fixed_width_compare", rewriter.getUnitAttr());
    auto signFlag = rewriter.create<mid::BinExprOp>(
        loc, rewriter.getI1Type(),
        mid::BinExprKindAttr::get(
            rewriter.getContext(), mid::BinExprKind::Lt),
        result, zero.getResult(), address);
    return {zeroFlag.getResult(), signFlag.getResult()};
}

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

static std::optional<mid::BinExprKind> mapBinOpKind(low::BinOpKind kind) {
    switch (kind) {
    case low::BinOpKind::Add:  return mid::BinExprKind::Add;
    case low::BinOpKind::Sub:  return mid::BinExprKind::Sub;
    case low::BinOpKind::Mul:  return mid::BinExprKind::UMul;
    case low::BinOpKind::IMul: return mid::BinExprKind::SMul;
    case low::BinOpKind::Div:  return mid::BinExprKind::UDiv;
    case low::BinOpKind::IDiv: return mid::BinExprKind::SDiv;
    case low::BinOpKind::And:  return mid::BinExprKind::BitAnd;
    case low::BinOpKind::Or:   return mid::BinExprKind::BitOr;
    case low::BinOpKind::Xor:  return mid::BinExprKind::BitXor;
    case low::BinOpKind::Shl:  return mid::BinExprKind::Shl;
    case low::BinOpKind::Shr:  return mid::BinExprKind::Shr;
    case low::BinOpKind::Sar:  return mid::BinExprKind::Sar;
    case low::BinOpKind::Rol:  return mid::BinExprKind::Rol;
    case low::BinOpKind::Ror:  return mid::BinExprKind::Ror;
    }
    return std::nullopt;
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

        auto assignment = rewriter.create<mid::AssignOp>(
            op.getLoc(),
            rewriter.getUI32IntegerAttr(slot_id),
            adaptor.getValue(),
            op.getAddressAttr()
        );
        copyRecoveryAttrs(op, assignment);

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

    auto extractConst = [](Value v) -> std::optional<int64_t> {
        auto cst = v.getDefiningOp<LLVM::ConstantOp>();
        if (!cst) return std::nullopt;
        auto intAttr = dyn_cast<IntegerAttr>(cst.getValue());
        if (!intAttr) return std::nullopt;
        return intAttr.getValue().getSExtValue();
    };

    auto lhsConst = extractConst(lhs);
    auto rhsConst = extractConst(rhs);

    // Refuse if both operands are constants (fully-foldable; no provenance).
    if (lhsConst && rhsConst) return std::nullopt;
    // Only positive displacements can be inferred as forward struct fields.
    // Negative displacements are common for stack/container arithmetic.  The
    // old ZExt read turned -80 into 0xffffffffffffffb0 and printed it as an
    // enormous field offset.
    if (rhsConst && *rhsConst <= 0) return std::nullopt;
    if (lhsConst && *lhsConst <= 0) return std::nullopt;

    // Keep this recognizer scoped to a direct base plus a constant.  An outer
    // Add whose non-constant side is itself address arithmetic commonly means
    // `image_base + index * stride + displacement`, not a struct field.
    // Classifying that shape as FieldPtr fabricated forms such as
    // `(image_base + (i << 3))->field_0x18b30`.
    if (rhsConst && lhs.getDefiningOp<LLVM::AddOp>())
        return std::nullopt;
    if (lhsConst && rhs.getDefiningOp<LLVM::AddOp>())
        return std::nullopt;

    if (rhsConst)
        return AddrFieldDecomposition{lhs, static_cast<uint64_t>(*rhsConst)};
    if (lhsConst)
        return AddrFieldDecomposition{rhs, static_cast<uint64_t>(*lhsConst)};
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
        if (!mid_kind)
            return failure();
        auto loc = op.getLoc();
        auto result_type = op.getResult().getType();

        // Ensure arithmetic operates on integer types, not pointers.
        // Pointer-typed BinOps (from address arithmetic in Remill IR)
        // must be cast to i64 to avoid crashes in downstream patterns.
        auto i64Type = rewriter.getI64Type();
        auto arith_type = isa<IntegerType>(result_type) ? result_type : i64Type;

        auto lhs = adaptor.getLhs();
        auto rhs = adaptor.getRhs();
        lhs = coerceToIntegerType(rewriter, loc, lhs, arith_type);
        rhs = coerceToIntegerType(rewriter, loc, rhs, arith_type);

        const bool exactAddSub = op.getKind() == low::BinOpKind::Add ||
                                 op.getKind() == low::BinOpKind::Sub;
        const bool exactLogic = op.getKind() == low::BinOpKind::And ||
                                op.getKind() == low::BinOpKind::Or ||
                                op.getKind() == low::BinOpKind::Xor;
        const bool carryLive = !op.getCarryFlag().use_empty();
        const bool zeroLive = !op.getZeroFlag().use_empty();
        const bool signLive = !op.getSignFlag().use_empty();
        const bool overflowLive = !op.getOverflowFlag().use_empty();

        auto falseValue = rewriter.create<mlir::arith::ConstantOp>(
            loc, rewriter.getI1Type(), rewriter.getBoolAttr(false));
        ResultFlags resultFlags{falseValue, falseValue};
        Value carryFlag = falseValue;
        Value overflowFlag = falseValue;

        const bool needsFixedResult = exactAddSub &&
            (zeroLive || signLive || overflowLive ||
             (carryLive && op.getKind() == low::BinOpKind::Add));
        auto newOp = needsFixedResult
            ? createFixedWidthBinary(
                rewriter, loc, *mid_kind, lhs, rhs, arith_type,
                op.getAddressAttr())
            : rewriter.create<mid::BinExprOp>(
                loc, arith_type,
                mid::BinExprKindAttr::get(rewriter.getContext(), *mid_kind),
                lhs, rhs, op.getAddressAttr());

        // The arithmetic result and every derived flag must share one SSA
        // definition. Duplicating the Add/Sub for flags becomes a second
        // source expression after de-SSA and can re-evaluate against a mutated
        // recovered variable (e.g. `result--; if (result - 1)`).
        Value flagResult = newOp.getResult();

        // Cast back to original type if it was pointer.
        Value resultVal = flagResult;
        if (result_type != arith_type) {
            resultVal = rewriter.create<mid::CastOp>(
                loc, result_type, resultVal, IntegerAttr{},
                mid::CastKindAttr{}).getResult();
        }
        if ((exactAddSub && (zeroLive || signLive || overflowLive)) ||
            (exactLogic && (zeroLive || signLive))) {
            resultFlags = createZeroAndSignFlags(
                rewriter, loc, flagResult, arith_type, op.getAddressAttr(),
                exactAddSub);
        }

        if (exactAddSub && carryLive) {
            carryFlag = op.getKind() == low::BinOpKind::Add
                ? createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Ult, flagResult, lhs,
                    op.getAddressAttr())
                : createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Ult, lhs, rhs,
                    op.getAddressAttr());
        }

        if (exactAddSub && overflowLive) {
            auto zero = rewriter.create<mid::ConstantOp>(
                loc, arith_type, getSI64Attr(rewriter, 0), IntegerAttr{});
            Value lhsSign = createBoolBinary(
                rewriter, loc, mid::BinExprKind::Lt, lhs, zero,
                op.getAddressAttr());
            Value rhsSign = createBoolBinary(
                rewriter, loc, mid::BinExprKind::Lt, rhs, zero,
                op.getAddressAttr());
            Value signsRelation = op.getKind() == low::BinOpKind::Add
                ? createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Eq, lhsSign, rhsSign,
                    op.getAddressAttr())
                : createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Ne, lhsSign, rhsSign,
                    op.getAddressAttr());
            Value resultDiffersFromLhs = createBoolBinary(
                rewriter, loc, mid::BinExprKind::Ne,
                resultFlags.sign, lhsSign, op.getAddressAttr());
            overflowFlag = createBoolBinary(
                rewriter, loc, mid::BinExprKind::LogAnd,
                signsRelation, resultDiffersFromLhs, op.getAddressAttr());
        }

        if (!exactAddSub && !exactLogic) {
            if (carryLive)
                carryFlag = createUnknownValue(
                    rewriter, loc, rewriter.getI1Type(),
                    "carry flag undefined for lowered operation",
                    op.getAddressAttr());
            if (zeroLive)
                resultFlags.zero = createUnknownValue(
                    rewriter, loc, rewriter.getI1Type(),
                    "zero flag undefined for lowered operation",
                    op.getAddressAttr());
            if (signLive)
                resultFlags.sign = createUnknownValue(
                    rewriter, loc, rewriter.getI1Type(),
                    "sign flag undefined for lowered operation",
                    op.getAddressAttr());
            if (overflowLive)
                overflowFlag = createUnknownValue(
                    rewriter, loc, rewriter.getI1Type(),
                    "overflow flag undefined for lowered operation",
                    op.getAddressAttr());
        }

        rewriter.replaceOp(op, {
            resultVal,
            carryFlag, resultFlags.zero, resultFlags.sign, overflowFlag
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
        auto loc = op.getLoc();

        SmallVector<arith::XOrIOp, 4> signedLessOps;
        SmallVector<arith::OrIOp, 4> signedLessEqualOps;
        SmallVector<arith::OrIOp, 4> unsignedLessEqualOps;
        for (Operation* user : op.getSignFlag().getUsers()) {
            auto xorOp = dyn_cast<arith::XOrIOp>(user);
            if (!xorOp)
                continue;
            Value other = xorOp.getLhs() == op.getSignFlag()
                ? xorOp.getRhs() : xorOp.getLhs();
            if (other != op.getOverflowFlag())
                continue;
            signedLessOps.push_back(xorOp);
            for (Operation* xorUser : xorOp.getResult().getUsers()) {
                auto orOp = dyn_cast<arith::OrIOp>(xorUser);
                if (!orOp)
                    continue;
                Value orOther = orOp.getLhs() == xorOp.getResult()
                    ? orOp.getRhs() : orOp.getLhs();
                if (orOther == op.getZeroFlag())
                    signedLessEqualOps.push_back(orOp);
            }
        }
        for (Operation* user : op.getCarryFlag().getUsers()) {
            auto orOp = dyn_cast<arith::OrIOp>(user);
            if (!orOp)
                continue;
            Value other = orOp.getLhs() == op.getCarryFlag()
                ? orOp.getRhs() : orOp.getLhs();
            if (other == op.getZeroFlag())
                unsignedLessEqualOps.push_back(orOp);
        }

        Type arithmeticType = adaptor.getLhs().getType();
        if (!isa<IntegerType>(arithmeticType))
            arithmeticType = isa<IntegerType>(adaptor.getRhs().getType())
                ? adaptor.getRhs().getType()
                : rewriter.getI64Type();
        Value lhs = coerceToIntegerType(
            rewriter, loc, adaptor.getLhs(), arithmeticType);
        Value rhs = coerceToIntegerType(
            rewriter, loc, adaptor.getRhs(), arithmeticType);
        auto replaceComparison = [&](Operation* oldOp, mid::BinExprKind kind) {
            rewriter.setInsertionPoint(oldOp);
            Value comparison = createBoolBinary(
                rewriter, oldOp->getLoc(), kind, lhs, rhs,
                op.getAddressAttr());
            oldOp->getResult(0).replaceAllUsesWith(comparison);
            rewriter.eraseOp(oldOp);
        };
        for (auto orOp : signedLessEqualOps)
            replaceComparison(orOp, mid::BinExprKind::Le);
        for (auto orOp : unsignedLessEqualOps)
            replaceComparison(orOp, mid::BinExprKind::Ule);
        for (auto xorOp : signedLessOps)
            replaceComparison(xorOp, mid::BinExprKind::Lt);

        rewriter.setInsertionPoint(op);

        const bool carryLive = !op.getCarryFlag().use_empty();
        const bool zeroLive = !op.getZeroFlag().use_empty();
        const bool signLive = !op.getSignFlag().use_empty();
        const bool overflowLive = !op.getOverflowFlag().use_empty();
        auto falseValue = rewriter.create<mlir::arith::ConstantOp>(
            loc, rewriter.getI1Type(), rewriter.getBoolAttr(false));
        Value carryFlag = falseValue;
        Value zeroFlag = falseValue;
        Value signFlag = falseValue;
        Value overflowFlag = falseValue;

        if (carryLive) {
            carryFlag = createBoolBinary(
                rewriter, loc, mid::BinExprKind::Ult, lhs, rhs,
                op.getAddressAttr());
        }
        if (zeroLive) {
            zeroFlag = createBoolBinary(
                rewriter, loc, mid::BinExprKind::Eq, lhs, rhs,
                op.getAddressAttr());
        }
        if (signLive || overflowLive) {
            auto zero = rewriter.create<mid::ConstantOp>(
                loc, arithmeticType, getSI64Attr(rewriter, 0), IntegerAttr{});
            auto subtraction = createFixedWidthBinary(
                rewriter, loc, mid::BinExprKind::Sub, lhs, rhs,
                arithmeticType, op.getAddressAttr());
            signFlag = createBoolBinary(
                rewriter, loc, mid::BinExprKind::Lt, subtraction, zero,
                op.getAddressAttr());
            if (overflowLive) {
                Value lhsSign = createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Lt, lhs, zero,
                    op.getAddressAttr());
                Value rhsSign = createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Lt, rhs, zero,
                    op.getAddressAttr());
                Value signsDiffer = createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Ne, lhsSign, rhsSign,
                    op.getAddressAttr());
                Value resultDiffersFromLhs = createBoolBinary(
                    rewriter, loc, mid::BinExprKind::Ne, signFlag, lhsSign,
                    op.getAddressAttr());
                overflowFlag = createBoolBinary(
                    rewriter, loc, mid::BinExprKind::LogAnd,
                    signsDiffer, resultDiffersFromLhs,
                    op.getAddressAttr());
            }
        }

        rewriter.replaceOp(op, {
            carryFlag, zeroFlag, signFlag, overflowFlag
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
            lhs = rewriter.create<mid::CastOp>(
                loc, arith_type, lhs, IntegerAttr{},
                mid::CastKindAttr{}).getResult();
        if (!isa<IntegerType>(rhs.getType()))
            rhs = rewriter.create<mid::CastOp>(
                loc, arith_type, rhs, IntegerAttr{},
                mid::CastKindAttr{}).getResult();

        auto and_result = rewriter.create<mid::BinExprOp>(
            loc, arith_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::BitAnd),
            lhs, rhs,
            op.getAddressAttr()
        );

        auto zero = rewriter.create<mid::ConstantOp>(
            loc, arith_type,
            getSI64Attr(rewriter, 0),
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
        if (helix::pipelineDebugEnabled()) {
            llvm::errs() << "[P0-DEBUG] CallToMidCall: attempting conversion for CallOp"
                         << " target=" << (op.getTargetNameAttr() ? op.getTargetNameAttr().getValue() : "none")
                         << " nArgs=" << op.getArgs().size()
                         << " nAdaptedArgs=" << adaptor.getArgs().size()
                         << "\n";
        }

        // Check if adapted args are valid
        for (unsigned i = 0; i < adaptor.getArgs().size(); ++i) {
            auto arg = adaptor.getArgs()[i];
            if (!arg && helix::pipelineDebugEnabled()) {
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
            getUI64Attr(rewriter, callee_addr),
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

        if (helix::pipelineDebugEnabled()) {
            llvm::errs() << "[P0-DEBUG] CallToMidCall: SUCCESS → mid.call"
                         << " name=" << (callee_name_attr ? callee_name_attr.getValue() : "none")
                         << " addr=" << callee_addr
                         << " hasResult=" << (op.getNumResults() > 0)
                         << "\n";
        }

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
            base = rewriter.create<mid::CastOp>(
                loc, arith_type, base, IntegerAttr{},
                mid::CastKindAttr{}).getResult();
        if (!isa<IntegerType>(index.getType()))
            index = rewriter.create<mid::CastOp>(
                loc, arith_type, index, IntegerAttr{},
                mid::CastKindAttr{}).getResult();

        // LEA: base + index * scale + displacement
        auto scale_val = rewriter.create<mid::ConstantOp>(
            loc, arith_type,
            getSI64Attr(rewriter, static_cast<int64_t>(op.getScale())),
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
                getSI64Attr(rewriter, op.getDisplacement()),
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
                loc, result_type, final_result, IntegerAttr{},
                mid::CastKindAttr{}).getResult();
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
            op.getAddressAttr(),
            mid::CastKindAttr::get(
                rewriter.getContext(), mid::CastKind::ZeroExtend)
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
            op.getAddressAttr(),
            mid::CastKindAttr::get(
                rewriter.getContext(), mid::CastKind::SignExtend)
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

/// Convert helix_low.int3 → helix_mid.debug_break.
struct Int3ToDebugBreak : public OpConversionPattern<low::Int3Op> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::Int3Op op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.replaceOpWithNewOp<mid::DebugBreakOp>(
            op, op.getAddressAttr());
        return success();
    }
};

struct UnknownValueToMid
    : public OpConversionPattern<low::UnknownValueOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::UnknownValueOp op, OpAdaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.replaceOpWithNewOp<mid::UnknownValueOp>(
            op, op.getResult().getType(), op.getReasonAttr(),
            op.getAddressAttr());
        return success();
    }
};

struct XchgToMid : public OpConversionPattern<low::XchgOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::XchgOp op, OpAdaptor,
        ConversionPatternRewriter& rewriter) const override {
        rewriter.replaceOpWithNewOp<mid::XchgOp>(
            op, op.getRegAAttr(), op.getRegBAttr(), op.getBitWidthAttr(),
            op.getAddressAttr());
        return success();
    }
};

struct PushToMidStack : public OpConversionPattern<low::PushOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::PushOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        if (op->hasAttr("is_callee_save_push"))
            rewriter.eraseOp(op);
        else
            rewriter.replaceOpWithNewOp<mid::StackPushOp>(
                op, adaptor.getValue(), op.getAddressAttr());
        return success();
    }
};

struct PopToMidStack : public OpConversionPattern<low::PopOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::PopOp op, OpAdaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        if (op->hasAttr("is_callee_save_pop") &&
            op.getResult().use_empty()) {
            rewriter.eraseOp(op);
        } else {
            rewriter.replaceOpWithNewOp<mid::StackPopOp>(
                op, op.getResult().getType(), op.getAddressAttr());
        }
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
        // Inc/Dec → BinExpr(Add/Sub, operand, 1)
        if (op.getKind() == low::UnaryOpKind::Inc ||
            op.getKind() == low::UnaryOpKind::Dec) {
            // Use integer type for arithmetic (pointer Inc/Dec = pointer + 1)
            auto arith_type = isa<IntegerType>(result_type) ? result_type : rewriter.getI64Type();
            auto one = rewriter.create<mid::ConstantOp>(
                loc, arith_type,
                getSI64Attr(rewriter, 1),
                /*address=*/mlir::IntegerAttr{}
            );
            auto bin_kind = (op.getKind() == low::UnaryOpKind::Inc)
                ? mid::BinExprKind::Add
                : mid::BinExprKind::Sub;
            // Cast operand to integer if pointer-typed
            auto operand = adaptor.getOperand();
            if (!isa<IntegerType>(operand.getType()))
                operand = rewriter.create<mid::CastOp>(
                    loc, arith_type, operand, IntegerAttr{},
                    mid::CastKindAttr{}).getResult();

            auto new_op = rewriter.create<mid::BinExprOp>(
                loc, arith_type,
                mid::BinExprKindAttr::get(rewriter.getContext(), bin_kind),
                operand, one.getResult(),
                op.getAddressAttr()
            );

            // Cast back if original was pointer
            Value inc_result = new_op.getResult();
            if (result_type != arith_type)
                inc_result = rewriter.create<mid::CastOp>(
                    loc, result_type, inc_result, IntegerAttr{},
                    mid::CastKindAttr{}).getResult();

            auto resultFlags = createZeroAndSignFlags(
                rewriter, loc, new_op.getResult(), arith_type,
                op.getAddressAttr());

            rewriter.replaceOp(op, {
                inc_result, resultFlags.zero, resultFlags.sign
            });
            return success();
        }

        // Every remaining Low unary kind has an exact Mid identity. Bit-scan
        // source-zero behavior stays explicit in its Mid kind and is emitted
        // through a Helix helper rather than invoking a C builtin on zero.
        mid::UnExprKind mid_kind;
        switch (op.getKind()) {
        case low::UnaryOpKind::Neg:   mid_kind = mid::UnExprKind::Neg; break;
        case low::UnaryOpKind::Not:   mid_kind = mid::UnExprKind::BitNot; break;
        case low::UnaryOpKind::Bswap: mid_kind = mid::UnExprKind::Bswap; break;
        case low::UnaryOpKind::Bsf:   mid_kind = mid::UnExprKind::Bsf; break;
        case low::UnaryOpKind::Bsr:   mid_kind = mid::UnExprKind::Bsr; break;
        default:                       return failure();
        }

        // Cast operand to integer if pointer-typed
        auto unary_type = isa<IntegerType>(result_type) ? result_type : rewriter.getI64Type();
        auto unary_operand = adaptor.getOperand();
        if (!isa<IntegerType>(unary_operand.getType()))
            unary_operand = rewriter.create<mid::CastOp>(
                loc, unary_type, unary_operand, IntegerAttr{},
                mid::CastKindAttr{}).getResult();

        auto new_op = rewriter.create<mid::UnExprOp>(
            loc, unary_type,
            mid::UnExprKindAttr::get(rewriter.getContext(), mid_kind),
            unary_operand,
            op.getAddressAttr()
        );

        Value unary_result = new_op.getResult();
        if (result_type != unary_type)
            unary_result = rewriter.create<mid::CastOp>(
                loc, result_type, unary_result, IntegerAttr{},
                mid::CastKindAttr{}).getResult();

        ResultFlags resultFlags;
        if (op.getKind() == low::UnaryOpKind::Not ||
            op.getKind() == low::UnaryOpKind::Bswap) {
            auto falseValue = rewriter.create<arith::ConstantOp>(
                loc, rewriter.getI1Type(), rewriter.getBoolAttr(false));
            resultFlags.zero = op.getZeroFlag().use_empty()
                ? falseValue.getResult()
                : createUnknownValue(
                    rewriter, loc, rewriter.getI1Type(),
                    "zero flag preserved but prior state unavailable",
                    op.getAddressAttr());
            resultFlags.sign = op.getSignFlag().use_empty()
                ? falseValue.getResult()
                : createUnknownValue(
                    rewriter, loc, rewriter.getI1Type(),
                    "sign flag preserved but prior state unavailable",
                    op.getAddressAttr());
        } else if (op.getKind() == low::UnaryOpKind::Bsf ||
                   op.getKind() == low::UnaryOpKind::Bsr) {
            auto zero = rewriter.create<mid::ConstantOp>(
                loc, unary_type, getSI64Attr(rewriter, 0), IntegerAttr{});
            resultFlags.zero = op.getZeroFlag().use_empty()
                ? rewriter.create<arith::ConstantOp>(
                      loc, rewriter.getI1Type(),
                      rewriter.getBoolAttr(false)).getResult()
                : createBoolBinary(
                      rewriter, loc, mid::BinExprKind::Eq,
                      unary_operand, zero.getResult(), op.getAddressAttr());
            resultFlags.sign = op.getSignFlag().use_empty()
                ? rewriter.create<arith::ConstantOp>(
                      loc, rewriter.getI1Type(),
                      rewriter.getBoolAttr(false)).getResult()
                : createUnknownValue(
                      rewriter, loc, rewriter.getI1Type(),
                      "sign flag undefined for bit scan",
                      op.getAddressAttr());
        } else {
            resultFlags = createZeroAndSignFlags(
                rewriter, loc, new_op.getResult(), unary_type,
                op.getAddressAttr());
        }

        rewriter.replaceOp(op, {
            unary_result, resultFlags.zero, resultFlags.sign
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

    explicit HelixLowToMidPass(bool strictClosure = false)
        : strictClosure_(strictClosure) {}

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

        const char* disableNormalization =
            std::getenv("HELIX_DISABLE_RECOVERED_HIGH_NORMALIZATION");
        const bool normalizationDisabled = disableNormalization &&
            disableNormalization[0] != '\0' &&
            StringRef(disableNormalization) != "0";
        // RecoverVariables historically materialized six source-facing High
        // families before Low->Mid. Normalize them back into Mid by default so
        // the tier boundary is closed. Strict mode cannot be opted out; the
        // environment switch exists only for compatibility A/B comparisons.
        if (strictClosure_ || !normalizationDisabled) {
            normalizeRecoveredHighToMid(module);
        }

        if (helix::pipelineDebugEnabled()) {
            unsigned lowCalls = 0;
            module.walk([&](low::CallOp) { ++lowCalls; });
            llvm::errs() << "[P0-DEBUG] HelixLowToMid entry: "
                         << lowCalls << " low.call ops\n";
        }

        // Set up conversion target: HelixMid is legal, HelixLow is illegal
        ConversionTarget target(*ctx);
        target.addLegalDialect<helix::mid::HelixMidDialect>();
        // High ops already produced by the current SCF bridge are accepted by
        // dialect conversion so the explicit postcondition below can count
        // and diagnose them instead of failing with an opaque legalization
        // error at the first High op.
        target.addLegalDialect<helix::high::HelixHighDialect>();
        target.addLegalDialect<mlir::arith::ArithDialect>();
        target.addLegalDialect<mlir::cf::ControlFlowDialect>();
        target.addLegalDialect<mlir::func::FuncDialect>();
        target.addLegalDialect<mlir::LLVM::LLVMDialect>();
        target.addLegalDialect<mlir::scf::SCFDialect>();
        target.addLegalOp<mlir::ModuleOp>();
        target.addIllegalDialect<helix::low::HelixLowDialect>();

        // Allow HelixLow ops that we don't convert yet (JmpOp, JccOp, etc.)
        // to survive — they'll be handled by subsequent passes.
        target.addLegalOp<low::JmpOp>();
        target.addLegalOp<low::JccOp>();
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
            PushToMidStack,
            PopToMidStack,
            Int3ToDebugBreak,
            UnknownValueToMid,
            XchgToMid,
            UnaryOpToUnExpr
        >(ctx);

        // Bundle carriage is a temporary import representation. Normalize it
        // before conversion so strict mode can enforce a real closed tier.
        const unsigned collapsedVariadicCalls =
            collapseVariadicCallsToMid(module);

        // Run partial conversion (some HelixLow ops may remain for now)
        LogicalResult conversionResult = strictClosure_
            ? applyFullConversion(module, target, std::move(patterns))
            : applyPartialConversion(module, target, std::move(patterns));
        if (failed(conversionResult)) {
            LLVM_DEBUG(llvm::dbgs() << "HelixLowToMid: partial conversion "
                                    << "completed with unconverted ops\n");
            if (strictClosure_) {
                signalPassFailure();
                return;
            }
        }

        if (collapsedVariadicCalls > 0 && helix::pipelineDebugEnabled()) {
            llvm::errs() << "[P0-DEBUG] variadic_call+bundle->mid.call: "
                         << collapsedVariadicCalls << "\n";
        }

        if (helix::pipelineDebugEnabled()) {
            unsigned lowCalls = 0, midCalls = 0;
            module.walk([&](Operation* op) {
                if (isa<low::CallOp>(op)) ++lowCalls;
                else if (isa<mid::CallOp>(op)) ++midCalls;
            });
            llvm::errs() << "[P0-DEBUG] HelixLowToMid exit: "
                         << lowCalls << " low.call, "
                          << midCalls << " mid.call\n";
        }

        unsigned residualLowOps = 0;
        unsigned lowContainers = 0;
        unsigned preexistingHighOps = 0;
        module.walk([&](Operation* op) {
            StringRef dialect = op->getName().getDialectNamespace();
            if (dialect == "helix_low") {
                if (isa<low::FuncOp>(op))
                    ++lowContainers;
                else
                    ++residualLowOps;
            } else if (dialect == "helix_high") {
                ++preexistingHighOps;
            }
        });
        Builder metricBuilder(ctx);
        module->setAttr(
            "helix.tier_closure.low_to_mid.residual_low_ops",
            metricBuilder.getI64IntegerAttr(residualLowOps));
        module->setAttr(
            "helix.tier_closure.low_to_mid.low_containers",
            metricBuilder.getI64IntegerAttr(lowContainers));
        module->setAttr(
            "helix.tier_closure.low_to_mid.preexisting_high_ops",
            metricBuilder.getI64IntegerAttr(preexistingHighOps));

        if (strictClosure_ && (residualLowOps != 0 ||
                              preexistingHighOps != 0)) {
            module.emitError()
                << "HelixLowToMid strict tier closure failed: "
                << residualLowOps << " residual Low op(s), "
                << preexistingHighOps << " pre-existing High op(s)";
            signalPassFailure();
        }
    }

private:
    bool strictClosure_ = false;
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixLowToMidPass(
        bool strictClosure) {
    return std::make_unique<HelixLowToMidPass>(strictClosure);
}
