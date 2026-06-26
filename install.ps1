# swarmcode installer for Windows — downloads the prebuilt binary.
#   irm https://raw.githubusercontent.com/SwarmPathAI/swarmcode/main/install.ps1 | iex
#
# Requires Windows 10+ (bundled `tar`) and PowerShell 5.1+.
$ErrorActionPreference = "Stop"

$repo = if ($env:SWARMCODE_REPO) { $env:SWARMCODE_REPO } else { "SwarmPathAI/swarmcode" }
# ~/.local/bin — same location the unix install.sh uses, so the install path
# is identical across macOS / Linux / Windows.
$installDir = if ($env:SWARMCODE_INSTALL_DIR) { $env:SWARMCODE_INSTALL_DIR } else { Join-Path $HOME ".local\bin" }

# Windows PowerShell 5.1 defaults to SystemDefault, which on older .NET may not
# negotiate TLS 1.2 — GitHub requires it. Force TLS 1.2 so the download works.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$label = "windows-x64"
$url = "https://github.com/$repo/releases/latest/download/swarmcode-$label.tar.gz"
Write-Host "Downloading $url ..."

$tmp = Join-Path $env:TEMP ("swarmcode-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
    $tarball = Join-Path $tmp "swarmcode.tar.gz"
    Invoke-WebRequest -Uri $url -OutFile $tarball -UseBasicParsing
    # Windows 10+ ships bsdtar as `tar`; it reads .tar.gz natively.
    tar -xzf $tarball -C $tmp
    if ($LASTEXITCODE -ne 0) { throw "tar extraction failed" }

    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
    $dest = Join-Path $installDir "swarmcode.exe"
    try {
        Copy-Item -Force (Join-Path $tmp "swarmcode.exe") $dest
    }
    catch {
        # The most common failure on Windows: the target swarmcode.exe is still
        # running and holding a file lock, so the copy is denied. Give a clear,
        # actionable message instead of a cryptic access error.
        throw "Could not write $dest. If swarmcode is currently running, close it (all terminals/tabs) and re-run the installer. Original error: $($_.Exception.Message)"
    }
}
finally {
    # Best-effort cleanup. Never let a cleanup failure mask the real error from
    # the try block (PS 5.1 can throw a non-suppressible error here on paths
    # with spaces), so swallow anything this throws.
    try { Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue } catch { }
}

$exe = Join-Path $installDir "swarmcode.exe"
Write-Host "Installed: $exe"
& $exe --version

# Add the install dir to the USER PATH (persisted) if it isn't already there.
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($userPath -split ';') -notcontains $installDir) {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
    Write-Host "Added $installDir to your user PATH. Open a NEW terminal for it to take effect."
}

Write-Host "Get started:  swarmcode model   (configure a channel)   then:  swarmcode"

# swarmcode's full-screen UI targets a modern VT terminal. The legacy
# PowerShell 5.1 / conhost console lacks VT processing, glyph coverage, and
# alt-screen mouse scroll — colors, borders and the selection pointer render
# wrong there. Windows Terminal (preinstalled on Win11, free on Win10) fixes
# all of it. Nudge the user if they're on the legacy console.
if (-not $env:WT_SESSION) {
    Write-Host ""
    Write-Host "Tip: for the best experience, run swarmcode in Windows Terminal" -ForegroundColor Yellow
    Write-Host "     (Start menu -> 'Terminal', or run 'wt'). The legacy console" -ForegroundColor Yellow
    Write-Host "     renders colors, borders and the cursor incorrectly." -ForegroundColor Yellow
}
