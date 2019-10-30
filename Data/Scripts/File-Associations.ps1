function File-Associations {
	try 
	{
		cmd /c assoc | Out-File "$global:OUTPUT_DIR\File-Associations.txt"
		Search-And-Add-Log-Entry $SUCCESS_LOG "File-Associations"
	}
	catch
	{
		Search-And-Add-Log-Entry $FAIL_LOG "File-Associations"
	}
}