<#
    This function attempts to find the drive that windows is installed on
    and copy the Prefetch files from the local machine by copying the entire
    C:\Windows\Prefetch folder to the output directory.
    It then logs its success or failure.
#>
function Prefetch
{
    # Get the drive letters of all local drives
    $localDrives = ([System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -eq 'Fixed'}).Name

    # Find the local drive that windows is installed on
    ForEach ($drive in $localDrives)
    {
        if(Test-Path "$drive\Windows\Prefetch")
        {
            # Copy the entire Prefetch folder to the output dir, even if it already exists there
            Copy-Item "$drive\Windows\Prefetch" -destination $global:OUTPUT_DIR -recurse -force
            break
        }
    }

    # Consider the function a success if a path to the Prefetch folder
    # exists in the program output dir; fail otherwise
    $success = Test-Path "$global:OUTPUT_DIR\Prefetch"

    if($success)
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Copied Prefetch files from local machine")
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to copy Prefetch files from local machine")
    }
}