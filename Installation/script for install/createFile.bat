@echo off
echo ^@echo off>"%New_FullPath%\Configuration\unicfg.bat"
rem echo call "%%~dp0CHANGE ALIAS.exe">>"%New_FullPath%\Configuration\unicfg.bat"
rem new add
echo net use \\172.20.20.55\qa /u:test1 password>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _cfg_path=%%~dp0>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _pdt_path=%%_cfg_path:Configuration\=%%>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _sft_path=%%_cfg_path:Configuration=Software%%>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _tls_path=\\172.20.20.55\qa\CN\scripts\common\script for install\>>"%New_FullPath%\Configuration\unicfg.bat"

rem echo REG IMPORT "%%~dp0%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
rem echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%~dp0%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo REG IMPORT "%%_cfg_path%%%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%_cfg_path%%%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"

echo CALL "%%_tls_path%%AutoChangeAlias.exe" "%%_sft_path%%CHANGE ALIAS.exe" "%%_pdt_path%%">>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%_tls_path%%AutoSTBConnSetup.exe" "%%_sft_path%%STBConnSetup.exe">>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%_tls_path%%AutoSuperC.exe" "%%_sft_path%%" ADMIN>>"%New_FullPath%\Configuration\unicfg.bat"
rem echo call "%%_sft_path%%STBDATA.exe" /username="admin" /password="">>"%New_FullPath%\Configuration\unicfg.bat"
echo exit /B ^0>>"%New_FullPath%\Configuration\unicfg.bat"
rem end new add

PUSHD "%New_FullPath%\Configuration" & START . & POPD
