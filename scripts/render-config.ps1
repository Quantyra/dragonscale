param(
  [string]$EnvFile = ".env",
  [string]$Template = "config/headscale.config.example.yaml",
  [string]$Output = "config/config.yaml"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $EnvFile)) {
  throw "Env file not found: $EnvFile"
}

$values = @{}
Get-Content $EnvFile | ForEach-Object {
  $line = $_.Trim()
  if (-not $line -or $line.StartsWith("#")) { return }
  $idx = $line.IndexOf("=")
  if ($idx -lt 1) { return }
  $key = $line.Substring(0, $idx).Trim()
  $value = $line.Substring($idx + 1).Trim().Trim('"').Trim("'")
  $values[$key] = $value
}

$required = @(
  "DRAGONSCALE_SERVER_URL",
  "DRAGONSCALE_OIDC_CLIENT_ID",
  "DRAGONSCALE_OIDC_CLIENT_SECRET",
  "DRAGONSCALE_ALLOWED_USER_1",
  "DRAGONSCALE_ALLOWED_USER_2"
)

foreach ($key in $required) {
  if (-not $values.ContainsKey($key) -or -not $values[$key] -or $values[$key] -like "replace-*") {
    throw "Missing required value in ${EnvFile}: $key"
  }
}

$content = Get-Content $Template -Raw
foreach ($key in $required) {
  $content = $content.Replace("__${key}__", $values[$key])
}

Set-Content -Path $Output -Value $content -Encoding UTF8
Write-Host "Rendered $Output"
