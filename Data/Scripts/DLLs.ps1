#credit Kyle Pott lifehacker

function find-unsigned {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path
    )
    
 
    Process
    {
      get-childitem -path $Path -Include `
            *.dll -Recurse -ErrorAction ignore |
            Get-AuthenticodeSignature -ErrorAction ignore |
            where-object -Property status -eq "NotSigned" |    
            Out-File "$global:OUTPUT_DIR\DllList.txt"
                $outputFilename = "DllList.txt"
    
      if(Test-Path "$global:OUTPUT_DIR\DllList.txt")
        {
            Search-And-Add-Log-Entry $SUCCESS_LOG ("Created $outputFilename output file successfully")
            return $true
        }
      else
        {
            Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create $outputFilename output file")
            return $false
        }
    }

}


function DLL {

    find-unsigned "C:\Program Files"
    find-unsigned "C:\Program Files (x86)"
    find-unsigned "C:\Windows"
 }

