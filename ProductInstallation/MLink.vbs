dim arr(5),i,oArgs,fpath
arr(0)="STBDATA.EXE"
arr(1)="STBConnSetup.exe"
arr(2)="STBFORMS.EXE"
arr(3)="STBQUERY.EXE"
arr(4)="STBADMIN.EXE"
arr(5)="UTILITIES\InstalledProductVersion"
Set oArgs=WScript.Arguments
If oArgs.length=1 Then
'WScript.Echo oArgs(0)
fpath=oArgs(0)
Else
MsgBox ("Error")
End If
Set oArgs=nothing
For Each s In arr
assignlink s,fpath
Next

Sub assignlink(a,b)
Dim WshShell,oShellLink,filename,fso,source,direct
filename=a
set WshShell = WScript.CreateObject("WScript.Shell")
Set fso=WScript.CreateObject("Scripting.FileSystemObject")
'strDesktop = WshShell.SpecialFolders("Desktop")

source=b & "\Software\" & filename
direct=b & "\Configuration\"
If (fso.FileExists(source)) Then  
set oShellLink = WshShell.CreateShortcut(direct & filename & ".lnk")
End If
If (fso.FolderExists(source)) Then
set oShellLink = WshShell.CreateShortcut(direct & "InstalledProductVersion.lnk")
oShellLink.IconLocation = "%SystemRoot%\system32\SHELL32.dll,3"
End If
oShellLink.TargetPath = source
oShellLink.WindowStyle = 1
oShellLink.WorkingDirectory = direct
oShellLink.Arguments = source
oShellLink.Save
End Sub
