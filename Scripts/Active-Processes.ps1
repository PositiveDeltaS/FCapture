function Active-Processes
{
    $filename = "ActiveProcesses.txt"
    $saveLocation = $OUTPUT_DIR + $fileName

    $success = Active-Processes-Helper $saveLocation
	
	if(!$success)
	{	
		Search-And-Add-Log-Entry $FAIL_LOG ("Created " + $fileName)
	}
	else
	{
		Search-And-Add-Log-Entry $SUCCESS_LOG ("Created " + $fileName)
	}
}

function Active-Processes-Helper([string]$saveLocation)
{	
	if(Test-Path $saveLocation)
	{
		$debugMSG = $saveLocation + " already exists"
		Add-Log-Entry $DEBUG_LOG $debugMSG
	}
	
	Get-Process | Out-File -filepath $saveLocation
	$success = Test-Path $saveLocation

	return $success
}