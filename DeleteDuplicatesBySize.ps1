# Define the folder path
$folderPath = "C:\Users\albur\iCloudPhotos\iPhone Photos"

# Set the minimum file size threshold (in bytes), 10,000 KB is 10,240,000 bytes
$minFileSize = 10240KB

# Get all files in the folder that are videos and larger than 10,000 KB
$files = Get-ChildItem -Path $folderPath -File |
    Where-Object { $_.Length -ge $minFileSize -and $_.Extension -match '\.(mp4|mov|avi|mkv)$' }

# Group files by their size
$groupedFiles = $files | Group-Object Length | Where-Object { $_.Count -gt 1 }

# For each group of files with the same size, delete the newer one and keep the older one
foreach ($group in $groupedFiles) {
    # Sort files by creation time in descending order (newest first)
    $filesToDelete = $group.Group | Sort-Object CreationTime -Descending | Select-Object -Skip 1

    foreach ($file in $filesToDelete) {
        Write-Host "Deleting newer video file: $($file.FullName)"
        Remove-Item $file.FullName -Force
    }
}
