'use strict';
// FIX-096 deployed-.node load test.
// Requires the DEPLOYED index.js loader (old loader + new .node = proven combo),
// constructs HelixEngine(X86_64), decompiles an akasha .ll with the real
// function-starts table, and confirms a LOCATED cap with the phantom string gone.
const fs = require('fs');
const path = require('path');

const EXT = 'C:/Users/Mazum/Desktop/vscode-main/extensions/hexcore-helix';
const mod = require(path.join(EXT, 'index.js'));
const { HelixEngine, Architecture } = mod;

console.log('loaded keys:', Object.keys(mod).join(','));
console.log('Architecture.X86_64 =', Architecture.X86_64);

// Real akasha function entries (the authoritative function table).
const STARTS = [
  0x140001000, 0x140001090, 0x140001190, 0x140001350,
  0x140001410, 0x1400015c0, 0x140001740,
];

const CASES = [
  { tag: 'sub_140001190', ll: 'C:/Users/Mazum/Desktop/HTB Challenge/akasha_fresh_ll_table/0x140001190_sub_140001190.ll',
    expectCap: true, expectReason: "uninitialized return value 'result'" },
  { tag: 'sub_1400015C0', ll: 'C:/Users/Mazum/Desktop/HTB Challenge/akasha_fresh_ll_table/0x1400015C0_sub_1400015C0.ll',
    expectCap: true, expectReason: 'irreducible CFG; no return path recovered' },
  { tag: 'start',         ll: 'C:/Users/Mazum/Desktop/HTB Challenge/akasha_fresh_ll_table/0x140001740_start.ll',
    expectCap: true, expectReason: 'out-of-table call' },
  { tag: 'sub_140001000', ll: 'C:/Users/Mazum/Desktop/HTB Challenge/akasha_fresh_ll_table/0x140001000_sub_140001000.ll',
    expectCap: false, expectReason: null },
];

let pass = 0, fail = 0;
for (const c of CASES) {
  const ir = fs.readFileSync(c.ll, 'utf8');
  const engine = new HelixEngine(Architecture.X86_64);
  try { engine.setUseCastLayer(true); } catch (e) {}
  try { engine.setFunctionStarts(STARTS); } catch (e) { console.log('  setFunctionStarts threw:', e.message); }
  const res = engine.decompileIr(ir);
  try { engine.dispose && engine.dispose(); } catch {}

  const src = res.source || '';
  const hdr = src.split('\n').filter(l => l.includes('Confidence:') || l.includes('Issues:'));
  const phantom = src.includes('code-address leak or out-of-table call');
  const capLine = (src.match(/damning honesty defect \([^)]*\)/) || [])[0] || '';
  const isCapped = capLine.length > 0;
  const reasonOk = c.expectReason ? capLine.includes(c.expectReason) : true;

  console.log('\n==== ' + c.tag + ' ====');
  hdr.forEach(h => console.log('  ' + h.trim()));
  console.log('  phantom-string-present:', phantom, '(must be false)');
  console.log('  cap-line:', capLine || '(none)');

  let ok = true;
  if (phantom) { ok = false; console.log('  FAIL: phantom string present'); }
  if (c.expectCap && !isCapped) { ok = false; console.log('  FAIL: expected cap, none found'); }
  if (!c.expectCap && isCapped) { ok = false; console.log('  FAIL: unexpected cap'); }
  if (c.expectCap && !reasonOk) { ok = false; console.log('  FAIL: cap reason mismatch (want "' + c.expectReason + '")'); }
  if (ok) { pass++; console.log('  PASS'); } else { fail++; }
}

console.log('\n=== LOAD TEST: pass=' + pass + ' fail=' + fail + ' ===');
process.exit(fail === 0 ? 0 : 1);
