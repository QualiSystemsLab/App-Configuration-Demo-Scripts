# WebUrl example: "http://localhost:9091/hello_world.zip"

$WebUrl = $env:WebUrl 
$ZipName = "my_archive.zip"
$ExeFolder = "C:\my-exe"
$ZipPath = "$ExeFolder\$ZipName"
$ExeName = "hello_world.exe"

# Create Parent Exe Folder
New-Item -ItemType Directory -Force -Path $ExeFolder

# download zip from target url to Exe Folder
Invoke-WebRequest $WebUrl -OutFile $ZipPath

# extract exe from zip - overwrite existing
Expand-Archive -Path $ZipPath -DestinationPath $ExeFolder

# Run Exe
& $ExeFolder\$ExeName