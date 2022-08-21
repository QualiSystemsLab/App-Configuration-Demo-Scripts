$User = "MyUser"
$PWord = ConvertTo-SecureString -String "MyPasswor" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Invoke-Command -ComputerName 192.168.3.5 -Credential $Credential -ScriptBlock {hostname}