function Screenshot {
  param([Switch]$OfWindow)
    
  begin {
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
    
    $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | 
    Where-Object { $_.FormatDescription -eq "JPEG" }
  } # End of begin {}

  process {
    $NumActiveWindow = Count-Windows
    
    # Screencapture full screen once
    Start-Sleep -Milliseconds 50
    [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")
    Start-Sleep -Milliseconds 50
    
    Save-Screenshot
    
    (Get-Process | Where {$_.MainWindowTitle}).MainWindowTitle | % {
      $winmax = (New-Object -ComObject wscript.shell)
      $wshell.AppActivate($_)
      sleep 1
      $wshell.SendKeys("% x")
      sleep 1
    } | Out-Null
    
    [Windows.Forms.Sendkeys]::Send("%{ESC}")
    start-sleep -Seconds 2
    
    # Cycle through active windows and screenshot them
    for($i = 0;$i -le $NumActiveWindow; $i++){

      Start-Sleep -Milliseconds 250
      [Windows.Forms.Sendkeys]::SendWait("%{PrtSc}")
      Start-Sleep -Milliseconds 50
      #start-sleep -Seconds 2 
      Save-Screenshot
      
      [Windows.Forms.Sendkeys]::Send("%{ESC}")
      start-sleep -Seconds 2
    } # End of for loop {}
    
    # Minimize all the Windows
    $shell = New-Object -ComObject "Shell.Application"
    $shell.MinimizeAll()
    start-sleep -Seconds 2
    
    # Screencapture desktop once
    Start-Sleep -Milliseconds 250
    [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")
    Start-Sleep -Milliseconds 50
    
    Save-Screenshot
    
    # get your screen back
    $shell.undominimizeall()
  } # End of process {}
} # End of Screenshot {}

function Count-Windows{
  $NumOtherWindows = (Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle).Count
  $NumExplorerWindows = (Get-Process | Where-Object {$_.MainWindowTitle -eq $_.HWND} | Select-Object MainWindowTitle).Count
  
  $WindowSum = $NumOtherWindows + $NumExplorerWindows
  Return $WindowSum
}

function Save-Screenshot{
    $bitmap = [Windows.Forms.Clipboard]::GetImage()    
    $ep = New-Object Drawing.Imaging.EncoderParameters  
    $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)  
    
    $screenCapturePathBase = "$global:OUTPUT_DIR\ScreenCapture"
    $c = 0
    while (Test-Path "${screenCapturePathBase}${c}.jpg") {
      $c++
    }
    $bitmap.Save("${screenCapturePathBase}${c}.jpg", $jpegCodec, $ep)
}