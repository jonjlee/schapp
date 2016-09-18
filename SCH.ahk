; Test function - Ctrl+Shift+Alt+T
;^!+t::
;Return

; ---------------------------------------------------------
; Configuration
; ---------------------------------------------------------
SetTitleMatchMode 2
AHKExe := (A_AHKPath <> "") ? A_AHKPath : "O:\AutoHotKey.exe"
CalcEnabled := FileExist(AHKexe)

; ---------------------------------------------------------
; UI setup
; ---------------------------------------------------------
; Splash screen
splash_w := 400
splash_x := A_ScreenWidth - splash_w - 25
splash_y := A_ScreenHeight - 100
Gui, Font, s14
Gui, Add, Text, x0 y10 w%splash_w% center, CIS shortcuts enabled. Ctrl+? for help.
Gui, -Caption +alwaysontop +Toolwindow +Border
Gui, Show, x%splash_x% y%splash_y% w%splash_w% NoActivate,
Sleep 100
Loop {
  If (A_TimeIdlePhysical < 100 or A_TimeIdlePhysical > 2500) {
    break
  }
}
Gui, Destroy

; Calculator window -  combobox to type in and OK button (activated by enter)
CalcFunctions =
( LTRIM
mivf(weight in kg) - maintenance IVF rate
kcal(mL in last 24h, kCal of formula, weight in kg) - kCal/kg/day
w(weight) - convert lbs / kg
t(temp) - convert C / F
Up/Down and Alt+Up/Down - previous calculations
)
CalcHistory := []
CalcY := 85
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
FileInstall, CalcFuns.ahk, %A_Temp%\CalcFuns.ahk, 1
FileInstall, img\add.png, img\add.png, 1
FileInstall, img\add2.png, img\add2.png, 1
FileInstall, img\refresh.png, img\refresh.png, 1
FileInstall, img\primaryres.png, img\primaryres.png, 1
FileInstall, img\vitalsigns.png, img\vitalsigns.png, 1
FileInstall, img\clipboard.png, img\clipboard.png, 1
FileInstall, img\exit.png, img\exit.png, 1
FileInstall, img\graph.png, img\graph.png, 1
FileInstall, img\seen.png, img\seen.png, 1
FileInstall, img\add.png, img\add.png, 1
FileInstall, img\dropdown.png, img\dropdown.png, 1
FileInstall, img\close.png, img\close.png, 1
FileInstall, img\ordersall.png, img\ordersall.png, 1
FileInstall, img\ordersactive.png, img\ordersactive.png, 1
FileInstall, img\checked.PNG, img\checked.PNG, 1
FileInstall, img\unchecked.png, img\unchecked.png, 1
FileInstall, img\coresexit.png, img\coresexit.png, 1
FileInstall, img\coressave.png, img\coressave.png, 1
FileInstall, img\check.png, img\check.png, 1
FileInstall, img\firstneticon.png, img\firstneticon.png, 1

; ---------------------------------------------------------
; Helpers
; ---------------------------------------------------------
Shake()
{
  MouseGetPos X, Y
  Loop, 2 {
    MouseMove, % X+7, % Y
    MouseMove, % X-7, % Y
  }
  MouseMove, %X%, %Y%
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
ImagePath(image) {
  return "*20 " . A_ScriptDir . "\img\" . image
}
ImageSearchAll(ByRef Arr, image, orientation:="Vertical", max:=0, minX:=0, minY:=0) {
  if (SubStr(image, 1, 1) <> "*") {
    image := ImagePath(image)
  }

  Arr := []
  lastX := minX
  lastY := minY
  Loop {
    ImageSearch, X, Y, %lastX%, %lastY%, %A_ScreenWidth%, %A_ScreenHeight%, %image%
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
ImageClick(image, n:=1, orientation:="Vertical", minX:=0, minY:=0) {
  ImageSearchAll(images, image, orientation, n, minX, minY)
  if (images.MaxIndex() >= n) {
    MouseClick, , % images[n][1], % images[n][2]
    return true   
  }
  return false
}
ImageWait(image, sec:=5) {
  if (SubStr(image, 1, 1) <> "*") {
    image := ImagePath(image)
  }

  n := sec * 1000 / 300
  Loop %n% {
    ImageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %image%
    if (ErrorLevel = 0) {
      return true
    }
    Sleep, 300
  }
  return false
}
WinWait(title, sec:=5) {
  n := sec * 1000 / 300
  Loop %n% {
    if (WinActive(title)) {
      return true
    }
    Sleep, 300
  }
  return false
}
CursorNotBusyWait(sec:=5) {
  n := sec * 1000 / 300
  Loop %n% {
    if ((A_Cursor <> "Wait") and (A_Cursor <> "AppStarting")) {
      return true
    }
    Sleep, 300
  }
  return false
}

; -----------------------------------------------------------------------------
; Main tasks
; -----------------------------------------------------------------------------
ShowNotes() {
  ; Notes via menu
  MouseClick, , 190, 40
  MouseClick, , 190, 340
  MouseMove, 250, 360
}
ShowDocuments() {
  ; Documents via menu
  MouseClick, , 190, 40
  MouseClick, , 190, 325
  MouseMove, 240, 290
}
ShowOrders() {
  ; Orders via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 95
  MouseMove, %X%, %Y%

  ;MouseClick, , 730, 350   ; focus order list
  ;MouseMove, 240, 230	    ; hover over add button
}
ShowVitals() {
  ; Vitals via menu with default vitals (HR, BP, etc) to trend selected
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 120
  CursorNotBusyWait()
  ImageWait("vitalsigns.png")
  Sleep, 300
  ImageClick("vitalsigns.png")
  MouseMove, %X%, %Y%
}
ShowLabs() {
  ; Labs via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 140
  MouseMove, %X%, %Y%
}
ShowIView() {
  ; IView and I&O
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 410
  MouseMove, %X%, %Y%
}
ShowMAR() {
  ; MAR Summary via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 455
  MouseMove, %X%, %Y%
}
ShowPatientSummary() {
  ; Patient Summary via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 55
  MouseMove, %X%, %Y%
}
ShowPatientList() {
  ; Patient List via menu
  MouseGetPos X, Y
  if (WinActive("FirstNet") or (WinActive("Opened by") and ImageSearchAll(_, "firstneticon.png"))) {
    MouseClick, , 100, 40
    MouseClick, , 100, 55
  } else {
    MouseClick, , 350, 60
    MouseClick, , 250, 900
  }
  MouseMove, %X%, %Y%
}
ShowCores() {
  ; CORES via menu
  MouseGetPos X, Y
  MouseClick, , 100, 40
  MouseClick, , 100, 205
  MouseMove, %X%, %Y%
}  

; -----------------------------------------------------------------------------
; Common secondary tasks - Ctrl+Shift+letter
; -----------------------------------------------------------------------------
CloseChart() {
  MouseGetPos X, Y
  if (WinActive("Flowsheet") or WinActive("Document Viewer")) {
    ; Close flowsheet via exit button
    ImageClick("exit.png")
  } else if (WinActive("CORES")) {
    ; Close CORES via Save & Exit button
    ImageClick("coresexit.png")
  } else if (WinActive("Medication Reconciliation")) {
    ; Close forms with check mark
    ImageClick("check.png")
  } else {
    ; Close chart via x button
    ImageClick("*100 " . A_ScriptDir . "\img\close.png")
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
  if (not ImageClick("clipboard.png", 2)) {
    Shake()
  }
}
MarkClipboardRead() {
  ; Mark clipboard as read & refresh
  ImageClick("seen.png")
  ImageClick("exit.png")

  ; Wait for results popup to disappear and main window to reactivate
  WinWait("PowerChart")
  CursorNotBusyWait()

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
    MouseClick, , % icon[1], % icon[2]

    ; Wait 500ms for possible abort - press any key to abort 
    Input, key, I L1 T0.5
    if (key <> "") {
      Shake()
      Return
    }

    CursorNotBusyWait()
    ImageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %A_ScriptDir%\img\primaryres.png
    if (ErrorLevel = 0) {
      ImageClick("primaryres.png")
      Click 2
      Sleep, 300
    }
    
    CursorNotBusyWait()
    if (not ImageWait("seen.png", 20)) {
      Shake()
      Return
    }
    
    Sleep, 500
    ImageClick("seen.png")
    ImageClick("exit.png")

    CursorNotBusyWait()
    if (not WinWait("PowerChart")) {
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
  ImageSearchAll(checkboxes, img, , , 230)
  for i, checkbox in checkboxes {
    MouseClick, , % checkbox[1], % checkbox[2]
    if (A_TimeIdlePhysical < 100) {
      break
    }
  }
}
ShowAllOrders() {
  ; Click dropdown, wait for menu to show, then select All Orders
  ImageClick("dropdown.png")
  Sleep, 500
  if (not ImageClick("ordersall.png")) {
    Shake()
  }
}
ShowActiveOrders() {
  ; Click dropdown, wait for menu to show, then select Active Orders
  ImageClick("dropdown.png")
  Sleep, 200
  if (not ImageClick("ordersactive.png")) {
    Shake()
  }
}
ClickAdd() {
  ; Add button on Orders and Notes tabs
  if (not ImageClick("add.png")) {
    if (not ImageClick("add2.png")) {
      Shake()
    }
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
  if (not ImageClick("coressave.png")) {
    Shake()
  }
  MouseMove, %X%, %Y%
}

; -----------------------------------------------------------------------------
; Shortcut keys
; -----------------------------------------------------------------------------
HandleSecondaryKey(key) {
  MouseGetPos X, Y

  if (key = "a") {
    ShowAllOrders() 
  } else if (key = "d") {
    ClickAdd()
  } else if (key = "g") {
    ClickGraph()
  } else if (key = "s") {
    ShowActiveOrders()
  } else if (key = "n") {
    OpenNextClipboard()
  } else if (key = "r") {
    MarkClipboardRead()
  } else if (key = "!") {
    MarkAllClipboardsRead()
  } else if (key = "*") {
    CheckAllCheckboxes()
  } else if (key = "8") {
    CheckAllCheckboxes(false)
  } else if (key = " ") {
    Click
  } else {
    Shake()   ; unrecognized
  }

  MouseMove, %X%, %Y%
}

; CIS / FirstNet shortcuts - only trigger when active window's title matches 
#If (WinActive("PowerChart") or WinActive("FirstNet") or WinActive("Opened by") or WinActive("CORES") or WinActive("Flowsheet") or WinActive("Document Viewer") or WinActive("Diagnosis List") or WinActive("Medication Reconciliation"))

; Main tasks
^!+n::ShowNotes()
^!+u::ShowDocuments()
^!+o::ShowOrders()
^!+v::ShowVitals()
^!+l::ShowLabs()
^!+i::ShowIView()
^!+m::ShowMAR()
^!+s::ShowPatientSummary()
^!+p::ShowPatientList()
^!+c::ShowCores()

; Common secondary tasks - Ctrl+Shift+letter
^!+w::CloseChart()
^+w::CloseChart()
^!+r::Refresh()
^+r::Refresh()

; Less common secondary tasks - activate by Ctrl+K followed by another letter
^k::
^!+k::
  Input, key, I L1 T1
  if (ErrorLevel = "Timeout") {
    Shake()
    Return
  }

  HandleSecondaryKey(key)
Return

; CORES popup window only shortcuts
#If WinActive("CORES")
^s::SaveCORES()

; --------------------------------------------------------------------------------
; Global shortcut keys (not restricted to certain active windows)
; --------------------------------------------------------------------------------
#If

; Logout
^!+Backspace::
  Run, C:\Windows\System32\Disconnect.exe
Return

; Help screen
^?::
^/::
  ; Window size and location
  h := 320
  w := 500
  titleh := 40
  col2x := w/2 - 10
  x := (A_ScreenWidth - w - 2)
  y := (A_ScreenHeight - h - 2)

  ; Build window text
  Gui, Font, s11
  Gui, Add, Text, x0 y10 w%w% h%titleh% center, Type a letter to trigger the associated action:
  Gui, Font, s9

  Gui, Font, w700
  Gui, Add, Text, Section x10 y%titleh%, Common Actions
  Gui, Font, w100
  Gui, Add, Text, xs, R - Refresh  (or Ctrl+Shift + R)
  Gui, Add, Text, xs, W - Close Chart  (or Ctrl+Shift + W)

  Gui, Font, w700
  Gui, Add, Text, xs, Patient Screens
  Gui, Font, w100
  Gui, Add, Text, xs, C - CORES  (or Ctrl+Shift+Alt + C)
  Gui, Add, Text, xs, P - Patient List  (or Ctrl+Shift+Alt + P)
  Gui, Add, Text, xs, O - Orders  (or Ctrl+Shift+Alt + O)
  Gui, Add, Text, xs, V - Vitals  (or Ctrl+Shift+Alt + V)
  Gui, Add, Text, xs, L - Labs  (or Ctrl+Shift+Alt + L)
  Gui, Add, Text, xs, N - Notes  (or Ctrl+Shift+Alt + N)
  Gui, Add, Text, xs, I - I/Os  (or Ctrl+Shift+Alt + I)
  Gui, Add, Text, xs, M - MAR Summary  (or Ctrl+Shift+Alt + M)

  Gui, Add, Text, xs, --- Patient Summary  (use Ctrl+Shift+Alt + S)
  Gui, Add, Text, xs, --- Documents  (use Ctrl+Shift+Alt + U)

  Gui, Font, w700
  Gui, Add, Text, Section x%col2x% y%titleh%, Vitals
  Gui, Font, w100
  Gui, Add, Text, xs, * - Check all boxes  (or Ctrl+K then *)
  Gui, Add, Text, xs, 8 - Unheck all boxes  (or Ctrl+K then 8)

  Gui, Font, w700
  Gui, Add, Text, xs, Orders
  Gui, Font, w100
  Gui, Add, Text, xs, D - Add Order or Note  (or Ctrl+K then D)
  Gui, Add, Text, xs, A - All Orders  (or Ctrl+K then A)
  Gui, Add, Text, xs, S - Active Orders  (or Ctrl+K then S)

  Gui, Font, w700
  Gui, Add, Text, xs, Clipboards
  Gui, Font, w100
  Gui, Add, Text, xs, N - Next clipboard  (or Ctrl+K then N)
  Gui, Add, Text, xs, R - Mark flowsheet read  (or Ctrl+K then R)
  Gui, Add, Text, xs, ! - Clear all clipboards  (or Ctrl+K then !)

  Gui, Font, w700
  Gui, Add, Text, xs, Other
  Gui, Font, w100
  Gui, Add, Text, xs, Ctrl + ? - This help screen

  if (CalcEnabled) {
    Gui, Add, Text, xs, # - Calculator (or Ctrl+Shift+Alt + 3)
    h := h + 20
    y := y - 20
  }

  ; Show window and wait for a key
  Gui, -Caption +AlwaysOntop +Toolwindow +Border
  Gui, Show, x%x% y%y% h%h% w%w% NoActivate, CIS Shortcut Key
  Input, key, I L1
  Gui, Destroy

  ; Allow for shortcuts to be launched directly from the help screen
  if (key = "n") {
    ShowNotes()
  } else if (key = "d") {
    ShowDocuments()
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
  } else if (key = "c") {
    ShowCores()
  } else if (key = "w") {
    CloseChart()
  } else if (key = "r" and not WinActive("Flowsheet")) {
    Refresh()
  } else if (key = "#" and CalcEnabled) {
    ShowCalculator()
  } else {
    HandleSecondaryKey(key)
  }
Return

; ---------------------------------------------------
; Calculator
; ---------------------------------------------------
; Enable calculator GUI only if AutoHotKey.exe is available
#If CalcEnabled
^!+3::
  ; show, but cut off combobox dropdown & ok button
  ShowCalculator()
Return
CalcGuiEscape:
  Gui, Calc:Show, Hide
Return
CalcButtonOK:
  ; get text from ComboBox named CalcExpr into a variable named CalcExpr
  GuiControlGet CalcExpr, , CalcExpr                  

  ; Keep up to 20 items of history, and set combo box list contents
  CalcHistory.push(CalcExpr)
  if (CalcHistory.Length() > 20) {
    CalcHistory.RemoveAt(0)
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
  RunWait %AHKExe% %calcFile%

  ; get result and show
  FileRead Result, %resFile%
  GuiControl, Text, CalcExpr, %Result%
Return
#If