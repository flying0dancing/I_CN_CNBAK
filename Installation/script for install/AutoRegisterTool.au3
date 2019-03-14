dim $exepath,$STBDATA,$RegisterFile
If $CmdLine[0]<>2 Then
   MsgBox(0,"Register ToolV4 Error","Need TWO arguments for Execution.Client's Path,Full Path of Register File")
Else
   $exepath=$CmdLine[1]
   $STBDATA="\Software\STBDATA.EXE"
   $RegisterFile=$CmdLine[2]
   if FileExists($RegisterFile) Then
	  If FileExists($exepath&$STBDATA)  Then
		 ;run($exepath)
		 ShellExecute($exepath&$STBDATA)
		 ;sleep(60000)
		 If WinWaitActive("Confirm","OK",80) Then
		 ;If WinExists("Confirm","OK") Then	
			;WinWaitActive("Confirm","OK")
			ControlClick("Confirm","OK","[CLASS:TButton; INSTANCE:2]")
			WinWaitActive("Select a licence to install on this system","&Browse...")
			send($RegisterFile)
			ControlClick("Select a licence to install on this system","&Ok","[CLASS:TButton; INSTANCE:3]")
			WinWaitActive("Confirm","OK")
			ControlClick("Confirm","OK","[CLASS:TButton; INSTANCE:2]")
			WinWaitActive("STB Systems","Cancel")
			ControlClick("STB Systems","Cancel","[CLASS:TButton; INSTANCE:1]")
		 ElseIf WinWaitActive("STB Systems","Cancel",80) Then		
			;MsgBox(0,"ddd","winaa")
			;WinWaitActive("STB Systems","Cancel")
			ControlClick("STB Systems","Cancel","[CLASS:TButton; INSTANCE:1]")
		 EndIf
	  Else
		 MsgBox(0,"Register ToolV4 Error","Fullpath of "&$exepath&$STBDATA&" doesn't exist.")
	  EndIf
   Else
      MsgBox(0,"Register ToolV4 Error","Fullpath of License "&$RegisterFile&" doesn't exist.")
   EndIf
EndIf

