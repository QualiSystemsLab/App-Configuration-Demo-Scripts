### Set Log file ###
$dir_name = "azure-config-logs"
$dir_path = "C:\$dir_name\azure-config-log.txt"
New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path $dir_path -Value "Beginning config script" -Force

# turning off local firewall, if you want to leave on you need to open up winrm ports 5985
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Set network to private (necessary for winrm to work)
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
$net_connection_profile = Get-NetConnectionProfile
$net_category = $net_connection_profile.NetworkCategory
Add-Content -Path $dir_path -Value "Current Network Profile $net_category" -Force

# allow winrm config
Enable-PSRemoting -SkipNetworkProfileCheck -Force
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
set-item WSMan:\localhost\Client\TrustedHosts * -Force

# check winrm status
$winrm_status= Test-WSMan
$wsmid = $winrm_status.wsmid
Add-Content -Path $dir_path "WinRm wsmid: `n$wsmid"

# winrm quickconfig
$winrm_quickconfig_res = winrm quickconfig -force
Add-Content -Path $dir_path "WinRm quickconfig response: `n$winrm_quickconfig_res"

# set execution policy to allow scripts to run
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$exec_policy = Get-ExecutionPolicy
Add-Content -Path $dir_path "Current Execution Policy: $exec_policy"
