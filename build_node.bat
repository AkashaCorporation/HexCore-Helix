@echo off
setlocal

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
if errorlevel 1 exit /b 1

set "LLVM_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\llvm"
set "MLIR_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\mlir"
set "LLVM_LIB_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib"
cd /d "%~dp0"

echo ==== 1/3 Build the current Helix engine ====
ninja -C engine\build helix_engine.lib
if errorlevel 1 exit /b 1

echo ==== 2/3 Stage the exact engine library used by Cargo ====
copy /Y engine\build\helix_engine.lib engine\deps\llvm-mlir\engine\helix_engine.lib >nul
if errorlevel 1 exit /b 1

echo ==== 3/3 Build the release N-API package ====
call npm run build
if errorlevel 1 exit /b 1

if not exist hexcore-helix.win32-x64-msvc.node exit /b 1
if not exist index.js exit /b 1
if not exist index.d.ts exit /b 1
echo Built hexcore-helix.win32-x64-msvc.node

endlocal
