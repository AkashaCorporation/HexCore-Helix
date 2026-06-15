$vcvars = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
$envOutput = cmd /c "`"$vcvars`" && set" 2>&1
foreach ($line in $envOutput) {
    if ($line -match '^([^=]+)=(.*)$') {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
}
$engineBuild = "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build"
$result = cmake --build "$engineBuild" --config Release 2>&1
$result | Where-Object { $_ -match "Building CXX|Linking|error C|ninja:" } | Select-Object -Last 15
exit $LASTEXITCODE
