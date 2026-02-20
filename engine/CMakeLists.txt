cmake_minimum_required(VERSION 3.20)
project(helix_engine
    VERSION 0.1.0
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

# ─── LLVM/MLIR (Optional in Phase 1, Required in Phase 2+) ──────────────────────

option(HELIX_USE_LLVM "Link against LLVM/MLIR libraries" ON)

if(HELIX_USE_LLVM)
    find_package(LLVM REQUIRED CONFIG)
    find_package(MLIR REQUIRED CONFIG)

    message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
    message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

    include_directories(${LLVM_INCLUDE_DIRS})
    separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
    add_definitions(${LLVM_DEFINITIONS_LIST})

    # MLIR includes
    include_directories(${MLIR_INCLUDE_DIRS})
endif()

# ─── Helix Engine Library ────────────────────────────────────────────────────────

set(HELIX_SOURCES
    src/Engine.cpp
    src/CApi.cpp
)

set(HELIX_HEADERS
    include/helix/Engine.h
    include/helix/Types.h
)

add_library(helix_engine STATIC ${HELIX_SOURCES} ${HELIX_HEADERS})

target_include_directories(helix_engine
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# Phase 2+: Link LLVM/MLIR
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

    # MLIR libraries for dialect infrastructure
    target_link_libraries(helix_engine PRIVATE
        MLIRDialect
        MLIRIR
        MLIRTransforms
        MLIRPass
    )
endif()

# ─── Install ─────────────────────────────────────────────────────────────────────

install(TARGETS helix_engine
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY include/ DESTINATION include)

# ─── Summary ─────────────────────────────────────────────────────────────────────

message(STATUS "")
message(STATUS "=== HexCore Helix Engine ===")
message(STATUS "  Version:    ${PROJECT_VERSION}")
message(STATUS "  C++ Std:    C++${CMAKE_CXX_STANDARD}")
message(STATUS "  LLVM/MLIR:  ${HELIX_USE_LLVM}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "============================")
message(STATUS "")
