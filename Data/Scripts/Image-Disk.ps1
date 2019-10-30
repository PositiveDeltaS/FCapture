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
	$drivesToCopy = ($DiskImgCBList.CheckedItems).replace(":\", "") -join ','

    # For each drive, image the disk
	$outputDrive = (Get-Item $global:OUTPUT_DIR).PSDrive.Name
	wbAdmin start backup -backupTarget:${outputDrive}: -include:${drivesToCopy}: -quiet
}