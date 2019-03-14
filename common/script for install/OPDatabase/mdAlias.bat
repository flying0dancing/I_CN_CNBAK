@Echo off
if "%1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
set NDataBbase=%1
call "%~dp0\setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "use $(NDataBbase); UPDATE [dbo].[ALIASES] SET USERNAME='sa',SQLENGINE='SQLSERVER',PASSWORD='7088ED8B04A4DC35',AUTOLOGIN=1 where ALIASTYPE='SQL Server' and  ALIAS IN ('STB System','STB Work','STB CORE Data','STB CORE System','STB CN Data','CHINA_DATA','CHINA_SYSTEM','STB CBRC Data','STB CBRC System','STB PBOC Data','STB PBOC System','STB SAFE Data','STB SAFE System');"


:EXIT