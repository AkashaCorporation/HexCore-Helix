cmake_minimum_required(VERSION 3.20)
project(helix_engine
    VERSION 1.0.0
    LANGUAGES CXX C
    DESCRIPTION "HexCore Helix Decompilation Engine — C++23/MLIR 3-Tier Architecture"
)

# ─── C++23 Standard ─────────────────────────────────────────────────────────────

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ─── Compiler Warnings ──────────────────────────────────────────────────────────

if(MSVC)
    add_compile_options(/W4 /WX- /permissive- /Zc:__cplusplus)
else()
    add_compile_options(-Wall -Wextra -Wpedantic -Wno-unused-parameter)
endif()

# ─── LLVM/MLIR ──────────────────────────────────────────────────────────────────

option(HELIX_USE_LLVM "Link against LLVM/MLIR libraries" ON)

if(HELIX_USE_LLVM)
    if(NOT DEFINED LLVM_DIR AND DEFINED ENV{LLVM_DIR})
        set(LLVM_DIR $ENV{LLVM_DIR})
    endif()
    if(NOT DEFINED MLIR_DIR AND DEFINED ENV{MLIR_DIR})
        set(MLIR_DIR $ENV{MLIR_DIR})
    endif()

    find_package(LLVM REQUIRED CONFIG)
    find_package(MLIR REQUIRED CONFIG)

    message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
    message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
    message(STATUS "Using MLIRConfig.cmake in: ${MLIR_DIR}")

    include_directories(${LLVM_INCLUDE_DIRS})
    include_directories(${MLIR_INCLUDE_DIRS})
    separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
    add_definitions(${LLVM_DEFINITIONS_LIST})

    # ─── TableGen for MLIR Dialects ──────────────────────────────────────
    include(${MLIR_DIR}/AddMLIR.cmake OPTIONAL)

    set(HELIX_TABLEGEN_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dialects)
    set(HELIX_TABLEGEN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/include/helix/dialects)
    set(HELIX_IFACE_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/include/helix)

    # Ensure output directories exist
    file(MAKE_DIRECTORY ${HELIX_TABLEGEN_OUTPUT_DIR})
    file(MAKE_DIRECTORY ${HELIX_IFACE_OUTPUT_DIR})

    # Find mlir-tblgen
    find_program(MLIR_TBLGEN_EXE mlir-tblgen HINTS ${LLVM_TOOLS_BINARY_DIR})
    if(NOT MLIR_TBLGEN_EXE)
        message(WARNING "mlir-tblgen not found — dialect codegen will not run")
    else()
        message(STATUS "Found mlir-tblgen: ${MLIR_TBLGEN_EXE}")

        # TableGen include paths
        set(TBLGEN_INCLUDES "")
        foreach(inc_dir ${MLIR_INCLUDE_DIRS})
            list(APPEND TBLGEN_INCLUDES "-I${inc_dir}")
        endforeach()
        list(APPEND TBLGEN_INCLUDES "-I${CMAKE_CURRENT_SOURCE_DIR}")

        # ── Macro: generate all .inc files for a dialect ──────────────────
        macro(helix_tablegen_dialect DIALECT_NAME OPS_TD DIALECT_TD TYPES_TD)
            set(_OPS_TD_PATH ${HELIX_TABLEGEN_DIR}/${OPS_TD})
            set(_DIALECT_TD_PATH ${HELIX_TABLEGEN_DIR}/${DIALECT_TD})
            set(_TYPES_TD_PATH ${HELIX_TABLEGEN_DIR}/${TYPES_TD})
            set(_OUT ${HELIX_TABLEGEN_OUTPUT_DIR})

            # Op declarations/definitions
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Ops.h.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-op-decls ${TBLGEN_INCLUDES} ${_OPS_TD_PATH}
                    -o ${_OUT}/${DIALECT_NAME}Ops.h.inc
                DEPENDS ${_OPS_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} op declarations"
            )
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Ops.cpp.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-op-defs ${TBLGEN_INCLUDES} ${_OPS_TD_PATH}
                    -o ${_OUT}/${DIALECT_NAME}Ops.cpp.inc
                DEPENDS ${_OPS_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} op definitions"
            )

            # Dialect declarations/definitions
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Dialect.h.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-dialect-decls ${TBLGEN_INCLUDES}
                    ${_DIALECT_TD_PATH} -o ${_OUT}/${DIALECT_NAME}Dialect.h.inc
                DEPENDS ${_DIALECT_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} dialect declaration"
            )
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Dialect.cpp.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-dialect-defs ${TBLGEN_INCLUDES}
                    ${_DIALECT_TD_PATH} -o ${_OUT}/${DIALECT_NAME}Dialect.cpp.inc
                DEPENDS ${_DIALECT_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} dialect definition"
            )

            # Enum declarations/definitions
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Enums.h.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-enum-decls ${TBLGEN_INCLUDES} ${_OPS_TD_PATH}
                    -o ${_OUT}/${DIALECT_NAME}Enums.h.inc
                DEPENDS ${_OPS_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} enum declarations"
            )
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Enums.cpp.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-enum-defs ${TBLGEN_INCLUDES} ${_OPS_TD_PATH}
                    -o ${_OUT}/${DIALECT_NAME}Enums.cpp.inc
                DEPENDS ${_OPS_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} enum definitions"
            )

            # Type declarations/definitions
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Types.h.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-typedef-decls ${TBLGEN_INCLUDES}
                    ${_TYPES_TD_PATH} -o ${_OUT}/${DIALECT_NAME}Types.h.inc
                DEPENDS ${_TYPES_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} type declarations"
            )
            add_custom_command(
                OUTPUT ${_OUT}/${DIALECT_NAME}Types.cpp.inc
                COMMAND ${MLIR_TBLGEN_EXE} -gen-typedef-defs ${TBLGEN_INCLUDES}
                    ${_TYPES_TD_PATH} -o ${_OUT}/${DIALECT_NAME}Types.cpp.inc
                DEPENDS ${_TYPES_TD_PATH}
                COMMENT "Generating ${DIALECT_NAME} type definitions"
            )
        endmacro()

        # ── Generate all three dialects ──────────────────────────────────
        helix_tablegen_dialect(HelixLow  HelixLowOps.td  HelixLowDialect.td  HelixLowTypes.td)
        helix_tablegen_dialect(HelixMid  HelixMidOps.td  HelixMidDialect.td  HelixMidTypes.td)
        helix_tablegen_dialect(HelixHigh HelixHighOps.td HelixHighDialect.td HelixHighTypes.td)

        # ── Helix Interfaces TableGen ────────────────────────────────────
        set(HELIX_IFACE_TD ${HELIX_TABLEGEN_DIR}/HelixInterfaces.td)
        add_custom_command(
            OUTPUT ${HELIX_IFACE_OUTPUT_DIR}/HelixInterfaces.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-op-interface-decls ${TBLGEN_INCLUDES}
                ${HELIX_IFACE_TD} -o ${HELIX_IFACE_OUTPUT_DIR}/HelixInterfaces.h.inc
            DEPENDS ${HELIX_IFACE_TD}
            COMMENT "Generating Helix interface declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_IFACE_OUTPUT_DIR}/HelixInterfaces.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-op-interface-defs ${TBLGEN_INCLUDES}
                ${HELIX_IFACE_TD} -o ${HELIX_IFACE_OUTPUT_DIR}/HelixInterfaces.cpp.inc
            DEPENDS ${HELIX_IFACE_TD}
            COMMENT "Generating Helix interface definitions"
        )

        # ── Collect all generated files ──────────────────────────────────
        add_custom_target(helix_tablegen ALL DEPENDS
            # HelixLow
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.cpp.inc
            # HelixMid (NEW in v1.0)
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidOps.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidOps.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidDialect.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidDialect.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidEnums.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidEnums.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidTypes.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixMidTypes.cpp.inc
            # HelixHigh
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.cpp.inc
            # Interfaces
            ${HELIX_IFACE_OUTPUT_DIR}/HelixInterfaces.h.inc
            ${HELIX_IFACE_OUTPUT_DIR}/HelixInterfaces.cpp.inc
        )
    endif()
endif()

# ─── Helix Engine Library ────────────────────────────────────────────────────────

set(HELIX_SOURCES
    # Core
    src/Engine.cpp
    src/CApi.cpp
    src/Pipeline.cpp

    # Dialects — 3-tier architecture (Low → Mid → High)
    src/dialects/HelixLowDialect.cpp
    src/dialects/HelixLowOps.cpp
    src/dialects/HelixMidDialect.cpp          # NEW v1.0
    src/dialects/HelixMidOps.cpp              # NEW v1.0
    src/dialects/HelixHighDialect.cpp
    src/dialects/HelixHighOps.cpp

    # Analysis
    src/analysis/RemillDemangler.cpp
    src/analysis/SignatureDb.cpp
    src/analysis/CallingConventionDb.cpp

    # Analysis — Helix-Nightly
    src/analysis/TypeLattice.cpp               # P1.5 Type lattice
    src/analysis/JumpTableAnalysis.cpp         # P0.2 Jump table detection
    src/analysis/DataSectionProvider.cpp       # P0.2 Binary data access
    src/analysis/StructRecovery.cpp            # P1.6 Struct recovery
    src/analysis/SubRegisterMap.cpp            # P2.9 Sub-register SSA
    src/analysis/NonzeroMaskAnalysis.cpp       # P3.13 Nonzero mask
    src/analysis/IntrinsicModel.cpp            # P3.14 Intrinsic models
    src/analysis/HelixValueRangeAnalysis.cpp   # P3.12 Value range

    # Passes — original v0.5 analysis passes
    src/passes/Passes.cpp
    src/passes/RemillToHelixLow.cpp
    src/passes/RecoverStackLayout.cpp
    src/passes/RecoverCallingConvention.cpp
    src/passes/PropagateTypes.cpp
    src/passes/StructureControlFlow.cpp
    src/passes/RecoverVariables.cpp
    src/passes/EliminateDeadCode.cpp

    # Passes — v3.8.0 optimization passes
    src/passes/RecoverMagicDivision.cpp        # NEW v3.8.0
    src/passes/DevirtualizeIndirectCalls.cpp   # NEW v3.8.0
    src/passes/InterProceduralTypePropagation.cpp  # NEW v3.8.0

    # Passes — Helix-Nightly (Pattern Rewrite Engine + new passes)
    src/passes/HelixLowSimplify.cpp           # P0.1 Pattern rewrite (HelixLow)
    src/passes/HelixMidSimplify.cpp           # P0.1 Pattern rewrite (HelixMid)
    src/passes/patterns/ArithPatterns.cpp     # P0.1 Arithmetic patterns
    src/passes/patterns/FlagPatterns.cpp      # P0.1 Flag patterns
    src/passes/patterns/MemoryPatterns.cpp    # P0.1 Memory patterns
    src/passes/patterns/CastPatterns.cpp      # P0.1 Cast patterns
    src/passes/patterns/ConstantFoldPatterns.cpp  # P2.11 Constant folding
    src/passes/RecoverSwitchTables.cpp        # P0.2 Switch/jump table
    src/passes/EscapeAnalysis.cpp             # P2.8 Escape analysis
    src/passes/RecoverStructTypes.cpp         # P1.6 Struct recovery
    src/passes/SubRegisterSSA.cpp             # P2.9 Sub-register refinement
    src/passes/ConstantFoldingPass.cpp        # P2.11 Constant folding pass

    # Passes — v1.0 dialect conversion passes
    src/passes/HelixLowToMid.cpp              # NEW v1.0
    src/passes/HelixMidToHigh.cpp             # NEW v1.0
    # Emitters
    src/emit/PseudoCEmitter.cpp
    src/emit/FlatBufSerializer.cpp
)

set(HELIX_HEADERS
    include/helix/Engine.h
    include/helix/Types.h
    include/helix/Pipeline.h
    include/helix/Interfaces.h                # NEW v1.0
    include/helix/passes/Passes.h
    # Dialects — Low
    include/helix/dialects/HelixLowDialect.h
    include/helix/dialects/HelixLowTypes.h
    include/helix/dialects/HelixLowOps.h
    # Dialects — Mid (NEW v1.0)
    include/helix/dialects/HelixMidDialect.h
    include/helix/dialects/HelixMidTypes.h
    include/helix/dialects/HelixMidOps.h
    # Dialects — High
    include/helix/dialects/HelixHighDialect.h
    include/helix/dialects/HelixHighTypes.h
    include/helix/dialects/HelixHighOps.h
    # Emitters & Analysis
    include/helix/emit/PseudoCEmitter.h
    include/helix/emit/FlatBufSerializer.h
    include/helix/analysis/RemillDemangler.h
    include/helix/analysis/SignatureDb.h
    include/helix/analysis/X86RegisterInfo.h
    # Helix-Nightly headers
    include/helix/passes/Patterns.h
    include/helix/analysis/TypeLattice.h
    include/helix/analysis/JumpTableAnalysis.h
    include/helix/analysis/DataSectionProvider.h
    include/helix/analysis/CallingConventionDb.h
    include/helix/analysis/StructRecovery.h
    include/helix/analysis/SubRegisterMap.h
    include/helix/analysis/HelixValueRangeAnalysis.h
    include/helix/analysis/NonzeroMaskAnalysis.h
    include/helix/analysis/IntrinsicModel.h
)

add_library(helix_engine STATIC ${HELIX_SOURCES} ${HELIX_HEADERS})

target_include_directories(helix_engine
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# Depend on TableGen-generated files
if(TARGET helix_tablegen)
    add_dependencies(helix_engine helix_tablegen)
endif()

# Link LLVM/MLIR
if(HELIX_USE_LLVM)
    # Core LLVM libraries needed for decompilation
    llvm_map_components_to_libnames(LLVM_LIBS
        core
        support
        irreader
        analysis
        passes
        target
        x86codegen
        x86asmparser
        x86desc
        x86info
        aarch64codegen
        aarch64asmparser
        aarch64desc
        aarch64info
    )

    target_link_libraries(helix_engine PRIVATE ${LLVM_LIBS})

    # MLIR libraries for dialect infrastructure and translation
    target_link_libraries(helix_engine PRIVATE
        # Core MLIR
        MLIRIR
        MLIRDialect
        MLIRPass
        MLIRTransforms
        MLIRSupport

        # Analysis
        MLIRAnalysis

        # LLVM Dialect and Translation
        MLIRLLVMDialect
        MLIRLLVMCommonConversion
        MLIRTargetLLVMIRImport
        MLIRLLVMIRToLLVMTranslation
        MLIRLLVMIRToNVVMTranslation

        # Built-in passes
        MLIRTransformUtils

        # Interfaces
        MLIRSideEffectInterfaces
        MLIRControlFlowInterfaces
        MLIRFunctionInterfaces
        MLIRInferTypeOpInterface

        # Arith Dialect
        MLIRArithDialect

        # UB Dialect (dependency of ArithDialect in MLIR 18+)
        MLIRUBDialect

        # Func Dialect (required by LLVM IR translation)
        MLIRFuncDialect

        # Control Flow Dialect (cf::BranchOp in StructureControlFlow)
        MLIRControlFlowDialect

        # SCF Dialect (structured control flow)
        MLIRSCFDialect

        # DLTI Dialect (required by translateLLVMIRToModule)
        MLIRDLTIDialect

    )
endif()

# ─── FlatBuffers (optional) ──────────────────────────────────────────────────────

find_package(flatbuffers QUIET)
if(flatbuffers_FOUND)
    message(STATUS "Found FlatBuffers — enabling real serialization")
    target_link_libraries(helix_engine PRIVATE flatbuffers::flatbuffers)
    target_compile_definitions(helix_engine PRIVATE HELIX_HAS_FLATBUFFERS)
endif()

# ─── CLI Tool ──────────────────────────────────────────────────────────────────

option(HELIX_BUILD_TOOLS "Build Helix CLI tools" ON)
if(HELIX_BUILD_TOOLS)
    add_executable(helix_tool tools/helix_tool.cpp)
    target_link_libraries(helix_tool PRIVATE helix_engine)
    target_include_directories(helix_tool PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_BINARY_DIR}/include
    )

    # MLIR's internal recursion can blow the default 1 MB stack on large IR
    # inputs.  Set the PE default stack reserve to 64 MB.
    if(MSVC)
        target_link_options(helix_tool PRIVATE /STACK:67108864)
    endif()

    install(TARGETS helix_tool RUNTIME DESTINATION bin)
endif()

# ─── Install ─────────────────────────────────────────────────────────────────────

install(TARGETS helix_engine
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY include/ DESTINATION include)

# ─── Tests (optional) ────────────────────────────────────────────────────────────

option(HELIX_BUILD_TESTS "Build Helix engine tests" OFF)
if(HELIX_BUILD_TESTS)
    add_subdirectory(test)
endif()

# ─── Summary ─────────────────────────────────────────────────────────────────────

message(STATUS "")
message(STATUS "╔══════════════════════════════════════════╗")
message(STATUS "║   HexCore Helix Engine v${PROJECT_VERSION}           ║")
message(STATUS "╠══════════════════════════════════════════╣")
message(STATUS "║  Architecture:  3-Tier (Low→Mid→High)   ║")
message(STATUS "║  C++ Standard:  C++${CMAKE_CXX_STANDARD}                    ║")
message(STATUS "║  LLVM/MLIR:     ${HELIX_USE_LLVM}                      ║")
message(STATUS "║  Emitter:       PseudoC                   ║")
message(STATUS "║  FlatBuffers:   ${flatbuffers_FOUND}")
message(STATUS "║  CLI Tool:      ${HELIX_BUILD_TOOLS}")
message(STATUS "║  Tests:         ${HELIX_BUILD_TESTS}")
message(STATUS "║  Build Type:    ${CMAKE_BUILD_TYPE}")
message(STATUS "╚══════════════════════════════════════════╝")
message(STATUS "")
