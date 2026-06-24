param(
  [string]$GodotExe = "",
  [string]$ProjectDir = "",
  [string]$OutputRoot = "",
  [switch]$Headless
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
  $ProjectDir = Resolve-Path (Join-Path $PSScriptRoot "..")
} else {
  $ProjectDir = Resolve-Path $ProjectDir
}

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
  $OutputRoot = Join-Path $ProjectDir "screenshots\mobile-layout"
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

function Invoke-MobileCapture {
  param(
    [string]$Godot,
    [int]$Width,
    [int]$Height
  )

  $label = "$($Width)x$($Height)"
  $outDir = Join-Path $OutputRoot $label
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  Get-ChildItem -Path $outDir -Filter "*.png" -File -ErrorAction SilentlyContinue | Remove-Item -Force

  $oldAppData = $env:APPDATA
  $oldWidth = $env:AG_CAPTURE_WIDTH
  $oldHeight = $env:AG_CAPTURE_HEIGHT
  $oldLabel = $env:AG_CAPTURE_LABEL
  try {
    $env:APPDATA = Join-Path (Resolve-Path (Join-Path $ProjectDir "..")) ".runtime\godot-mobile-layout-$label"
    $env:AG_CAPTURE_WIDTH = [string]$Width
    $env:AG_CAPTURE_HEIGHT = [string]$Height
    $env:AG_CAPTURE_LABEL = $label

    $rawDir = Join-Path $outDir "frames"
    if (Test-Path $rawDir) {
      Remove-Item -LiteralPath $rawDir -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $rawDir | Out-Null

    $logPath = Join-Path $outDir "capture.log"
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
      $resolution = "$($Width)x$($Height)"
      $godotArgs = @("--path", $ProjectDir, "--resolution", $resolution, "--scene", "res://scenes/mobile_layout_capture.tscn")
      if ($Headless) {
        $godotArgs = @("--headless") + $godotArgs
      }
      $output = & $Godot @godotArgs 2>&1
      $exitCode = $LASTEXITCODE
    } finally {
      $ErrorActionPreference = $oldErrorActionPreference
    }
    $output | Set-Content -Encoding UTF8 -Path $logPath

    if ($exitCode -ne 0) {
      $output | Write-Output
      throw "Godot mobile layout capture failed for $label with exit code $exitCode. See $logPath"
    }
    if ($output -match "ASSERT FAIL") {
      $output | Write-Output
      throw "Godot mobile layout capture reported ASSERT FAIL for $label. See $logPath"
    }

    $expectedViews = @(
      "active-map",
      "harvested-map",
      "dormant-map",
      "detail-active",
      "record-drawer",
      "seed-shop",
      "decor-shop",
      "backup-panel",
      "onboarding",
      "remove-confirmation"
    )
    $hasNamedCaptures = $true
    foreach ($view in $expectedViews) {
      if (-not (Test-Path (Join-Path $outDir "$view.png"))) {
        $hasNamedCaptures = $false
        break
      }
    }

    if (-not $hasNamedCaptures) {
      $frames = Get-ChildItem -Path $rawDir -Filter "frame*.png" | Sort-Object Name
      if ($frames.Count -lt ($expectedViews.Count * 3)) {
        throw "Expected named captures or a PNG frame sequence for $label, found only $($frames.Count) frames in $rawDir"
      }

      for ($i = 0; $i -lt $expectedViews.Count; $i++) {
        $view = $expectedViews[$i]
        $frameIndex = [Math]::Min(($i * 6) + 4, $frames.Count - 1)
        Copy-Item -LiteralPath $frames[$frameIndex].FullName -Destination (Join-Path $outDir "$view.png") -Force
      }
    }

    foreach ($view in $expectedViews) {
      $pngPath = Join-Path $outDir "$view.png"
      if (-not (Test-Path $pngPath)) {
        throw "Expected capture missing: $pngPath"
      }
    }

    $validator = @"
from pathlib import Path
from PIL import Image
import sys

root = Path(r'''$outDir''')
expected_width = $Width
expected_height = $Height
failed = False
for path in sorted(root.glob('*.png')):
    image = Image.open(path).convert('RGBA')
    if image.size != (expected_width, expected_height):
        print(f'ASSERT FAIL: {path.name} size {image.size}, expected {(expected_width, expected_height)}')
        failed = True
        continue
    colors = set()
    opaque = 0
    for y in range(0, image.height, 16):
        for x in range(0, image.width, 16):
            pixel = image.getpixel((x, y))
            if pixel[3] > 12:
                opaque += 1
                colors.add(pixel)
    if opaque < 20 or len(colors) < 12:
        print(f'ASSERT FAIL: {path.name} looks blank or too flat: opaque={opaque} colors={len(colors)}')
        failed = True
    else:
        print(f'ASSERT PASS: {path.name} {image.width}x{image.height} colors={len(colors)}')
sys.exit(1 if failed else 0)
"@
    $validatorOutput = $validator | python -
    $validatorExit = $LASTEXITCODE
    $validatorOutput | Add-Content -Encoding UTF8 -Path $logPath
    if ($validatorExit -ne 0) {
      $validatorOutput | Write-Output
      throw "Mobile layout PNG validation failed for $label. See $logPath"
    }
    Write-Output "Mobile layout capture passed: $label -> $outDir"
  } finally {
    $env:APPDATA = $oldAppData
    $env:AG_CAPTURE_WIDTH = $oldWidth
    $env:AG_CAPTURE_HEIGHT = $oldHeight
    $env:AG_CAPTURE_LABEL = $oldLabel
  }
}

$godot = Resolve-GodotExe $GodotExe
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
New-Item -ItemType File -Force -Path (Join-Path (Split-Path $OutputRoot -Parent) ".gdignore") | Out-Null

Invoke-MobileCapture -Godot $godot -Width 390 -Height 844
Invoke-MobileCapture -Godot $godot -Width 430 -Height 932

Write-Output "All mobile layout captures passed."
