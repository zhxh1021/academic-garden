param(
  [string]$GodotExe = "",
  [string]$ProjectDir = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
  $ProjectDir = Resolve-Path (Join-Path $PSScriptRoot "..")
} else {
  $ProjectDir = Resolve-Path $ProjectDir
}

function Resolve-GodotExe {
  param([string]$Requested)

  $candidates = @()
  if (-not [string]::IsNullOrWhiteSpace($Requested)) {
    $candidates += $Requested
  }
  if (-not [string]::IsNullOrWhiteSpace($env:GODOT_EXE)) {
    $candidates += $env:GODOT_EXE
  }
  foreach ($name in @("godot", "godot4", "godot4_console")) {
    $command = Get-Command $name -ErrorAction SilentlyContinue
    if ($command) {
      $candidates += $command.Source
    }
  }
  $candidates += @(
    "D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe",
    "D:\Program Files\Godot\Godot_v4.6.3-stable_win64.exe"
  )

  foreach ($candidate in $candidates) {
    if (-not [string]::IsNullOrWhiteSpace($candidate) -and (Test-Path $candidate)) {
      return (Resolve-Path $candidate).Path
    }
  }
  throw "Godot executable not found. Pass -GodotExe or set GODOT_EXE."
}

$godot = Resolve-GodotExe $GodotExe
$oldAppData = $env:APPDATA
try {
  $env:APPDATA = Join-Path (Resolve-Path (Join-Path $ProjectDir "..")) ".runtime\godot-economy-balance-check"
  $oldErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  try {
    $output = & $godot --headless --path $ProjectDir --scene "res://scenes/economy_balance_check.tscn" 2>&1
    $exitCode = $LASTEXITCODE
  } finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }

  $outputText = $output | Out-String
  $outputText | Write-Output
  if ($exitCode -ne 0) {
    throw "Economy balance check failed with exit code $exitCode."
  }
  if ($outputText -match "ASSERT FAIL") {
    throw "Economy balance check reported ASSERT FAIL."
  }
  if ($outputText -notmatch "ECONOMY_BALANCE_CHECK=PASS") {
    throw "Economy balance check did not report PASS."
  }
  Write-Output "Economy balance checks passed."
} finally {
  $env:APPDATA = $oldAppData
}
