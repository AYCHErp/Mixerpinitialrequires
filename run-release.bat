@echo off
SET currentDirectory=%~dp0

powershell.exe -File mixerp-v2.ps1
powershell.exe -File to-release-build.ps1
powershell.exe -File build.ps1

powershell.exe -File remove-git.ps1
powershell.exe -File remove-nuget-packages.ps1
powershell.exe -File remove-cs.ps1
powershell.exe -File remove-area-output.ps1

powershell.exe -File compress-output.ps1

