# Function for going from splashscreen to main menu
function Open-Main-Menu()
{
	# Hide Splashscreen UI elements
	$SSTopPanel.Hide()
    $SSBottomPanel.Hide()

	# Show Main Menu UI elements
	$GoButton.Show()
    $OutDirTextBoxLbl.Show()
	$OutDirBtn.Show()
	$OutDirTextBox.Show()
	$AdvancedBtn.Show()
    $BgPanel.Show()
    $MenuStrip.Show()
}

# Functions for toggling advanced menu on/off
function Open-Advanced-Menu()
{
	# Hide Main Menu UI elements
	$GoButton.Hide()
    $OutDirTextBoxLbl.Hide()
	$OutDirBtn.Hide()
	$OutDirTextBox.Hide()
	$AdvancedBtn.Hide()
    $BgPanel.Hide()

    # Populate list of drives for imaging if first time opening
    Set-Disks-List

	# Show Advanced UI elements
	$AdvOptionGrpBox.Show()
}

function Close-Advanced-Menu()
{
	# Hide Advanced UI elements
	$AdvOptionGrpBox.Hide()

	# Show Main Menu UI elements
	$GoButton.Show()
    $OutDirTextBoxLbl.Show()
	$OutDirBtn.Show()
	$OutDirTextBox.Show()
	$AdvancedBtn.Show()
    $BgPanel.Show()
}