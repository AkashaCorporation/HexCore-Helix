@echo off
setlocal

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
if errorlevel 1 exit /b %errorlevel%

set "ENGINE_DIR=%~dp0."
set "LLVM_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\llvm"
set "MLIR_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\mlir"

cmake -S "%ENGINE_DIR%" -B "%ENGINE_DIR%\build-tests" -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_DIR="%LLVM_DIR%" -DMLIR_DIR="%MLIR_DIR%" -DHELIX_BUILD_TESTS=ON
if errorlevel 1 exit /b %errorlevel%

ninja -C "%ENGINE_DIR%\build-tests" helix_tests
exit /b %errorlevel%
