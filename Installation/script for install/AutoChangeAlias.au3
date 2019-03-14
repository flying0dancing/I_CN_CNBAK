#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;MsgBox(0,"hai","hello world!")
#requireadmin
dim $exepath
If $CmdLine[0]>2 or $CmdLine[0]<1 Then
   MsgBox(0,"Error Message","arguments: fullpath of 'CHANGE ALIAS.exe' [, fullpath of product for replace].")
Else
 $exepath=$CmdLine[1]
 If FileExists($exepath) Then 
  ; run($exepath)
  ShellExecute($exepath)
   WinWaitActive("Alias Search and Replace","OK")
   Local $TEdit1=ControlGetText("Alias Search and Replace","OK","[CLASS:TEdit; INSTANCE:1]")
   Local $TEdit2=ControlGetText("Alias Search and Replace","OK","[CLASS:TEdit; INSTANCE:2]")
   
	  If StringCompare($TEdit1,$TEdit2,0 )=0 Then
		 ControlClick("Alias Search and Replace","&Close","[CLASS:TBitBtn; INSTANCE:1]")
		 Exit
	  EndIf
	  If StringCompare($CmdLine[$CmdLine[0]],$exepath,0)=0 and $CmdLine[0]=2 Then
		 WinClose("Alias Search and Replace","OK")
		 MsgBox(0,"Error Message","invalid argument,[fullpath of product for replace] isn't Execute file, is an folder.")
		 Exit
	  EndIf
	  
	  If StringCompare($CmdLine[$CmdLine[0]],$exepath,0)<>0 Then
		 dim $New_FullPath
		 $New_FullPath=$CmdLine[2]
		 ControlSetText("Alias Search and Replace","OK","[CLASS:TEdit; INSTANCE:1]",$New_FullPath)
		 ControlClick("Alias Search and Replace","OK","[CLASS:TBitBtn; INSTANCE:2]")
		 WinWaitActive("Confirm","OK")
		 ControlClick("Confirm","OK","[CLASS:TButton; INSTANCE:2]")
		 WinClose("Alias Search and Replace","OK")
	  EndIf
   
  Else
   MsgBox(0,"Error Message","invalid argument,Execute file doesn't exist.")
   Exit
  EndIf

EndIf

