@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1
cd /d "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build"
"C:\Program Files\CMake\bin\cmake.exe" .. -G Ninja -DLLVM_DIR=C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib/cmake/llvm -DMLIR_DIR=C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib/cmake/mlir > C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build_output.txt 2>&1
"C:\Users\Mazum\AppData\Local\Programs\Python\Python311\Scripts\ninja.exe" >> C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build_output.txt 2>&1
echo EXIT_CODE=%ERRORLEVEL% >> C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build_output.txt
