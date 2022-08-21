# provide comma separated list of execution server IPs
# credentials are assumed to be same for all servers
# pre-configure git on all target servers

$Servers = "192.168.85.33", "192.168.85.25"
$ServerUser = "Administrator"
$ServerPass = "Password1"
$RepoPath = "C:\App-Configuration-Demo-Scripts"
$GitExePath = "C:\Program Files\Git\cmd\git.exe"


$PWord = ConvertTo-SecureString -String $ServerPass -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ServerUser, $PWord

#verify that WinRM is setup and configured locally
Test-WSMan

# iterate over servers, test winrm connection and do git pull action
foreach ($server in $Servers) {
    Write-Output "testing winrm service on $server..."
    # see that remote winrm port is listening
    Test-NetConnection -Computername $server -Port 5985
    
    # validate winrm service on remote
    Test-WSMan $server

    # do git pull operation
    Write-Output "Running against $server.."
    
    Invoke-Command -ComputerName $server -Credential $Credential -ScriptBlock {
        Write-Output "hostname: $(hostname)"
        Set-Location -Path $Using:RepoPath
        
        Write-Output "git pull output:"
        & $Using:GitExePath pull
    }
}

Write-Output "Script done!"

