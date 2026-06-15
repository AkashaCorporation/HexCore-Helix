@echo off
setlocal

:: Set up Visual Studio environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

:: Set LLVM paths for Rust build
set LLVM_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\llvm
set MLIR_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\mlir
set LLVM_LIB_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib

:: Change to project directory
cd /d "%~dp0"

:: Run npm build
npm run build

endlocal
