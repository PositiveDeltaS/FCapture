
function Get-Recycle-Bin {

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
# This line is outside of the function so it's being called immediately upon starting the program and causing errors
#Get-Recycle-Bin 'C:\$Recycle.Bin\*' "$global:OUTPUT_DIR\RecycleBinFiles" | Out-File "$global:OUTPUT_DIR\Recyclebincontents.txt"
