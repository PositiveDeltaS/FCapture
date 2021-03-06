function Active-Processes
{
    $filename = "ActiveProcesses.txt"
    $saveLocation = "$global:OUTPUT_DIR\$filename"

    $success = Active-Processes-Helper $saveLocation

	if(!$success)
	{
		Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create " + $fileName)
        return $false
	}
	else
	{
		Search-And-Add-Log-Entry $SUCCESS_LOG ("Created " + $fileName)
        return $true
	}
}

function Active-Processes-Helper([string]$saveLocation)
{
	if(Test-Path $saveLocation)
	{
		$debugMSG = $saveLocation + " already exists"
		Add-Log-Entry $DEBUG_LOG $debugMSG
	}

	Get-Process | Out-File $saveLocation
	$success = Test-Path $saveLocation

	return $success
}
