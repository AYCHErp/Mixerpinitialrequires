@echo off
set arg1=%1

if "%1" == "env" (powershell.exe -ExecutionPolicy Bypass -Command "./init/env.ps1")
if "%1" == "config" (powershell.exe -ExecutionPolicy Bypass -Command "./init/config.ps1")
if "%1" == "check-iis" (powershell.exe -ExecutionPolicy Bypass -Command "./init/check-iis.ps1")
if "%1" == "check-pg" (powershell.exe -ExecutionPolicy Bypass -Command "./init/check-postgresql.ps1")
if "%1" == "check-sql-server" (powershell.exe -ExecutionPolicy Bypass -Command "./init/check-sql-server.ps1")
if "%1" == "check-redis" (powershell.exe -ExecutionPolicy Bypass -Command "./init/check-redis.ps1")
if "%1" == "check-vs" (powershell.exe -ExecutionPolicy Bypass -Command "./init/check-vs.ps1")
if "%1" == "check" (
	powershell.exe -ExecutionPolicy Bypass -Command "./init/check-iis.ps1"
	powershell.exe -ExecutionPolicy Bypass -Command "./init/check-postgresql.ps1"
	powershell.exe -ExecutionPolicy Bypass -Command "./init/check-sql-server.ps1"
	powershell.exe -ExecutionPolicy Bypass -Command "./init/check-redis.ps1"
	powershell.exe -ExecutionPolicy Bypass -Command "./init/check-vs.ps1"
)

pause
