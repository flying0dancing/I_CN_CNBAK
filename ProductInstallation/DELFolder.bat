@ECHO OFF
REM Delete all files and subfolders under given folder
DEL /F /S /Q %1 1>nul
RMDIR /S /Q %1 1>nul