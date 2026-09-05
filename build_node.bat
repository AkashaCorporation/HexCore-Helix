@echo off
setlocal
cd /d "%~dp0"

where cl.exe >nul 2>&1
if errorlevel 1 (
    echo Run from a Visual Studio x64 Native Tools command prompt.
    exit /b 1
)
if not defined LLVM_DIR (
    echo Set LLVM_DIR to the LLVM CMake package directory.
    exit /b 1
)
if not defined MLIR_DIR (
    echo Set MLIR_DIR to the matching MLIR CMake package directory.
    exit /b 1
)
if not defined HELIX_BUILD_DIR set "HELIX_BUILD_DIR=engine\build"
if not defined HELIX_BUILD_JOBS set "HELIX_BUILD_JOBS=2"

cmake -S engine -B "%HELIX_BUILD_DIR%" -G Ninja -DCMAKE_BUILD_TYPE=Release -DHELIX_BUILD_TESTS=ON -DLLVM_DIR="%LLVM_DIR%" -DMLIR_DIR="%MLIR_DIR%" %*
if errorlevel 1 exit /b 1
cmake --build "%HELIX_BUILD_DIR%" --parallel %HELIX_BUILD_JOBS% --target helix_engine helix_tests
if errorlevel 1 exit /b 1
ctest --test-dir "%HELIX_BUILD_DIR%" --output-on-failure
if errorlevel 1 exit /b 1

if not exist engine\deps\llvm-mlir\engine mkdir engine\deps\llvm-mlir\engine
copy /Y "%HELIX_BUILD_DIR%\helix_engine.lib" engine\deps\llvm-mlir\engine\helix_engine.lib >nul
if errorlevel 1 exit /b 1
call npm run build
if errorlevel 1 exit /b 1
node tools\smoke_napi.cjs
if errorlevel 1 exit /b 1
endlocal
