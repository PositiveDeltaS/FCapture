function Swap-Files {
	$winPMem = "$PSScriptRoot\..\Tools\WinPmem\winpmem_v3.3.rc3.exe"
	
	$outputFile =  "\physical-memory-image-with-swap-files.aff4"
	$pageFiles = ""
	
	try
	{
		Get-WmiObject Win32_PageFileusage | Select-Object Name | ForEach-Object -Process{$pageFiles = $pageFiles + " -p " + $_.Name}
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "PhysicalMemory-Image: Error when collecting pagefile locations"
		return $false
	}
	
	$outOptions = " -o " + $global:OUTPUT_DIR + $outputFile
	$run = $winPMem + $outOptions + $pageFiles
	
	try 
	{
		iex $run 
		Search-And-Add-Log-Entry $SUCCESS_LOG "PhysicalMemory-Image"
		return $true
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "PhysicalMemory-Image"
		return $false
	}
}
