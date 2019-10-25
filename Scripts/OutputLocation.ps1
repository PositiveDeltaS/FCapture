

<#
********NOTE!**********
When writing to the output directory, for text 
and csv the filenames will likely need to be appended
to the output_dir.
#>


<#
Creates a file browser window for the user to select the global
output destination. Checks if destination is on a removable drive
and fails to change output destination if not.
#>
function Output-Location
{
	#Create our file browser to select the output destination
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        SelectedPath = $global:OUTPUT_DIR
    }
    [void]$FolderBrowser.ShowDialog()
	$selectedOutputPath = $FolderBrowser.SelectedPath
	
	#Make sure the selected path is useable
	if(Assert-Path-Is-On-Removable-Device $selectedOutputPath)
	{
        # Set global directory location for other scripts to use
        $global:OUTPUT_DIR = $selectedOutputPath

		Write-Host "Successfully selected removable output destination"
		
		$outputLogMsg = "Selected Output Directory : $OUTPUT_DIR"
		Search-And-Add-Log-Entry $SUCCESS_LOG $outputLogMsg
    
        # Update Output Directory text in GUI
        $OutDirTextBox.text = $OUTPUT_DIR
	}
	else
    {
        Write-Host "Selected output destination was on local machine"
		Add-Log-Entry $FAIL_LOG "Failed to change output directory"
	}
}

#insert removable media to help test this

<#
Asserts that the file path is located on a removable device.
Takes drive name from selected path, then compares it to the
array of removable drive names to ensure that the selected
path is located on a removable device.
#>
function Assert-Path-Is-On-Removable-Device([string]$filePath)
{
	# -Qualifier removes everything except drive name from string
	$pathRoot = Split-Path -Path $filePath -Qualifier # Example: "E:\1\2" -> "E:"
    # Get an array of every removable drive, then just take the Name property for each drive
	$removableDrives = ([System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -eq "Removable" }).Name
    
    # If there are no removable drive, just fail
    if($removableDrives.Count -eq 0)
    {
        Write-Host "There are no removable drives available"
        return $false
    }

	# Check that the chosen drive name matches the name of a removable drive
    # Trim the '\' off the drive names so that -match will work
	$matched = $removableDrives.Trim("\") -match $pathRoot

    # -match returns $pathRoot if it was a good path and "" otherwise, so we compare to "" to get a bool
    $success = "" -ne $matched

	return $success
}


<#
Simple output test, saves text file to 
specified location and tests to ensure that 
the text file is found there.
#>
function Test-Output-Location()
{

	$testSTR = "This is a test"
	
	$saveLocation = $OUTPUT_DIR + "saveTest.txt"
	
	
	Write-Host $saveLocation
	
	if(Test-Path $OUTPUT_DIR)
	{
		echo $testSTR | Out-File $saveLocation
	}
	else
	{
		Write-Host "Didn't find output path to test" 
	}
	if(Test-Path $saveLocation)
	{
		Write-Host "Successful output location test"
	}
	else
	{
		Write-Host "Failed output location test"
	}


}