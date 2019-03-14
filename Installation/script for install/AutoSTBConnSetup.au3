
dim $exepath
;$exepath="I:\CN\CN_420\CN_4207_0823\Software\STBConnSetup.exe"
If $CmdLine[0]<>1 Then
   MsgBox(0,"AutoSTBConnSetup Error","need one argument: full path of STBConnSetup.exe")
Else
$exepath=$CmdLine[1]
If FileExists($exepath) Then
;run($exepath)
ShellExecute($exepath)
WinWaitActive("Metadata database connection setup","TabSheet1")
ControlClick("Metadata database connection setup","TabSheet1","[CLASS:TButton;INSTANCE:2]")
WinWaitActive("Metadata database connection setup","TabSheet2")
ControlCommand ( "Metadata database connection setup", "TabSheet2", "[CLASS:TComboBox; INSTANCE:2]", "SelectString", 'STB Work' )
ControlSetText("Metadata database connection setup", "TabSheet2","[CLASS:TEdit; INSTANCE:1]","password")
ControlClick("Metadata database connection setup","TabSheet2","[CLASS:TButton; INSTANCE:3]")
WinWaitActive("Information","Setup successful.")
controlclick("Information","Setup successful.","[CLASS:Button; INSTANCE:1]")

Else
   MsgBox(0,"AutoSTBConnSetup Error","File not found:"&chr(10)&$exepath)
EndIf
EndIf


