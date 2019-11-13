<#
    This may not be the correct registry keys for Network Share Info,
    but as far as I can tell, this is at least partially correct.
#>

function Network-Share-Info
{
    $SIDs        = Split-Path -Path (Resolve-Path -Path Registry::HKEY_USERS\*) -Leaf
    $mntPtSIDs   = $SIDs | Where {Test-Path "Registry::HKEY_USERS\$_\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPounts2"}
    $networkSIDs = $SIDs | Where {Test-Path "Registry::HKEY_USERS\$_\Network"}
    $success     = $true

    # Copy the MountPoints2 registry keys for each user to the output folder
    ForEach($SID in $mntPtSIDs)
    {
        $mntPtsKey = "HKU\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPounts2"
        $outPath   = "$global:OUTPUT_DIR\NetworkShareInfo\Users\$SID"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $mntPtsKey "$outPath\MountPounts2.reg" /y

        $success = $success -and (Test-Path "$outPath\MountPounts2.reg")
    }

    # Copy the Network registry keys for each user to the output folder
    ForEach($SID in $networkSIDs)
    {
        $networkKey = "HKU\$SID\Network"
        $outPath   = "$global:OUTPUT_DIR\NetworkShareInfo\Users\$SID"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $networkKey "$outPath\Network.reg" /y

        $success = $success -and (Test-Path "$outPath\Network.reg")
    }

    # Copy both keys for the current user
    if(Test-Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPounts2")
    {
        $mntPtsKey = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPounts2"
        $outPath   = "$global:OUTPUT_DIR\NetworkShareInfo\Users\HKCU"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $mntPtsKey "$outPath\MountPoints2.reg" /y

        $success = $success -and (Test-Path "$outPath\MountPounts2.reg")
    }
    if(Test-Path "Registry::HKEY_CURRENT_USER\Network")
    {
        $networkKey = "HKCU\Network"
        $outPath   = "$global:OUTPUT_DIR\NetworkShareInfo\Users\HKCU"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $networkKey "$outPath\Network.reg" /y

        $success = $success -and (Test-Path "$outPath\Network.reg")
    }

    if ($success) # Validate the created filepaths to determine success; Log results
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Exported Network Share registry files")
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to export one or more Network Share registry file")
    }
}