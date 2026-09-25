# Count batches and .raw files (samples) by month (creation date)
# Structure expected: user/project/batch/Data/*.raw
# Compatible with PowerShell 2.0
#
# Usage:
#   .\Count-UserLCMSperMonth.ps1 "C:\Path\To\User"
#   (if no path is given, it will prompt you to enter one)

param(
    [string]$rootPath
)

if ([string]::IsNullOrEmpty($rootPath)) {
    $rootPath = Read-Host "Enter the folder path to scan"
}

if (-not (Test-Path $rootPath)) {
    Write-Host "Path not found: $rootPath"
    exit
}

# Get all batch folders (user/project/batch)
$batches = Get-ChildItem $rootPath | 
    Where-Object { $_.PSIsContainer } | 
    ForEach-Object {
        Get-ChildItem $_.FullName | Where-Object { $_.PSIsContainer }
    }

# Get all .raw files sitting in Data subfolders
$rawFiles = Get-ChildItem $rootPath -Recurse | 
    Where-Object { $_.Extension -eq ".raw" -and $_.DirectoryName -like "*\Data" }

$batchByMonth = $batches   | Group-Object { $_.CreationTime.ToString("yyyy-MM") }
$rawByMonth   = $rawFiles  | Group-Object { $_.CreationTime.ToString("yyyy-MM") }

# Combine month lists from both sets (in case one has a month the other doesn't)
$months = @()
$months += $batchByMonth | ForEach-Object { $_.Name }
$months += $rawByMonth   | ForEach-Object { $_.Name }
$months = $months | Sort-Object -Unique

$months | ForEach-Object {
    $month = $_
    $batchGroup = $batchByMonth | Where-Object { $_.Name -eq $month }
    $rawGroup   = $rawByMonth   | Where-Object { $_.Name -eq $month }

    $batchCount = 0
    if ($batchGroup) { $batchCount = [math]::Floor($batchGroup.Count / 4)}

    $sampleCount = 0
    if ($rawGroup) { $sampleCount = $rawGroup.Count }

    New-Object PSObject -Property @{
        Time   = $month
        Batch  = $batchCount
        Sample = $sampleCount
    }
} | Format-Table Time, Batch, Sample -AutoSize
