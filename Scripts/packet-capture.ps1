function Packet-Capture-Start
{	
	$output = ".\Output\packet-capture.etl"
	try
	{
		netsh trace start scenario=NetConnection capture=yes report=yes persistent=no maxsize=1024 correlation=no traceFile=$output
		Search-And-Add-Log-Entry $SUCCESS_LOG "PhysicalMemory-Image"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "Packet-Capture-Start"
	}
}

function Packet-Capture-Stop
{
	try
	{
		netsh trace stop
		Search-And-Add-Log-Entry $SUCCESS_LOG "Packet-Capture-Stop"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "Packet-Capture-Stop"
	}
}