function UserAssist
{
    $key  = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist"
    $path = "$global:OUTPUT_DIR\UserAssist.reg"

    # Save the registry info contained in $key to a new .reg file and save it at $path
    reg export $key $path /y

    if (Test-Path $path) # Validate the created path to determine success; Log results
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created UserAssist.reg")
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create UserAssist.reg")
    }
}