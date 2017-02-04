;directories, paths and prefixes
Global LogPrefix$         =   ""
Global LogDir$            =   ""
Global LogFileName$       =   ""
Global MemDumpOutput$     =   ""
Global BaseDir$           =   GetCurrentDirectory()
Global ExeDirectory$      =   BaseDir$ + "tools"

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Getting project prefix
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure GetPrefix()
  If OpenConsole()
    Print("[*] Enter Project-Prefix and press return: ")
    LogPrefix$ = Input()
    PrintN("")
    PrintN("[*] OK, " + LogPrefix$ + " set as project prefix")
    PrintN("")
  EndIf
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Write To the log file
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure LogMessages(Message.s)
  
  LogFileName$ = LogPrefix$ + "_" + FormatDate("%yyyy%mm%dd", Date()) + ".txt"
  LogDir$ = BaseDir$ + LogPrefix$ + "_log\"
  
  Log = OpenFile(#PB_Any, LogDir$ + LogFileName$)
  Seperator$ = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + Chr(13) + ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"  + Chr(13)
  
  If Log
    FileSeek(Log, Lof(Log))
    WriteStringN(Log, Seperator$)
    WriteStringN(Log, FormatDate(Chr(13) + "[+] %yyyy.%mm.%dd (%hh:%ii:%ss) ", Date()) + Chr(13) + Message.s)
    CloseFile(Log)
    ProcedureReturn 2
  Else
    CreateDirectory(LogDir$)
    CreateLog = CreateFile(#PB_Any, LogDir$ + LogFileName$)    
    CloseFile(CreateLog)
    ProcedureReturn 1
  EndIf 
  ProcedureReturn 0  
  
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Running memdump
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure MemDump()
  
  
  BaseDir$ = GetCurrentDirectory()
  TimeStamp$ = FormatDate("%yyyy%mm%dd", Date())
  RamCapture64$ = "RamCapture64.exe "
  Parameters$ = LogDir$ + LogPrefix$ + "_" + TimeStamp$ + ".dd"
  
  SetCurrentDirectory(ExeDirectory$ + "\ramcap")
  MemDumpOutput$ = "[+] Running memdump " + Chr(13) + Chr(13)
  Print(MemDumpOutput$)
  
  
  MemDump = RunProgram(RamCapture64$, Parameters$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  
  If MemDump
    While ProgramRunning(MemDump)
      Error$ = ReadProgramError(MemDump) ;catching possible errors
      If Error$
        MemDumpOutput$ = MemDumpOutput$ + Error$
      EndIf
      If AvailableProgramOutput(MemDump)
        MemDumpOutput$ + ReadProgramString(MemDump) + Chr(13)
      EndIf
    Wend
  
    MemDumpOutput$ + Chr(13) + Chr(13)
    CloseProgram(MemDump) ; Close the connection to the program
    
  EndIf

  SetCurrentDirectory(BaseDir$)
  
  LogMessages(MemDumpOutput$)  
  
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Running Program
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure RunProg(COMMAND.s, PARAMETER.s, MESSAGE.s)
  
  SetCurrentDirectory(ExeDirectory$)
  TimeStamp$ = FormatDate("%yyyy%mm%dd%hh%mm%ss", Date())
    
  Output$ = MESSAGE.s + Chr(13)
  PrintN(Output$ + Chr(13)) 
  
  prog = RunProgram(COMMAND.s, PARAMETER.s, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  
  If prog
    While ProgramRunning(prog)
      Error$ = ReadProgramError(prog) ;catching possible errors
      If Error$
        Output$ = Output$ + Error$
      EndIf
      If AvailableProgramOutput(prog)
        Output$ + ReadProgramString(prog) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(prog) ; Close the connection to the program  
  
  LogMessages(Output$)  
  
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Main Function
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


OpenConsole("HOT DATA SAVER")

StartTime = ElapsedMilliseconds() 
 
PrintN ("")
PrintN ("")
PrintN ("##########################################")
PrintN ("# Hot Data Saver    -     2017    flux*  #")
PrintN ("##########################################")
PrintN ("")
PrintN ("")

GetPrefix()
LogMessages("")
MemDump()

;init the map of commands
NewMap commands.s()
commands("com0") = "pslist64.exe"
commands("com1") = "route"
commands("com2") = "arp"
commands("com3") = "ipconfig"
commands("com4") = "openports.exe"
commands("com5") = "netstat"
commands("com6") = "pslist64.exe"
commands("com7") = "PsLoggedon64.exe"
commands("com8") = "psfile64.exe"
commands("com9") = "net"
commands("com9") = "psloglist.exe"
commands("com9") = "psloglist.exe" ;need to run it twice because we want SYSTEM and SECURITY logs
commands("com9") = "reg"
commands("com9") = "cmd"
commands("com9") = "pclip.exe"

;init the map of parameters
NewMap parameters.s()
parameters("par0") = "-nobanner -accepteula"
parameters("par1") = "PRINT"
parameters("par2") = "-a"
parameters("par3") = "/all"
parameters("par4") = "-netstat"
parameters("par5") = "-ab"
parameters("par6") = "-nobanner -accepteula"
parameters("par7") = "-nobanner -accepteula"
parameters("par8") = "-nobanner -accepteula"
parameters("par9") = "share"
parameters("par9") = "/accepteula -n 10 SYSTEM"
parameters("par9") = "-n 10 SECURITY"
parameters("par9") = "QUERY HKLM\SYSTEM\MountedDevices"
parameters("par9") = "/c set"
parameters("par9") = "" ;thats intended


;init the map of messages
NewMap messages.s()
messages("mes0") = "[+] Getting Basic Process and User Info "
messages("mes1") = "[+] Getting routes "
messages("mes2") = "[+] Getting arp "
messages("mes3") = "[+] Getting interface config "
messages("mes4") = "[+] Getting open ports "
messages("mes5") = "[+] Getting connections and their processes "
messages("mes6") = "[+] Getting Processes "
messages("mes7") = "[+] Getting logged on users "
messages("mes8") = "[+] Getting remotely opened files "
messages("mes9") = "[+] Getting network shares "
messages("mes9") = "[+] Getting SYSTEM logs "
messages("mes9") = "[+] Getting SECURITY Logs "
messages("mes9") = "[+] Getting Mountpoints and devices "
messages("mes9") = "[+] Getting Environment Variables "
messages("mes9") = "[+] Getting Clipboard Content "

;run program
For i = 0 To MapSize(commands())-1
  com.s = commands("com" + i) 
  par.s = parameters("par" + i)
  mes.s = messages("mes" + i)
  RunProg(com, par, mes)
Next


ElapsedTime = ElapsedMilliseconds()-StartTime 

PrintN ("")
PrintN ("[*] Run completed in: " + Str(ElapsedTime/1000) + " seconds")
PrintN ("")
LogMessages("[*] Run completed in: " + Str(ElapsedTime/1000) + " seconds")
PrintN ("[*] Done, see ya!")
Delay(10000)
CloseConsole()
; IDE Options = PureBasic 5.51 (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 198
; FirstLine = 154
; Folding = 0
; EnableXP
; EnableAdmin
; Executable = hds_v0.2.exe
; Compiler = PureBasic 5.51 (Windows - x64)