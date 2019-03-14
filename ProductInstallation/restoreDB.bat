@Echo off
if "%~1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
if "%~2"=="" (echo Error: No new db passed with script!) & (goto EXIT)
set OClient=%~1
set NClient=%~2
call "%~dp0setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "RESTORE FILELISTONLY FROM DISK=N'$(sqlbak)\$(OClient).bak'; RESTORE DATABASE [$(NClient)] FROM  DISK =N'$(sqlbak)\$(OClient).bak' WITH RECOVERY,NOUNLOAD,REPLACE,MOVE N'$(OClient)' TO N'$(sqlstore)\$(NClient).mdf',MOVE N'$(OClient)_log' TO N'$(sqlstore)\$(NClient)_log.ldf';"
sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "ALTER DATABASE [$(NClient)] MODIFY FILE (NAME=N'$(OClient)', NEWNAME=N'$(NClient)'); ALTER DATABASE [$(NClient)] MODIFY FILE (NAME=N'$(OClient)_Log', NEWNAME=N'$(NClient)_Log');"

:EXIT