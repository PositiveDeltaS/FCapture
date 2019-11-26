function Timezone-Info { 
    
    Get-TimeZone | Out-File "$global:OUTPUT_DIR\Timezone.txt"
    $outputFilename = "Timezone.txt"
    if(Test-Path "$global:OUTPUT_DIR\$outputFilename.*")
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