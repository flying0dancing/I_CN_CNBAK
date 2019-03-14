@echo off
if not "!PROCESSOR_ARCHITECTURE!"=="%PROCESSOR_ARCHITECTURE%" (
	cmd /V:ON /C %0 %*
    goto END
)

IF "%~1"=="" GOTO Help
IF "%~1"=="/?" GOTO Help

set testset=%~1
set cfg=%testset%.cfg
set reg=%testset%.reg
set InstallScriptsPath=%~dp0script for install
set "flag="
set "flag2="

for /f "tokens=1,2,* delims=_" %%a in ("%testset%") do (
  set sqltype=%%b
  if /I "!sqltype:~,3!"=="SQL" ( set sqlbat=SQL)
  if /I "!sqltype:~,4!"=="ORCL" ( set sqlbat=Oral)
)
if /I "%sqlbat%"=="" ( set sqlbat=SQL)

IF NOT EXIST "%~dpn0.ini" GOTO ERROR1
echo config file is : "%~dpn0.ini"
for /f "delims= usebackq" %%a in (`type "%~dpn0.ini"`) do (
  set v=%%a
  if "!v:~0,1!"=="[" ( 
    if /I %%a==[%testset%] (set flag=1) else (if defined flag2 (GOTO Start) else (set "flag="))
  ) else (
    if defined flag (
      for /f "eol=; tokens=1,2 delims==" %%i in ("%%a") do (
		set %%i=%%~j
		rem echo %%i=%%~j
		set flag2=1        
      )
    )
  )
)
if defined flag (
  if defined flag2 (GOTO Start) else (
   ECHO no arguments under test-set [%testset%] in %~n0.ini file.
   GOTO END
 )
) else (
   ECHO test-set [%testset%] doesn't exist in %~n0.ini file.
   GOTO END
)

:CUTSTR_LOOP
IF NOT "%str%"=="" (
    IF NOT "%str:~-1%"=="\" (
		SET "str=%str:~,-1%"
		GOTO CUTSTR_LOOP
	) 

) 
GOTO :EOF
:Start
IF "%New_FullPath:~-1%"=="\" (
	SET "New_FullPath=%New_FullPath:~,-1%"	
	) 
set str=%New_FullPath%
call :CUTSTR_LOOP
set New_Path=%str%
set New_Client=!New_FullPath:%str%=!



IF "%Old_FullPath:~-1%"=="\" (
	SET "Old_FullPath=%Old_FullPath:~,-1%"	
	) 
set str=%Old_FullPath%
call :CUTSTR_LOOP
set Old_Path=%str%
set Old_Client=!Old_FullPath:%str%=!

IF NOT EXIST "C:\Temp"  MD C:\Temp
IF NOT EXIST "C:\STBTEMP"  MD C:\STBTEMP

IF "%cfg%"=="" GOTO ERROR3
IF "%reg%"=="" GOTO ERROR3
IF /I "%Install_Mode%"=="N" ( 
		IF /I "%WOW64%"=="Y" ( 
			set searchpath=%~dp0\Configuration\reg_wow64\%reg%
		) else ( 
			set searchpath=%~dp0\Configuration\reg\%reg%
		)
 ) else (
		set searchpath=%Old_FullPath%\Configuration\%reg%
 )
findstr /i /r "sqlsrv32\.dll" "%searchpath%" >nul && set varALIASTYPE=SQL SERVER
findstr /i /r "sqlncli\.dll" "%searchpath%" >nul && set varALIASTYPE=SQL SERVER
findstr /i /r "sqlncli10\.dll" "%searchpath%" >nul && set varALIASTYPE=SQL Native Client 10.0
findstr /i /r "Driver.*\\10.*SQORA32\.dll" "%searchpath%" >nul && set varALIASTYPE=Oracle in OraClient10g_home1
findstr /i /r "Driver.*\\11.*SQORA32\.dll" "%searchpath%" >nul && set varALIASTYPE=Oracle in OraClient11g_home1
for /f "delims= usebackq" %%a in (`findstr /i /r "^.server" "%searchpath%"`) do (
  set vln=%%a
  if /I "!vln:~1,6!"=="server" ( 
      for /f "eol=; tokens=1,2 delims==" %%i in ("%%a") do (
		set DBServer=%%~j
		set DBServer=!DBServer:\\=\!  
      )
  )
)
IF /I "%~2"=="/cleanup" GOTO CleanEnvironment
IF "%Install_Mode%"=="" ( 
	GOTO ERROR2
) ELSE (
    IF /I "%Install_Mode%"=="N" (
	    IF EXIST "%New_FullPath%" GOTO ERROR
        IF NOT EXIST "%New_FullPath%" GOTO NEW
    )
	IF /I "%Install_Mode%"=="I" (
		IF "%Old_Path%"=="" GOTO HELP
	    IF "%Old_Client%"=="" GOTO HELP
		IF NOT EXIST "%Old_FullPath%" GOTO ERROR
		IF NOT EXIST "%Old_FullPath%\Configuration\%reg%" GOTO ERROR5
		IF NOT EXIST "%Old_FullPath%\Configuration\%cfg%" GOTO ERROR5
		GOTO INTEGRATION
    )
	IF /I "%Install_Mode%"=="U" (
	    IF "%Old_Path%"=="" GOTO HELP
	    IF "%Old_Client%"=="" GOTO HELP
		IF NOT EXIST "%Old_FullPath%" GOTO ERROR
        IF EXIST "%New_FullPath%" GOTO ERROR
		IF NOT EXIST "%Old_FullPath%\Configuration\%reg%" GOTO ERROR5
		IF NOT EXIST "%Old_FullPath%\Configuration\%cfg%" GOTO ERROR5
		GOTO UPDATE
		ECHO type wrong...
		GOTO END
		
    )
	GOTO ERROR2
)



:UPDATE
ECHO ==================================================================
ECHO Begin to copy all files and folders under previous Client(%Old_Client%) to New Client(%New_Client%)
ECHO at %date% %time%
ECHO ==================================================================
IF NOT EXIST "%windir%\system32\robocopy.exe" ( copy "%InstallScriptsPath%\robocopy.exe" "%windir%\system32\robocopy.exe" /Y 1>nul)
call "%InstallScriptsPath%\op%sqlbat%Database.bat" backup "%testset%" "%Old_Client%_DATA"
call "%InstallScriptsPath%\op%sqlbat%Database.bat" backup "%testset%" "%Old_Client%_SYSTEM"
call "%InstallScriptsPath%\op%sqlbat%Database.bat" restore "%testset%" "%Old_Client%_DATA" "%New_Client%_DATA"
call "%InstallScriptsPath%\op%sqlbat%Database.bat" restore "%testset%" "%Old_Client%_SYSTEM" "%New_Client%_SYSTEM"
robocopy.exe "%Old_FullPath%" "%New_FullPath%" /E /V /ETA 1>nul
rem robocopy.exe "%~dp0\Configuration" "%New_FullPath%\Software\UTILITIES\InstalledProductVersion" "0.0.0.1_InstalledProducts.INI" 1>nul
IF /I "%reg%"=="%testset%.reg" (
    ECHO.
) ELSE (
    rename "%New_FullPath%\Configuration\%reg%" "%testset%.reg"
    set reg=%testset%.reg
)
IF /I "%cfg%"=="%testset%.cfg" (
    ECHO.
) ELSE (
    rename "%New_FullPath%\Configuration\%cfg%" "%testset%.cfg"
    set cfg=%testset%.cfg
)
call "%InstallScriptsPath%\MLink.vbs" "%New_FullPath%"
"%InstallScriptsPath%\Perl\Perl.exe" "%InstallScriptsPath%\MdRegwithClient.bat" "%New_FullPath%\Configuration\%reg%" "%New_Client%"
REG IMPORT "%New_FullPath%\Configuration\%reg%" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%New_FullPath%\Configuration\%cfg%" /f 1>nul
call "%InstallScriptsPath%\AutoChangeAlias.exe" "%New_FullPath%\Software\CHANGE ALIAS.exe" "%New_FullPath%\"
call "%InstallScriptsPath%\AutoSTBConnSetup.exe" "%New_FullPath%\Software\STBConnSetup.exe"

    IF EXIST "%Toolset%" (
	call "%InstallScriptsPath%\AutoInstalV4.exe" "%Toolset%"
    )
    IF EXIST "%Product%" ( 
	    call "%InstallScriptsPath%\AutoProduct.exe" "%Product%"
	    call "%InstallScriptsPath%\op%sqlbat%Database.bat" setadmin "%testset%" "%New_Client%_SYSTEM"
    )
rem call "%New_FullPath%\Software\UTILITIES\InstalledProductVersion\STBInstalledProductVersion.exe" /productsfile="%New_FullPath%\Software\UTILITIES\InstalledProductVersion\0.0.0.1_InstalledProducts.INI" >%New_FullPath%\Software\UTILITIES\InstalledProductVersion\upgrade0.0.0.1.bat

ECHO ==================================================================
ECHO End of Update previous Client(%Old_Client%) to New Client(%New_Client%)
ECHO at %date% %time%
ECHO ==================================================================
GOTO CreateFile

:INTEGRATION
ECHO ==================================================================
ECHO Begin to install toolset or product under Client(%New_Client%)
ECHO at %date% %time%
ECHO ==================================================================
REG IMPORT "%Old_FullPath%\Configuration\%reg%" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%Old_FullPath%\Configuration\%cfg%" /f 1>nul
call "%InstallScriptsPath%\AutoChangeAlias.exe" "%Old_FullPath%\Software\CHANGE ALIAS.exe" "%Old_FullPath%\"
call "%InstallScriptsPath%\AutoSTBConnSetup.exe" "%Old_FullPath%\Software\STBConnSetup.exe"
IF EXIST "%Toolset%" (
	call "%InstallScriptsPath%\AutoInstalV4.exe" "%Toolset%"
    )
IF EXIST "%Product%" ( 
	call "%InstallScriptsPath%\AutoProduct.exe" "%Product%"
	call "%InstallScriptsPath%\op%sqlbat%Database.bat" setadmin "%testset%" "%Old_Client%_SYSTEM"
    )
ECHO ==================================================================
ECHO End of installation toolset or product under Client(%New_Client%)
ECHO at %date% %time%
ECHO ==================================================================
GOTO END
:NEW
ECHO ==================================================================
ECHO Begin to create new client(%New_Client%) at %date% %time%
rem ECHO Copy CHANGE ALIAS.exe to new client
ECHO ==================================================================

set cfg=%testset%.cfg
set reg=%testset%.reg
IF NOT EXIST "%~dp0Configuration\%cfg%" GOTO ERROR4
IF NOT EXIST "%~dp0Configuration\CHANGE ALIAS.exe" GOTO ERROR4

call "%InstallScriptsPath%\op%sqlbat%Database.bat" create "%testset%" "%New_Client%_DATA"
call "%InstallScriptsPath%\op%sqlbat%Database.bat" create "%testset%" "%New_Client%_SYSTEM"
IF NOT "!sqlreturnflag!"=="1" GOTO ERROR6

MD "%New_FullPath%\Admin" && MD "%New_FullPath%\Configuration" && MD "%New_FullPath%\Software" && MD "%New_FullPath%\System" && MD "%New_FullPath%\OUTPUT"
IF NOT EXIST "%windir%\system32\robocopy.exe" ( copy "%InstallScriptsPath%\robocopy.exe" "%windir%\system32\robocopy.exe" /Y 1>nul)

robocopy.exe "%~dp0\Configuration" "%New_FullPath%\Configuration" "%cfg%" "CHANGE ALIAS.exe" 1>nul
IF /I "%WOW64%"=="Y" ( 
	robocopy.exe "%~dp0\Configuration\reg_wow64" "%New_FullPath%\Configuration" "%reg%" 1>nul
) else ( 
	robocopy.exe "%~dp0\Configuration\reg" "%New_FullPath%\Configuration" "%reg%" 1>nul
)
"%InstallScriptsPath%\Perl\Perl.exe" "%InstallScriptsPath%\MdRegwithClient.bat" "%New_FullPath%\Configuration\%reg%" "%New_Client%"
ECHO REG IMPORT "%New_FullPath%\Configuration\%reg%"
REG IMPORT "%New_FullPath%\Configuration\%reg%" 1>nul
reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%New_FullPath%\Configuration\%cfg%" /f 1>nul
call "%InstallScriptsPath%\AutoChangeAlias.exe" "%New_FullPath%\Configuration\CHANGE ALIAS.exe" "%New_FullPath%\"


IF EXIST "%Toolset%" call "%InstallScriptsPath%\AutoInstalV4.exe" "%Toolset%"
call "%InstallScriptsPath%\MLink.vbs" "%New_FullPath%"
robocopy.exe "%~dp0\Configuration" "%New_FullPath%\Software\UTILITIES\InstalledProductVersion" "0.0.0.0_InstalledProducts.INI" "0.0.0.0_InstalledProducts.bat" 1>nul
call "%New_FullPath%\Software\UTILITIES\InstalledProductVersion\STBInstalledProductVersion.exe" /productsfile="%New_FullPath%\Software\UTILITIES\InstalledProductVersion\0.0.0.0_InstalledProducts.INI"
echo register toolset...
IF EXIST "%License%" call "%InstallScriptsPath%\AutoRegisterTool.exe" "%New_FullPath%" "%License%"

echo call "%InstallScriptsPath%\op%sqlbat%Database.bat" mdalias "%testset%" "%New_Client%_SYSTEM"
call "%InstallScriptsPath%\op%sqlbat%Database.bat" mdalias "%testset%" "%New_Client%_SYSTEM"
IF EXIST "%Product%" ( 
	echo call "%InstallScriptsPath%\AutoProduct.exe" "%Product%"
	call "%InstallScriptsPath%\AutoProduct.exe" "%Product%"
	echo call "%InstallScriptsPath%\op%sqlbat%Database.bat" setadmin "%testset%" "%New_Client%_SYSTEM"
	call "%InstallScriptsPath%\op%sqlbat%Database.bat" setadmin "%testset%" "%New_Client%_SYSTEM"
)


ECHO ==================================================================
ECHO End of create New Client(%New_Client%) at %date% %time%
ECHO ==================================================================
GOTO CreateFile

:CreateFile
echo ^@echo off>"%New_FullPath%\Configuration\unicfg.bat"
rem echo call "%%~dp0CHANGE ALIAS.exe">>"%New_FullPath%\Configuration\unicfg.bat"
rem new add
echo net use \\172.20.20.55\qa /u:test1 password>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _cfg_path=%%~dp0>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _pdt_path=%%_cfg_path:Configuration\=%%>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _sft_path=%%_cfg_path:Configuration=Software%%>>"%New_FullPath%\Configuration\unicfg.bat"
echo set _tls_path=\\172.20.20.55\qa\CN\scripts\common\script for install\>>"%New_FullPath%\Configuration\unicfg.bat"

rem echo REG IMPORT "%%~dp0%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
rem echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%~dp0%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo REG IMPORT "%%_cfg_path%%%reg%" 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"
echo reg add "HKLM\SOFTWARE\Borland\Database Engine" /v CONFIGFILE01 /t REG_SZ /d "%%_cfg_path%%%cfg%" /f 1^>nul>>"%New_FullPath%\Configuration\unicfg.bat"

echo CALL "%%_tls_path%%AutoChangeAlias.exe" "%%_sft_path%%CHANGE ALIAS.exe" "%%_pdt_path%%">>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%_tls_path%%AutoSTBConnSetup.exe" "%%_sft_path%%STBConnSetup.exe">>"%New_FullPath%\Configuration\unicfg.bat"
echo call "%%_tls_path%%AutoSuperC.exe" "%%_sft_path%%" ADMIN>>"%New_FullPath%\Configuration\unicfg.bat"
rem echo call "%%_sft_path%%STBDATA.exe" /username="admin" /password="">>"%New_FullPath%\Configuration\unicfg.bat"
echo exit /B ^0>>"%New_FullPath%\Configuration\unicfg.bat"
rem end new add

PUSHD "%New_FullPath%\Configuration" & START . & POPD
GOTO END

:CleanEnvironment
ECHO ==================================================================
ECHO Begin to clean environment and drop databases at %date% %time%
ECHO ==================================================================
echo cleanup environment %New_Client%
call "%InstallScriptsPath%\op%sqlbat%Database.bat" drop "%testset%" "%New_Client%_DATA"
call "%InstallScriptsPath%\op%sqlbat%Database.bat" drop "%testset%" "%New_Client%_SYSTEM"
echo RD /S /Q %New_FullPath%
RD /S /Q %New_FullPath% 1>nul
ECHO ==================================================================
ECHO End of clean environment and drop databases at %date% %time%
ECHO ==================================================================
GOTO END

:Help
ECHO.
ECHO ___________________________________________________________________
ECHO 			HELP DOCUMENT					   
ECHO	Usage :: %~nx0 Test-Set [/cleanup]
ECHO.
ECHO	Test-Set :: Test-Set exists in %~n0.ini, contained in [].
ECHO :: Test-Set List :
ECHO		CHINA_SQL
ECHO		HKMS_SQL
ECHO	cleanup :: Need set arg New_FullPath, delete New Client and related databases.
ECHO :: Argument in %~n0.ini :
ECHO		Toolset :: Full path of toolset. If Don't install it, set it NULL.
ECHO		License :: Full path of License for activating toolset.
ECHO		Product :: Full path of Product. If Don't install it, set it NULL.
ECHO		Old_FullPath :: Assign fullpath of old client to it if Install_Mode=N.
ECHO		New_FullPath :: Assign fullpath of new client to it.
ECHO				Make sure new client doesn't exists.
ECHO		Install_Mode :: N/U/I,
ECHO				N means new installation, U means upgrade/integration 
ECHO				to new client,I means integration in old client.
ECHO.
ECHO		[option argument]
ECHO		If Old Client's cfg and reg file are different from [Test-Set].cfg and 
ECHO		[Test-Set].reg, can using option argument, make sure Install_Mode=N.
ECHO		cfg :: assigned the xxx.cfg file in Configuration of Old_FullPath
ECHO		reg :: assigned the xxx.reg file in Configuration of Old_FullPath
ECHO ___________________________________________________________________
ECHO.
GOTO END

:ERROR1
ECHO.
ECHO Error1:configuration file "%~dpn0.ini" doesn't exist. please find configuration file.
GOTO END
:ERROR2
ECHO You might be encounter an error in configuration.
ECHO   Install_Mode=N or U or I
ECHO   Install_Mode=N means new install mode, 
ECHO   Install_Mode=U means upgrade/integration to new client,
ECHO   Install_Mode=I means integration in old client.
GOTO END
:ERROR3
ECHO You might be encounter one of these errors in configuration.
ECHO   cfg= means file name of .cfg file,reg= means file name of .reg file. 
ECHO   If use these option arguments, use "/?" to see HELP DOCUMENT...
GOTO END
:ERROR4
ECHO You might be encounter one of these errors.
ECHO   make sure %testset%.reg,%testset%.cfg,CHANGE ALIAS.exe are in %~dp0Configuration directory.
GOTO END
:ERROR5
ECHO You might be encounter one of these errors.
ECHO NOT EXIST %Old_FullPath%\Configuration\%reg% or %cfg%
ECHO If Install_Mode=I or U and not set option argument, default is %testset%.reg or %testset%.cfg
ECHO Recommend use "/?" for more instruction...
GOTO END
:ERROR6
ECHO You might be encounter one of these errors.
ECHO EXIST database:%New_Client%_DATA or %New_Client%_SYSTEM
ECHO Recommend use "/?" for more instruction...
GOTO END
:ERROR
ECHO.
ECHO You might be encounter one of these errors.
ECHO   When updating or Integrating product, Old Client Folder "%Old_FullPath%" doesn't exist!
ECHO   When installing new product, New Client Folder "%New_FullPath%" exists!
ECHO   Miss Arguments or type wrong, check configuration file...
ECHO use "/?" to see HELP DOCUMENT...
ECHO.
GOTO END

:END





