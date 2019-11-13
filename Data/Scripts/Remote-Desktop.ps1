function Remote-Desktop
{
    $users = Split-Path -Path (Resolve-Path "$env:HOMEDRIVE\Users\*" | Select -ExpandProperty Path) -Leaf
    $usefulUsers = $users | Where {Test-Path "$env:HOMEDRIVE\Users\$_\AppData\Local\Microsoft\Terminal Server Client\Cache"}

    # If there are no RDPCache files in any user account, just log as much and abort
    if($usefulUsers.Length -lt 1) { Search-And-Add-Log-Entry $SUCCESS_LOG "No RDPCache files in any user accounts; skipped"; return }

    # Copy the RDP Cache of each user to the output directory
    ForEach($user in $usefulUsers)
    {
        # Make a path to the RDP Cache folder for this user and to the output folder we will copy it to
        $RDPInPath  = "$env:HOMEDRIVE\Users\$user\AppData\Local\Microsoft\Terminal Server Client\Cache"
        $RDPOutPath = "$global:OUTPUT_DIR\RDPCache\Users\$user"

        try
        { 
            New-Item -Path $RDPOutPath -ItemType Directory
            Copy-Item $RDPInPath -Destination $RDPOutPath -Recurse
            Search-And-Add-Log-Entry $SUCCESS_LOG "Copied RDPCache files at $RDPInPath"
        }
        catch
        { 
            Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy RDPCache files at $RDPInPath"
        }
    }
}