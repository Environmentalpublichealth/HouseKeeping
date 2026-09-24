# Count batches and .raw files (samples) for a SPECIFIC MONTH, broken down by user
# Structure expected: root/user/project/batch/Data/*.raw
# Each batch folder contains 4 subfolders, so batch counts are divided by 4
# Compatible with PowerShell 2.0
#
# Usage:
#   .\Count-BatchesAndSamplesByUser.ps1 "C:\Path\To\Root" "2026-09"
#   (if no path or month is given, it will prompt you to enter them)

param(
    [string]$rootPath,
    [string]$targetMonth
)

if ([string]::IsNullOrEmpty($rootPath)) {
    $rootPath = Read-Host "Enter the root folder path to scan (contains user folders)"
}

if ([string]::IsNullOrEmpty($targetMonth)) {
    $targetMonth = Read-Host "Enter the month to check (format yyyy-MM, e.g. 2026-09)"
}

if (-not (Test-Path $rootPath)) {
    Write-Host "Path not found: $rootPath"
    exit
}

$userFolders = Get-ChildItem $rootPath | Where-Object { $_.PSIsContainer }

$results = @()

foreach ($userFolder in $userFolders) {

    # projects under this user
    $projects = Get-ChildItem $userFolder.FullName | Where-Object { $_.PSIsContainer }

    # batches under each project (user/project/batch)
    $batches = $projects | ForEach-Object {
        Get-ChildItem $_.FullName | Where-Object { $_.PSIsContainer }
    }

    # batches created in the target month
    $batchesInMonth = $batches | Where-Object {
        $_.CreationTime.ToString("yyyy-MM") -eq $targetMonth
    }

    # raw count divided by 4 (since each batch folder has 4 subfolders)
    $batchCount = 0
    if ($batchesInMonth) {
        $rawBatchCount = ($batchesInMonth | Measure-Object).Count
        $batchCount = [math]::Floor($rawBatchCount / 4)
    }

    # .raw files under this user, sitting in Data subfolders, created in target month
    $rawFiles = Get-ChildItem $userFolder.FullName -Recurse | Where-Object {
        $_.Extension -eq ".raw" -and
        $_.DirectoryName -like "*\Data" -and
        $_.CreationTime.ToString("yyyy-MM") -eq $targetMonth
    }

    $sampleCount = 0
    if ($rawFiles) {
        $sampleCount = ($rawFiles | Measure-Object).Count
    }

    $results += New-Object PSObject -Property @{
        User   = $userFolder.Name
        Month  = $targetMonth
        Batch  = $batchCount
        Sample = $sampleCount
    }
}

$results | Format-Table User, Month, Batch, Sample -AutoSize
