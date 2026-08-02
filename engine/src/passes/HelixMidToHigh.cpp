/// @file HelixMidToHigh.cpp
/// @brief MLIR conversion pass: HelixMid Dialect → HelixHigh Dialect.
///
/// This pass performs the final lowering from the ISA-agnostic typed SSA
/// representation to the C source-level representation.  Key transformations:
///
///   - Abstract variable slots → named variables (var.decl with human names)
///   - Typed expressions → C-level binary/unary ops
///   - helix_mid.select → helix_high.ternary
///   - Control flow regions → helix_high if/while/for/switch
///   - Type annotations → helix_high.ctype attributes
///   - memcpy/memset → helix_high.call with known signatures
///
/// Uses the MLIR dialect conversion framework.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixMidOps.h"
#include "helix/dialects/HelixHighOps.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/utils/Debug.h"

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
#include "llvm/Support/FormatVariadic.h"

#include <format>
#include <string>

#define DEBUG_TYPE "helix-mid-to-high"

using namespace mlir;
using namespace helix;

namespace {

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Variable Naming
// ═══════════════════════════════════════════════════════════════════════════════

/// Per-function slot → canonical name map.
/// Populated before pattern conversion and consumed by Mid→High patterns
/// (MidVarRefToHighVarRef, MidAssignToHighAssign, MidVarDeclToHighVarDecl).
///
/// This eliminates the "v{slot_id}" garbage where raw slot_ids (often large
/// numbers like 50909, 40137) leak into the output.  Instead we assign a
/// compact sequential name per function (v0, v1, v2, ...).
static llvm::DenseMap<uint32_t, std::string>& getSlotNameMap() {
    static llvm::DenseMap<uint32_t, std::string> map;
    return map;
}

/// Look up (or lazily generate) a sequential name for a slot_id.
/// If the slot wasn't pre-registered, returns "v{seq}" using a per-function
/// counter so that names are stable and small regardless of slot_id magnitude.
static std::string getSequentialSlotName(uint32_t slot_id) {
    auto& map = getSlotNameMap();
    auto it = map.find(slot_id);
    if (it != map.end())
        return it->second;
    // Fallback: generate a sequential name and cache it.
    std::string name = std::format("v{}", static_cast<unsigned>(map.size()));
    map[slot_id] = name;
    return name;
}

/// Generates human-readable variable names from slot IDs.
struct VariableNamer {
    llvm::DenseMap<uint32_t, std::string> names;
    unsigned temp_counter = 0;

    std::string getName(uint32_t slot_id) {
        auto it = names.find(slot_id);
        if (it != names.end())
            return it->second;

        std::string name = std::format("v{}", temp_counter++);
        names[slot_id] = name;
        return name;
    }

    void setName(uint32_t slot_id, std::string_view name) {
        names[slot_id] = std::string(name);
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Map HelixMid BinExprKind → HelixHigh BinaryOpKind
// ═══════════════════════════════════════════════════════════════════════════════

static high::BinaryOpKind mapBinExprToHighOp(mid::BinExprKind kind) {
    switch (kind) {
    case mid::BinExprKind::Add:    return high::BinaryOpKind::Add;
    case mid::BinExprKind::Sub:    return high::BinaryOpKind::Sub;
    case mid::BinExprKind::Mul:    return high::BinaryOpKind::Mul;
    case mid::BinExprKind::Div:    return high::BinaryOpKind::Div;
    case mid::BinExprKind::Mod:    return high::BinaryOpKind::Mod;
    case mid::BinExprKind::BitAnd: return high::BinaryOpKind::BitAnd;
    case mid::BinExprKind::BitOr:  return high::BinaryOpKind::BitOr;
    case mid::BinExprKind::BitXor: return high::BinaryOpKind::BitXor;
    case mid::BinExprKind::Shl:    return high::BinaryOpKind::Shl;
    case mid::BinExprKind::Shr:    return high::BinaryOpKind::Shr;
    case mid::BinExprKind::Sar:    return high::BinaryOpKind::Sar;
    case mid::BinExprKind::Eq:     return high::BinaryOpKind::Eq;
    case mid::BinExprKind::Ne:     return high::BinaryOpKind::Ne;
    case mid::BinExprKind::Lt:     return high::BinaryOpKind::Lt;
    case mid::BinExprKind::Le:     return high::BinaryOpKind::Le;
    case mid::BinExprKind::Gt:     return high::BinaryOpKind::Gt;
    case mid::BinExprKind::Ge:     return high::BinaryOpKind::Ge;
    case mid::BinExprKind::LogAnd: return high::BinaryOpKind::LogAnd;
    case mid::BinExprKind::LogOr:  return high::BinaryOpKind::LogOr;
    }
    return high::BinaryOpKind::Add;
}

static high::UnaryOpKind mapUnExprToHighOp(mid::UnExprKind kind) {
    switch (kind) {
    case mid::UnExprKind::Neg:     return high::UnaryOpKind::Neg;
    case mid::UnExprKind::LogNot:  return high::UnaryOpKind::LogNot;
    case mid::UnExprKind::BitNot:  return high::UnaryOpKind::BitNot;
    case mid::UnExprKind::Deref:   return high::UnaryOpKind::Deref;
    case mid::UnExprKind::AddrOf:  return high::UnaryOpKind::AddressOf;
    }
    return high::UnaryOpKind::Neg;
}

// ═══════════════════════════════════════════════════════════════════════════════
// Conversion Patterns
// ═══════════════════════════════════════════════════════════════════════════════

/// Convert helix_mid.var.ref → helix_high.var.ref (add human name)
struct MidVarRefToHighVarRef : public OpConversionPattern<mid::VarRefOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::VarRefOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        uint32_t slot_id = op.getSlotId();
        std::string name = getSequentialSlotName(slot_id);

        auto new_op = rewriter.create<high::VarRefOp>(
            op.getLoc(),
            op.getResult().getType(),
            rewriter.getUI32IntegerAttr(slot_id),
            rewriter.getStringAttr(name),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.assign → helix_high.assign
struct MidAssignToHighAssign : public OpConversionPattern<mid::AssignOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::AssignOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        uint32_t slot_id = op.getSlotId();
        std::string name = getSequentialSlotName(slot_id);

        // Create a var.ref for the target
        auto target_ref = rewriter.create<high::VarRefOp>(
            op.getLoc(),
            adaptor.getValue().getType(),
            rewriter.getUI32IntegerAttr(slot_id),
            rewriter.getStringAttr(name),
            /*address=*/mlir::IntegerAttr{}
        );

        rewriter.create<high::AssignOp>(
            op.getLoc(),
            target_ref.getResult(),
            adaptor.getValue(),
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.var.decl → helix_high.var.decl (add name + storage)
struct MidVarDeclToHighVarDecl : public OpConversionPattern<mid::VarDeclOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::VarDeclOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        uint32_t slot_id = op.getSlotId();

        // Map slot kind to storage kind
        high::StorageKind storage;
        std::string name;
        switch (op.getSlotKind()) {
        case mid::SlotKind::Stack:
            storage = high::StorageKind::Stack;
            if (auto offset = op.getStackOffset())
                name = std::format("var_{:X}", std::abs(offset.value()));
            else
                name = std::format("var_{}", slot_id);
            break;
        case mid::SlotKind::Register:
            storage = high::StorageKind::Register;
            name = getSequentialSlotName(slot_id);
            break;
        case mid::SlotKind::Param:
            storage = high::StorageKind::Parameter;
            name = std::format("param_{}", slot_id);
            break;
        case mid::SlotKind::Global:
            storage = high::StorageKind::Global;
            name = std::format("g_{:X}", slot_id);
            break;
        case mid::SlotKind::Temp:
            storage = high::StorageKind::Temporary;
            name = std::format("t{}", slot_id);
            break;
        }

        auto highDecl = rewriter.create<high::VarDeclOp>(
            op.getLoc(),
            rewriter.getUI32IntegerAttr(slot_id),
            rewriter.getStringAttr(name),
            high::StorageKindAttr::get(rewriter.getContext(), storage),
            op.getStackOffsetAttr(),
            adaptor.getInit(),
            op.getAddressAttr()
        );

        // Propagate struct recovery attributes from Mid → High.
        // These are set by RecoverStructTypes and consumed by
        // PropagateTypes (High) to seed pointer-to-struct types.
        for (auto attrName : {"helix.struct_name", "helix.struct_size",
                               "helix.struct_align", "helix.struct_field_count",
                               "helix.is_union_candidate"}) {
            if (auto attr = op->getAttr(attrName))
                highDecl->setAttr(attrName, attr);
        }

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.binexpr → helix_high.binary
struct MidBinExprToHighBinary : public OpConversionPattern<mid::BinExprOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::BinExprOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto high_kind = mapBinExprToHighOp(op.getKind());

        auto new_op = rewriter.create<high::BinaryOp>(
            op.getLoc(),
            op.getResult().getType(),
            high::BinaryOpKindAttr::get(rewriter.getContext(), high_kind),
            adaptor.getLhs(),
            adaptor.getRhs(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.unexpr → helix_high.unary
struct MidUnExprToHighUnary : public OpConversionPattern<mid::UnExprOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::UnExprOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto high_kind = mapUnExprToHighOp(op.getKind());

        auto new_op = rewriter.create<high::UnaryOp>(
            op.getLoc(),
            op.getResult().getType(),
            high::UnaryOpKindAttr::get(rewriter.getContext(), high_kind),
            adaptor.getOperand(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.cast → helix_high.cast
struct MidCastToHighCast : public OpConversionPattern<mid::CastOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::CastOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<high::CastOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getInput(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.select → helix_high.ternary
struct MidSelectToHighTernary : public OpConversionPattern<mid::SelectOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::SelectOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<high::TernaryOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getCondition(),
            adaptor.getTrueVal(),
            adaptor.getFalseVal(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.constant → helix_high.int.lit
struct MidConstantToHighIntLit : public OpConversionPattern<mid::ConstantOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::ConstantOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<high::IntLitOp>(
            op.getLoc(),
            op.getResult().getType(),
            op.getValueAttr(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.addr.const → helix_high.addr.lit
struct MidAddrConstToHighAddrLit : public OpConversionPattern<mid::AddrConstOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::AddrConstOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<high::AddrLitOp>(
            op.getLoc(),
            op.getResult().getType(),
            op.getAddrValueAttr(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.load → helix_high.unary Deref
struct MidLoadToHighDeref : public OpConversionPattern<mid::LoadOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::LoadOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<high::UnaryOp>(
            op.getLoc(),
            op.getResult().getType(),
            high::UnaryOpKindAttr::get(rewriter.getContext(), high::UnaryOpKind::Deref),
            adaptor.getAddr(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.store → helix_high.assign (with deref target)
struct MidStoreToHighAssign : public OpConversionPattern<mid::StoreOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::StoreOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        // *addr = value
        auto deref = rewriter.create<high::UnaryOp>(
            op.getLoc(),
            adaptor.getValue().getType(),
            high::UnaryOpKindAttr::get(rewriter.getContext(), high::UnaryOpKind::Deref),
            adaptor.getAddr(),
            /*address=*/mlir::IntegerAttr{}
        );

        rewriter.create<high::AssignOp>(
            op.getLoc(),
            deref.getResult(),
            adaptor.getValue(),
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.call → helix_high.call
struct MidCallToHighCall : public OpConversionPattern<mid::CallOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::CallOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        std::string callee_name;
        if (auto name_attr = op.getCalleeNameAttr())
            callee_name = name_attr.getValue().str();
        else if (op->hasAttr("is_indirect")) {
            if (auto vtableAttr = op->getAttrOfType<IntegerAttr>("vtable_offset")) {
                // Vtable pattern detected: CALL [reg+offset]
                // Generate a name that PseudoCEmitter can recognize.
                uint64_t offset = vtableAttr.getValue().getZExtValue();
                callee_name = std::format("__vtable_0x{:x}", offset);
            } else {
                auto addr = op.getCalleeAddr();
                if (addr != 0)
                    // Known indirect target address (e.g. resolved vtable slot)
                    callee_name = std::format("__indirect_{:x}", addr);
                else
                    // Truly unresolved indirect call (runtime-computed target).
                    // Do NOT use the instruction address as callee — it's the
                    // address of the CALL instruction, not the function called.
                    callee_name = "__indirect_call";
            }
        } else {
            auto addr = op.getCalleeAddr();
            callee_name = addr != 0
                ? std::format("sub_{:x}", addr)
                : "sub_unknown";
        }

        auto new_op = rewriter.create<high::CallOp>(
            op.getLoc(),
            op.getResultTypes(),
            rewriter.getI64IntegerAttr(op.getCalleeAddr()),
            rewriter.getStringAttr(callee_name),
            adaptor.getArgs(),
            op.getAddressAttr()
        );

        // Propagate helix.* attributes from mid → high, including
        // resolved_name (set by DevirtualizeIndirectCalls Phase 4 for
        // RTTI Tier 1 class::method naming).
        for (auto namedAttr : op->getAttrs()) {
            StringRef name = namedAttr.getName().strref();
            if (name.starts_with("helix."))
                new_op->setAttr(name, namedAttr.getValue());
        }

        if (op.getNumResults() > 0)
            rewriter.replaceOp(op, new_op.getResults());
        else {
            rewriter.eraseOp(op);
        }
        return success();
    }
};

/// Convert helix_mid.return → helix_high.return
struct MidReturnToHighReturn : public OpConversionPattern<mid::ReturnOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::ReturnOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::ReturnOp>(
            op.getLoc(),
            adaptor.getValue(),
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.comment → helix_high.comment
struct MidCommentToHighComment : public OpConversionPattern<mid::CommentOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::CommentOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::CommentOp>(
            op.getLoc(),
            op.getTextAttr()
        );
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.goto → helix_high.goto
struct MidGotoToHighGoto : public OpConversionPattern<mid::GotoOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::GotoOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::GotoOp>(
            op.getLoc(), op.getLabelAttr(), op.getAddressAttr());
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.label → helix_high.label
struct MidLabelToHighLabel : public OpConversionPattern<mid::LabelOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::LabelOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::LabelOp>(
            op.getLoc(), op.getNameAttr(), op.getAddressAttr());
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.yield → helix_high.yield
struct MidYieldToHighYield : public OpConversionPattern<mid::YieldOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::YieldOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::YieldOp>(
            op.getLoc(), adaptor.getValue());
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.break → helix_high.break
struct MidBreakToHighBreak : public OpConversionPattern<mid::BreakOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::BreakOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::BreakOp>(op.getLoc(), op.getAddressAttr());
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.continue → helix_high.continue
struct MidContinueToHighContinue : public OpConversionPattern<mid::ContinueOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::ContinueOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        rewriter.create<high::ContinueOp>(op.getLoc(), op.getAddressAttr());
        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.memcpy → helix_high.call("memcpy", ...)
struct MidMemcpyToHighCall : public OpConversionPattern<mid::MemcpyOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::MemcpyOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        SmallVector<Value> args = {
            adaptor.getDst(), adaptor.getSrc(), adaptor.getCount()
        };

        rewriter.create<high::CallOp>(
            op.getLoc(),
            /*result=*/TypeRange{},
            rewriter.getI64IntegerAttr(0),
            rewriter.getStringAttr("memcpy"),
            args,
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.memset → helix_high.call("memset", ...)
struct MidMemsetToHighCall : public OpConversionPattern<mid::MemsetOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::MemsetOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        SmallVector<Value> args = {
            adaptor.getDst(), adaptor.getValue(), adaptor.getCount()
        };

        rewriter.create<high::CallOp>(
            op.getLoc(),
            /*result=*/TypeRange{},
            rewriter.getI64IntegerAttr(0),
            rewriter.getStringAttr("memset"),
            args,
            op.getAddressAttr()
        );

        rewriter.eraseOp(op);
        return success();
    }
};

/// Convert helix_mid.field.ptr → helix_high.field
struct MidFieldPtrToHighField : public OpConversionPattern<mid::FieldPtrOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::FieldPtrOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        std::string field_name;
        if (auto name_attr = op.getFieldNameAttr())
            field_name = name_attr.getValue().str();
        else
            // Canonical unrecovered-field format, shared with CAstBuilder and
            // CAstOptimizer: `field_0x<lowercase-hex>`. Keeping all three name
            // producers byte-identical means a field's printed name no longer
            // depends on which lowering path happens to handle it (which the
            // dialect-conversion reachability — and thus upstream op shape —
            // can otherwise flip).
            field_name = std::format("field_0x{:x}", op.getFieldOffset());

        auto new_op = rewriter.create<high::FieldAccessOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getBase(),
            rewriter.getStringAttr(field_name),
            rewriter.getI64IntegerAttr(op.getFieldOffset()),
            rewriter.getUnitAttr(),  // is_pointer = true
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

/// Convert helix_mid.index.ptr → helix_high.subscript
struct MidIndexPtrToHighSubscript : public OpConversionPattern<mid::IndexPtrOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        mid::IndexPtrOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<high::SubscriptOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getBase(),
            adaptor.getIndex(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, new_op.getResult());
        return success();
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Definition
// ═══════════════════════════════════════════════════════════════════════════════

struct HelixMidToHighPass
    : public PassWrapper<HelixMidToHighPass, OperationPass<ModuleOp>>
{
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(HelixMidToHighPass)

    StringRef getArgument() const final { return "helix-mid-to-high"; }
    StringRef getDescription() const final {
        return "Convert HelixMid dialect to HelixHigh dialect";
    }

    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<helix::high::HelixHighDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();
        auto *ctx = &getContext();

        // Clear the global slot→name map from any previous run so that
        // sequential counters start fresh for this pass invocation.
        // Then pre-populate it by walking mid::VarDeclOps: stack slots
        // get "var_<offset>" names, params get "param_<N>", globals get
        // "g_<addr>", and register slots get sequential "v<N>" names
        // in declaration order (instead of raw slot_ids).
        {
            auto& slotMap = getSlotNameMap();
            slotMap.clear();
            unsigned regSeq = 0;
            module.walk([&](mid::VarDeclOp decl) {
                uint32_t slot_id = decl.getSlotId();
                if (slotMap.count(slot_id))
                    return;
                switch (decl.getSlotKind()) {
                case mid::SlotKind::Stack:
                    if (auto offset = decl.getStackOffset())
                        slotMap[slot_id] = std::format(
                            "var_{:X}", std::abs(offset.value()));
                    else
                        slotMap[slot_id] = std::format("var_{}", slot_id);
                    break;
                case mid::SlotKind::Param:
                    slotMap[slot_id] = std::format("param_{}", slot_id);
                    break;
                case mid::SlotKind::Global:
                    slotMap[slot_id] = std::format("g_{:X}", slot_id);
                    break;
                case mid::SlotKind::Register:
                case mid::SlotKind::Temp:
                default:
                    slotMap[slot_id] = std::format("v{}", regSeq++);
                    break;
                }
            });
        }

        ConversionTarget target(*ctx);
        target.addLegalDialect<helix::high::HelixHighDialect>();
        target.addLegalDialect<mlir::arith::ArithDialect>();
        target.addLegalDialect<mlir::LLVM::LLVMDialect>();
        target.addIllegalDialect<helix::mid::HelixMidDialect>();

        RewritePatternSet patterns(ctx);
        patterns.add<
            MidVarRefToHighVarRef,
            MidAssignToHighAssign,
            MidVarDeclToHighVarDecl,
            MidBinExprToHighBinary,
            MidUnExprToHighUnary,
            MidCastToHighCast,
            MidSelectToHighTernary,
            MidConstantToHighIntLit,
            MidAddrConstToHighAddrLit,
            MidLoadToHighDeref,
            MidStoreToHighAssign,
            MidCallToHighCall,
            MidReturnToHighReturn,
            MidCommentToHighComment,
            MidGotoToHighGoto,
            MidLabelToHighLabel,
            MidYieldToHighYield,
            MidBreakToHighBreak,
            MidContinueToHighContinue,
            MidMemcpyToHighCall,
            MidMemsetToHighCall,
            MidFieldPtrToHighField,
            MidIndexPtrToHighSubscript
        >(ctx);

        if (failed(applyPartialConversion(module, target, std::move(patterns)))) {
            LLVM_DEBUG(llvm::dbgs() << "HelixMidToHigh: partial conversion "
                                    << "completed with unconverted ops\n");
        }

        // ── Manual mid::CallOp → high::CallOp for ops inside low::FuncOp ──
        // Same issue as HelixLowToMid: the conversion framework doesn't
        // recurse into low::FuncOp regions (unknown dialect = not visited).
        {
            llvm::SmallVector<mid::CallOp, 16> callsToConvert;
            module.walk([&](mid::CallOp call) {
                callsToConvert.push_back(call);
            });

            unsigned converted = 0;
            for (auto midCall : callsToConvert) {
                OpBuilder builder(midCall);

                std::string callee_name;
                if (auto name_attr = midCall.getCalleeNameAttr())
                    callee_name = name_attr.getValue().str();
                else if (midCall->hasAttr("is_indirect")) {
                    if (auto vtableAttr = midCall->getAttrOfType<IntegerAttr>("vtable_offset")) {
                        uint64_t offset = vtableAttr.getValue().getZExtValue();
                        callee_name = std::format("__vtable_0x{:x}", offset);
                    } else {
                        auto addr = midCall.getCalleeAddr();
                        callee_name = addr != 0
                            ? std::format("__indirect_{:x}", addr)
                            : "__indirect_call";
                    }
                } else {
                    auto addr = midCall.getCalleeAddr();
                    callee_name = addr != 0
                        ? std::format("sub_{:x}", addr)
                        : "sub_unknown";
                }

                auto highCall = builder.create<high::CallOp>(
                    midCall.getLoc(),
                    midCall.getResultTypes(),
                    builder.getI64IntegerAttr(midCall.getCalleeAddr()),
                    builder.getStringAttr(callee_name),
                    midCall.getArgs(),
                    midCall.getAddressAttr()
                );

                // Propagate helix.* attributes from mid → high, including
                // resolved_name (set by DevirtualizeIndirectCalls Phase 4
                // for RTTI Tier 1 class::method naming).
                for (auto namedAttr : midCall->getAttrs()) {
                    StringRef name = namedAttr.getName().strref();
                    if (name.starts_with("helix."))
                        highCall->setAttr(name, namedAttr.getValue());
                }

                if (helix::pipelineDebugEnabled()) {
                    llvm::errs() << "[P0-DEBUG] Manual MidCall→HighCall: "
                                 << callee_name << "\n";
                }

                // When the mid.call produced a return value (RAX), forward
                // uses of its result onto high.call's result before erasing.
                // Without this, any consumer of midCall.getResult() (e.g. the
                // synthetic RegWrite from RemillToHelixLow) is left dangling.
                if (midCall->getNumResults() > 0) {
                    midCall->getResult(0).replaceAllUsesWith(
                        highCall->getResult(0));
                }
                midCall->erase();
                ++converted;
            }

            if (converted > 0 && helix::pipelineDebugEnabled()) {
                llvm::errs() << "[P0-DEBUG] HelixMidToHigh: manually converted "
                             << converted << " mid.call → high.call\n";
            }
        }

        // ── Post-pass: renumber v<slot_id> names per-function ────────────
        //
        // The conversion patterns above use `std::format("v{}", slot_id)`
        // where slot_id is a module-wide counter.  This produces ugly
        // identifiers like `v50909`, `v40137`, `v11845` because slot IDs
        // are assigned sequentially across the entire module.
        //
        // Walk each function and build a mapping from raw slot-based
        // names (v<N>) to compact sequential names (v0, v1, v2, ...).
        // Skip names that are already short (v0-v99) or semantic
        // (rax, rbx, param_1, var_20, etc.).
        {
            auto isRawSlotName = [](llvm::StringRef name) -> bool {
                // "v" followed by all digits, and the number is > 99
                // (smaller numbers are likely intentional temp names).
                if (name.size() < 4 || name[0] != 'v')
                    return false;
                for (size_t i = 1; i < name.size(); ++i) {
                    if (!std::isdigit(static_cast<unsigned char>(name[i])))
                        return false;
                }
                // Parse the number.
                uint64_t num = 0;
                for (size_t i = 1; i < name.size(); ++i)
                    num = num * 10 + (name[i] - '0');
                return num >= 100;
            };

            module.walk([&](helix::low::FuncOp funcOp) {
                // Collect all raw slot names in order of first appearance.
                llvm::StringMap<std::string> renames;
                unsigned nextId = 0;

                // Pre-seed with VarDeclOps for ordering stability.
                funcOp->walk([&](helix::high::VarDeclOp decl) {
                    llvm::StringRef curName = decl.getVarName();
                    if (!isRawSlotName(curName))
                        return;
                    if (!renames.contains(curName)) {
                        renames[curName] =
                            llvm::formatv("v{0}", nextId++).str();
                    }
                });

                // Also pick up VarRefOps whose names weren't in decls.
                funcOp->walk([&](helix::high::VarRefOp ref) {
                    llvm::StringRef curName = ref.getVarName();
                    if (!isRawSlotName(curName))
                        return;
                    if (!renames.contains(curName)) {
                        renames[curName] =
                            llvm::formatv("v{0}", nextId++).str();
                    }
                });

                if (renames.empty())
                    return;

                // Apply renames.
                funcOp->walk([&](helix::high::VarDeclOp decl) {
                    llvm::StringRef curName = decl.getVarName();
                    auto it = renames.find(curName);
                    if (it != renames.end())
                        decl.setVarName(it->second);
                });
                funcOp->walk([&](helix::high::VarRefOp ref) {
                    llvm::StringRef curName = ref.getVarName();
                    auto it = renames.find(curName);
                    if (it != renames.end())
                        ref.setVarName(it->second);
                });

                LLVM_DEBUG(llvm::dbgs()
                    << "  HelixMidToHigh: renumbered "
                    << renames.size() << " v<slot> names in '"
                    << funcOp.getSymName() << "'\n");
            });
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixMidToHighPass() {
    return std::make_unique<HelixMidToHighPass>();
}
