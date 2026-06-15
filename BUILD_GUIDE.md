# HexCore-Helix Build Guide

Este guia documenta como compilar o HexCore-Helix do zero.

## Pré-requisitos

- **Visual Studio 2022** com C++ Desktop Development
- **LLVM/MLIR** compilado (localizado em `C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir`)
- **Node.js** (v18+)
- **Rust** (stable)
- **Ninja** (build system)
- **CMake** (3.20+)

## Estrutura do Projeto

```
HexCore-Helix/
├── engine/          # C++ engine (MLIR passes)
│   ├── src/         # Source code
│   └── build/       # Build output
├── crates/          # Rust crates
│   ├── helix-core/  # Core bindings
│   └── hexcore-helix/ # NAPI module
└── BUILD_GUIDE.md   # Este arquivo
```

## Passo 1: Compilar o Engine C++

### Opção A: Usando o VS Developer PowerShell

```powershell
# Abrir VS Developer PowerShell ou configurar ambiente:
Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath "C:\Program Files\Microsoft Visual Studio\2022\Community"

# Navegar para o diretório do engine
cd C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build

# Compilar
cmake --build . --config Release
```

### Opção B: Usando o script batch

```cmd
C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\rebuild_engine.bat
```

### Opção C: Reconfigurar do zero (se necessário)

Se o CMake cache estiver corrompido:

```powershell
# Limpar cache
cd C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build
Remove-Item CMakeCache.txt -ErrorAction SilentlyContinue
Remove-Item -Recurse CMakeFiles -ErrorAction SilentlyContinue

# Reconfigurar
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=23 `
  -DLLVM_DIR='C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib/cmake/llvm' `
  -DMLIR_DIR='C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib/cmake/mlir'

# Compilar
cmake --build . --config Release
```

## Passo 2: Compilar o Módulo NAPI (Rust)

O módulo NAPI precisa saber onde estão as libs do LLVM.

### Usando Git Bash ou terminal Unix-like

```bash
cd /c/Users/Mazum/Desktop/HexCore-Helix-Original/HexCore-Helix

# Definir LLVM_LIB_DIR e compilar
LLVM_LIB_DIR="C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib" npm run build
```

### Usando CMD

```cmd
set LLVM_LIB_DIR=C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib
cd C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix
npm run build
```

### Usando PowerShell

```powershell
$env:LLVM_LIB_DIR = "C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib"
cd C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix
npm run build
```

O arquivo `.node` será gerado em:
```
crates/hexcore-helix/hexcore-helix.win32-x64-msvc.node
```

## Passo 3: Copiar para a Extensão VSCode

**IMPORTANTE:** Feche o VSCode antes de copiar!

```bash
cp crates/hexcore-helix/hexcore-helix.win32-x64-msvc.node \
   "C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix/"
```

Ou via PowerShell:

```powershell
Copy-Item ".\crates\hexcore-helix\hexcore-helix.win32-x64-msvc.node" `
  -Destination "C:\Users\Mazum\Desktop\vscode-main\extensions\hexcore-helix\" -Force
```

## Build Completo (Script Único)

Para conveniência, você pode usar este script no Git Bash:

```bash
#!/bin/bash
# build_all.sh

set -e

PROJECT_DIR="C:/Users/Mazum/Desktop/HexCore-Helix-Original/HexCore-Helix"
LLVM_LIB="C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib"
VSCODE_EXT="C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix"

echo "=== Building C++ Engine ==="
cd "$PROJECT_DIR"
./rebuild_engine.bat

echo "=== Building NAPI Module ==="
LLVM_LIB_DIR="$LLVM_LIB" npm run build

echo "=== Copying to VSCode Extension ==="
cp crates/hexcore-helix/hexcore-helix.win32-x64-msvc.node "$VSCODE_EXT/"

echo "=== Build Complete ==="
```

## Troubleshooting

### Erro: "stddef.h not found"
O ambiente MSVC não está configurado. Use o VS Developer PowerShell ou execute `vcvars64.bat` primeiro.

### Erro: "Could not determine LLVM/MLIR lib directory"
Defina a variável de ambiente `LLVM_LIB_DIR`:
```bash
export LLVM_LIB_DIR="C:/Users/Mazum/Desktop/caps/llvm-build/build-mlir/lib"
```

### Erro: "x86/x64 mismatch" no linking
O CMake cache está corrompido. Delete `CMakeCache.txt` e `CMakeFiles/`, depois reconfigure.

### Erro: "Device or resource busy" ao copiar .node
O VSCode está usando o arquivo. Feche o VSCode completamente antes de copiar.

### Erro: "Use leaves the current parent region" (MLIR assertion)
Este erro foi corrigido no `StructureControlFlow.cpp` com value promotion. Se aparecer novamente, verifique se o engine foi recompilado.

## Variáveis de Ambiente Importantes

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `LLVM_LIB_DIR` | `C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib` | Diretório das libs LLVM/MLIR |
| `LLVM_DIR` | `C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\llvm` | CMake config do LLVM |
| `MLIR_DIR` | `C:\Users\Mazum\Desktop\caps\llvm-build\build-mlir\lib\cmake\mlir` | CMake config do MLIR |

---

*Última atualização: 2026-03-21*
