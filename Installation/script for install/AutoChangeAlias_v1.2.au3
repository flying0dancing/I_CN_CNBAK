#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;MsgBox(0,"hai","hello world!")
dim $exepath
If $CmdLine[0]>2 or $CmdLine[0]<1 Then
   MsgBox(0,"Change Alias Error","at least need one argument for Execution.Order:fullpath of Change Alias.exe[,Replace Path]")
Else
 $exepath=$CmdLine[1]
 If FileExists($exepath) Then 
  ; run($exepath)
  ShellExecute($exepath)
   WinWaitActive("Alias Search and Replace","OK")
   If $CmdLine[$CmdLine[0]]<>$exepath Then
   dim $New_FullPath
   $New_FullPath=$CmdLine[2]
   ControlSetText("Alias Search and Replace","OK","[CLASS:TEdit; INSTANCE:1]",$New_FullPath)
   EndIf
   ControlClick("Alias Search and Replace","OK","[CLASS:TBitBtn; INSTANCE:2]")
   WinWaitActive("Confirm","OK")
   ControlClick("Confirm","OK","[CLASS:TButton; INSTANCE:2]")
   WinClose("Alias Search and Replace","OK")
  Else
   MsgBox(0,"Change Alias Error","invalid argument,fullpath of Change Alias.exe doesn't exist.")
  EndIf

EndIf

