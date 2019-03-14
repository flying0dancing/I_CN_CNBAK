While WinExists("Transmit Forms","Transmit Options") ;And $i<=300
   WinWait("Variable Data Item Values","OK",10) ;timeout 10 seconds
   ControlSetText("Variable Data Item Values","OK","[CLASS:TInplaceEdit; INSTANCE:1]","Pass123ssaP")
   ControlClick("Variable Data Item Values","OK","[CLASS:TButton; INSTANCE:2]")
   Sleep(10000) ;10 seconds
   
WEnd