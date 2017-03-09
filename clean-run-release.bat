@echo off
SET currentDirectory=%~dp0

powershell.exe -File empty-solution-directory.ps1
call run-release.bat