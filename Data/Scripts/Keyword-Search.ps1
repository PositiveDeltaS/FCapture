function KeyWord-Search
{
    # Set up path key of registry entry and path to output directory
    $key = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery"
    $path = "$global:OUTPUT_DIR\KeywordSearches.reg"

    # Save the registry info contained in $key to a new .reg file and save it at $path
    reg export $key $path /y

    if (Test-Path $path) # Validate the created path to determine success; Log results
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created KeywordSearches.reg")
        return $true
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create KeywordSearches.reg")
        return $false
    }
}