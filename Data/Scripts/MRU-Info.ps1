function MRU
{
    # Create an array of all of the ("most useful") MRU list registry locations, minus the qualifier
    $keys    = ( "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU",
                 "Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU",
                 "Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs",
                 "Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
                 "Software\Microsoft\Internet Explorer\TypedURLs" )

    $SIDs       = Split-Path -Path (Resolve-Path -Path Registry::HKEY_USERS\*) -Leaf
                 
    $success = $true # Remains true if all files export, false if one or more fail to export

    # Export and save each registry key as keyname.reg
    Foreach ($index in 0..4)
    {
        Foreach ($SID in ($SIDs | Where { Test-Path "Registry::HKEY_USERS\$_\$($keys[$index])" }))
        {
            $path    = "$global:OUTPUT_DIR\MRU\$SID" # Path to save all of the users keys
            # Make sure path folders are created
            if(!(Test-Path $path)){ New-Item -Path $path -ItemType Directory }

            $MRUType      = Split-Path -Path $keys[$index] -Leaf
            $specificPath = "$path\$MRUType.reg"
            $fullKey      = "HKU\$SID\$($keys[$index])"

            reg export $fullKey $specificPath /y

            $success = $success -and (Test-Path $specificPath)
        }
        # Copy keys from HKCU (if present)
        if (Test-Path "Registry::HKEY_CURRENT_USER\$($keys[$index])")
        {
            $path = "$global:OUTPUT_DIR\MRU\HKCU" # Path to save all of the users keys
            # Make sure path folders are created
            if(!(Test-Path $path)){ New-Item -Path $path -ItemType Directory }

            $MRUType      = Split-Path -Path $keys[$index] -Leaf
            $specificPath = "$path\$MRUType.reg"
            $fullKey      = "HKCU\$($keys[$index])"

            reg export $fullKey $specificPath /y

            $success = $success -and (Test-Path $specificPath)
        }
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