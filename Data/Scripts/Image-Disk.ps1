function Set-Disks-List
{
    if(!$DiskImgCBList.Items)
    {
        # Currently, we only get the non-removable drives as candidates for imaging
        $DiskImgCBList.Items.AddRange(([System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -ne "Removable" }).Name)
    }
}

function Disk-Image
{
    # Get the list of drives that the user wants to image
	if($DiskImgCBList.CheckedItems) {
		$drivesToCopy = ($DiskImgCBList.CheckedItems).replace(":\", "") -join ','
		
		# For each drive, image the disk
		$outputDrive = (Get-Item $global:OUTPUT_DIR).PSDrive.Name
		wbAdmin start backup -backupTarget:${outputDrive}: -include:${drivesToCopy}: -quiet | Out-Null
		
		$imagePath = $outputDrive + ":\WindowsImageBackup"
		if(Test-Path -Path $imagePath) {
			mv $imagePath ($global:OUTPUT_DIR + "\Disk-Image")
			Search-And-Add-Log-Entry $SUCCESS_LOG "Image-Disk"
		}
		else {
			Search-And-Add-Log-Entry $FAIL_LOG "Image-Disk"
		}
	}
	else {
		Search-And-Add-Log-Entry $SUCCESS_LOG "Image-Disk: No Drives Selected"
	}
}