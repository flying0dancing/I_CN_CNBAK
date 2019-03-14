@Echo off
if "%~1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
set OClient=%~1
call "%~dp0\setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "BACKUP DATABASE [$(OClient)] TO DISK=N'$(sqlbak)\$(OClient).bak' WITH NAME=N'$(OClient)', INIT, FORMAT, CHECKSUM, STOP_ON_ERROR;"

:EXIT