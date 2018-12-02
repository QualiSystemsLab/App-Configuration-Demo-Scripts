### Set Log file ###
$dir_name = "azure_config_log"
$dir_path = "C:\$dir_name\azure_config.txt"

New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path $dir_path -Value "Beginning config script" -Force

# turning off local firewall, if you want to leave on you need to open up winrm ports 5985
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Set network to private (necessary for winrm to work)
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# allow winrm config
Enable-PSRemoting -SkipNetworkProfileCheck -Force
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# check winrm status
$winrm_status= Test-WSMan
Add-Content -Path $dir_path "WinRm Status: `n$winrm_status"


# set execution policy to allow scripts to run
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$exec_policy = Get-ExecutionPolicy

Add-Content -Path $dir_path "Current Execution Policy: $exec_policy"