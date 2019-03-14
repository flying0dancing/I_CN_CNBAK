dim $exepath
If $CmdLine[0]<>1 Then
   MsgBox(0,"Install ToolV4 Error","Need an argument:fullpath of toolset v4 for execution.")
Else
 $exepath=$CmdLine[1]
 If FileExists($exepath) Then
;run($exepath)
ShellExecute($exepath)
while(1)
Sleep ( 100 )
If	WinExists("STB-Tools","&Next >")=1 Then
	WinWaitActive("STB-Tools","&Next >")
	ControlClick("STB-Tools","&Next >","[CLASS:Button; INSTANCE:1]")
	ExitLoop
EndIf
If	WinExists("REPORTER","&Next >")=1 Then
	WinWaitActive("REPORTER","&Next >")
	ControlClick("REPORTER","&Next >","[CLASS:Button; INSTANCE:1]")
	ExitLoop
 EndIf
WEnd


WinWaitActive("Warning","&Next >")
ControlClick("Warning","&Next >","[CLASS:Button; INSTANCE:1]")
WinWaitActive("Installation Mode Selection","&Next >")
ControlClick("Installation Mode Selection","&Next >","[CLASS:Button; INSTANCE:1]")
WinWaitActive("Confirm Software Folder","&Next >")
ControlClick("Confirm Software Folder","&Next >","[CLASS:Button; INSTANCE:1]")

WinWaitActive("Metadata database connection setup","TabSheet1")
ControlClick("Metadata database connection setup","TabSheet1","[CLASS:TButton; INSTANCE:2]")

WinWaitActive("Metadata database connection setup","TabSheet2")
ControlSend("Metadata database connection setup","TabSheet2","[CLASS:TEdit; INSTANCE:1]","password")
ControlClick("Metadata database connection setup","TabSheet2","[CLASS:TButton; INSTANCE:3]")

WinWaitActive("Information","Setup successful")
ControlClick("Information","Setup successful","[CLASS:Button; INSTANCE:1]")

WinWaitActive("Installation Completed","STB-Tools has been successfully installed")
ControlClick("Installation Completed","STB-Tools has been successfully installed","[CLASS:Button; INSTANCE:1]")
Else
   MsgBox(0,"Install ToolV4 Error","invalid argument,Fullpath of toolset "&$exepath&" doesn't exist.")
EndIf

EndIf
