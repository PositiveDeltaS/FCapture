function Peripheral-Devices { 
	Get-PnPDevice | Export-Csv -Path "$global:OUTPUT_DIR\peripheral_devices.csv" 

    if(Test-Path "$global:OUTPUT_DIR\peripheral_devices.csv")
    {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created peripheral_devices.csv output file successfully")
        return $true
    }
    else
    {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create peripheral_devices.csv output file")
        return $false
    }
}
