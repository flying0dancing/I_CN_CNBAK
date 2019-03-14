@Echo off
if not "!PROCESSOR_ARCHITECTURE!"=="%PROCESSOR_ARCHITECTURE%" (
	cmd /V:ON /C %0 %*
    goto END
)

IF "%~1"=="" GOTO Help
IF "%~1"=="/?" GOTO Help
set testset=%~1
set "flag="
set "flag2="
IF NOT EXIST "%~dp0%~n0.ini" GOTO ERROR1
for /f "delims= usebackq" %%a in (`type "%~dp0%~n0.ini"`) do (
  set v=%%a
  if "!v:~0,1!"=="[" ( 
    if /I %%a==[%testset%] (set flag=1) else (if defined flag2 (goto Start) else (set "flag="))
  ) else (
    if defined flag (
      for /f "tokens=1,2 delims==" %%i in ("%%a") do (
		set %%i=%%j
		set flag2=1
         
      )
    )
  )
)

:Start
if "%New_Path%"==""  GOTO ERROR
if "%New_Client%"=="" GOTO ERROR
set New_FullPath=%New_Path%\%New_Client%
set Old_FullPath=%Old_Path%\%Old_Client%
set InstallScriptsPath=%~dp0\script for install
%ExecCmd_1%
    IF /I "%NEW_Install_Mode%"=="Y" (
	    IF EXIST "%New_FullPath%" GOTO ERROR
        net use \\sha-sql2005-c\QA /u:test1 password & GOTO NEW
    ) ELSE (
	    IF "%Old_Client%"=="" GOTO ERROR
	    IF NOT EXIST "%Old_FullPath%" GOTO ERROR
        net use \\sha-sql2005-c\QA /u:test1 password & GOTO UPDATE
    )
GOTO ERROR

:UPDATE
ECHO ==================================================================
ECHO Copy all files and folders under previous client to new client
ECHO ==================================================================
IF NOT EXIST %windir%\system32\robocopy.exe ( copy \\sha-sql2005-c\QA\Applications\robocopy.exe %windir%\system32\robocopy.exe /Y 1>nul)
call "%InstallScriptsPath%\createDB.bat" "%New_Client%_DATA" "%testset%"
call "%InstallScriptsPath%\createDB.bat" "%New_Client%_SYSTEM" "%testset%"
rem call "%InstallScriptsPath%\backupDB.bat" "%Old_Client%_SYSTEM"
call "%InstallScriptsPath%\restoreDB.bat" "%Old_Client%_DATA" "%New_Client%_DATA"
call "%InstallScriptsPath%\restoreDB.bat" "%Old_Client%_SYSTEM" "%New_Client%_SYSTEM"
robocopy.exe "%Old_FullPath%" "%New_FullPath%" /E /V /ETA 1>nul
call "%InstallScriptsPath%\MLink.vbs" "%New_FullPath%"
call "%InstallScriptsPath%\MdRegwithClient.bat" "%New_FullPath%\Configuration\%reg%" "%New_Client%"

REG IMPORT "%New_FullPath%\Configuration\%reg%" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%New_FullPath%\Configuration\%cfg%" /f 1>nul
call "%InstallScriptsPath%\AutoChangeAlias.exe" "%New_FullPath%\Software\CHANGE ALIAS.exe" "%New_FullPath%\"
call "%InstallScriptsPath%\AutoSTBConnSetup.exe" "%New_FullPath%\Software\STBConnSetup.exe"

echo ^@echo off>"%New_FullPath%\Configuration\unicfg.bat"
echo REG IMPORT "%%~dp0%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%~dp0%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"

PUSHD "%New_FullPath%\Configuration" & START . & POPD
ECHO ==================================================================
ECHO End of Update previous Client(%Old_Client%) to New Client(%New_Client%)
ECHO ==================================================================
GOTO END

:NEW
ECHO ==================================================================
ECHO Copy Configuration folder under previous client to new client
ECHO Copy CHANGE ALIAS.exe and ChangeAlias.exe to new client
ECHO ==================================================================
if "%cfg%"=="" GOTO ERROR
if "%reg%"=="" GOTO ERROR
if "%Toolset%"=="" GOTO ERROR

call "%InstallScriptsPath%\createDB.bat" "%New_Client%_DATA" "%testset%"
call "%InstallScriptsPath%\createDB.bat" "%New_Client%_SYSTEM" "%testset%"
MD "%New_FullPath%\Admin" && MD "%New_FullPath%\Configuration" && MD "%New_FullPath%\Software" && MD "%New_FullPath%\System" && MD "%New_FullPath%\OUTPUT"
IF NOT EXIST %windir%\system32\robocopy.exe ( copy \\sha-sql2005-c\QA\Applications\robocopy.exe %windir%\system32\robocopy.exe /Y 1>nul)

robocopy.exe "%~dp0\Configuration" "%New_FullPath%\Configuration" "%cfg%" "%reg%" "CHANGE ALIAS.exe" 1>nul
call "%InstallScriptsPath%\MdRegwithClient.bat" "%New_FullPath%\Configuration\%reg%" "%New_Client%"

REG IMPORT "%New_FullPath%\Configuration\%reg%" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%New_FullPath%\Configuration\%cfg%" /f 1>nul
call "%InstallScriptsPath%\AutoChangeAlias.exe" "%New_FullPath%\Configuration\CHANGE ALIAS.exe" "%New_FullPath%\"

echo ^@echo off>"%New_FullPath%\Configuration\unicfg.bat"
echo REG IMPORT "%%~dp0%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%~dp0%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%~dp0CHANGE ALIAS.exe">>"%New_FullPath%\Configuration\unicfg.bat"


IF NOT EXIST "C:\Temp"  MD C:\Temp
IF NOT EXIST "C:\STBTEMP"  MD C:\STBTEMP
call "%InstallScriptsPath%\AutoInstalV4.exe" "%Toolset%"
echo "installing toolset..."
call "%InstallScriptsPath%\MLink.vbs" "%New_FullPath%"
PUSHD "%New_FullPath%\Configuration" & START . & POPD

ECHO ==================================================================
ECHO End of Create New Client,please manual install next steps
ECHO ==================================================================
GOTO END

:Help
ECHO.
ECHO ___________________________________________________________________
ECHO 			HELP DOCUMENT					   
ECHO	Usage :: %~nx0 Test-Set
ECHO	Test-Set :: Test-Set exists in configuration, which is contained in [].
ECHO ___________________________________________________________________
ECHO.
GOTO END

:ERROR1
ECHO.
ECHO Error:configuration file "%~dp0%~n0.ini" doesn't exist. please find configuration file.
GOTO END

:ERROR
ECHO.
ECHO You might be encounter one of these errors.
ECHO   When updating product, Old Client Folder "%Old_Path%\%New_Client%" doesn't exist!
ECHO   When installing new product, New Client Folder "%New_Path%\%New_Client%" exists!
ECHO   Miss Arguments or type wrong, check configuration file...
ECHO use "/?" to see HELP DOCUMENT...
ECHO.
GOTO END

:END





