# Crazyrouter + OpenAI Codex CLI setup for Windows
# Remote-exec friendly version for GitHub raw hosting
# Usage:
#   iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex
#   $env:CRAZYROUTER_CODEX_MODE='switch'; iwr -UseB https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/install-crazyrouter-codex.ps1 | iex

param(
  [ValidateSet('full', 'switch')]
  [string]$Mode = $(if ($env:CRAZYROUTER_CODEX_MODE -in @('full', 'switch')) { $env:CRAZYROUTER_CODEX_MODE } else { 'full' })
)

$ErrorActionPreference = 'Stop'
$BaseUrl = 'https://cn.crazyrouter.com/v1'
$DefaultModel = 'gpt-5.5'

function Write-Step($Message) {
  Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Write-Ok($Message) {
  Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarnMsg($Message) {
  Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Refresh-UserPath {
  $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  $user = [Environment]::GetEnvironmentVariable('Path', 'User')
  $env:Path = (($machine, $user) -join ';')
}

function Ensure-Winget {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Please install/update App Installer from Microsoft Store, then rerun."
  }
  Write-Ok "winget detected"
}

function Ensure-Git {
  if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Ok "Git already installed: $(git --version)"
    return
  }

  Ensure-Winget
  Write-Step "Installing Git for Windows"
  winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
  Refresh-UserPath

  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    $gitCmd = Get-ChildItem 'C:\Program Files\Git\cmd\git.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($gitCmd) {
      $gitDir = Split-Path $gitCmd.FullName
      if ($env:Path -notlike "*$gitDir*") { $env:Path += ";$gitDir" }
    }
  }

  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git installation finished, but git is still not found in PATH. Please reopen PowerShell and rerun."
  }

  Write-Ok "Git installed: $(git --version)"
}

function Get-NodeMajorVersion {
  try {
    return [int](& node -p "process.versions.node.split('.')[0]")
  } catch {
    return $null
  }
}

function Ensure-Node {
  $hasNode = Get-Command node -ErrorAction SilentlyContinue
  $hasNpm = Get-Command npm -ErrorAction SilentlyContinue
  if ($hasNode -and $hasNpm) {
    $major = Get-NodeMajorVersion
    if ($major -and $major -lt 22) {
      Write-WarnMsg "Node.js $(node --version) is installed. Node.js 22+ is recommended for Codex CLI."
    } else {
      Write-Ok "Node already installed: $(node --version) / npm $(npm --version)"
    }
    return
  }

  Ensure-Winget
  Write-Step "Installing Node.js LTS"
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
  Refresh-UserPath

  if (-not (Get-Command node -ErrorAction SilentlyContinue) -or -not (Get-Command npm -ErrorAction SilentlyContinue)) {
    $nodeDirs = @(
      'C:\Program Files\nodejs',
      "$env:LOCALAPPDATA\Programs\nodejs"
    )
    foreach ($dir in $nodeDirs) {
      if (Test-Path $dir) {
        if ($env:Path -notlike "*$dir*") { $env:Path += ";$dir" }
      }
    }
  }

  if (-not (Get-Command node -ErrorAction SilentlyContinue) -or -not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "Node.js installation finished, but node/npm are still not found in PATH. Please reopen PowerShell and rerun."
  }

  Write-Ok "Node installed: $(node --version) / npm $(npm --version)"
}

function Add-NpmToPath {
  try {
    $npmPrefix = npm config get prefix
  } catch {
    $npmPrefix = $null
  }

  $candidates = @(
    $npmPrefix,
    (Join-Path $env:APPDATA 'npm')
  ) | Where-Object { $_ } | Select-Object -Unique

  foreach ($dir in $candidates) {
    if ($dir -and (Test-Path $dir)) {
      if ($env:Path -notlike "*$dir*") { $env:Path += ";$dir" }
    }
  }
}

function Ensure-CodexCli {
  if (Get-Command codex -ErrorAction SilentlyContinue) {
    try {
      $ver = codex --version 2>$null
      Write-Ok "Codex CLI already installed: $ver"
    } catch {
      Write-Ok "Codex CLI command already present"
    }
    return
  }

  Ensure-Node
  Write-Step "Installing OpenAI Codex CLI"
  npm install -g @openai/codex
  Refresh-UserPath
  Add-NpmToPath

  if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    throw "Codex CLI installed, but 'codex' is still not found. Please open a new PowerShell window and run: codex --version"
  }

  try {
    $ver = codex --version 2>$null
    Write-Ok "Codex CLI installed: $ver"
  } catch {
    Write-Ok "Codex CLI installed"
  }
}

function Require-ExistingCodex {
  if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
    throw "Codex CLI is not installed or not in PATH. Rerun with -Mode full to install it automatically."
  }

  try {
    $ver = codex --version 2>$null
    Write-Ok "Codex CLI detected: $ver"
  } catch {
    Write-Ok "Codex CLI command detected"
  }
}

function Read-SecretPlainText($Prompt) {
  $secure = Read-Host $Prompt -AsSecureString
  $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  try {
    return [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
  } finally {
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
  }
}

function Read-Settings {
  Write-Step "Enter your Crazyrouter API key"
  $token = Read-SecretPlainText 'Paste your Crazyrouter API key (input hidden)'
  if ([string]::IsNullOrWhiteSpace($token)) {
    throw 'No API key entered. Get one at https://cn.crazyrouter.com'
  }

  if ($token -notmatch '^sk-|^cr-|^rk-') {
    Write-WarnMsg "Token format looks unusual. Continuing anyway."
  }

  $model = Read-Host "Model name [default: $DefaultModel]"
  if ([string]::IsNullOrWhiteSpace($model)) {
    $model = $DefaultModel
  }

  if ($model.Contains('"')) {
    throw 'Model name cannot contain double quotes.'
  }

  return @{
    Token = $token
    Model = $model
  }
}

function Set-CrazyrouterEnv($Token) {
  Write-Step "Saving Crazyrouter environment variables"

  [Environment]::SetEnvironmentVariable('OPENAI_API_KEY', $Token, 'User')
  [Environment]::SetEnvironmentVariable('OPENAI_BASE_URL', $BaseUrl, 'User')

  $env:OPENAI_API_KEY = $Token
  $env:OPENAI_BASE_URL = $BaseUrl

  Write-Ok "Crazyrouter API key saved for current user"
}

function Backup-File($Path) {
  if (Test-Path $Path) {
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $backupPath = "$Path.bak.$timestamp"
    Copy-Item $Path $backupPath
    Write-WarnMsg "Backed up existing config to: $backupPath"
  }
}

function Update-CodexConfig($Model) {
  $codexDir = Join-Path $env:USERPROFILE '.codex'
  $configPath = Join-Path $codexDir 'config.toml'

  if (-not (Test-Path $codexDir)) {
    New-Item -ItemType Directory -Path $codexDir -Force | Out-Null
  }

  Backup-File $configPath

  $existing = @()
  if (Test-Path $configPath) {
    $existing = Get-Content $configPath
  }

  $filtered = New-Object System.Collections.Generic.List[string]
  $section = ''
  $skipProvider = $false

  foreach ($line in $existing) {
    if ($line -match '^\s*\[') {
      if ($line -match '^\s*\[model_providers\.crazyrouter(\.|\])') {
        $skipProvider = $true
        continue
      }

      $skipProvider = $false
      $section = $line
    }

    if ($skipProvider) {
      continue
    }

    if ($section -eq '' -and $line -match '^\s*model\s*=') {
      continue
    }

    if ($section -eq '' -and $line -match '^\s*model_provider\s*=') {
      continue
    }

    $filtered.Add($line)
  }

  $newLines = New-Object System.Collections.Generic.List[string]
  $newLines.Add("model = `"$Model`"")
  $newLines.Add('model_provider = "crazyrouter"')
  $newLines.Add('')

  foreach ($line in $filtered) {
    $newLines.Add($line)
  }

  if ($filtered.Count -gt 0 -and $filtered[$filtered.Count - 1] -ne '') {
    $newLines.Add('')
  }

  $newLines.Add('[model_providers.crazyrouter]')
  $newLines.Add('name = "Crazyrouter"')
  $newLines.Add("base_url = `"$BaseUrl`"")
  $newLines.Add('env_key = "OPENAI_API_KEY"')
  $newLines.Add('wire_api = "responses"')
  $newLines.Add('')
  $newLines.Add('[model_providers.crazyrouter.query_params]')

  Set-Content -Path $configPath -Value $newLines -Encoding UTF8
  Write-Ok "Codex config written: $configPath"
}

function Ensure-TestRepo {
  $repoPath = Join-Path $HOME 'Projects\codex-crazyrouter-test'
  if (-not (Test-Path $repoPath)) {
    New-Item -ItemType Directory -Path $repoPath -Force | Out-Null
  }

  if (Get-Command git -ErrorAction SilentlyContinue) {
    Push-Location $repoPath
    try {
      if (-not (Test-Path (Join-Path $repoPath '.git'))) {
        git init | Out-Null
        Write-Ok "Created test repo at $repoPath"
      } else {
        Write-Ok "Test repo exists at $repoPath"
      }
    } finally {
      Pop-Location
    }
  } else {
    Write-Ok "Test directory ready: $repoPath"
  }

  return $repoPath
}

function Show-NextSteps($Model, $RepoPath) {
  Write-Host "`n========================================" -ForegroundColor Cyan
  Write-Host "Crazyrouter Codex CLI setup complete" -ForegroundColor Cyan
  Write-Host "========================================`n" -ForegroundColor Cyan

  Write-Host "Mode: $Mode" -ForegroundColor White
  Write-Host "Base URL: $BaseUrl" -ForegroundColor Gray
  Write-Host "Model: $Model" -ForegroundColor Gray
  Write-Host ""
  Write-Host "Next steps:" -ForegroundColor White
  Write-Host "1. Open a NEW PowerShell window" -ForegroundColor Gray
  Write-Host "2. Run: codex --version" -ForegroundColor Gray

  if ($RepoPath) {
    Write-Host "3. Run:" -ForegroundColor Gray
    Write-Host "   cd `"$RepoPath`"" -ForegroundColor DarkGray
    Write-Host "   codex" -ForegroundColor DarkGray
  } else {
    Write-Host "3. Start Codex in your project directory: codex" -ForegroundColor Gray
  }

  Write-Host ""
  Write-Host "Saved env vars:" -ForegroundColor White
  Write-Host "- OPENAI_API_KEY" -ForegroundColor Gray
  Write-Host "- OPENAI_BASE_URL=$BaseUrl" -ForegroundColor Gray
}

try {
  Write-Host "Crazyrouter Codex CLI installer" -ForegroundColor White
  Write-Host ""

  if ($Mode -eq 'full') {
    Write-Host "This mode installs Git, Node.js, Codex CLI, and configures Crazyrouter." -ForegroundColor Gray
  } else {
    Write-Host "This mode only switches your existing Codex CLI configuration to Crazyrouter." -ForegroundColor Gray
  }

  $settings = Read-Settings

  if ($Mode -eq 'full') {
    Write-Step "Checking / installing Git"
    Ensure-Git

    Write-Step "Checking / installing Node.js"
    Ensure-Node

    Write-Step "Checking / installing Codex CLI"
    Ensure-CodexCli
  } else {
    Write-Step "Checking existing Codex CLI"
    Require-ExistingCodex
  }

  Set-CrazyrouterEnv $settings.Token

  Write-Step "Updating Codex provider config"
  Update-CodexConfig $settings.Model

  $repoPath = $null
  if ($Mode -eq 'full') {
    $repoPath = Ensure-TestRepo
  }

  Show-NextSteps $settings.Model $repoPath
}
catch {
  Write-Host "`n[ERROR] $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}
