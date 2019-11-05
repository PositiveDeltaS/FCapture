function Toggle-All-Checkboxes
{
    # Get checked state of the toggle checkbox
    $newCheckedstate = $CheckUncheckAllCB.Checked

    # Match all checkboxes with the toggle checkbox
    Foreach ($control in $AdvOptionGrpBox.Controls)
    {
        $objectType = $control.GetType().Name
        If ($objectType -like "CheckBox")
        { 
            $control.Checked = $newCheckedstate
        }
    }
}