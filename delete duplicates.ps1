$folderPath = "C:\Users\[username]\[...]"  # Specify your new folder path here

# Get all files in the specified folder
$files = Get-ChildItem -Path $folderPath -Recurse

# Create a hash table to store file hashes
$hashTable = @{}

foreach ($file in $files) {
    # Calculate the hash of the file
    $fileHash = Get-FileHash -Path $file.FullName

    # Check if the hash already exists in the hash table
    if ($hashTable.ContainsKey($fileHash.Hash)) {
        # If it exists, remove the duplicate file
        Remove-Item -Path $file.FullName -Force
        Write-Host "Removed duplicate: $($file.FullName)"
    } else {
        # If it does not exist, add it to the hash table
        $hashTable[$fileHash.Hash] = $file.FullName
    }
}
