function ShimCache {
    # Set up path key of registry entry and path to output directory
    $key = "HKLM\SYSTEM\CurrentControlSet\Control\SessionManager\AppCompatCache\AppCompatCache"
    $path = "$global:OUTPUT_DIR\ShimCache.reg"

    # Save the registry info contained in $key to a new .reg file and save it at $path
    reg export $key $path /y

    if (Test-Path $path) # Validate the created path to determine success; Log results
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created ShimCache.reg")
        return $true;
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create ShimCache.reg")
        return $false;
    }
}