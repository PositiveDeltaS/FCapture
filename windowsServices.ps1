

function Windows-Services
{
    $filename = "RunningServices.txt"
    $saveLocation = $OUTPUT_DIR + $fileName

    $success = Windows-Services-Helper $saveLocation
	
	if(!$success)
	{	
		Search-And-Add-Log-Entry $FAIL_LOG ("Created " + $fileName)
	}
	else
	{
		Search-And-Add-Log-Entry $SUCCESS_LOG ("Created " + $fileName)
	}
}

function Windows-Services-Helper([string]$saveLocation)
{	
	if(Test-Path $saveLocation)
	{
		$debugMSG = $saveLocation + " already exists"
		Add-Log-Entry $DEBUG_LOG $debugMSG
	}
	
	Get-Service | Where-Object {$_.Status -eq "Running"} | Out-File -filepath $saveLocation
	$success = Test-Path $saveLocation

	return $success
}