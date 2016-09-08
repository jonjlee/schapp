; ---------------------------------------------------------
; Splash screen and setup
; ---------------------------------------------------------
Progress, zh0 fs18, CIS shortcut keys set up. Press Ctrl+? for help.
Sleep, 1100
Progress, Off

FileCreateDir, img
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
;  MsgBox, %A_Desktop%
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
ImagePath(image) {
  return "*20 " . A_ScriptDir . "\img\" . image
}
ImageSearchAll(ByRef Arr, image, orientation:="Vertical", max:=0) {
  if (SubStr(image, 1, 1) <> "*") {
    image := ImagePath(image)
  }

  Arr := []
  lastX := 0
  lastY := 0
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
CheckAllCheckboxes() {
  ; select all unchecked boxes on screen
  ImageSearchAll(checkboxes, "unchecked.png")
  for i, checkbox in checkboxes {
    MouseClick, , % checkbox[1], % checkbox[2]
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

; -------------------------------------------------
; Help screen
; -------------------------------------------------
help_title =
(
These shortcuts can be used in CIS and FirstNet:
)
help_col1 = 
(
Ctrl+Shift+Alt + C - CORES
Ctrl+Shift+Alt + P - Patient List
Ctrl+Shift+Alt + O - Orders
Ctrl+Shift+Alt + V - Vitals
Ctrl+Shift+Alt + L - Labs
Ctrl+Shift+Alt + N - Notes
Ctrl+Shift+Alt + M - Documents

Ctrl+Shift + R - Refresh
Ctrl+Shift + W - Close Chart
)  
help_col2 = 
(
Ctrl+K then * - Check boxes (vitals)

Ctrl+K then D - Add Order or Note
Ctrl+K then A - All Orders
Ctrl+K then S - Active Orders

Ctrl+K then N - Next clipboard
Ctrl+K then R - Mark clipboard read
Ctrl+K then ! - Clear all clipboards

Ctrl + ? - This help screen
)  

^?::
^/::
  h := 230
  w := 450
  titleh := 40
  colh := h - titleh
  colw := w/2 - 10
  col2x := w/2 - 10
  x := (A_ScreenWidth - w)
  y := (A_ScreenHeight - h)

  Gui, Font, s12
  Gui, Add, Text, x6 y6 w%w% h%titleh%, %title%
  
  Gui, Font, s10
  Gui, Add, Text, x6 y%titleh% w%colw% h%colh% , %col1%
  Gui, Add, Text, x%col2x% y%titleh% w%colw% h%colh% , %col2%

  Gui, -caption
  Gui, +alwaysontop +Toolwindow
  ;Gui, Color, 808080
  
  Gui, Show, x%x% y%y% h%h% w%w% NoActivate, CIS Shortcut Key
  

  Input, key, I L1
  Gui, Destroy

  ; Allow for shortcuts to be launched directly from the help screen
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
  } else if (key = " ") {
    Click
  } else {
    Shake()   ; unrecognized
  }
Return
