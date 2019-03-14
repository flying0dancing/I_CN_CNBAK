@Echo off
if "%~1"=="" GOTO HELP
if "%~2"=="" GOTO HELP
if "%~3"=="" GOTO HELP
set OP=%~1
set Flag=%~2
set OClient=%~3
rem set "NClient="
IF NOT "%~4"=="" (
	 set NClient=%~4
)
echo "%OP%" "%Flag%"
echo "%OClient%"
echo "%NClient%"
GOTO EXIT

:create
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if not exists (select * From master.dbo.sysdatabases where name='$(NClient)') CREATE DATABASE [$(NClient)] ON  PRIMARY ( NAME = N'$(NClient)', FILENAME = N'$(sqlstore)\$(NClient).mdf') LOG ON ( NAME = N'$(NClient)_Log', FILENAME = N'$(sqlstore)\$(NClient)_Log.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS;"
 IF /I "%Flag%"=="CHINA" (
     sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] COLLATE Chinese_PRC_CI_AS;"
 ) 
GOTO :EOF
:backup
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if exists (select * From master.dbo.sysdatabases where name='$(OClient)') BACKUP DATABASE [$(OClient)] TO DISK=N'$(sqlbak)\$(OClient).bak' WITH NAME=N'$(OClient)', INIT, FORMAT;"
GOTO :EOF

:HELPE
CHO.
ECHO ___________________________________________________________________
ECHO 			HELP DOCUMENT					   
ECHO	Usage :: %~nx0 Operate Flag Database1 [Database2]
ECHO	Operate :: Create,backup,restore,drop
ECHO	Flag :: CHINA_SQLECHO	Database1 :: database name
ECHO ___________________________________________________________________
ECHO.
GOTO EXIT
:EXIT

