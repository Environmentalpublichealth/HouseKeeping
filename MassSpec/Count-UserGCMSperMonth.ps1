# Count .qgd files by month (creation date)
# Compatible with PowerShell 2.0
#
# Usage:
#   .\Count-UserGCMSperMonth.ps1 "C:\Path\To\User"
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

Get-ChildItem $rootPath -Recurse | 
    Where-Object { $_.Extension -eq ".qgd" } | 
    Group-Object { $_.CreationTime.ToString("yyyy-MM") } | 
    Sort-Object Name | 
    ForEach-Object {
        New-Object PSObject -Property @{
            Month        = $_.Name
            QgdFileCount = $_.Count
        }
    } | Format-Table Month, QgdFileCount -AutoSize
