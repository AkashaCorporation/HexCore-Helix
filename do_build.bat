@echo off
setlocal
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" > "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\build_out.txt" 2>&1
if errorlevel 1 (
    echo vcvars64 failed >> "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\build_out.txt"
    exit /b 1
)
cd /d "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix"
cmake --build engine\build --config Release >> "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\build_out.txt" 2>&1
exit /b %errorlevel%
