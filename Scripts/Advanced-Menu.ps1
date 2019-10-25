# Functions for toggling advanced menu on/off
function Open-Advanced-Menu()
{
	# Hide Simple UI elements
	$GoButton.Hide()
    $OutDirTextBoxLbl.Hide()
	$OutDirBtn.Hide()
	$OutDirTextBox.Hide()
	$AdvancedBtn.Hide()

    # Populate list of drives for imaging if first time opening
    Set-Disks-List

	# Show Advanced UI elements
	$AdvOptionGrpBox.Show()
}

function Close-Advanced-Menu()
{
	# Hide Advanced UI elements
	$AdvOptionGrpBox.Hide()

	# Show Simple UI elements
	$GoButton.Show()
    $OutDirTextBoxLbl.Show()
	$OutDirBtn.Show()
	$OutDirTextBox.Show()
	$AdvancedBtn.Show()
}