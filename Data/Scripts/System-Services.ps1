function Windows-Services
{
    $filename = "RunningServices.txt"
    $saveLocation = "$global:OUTPUT_DIR\$filename"

    $success = Windows-Services-Helper $saveLocation

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
