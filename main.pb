;directories, paths and prefixes
Global LogPrefix$         =   ""
Global LogDir$            =   ""
Global LogFileName$       =   ""
Global BaseDir$           =   GetCurrentDirectory()
Global ExeDirectory$      =   BaseDir$ + "tools"

;packaged executables
Global WINDDEXE64$        =   "win64dd.exe"
Global PSLOGLISTEXE$      =   "psloglist.exe"
Global PSLOGGEDONEXE64$   =   "PsLoggedon64.exe"
Global PSLISTEXE64$       =   "pslist64.exe"
Global PSFILEEXE64$       =   "psfile64.exe"
Global OPENPORTSEXE$      =   "openports.exe"
Global PCLIPEXE$          =   "pclip.exe"


;system commands
Global ROUTE$             =   "route"
Global ARP$               =   "arp"
Global IPCONFIG$          =   "ipconfig"
Global NETSTAT$           =   "netstat"
Global NET$               =   "net"
Global REG$               =   "reg"
Global CMD$               =   "cmd"



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Getting project prefix
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure GetPrefix()
  If OpenConsole()
    Print("[+] Enter Project-Prefix and press return: ")
    LogPrefix$ = Input()
    PrintN("")
    PrintN("[+] OK, " + LogPrefix$ + " set as project prefix")
  EndIf
EndProcedure

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Write To the log file
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure LogMessages(Message.s)
  
  LogFileName$ = LogPrefix$ + "_" + FormatDate("%yyyy%mm%dd", Date())
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
  Parameters$ = "/r /a /f " + LogDir$ + LogPrefix$ + "_" + TimeStamp$ + ".dd"
  
  SetCurrentDirectory(ExeDirectory$)
  Output$ = "[+] Running memdump " + Chr(13) + Chr(13)
  MemDump = RunProgram(WINDDEXE64$, Parameters$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  
  If MemDump
    While ProgramRunning(MemDump)
      If AvailableProgramOutput(MemDump)
        Output$ + ReadProgramString(MemDump) + Chr(13)
      EndIf
    keybd_event_(#VK_RETURN,0,0,0) ; Simulate Keypress
    keybd_event_(#VK_RETURN,0,#KEYEVENTF_KEYUP,0) ; Simulate release key
    Delay(60) 
    Wend
  
    Output$ + Chr(13) + Chr(13)
    
    KillProgram(MemDump)
    CloseProgram(MemDump) ; Close the connection to the program
    
  EndIf
  SetCurrentDirectory(BaseDir$)
  LogMessages(Output$)  
  
EndProcedure

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Getting Basic Network Info
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure NetBasic()
  SetCurrentDirectory(ExeDirectory$)
  TimeStamp$ = FormatDate("%yyyy%mm%dd%hh%mm%ss", Date())
  
  ParametersRoute$ = "PRINT"
  ParametersArp$ = "-a"
  ParametersIpconfig$ = "/all"
  ParametersOpenports$ = "-netstat"
  ParametersNetstat$ = "-ab"
  
  
  
  Output$ = "[+] Getting Basic Network Info " + Chr(13)
  
  Route = RunProgram(ROUTE$, ParametersRoute$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Getting routes: " + Chr(13) + Chr(13)
  If Route
    While ProgramRunning(Route)
      If AvailableProgramOutput(Route)
        Output$ + ReadProgramString(Route) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Route) ; Close the connection to the program
  
  
  
  Arp = RunProgram(ARP$, ParametersArp$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Getting arp: " + Chr(13) + Chr(13)
  If Arp
   While ProgramRunning(Arp)
     If AvailableProgramOutput(Arp)
       Output$ + ReadProgramString(Arp) + Chr(13)
     EndIf
   Wend
   Output$ + Chr(13) + Chr(13)
  EndIf
  
  CloseProgram(Arp) ; Close the connection to the program
  
  
  
  Ipconfig = RunProgram(IPCONFIG$, ParametersIpconfig$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Getting interface config: " + Chr(13) + Chr(13)  
  If Ipconfig
   While ProgramRunning(Ipconfig)
     If AvailableProgramOutput(Ipconfig)
       Output$ + ReadProgramString(Ipconfig) + Chr(13)
     EndIf
   Wend
   Output$ + Chr(13) + Chr(13)
  EndIf
  
  CloseProgram(Ipconfig) ; Close the connection to the program
  
  
  OpenportsPath$ = GetCurrentDirectory() + OPENPORTSEXE$
  Openports = RunProgram(OpenportsPath$, ParametersOpenports$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Getting open ports: " + Chr(13) + Chr(13)  
  If Openports
   While ProgramRunning(Openports)
     If AvailableProgramOutput(Openports)
       Output$ + ReadProgramString(Openports) + Chr(13)
     EndIf
   Wend
   Output$ + Chr(13) + Chr(13)
  EndIf
  
  CloseProgram(Openports) ; Close the connection to the program  
  
  
  
  Netstat = RunProgram(NETSTAT$, ParametersNetstat$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Getting connections and their processes: " + Chr(13) + Chr(13)
  If Netstat
   While ProgramRunning(Netstat)
     If AvailableProgramOutput(Netstat)
       Output$ + ReadProgramString(Netstat) + Chr(13)
     EndIf
   Wend
   Output$ + Chr(13) + Chr(13)
  EndIf
  
  CloseProgram(Netstat) ; Close the connection to the program
   
  LogMessages(Output$)  
  
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Getting Basic Process and User Info
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure ProcessUserBasic()
  
  SetCurrentDirectory(ExeDirectory$)
  TimeStamp$ = FormatDate("%yyyy%mm%dd%hh%mm%ss", Date())
  
  ParametersPslist$ = "-nobanner"
  ParametersPsloggedon$ = "-nobanner"

  Output$ = "[+] Getting Basic Process and User Info " + Chr(13)
  
  Pslist = RunProgram(PSLISTEXE64$, ParametersPslist$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Listing Processes: " + Chr(13) + Chr(13)
  If Pslist
    While ProgramRunning(Pslist)
      If AvailableProgramOutput(Pslist)
        Output$ + ReadProgramString(Pslist) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Pslist) ; Close the connection to the program
  
 Psloggedon = RunProgram(PSLOGGEDONEXE64$, ParametersPsloggedon$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
 Output$ + "[+] Listing logged on users: " + Chr(13) + Chr(13)
 If Psloggedon
   While ProgramRunning(Psloggedon)
     If AvailableProgramOutput(Psloggedon)
       Output$ + ReadProgramString(Psloggedon) + Chr(13)
     EndIf
   Wend
   Output$ + Chr(13) + Chr(13)
 EndIf
    
  CloseProgram(Psloggedon) ; Close the connection to the program  
  
  
  LogMessages(Output$)  
  
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Getting open remote files, network shares and last 10 SYSTEM/SECURITY logs
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure RemoteFilesSharesLogs()
  
  SetCurrentDirectory(ExeDirectory$)
  TimeStamp$ = FormatDate("%yyyy%mm%dd%hh%mm%ss", Date())
  
  ParametersPsfile$ = "-nobanner"
  ParametersNet$ = "share"
  ParametersPsloglist_1$ = "/accepteula -n 10 SYSTEM"
  ParametersPsloglist_2$ = "-n 10 SECURITY"


  Output$ = "[+] Getting open remote files, network shares and last 10 SYSTEM/SECURITY logs " + Chr(13)
  
  Psfile = RunProgram(PSFILEEXE64$, ParametersPsfile$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Listing remotely opened files: " + Chr(13) + Chr(13)
  If Psfile
    While ProgramRunning(Psfile)
      If AvailableProgramOutput(Psfile)
        Output$ + ReadProgramString(Psfile) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Psfile) ; Close the connection to the program
  
  
  Net = RunProgram(NET$, ParametersNet$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Listing network shares: " + Chr(13) + Chr(13)
  If Net
    While ProgramRunning(Net)
      If AvailableProgramOutput(Net)
        Output$ + ReadProgramString(Net) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Net) ; Close the connection to the program
  
  
  ;first run
  Psloglist = RunProgram(PSLOGLISTEXE$, ParametersPsloglist_1$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide | #PB_Program_Error)
  Output$ + "[+] Getting SYSTEM logs: " + Chr(13) + Chr(13)
  
  If Psloglist
    While ProgramRunning(Psloglist)
      Error$ = ReadProgramError(Psloglist) ;because program disclaimer is returned as sterror
      If AvailableProgramOutput(Psloglist)
        Output$ + ReadProgramString(Psloglist) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Psloglist) ; Close the connection to the program
  
  
  ;second run
  Psloglist = RunProgram(PSLOGLISTEXE$, ParametersPsloglist_2$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide | #PB_Program_Error)
  Output$ + "[+] Getting SECURITY Logs: " + Chr(13) + Chr(13)
  
  If Psloglist
    While ProgramRunning(Psloglist)
      Error$ = ReadProgramError(Psloglist) ;because program disclaimer is returned as sterror      
      If AvailableProgramOutput(Psloglist)
        Output$ + ReadProgramString(Psloglist) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Psloglist) ; Close the connection to the program
  
  
  LogMessages(Output$)  
  
EndProcedure


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Getting mounts, environment variables and clipboard content
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Procedure MountEnvironmentClipboard()
  
  SetCurrentDirectory(ExeDirectory$)
  TimeStamp$ = FormatDate("%yyyy%mm%dd%hh%mm%ss", Date())
  
  ParametersReg$ = "QUERY HKLM\SYSTEM\MountedDevices" ; getting mounts from registry
  ParametersCmd$ = "/c set"
  ParametersPclip$ = ""


  Output$ = "[+] Getting mounts, environment variables and clipboard content " + Chr(13)
  
  Reg = RunProgram(REG$, ParametersReg$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Mountpoints and devices: " + Chr(13) + Chr(13)
  If Reg
    While ProgramRunning(Reg)
      If AvailableProgramOutput(Reg)
        Output$ + ReadProgramString(Reg) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Reg) ; Close the connection to the program
  
  
  Cmd = RunProgram(CMD$, ParametersCmd$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
  Output$ + "[+] Environment Variables: " + Chr(13) + Chr(13)
  If Cmd
    While ProgramRunning(Cmd)
      If AvailableProgramOutput(Cmd)
        Output$ + ReadProgramString(Cmd) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Cmd) ; Close the connection to the program
  
  Pclip = RunProgram(PCLIPEXE$, ParametersPclip$, "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide | #PB_Program_Error)
  Output$ + "[+] Clipboard Content: " + Chr(13) + Chr(13)
  If Pclip
    While ProgramRunning(Pclip)
      Error$ = ReadProgramError(Pclip) ;because an error is returned if clipboard uninitialized and empty
      Output$ + Error$
      If AvailableProgramOutput(Pclip)
        Output$ + ReadProgramString(Pclip) + Chr(13)
      EndIf
    Wend
    Output$ + Chr(13) + Chr(13)
  EndIf
    
  CloseProgram(Pclip) ; Close the connection to the program
  
  
  
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
NetBasic()
ProcessUserBasic()
RemoteFilesSharesLogs()
MountEnvironmentClipboard()


ElapsedTime = ElapsedMilliseconds()-StartTime 

PrintN ("[+] Run completed in: " + Str(ElapsedTime/1000) + " seconds")
PrintN ("")
LogMessages("[+] Run completed in: " + Str(ElapsedTime/1000) + " seconds")
PrintN ("[+] Done, see ya!")
Delay(10000)
CloseConsole()
; IDE Options = PureBasic 5.51 (Windows - x64)
; CursorPosition = 363
; FirstLine = 193
; Folding = i-
; EnableXP