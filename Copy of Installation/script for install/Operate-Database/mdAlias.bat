@Echo off
if "%1"=="" (echo Error: No old db passed with script!) & (goto EXIT)
set NDataBbase=%1
call "%~dp0\setDBServer.bat"
sqlcmd -S %DBServer% -U %User% -P %Password% -Q "use $(NDataBbase); UPDATE ALIASES SET USERNAME='sa',SQLENGINE='SQLSERVER',PASSWORD='7088ED8B04A4DC35',AUTOLOGIN=1 WHERE ALIASTYPE='SQL Server' and ALIAS IN ('STB System','STB Work','STB CORE Data');"


:EXIT