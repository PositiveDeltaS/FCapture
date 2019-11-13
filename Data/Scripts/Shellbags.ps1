<#
    This function only copies the registry keys that correspond to the shellbags.
    There is a good chance that this is not good enough; ideally, we would be
    copying NTUSER.DAT, UsrClass.dat, and their associated LOG files, but this
    is extrememly difficult without installing 3rd party software to copy files
    that the operating system is always using. Unless portable software that can
    copy these files is found, this may be as good as we can do.
#>

function Shellbags
{
    $SIDs       = Split-Path -Path (Resolve-Path -Path Registry::HKEY_USERS\*) -Leaf
    $bagMRUSIDs = $SIDs | Where {Test-Path "Registry::HKEY_USERS\$_\Software\Microsoft\Windows\Shell\BagMRU"}
    $bagsSIDs   = $SIDs | Where {Test-Path "Registry::HKEY_USERS\$_\Software\Microsoft\Windows\Shell\Bags"}
    $success    = $true

    # Export BagMRU registry keys for each user that has them
    Foreach ($SID in $bagMRUSIDs)
    {
        $bagMRUKey = "HKU\$SID\Software\Microsoft\Windows\Shell\BagMRU"
        $outPath   = "$global:OUTPUT_DIR\Shellbags\Users\$SID"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $bagMRUKey "$outPath\BagMRU.reg" /y

        $success = $success -and (Test-Path "$outPath\BagMRU.reg")
    }

    # Export Bags registry keys for each user that has them
    Foreach ($SID in $bagsSIDs)
    {
        $bagsKey = "HKU\$SID\Software\Microsoft\Windows\Shell\Bags"
        $outPath   = "$global:OUTPUT_DIR\Shellbags\Users\$SID"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $bagsKey "$outPath\Bags.reg" /y

        $success = $success -and (Test-Path "$outPath\Bags.reg")
    }

    # Export both keys for the current user
    if(Test-Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU")
    {
        $bagMRUKey = "HKCU\Software\Microsoft\Windows\Shell\BagMRU"
        $outPath   = "$global:OUTPUT_DIR\Shellbags\Users\HKCU"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $bagMRUKey "$outPath\BagMRU.reg" /y

        $success = $success -and (Test-Path "$outPath\BagMRU.reg")
    }
    if(Test-Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags")
    {
        $bagsKey = "HKCU\Software\Microsoft\Windows\Shell\Bags"
        $outPath   = "$global:OUTPUT_DIR\Shellbags\Users\HKCU"

        if(!(Test-Path $outPath)){ New-Item -Path $outPath -ItemType Directory }
        reg export $bagsKey "$outPath\Bags.reg" /y

        $success = $success -and (Test-Path "$outPath\Bags.reg")
    }

    if ($success) # Validate the created filepaths to determine success; Log results
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Exported Shellbag registry files")
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to export one or more Shellbag registry file")
    }
}