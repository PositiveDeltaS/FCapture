function Jump-List
{
    # Get a list of names of users that actually have jump lists
    $users       = Split-Path -Path (Resolve-Path "$env:HOMEDRIVE\Users\*" | Select -ExpandProperty Path) -Leaf
    $usefulUsers = $users | Where {Test-Path "$env:HOMEDRIVE\Users\$_\AppData\Roaming\Microsoft\Windows\Recent"}

    # Copy the jump lists of each user to the output directory
    ForEach($user in $usefulUsers)
    {
        # Make a path to the jump list folder for this user and to the output folder we will copy it to
        $JLInPath  = "$env:HOMEDRIVE\Users\$user\AppData\Roaming\Microsoft\Windows\Recent"
        $JLOutPath = "$global:OUTPUT_DIR\JumpLists\Users\$user"

        try
        { 
            New-Item -Path $JLOutPath -ItemType Directory
            Copy-Item $JLInPath -Destination $JLOutPath -Recurse
            Search-And-Add-Log-Entry $SUCCESS_LOG "Copied Jump List directories/files at $JLInPath"
        }
        catch
        { 
            Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy Jump List directories/files at $JLInPath"
        }
    }
}