cmake_minimum_required(VERSION 3.20)
project(helix_engine
    VERSION 0.2.0
    LANGUAGES CXX C
    DESCRIPTION "HexCore Helix Decompilation Engine — C++23/MLIR Core"
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

    # Ensure output directories exist
    file(MAKE_DIRECTORY ${HELIX_TABLEGEN_OUTPUT_DIR})

    # Find mlir-tblgen
    find_program(MLIR_TBLGEN_EXE mlir-tblgen HINTS ${LLVM_TOOLS_BINARY_DIR})
    if(NOT MLIR_TBLGEN_EXE)
        message(WARNING "mlir-tblgen not found — dialect codegen will not run")
    else()
        message(STATUS "Found mlir-tblgen: ${MLIR_TBLGEN_EXE}")

        # TableGen include paths — MLIR_INCLUDE_DIRS may have multiple entries
        set(TBLGEN_INCLUDES "")
        foreach(inc_dir ${MLIR_INCLUDE_DIRS})
            list(APPEND TBLGEN_INCLUDES "-I${inc_dir}")
        endforeach()
        list(APPEND TBLGEN_INCLUDES "-I${CMAKE_CURRENT_SOURCE_DIR}")

        # ── HelixLow Dialect TableGen ────────────────────────────────────
        set(HELIX_LOW_TD ${HELIX_TABLEGEN_DIR}/HelixLowOps.td)

        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-op-decls ${TBLGEN_INCLUDES} ${HELIX_LOW_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.h.inc
            DEPENDS ${HELIX_LOW_TD}
            COMMENT "Generating HelixLow op declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-op-defs ${TBLGEN_INCLUDES} ${HELIX_LOW_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.cpp.inc
            DEPENDS ${HELIX_LOW_TD}
            COMMENT "Generating HelixLow op definitions"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-dialect-decls ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixLowDialect.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.h.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixLowDialect.td
            COMMENT "Generating HelixLow dialect declaration"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-dialect-defs ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixLowDialect.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.cpp.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixLowDialect.td
            COMMENT "Generating HelixLow dialect definition"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-enum-decls ${TBLGEN_INCLUDES} ${HELIX_LOW_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.h.inc
            DEPENDS ${HELIX_LOW_TD}
            COMMENT "Generating HelixLow enum declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-enum-defs ${TBLGEN_INCLUDES} ${HELIX_LOW_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.cpp.inc
            DEPENDS ${HELIX_LOW_TD}
            COMMENT "Generating HelixLow enum definitions"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-typedef-decls ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixLowTypes.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.h.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixLowTypes.td
            COMMENT "Generating HelixLow type declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-typedef-defs ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixLowTypes.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.cpp.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixLowTypes.td
            COMMENT "Generating HelixLow type definitions"
        )

        # ── HelixHigh Dialect TableGen ───────────────────────────────────
        set(HELIX_HIGH_TD ${HELIX_TABLEGEN_DIR}/HelixHighOps.td)

        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-op-decls ${TBLGEN_INCLUDES} ${HELIX_HIGH_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.h.inc
            DEPENDS ${HELIX_HIGH_TD}
            COMMENT "Generating HelixHigh op declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-op-defs ${TBLGEN_INCLUDES} ${HELIX_HIGH_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.cpp.inc
            DEPENDS ${HELIX_HIGH_TD}
            COMMENT "Generating HelixHigh op definitions"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-dialect-decls ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixHighDialect.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.h.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixHighDialect.td
            COMMENT "Generating HelixHigh dialect declaration"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-dialect-defs ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixHighDialect.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.cpp.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixHighDialect.td
            COMMENT "Generating HelixHigh dialect definition"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-enum-decls ${TBLGEN_INCLUDES} ${HELIX_HIGH_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.h.inc
            DEPENDS ${HELIX_HIGH_TD}
            COMMENT "Generating HelixHigh enum declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-enum-defs ${TBLGEN_INCLUDES} ${HELIX_HIGH_TD}
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.cpp.inc
            DEPENDS ${HELIX_HIGH_TD}
            COMMENT "Generating HelixHigh enum definitions"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.h.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-typedef-decls ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixHighTypes.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.h.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixHighTypes.td
            COMMENT "Generating HelixHigh type declarations"
        )
        add_custom_command(
            OUTPUT ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.cpp.inc
            COMMAND ${MLIR_TBLGEN_EXE} -gen-typedef-defs ${TBLGEN_INCLUDES}
                ${HELIX_TABLEGEN_DIR}/HelixHighTypes.td
                -o ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.cpp.inc
            DEPENDS ${HELIX_TABLEGEN_DIR}/HelixHighTypes.td
            COMMENT "Generating HelixHigh type definitions"
        )

        # Collect all generated files as a custom target
        add_custom_target(helix_tablegen ALL DEPENDS
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowOps.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowDialect.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowEnums.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixLowTypes.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighOps.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighDialect.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighEnums.cpp.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.h.inc
            ${HELIX_TABLEGEN_OUTPUT_DIR}/HelixHighTypes.cpp.inc
        )
    endif()
endif()

# ─── Helix Engine Library ────────────────────────────────────────────────────────

set(HELIX_SOURCES
    # Core
    src/Engine.cpp
    src/CApi.cpp
    src/Pipeline.cpp

    # Dialects
    src/dialects/HelixLowDialect.cpp
    src/dialects/HelixLowOps.cpp
    src/dialects/HelixHighDialect.cpp
    src/dialects/HelixHighOps.cpp

    # Analysis
    src/analysis/RemillDemangler.cpp
    src/analysis/SignatureDb.cpp

    # Passes
    src/passes/Passes.cpp
    src/passes/RemillToHelixLow.cpp
    src/passes/RecoverStackLayout.cpp
    src/passes/RecoverCallingConvention.cpp
    src/passes/PropagateTypes.cpp
    src/passes/StructureControlFlow.cpp
    src/passes/RecoverVariables.cpp
    src/passes/EliminateDeadCode.cpp

    # Emitters
    src/emit/PseudoCEmitter.cpp
    src/emit/FlatBufSerializer.cpp
)

set(HELIX_HEADERS
    include/helix/Engine.h
    include/helix/Types.h
    include/helix/Pipeline.h
    include/helix/passes/Passes.h
    include/helix/dialects/HelixLowDialect.h
    include/helix/dialects/HelixLowTypes.h
    include/helix/dialects/HelixLowOps.h
    include/helix/dialects/HelixHighDialect.h
    include/helix/dialects/HelixHighTypes.h
    include/helix/dialects/HelixHighOps.h
    include/helix/emit/PseudoCEmitter.h
    include/helix/emit/FlatBufSerializer.h
    include/helix/analysis/RemillDemangler.h
    include/helix/analysis/SignatureDb.h
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

# Phase 2: Link LLVM/MLIR
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

        # Arith Dialect (arith::ConstantOp, ShRUIOp, etc. in RecoverVariables)
        MLIRArithDialect

        # Control Flow Dialect (cf::BranchOp in StructureControlFlow)
        MLIRControlFlowDialect

        # DLTI Dialect (required by translateLLVMIRToModule for data layout)
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
    # inputs.  Set the PE default stack reserve to 16 MB so that both the
    # main thread and any std::thread spawned by the engine get enough room.
    if(MSVC)
        target_link_options(helix_tool PRIVATE /STACK:67108864)
    else()
        # On Linux/macOS, control via ulimit or pthread_attr; linker flags vary.
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
message(STATUS "=== HexCore Helix Engine ===")
message(STATUS "  Version:      ${PROJECT_VERSION}")
message(STATUS "  C++ Std:      C++${CMAKE_CXX_STANDARD}")
message(STATUS "  LLVM/MLIR:    ${HELIX_USE_LLVM}")
message(STATUS "  FlatBuffers:  ${flatbuffers_FOUND}")
message(STATUS "  CLI Tool:     ${HELIX_BUILD_TOOLS}")
message(STATUS "  Tests:        ${HELIX_BUILD_TESTS}")
message(STATUS "  Build Type:   ${CMAKE_BUILD_TYPE}")
message(STATUS "============================")
message(STATUS "")
