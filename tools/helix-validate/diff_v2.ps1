# Helix v2 differential harness v2 (the confidence-aware scoreboard).
#
# Lesson from the Mali kbase run: a raw vN-count delta is AMBIGUOUS - more vN
# can mean "recovered more real code" (good, e.g. kbase_mem_free went stub -> a
# 52%-Medium body) OR "more garbage placeholders" (bad). So this version parses
# confidence %, confidence label (Low/Medium/High), the "stub function" flag,
# and the unreachable-statement count, and emits a per-function VERDICT instead
# of trusting vN alone.
#
# Verdicts: RESCUED (stub -> body) | IMPROVED | REGRESSED | STUBBED (body ->
# stub) | CHANGED? (output moved but confidence flat - needs human/agent look)
# | = (identical).
#
# Usage: pwsh tools\helix-validate\diff_v2.ps1 [-LlDir <dir>] [-Csv <out.csv>]
param(
  [string]$Baseline   = "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build\helix_tool.exe",
  [string]$Experiment = "C:\Users\Mazum\Desktop\HexCore-Helix-v2\engine\build\helix_tool.exe",
  [string]$LlDir      = "C:\Users\Mazum\Desktop\HexCore-Helix-v2\engine\test\fixtures",
  [string]$Csv        = ""
)

$inv   = [Globalization.CultureInfo]::InvariantCulture
$noise = '^\[(P0-TRACE|P0-DEBUG|LIFT-STATS|CAST|v2|\[Helix\]|Helix)'
function Emit($exe, $ll) { (& $exe --use-cast-layer $ll 2>&1 | Where-Object { $_ -notmatch $noise }) -join "`n" }
function CountVN($t)     { ([regex]::Matches($t, '\bv\d+\b')).Count }
function ConfPct($t)     { if ($t -match 'Confidence:\s*([\d.]+)%') { [double]::Parse($Matches[1], $inv) } else { [double]::NaN } }
function ConfRank($t)    { if ($t -match 'Confidence:[^(]*\((\w+)\)') { switch ($Matches[1]) { 'Low'{1} 'Medium'{2} 'High'{3} default{0} } } else { 0 } }
function IsStub($t)      { $t -match 'stub function' }
function Unreach($t)     { if ($t -match '(\d+)\s+unreachable statement') { [int]$Matches[1] } else { 0 } }

$files = Get-ChildItem "$LlDir\*.ll" -ErrorAction SilentlyContinue | Sort-Object Name
if (-not $files) { Write-Host "No .ll files in $LlDir"; exit 1 }

$rows = @()
$tally = @{ RESCUED=0; IMPROVED=0; REGRESSED=0; STUBBED=0; 'CHANGED?'=0; '='=0 }
$netConf = 0.0

foreach ($f in $files) {
  $b = Emit $Baseline   $f.FullName
  $e = Emit $Experiment $f.FullName
  $cb = ConfPct $b; $ce = ConfPct $e
  $rb = ConfRank $b; $re = ConfRank $e
  $sb = IsStub $b;  $se = IsStub $e
  $cd = if (-not [double]::IsNaN($cb) -and -not [double]::IsNaN($ce)) { [math]::Round($ce - $cb, 1) } else { 0 }

  $verdict =
    if ($b -eq $e)                 { '=' }
    elseif ($sb -and -not $se)     { 'RESCUED' }
    elseif ($se -and -not $sb)     { 'STUBBED' }
    elseif ($re -gt $rb -or $cd -ge 2)  { 'IMPROVED' }
    elseif ($re -lt $rb -or $cd -le -2) { 'REGRESSED' }
    else                           { 'CHANGED?' }

  $tally[$verdict]++
  if (-not [double]::IsNaN($cd)) { $netConf += $cd }

  $rows += [PSCustomObject]@{
    File = $f.Name; Verdict = $verdict
    conf = ("{0}->{1}" -f $cb, $ce); dConf = $cd
    label = ("{0}->{1}" -f $rb, $re)
    stub = ("{0}->{1}" -f [int]$sb, [int]$se)
    vN_d = (CountVN $e) - (CountVN $b); unreach_d = (Unreach $e) - (Unreach $b)
  }
}

$rows | Format-Table -AutoSize
if ($Csv) { $rows | Export-Csv -Path $Csv -NoTypeInformation; Write-Host "csv -> $Csv" }
Write-Host ""
Write-Host ("VERDICTS  RESCUED={0}  IMPROVED={1}  REGRESSED={2}  STUBBED={3}  CHANGED?={4}  ={5}" -f `
  $tally.RESCUED, $tally.IMPROVED, $tally.REGRESSED, $tally.STUBBED, $tally.'CHANGED?', $tally.'=')
Write-Host ("net confidence delta: {0:+0.0;-0.0;0} pp across {1} files" -f $netConf, $files.Count)
Write-Host "(RESCUED/IMPROVED = guard helps; REGRESSED/STUBBED = guard hurts; CHANGED? = inspect)"
