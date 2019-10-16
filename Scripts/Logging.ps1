function Hello-World { 
	$saveText = "Hello World!"
	$fileName = "HelloWorld.txt"
	$saveLocation = ".\" + $fileName

	$success = Hello-World-Helper $saveText $saveLocation
	
	if(!$success)
	{	
		Search-And-Add-Log-Entry $FAIL_LOG $fileName
	}
	else
	{
		Search-And-Add-Log-Entry $SUCCESS_LOG $fileName
	}
}


function Hello-World-Helper([string]$saveText, [string]$saveLocation)
{
	<#For future implementations, we need to be waiting until the process finishes
		before checking if the file exists#>
		
	if(Test-Path $saveLocation)
	{
		$debugMSG = $saveLocation + " already exists"
		Add-Log-Entry $DEBUG_LOG $debugMSG
	}
	
	echo $saveText | Out-File $saveLocation
	$success = Test-Path $saveLocation

	return $success
}


#Add message to specified log w/ date, typically a filename
function Add-Log-Entry([string]$logFilePath, [string]$msgToLog)
{
	$datedMessage = "{0} - {1}" -f (Get-Date), $msgToLog
	
	#check if log exists
	if(!(Test-Path $logFilePath))
	{
		#creates new log file w/ logfilepath with str as first entry
		echo $datedMessage | Out-File $logFilePath
	}
	else
	{
		#Adds str to newline
		Add-Content $logFilePath $datedMessage
	}
}


#Check if entry is in the specified log file 
function Search-For-Log-Entry([string]$logFilePath, [string]$entryToSearch)
{
	#if the log exists
	if((Test-Path $logFilePath))
	{
		#iterate through all lines in file and check if match 
		foreach($logEntry in Get-Content $logFilePath)
		{
		#Match uses regex to str match 
			if($logEntry -Match $entryToSearch)
			{
				return 1
			} 
		}
	}
	else
	{
		$debugMSG = "Log file " + $logFilePath + " does not exist. Search Aborted."
		Add-Log-Entry $DEBUG_LOG $debugMSG
	}
	return 0
}


#Wrapper to check if log entry already exists in the specified log and appends it if not
function Search-And-Add-Log-Entry([string]$logFilePath, [string]$entryToSearch)
{
	#Add to log if not already in log
	if(!(Search-For-Log-Entry $logFilePath $entryToSearch))
	{
		Add-Log-Entry $logFilePath $entryToSearch
	}
	else
	{
		$debugMSG = "File " + $entryToSearch + " already logged in " + $logFilePath
		Add-Log-Entry $DEBUG_LOG $debugMSG
	}
}