@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set LLVM_BUILD=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir
set LLVM_SRC=C:\Users\Mazum\Desktop\caps\llvm-build\llvm-project-18.1.8.src

cd /d C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build

echo ========================================
echo Configuring Helix Engine against LLVM+MLIR
echo ========================================

cmake -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DHELIX_USE_LLVM=ON ^
  -DHELIX_BUILD_TOOLS=ON ^
  -DHELIX_BUILD_TESTS=OFF ^
  -DLLVM_DIR=%LLVM_BUILD%\lib\cmake\llvm ^
  -DMLIR_DIR=%LLVM_BUILD%\lib\cmake\mlir ^
  -DCMAKE_INSTALL_PREFIX=C:\Users\Mazum\Desktop\HexCore-Helix-Original\helix-install ^
  ..

if %ERRORLEVEL% NEQ 0 (
    echo ========================================
    echo CMake configure FAILED
    echo ========================================
    exit /b 1
)

echo ========================================
echo Building Helix Engine
echo ========================================

ninja -j%NUMBER_OF_PROCESSORS%

echo EXIT_CODE=%ERRORLEVEL%
