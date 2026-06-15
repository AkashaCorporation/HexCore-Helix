# Helix v2 differential harness (the scoreboard).
# Runs the v0.9.2 baseline exe and the v2 experiment exe over a directory of
# .ll files, strips trace noise, and reports per-function: identical vs changed,
# the vN-placeholder count delta (the FIX-081 option-1 regression metric), and
# the confidence delta. A negative vN delta = fewer placeholders = better; a
# positive delta = the "extra vN placeholders" risk the changelog warns about.
#
# Usage: pwsh tools\helix-validate\diff_v2.ps1 [-LlDir <dir>]
param(
  [string]$Baseline   = "C:\Users\Mazum\Desktop\HexCore-Helix-Original\HexCore-Helix\engine\build\helix_tool.exe",
  [string]$Experiment = "C:\Users\Mazum\Desktop\HexCore-Helix-v2\engine\build\helix_tool.exe",
  [string]$LlDir      = "C:\Users\Mazum\Desktop\HexCore-Helix-v2\engine\test\fixtures"
)

$noise = '^\[(P0-TRACE|P0-DEBUG|LIFT-STATS|CAST|v2-exp)'
function Emit($exe, $ll) { (& $exe --use-cast-layer $ll 2>&1 | Where-Object { $_ -notmatch $noise }) -join "`n" }
function CountVN($text)  { ([regex]::Matches($text, '\bv\d+\b')).Count }
function Conf($text)     { if ($text -match 'Confidence:\s*([\d.]+)%') { [double]$Matches[1] } else { $null } }

$files = Get-ChildItem "$LlDir\*.ll" -ErrorAction SilentlyContinue | Sort-Object Name
if (-not $files) { Write-Host "No .ll files in $LlDir"; exit 1 }

$nIdentical = 0; $nChanged = 0; $totVnDelta = 0; $rows = @()
foreach ($f in $files) {
  $b = Emit $Baseline   $f.FullName
  $e = Emit $Experiment $f.FullName
  $same = ($b -eq $e)
  $bvn = CountVN $b; $evn = CountVN $e
  $rows += [PSCustomObject]@{
    File = $f.Name
    Status = if ($same) { "=" } else { "CHANGED" }
    vN_base = $bvn; vN_v2 = $evn; vN_delta = ($evn - $bvn)
    conf_base = (Conf $b); conf_v2 = (Conf $e)
  }
  if ($same) { $nIdentical++ } else { $nChanged++ }
  $totVnDelta += ($evn - $bvn)
}

$rows | Format-Table -AutoSize
Write-Host ""
Write-Host "SCOREBOARD: $($files.Count) files | $nIdentical identical | $nChanged changed | total vN delta: $totVnDelta"
Write-Host "(vN delta < 0 = fewer placeholders = better; > 0 = the option-1 regression risk materialising)"
