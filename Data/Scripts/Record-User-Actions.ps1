<#  
    Contained are a set of functions for recording program states as well as the time of state change.
    Treat the wrapper functions as public and the recursive functions as private.
    Since the recursive functions require parameters to be passed into them, wrapper
    functions should be used to call the recursive functions from main.
    If a preexisting wrapper function does not meet your needs, create a new wrapper
    function that calls the desired recursive function with more appropriate arguments.
#> 


<# -                              - #>
<# --- Public Wrapper Functions --- #>
<# -                              - #>

# Wrapper for Display-Interactable-Elements
function Display-Main() {
    Display-Interactable-Elements $MainForm ""
}

# Wrapper for Initialize-EventListeners
function Initialize-Main() {
    Initialize-EventListeners $MainForm
}

# Wrapper for Update-State
# Caller parameter is necessary for accurate PushButton state update
function Update-Main-State($Caller) {
    $State = [ordered]@{}
    Update-State $MainForm $State $Caller
    $global:StateRecord[(Get-Date -Format "MM/dd/yyyy HH:mm:ss:fff").ToString()] = $State
}

function Store-Main-State() {
    $SessionDir = Get-ChildItem -Path "$global:OUTPUT_DIR\Record\"
    if($SessionDir) {
        $NameData = $SessionDir.Name
        if($NameData -is [array]) {
            $NameData = $NameData[$NameData.Length - 1].ToString() # Convert $NameData from Array to String
        }
        $Number = [int]$NameData[7].ToString()
        $Number++
    } else {
        $Number = 1
    }
    Write-Recoverable $global:StateRecord "$global:OUTPUT_DIR\Record\Session$Number.xml" 
}


<# -                                         - #>
<# --- Recursive/General Purpose Functions --- #>
<# -                                         - #>

# Recursively displays elements contained in $ElementArray that are derived from ButtonBase class
function Display-Interactable-Elements($ElementArray, $Tabs) {
    $ElementArray.Controls.ForEach({
        if($_.GetType().BaseType.ToString().Equals("System.Windows.Forms.ButtonBase")) {
            Write-Host "$($Tabs)Name: $($_.Text)"
            Write-Host "$($Tabs)Role: $($_.AccessibilityObject.Role)"
            Write-Host "- - - - - - - - - - - - - - -"
        } elseif($_.Controls) {
            Display-Interactable-Elements $_ +$Tabs"`t"
        }
    })
}

# Initialize all ButtonBase derived elements contained within $ElementArray with Click event listeners
function Initialize-EventListeners($ElementArray) {
    $ElementArray.Controls.ForEach({
        if($_.GetType().BaseType.ToString().Equals("System.Windows.Forms.ButtonBase")) {
            Register-ObjectEvent -InputObject $_ -EventName Click -Action { 
                Update-Main-State $Event.SourceArgs.Text
            } | Out-Null
        } elseif($_.Controls) {
            Initialize-EventListeners $_
        }
    })
}

# Store newly updated state of $ElementArray in $StateRecord
function Update-State($ElementArray, $State, $Caller) {
    $ElementArray.Controls.ForEach({
        if($_.GetType().BaseType.ToString().Equals("System.Windows.Forms.ButtonBase")) {
            $Name = $_.Text
            $Role = $_.AccessibilityObject.Role.ToString()
            if($Role.Equals("PushButton")) {
                if($Name.Equals($Caller)) {$State[$Name] = 1} else {$State[$Name] = 0}
            } else {
                $State[$Name] = $_.Checked
            }
        } elseif($_.Controls) {
            Update-State $_ $State $Caller
        }
    })
}

function Write-Recoverable($PSObj, $Path) {
    $PSObj | Export-Clixml $Path
}