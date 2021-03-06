#singleinstance force

; Test function - Ctrl+Shift+Alt+T
;^!+t::
;Return

; ---------------------------------------------------------
; Configuration
; ---------------------------------------------------------
SetTitleMatchMode RegEx
DetectHiddenWindows, On
SetDefaultMouseSpeed, 0
AHKExe := A_Temp . "\AutoHotKey.exe"
FileInstall, AutoHotKey.exe, % AHKExe, 1
CalcEnabled := FileExist(AHKexe)

; ---------------------------------------------------------
; UI setup
; ---------------------------------------------------------
; Splash screen
splash_w := 400
splash_x := A_ScreenWidth - splash_w - 25
splash_y := A_ScreenHeight - 100
Gui, Splash:Font, s14
Gui, Splash:Add, Text, x0 y10 w%splash_w% center, CIS shortcuts enabled. Ctrl+? for help.
Gui, Splash:-Caption +alwaysontop +Toolwindow +Border
Gui, Splash:Show, x%splash_x% y%splash_y% w%splash_w% NoActivate,
SetTimer, HideSplash, -2500

; Notification window
notify_w := 200
notify_x := A_ScreenWidth - notify_w - 25
notify_y := A_ScreenHeight - 100
Gui, Notify:Font, s12
Gui, Notify:Add, Text, x0 y10 w%notify_w% center, Message
Gui, Notify:-Caption +alwaysontop +Toolwindow +Border

; Calculator window -  combobox to type in and OK button (activated by enter)
CalcFunctions =
( LTRIM
mivf: weight in kg - maintenance IVF rate
w: weight - convert lbs / kg
t: temp - convert C / F
f: drug - open formulary
u: search - search uptodate
path: name - open pathway
Up/Down arrows - see previous calculations
)
CalcHistory := []
CalcY := 100
CalcWidth := 350
Gui, Calc:Font, s7
Gui, Calc:Add, Text, X5 Y5 W%CalcWidth%, %CalcFunctions%
Gui, Calc:Font, s12
Gui, Calc:Add, ComboBox, X-2 Y%CalcY% W%CalcWidth% vCalcExpr
Gui, Calc:Add, Button, Default, OK
Gui, Calc:-Caption +Border
ShowCalculator() {
  global CalcY, CalcWidth
  CalcWinH := CalcY + 24
  CalcWinWidth := CalcWidth - 23
  Gui, Calc:Show, H%CalcWinH% W%CalcWinWidth%
}

; ---------------------------------------------------------
; Install script
; ---------------------------------------------------------
; Create hidden directory and install images
if (not FileExist("img")) {
  FileCreateDir, img
  FileSetAttrib, +H, img
}
FileInstall, Disconnect.exe, Disconnect.exe, 1
FileInstall, img\add.png, img\add.png, 1
FileInstall, img\add2.png, img\add2.png, 1
FileInstall, img\add3.png, img\add3.png, 1
FileInstall, img\arrowright.png, img\arrowright.png, 1
FileInstall, img\check.png, img\check.png, 1
FileInstall, img\checked.PNG, img\checked.PNG, 1
FileInstall, img\clipboard.png, img\clipboard.png, 1
FileInstall, img\close.png, img\close.png, 1
FileInstall, img\cores.png, img\cores.png, 1
FileInstall, img\coresactiveissues.png, img\coresactiveissues.png, 1
FileInstall, img\coresexit.png, img\coresexit.png, 1
FileInstall, img\coresexit2.png, img\coresexit2.png, 1
FileInstall, img\coresnotes.png, img\coresnotes.png, 1
FileInstall, img\coresplan.png, img\coresplan.png, 1
FileInstall, img\coressave.png, img\coressave.png, 1
FileInstall, img\coressave2.png, img\coressave2.png, 1
FileInstall, img\discharge.png, img\discharge.png, 1
FileInstall, img\dropdown.png, img\dropdown.png, 1
FileInstall, img\edboard.png, img\edboard.png, 1
FileInstall, img\exit.png, img\exit.png, 1
FileInstall, img\exit2.png, img\exit2.png, 1
FileInstall, img\firstneticon.png, img\firstneticon.png, 1
FileInstall, img\flowsheetdropdown.png, img\flowsheetdropdown.png, 1
FileInstall, img\graph.png, img\graph.png, 1
FileInstall, img\hilitedrow.png, img\hilitedrow.png, 1
FileInstall, img\labs.png, img\labs.png, 1
FileInstall, img\meddose.png, img\meddose.png, 1
FileInstall, img\medfreq.png, img\medfreq.png, 1
FileInstall, img\medinstructions.png, img\medinstructions.png, 1
FileInstall, img\mednonesig.png, img\mednonesig.png, 1
FileInstall, img\medprn.png, img\medprn.png, 1
FileInstall, img\medprnother.png, img\medprnother.png, 1
FileInstall, img\medprnreason.png, img\medprnreason.png, 1
FileInstall, img\medroute.png, img\medroute.png, 1
FileInstall, img\medstart.png, img\medstart.png, 1
FileInstall, img\medunit.png, img\medunit.png, 1
FileInstall, img\modify.png, img\modify.png, 1
FileInstall, img\navigator.png, img\navigator.png, 1
FileInstall, img\networkdrive.png, img\networkdrive.png, 1
FileInstall, img\orca.png, img\orca.png, 1
FileInstall, img\orcaptlist.png, img\orcaptlist.png, 1
FileInstall, img\ordersactive.png, img\ordersactive.png, 1
FileInstall, img\ordersall.png, img\ordersall.png, 1
FileInstall, img\ordersallsel.png, img\ordersallsel.png, 1
FileInstall, img\ordersforsig.png, img\ordersforsig.png, 1
FileInstall, img\ordersorders.png, img\ordersorders.png, 1
FileInstall, img\ordersselected.png, img\ordersselected.png, 1
FileInstall, img\primaryres.png, img\primaryres.png, 1
FileInstall, img\provideroverview.png, img\provideroverview.png, 1
FileInstall, img\ptactionsmenu.png, img\ptactionsmenu.png, 1
FileInstall, img\ptdocuments.png, img\ptdocuments.png, 1
FileInstall, img\ptflowsheets.png, img\ptflowsheets.png, 1
FileInstall, img\ptiview.png, img\ptiview.png, 1
FileInstall, img\ptmarsummary.png, img\ptmarsummary.png, 1
FileInstall, img\ptmenu.png, img\ptmenu.png, 1
FileInstall, img\ptnotes2.png, img\ptnotes2.png, 1
FileInstall, img\ptorders.png, img\ptorders.png, 1
FileInstall, img\ptsummary.png, img\ptsummary.png, 1
FileInstall, img\refresh.png, img\refresh.png, 1
FileInstall, img\seen.png, img\seen.png, 1
FileInstall, img\unchecked.png, img\unchecked.png, 1
FileInstall, img\vitalsigns.png, img\vitalsigns.png, 1
FileInstall, img\winclose.png, img\winclose.png, 1
FileInstall, img\zoomin.png, img\zoomin.png, 1
FileInstall, img\zoomout.png, img\zoomout.png, 1
; Files for calculator installed in implementation below

; ---------------------------------------------------------
; Helpers
; ---------------------------------------------------------
Sonar()
{
  DllCall("SystemParametersInfo", UInt, 0x101D, UInt, 0, UInt, 1, UInt, 0) ;SPI_SETMOUSESONAR ON
	Send {LCtrl} ;Invoke MouseSonar
  DllCall("SystemParametersInfo", UInt, 0x101D, UInt, 0, UInt, 0, UInt, 0) ;SPI_SETMOUSESONAR OFF
}
Shake()
{
  MouseGetPos X, Y
  MouseMove, % X+50, % Y+4, 0
  MouseMove, % X-50, % Y-3, 1
  MouseMove, % X+25, % Y-3, 1
  MouseMove, % X-25, % Y+3, 1
  MouseMove, % X+13, % Y+3, 2
  MouseMove, % X-6, % Y+2, 2
  MouseMove, %X%, %Y%
}
Notify(msg, sec:=3) {
  if (msg = "") {
    Gui, Notify:Show, Hide
  } else {
    Gui, Notify:Show, x%msg_x% y%msg_y% w%msg_w% NoActivate,
  }
}
Log(event) {
  FormatTime, T, , yyyy-MM-dd HH:mm:ss
  FileAppend, %T% %A_UserName% %event%`n, %A_Temp%\ahklog.txt
}
Join(arr, sep:=",") {
  ret := ""
  if (arr.MaxIndex() > 0) {
    for i, el in arr {
      if (i > 1) {
        ret := ret . sep
      }
      ret := ret . el
    }
  }
  return ret
}
ImagePath(image, options:="*20") {
  if (SubStr(image, 1, 1) <> "*") {
    return options . " " . A_ScriptDir . "\img\" . image
  } else {
    return image
  }
}
ImageExists(image, minX:=0, minY:=0, maxX:=0, maxY:=0) {
  WinGetActiveStats, _, W, H, _, _
  image := ImagePath(image)
  maxX := (maxX = 0) ? W : maxX
  maxY := (maxY = 0) ? H : maxY
  ImageSearch, X, Y, %minX%, %minY%, %maxX%, %maxY%, %image%
  return (ErrorLevel = 0) ? [X, Y] : false
}
ImageSearchAll(ByRef Arr, image, max:=0, minX:=0, minY:=0, maxX:=0, maxY:=0, orientation:="Vertical") {
  WinGetActiveStats, _, W, H, _, _
  image := ImagePath(image)
  maxX := (maxX = 0) ? W : maxX
  maxY := (maxY = 0) ? H : maxY
  lastX := minX
  lastY := minY
  Arr := []
  Loop {
    ImageSearch, X, Y, %lastX%, %lastY%, %maxX%, %maxY%, %image%
    if (ErrorLevel > 0) {
      break
    }

    Arr.Push([X, Y])
    if (max > 0 and Arr.MaxIndex() >= max) {
      break
    }

    if (SubStr(orientation, 1, 1) = "H") {
      lastX := X+2
    } else {
      lastY := Y+2
    }
  }
  return (Arr.length() > 0)
}
ImageClick(image, minX:=0, minY:=0, maxX:=0, maxY:=0, offsetX:=0, offsetY:=0, n:=1) {
  ImageWait(image, 0.5, minX, minY, maxX, maxY)
  ImageSearchAll(images, image, n, minX, minY, maxX, maxY)
  if (images.MaxIndex() >= n) {
    MouseClick, , % images[n][1] + offsetX, % images[n][2] + offsetY
    return images[n]
  }
  return false
}
ImageClickCached(image, minX:=0, minY:=0, maxX:=0, maxY:=0) {
  static imagePosCache := {}
  static firstNetImagePosCache := {}
  cache := imagePosCache
  if (ImageExists("firstneticon.png", 0, 0, 30, 30)) {
    cache := firstNetImagePosCache
  }
  coord := cache[image]
  coord := coord ? coord : ImageWait(image, 0.5, minX, minY, maxX, maxY)
  cache[image] := coord
  
  if (coord) {
    MouseClick, , % coord[1], % coord[2]
    return coord
  }
  return false
}
ImageWaitWhileIdle(image, sec:=5, minX:=0, minY:=0, maxX:=0, maxY:=0) {
  return ImageWait(image, sec, minX, minY, maxX, maxY, true)
}
ImageWait(image, sec:=5, minX:=0, minY:=0, maxX:=0, maxY:=0, onlyWhileIdle:=false) {
  ; search whole screen, not window, since active window can change while waiting
  image := (SubStr(image, 1, 1) <> "*") ? ImagePath(image) : image
  maxX := (maxX = 0) ? A_ScreenWidth : maxX
  maxY := (maxY = 0) ? A_ScreenHeight : maxY

  ; Look for an image for a maximum number of seconds.
  ; Abort if there is user activity when onlyWhileIdle is set.
  maxMs := sec * 1000
  start := A_TickCount
  Loop {
    ImageSearch, X, Y, %minX%, %minY%, %maxX%, %maxY%, %image%
    if (ErrorLevel = 0) {
      return [X, Y]
    }
    Sleep, 100
    if ((A_TickCount - start > maxMs) or (onlyWhileIdle and A_TimeIdle < 100)) {
      return false
    }
  }
}
WinWaitActive(title, sec:=5) {
  WinWaitActive, %title%, , %sec%
  return (ErrorLevel = 0)
}
WinWaitAndActivate(title, sec:="") {
  WinWait, %title%, , %sec%
  if (ErrorLevel = 0) {
    WinActivate, %title%
    WinWaitActive, %title%, , 2
    Sleep, 250
  }
  return (ErrorLevel = 0)
}
CursorNotBusyWait(sec:=5) {   ; Not compatible with citrix: A_Cursor = "Unknown"
  maxMs := sec * 1000
  start := A_TickCount
  Loop {
    if ((A_Cursor <> "Wait") and (A_Cursor <> "AppStarting")) {
      return true
    }
    if (A_TickCount - start > maxMs) {
      return false
    }
    Sleep, 300
  }
}
CopyAllText() {
  Clipboard := ""
  Sleep, 50
  SendInput, ^a
  Sleep, 300
  SendInput, ^c
  ClipWait, 0.5
  return Clipboard
}
SetClipboard(s) {
  Clipboard := ""
  Sleep, 50
  Clipboard := s
  ClipWait, 0.5
}

; -----------------------------------------------------------------------------
; Main tasks
; -----------------------------------------------------------------------------
isORCA() {
  return ImageExists("orca.png", 0, 0, 150, 100)
}

ShowNotes() {
  ; Notes via menu
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 260
    MouseMove, %X%, %Y%
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    if (ImageClickCached("ptnotes2.png", 70, 0, 400, 600)) {
      MouseMove, 250, 360
    } else {
      Shake()
    }
  }  
}
ShowDocuments() {
  ; Documents via menu
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 245
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    if (ImageClickCached("ptdocuments.png", 70, 0, 400, 600)) {
      MouseMove, 240, 290
    } else {
      Shake()
    }
  }
}
ShowOrders() {
  ; Orders via menu
  MouseGetPos X, Y
  if (ImageExists("ordersselected.png")) {
    ; If already on orders screen, toggle between orders for signature and orders
    if (not ImageClick(ImagePath("ordersforsig.png", "*0"))) {
      ImageClick("ordersorders.png")
    }
  } else {
    if (isORCA()) {
      MouseClick, , 190, 40
      MouseClick, , 190, 415
    } else {
      ImageClickCached("ptmenu.png", 0, 0, 500, 70)
      if (not ImageClickCached("ptorders.png", 70, 0, 400, 600)) {
        Shake()
      }
    }
  }
  MouseMove, %X%, %Y%
}
ShowVitals() {
  ; Flowsheets via menu > Provider Overview tab > Vitals Signs in left sided Navigator
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 790
    MouseMove, %X%, %Y%
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    ImageClickCached("ptflowsheets.png", 70, 0, 400, 600)
    MouseMove, %X%, %Y%
      MouseGetPos X, Y
    if (ImageWaitWhileIdle("flowsheetdropdown.png", , 100, 100, 400, 400)) {
      ImageClick("provideroverview.png", , , 1000, 350)
      MouseMove, %X%, %Y%
    }
  }
}
ShowLabs() {
  ; Flowsheets via menu > Labs tab
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 855
    MouseMove, %X%, %Y%
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    ImageClickCached("ptflowsheets.png", 70, 0, 400, 600)
    MouseMove, %X%, %Y%
    if (ImageWaitWhileIdle("flowsheetdropdown.png", , 100, 100, 400, 400)) {
      MouseGetPos X, Y
      ImageClickCached("labs.png", , , 1000, 350)
      MouseMove, %X%, %Y%
    }
  }
}
ShowIView() {
  ; IView and I&O
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 525
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    if (not ImageClickCached("ptiview.png", 70, 0, 400, 600)) {
      Shake()
    }
  }
  MouseMove, %X%, %Y%
}
ShowMAR() {
  ; MAR Summary via menu
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 460
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    if (not ImageClickCached("ptmarsummary.png", 70, 0, 400, 600)) {
      Shake()
    }
  }
  MouseMove, %X%, %Y%
}
ShowPatientSummary() {
  ; Patient Summary via menu
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 85
  } else {
    ImageClickCached("ptmenu.png", 0, 0, 500, 70)
    if (not ImageClickCached("ptsummary.png", 70, 0, 400, 600)) {
      Shake()
    }
  }
  MouseMove, %X%, %Y%
}
ShowPatientList() {
  ; Patient List via menu
  MouseGetPos X, Y
  ImageClick("orcaptlist.png")
  Sleep, 200
  ImageClick("hilitedrow.png", , , 30, , 40) 
  MouseMove, %X%, %Y%
}
ShowEDBoard() {
  ; Enhanced Tracking via menu
  if (WinActive("FirstNet") or (WinActive("Opened by") and ImageExists("firstneticon.png"))) {
    MouseGetPos X, Y
    ImageClick("edboard.png")
    MouseMove, %X%, %Y%
  }
}
ShowCores() {
  ; CORES via menu
  MouseGetPos X, Y
  ImageClick("cores.png")
  MouseMove, %X%, %Y%
}
ShowDischarge() {
  ; Discharge via Patient Actions menu
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 615
  } else {
    ImageClick("ptactionsmenu.png")
    if (ImageWaitWhileIdle("discharge.png")) {
      MouseGetPos X, Y
      ImageClick("discharge.png")
    }
  }
  MouseMove, %X%, %Y%
}

; -----------------------------------------------------------------------------
; Common secondary tasks - Ctrl+Shift+letter
; -----------------------------------------------------------------------------
CloseChart() {
  MouseGetPos X, Y
  if (WinActive("Flowsheet") or WinActive("Document Viewer")) {
    ; Close flowsheet via exit button
    if (not ImageClick(ImagePath("exit.png", "*100"))) {
      ImageClick("exit2.png")
    }
  } else if (WinActive("CORES")) {
    ; Close CORES via Save & Exit button
    if (not ImageClick("coresexit.png")) {
      ImageClick("coresexit2.png")
    }
  } else {
    ; Try to close any active form by clicking a check mark
    if (not ImageClick("check.png")) {
      ; Otherwise, close chart via x button
      ImageClick(ImagePath("close.png", "*100"))
    }
  }
  MouseMove, %X%, %Y%
}
Refresh() {
  MouseGetPos X, Y
  ImageClick("refresh.png")
  MouseMove, %X%, %Y%
}

; -----------------------------------------------------------------------------
; Less common secondary tasks - activate by Ctrl+K followed by another letter
; -----------------------------------------------------------------------------
OpenNextClipboard() {
  ; Next clipboard (click 2nd clipboard icon - first one is column header)
  if (not ImageClick("clipboard.png", , , , , , , 2)) {
    Shake()
  }
}
MarkClipboardRead() {
  ; Mark clipboard as read & refresh
  seen := ImageClick("seen.png")
  if (not ImageClick(ImagePath("exit.png", "*100"))) {
    ImageClick("exit2.png")
  }
  
  ; If seen icon not clicked, don't click refresh
  if (not seen) {
    return
  }

  ; Wait for results popup to disappear and main window to reactivate
  WinWaitActive("PowerChart|FirstNet")
  Sleep, 100
  ImageClick("refresh.png")
}
MarkAllClipboardsRead() {
  ; Mark all clipboards as read & refresh
  ImageClick("refresh.png")
  Sleep, 500
  
  ; Find all clipboard icons and click one at a time. Skip first one, which is column header
  ImageSearchAll(icons, "clipboard.png")

  icons.RemoveAt(1)
  for i, icon in icons {
    ; click next clipboard
    MouseClick, , % icon[1], % icon[2]

    ; Wait 600ms for possible abort - press any key to abort 
    Input, key, I L1 T0.6
    if (key <> "") {
      Shake()
      Return
    }

    ; Click "Primary resident" if there is a popup
    if (ImageClick("primaryres.png")) {
      Click 2
      Sleep, 300
    }
    
    ; Wait for flowsheet to appear - look for seen button
    if (not WinWaitActive("Flowsheet", 20)) {
      Shake()
      Return
    }
    
    ; Wait another 250ms for possible abort before pressing seen icon
    Input, key, I L1 T0.25
    if (key <> "") {
      Shake()
      Return
    }

    ; Click seen & exit buttons
    ImageClick("seen.png")
    if (not ImageClick(ImagePath("exit.png", "*100"))) {
      ImageClick("exit2.png")
    }

    if (not WinWaitActive("PowerChart|FirstNet")) {
      Shake()
      Return
    }
  }

  ImageClick("refresh.png")
}
CheckAllCheckboxes(check:=true) {
  Sleep 100
  
  img := "unchecked.png"
  if (check = false) {
    img := "checked.png"
  }

  ; select all unchecked boxes on screen
  ImageSearchAll(checkboxes, img, , 250)
  for i, checkbox in checkboxes {
    MouseClick, , % checkbox[1], % checkbox[2]
    if (A_TimeIdlePhysical < 100) {
      break
    }
  }
}
ToggleAllOrders() {
  ; If all orders shown, then select active orders & vice versa
  image := "ordersactive.png"
  if (not ImageExists("ordersall.png", , , , 320) and not ImageExists("ordersallsel.png", , , , 320)) {
    image := "ordersall.png"
  }
  
  ; Click dropdown, wait for menu to show, then select All Orders
  ImageClick("dropdown.png")
  Sleep, 500
  if (not ImageClick(image)) {
    Shake()
  }
}
ClickAdd() {
  ; Add button on Orders and Notes tabs
  if (ImageClick("add.png")) {
    return
  } else if (ImageClick("add2.png")) {
    return
  } else if (ImageClick("add3.png")) {
    return
  } else if (ImageSearchAll(images, "arrowright.png", 1)) {
    MouseClick, , 360, 40
    MouseClick, , 360, 235
  } else {
    Shake()
  }
}
ClickModify() {
  ; Modify button
  if (not ImageClick("modify.png")) {
    Shake()
  }
}
ClickGraph() {
  ; Graph button
  if (not ImageClick("graph.png")) {
    Shake()
  }
}
SaveCORES() {
  MouseGetPos X, Y
  if (not ImageClick("coressave.png") and not ImageClick("coressave2.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}
EditCORESinNotepad() {
  s := ""
  Clipboard := ""
  
  if (ImageClick("coresactiveissues.png", , , 200, , 10, 45) or ImageClick("coresplan.png", , , 200, , 10, 45)) {
    s := CopyAllText()
  }
  
  WinActivate, % "Notepad\+\+"
  if (WinWaitActive("Notepad\+\+", 0.5)) {
    SendInput, ^n
  } else {
    try {
      Run, C:\Windows\Notepad.exe
    } catch e {
      TrayTip, , Could not start Notepad
    }
    if (not WinWaitActive("Notepad", 2)) {
      Shake()
    }
  }
  Sleep, 100

  SetClipboard(s)
  SendInput, ^a
  Sleep, 200
  SendInput, ^v
  SendInput, ^{home}
  Sonar()
}
SaveNotepadToCORES() {
  s := CopyAllText()

  Clipboard := ""
  Sleep, 50
  
  WinActivate, CORES
  if (WinWaitActive("CORES", 2) and (ImageClick("coresactiveissues.png", , , 200, , 10, 45) or ImageClick("coresplan.png", , , 200, , 10, 45))) {
    Clipboard := s
    SendInput, ^a
    Sleep, 300
    ClipWait, 0.5
    SendInput, ^v
  } else {
    Shake()
  }
}
QuickSig() {

  err := "Warning: this feature is experimental`n`n"
  done := false
  Loop {
    InputBox, sig, Quick Med Sig, % err . "Sig to use (e.g. 140mg PO Q4h PRN pain):", , , 160
    if (sig = "") {
      return
    } else if (RegExMatch(sig, "i)([0-9.]+)\s*([a-zA-Z]+)\s+([a-zA-Z /-]+?)\s+(.+?)(?:\s+(prn ?)(.*))?$", m)) {
      dose := m1, unit := m2, route := m3, freq := m4, prn := m5, inst := m6
      break
    } else {
      err := "Unrecognized med sig: " . sig . "`n`n"
    }
  }

  if (ImageClick("meddose.png")) {
    Sleep, 100
    SendPlay, % dose
  }
    

  Sleep, 100
  if (ImageClick("medunit.png")) {
    Sleep, 300
    SendPlay, % unit
  }
  
  Sleep, 100
  if (ImageClick("medroute.png")) {
    Sleep, 300
    if (route = "PO" or route = "NG") {
      SendPlay, PO or
    } else if (route = "ND") {
      SendPlay, by ND
    } else if (route = "GT") {
      SendPlay, by G-{up}
    } else {
      SendPlay, % route
    }
  }
  
  Sleep, 100
  if (ImageClick("medfreq.png")) {
    Sleep, 300
    if (freq = "QD") {
      SendPlay, once a day     
    } else if (freq = "BID") {
      SendPlay, 2 times a day{up}
    } else if (freq = "TID") {
      SendPlay, 3 times a day
    } else if (freq = "qwk" or freq = "qweek") {
      SendPlay, every week
    } else if (freq = "qTuF" or freq = "qMTh") {
      SendPlay, % "2 times a week (" . substr(freq, 2)
    } else if (RegExmatch(freq, "i)q\s*([0-9]+)\s*(h|m)", freq)) {
      SendPlay, % "q " . freq1 . " " . freq2
    } else if (RegExmatch(freq, "i)q([0-9a-zA-Z]+)", freq)) {
      SendPlay, % "q " . freq1
    } else {
      SendPlay, % freq
    }
  }
  
  if (prn != "") {
    Sleep, 100
    if (ImageClick("medprn.png")) {
      Sleep, 300
      SendPlay, y
    }
    Sleep, 100
    if (ImageClick("medprnreason.png")) {
      Sleep, 300
      if (inst != "") {
        SendPlay, other
        Sleep, 100
        if (ImageClick("medinstructions.png")) {
          Sleep, 300
          SendPlay, % inst
        }
      } else {
        ; select first reason
        SendPlay, {PgUp}
      }
    }
  }

  Sleep, 100
  ImageClick("medstart.png")
  
  Sonar()
  return
}

; -----------------------------------------------------------------------------
; Shortcut keys
; -----------------------------------------------------------------------------
HandleHelpKey(key) {
  global CalcEnabled

    ; Handle a key press from the help screen
  if (key = "") {
    Return
  } else if (key = "s" and not WinActive("CORES")) {
    ShowPatientSummary()
  } else if (key = "n") {
    ShowNotes()
  } else if (key = "o") {
    ShowOrders()
  } else if (key = "v") {
    ShowVitals()
  } else if (key = "l") {
    ShowLabs()
  } else if (key = "u") {
    ShowDocuments()
  } else if (key = "i") {
    ShowIView()
  } else if (key = "m") {
    ShowMAR()
  } else if (key = "p") {
    ShowPatientList()
  } else if (key = "e" and not WinActive("Notepad") and not WinActive("CORE")) {
    ShowEDBoard()
  } else if (key = "c") {
    ShowCores()
  } else if (key = "w") {
    CloseChart()
  } else if (key = "r" and not WinActive("Flowsheet")) {
    Refresh()
  } else if ((key = "#" or key = "3") and CalcEnabled) {
    ShowCalculator()
  } else {
    HandleSecondaryKey(key)
  }
}
HandleSecondaryKey(key) {
  ; Handle a key press after Ctrl+K
  if (key = "") {
    return
  } else if (key = "a") {
    ToggleAllOrders() 
  } else if (key = "d") {
    ClickAdd()
  } else if (key = "q") {
    QuickSig()
  } else if (key = "m") {
    ClickModify()
  } else if (key = "g") {
    ClickGraph()
  } else if (key = "n" or key = "x") {
    OpenNextClipboard()
  } else if (key = "r") {
    MarkClipboardRead()
  } else if (key = "!" or key = "1") {
    MarkAllClipboardsRead()
  } else if (key = "*") {
    CheckAllCheckboxes()
  } else if (key = "8") {
    CheckAllCheckboxes(false)
  } else if (key = "s" and WinActive("CORES")) {
    SaveCORES()
  } else if (key = "e" and WinActive("CORES")) {
    EditCORESinNotepad()
  } else if (key = "e" and WinActive("Notepad")) {
    SaveNotepadToCORES()
  } else if (key = " ") {
    Click
  } else {
    Shake()   ; unrecognized
  }
}

; CIS / FirstNet shortcuts - only trigger when active window's title matches 
#If (WinActive("PowerChart") or WinActive("FirstNet") or WinActive("Opened by") or WinActive("CORES") or WinActive("Flowsheet") or WinActive("Document Viewer") or WinActive("Diagnosis List") or WinActive("Medication Reconciliation") or WinActive("Summary of Visit") or WinActive("ED Callback"))

; Main tasks
^n::ShowNotes()
^u::ShowDocuments()
^o::ShowOrders()
^+v::ShowVitals()
^l::ShowLabs()
^i::ShowIView()
^m::ShowMAR()
^p::ShowPatientList()
^e::ShowEDBoard()
^+c::ShowCores()
^d::ShowDischarge()
^+s::ShowPatientSummary()

; Common secondary tasks - Ctrl+Shift+letter
^+w::CloseChart()
^w::CloseChart()
^+r::Refresh()
^r::Refresh()

; Less common secondary tasks - activate by Ctrl+K followed by another letter
^k::
^!+k::
  Input, key, I L1 T4, {Escape}{LControl}{RControl}{LAlt}{RAlt}{Enter}{Backspace}{Tab}
  if (ErrorLevel = "Timeout") {
    Shake()
    Return
  }

  HandleSecondaryKey(key)
Return

; Shortcuts for CORES only
#if (WinActive("CORES"))
^s::SaveCORES()    

; --------------------------------------------------------------------------------
; Global shortcut keys (not restricted to certain active windows)
; --------------------------------------------------------------------------------
#If

; Logout
^Backspace::
  Run, disconnect.exe
Return

; Help screen
^?::
^/::
  ; Window size and location
  h := 338
  w := 500
  titleh := 40
  col2x := w/2 - 10
  x := (A_ScreenWidth - w - 2)
  y := (A_ScreenHeight - h - 45)

  ; Build window text
  Gui, Font, s11
  Gui, Add, Text, x0 y10 w%w% h%titleh% center, Type a letter to trigger the associated action:
  Gui, Font, s9

  Gui, Font, w700
  Gui, Add, Text, Section x10 y%titleh%, Common Actions
  Gui, Font, w100
  Gui, Add, Text, xs, R - Refresh  (or Ctrl + R)
  Gui, Add, Text, xs, W - Close Chart  (or Ctrl + W)

  Gui, Font, w700
  Gui, Add, Text, xs, Patient Screens
  Gui, Font, w100
  Gui, Add, Text, xs, C - CORES  (or Ctrl+Shift + C)
  Gui, Add, Text, xs, P - Patient List  (or Ctrl + P)
  Gui, Add, Text, xs, S - Patient Summary  (or Ctrl+Shift + S)
  Gui, Add, Text, xs, O - Orders  (or Ctrl + O)
  Gui, Add, Text, xs, V - Vitals  (or Ctrl+Shift + V)
  Gui, Add, Text, xs, L - Labs  (or Ctrl + L)
  Gui, Add, Text, xs, U - Documents  (or Ctrl + U)
  Gui, Add, Text, xs, N - Notes  (or Ctrl + N)
  Gui, Add, Text, xs, I - I/Os  (or Ctrl + I)
  Gui, Add, Text, xs, M - MAR Summary  (or Ctrl + M)
  Gui, Add, Text, xs, E - ED Board (FirstNet) (or Ctrl + E)

  Gui, Font, w700
  Gui, Add, Text, Section x%col2x% y%titleh%, Orders
  Gui, Font, w100
  Gui, Add, Text, xs, D - Add Order or Note  (or Ctrl+K then D)
  Gui, Add, Text, xs, A - Toggle All / Active Orders  (or Ctrl+K then A)

  Gui, Font, w700
  Gui, Add, Text, xs, Clipboards
  Gui, Font, w100
  Gui, Add, Text, xs, ! - Clear all clipboards  (or Ctrl+K then !)
  Gui, Add, Text, xs, X - Next clipboard  (use Ctrl+K then X)
  Gui, Add, Text, xs, R - Mark flowsheet read  (or Ctrl+K then R)

  Gui, Font, w700
  Gui, Add, Text, xs, CORES
  Gui, Font, w100
  Gui, Add, Text, xs, % WinActive("Notepad") ? "E - Copy document to CORES" : "E - Edit plan in Notepad"
  Gui, Add, Text, xs, S - Save  (or Ctrl+S)
  Gui, Add, Text, xs, W - Save && Exit  (or Ctrl+W)

  Gui, Font, w700
  Gui, Add, Text, xs, Other
  Gui, Font, w100
  Gui, Add, Text, xs, Ctrl + ? - This help screen
  Gui, Add, Text, xs, Ctrl + Backspace - Logout
  if (CalcEnabled) {
    Gui, Add, Text, xs, # - Calculator (or Ctrl+Shift + 3)
    h := h + 20
    y := y - 20
  }

  ; Show window. Keep up until key pressed or for 3s, regardlness of user activity (e.g. moving mouse).
  Gui, -Caption +AlwaysOntop +Toolwindow +Border
  Gui, Show, x%x% y%y% h%h% w%w% NoActivate, CIS Shortcut Key
  Input, key, I L1 T3, {Escape}{Space}{LControl}{RControl}{LAlt}{RAlt}{Enter}{Backspace}{Tab}

  ; As long as user is inactive, leave help screen up
  While ((key = "") and (A_TimeIdle > 1000)) {
    Input, key, I L1 T0.1, {Escape}{Space}{LControl}{RControl}{LAlt}{RAlt}{Enter}{Backspace}{Tab}
  }
  Gui, Destroy

  ; Allow for shortcuts to be launched directly from the help screen
  HandleHelpKey(key)
Return

; ---------------------------------------------------
; Calculator
; ---------------------------------------------------
; Enable calculator GUI only if AutoHotKey.exe is available
#If CalcEnabled
^!+3::
^+3::
  ; show, but cut off combobox dropdown & ok button
  ShowCalculator()
Return
CalcGuiEscape:
  Gui, Calc:Show, Hide
Return
CalcButtonOK:
  FileInstall, AutoHotKey.exe, % AHKExe, 1
  FileInstall, CalcFuns.ahk, %A_Temp%\CalcFuns.ahk, 1

  ; get text from ComboBox named CalcExpr into a variable named CalcExpr
  GuiControlGet CalcExpr, , CalcExpr                  

  ; Keep up to 20 items of history, and set combo box list contents
  CalcHistory.push(CalcExpr)
  if (CalcHistory.Length() > 20) {
    CalcHistory.RemoveAt(0)
  }

  ; Convert fn: param1, param2 to fn("param1", "param2")
  if (RegExMatch(CalcExpr, "^[a-zA-Z_]+\s*:")) {
  	CalcExpr := RegExReplace(CalcExpr, "^([a-zA-Z_]+)\s*:\s*", "$1(""", "", 1)
  	CalcExpr := RegExReplace(CalcExpr, "\s*,\s*", """,""")
    CalcExpr := CalcExpr . """)"
  }

  GuiControl, , CalcExpr, % "|" . Join(CalcHistory,"|")
  
  ; Convert ; to newlines
  StringReplace CalcExpr, CalcExpr, `;, `n, All
  StringGetPos Last, CalcExpr, `n, R1
  StringLeft Pre, CalcExpr, Last
  StringTrimLeft CalcExpr, CalcExpr, Last+1

  ; run AHK to execute temp script, evaluate expression
  calcFile = %A_Temp%\docalc.ahk
  resFile = %A_Temp%\docalc.res
  FileDelete %calcFile%
  FileAppend #NoTrayIcon`n#Include %A_Temp%\CalcFuns.ahk`nFileDelete %resFile%`n%pre%`nFileAppend `% (%CalcExpr%)`, %resFile%`n, %calcFile%
  
  try {
    RunWait %AHKExe% %calcFile%

    ; get result and show
    FileRead Result, %resFile%
    GuiControl, Text, CalcExpr, %Result%
  } catch e {
  }
Return
#If

; ---------------------------------------------------
; Event handlers
; ---------------------------------------------------
HideSplash:
  Gui, Splash:Destroy
Return
