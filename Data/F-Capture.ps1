# Import powershell functions from Scripts directory
. "$PSScriptRoot\Scripts\~IMPORTS.ps1"

# Store log locations in global variables so functions can access them
$global:DEBUG_LOG   = "$PSScriptRoot\debugLog.txt"
$global:SUCCESS_LOG = "$PSScriptRoot\success.txt"
$global:FAIL_LOG    = "$PSScriptRoot\fail.txt"

# Set default output location to F-Capture.ps1 directory
# For testing & development purposes only, output should be redirected to a removable drive
$global:OUTPUT_DIR  = "$PSScriptRoot"

# Hides console soonafter starting if $DEV_MODE is $false
$global:DEV_MODE    = $true
if(!$DEV_MODE){ Hide-Console }

# Import PS Windows Forms wrapper because F-Capture is a GUI-based application
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Visual settings for various UI elements
$Icon             = New-Object System.Drawing.Icon("$PSScriptRoot\Resources\FCAP.ICO")
$VersionNumber    = 'Version 0.1.0'
$MainFormBGColor  = [System.Drawing.Color]::FromArgb(219,228,235)
$MainFormFGColor  = [System.Drawing.Color]::FromArgb(255,255,255)
$BannerBGColor    = [System.Drawing.Color]::FromArgb(5,78,111)
$BannerFGColor    = [System.Drawing.Color]::FromArgb(0,0,0)
$GroupBoxBGColor  = [System.Drawing.Color]::FromArgb(0,0,0)
$GroupBoxFGColor  = [System.Drawing.Color]::FromArgb(255,255,255)
$ButtonBGColor    = [System.Drawing.Color]::FromArgb(255,255,255)
$ButtonFGColor    = [System.Drawing.Color]::FromArgb(0,0,0)
$GoBtnBGColor     = [System.Drawing.Color]::LimeGreen
$AdvBtnBGColor    = [System.Drawing.Color]::Firebrick
$CheckmarkBGColor = [System.Drawing.Color]::Transparent
$MStripFGColor    = [System.Drawing.Color]::FromArgb(0,0,0)
$WarningLblColor  = [System.Drawing.Color]::Yellow
$LinkLblColor     = [System.Drawing.Color]::LimeGreen

# Create main form and button elements
$MainForm                     = New-Object System.Windows.Forms.Form
$MainForm.AutoScaleDimensions = New-Object System.Drawing.SizeF(6,13)
$MainForm.AutoScaleMode       = [System.Windows.Forms.AutoScaleMode]::Dpi
$MainForm.AutoScroll          = $true
$MainForm.BackColor           = $MainFormBGColor
$MainForm.ClientSize          = New-Object System.Drawing.Size(1146,663)
$MainForm.Font                = 'Consolas,8.25'
$MainForm.ForeColor           = $MainFormFGColor
$MainForm.Icon                = $Icon
$MainForm.TopMost             = $false
$MainForm.MinimumSize         = New-Object System.Drawing.Size(1090,690)
$MainForm.Name                = 'MainForm'
$MainForm.StartPosition       = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainForm.Text                = 'F-Capture'

# ------------ Splashscreen Elements ------------

# Warning Label
$WarningLbl           = New-Object System.Windows.Forms.Label
$WarningLbl.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$WarningLbl.Font      = New-Object System.Drawing.Font('Cambria',30,[System.Drawing.FontStyle]::Bold)
$WarningLbl.ForeColor = $WarningLblColor
$WarningLbl.Location  = New-Object System.Drawing.Point(472,20)
$WarningLbl.Name      = 'WarningLbl'
$WarningLbl.Size      = New-Object System.Drawing.Size(201,47)
$WarningLbl.TabIndex  = 0
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
$ExitBtn.TabIndex  = 5
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
$AcceptBtn.TabIndex  = 4
$AcceptBtn.Text      = 'ACCEPT'

# Splashscreen Top Panel
$SSTopPanel             = New-Object System.Windows.Forms.Panel
$SSTopPanel.Anchor      = ([System.Windows.Forms.AnchorStyles][System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right)
$SSTopPanel.BackColor   = $BannerBGColor
$SSTopPanel.Location    = New-Object System.Drawing.Point(0,180)
$SSTopPanel.MaximumSize = New-Object System.Drawing.Size(10000,347)
$SSTopPanel.Name        = 'SSTopPanel'
$SSTopPanel.Size        = New-Object System.Drawing.Size(1146,347)
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
$GoSMItem.ToolTipText = 'Start the scanning process'

# Exit Menu Item
$ExitSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$ExitSMItem.AutoToolTip = $true
$ExitSMItem.Name        = 'ExitSMItem'
$ExitSMItem.Size        = New-Object System.Drawing.Size(180,22)
$ExitSMItem.Text        = 'Exit'
$ExitSMItem.ToolTipText = 'Exit the program'

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
$PuTTYSMItem.ToolTipText = 'PuTTY is a free and open-source terminal emulator, serial console and network file transfer application'

# VNCServer Menu Item
$VNCServerSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$VNCServerSMItem.AutoToolTip = $true
$VNCServerSMItem.Name        = 'VNCServerSMItem'
$VNCServerSMItem.Size        = New-Object System.Drawing.Size(180,22)
$VNCServerSMItem.Text        = 'VNC Server'
$VNCServerSMItem.ToolTipText = 'VNC is a graphical desktop-sharing system that uses the Remote Frame Buffer protocol to remotely control another computer'
$VNCServerSMItem.Enabled     = $false

# Tools Submenu
$ToolsSMItem           = New-Object System.Windows.Forms.ToolStripMenuItem
$ToolsSMItem.ForeColor = $MStripFGColor
$ToolsSMItem.Name      = 'ToolsSMItem'
$ToolsSMItem.Size      = New-Object System.Drawing.Size(47,20)
$ToolsSMItem.Text      = 'Tools'
[void]$ToolsSMItem.DropDownItems.Add($PuTTYSMItem)
[void]$ToolsSMItem.DropDownItems.Add($VNCServerSMItem)

# Website Menu Item
$WebsiteSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$WebsiteSMItem.AutoToolTip = $true
$WebsiteSMItem.Name        = 'WebsiteSMItem'
$WebsiteSMItem.Size        = New-Object System.Drawing.Size(180,22)
$WebsiteSMItem.Text        = 'Website'
$WebsiteSMItem.ToolTipText = 'Open the F-Capture website in the default browser'

# Github Menu Item
$GithubSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$GithubSMItem.AutoToolTip = $true
$GithubSMItem.Name        = 'GithubSMItem'
$GithubSMItem.Size        = New-Object System.Drawing.Size(180,22)
$GithubSMItem.Text        = 'Github'
$GithubSMItem.ToolTipText = 'Open the F-Capture Github Repository in the default browser'

# Wiki Menu Item
$WikiSMItem             = New-Object System.Windows.Forms.ToolStripMenuItem
$WikiSMItem.Name        = 'WikiSMItem'
$WikiSMItem.Size        = New-Object System.Drawing.Size(180,22)
$WikiSMItem.Text        = 'Wiki'
$WikiSMItem.ToolTipText = 'Open the F-Capture wiki in the default browser'

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
$MenuStrip.TabIndex    = 9
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
$GoButton.TabIndex  = 1
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
$OutDirBtn.TabIndex  = 3
$OutDirBtn.Text      = '...'
$OutDirBtn.Visible   = $false

# Output Directory Textbox config
$OutDirTextBox           = New-Object System.Windows.Forms.TextBox
$OutDirTextBox.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$OutDirTextBox.Font      = 'Consolas,12'
$OutDirTextBox.Location  = New-Object System.Drawing.Point(426,419)
$OutDirTextBox.Name      = 'OutDirTextBox'
$OutDirTextBox.Size      = New-Object System.Drawing.Size(250,27)
$OutDirTextBox.TabIndex  = 5
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
$AdvancedBtn.TabIndex  = 4
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
$AdvMenuCloseBtn.TabIndex                = 48

# Profiles dropdown label
$ProfileDDLabel           = New-Object System.Windows.Forms.Label
$ProfileDDLabel.BackColor = $CheckmarkBGColor
$ProfileDDLabel.Location  = New-Object System.Drawing.Point(713,64)
$ProfileDDLabel.Name      = 'ProfileDDLabel'
$ProfileDDLabel.Size      = New-Object System.Drawing.Size(194,24)
$ProfileDDLabel.TabIndex  = 47
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
$ProfileLoadBtn.TabIndex  = 46
$ProfileLoadBtn.Text      = 'Load'

# Button to save current configuration with name from ProfileDropDown
$ProfileSaveBtn           = New-Object System.Windows.Forms.Button
$ProfileSaveBtn.BackColor = $ButtonBGColor
$ProfileSaveBtn.ForeColor = $ButtonFGColor
$ProfileSaveBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$ProfileSaveBtn.Location  = New-Object System.Drawing.Point(938,85)
$ProfileSaveBtn.Name      = 'ProfileSaveBtn'
$ProfileSaveBtn.Size      = New-Object System.Drawing.Size(44,38)
$ProfileSaveBtn.TabIndex  = 45
$ProfileSaveBtn.Text      = 'Save'

# Dropdown for choosing a profile to load or entering a name to save one
$ProfileDropdown                   = New-Object System.Windows.Forms.ComboBox
$ProfileDropdown.BackColor         = $ButtonBGColor
$ProfileDropdown.Font              = 'Consolas,12'
$ProfileDropdown.FormattingEnabled = $true
$ProfileDropdown.Location          = New-Object System.Drawing.Point(713,91)
$ProfileDropdown.Name              = 'ProfileDropdown'
$ProfileDropdown.Size              = New-Object System.Drawing.Size(219,27)
$ProfileDropdown.TabIndex          = 44

# Disk Imaging checkbox list label
$DiskImgLabel           = New-Object System.Windows.Forms.Label
$DiskImgLabel.BackColor = $CheckmarkBGColor
$DiskImgLabel.Location  = New-Object System.Drawing.Point(889,147)
$DiskImgLabel.Name      = 'DiskImgLabel'
$DiskImgLabel.Size      = New-Object System.Drawing.Size(118,24)
$DiskImgLabel.TabIndex  = 43
$DiskImgLabel.Text      = 'Disk Imaging'
$DiskImgLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# List of checkboxes that shows user all the drive that are available
# to make images of and lets the user check the ones they want
$DiskImgCBList                   = New-Object System.Windows.Forms.CheckedListBox
$DiskImgCBList.BackColor         = $ButtonBGColor
$DiskImgCBList.CheckOnClick      = $true
$DiskImgCBList.Font              = 'Consolas,9.75'
$DiskImgCBList.ForeColor         = $ButtonFGColor
$DiskImgCBList.FormattingEnabled = $true
$DiskImgCBList.Location          = New-Object System.Drawing.Point(889,174)
$DiskImgCBList.Name              = 'DiskImgCBList'
$DiskImgCBList.Size              = New-Object System.Drawing.Size(118,184)
$DiskImgCBList.TabIndex          = 42

# VNC Server button config
$VNCServerBtn           = New-Object System.Windows.Forms.Button
$VNCServerBtn.BackColor = $ButtonBGColor
$VNCServerBtn.ForeColor = $ButtonFGColor
$VNCServerBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$VNCServerBtn.Location  = New-Object System.Drawing.Point(757,295)
$VNCServerBtn.Name      = 'VNCServerBtn'
$VNCServerBtn.Size      = New-Object System.Drawing.Size(103,38)
$VNCServerBtn.TabIndex  = 41
$VNCServerBtn.Text      = 'VNC Server'
$VNCServerBtn.Enabled   = $false # Not implemented yet, so disable it to communicate that

# Textbox that holds the user-entered text to scan the registry for
$RegistryScanTB           = New-Object System.Windows.Forms.TextBox
$RegistryScanTB.BackColor = $ButtonBGColor
$RegistryScanTB.Font      = 'Consolas,12'
$RegistryScanTB.Location  = New-Object System.Drawing.Point(713,393)
$RegistryScanTB.Name      = 'RegistryScanTB'
$RegistryScanTB.Size      = New-Object System.Drawing.Size(236,26)
$RegistryScanTB.TabIndex  = 40
$RegistryScanTB.Enabled   = $false # Not implemented yet, so disable it to communicate that

# Scan Registry button config
$RegistryScanBtn           = New-Object System.Windows.Forms.Button
$RegistryScanBtn.BackColor = $ButtonBGColor
$RegistryScanBtn.ForeColor = $ButtonFGColor
$RegistryScanBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$RegistryScanBtn.Location  = New-Object System.Drawing.Point(955,387)
$RegistryScanBtn.Name      = 'RegistryScanBtn'
$RegistryScanBtn.Size      = New-Object System.Drawing.Size(77,38)
$RegistryScanBtn.TabIndex  = 39
$RegistryScanBtn.Text      = 'Scan Registry'
$RegistryScanBtn.Enabled   = $false # Not implemented yet, so disable it to communicate that

# PuTTY button config
$PuTTYBtn           = New-Object System.Windows.Forms.Button
$PuTTYBtn.BackColor = $ButtonBGColor
$PuTTYBtn.ForeColor = $ButtonFGColor
$PuTTYBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$PuTTYBtn.Location  = New-Object System.Drawing.Point(757,231)
$PuTTYBtn.Name      = 'PuTTYBtn'
$PuTTYBtn.Size      = New-Object System.Drawing.Size(103,38)
$PuTTYBtn.TabIndex  = 38
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
$PacketCaptureCB.TabIndex   = 37
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
$NetworkShareInfoCB.TabIndex   = 36
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
$NetworkInterfacesCB.TabIndex   = 35
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
$FileSystemInfoCB.TabIndex   = 34
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
$AutoRunItemsCB.TabIndex   = 33
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
$UserAssistInfoCB.TabIndex   = 32
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
$NetworkProfilesCB.TabIndex   = 31
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
$UserAccountsCB.TabIndex   = 30
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
$TimezoneInfoCB.TabIndex   = 29
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
$WindowsServicesCB.TabIndex   = 28
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
$SRUMInfoCB.TabIndex   = 27
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
$ShimCacheCB.TabIndex   = 25
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
$ShellbagsCB.TabIndex   = 24
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
$ScheduledTasksCB.TabIndex   = 23
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
$RDPCacheCB.TabIndex   = 22
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
$RecycleBinCB.TabIndex   = 21
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
$PrefetchFilesCB.TabIndex   = 20
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
$SwapFilesCB.TabIndex   = 19
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
$MRUListsCB.TabIndex   = 18
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
$DLLsCB.TabIndex   = 16
$DLLsCB.Text       = 'DLLs'
$DLLsCB.UseVisualStyleBackColor = $true

# System Restore Points checkbox config
$RestorePointsCB            = New-Object System.Windows.Forms.CheckBox
$RestorePointsCB.BackColor  = $CheckmarkBGColor
$RestorePointsCB.AutoSize   = $true
$RestorePointsCB.Checked    = $true
$RestorePointsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RestorePointsCB.Location   = New-Object System.Drawing.Point(200,391)
$RestorePointsCB.Name       = 'RestorePointsCB'
$RestorePointsCB.Size       = New-Object System.Drawing.Size(173,19)
$RestorePointsCB.TabIndex   = 26
$RestorePointsCB.Text       = 'System Restore Points'
$RestorePointsCB.UseVisualStyleBackColor = $true

# LNK files checkbox config
$LNKFilesCB            = New-Object System.Windows.Forms.CheckBox
$LNKFilesCB.BackColor  = $CheckmarkBGColor
$LNKFilesCB.AutoSize   = $true
$LNKFilesCB.Checked    = $true
$LNKFilesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$LNKFilesCB.Location   = New-Object System.Drawing.Point(200,438)
$LNKFilesCB.Name       = 'LNKFilesCB'
$LNKFilesCB.Size       = New-Object System.Drawing.Size(89,19)
$LNKFilesCB.TabIndex   = 17
$LNKFilesCB.Text       = 'LNK Files'
$LNKFilesCB.UseVisualStyleBackColor = $true

# Keyword Searches checkbox config
$KeywordSearchesCB            = New-Object System.Windows.Forms.CheckBox
$KeywordSearchesCB.BackColor  = $CheckmarkBGColor
$KeywordSearchesCB.AutoSize   = $true
$KeywordSearchesCB.Checked    = $true
$KeywordSearchesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$KeywordSearchesCB.Location   = New-Object System.Drawing.Point(200,344)
$KeywordSearchesCB.Name       = 'KeywordSearchesCB'
$KeywordSearchesCB.Size       = New-Object System.Drawing.Size(138,19)
$KeywordSearchesCB.TabIndex   = 15
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
$JumpListsCB.TabIndex   = 14
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
$InstalledProgramsCB.TabIndex   = 13
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
$FileAssociationsCB.TabIndex   = 12
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
$StartupProgramsCB.TabIndex   = 11
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
$AmCacheCB.TabIndex   = 10
$AmCacheCB.Text       = 'AmCache'
$AmCacheCB.UseVisualStyleBackColor = $true

# Windows Event Logs checkbox config
$EventLogsCB            = New-Object System.Windows.Forms.CheckBox
$EventLogsCB.BackColor  = $CheckmarkBGColor
$EventLogsCB.AutoSize   = $true
$EventLogsCB.Checked    = $true
$EventLogsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$EventLogsCB.Location   = New-Object System.Drawing.Point(200,62)
$EventLogsCB.Name       = 'EventLogsCB'
$EventLogsCB.Size       = New-Object System.Drawing.Size(96,19)
$EventLogsCB.TabIndex   = 9
$EventLogsCB.Text       = 'Event Logs'
$EventLogsCB.UseVisualStyleBackColor = $true

# Registry recording checkbox config
$RegistryCB            = New-Object System.Windows.Forms.CheckBox
$RegistryCB.BackColor  = $CheckmarkBGColor
$RegistryCB.AutoSize   = $true
$RegistryCB.Checked    = $true
$RegistryCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$RegistryCB.Location   = New-Object System.Drawing.Point(22,438)
$RegistryCB.Name       = 'RegistryCB'
$RegistryCB.Size       = New-Object System.Drawing.Size(82,19)
$RegistryCB.TabIndex   = 8
$RegistryCB.Text       = 'Registry'
$RegistryCB.UseVisualStyleBackColor = $true

# Image Scan checkbox config
$ImageScanCB            = New-Object System.Windows.Forms.CheckBox
$ImageScanCB.BackColor  = $CheckmarkBGColor
$ImageScanCB.AutoSize   = $true
$ImageScanCB.Checked    = $true
$ImageScanCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ImageScanCB.Location   = New-Object System.Drawing.Point(22,391)
$ImageScanCB.Name       = 'ImageScanCB'
$ImageScanCB.Size       = New-Object System.Drawing.Size(96,19)
$ImageScanCB.TabIndex   = 7
$ImageScanCB.Text       = 'Image Scan'
$ImageScanCB.UseVisualStyleBackColor = $true

# Peripheral Devices checkbox config
$PeripheralDevicesCB            = New-Object System.Windows.Forms.CheckBox
$PeripheralDevicesCB.BackColor  = $CheckmarkBGColor
$PeripheralDevicesCB.AutoSize   = $true
$PeripheralDevicesCB.Checked    = $true
$PeripheralDevicesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$PeripheralDevicesCB.Location   = New-Object System.Drawing.Point(22,344)
$PeripheralDevicesCB.Name       = 'PeripheralDevicesCB'
$PeripheralDevicesCB.Size       = New-Object System.Drawing.Size(152,19)
$PeripheralDevicesCB.TabIndex   = 6
$PeripheralDevicesCB.Text       = 'Peripheral Devices'
$PeripheralDevicesCB.UseVisualStyleBackColor = $true

# Browser History checkbox config
$BrowserHistoryCB            = New-Object System.Windows.Forms.CheckBox
$BrowserHistoryCB.BackColor  = $CheckmarkBGColor
$BrowserHistoryCB.AutoSize   = $true
$BrowserHistoryCB.Checked    = $true
$BrowserHistoryCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$BrowserHistoryCB.Location   = New-Object System.Drawing.Point(22,297)
$BrowserHistoryCB.Name       = 'BrowserHistoryCB'
$BrowserHistoryCB.Size       = New-Object System.Drawing.Size(131,19)
$BrowserHistoryCB.TabIndex   = 5
$BrowserHistoryCB.Text       = 'Browser History'
$BrowserHistoryCB.UseVisualStyleBackColor = $true

# Browser Cookies checkbox config
$BrowserCookiesCB            = New-Object System.Windows.Forms.CheckBox
$BrowserCookiesCB.BackColor  = $CheckmarkBGColor
$BrowserCookiesCB.AutoSize   = $true
$BrowserCookiesCB.Checked    = $true
$BrowserCookiesCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$BrowserCookiesCB.Location   = New-Object System.Drawing.Point(22,250)
$BrowserCookiesCB.Name       = 'BrowserCookiesCB'
$BrowserCookiesCB.Size       = New-Object System.Drawing.Size(131,19)
$BrowserCookiesCB.TabIndex   = 4
$BrowserCookiesCB.Text       = 'Browser Cookies'
$BrowserCookiesCB.UseVisualStyleBackColor = $true

# Open Window Screenshots checkbox config
$ScreenshotsCB            = New-Object System.Windows.Forms.CheckBox
$ScreenshotsCB.BackColor  = $CheckmarkBGColor
$ScreenshotsCB.AutoSize   = $true
$ScreenshotsCB.Checked    = $true
$ScreenshotsCB.CheckState = [System.Windows.Forms.CheckState]::Checked
$ScreenshotsCB.Location   = New-Object System.Drawing.Point(22,203)
$ScreenshotsCB.Name       = 'ScreenshotsCB'
$ScreenshotsCB.Size       = New-Object System.Drawing.Size(152,19)
$ScreenshotsCB.TabIndex   = 3
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
$MemoryImageCB.TabIndex   = 2
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
$ActiveProcessesCB.TabIndex   = 1
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
$SystemInfoCB.TabIndex   = 0
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
$CheckUncheckAllCB.TabIndex   = 49
$CheckUncheckAllCB.Text       = 'Check/Uncheck All'
$CheckUncheckAllCB.UseVisualStyleBackColor = $false

#VHDXOutputRBtn
$VHDXOutputRBtn            = New-Object System.Windows.Forms.RadioButton
$VHDXOutputRBtn.AutoSize   = $true
$VHDXOutputRBtn.BackColor  = $CheckmarkBGColor
$VHDXOutputRBtn.CheckAlign = [System.Drawing.ContentAlignment]::TopCenter
$VHDXOutputRBtn.Checked    = $true
$VHDXOutputRBtn.Location   = New-Object System.Drawing.Point (772,174)
$VHDXOutputRBtn.Name       = 'VHDXOutputRBtn'
$VHDXOutputRBtn.Size       = New-Object System.Drawing.Size (39,32)
$VHDXOutputRBtn.TabIndex   = 50
$VHDXOutputRBtn.TabStop    = $true
$VHDXOutputRBtn.Text       = 'VHDX'
$VHDXOutputRBtn.UseVisualStyleBackColor = $false

#ZipOutputRBtn
$ZipOutputRBtn            = New-Object System.Windows.Forms.RadioButton
$ZipOutputRBtn.AutoSize   = $true
$ZipOutputRBtn.BackColor  = $CheckmarkBGColor
$ZipOutputRBtn.CheckAlign = [System.Drawing.ContentAlignment]::TopCenter
$ZipOutputRBtn.Location   = New-Object System.Drawing.Point (817,174)
$ZipOutputRBtn.Name       = 'ZipOutputRBtn'
$ZipOutputRBtn.Size       = New-Object System.Drawing.Size (32,32)
$ZipOutputRBtn.TabIndex   = 51
$ZipOutputRBtn.Text       = 'Zip'
$ZipOutputRBtn.UseVisualStyleBackColor = $false

#OutputFormatLabel
$OutputFormatLabel           = New-Object System.Windows.Forms.Label
$OutputFormatLabel.BackColor = $CheckmarkBGColor
$OutputFormatLabel.Location  = New-Object System.Drawing.Point (754,147)
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

# ------------ Scanning Page Elements ------------

# Progress bar
# Timer; Count elapsed time; Estimate time left

# ------------ Results Page Elements ------------

# Panel or group with results textbox
# Textbox has time elapsed, list of things done, successes/failures

# Add buttons to the main form's list of elements

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
$PuTTYBtn.Add_Click({ Putty })
$RegistryScanBtn.Add_Click({ Scan-Registry })
$CheckUncheckAllCB.Add_CheckedChanged({ Toggle-All-Checkboxes })

# Run the main window
[void]$MainForm.ShowDialog()