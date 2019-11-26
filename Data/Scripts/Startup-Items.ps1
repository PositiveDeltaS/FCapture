function Startup-Programs {  

    Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Format-List | Out-File "$global:OUTPUT_DIR\StartupPrograms.txt" 
    
    $outputFilename = "StartupPrograms.txt"
    if(Test-Path "$global:OUTPUT_DIR\StartupPrograms.txt")
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created $outputFilename output file successfully")
        return $true
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create $outputFilename output file")
        return $false
    }
 }

    