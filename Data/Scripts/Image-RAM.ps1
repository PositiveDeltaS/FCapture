function PhysicalMemory-Image {
	$winPMem = "$PSScriptRoot\..\Tools\WinPmem\winpmem_v3.3.rc3.exe"
	$outputFile =  "\physical-memory-image.aff4"
	$options = " -o " + $global:OUTPUT_DIR + $outputFile

  $run = $winPMem + $options
	try 
	{
		iex $run 
		Search-And-Add-Log-Entry $SUCCESS_LOG "PhysicalMemory-Image"
		return $true
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "PhysicalMemory-Image"
		return $fail
	}
}
