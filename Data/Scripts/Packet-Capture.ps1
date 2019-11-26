function Packet-Capture-Start
{	
	$output = "$global:OUTPUT_DIR\packet-capture.etl"
	try
	{
		netsh trace start scenario=InternetClient,InternetServer,NetConnection capture=yes report=yes persistent=no maxsize=1024 correlation=no traceFile=$output
		Search-And-Add-Log-Entry $SUCCESS_LOG "Packet-Capture-Start"
		return $true
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "Packet-Capture-Start"
		return $false
	}
}

function Packet-Capture-Stop
{
	try
	{
		netsh trace stop
		Search-And-Add-Log-Entry $SUCCESS_LOG "Packet-Capture-Stop"
		return $true
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "Packet-Capture-Stop"
		return $false
	}
}
