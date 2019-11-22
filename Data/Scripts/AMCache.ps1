function AmCache {
    
   reg export “HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache” $global:OUTPUT_DIR\Amcache.reg
   $outputFilename = Amcache.reg
   if(Test-Path "$global:OUTPUT_DIR\Amcache.reg")
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
 AmCache