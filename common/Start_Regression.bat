@echo off
if not "!PROCESSOR_ARCHITECTURE!"=="%PROCESSOR_ARCHITECTURE%" (
	cmd /V:ON /C %0 %*
    goto END
)
:Start

set TMP_str=%~dp0
set TMP_str=%TMP_str:Configuration\=%
IF "%TMP_str:~-1%"=="\" (
	SET "TMP_str=%TMP_str:~,-1%"	
	) 
set Client_FULLPATH=%TMP_str%
set Client_RT_LOG=%Client_FULLPATH%\Logs\Start_Regression.log
call :CUTSTR_LOOP
set Client_SYSTEM_DATABASE=!Client_FULLPATH:%TMP_str%=!_SYSTEM
echo SYSTEM DATABASE: %Client_SYSTEM_DATABASE%
SET Client_OCMD=sqlcmd -S 172.20.20.55\sql2008 -U sa -P password -d %Client_SYSTEM_DATABASE%
%Client_OCMD% -i "I:\CN\scripts\common\create_sp.sql" -o "%Client_RT_LOG%"

SET AUTOCMD=%Client_FULLPATH%\software\stbauto /username="ADMIN" /password=""
for /F "eol=; tokens=1,* delims=:" %%i in (%~dp0process_date.txt) do ( 
 if "%%i" NEQ "" (
%Client_OCMD% -Q "execute RegressionTests_Prepare '%%j'"
)
 )
 for /F "eol=; tokens=1,* delims=:" %%i in (%~dp0process_date.txt) do ( 
 if "%%i" NEQ "" (
%AUTOCMD% /product="%%i" /PROCDATE=S:%%j
)
 )
CALL %Client_FULLPATH%\SOFTWARE\Utilities\STBReturnCompare\STBReturnCompare.exe
goto END

:CUTSTR_LOOP
IF NOT "%TMP_str%"=="" (
    IF NOT "%TMP_str:~-1%"=="\" (
		SET "TMP_str=%TMP_str:~,-1%"
		GOTO CUTSTR_LOOP
	) 
   
) 
GOTO :EOF


:END