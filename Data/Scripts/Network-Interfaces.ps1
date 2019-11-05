function Network-Interfaces {
	$File = "$global:OUTPUT_DIR\NetworkInterfaces.txt"

	try
	{	
		# Get List of virtual and physical interfaces
		write-output "Network Interface Summary" | Out-File $File
		write-output "================================================================" | Out-File $File -Append
		Get-NetAdapter -Name "*" -IncludeHidden | Format-Table -Property "Name", "Status", "InterfaceDescription", "InterfaceName" | Out-File $File -Append 
		
		# Get Ip Adresses
		ipconfig /all | Out-File $File -Append
		write-output "`n`n" | Out-File $File -Append

		# Get detailed interface properties
		write-output "Network Interface Detailed Properties" | Out-File $File -Append
		write-output "================================================================" | Out-File $File -Append
		Get-NetAdapter -Name "*" -IncludeHidden | ForEach-Object {
			write-output "--------------------------------" | Out-File $File -Append -NoNewLine
			write-output($_.Name)  | Out-File $File -Append
			Write-output ($_ | Format-List -Property "*" | Out-String)  | Out-File $File -Append	
		}
		Search-And-Add-Log-Entry $SUCCESS_LOG "Network-Interfaces"
	}
	catch
	{
		if(Test-Path -Path $File){rm $File}
		Search-And-Add-Log-Entry $SUCCESS_LOG "Network-Interfaces"
	}
}