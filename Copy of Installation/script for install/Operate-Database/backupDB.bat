@Echo off
if "%~1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
set OClient=%~1
call "%~dp0\setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if exists (select * From master.dbo.sysdatabases where name='$(OClient)') BACKUP DATABASE [$(OClient)] TO DISK=N'$(sqlbak)\$(OClient).bak' WITH NAME=N'$(OClient)', INIT, FORMAT;"
rem sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if not exists(select * from msdb.dbo.backupset where database_name='$(OClient)' and type='D') BACKUP DATABASE [$(OClient)] TO DISK=N'$(sqlbak)\$(OClient).bak' WITH NAME=N'$(OClient)', INIT, FORMAT, CHECKSUM, STOP_ON_ERROR;"
:EXIT