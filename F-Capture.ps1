# Import powershell functions from Scripts directory
. "$PSScriptRoot\Scripts\~IMPORTS.ps1"

# Store log locations in global variables so functions can access them
$global:DEBUG_LOG   = "$PSScriptRoot\debugLog.txt"
$global:SUCCESS_LOG = "$PSScriptRoot\success.txt"
$global:FAIL_LOG    = "$PSScriptRoot\fail.txt"

# Set default output location to F-Capture.ps1 directory
# For testing & development purposes only, output should be redirected to a removable drive
$global:OUTPUT_DIR  = "$PSScriptRoot"

# Import PS Windows Forms wrapper because F-Capture is a GUI-based application
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Create elements to use when setting up main form
$Icon            = New-Object System.Drawing.Icon ("$PSScriptRoot\Resources\FCAP.ICO")
$DefaultBGColor = [System.Drawing.Color]::Black
$DefaultFGColor = [System.Drawing.Color]::WhiteSmoke

# Create main form and button elements
$MainForm                     = New-Object -TypeName System.Windows.Forms.Form
$MainForm.AutoScaleDimensions = (New-Object -TypeName System.Drawing.SizeF -ArgumentList @([System.Single]6,[System.Single]13))
$MainForm.AutoScaleMode       = [System.Windows.Forms.AutoScaleMode]::Font
$MainForm.AutoScroll          = $true
$MainForm.BackColor           = $DefaultBGColor
$MainForm.ClientSize          = New-Object System.Drawing.Size("1146,663")
$MainForm.Font                = 'Consolas,8.25'
$MainForm.ForeColor           = $DefaultFGColor
$MainForm.Icon                = $Icon
$MainForm.TopMost             = $false
$MainForm.MinimumSize         = New-Object System.Drawing.Size("1090,690")
$MainForm.Name                = 'MainForm'
$MainForm.StartPosition       = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainForm.Text                = 'F-Capture'

# Go Button config
$GoButton           = New-Object System.Windows.Forms.Button
$GoButton.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$GoButton.BackColor = [System.Drawing.Color]::LimeGreen
$GoButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$GoButton.Font      = 'Consolas,36'
$GoButton.ForeColor = [System.Drawing.Color]::Black
$GoButton.Location  = New-Object System.Drawing.Point(483,219)
$GoButton.Name      = 'GoButton'
$GoButton.Size      = New-Object System.Drawing.Size(177,141)
$GoButton.TabIndex  = 0
$GoButton.Text      = 'GO'
$GoButton.UseVisualStyleBackColor = $false

# F-Cap Title config
$FCapTitle             = New-Object System.Windows.Forms.Label
$FCapTitle.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$FCapTitle.BackColor   = [System.Drawing.Color]::Maroon
$FCapTitle.Font        = 'Elephant,48'
$FCapTitle.ForeColor   = [System.Drawing.Color]::WhiteSmoke
$FCapTitle.Location    = New-Object System.Drawing.Point(0,41)
$FCapTitle.MaximumSize = New-Object System.Drawing.Size(5000,102)
$FCapTitle.Name        = 'FCapTitle'
$FCapTitle.Size        = New-Object System.Drawing.Size(1147,102)
$FCapTitle.TabIndex    = 1
$FCapTitle.Text        = 'F-Capture'
$FCapTitle.TextAlign   = [System.Drawing.ContentAlignment]::MiddleCenter

# Output Directory Change button config
$OutDirBtn           = New-Object System.Windows.Forms.Button
$OutDirBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$OutDirBtn.BackColor = [System.Drawing.Color]::WhiteSmoke
$OutDirBtn.Font      = 'Consolas,8.25'
$OutDirBtn.ForeColor = [System.Drawing.Color]::Black
$OutDirBtn.Location  = New-Object System.Drawing.Point(682,419)
$OutDirBtn.Name      = 'OutDirBtn'
$OutDirBtn.Size      = New-Object System.Drawing.Size(33,27)
$OutDirBtn.TabIndex  = 3
$OutDirBtn.Text      = '...'
$OutDirBtn.UseVisualStyleBackColor = $false

# Output Directory Dropdown config
$OutDirComboBox                   = New-Object System.Windows.Forms.ComboBox
$OutDirComboBox.Anchor            = [System.Windows.Forms.AnchorStyles]::None
$OutDirComboBox.Font              = 'Consolas,12'
$OutDirComboBox.Location          = New-Object System.Drawing.Point(426,419)
$OutDirComboBox.Name              = 'OutDirComboBox'
$OutDirComboBox.Size              = New-Object System.Drawing.Size(250,27)
$OutDirComboBox.TabIndex          = 5
$OutDirComboBox.FormattingEnabled = $true

# Advanced Menu button config
$AdvancedBtn           = New-Object System.Windows.Forms.Button
$AdvancedBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$AdvancedBtn.BackColor = [System.Drawing.Color]::Firebrick
$AdvancedBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$AdvancedBtn.Font      = 'Consolas,12'
$AdvancedBtn.ForeColor = [System.Drawing.Color]::Black
$AdvancedBtn.Location  = New-Object System.Drawing.Point(483,499)
$AdvancedBtn.Name      = 'AdvancedBtn'
$AdvancedBtn.Size      = New-Object System.Drawing.Size(177,50)
$AdvancedBtn.TabIndex  = 4
$AdvancedBtn.Text      = 'Advanced Options'
$AdvancedBtn.UseVisualStyleBackColor = $false

# ------------Start of configs for things inside AdvOptionGrpBox------------

# Button to close Advanced Menu
$AdvMenuCloseBtn                            = New-Object System.Windows.Forms.Button
$AdvMenuCloseBtn.BackColor                  = [System.Drawing.Color]::LimeGreen
$AdvMenuCloseBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::LimeGreen
$AdvMenuCloseBtn.FlatStyle                  = [System.Windows.Forms.FlatStyle]::Popup
$AdvMenuCloseBtn.Font                       = 'Arial Rounded MT Bold,12'
$AdvMenuCloseBtn.ForeColor                  = [System.Drawing.Color]::Black
$AdvMenuCloseBtn.Location                   = New-Object System.Drawing.Point(1022,18)
$AdvMenuCloseBtn.Name                       = 'AdvMenuCloseBtn'
$AdvMenuCloseBtn.Size                       = New-Object System.Drawing.Size(28,26)
$AdvMenuCloseBtn.TabIndex                   = 48
$AdvMenuCloseBtn.Text                       = 'X'
$AdvMenuCloseBtn.UseVisualStyleBackColor = $false

# Profiles dropdown label
$ProfileDDLabel           = New-Object System.Windows.Forms.Label
$ProfileDDLabel.Location  = New-Object System.Drawing.Point(712,62)
$ProfileDDLabel.Name      = 'ProfileDDLabel'
$ProfileDDLabel.Size      = New-Object System.Drawing.Size(219,24)
$ProfileDDLabel.TabIndex  = 47
$ProfileDDLabel.Text      = 'User Profile'
$ProfileDDLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Button to load and apply a profile
$ProfileLoadBtn           = New-Object System.Windows.Forms.Button
$ProfileLoadBtn.BackColor = [System.Drawing.Color]::WhiteSmoke
$ProfileLoadBtn.ForeColor = [System.Drawing.Color]::Black
$ProfileLoadBtn.Location  = New-Object System.Drawing.Point(987,83)
$ProfileLoadBtn.Name      = 'ProfileLoadBtn'
$ProfileLoadBtn.Size      = New-Object System.Drawing.Size(44,38)
$ProfileLoadBtn.TabIndex  = 46
$ProfileLoadBtn.Text      = 'Load'
$ProfileLoadBtn.UseVisualStyleBackColor = $false

# Button to save current configuration with name from ProfileDropDown
$ProfileSaveBtn           = New-Object System.Windows.Forms.Button
$ProfileSaveBtn.BackColor = [System.Drawing.Color]::WhiteSmoke
$ProfileSaveBtn.ForeColor = [System.Drawing.Color]::Black
$ProfileSaveBtn.Location  = New-Object System.Drawing.Point(937,83)
$ProfileSaveBtn.Name      = 'ProfileSaveBtn'
$ProfileSaveBtn.Size      = New-Object System.Drawing.Size(44,38)
$ProfileSaveBtn.TabIndex  = 45
$ProfileSaveBtn.Text      = 'Save'
$ProfileSaveBtn.UseVisualStyleBackColor = $false

# Dropdown for choosing a profile to load or entering a name to save one
$ProfileDropdown                   = New-Object System.Windows.Forms.ComboBox
$ProfileDropdown.BackColor         = [System.Drawing.Color]::WhiteSmoke
$ProfileDropdown.Font              = 'Consolas,12'
$ProfileDropdown.FormattingEnabled = $true
$ProfileDropdown.Location          = New-Object System.Drawing.Point(712,89)
$ProfileDropdown.Name              = 'ProfileDropdown'
$ProfileDropdown.Size              = New-Object System.Drawing.Size(219,27)
$ProfileDropdown.TabIndex          = 44

# Disk Imaging checkbox list label
$DiskImgLabel           = New-Object System.Windows.Forms.Label
$DiskImgLabel.Location  = New-Object System.Drawing.Point(820,140)
$DiskImgLabel.Name      = 'DiskImgLabel'
$DiskImgLabel.Size      = New-Object System.Drawing.Size(103,24)
$DiskImgLabel.TabIndex  = 43
$DiskImgLabel.Text      = 'Disk Imaging'
$DiskImgLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# List of checkboxes that shows user all the drive that are available
# to make images of and lets the user check the ones they want
$DiskImgCBList                   = New-Object System.Windows.Forms.CheckedListBox
$DiskImgCBList.BackColor         = [System.Drawing.Color]::WhiteSmoke
$DiskImgCBList.CheckOnClick      = $true
$DiskImgCBList.Font              = 'Consolas,9.75'
$DiskImgCBList.ForeColor         = [System.Drawing.Color]::Black
$DiskImgCBList.FormattingEnabled = $true
$DiskImgCBList.Location          = New-Object System.Drawing.Point(820,167)
$DiskImgCBList.Name              = 'DiskImgCBList'
$DiskImgCBList.Size              = New-Object System.Drawing.Size(103,112)
$DiskImgCBList.TabIndex          = 42

# VNC Server button config
$VNCServerBtn           = New-Object System.Windows.Forms.Button
$VNCServerBtn.BackColor = [System.Drawing.Color]::WhiteSmoke
$VNCServerBtn.ForeColor = [System.Drawing.Color]::Black
$VNCServerBtn.Location  = New-Object System.Drawing.Point(895,312)
$VNCServerBtn.Name      = 'VNCServerBtn'
$VNCServerBtn.Size      = New-Object System.Drawing.Size(103,38)
$VNCServerBtn.TabIndex  = 41
$VNCServerBtn.Text      = 'VNC Server'
$VNCServerBtn.Enabled   = $false # Not implemented yet, so disable it to communicate that
$VNCServerBtn.UseVisualStyleBackColor = $false

# Textbox that holds the user-entered text to scan the registry for
$RegistryScanTB           = New-Object System.Windows.Forms.TextBox
$RegistryScanTB.BackColor = [System.Drawing.Color]::WhiteSmoke
$RegistryScanTB.Font      = 'Consolas,12'
$RegistryScanTB.Location  = New-Object System.Drawing.Point(713,393)
$RegistryScanTB.Name      = 'RegistryScanTB'
$RegistryScanTB.Size      = New-Object System.Drawing.Size(236,26)
$RegistryScanTB.TabIndex  = 40
$RegistryScanTB.Enabled   = $false # Not implemented yet, so disable it to communicate that

# Scan Registry button config
$RegistryScanBtn           = New-Object System.Windows.Forms.Button
$RegistryScanBtn.BackColor = [System.Drawing.Color]::WhiteSmoke
$RegistryScanBtn.ForeColor = [System.Drawing.Color]::Black
$RegistryScanBtn.Location  = New-Object System.Drawing.Point(955,387)
$RegistryScanBtn.Name      = 'RegistryScanBtn'
$RegistryScanBtn.Size      = New-Object System.Drawing.Size(77,38)
$RegistryScanBtn.TabIndex  = 39
$RegistryScanBtn.Text      = 'Scan Registry'
$RegistryScanBtn.Enabled   = $false # Not implemented yet, so disable it to communicate that
$RegistryScanBtn.UseVisualStyleBackColor = $false

# PuTTY button config
$PuTTYBtn           = New-Object System.Windows.Forms.Button
$PuTTYBtn.BackColor = [System.Drawing.Color]::WhiteSmoke
$PuTTYBtn.ForeColor = [System.Drawing.Color]::Black
$PuTTYBtn.Location  = New-Object System.Drawing.Point(744,312)
$PuTTYBtn.Name      = 'PuTTYBtn'
$PuTTYBtn.Size      = New-Object System.Drawing.Size(103,38)
$PuTTYBtn.TabIndex  = 38
$PuTTYBtn.Text      = 'PuTTY'
$PuTTYBtn.UseVisualStyleBackColor = $false

# Packet Capture checkbox config
$PacketCaptureCB            = New-Object System.Windows.Forms.CheckBox
$PacketCaptureCB.AutoSize   = $true
$PacketCaptureCB.Checked    = $true
$PacketCaptureCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PacketCaptureCB.Location   = New-Object System.Drawing.Point(386,382)
$PacketCaptureCB.Name       = 'PacketCaptureCB'
$PacketCaptureCB.Size       = New-Object System.Drawing.Size(124,19)
$PacketCaptureCB.TabIndex   = 37
$PacketCaptureCB.Text       = 'Packet Capture'
$PacketCaptureCB.UseVisualStyleBackColor = $true

# Network Share Info checkbox config
$NetworkShareInfoCB            = New-Object System.Windows.Forms.CheckBox
$NetworkShareInfoCB.AutoSize   = $true
$NetworkShareInfoCB.Checked    = $true
$NetworkShareInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$NetworkShareInfoCB.Location   = New-Object System.Drawing.Point(536,296)
$NetworkShareInfoCB.Name       = 'NetworkShareInfoCB'
$NetworkShareInfoCB.Size       = New-Object System.Drawing.Size(152,19)
$NetworkShareInfoCB.TabIndex   = 36
$NetworkShareInfoCB.Text       = 'Network Share Info'
$NetworkShareInfoCB.UseVisualStyleBackColor = $true

# Network Interfaces checkbox config
$NetworkInterfacesCB            = New-Object System.Windows.Forms.CheckBox
$NetworkInterfacesCB.AutoSize   = $true
$NetworkInterfacesCB.Checked    = $true
$NetworkInterfacesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$NetworkInterfacesCB.Location   = New-Object System.Drawing.Point(536,425)
$NetworkInterfacesCB.Name       = 'NetworkInterfacesCB'
$NetworkInterfacesCB.Size       = New-Object System.Drawing.Size(152,19)
$NetworkInterfacesCB.TabIndex   = 35
$NetworkInterfacesCB.Text       = 'Network Interfaces'
$NetworkInterfacesCB.UseVisualStyleBackColor = $true

# FileSystem Info checkbox config
$FileSystemInfoCB            = New-Object System.Windows.Forms.CheckBox
$FileSystemInfoCB.AutoSize   = $true
$FileSystemInfoCB.Checked    = $true
$FileSystemInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$FileSystemInfoCB.Location   = New-Object System.Drawing.Point(536,382)
$FileSystemInfoCB.Name       = 'FileSystemInfoCB'
$FileSystemInfoCB.Size       = New-Object System.Drawing.Size(138,19)
$FileSystemInfoCB.TabIndex   = 34
$FileSystemInfoCB.Text       = 'File System Info'
$FileSystemInfoCB.UseVisualStyleBackColor = $true

# AutoRun Items checkbox config
$AutoRunItemsCB            = New-Object System.Windows.Forms.CheckBox
$AutoRunItemsCB.AutoSize   = $true
$AutoRunItemsCB.Checked    = $true
$AutoRunItemsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$AutoRunItemsCB.Location   = New-Object System.Drawing.Point(536,339)
$AutoRunItemsCB.Name       = 'AutoRunItemsCB'
$AutoRunItemsCB.Size       = New-Object System.Drawing.Size(117,19)
$AutoRunItemsCB.TabIndex   = 33
$AutoRunItemsCB.Text       = 'AutoRun Items'
$AutoRunItemsCB.UseVisualStyleBackColor = $true

# UserAssist Info checkbox config
$UserAssistInfoCB            = New-Object System.Windows.Forms.CheckBox
$UserAssistInfoCB.AutoSize   = $true
$UserAssistInfoCB.Checked    = $true
$UserAssistInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$UserAssistInfoCB.Location   = New-Object System.Drawing.Point(536,253)
$UserAssistInfoCB.Name       = 'UserAssistInfoCB'
$UserAssistInfoCB.Size       = New-Object System.Drawing.Size(131,19)
$UserAssistInfoCB.TabIndex   = 32
$UserAssistInfoCB.Text       = 'UserAssist Info'
$UserAssistInfoCB.UseVisualStyleBackColor = $true

# Network Profiles checkbox config
$NetworkProfilesCB            = New-Object System.Windows.Forms.CheckBox
$NetworkProfilesCB.AutoSize   = $true
$NetworkProfilesCB.Checked    = $true
$NetworkProfilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$NetworkProfilesCB.Location   = New-Object System.Drawing.Point(536,210)
$NetworkProfilesCB.Name       = 'NetworkProfilesCB'
$NetworkProfilesCB.Size       = New-Object System.Drawing.Size(138,19)
$NetworkProfilesCB.TabIndex   = 31
$NetworkProfilesCB.Text       = 'Network Profiles'
$NetworkProfilesCB.UseVisualStyleBackColor = $true

# User Accounts checkbox config
$UserAccountsCB            = New-Object System.Windows.Forms.CheckBox
$UserAccountsCB.AutoSize   = $true
$UserAccountsCB.Checked    = $true
$UserAccountsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$UserAccountsCB.Location   = New-Object System.Drawing.Point(536,167)
$UserAccountsCB.Name       = 'UserAccountsCB'
$UserAccountsCB.Size       = New-Object System.Drawing.Size(117,19)
$UserAccountsCB.TabIndex   = 30
$UserAccountsCB.Text       = 'User Accounts'
$UserAccountsCB.UseVisualStyleBackColor = $true

# Timezone Info checkbox config
$TimezoneInfoCB            = New-Object System.Windows.Forms.CheckBox
$TimezoneInfoCB.AutoSize   = $true
$TimezoneInfoCB.Checked    = $true
$TimezoneInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$TimezoneInfoCB.Location   = New-Object System.Drawing.Point(536,122)
$TimezoneInfoCB.Name       = 'TimezoneInfoCB'
$TimezoneInfoCB.Size       = New-Object System.Drawing.Size(117,19)
$TimezoneInfoCB.TabIndex   = 29
$TimezoneInfoCB.Text       = 'Timezone Info'
$TimezoneInfoCB.UseVisualStyleBackColor = $true

# Windows Services checkbox config
$WindowsServicesCB            = New-Object System.Windows.Forms.CheckBox
$WindowsServicesCB.AutoSize   = $true
$WindowsServicesCB.Checked    = $true
$WindowsServicesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$WindowsServicesCB.Location   = New-Object System.Drawing.Point(536,79)
$WindowsServicesCB.Name       = 'WindowsServicesCB'
$WindowsServicesCB.Size       = New-Object System.Drawing.Size(138,19)
$WindowsServicesCB.TabIndex   = 28
$WindowsServicesCB.Text       = 'Windows Services'
$WindowsServicesCB.UseVisualStyleBackColor = $true

# SRUM Info checkbox config
$SRUMInfoCB            = New-Object System.Windows.Forms.CheckBox
$SRUMInfoCB.AutoSize   = $true
$SRUMInfoCB.Checked    = $true
$SRUMInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$SRUMInfoCB.Location   = New-Object System.Drawing.Point(536,33)
$SRUMInfoCB.Name       = 'SRUMInfoCB'
$SRUMInfoCB.Size       = New-Object System.Drawing.Size(89,19)
$SRUMInfoCB.TabIndex   = 27
$SRUMInfoCB.Text       = 'SRUM Info'
$SRUMInfoCB.UseVisualStyleBackColor = $true

# System Restore Points checkbox config
$RestorePointsCB            = New-Object System.Windows.Forms.CheckBox
$RestorePointsCB.AutoSize   = $true
$RestorePointsCB.Checked    = $true
$RestorePointsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RestorePointsCB.Location   = New-Object System.Drawing.Point(201,376)
$RestorePointsCB.Name       = 'RestorePointsCB'
$RestorePointsCB.Size       = New-Object System.Drawing.Size(173,19)
$RestorePointsCB.TabIndex   = 26
$RestorePointsCB.Text       = 'System Restore Points'
$RestorePointsCB.UseVisualStyleBackColor = $true

# Shim Cache checkbox config
$ShimCacheCB            = New-Object System.Windows.Forms.CheckBox
$ShimCacheCB.AutoSize   = $true
$ShimCacheCB.Checked    = $true
$ShimCacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ShimCacheCB.Location   = New-Object System.Drawing.Point(386,339)
$ShimCacheCB.Name       = 'ShimCacheCB'
$ShimCacheCB.Size       = New-Object System.Drawing.Size(89,19)
$ShimCacheCB.TabIndex   = 25
$ShimCacheCB.Text       = 'ShimCache'
$ShimCacheCB.UseVisualStyleBackColor = $true

# Shellbags checkbox config
$ShellbagsCB            = New-Object System.Windows.Forms.CheckBox
$ShellbagsCB.AutoSize   = $true
$ShellbagsCB.Checked    = $true
$ShellbagsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ShellbagsCB.Location   = New-Object System.Drawing.Point(386,296)
$ShellbagsCB.Name       = 'ShellbagsCB'
$ShellbagsCB.Size       = New-Object System.Drawing.Size(89,19)
$ShellbagsCB.TabIndex   = 24
$ShellbagsCB.Text       = 'Shellbags'
$ShellbagsCB.UseVisualStyleBackColor = $true

# Scheduled Tasks checkbox config
$ScheduledTasksCB            = New-Object System.Windows.Forms.CheckBox
$ScheduledTasksCB.AutoSize   = $true
$ScheduledTasksCB.Checked    = $true
$ScheduledTasksCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ScheduledTasksCB.Location   = New-Object System.Drawing.Point(386,253)
$ScheduledTasksCB.Name       = 'ScheduledTasksCB'
$ScheduledTasksCB.Size       = New-Object System.Drawing.Size(131,19)
$ScheduledTasksCB.TabIndex   = 23
$ScheduledTasksCB.Text       = 'Scheduled Tasks'
$ScheduledTasksCB.UseVisualStyleBackColor = $true

# RDP Cache checkbox config
$RDPCacheCB            = New-Object System.Windows.Forms.CheckBox
$RDPCacheCB.AutoSize   = $true
$RDPCacheCB.Checked    = $true
$RDPCacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RDPCacheCB.Location   = New-Object System.Drawing.Point(386,210)
$RDPCacheCB.Name       = 'RDPCacheCB'
$RDPCacheCB.Size       = New-Object System.Drawing.Size(89,19)
$RDPCacheCB.TabIndex   = 22
$RDPCacheCB.Text       = 'RDP Cache'
$RDPCacheCB.UseVisualStyleBackColor = $true

# Recycle Bin checkbox config
$RecycleBinCB            = New-Object System.Windows.Forms.CheckBox
$RecycleBinCB.AutoSize   = $true
$RecycleBinCB.Checked    = $true
$RecycleBinCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RecycleBinCB.Location   = New-Object System.Drawing.Point(386,167)
$RecycleBinCB.Name       = 'RecycleBinCB'
$RecycleBinCB.Size       = New-Object System.Drawing.Size(103,19)
$RecycleBinCB.TabIndex   = 21
$RecycleBinCB.Text       = 'Recycle Bin'
$RecycleBinCB.UseVisualStyleBackColor = $true

# Prefetch files checkbox config
$PrefetchFilesCB            = New-Object System.Windows.Forms.CheckBox
$PrefetchFilesCB.AutoSize   = $true
$PrefetchFilesCB.Checked    = $true
$PrefetchFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PrefetchFilesCB.Location   = New-Object System.Drawing.Point(386,122)
$PrefetchFilesCB.Name       = 'PrefetchFilesCB'
$PrefetchFilesCB.Size       = New-Object System.Drawing.Size(124,19)
$PrefetchFilesCB.TabIndex   = 20
$PrefetchFilesCB.Text       = 'Prefetch Files'
$PrefetchFilesCB.UseVisualStyleBackColor = $true

# Swap files checkbox config
$SwapFilesCB            = New-Object System.Windows.Forms.CheckBox
$SwapFilesCB.AutoSize   = $true
$SwapFilesCB.Checked    = $true
$SwapFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$SwapFilesCB.Location   = New-Object System.Drawing.Point(386,79)
$SwapFilesCB.Name       = 'SwapFilesCB'
$SwapFilesCB.Size       = New-Object System.Drawing.Size(96,19)
$SwapFilesCB.TabIndex   = 19
$SwapFilesCB.Text       = 'Swap Files'
$SwapFilesCB.UseVisualStyleBackColor = $true

# MRU Lists checkbox config
$MRUListsCB            = New-Object System.Windows.Forms.CheckBox
$MRUListsCB.AutoSize   = $true
$MRUListsCB.Checked    = $true
$MRUListsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$MRUListsCB.Location   = New-Object System.Drawing.Point(386,33)
$MRUListsCB.Name       = 'MRUListsCB'
$MRUListsCB.Size       = New-Object System.Drawing.Size(89,19)
$MRUListsCB.TabIndex   = 18
$MRUListsCB.Text       = 'MRU Lists'
$MRUListsCB.UseVisualStyleBackColor = $true

# LNK files checkbox config
$LNKFilesCB            = New-Object System.Windows.Forms.CheckBox
$LNKFilesCB.AutoSize   = $true
$LNKFilesCB.Checked    = $true
$LNKFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$LNKFilesCB.Location   = New-Object System.Drawing.Point(201,425)
$LNKFilesCB.Name       = 'LNKFilesCB'
$LNKFilesCB.Size       = New-Object System.Drawing.Size(89,19)
$LNKFilesCB.TabIndex   = 17
$LNKFilesCB.Text       = 'LNK Files'
$LNKFilesCB.UseVisualStyleBackColor = $true

# DLLs checkbox config
$DLLsCB            = New-Object System.Windows.Forms.CheckBox
$DLLsCB.AutoSize   = $true
$DLLsCB.Checked    = $true
$DLLsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$DLLsCB.Location   = New-Object System.Drawing.Point(386,425)
$DLLsCB.Name       = 'DLLsCB'
$DLLsCB.Size       = New-Object System.Drawing.Size(54,19)
$DLLsCB.TabIndex   = 16
$DLLsCB.Text       = 'DLLs'
$DLLsCB.UseVisualStyleBackColor = $true

# Keyword Searches checkbox config
$KeywordSearchesCB            = New-Object System.Windows.Forms.CheckBox
$KeywordSearchesCB.AutoSize   = $true
$KeywordSearchesCB.Checked    = $true
$KeywordSearchesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$KeywordSearchesCB.Location   = New-Object System.Drawing.Point(201,327)
$KeywordSearchesCB.Name       = 'KeywordSearchesCB'
$KeywordSearchesCB.Size       = New-Object System.Drawing.Size(138,19)
$KeywordSearchesCB.TabIndex   = 15
$KeywordSearchesCB.Text       = 'Keyword Searches'
$KeywordSearchesCB.UseVisualStyleBackColor = $true

# Jump Lists checkbox config
$JumpListsCB            = New-Object System.Windows.Forms.CheckBox
$JumpListsCB.AutoSize   = $true
$JumpListsCB.Checked    = $true
$JumpListsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$JumpListsCB.Location   = New-Object System.Drawing.Point(201,278)
$JumpListsCB.Name       = 'JumpListsCB'
$JumpListsCB.Size       = New-Object System.Drawing.Size(96,19)
$JumpListsCB.TabIndex   = 14
$JumpListsCB.Text       = 'Jump Lists'
$JumpListsCB.UseVisualStyleBackColor = $true

# Installed Programs checkbox config
$InstalledProgramsCB            = New-Object System.Windows.Forms.CheckBox
$InstalledProgramsCB.AutoSize   = $true
$InstalledProgramsCB.Checked    = $true
$InstalledProgramsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$InstalledProgramsCB.Location   = New-Object System.Drawing.Point(201,229)
$InstalledProgramsCB.Name       = 'InstalledProgramsCB'
$InstalledProgramsCB.Size       = New-Object System.Drawing.Size(152,19)
$InstalledProgramsCB.TabIndex   = 13
$InstalledProgramsCB.Text       = 'Installed Programs'
$InstalledProgramsCB.UseVisualStyleBackColor = $true

# File Associations checkbox config
$FileAssociationsCB            = New-Object System.Windows.Forms.CheckBox
$FileAssociationsCB.AutoSize   = $true
$FileAssociationsCB.Checked    = $true
$FileAssociationsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$FileAssociationsCB.Location   = New-Object System.Drawing.Point(201,180)
$FileAssociationsCB.Name       = 'FileAssociationsCB'
$FileAssociationsCB.Size       = New-Object System.Drawing.Size(145,19)
$FileAssociationsCB.TabIndex   = 12
$FileAssociationsCB.Text       = 'File Associations'
$FileAssociationsCB.UseVisualStyleBackColor = $true

# Startup Programs checkbox config
$StartupProgramsCB            = New-Object System.Windows.Forms.CheckBox
$StartupProgramsCB.AutoSize   = $true
$StartupProgramsCB.Checked    = $true
$StartupProgramsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$StartupProgramsCB.Location   = New-Object System.Drawing.Point(201,131)
$StartupProgramsCB.Name       = 'StartupProgramsCB'
$StartupProgramsCB.Size       = New-Object System.Drawing.Size(138,19)
$StartupProgramsCB.TabIndex   = 11
$StartupProgramsCB.Text       = 'Startup Programs'
$StartupProgramsCB.UseVisualStyleBackColor = $true

# AmCache checkbox config
$AmCacheCB            = New-Object System.Windows.Forms.CheckBox
$AmCacheCB.AutoSize   = $true
$AmCacheCB.Checked    = $true
$AmCacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$AmCacheCB.Location   = New-Object System.Drawing.Point(201,82)
$AmCacheCB.Name       = 'AmCacheCB'
$AmCacheCB.Size       = New-Object System.Drawing.Size(75,19)
$AmCacheCB.TabIndex   = 10
$AmCacheCB.Text       = 'AmCache'
$AmCacheCB.UseVisualStyleBackColor = $true

# Windows Event Logs checkbox config
$EventLogsCB            = New-Object System.Windows.Forms.CheckBox
$EventLogsCB.AutoSize   = $true
$EventLogsCB.Checked    = $true
$EventLogsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$EventLogsCB.Location   = New-Object System.Drawing.Point(201,33)
$EventLogsCB.Name       = 'EventLogsCB'
$EventLogsCB.Size       = New-Object System.Drawing.Size(96,19)
$EventLogsCB.TabIndex   = 9
$EventLogsCB.Text       = 'Event Logs'
$EventLogsCB.UseVisualStyleBackColor = $true

# Registry recording checkbox config
$RegistryCB            = New-Object System.Windows.Forms.CheckBox
$RegistryCB.AutoSize   = $true
$RegistryCB.Checked    = $true
$RegistryCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RegistryCB.Location   = New-Object System.Drawing.Point(23,425)
$RegistryCB.Name       = 'RegistryCB'
$RegistryCB.Size       = New-Object System.Drawing.Size(82,19)
$RegistryCB.TabIndex   = 8
$RegistryCB.Text       = 'Registry'
$RegistryCB.UseVisualStyleBackColor = $true

# Image Scan checkbox config
$ImageScanCB            = New-Object System.Windows.Forms.CheckBox
$ImageScanCB.AutoSize   = $true
$ImageScanCB.Checked    = $true
$ImageScanCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ImageScanCB.Location   = New-Object System.Drawing.Point(23,376)
$ImageScanCB.Name       = 'ImageScanCB'
$ImageScanCB.Size       = New-Object System.Drawing.Size(96,19)
$ImageScanCB.TabIndex   = 7
$ImageScanCB.Text       = 'Image Scan'
$ImageScanCB.UseVisualStyleBackColor = $true

# Peripheral Devices checkbox config
$PeripheralDevicesCB            = New-Object System.Windows.Forms.CheckBox
$PeripheralDevicesCB.AutoSize   = $true
$PeripheralDevicesCB.Checked    = $true
$PeripheralDevicesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PeripheralDevicesCB.Location   = New-Object System.Drawing.Point(23,327)
$PeripheralDevicesCB.Name       = 'PeripheralDevicesCB'
$PeripheralDevicesCB.Size       = New-Object System.Drawing.Size(152,19)
$PeripheralDevicesCB.TabIndex   = 6
$PeripheralDevicesCB.Text       = 'Peripheral Devices'
$PeripheralDevicesCB.UseVisualStyleBackColor = $true

# Browser History checkbox config
$BrowserHistoryCB            = New-Object System.Windows.Forms.CheckBox
$BrowserHistoryCB.AutoSize   = $true
$BrowserHistoryCB.Checked    = $true
$BrowserHistoryCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$BrowserHistoryCB.Location   = New-Object System.Drawing.Point(23,278)
$BrowserHistoryCB.Name       = 'BrowserHistoryCB'
$BrowserHistoryCB.Size       = New-Object System.Drawing.Size(131,19)
$BrowserHistoryCB.TabIndex   = 5
$BrowserHistoryCB.Text       = 'Browser History'
$BrowserHistoryCB.UseVisualStyleBackColor = $true

# Browser Cookies checkbox config
$BrowserCookiesCB            = New-Object System.Windows.Forms.CheckBox
$BrowserCookiesCB.AutoSize   = $true
$BrowserCookiesCB.Checked    = $true
$BrowserCookiesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$BrowserCookiesCB.Location   = New-Object System.Drawing.Point(23,229)
$BrowserCookiesCB.Name       = 'BrowserCookiesCB'
$BrowserCookiesCB.Size       = New-Object System.Drawing.Size(131,19)
$BrowserCookiesCB.TabIndex   = 4
$BrowserCookiesCB.Text       = 'Browser Cookies'
$BrowserCookiesCB.UseVisualStyleBackColor = $true

# Open Window Screenshots checkbox config
$ScreenshotsCB            = New-Object System.Windows.Forms.CheckBox
$ScreenshotsCB.AutoSize   = $true
$ScreenshotsCB.Checked    = $true
$ScreenshotsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ScreenshotsCB.Location   = New-Object System.Drawing.Point(23,180)
$ScreenshotsCB.Name       = 'ScreenshotsCB'
$ScreenshotsCB.Size       = New-Object System.Drawing.Size(152,19)
$ScreenshotsCB.TabIndex   = 3
$ScreenshotsCB.Text       = 'Screenshot Windows'
$ScreenshotsCB.UseVisualStyleBackColor = $true

# Memory Imaging checkbox config
$MemoryImageCB            = New-Object System.Windows.Forms.CheckBox
$MemoryImageCB.AutoSize   = $true
$MemoryImageCB.Checked    = $true
$MemoryImageCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$MemoryImageCB.Location   = New-Object System.Drawing.Point(23,131)
$MemoryImageCB.Name       = 'MemoryImageCB'
$MemoryImageCB.Size       = New-Object System.Drawing.Size(124,19)
$MemoryImageCB.TabIndex   = 2
$MemoryImageCB.Text       = 'Memory Imaging'
$MemoryImageCB.UseVisualStyleBackColor = $true

# Active Processes checkbox config
$ActiveProcessesCB            = New-Object System.Windows.Forms.CheckBox
$ActiveProcessesCB.AutoSize   = $true
$ActiveProcessesCB.Checked    = $true
$ActiveProcessesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ActiveProcessesCB.Location   = New-Object System.Drawing.Point(23,82)
$ActiveProcessesCB.Name       = 'ActiveProcessesCB'
$ActiveProcessesCB.Size       = New-Object System.Drawing.Size(138,19)
$ActiveProcessesCB.TabIndex   = 1
$ActiveProcessesCB.Text       = 'Active Processes'
$ActiveProcessesCB.UseVisualStyleBackColor = $true

# System Information checkbox config
$SystemInfoCB            = New-Object System.Windows.Forms.CheckBox
$SystemInfoCB.AutoSize   = $true
$SystemInfoCB.Checked    = $true
$SystemInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$SystemInfoCB.Location   = New-Object System.Drawing.Point(23,33)
$SystemInfoCB.Name       = 'SystemInfoCB'
$SystemInfoCB.Size       = New-Object System.Drawing.Size("103,19")
$SystemInfoCB.TabIndex   = 0
$SystemInfoCB.Text       = 'System Info'
$SystemInfoCB.UseVisualStyleBackColor = $true

# ------------End of configs for things inside AdvOptionGrpBox------------

# Group Box holding Advanced Menu items
$AdvOptionGrpBox             = New-Object System.Windows.Forms.GroupBox
$AdvOptionGrpBox.BackColor   = [System.Drawing.Color]::Black
$AdvOptionGrpBox.Font        = 'Consolas,9.75'
$AdvOptionGrpBox.ForeColor   = [System.Drawing.Color]::White
$AdvOptionGrpBox.Location    = New-Object System.Drawing.Point(41,160)
$AdvOptionGrpBox.MinimumSize = New-Object System.Drawing.Size(1060,482)
$AdvOptionGrpBox.Name        = 'AdvOptionGrpBox'
$AdvOptionGrpBox.Size        = New-Object System.Drawing.Size(1060,482)
$AdvOptionGrpBox.TabIndex    = 8
$AdvOptionGrpBox.TabStop     = $false
$AdvOptionGrpBox.Text        = 'Advanced-Menu'
$AdvOptionGrpBox.Visible     = $false
$AdvOptionGrpBox.Controls.Add($AdvMenuCloseBtn)
$AdvOptionGrpBox.Controls.Add($ProfileDDLabel)
$AdvOptionGrpBox.Controls.Add($ProfileLoadBtn)
$AdvOptionGrpBox.Controls.Add($ProfileSaveBtn)
$AdvOptionGrpBox.Controls.Add($ProfileDropdown)
$AdvOptionGrpBox.Controls.Add($DiskImgLabel)
$AdvOptionGrpBox.Controls.Add($DiskImgCBList)
$AdvOptionGrpBox.Controls.Add($VNCServerBtn)
$AdvOptionGrpBox.Controls.Add($RegistryScanTB)
$AdvOptionGrpBox.Controls.Add($RegistryScanBtn)
$AdvOptionGrpBox.Controls.Add($PuTTYBtn)
$AdvOptionGrpBox.Controls.Add($PacketCaptureCB)
$AdvOptionGrpBox.Controls.Add($NetworkShareInfoCB)
$AdvOptionGrpBox.Controls.Add($NetworkInterfacesCB)
$AdvOptionGrpBox.Controls.Add($FileSystemInfoCB)
$AdvOptionGrpBox.Controls.Add($AutoRunItemsCB)
$AdvOptionGrpBox.Controls.Add($UserAssistInfoCB)
$AdvOptionGrpBox.Controls.Add($NetworkProfilesCB)
$AdvOptionGrpBox.Controls.Add($UserAccountsCB)
$AdvOptionGrpBox.Controls.Add($TimezoneInfoCB)
$AdvOptionGrpBox.Controls.Add($WindowsServicesCB)
$AdvOptionGrpBox.Controls.Add($SRUMInfoCB)
$AdvOptionGrpBox.Controls.Add($RestorePointsCB)
$AdvOptionGrpBox.Controls.Add($ShimCacheCB)
$AdvOptionGrpBox.Controls.Add($ShellbagsCB)
$AdvOptionGrpBox.Controls.Add($ScheduledTasksCB)
$AdvOptionGrpBox.Controls.Add($RDPCacheCB)
$AdvOptionGrpBox.Controls.Add($RecycleBinCB)
$AdvOptionGrpBox.Controls.Add($PrefetchFilesCB)
$AdvOptionGrpBox.Controls.Add($SwapFilesCB)
$AdvOptionGrpBox.Controls.Add($MRUListsCB)
$AdvOptionGrpBox.Controls.Add($LNKFilesCB)
$AdvOptionGrpBox.Controls.Add($DLLsCB)
$AdvOptionGrpBox.Controls.Add($KeywordSearchesCB)
$AdvOptionGrpBox.Controls.Add($JumpListsCB)
$AdvOptionGrpBox.Controls.Add($InstalledProgramsCB)
$AdvOptionGrpBox.Controls.Add($FileAssociationsCB)
$AdvOptionGrpBox.Controls.Add($StartupProgramsCB)
$AdvOptionGrpBox.Controls.Add($AmCacheCB)
$AdvOptionGrpBox.Controls.Add($EventLogsCB)
$AdvOptionGrpBox.Controls.Add($RegistryCB)
$AdvOptionGrpBox.Controls.Add($ImageScanCB)
$AdvOptionGrpBox.Controls.Add($PeripheralDevicesCB)
$AdvOptionGrpBox.Controls.Add($BrowserHistoryCB)
$AdvOptionGrpBox.Controls.Add($BrowserCookiesCB)
$AdvOptionGrpBox.Controls.Add($ScreenshotsCB)
$AdvOptionGrpBox.Controls.Add($MemoryImageCB)
$AdvOptionGrpBox.Controls.Add($ActiveProcessesCB)
$AdvOptionGrpBox.Controls.Add($SystemInfoCB)

# Add buttons to the main form's list of elements
$MainForm.Controls.Add($FCapTitle)
$MainForm.Controls.Add($GoButton)
$MainForm.Controls.Add($OutDirComboBox)
$MainForm.Controls.Add($OutDirBtn)
$MainForm.Controls.Add($AdvancedBtn)
$MainForm.Controls.Add($AdvOptionGrpBox)

# Add functions to their respective button's event handler
$AdvancedBtn.Add_Click({ Open-Advanced-Menu })
$AdvMenuCloseBtn.Add_Click({ Close-Advanced-Menu })
$GoButton.Add_Click({ OneForAll })
$RegistryScanBtn.Add_Click({ Scan-Registry })
$ProfileSaveBtn.Add_Click({ Save-User-Profile })
$ProfileLoadBtn.Add_Click({ Load-User-Profile })
$PuTTYBtn.Add_Click({ Putty })
$OutDirComboBox.Add_SelectedIndexChanged({ Changed-OutDir-In-Box })
$OutDirBtn.Add_Click({ Output-Location })

# Run the main window
$MainForm.ShowDialog()
