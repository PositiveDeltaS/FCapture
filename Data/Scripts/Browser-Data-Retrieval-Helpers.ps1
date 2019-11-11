function Get-Browser-Data($users, [string] $desiredPath, [string] $outPath)
{
	ForEach($_ in $users)
	{
		$unqualifiedPath = Split-Path -Path $_ -NoQualifier
		$completeOutPath   = "$global:OUTPUT_DIR\BrowserData\$unqualifiedPath\$outPath"
		$filePath = "$env:HOMEDRIVE\Users\$_\$desiredPath"
		
		try
		{ 
			New-Item -Path $completeOutPath -ItemType Directory
			Copy-Item $filePath -Destination $completeOutPath -Recurse
			Search-And-Add-Log-Entry $SUCCESS_LOG "Copied files at $filePath"
		}
		catch
		{ 
			Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy at $filePath"
		}	
	}
}

function Get-Desired-User-Profile-Names([string] $pathExtension)
{	
	return Split-Path -Path (Resolve-Path "$env:HOMEDRIVE\Users\*" | 
	Select -ExpandProperty Path) -Leaf | Where {Test-Path "$env:HOMEDRIVE\Users\$_\$pathExtension"}
}
