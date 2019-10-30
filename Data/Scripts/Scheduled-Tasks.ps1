function Scheduled-Tasks {
  #Copy all directories in \Task and copy all files with extension .xml 
  Copy-Item C:\Windows\System32\Tasks -Filter *.xml -Destination $global:OUTPUT_DIR\Tasks -Recurse
  
  #Clean up all empty directories that were copied
  $clean="$global:OUTPUT_DIR\Tasks"
  
  do {
    $dirs = gci $clean -directory -recurse | Where { (gci $_.fullName).count -eq 0 } | select -expandproperty FullName
    $dirs | Foreach-Object { Remove-Item $_ }
  } while ($dirs.count -gt 0)
}