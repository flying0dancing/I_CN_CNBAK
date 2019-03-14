@Echo off
if "%~1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
set NClient=%~1
call "%~dp0\setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "CREATE DATABASE [$(NClient)] ON  PRIMARY ( NAME = N'$(NClient)', FILENAME = N'$(sqlstore)\$(NClient).mdf') LOG ON ( NAME = N'$(NClient)_Log', FILENAME = N'$(sqlstore)\$(NClient)_Log.ldf') COLLATE Chinese_PRC_CI_AS;"

:EXIT