function Scheduled-Tasks {
  if(Test-Path -Path "$global:OUTPUT_DIR\Tasks"){
    Copy-Item C:\Windows\System32\Tasks -Filter *.xml -Destination $global:OUTPUT_DIR\Tasks -Recurse
  } else{
    New-Item -ItemType directory -Path $global:OUTPUT_DIR\Tasks
  }
}