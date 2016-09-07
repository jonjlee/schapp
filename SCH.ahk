Progress, zh0 fs18, CIS shortcut keys set up. Press Ctrl+? for help.
Sleep, 1500
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

^?::
^/::
title =
(
These shortcuts can be used in CIS and FirstNet:
)
col1 = 
(
Ctrl+Shift+Alt + C - CORES
Ctrl+Shift+Alt + P - Patient List
Ctrl+Shift+Alt + O - Orders
Ctrl+Shift+Alt + V - Vitals
Ctrl+Shift+Alt + L - Labs
Ctrl+Shift+Alt + N - Notes
Ctrl+Shift+Alt + M - Documents

Ctrl + ? - This help screen
)  
col2 = 
(
Ctrl+Shift + R - Refresh
Ctrl+Shift + W - Close Chart

Ctrl+K then * - Check boxes (vitals)

Ctrl+K then D - Add Order or Note

Ctrl+K then N - Next clipboard
Ctrl+K then R - Mark clipboard read
Ctrl+K then ! - Clear all clipboards
)  
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
Return

; Test function - Ctrl+Shift+Alt+T
;^!+t::
;  MsgBox, %A_Desktop%
;Return

; Only enable for CIS / FirstNet
SetTitleMatchMode 2
#If WinActive("PowerChart") or WinActive("FirstNet") or WinActive("Opened by") or WinActive("CORES") or WinActive("Flowsheet")

; Helpers
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
; Notes via menu
^!+n::
  MouseClick, , 190, 40
  MouseClick, , 190, 340
  MouseMove, 250, 360
Return

; Documents via menu
^!+m::
  MouseClick, , 190, 40
  MouseClick, , 190, 325
  MouseMove, 240, 290
Return

; Orders via menu. Leave mouse on Add button.
^!+o::
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 95
  MouseMove, %X%, %Y%

  ;MouseClick, , 730, 350   ; focus order list
  ;MouseMove, 240, 230	    ; hover over add button
Return

; Vitals via menu with default vitals (HR, BP, etc) to trend selected
^!+v::
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 120
  ImageWait("vitalsigns.png")
  ImageClick("vitalsigns.png")
  MouseMove, %X%, %Y%
Return

; Labs via menu
^!+l::
  MouseGetPos X, Y
  MouseClick, , 190, 40
  MouseClick, , 190, 140
  MouseMove, %X%, %Y%
Return

; Patient List via menu
^!+p::
  MouseGetPos X, Y
  MouseClick, , 350, 60
  MouseClick, , 250, 900
  MouseMove, %X%, %Y%
Return

; CORES via menu
^!+c::
  MouseGetPos X, Y
  MouseClick, , 100, 40
  MouseClick, , 100, 205
  MouseMove, %X%, %Y%
Return  

; -----------------------------------------------------------------------------
; Common secondary tasks - Ctrl+Shift+letter
; -----------------------------------------------------------------------------
; Close chart via x button
^!+w::
^+w::
  MouseGetPos X, Y
  ImageClick("*100 " . A_ScriptDir . "\img\close.png")
  MouseMove, %X%, %Y%
Return

; Refresh (click both button locations)
^!+r::
^+r::
  MouseGetPos X, Y
  ImageClick("refresh.png")
  MouseMove, %X%, %Y%
Return

; Focus (order list, patient list)
^+Space::
  MouseGetPos X, Y
  MouseClick, , 610, 850
  MouseMove, %X%, %Y%
Return

; -----------------------------------------------------------------------------
; Less common secondary tasks - activate by Ctrl+K followed by another letter
; -----------------------------------------------------------------------------
^k::
^!+k::
  Input, key, I L1 T1
  if (ErrorLevel = "Timeout") {
    Shake()
    Return
  }

  MouseGetPos X, Y

  ; All orders
  if (key = "a") {
    ImageClick("dropdown.png")
    Sleep, 200
    if (not ImageClick("ordersall.png"))
      Shake()

  ; Add (order)
  } else if (key = "d") {
    if (not ImageClick("add.png")) {
      if (not ImageClick("add2.png")) {
        Shake()
      }
    }

  ; Graph
  } else if (key = "g") {
    if (not ImageClick("graph.png")) {
      Shake()
    }

  ; Active orders
  } else if (key = "s") {
    ImageClick("dropdown.png")
    Sleep, 200
    if (not ImageClick("ordersactive.png"))
      Shake()

  ; Next clipboard (click 2nd clipboard icon - first one is column header)
  } else if (key = "n") {
    if (not ImageClick("clipboard.png", 2))
      Shake()

  ; Mark clipboard as read & refresh
  } else if (key = "r") {
    ImageClick("seen.png")
    ImageClick("exit.png")

    ; Wait for results popup to disappear and main window to reactivate
    WinWait("PowerChart")
    CursorNotBusyWait()

    ImageClick("refresh.png")
 
  ; Mark all clipboards as read & refresh
  } else if (key = "!") {
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
  
  ; select all unchecked boxes on screen
  } else if (key = "*") {
    ImageSearchAll(checkboxes, "unchecked.png")
    for i, checkbox in checkboxes {
      MouseClick, , % checkbox[1], % checkbox[2]
    }

  ; click mouse
  } else if (key = " ") {
    Click
  
  ; unrecognized
  } else {
    Shake()
  }

  MouseMove, %X%, %Y%
Return
