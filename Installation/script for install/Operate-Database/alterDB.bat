@Echo off
if "%~1"=="" (echo Error: No old database passed with script!) & (goto EXIT)
if "%~2"=="" (echo Error: No new database passed with script!) & (goto EXIT)
set OClient=%~1
set NClient=%~2
call "%~dp0setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] MODIFY FILE (NAME=N'$(OClient)', NEWNAME=N'$(NClient)'); if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] MODIFY FILE (NAME=N'$(OClient)_Log', NEWNAME=N'$(NClient)_Log');"

:EXIT