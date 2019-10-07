# Template for F-Capture
$global:DEBUG_LOG= ".\debugLog.txt"
$global:SUCCESS_LOG=".\success.txt"
$global:FAIL_LOG=".\fail.txt"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form					= New-Object system.Windows.Forms.Form
$Form.ClientSize		= '1200,800'
$Form.text				= "F-Capture"
$Form.TopMost			= $false

$SysInfBtn				= New-Object system.Windows.Forms.Button
$SysInfBtn.text			= "System Information"
$SysInfBtn.width		= 110
$SysInfBtn.height		= 35
$SysInfBtn.location		= New-Object System.Drawing.Point(10,10)
$SysInfBtn.Font			= 'Microsoft Sans Serif,10'

$ProcsBtn				= New-Object system.Windows.Forms.Button
$ProcsBtn.text			= "Active Processes"
$ProcsBtn.width			= 110
$ProcsBtn.height		= 35
$ProcsBtn.location		= New-Object System.Drawing.Point(140,10)
$ProcsBtn.Font			= 'Microsoft Sans Serif,10'

$PhysMemBtn             = New-Object system.Windows.Forms.Button
$PhysMemBtn.text        = "Image RAM"
$PhysMemBtn.width       = 110
$PhysMemBtn.height      = 35
$PhysMemBtn.location    = New-Object System.Drawing.Point(270,10)
$PhysMemBtn.Font        = 'Microsoft Sans Serif,10'

$DiskBtn                = New-Object system.Windows.Forms.Button
$DiskBtn.text           = "Image Disk"
$DiskBtn.width          = 110
$DiskBtn.height         = 35
$DiskBtn.location       = New-Object System.Drawing.Point(400,10)
$DiskBtn.Font           = 'Microsoft Sans Serif,10'

$SnapBtn                = New-Object system.Windows.Forms.Button
$SnapBtn.text           = "Screenshot"
$SnapBtn.width          = 110
$SnapBtn.height         = 35
$SnapBtn.location       = New-Object System.Drawing.Point(530,10)
$SnapBtn.Font           = 'Microsoft Sans Serif,10'

$CookieBtn              = New-Object system.Windows.Forms.Button
$CookieBtn.text         = "Browser Cookies"
$CookieBtn.width        = 110
$CookieBtn.height       = 35
$CookieBtn.location     = New-Object System.Drawing.Point(660,10)
$CookieBtn.Font         = 'Microsoft Sans Serif,10'

$HistBtn                = New-Object system.Windows.Forms.Button
$HistBtn.text           = "Browser History"
$HistBtn.width          = 110
$HistBtn.height         = 35
$HistBtn.location       = New-Object System.Drawing.Point(790,10)
$HistBtn.Font           = 'Microsoft Sans Serif,10'

$DeviceBtn              = New-Object system.Windows.Forms.Button
$DeviceBtn.text         = "Peripheral Devices"
$DeviceBtn.width        = 110
$DeviceBtn.height       = 35
$DeviceBtn.location     = New-Object System.Drawing.Point(920,10)
$DeviceBtn.Font         = 'Microsoft Sans Serif,10'

$ScanRegBtn             = New-Object system.Windows.Forms.Button
$ScanRegBtn.text        = "Scan Registry"
$ScanRegBtn.width       = 110
$ScanRegBtn.height      = 35
$ScanRegBtn.location    = New-Object System.Drawing.Point(10,65)
$ScanRegBtn.Font        = 'Microsoft Sans Serif,10'

$ImgScanBtn             = New-Object system.Windows.Forms.Button
$ImgScanBtn.text        = "Image Scan"
$ImgScanBtn.width       = 110
$ImgScanBtn.height      = 35
$ImgScanBtn.location    = New-Object System.Drawing.Point(140,65)
$ImgScanBtn.Font        = 'Microsoft Sans Serif,10'

$RegBtn                 = New-Object system.Windows.Forms.Button
$RegBtn.text            = "Record Registry"
$RegBtn.width           = 110
$RegBtn.height          = 35
$RegBtn.location        = New-Object System.Drawing.Point(270,65)
$RegBtn.Font            = 'Microsoft Sans Serif,10'
					    
$EventBtn               = New-Object system.Windows.Forms.Button
$EventBtn.text          = "Event Logs"
$EventBtn.width         = 110
$EventBtn.height        = 35
$EventBtn.location      = New-Object System.Drawing.Point(400,65)
$EventBtn.Font          = 'Microsoft Sans Serif,10'

$AmCacheBtn             = New-Object system.Windows.Forms.Button
$AmCacheBtn.text        = "AMCache"
$AmCacheBtn.width       = 110
$AmCacheBtn.height      = 35
$AmCacheBtn.location    = New-Object System.Drawing.Point(530,65)
$AmCacheBtn.Font        = 'Microsoft Sans Serif,10'

$AutoBtn                = New-Object system.Windows.Forms.Button
$AutoBtn.text           = "Startup Items"
$AutoBtn.width          = 110
$AutoBtn.height         = 35
$AutoBtn.location       = New-Object System.Drawing.Point(660,65)
$AutoBtn.Font           = 'Microsoft Sans Serif,10'

$FileAssocBtn           = New-Object system.Windows.Forms.Button
$FileAssocBtn.text      = "File Associations"
$FileAssocBtn.width     = 110
$FileAssocBtn.height    = 35
$FileAssocBtn.location  = New-Object System.Drawing.Point(790,65)
$FileAssocBtn.Font      = 'Microsoft Sans Serif,10'

$InstalledBtn           = New-Object system.Windows.Forms.Button
$InstalledBtn.text      = "Installed Programs"
$InstalledBtn.width     = 110
$InstalledBtn.height    = 35
$InstalledBtn.location  = New-Object System.Drawing.Point(920,65)
$InstalledBtn.Font      = 'Microsoft Sans Serif,10'

$JumpBtn                = New-Object system.Windows.Forms.Button
$JumpBtn.text           = "Jump List"
$JumpBtn.width          = 110
$JumpBtn.height         = 35
$JumpBtn.location       = New-Object System.Drawing.Point(10,110)
$JumpBtn.Font           = 'Microsoft Sans Serif,10'

$KWordBtn               = New-Object system.Windows.Forms.Button
$KWordBtn.text          = "Keyword Search"
$KWordBtn.width         = 110
$KWordBtn.height        = 35
$KWordBtn.location      = New-Object System.Drawing.Point(140,110)
$KWordBtn.Font          = 'Microsoft Sans Serif,10'

$DLLBtn                 = New-Object system.Windows.Forms.Button
$DLLBtn.text            = "DLLs"
$DLLBtn.width           = 110
$DLLBtn.height          = 35
$DLLBtn.location        = New-Object System.Drawing.Point(270,110)
$DLLBtn.Font            = 'Microsoft Sans Serif,10'
					    
$LNKBtn                 = New-Object system.Windows.Forms.Button
$LNKBtn.text            = "LNK Files"
$LNKBtn.width           = 110
$LNKBtn.height          = 35
$LNKBtn.location        = New-Object System.Drawing.Point(400,110)
$LNKBtn.Font            = 'Microsoft Sans Serif,10'
					    
$MRUBtn                 = New-Object system.Windows.Forms.Button
$MRUBtn.text            = "MRU Info"
$MRUBtn.width           = 110
$MRUBtn.height          = 35
$MRUBtn.location        = New-Object System.Drawing.Point(530,110)
$MRUBtn.Font            = 'Microsoft Sans Serif,10'
					    
$SwapBtn                = New-Object system.Windows.Forms.Button
$SwapBtn.text           = "Swap Files"
$SwapBtn.width          = 110
$SwapBtn.height         = 35
$SwapBtn.location       = New-Object System.Drawing.Point(660,110)
$SwapBtn.Font           = 'Microsoft Sans Serif,10'
					    
$PFBtn                  = New-Object system.Windows.Forms.Button
$PFBtn.text             = "Prefetch Files"
$PFBtn.width            = 110
$PFBtn.height           = 35
$PFBtn.location         = New-Object System.Drawing.Point(790,110)
$PFBtn.Font             = 'Microsoft Sans Serif,10'

$RecycleBtn             = New-Object system.Windows.Forms.Button
$RecycleBtn.text        = "Recycle Bin"
$RecycleBtn.width       = 110
$RecycleBtn.height      = 35
$RecycleBtn.location    = New-Object System.Drawing.Point(920,110)
$RecycleBtn.Font        = 'Microsoft Sans Serif,10'

$RemoteBtn              = New-Object system.Windows.Forms.Button
$RemoteBtn.text         = "Remote Desktop"
$RemoteBtn.width        = 110
$RemoteBtn.height       = 35
$RemoteBtn.location     = New-Object System.Drawing.Point(10,155)
$RemoteBtn.Font         = 'Microsoft Sans Serif,10'

$SchedTasksBtn          = New-Object system.Windows.Forms.Button
$SchedTasksBtn.text     = "Sceduled Tasks"
$SchedTasksBtn.width    = 110
$SchedTasksBtn.height   = 35
$SchedTasksBtn.location = New-Object System.Drawing.Point(140,155)
$SchedTasksBtn.Font     = 'Microsoft Sans Serif,10'

$ShellbagsBtn           = New-Object system.Windows.Forms.Button
$ShellbagsBtn.text      = "Shellbags"
$ShellbagsBtn.width     = 110
$ShellbagsBtn.height    = 35
$ShellbagsBtn.location  = New-Object System.Drawing.Point(270,155)
$ShellbagsBtn.Font      = 'Microsoft Sans Serif,10'

$ShimCacheBtn           = New-Object system.Windows.Forms.Button
$ShimCacheBtn.text      = "ShimCache"
$ShimCacheBtn.width     = 110
$ShimCacheBtn.height    = 35
$ShimCacheBtn.location  = New-Object System.Drawing.Point(400,155)
$ShimCacheBtn.Font      = 'Microsoft Sans Serif,10'

$SysRestBtn             = New-Object system.Windows.Forms.Button
$SysRestBtn.text        = "System Restore Points"
$SysRestBtn.width       = 110
$SysRestBtn.height      = 35
$SysRestBtn.location    = New-Object System.Drawing.Point(530,155)
$SysRestBtn.Font        = 'Microsoft Sans Serif,10'

$SRUMBtn                = New-Object system.Windows.Forms.Button
$SRUMBtn.text           = "SRUM Info"
$SRUMBtn.width          = 110
$SRUMBtn.height         = 35
$SRUMBtn.location       = New-Object System.Drawing.Point(660,155)
$SRUMBtn.Font           = 'Microsoft Sans Serif,10'

$ServBtn                = New-Object system.Windows.Forms.Button
$ServBtn.text           = "System Services"
$ServBtn.width          = 110
$ServBtn.height         = 35
$ServBtn.location       = New-Object System.Drawing.Point(790,155)
$ServBtn.Font           = 'Microsoft Sans Serif,10'

$TimezoneBtn            = New-Object system.Windows.Forms.Button
$TimezoneBtn.text       = "Timezone Info"
$TimezoneBtn.width      = 110
$TimezoneBtn.height     = 35
$TimezoneBtn.location   = New-Object System.Drawing.Point(920,155)
$TimezoneBtn.Font       = 'Microsoft Sans Serif,10'

$UserAccBtn             = New-Object system.Windows.Forms.Button
$UserAccBtn.text        = "User Accounts"
$UserAccBtn.width       = 110
$UserAccBtn.height      = 35
$UserAccBtn.location    = New-Object System.Drawing.Point(10,200)
$UserAccBtn.Font        = 'Microsoft Sans Serif,10'

$UserAssistBtn          = New-Object system.Windows.Forms.Button
$UserAssistBtn.text     = "User Assist Info"
$UserAssistBtn.width    = 110
$UserAssistBtn.height   = 35
$UserAssistBtn.location = New-Object System.Drawing.Point(140,200)
$UserAssistBtn.Font     = 'Microsoft Sans Serif,10'

$ActionBtn              = New-Object system.Windows.Forms.Button
$ActionBtn.text         = "Begin Recording User"
$ActionBtn.width        = 110
$ActionBtn.height       = 35
$ActionBtn.location     = New-Object System.Drawing.Point(270,200)
$ActionBtn.Font         = 'Microsoft Sans Serif,10'

$UserProfBtn            = New-Object system.Windows.Forms.Button
$UserProfBtn.text       = "User Profiles"
$UserProfBtn.width      = 110
$UserProfBtn.height     = 35
$UserProfBtn.location   = New-Object System.Drawing.Point(400,200)
$UserProfBtn.Font       = 'Microsoft Sans Serif,10'

$OneForAll              = New-Object system.Windows.Forms.Button
$OneForAll.text         = "Incomplete"
$OneForAll.width        = 110
$OneForAll.height       = 35
$OneForAll.location     = New-Object System.Drawing.Point(530,200)
$OneForAll.Font         = 'Microsoft Sans Serif,10'

$OutputLocBtn           = New-Object system.Windows.Forms.Button
$OutputLocBtn.text      = "Set Output Location"
$OutputLocBtn.width     = 110
$OutputLocBtn.height    = 35
$OutputLocBtn.location  = New-Object System.Drawing.Point(660,200)
$OutputLocBtn.Font      = 'Microsoft Sans Serif,10'

$AdvMenuBtn             = New-Object system.Windows.Forms.Button
$AdvMenuBtn.text        = "Advanced Menu"
$AdvMenuBtn.width       = 110
$AdvMenuBtn.height      = 35
$AdvMenuBtn.location    = New-Object System.Drawing.Point(790,200)
$AdvMenuBtn.Font        = 'Microsoft Sans Serif,10'

$HelloWorldBtn          = New-Object system.Windows.Forms.Button
$HelloWorldBtn.text     = "Hello World!"
$HelloWorldBtn.width    = 110
$HelloWorldBtn.height   = 35
$HelloWorldBtn.location = New-Object System.Drawing.Point(920,200)
$HelloWorldBtn.Font     = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($SysInfBtn))
$Form.controls.AddRange(@($ProcsBtn))
$Form.controls.AddRange(@($PhysMemBtn))
$Form.controls.AddRange(@($DiskBtn))
$Form.controls.AddRange(@($SnapBtn))
$Form.controls.AddRange(@($CookieBtn))
$Form.controls.AddRange(@($HistBtn))
$Form.controls.AddRange(@($DeviceBtn))
$Form.controls.AddRange(@($ScanRegBtn))
$Form.controls.AddRange(@($ImgScanBtn))
$Form.controls.AddRange(@($RegBtn))
$Form.controls.AddRange(@($EventBtn))
$Form.controls.AddRange(@($AmCacheBtn))
$Form.controls.AddRange(@($AutoBtn))
$Form.controls.AddRange(@($FileAssocBtn))
$Form.controls.AddRange(@($InstalledBtn))
$Form.controls.AddRange(@($JumpBtn))
$Form.controls.AddRange(@($KWordBtn))
$Form.controls.AddRange(@($DLLBtn))
$Form.controls.AddRange(@($LNKBtn))
$Form.controls.AddRange(@($MRUBtn))
$Form.controls.AddRange(@($SwapBtn))
$Form.controls.AddRange(@($PFBtn))
$Form.controls.AddRange(@($RecycleBtn))
$Form.controls.AddRange(@($RemoteBtn))
$Form.controls.AddRange(@($SchedTasksBtn))
$Form.controls.AddRange(@($ShellbagsBtn))
$Form.controls.AddRange(@($ShimCacheBtn))
$Form.controls.AddRange(@($SysRestBtn))
$Form.controls.AddRange(@($SRUMBtn))
$Form.controls.AddRange(@($ServBtn))
$Form.controls.AddRange(@($TimezoneBtn))
$Form.controls.AddRange(@($UserAccBtn))
$Form.controls.AddRange(@($UserAssistBtn))
$Form.controls.AddRange(@($ActionBtn))
$Form.controls.AddRange(@($UserProfBtn))
$Form.controls.AddRange(@($OneForAll))
$Form.controls.AddRange(@($OutputLocBtn))
$Form.controls.AddRange(@($AdvMenuBtn))
$Form.controls.AddRange(@($HelloWorldBtn))

$SysInfBtn.Add_Click({ System-Info })
$ProcsBtn.Add_Click({ Active-Processes })
$PhysMemBtn.Add_Click({ PhysicalMemory-Image })
$DiskBtn.Add_Click({ Disk-Image })
$SnapBtn.Add_Click({ Screenshot })
$CookieBtn.Add_Click({ Browser-Cookies })
$HistBtn.Add_Click({ Browser-History })
$DeviceBtn.Add_Click({ Peripheral-Devices })
$ScanRegBtn.Add_Click({ Scan-Registry })
$ImgScanBtn.Add_Click({ Image-Scan })
$RegBtn.Add_Click({ Record-Registry })
$EventBtn.Add_Click({ Event-Logs })
$AmCacheBtn.Add_Click({ AmCache })
$AutoBtn.Add_Click({ Startup-Programs })
$FileAssocBtn.Add_Click({ File-Associations })
$InstalledBtn.Add_Click({ Installed-Programs })
$JumpBtn.Add_Click({ Jump-List })
$KWordBtn.Add_Click({ KeyWord-Search })
$DLLBtn.Add_Click({ DLL })
$LNKBtn.Add_Click({ LNK })
$MRUBtn.Add_Click({ MRU })
$SwapBtn.Add_Click({ Swap-Files })
$PFBtn.Add_Click({ Prefetch })
$RecycleBtn.Add_Click({ Recycle-Bin })
$RemoteBtn.Add_Click({ Remote-Desktop })
$SchedTasksBtn.Add_Click({ Scheduled-Tasks })
$ShellbagsBtn.Add_Click({ Shellbags })
$ShimCacheBtn.Add_Click({ ShimCache })
$SysRestBtn.Add_Click({ System-Restore-Points })
$SRUMBtn.Add_Click({ SRUM })
$ServBtn.Add_Click({ Windows-Services })
$TimezoneBtn.Add_Click({ Timezone-Info })
$TimezoneBtn.Add_Click({ User-Accounts })
$UserAssistBtn.Add_Click({ UserAssist })
$ActionBtn.Add_Click({ Record-User-Actions })
$UserProfBtn.Add_Click({ User-Profiles })
$OneForAll.Add_Click({ OneForAll })
$OutputLocBtn.Add_Click({ Output-Location })
$AdvMenuBtn.Add_Click({ Advanced-Menu })
$HelloWorldBtn.Add_Click({ Hello-World })

function System-Info {}
function Active-Processes { Get-Process | Out-File .\RunningProcesses.txt }
function PhysicalMemory-Image {}
function Disk-Image {}
function Screenshot {}
function Browser-Cookies {}
function Browser-History {}
function Peripheral-Devices {}
function Scan-Registry {}
function Image-Scan {}
function Record-Registry {}
function Event-Logs {}
function AmCache {}
function Startup-Programs {}
function File-Associations {}
function Installed-Programs {}
function Jump-List {}
function KeyWord-Search {}
function DLL {}
function LNK {}
function MRU {}
function Swap-Files {}
function Prefetch {}
function Recycle-Bin {}
function Remote-Desktop {}
function Scheduled-Tasks {}
function Shellbags {}
function ShimCache {}
function System-Restore-Points {}
function SRUM {}
function Windows-Services { Get-Service | Out-File .\RunningServices.txt }
function Timezone-Info {}
function User-Accounts {}
function UserAssist {}
function Record-User-Actions {}
function User-Profiles {}
function OneForAll {}
function Output-Location {}
function Advanced-Menu {}
function Hello-World { 

	$saveText = "Hello World!"
	$fileName = "HelloWorld.txt"
	$saveLocation = ".\" + $fileName

	$success = Hello-World-Helper $saveText $saveLocation
	
	if(!$success)
	{	
		Check-And-Add-Log $FAIL_LOG $fileName
	}
	else
	{
		Check-And-Add-Log $SUCCESS_LOG $fileName
	}
}


function Hello-World-Helper([string]$saveText, [string]$saveLocation)
{
	<#For future implementations, we need to be waiting until the process finishes
		before checking if the file exists#>
		
	if(Test-Path $saveLocation)
	{
		$debugMSG = $saveLocation + " already exists"
		Add-Log $DEBUG_LOG $debugMSG
	}
	
	echo $saveText | Out-File $saveLocation
	$success = Test-Path $saveLocation

	return $success
}


#Add filename to specified log 
function Add-Log([string]$logFilePath, [string]$msgToLog)
{
	$datedMessage = "{0} - {1}" -f (Get-Date), $msgToLog
	
	#check if log exists
	if(!(Test-Path $logFilePath))
	{
		#creates new log file w/ logfilepath with str as first entry
		echo $datedMessage | Out-File $logFilePath
	}
	else
	{
		#Adds str to newline
		Add-Content $logFilePath $datedMessage
	}
}


#Check if filename is in the specified logfile 
function Search-For-Log-Entry([string]$logFilePath, [string]$entryToSearch)
{
	#if the log exists
	if((Test-Path $logFilePath))
	{
		#iterate through all lines in file and check if match 
		foreach($log in Get-Content $logFilePath)
		{
		#Match uses regex to str match 
			if($log -Match $entryToSearch)
			{
				return 1
			} 
		}
	}
	else
	{
		$debugMSG = "File " + $logFilePath + " does not exist."
		Add-Log $DEBUG_LOG $debugMSG
	}
	return 0
}


#Wrapper to check if file name already exists in the log and appends it if not
function Check-And-Add-Log([string]$logFilePath, [string]$entryToSearch)
{
	#Add to log if not already in log
	if(!(Search-For-Log-Entry $logFilePath $entryToSearch))
	{
		Add-Log $logFilePath $entryToSearch
	}
	else
	{
		$debugMSG = "File " + $entryToSearch + " already logged in " + $logFilePath
		Add-Log $DEBUG_LOG $debugMSG
	}
}


[void]$Form.ShowDialog()