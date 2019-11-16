# Import powershell functions from Scripts directory
. "$PSScriptRoot\Scripts\~IMPORTS.ps1"

# Import PS Windows Forms wrapper because F-Capture is a GUI-based application
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Management.Automation
[System.Windows.Forms.Application]::EnableVisualStyles()

# Store log locations in global variables so functions can access them
$global:DEBUG_LOG   = "$PSScriptRoot\Logs\debugLog.txt"
$global:SUCCESS_LOG = "$PSScriptRoot\Logs\success.txt"
$global:FAIL_LOG    = "$PSScriptRoot\Logs\fail.txt"

# Set default output location to F-Capture.ps1 directory
# For testing & development purposes only, output should be redirected to a removable drive
$global:OUTPUT_DIR  = "$PSScriptRoot"

# Hides console soonafter starting if $DEV_MODE is $false
$global:DEV_MODE    = $true
if(!$DEV_MODE){ Hide-Console }

# Checks whether the drive F-Capture is on is NTFS, true if NTFS, false otherwise
$global:ON_NTFS     = Check-RD-Filesystem

# Ordered Hash Table: Records all program configuration changes (aka state changes)
# StateRecord keys are date/time, and values are states, which are hash tables themselves
$global:StateRecord = [ordered]@{}

# Profiles is a hash table. Profiles' keys are profile names, and values are states.
$global:Profiles    = [ordered]@{}

# Visual settings for various UI elements
$Icon               = New-Object System.Drawing.Icon("$PSScriptRoot\Resources\FCAP.ICO")
$VersionNumber      = 'Version 0.1.0'
$MainFormBGColor    = [System.Drawing.Color]::FromArgb(219,228,235)
$MainFormFGColor    = [System.Drawing.Color]::FromArgb(255,255,255)
$BannerBGColor      = [System.Drawing.Color]::FromArgb(5,78,111)
$BannerFGColor      = [System.Drawing.Color]::FromArgb(0,0,0)
$GroupBoxBGColor    = [System.Drawing.Color]::FromArgb(0,0,0)
$GroupBoxFGColor    = [System.Drawing.Color]::FromArgb(255,255,255)
$ButtonBGColor      = [System.Drawing.Color]::FromArgb(255,255,255)
$ButtonFGColor      = [System.Drawing.Color]::FromArgb(0,0,0)
$GoBtnBGColor       = [System.Drawing.Color]::LimeGreen
$AdvBtnBGColor      = [System.Drawing.Color]::Firebrick
$CheckmarkBGColor   = [System.Drawing.Color]::Transparent
$MStripFGColor      = [System.Drawing.Color]::FromArgb(0,0,0)
$WarningLblColor    = [System.Drawing.Color]::Yellow
$LinkLblColor       = [System.Drawing.Color]::LimeGreen

# Create main form and button elements
$MainForm                     = New-Object System.Windows.Forms.Form
$MainForm.AutoScaleDimensions = New-Object System.Drawing.SizeF(6,13)
$MainForm.AutoScaleMode       = [System.Windows.Forms.AutoScaleMode]::Dpi
$MainForm.AutoScroll          = $true
$MainForm.BackColor           = $MainFormBGColor
$MainForm.ClientSize          = New-Object System.Drawing.Size(1146,690)
$MainForm.Font                = 'Consolas,8.25'
$MainForm.ForeColor           = $MainFormFGColor
$MainForm.Icon                = $Icon
$MainForm.TopMost             = $false
$MainForm.MinimumSize         = New-Object System.Drawing.Size(1090,690)
$MainForm.Name                = 'MainForm'
$MainForm.StartPosition       = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainForm.Text                = 'F-Capture'

# Tooltip settings (Applies to all tooltips in the entire UI)
$Tooltip = New-Object System.Windows.Forms.ToolTip
$Tooltip.AutomaticDelay = 300
$Tooltip.AutoPopDelay   = 30000
$Tooltip.IsBalloon      = $false
$Tooltip.UseAnimation   = $true
$Tooltip.UseFading      = $true
$Tooltip.Active         = $true

# ------------ Splashscreen Elements ------------

# Warning Label
$WarningLbl           = New-Object System.Windows.Forms.Label
$WarningLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$WarningLbl.Font      = New-Object System.Drawing.Font('Cambria',30,[System.Drawing.FontStyle]::Bold)
$WarningLbl.ForeColor = $WarningLblColor
$WarningLbl.Location  = New-Object System.Drawing.Point(472,20)
$WarningLbl.Name      = 'WarningLbl'
$WarningLbl.Size      = New-Object System.Drawing.Size(201,47)
$WarningLbl.Text      = 'WARNING'
$WarningLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Info Label
$InfoLbl           = New-Object System.Windows.Forms.Label
$InfoLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$InfoLbl.Font      = New-Object System.Drawing.Font('Consolas',14.25,[System.Drawing.FontStyle]::Bold)
$InfoLbl.ForeColor = [System.Drawing.Color]::White
$InfoLbl.Location  = New-Object System.Drawing.Point(116,79)
$InfoLbl.Name      = 'InfoLbl'
$InfoLbl.Size      = New-Object System.Drawing.Size(914,188)
$InfoLbl.Text      = Get-Content "$PSScriptRoot\Resources\SplashscreenInfo.txt" -Raw
$InfoLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Exit Button
$ExitBtn           = New-Object System.Windows.Forms.Button
$ExitBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$ExitBtn.BackColor = [System.Drawing.Color]::White
$ExitBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$ExitBtn.Font      = 'Consolas,12'
$ExitBtn.ForeColor = [System.Drawing.Color]::Black
$ExitBtn.Location  = New-Object System.Drawing.Point(637,280)
$ExitBtn.Name      = 'ExitBtn'
$ExitBtn.Size      = New-Object System.Drawing.Size(152,48)
$ExitBtn.TabIndex  = 1
$ExitBtn.Text      = 'EXIT'

# Accept Button
$AcceptBtn           = New-Object System.Windows.Forms.Button
$AcceptBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$AcceptBtn.BackColor = [System.Drawing.Color]::White
$AcceptBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$AcceptBtn.Font      = 'Consolas,12'
$AcceptBtn.ForeColor = [System.Drawing.Color]::Black
$AcceptBtn.Location  = New-Object System.Drawing.Point(348,280)
$AcceptBtn.Name      = 'AcceptBtn'
$AcceptBtn.Size      = New-Object System.Drawing.Size(152,48)
$AcceptBtn.TabIndex  = 0
$AcceptBtn.Text      = 'ACCEPT'

# Splashscreen Top Panel
$SSTopPanel             = New-Object System.Windows.Forms.Panel
$SSTopPanel.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$SSTopPanel.BackColor   = $BannerBGColor
$SSTopPanel.Location    = New-Object System.Drawing.Point(0,180)
$SSTopPanel.MaximumSize = New-Object System.Drawing.Size(10000,347)
$SSTopPanel.Name        = 'SSTopPanel'
$SSTopPanel.Size        = New-Object System.Drawing.Size(1146,347)
$SSTopPanel.TabIndex    = 1
$SSTopPanel.Controls.Add($ExitBtn)
$SSTopPanel.Controls.Add($AcceptBtn)
$SSTopPanel.Controls.Add($InfoLbl)
$SSTopPanel.Controls.Add($WarningLbl)

# Version Number Label
$VersionNumLbl           = New-Object System.Windows.Forms.Label
$VersionNumLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$VersionNumLbl.AutoSize  = $true
$VersionNumLbl.BackColor = [System.Drawing.Color]::Transparent
$VersionNumLbl.Font      = New-Object System.Drawing.Font('Consolas',14.25,[System.Drawing.FontStyle]::Bold)
$VersionNumLbl.ForeColor = [System.Drawing.Color]::White
$VersionNumLbl.Location  = New-Object System.Drawing.Point(57,9)
$VersionNumLbl.Name      = 'VersionNumLbl'
$VersionNumLbl.Size      = New-Object System.Drawing.Size(140,22)
$VersionNumLbl.Text      = $VersionNumber
$VersionNumLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Website Label
$WebsiteLbl           = New-Object System.Windows.Forms.LinkLabel
$WebsiteLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$WebsiteLbl.AutoSize  = $true
$WebsiteLbl.BackColor = [System.Drawing.Color]::Transparent
$WebsiteLbl.Font      = 'Consolas,12'
$WebsiteLbl.ForeColor = [System.Drawing.Color]::Black
$WebsiteLbl.LinkColor = $LinkLblColor
$WebsiteLbl.Location  = New-Object System.Drawing.Point(338,11)
$WebsiteLbl.Name      = 'WebsiteLbl'
$WebsiteLbl.Size      = New-Object System.Drawing.Size(162,19)
$WebsiteLbl.Text      = 'F-Capture Website'
$WebsiteLbl.TabIndex  = 0

# Github Label
$GithubLbl           = New-Object System.Windows.Forms.LinkLabel
$GithubLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$GithubLbl.AutoSize  = $true
$GithubLbl.BackColor = [System.Drawing.Color]::Transparent
$GithubLbl.Font      = 'Consolas,12'
$GithubLbl.ForeColor = [System.Drawing.Color]::Black
$GithubLbl.LinkColor = $LinkLblColor
$GithubLbl.Location  = New-Object System.Drawing.Point(636,11)
$GithubLbl.Name      = 'GithubLbl'
$GithubLbl.Size      = New-Object System.Drawing.Size(153,19)
$GithubLbl.Text      = 'F-Capture Github'
$GithubLbl.TabIndex  = 1

# Team Name Label
$TeamNameLbl           = New-Object System.Windows.Forms.Label
$TeamNameLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$TeamNameLbl.AutoSize  = $true
$TeamNameLbl.BackColor = [System.Drawing.Color]::Transparent
$TeamNameLbl.Font      = New-Object System.Drawing.Font('Consolas',14.25,[System.Drawing.FontStyle]::Bold)
$TeamNameLbl.ForeColor = [System.Drawing.Color]::White
$TeamNameLbl.Location  = New-Object System.Drawing.Point(880,9)
$TeamNameLbl.Name      = 'TeamNameLbl'
$TeamNameLbl.Size      = New-Object System.Drawing.Size(210,22)
$TeamNameLbl.Text      = 'F-Capture Team, 2019'
$TeamNameLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Splashscreen Bottom Panel
$SSBottomPanel             = New-Object System.Windows.Forms.Panel
$SSBottomPanel.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$SSBottomPanel.BackColor   = $BannerBGColor
$SSBottomPanel.Location    = New-Object System.Drawing.Point(0,623)
$SSBottomPanel.MaximumSize = New-Object System.Drawing.Size(10000,40)
$SSBottomPanel.Name        = 'SSBottomPanel'
$SSBottomPanel.Size        = New-Object System.Drawing.Size(1146,40)
$SSBottomPanel.TabIndex    = 2
$SSBottomPanel.Controls.Add($GithubLbl)
$SSBottomPanel.Controls.Add($WebsiteLbl)
$SSBottomPanel.Controls.Add($VersionNumLbl)
$SSBottomPanel.Controls.Add($TeamNameLbl)

# ------------ Menu Strip ------------

# Go Menu Item
$GoSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$GoSMItem.AutoToolTip = $true
$GoSMItem.Name        = 'GoSMItem'
$GoSMItem.Size        = New-Object System.Drawing.Size(180,22)
$GoSMItem.Text        = 'Go'
$GoSMItem.ToolTipText = "Start the scanning process"

# Exit Menu Item
$ExitSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$ExitSMItem.AutoToolTip = $true
$ExitSMItem.Name        = 'ExitSMItem'
$ExitSMItem.Size        = New-Object System.Drawing.Size(180,22)
$ExitSMItem.Text        = 'Exit'
$ExitSMItem.ToolTipText = "Exit the program"

# File Submenu
$FileSMItem           = New-Object System.Windows.Forms.ToolStripMenuItem
$FileSMItem.ForeColor = $MStripFGColor
$FileSMItem.Name      = 'FileSMItem'
$FileSMItem.Size      = New-Object System.Drawing.Size(37,20)
$FileSMItem.Text      = 'File'
[void]$FileSMItem.DropDownItems.Add($GoSMItem)
[void]$FileSMItem.DropDownItems.Add($ExitSMItem)

# PuTTY Menu Item
$PuTTYSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$PuTTYSMItem.AutoToolTip = $true
$PuTTYSMItem.Name        = 'PuTTYSMItem'
$PuTTYSMItem.Size        = New-Object System.Drawing.Size(180,22)
$PuTTYSMItem.Text        = 'PuTTY'
$PuTTYSMItem.ToolTipText = "Open PuTTY, a free and open-source terminal emulator,`nserial console and network file transfer application"

# VNCServer Menu Item
$VNCServerSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$VNCServerSMItem.AutoToolTip = $true
$VNCServerSMItem.Name        = 'VNCServerSMItem'
$VNCServerSMItem.Size        = New-Object System.Drawing.Size(180,22)
$VNCServerSMItem.Text        = 'VNC Server'
$VNCServerSMItem.ToolTipText = "Not yet implemented"
$VNCServerSMItem.Enabled     = $false

# Data Recovery Menu Item
$DataRecoverySMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$DataRecoverySMItem.AutoToolTip = $true
$DataRecoverySMItem.Name        = 'DataRecoverySMItem'
$DataRecoverySMItem.Size        = New-Object System.Drawing.Size(180,22)
$DataRecoverySMItem.Text        = 'Data Recovery'
$DataRecoverySMItem.ToolTipText = "Starts TestDisk data recovery software"

# Scan Registry Menu Item
$ScanRegistrySMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$ScanRegistrySMItem.AutoToolTip = $true
$ScanRegistrySMItem.Name        = 'ScanRegistrySMItem'
$ScanRegistrySMItem.Size        = New-Object System.Drawing.Size(180,22)
$ScanRegistrySMItem.Text        = 'Scan Registry'
$ScanRegistrySMItem.ToolTipText = "Open RegScanner, a small utility that allows you to scan the Registry`nfor a particular string and then view or export the matches to a .reg file"
$ScanRegistrySMItem.Enabled     = $true

# Tools Submenu
$ToolsSMItem           = New-Object System.Windows.Forms.ToolStripMenuItem
$ToolsSMItem.ForeColor = $MStripFGColor
$ToolsSMItem.Name      = 'ToolsSMItem'
$ToolsSMItem.Size      = New-Object System.Drawing.Size(47,20)
$ToolsSMItem.Text      = 'Tools'
[void]$ToolsSMItem.DropDownItems.Add($PuTTYSMItem)
[void]$ToolsSMItem.DropDownItems.Add($VNCServerSMItem)
[void]$ToolsSMItem.DropDownItems.Add($DataRecoverySMItem)
[void]$ToolsSMItem.DropDownItems.Add($ScanRegistrySMItem)

# Website Menu Item
$WebsiteSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$WebsiteSMItem.AutoToolTip = $true
$WebsiteSMItem.Name        = 'WebsiteSMItem'
$WebsiteSMItem.Size        = New-Object System.Drawing.Size(180,22)
$WebsiteSMItem.Text        = 'Website'
$WebsiteSMItem.ToolTipText = "Open the F-Capture website in the default browser"

# Github Menu Item
$GithubSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$GithubSMItem.AutoToolTip = $true
$GithubSMItem.Name        = 'GithubSMItem'
$GithubSMItem.Size        = New-Object System.Drawing.Size(180,22)
$GithubSMItem.Text        = 'Github'
$GithubSMItem.ToolTipText = "Open the F-Capture Github Repository in the default browser"

# Wiki Menu Item
$WikiSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$WikiSMItem.Name        = 'WikiSMItem'
$WikiSMItem.Size        = New-Object System.Drawing.Size(180,22)
$WikiSMItem.Text        = 'Wiki'
$WikiSMItem.ToolTipText = "Open the F-Capture wiki in the default browser"

# Help Submenu
$HelpSMItem           = New-Object System.Windows.Forms.ToolStripMenuItem
$HelpSMItem.ForeColor = $MStripFGColor
$HelpSMItem.Name      = 'HelpSMItem'
$HelpSMItem.Size      = New-Object System.Drawing.Size(44,20)
$HelpSMItem.Text      = 'Help'
[void]$HelpSMItem.DropDownItems.Add($WebsiteSMItem)
[void]$HelpSMItem.DropDownItems.Add($GithubSMItem)
[void]$HelpSMItem.DropDownItems.Add($WikiSMItem)

# Menu Strip itself
$MenuStrip             = New-Object System.Windows.Forms.MenuStrip
$MenuStrip.Location    = New-Object System.Drawing.Point(0,0)
$MenuStrip.MaximumSize = New-Object System.Drawing.Size(10000,24)
$MenuStrip.Name        = 'MenuStrip'
$MenuStrip.Size        = New-Object System.Drawing.Size(1146,24)
$MenuStrip.Visible     = $false
[void]$MenuStrip.Items.Add($FileSMItem)
[void]$MenuStrip.Items.Add($ToolsSMItem)
[void]$MenuStrip.Items.Add($HelpSMItem)

# ------------ Main Menu Elements ------------

# Go Button config
$GoButton           = New-Object System.Windows.Forms.Button
$GoButton.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$GoButton.BackColor = $GoBtnBGColor
$GoButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$GoButton.Font      = 'Consolas,36'
$GoButton.ForeColor = $ButtonFGColor
$GoButton.Location  = New-Object System.Drawing.Point(483,219)
$GoButton.Name      = 'GoButton'
$GoButton.Size      = New-Object System.Drawing.Size(177,141)
$GoButton.TabIndex  = 2
$GoButton.Text      = 'GO'
$GoButton.Visible   = $false

# F-Cap Title config
$FCapTitle             = New-Object System.Windows.Forms.Label
$FCapTitle.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$FCapTitle.BackColor   = $CheckmarkBGColor
$FCapTitle.Font        = 'Elephant,48'
$FCapTitle.ForeColor   = $BannerFGColor
$FCapTitle.Location    = New-Object System.Drawing.Point(0,41)
$FCapTitle.MaximumSize = New-Object System.Drawing.Size(10000,102)
$FCapTitle.Name        = 'FCapTitle'
$FCapTitle.Size        = New-Object System.Drawing.Size(1147,102)
$FCapTitle.Text        = 'F-Capture'
$FCapTitle.TextAlign   = [System.Drawing.ContentAlignment]::MiddleCenter

#Background panel
$BgPanel             = New-Object System.Windows.Forms.Panel
$BgPanel.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$BgPanel.BackColor   = $BannerBGColor
$BgPanel.ForeColor   = $BannerBGColor
$BgPanel.Location    = New-Object System.Drawing.Point(0,90)
$BgPanel.MaximumSize = New-Object System.Drawing.Size(10000,400)
$BgPanel.Size        = New-Object System.Drawing.Size(1147,400)
$BgPanel.Visible     = $false

# Output directory change label
$OutDirTextBoxLbl           = New-Object System.Windows.Forms.Label
$OutDirTextBoxLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$OutDirTextBoxLbl.BackColor = $BannerBGColor
$OutDirTextBoxLbl.ForeColor = $MainFormBGColor
$OutDirTextBoxLbl.Font      = 'Consolas,9.75'
$OutDirTextBoxLbl.Location  = New-Object System.Drawing.Point(467,382)
$OutDirTextBoxLbl.Name      = 'OutDirTextBoxLbl'
$OutDirTextBoxLbl.Size      = New-Object System.Drawing.Size(209,36)
$OutDirTextBoxLbl.Text      = 'Choose an Output Directory:'
$OutDirTextBoxLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$OutDirTextBoxLbl.Visible   = $false

# Output Directory Change button config
$OutDirBtn           = New-Object System.Windows.Forms.Button
$OutDirBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$OutDirBtn.BackColor = $ButtonBGColor
$OutDirBtn.Font      = 'Consolas,8.25'
$OutDirBtn.ForeColor = $ButtonFGColor
$OutDirBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$OutDirBtn.Location  = New-Object System.Drawing.Point(682,419)
$OutDirBtn.Name      = 'OutDirBtn'
$OutDirBtn.Size      = New-Object System.Drawing.Size(33,27)
$OutDirBtn.TabIndex  = 0
$OutDirBtn.Text      = '...'
$OutDirBtn.Visible   = $false

# Output Directory Textbox config
$OutDirTextBox           = New-Object System.Windows.Forms.TextBox
$OutDirTextBox.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$OutDirTextBox.Font      = 'Consolas,12'
$OutDirTextBox.Location  = New-Object System.Drawing.Point(426,419)
$OutDirTextBox.Name      = 'OutDirTextBox'
$OutDirTextBox.Size      = New-Object System.Drawing.Size(250,27)
$OutDirTextBox.TabIndex  = 3
$OutDirTextBox.Visible   = $false

# Advanced Menu button config
$AdvancedBtn           = New-Object System.Windows.Forms.Button
$AdvancedBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$AdvancedBtn.BackColor = $AdvBtnBGColor
$AdvancedBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$AdvancedBtn.Font      = 'Consolas,12'
$AdvancedBtn.ForeColor = $ButtonFGColor
$AdvancedBtn.Location  = New-Object System.Drawing.Point(483,499)
$AdvancedBtn.Name      = 'AdvancedBtn'
$AdvancedBtn.Size      = New-Object System.Drawing.Size(177,50)
$AdvancedBtn.TabIndex  = 1
$AdvancedBtn.Text      = 'Advanced Options'
$AdvancedBtn.Visible   = $false

# ------------ Advanced Menu Elements ------------

# Button to close Advanced Menu
$AdvMenuCloseBtn                         = New-Object System.Windows.Forms.Button
$AdvMenuCloseBtn.BackColor               = $CheckmarkBGColor
$AdvMenuCloseBtn.BackgroundImage         = [System.Drawing.Image]::FromFile("$PSScriptRoot\Resources\delete_sign_filled_30px.png")
$AdvMenuCloseBtn.BackgroundImageLayout   = [System.Windows.Forms.ImageLayout]::Stretch
$AdvMenuCloseBtn.FlatStyle               = [System.Windows.Forms.FlatStyle]::Popup
$AdvMenuCloseBtn.Font                    = 'Arial Rounded MT Bold,12'
$AdvMenuCloseBtn.ForeColor               = $ButtonFGColor
$AdvMenuCloseBtn.Location                = New-Object System.Drawing.Point(1024,16)
$AdvMenuCloseBtn.Name                    = 'AdvMenuCloseBtn'
$AdvMenuCloseBtn.Size                    = New-Object System.Drawing.Size(27,27)
$AdvMenuCloseBtn.TabIndex                = 2

# Profiles dropdown label
$ProfileDDLabel           = New-Object System.Windows.Forms.Label
$ProfileDDLabel.BackColor = $CheckmarkBGColor
$ProfileDDLabel.Location  = New-Object System.Drawing.Point(713,64)
$ProfileDDLabel.Name      = 'ProfileDDLabel'
$ProfileDDLabel.Size      = New-Object System.Drawing.Size(194,24)
$ProfileDDLabel.Text      = 'User Profile'
$ProfileDDLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Button to load and apply a profile
$ProfileLoadBtn           = New-Object System.Windows.Forms.Button
$ProfileLoadBtn.BackColor = $ButtonBGColor
$ProfileLoadBtn.ForeColor = $ButtonFGColor
$ProfileLoadBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$ProfileLoadBtn.Location  = New-Object System.Drawing.Point(988,85)
$ProfileLoadBtn.Name      = 'ProfileLoadBtn'
$ProfileLoadBtn.Size      = New-Object System.Drawing.Size(44,38)
$ProfileLoadBtn.TabIndex  = 44
$ProfileLoadBtn.Text      = 'Load'

# Button to save current configuration with name from ProfileDropDown
$ProfileSaveBtn           = New-Object System.Windows.Forms.Button
$ProfileSaveBtn.BackColor = $ButtonBGColor
$ProfileSaveBtn.ForeColor = $ButtonFGColor
$ProfileSaveBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$ProfileSaveBtn.Location  = New-Object System.Drawing.Point(938,85)
$ProfileSaveBtn.Name      = 'ProfileSaveBtn'
$ProfileSaveBtn.Size      = New-Object System.Drawing.Size(44,38)
$ProfileSaveBtn.TabIndex  = 43
$ProfileSaveBtn.Text      = 'Save'

# Dropdown for choosing a profile to load or entering a name to save one
$ProfileDropdown                   = New-Object System.Windows.Forms.ComboBox
$ProfileDropdown.BackColor         = $ButtonBGColor
$ProfileDropdown.Font              = 'Consolas,12'
$ProfileDropdown.FormattingEnabled = $true
$ProfileDropdown.Location          = New-Object System.Drawing.Point(713,91)
$ProfileDropdown.Name              = 'ProfileDropdown'
$ProfileDropdown.Size              = New-Object System.Drawing.Size(219,27)
$ProfileDropdown.TabIndex          = 42

# Disk Imaging checkbox list label
$DiskImgLabel           = New-Object System.Windows.Forms.Label
$DiskImgLabel.BackColor = $CheckmarkBGColor
$DiskImgLabel.Location  = New-Object System.Drawing.Point(889,177)
$DiskImgLabel.Name      = 'DiskImgLabel'
$DiskImgLabel.Size      = New-Object System.Drawing.Size(118,24)
$DiskImgLabel.Text      = 'Disk Imaging'
$DiskImgLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# List of checkboxes that shows user all the drives that are available
# to make images of and lets the user check the ones they want
$DiskImgCBList                   = New-Object System.Windows.Forms.CheckedListBox
$DiskImgCBList.BackColor         = $ButtonBGColor
$DiskImgCBList.CheckOnClick      = $true
$DiskImgCBList.Font              = 'Consolas,9.75'
$DiskImgCBList.ForeColor         = $ButtonFGColor
$DiskImgCBList.FormattingEnabled = $true
$DiskImgCBList.Location          = New-Object System.Drawing.Point(889,204)
$DiskImgCBList.Name              = 'DiskImgCBList'
$DiskImgCBList.Size              = New-Object System.Drawing.Size(118,184)
$DiskImgCBList.TabIndex          = 51

# VNC Server button config
$VNCServerBtn           = New-Object System.Windows.Forms.Button
$VNCServerBtn.BackColor = $ButtonBGColor
$VNCServerBtn.ForeColor = $ButtonFGColor
$VNCServerBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$VNCServerBtn.Location  = New-Object System.Drawing.Point(755,272)
$VNCServerBtn.Name      = 'VNCServerBtn'
$VNCServerBtn.Size      = New-Object System.Drawing.Size(112,38)
$VNCServerBtn.TabIndex  = 48
$VNCServerBtn.Text      = 'VNC Server'
$VNCServerBtn.Enabled   = $false # Not implemented yet, so disable it to communicate that

# Data Recovery button config
$DataRecoveryBtn           = New-Object System.Windows.Forms.Button
$DataRecoveryBtn.BackColor = $ButtonBGColor
$DataRecoveryBtn.ForeColor = $ButtonFGColor
$DataRecoveryBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$DataRecoveryBtn.Location  = New-Object System.Drawing.Point(755,325)
$DataRecoveryBtn.Name      = 'DataRecoveryBtn'
$DataRecoveryBtn.Size      = New-Object System.Drawing.Size(112,38)
$DataRecoveryBtn.TabIndex  = 49
$DataRecoveryBtn.Text      = 'Data Recovery'

# Scan Registry button config
$RegistryScanBtn           = New-Object System.Windows.Forms.Button
$RegistryScanBtn.BackColor = $ButtonBGColor
$RegistryScanBtn.ForeColor = $ButtonFGColor
$RegistryScanBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$RegistryScanBtn.Location  = New-Object System.Drawing.Point(755,378)
$RegistryScanBtn.Name      = 'RegistryScanBtn'
$RegistryScanBtn.Size      = New-Object System.Drawing.Size(112,38)
$RegistryScanBtn.TabIndex  = 50
$RegistryScanBtn.Text      = 'Scan Registry'

# PuTTY button config
$PuTTYBtn           = New-Object System.Windows.Forms.Button
$PuTTYBtn.BackColor = $ButtonBGColor
$PuTTYBtn.ForeColor = $ButtonFGColor
$PuTTYBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$PuTTYBtn.Location  = New-Object System.Drawing.Point(755,219)
$PuTTYBtn.Name      = 'PuTTYBtn'
$PuTTYBtn.Size      = New-Object System.Drawing.Size(112,38)
$PuTTYBtn.TabIndex  = 47
$PuTTYBtn.Text      = 'PuTTY'

# Packet Capture checkbox config
$PacketCaptureCB            = New-Object System.Windows.Forms.CheckBox
$PacketCaptureCB.BackColor  = $CheckmarkBGColor
$PacketCaptureCB.AutoSize   = $true
$PacketCaptureCB.Checked    = $true
$PacketCaptureCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PacketCaptureCB.Location   = New-Object System.Drawing.Point(385,398)
$PacketCaptureCB.Name       = 'PacketCaptureCB'
$PacketCaptureCB.Size       = New-Object System.Drawing.Size(124,19)
$PacketCaptureCB.TabIndex   = 30
$PacketCaptureCB.Text       = 'Packet Capture'

# Network Share Info checkbox config
$NetworkShareInfoCB            = New-Object System.Windows.Forms.CheckBox
$NetworkShareInfoCB.BackColor  = $CheckmarkBGColor
$NetworkShareInfoCB.AutoSize   = $true
$NetworkShareInfoCB.Checked    = $true
$NetworkShareInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$NetworkShareInfoCB.Location   = New-Object System.Drawing.Point(535,314)
$NetworkShareInfoCB.Name       = 'NetworkShareInfoCB'
$NetworkShareInfoCB.Size       = New-Object System.Drawing.Size(152,19)
$NetworkShareInfoCB.TabIndex   = 38
$NetworkShareInfoCB.Text       = 'Network Share Info'
$NetworkShareInfoCB.UseVisualStyleBackColor = $true

# Network Interfaces checkbox config
$NetworkInterfacesCB            = New-Object System.Windows.Forms.CheckBox
$NetworkInterfacesCB.BackColor  = $CheckmarkBGColor
$NetworkInterfacesCB.AutoSize   = $true
$NetworkInterfacesCB.Checked    = $true
$NetworkInterfacesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$NetworkInterfacesCB.Location   = New-Object System.Drawing.Point(535,438)
$NetworkInterfacesCB.Name       = 'NetworkInterfacesCB'
$NetworkInterfacesCB.Size       = New-Object System.Drawing.Size(152,19)
$NetworkInterfacesCB.TabIndex   = 41
$NetworkInterfacesCB.Text       = 'Network Interfaces'
$NetworkInterfacesCB.UseVisualStyleBackColor = $true

# FileSystem Info checkbox config
$FileSystemInfoCB            = New-Object System.Windows.Forms.CheckBox
$FileSystemInfoCB.BackColor  = $CheckmarkBGColor
$FileSystemInfoCB.AutoSize   = $true
$FileSystemInfoCB.Checked    = $true
$FileSystemInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$FileSystemInfoCB.Location   = New-Object System.Drawing.Point(535,398)
$FileSystemInfoCB.Name       = 'FileSystemInfoCB'
$FileSystemInfoCB.Size       = New-Object System.Drawing.Size(138,19)
$FileSystemInfoCB.TabIndex   = 40
$FileSystemInfoCB.Text       = 'File System Info'
$FileSystemInfoCB.UseVisualStyleBackColor = $true

# AutoRun Items checkbox config
$AutoRunItemsCB            = New-Object System.Windows.Forms.CheckBox
$AutoRunItemsCB.BackColor  = $CheckmarkBGColor
$AutoRunItemsCB.AutoSize   = $true
$AutoRunItemsCB.Checked    = $true
$AutoRunItemsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$AutoRunItemsCB.Location   = New-Object System.Drawing.Point(535,356)
$AutoRunItemsCB.Name       = 'AutoRunItemsCB'
$AutoRunItemsCB.Size       = New-Object System.Drawing.Size(117,19)
$AutoRunItemsCB.TabIndex   = 39
$AutoRunItemsCB.Text       = 'AutoRun Items'
$AutoRunItemsCB.UseVisualStyleBackColor = $true

# UserAssist Info checkbox config
$UserAssistInfoCB            = New-Object System.Windows.Forms.CheckBox
$UserAssistInfoCB.BackColor  = $CheckmarkBGColor
$UserAssistInfoCB.AutoSize   = $true
$UserAssistInfoCB.Checked    = $true
$UserAssistInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$UserAssistInfoCB.Location   = New-Object System.Drawing.Point(535,272)
$UserAssistInfoCB.Name       = 'UserAssistInfoCB'
$UserAssistInfoCB.Size       = New-Object System.Drawing.Size(131,19)
$UserAssistInfoCB.TabIndex   = 37
$UserAssistInfoCB.Text       = 'UserAssist Info'
$UserAssistInfoCB.UseVisualStyleBackColor = $true

# Network Profiles checkbox config
$NetworkProfilesCB            = New-Object System.Windows.Forms.CheckBox
$NetworkProfilesCB.BackColor  = $CheckmarkBGColor
$NetworkProfilesCB.AutoSize   = $true
$NetworkProfilesCB.Checked    = $true
$NetworkProfilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$NetworkProfilesCB.Location   = New-Object System.Drawing.Point(535,230)
$NetworkProfilesCB.Name       = 'NetworkProfilesCB'
$NetworkProfilesCB.Size       = New-Object System.Drawing.Size(138,19)
$NetworkProfilesCB.TabIndex   = 36
$NetworkProfilesCB.Text       = 'Network Profiles'
$NetworkProfilesCB.UseVisualStyleBackColor = $true

# User Accounts checkbox config
$UserAccountsCB            = New-Object System.Windows.Forms.CheckBox
$UserAccountsCB.BackColor  = $CheckmarkBGColor
$UserAccountsCB.AutoSize   = $true
$UserAccountsCB.Checked    = $true
$UserAccountsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$UserAccountsCB.Location   = New-Object System.Drawing.Point(535,188)
$UserAccountsCB.Name       = 'UserAccountsCB'
$UserAccountsCB.Size       = New-Object System.Drawing.Size(117,19)
$UserAccountsCB.TabIndex   = 35
$UserAccountsCB.Text       = 'User Accounts'
$UserAccountsCB.UseVisualStyleBackColor = $true

# Timezone Info checkbox config
$TimezoneInfoCB            = New-Object System.Windows.Forms.CheckBox
$TimezoneInfoCB.BackColor  = $CheckmarkBGColor
$TimezoneInfoCB.AutoSize   = $true
$TimezoneInfoCB.Checked    = $true
$TimezoneInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$TimezoneInfoCB.Location   = New-Object System.Drawing.Point(535,146)
$TimezoneInfoCB.Name       = 'TimezoneInfoCB'
$TimezoneInfoCB.Size       = New-Object System.Drawing.Size(117,19)
$TimezoneInfoCB.TabIndex   = 34
$TimezoneInfoCB.Text       = 'Timezone Info'
$TimezoneInfoCB.UseVisualStyleBackColor = $true

# Windows Services checkbox config
$WindowsServicesCB            = New-Object System.Windows.Forms.CheckBox
$WindowsServicesCB.BackColor  = $CheckmarkBGColor
$WindowsServicesCB.AutoSize   = $true
$WindowsServicesCB.Checked    = $true
$WindowsServicesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$WindowsServicesCB.Location   = New-Object System.Drawing.Point(535,104)
$WindowsServicesCB.Name       = 'WindowsServicesCB'
$WindowsServicesCB.Size       = New-Object System.Drawing.Size(138,19)
$WindowsServicesCB.TabIndex   = 33
$WindowsServicesCB.Text       = 'Windows Services'
$WindowsServicesCB.UseVisualStyleBackColor = $true

# SRUM Info checkbox config
$SRUMInfoCB            = New-Object System.Windows.Forms.CheckBox
$SRUMInfoCB.BackColor  = $CheckmarkBGColor
$SRUMInfoCB.AutoSize   = $true
$SRUMInfoCB.Checked    = $true
$SRUMInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$SRUMInfoCB.Location   = New-Object System.Drawing.Point(535,62)
$SRUMInfoCB.Name       = 'SRUMInfoCB'
$SRUMInfoCB.Size       = New-Object System.Drawing.Size(89,19)
$SRUMInfoCB.TabIndex   = 32
$SRUMInfoCB.Text       = 'SRUM Info'
$SRUMInfoCB.UseVisualStyleBackColor = $true

# Shim Cache checkbox config
$ShimCacheCB            = New-Object System.Windows.Forms.CheckBox
$ShimCacheCB.BackColor  = $CheckmarkBGColor
$ShimCacheCB.AutoSize   = $true
$ShimCacheCB.Checked    = $true
$ShimCacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ShimCacheCB.Location   = New-Object System.Drawing.Point(385,356)
$ShimCacheCB.Name       = 'ShimCacheCB'
$ShimCacheCB.Size       = New-Object System.Drawing.Size(89,19)
$ShimCacheCB.TabIndex   = 29
$ShimCacheCB.Text       = 'ShimCache'
$ShimCacheCB.UseVisualStyleBackColor = $true

# Shellbags checkbox config
$ShellbagsCB            = New-Object System.Windows.Forms.CheckBox
$ShellbagsCB.BackColor  = $CheckmarkBGColor
$ShellbagsCB.AutoSize   = $true
$ShellbagsCB.Checked    = $true
$ShellbagsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ShellbagsCB.Location   = New-Object System.Drawing.Point(385,314)
$ShellbagsCB.Name       = 'ShellbagsCB'
$ShellbagsCB.Size       = New-Object System.Drawing.Size(89,19)
$ShellbagsCB.TabIndex   = 28
$ShellbagsCB.Text       = 'Shellbags'
$ShellbagsCB.UseVisualStyleBackColor = $true

# Scheduled Tasks checkbox config
$ScheduledTasksCB            = New-Object System.Windows.Forms.CheckBox
$ScheduledTasksCB.BackColor  = $CheckmarkBGColor
$ScheduledTasksCB.AutoSize   = $true
$ScheduledTasksCB.Checked    = $true
$ScheduledTasksCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ScheduledTasksCB.Location   = New-Object System.Drawing.Point(385,272)
$ScheduledTasksCB.Name       = 'ScheduledTasksCB'
$ScheduledTasksCB.Size       = New-Object System.Drawing.Size(131,19)
$ScheduledTasksCB.TabIndex   = 27
$ScheduledTasksCB.Text       = 'Scheduled Tasks'
$ScheduledTasksCB.UseVisualStyleBackColor = $true

# RDP Cache checkbox config
$RDPCacheCB            = New-Object System.Windows.Forms.CheckBox
$RDPCacheCB.BackColor  = $CheckmarkBGColor
$RDPCacheCB.AutoSize   = $true
$RDPCacheCB.Checked    = $true
$RDPCacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RDPCacheCB.Location   = New-Object System.Drawing.Point(385,230)
$RDPCacheCB.Name       = 'RDPCacheCB'
$RDPCacheCB.Size       = New-Object System.Drawing.Size(89,19)
$RDPCacheCB.TabIndex   = 26
$RDPCacheCB.Text       = 'RDP Cache'
$RDPCacheCB.UseVisualStyleBackColor = $true

# Recycle Bin checkbox config
$RecycleBinCB            = New-Object System.Windows.Forms.CheckBox
$RecycleBinCB.BackColor  = $CheckmarkBGColor
$RecycleBinCB.AutoSize   = $true
$RecycleBinCB.Checked    = $true
$RecycleBinCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RecycleBinCB.Location   = New-Object System.Drawing.Point(385,188)
$RecycleBinCB.Name       = 'RecycleBinCB'
$RecycleBinCB.Size       = New-Object System.Drawing.Size(103,19)
$RecycleBinCB.TabIndex   = 25
$RecycleBinCB.Text       = 'Recycle Bin'
$RecycleBinCB.UseVisualStyleBackColor = $true

# Prefetch files checkbox config
$PrefetchFilesCB            = New-Object System.Windows.Forms.CheckBox
$PrefetchFilesCB.BackColor  = $CheckmarkBGColor
$PrefetchFilesCB.AutoSize   = $true
$PrefetchFilesCB.Checked    = $true
$PrefetchFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PrefetchFilesCB.Location   = New-Object System.Drawing.Point(385,146)
$PrefetchFilesCB.Name       = 'PrefetchFilesCB'
$PrefetchFilesCB.Size       = New-Object System.Drawing.Size(124,19)
$PrefetchFilesCB.TabIndex   = 24
$PrefetchFilesCB.Text       = 'Prefetch Files'
$PrefetchFilesCB.UseVisualStyleBackColor = $true

# Swap files checkbox config
$SwapFilesCB            = New-Object System.Windows.Forms.CheckBox
$SwapFilesCB.BackColor  = $CheckmarkBGColor
$SwapFilesCB.AutoSize   = $true
$SwapFilesCB.Checked    = $true
$SwapFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$SwapFilesCB.Location   = New-Object System.Drawing.Point(385,104)
$SwapFilesCB.Name       = 'SwapFilesCB'
$SwapFilesCB.Size       = New-Object System.Drawing.Size(96,19)
$SwapFilesCB.TabIndex   = 23
$SwapFilesCB.Text       = 'Swap Files'
$SwapFilesCB.UseVisualStyleBackColor = $true

# MRU Lists checkbox config
$MRUListsCB            = New-Object System.Windows.Forms.CheckBox
$MRUListsCB.BackColor  = $CheckmarkBGColor
$MRUListsCB.AutoSize   = $true
$MRUListsCB.Checked    = $true
$MRUListsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$MRUListsCB.Location   = New-Object System.Drawing.Point(385,62)
$MRUListsCB.Name       = 'MRUListsCB'
$MRUListsCB.Size       = New-Object System.Drawing.Size(89,19)
$MRUListsCB.TabIndex   = 22
$MRUListsCB.Text       = 'MRU Lists'
$MRUListsCB.UseVisualStyleBackColor = $true

# DLLs checkbox config
$DLLsCB            = New-Object System.Windows.Forms.CheckBox
$DLLsCB.BackColor  = $CheckmarkBGColor
$DLLsCB.AutoSize   = $true
$DLLsCB.Checked    = $true
$DLLsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$DLLsCB.Location   = New-Object System.Drawing.Point(385,438)
$DLLsCB.Name       = 'DLLsCB'
$DLLsCB.Size       = New-Object System.Drawing.Size(54,19)
$DLLsCB.TabIndex   = 31
$DLLsCB.Text       = 'DLLs'
$DLLsCB.UseVisualStyleBackColor = $true

# LNK files checkbox config
$LNKFilesCB            = New-Object System.Windows.Forms.CheckBox
$LNKFilesCB.BackColor  = $CheckmarkBGColor
$LNKFilesCB.AutoSize   = $true
$LNKFilesCB.Checked    = $true
$LNKFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$LNKFilesCB.Location   = New-Object System.Drawing.Point(200,438)
$LNKFilesCB.Name       = 'LNKFilesCB'
$LNKFilesCB.Size       = New-Object System.Drawing.Size(89,19)
$LNKFilesCB.TabIndex   = 21
$LNKFilesCB.Text       = 'LNK Files'
$LNKFilesCB.UseVisualStyleBackColor = $true

# System Restore Points checkbox config
$RestorePointsCB            = New-Object System.Windows.Forms.CheckBox
$RestorePointsCB.BackColor  = $CheckmarkBGColor
$RestorePointsCB.AutoSize   = $true
$RestorePointsCB.Checked    = $true
$RestorePointsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RestorePointsCB.Location   = New-Object System.Drawing.Point(200,391)
$RestorePointsCB.Name       = 'RestorePointsCB'
$RestorePointsCB.Size       = New-Object System.Drawing.Size(173,19)
$RestorePointsCB.TabIndex   = 20
$RestorePointsCB.Text       = 'System Restore Points'
$RestorePointsCB.UseVisualStyleBackColor = $true

# Keyword Searches checkbox config
$KeywordSearchesCB            = New-Object System.Windows.Forms.CheckBox
$KeywordSearchesCB.BackColor  = $CheckmarkBGColor
$KeywordSearchesCB.AutoSize   = $true
$KeywordSearchesCB.Checked    = $true
$KeywordSearchesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$KeywordSearchesCB.Location   = New-Object System.Drawing.Point(200,344)
$KeywordSearchesCB.Name       = 'KeywordSearchesCB'
$KeywordSearchesCB.Size       = New-Object System.Drawing.Size(138,19)
$KeywordSearchesCB.TabIndex   = 19
$KeywordSearchesCB.Text       = 'Keyword Searches'
$KeywordSearchesCB.UseVisualStyleBackColor = $true

# Jump Lists checkbox config
$JumpListsCB            = New-Object System.Windows.Forms.CheckBox
$JumpListsCB.BackColor  = $CheckmarkBGColor
$JumpListsCB.AutoSize   = $true
$JumpListsCB.Checked    = $true
$JumpListsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$JumpListsCB.Location   = New-Object System.Drawing.Point(200,297)
$JumpListsCB.Name       = 'JumpListsCB'
$JumpListsCB.Size       = New-Object System.Drawing.Size(96,19)
$JumpListsCB.TabIndex   = 18
$JumpListsCB.Text       = 'Jump Lists'
$JumpListsCB.UseVisualStyleBackColor = $true

# Installed Programs checkbox config
$InstalledProgramsCB            = New-Object System.Windows.Forms.CheckBox
$InstalledProgramsCB.BackColor  = $CheckmarkBGColor
$InstalledProgramsCB.AutoSize   = $true
$InstalledProgramsCB.Checked    = $true
$InstalledProgramsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$InstalledProgramsCB.Location   = New-Object System.Drawing.Point(200,250)
$InstalledProgramsCB.Name       = 'InstalledProgramsCB'
$InstalledProgramsCB.Size       = New-Object System.Drawing.Size(152,19)
$InstalledProgramsCB.TabIndex   = 17
$InstalledProgramsCB.Text       = 'Installed Programs'
$InstalledProgramsCB.UseVisualStyleBackColor = $true

# File Associations checkbox config
$FileAssociationsCB            = New-Object System.Windows.Forms.CheckBox
$FileAssociationsCB.BackColor  = $CheckmarkBGColor
$FileAssociationsCB.AutoSize   = $true
$FileAssociationsCB.Checked    = $true
$FileAssociationsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$FileAssociationsCB.Location   = New-Object System.Drawing.Point(200,203)
$FileAssociationsCB.Name       = 'FileAssociationsCB'
$FileAssociationsCB.Size       = New-Object System.Drawing.Size(145,19)
$FileAssociationsCB.TabIndex   = 16
$FileAssociationsCB.Text       = 'File Associations'
$FileAssociationsCB.UseVisualStyleBackColor = $true

# Startup Programs checkbox config
$StartupProgramsCB            = New-Object System.Windows.Forms.CheckBox
$StartupProgramsCB.BackColor  = $CheckmarkBGColor
$StartupProgramsCB.AutoSize   = $true
$StartupProgramsCB.Checked    = $true
$StartupProgramsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$StartupProgramsCB.Location   = New-Object System.Drawing.Point(200,156)
$StartupProgramsCB.Name       = 'StartupProgramsCB'
$StartupProgramsCB.Size       = New-Object System.Drawing.Size(138,19)
$StartupProgramsCB.TabIndex   = 15
$StartupProgramsCB.Text       = 'Startup Programs'
$StartupProgramsCB.UseVisualStyleBackColor = $true

# AmCache checkbox config
$AmCacheCB            = New-Object System.Windows.Forms.CheckBox
$AmCacheCB.BackColor  = $CheckmarkBGColor
$AmCacheCB.AutoSize   = $true
$AmCacheCB.Checked    = $true
$AmCacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$AmCacheCB.Location   = New-Object System.Drawing.Point(200,109)
$AmCacheCB.Name       = 'AmCacheCB'
$AmCacheCB.Size       = New-Object System.Drawing.Size(75,19)
$AmCacheCB.TabIndex   = 14
$AmCacheCB.Text       = 'AmCache'
$AmCacheCB.UseVisualStyleBackColor = $true

# MUICache checkbox config
$MUICacheCB            = New-Object System.Windows.Forms.CheckBox
$MUICacheCB.BackColor  = $CheckmarkBGColor
$MUICacheCB.AutoSize   = $true
$MUICacheCB.Checked    = $true
$MUICacheCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$MUICacheCB.Location   = New-Object System.Drawing.Point(200,62)
$MUICacheCB.Name       = 'MUICacheCB'
$MUICacheCB.Size       = New-Object System.Drawing.Size(75,19)
$MUICacheCB.TabIndex   = 13
$MUICacheCB.Text       = 'MUICache'
$MUICacheCB.UseVisualStyleBackColor = $true

# Windows Event Logs checkbox config
$EventLogsCB            = New-Object System.Windows.Forms.CheckBox
$EventLogsCB.BackColor  = $CheckmarkBGColor
$EventLogsCB.AutoSize   = $true
$EventLogsCB.Checked    = $true
$EventLogsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$EventLogsCB.Location   = New-Object System.Drawing.Point(22,438)
$EventLogsCB.Name       = 'EventLogsCB'
$EventLogsCB.Size       = New-Object System.Drawing.Size(96,19)
$EventLogsCB.TabIndex   = 12
$EventLogsCB.Text       = 'Event Logs'
$EventLogsCB.UseVisualStyleBackColor = $true

# Registry recording checkbox config
$RegistryCB            = New-Object System.Windows.Forms.CheckBox
$RegistryCB.BackColor  = $CheckmarkBGColor
$RegistryCB.AutoSize   = $true
$RegistryCB.Checked    = $true
$RegistryCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RegistryCB.Location   = New-Object System.Drawing.Point(22,391)
$RegistryCB.Name       = 'RegistryCB'
$RegistryCB.Size       = New-Object System.Drawing.Size(82,19)
$RegistryCB.TabIndex   = 11
$RegistryCB.Text       = 'Registry'
$RegistryCB.UseVisualStyleBackColor = $true

# Image Scan checkbox config
$ImageScanCB            = New-Object System.Windows.Forms.CheckBox
$ImageScanCB.BackColor  = $CheckmarkBGColor
$ImageScanCB.AutoSize   = $true
$ImageScanCB.Checked    = $true
$ImageScanCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ImageScanCB.Location   = New-Object System.Drawing.Point(22,344)
$ImageScanCB.Name       = 'ImageScanCB'
$ImageScanCB.Size       = New-Object System.Drawing.Size(96,19)
$ImageScanCB.TabIndex   = 10
$ImageScanCB.Text       = 'Image Scan'
$ImageScanCB.UseVisualStyleBackColor = $true

# Peripheral Devices checkbox config
$PeripheralDevicesCB            = New-Object System.Windows.Forms.CheckBox
$PeripheralDevicesCB.BackColor  = $CheckmarkBGColor
$PeripheralDevicesCB.AutoSize   = $true
$PeripheralDevicesCB.Checked    = $true
$PeripheralDevicesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PeripheralDevicesCB.Location   = New-Object System.Drawing.Point(22,297)
$PeripheralDevicesCB.Name       = 'PeripheralDevicesCB'
$PeripheralDevicesCB.Size       = New-Object System.Drawing.Size(152,19)
$PeripheralDevicesCB.TabIndex   = 9
$PeripheralDevicesCB.Text       = 'Peripheral Devices'
$PeripheralDevicesCB.UseVisualStyleBackColor = $true

# Browser Data checkbox config
$BrowserDataCB            = New-Object System.Windows.Forms.CheckBox
$BrowserDataCB.BackColor  = $CheckmarkBGColor
$BrowserDataCB.AutoSize   = $true
$BrowserDataCB.Checked    = $true
$BrowserDataCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$BrowserDataCB.Location   = New-Object System.Drawing.Point(22,250)
$BrowserDataCB.Name       = 'BrowserDataCB'
$BrowserDataCB.Size       = New-Object System.Drawing.Size(131,19)
$BrowserDataCB.TabIndex   = 8
$BrowserDataCB.Text       = 'Browser Data'
$BrowserDataCB.UseVisualStyleBackColor = $true

# Open Window Screenshots checkbox config
$ScreenshotsCB            = New-Object System.Windows.Forms.CheckBox
$ScreenshotsCB.BackColor  = $CheckmarkBGColor
$ScreenshotsCB.AutoSize   = $true
$ScreenshotsCB.Checked    = $true
$ScreenshotsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ScreenshotsCB.Location   = New-Object System.Drawing.Point(22,203)
$ScreenshotsCB.Name       = 'ScreenshotsCB'
$ScreenshotsCB.Size       = New-Object System.Drawing.Size(152,19)
$ScreenshotsCB.TabIndex   = 6
$ScreenshotsCB.Text       = 'Screenshot Windows'
$ScreenshotsCB.UseVisualStyleBackColor = $true

# Memory Imaging checkbox config
$MemoryImageCB            = New-Object System.Windows.Forms.CheckBox
$MemoryImageCB.BackColor  = $CheckmarkBGColor
$MemoryImageCB.AutoSize   = $true
$MemoryImageCB.Checked    = $true
$MemoryImageCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$MemoryImageCB.Location   = New-Object System.Drawing.Point(22,156)
$MemoryImageCB.Name       = 'MemoryImageCB'
$MemoryImageCB.Size       = New-Object System.Drawing.Size(124,19)
$MemoryImageCB.TabIndex   = 5
$MemoryImageCB.Text       = 'Memory Imaging'
$MemoryImageCB.UseVisualStyleBackColor = $true

# Active Processes checkbox config
$ActiveProcessesCB            = New-Object System.Windows.Forms.CheckBox
$ActiveProcessesCB.BackColor  = $CheckmarkBGColor
$ActiveProcessesCB.AutoSize   = $true
$ActiveProcessesCB.Checked    = $true
$ActiveProcessesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ActiveProcessesCB.Location   = New-Object System.Drawing.Point(22,109)
$ActiveProcessesCB.Name       = 'ActiveProcessesCB'
$ActiveProcessesCB.Size       = New-Object System.Drawing.Size(138,19)
$ActiveProcessesCB.TabIndex   = 4
$ActiveProcessesCB.Text       = 'Active Processes'
$ActiveProcessesCB.UseVisualStyleBackColor = $true

# System Information checkbox config
$SystemInfoCB            = New-Object System.Windows.Forms.CheckBox
$SystemInfoCB.BackColor  = $CheckmarkBGColor
$SystemInfoCB.AutoSize   = $true
$SystemInfoCB.Checked    = $true
$SystemInfoCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$SystemInfoCB.Location   = New-Object System.Drawing.Point(22,62)
$SystemInfoCB.Name       = 'SystemInfoCB'
$SystemInfoCB.Size       = New-Object System.Drawing.Size(103,19)
$SystemInfoCB.TabIndex   = 3
$SystemInfoCB.Text       = 'System Info'
$SystemInfoCB.UseVisualStyleBackColor = $true

#CheckUncheckAllCB
$CheckUncheckAllCB            = New-Object System.Windows.Forms.CheckBox
$CheckUncheckAllCB.AutoSize   = $true
$CheckUncheckAllCB.BackColor  = $CheckmarkBGColor
$CheckUncheckAllCB.Checked    = $true
$CheckUncheckAllCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$CheckUncheckAllCB.ForeColor  = [System.Drawing.Color]::White
$CheckUncheckAllCB.Location   = New-Object System.Drawing.Point (261,25)
$CheckUncheckAllCB.Name       = 'CheckUncheckAllCB'
$CheckUncheckAllCB.Size       = New-Object System.Drawing.Size (145,19)
$CheckUncheckAllCB.TabIndex   = 1
$CheckUncheckAllCB.Text       = 'Check/Uncheck All'
$CheckUncheckAllCB.UseVisualStyleBackColor = $false

#VHDXOutputRBtn
$VHDXOutputRBtn            = New-Object System.Windows.Forms.RadioButton
$VHDXOutputRBtn.AutoSize   = $true
$VHDXOutputRBtn.BackColor  = $CheckmarkBGColor
$VHDXOutputRBtn.CheckAlign = [System.Drawing.ContentAlignment]::TopCenter
$VHDXOutputRBtn.Checked    = $global:ON_NTFS
$VHDXOutputRBtn.Enabled    = $global:ON_NTFS
$VHDXOutputRBtn.Location   = New-Object System.Drawing.Point (770,169)
$VHDXOutputRBtn.Name       = 'VHDXOutputRBtn'
$VHDXOutputRBtn.Size       = New-Object System.Drawing.Size (39,32)
$VHDXOutputRBtn.TabIndex   = 45
$VHDXOutputRBtn.TabStop    = $true
$VHDXOutputRBtn.Text       = 'VHDX'
$VHDXOutputRBtn.UseVisualStyleBackColor = $false

#ZipOutputRBtn
$ZipOutputRBtn            = New-Object System.Windows.Forms.RadioButton
$ZipOutputRBtn.AutoSize   = $true
$ZipOutputRBtn.BackColor  = $CheckmarkBGColor
$ZipOutputRBtn.CheckAlign = [System.Drawing.ContentAlignment]::TopCenter
$ZipOutputRBtn.Checked    = !$global:ON_NTFS
$ZipOutputRBtn.Location   = New-Object System.Drawing.Point (815,169)
$ZipOutputRBtn.Name       = 'ZipOutputRBtn'
$ZipOutputRBtn.Size       = New-Object System.Drawing.Size (32,32)
$ZipOutputRBtn.TabIndex   = 44
$ZipOutputRBtn.Text       = 'Zip'
$ZipOutputRBtn.UseVisualStyleBackColor = $false

#OutputFormatLabel
$OutputFormatLabel           = New-Object System.Windows.Forms.Label
$OutputFormatLabel.BackColor = $CheckmarkBGColor
$OutputFormatLabel.Location  = New-Object System.Drawing.Point (752,142)
$OutputFormatLabel.Name      = 'OutputFormatLabel'
$OutputFormatLabel.Size      = New-Object System.Drawing.Size (114,24)
$OutputFormatLabel.Text      = 'Output Format'
$OutputFormatLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Group Box holding Advanced Menu items
$AdvOptionGrpBox             = New-Object System.Windows.Forms.GroupBox
$AdvOptionGrpBox.Anchor      = [System.Windows.Forms.AnchorStyles]::None
$AdvOptionGrpBox.BackColor   = $GroupBoxBGColor
$AdvOptionGrpBox.Font        = 'Consolas,9.75'
$AdvOptionGrpBox.ForeColor   = $GroupBoxFGColor
$AdvOptionGrpBox.Location    = New-Object System.Drawing.Point(41,160)
$AdvOptionGrpBox.MinimumSize = New-Object System.Drawing.Size(1060,482)
$AdvOptionGrpBox.Name        = 'AdvOptionGrpBox'
$AdvOptionGrpBox.Size        = New-Object System.Drawing.Size(1060,482)
$AdvOptionGrpBox.Text        = 'Advanced-Menu'
$AdvOptionGrpBox.Visible     = $false
$AdvOptionGrpBox.Controls.Add($DataRecoveryBtn)
$AdvOptionGrpBox.Controls.Add($OutputFormatLabel)
$AdvOptionGrpBox.Controls.Add($ZipOutputRBtn)
$AdvOptionGrpBox.Controls.Add($VHDXOutputRBtn)
$AdvOptionGrpBox.Controls.Add($CheckUncheckAllCB)
$AdvOptionGrpBox.Controls.Add($AdvMenuCloseBtn)
$AdvOptionGrpBox.Controls.Add($ProfileDDLabel)
$AdvOptionGrpBox.Controls.Add($ProfileLoadBtn)
$AdvOptionGrpBox.Controls.Add($ProfileSaveBtn)
$AdvOptionGrpBox.Controls.Add($ProfileDropdown)
$AdvOptionGrpBox.Controls.Add($DiskImgLabel)
$AdvOptionGrpBox.Controls.Add($DiskImgCBList)
$AdvOptionGrpBox.Controls.Add($VNCServerBtn)
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
$AdvOptionGrpBox.Controls.Add($MUICacheCB)
$AdvOptionGrpBox.Controls.Add($AmCacheCB)
$AdvOptionGrpBox.Controls.Add($EventLogsCB)
$AdvOptionGrpBox.Controls.Add($RegistryCB)
$AdvOptionGrpBox.Controls.Add($ImageScanCB)
$AdvOptionGrpBox.Controls.Add($PeripheralDevicesCB)
$AdvOptionGrpBox.Controls.Add($BrowserDataCB)
$AdvOptionGrpBox.Controls.Add($ScreenshotsCB)
$AdvOptionGrpBox.Controls.Add($MemoryImageCB)
$AdvOptionGrpBox.Controls.Add($ActiveProcessesCB)
$AdvOptionGrpBox.Controls.Add($SystemInfoCB)

# ------------ Results/Scanning Page Elements ------------

# Scanning label settings
$ScanningLbl              = New-Object System.Windows.Forms.Label
$ScanningLbl.Anchor       = [System.Windows.Forms.AnchorStyles]::None
$ScanningLbl.BackColor    = $CheckmarkBGColor
$ScanningLbl.Location     = New-Object System.Drawing.Point (320,0)
$ScanningLbl.Font         = 'Consolas,12'
$ScanningLbl.Name         = 'ScanningLbl'
$ScanningLbl.Size         = New-Object System.Drawing.Size (504,39)
$ScanningLbl.Text         = 'Scanning...'
$ScanningLbl.TextAlign    = [System.Drawing.ContentAlignment]::MiddleCenter

# Results Textbox settings
$ResultsTB                = New-Object System.Windows.Forms.TextBox
$ResultsTB.Anchor         = [System.Windows.Forms.AnchorStyles]::None
$ResultsTB.ScrollBars     = [System.Windows.Forms.ScrollBars]::Vertical
$ResultsTB.BackColor      = $ButtonBGColor
$ResultsTB.ForeColor      = $ButtonFGColor
$ResultsTB.Font           = 'Consolas,9.75'
$ResultsTB.Location       = New-Object System.Drawing.Point(320,35)
$ResultsTB.Name           = 'ResultsTB'
$ResultsTB.Size           = New-Object System.Drawing.Size(504,334)
$ResultsTB.TabStop        = $false
$ResultsTB.Multiline      = $true
$ResultsTB.ReadOnly       = $true

# Back to Main Menu Button settings
$MainMenuBtn              = New-Object System.Windows.Forms.Button
$MainMenuBtn.Anchor       = [System.Windows.Forms.AnchorStyles]::None
$MainMenuBtn.BackColor    = $AdvBtnBGColor
$MainMenuBtn.ForeColor    = 'White'
$MainMenuBtn.Font         = 'Consolas,9.75'
$MainMenuBtn.FlatStyle    = [System.Windows.Forms.FlatStyle]::Popup
$MainMenuBtn.Location     = New-Object System.Drawing.Point(320,560)
$MainMenuBtn.Name         = 'MainMenuBtn'
$MainMenuBtn.Size         = New-Object System.Drawing.Size(122,39)
$MainMenuBtn.TabIndex     = 2
$MainMenuBtn.Text         = 'Main Menu'
$MainMenuBtn.Visible      = $false

# Open Output Folder Button settings
$ViewOutputBtn            = New-Object System.Windows.Forms.Button
$ViewOutputBtn.Anchor     = [System.Windows.Forms.AnchorStyles]::None
$ViewOutputBtn.BackColor  = $AdvBtnBGColor
$ViewOutputBtn.ForeColor  = 'White'
$ViewOutputBtn.Font       = 'Consolas,9.75'
$ViewOutputBtn.FlatStyle  = [System.Windows.Forms.FlatStyle]::Popup
$ViewOutputBtn.Location   = New-Object System.Drawing.Point(511,560)
$ViewOutputBtn.Name       = 'ViewOutputBtn'
$ViewOutputBtn.Size       = New-Object System.Drawing.Size(122,39)
$ViewOutputBtn.TabIndex   = 3
$ViewOutputBtn.Text       = 'View Output'
$ViewOutputBtn.Visible    = $false

# Exit from Resutlts page Button settings
$ExitResultsBtn           = New-Object System.Windows.Forms.Button
$ExitResultsBtn.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$ExitResultsBtn.BackColor = $AdvBtnBGColor
$ExitResultsBtn.ForeColor = 'White'
$ExitResultsBtn.Font      = 'Consolas,9.75'
$ExitResultsBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$ExitResultsBtn.Location  = New-Object System.Drawing.Point(702,560)
$ExitResultsBtn.Name      = 'ExitResultsBtn'
$ExitResultsBtn.Size      = New-Object System.Drawing.Size(122,39)
$ExitResultsBtn.TabIndex  = 4
$ExitResultsBtn.Text      = 'Exit'
$ExitResultsBtn.Visible   = $false

# Results Page Panel
$ResultsPanel             = New-Object System.Windows.Forms.Panel
$ResultsPanel.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$ResultsPanel.BackColor   = $BannerBGColor
$ResultsPanel.Location    = New-Object System.Drawing.Point(0,150)
$ResultsPanel.MaximumSize = New-Object System.Drawing.Size(10000,400)
$ResultsPanel.Name        = 'ResultsPanel'
$ResultsPanel.Size        = New-Object System.Drawing.Size(1146,400)
$ResultsPanel.Visible     = $false
$ResultsPanel.Controls.Add($ResultsTB)
$ResultsPanel.Controls.Add($ScanningLbl)

# -----------------------------------------------

# Add buttons to the main form's list of elements

$MainForm.Controls.Add($ExitResultsBtn)
$MainForm.Controls.Add($ViewOutputBtn)
$MainForm.Controls.Add($MainMenuBtn)
$MainForm.Controls.Add($ResultsPanel)
$MainForm.Controls.Add($GoButton)
$MainForm.Controls.Add($FCapTitle)
$MainForm.Controls.Add($OutDirTextBoxLbl)
$MainForm.Controls.Add($OutDirTextBox)
$MainForm.Controls.Add($OutDirBtn)
$MainForm.Controls.Add($AdvancedBtn)
$MainForm.Controls.Add($BgPanel)
$MainForm.Controls.Add($AdvOptionGrpBox)
$MainForm.Controls.Add($SSBottomPanel)
$MainForm.Controls.Add($SSTopPanel)
$MainForm.Controls.Add($MenuStrip)

# Add Tooltips to individual controls (Add/modify tooltips here)

# ------------------|----Control name----|-------Tooltip text------>
$Tooltip.SetToolTip( $AdvMenuCloseBtn,    "Close this menu (Configuration will be saved)") 
$Tooltip.SetToolTip( $ProfileLoadBtn,     "Load the user profile configuration associated`nwith the name in the textbox")
$Tooltip.SetToolTip( $ProfileSaveBtn,     "Save the current configuration to a new user profile`nunder the name in the textbox")
$Tooltip.SetToolTip( $ProfileDropdown,    "Enter a new name to save the current configuration under`nor enter/select the name of a previously saved profile")
$Tooltip.SetToolTip( $DiskImgCBList,      "All selected drives are imaged and their contents`nexported as individual .vdhx files")
$Tooltip.SetToolTip( $ZipOutputRBtn,      "Save all program output in a single .zip archive")
$Tooltip.SetToolTip( $VHDXOutputRBtn,     "Save all program output to a single .vhdx file")
$Tooltip.SetToolTip( $PuTTYBtn,           "Open PuTTY, a free and open-source terminal emulator,`nserial console and network file transfer application")
$Tooltip.SetToolTip( $VNCServerBtn,       "Not yet implemented")
$Tooltip.SetToolTip( $DataRecoveryBtn,    "Starts TestDisk data recovery software")
$Tooltip.SetToolTip( $RegistryScanBtn,    "Open RegScanner, a small utility that allows you to scan the Registry`nfor a particular string and then view or export the matches to a .reg file")
$Tooltip.SetToolTip( $SystemInfoCB,       "Record a detailed overview of the system specifications, etc.")
$Tooltip.SetToolTip( $ActiveProcessesCB,  "Record a list of the currently active processes")
$Tooltip.SetToolTip( $MemoryImageCB,      "Copy the physical memory (RAM) of`nthe windows system using winPMem`nand export a raw memory image")
$Tooltip.SetToolTip( $ScreenshotsCB,      "Take a screenshot of every open window,`nregardless of whether they are minimized`nor hidden behind other windows")
$Tooltip.SetToolTip( $BrowserDataCB,      "Copy and export all browser data stored on the system`n(includes Mozila, Edge, IE, Opera, and Chrome)")
$Tooltip.SetToolTip( $PeripheralDevicesCB,"Record a list of all peripheral devices`nthat are currently connected to the system")
$Tooltip.SetToolTip( $ImageScanCB,        "Scan the entire system and save to a`nfolder any images that are not`nstandard windows/system images")
$Tooltip.SetToolTip( $RegistryCB,         "Copy and export all registry keys and hive information")
$Tooltip.SetToolTip( $EventLogsCB,        "Copy and export all Windows event logs")
$Tooltip.SetToolTip( $MUICacheCB,         "Copy and export the MUICache registry hive")
$Tooltip.SetToolTip( $AmCacheCB,          "Copy and export the AmCache registry hive")
$Tooltip.SetToolTip( $StartupProgramsCB,  "Record a list of the startup programs")
$Tooltip.SetToolTip( $FileAssociationsCB, "Find and copy the file association information`nfor the system to a text file")
$Tooltip.SetToolTip( $InstalledProgramsCB,"Record a list of the Installed Programs,`nboth Microsoft & Non-Microsoft")
$Tooltip.SetToolTip( $JumpListsCB,        "Copy and export the jump lists for each user on the machine")
$Tooltip.SetToolTip( $KeywordSearchesCB,  "Copy and export the WordWheelQuery registry keys and`nother information relating to keyword searches`nperformed by each User")
$Tooltip.SetToolTip( $LNKFilesCB,         "Record a list of all .LNK files on the system")
$Tooltip.SetToolTip( $RestorePointsCB,    "Record a list of all system restore points on the machine")
$Tooltip.SetToolTip( $DLLsCB,             "Record a list of all .dll files on the machine")
$Tooltip.SetToolTip( $MRUListsCB,         "Copy and export all registry keys related`nto the Most Recently Used (MRU) list")
$Tooltip.SetToolTip( $SwapFilesCB,        "Copy the swap file (page file) of`nthe windows system using winPMem`nand export a raw memory image")
$Tooltip.SetToolTip( $PrefetchFilesCB,    "Copy and export the files from `"C:\Windows\Prefetch`"")
$Tooltip.SetToolTip( $RecycleBinCB,       "Copy and export any metadata files that are`npresent in the `$RECYCLE.BIN system folder")
$Tooltip.SetToolTip( $RDPCacheCB,         "Copy and export into a folder any bitmap files that are`nstored in the Remote Desktop Protocol (RDP) Cache")
$Tooltip.SetToolTip( $ScheduledTasksCB,   "Copy to a folder the .XML files that represent each`nscheduled task from the `"C:/Windows/System32/Tasks`"`nfolder (or equivalent for target version of Windows,`nas the location may vary)")
$Tooltip.SetToolTip( $ShellbagsCB,        "Copy and export the NTUSER.DAT and USRCLASS.DAT`nfiles and related .LOG files")
$Tooltip.SetToolTip( $ShimCacheCB,        "Copy and export the ShimCache registry hive and related files")
$Tooltip.SetToolTip( $SRUMInfoCB,         "Copy and export all SRUM Information, (including Application resource usage,`nEnergy usage (long term), Network connections, Network usage,`nand Push notification data)")
$Tooltip.SetToolTip( $WindowsServicesCB,  "Record a list of the currently running Windows services")
$Tooltip.SetToolTip( $TimezoneInfoCB,     "Record the timezone information of the machine")
$Tooltip.SetToolTip( $UserAccountsCB,     "Record a list of the Windows User accounts")
$Tooltip.SetToolTip( $NetworkProfilesCB,  "Record a list of network connection profiles`nassociated with any network adapters")
$Tooltip.SetToolTip( $UserAssistInfoCB,   "Copy and export all UserAssist related registry keys")
$Tooltip.SetToolTip( $AutoRunItemsCB,     "Record a list of all autorun items of the machine")
$Tooltip.SetToolTip( $FileSystemInfoCB,   "Record useful information about the filesystem of the machine")
$Tooltip.SetToolTip( $NetworkInterfacesCB,"Record all network device names,`nnetwork interface names,`nand related IP addresses")
$Tooltip.SetToolTip( $NetworkShareInfoCB, "Copy and export all registry keys related`nto network shares for each user")
$Tooltip.SetToolTip( $PacketCaptureCB,    "Run a Packet sniffer during the scanning process,`nso that data travelling through the systems`nnetwork during scanning can be recorded")

# Add functions to their respective button's event handler

# Splashscreen Events
$AcceptBtn.Add_Click({ Open-Main-Menu })
$ExitBtn.Add_Click({ $MainForm.Close() })
$WebsiteLbl.Add_Click({ Start-Process "http://fcaptureteam.com/" })
$GithubLbl.Add_Click({ Start-Process "https://github.com/PositiveDeltaS/FCapture" })

# MenuStrip Events
$GoSMItem.Add_Click({ OneForAll })
$ExitSMItem.Add_Click({ $MainForm.Close() })
$PuTTYSMItem.Add_Click({ Putty })
$VNCServerSMItem.Add_Click({ Start-VNC-Server })
$DataRecoverySMItem.Add_Click({ Start-Recovery-Tool })
$ScanRegistrySMItem.Add_Click({ Scan-Registry })
$WebsiteSMItem.Add_Click({ Start-Process "http://fcaptureteam.com/" })
$GithubSMItem.Add_Click({ Start-Process "https://github.com/PositiveDeltaS/FCapture" })
$WikiSMItem.Add_Click({ Start-Process "https://github.com/PositiveDeltaS/FCapture/wiki" })

# Main Menu Events
$GoButton.Add_Click({ OneForAll })
$OutDirBtn.Add_Click({ Output-Location })
$AdvancedBtn.Add_Click({ Open-Advanced-Menu })

# Advanced Menu Events
$AdvMenuCloseBtn.Add_Click({ Close-Advanced-Menu })
$ProfileSaveBtn.Add_Click({ Save-User-Profile })
$ProfileLoadBtn.Add_Click({ Load-User-Profile })
$ProfileDropdown.Add_Click({ Update-DD })
$PuTTYBtn.Add_Click({ Putty })
$VNCServerBtn.Add_Click({ Start-VNC-Server })
$DataRecoveryBtn.Add_Click({ Start-Recovery-Tool })
$RegistryScanBtn.Add_Click({ Scan-Registry })
$CheckUncheckAllCB.Add_CheckedChanged({ Toggle-All-Checkboxes })
$VHDXOutputRBtn.Add_CheckedChanged({ Handle-VHDX-Check })

# Results Page Events
$MainMenuBtn.Add_Click({ Close-Results-Page })
$ViewOutputBtn.Add_Click({ Invoke-Item $global:OUTPUT_DIR })
$ExitResultsBtn.Add_Click({ $MainForm.Close() })

Register-ObjectEvent -InputObject $MainForm -EventName FormClosing -Action { Store-Main-State } | Out-Null

Initialize-Main
Update-DD

# Run the main window
[void]$MainForm.ShowDialog()
