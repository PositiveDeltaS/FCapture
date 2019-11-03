function MRU
{
    # Create an array of all of the ("most useful") MRU list registry locations
    $keys    = ( "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU",
                 "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU",
                 "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs",
                 "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
                 "HKCU\Software\Microsoft\Internet Explorer\TypedURLs" )

    $path    = "$global:OUTPUT_DIR\MRU" # Path to save all .reg files to

    $success = $true # Remains true if all files export, false if one or more fail to export

    New-Item -Path $path -ItemType Directory # Create the MRU folder to save files to

    # Export and save each registry key as keyname.reg
    Foreach ($key in $keys)
    {
        $MRUType      = Split-Path -Path $key -Leaf
        $specificPath = "$path\$MRUType.reg"

        reg export $key $specificPath /y

        $success = $success -and (Test-Path $specificPath)
    }

    if ($success) # Validate the created filepaths to determine success; Log results
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Exported MRU registry files")
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to export one or more MRU registry file")
    }
}