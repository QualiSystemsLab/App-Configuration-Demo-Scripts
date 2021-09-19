$User = "Administrator"
$PWord = ConvertTo-SecureString -String "Password1" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
Invoke-Command -ComputerName 192.168.85.79 -Credential $Credential -ScriptBlock {hostname}