@echo off
setlocal
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul
set LLVM_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\llvm
set MLIR_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\mlir
set LLVM_LIB_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib
cd /d C:\Users\Mazum\Desktop\HexCore-Helix-v2

echo ==== 1/3 ensure engine lib is current (FIX-097) ====
ninja -C engine\build helix_engine.lib
if %ERRORLEVEL% NEQ 0 ( echo NINJA_FAILED & exit /b 1 )

echo ==== 2/3 LNK2019 fix: copy fresh engine lib over the stale deps copy ====
copy /Y engine\build\helix_engine.lib engine\deps\llvm-mlir\engine\helix_engine.lib
if %ERRORLEVEL% NEQ 0 ( echo ENGINE_LIB_COPY_FAILED & exit /b 1 )

for /f %%H in ('powershell.exe -NoProfile -Command "(Get-FileHash -Algorithm SHA256 'engine\deps\llvm-mlir\engine\helix_engine.lib').Hash"') do set HELIX_ENGINE_LIB_HASH=%%H
if not defined HELIX_ENGINE_LIB_HASH ( echo ENGINE_LIB_HASH_FAILED & exit /b 1 )
echo ENGINE_LIB_SHA256=%HELIX_ENGINE_LIB_HASH%

echo ==== 3/3 cargo build the cdylib (.node) ====
"C:\Users\Mazum\.cargo\bin\cargo.exe" build --release -p hexcore-helix
echo CARGO_BUILD_EXIT=%ERRORLEVEL%
if %ERRORLEVEL% NEQ 0 ( echo CARGO_BUILD_FAILED & exit /b 1 )
dir /b target\release\hexcore_helix.dll
if %ERRORLEVEL% NEQ 0 ( echo NODE_ARTIFACT_MISSING & exit /b 1 )
endlocal
