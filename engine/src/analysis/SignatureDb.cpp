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

            // If the function name matches a known signature, prefer the
            // canonical signature name (handles cases where the binary's
            // symbol table has a decorated name but we know the real API).
            auto sig = lookupSignature(funcName);
            if (sig) {
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), sig->name));
            } else {
                call.setTargetNameAttr(
                    mlir::StringAttr::get(call->getContext(), funcName));
            }
        } else {
            // Address not in module's function table — format as sub_<hex>.
            auto name = std::format("sub_{:x}", targetAddr);
            call.setTargetNameAttr(
                mlir::StringAttr::get(call->getContext(), name));
        }
    });
}
