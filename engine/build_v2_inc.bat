@echo off
REM FIX-097 incremental build: recompile changed TUs + relink helix_tool.exe.
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul
cd /d C:\Users\Mazum\Desktop\HexCore-Helix-v2\engine
ninja -C build -j%NUMBER_OF_PROCESSORS%
set "BUILD_EXIT_CODE=%ERRORLEVEL%"
echo BUILD_EXIT_CODE=%BUILD_EXIT_CODE%
exit /b %BUILD_EXIT_CODE%
