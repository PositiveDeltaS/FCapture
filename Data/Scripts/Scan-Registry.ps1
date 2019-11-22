function Scan-Registry {
	$RegScanner = "$PSScriptRoot\..\Tools\RegScanner\RegScanner.exe"

	$run = $RegScanner
	try 
	{
		iex $run 
		Search-And-Add-Log-Entry $SUCCESS_LOG "Scan-Registry"
		return $true
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "Scan-Registry"
		return $false
	}
}
