<#
Generic function to get browser data for specified users. Copies everything
at specified path to specified outpath.
#>
function Get-Browser-Data($users, [string] $desiredPath, [string] $outPath)
{
#can possibly update to $users | ForEach-Object
	ForEach($_ in $users)
	{
		$unqualifiedPath = Split-Path -Path $_ -NoQualifier
		$completeOutPath   = "$global:OUTPUT_DIR\Browser Data\$unqualifiedPath\$outPath"
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


<#
Returns list of windows user names that have files at the specified path. 
#>
function Get-Desired-User-Profile-Names([string] $pathExtension)
{	
	return Split-Path -Path (Resolve-Path "$env:HOMEDRIVE\Users\*" | 
	Select -ExpandProperty Path) -Leaf | Where {Test-Path "$env:HOMEDRIVE\Users\$_\$pathExtension"}
}



function Browser-Data-Helper([string] $SavePath, [string] $FilePath)
{
	$users = Get-Desired-User-Profile-Names $FilePath
	Get-Browser-Data $users $FilePath $SavePath
}