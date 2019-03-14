@echo off
if not "!PROCESSOR_ARCHITECTURE!"=="%PROCESSOR_ARCHITECTURE%" (
	cmd /V:ON /C %0 %*
    goto EXIT
)
if "%~1"=="" GOTO HELP
if "%~1"=="/?" GOTO HELP
if "%~2"=="" GOTO HELP
if "%~3"=="" GOTO HELP
set OP=%~1
set Flag=%~2
set OClient=%~3
set "NClient="
set sqlreturnflag=
IF NOT "%~4"=="" (
	 set NClient=%~4
)

IF EXIST "%~dp0\setServer_%Flag%.bat" (
    call "%~dp0\setServer_%Flag%.bat"

    IF /I "%OP%"=="create" (
	    echo Now creating database: %OClient%
	    
	    IF NOT EXIST "!websqlstore!\%OClient%.mdf" (
			 call :create
    			 set sqlreturnflag=1
		) ELSE ( 
			 echo EXIST !websqlstore!\%OClient%.mdf,Cannot create DATABASE.
			set sqlreturnflag=0
	    )
    )
	IF /I "%OP%"=="backup" ( 
	    
		IF NOT EXIST "!websqlbak!\%OClient%.bak" (
			 echo Now backuping database: %OClient%
			 call :backup
		) ELSE ( 
			 echo EXIST !websqlbak!\%OClient%.bak,NO NEED BACKUP DATABASE.
	    )
    )
	IF /I "%OP%"=="restore" (
	    echo restore database: %OClient% to %NClient%
	    call :restore
    )
	IF /I "%OP%"=="drop" (
	    echo drop database: %OClient%
		call :drop
    )
	IF /I "%OP%"=="mdalias" (
	    echo update alias in database: %OClient%
	    rem call :updatealias
		call :mdalias
    )
	
	IF /I "%OP%"=="setADMIN" (
	    echo assignAG in STBADMIN.exe: %OClient%
	    call :assignAG
    )
)
GOTO EXIT

:create
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if not exists (select * From master.dbo.sysdatabases where name='$(OClient)') CREATE DATABASE [$(OClient)] ON  PRIMARY ( NAME = N'$(OClient)', FILENAME = N'$(sqlstore)\$(OClient).mdf') LOG ON ( NAME = N'$(OClient)_Log', FILENAME = N'$(sqlstore)\$(OClient)_Log.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS;"
 IF /I "%Flag:~,5%"=="CHINA" (
     sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "if exists (select * From master.dbo.sysdatabases where name='$(OClient)') ALTER DATABASE [$(OClient)] COLLATE Chinese_PRC_CI_AS;"
 ) 

GOTO :EOF
:backup
echo sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if exists (select * From master.dbo.sysdatabases where name='$(OClient)') BACKUP DATABASE [$(OClient)] TO DISK=N'$(sqlbak)\$(OClient).bak' WITH NAME=N'$(OClient)', INIT, FORMAT;"
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if exists (select * From master.dbo.sysdatabases where name='$(OClient)') BACKUP DATABASE [$(OClient)] TO DISK=N'$(sqlbak)\$(OClient).bak' WITH NAME=N'$(OClient)', INIT, FORMAT;"

GOTO :EOF

:restore
sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "RESTORE FILELISTONLY FROM DISK=N'$(sqlbak)\$(OClient).bak'; RESTORE DATABASE [$(NClient)] FROM  DISK =N'$(sqlbak)\$(OClient).bak' WITH RECOVERY,NOUNLOAD,REPLACE,MOVE N'$(OClient)' TO N'$(sqlstore)\$(NClient).mdf',MOVE N'$(OClient)_log' TO N'$(sqlstore)\$(NClient)_log.ldf';"
sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] MODIFY FILE (NAME=N'$(OClient)', NEWNAME=N'$(NClient)'); if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] MODIFY FILE (NAME=N'$(OClient)_Log', NEWNAME=N'$(NClient)_Log');"
 rem IF /I "%Flag:~,5%"=="CHINA" (
 rem     sqlcmd -S %DBServer% -U %User% -P %Password%  -Q "if exists (select * From master.dbo.sysdatabases where name='$(NClient)') ALTER DATABASE [$(NClient)] COLLATE Chinese_PRC_CI_AS;"
 rem ) 
GOTO :EOF

:drop
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "if exists (select * From master.dbo.sysdatabases where name='$(OClient)') DROP DATABASE [$(OClient)];"
GOTO :EOF

:updatealias
sqlcmd -S %DBServer% -U %User% -P %Password% -d "%OClient%" -Q "UPDATE dbo.ALIASES SET USERNAME='sa',SQLENGINE='SQLSERVER',PASSWORD='7088ED8B04A4DC35',AUTOLOGIN=1 WHERE ALIASTYPE='SQL Server' and ALIAS IN ('STB System','STB Work','STB CORE Data');"
GOTO :EOF

:mdalias
echo sqlcmd -S %DBServer% -U %User% -P %Password% -d "%OClient%" -i "%~dsp0InsertAliases.sql"
sqlcmd -S %DBServer% -U %User% -P %Password% -d "%OClient%" -i "%~dsp0InsertAliases.sql"
GOTO :EOF

:assignAG
sqlcmd -S %DBServer% -U %User% -P %Password% -d "%OClient%" -Q "insert into dbo.USERACCESSGROUPS(AGID,USERNAME) select ID,'ADMIN' from dbo.ACCESSGROUPS where not exists(select AGID from USERACCESSGROUPS where AGID=ID);"
GOTO :EOF

:HELP

ECHO.

ECHO ___________________________________________________________________

ECHO 			HELP DOCUMENT					   

ECHO	Usage :: %~nx0 Operate Testset Database1 [Database2]

ECHO	Operate :: Create,backup,restore,drop,mdalias,setADMIN

ECHO	Testset :: CHINA_SQL

ECHO	Database1 :: database name
ECHO	Database2 :: [use with restore]database name

ECHO ___________________________________________________________________

ECHO.

GOTO EXIT
:EXIT

