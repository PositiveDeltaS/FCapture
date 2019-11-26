function Record-Registry {
    
     $path = "$global:OUTPUT_DIR\Registry"

     if (-not (Test-Path -Path $path)) {
        New-Item -ItemType directory -Path $global:OUTPUT_DIR\Registry
    }

    $flag = $true

    reg export “HKEY_CLASSES_ROOT” $global:OUTPUT_DIR\Registry\Hkey_classes_root.reg
    if(-not (Test-Path "$global:OUTPUT_DIR\Registry\Hkey_classes_root.reg")) {
        $flag = $false
    }

    reg export “HKEY_CURRENT_USER” $global:OUTPUT_DIR\Registry\Hkey_current_user.reg
    if(-not (Test-Path "$global:OUTPUT_DIR\Registry\Hkey_current_user.reg")) {
         $flag = $false
    }

    reg export “HKEY_LOCAL_MACHINE” $global:OUTPUT_DIR\Registry\Hkey_local_machine.reg
    if(-not (Test-Path "$global:OUTPUT_DIR\Registry\Hkey_local_machine.reg")) {
         $flag = $false
    }

    reg export “HKEY_USERS” $global:OUTPUT_DIR\Registry\Hkey_users.reg
    if(-not (Test-Path "$global:OUTPUT_DIR\Registry\Hkey_users.reg")) {
         $flag = $false
    }

    reg export “HKEY_CURRENT_CONFIG” $global:OUTPUT_DIR\Registry\Hkey_current_config.reg
    if(-not (Test-Path "$global:OUTPUT_DIR\Registry\Hkey_current_config.reg")) {
         $flag = $false
    }

    if($flag -eq $false) {
        Search-And-Add-Log-Entry $FAIL_LOG ("Failed to create output file for one or more registry files in Record-Registry function")
        return $false
    }
    else {
        Search-And-Add-Log-Entry $SUCCESS_LOG ("Created Registry output files successfully")
        return $true
    }
    
  }