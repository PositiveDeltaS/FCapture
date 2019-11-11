function Browser-Data-FireFox
{
	$path = "AppData\Roaming\Mozilla\Firefox\Profiles"
	$outPath = "FireFox\Data"
	$users = Get-Desired-User-Profile-Names $path
	Get-Browser-Data $users $path $outPath
}
