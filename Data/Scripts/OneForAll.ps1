function OneForAll
{
    # Fail if user hasn't picked an output directory and the f-capture root dir is not on removable drive
    if(("" -eq $OutDirTextBox.text) -and (!(Assert-Path-Is-On-Removable-Device "$PSScriptRoot"))){ return }

    # Disable Buttons
    $GoButton.Enabled    = $false
    $AdvancedBtn.Enabled = $false
    $GoSMItem.Enabled    = $false

    # Start packet capture
    if($PacketCaptureCB.Checked)    { Write-Host "Packet-Capture-Start started"; Packet-Capture-Start }

    # Do everything else
    if($NetworkShareInfoCB.Checked) { Write-Host "Network-Share-Info started"; Network-Share-Info }
    if($NetworkInterfacesCB.Checked){ Write-Host "Network-Interfaces started"; Network-Interfaces }
    if($FileSystemInfoCB.Checked)   { Write-Host "Filesystem-Info started"; Filesystem-Info }
    if($AutoRunItemsCB.Checked)     { Write-Host "AutoRun-Items started"; AutoRun-Items }
    if($UserAssistInfoCB.Checked)   { Write-Host "UserAssist started"; UserAssist }
    if($NetworkProfilesCB.Checked)  { Write-Host "Net-Connection-Profile started"; Net-Connection-Profile }
    if($UserAccountsCB.Checked)     { Write-Host "User-Accounts started"; User-Accounts }
    if($TimezoneInfoCB.Checked)     { Write-Host "Timezone-Info started"; Timezone-Info }
    if($WindowsServicesCB.Checked)  { Write-Host "Windows-Services started"; Windows-Services }
    if($SRUMInfoCB.Checked)         { Write-Host "SRUM started"; SRUM }
    if($RestorePointsCB.Checked)    { Write-Host "System-Restore-Points started"; System-Restore-Points }
    if($ShimCacheCB.Checked)        { Write-Host "ShimCache started"; ShimCache }
    if($ShellbagsCB.Checked)        { Write-Host "Shellbags started"; Shellbags }
    if($ScheduledTasksCB.Checked)   { Write-Host "Scheduled-Tasks started"; Scheduled-Tasks }
    if($RDPCacheCB.Checked)         { Write-Host "Remote-Desktop started"; Remote-Desktop }
    if($RecycleBinCB.Checked)       { Write-Host "Recycle-Bin started"; Recycle-Bin }
    if($PrefetchFilesCB.Checked)    { Write-Host "Prefetch started"; Prefetch }
    if($SwapFilesCB.Checked)        { Write-Host "Swap-Files started"; Swap-Files }
    if($MRUListsCB.Checked)         { Write-Host "MRU started"; MRU }
    if($LNKFilesCB.Checked)         { Write-Host "LNK started"; LNK }
    if($DLLsCB.Checked)             { Write-Host "DLL started"; DLL }
    if($KeywordSearchesCB.Checked)  { Write-Host "KeyWord-Search started"; KeyWord-Search }
    if($JumpListsCB.Checked)        { Write-Host "Jump-List started"; Jump-List }
    if($InstalledProgramsCB.Checked){ Write-Host "Installed-Programs started"; Installed-Programs }
    if($FileAssociationsCB.Checked) { Write-Host "File-Associations started"; File-Associations }
    if($StartupProgramsCB.Checked)  { Write-Host "Startup-Programs started"; Startup-Programs }
    if($AmCacheCB.Checked)          { Write-Host "AmCache started"; AmCache }
    if($EventLogsCB.Checked)        { Write-Host "Event-Logs started"; Event-Logs }
    if($RegistryCB.Checked)         { Write-Host "Record-Registry started"; Record-Registry }
    if($ImageScanCB.Checked)        { Write-Host "Image-Scan started"; Image-Scan }
    if($PeripheralDevicesCB.Checked){ Write-Host "Peripheral-Devices started"; Peripheral-Devices }
    if($BrowserHistoryCB.Checked)   { Write-Host "Browser-History started"; Browser-History }
    if($BrowserCookiesCB.Checked)   { Write-Host "Browser-Cookies started"; Browser-Cookies }
    if($ScreenshotsCB.Checked)      { Write-Host "Screenshot windows started"; Screenshot }
    if($MemoryImageCB.Checked)      { Write-Host "PhysicalMemory-Image started"; PhysicalMemory-Image }
    if($ActiveProcessesCB.Checked)  { Write-Host "Active-Processes started"; Active-Processes }
    if($SystemInfoCB.Checked)       { Write-Host "System-Info started"; System-Info }

    # Image drives that the user requested, if any
    Disk-Image

    # End packet capture
    if($PacketCaptureCB.Checked)    { Write-Host "Packet-Capture-Stop started"; Packet-Capture-Stop }

    # Re-enable buttons
    $GoButton.Enabled    = $true
    $AdvancedBtn.Enabled = $true
    $GoSMItem.Enabled    = $true
}