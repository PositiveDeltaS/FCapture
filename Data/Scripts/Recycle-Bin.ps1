
function Get-Recycle-Bin {
#  ---Temporary function---

    # This is a temporary function for use until the original function is bugfixed
    $RBPath  = "$env:HOMEDRIVE\`$Recycle.Bin"
    $outPath = "$global:OUTPUT_DIR\RecycleBinFiles"

    Copy-Item -Path $RBPath -Destination $outPath -Recurse -Force -ErrorAction SilentlyContinue

<# ---Original function---

 [CmdletBinding()]
    param ( [string]$path, [string]$destination)

 if (-not (Test-Path -Path $path)) {
   throw "File not found: $path" 
   }

 $sourcefile = Split-Path -Path $path -Leaf
 $destinationfile = Join-Path -Path $destination -ChildPath $sourcefile
 $b4hash = Get-FileHash -Path $path

 try {
    Copy-Item -Path $path -Destination $destination -Recurse -Force -ErrorAction Stop
 }
 catch {
   throw "File copy failed"
 }
 finally {
   $afhash = Get-FileHash -Path $destinationfile
   if ($afhash.Hash -ne $b4hash.Hash) {
      throw "File corrupted during copy"
   }
   else {
     Write-Information -MessageData "File copied successfully" -InformationAction Continue
   }
 }
} 
#>
