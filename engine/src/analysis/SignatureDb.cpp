/// @file SignatureDb.cpp
/// @brief Function signature database for known library functions.
///
/// Provides type information for common C runtime, Win32 API, and standard
/// library functions. Used by the type propagation pass to seed initial
/// type information from known function signatures.

#include "helix/analysis/SignatureDb.h"
#include "helix/dialects/HelixLowOps.h"

#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/IR/BuiltinOps.h"

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringRef.h"

#include <format>
#include <string>

using namespace helix;

namespace {

/// Lazily-built database of known function signatures.
struct SignatureDatabase {
    llvm::StringMap<FunctionSignature> db;

    SignatureDatabase() {
        // ─── C Runtime ──────────────────────────────────────────────────
        add("malloc",   "void*",   {"uint64_t"});
        add("calloc",   "void*",   {"uint64_t", "uint64_t"});
        add("realloc",  "void*",   {"void*", "uint64_t"});
        add("free",     "void",    {"void*"});
        add("memcpy",   "void*",   {"void*", "void*", "uint64_t"});
        add("memmove",  "void*",   {"void*", "void*", "uint64_t"});
        add("memset",   "void*",   {"void*", "int32_t", "uint64_t"});
        add("memcmp",   "int32_t", {"void*", "void*", "uint64_t"});
        add("strlen",   "uint64_t",{"void*"});
        add("strcpy",   "void*",   {"void*", "void*"});
        add("strncpy",  "void*",   {"void*", "void*", "uint64_t"});
        add("strcmp",   "int32_t", {"void*", "void*"});
        add("strncmp",  "int32_t", {"void*", "void*", "uint64_t"});
        add("strcat",   "void*",   {"void*", "void*"});
        add("strchr",   "void*",   {"void*", "int32_t"});
        add("strrchr",  "void*",   {"void*", "int32_t"});
        add("strstr",   "void*",   {"void*", "void*"});
        add("atoi",     "int32_t", {"void*"});
        add("atol",     "int64_t", {"void*"});
        add("printf",   "int32_t", {"void*"}, true);
        add("sprintf",  "int32_t", {"void*", "void*"}, true);
        add("snprintf", "int32_t", {"void*", "uint64_t", "void*"}, true);
        add("fprintf",  "int32_t", {"void*", "void*"}, true);
        add("puts",     "int32_t", {"void*"});
        add("fopen",    "void*",   {"void*", "void*"});
        add("fclose",   "int32_t", {"void*"});
        add("fread",    "uint64_t",{"void*", "uint64_t", "uint64_t", "void*"});
        add("fwrite",   "uint64_t",{"void*", "uint64_t", "uint64_t", "void*"});
        add("fseek",    "int32_t", {"void*", "int64_t", "int32_t"});
        add("ftell",    "int64_t", {"void*"});
        add("exit",     "void",    {"int32_t"});
        add("abort",    "void",    {});
        add("abs",      "int32_t", {"int32_t"});

        // ─── Win32 API ──────────────────────────────────────────────────
        add("GetProcAddress",       "void*",    {"void*", "void*"});
        add("LoadLibraryA",         "void*",    {"void*"});
        add("LoadLibraryW",         "void*",    {"void*"});
        add("FreeLibrary",          "int32_t",  {"void*"});
        add("GetModuleHandleA",     "void*",    {"void*"});
        add("GetModuleHandleW",     "void*",    {"void*"});
        add("CreateFileA",          "void*",    {"void*", "uint32_t", "uint32_t", "void*", "uint32_t", "uint32_t", "void*"});
        add("CreateFileW",          "void*",    {"void*", "uint32_t", "uint32_t", "void*", "uint32_t", "uint32_t", "void*"});
        add("CloseHandle",          "int32_t",  {"void*"});
        add("ReadFile",             "int32_t",  {"void*", "void*", "uint32_t", "void*", "void*"});
        add("WriteFile",            "int32_t",  {"void*", "void*", "uint32_t", "void*", "void*"});
        add("VirtualAlloc",         "void*",    {"void*", "uint64_t", "uint32_t", "uint32_t"});
        add("VirtualFree",          "int32_t",  {"void*", "uint64_t", "uint32_t"});
        add("VirtualProtect",       "int32_t",  {"void*", "uint64_t", "uint32_t", "void*"});
        add("GetLastError",         "uint32_t", {});
        add("SetLastError",         "void",     {"uint32_t"});
        add("HeapAlloc",            "void*",    {"void*", "uint32_t", "uint64_t"});
        add("HeapFree",             "int32_t",  {"void*", "uint32_t", "void*"});
        add("GetProcessHeap",       "void*",    {});
        add("CreateThread",         "void*",    {"void*", "uint64_t", "void*", "void*", "uint32_t", "void*"});
        add("WaitForSingleObject",  "uint32_t", {"void*", "uint32_t"});
        add("Sleep",                "void",     {"uint32_t"});
        add("GetTickCount",         "uint32_t", {});
        add("QueryPerformanceCounter", "int32_t", {"void*"});
        add("MessageBoxA",          "int32_t",  {"void*", "void*", "void*", "uint32_t"});
        add("MessageBoxW",          "int32_t",  {"void*", "void*", "void*", "uint32_t"});

        // ─── CRT Security Functions ─────────────────────────────────────
        add("strcpy_s",  "int32_t", {"void*", "uint64_t", "void*"});
        add("strncpy_s", "int32_t", {"void*", "uint64_t", "void*", "uint64_t"});
        add("memcpy_s",  "int32_t", {"void*", "uint64_t", "void*", "uint64_t"});
        add("sprintf_s", "int32_t", {"void*", "uint64_t", "void*"}, true);
    }

    void add(const char* name, const char* ret_type,
             std::initializer_list<const char*> param_types,
             bool variadic = false) {
        FunctionSignature sig;
        sig.name = name;
        sig.return_type = ret_type;
        for (auto* pt : param_types)
            sig.param_types.push_back(pt);
        sig.is_variadic = variadic;
        db[name] = std::move(sig);
    }
};

/// Get the global signature database (initialized once).
const SignatureDatabase& getDb() {
    static SignatureDatabase instance;
    return instance;
}

} // anonymous namespace

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

std::optional<FunctionSignature> helix::lookupSignature(llvm::StringRef name) {
    const auto& db = getDb().db;
    auto it = db.find(name);
    if (it != db.end())
        return it->second;
    return std::nullopt;
}

bool helix::isCrtFunction(llvm::StringRef name) {
    // Check if a function name is a known CRT function
    static const llvm::StringRef crtPrefixes[] = {
        "malloc", "calloc", "realloc", "free",
        "memcpy", "memmove", "memset", "memcmp",
        "strlen", "strcpy", "strncpy", "strcmp", "strncmp",
        "strcat", "strchr", "strrchr", "strstr",
        "printf", "sprintf", "snprintf", "fprintf",
        "puts", "fopen", "fclose", "fread", "fwrite",
        "fseek", "ftell", "exit", "abort", "atoi", "atol",
        "abs",
    };

    for (auto prefix : crtPrefixes) {
        if (name == prefix || name.starts_with(prefix))
            return true;
    }
    return false;
}

bool helix::isWin32Function(llvm::StringRef name) {
    // Win32 API functions typically start with a capital letter
    // and use PascalCase naming convention.
    if (name.empty() || !std::isupper(name[0]))
        return false;

    const auto& db = getDb().db;
    return db.count(name) > 0 && !isCrtFunction(name);
}

// ═══════════════════════════════════════════════════════════════════════════════
// Call Target Resolution
// ═══════════════════════════════════════════════════════════════════════════════

void helix::resolveCallTargets(mlir::ModuleOp module) {
    // Phase 1: Build address → function name map from all FuncOps in the module.
    llvm::DenseMap<uint64_t, llvm::StringRef> addrToName;

    module.walk([&](helix::low::FuncOp func) {
        uint64_t addr = func.getEntryAddress();
        auto symName = func.getSymName();
        addrToName[addr] = symName;
    });

    // Phase 1b: Build relocation map from __hxreloc__ function declarations.
    // These are emitted by the hexcore-disassembler when lifting ET_REL (.ko)
    // files. Format: @__hxreloc__<16-hex-addr>__<symbol_name>
    // The hex addr is the CALL instruction address in .text.
    llvm::DenseMap<uint64_t, std::string> relocMap;

    module.walk([&](mlir::LLVM::LLVMFuncOp func) {
        auto name = func.getSymName();
        if (!name.starts_with("__hxreloc__"))
            return;
        // Parse: skip "__hxreloc__" (11 chars), read 16 hex digits, skip "__", rest is symbol
        auto rest = name.drop_front(11); // after "__hxreloc__"
        if (rest.size() < 19) // 16 hex + "__" + at least 1 char
            return;
        auto hexPart = rest.take_front(16);
        auto symPart = rest.drop_front(18); // skip 16 hex + "__"
        if (symPart.empty())
            return;
        uint64_t instrAddr = 0;
        if (hexPart.getAsInteger(16, instrAddr))
            return; // parse failed
        relocMap[instrAddr] = symPart.str();
    });

    if (!relocMap.empty()) {
        llvm::errs() << "[Helix] resolveCallTargets: loaded " << relocMap.size()
                     << " relocation entries from __hxreloc__ declarations\n";
    }

    // Phase 2: Walk all CallOps and resolve target addresses.
    module.walk([&](helix::low::CallOp call) {
        // Skip if already resolved.
        if (call.getTargetName())
            return;

        // Try to extract a constant address from the target_addr operand.
        auto targetVal = call.getTargetAddr();
        auto* defOp = targetVal.getDefiningOp();
        if (!defOp)
            return;

        // Handle LLVM constant integer (the common case from Remill lifting).
        uint64_t targetAddr = 0;
        bool resolved = false;

        if (auto constOp = mlir::dyn_cast<mlir::LLVM::ConstantOp>(defOp)) {
            if (auto intAttr = mlir::dyn_cast<mlir::IntegerAttr>(constOp.getValue())) {
                targetAddr = intAttr.getValue().getZExtValue();
                resolved = true;
            }
        }
        // Also handle arith.constant if present.
        if (!resolved) {
            if (auto intAttr = defOp->getAttrOfType<mlir::IntegerAttr>("value")) {
                targetAddr = intAttr.getValue().getZExtValue();
                resolved = true;
            }
        }

        if (!resolved)
            return;

        // Look up the address in the module's function table.
        auto it = addrToName.find(targetAddr);
        if (it != addrToName.end()) {
            auto funcName = it->second;
            auto sig = lookupSignature(funcName);
            if (sig) {
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), sig->name));
            } else {
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), funcName));
            }
        } else if (!relocMap.empty()) {
            // Phase 2b: Check relocation map.
            // For unresolved ET_REL calls, the target is often callAddr+5
            // (rel32=0 → call to next instruction). The relocation map is
            // keyed by the CALL instruction address. Try both:
            //   1. CallOp's address attribute (instruction address directly)
            //   2. targetAddr - 5 (infer instruction address from target)
            std::string relocName;
            bool relocFound = false;

            // Method 1: Use the CallOp's own address attribute
            if (auto addrAttr = call.getAddressAttr()) {
                uint64_t instrAddr = addrAttr.getValue().getZExtValue();
                auto rit = relocMap.find(instrAddr);
                if (rit != relocMap.end()) {
                    relocName = rit->second;
                    relocFound = true;
                }
            }

            // Method 2: Infer from target = instrAddr + 5 (for call rel32=0)
            if (!relocFound && targetAddr >= 5) {
                auto rit = relocMap.find(targetAddr - 5);
                if (rit != relocMap.end()) {
                    relocName = rit->second;
                    relocFound = true;
                }
            }

            if (relocFound) {
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), relocName));
            } else {
                auto name = std::format("sub_{:x}", targetAddr);
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), name));
            }
        } else {
            // Address not in module's function table — format as sub_<hex>.
            auto name = std::format("sub_{:x}", targetAddr);
            call.setTargetNameAttr(
                mlir::StringAttr::get(call->getContext(), name));
        }
    });

    // Phase 3: Resolve remaining nameless CallOps via llvm.mlir.addressof.
    // In fresh Remill output for ET_REL files, the target operand of external
    // calls is `ptrtoint(@symbol)` which becomes `llvm.mlir.addressof @symbol`.
    // Phase 2 may have missed these because the constant address extraction
    // failed (addressof is not a constant integer).
    module.walk([&](helix::low::CallOp call) {
        if (call.getTargetName())
            return; // already resolved

        auto targetVal = call.getTargetAddr();
        auto* defOp = targetVal.getDefiningOp();
        if (!defOp)
            return;

        // Look through ptrtoint wrapper: addressof @sym → ptrtoint → target
        mlir::Value lookThrough = targetVal;
        if (auto ptrToInt = mlir::dyn_cast<mlir::LLVM::PtrToIntOp>(defOp))
            lookThrough = ptrToInt.getArg();

        auto* innerDef = lookThrough.getDefiningOp();
        if (!innerDef)
            return;

        if (auto addrOf = mlir::dyn_cast<mlir::LLVM::AddressOfOp>(innerDef)) {
            auto symName = addrOf.getGlobalName();
            if (!symName.starts_with("__remill_") &&
                !symName.starts_with("llvm.") &&
                !symName.starts_with("_ZN")) {
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), symName));
            }
        }
    });
}
