@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" > nul 2>&1
set LLVM_LIB_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib
cd /d "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix"
npm run build
