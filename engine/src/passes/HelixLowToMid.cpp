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

/// Convert helix_low.reg.read → helix_mid.var.ref
struct RegReadToVarRef : public OpConversionPattern<low::RegReadOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::RegReadOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto result_type = op.getResult().getType();

        // Build a slot_id attribute from the register name.
        // The actual slot allocation is done per-function in the pass driver.
        // Here we use a hash-based approach for simplicity.
        auto reg_name = op.getRegName();
        uint32_t slot_id = llvm::hash_value(reg_name) & 0xFFFF;

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
        auto reg_name = op.getRegName();
        uint32_t slot_id = llvm::hash_value(reg_name) & 0xFFFF;

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

/// Convert helix_low.mem.read → helix_mid.load
struct MemReadToLoad : public OpConversionPattern<low::MemReadOp> {
    using OpConversionPattern::OpConversionPattern;

    LogicalResult matchAndRewrite(
        low::MemReadOp op, OpAdaptor adaptor,
        ConversionPatternRewriter &rewriter) const override
    {
        auto new_op = rewriter.create<mid::LoadOp>(
            op.getLoc(),
            op.getResult().getType(),
            adaptor.getAddr(),
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
        rewriter.create<mid::StoreOp>(
            op.getLoc(),
            adaptor.getAddr(),
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
        auto result_type = op.getResult().getType();

        auto new_op = rewriter.create<mid::BinExprOp>(
            op.getLoc(),
            result_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid_kind),
            adaptor.getLhs(),
            adaptor.getRhs(),
            op.getAddressAttr()
        );

        // Replace the value result.  Flag results (carry, zero, sign, overflow)
        // need to be resolved to comparisons before this pattern runs.
        // For now, replace them with constant false (dead flags are eliminated
        // by DCE).
        auto i1_type = rewriter.getI1Type();
        auto false_val = rewriter.create<mlir::arith::ConstantOp>(
            op.getLoc(), i1_type, rewriter.getBoolAttr(false));

        rewriter.replaceOp(op, {
            new_op.getResult(),
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
        auto and_result = rewriter.create<mid::BinExprOp>(
            loc, adaptor.getLhs().getType(),
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::BitAnd),
            adaptor.getLhs(), adaptor.getRhs(),
            op.getAddressAttr()
        );

        // Create a zero constant for comparison
        auto zero = rewriter.create<mid::ConstantOp>(
            loc, adaptor.getLhs().getType(),
            rewriter.getI64IntegerAttr(0),
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

        // For now, mid.call has no result (void).  Return type recovery
        // happens in later passes.
        auto midCall = rewriter.create<mid::CallOp>(
            op.getLoc(),
            /*result=*/TypeRange{},
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

        rewriter.eraseOp(op);
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

        // LEA: base + index * scale + displacement
        // First: index * scale
        auto scale_val = rewriter.create<mid::ConstantOp>(
            loc, result_type,
            rewriter.getI64IntegerAttr(op.getScale()),
            /*address=*/mlir::IntegerAttr{}
        );
        auto scaled_index = rewriter.create<mid::BinExprOp>(
            loc, result_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Mul),
            adaptor.getIndex(), scale_val.getResult(),
            /*address=*/mlir::IntegerAttr{}
        );

        // base + scaled_index
        auto base_plus_index = rewriter.create<mid::BinExprOp>(
            loc, result_type,
            mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Add),
            adaptor.getBase(), scaled_index.getResult(),
            /*address=*/mlir::IntegerAttr{}
        );

        // + displacement
        if (op.getDisplacement() != 0) {
            auto disp_val = rewriter.create<mid::ConstantOp>(
                loc, result_type,
                rewriter.getI64IntegerAttr(op.getDisplacement()),
                /*address=*/mlir::IntegerAttr{}
            );
            auto final_val = rewriter.create<mid::BinExprOp>(
                loc, result_type,
                mid::BinExprKindAttr::get(rewriter.getContext(), mid::BinExprKind::Add),
                base_plus_index.getResult(), disp_val.getResult(),
                op.getAddressAttr()
            );
            rewriter.replaceOp(op, final_val.getResult());
        } else {
            rewriter.replaceOp(op, base_plus_index.getResult());
        }
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
            auto one = rewriter.create<mid::ConstantOp>(
                loc, result_type,
                rewriter.getI64IntegerAttr(1),
                /*address=*/mlir::IntegerAttr{}
            );
            auto bin_kind = (op.getKind() == low::UnaryOpKind::Inc)
                ? mid::BinExprKind::Add
                : mid::BinExprKind::Sub;
            auto new_op = rewriter.create<mid::BinExprOp>(
                loc, result_type,
                mid::BinExprKindAttr::get(rewriter.getContext(), bin_kind),
                adaptor.getOperand(), one.getResult(),
                op.getAddressAttr()
            );
            rewriter.replaceOp(op, {
                new_op.getResult(), false_val, false_val
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

        auto new_op = rewriter.create<mid::UnExprOp>(
            loc, result_type,
            mid::UnExprKindAttr::get(rewriter.getContext(), mid_kind),
            adaptor.getOperand(),
            op.getAddressAttr()
        );

        rewriter.replaceOp(op, {
            new_op.getResult(), false_val, false_val
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

        // Set up conversion target: HelixMid is legal, HelixLow is illegal
        ConversionTarget target(*ctx);
        target.addLegalDialect<helix::mid::HelixMidDialect>();
        target.addLegalDialect<mlir::arith::ArithDialect>();
        target.addLegalDialect<mlir::LLVM::LLVMDialect>();
        target.addIllegalDialect<helix::low::HelixLowDialect>();

        // Allow HelixLow ops that we don't convert yet (JmpOp, JccOp, FuncOp)
        // to survive — they'll be handled by subsequent passes.
        target.addLegalOp<low::JmpOp>();
        target.addLegalOp<low::JccOp>();
        target.addLegalOp<low::FuncOp>();
        target.addLegalOp<low::PushOp>();
        target.addLegalOp<low::PopOp>();
        target.addLegalOp<low::XchgOp>();

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
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Registration
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createHelixLowToMidPass() {
    return std::make_unique<HelixLowToMidPass>();
}
