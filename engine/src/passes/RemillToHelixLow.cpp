/// @file RemillToHelixLow.cpp
/// @brief MLIR conversion pass: LLVM Dialect → HelixLow Dialect.
///
/// Recognizes Remill IR patterns (State struct GEPs with !remill_register
/// metadata, mangled C++ semantic function calls, __remill_* intrinsics)
/// and converts them to explicit HelixLow dialect operations.
///
/// This pass is the bridge between LLVM's generic IR representation and
/// Helix's decompiler-specific IR.

#include "helix/passes/Passes.h"
#include "helix/dialects/HelixLowOps.h"
#include "helix/analysis/RemillDemangler.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/SmallVector.h"

#include <format>
#include <string>
#include <string_view>

using namespace mlir;
using namespace helix;

// ═══════════════════════════════════════════════════════════════════════════════
// Helper: Register Tracking
// ═══════════════════════════════════════════════════════════════════════════════

namespace {

/// Tracks which MLIR Values correspond to register GEP pointers.
/// Built during the initial scan of the LLVM Dialect module by recognizing
/// getelementptr operations that carry !remill_register metadata.
struct RegisterTracker {
    /// Maps SSA values (GEP results) to their register name.
    llvm::DenseMap<Value, std::string> gep_to_reg;

    /// Maps register names to their bit width (derived from access patterns).
    llvm::StringMap<unsigned> reg_widths;

    /// x86-64 GPR struct index-to-register mapping.
    /// Remill State → X86State → GPR field at struct index 6.
    /// The GPR struct alternates: padding (i64) + Reg.
    /// Field indices: 1=RAX, 3=RBX, 5=RCX, 7=RDX, 9=RSI, 11=RDI,
    ///   13=RSP, 15=RBP, 17=R8, 19=R9, 21=R10, 23=R11,
    ///   25=R12, 27=R13, 29=R14, 31=R15, 33=RIP
    static constexpr std::pair<int, const char*> kGprIndexMap[] = {
        {1, "RAX"}, {3, "RBX"}, {5, "RCX"}, {7, "RDX"},
        {9, "RSI"}, {11, "RDI"}, {13, "RSP"}, {15, "RBP"},
        {17, "R8"}, {19, "R9"}, {21, "R10"}, {23, "R11"},
        {25, "R12"}, {27, "R13"}, {29, "R14"}, {31, "R15"},
        {33, "RIP"},
    };

    /// Scan a function body and build the register map.
    void scan(LLVM::LLVMFuncOp func) {
        func.walk([&](LLVM::GEPOp gep) {
            // Strategy 1: Check for !remill_register metadata as an MLIR attribute.
            if (auto regAttr = gep->getAttrOfType<StringAttr>("remill_register")) {
                std::string name = regAttr.getValue().str();
                gep_to_reg[gep.getResult()] = name;
                reg_widths[name] = inferRegWidth(name);
                return;
            }

            // Strategy 2: Check llvm.metadata dictionary for the register name.
            if (auto metaDict = gep->getAttrOfType<DictionaryAttr>("llvm.metadata")) {
                if (auto regAttr = metaDict.getAs<StringAttr>("remill_register")) {
                    std::string name = regAttr.getValue().str();
                    gep_to_reg[gep.getResult()] = name;
                    reg_widths[name] = inferRegWidth(name);
                    return;
                }
            }

            // Strategy 3: Structural analysis of GEP indices into the State struct.
            // Remill pattern: gep %state, 0, 0, 6, <gpr_field_index>, 0, 0
            // where the indices are: State→X86State→GPR→<field>→Reg→union→i64
            auto indices = gep.getIndices();
            if (indices.size() >= 4) {
                // Check for the GPR struct access pattern:
                // First 3 constant indices should be 0, 0, 6 (State → X86State → GPR)
                if (auto constIndices = extractConstantGEPIndices(gep)) {
                    if (constIndices->size() >= 4 &&
                        (*constIndices)[0] == 0 &&
                        (*constIndices)[1] == 0 &&
                        (*constIndices)[2] == 6) {
                        int gprIdx = (*constIndices)[3];
                        for (auto [idx, name] : kGprIndexMap) {
                            if (idx == gprIdx) {
                                gep_to_reg[gep.getResult()] = name;
                                reg_widths[name] = inferRegWidth(name);
                                return;
                            }
                        }
                    }
                }
            }
        });

        // Also track alloca-based bookkeeping values (for filtering).
        func.walk([&](LLVM::AllocaOp alloca) {
            // BRANCH_TAKEN, RETURN_PC, MONITOR, etc. are Remill internals.
        });
    }

    /// Try to extract constant integer indices from a GEP operation.
    static std::optional<SmallVector<int, 6>>
    extractConstantGEPIndices(LLVM::GEPOp gep) {
        SmallVector<int, 6> result;
        for (auto idx : gep.getIndices()) {
            // In MLIR LLVM dialect, GEP indices can be either constant attributes
            // or SSA values. We only handle constant attributes here.
            if (auto intAttr = dyn_cast<IntegerAttr>(idx)) {
                result.push_back(static_cast<int>(intAttr.getInt()));
            } else if (auto val = dyn_cast<Value>(idx)) {
                // Try to resolve through a constant op
                if (auto constOp = val.getDefiningOp<LLVM::ConstantOp>()) {
                    if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                        result.push_back(static_cast<int>(intAttr.getInt()));
                        continue;
                    }
                }
                return std::nullopt;  // Non-constant index
            }
        }
        return result;
    }

    /// Infer register bit width from its name.
    static unsigned inferRegWidth(llvm::StringRef name) {
        // 64-bit: RAX, RBX, RCX, RDX, RSI, RDI, RSP, RBP, R8-R15, RIP
        if (name.starts_with("R") || name == "RIP")
            return 64;
        // 32-bit: EAX, EBX, etc.
        if (name.starts_with("E"))
            return 32;
        // 16-bit: AX, BX, CX, DX, SI, DI, SP, BP
        if (name.size() == 2 && (name.ends_with("X") || name.ends_with("I") ||
                                  name.ends_with("P")))
            return 16;
        // 8-bit: AL, AH, BL, BH, CL, CH, DL, DH
        if (name.size() == 2 && (name.ends_with("L") || name.ends_with("H")))
            return 8;
        // Special: flags, segments, PC
        if (name == "PC" || name == "NEXT_PC")
            return 64;
        // Default to 64-bit for unknown registers
        return 64;
    }

    /// Check if a value is a known register GEP pointer.
    bool isRegisterPtr(Value val) const {
        return gep_to_reg.count(val) > 0;
    }

    /// Get the register name for a GEP result, if known.
    std::optional<std::string> getRegName(Value val) const {
        auto it = gep_to_reg.find(val);
        if (it != gep_to_reg.end())
            return it->second;
        return std::nullopt;
    }
};

/// Tracks PC values during conversion to set address attributes on ops.
struct PCTracker {
    /// Current PC value (if known).
    uint64_t current_pc = 0;
    /// Whether we have a valid PC.
    bool has_pc = false;

    /// Try to extract a PC value from a store to NEXT_PC.
    void trackStore(LLVM::StoreOp store, const RegisterTracker& regs) {
        // Pattern: store i64 %val, ptr %NEXT_PC
        // The stored value is often: add i64 %prev_pc, <instr_size>
        auto destReg = regs.getRegName(store.getAddr());
        if (destReg && (*destReg == "PC" || *destReg == "NEXT_PC")) {
            // Try to extract a constant PC value
            if (auto constOp = store.getValue().getDefiningOp<LLVM::ConstantOp>()) {
                if (auto intAttr = dyn_cast<IntegerAttr>(constOp.getValue())) {
                    current_pc = intAttr.getUInt();
                    has_pc = true;
                }
            }
        }
    }

    /// Get an optional address attribute for the current PC.
    std::optional<uint64_t> getAddress() const {
        return has_pc ? std::optional(current_pc) : std::nullopt;
    }
};

// ═══════════════════════════════════════════════════════════════════════════════
// Conversion Pass
// ═══════════════════════════════════════════════════════════════════════════════

/// The Remill-to-HelixLow conversion pass.
///
/// Processes each LLVM function in the module:
/// 1. Scans for register GEPs to build the register map
/// 2. Walks operations in order, converting recognized patterns to HelixLow ops
/// 3. Wraps the converted ops in a helix_low.func operation
/// 4. Removes the original LLVM function
struct RemillToHelixLowPass
    : public PassWrapper<RemillToHelixLowPass, OperationPass<ModuleOp>> {

    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RemillToHelixLowPass)

    StringRef getArgument() const final { return "remill-to-helix-low"; }
    StringRef getDescription() const final {
        return "Convert LLVM Dialect (Remill IR) to HelixLow Dialect";
    }

    void getDependentDialects(DialectRegistry& registry) const override {
        registry.insert<LLVM::LLVMDialect>();
        registry.insert<helix::low::HelixLowDialect>();
    }

    void runOnOperation() override {
        auto module = getOperation();

        // Process each LLVM function that looks like a Remill lifted function.
        // Remill functions have the signature:
        //   define ptr @lifted_<addr>(ptr %state, i64 %program_counter, ptr %memory)
        SmallVector<LLVM::LLVMFuncOp> funcsToConvert;

        module.walk([&](LLVM::LLVMFuncOp func) {
            auto name = func.getName();
            // Remill lifted functions start with "lifted_" or "sub_"
            if (name.starts_with("lifted_") || name.starts_with("sub_")) {
                funcsToConvert.push_back(func);
            }
        });

        for (auto func : funcsToConvert) {
            if (failed(convertFunction(func))) {
                signalPassFailure();
                return;
            }
        }
    }

private:
    /// Convert a single Remill lifted function to HelixLow.
    LogicalResult convertFunction(LLVM::LLVMFuncOp llvmFunc) {
        OpBuilder builder(llvmFunc->getContext());
        builder.setInsertionPointAfter(llvmFunc);

        // Extract entry address from function name.
        // Pattern: "lifted_<decimal_addr>" or "sub_<hex_addr>"
        uint64_t entryAddr = 0;
        auto name = llvmFunc.getName();
        if (name.starts_with("lifted_")) {
            auto addrStr = name.drop_front(7);
            // Parse as decimal (Remill convention)
            llvm::StringRef(addrStr).getAsInteger(10, entryAddr);
        } else if (name.starts_with("sub_")) {
            auto addrStr = name.drop_front(4);
            llvm::StringRef(addrStr).getAsInteger(16, entryAddr);
        }

        // Build register tracker.
        RegisterTracker regs;
        regs.scan(llvmFunc);

        // Create the HelixLow function.
        auto funcName = std::format("sub_{:x}", entryAddr);
        auto helixFunc = builder.create<helix::low::FuncOp>(
            llvmFunc.getLoc(),
            builder.getStringAttr(funcName),
            builder.getUI64IntegerAttr(entryAddr),
            /*original_name=*/StringAttr{});

        // Create the entry block in the HelixLow function.
        auto* entryBlock = new Block();
        helixFunc.getBody().push_back(entryBlock);
        builder.setInsertionPointToStart(entryBlock);

        // Walk the original function's operations and convert them.
        PCTracker pcTracker;
        auto& llvmBody = llvmFunc.getBody();

        for (auto& block : llvmBody) {
            for (auto& op : block.getOperations()) {
                // Track PC updates.
                if (auto store = dyn_cast<LLVM::StoreOp>(&op)) {
                    pcTracker.trackStore(store, regs);
                }

                convertOperation(&op, builder, regs, pcTracker);
            }
        }

        // Add a terminator if the block doesn't have one.
        if (entryBlock->empty() ||
            !entryBlock->back().hasTrait<OpTrait::IsTerminator>()) {
            auto addr = pcTracker.has_pc
                ? builder.getUI64IntegerAttr(pcTracker.current_pc)
                : IntegerAttr{};
            builder.create<helix::low::RetOp>(
                llvmFunc.getLoc(), addr);
        }

        // Remove the original LLVM function.
        llvmFunc.erase();

        return success();
    }

    /// Convert a single LLVM Dialect operation to HelixLow.
    void convertOperation(Operation* op, OpBuilder& builder,
                          const RegisterTracker& regs,
                          PCTracker& pcTracker) {
        auto loc = op->getLoc();
        auto addrAttr = pcTracker.has_pc
            ? builder.getUI64IntegerAttr(pcTracker.current_pc)
            : IntegerAttr{};

        // ─── Pattern: Load from register pointer ─────────────────────────
        if (auto load = dyn_cast<LLVM::LoadOp>(op)) {
            if (auto regName = regs.getRegName(load.getAddr())) {
                unsigned width = RegisterTracker::inferRegWidth(*regName);
                auto intTy = builder.getIntegerType(width);

                builder.create<helix::low::RegReadOp>(
                    loc,
                    intTy,
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                return;
            }
            // Non-register load — could be stack/memory access
            // For now, emit as mem.read if we have an address value
            return;
        }

        // ─── Pattern: Store to register pointer ──────────────────────────
        if (auto store = dyn_cast<LLVM::StoreOp>(op)) {
            if (auto regName = regs.getRegName(store.getAddr())) {
                // Skip PC/NEXT_PC updates — these are bookkeeping
                if (*regName == "PC" || *regName == "NEXT_PC")
                    return;
                // Skip MEMORY, STATE, segment bases — Remill internals
                if (*regName == "MEMORY" || *regName == "STATE" ||
                    regName->ends_with("BASE"))
                    return;

                unsigned width = RegisterTracker::inferRegWidth(*regName);

                builder.create<helix::low::RegWriteOp>(
                    loc,
                    store.getValue(),
                    builder.getStringAttr(*regName),
                    builder.getUI32IntegerAttr(width),
                    addrAttr);
                return;
            }
            return;
        }

        // ─── Pattern: Call to Remill semantic or intrinsic ───────────────
        if (auto call = dyn_cast<LLVM::CallOp>(op)) {
            auto callee = call.getCallee();
            if (!callee)
                return;

            auto calleeName = callee->str();

            // Check for Remill memory intrinsics.
            if (calleeName.starts_with("__remill_read_memory_")) {
                unsigned width = extractRemillMemoryWidth(calleeName);
                if (width == 0) return;

                auto intTy = builder.getIntegerType(width);
                // __remill_read_memory_N(ptr %memory, i64 %addr) -> iN
                // Operand 1 is the address (operand 0 is the memory token).
                if (call.getNumOperands() >= 2) {
                    builder.create<helix::low::MemReadOp>(
                        loc,
                        intTy,
                        call.getOperand(1),  // address
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                }
                return;
            }

            if (calleeName.starts_with("__remill_write_memory_")) {
                unsigned width = extractRemillMemoryWidth(calleeName);
                if (width == 0) return;

                // __remill_write_memory_N(ptr %memory, i64 %addr, iN %value) -> ptr
                if (call.getNumOperands() >= 3) {
                    builder.create<helix::low::MemWriteOp>(
                        loc,
                        call.getOperand(1),  // address
                        call.getOperand(2),  // value
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                }
                return;
            }

            // Skip other Remill helpers (flag computations, etc.)
            if (calleeName.starts_with("__remill_") ||
                calleeName.starts_with("llvm.")) {
                return;
            }

            // Try to demangle as a Remill semantic function.
            auto semInfo = demangleRemillSemantic(calleeName);
            if (!semInfo)
                return;

            if (semInfo->is_helper)
                return;

            convertSemantic(call, builder, regs, *semInfo, addrAttr, loc);
            return;
        }

        // ─── Pattern: GEP (register access setup) — skip ────────────────
        if (isa<LLVM::GEPOp>(op))
            return;

        // ─── Pattern: Alloca (Remill internals) — skip ──────────────────
        if (isa<LLVM::AllocaOp>(op))
            return;

        // ─── Pattern: Return — emit HelixLow ret ────────────────────────
        if (isa<LLVM::ReturnOp>(op)) {
            builder.create<helix::low::RetOp>(loc, addrAttr);
            return;
        }

        // ─── Pattern: Add (PC increment) — check if bookkeeping ─────────
        // Remill emits: %next = add i64 %pc, <size> for PC tracking.
        // We skip these as they're handled by PCTracker.
        if (isa<LLVM::AddOp>(op))
            return;

        // Other LLVM ops are currently ignored (will be handled as passes mature).
    }

    /// Convert a recognized Remill semantic function call to HelixLow ops.
    void convertSemantic(LLVM::CallOp call, OpBuilder& builder,
                         const RegisterTracker& regs,
                         const RemillSemanticInfo& semInfo,
                         IntegerAttr addrAttr, Location loc) {
        auto semantic = semInfo.semantic;

        // Determine the working integer type (default 64-bit for x86_64).
        auto i64Ty = builder.getIntegerType(64);
        auto i1Ty = builder.getIntegerType(1);

        switch (semantic) {
        // ─── Arithmetic/Logic Binary Ops ─────────────────────────────────
        case RemillSemantic::ADD:
        case RemillSemantic::SUB:
        case RemillSemantic::MUL:
        case RemillSemantic::IMUL:
        case RemillSemantic::DIV:
        case RemillSemantic::IDIV:
        case RemillSemantic::AND:
        case RemillSemantic::OR:
        case RemillSemantic::XOR:
        case RemillSemantic::SHL:
        case RemillSemantic::SHR:
        case RemillSemantic::SAR:
        case RemillSemantic::ROL:
        case RemillSemantic::ROR: {
            auto kind = semanticToBinOpKind(semantic);
            if (!kind) break;

            // Remill semantic calls pass operands after (memory, state):
            //   call @_ZN..ADD...(ptr %mem, ptr %state, i64 %dst, i64 %src, i64 %val)
            // The exact operand layout varies, but operands 2+ are the instruction ops.
            if (call.getNumOperands() >= 4) {
                builder.create<helix::low::BinOp>(
                    loc,
                    /*result=*/i64Ty,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    builder.getI32IntegerAttr(static_cast<int32_t>(*kind)),
                    call.getOperand(2),   // lhs (often reg value)
                    call.getOperand(3),   // rhs (src/imm)
                    addrAttr);
            }
            break;
        }

        // ─── Comparison ──────────────────────────────────────────────────
        case RemillSemantic::CMP: {
            if (call.getNumOperands() >= 4) {
                builder.create<helix::low::CmpOp>(
                    loc,
                    /*carry_flag=*/i1Ty,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    /*overflow_flag=*/i1Ty,
                    call.getOperand(2),
                    call.getOperand(3),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::TEST: {
            if (call.getNumOperands() >= 4) {
                builder.create<helix::low::TestOp>(
                    loc,
                    /*zero_flag=*/i1Ty,
                    /*sign_flag=*/i1Ty,
                    call.getOperand(2),
                    call.getOperand(3),
                    addrAttr);
            }
            break;
        }

        // ─── Data Movement ───────────────────────────────────────────────
        case RemillSemantic::MOV: {
            // Remill MOV semantic: call @MOV(mem, state, dst_reg_ptr, src_value)
            // The register write happens inside the callee. Since MLIR doesn't
            // inline, we must explicitly emit a reg.write here.
            // Operand layout: [0]=memory, [1]=state, [2]=dest_reg_ptr, [3]=value
            if (call.getNumOperands() >= 4) {
                auto destRegPtr = call.getOperand(2);
                auto srcValue = call.getOperand(3);

                // Try to resolve the destination register name from the GEP pointer.
                auto regName = regs.getRegName(destRegPtr);
                if (regName) {
                    unsigned width = RegisterTracker::inferRegWidth(*regName);
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        srcValue,
                        builder.getStringAttr(*regName),
                        builder.getUI32IntegerAttr(width),
                        addrAttr);
                } else {
                    // Unknown destination — emit as a generic 64-bit reg.write.
                    builder.create<helix::low::RegWriteOp>(
                        loc,
                        srcValue,
                        builder.getStringAttr("unknown"),
                        builder.getUI32IntegerAttr(64),
                        addrAttr);
                }
            }
            break;
        }

        case RemillSemantic::MOVZX: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::MovZxOp>(
                    loc,
                    i64Ty,
                    call.getOperand(2),
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::MOVSX:
        case RemillSemantic::CDQE:
        case RemillSemantic::CDQ: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::MovSxOp>(
                    loc,
                    i64Ty,
                    call.getOperand(2),
                    builder.getUI32IntegerAttr(64),
                    addrAttr);
            }
            break;
        }

        // ─── Stack Operations ────────────────────────────────────────────
        case RemillSemantic::PUSH: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::PushOp>(
                    loc,
                    call.getOperand(2),  // value to push
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::POP: {
            builder.create<helix::low::PopOp>(
                loc,
                i64Ty,
                addrAttr);
            break;
        }

        // ─── Control Flow ────────────────────────────────────────────────
        case RemillSemantic::CALL: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::CallOp>(
                    loc,
                    call.getOperand(2),  // target address
                    /*target_name=*/StringAttr{},
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::RET: {
            builder.create<helix::low::RetOp>(loc, addrAttr);
            break;
        }

        case RemillSemantic::JMP: {
            // Remill JMP semantic:
            //   call @JMP(mem, state, target_addr, NEXT_PC_ptr)
            // Operands: [0]=mem, [1]=state, [2]=target, [3]=next_pc_ptr
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::JmpOp>(
                    loc,
                    call.getOperand(2),  // target address
                    addrAttr);
            }
            break;
        }

        // ─── Conditional Jumps ───────────────────────────────────────────
        case RemillSemantic::JZ:
        case RemillSemantic::JNZ:
        case RemillSemantic::JB:
        case RemillSemantic::JNB:
        case RemillSemantic::JBE:
        case RemillSemantic::JNBE:
        case RemillSemantic::JL:
        case RemillSemantic::JNL:
        case RemillSemantic::JLE:
        case RemillSemantic::JNLE:
        case RemillSemantic::JS:
        case RemillSemantic::JNS:
        case RemillSemantic::JO:
        case RemillSemantic::JNO:
        case RemillSemantic::JP:
        case RemillSemantic::JNP: {
            // Remill Jcc semantic:
            //   call @JZ(mem, state, BRANCH_TAKEN_ptr, taken_addr, fallthrough_addr, NEXT_PC_ptr)
            // Operands: [0]=mem, [1]=state, [2]=branch_taken_ptr, [3]=taken, [4]=fallthrough, [5]=next_pc_ptr
            auto condStr = getJccCondition(semantic);
            if (condStr && call.getNumOperands() >= 5) {
                // Create a flag placeholder (the actual flag comes from the preceding CMP/TEST).
                auto flagVal = builder.create<LLVM::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true));

                builder.create<helix::low::JccOp>(
                    loc,
                    builder.getStringAttr(*condStr),
                    flagVal,
                    call.getOperand(3),  // taken target address
                    call.getOperand(4),  // fallthrough address
                    addrAttr);
            }
            break;
        }

        // ─── Conditional Move ────────────────────────────────────────────
        case RemillSemantic::CMOV: {
            if (call.getNumOperands() >= 4) {
                // CMOV reads a flag and selects between two values.
                // We need the condition from the semantic name (e.g., "E", "NE").
                auto condStr = semInfo.raw_name.substr(4); // strip "CMOV"
                auto i1Val = builder.create<LLVM::ConstantOp>(
                    loc, i1Ty, builder.getBoolAttr(true));

                builder.create<helix::low::CMovOp>(
                    loc,
                    i64Ty,
                    builder.getStringAttr(condStr),
                    i1Val,
                    call.getOperand(2),
                    call.getOperand(3),
                    addrAttr);
            }
            break;
        }

        // ─── Exchange ────────────────────────────────────────────────────
        case RemillSemantic::XCHG: {
            builder.create<helix::low::XchgOp>(
                loc,
                builder.getStringAttr("reg_a"),
                builder.getStringAttr("reg_b"),
                builder.getUI32IntegerAttr(64),
                addrAttr);
            break;
        }

        // ─── Bit Manipulation ────────────────────────────────────────────
        case RemillSemantic::BSF: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Bsf)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::BSR: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Bsr)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::BSWAP: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Bswap)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::NEG: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Neg)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::NOT: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Not)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::INC: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Inc)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::DEC: {
            if (call.getNumOperands() >= 3) {
                builder.create<helix::low::UnaryOp>(
                    loc, i64Ty, i1Ty, i1Ty,
                    builder.getI32IntegerAttr(
                        static_cast<int32_t>(helix::low::UnaryOpKind::Dec)),
                    call.getOperand(2),
                    addrAttr);
            }
            break;
        }

        // ─── REP String Operations ───────────────────────────────────────
        case RemillSemantic::REP_MOVS: {
            if (call.getNumOperands() >= 5) {
                builder.create<helix::low::RepMovsOp>(
                    loc,
                    call.getOperand(2),  // dst (RDI)
                    call.getOperand(3),  // src (RSI)
                    call.getOperand(4),  // count (RCX)
                    builder.getUI32IntegerAttr(8),  // byte width
                    addrAttr);
            }
            break;
        }

        case RemillSemantic::REP_STOS: {
            if (call.getNumOperands() >= 5) {
                builder.create<helix::low::RepStosOp>(
                    loc,
                    call.getOperand(2),  // dst (RDI)
                    call.getOperand(3),  // value (AL/AX/EAX)
                    call.getOperand(4),  // count (RCX)
                    builder.getUI32IntegerAttr(8),
                    addrAttr);
            }
            break;
        }

        // ─── LEA (pure address computation) ──────────────────────────────
        case RemillSemantic::LEA: {
            // LEA is a pure address computation, not a memory access.
            // In Remill IR it computes base + index*scale + disp.
            if (call.getNumOperands() >= 4) {
                auto zero = builder.create<LLVM::ConstantOp>(
                    loc, i64Ty, builder.getI64IntegerAttr(0));
                builder.create<helix::low::LeaOp>(
                    loc, i64Ty,
                    call.getOperand(2),   // base
                    call.getOperand(3),   // index
                    builder.getUI32IntegerAttr(1),  // scale
                    builder.getSI64IntegerAttr(0),   // displacement
                    addrAttr);
            }
            break;
        }

        // ─── NOP / INT3 ─────────────────────────────────────────────────
        case RemillSemantic::NOP: {
            builder.create<helix::low::NopOp>(loc, addrAttr);
            break;
        }

        case RemillSemantic::INT3: {
            builder.create<helix::low::Int3Op>(loc, addrAttr);
            break;
        }

        // ─── Bit Test ────────────────────────────────────────────────────
        case RemillSemantic::BT:
        case RemillSemantic::BTS:
        case RemillSemantic::BTR:
        case RemillSemantic::BTC:
            // BT family — emit as a compare-like op for now
            break;

        // ─── Unhandled / Future ──────────────────────────────────────────
        default:
            // Unhandled semantics are silently skipped in Phase 2.
            // Future passes will add support for: FPU, SSE/AVX, SYSCALL, etc.
            break;
        }
    }

    /// Map a RemillSemantic to HelixLow BinOpKind.
    static std::optional<helix::low::BinOpKind>
    semanticToBinOpKind(RemillSemantic sem) {
        switch (sem) {
        case RemillSemantic::ADD:  return helix::low::BinOpKind::Add;
        case RemillSemantic::SUB:  return helix::low::BinOpKind::Sub;
        case RemillSemantic::MUL:  return helix::low::BinOpKind::Mul;
        case RemillSemantic::IMUL: return helix::low::BinOpKind::IMul;
        case RemillSemantic::DIV:  return helix::low::BinOpKind::Div;
        case RemillSemantic::IDIV: return helix::low::BinOpKind::IDiv;
        case RemillSemantic::AND:  return helix::low::BinOpKind::And;
        case RemillSemantic::OR:   return helix::low::BinOpKind::Or;
        case RemillSemantic::XOR:  return helix::low::BinOpKind::Xor;
        case RemillSemantic::SHL:  return helix::low::BinOpKind::Shl;
        case RemillSemantic::SHR:  return helix::low::BinOpKind::Shr;
        case RemillSemantic::SAR:  return helix::low::BinOpKind::Sar;
        case RemillSemantic::ROL:  return helix::low::BinOpKind::Rol;
        case RemillSemantic::ROR:  return helix::low::BinOpKind::Ror;
        default: return std::nullopt;
        }
    }
};

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Pass Factory
// ═══════════════════════════════════════════════════════════════════════════════

std::unique_ptr<mlir::Pass> helix::createRemillToHelixLowPass() {
    return std::make_unique<RemillToHelixLowPass>();
}
