function Peripheral-Devices 
{
	Get-PnPDevice | Export-Csv -Path .\peripheral_devices.csv 
}