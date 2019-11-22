# The function of this script is to take
# a screen shot of all windows. This includes
# hidden and minimized windows, and the desktop
# as well.

#------------------------------------------------
# Note: While currently the script can take
# screenshots of current display, and desktop
# well, it has trouble cycling through the 
# accurate number of windows to alt+prt-sc.
#------------------------------------------------

function Screenshot {
  try{
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
    
      # Maximize all hidden processes
      (Get-Process | Where {$_.MainWindowTitle}).MainWindowTitle | % {
        $WShell = (New-Object -ComObject wscript.shell)
        $WShell.AppActivate($_)
        sleep 1
        $WShell.SendKeys("% x")
        sleep 1
      } | Out-Null
    
      # Skip FCapture Screenshot
      [Windows.Forms.Sendkeys]::Send("%{ESC}")
      start-sleep -Seconds 2
    
      # Cycle through active windows and screenshot them
      for($i = 0;$i -le $NumActiveWindow; $i++){

        # Screenshot
        Start-Sleep -Milliseconds 250
        [Windows.Forms.Sendkeys]::SendWait("%{PrtSc}")
        Start-Sleep -Milliseconds 50
        #start-sleep -Seconds 2 
        Save-Screenshot
      
        # Got to next window
        [Windows.Forms.Sendkeys]::Send("%{ESC}")
        start-sleep -Seconds 2
      } # End of for loop {}
    
      # Minimize all the Windows
      $Shell = New-Object -ComObject "Shell.Application"
      $Shell.MinimizeAll()
      start-sleep -Seconds 2
    
      # Screencapture desktop once
      Start-Sleep -Milliseconds 250
      [Windows.Forms.Sendkeys]::SendWait("{PrtSc}")
      Start-Sleep -Milliseconds 50
    
      Save-Screenshot
    
      # Undo minimize
      $Shell.UndoMinimizeAll()
      Search-And-Add-Log-Entry $SUCCESS_LOG "Successfully ran Screenshot-Windows Function"
      return $true
    } # End of process {}
  } # End of Try{} block
  catch{
    Search-And-Add-Log-Entry $FAIL_LOG "Failed to run Screenshot-Windows Function"
    return $false
  }
} # End of Screenshot {}

function Count-Windows{
  # Count number of non-windows explorer windows
  $NumOtherWindows = (Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle).Count
  
  # Count number of window explorer windows
  # NOTE: EXPRESSION BELOW CURRENTLY NOT WORKING AS INTENDED - Doesn't accurately give count 
  $NumExplorerWindows = (Get-Process | Where-Object {$_.MainWindowTitle -eq $_.HWND} | Select-Object MainWindowTitle).Count
  
  # Sum up types of windows
  $WindowSum = $NumOtherWindows + $NumExplorerWindows
  Return $WindowSum
}

function Save-Screenshot{
  try{
    $bitmap = [Windows.Forms.Clipboard]::GetImage()    
    $ep = New-Object Drawing.Imaging.EncoderParameters  
    $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)  
    
    $screenCapturePathBase = "$global:OUTPUT_DIR\ScreenCapture"
    $c = 0
    while (Test-Path "${screenCapturePathBase}${c}.jpg") {
      $c++
    }
    $bitmap.Save("${screenCapturePathBase}${c}.jpg", $jpegCodec, $ep)
    
    # Log Successful Action
    Search-And-Add-Log-Entry $SUCCESS_LOG ("Successfully saved screenshot")
        return $true
        
    } # End of Try Block
    Catch{
      # Log Failure
      Search-And-Add-Log-Entry $FAIL_LOG ("Failed to save screenshot")
        return $false
    } # End of Catch Block
} # End of Save-Screenshot helper function