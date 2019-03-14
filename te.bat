@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%i in ('dir /o-d /a-d /tc /b *.*') do (
set /a n+=1
::如果你想把文件复制出来可以在下面写上命令。
echo name:%%i, size:%%~zi
if %%~zi lss 1048576 set /a dx+=1
if "!n!"=="1" goto e
)
:e
echo.
if !dx!==1 echo 这里可以写上你要执行的命令...
pause>nul