function AmCache {
    
    $path = "C:\Windows\appcompat\Programs\Amcache.hve"
    $destination = "global:OUTPUT_DIR\"

    
    if (-not (Test-Path -Path $path)) {
        throw "File not found: $path" 
    }

    $sourcefile = Split-Path -Path $path -Leaf
    $destinationfile = Join-Path -Path $destination -ChildPath $sourcefile
    $b4hash = Get-FileHash -Path $path
    
    try {
        Copy-Item -Path $path -Destination $destination -Force -ErrorAction Stop
    }
    catch {
        throw "Copying Amcache.hve failed"
    }
    finally {
        $afhash = Get-FileHash -Path $destinationfile
        if ($afhash.Hash -ne $b4hash.Hash) {
            throw "Amcache.hve corrupted during copy"
        }
        else {
            Write-Information -MessageData "Amcache.hve copied successfully" -InformationAction Continue
        }
    }
 }

 Amcache