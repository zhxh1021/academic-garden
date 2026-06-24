param(
  [switch]$KeepData,
  [switch]$SkipExport,
  [switch]$NoScreenshot,
  [string]$GodotExe = "",
  [string]$JavaHome = ""
)

$ErrorActionPreference = "Stop"

$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$RepoRoot = (Resolve-Path (Join-Path $ProjectRoot "..")).Path
$SdkRoot = "D:\ag_runtime\android-sdk"
$PreferredAvdHome = Join-Path $RepoRoot ".runtime\android-avd"
$ProjectAvdHome = Join-Path $ProjectRoot "android-avd"
$AvdHome = $PreferredAvdHome
if (-not (Test-Path $AvdHome) -and (Test-Path $ProjectAvdHome)) {
  $AvdHome = $ProjectAvdHome
}
$AvdName = "academic_garden_api35"
$PackageName = "org.academicgarden.prototype"
$ExportsDir = Join-Path $ProjectRoot "exports"
$UnsignedApk = Join-Path $ExportsDir "academic-garden-prototype-preview-unsigned.apk"
$FinalApk = Join-Path $ExportsDir "academic-garden-prototype-debug.apk"
$ExistingApk = $FinalApk
$Adb = Join-Path $SdkRoot "platform-tools\adb.exe"
$Emulator = Join-Path $SdkRoot "emulator\emulator.exe"
$ApkSigner = Join-Path $SdkRoot "build-tools\36.0.0\apksigner.bat"
$DebugKeystore = "D:\ag_runtime\academic-garden-debug.keystore"

function Require-File($Path, $Label) {
  if (-not (Test-Path $Path)) {
    throw "$Label not found: $Path"
  }
}

function Find-Godot {
  param([string]$Provided)
  if ($Provided -and (Test-Path $Provided)) {
    return (Resolve-Path $Provided).Path
  }
  if ($env:GODOT_EXE -and (Test-Path $env:GODOT_EXE)) {
    return (Resolve-Path $env:GODOT_EXE).Path
  }
  if ($env:GODOT_PATH -and (Test-Path $env:GODOT_PATH)) {
    return (Resolve-Path $env:GODOT_PATH).Path
  }

  $fromPath = (Get-Command godot -ErrorAction SilentlyContinue)
  if ($fromPath) {
    return $fromPath.Source
  }

  $candidateRoots = @(
    "D:\ag_runtime",
    "D:\Godot",
    "C:\Godot",
    "$env:LOCALAPPDATA\Programs",
    "$env:USERPROFILE\Downloads"
  )
  foreach ($root in $candidateRoots) {
    if (-not (Test-Path $root)) {
      continue
    }
    $match = Get-ChildItem -Path $root -Recurse -File -ErrorAction SilentlyContinue |
      Where-Object { $_.Name -match "^Godot.*\.exe$|^godot.*\.exe$" } |
      Select-Object -First 1
    if ($match) {
      return $match.FullName
    }
  }
  return ""
}

function Find-JavaHome {
  param([string]$Provided)

  $candidates = @()
  if ($Provided) {
    $candidates += $Provided
  }
  if ($env:JAVA_HOME) {
    $candidates += $env:JAVA_HOME
  }

  $runtimeJdkRoot = "D:\ag_runtime\jdk"
  if (Test-Path $runtimeJdkRoot) {
    $candidates += Get-ChildItem -Path $runtimeJdkRoot -Directory -ErrorAction SilentlyContinue |
      Sort-Object Name -Descending |
      ForEach-Object { $_.FullName }
  }

  foreach ($candidate in $candidates) {
    if (-not $candidate) {
      continue
    }
    $javaExe = Join-Path $candidate "bin\java.exe"
    if (Test-Path $javaExe) {
      return (Resolve-Path $candidate).Path
    }
  }

  $fromPath = Get-Command java -ErrorAction SilentlyContinue
  if ($fromPath -and (Test-Path $fromPath.Source)) {
    $binDir = Split-Path $fromPath.Source -Parent
    return (Resolve-Path (Join-Path $binDir "..")).Path
  }

  return ""
}

function Configure-JavaForAndroidTools {
  param([string]$Provided)

  $resolvedJavaHome = Find-JavaHome $Provided
  if (-not $resolvedJavaHome) {
    throw "Java was not found. Pass -JavaHome <jdk path> or set JAVA_HOME so apksigner can sign the APK."
  }

  $javaBin = Join-Path $resolvedJavaHome "bin"
  $env:JAVA_HOME = $resolvedJavaHome
  if (($env:Path -split ";") -notcontains $javaBin) {
    $env:Path = "$javaBin;$env:Path"
  }
  Write-Host "Using Java: $resolvedJavaHome"
}

function Run-Step {
  param(
    [string]$Title,
    [scriptblock]$Block
  )
  Write-Host ""
  Write-Host "== $Title =="
  & $Block
}

function Wait-For-Boot {
  Write-Host "Waiting for emulator device..."
  & $Adb wait-for-device | Out-Null
  for ($i = 0; $i -lt 90; $i++) {
    $booted = (& $Adb shell getprop sys.boot_completed 2>$null).Trim()
    if ($booted -eq "1") {
      Write-Host "Emulator booted."
      return
    }
    Start-Sleep -Seconds 2
  }
  throw "Timed out waiting for emulator boot."
}

Require-File $Adb "adb"
Require-File $Emulator "Android emulator"
Require-File $ApkSigner "apksigner"
Require-File $DebugKeystore "debug keystore"
if (-not (Test-Path $ExportsDir)) {
  New-Item -ItemType Directory -Path $ExportsDir | Out-Null
}

Run-Step "Start Android emulator" {
  $env:ANDROID_AVD_HOME = $AvdHome
  & $Adb start-server | Out-Null
  $devices = (& $Adb devices) -join "`n"
  if ($devices -notmatch "emulator-\d+\s+device") {
    Write-Host "Launching AVD $AvdName from $AvdHome"
    Start-Process -FilePath $Emulator -ArgumentList @("-avd", $AvdName, "-gpu", "host", "-no-snapshot-load") -WindowStyle Hidden
    Wait-For-Boot
  } else {
    Write-Host "An emulator is already connected."
  }
}

if (-not $SkipExport) {
  Configure-JavaForAndroidTools $JavaHome
  $ResolvedGodot = Find-Godot $GodotExe
  if ($ResolvedGodot) {
    Run-Step "Export debug APK" {
      Write-Host "Using Godot: $ResolvedGodot"
      Push-Location $ProjectRoot
      try {
        & $ResolvedGodot --headless --path $ProjectRoot --import
        if ($LASTEXITCODE -ne 0) {
          throw "Godot import failed with exit code $LASTEXITCODE"
        }
        & $ResolvedGodot --headless --path $ProjectRoot --export-debug "Android Debug" $UnsignedApk
        if ($LASTEXITCODE -ne 0) {
          throw "Godot Android export failed with exit code $LASTEXITCODE"
        }
      } finally {
        Pop-Location
      }
      & $ApkSigner sign --ks $DebugKeystore --ks-key-alias androiddebugkey --ks-pass pass:android --key-pass pass:android --out $FinalApk $UnsignedApk
      if ($LASTEXITCODE -ne 0) {
        throw "APK signing failed with exit code $LASTEXITCODE"
      }
      & $ApkSigner verify --verbose $FinalApk
      if ($LASTEXITCODE -ne 0) {
        throw "APK verification failed with exit code $LASTEXITCODE"
      }
    }
  } else {
    throw "Godot executable was not found. Pass -GodotExe <path> or set GODOT_EXE/GODOT_PATH so the preview can export a fresh APK."
  }
}

Require-File $FinalApk "APK"

Run-Step "Install and launch APK" {
  & $Adb logcat -c | Out-Null
  if (-not $KeepData) {
    Write-Host "Clearing emulator app data so preview uses the current bundled seed/layout."
    & $Adb shell pm clear $PackageName | Out-Null
  }
  & $Adb install -r $FinalApk
  if ($LASTEXITCODE -ne 0) {
    throw "adb install failed with exit code $LASTEXITCODE"
  }
  & $Adb shell monkey -p $PackageName -c android.intent.category.LAUNCHER 1 | Out-Null
  Start-Sleep -Seconds 6
}

if (-not $NoScreenshot) {
  Run-Step "Capture screenshot and logcat" {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $deviceShot = "/sdcard/academic-garden-preview.png"
    $screenPath = Join-Path $ExportsDir "android-qa-preview-$stamp.png"
    $latestScreenPath = Join-Path $ExportsDir "android-qa-preview-latest.png"
    $logPath = Join-Path $ExportsDir "android-qa-preview-$stamp-logcat.txt"
    $latestLogPath = Join-Path $ExportsDir "android-qa-preview-latest-logcat.txt"

    & $Adb shell screencap -p $deviceShot | Out-Null
    & $Adb pull $deviceShot $screenPath | Out-Null
    Copy-Item $screenPath $latestScreenPath -Force
    & $Adb logcat -d | Set-Content -Path $logPath -Encoding UTF8
    Copy-Item $logPath $latestLogPath -Force

    Write-Host "Screenshot: $screenPath"
    Write-Host "Latest screenshot: $latestScreenPath"
    Write-Host "Logcat: $logPath"
  }
}

Write-Host ""
Write-Host "Android preview is ready."
