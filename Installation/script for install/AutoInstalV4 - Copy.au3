dim $exepath
If $CmdLine[0]<>1 Then
   MsgBox(0,"Install ToolV4 Error","Need an argument:fullpath of toolset v4 for execution.")
Else
 $exepath=$CmdLine[1]
 If FileExists($exepath) Then
;run($exepath)
ShellExecute($exepath)
Local $i=100
while $i>=0
Sleep ( 1000 )
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
$i=$i-1
WEnd

If WinWaitActive("Warning","&Next >",30)<>0 then
	ControlClick("Warning","&Next >","[CLASS:Button; INSTANCE:1]")
EndIf
If WinWaitActive("Installation Mode Selection","&Next >",60*2)<>0 Then
	ControlClick("Installation Mode Selection","&Next >","[CLASS:Button; INSTANCE:1]")
EndIf

If	WinWaitActive("Confirm Software Folder","&Next >",60*1)<>0 Then
	ControlClick("Confirm Software Folder","&Next >","[CLASS:Button; INSTANCE:1]")
EndIf
;~ sleep 5 minutes
Sleep(1000*60*5)
$i=60
while $i>=0

	If WinWaitActive("Metadata database connection setup","TabSheet1",5)<>0 then
		ControlClick("Metadata database connection setup","TabSheet1","[CLASS:TButton; INSTANCE:2]")
		If	WinWaitActive("Metadata database connection setup","TabSheet2",5)<>0 Then
			ControlSend("Metadata database connection setup","TabSheet2","[CLASS:TEdit; INSTANCE:1]","password")
			ControlClick("Metadata database connection setup","TabSheet2","[CLASS:TButton; INSTANCE:3]")

		EndIf
	EndIf

	If WinWaitActive("Information","Setup successful",5)<>0 Then
		ControlClick("Information","Setup successful","[CLASS:Button; INSTANCE:1]")
	EndIf
	If WinWaitActive("Installation Completed","has been successfully installed",5)<>0 Then
		ControlClick("Installation Completed","has been successfully installed","[CLASS:Button; INSTANCE:1]")
		ExitLoop
	EndIf
$i=$i-1
WEnd

Else
   MsgBox(0,"Install ToolV4 Error","invalid argument,Fullpath of toolset "&$exepath&" doesn't exist.")
EndIf

EndIf
