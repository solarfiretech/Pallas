[CmdletBinding()]
param(
    [int]$ReadyTimeoutSeconds = 600,
    [int]$RecoveryTimeoutSeconds = 120,
    [switch]$KeepEnvironment
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$projectName = 'pallas-readiness-' + ([guid]::NewGuid().ToString('N').Substring(0, 8))
$startedAt = Get-Date
$timeline = [System.Collections.Generic.List[string]]::new()

function Write-Event([string]$Message) {
    $elapsed = [math]::Round(((Get-Date) - $startedAt).TotalSeconds, 1)
    $line = ('{0,7:N1}s  {1}' -f $elapsed, $Message)
    $timeline.Add($line)
    Write-Host $line
}

function Invoke-Compose {
    & docker compose --project-name $projectName @args
    if ($LASTEXITCODE -ne 0) { throw "docker compose failed with exit code $LASTEXITCODE" }
}

function Get-Health([string]$Service) {
    $containerId = (& docker compose --project-name $projectName ps --quiet $Service).Trim()
    if (-not $containerId) { return 'absent' }
    $value = (& docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' $containerId).Trim()
    if ($LASTEXITCODE -ne 0) { throw "docker inspect failed for $Service" }
    return $value
}

function Wait-Health([string]$Service, [string]$Expected, [int]$TimeoutSeconds) {
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    $previous = $null
    do {
        $current = Get-Health $Service
        if ($current -ne $previous) {
            Write-Event "$Service health=$current"
            $previous = $current
        }
        if ($current -eq $Expected) { return }
        Start-Sleep -Seconds 2
    } while ((Get-Date) -lt $deadline)
    throw "$Service did not reach '$Expected' within $TimeoutSeconds seconds (last state: $current)"
}

function Get-AggregateStatus {
    try {
        $response = Invoke-RestMethod -Uri 'http://localhost:8000/health/containers' -TimeoutSec 15
        return $response.status
    } catch {
        return 'unreachable'
    }
}

function Wait-Aggregate([string]$Expected, [int]$TimeoutSeconds) {
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    $previous = $null
    do {
        $current = Get-AggregateStatus
        if ($current -ne $previous) {
            Write-Event "FastAPI aggregate status=$current"
            $previous = $current
        }
        if ($current -eq $Expected) { return }
        Start-Sleep -Seconds 2
    } while ((Get-Date) -lt $deadline)
    throw "FastAPI aggregate did not reach '$Expected' within $TimeoutSeconds seconds (last state: $current)"
}

Push-Location $repoRoot
try {
    if (-not $env:POSTGRES_PASSWORD_FILE -or -not $env:PGADMIN_DEFAULT_PASSWORD_FILE) {
        throw 'Set POSTGRES_PASSWORD_FILE and PGADMIN_DEFAULT_PASSWORD_FILE to readable secret files before running this test.'
    }

    Write-Event "project=$projectName cold start with PostgreSQL and OpenPLC delayed"
    Invoke-Compose up --detach --build node-red pgadmin fastapi
    foreach ($service in @('node-red', 'pgadmin', 'fastapi')) {
        Wait-Health $service 'healthy' $ReadyTimeoutSeconds
    }
    Wait-Aggregate 'degraded' $RecoveryTimeoutSeconds
    Write-Event 'starting delayed PostgreSQL'
    Invoke-Compose up --detach postgres
    Wait-Health 'postgres' 'healthy' $RecoveryTimeoutSeconds
    Wait-Aggregate 'degraded' $RecoveryTimeoutSeconds
    Write-Event 'starting delayed OpenPLC'
    Invoke-Compose up --detach openplc-runtime
    Wait-Health 'openplc-runtime' 'healthy' $ReadyTimeoutSeconds
    Wait-Aggregate 'ok' $RecoveryTimeoutSeconds

    Write-Event 'PostgreSQL restart scenario'
    Invoke-Compose restart postgres
    Wait-Health 'postgres' 'healthy' $RecoveryTimeoutSeconds
    Wait-Aggregate 'ok' $RecoveryTimeoutSeconds

    Write-Event 'OpenPLC restart scenario'
    Invoke-Compose restart openplc-runtime
    Wait-Health 'openplc-runtime' 'healthy' $RecoveryTimeoutSeconds
    Wait-Aggregate 'ok' $RecoveryTimeoutSeconds
    Write-Event 'PASS: cold start, delayed dependencies, and restart recovery'
} finally {
    if (-not $KeepEnvironment) {
        Write-Event "removing isolated project $projectName"
        & docker compose --project-name $projectName down --volumes --remove-orphans
    }
    Pop-Location
}
