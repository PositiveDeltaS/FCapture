function Browser-History-Edge{

#https://www.foxtonforensics.com/browser-history-examiner/microsoft-edge-history-location
#https://community.spiceworks.com/topic/2180388-edge-browsing-history-location

$historyPathList = Resolve-Path "$env:HOMEDRIVE\Users\*\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\AC\MicrosoftEdge\User\Default" | Select -ExpandProperty Path

ForEach($historyPath in $historyPathList)
    {
        # Make a path to save output
        # Maintain/copy hierarchy because it's simple and straight-forward
        $unqualifiedPath = Split-Path -Path (Split-Path -Path $historyPath -NoQualifier) -Parent
        $completeOutPath   = "$global:OUTPUT_DIR\History\Edge$unqualifiedPath"

        try
        { 
            New-Item -Path $completeOutPath -ItemType Directory
            Copy-Item $historyPath -Destination $completeOutPath -Recurse
            Search-And-Add-Log-Entry $SUCCESS_LOG "Copied Microsoft Edge directories/files at $historyPath"
        }
        catch
        { 
            Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy Microsoft Edge directories/files at $historyPath"
        }
    }


}