<#
    This function takes all of the output folders and files that were created
    during the operation of the program and compresses them into a zip archive
    or puts them into a vhdx file, depending on the user's decision in the
    advanced menu.
    The way this is done is fairly convoluted, but it works.

    ***WARNINGS***
    - The $outputFilename is too long for Fat32, and will only work for Ntfs;
    If the filesystem is ever changed, it's highly likely that the $outputFilename
    will need to be changed/shortened.
    - For some reason, folders with many subfolders (like Jump Lists) occasionally
    won't end up in the archive and instead remain outside of it. Not sure why.
#>
function Package-Output-Data
{
    Add-Type -AssemblyName System.IO.Compression.Filesystem # Needed to create .zip archive
    $ErrorActionPreference = 'silentlycontinue' # Don't print errors to the console if encountered
    $timestamp      = Get-Date -Format "HHmmss_ddMMyyyy" # Differentiates each output file by date/time created
    $outputFilename = "FCAP_OUTPUT_$timestamp" # The actual filename of the .zip or .vhdx file

    if($ZipOutputRBtn.Checked) # Output the collected data as a .zip file
    {
        # Temporarily create a folder containing the folder that will be archived
        New-Item -Name "FCAP_OUTPUT\FCAP_OUTPUT" -Path "$PSScriptRoot\.." -ItemType Directory

        # Move all of the output files\folders to the inner folder, skipping any output files from previous scans and the Record folder
        Move-Item "$global:OUTPUT_DIR\*" -Destination "$PSScriptRoot\..\FCAP_OUTPUT\FCAP_OUTPUT" -Force -Exclude @("FCAP_OUTPUT*","Record")

        # Zip the inner folder, name it with timestamp, then place it in the output directory
        [IO.Compression.Zipfile]::CreateFromDirectory("$PSScriptRoot\..\FCAP_OUTPUT","$global:OUTPUT_DIR\$outputFilename.zip")
        Remove-Item "$PSScriptRoot\..\FCAP_OUTPUT" -Recurse -Force # Remove the temporary folder that was just archived
    }
    else # Output the collected data as a .vhdx file
    {
        # Estimate the size of the virtual HD, rounding up 1Gb for some breathing room
        $outFolderSize = [math]::Round((Get-ChildItem $global:OUTPUT_DIR | Measure-Object -Property Length -Sum).Sum / 1Mb) + 1024
        $qualifiedPath = Resolve-Path -Path "$PSScriptRoot\.."
        
        # Create a script to be used by diskpart, which creates, mounts, formats, and sets up the VHD
        $diskPartScript =
@"
create vdisk file="$qualifiedPath\$outputFilename.vhdx" maximum=$outFolderSize type=expandable
select vdisk file="$qualifiedPath\$outputFilename.vhdx"
attach vdisk
create partition primary
format fs=NTFS label="$outputFilename" quick
assign
"@
        # Create DPScript.txt because diskpart needs an actual text file to use as a script
        New-Item -Name "DPScript.txt" -Path "$PSScriptRoot\.." -ItemType File -Value $diskPartScript

        # Run diskpart with DPScript.txt, catch the output in $dpOutput to stop it printing to console
        $dpOutput = (Diskpart /s "$PSScriptRoot\..\DPScript.txt")

        # Find the drive letter of the newly created and mounted VHD, append a ':' to it
        $vhdx = (Get-Volume -FriendlyName "$outputFilename").DriveLetter + ":"

        # Create a folder to hold the F-Capture output data in the VHD
        New-Item -Name "FCAP_OUTPUT" -Path "$vhdx" -ItemType Directory

        # Move all of the output data to the newly created folder on the VHD, skipping any output files from previous scans and the Record folder
        Move-Item "$global:OUTPUT_DIR\*" -Destination "$vhdx\FCAP_OUTPUT" -Force -Exclude @("FCAP_OUTPUT*","Record")

        # Create a new script to be used by diskpart to unmount the VHD
        $diskPartScript =
@"
select vdisk file="$qualifiedPath\$outputFilename.vhdx"
detach vdisk
"@
        # Create text file containing script so diskpart can use it
        Set-Content -Path "$PSScriptRoot\..\DPScript.txt" -Value $diskPartScript
        $dpOutput = (Diskpart /s "$PSScriptRoot\..\DPScript.txt") # Run diskpart with DPScript.txt
        Remove-Item "$PSScriptRoot\..\DPScript.txt" # Remove DPScript.txt, as it isn't needed anymore

        # Move the (now unmounted) VHDX file to the output folder
        Move-Item -Path "$PSScriptRoot\..\$outputFilename.vhdx" -Destination "$global:OUTPUT_DIR\$outputFilename.vhdx"
    }
    # Test whether a file with the expected name was created, consider its existence a sign of success
    # Add log entries accordingly and return true or false to signify success or failure to calling function
    if(Test-Path "$global:OUTPUT_DIR\$outputFilename.*")
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created $outputFilename output file successfully")
        return $true
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create $outputFilename output file")
        return $false
    }
}