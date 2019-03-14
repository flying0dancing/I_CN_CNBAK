@Echo off
if "%~1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
set NClient=%~1
rem call "%~dp0\setDBServer.bat"

sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if not exists (select * From master.dbo.sysdatabases where name='$(NClient)') CREATE DATABASE [$(NClient)] ON  PRIMARY ( NAME = N'$(NClient)', FILENAME = N'$(sqlstore)\$(NClient).mdf') LOG ON ( NAME = N'$(NClient)_Log', FILENAME = N'$(sqlstore)\$(NClient)_Log.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS;"


if "%~2"=="" goto EXIT
set Flag=%~2
 IF /I "%Flag%"=="CHINA" (
     sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] COLLATE Chinese_PRC_CI_AS;"
 ) 
 
 
:EXIT