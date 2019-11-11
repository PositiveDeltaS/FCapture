function Start-Recovery-Tool
{
    # Stretch goal: Start a data recovery tool from a binary, or something similar
	$TestDisk = "$PSScriptRoot\..\Tools\TestDisk\testdisk_win.exe"

	$run = $TestDisk
	try 
	{
		Start-Process $run
		Search-And-Add-Log-Entry $SUCCESS_LOG "TestDisk"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "TestDisk"
	}
}