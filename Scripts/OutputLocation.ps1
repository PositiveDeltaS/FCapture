

<#
********NOTE!**********
When writing to the output directory, for text 
and csv the filenames will likely need to be appended
to the output_dir.
#>


<#
Creates a file browser window for the user to select the global
output destination. Checks if destination is on a removeable drive
and fails to change output destiantion if not.
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
	if(Assert-Path-Is-On-Removeable-Device $selectedOutputPath)
	{
        $global:OUTPUT_DIR = $selectedOutputPath

		# Folder browser selection doesn't add '\', so we add it manually
		Write-Host "Successfully selected removeable output destination"
		if ($OUTPUT_DIR -notmatch '.+?\\$') # Avoid adding extra backslashes
		{
			$global:OUTPUT_DIR = $global:OUTPUT_DIR + "\"
		}

		$outputLogMsg = "Selected Output Directory : " + $OUTPUT_DIR
		Search-And-Add-Log-Entry $SUCCESS_LOG $outputLogMsg
    
        # Update Output Directory Textbox in GUI
        $OutputDirTextBox.text = $OUTPUT_DIR
	}
	else
    {
		Add-Log-Entry $FAIL_LOG "Failed to change output directory"
	}
}


#insert removeable media to help test this

<#
Asserts that the file path is located on a removeable device.
Removes drive name from selected path, then prepends each removeable 
drive name found and tests that path to ensure that the selected path is 
found on a removeable device.
#>
function Assert-Path-Is-On-Removeable-Device([string]$filePath)
{
	$success = $false
	
	#-NoQualifier removes drive name from string
	$trimmedPath = Split-Path -Path $filePath -NoQualifier
	$removabledrives = @([System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -eq "Removable" })

	#Check each removeable drive for the path
	$removabledrives | ForEach-Object {
		#Prepend the drive name to the trimmed path
		$testPath = $_.Name.Trim("\") + $trimmedPath #remove "\" at end of string 
		$out = [string]::Format("Testing Drive : {0}   Path : {1} ", $_.Name, $testPath)
		Write-Host $out
		if(Test-Path $testPath)
		{
			Write-Host "Found path : ", $testPath
			$success = $true
		}
	}
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