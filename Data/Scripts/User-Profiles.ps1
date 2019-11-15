function Save-User-Profile {
    $Name = $ProfileDropdown.Text
    if(!$Name -or $Name.Equals("")) {
        Write-Host "Not a valid profile name."
        return
    }
    $State = [ordered]@{}
    Update-State $MainForm $State ""
    $State | Export-Clixml "$PSScriptRoot\..\Profiles\$Name.xml"
}

function Load-User-Profile {
    # Check if user entered a name to load
    $Name = $ProfileDropdown.Text
    if(!$Name -or $Name.Equals("")) {
        Write-Host "Not a valid profile name."
        return
    }

    # Check if any profiles exist in directory
    $ProfileDir = Get-ChildItem -Path "$PSScriptRoot\..\Profiles\"
    if(!$ProfileDir) {
        Write-Host "Profile not found."
        return
    }

    # Remove .xml extension in filename
    $NameList = New-Object System.Collections.ArrayList
    foreach($FileName in $ProfileDir.Name) {
        $NameList.Add($FileName.Remove($FileName.Length-4))
    }

    # Check list of profiles names for a match
    if($NameList -match $Name) { 
        $State = Import-Clixml "$PSScriptRoot\..\Profiles\$Name.xml"
        Set-State $MainForm $State
    } else {
        Write-Host "Profile not found."
        return
    }
}

function Update-DD {
    $ProfileDropdown.Items.Clear()
    $ProfileDir = Get-ChildItem -Path "$PSScriptRoot\..\Profiles\"
    if(!$ProfileDir) {
        return
    }
    [array]$NameData = $ProfileDir.Name
    foreach($Name in $NameData) {
        $ProfileDropdown.Items.Add($Name.Remove($Name.Length-4)) | Out-Null
    }
}