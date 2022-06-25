# WebUrl example: "http://localhost:9091/hello_world.zip"

$WebUrl = $env:WebUrl 
$ZipName = "my_archive.zip"
$ExeName = "hello_world.exe"

# download zip from target url
Invoke-WebRequest $WebUrl -OutFile .\$ZipName

# extract zip - overwrite existing
Expand-Archive -Path .\$ZipName -DestinationPath . -Force

# Run Exe
& .\$ExeName