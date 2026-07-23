[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$examplePath = Join-Path $projectRoot '.env.example'
$envPath = Join-Path $projectRoot '.env'
$secretDirectory = Join-Path $projectRoot '.secrets'
$postgresPath = Join-Path $secretDirectory 'postgres_password'
$pgadminPath = Join-Path $secretDirectory 'pgadmin_password'

if ((Test-Path -LiteralPath $envPath) -or
    (Test-Path -LiteralPath $postgresPath) -or
    (Test-Path -LiteralPath $pgadminPath)) {
    throw 'Local configuration or secret files already exist; move them before generating replacements.'
}

New-Item -ItemType Directory -Path $secretDirectory -Force | Out-Null

function New-RandomSecret {
    $bytes = [byte[]]::new(32)
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
    return [Convert]::ToBase64String($bytes)
}

[System.IO.File]::WriteAllText($postgresPath, (New-RandomSecret))
[System.IO.File]::WriteAllText($pgadminPath, (New-RandomSecret))

$content = [System.IO.File]::ReadAllText($examplePath)
$content = $content.Replace('.secrets/REPLACE_WITH_POSTGRES_PASSWORD_FILE', '.secrets/postgres_password')
$content = $content.Replace('.secrets/REPLACE_WITH_PGADMIN_PASSWORD_FILE', '.secrets/pgadmin_password')
[System.IO.File]::WriteAllText($envPath, $content)

if ($PSVersionTable.PSEdition -eq 'Core' -and -not $IsWindows) {
    & chmod 600 -- $postgresPath $pgadminPath
}

Write-Host 'Created .env and two local secret files. Secret values were not displayed.'
