function packet-capture-start
{	
	$output = ".\Output\packet-capture.etl"
	try
	{
		netsh trace start scenario=NetConnection capture=yes report=yes persistent=no maxsize=1024 correlation=no traceFile=$output
		Search-And-Add-Log-Entry $SUCCESS_LOG "PhysicalMemory-Image"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "PhysicalMemory-Image"
	}
}

function packet-capture-stop
{
	netsh trace stop
}