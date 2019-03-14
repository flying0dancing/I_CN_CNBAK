@Echo off

IF "%~1"=="" GOTO Help
IF "%~1"=="/?" GOTO Help

set Product=%~1
set Old_Client=%~2
set New_Client=%~3
Set Flag=%~4



IF NOT EXIST "%Product%\%Old_Client%" GOTO ERROR
IF EXIST "%Product%\%New_Client%" GOTO ERROR

IF /I "%Flag%"=="/U" (net use \\sha-sql2005-c\QA /u:test1 password & GOTO UPDATE)
IF /I "%Flag%"=="/N" (net use \\sha-sql2005-c\QA /u:test1 password & GOTO NEW)
GOTO ERROR

:UPDATE
ECHO ==================================================================
ECHO Copy all files and folders under previous client to new client
ECHO ==================================================================
IF NOT EXIST %windir%\system32\robocopy.exe ( copy \\sha-sql2005-c\QA\Applications\robocopy.exe %windir%\system32\robocopy.exe /Y 1>nul)
call "%~dp0\createDB.bat" "%New_Client%_DATA"
call "%~dp0\createDB.bat" "%New_Client%_SYSTEM"
call "%~dp0\restoreDB.bat" "%Old_Client%_SYSTEM" "%New_Client%_SYSTEM"
robocopy.exe "%Product%\%Old_Client%" "%Product%\%New_Client%" /E /V /ETA 1>nul
call "%~dp0\MLink.vbs" "%Product%\%New_Client%"
call "%~dp0\UpdateDB2.bat" "%Product%\%New_Client%" "%New_Client%"
REG IMPORT "%Product%\%New_Client%\Configuration\UNI.REG" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%Product%\%New_Client%\Configuration\china.cfg" /f 1>nul
CALL "%Product%\%New_Client%\Configuration\CHANGE ALIAS.exe"
PUSHD "%Product%\%New_Client%\Configuration" & START . & POPD
ECHO ==================================================================
ECHO End of Update Old Client to New Client
ECHO ==================================================================
GOTO END

:NEW
ECHO ==================================================================
ECHO Copy Configuration folder under previous client to new client
ECHO Copy CHANGE ALIAS.exe and ChangeAlias.exe to new client
ECHO ==================================================================
call "%~dp0\createDB.bat" "%New_Client%_DATA"
call "%~dp0\createDB.bat" "%New_Client%_SYSTEM"
MD "%Product%\%New_Client%\Admin" && MD "%Product%\%New_Client%\Configuration" && MD "%Product%\%New_Client%\Software" && MD "%Product%\%New_Client%\System" && MD "%Product%\%New_Client%\OUTPUT"
IF NOT EXIST %windir%\system32\robocopy.exe ( copy \\sha-sql2005-c\QA\Applications\robocopy.exe %windir%\system32\robocopy.exe /Y 1>nul)

robocopy.exe "\\sha-sql2005-c\QA\CN\CNBAK\Configuration" "%Product%\%New_Client%\Configuration" "CHANGE ALIAS.exe" china.cfg unicfg.bat 1>nul
call "%~dp0\UpdateDB2.bat" "%Product%\%New_Client%" "%New_Client%"

REG IMPORT "%Product%\%New_Client%\Configuration\UNI.REG" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%Product%\%New_Client%\Configuration\china.cfg" /f 1>nul
CALL "%Product%\%New_Client%\Configuration\CHANGE ALIAS.exe"
ECHO "RUN CHANGE ALIAS.exe" & PAUSE
IF NOT EXIST "C:\Temp"  MD C:\Temp
IF NOT EXIST "C:\STBTEMP"  MD C:\STBTEMP
start /w I:\CN\CN_4201\toolset\v4.5.4.10.exe
call "%~dp0\MLink.vbs" "%Product%\%New_Client%"
PUSHD "%Product%\%New_Client%\Configuration" & START . & POPD
echo "install license & run "%~dp0\mdAlias.bat" "%New_Client%_SYSTEM""
ECHO ==================================================================
ECHO End of Create New Client from Old Client
ECHO ==================================================================
GOTO END

:Help
ECHO ___________________________________________________________________
ECHO 			HELP DOCUMENT					
REM ECHO    
ECHO	Usage :: %~nx0 Product PreviousClient NewClient FLAG
REM ECHO 
ECHO	Product :: Product Directory (drive:\path or \\server\share\path)
ECHO	PreviousClient :: Previous client folder under Product
ECHO	NewClient :: New folder name you want to create under Product
REM ECHO 
ECHO  ::
ECHO  :: FLAG :
ECHO  ::
ECHO	/U :: Update installation mode
ECHO	/N :: New installation mode
ECHO ___________________________________________________________________
GOTO END

:ERROR

ECHO You might be encounter one of these errors.
ECHO   Old Client Folder "%Product%\%Old_Client%" doesn't exist!
ECHO   New Client Folder "%Product%\%New_Client%" exists!
ECHO   Miss Arguments or type wrong
ECHO use "/?" to see HELP DOCUMENT...
GOTO END

:END





