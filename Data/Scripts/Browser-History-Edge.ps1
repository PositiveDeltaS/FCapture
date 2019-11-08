function Browser-History-Edge{

#https://www.foxtonforensics.com/browser-history-examiner/microsoft-edge-history-location
#https://community.spiceworks.com/topic/2180388-edge-browsing-history-location

	$userPathList = Resolve-Path "$env:HOMEDRIVE\Users\*" | Select -ExpandProperty Path

	Write-Host $userPathList

	ForEach($userPath in $userPathList)
	{
		$unqualifiedPath = Split-Path -Path $userPath -NoQualifier
		$completeOutPath   = "$global:OUTPUT_DIR\BrowserData$unqualifiedPath\Microsoft Edge"
		$historyFilePath = $userPath + "\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\User\Default"
		
		<#
		Write-Host "UnqualifiedPath: " $unqualifiedPath
		Write-Host "HistoryFilePath: " $historyPath
		Write-Host "CompleteOutPath: " $completeOutPath
		#>
		try
		{ 
			New-Item -Path $completeOutPath -ItemType Directory
			Copy-Item $historyFilePath -Destination $completeOutPath -Recurse
			Search-And-Add-Log-Entry $SUCCESS_LOG "Copied Microsoft Edge history files at $historyPath"
		}
		catch
		{ 
			Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy Microsoft Edge history files at $historyPath"
		}
	}
}