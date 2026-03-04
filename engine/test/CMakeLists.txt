# ─── Helix Engine Tests ──────────────────────────────────────────────────────────

find_package(GTest QUIET)
if(NOT GTest_FOUND)
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.14.0
    )
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
endif()

enable_testing()

# ─── Test Data Directory (for integration tests) ────────────────────────────────

set(HELIX_TEST_DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../tests")

# ─── Test Executable ─────────────────────────────────────────────────────────────

add_executable(helix_tests
    RemillDemanglerTest.cpp
    Remill6DemanglerTest.cpp
    Remill6IntegrationTest.cpp
    IntegrationPipelineTest.cpp
    EmitterTest.cpp
)

target_include_directories(helix_tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../include
    ${CMAKE_CURRENT_BINARY_DIR}/../include
)

target_compile_definitions(helix_tests PRIVATE
    HELIX_TEST_DATA_DIR="${HELIX_TEST_DATA_DIR}"
)

target_link_libraries(helix_tests PRIVATE
    helix_engine
    GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(helix_tests)

# ─── Copy test fixtures ─────────────────────────────────────────────────────────

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/fixtures
     DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
