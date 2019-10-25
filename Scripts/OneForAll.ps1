function OneForAll
{
    # Fail if user hasn't picked an output directory and the f-capture root dir is not on removable drive
    if(("" -eq $OutDirTextBox.text) -and (!(Assert-Path-Is-On-Removable-Device "$PSScriptRoot"))){ return }

    # Disable Buttons
    $GoButton.Enabled    = $false
    $AdvancedBtn.Enabled = $false

    # Start packet capture
    if($PacketCaptureCB.Checked){ Packet-Capture-Start }

    # Do everything else
    if($NetworkShareInfoCB.Checked){ Network-Share-Info }
    if($NetworkInterfacesCB.Checked){ Network-Interfaces }
    if($FileSystemInfoCB.Checked){ Filesystem-Info }
    if($AutoRunItemsCB.Checked){ AutoRun-Items }
    if($UserAssistInfoCB.Checked){ UserAssist }
    if($NetworkProfilesCB.Checked){ Net-Connection-Profile }
    if($UserAccountsCB.Checked){ User-Accounts }
    if($TimezoneInfoCB.Checked){ Timezone-Info }
    if($WindowsServicesCB.Checked){ Windows-Services }
    if($SRUMInfoCB.Checked){ SRUM }
    if($RestorePointsCB.Checked){ System-Restore-Points }
    if($ShimCacheCB.Checked){ ShimCache }
    if($ShellbagsCB.Checked){ Shellbags }
    if($ScheduledTasksCB.Checked){ Scheduled-Tasks }
    if($RDPCacheCB.Checked){ Remote-Desktop }
    if($RecycleBinCB.Checked){ Recycle-Bin }
    if($PrefetchFilesCB.Checked){ Prefetch }
    if($SwapFilesCB.Checked){ Swap-Files }
    if($MRUListsCB.Checked){ MRU }
    if($LNKFilesCB.Checked){ LNK }
    if($DLLsCB.Checked){ DLL }
    if($KeywordSearchesCB.Checked){ KeyWord-Search }
    if($JumpListsCB.Checked){ Jump-List }
    if($InstalledProgramsCB.Checked){ Installed-Programs }
    if($FileAssociationsCB.Checked){ File-Associations }
    if($StartupProgramsCB.Checked){ Startup-Programs }
    if($AmCacheCB.Checked){ AmCache }
    if($EventLogsCB.Checked){ Event-Logs }
    if($RegistryCB.Checked){ Record-Registry }
    if($ImageScanCB.Checked){ Image-Scan }
    if($PeripheralDevicesCB.Checked){ Peripheral-Devices }
    if($BrowserHistoryCB.Checked){ Browser-History }
    if($BrowserCookiesCB.Checked){ Browser-Cookies }
    if($ScreenshotsCB.Checked){ Screenshot }
    if($MemoryImageCB.Checked){ PhysicalMemory-Image }
    if($ActiveProcessesCB.Checked){ Active-Processes }
    if($SystemInfoCB.Checked){ System-Info }

    # Image drives that the user requested, if any
    Disk-Image

    # End packet capture
    if($PacketCaptureCB.Checked){ Packet-Capture-Stop }

    # Re-enable buttons
    $GoButton.Enabled    = $true
    $AdvancedBtn.Enabled = $true
}