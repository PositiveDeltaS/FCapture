# Saves the current state of F-Capture in an xml file to load later
function Save-User-Profile {
    $Name = $ProfileDropdown.Text
    if(!$Name -or $Name.Equals("")) {
        Search-And-Add-Log-Entry $FAIL_LOG "User attempted to save a profile with an empty name"
        return
    }
    $State = [ordered]@{}
    Update-State $MainForm $State ""
    $State | Export-Clixml "$PSScriptRoot\..\Profiles\$Name.xml"
    Search-And-Add-Log-Entry $SUCESS_LOG "User successfully saved the profile: $Name.xml"

}

# Loads F-Capture state from saved xml files
function Load-User-Profile {
    # Check if user entered a name to load
    $Name = $ProfileDropdown.Text
    if(!$Name -or $Name.Equals("")) {
        Search-And-Add-Log-Entry $FAIL_LOG "User attempted to load a profile with an empty name"
        return
    }

    # Check if any profiles exist in directory
    $ProfileDir = Get-ChildItem -Path "$PSScriptRoot\..\Profiles\"
    if(!$ProfileDir) {
        Search-And-Add-Log-Entry $FAIL_LOG "User attempted to load a profile when there are none"
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
        Search-And-Add-Log-Entry $FAIL_LOG "Profile that usr attempted to load was not found"
        return
    }
    Search-And-Add-Log-Entry $SUCCESS_LOG "User successfully loaded the profile: $Name.xml"
}

# Updates the profile dropdown list on the advanced menu
function Update-DD {
    $ProfileDropdown.Items.Clear()
    $ProfileDir = Get-ChildItem -Path "$PSScriptRoot\..\Profiles\"
    if(!$ProfileDir) {
        Search-And-Add-Log-Entry $FAIL_LOG "Advanced Menu DropDown Menu attempted to update"
        return
    }
    [array]$NameData = $ProfileDir.Name
    foreach($Name in $NameData) {
        $ProfileDropdown.Items.Add($Name.Remove($Name.Length-4)) | Out-Null
    }
    Search-And-Add-Log-Entry $SUCCESS_LOG "Advanced Menu DropDown Menu successfully updated"
}