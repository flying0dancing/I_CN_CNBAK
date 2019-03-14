;Local $i=1
While WinExists("Installing","Cancel") ;And $i<=300
   WinWait("Warning:","The following table(s) you selected are metadata tables:",10) ;timeout 10 seconds
   ControlClick("Warning:","The following table(s) you selected are metadata tables:","[CLASS:TButton; INSTANCE:1]")
   Sleep(10000) ;10 seconds
   ;$i=$i+1
WEnd
;Func ClickWarning ()
;   Local $i=0
;   While $i<=120
;	  WinWait("Warning:","The following table(s) you selected are metadata tables:")
;	  ControlClick("Warning:","The following table(s) you selected are metadata tables:","[CLASS:TButton; INSTANCE:1]")
;	  Sleep(10000) ;1 min
;	  $i=$i+1
;   WEnd
;EndFunc