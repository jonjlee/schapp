#singleinstance force

; Test function - Ctrl+Shift+Alt+T
;^!+t::
;Return

; ---------------------------------------------------------
; Configuration
; ---------------------------------------------------------
SetTitleMatchMode 2
SetDefaultMouseSpeed, 0
AHKExe := A_Temp . "\AutoHotKey.exe"
FileInstall, AutoHotKey.exe, % AHKExe, 1
CalcEnabled := FileExist(AHKexe)

; ---------------------------------------------------------
; UI setup
; ---------------------------------------------------------
; Tray menu
Menu, tray, add, Start Internet Bridge, StartBridge

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
mivf: weight in kg - maintenance IVF rate
w: weight - convert lbs / kg
t: temp - convert C / F
f: drug - open formulary (internet bridge must be started)
pathway: name - open pathway (internet bridge must be started)
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
FileInstall, img\add.png, img\add.png, 1
FileInstall, img\add2.png, img\add2.png, 1
FileInstall, img\add3.png, img\add3.png, 1
FileInstall, img\arrowright.png, img\arrowright.png, 1
FileInstall, img\check.png, img\check.png, 1
FileInstall, img\checked.PNG, img\checked.PNG, 1
FileInstall, img\clipboard.png, img\clipboard.png, 1
FileInstall, img\close.png, img\close.png, 1
FileInstall, img\cores.png, img\cores.png, 1
FileInstall, img\coresexit.png, img\coresexit.png, 1
FileInstall, img\coressave.png, img\coressave.png, 1
FileInstall, img\discharge.png, img\discharge.png, 1
FileInstall, img\dropdown.png, img\dropdown.png, 1
FileInstall, img\exit.png, img\exit.png, 1
FileInstall, img\exit2.png, img\exit2.png, 1
FileInstall, img\firstneticon.png, img\firstneticon.png, 1
FileInstall, img\flowsheetseeker.png, img\flowsheetseeker.png, 1
FileInstall, img\graph.png, img\graph.png, 1
FileInstall, img\hilitedrow.png, img\hilitedrow.png, 1
FileInstall, img\labs.png, img\labs.png, 1
FileInstall, img\modify.png, img\modify.png, 1
FileInstall, img\navigator.png, img\navigator.png, 1
FileInstall, img\networkdrive.png, img\networkdrive.png, 1
FileInstall, img\orca.png, img\orca.png, 1
FileInstall, img\orcaptlist.png, img\orcaptlist.png, 1
FileInstall, img\ordersactive.png, img\ordersactive.png, 1
FileInstall, img\ordersall.png, img\ordersall.png, 1
FileInstall, img\ordersallsel.png, img\ordersallsel.png, 1
FileInstall, img\primaryres.png, img\primaryres.png, 1
FileInstall, img\provideroverview.png, img\provideroverview.png, 1
FileInstall, img\refresh.png, img\refresh.png, 1
FileInstall, img\seen.png, img\seen.png, 1
FileInstall, img\unchecked.png, img\unchecked.png, 1
FileInstall, img\vitalsigns.png, img\vitalsigns.png, 1
FileInstall, img\winclose.png, img\winclose.png, 1
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
  MouseMove, % X+35, % Y+4, 0
  MouseMove, % X-35, % Y-3, 1
  MouseMove, % X+15, % Y-3, 2
  MouseMove, % X-6, % Y+2, 2
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
  return (ErrorLevel = 0)
}
ImageSearchAll(ByRef Arr, image, orientation:="Vertical", max:=0, minX:=0, minY:=0, maxX:=0, maxY:=0) {
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
ImageClick(image, n:=1, orientation:="Vertical", minX:=0, minY:=0, maxX:=0, maxY:=0) {
  ImageSearchAll(images, image, orientation, n, minX, minY, maxX, maxY)
  if (images.MaxIndex() >= n) {
    MouseClick, , % images[n][1], % images[n][2]
    return true   
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
      return true
    }
    Sleep, 100
    if ((A_TickCount - start > maxMs) or (onlyWhileIdle and A_TimeIdle < 100)) {
      return false
    }
  }
}
WinWait(title, sec:=5) {
  maxMs := sec * 1000
  start := A_TickCount
  Loop {
    if (WinActive(title)) {
      return true
    }
    if (A_TickCount - start > maxMs) {
      return false
    }
    Sleep, 300
  }
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

; -----------------------------------------------------------------------------
; Main tasks
; -----------------------------------------------------------------------------
isORCA() {
  return ImageExists("orca.png", 0, 0, 150, 100)
}

ShowNotes() {
  ; Notes via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 260
    MouseMove, %X%, %Y%
  } else {
    MouseClick, , 190, 235
    MouseMove, 250, 360
  }  
}
ShowDocuments() {
  ; Documents via menu
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 245
  } else {
    MouseClick, , 190, 210
  }
  MouseMove, 240, 290
}
ShowOrders() {
  ; Orders via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 415
  } else {
    MouseClick, , 190, 105
  }
  MouseMove, %X%, %Y%
}
ShowVitals() {
  ; Flowsheets via menu > Provider Overview tab > Vitals Signs in left sided Navigator
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 790
    MouseMove, %X%, %Y%
  } else {
    MouseClick, , 190, 150
    MouseMove, %X%, %Y%
    if (ImageWaitWhileIdle("flowsheetseeker.png", , 100, 100, 400, 300)) {
      MouseGetPos X, Y
      ImageClick("provideroverview.png")
      MouseMove, %X%, %Y%
    }
  }
}
ShowLabs() {
  ; Flowsheets via menu > Labs tab
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 855
    MouseMove, %X%, %Y%
  } else {
    MouseClick, , 190, 150
    MouseMove, %X%, %Y%
    if (ImageWaitWhileIdle("flowsheetseeker.png", , 100, 100, 400, 300)) {
      MouseGetPos X, Y
      ImageClick("labs.png")
      MouseMove, %X%, %Y%
    }
  }
}
ShowIView() {
  ; IView and I&O
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 525
  } else {
    MouseClick, , 190, 285
  }
  MouseMove, %X%, %Y%
}
ShowMAR() {
  ; MAR Summary via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 460
  } else {
    MouseClick, , 190, 310
  }
  MouseMove, %X%, %Y%
}
ShowPatientSummary() {
  ; Patient Summary via menu
  MouseGetPos X, Y
  MouseClick, , 190, 40
  if (isORCA()) {
    MouseClick, , 190, 85
  } else {
    MouseClick, , 190, 65
  }
  MouseMove, %X%, %Y%
}
ShowPatientList() {
  ; Patient List via menu
  MouseGetPos X, Y
  ImageClick("orcaptlist.png")
  Sleep, 200
  ImageSearch, hiliteX, hiliteY, 0, 0, 30, %A_ScreenHeight%, % ImagePath("hilitedrow.png")
  if (ErrorLevel = 0) {
    MouseClick, , % hiliteX+40, % hiliteY
  }
  MouseMove, %X%, %Y%
}
ShowEDBoard() {
  ; Enhanced Tracking via menu
  if (WinActive("FirstNet") or (WinActive("Opened by") and ImageExists("firstneticon.png"))) {
    MouseGetPos X, Y
    MouseClick, , 100, 40
    MouseClick, , 100, 55
    MouseMove, %X%, %Y%
  }
}
ShowCores() {
  ; CORES via menu
  MouseGetPos X, Y
  if (isORCA()) {
    ImageClick("cores.png")
  } else if (WinActive("FirstNet") or (WinActive("Opened by") and ImageExists("firstneticon.png"))) {
    ImageClick("cores.png")
  } else {
    MouseClick, , 100, 40
    MouseClick, , 100, 220
  }
  MouseMove, %X%, %Y%
}
ShowDischarge() {
  ; Discharge via Patient Actions menu
  MouseGetPos X, Y
  if (isORCA()) {
    MouseClick, , 190, 40
    MouseClick, , 190, 615
  } else {
    MouseClick, , 360, 40
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
    ImageClick(ImagePath("coresexit.png", "*100"))
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
  if (not ImageClick("clipboard.png", 2)) {
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
  WinWait("PowerChart")
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
    ImageSearch, X, Y, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %A_ScriptDir%\img\primaryres.png
    if (ErrorLevel = 0) {
      ImageClick("primaryres.png")
      Click 2
      Sleep, 300
    }
    
    ; Wait for flowsheet to appear - look for seen button
    if (not ImageWait("seen.png", 20)) {
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
  ImageSearchAll(checkboxes, img, , , 250)
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
ShowActiveOrders() {
  ; Click dropdown, wait for menu to show, then select Active Orders
  ImageClick("dropdown.png")
  Sleep, 500
  if (not ImageClick("ordersactive.png")) {
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
  ; Graph button
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
  if (not ImageClick(ImagePath("coressave.png", "*100"))) {
    Shake()
  }
  MouseMove, %X%, %Y%
}

; -----------------------------------------------------------------------------
; Shortcut keys
; -----------------------------------------------------------------------------
HandleSecondaryKey(key) {
  if (key = "") {
    return
  } else if (key = "a") {
    ToggleAllOrders() 
  } else if (key = "d") {
    ClickAdd()
  } else if (key = "m") {
    ClickModify()
  } else if (key = "g") {
    ClickGraph()
  } else if (key = "s") {
    ShowActiveOrders()
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
  } else if (key = " ") {
    Click
  } else {
    Shake()   ; unrecognized
  }
}
ClickLeft() {
  ; click top left side of screen, i.e. title bar if 2 windows tiled side-by-side
  CoordMode, Mouse, Screen
  MouseGetPos X, Y
  MouseClick, , A_ScreenWidth / 4, 5 
  MouseMove, %X%, %Y%
  CoordMode, Mouse, Relative
}
ClickRight() {
  CoordMode, Mouse, Screen
  MouseGetPos X, Y
  MouseClick, , A_ScreenWidth * 3/4, 5 
  MouseMove, %X%, %Y%
  CoordMode, Mouse, Relative
}

; CIS / FirstNet shortcuts - only trigger when active window's title matches 
#If (WinActive("PowerChart") or WinActive("FirstNet") or WinActive("Opened by") or WinActive("CORES") or WinActive("Flowsheet") or WinActive("Document Viewer") or WinActive("Diagnosis List") or WinActive("Medication Reconciliation") or WinActive("Summary of Visit") or WinActive("ED Callback"))

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
^!+e::ShowEDBoard()
^!+c::ShowCores()
^!+d::ShowDischarge()

; Common secondary tasks - Ctrl+Shift+letter
^!+w::CloseChart()
^+w::CloseChart()
^!+r::Refresh()
^+r::Refresh()

; Less common secondary tasks - activate by Ctrl+K followed by another letter
^k::
^!+k::
  Input, key, I L1 T3, {Escape}{LControl}{RControl}{LAlt}{RAlt}{Enter}{Backspace}{Tab}
  if (ErrorLevel = "Timeout") {
    Shake()
    Return
  }

  HandleSecondaryKey(key)
Return

^Left::ClickLeft()
^Right::ClickRight()

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
  h := 340
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
  Gui, Add, Text, xs, R - Refresh  (or Ctrl+Shift + R)
  Gui, Add, Text, xs, W - Close Chart  (or Ctrl+Shift + W)

  Gui, Font, w700
  Gui, Add, Text, xs, Patient Screens
  Gui, Font, w100
  Gui, Add, Text, xs, C - CORES  (or Ctrl+Shift+Alt + C)
  Gui, Add, Text, xs, P - Patient List  (or Ctrl+Shift+Alt + P)
  Gui, Add, Text, xs, S - Patient Summary  (or Ctrl+Shift+Alt + S)
  Gui, Add, Text, xs, O - Orders  (or Ctrl+Shift+Alt + O)
  Gui, Add, Text, xs, V - Vitals  (or Ctrl+Shift+Alt + V)
  Gui, Add, Text, xs, L - Labs  (or Ctrl+Shift+Alt + L)
  Gui, Add, Text, xs, U - Documents  (or Ctrl+Shift+Alt + U)
  Gui, Add, Text, xs, N - Notes  (or Ctrl+Shift+Alt + N)
  Gui, Add, Text, xs, I - I/Os  (or Ctrl+Shift+Alt + I)
  Gui, Add, Text, xs, M - MAR Summary  (or Ctrl+Shift+Alt + M)
  Gui, Add, Text, xs, E - ED Board (FirstNet only) (or Ctrl+Shift+Alt + E)

  Gui, Font, w700
  Gui, Add, Text, Section x%col2x% y%titleh%, Vitals
  Gui, Font, w100
  Gui, Add, Text, xs, * - Check all boxes  (or Ctrl+K then *)
  Gui, Add, Text, xs, 8 - Unheck all boxes  (or Ctrl+K then 8)

  Gui, Font, w700
  Gui, Add, Text, xs, Orders
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
  Gui, Add, Text, xs, Other
  Gui, Font, w100
  Gui, Add, Text, xs, Ctrl + ? - This help screen
  Gui, Add, Text, xs, Ctrl+Shift+Alt + Backspace - Logout

  if (CalcEnabled) {
    Gui, Add, Text, xs, # - Calculator (or Ctrl+Shift+Alt + 3)
    h := h + 20
    y := y - 20
  }

  ; Show window and wait for a key
  Gui, -Caption +AlwaysOntop +Toolwindow +Border
  Gui, Show, x%x% y%y% h%h% w%w% NoActivate, CIS Shortcut Key
  Input, key, I L1 T5, {Escape}{Space}{LControl}{RControl}{LAlt}{RAlt}{Enter}{Backspace}{Tab}
  Gui, Destroy

  ; Allow for shortcuts to be launched directly from the help screen
  if (key = "") {
    Return
  } else if (key = "s") {
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
  } else if (key = "e") {
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
  RunWait %AHKExe% %calcFile%

  ; get result and show
  FileRead Result, %resFile%
  GuiControl, Text, CalcExpr, %Result%
Return
#If

; ---------------------------------------------------
; Tray menu handlers
; ---------------------------------------------------
StartBridge:
  FileInstall, schbridge.exe, o:\schbridge.exe, 1
  Run, "C:\Program Files\Citrix\ICA Client\pnagent.exe" /CitrixShortcut: (2) /QLaunch "XenApp65:O drive - Home Folder"
  if (ImageWait("networkdrive.png", 10)) {
    MouseGetPos X, Y
    ImageClick("networkdrive.png")
    Sleep, 500
    SendInput, O:\schbridge.exe{enter}
    Sleep, 100
    ImageClick("winclose.png")
    MouseMove, %X%, %Y%
  }
Return
