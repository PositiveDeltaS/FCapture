function Putty {
	$Putty = "$PSScriptRoot\..\Tools\Putty\putty.exe"

	$run = $Putty
	try 
	{
		iex $run 
		Search-And-Add-Log-Entry $SUCCESS_LOG "Putty"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "Putty"
	}
}