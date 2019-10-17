function PhysicalMemory-Image {
	$winPMem = ".\Tools\WinPmem\winpmem_v3.3.rc3.exe"
	$outputFile = " -o " + $OUTPUT_DIR + "physical-memory-image.raw"
	$options = " --format raw" 

	$run = $winPMem + $outputFile + $options
	
	try 
	{
		iex $run 
		Search-And-Add-Log-Entry $SUCCESS_LOG "PhysicalMemory-Image"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "PhysicalMemory-Image"
	}
}
