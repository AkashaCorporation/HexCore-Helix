'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { spawnSync } = require('node:child_process');

const root = path.resolve(__dirname, '..');
const libraryName = process.platform === 'win32' ? 'helix_engine.lib' : 'libhelix_engine.a';
const candidates = ['engine/deps/llvm-mlir/engine', 'engine/build/Release', 'engine/build'];
const library = candidates.map(dir => path.join(root, dir, libraryName)).find(file => fs.existsSync(file));
if (!library) throw new Error('Build the current C++ engine first; no native static library was found.');
if (!process.env.npm_execpath) throw new Error('Run this entrypoint through npm run build or npm run build:debug.');

const hash = crypto.createHash('sha256');
const buffer = Buffer.allocUnsafe(1024 * 1024);
const fd = fs.openSync(library, 'r');
try { let read; while ((read = fs.readSync(fd, buffer, 0, buffer.length, null))) hash.update(buffer.subarray(0, read)); }
finally { fs.closeSync(fd); }
const digest = hash.digest('hex');
console.log(`Linking ${libraryName} SHA-256 ${digest}`);

const args = [process.env.npm_execpath, 'exec', '--no', '--', 'napi', 'build', '--platform'];
if (!process.argv.includes('--debug')) args.push('--release');
args.push('--manifest-path', 'crates/hexcore-helix/Cargo.toml', '--output-dir', '.');
const result = spawnSync(process.execPath, args, {
  cwd: root, stdio: 'inherit', windowsHide: true,
  env: { ...process.env, HELIX_ENGINE_LIB_HASH: digest, CARGO_BUILD_JOBS: process.env.CARGO_BUILD_JOBS || '2' },
});
if (result.error) throw result.error;
process.exitCode = result.status ?? 1;
