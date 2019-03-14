dim $exepath
If $CmdLine[0]<>1 Then
   MsgBox(0,"Install Product Error","Need an argument:fullpath of product for execution.")
Else 
 $exepath=$CmdLine[1]
 If FileExists($exepath) Then 
;run($exepath)
ShellExecute($exepath)
WinWait("Product Setup","&Next >")
ControlClick("Product Setup","&Next >","[CLASS:Button; INSTANCE:1]")

WinWait("Confirm Software Folder","&Next >")
ControlClick("Confirm Software Folder","&Next >","[CLASS:Button; INSTANCE:1]")

;WinWaitActive("","Backup File Destination Directory")
;ControlClick("","N&o","[CLASS:Button; INSTANCE:5]")
;
;send("!o")
;WinWaitActive("","Backup File Destination Directory")
;send("!N")
;WinWaitActive("","Are you sure you want to install")
;send("!N")
;
WinWait("Backup","N&o")
ControlClick("Backup","N&o","[CLASS:Button; INSTANCE:5]")
ControlClick("Backup","N&o","[CLASS:Button; INSTANCE:1]")
WinWait("Comfirm Backup","&Next >")
ControlClick("Comfirm Backup","&Next >","[CLASS:Button; INSTANCE:1]")
Sleep(100000) ;100 seconds
Run("ClickWarningBox.exe")
Sleep(40000) ;40 seconds
WinWait("Upgrade Complete","Press OK to continue")
ControlClick("Upgrade Complete","Press OK to continue","[CLASS:Button; INSTANCE:1]")

Else
   MsgBox(0,"Install Product Error","invalid argument,Fullpath of product "&$exepath&" doesn't exist.")
EndIf

EndIf
