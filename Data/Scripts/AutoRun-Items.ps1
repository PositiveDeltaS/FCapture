function AutoRun-Items {
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User | Format-List | Out-File $global:OUTPUT_DIR\autorun-items.txt
}