@echo off
@setlocal enableextensions
@cd /d "%~dp0"

powershell.exe -File mixerp-v2.ps1
powershell.exe -File build.ps1

pause