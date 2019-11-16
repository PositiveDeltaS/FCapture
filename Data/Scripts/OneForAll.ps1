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

#Create empty Function table
    $FunctionsToExecute = @()

 #must use $FunctionsToExecute+=$element   --> += creates a new array and appends the new item

    # Do everything else
    if($NetworkShareInfoCB.Checked){ Update-TB("Network Share Info"); $FunctionsToExecute += (Get-Item -Path function:Network-Share-Info); Update-TB }
    if($NetworkInterfacesCB.Checked){ Update-TB("Network Interfaces"); $FunctionsToExecute += (Get-Item -Path function:Network-Interfaces); Update-TB }
    if($FileSystemInfoCB.Checked){ Update-TB("FileSystem Info"); $FunctionsToExecute += (Get-Item -Path function:Filesystem-Info); Update-TB }
    if($AutoRunItemsCB.Checked){ Update-TB("AutoRun Items"); $FunctionsToExecute += (Get-Item -Path function:AutoRun-Items); Update-TB }
    if($UserAssistInfoCB.Checked){ Update-TB("UserAssist Info"); $FunctionsToExecute += (Get-Item -Path function:UserAssist); Update-TB }
    if($NetworkProfilesCB.Checked){ Update-TB("Network Profiles"); $FunctionsToExecute += (Get-Item -Path function:Net-Connection-Profile); Update-TB }
    if($UserAccountsCB.Checked){ Update-TB("User Accounts"); $FunctionsToExecute += (Get-Item -Path function:User-Accounts); Update-TB }
    if($TimezoneInfoCB.Checked){ Update-TB("Timezone Info"); $FunctionsToExecute += (Get-Item -Path function:Timezone-Info); Update-TB }
    if($WindowsServicesCB.Checked){ Update-TB("Windows Services"); $FunctionsToExecute += (Get-Item -Path function:Windows-Services); Update-TB }
    if($SRUMInfoCB.Checked){ Update-TB("SRUM Info"); $FunctionsToExecute += (Get-Item -Path function:SRUM); Update-TB }
    if($RestorePointsCB.Checked){ Update-TB("Restore Points"); $FunctionsToExecute += (Get-Item -Path function:System-Restore-Points); Update-TB }
    if($ShimCacheCB.Checked){ Update-TB("ShimCache"); $FunctionsToExecute += (Get-Item -Path function:ShimCache); Update-TB }
    if($ShellbagsCB.Checked){ Update-TB("Shellbags"); $FunctionsToExecute += (Get-Item -Path function:Shellbags); Update-TB }
    if($ScheduledTasksCB.Checked){ Update-TB("Scheduled Tasks"); $FunctionsToExecute += (Get-Item -Path function:Scheduled-Tasks); Update-TB }
    if($RDPCacheCB.Checked){ Update-TB("RDP Cache"); $FunctionsToExecute += (Get-Item -Path function:Remote-Desktop); Update-TB }
    if($RecycleBinCB.Checked){ Update-TB("Recycle Bin"); $FunctionsToExecute += (Get-Item -Path function:Recycle-Bin); Update-TB }
    if($PrefetchFilesCB.Checked){ Update-TB("Prefetch Files"); $FunctionsToExecute += (Get-Item -Path function:Prefetch); Update-TB }
    if($MRUListsCB.Checked){ Update-TB("MRU Lists"); $FunctionsToExecute += (Get-Item -Path function:MRU); Update-TB }
    if($LNKFilesCB.Checked){ Update-TB("LNK Files"); $FunctionsToExecute += (Get-Item -Path function:LNK); Update-TB }
    if($DLLsCB.Checked){ Update-TB("DLLs"); $FunctionsToExecute += (Get-Item -Path function:DLL); Update-TB }
    if($KeywordSearchesCB.Checked){ Update-TB("Keyword Searches"); $FunctionsToExecute += (Get-Item -Path function:KeyWord-Search); Update-TB }
    if($JumpListsCB.Checked){ Update-TB("Jump Lists"); $FunctionsToExecute += (Get-Item -Path function:Jump-List); Update-TB }
    if($InstalledProgramsCB.Checked){ Update-TB("Installed Programs"); $FunctionsToExecute += (Get-Item -Path function:Installed-Programs); Update-TB }
    if($FileAssociationsCB.Checked){ Update-TB("File Associations"); $FunctionsToExecute += (Get-Item -Path function:File-Associations); Update-TB }
    if($StartupProgramsCB.Checked){ Update-TB("Startup Programs"); $FunctionsToExecute += (Get-Item -Path function:Startup-Programs); Update-TB }
    if($AmCacheCB.Checked){ Update-TB("AmCache"); $FunctionsToExecute += (Get-Item -Path function:AmCache); Update-TB }
    if($MUICacheCB.Checked){ Update-TB("MUICache"); $FunctionsToExecute += (Get-Item -Path function:MUICache); Update-TB }
    if($EventLogsCB.Checked){ Update-TB("Event Logs"); $FunctionsToExecute += (Get-Item -Path function:Event-Logs); Update-TB }
    if($RegistryCB.Checked){ Update-TB("Registry"); $FunctionsToExecute += (Get-Item -Path function:Record-Registry); Update-TB }
    if($ImageScanCB.Checked){ Update-TB("Image Scan"); $FunctionsToExecute += (Get-Item -Path function:Image-Scan); Update-TB }
    if($PeripheralDevicesCB.Checked){ Update-TB("Peripheral Devices"); $FunctionsToExecute += (Get-Item -Path function:Peripheral-Devices); Update-TB }
    if($BrowserDataCB.Checked){ Update-TB("Browser Data"); $FunctionsToExecute += (Get-Item -Path function:Browser-Data-Retrieval); Update-TB }
    if($ScreenshotsCB.Checked){ Update-TB("Screenshots"); $FunctionsToExecute += (Get-Item -Path function:Screenshot); Update-TB }
    if($MemoryImageCB.Checked -or $SwapFilesCB.Checked){
		if($SwapFilesCB.Checked){ Update-TB("Swap Files"); $FunctionsToExecute += (Get-Item -Path function:Swap-Files); Update-TB }
		else{ Update-TB("Physical Memory Imaging"); $FunctionsToExecute += (Get-Item -Path function:PhysicalMemory-Image); Update-TB }}
    if($ActiveProcessesCB.Checked){ Update-TB("Active Processes"); $FunctionsToExecute += (Get-Item -Path function:Active-Processes); Update-TB }
    if($SystemInfoCB.Checked){ Update-TB("System Info"); $FunctionsToExecute += (Get-Item -Path function:System-Info); Update-TB }


    #Iterate and execute each function that correlates to a checkbox that is checked
    foreach($funct in $FunctionsToExecute)
    {
       & $funct
    }

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
