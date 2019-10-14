function Copy-Contents-To-Output-Directory([string]$source, [string]$destination)
{

	#First check if source and destination end with "\"
	#if not then
	$source = $source + "\*"
	$destination = $destination + "\"
	
	#else, source will only need a "*" appended, not a "\*" appended
	
	Write-Host "Copying contents..."
	Write-Host "Source : ", $source
	Write-Host "DEST : ", $destination
	
	#MAY NEED TO TRIM DESTINATION OF END "\"
	#Copy-Item -Path $source -Destination $destination -Recurse
	Move-Item -Path $source -Destination $destination
}