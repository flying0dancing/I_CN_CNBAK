@echo off
echo ^@echo off>"%New_FullPath%\Configuration\unicfg.bat"

rem new add
echo net use i: \\172.20.20.55\qa /u:test1 password>>"%New_FullPath%\Configuration\unicfg.bat"
echo net use H: \\172.20.20.57\qa /u:test1 password>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _cfg_path=%%~dp0>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _pdt_path=%%_cfg_path:Configuration\=%%>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _sft_path=%%_cfg_path:Configuration=Software%%>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _tls_path=\\172.20.20.55\qa\CN\scripts\Copy of Installation\script for install\>>"%New_FullPath%\Configuration\unicfg.bat"

rem echo REG IMPORT "%%~dp0%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
rem echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%~dp0%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"


echo if defined PROCESSOR_ARCHITEW6432 (  >>"%New_FullPath%\Configuration\unicfg.bat"
echo REG IMPORT "%%_cfg_path%%%testset%_wow64.reg" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo reg add "HKLM\SOFTWARE\Wow6432Node\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%_cfg_path%%%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo ) else (  >>"%New_FullPath%\Configuration\unicfg.bat"
echo    if "%%PROCESSOR_ARCHITECTURE%%"=="x86" (  >>"%New_FullPath%\Configuration\unicfg.bat"
echo REG IMPORT "%%_cfg_path%%%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%_cfg_path%%%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo  ) else (  echo "please use elevated C:\\Windows\\SysWOW64\\cmd.exe" ^& GOTO END) >>"%New_FullPath%\Configuration\unicfg.bat"
echo   )  >>"%New_FullPath%\Configuration\unicfg.bat"



echo CALL "%%_tls_path%%AutoChangeAlias.exe" "%%_sft_path%%CHANGE ALIAS.exe" "%%_pdt_path%%">>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%_tls_path%%AutoSTBConnSetup.exe" "%%_sft_path%%STBConnSetup.exe">>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%_tls_path%%AutoSuperC.exe" "%%_sft_path%%" ADMIN>>"%New_FullPath%\Configuration\unicfg.bat"
rem echo call "%%_sft_path%%STBDATA.exe" /username="admin" /password="">>"%New_FullPath%\Configuration\unicfg.bat"
echo exit /B ^0>>"%New_FullPath%\Configuration\unicfg.bat"
echo :END>>"%New_FullPath%\Configuration\unicfg.bat"
rem end new add

PUSHD "%New_FullPath%\Configuration" & START . & POPD
