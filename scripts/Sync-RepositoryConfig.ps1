[CmdletBinding()]
param(
    [string] $RepositoriesRoot = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),
    [switch] $Check,
    [switch] $Force
)

$ErrorActionPreference = 'Stop'

$sourceRepository = Split-Path $PSScriptRoot -Parent
$repositoryNames = Get-Content (Join-Path $sourceRepository 'config-repositories.txt') |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }
$configurationFiles = '.editorconfig', '.gitignore'
$drift = [System.Collections.Generic.List[string]]::new()
$repositories = [System.Collections.Generic.List[object]]::new()

foreach ($repositoryName in $repositoryNames) {
    if ([IO.Path]::IsPathRooted($repositoryName) -or
        $repositoryName -ne [IO.Path]::GetFileName($repositoryName)) {
        throw "Invalid repository name in config-repositories.txt: $repositoryName"
    }

    $repositoryPath = Join-Path $RepositoriesRoot $repositoryName

    if (-not (Test-Path (Join-Path $repositoryPath '.git'))) {
        throw "Repository clone not found: $repositoryPath"
    }

    if (-not $Check -and -not $Force) {
        $status = git -C $repositoryPath status --porcelain -- @configurationFiles

        if ($LASTEXITCODE -ne 0) {
            throw "Could not inspect repository status: $repositoryPath"
        }

        if ($status) {
            throw "Uncommitted root configuration changes found in $repositoryPath. Use -Force to replace them."
        }
    }

    $repositories.Add([pscustomobject]@{
        Name = $repositoryName
        Path = $repositoryPath
    })
}

foreach ($repository in $repositories) {
    foreach ($configurationFile in $configurationFiles) {
        $sourcePath = Join-Path $sourceRepository $configurationFile
        $targetPath = Join-Path $repository.Path $configurationFile
        $matches = (Test-Path $targetPath) -and
            ((Get-FileHash $sourcePath -Algorithm SHA256).Hash -eq
             (Get-FileHash $targetPath -Algorithm SHA256).Hash)

        if ($matches) {
            continue
        }

        $relativePath = Join-Path $repository.Name $configurationFile
        $drift.Add($relativePath)

        if (-not $Check) {
            Copy-Item $sourcePath $targetPath -Force
        }
    }
}

if ($drift.Count -eq 0) {
    Write-Output 'All repository configuration files match the canonical templates.'
    return
}

if ($Check) {
    $drift | ForEach-Object { Write-Error "Configuration drift: $_" -ErrorAction Continue }
    throw "$($drift.Count) configuration file(s) differ from the canonical templates."
}

$drift | ForEach-Object { Write-Output "Synchronized $_" }
