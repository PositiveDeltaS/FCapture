<#
    This function uses $env:HOMEDRIVE to find the drive that windows is installed on
    and copies the Prefetch files from the local machine by copying the entire
    Prefetch folder to the output directory.
    It then logs its success or failure.

    NOTE: This function will likely FAIL if the program/script is not ran as an Administrator
#>
function Prefetch
{
    try
    {
        # Copy the entire Prefetch folder to the output dir, even if it already exists there
        Copy-Item "$env:HOMEDRIVE\Windows\Prefetch" -destination $global:OUTPUT_DIR -recurse -force
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Copied Prefetch files from local machine")
    }
    catch
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to copy Prefetch files from local machine")
    }
}