function Browser-Data-InternetExplorer
{
	C:\Users\Krempire\AppData\Local\Microsoft\Internet Explorer
	
	$path = "AppData\Local\Microsoft\Internet Explorer"
	$outPath = "Internet Explorer\Data"
	$users = Get-Desired-User-Profile-Names $path
	Get-Browser-Data $users $path $outPath

}