# provide comma separated list of execution server IPs
# server credentials are assumed to be same for all servers
# pre-configure git on all target servers and clone repo to same absolute path
# run 'winrm quickconfig' on target execution servers to turn on winrm service
# add execution servers to trusted host list of script runner machine: Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'IP_A, IP_B'

$Servers = "<SERVER_IP_1>", "<SERVER_IP_2>"
$ServerUser = "<MY_USER>"
$ServerPass = "<MY_PASS>"
$RepoPath = "<GIT_REPO_PATH>"
$GitExePath = "C:\Program Files\Git\cmd\git.exe"

$PWord = ConvertTo-SecureString -String $ServerPass -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ServerUser, $PWord

Test-WSMan

foreach ($server in $Servers) {
    Write-Output "Running against $server..."
    
    Write-Output "Checking winrm port:"
    Test-NetConnection -Computername $server -Port 5985
    
    Write-Output "Testing Winrm Service:"
    Test-WSMan $server

    Invoke-Command -ComputerName $server -Credential $Credential -ScriptBlock {
        Write-Output "Remote Hostname: $(hostname)"
        Set-Location -Path $Using:RepoPath
        
        Write-Output "git pull output:"
        & $Using:GitExePath pull
    }
}

Write-Output "Script done!"

