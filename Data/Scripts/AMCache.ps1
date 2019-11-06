function AmCache {
    
   $path = "$global:OUTPUT_DIR"

     if (-not (Test-Path -Path $path)) {
        throw "Output directory doesn't exist"
     }
     else {
      reg export “HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache” $path\Amcache.reg
     }
 }