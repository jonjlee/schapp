; ---------------------------------------------------------
; Splash screen and setup
; ---------------------------------------------------------
splash_h := 100
splash_w := 400
splash_x := A_ScreenWidth - splash_w - 25
splash_y := A_ScreenHeight - splash_h - 25
Gui, Font, s14
Gui, Add, Text, x0 y10 w%splash_w% center, CIS shortcuts enabled. Ctrl+? for help.
Gui, -Caption +alwaysontop +Toolwindow +Border
Gui, Show, x%splash_x% y%splash_y% w%splash_w% NoActivate,
Sleep 100
Loop {
  If (A_TimeIdlePhysical < 100 or A_TimeIdlePhysical > 2000) {
    break
  }
}
Gui, Destroy

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

; Test function - Ctrl+Shift+Alt+T
;^!+t::
;Return

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
  return Arr
}
ImageClick(image, n:=1, orientation:="Vertical") {
  ImageSearchAll(images, image, orientation, n)
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
ShowPatientList() {
  ; Patient List via menu
  MouseGetPos X, Y
  MouseClick, , 350, 60
  MouseClick, , 250, 900
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
  ; Close chart via x button
  MouseGetPos X, Y
  ImageClick("*100 " . A_ScriptDir . "\img\close.png")
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

; -----------------------------------------------------------------------------
; Shortcut keys
; -----------------------------------------------------------------------------

; CIS / FirstNet shortcuts - only trigger when active window's title matches 
SetTitleMatchMode 2
#If WinActive("PowerChart") or WinActive("FirstNet") or WinActive("Opened by") or WinActive("CORES") or WinActive("Flowsheet")

; Main tasks
^!+n::ShowNotes()
^!+m::ShowDocuments()
^!+o::ShowOrders()
^!+v::ShowVitals()
^!+l::ShowLabs()
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
Return

; --------------------------------------------------------------------------------
; Global shortcuts below this point - not restricted to certain active windows
; --------------------------------------------------------------------------------
#If

; Logout
^!+Backspace::
  Run, C:\Windows\System32\Disconnect.exe
Return

; -------------------------------------------------
; Help screen
; -------------------------------------------------
^?::
^/::
  help_title =
  ( LTrim
    Type a letter to trigger the associated action:
  )
  help_col1 = 
  ( LTrim
    C - CORES  (or Ctrl+Shift+Alt + C)
    P - Patient List  (or Ctrl+Shift+Alt + P)
    O - Orders  (or Ctrl+Shift+Alt + O)
    V - Vitals  (or Ctrl+Shift+Alt + V)
    L - Labs  (or Ctrl+Shift+Alt + L)
    N - Notes  (or Ctrl+Shift+Alt + N)
    M - Documents  (or Ctrl+Shift+Alt + M)

    R - Refresh  (or Ctrl+Shift + R)
    W - Close Chart  (or Ctrl+Shift + W)
  )  
  help_col2 = 
  ( LTrim
    * - Check boxes (vitals)  (or Ctrl+K then *)
    8 - Unheck boxes (vitals)  (or Ctrl+K then 8)

    D - Add Order or Note  (or Ctrl+K then D)
    A - All Orders  (or Ctrl+K then A)
    S - Active Orders  (or Ctrl+K then S)

    N - Next clipboard  (or Ctrl+K then N)
    R - Mark clipboard read  (or Ctrl+K then R)
    ! - Clear all clipboards  (or Ctrl+K then !)

    Ctrl + ? - This help screen
  )  

  h := 360
  w := 500
  titleh := 40
  colh := h - titleh
  colw := w/2 - 10
  col2x := w/2 - 10
  x := (A_ScreenWidth - w - 2)
  y := (A_ScreenHeight - h - 2)

  Gui, Font, s11
  Gui, Add, Text, x0 y10 w%w% h%titleh% center, %help_title%

  Gui, Font, s9

  Gui, Font, w700
  Gui, Add, Text, Section x10 y%titleh%, Common Actions
  Gui, Font, w100
  Gui, Add, Text, xs, R - Refresh  (or Ctrl+Shift + R)
  Gui, Add, Text, xs, W - Close Chart  (or Ctrl+Shift + W)

  Gui, Font, w700
  Gui, Add, Text, xs, Patient Areas
  Gui, Font, w100
  Gui, Add, Text, xs, C - CORES  (or Ctrl+Shift+Alt + C)
  Gui, Add, Text, xs, P - Patient List  (or Ctrl+Shift+Alt + P)
  Gui, Add, Text, xs, O - Orders  (or Ctrl+Shift+Alt + O)
  Gui, Add, Text, xs, V - Vitals  (or Ctrl+Shift+Alt + V)
  Gui, Add, Text, xs, L - Labs  (or Ctrl+Shift+Alt + L)
  Gui, Add, Text, xs, N - Notes  (or Ctrl+Shift+Alt + N)
  Gui, Add, Text, xs, M - Documents  (or Ctrl+Shift+Alt + M)

  Gui, Font, w700
  Gui, Add, Text, Section x%col2x% y%titleh%, Vitals
  Gui, Font, w100
  Gui, Add, Text, xs, * - Check boxes (vitals)  (or Ctrl+K then *)
  Gui, Add, Text, xs, 8 - Unheck boxes (vitals)  (or Ctrl+K then 8)

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
  Gui, Add, Text, xs, R - Mark clipboard read  (or Ctrl+K then R)
  Gui, Add, Text, xs, ! - Clear all clipboards  (or Ctrl+K then !)

  Gui, Font, w700
  Gui, Add, Text, xs, Other
  Gui, Font, w100
  Gui, Add, Text, xs, Ctrl+Shift+Alt + 3 - Calculator
  Gui, Add, Text, xs, Ctrl + ? - This help screen

  ;Gui, Add, Text, x10 y%titleh% w%colw% h%colh% , %help_col1%
  ;Gui, Add, Text, x%col2x% y%titleh% w%colw% h%colh% , %help_col2%

  Gui, -Caption +AlwaysOntop +Toolwindow +Border
  ;Gui, Color, 808080
  
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
  } else if (key = "p") {
    ShowPatientList()
  } else if (key = "c") {
    ShowCores()
  } else if (key = "w") {
    CloseChart()
  } else if (key = "r" and not WinActive("Flowsheet")) {
    Refresh()
  } else if (key = "a") {
    ShowAllOrders() 
  } else if (key = "d") {
    ClickAdd()
  } else if (key = "g") {
    ClickGraph()
  } else if (key = "s") {
    ShowActiveOrders()
  } else if (key = "n") {
    OpenNextClipboard()
  } else if (key = "r" and WinActive("Flowsheet")) {
    MarkClipboardRead()
  } else if (key = "!") {
    MarkAllClipboardsRead()
  } else if (key = "*") {
    CheckAllCheckboxes()
  } else if (key = "8") {
    CheckAllCheckboxes(false)
  }
Return

; ---------------------------------------------------
; Calculator
; ---------------------------------------------------
^!+3::
  file = %A_Temp%\docalc.ahk             ; any unused filename
  Gui, Font, s12
  Gui Add, ComboBox, X0 Y0 W300 vExpr
  Gui Add, Button, Default, OK     ; button activated by Enter, Gui Show cuts it off
  Gui -Caption +Border             ; small window w/o title bar
  Gui Show, H24 W277              ; cut off unnecessary parts
Return
GuiEscape:
   Gui, Destroy
Return
ButtonOK:
   GuiControlGet Expr,,Expr      ; get Expr from ComboBox
   GuiControl,,Expr,%Expr%       ; append Expr to internal ComboBox list
   StringReplace Expr, Expr, `;, `n, All
   StringGetPos Last, Expr, `n, R1
   StringLeft Pre, Expr, Last
   StringTrimLeft Expr, Expr, Last+1
   FileDelete %file%             ; delete old temporary file -> write new
   FileAppend #NoTrayIcon`n#Include %A_Temp%\CalcFuns.ahk`nFileDelete %file%`n%pre%`nFileAppend `% (%Expr%)+0`, %file%, %file%
   RunWait %A_AhkPath% %file%    ; run AHK to execute temp script, evaluate expression
   FileRead Result, %file%       ; get result
   FileDelete %file%
   GuiControl,,Expr,%Result%     ; append Result to internal ComboBox list
   N += 2                        ; count lines
   GuiControl Choose,Expr,%N%    ; show Result
Return
