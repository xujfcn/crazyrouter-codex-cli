param(
    [string]$ApiKey = $env:CRAZYROUTER_API_KEY,
    [string]$BaseUrl = "https://cn.crazyrouter.com",
    [string[]]$Models = @(
        "claude-opus-4-8",
        "claude-opus-4-7",
        "claude-sonnet-4-6",
        "gpt-5.5",
        "gpt-5.4"
    ),
    [string]$ConfigPath = (Join-Path $HOME ".workbuddy\models.json"),
    [switch]$ReplaceCrazyrouter,
    [switch]$NoBackup
)

$ErrorActionPreference = "Stop"

function ConvertFrom-SecureStringPlainText {
    param([Parameter(Mandatory = $true)][securestring]$SecureString)

    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    } finally {
        if ($ptr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
        }
    }
}

function Normalize-BaseUrl {
    param([Parameter(Mandatory = $true)][string]$Url)

    $normalized = $Url.Trim().TrimEnd("/")
    if ([string]::IsNullOrWhiteSpace($normalized)) {
        throw "BaseUrl cannot be empty."
    }

    if ($normalized -notmatch "^https?://") {
        throw "BaseUrl must start with http:// or https://"
    }

    if ($normalized -notmatch "/v1$") {
        $normalized = "$normalized/v1"
    }

    return $normalized
}

function Read-ExistingModels {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    $raw = Get-Content -LiteralPath $Path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    $json = ConvertFrom-Json -InputObject $raw -NoEnumerate
    if ($json -is [array]) {
        return @($json)
    }

    if ($null -ne $json.models -and $json.models -is [array]) {
        return @($json.models)
    }

    throw "Unsupported WorkBuddy models.json format. Expected a JSON array."
}

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    $secureKey = Read-Host "请输入 Crazyrouter API Key（以 sk- 开头，不会上传到任何地方）" -AsSecureString
    $ApiKey = ConvertFrom-SecureStringPlainText -SecureString $secureKey
}

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    throw "Missing API key. Set CRAZYROUTER_API_KEY or enter it when prompted."
}

$targetUrl = Normalize-BaseUrl -Url $BaseUrl
$configDir = Split-Path -Parent $ConfigPath
if (-not (Test-Path -LiteralPath $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

$existing = @(Read-ExistingModels -Path $ConfigPath)

if ((Test-Path -LiteralPath $ConfigPath) -and -not $NoBackup) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupPath = "$ConfigPath.bak.$timestamp"
    Copy-Item -LiteralPath $ConfigPath -Destination $backupPath -Force
    Write-Host "已备份原配置：$backupPath"
}

$desiredModelIds = New-Object System.Collections.Generic.List[string]
$desiredModelSet = New-Object "System.Collections.Generic.HashSet[string]"
foreach ($model in $Models) {
    $trimmed = $model.Trim()
    if (-not [string]::IsNullOrWhiteSpace($trimmed) -and $desiredModelSet.Add($trimmed)) {
        $desiredModelIds.Add($trimmed)
    }
}

if ($desiredModelIds.Count -eq 0) {
    throw "Models cannot be empty."
}

$merged = New-Object System.Collections.Generic.List[object]
foreach ($item in $existing) {
    $id = [string]$item.id
    $isDesiredModel = -not [string]::IsNullOrWhiteSpace($id) -and $desiredModelSet.Contains($id)
    $isCrazyrouterModel = [string]$item.vendor -eq "Custom" -and ([string]$item.url).TrimEnd("/") -match "^https://(cn\.)?crazyrouter\.com/v1/?$"

    if ($isDesiredModel) {
        continue
    }

    if ($ReplaceCrazyrouter -and $isCrazyrouterModel) {
        continue
    }

    $merged.Add($item)
}

foreach ($modelId in $desiredModelIds) {
    $merged.Add([ordered]@{
        id = $modelId
        name = $modelId
        vendor = "Custom"
        url = $targetUrl
        apiKey = $ApiKey
        supportsToolCall = $true
        supportsImages = $false
        supportsReasoning = $false
        useCustomProtocol = $false
    })
}

$jsonOutput = $merged.ToArray() | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $ConfigPath -Value $jsonOutput -Encoding UTF8

Write-Host ""
Write-Host "WorkBuddy Crazyrouter 自定义模型配置已写入：$ConfigPath"
Write-Host "接口地址：$targetUrl"
Write-Host "已配置模型："
foreach ($modelId in $desiredModelIds) {
    Write-Host " - $modelId"
}
Write-Host ""
Write-Host "请完全退出并重新打开 WorkBuddy，然后在模型列表中选择 Custom / 自定义模型。"
