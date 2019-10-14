

<#
When writing to the output directory, for text 
and csv the filenames will likely need to be appended
to the output_dir.
#>

function Output-Location
{
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        SelectedPath = $global:OUTPUT_DIR
    }
    [void]$FolderBrowser.ShowDialog()
	$selectedOutputPath = $FolderBrowser.SelectedPath
	
	if(Assert-Path-Is-Removeable-Device $selectedOutputPath)
	{
		# Folder browser selection doesn't add '\', so we add it manually
		Write-Host "Successfully selected removeable output destination"
		if ($selectedOutputPath -notmatch '.+?\\$') # Avoid adding extra backslashes
		{
			$global:OUTPUT_DIR = $selectedOutputPath + "\"
		}
		
		$global:OUTPUT_DIR = $selectedOutputPath
		$outputLogMsg = "Selected Output Directory : " + $OUTPUT_DIR
		Search-And-Add-Log-Entry $SUCCESS_LOG $outputLogMsg
	}
	else{
		Add-Log-Entry $FAIL_LOG "Failed to change output directory"
	}
}



#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/split-path?view=powershell-6
#https://community.idera.com/database-tools/powershell/ask_the_experts/f/learn_powershell_from_don_jones-24/20609/test-path-for-folder-on-removable-drive-root
#$testFile = [regex]::Escape($filePath)
#insert removeable media to help test this 
function Assert-Path-Is-Removeable-Device([string]$filePath)
{
	Write-Host "Selected Path: ", $filePath
	$success = $false
	
	#qualifier is the drive use -NoQualifier to remove drive name w/ split 
	$trimmedPath = Split-Path -Path $filePath -NoQualifier
	$removabledrives = @([System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -eq "Removable" })

	if($removabledrives.Count -eq 0)
	{
		Write-Host "No removeable media"
	}
	else
	{
		Write-Host "External Drives Found: ", $removabledrives
		$removabledrives | ForEach-Object {
			$testPath = $_.Name.Trim("\") + $trimmedPath #remove "\" at end of string 
			$out = [string]::Format("Testing Drive : {0}   Path : {1} ", $_.Name, $testPath)
			Write-Host $out
			if(Test-Path $testPath)
			{
				Write-Host "Found path : ", $testPath
				$success = $true
			}
		}
	}
	return $success
}



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
		Write-Host "Didn't find path to testt" 
	
	}


}