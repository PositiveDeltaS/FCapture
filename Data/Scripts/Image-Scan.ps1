# While heavily optimized, Image-Scan still takes an enormous amount of time to complete.
# This function is best used when time is not a concern and a thorough search is necessary.
# Image-Scan does not check file extension due to the fact that file extensions are easily modified;
#     this leads to an unreliable output if the host attempts to conceal their images by removing
#     or changing their images' extension.
# Instead Image-Scan retrieves the file header bytes to checks if they match any image formats.
# While this method can be fooled by modifying the header bytes manually, or encrypting the images,
#     it is quite a bit more thorough than the aforementioned method of checking extensions.

# TODO: Add extension scanning for "fast" scan, will be less thorough as a trade-off.
#       Scanning extensions (depending on the speed) may also serve as an estimate for
#       long the thorough scan will take. Not guaranteed to be accurate but may help
#       in cases where images have not been concealed.

# Scans all files in the system checking for images and copying them to an output directory
function Image-Scan {
    [Byte[]] $jpegHdr   = 255, 216
    [Byte[]] $pngHdr    = 137, 80, 78, 71, 13, 10, 26, 10
    [Byte[]] $pdfHdr    = 37, 80, 68, 70, 45
    [Byte[]] $psdHdr    = 56, 66, 80, 83
    [Byte[]] $webpHdr   = 82, 73, 70, 70
    [Byte[]] $tifHdr    = 73, 73, 42, 0
    [Byte[]] $bmpHdr    = 66, 77
    [Byte[]] $gif87aHdr = 71, 73, 70, 56, 55, 97
    [Byte[]] $gif89aHdr = 71, 73, 70, 56, 57, 97
    [Byte[]] $rawHdr    = 73, 73, 42, 0, 16, 67, 82

    [Byte[][]] $HeaderList = @($jpegHdr, $pngHdr, $pdfHdr, $psdHdr, $webpHdr, $tifHdr, $bmpHdr, $gif87aHdr, $gif89aHdr, $rawHdr)

    [System.IO.FileInfo[]] $Images = @(Get-ChildItem "$env:HOMEDRIVE" -Recurse | ?{ChkPerm $_} | ?{IsImage $_})

    if(!Test-Path "$global:OUTPUT_DIR\Images") {
        Search-And-Add-Log-Entry $FAIL_LOG "Image output directory does not exist and images were not copied"
        return $false
    }

    $Images.ForEach({
        $_.CopyTo("$global:OUTPUT_DIR\Images\$($_.Name)") | Out-Null
    })

    Search-And-Add-Log-Entry $SUCCESS_LOG "Image Scan completed successfully"
    return $true
}

# Checks the passed in file to see if the executing user has permissions to read the file
function ChkPerm($File) {
    # Initialize read bits
    $ReadVal = [System.Security.AccessControl.FileSystemRights]::Read -as [int]

    # Create array of Access Rules which have read permissions
    $AccessArray = $File.GetAccessControl().Access
    $CanRead = $AccessArray | ?{($_.FileSystemRights -band $ReadVal) -eq $ReadVal}

    # Create array of NTAccounts which have read permissions
    $CanRead = $CanRead.IdentityReference.Value
    # Grab user and user's groups NTAccounts
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Translate([System.Security.Principal.NTAccount]).Value
    $Groups = [System.Security.Principal.WindowsIdentity]::GetCurrent().Groups.Translate([System.Security.Principal.NTAccount]).Value

    # Combine the user and user's groups NTAccounts into one array
    # And do an intersection operation between the NTAccounts which
    # have read permissions and the NTAccounts tied to the user.
    # Resultant array is the intersection
    $Shared = @(Compare-Object $CanRead $Groups -PassThru -IncludeEqual -ExcludeDifferent)
    $Shared += @(Compare-Object $CanRead $User -PassThru -IncludeEqual -ExcludeDifferent)

    # Check if user NTAccount or user's group NTAccounts have read permissions
    if($Shared.Count -ne 0) {
        #Write-Host "User has read permissions."
        return $true
    } else {
        #Write-Host "User does not have read permissions."
        return $false
    }

}

# Checks to see if the file passed in is an image
function IsImage($File) {
    if($File -isnot [System.IO.FileInfo]) {
        return $false
    }
    if($File.Length -lt 5KB) {
        #Write-Host "File smaller than 5KB." 
        return $false
    }
    if($File.Length -gt 2GB) {
        #Write-Host "File greater than 2GB."
        return $false
    }

    $FileHeader = Get-Content -Path $File.FullName -Encoding Byte -ReadCount 0 -TotalCount 8
    $HeaderList.ForEach({
        if(!(Compare-Object $FileHeader[0..($_.Length-1)] $_ -SyncWindow 0)) {
            return $true
        }
    })
    return $false
}