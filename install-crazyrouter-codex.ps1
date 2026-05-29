# One-click switch OpenAI Codex CLI to Crazyrouter on Windows
# Usage:
#   iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host "Crazyrouter Codex CLI installer" -ForegroundColor Cyan
Write-Host "This will configure Codex CLI to use https://cn.crazyrouter.com/v1" -ForegroundColor Gray
Write-Host ""

$codexDir = Join-Path $env:USERPROFILE ".codex"
$configPath = Join-Path $codexDir "config.toml"

if (!(Test-Path $codexDir)) {
  New-Item -ItemType Directory -Path $codexDir | Out-Null
}

if (Test-Path $configPath) {
  $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
  $backupPath = "$configPath.bak.$timestamp"
  Copy-Item $configPath $backupPath
  Write-Host "Backed up existing config to: $backupPath" -ForegroundColor Yellow
}

$key = Read-Host "Paste your Crazyrouter API key"
if ([string]::IsNullOrWhiteSpace($key)) {
  throw "API key is empty."
}

$model = Read-Host "Model name [default: gpt-5.5]"
if ([string]::IsNullOrWhiteSpace($model)) {
  $model = "gpt-5.5"
}

[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", $key, "User")
[Environment]::SetEnvironmentVariable("OPENAI_BASE_URL", "https://cn.crazyrouter.com/v1", "User")

$toml = @"
model = "$model"
model_provider = "crazyrouter"

[model_providers.crazyrouter]
name = "Crazyrouter"
base_url = "https://cn.crazyrouter.com/v1"
env_key = "OPENAI_API_KEY"
wire_api = "responses"

[model_providers.crazyrouter.query_params]
"@

Set-Content -Path $configPath -Value $toml -Encoding UTF8

Write-Host ""
Write-Host "Done. Codex CLI is now configured to use Crazyrouter." -ForegroundColor Green
Write-Host "Config: $configPath"
Write-Host "Model: $model"
Write-Host "Base URL: https://cn.crazyrouter.com/v1"
Write-Host ""
Write-Host "Restart your terminal before running codex so the new environment variables are loaded." -ForegroundColor Cyan
