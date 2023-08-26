$7ZIPURL = 'https://www.7-zip.org/a/7z2301-x64.exe'
$SourceFolder = 'C:\Windows\Temp\7z2301-x64.exe'
Invoke-WebRequest -Uri $7ZIPURL -OutFile $SourceFolder

Start-Process -FilePath 'C:\Windows\Temp\7z2301-x64.exe' -ArgumentList "/S"
