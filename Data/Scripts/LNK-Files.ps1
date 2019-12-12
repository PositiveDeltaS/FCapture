function LNK {
     Try{
    #Copy all directories in \Task and copy all files with extension .xml 
    Copy-Item C:\ProgramData\Microsoft\Windows\Start Menu\Programs -Destination $global:OUTPUT_DIR\ -Recurse
  
    #Clean up all empty directories that were copied
    $clean="$global:OUTPUT_DIR\LNK"
  
    do {
      $dirs = gci $clean -directory -recurse | Where { (gci $_.fullName).count -eq 0 } | select -expandproperty FullName
      $dirs | Foreach-Object { Remove-Item $_ }
    } while ($dirs.count -gt 0)
    
    # Log success
    Search-And-Add-Log-Entry $SUCCESS_LOG ("Created $OUTPUT_DIR\LNK directory successfully")
        return $true
  } # End of try block
  Catch {
    # Log failure 
    Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create $OUTPUT_DIR\LNK directory")
        return $false
  } # End of catch block
}