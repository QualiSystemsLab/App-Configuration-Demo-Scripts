$localpass = $env:local_password
$dcpass = $env:dc_password

$dir_name = "test-dir-env-testing"

New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path "C:\$dir_name\ps-test.txt" -Value "localuser from env: $localpass, dcuser from env: $dcpass" -Force

Write-Output "The test directory has been created: $dir_name"