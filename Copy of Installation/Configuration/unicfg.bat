@echo off
net use \\172.20.20.55\qa /u:test1 password
set _cfg_path=%~dp0
set _pdt_path=%_cfg_path:Configuration\=%
set _sft_path=%_cfg_path:Configuration=Software%
set _tls_path=\\172.20.20.55\qa\CN\scripts\common\script for install\

REG IMPORT "%_cfg_path%China_sql.reg" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%_cfg_path%China_sql.cfg" /f 1>nul

CALL "%_tls_path%AutoChangeAlias.exe" "%_sft_path%CHANGE ALIAS.exe" "%_pdt_path%"
call "%_tls_path%AutoSTBConnSetup.exe" "%_sft_path%STBConnSetup.exe"
call "%_tls_path%AutoSuperC.exe" "%_sft_path%" ADMIN
exit /B 0
