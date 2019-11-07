
function Browser-Cache-Chrome{

	$cachePathList = Resolve-Path "$env:HOMEDRIVE\Users\*\AppData\Local\Google\Chrome\User Data\Default\Cache" | Select -ExpandProperty Path

	
	ForEach($cachePath in $cachePathList)
    {
        # Make a path to save output
        # Maintain/copy hierarchy because it's simple and straight-forward
        $unqualifiedPath = Split-Path -Path (Split-Path -Path $cachePath -NoQualifier) -Parent
        $completeOutPath   = "$global:OUTPUT_DIR\Cache\Chrome$unqualifiedPath"

        try
        { 
            New-Item -Path $completeOutPath -ItemType Directory
            Copy-Item $cachePath -Destination $completeOutPath -Recurse
            Search-And-Add-Log-Entry $SUCCESS_LOG "Copied chrome cache directories/files at $cachePath"
        }
        catch
        { 
            Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy chrome cache directories/files at $cachePath"
        }
    }
	
}