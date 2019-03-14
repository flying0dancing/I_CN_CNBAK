@echo off
REG IMPORT "%~dp0UNI.REG" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%~dp0china.cfg" /f 1>nul
CALL "%~dp0CHANGE ALIAS.exe"