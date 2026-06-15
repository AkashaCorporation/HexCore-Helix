@echo off
REM Helix v2 sandbox build - fresh configure against the shared external LLVM/MLIR.
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
set LLVM_BUILD=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir
cd /d C:\Users\Mazum\Desktop\HexCore-Helix-v2\engine

echo ======== Configuring Helix v2 engine ========
cmake -G Ninja -B build -S . ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DHELIX_USE_LLVM=ON ^
  -DHELIX_BUILD_TOOLS=ON ^
  -DHELIX_BUILD_TESTS=OFF ^
  -DLLVM_DIR=%LLVM_BUILD%\lib\cmake\llvm ^
  -DMLIR_DIR=%LLVM_BUILD%\lib\cmake\mlir ^
  -DCMAKE_INSTALL_PREFIX=C:\Users\Mazum\Desktop\HexCore-Helix-v2\helix-install
if %ERRORLEVEL% NEQ 0 ( echo CONFIGURE_FAILED & exit /b 1 )

echo ======== Building Helix v2 engine ========
ninja -C build -j%NUMBER_OF_PROCESSORS%
echo BUILD_EXIT_CODE=%ERRORLEVEL%
