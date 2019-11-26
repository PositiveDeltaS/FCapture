function Installed-Programs {  

    Get-ItemProperty HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize | Out-File "$global:OUTPUT_DIR\InstalledPrograms.txt"

    $outputFilename = "InstalledPrograms.txt"
    if(Test-Path "$global:OUTPUT_DIR\InstalledPrograms.txt")
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