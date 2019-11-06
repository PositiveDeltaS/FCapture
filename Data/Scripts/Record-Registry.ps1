function Record-Registry {
    
     $path = "$global:OUTPUT_DIR\Registry"

     if (-not (Test-Path -Path $path)) {
        New-Item -ItemType directory -Path $global:OUTPUT_DIR\Registry
    }

    reg export “HKEY_CLASSES_ROOT” $global:OUTPUT_DIR\Registry\Hkey_classes_root.reg
    reg export “HKEY_CURRENT_USER” $global:OUTPUT_DIR\Registry\Hkey_current_user.reg
    reg export “HKEY_LOCAL_MACHINE” $global:OUTPUT_DIR\Registry\Hkey_local_machine.reg
    reg export “HKEY_USERS” $global:OUTPUT_DIR\Registry\Hkey_users.reg
    reg export “HKEY_CURRENT_CONFIG” $global:OUTPUT_DIR\Registry\Hkey_current_config.reg

    }