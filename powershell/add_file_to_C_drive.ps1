$dir_name = "test-dir"

New-Item -ItemType Directory -Force -Path "C:\$dir_name"
Set-Content -Path "C:\$dir_name\ps-test.txt" -Value "My test Value!!!" -Force

Write-Output "The test directory has been created on C Drive: $dir_name"