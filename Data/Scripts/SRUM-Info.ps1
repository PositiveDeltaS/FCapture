function SRUM
{
    # Path to the SRUDB.dat file, accounting for homedrives that aren't C:
    $pathToSRUM = "$env:HOMEDRIVE\Windows\System32\sru\SRUDB.dat"

    try
    {
        Copy-Item $pathToSRUM -Destination "$global:OUTPUT_DIR\SRUDB.dat" -Force
        Search-And-Add-Log-Entry $SUCCESS_LOG "Copied SRUDB.dat file"
    }
    catch
    {
        Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy SRUDB.dat file"
    }
}