function Browser-Data-Chrome 
{
	$path = "AppData\Local\Google\Chrome\User Data\Default"
	$outPath = "Chrome\Data"
	$users = Get-Desired-User-Profile-Names $path
	Get-Browser-Data $users $path $outPath
}