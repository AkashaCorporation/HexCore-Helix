/// @file HelixInterfaces.td
/// @brief TableGen definitions for shared Helix MLIR interfaces.
///
/// These interfaces are implemented by operations across all three Helix
/// dialects (Low, Mid, High) to provide uniform access to common attributes
/// like source binary addresses and type information.

#ifndef HELIX_INTERFACES_TD
#define HELIX_INTERFACES_TD

include "mlir/IR/OpBase.td"

// ═══════════════════════════════════════════════════════════════════════════════
// HelixAddressableOpInterface
// ═══════════════════════════════════════════════════════════════════════════════
//
// Implemented by any Helix op that carries an optional `address` attribute
// mapping the operation back to a binary virtual address (PC value).
// Enables uniform source-mapping across all dialect levels.

def HelixAddressableOpInterface : OpInterface<"HelixAddressableOp"> {
  let description = [{
    Interface for Helix operations that track their origin binary address.
    Most decompilation operations carry an optional `address` attribute
    (ui64) that records the virtual address of the original machine
    instruction.  This interface provides uniform access to that attribute
    for passes that need source mapping (e.g., debug info generation,
    binary-to-source highlighting).
  }];

  let cppNamespace = "::helix";

  let methods = [
    InterfaceMethod<
      "Get the source binary address (empty if not set)",
      "std::optional<uint64_t>", "getSourceAddress", (ins),
      /*methodBody=*/[{}],
      /*defaultImplementation=*/[{
        auto attr = $_op->getAttrOfType<mlir::IntegerAttr>("address");
        if (!attr) return std::nullopt;
        return attr.getUInt();
      }]
    >,
    InterfaceMethod<
      "Set the source binary address",
      "void", "setSourceAddress", (ins "uint64_t":$addr),
      /*methodBody=*/[{}],
      /*defaultImplementation=*/[{
        $_op->setAttr("address",
            mlir::IntegerAttr::get(
                mlir::IntegerType::get($_op->getContext(), 64,
                    mlir::IntegerType::Unsigned),
                addr));
      }]
    >,
    InterfaceMethod<
      "Check whether a source binary address is set",
      "bool", "hasSourceAddress", (ins),
      /*methodBody=*/[{}],
      /*defaultImplementation=*/[{
        return $_op->hasAttr("address");
      }]
    >,
    InterfaceMethod<
      "Remove the source binary address",
      "void", "removeSourceAddress", (ins),
      /*methodBody=*/[{}],
      /*defaultImplementation=*/[{
        $_op->removeAttr("address");
      }]
    >,
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// HelixDecompilableOpInterface
// ═══════════════════════════════════════════════════════════════════════════════
//
// Implemented by function-level operations (helix_low.func, helix_mid.func,
// helix_high.func) to provide uniform access to decompilation metadata.

def HelixDecompilableOpInterface : OpInterface<"HelixDecompilableOp"> {
  let description = [{
    Interface for function-level Helix operations that carry decompilation
    metadata such as entry address and original name.
  }];

  let cppNamespace = "::helix";

  let methods = [
    InterfaceMethod<
      "Get the function's entry virtual address",
      "uint64_t", "getEntryAddress", (ins),
      /*methodBody=*/[{}],
      /*defaultImplementation=*/[{
        return $_op->getAttrOfType<mlir::IntegerAttr>("entry_address").getUInt();
      }]
    >,
    InterfaceMethod<
      "Get the function's original name (if known from symbols)",
      "std::optional<llvm::StringRef>", "getOriginalName", (ins),
      /*methodBody=*/[{}],
      /*defaultImplementation=*/[{
        auto attr = $_op->getAttrOfType<mlir::StringAttr>("original_name");
        if (!attr) return std::nullopt;
        return attr.getValue();
      }]
    >,
  ];
}

#endif // HELIX_INTERFACES_TD
