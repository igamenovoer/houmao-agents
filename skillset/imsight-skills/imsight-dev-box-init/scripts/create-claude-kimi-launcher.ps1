param(
    [string]$ApiKey = "",
    [string]$OutputPath = "",
    [string]$CmdShimPath = "",
    [string]$KeyFilePath = "",
    [string]$BaseUrl = "https://api.kimi.com/coding/",
    [string]$Model = "kimi-for-coding",
    [string]$ClaudeBin = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    $ApiKey = $env:KIMI_API_KEY
}
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    $ApiKey = $env:ANTHROPIC_API_KEY
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $env:LOCALAPPDATA "Programs\kimi-launchers\claude-kimi.ps1"
}
if ([string]::IsNullOrWhiteSpace($CmdShimPath)) {
    $CmdShimPath = Join-Path (Split-Path -Parent $OutputPath) "claude-kimi.cmd"
}
if ([string]::IsNullOrWhiteSpace($KeyFilePath)) {
    $KeyFilePath = Join-Path (Split-Path -Parent $OutputPath) "kimi-api-key"
}

function ConvertTo-SingleQuotedLiteralValue {
    param([string]$Value)
    return $Value.Replace("'", "''")
}

$keyFileLiteral = ConvertTo-SingleQuotedLiteralValue -Value $KeyFilePath
$baseUrlLiteral = ConvertTo-SingleQuotedLiteralValue -Value $BaseUrl
$modelLiteral = ConvertTo-SingleQuotedLiteralValue -Value $Model
$claudeBinLiteral = ConvertTo-SingleQuotedLiteralValue -Value $ClaudeBin

$launcher = @"
`$ErrorActionPreference = 'Stop'

`$keyFile = '$keyFileLiteral'
if (-not (Test-Path -LiteralPath `$keyFile)) {
    `$secureKey = Read-Host -Prompt 'Kimi API key' -AsSecureString
    `$keyPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR(`$secureKey)
    try {
        `$apiKey = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(`$keyPtr)
    } finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR(`$keyPtr)
    }
    if ([string]::IsNullOrWhiteSpace(`$apiKey)) {
        Write-Error 'claude-kimi: empty Kimi API key'
        exit 2
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent `$keyFile) | Out-Null
    Set-Content -LiteralPath `$keyFile -Value `$apiKey -Encoding UTF8
} else {
    `$apiKey = (Get-Content -LiteralPath `$keyFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace(`$apiKey)) {
        Write-Error "claude-kimi: empty Kimi API key in `$keyFile"
        exit 2
    }
}

`$env:ANTHROPIC_API_KEY = `$apiKey
`$env:ANTHROPIC_BASE_URL = '$baseUrlLiteral'
Remove-Item Env:ANTHROPIC_AUTH_TOKEN -ErrorAction SilentlyContinue
Remove-Item Env:CLAUDE_CODE_OAUTH_TOKEN -ErrorAction SilentlyContinue
if ([string]::IsNullOrWhiteSpace(`$env:CLAUDE_CODE_AUTO_COMPACT_WINDOW)) {
    `$env:CLAUDE_CODE_AUTO_COMPACT_WINDOW = '262144'
}

`$node = Get-Command node -ErrorAction SilentlyContinue
if (`$node) {
    & `$node.Source --eval @'
const fs = require('fs');
const os = require('os');
const path = require('path');
const filePath = path.join(os.homedir(), '.claude.json');
const content = fs.existsSync(filePath)
  ? JSON.parse(fs.readFileSync(filePath, 'utf-8'))
  : {};
fs.writeFileSync(
  filePath,
  JSON.stringify({ ...content, hasCompletedOnboarding: true }, null, 2),
  'utf-8'
);
'@
}

`$kimiModel = if ([string]::IsNullOrWhiteSpace(`$env:CLAUDE_KIMI_MODEL)) { '$modelLiteral' } else { `$env:CLAUDE_KIMI_MODEL }
`$claudeBin = '$claudeBinLiteral'
if ([string]::IsNullOrWhiteSpace(`$claudeBin)) {
    `$claude = Get-Command claude -ErrorAction SilentlyContinue
    if (`$claude) {
        `$claudeBin = `$claude.Source
    }
}
if ([string]::IsNullOrWhiteSpace(`$claudeBin)) {
    Write-Error 'claude-kimi: claude binary not found'
    exit 127
}

`$addModel = `$true
foreach (`$arg in `$args) {
    # Runtime args belong to Claude Code. The launcher only observes them to avoid
    # injecting duplicate defaults; it must not consume or reinterpret Claude flags.
    if (`$arg -eq '--model' -or `$arg.StartsWith('--model=') -or `$arg -eq '--help' -or `$arg -eq '-h' -or `$arg -eq '--version' -or `$arg -eq '-v') {
        `$addModel = `$false
    }
}

if (`$addModel) {
    & `$claudeBin --dangerously-skip-permissions --model `$kimiModel @args
} else {
    & `$claudeBin --dangerously-skip-permissions @args
}
exit `$LASTEXITCODE
"@

$outputDir = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
Set-Content -LiteralPath $OutputPath -Value $launcher -Encoding UTF8

if (-not [string]::IsNullOrWhiteSpace($ApiKey)) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $KeyFilePath) | Out-Null
    Set-Content -LiteralPath $KeyFilePath -Value $ApiKey -Encoding UTF8
}

$cmdDir = Split-Path -Parent $CmdShimPath
New-Item -ItemType Directory -Force -Path $cmdDir | Out-Null
$ps1ForCmd = $OutputPath.Replace("%", "%%")
$shim = @"
@echo off
where pwsh.exe >nul 2>nul
if %ERRORLEVEL% equ 0 (
  pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "$ps1ForCmd" %*
) else (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$ps1ForCmd" %*
)
"@
Set-Content -LiteralPath $CmdShimPath -Value $shim -Encoding ASCII

Write-Host "created $OutputPath"
Write-Host "created $CmdShimPath"
Write-Host "key file: $KeyFilePath"
