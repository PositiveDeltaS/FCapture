function Event-Logs {

    Get-WinEvent -ListLog * | Out-File "$global:OUTPUT_DIR\EventLogs.txt"
    $outputFilename = "EventLogs.txt"
    if(Test-Path "$global:OUTPUT_DIR\EventLogs.txt")
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