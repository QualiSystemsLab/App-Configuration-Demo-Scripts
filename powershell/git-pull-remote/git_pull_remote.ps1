# provide comma separated list of execution server IPs
# credentials are assumed to be same for all servers
# pre-configure git on all target servers and clone repo to same absolute path

$Servers = "<SERVER_IP_1>", "<SERVER_IP_2>"
$ServerUser = "<MY_USER>"
$ServerPass = "<MY_PASS>"
$RepoPath = "<GIT_REPO_PATH>"
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

