function Browser-History-Chrome($path) {

$historyPathList = Resolve-Path "$env:HOMEDRIVE\Users\*\AppData\Local\Google\Chrome\User Data\Default\History" | Select -ExpandProperty Path


ForEach($historyPath in $historyPathList)
    {
        # Make a path to save output
        # Maintain/copy hierarchy because it's simple and straight-forward
        $unqualifiedPath = Split-Path -Path (Split-Path -Path $historyPath -NoQualifier) -Parent
        $completeOutPath   = "$global:OUTPUT_DIR\History\Chrome$unqualifiedPath"

        try
        { 
            New-Item -Path $completeOutPath -ItemType Directory
            Copy-Item $historyPath -Destination $completeOutPath -Recurse
            Search-And-Add-Log-Entry $SUCCESS_LOG "Copied chrome history directories/files at $historyPath"
        }
        catch
        { 
            Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy chrome history directories/files at $historyPath"
        }
    }
}