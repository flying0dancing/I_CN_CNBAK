@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%i in ('dir /o-d /a-d /tc /b *.*') do (
set /a n+=1
::���������ļ����Ƴ�������������д�����
echo name:%%i, size:%%~zi
if %%~zi lss 1048576 set /a dx+=1
if "!n!"=="1" goto e
)
:e
echo.
if !dx!==1 echo �������д����Ҫִ�е�����...
pause>nul