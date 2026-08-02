const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const pkg = require(path.join(root, 'package.json'));
const { Architecture, HelixEngine } = require(path.join(root, 'index.js'));
const ir = fs.readFileSync(
  path.join(root, 'engine', 'test', 'fixtures', 'simple_add.ll'),
  'utf8',
);

function run() {
  const engine = new HelixEngine(Architecture.X86_64);
  engine.setUseCastLayer(true);
  const version = engine.version();
  const result = engine.decompileIr(ir);
  engine.dispose();
  return { result, version };
}

const first = run();
const second = run();
const expectedVersion = `helix-js=${pkg.version} native=${pkg.version}`;
const firstAst = first.result.astBuffer || Buffer.alloc(0);
const secondAst = second.result.astBuffer || Buffer.alloc(0);
const sha256 = (value) =>
  crypto.createHash('sha256').update(value).digest('hex');

const evidence = {
  version: first.version,
  pipeline: first.result.pipeline,
  sourceBytes: Buffer.byteLength(first.result.source),
  sourceSha256: sha256(first.result.source),
  astBytes: firstAst.length,
  astSha256: sha256(firstAst),
  deterministicSource: first.result.source === second.result.source,
  deterministicAst: firstAst.equals(secondAst),
};

console.log(JSON.stringify(evidence, null, 2));

if (first.version !== expectedVersion) {
  throw new Error(`Version mismatch: expected ${expectedVersion}`);
}
if (first.result.pipeline !== 'mlir') {
  throw new Error(`Unexpected pipeline: ${first.result.pipeline}`);
}
if (!first.result.source || !firstAst.length) {
  throw new Error('The package returned empty pseudo-C or HAST output');
}
if (!evidence.deterministicSource || !evidence.deterministicAst) {
  throw new Error('The package smoke fixture is not deterministic');
}
