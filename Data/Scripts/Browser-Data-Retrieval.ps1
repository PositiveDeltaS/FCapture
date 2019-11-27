function Browser-Data-Retrieval
{
    $browser = Get-Content '$PSScriptRoot\..\Scripts\Browser-Data-Paths.json' | Out-String | ConvertFrom-Json

    Browser-Data-Wrapper $browser.SavePath.Edge $browser.FilePath.Edge
    Browser-Data-Wrapper $browser.SavePath.Chrome $browser.FilePath.Chrome
    Browser-Data-Wrapper $browser.SavePath.Firefox $browser.FilePath.Firefox
    Browser-Data-Wrapper $browser.SavePath.Opera $browser.FilePath.Opera
    Browser-Data-Wrapper $browser.SavePath.IE $browser.FilePath.IE
	
	
    $success = Check-Success-Current-User-BrowserData
	return $success
}



function Check-Success-Current-User-BrowserData
{
	$successFail = @($false,$false,$false,$false,$false)
	
	$successFail[0] = Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Edge"
	$successFail[1] = Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Chrome"
	$successFail[2] = Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Firefox"
	$successFail[3] = Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Opera"
	$successFail[4] = Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\IE"
	
	return $successFail
}


