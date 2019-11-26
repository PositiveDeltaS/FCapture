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
    if($PacketCaptureCB.Checked){
        Update-TB "Start packet capture"
        $success = Packet-Capture-Start
        Update-TB "" $success
    }

    # Do everything else
    if($NetworkShareInfoCB.Checked){
        Update-TB "Network Share Info"
        $success = Network-Share-Info
        Update-TB "" $success
    }
    if($NetworkInterfacesCB.Checked){
        Update-TB "Network Interfaces"
        $success = Network-Interfaces
        Update-TB "" $success
    }
    if($FileSystemInfoCB.Checked){
        Update-TB "FileSystem Info"
        $success = Filesystem-Info
        Update-TB "" $success
    }
    if($AutoRunItemsCB.Checked){
        Update-TB "AutoRun Items"
        $success = AutoRun-Items
        Update-TB "" $success
    }
    if($UserAssistInfoCB.Checked){
        Update-TB "UserAssist Info"
        $success = UserAssist
        Update-TB "" $success
    }
    if($NetworkProfilesCB.Checked){
        Update-TB "Network Profiles"
        $success = Net-Connection-Profile
        Update-TB "" $success
    }
    if($UserAccountsCB.Checked){
        Update-TB "User Accounts"
        $success = User-Accounts
        Update-TB "" $success
    }
    if($TimezoneInfoCB.Checked){
        Update-TB "Timezone Info"
        $success = Timezone-Info
        Update-TB "" $success
    }
    if($WindowsServicesCB.Checked){
        Update-TB "Windows Services"
        $success = Windows-Services
        Update-TB "" $success
    }
    if($SRUMInfoCB.Checked){
        Update-TB "SRUM Info"
        $success = SRUM
        Update-TB "" $success
    }
    if($RestorePointsCB.Checked){
        Update-TB "Restore Points"
        $success = System-Restore-Points
        Update-TB "" $success
    }
    if($ShimCacheCB.Checked){
        Update-TB "ShimCache"
        $success = ShimCache
        Update-TB "" $success
    }
    if($ShellbagsCB.Checked){
        Update-TB "Shellbags"
        $success = Shellbags
        Update-TB "" $success
    }
    if($ScheduledTasksCB.Checked){
        Update-TB "Scheduled Tasks"
        $success = Scheduled-Tasks
        Update-TB "" $success
    }
    if($RDPCacheCB.Checked){
        Update-TB "RDP Cache"
        $success = Remote-Desktop
        Update-TB "" $success
    }
    if($RecycleBinCB.Checked){
        Update-TB "Recycle Bin"
        $success = Get-Recycle-Bin
        Update-TB "" $success
    }
    if($PrefetchFilesCB.Checked){
        Update-TB "Prefetch Files"
        $success = Prefetch
        Update-TB "" $success
    }
    if($MRUListsCB.Checked){
        Update-TB "MRU Lists"
        $success = MRU
        Update-TB "" $success
    }
    if($LNKFilesCB.Checked){
        Update-TB "LNK Files"
        $success = LNK
        Update-TB "" $success
    }
    if($DLLsCB.Checked){
        Update-TB "DLLs"
        $success = DLL
        Update-TB "" $success
    }
    if($KeywordSearchesCB.Checked){
        Update-TB "Keyword Searches"
        $success = KeyWord-Search
        Update-TB "" $success
    }
    if($JumpListsCB.Checked){
        Update-TB "Jump Lists"
        $success = Jump-List
        Update-TB "" $success
    }
    if($InstalledProgramsCB.Checked){
        Update-TB "Installed Programs"
        $success = Installed-Programs
        Update-TB "" $success
    }
    if($FileAssociationsCB.Checked){
        Update-TB "File Associations"
        $success = File-Associations
        Update-TB "" $success
    }
    if($StartupProgramsCB.Checked){
        Update-TB "Startup Programs"
        $success = Startup-Programs
        Update-TB "" $success
    }
    if($AmCacheCB.Checked){
        Update-TB "AmCache"
        $success = AmCache
        Update-TB "" $success
    }
    if($MUICacheCB.Checked){
        Update-TB "MUICache"
        $success = MUICache
        Update-TB "" $success
    }
    if($EventLogsCB.Checked){
        Update-TB "Event Logs"
        $success = Event-Logs
        Update-TB "" $success
    }
    if($RegistryCB.Checked){
        Update-TB "Registry"
        $success = Record-Registry
        Update-TB "" $success
    }
    if($ImageScanCB.Checked){
        Update-TB "Image Scan"
        $success = Image-Scan
        Update-TB "" $success
    }
    if($PeripheralDevicesCB.Checked){
        Update-TB "Peripheral Devices"
        $success = Peripheral-Devices
        Update-TB "" $success
    }
    if($BrowserDataCB.Checked){

        $boolArray = Browser-Data-Retrieval
		
		Update-TB("Edge Browser Data")
        Update-TB "" $boolArray[0]
		
		Update-TB("Chrome Browser Data")
        Update-TB "" $boolArray[1]

        Update-TB("Firefox Browser Data")
        Update-TB "" $boolArray[2]

        Update-TB("Opera Browser Data")
        Update-TB "" $boolArray[3]

        Update-TB("IE Browser Data")
        Update-TB "" $boolArray[4]
    }
    if($ScreenshotsCB.Checked){
        Update-TB "Screenshots"
        $success = Screenshot
        Update-TB "" $success
    }
    if($MemoryImageCB.Checked -or $SwapFilesCB.Checked){
		if($SwapFilesCB.Checked){
            Update-TB "Swap Files"
            $success = Swap-Files
            Update-TB "" $success
        }
		else{
            Update-TB "Physical Memory Imaging"
            $success = PhysicalMemory-Image
            Update-TB "" $success
        }
    }
    if($ActiveProcessesCB.Checked){
        Update-TB "Active Processes"
        $success = Active-Processes
        Update-TB "" $success
    }
    if($SystemInfoCB.Checked){
        Update-TB "System Info"
        $success = System-Info
        Update-TB "" $success
    }

    # Image drives that the user requested, if any
    if($DiskImgCBList.CheckedItems) {
        Update-TB "Image disks"
        $success = Disk-Image
        Update-TB "" $success
    }

    # End packet capture
    if($PacketCaptureCB.Checked){
        Update-TB "Stop packet capture"
        $success = Packet-Capture-Stop
        Update-TB "" $success
    }

    # Calculate and display the start, end, and total elapsed times to results textbox
    $endTime          = Get-Date
    Append-Time "Start time" $startTime
    Append-Time "End time" $endTime
    Append-Time "Elapsed time" ($endTime - $startTime)

    # Create summary text file
    New-Item -Path "$global:OUTPUT_DIR" -Name "FCAP_Summary.txt" -ItemType File -Value $ResultsTB.Text
    
    # Package output data into .zip or .vhdx
    Update-TB "`r`nPackage data"
    $success = Package-Output-Data
    Update-TB "" $success

    # Inform user that scan is complete
    $ScanningLbl.Text = 'Scan Complete'
    $ResultsTB.AppendText("`r`nFinished")

    # Re-enable buttons
    $GoSMItem.Enabled       = $true
    $MainMenuBtn.Enabled    = $true
    $ViewOutputBtn.Enabled  = $true
    $ExitResultsBtn.Enabled = $true
}

function Update-TB([string]$action, $success)
{
    if($action -ne "") # Something other than "" denotes the action is starting
    {
        $ResultsTB.AppendText("$action...")
    }
    else # Otherwise the action is ending, so print success/failure/NA
    {
        if(($success -eq $true) -or ($success -eq $True)){
            $ResultsTB.AppendText("OK`r`n")
        }
        elseif(($success -eq $false) -or ($success -eq $False)){
            $ResultsTB.AppendText("ERROR`r`n")
        }
        else{
            $ResultsTB.AppendText("DONE`r`n") # Catch-all if function doesn't return boolean
        }
    }
}

function Append-Time($label, $time)
{
    $timeFormatted = "{0:HH:mm:ss}" -f ([datetime]($time).Ticks)
    $ResultsTB.AppendText("`r`n$label`: $timeFormatted`r`n")
}