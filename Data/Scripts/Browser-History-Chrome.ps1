function Browser-History-Chrome {

	#get all users 
	$userPathList = Resolve-Path "$env:HOMEDRIVE\Users\*" | Select -ExpandProperty Path

	Write-Host $userPathList

	ForEach($userPath in $userPathList)
	{
		$unqualifiedPath = Split-Path -Path $userPath -NoQualifier
		$completeOutPath   = "$global:OUTPUT_DIR\BrowserData$unqualifiedPath\Chrome"
		$historyFilePath = $userPath + "\AppData\Local\Google\Chrome\User Data\Default\History"
		$cacheFilePath = $userPath + "\AppData\Local\Google\Chrome\User Data\Default\Cache"
		
		<#
		Write-Host "UnqualifiedPath: " $unqualifiedPath
		Write-Host "HistoryFilePath: " $historyPath
		Write-Host "CompleteOutPath: " $completeOutPath
		#>
		try
		{ 
			New-Item -Path $completeOutPath -ItemType Directory
			Copy-Item $historyFilePath -Destination $completeOutPath -Recurse
			Copy-Item $cacheFilePath -Destination $completeOutPath -Recurse
			Search-And-Add-Log-Entry $SUCCESS_LOG "Copied Chrome history files at $historyPath"
		}
		catch
		{ 
			Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy Chrome history files at $historyPath"
		}
	}
}