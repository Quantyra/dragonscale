param(
  [string]$BaseUrl = "https://dragonscale.example.com",
  [string]$HostName = "dragonscale.example.com"
)

$ErrorActionPreference = "Stop"

Write-Host "Checking DNS for $HostName"
$dns = Resolve-DnsName $HostName -ErrorAction Stop
$dns | Format-Table -AutoSize

Write-Host "Checking HTTPS response for $BaseUrl"
$response = Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing -TimeoutSec 15
Write-Host "HTTP status: $($response.StatusCode)"

Write-Host "Checking OIDC callback route is reachable enough to return an HTTP response"
try {
  $callback = Invoke-WebRequest -Uri "$BaseUrl/oidc/callback" -UseBasicParsing -TimeoutSec 15
  Write-Host "OIDC callback status: $($callback.StatusCode)"
} catch {
  $status = $_.Exception.Response.StatusCode.value__
  if ($status -in @(400, 404, 405)) {
    Write-Host "OIDC callback returned expected non-success HTTP status: $status"
  } else {
    throw
  }
}

Write-Host "Dragonscale smoke check complete."
