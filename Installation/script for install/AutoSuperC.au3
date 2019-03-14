
dim $exepath,$user,$password,$STBDATA,$STBFORM
If $CmdLine[0]>3 or $CmdLine[0]<2 Then
   MsgBox(0,"AutoSuperC Error","at least need TWO argument for Execution. Order:the Software path,user[,password]")
Else
$exepath=$CmdLine[1]
$STBDATA="STBDATA.EXE"
$STBFORM="STBFORMS.EXE"
If FileExists($exepath&$STBDATA) AND FileExists($exepath&$STBFORM) Then
;run($exepath)
  ShellExecute($exepath&$STBDATA)
$user=$CmdLine[2]
IF $CmdLine[$CmdLine[0]]<>$user Then
   $password=$CmdLine[3]
Else
   $password=""
EndIf
sleep(1000*7)
If	WinExists("[class:TfmSplashScreen]")<>0 Then

	If	WinActivate("[class:TfmSplashScreen]")<>0 Then
		ControlSend("[class:TfmSplashScreen]","OK","[CLASS:TEdit; INSTANCE:1]",$user)
		ControlSend("[class:TfmSplashScreen]","OK","[CLASS:TEdit; INSTANCE:2]",$password)
		ControlClick("[class:TfmSplashScreen]","OK","[CLASS:TButton; INSTANCE:2]")
		ShellExecute($exepath&$STBFORM)
	Else
		Exit
	EndIf

EndIf

Else
   MsgBox(0,"AutoSuperC Error","File "&$STBDATA &" or "&$STBFORM&"not found in "&chr(10)&$exepath)
EndIf
EndIf
