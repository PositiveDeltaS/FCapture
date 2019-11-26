function User-Accounts { 

    Get-LocalUser | Select * | Out-File "$global:OUTPUT_DIR\Userlist.txt" 
    
    $outputFilename = "Userlist.txt"
    if(Test-Path "$global:OUTPUT_DIR\Userlist.txt")
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
