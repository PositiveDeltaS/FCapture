function Jump-List
{
    $jumpListPaths = Resolve-Path "$env:HOMEDRIVE\Users\*\AppData\Roaming\Microsoft\Windows\Recent" | Select -ExpandProperty Path
    
    ForEach($jumpListPath in $jumpListPaths)
    {
        # Make a path to save output
        # Maintain/copy hierarchy because it's simple and straight-forward
        $unqualifiedJLPath = Split-Path -Path (Split-Path -Path $jumpListPath -NoQualifier) -Parent
        $completeOutPath   = "$global:OUTPUT_DIR\JumpLists$unqualifiedJLPath"

        try
        { 
            New-Item -Path $completeOutPath -ItemType Directory
            Copy-Item $jumpListPath -Destination $completeOutPath -Recurse
            Search-And-Add-Log-Entry $SUCCESS_LOG "Copied Jump List directories/files at $jumpListPath"
        }
        catch
        { 
            Search-And-Add-Log-Entry $FAIL_LOG "Failed to copy Jump List directories/files at $jumpListPath"
        }
    }
}