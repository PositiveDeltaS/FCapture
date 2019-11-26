function Browser-Data-Retrieval
{
    $browser = Get-Content '.\Scripts\Browser-Data-Paths.json' | Out-String | ConvertFrom-Json

    #Browser-Data-Wrapper $browser.SavePath.Edge $browser.FilePath.Edge
    #Browser-Data-Wrapper $browser.SavePath.Chrome $browser.FilePath.Chrome
    #Browser-Data-Wrapper $browser.SavePath.Firefox $browser.FilePath.Firefox
    Browser-Data-Wrapper $browser.SavePath.Opera $browser.FilePath.Opera
    Browser-Data-Wrapper $browser.SavePath.IE $browser.FilePath.IE
	
	
    $success = Check-Success-Current-User-BrowserData
	return $success
}



function Check-Success-Current-User-BrowserData
{
	$successFail = @()
	
	#Adds to beginning of array, so reverse the order for reading the output in the caller
	$successFail += (Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\IE")
	$successFail += (Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Opera")
	$successFail += (Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Firefox")
	$successFail += (Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Chrome")
	$successFail += (Test-Path "$global:OUTPUT_DIR\BrowserData\$env:UserName\Edge")
	
	return $successFail
}


