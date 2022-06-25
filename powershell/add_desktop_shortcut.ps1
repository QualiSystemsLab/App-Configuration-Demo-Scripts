# add folder to house shortcuts
$dir_name = "skybox-shortcuts"
$dirPath = Join-Path ([Environment]::GetFolderPath("Desktop")) $dir_name
New-Item -ItemType Directory -Force -Path $dirPath

# $linkPath = Join-Path ([Environment]::GetFolderPath("Desktop")) "shcuts\skyboxserver.lnk"
$linkPath = "$dirPath\test33.lnk"
# $targetPath = Join-Path ([Environment]::GetFolderPath("ProgramFiles")) "MyCompany\MyProgram.exe"
$targetPath = "http://skybox-server.demo.skybox.com"
$link = (New-Object -ComObject WScript.Shell).CreateShortcut( $linkpath )
$link.TargetPath = $targetPath
$link.Save()