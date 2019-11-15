function OneForAll
{
    # Fail if user hasn't picked an usable output directory
    if("" -eq $OutDirTextBox.text)
    {
        # If the script root is on a removable drive (or if dev mode is on),
        # make a new folder in the script root called DefaultOutput and set OUPUT_DIR to that
        if((Assert-Path-Is-On-Removable-Device "$PSScriptRoot") -or ($global:DEV_MODE))
        {
            New-Item -Name "DefaultOutput" -Path "$PSScriptRoot\.." -ItemType Directory -ErrorAction SilentlyContinue
            if(Test-Path "$PSScriptRoot\..\DefaultOutput") { $global:OUTPUT_DIR = "$PSScriptRoot\..\DefaultOutput" }
            else { return }
        }
        else # Bring up a message box to tell user to choose a usable drive and return
        {
            Add-Type -AssemblyName PresentationFramework
            [System.Windows.MessageBox]::Show('You must choose an output directory that is not on the local machine.','Output Directory Error','OK','Error')
            return
        }
    }

    # Open results page
    Open-Results-Page

    # Disable Buttons
    $GoSMItem.Enabled       = $false
    $MainMenuBtn.Enabled    = $false
    $ViewOutputBtn.Enabled  = $false
    $ExitResultsBtn.Enabled = $false

    # Inform user that scan has started
    $ScanningLbl.Text = 'Scanning...'
    $ResultsTB.Text   = "Scan started..."
    $ResultsTB.AppendText("`r`n`r`n")

    # Log the time that the scan started
    $startTime = Get-Date

    # Start packet capture
    if($PacketCaptureCB.Checked){ Update-TB("Start packet capture"); Packet-Capture-Start; Update-TB }

    # Do everything else
    if($NetworkShareInfoCB.Checked){ Update-TB("Network Share Info"); Network-Share-Info; Update-TB }
    if($NetworkInterfacesCB.Checked){ Update-TB("Network Interfaces"); Network-Interfaces; Update-TB }
    if($FileSystemInfoCB.Checked){ Update-TB("FileSystem Info"); Filesystem-Info; Update-TB }
    if($AutoRunItemsCB.Checked){ Update-TB("AutoRun Items"); AutoRun-Items; Update-TB }
    if($UserAssistInfoCB.Checked){ Update-TB("UserAssist Info"); UserAssist; Update-TB }
    if($NetworkProfilesCB.Checked){ Update-TB("Network Profiles"); Net-Connection-Profile; Update-TB }
    if($UserAccountsCB.Checked){ Update-TB("User Accounts"); User-Accounts; Update-TB }
    if($TimezoneInfoCB.Checked){ Update-TB("Timezone Info"); Timezone-Info; Update-TB }
    if($WindowsServicesCB.Checked){ Update-TB("Windows Services"); Windows-Services; Update-TB }
    if($SRUMInfoCB.Checked){ Update-TB("SRUM Info"); SRUM; Update-TB }
    if($RestorePointsCB.Checked){ Update-TB("Restore Points"); System-Restore-Points; Update-TB }
    if($ShimCacheCB.Checked){ Update-TB("ShimCache"); ShimCache; Update-TB }
    if($ShellbagsCB.Checked){ Update-TB("Shellbags"); Shellbags; Update-TB }
    if($ScheduledTasksCB.Checked){ Update-TB("Scheduled Tasks"); Scheduled-Tasks; Update-TB }
    if($RDPCacheCB.Checked){ Update-TB("RDP Cache"); Remote-Desktop; Update-TB }
    if($RecycleBinCB.Checked){ Update-TB("Recycle Bin"); Get-Recycle-Bin; Update-TB }
    if($PrefetchFilesCB.Checked){ Update-TB("Prefetch Files"); Prefetch; Update-TB }
    if($MRUListsCB.Checked){ Update-TB("MRU Lists"); MRU; Update-TB }
    if($LNKFilesCB.Checked){ Update-TB("LNK Files"); LNK; Update-TB }
    if($DLLsCB.Checked){ Update-TB("DLLs"); DLL; Update-TB }
    if($KeywordSearchesCB.Checked){ Update-TB("Keyword Searches"); KeyWord-Search; Update-TB }
    if($JumpListsCB.Checked){ Update-TB("Jump Lists"); Jump-List; Update-TB }
    if($InstalledProgramsCB.Checked){ Update-TB("Installed Programs"); Installed-Programs; Update-TB }
    if($FileAssociationsCB.Checked){ Update-TB("File Associations"); File-Associations; Update-TB }
    if($StartupProgramsCB.Checked){ Update-TB("Startup Programs"); Startup-Programs; Update-TB }
    if($AmCacheCB.Checked){ Update-TB("AmCache"); AmCache; Update-TB }
    if($MUICacheCB.Checked){ Update-TB("MUICache"); MUICache; Update-TB }
    if($EventLogsCB.Checked){ Update-TB("Event Logs"); Event-Logs; Update-TB }
    if($RegistryCB.Checked){ Update-TB("Registry"); Record-Registry; Update-TB }
    if($ImageScanCB.Checked){ Update-TB("Image Scan"); Image-Scan; Update-TB }
    if($PeripheralDevicesCB.Checked){ Update-TB("Peripheral Devices"); Peripheral-Devices; Update-TB }
    if($BrowserDataCB.Checked){ Update-TB("Browser Data"); Browser-Data-Retrieval; Update-TB }
    if($ScreenshotsCB.Checked){ Update-TB("Screenshots"); Screenshot; Update-TB }
    if($MemoryImageCB.Checked -or $SwapFilesCB.Checked){
		if($SwapFilesCB.Checked){ Update-TB("Swap Files"); Swap-Files; Update-TB }
		else{ Update-TB("Physical Memory Imaging"); PhysicalMemory-Image; Update-TB }}
    if($ActiveProcessesCB.Checked){ Update-TB("Active Processes"); Active-Processes; Update-TB }
    if($SystemInfoCB.Checked){ Update-TB("System Info"); System-Info; Update-TB }

    # Image drives that the user requested, if any
    if($DiskImgCBList.CheckedItems) { Update-TB("Image disks"); Disk-Image; Update-TB }

    # End packet capture
    if($PacketCaptureCB.Checked){ Update-TB("Stop packet capture"); Packet-Capture-Stop; Update-TB }

    # Package output data into .zip or .vhdx
    Update-TB("Package data"); Package-Output-Data; Update-TB

    # Calculate the elapsed time since the scan started, then diplay it in results textbox
    $elapsedTime = "{0:HH:mm:ss}" -f ([datetime]($(Get-Date) - $startTime).Ticks)
    $ResultsTB.AppendText("`r`nElapsed time: $elapsedTime`r`n")

    # Inform user that scan is complete
    $ScanningLbl.Text = 'Scan Complete'
    $ResultsTB.AppendText("`r`nFinished")

    # Re-enable buttons
    $GoSMItem.Enabled       = $true
    $MainMenuBtn.Enabled    = $true
    $ViewOutputBtn.Enabled  = $true
    $ExitResultsBtn.Enabled = $true
}

function Update-TB([string]$action)
{
    if($action -ne "") # "" denotes the action is finished
    {
        $ResultsTB.AppendText("$action...")
    }
    else # Otherwise the action is starting
    {
        $ResultsTB.AppendText("Done`r`n")
    }
}
