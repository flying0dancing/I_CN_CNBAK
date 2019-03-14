@echo off
setlocal enabledelayedexpansion
:start

for /f "delims=" %%i in ('dir /o-d /a-d /tc /b "D:\WorkArea\I_CN_CNBAK\*.*"') do (
echo %%i
set name=%%i
goto e
)

:e

echo %name%|findstr /I "c1"  &&  goto END
rem goto start
echo ""adf""

:END