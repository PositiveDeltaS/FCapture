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
		if ($selectedOutputPath -notmatch '.+?\\$') # Avoid adding extra backslashes
		{
			$global:OUTPUT_DIR = $selectedOutputPath + "\"
		}
		
		$global:OUTPUT_DIR = $selectedOutputPath
		$success = $OUTPUT_DIR -eq $selectedOutputPath
		
		Add-Log-Entry $DEBUG_LOG $OUTPUT_DIR
		
		if(!$success)
		{	
			Search-And-Add-Log-Entry $FAIL_LOG "Tried to change output directory"
		}
		else
		{
			$completeStr = "Changed output directory to " + $OUTPUT_DIR
			Search-And-Add-Log-Entry $SUCCESS_LOG $completeStr
		}
	}
}


function Output-Location-Helper()
{


}



#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/split-path?view=powershell-6
#https://community.idera.com/database-tools/powershell/ask_the_experts/f/learn_powershell_from_don_jones-24/20609/test-path-for-folder-on-removable-drive-root

#insert removeable media to help test this 
function Assert-Path-Is-Removeable-Device([string]$filePath)
{
	Write-Host "Selected Path: ", $filePath
	$success = $false
	#qualifier is the drive use -NoQualifier to remove drive name w/ split 
	$fp = Split-Path -Path $filePath -NoQualifier

	Write-Host "Trimmed Path: ", $fp

	#$testFile = [regex]::Escape($filePath)

	$removabledrives = @([System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -eq "Removable" })

	if($removabledrives.Count -eq 0){
		Write-Host "No removeable media"
	}
	else{
		Write-Host "External Drive Count: " ,$removabledrives.Count
		Write-Host "External Drives: ", $removabledrives
		$removabledrives | ForEach-Object {
			#Removes "\" at the beginning of drive name string before prepending
			$testPath = $_.Name.Trim("\") + $fp
			Write-Host "Path to test: ", $testPath
			if(Test-Path $testPath)
			{
				Write-Host "SUCCESS"
				$success = $true
			}
		}
		
		if($success -eq $false){
		Write-Host "Failed to set directory output, not removeable"
		}
		else{
		Write-Host "Output directory select successful"

		}

	}
	
	return $success

}


function Assert-Path-Helper()
{


}